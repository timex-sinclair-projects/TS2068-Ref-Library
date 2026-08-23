;******************************************************************
;
;  FDD-to-TPI Bridge Layer - Example Code
;
;  Maps FDD 3000 BASIC commands to TPI protocol commands
;  on the TS-PICO interface.
;
;  Phase 1: CAT, ERASE, SAVE, LOAD, VERIFY, CLOSE, MOVE (as CD)
;  Phase 2: OPEN/CLOSE with streams (sequential file I/O)
;
;  Approach: Intercept FDD keyword tokens during BASIC parsing,
;  build the equivalent TPI command string, and invoke the
;  existing TPI command handler in the modified EXROM.
;
;******************************************************************

;==================================================================
; System equates
;==================================================================
CH_ADD          EQU $5C5D       ; BASIC interpreter character pointer
FLAGS           EQU $5C3B       ; FLAGS system variable
TPMODE          EQU $5DDB       ; TPI mode variable
WTAPE           EQU $0068       ; EXROM write tape entry (intercepted by TPI)
RTAPE           EQU $00FC       ; EXROM read tape entry (intercepted by TPI)

; TPI BIOS (EXROM addresses, call via CALL_BANK)
G_MODE          EQU $1840       ; Get output mode
S_MODE          EQU $1842       ; Set output mode
TX_A            EQU $1846       ; Transmit byte
RX_A            EQU $1848       ; Receive byte
C_END           EQU $184A       ; Command end
WF_NPH          EQU $184C       ; Wait for peripheral handshake

; TPI command string addresses (these would be in ROM or RAM)
IO_PORT         EQU $0E         ; TS-PICO data port

;==================================================================
; Keyword token values (from TS-2068 token table)
; These are the tokens the BASIC interpreter generates
;==================================================================
TOK_CAT         EQU $CF         ; CAT keyword token
TOK_FORMAT      EQU $CE         ; FORMAT keyword token
TOK_MOVE        EQU $D3         ; MOVE keyword token
TOK_ERASE       EQU $D4         ; ERASE keyword token
TOK_SAVE        EQU $C9         ; SAVE keyword token
TOK_LOAD        EQU $CA         ; LOAD keyword token
TOK_VERIFY      EQU $D0         ; VERIFY keyword token
TOK_CLOSE       EQU $CC         ; CLOSE keyword token

;******************************************************************
;
;  EXAMPLE 1: CAT command
;
;  Syntax:  CAT                  (list all files)
;           CAT "*.tap"          (list matching files)
;           CAT #n               (output to stream n)
;
;  This is the simplest mapping. CAT with no arguments maps to
;  the TPI DIR listing. CAT with a wildcard maps to a filtered
;  DIR listing.
;
;  Implementation strategy: Build a "B" frame command block
;  with the TPI:DIR command string and send it to the Pico.
;  The Pico responds with the directory listing which we
;  display line by line.
;
;******************************************************************

;==================================================================
; CAT_HANDLER - Execute CAT command via TPI
;
; Entry: Called from BASIC command dispatcher
;        CH_ADD points past the CAT keyword
; Exit:  Directory listing displayed on screen
;==================================================================
CAT_HANDLER:
        ; First ensure we're in SDCARD mode
        LD      A,(TPMODE)
        BIT     1,A             ; check SD card mode active
        JP      Z,ERR_NO_DEVICE ; error if not in SD mode

        ; Check for optional filename/wildcard parameter
        RST     $18             ; get current char
        CALL    CHECK_EOL       ; end of statement?
        JR      Z,.cat_all      ; yes - list all files

        ; Parse the filename string expression
        CP      '"'             ; quoted string?
        JP      NZ,ERR_SYNTAX   ; must be a string
        CALL    EVAL_STRING     ; evaluate string, HL=addr, BC=len
        ; String is now on calculator stack
        ; Copy it to our command buffer
        CALL    BUILD_DIR_CMD   ; build "TPI:DIR pattern" command
        JR      .cat_send

.cat_all:
        ; No arguments - list everything
        LD      HL,STR_DIR_ALL
        LD      BC,STR_DIR_ALL_LEN
        CALL    BUILD_DIR_CMD_LITERAL

.cat_send:
        ; Send the command to the Pico via TPI protocol
        ; The existing TPI command handler will recognize "TPI:DIR"
        ; and process it
        CALL    SEND_TPI_CMD
        RET     C               ; return if error (carry set)

        ; Receive and display the directory listing
        ; The Pico sends back text lines terminated by $00
        CALL    RECV_AND_DISPLAY
        RET

;------------------------------------------------------------------
; BUILD_DIR_CMD - Build "TPI:DIR pattern" command in buffer
; Entry: HL = pattern string address, BC = pattern length
; Exit:  Command ready in CMD_BUFFER
;------------------------------------------------------------------
BUILD_DIR_CMD:
        PUSH    HL
        PUSH    BC
        LD      HL,CMD_BUFFER
        LD      DE,STR_TPI_DIR  ; "TPI:DIR "
        LD      BC,STR_TPI_DIR_LEN
        LDIR                    ; copy prefix
        POP     BC              ; restore pattern length
        POP     DE              ; restore pattern address (was HL)
        LDIR                    ; append pattern
        XOR     A
        LD      (HL),A          ; null terminate
        RET

BUILD_DIR_CMD_LITERAL:
        ; Same but HL already points to the full command string
        LD      DE,CMD_BUFFER
        LDIR
        XOR     A
        LD      (DE),A
        RET

;------------------------------------------------------------------
; String constants for CAT
;------------------------------------------------------------------
STR_TPI_DIR:
        DEFM    "TPI:DIR "
STR_TPI_DIR_LEN EQU $ - STR_TPI_DIR

STR_DIR_ALL:
        DEFM    "TPI:DIR *.*"
STR_DIR_ALL_LEN EQU $ - STR_DIR_ALL


;******************************************************************
;
;  EXAMPLE 2: ERASE command
;
;  Syntax:  ERASE "filename"
;
;  Maps to: First SAVE "TPI:filename.tap" to select the file,
;           then SAVE "TPI:DELETE" to delete it.
;
;  Or more directly: build a TPI command block that tells
;  the Pico to delete the named file.
;
;******************************************************************

;==================================================================
; ERASE_HANDLER - Execute ERASE command via TPI
;
; Entry: CH_ADD points past ERASE keyword
; Exit:  File deleted from SD card
;==================================================================
ERASE_HANDLER:
        LD      A,(TPMODE)
        BIT     1,A
        JP      Z,ERR_NO_DEVICE

        ; Parse the filename
        CALL    EVAL_STRING     ; get filename from BASIC expression
        JP      C,ERR_SYNTAX

        ; Build the TPI command: we need to open the file then delete it
        ; Option A: Use the file system ERASE command ($08) directly
        ; Option B: Build a "TPI:DELETE" style command

        ; Option B is simpler - leverage existing TPI BASIC parsing:
        ; Build command string "TPI:filename" to select the file
        CALL    BUILD_OPEN_CMD
        CALL    SEND_TPI_CMD
        RET     C

        ; Now send the delete command
        LD      HL,STR_TPI_DELETE
        LD      BC,STR_TPI_DELETE_LEN
        LD      DE,CMD_BUFFER
        LDIR
        XOR     A
        LD      (DE),A
        CALL    SEND_TPI_CMD
        RET

;------------------------------------------------------------------
; String constants for ERASE
;------------------------------------------------------------------
STR_TPI_DELETE:
        DEFM    "TPI:DELETE"
STR_TPI_DELETE_LEN EQU $ - STR_TPI_DELETE


;******************************************************************
;
;  EXAMPLE 3: MOVE used as CD (change directory)
;
;  Syntax:  MOVE "dirname"       (change to directory)
;           MOVE "\"             (change to root)
;           MOVE ".."            (go up one level)
;
;  Maps to: SAVE "TPI:CD dirname"
;
;  Note: The original FDD MOVE renames/moves files.
;  On the SD card, changing directories is more useful.
;  We could support both: MOVE "src";"dst" for rename,
;  MOVE "dir" for CD.
;
;******************************************************************

;==================================================================
; MOVE_HANDLER - Execute MOVE (as CD) via TPI
;==================================================================
MOVE_HANDLER:
        LD      A,(TPMODE)
        BIT     1,A
        JP      Z,ERR_NO_DEVICE

        ; Parse directory name
        CALL    EVAL_STRING
        JP      C,ERR_SYNTAX

        ; Build "TPI:CD dirname"
        PUSH    HL
        PUSH    BC
        LD      HL,CMD_BUFFER
        LD      DE,STR_TPI_CD
        LD      BC,STR_TPI_CD_LEN
        LDIR
        POP     BC
        POP     DE
        LDIR
        XOR     A
        LD      (HL),A

        CALL    SEND_TPI_CMD
        RET

STR_TPI_CD:
        DEFM    "TPI:CD "
STR_TPI_CD_LEN EQU $ - STR_TPI_CD


;******************************************************************
;
;  EXAMPLE 4: FORMAT (as factory reset / init)
;
;  Syntax:  FORMAT
;           FORMAT "label"      (ignored on SD - just resets)
;
;  Maps to: SAVE "TPI:FRESET"
;
;  SD cards don't need formatting in the floppy sense.
;  FORMAT could reset the TPI configuration to defaults.
;  Or we could make it create/format a disk image file.
;
;******************************************************************

FORMAT_HANDLER:
        LD      A,(TPMODE)
        BIT     1,A
        JP      Z,ERR_NO_DEVICE

        LD      HL,STR_TPI_FRESET
        LD      BC,STR_TPI_FRESET_LEN
        LD      DE,CMD_BUFFER
        LDIR
        XOR     A
        LD      (DE),A
        CALL    SEND_TPI_CMD
        RET

STR_TPI_FRESET:
        DEFM    "TPI:FRESET"
STR_TPI_FRESET_LEN EQU $ - STR_TPI_FRESET


;******************************************************************
;
;  CORE: SEND_TPI_CMD - Send a TPI BASIC command via the protocol
;
;  This is the glue between FDD keyword parsing and TPI execution.
;  It takes a null-terminated command string in CMD_BUFFER and
;  sends it to the Pico using the TPI "B" frame protocol.
;
;  The TPI protocol for a BASIC command is:
;    1. Send "B" frame header (9 bytes + CRC):
;       $42, TADDR, $FF, PMR1_L, PMR1_H, PMR2_L, PMR2_H,
;       CMD_LEN_L, CMD_LEN_H
;    2. Wait for status ($01 = OK)
;    3. Wait for continue (bit 6 on port)
;    4. Send "D" data block with command string + CRC
;    5. Wait for status
;    6. Wait for continue
;    7. Read final status
;
;  Entry: CMD_BUFFER contains null-terminated TPI command string
;         (e.g., "TPI:DIR *.*")
;  Exit:  Carry clear = success, Carry set = error
;
;******************************************************************

SEND_TPI_CMD:
        DI                      ; disable interrupts for bus access

        ; Save current port state and enable EXROM
        IN      A,($FF)
        LD      (SAVE_DECR),A
        SET     7,A             ; set EXROM control bit
        OUT     ($FF),A         ; enable EXROM

        IN      A,($F4)
        LD      (SAVE_HSR),A
        LD      A,$03           ; EXROM in chunk 0
        OUT     ($F4),A

        ; Calculate command string length
        LD      HL,CMD_BUFFER
        LD      BC,0
.len_loop:
        LD      A,(HL)
        OR      A
        JR      Z,.len_done
        INC     HL
        INC     BC
        JR      .len_loop
.len_done:
        LD      (CMD_LENGTH),BC

        ; Build the "B" frame pre-header (9 bytes)
        LD      HL,PREHDR_BUF
        LD      (HL),$42        ; "B" = BASIC command frame
        INC     HL
        LD      (HL),$00        ; TADDR = SAVE (we're sending a command)
        INC     HL
        LD      (HL),$FF        ; BANK = HOME
        INC     HL
        LD      (HL),$00        ; PMR1 low
        INC     HL
        LD      (HL),$00        ; PMR1 high
        INC     HL
        LD      (HL),$00        ; PMR2 low
        INC     HL
        LD      (HL),$00        ; PMR2 high
        INC     HL
        LD      A,(CMD_LENGTH)
        LD      (HL),A          ; CMD_LEN low
        INC     HL
        LD      A,(CMD_LENGTH+1)
        LD      (HL),A          ; CMD_LEN high

        ; Calculate CRC (XOR of bytes 0-8)
        LD      HL,PREHDR_BUF
        LD      B,9
        XOR     A
.crc_loop:
        XOR     (HL)
        INC     HL
        DJNZ    .crc_loop

        ; Send pre-header bytes via TX_A
        LD      HL,PREHDR_BUF
        LD      B,9
        LD      D,A             ; save CRC in D
.send_hdr:
        LD      A,(HL)
        CALL    TPI_TX          ; send byte via port $0E
        INC     HL
        DJNZ    .send_hdr
        LD      A,D             ; send CRC
        CALL    TPI_TX

        ; Read status (expect $01 = OK)
        CALL    TPI_RX
        CP      $01
        JR      NZ,.cmd_error

        ; Wait for continue flag
        CALL    TPI_WAIT_CONTINUE
        JR      C,.cmd_error    ; timeout

        ; Now send the "D" data block with command string
        LD      A,$44           ; "D" = data block
        CALL    TPI_TX
        LD      A,(CMD_LENGTH)
        CALL    TPI_TX          ; length low
        LD      A,(CMD_LENGTH+1)
        CALL    TPI_TX          ; length high

        ; Send command string bytes with running CRC
        LD      HL,CMD_BUFFER
        LD      BC,(CMD_LENGTH)
        XOR     A               ; init CRC
        LD      D,A
.send_data:
        LD      A,B
        OR      C
        JR      Z,.send_crc
        LD      A,(HL)
        XOR     D
        LD      D,A             ; accumulate CRC
        LD      A,(HL)
        CALL    TPI_TX
        INC     HL
        DEC     BC
        JR      .send_data

.send_crc:
        LD      A,D             ; send CRC
        CALL    TPI_TX

        ; Read status
        CALL    TPI_RX
        CP      $01
        JR      NZ,.cmd_error

        ; Wait for continue
        CALL    TPI_WAIT_CONTINUE
        JR      C,.cmd_error

        ; Read final status
        CALL    TPI_RX
        CP      $01
        JR      NZ,.cmd_error

        ; Success - restore ports and return
        CALL    RESTORE_PORTS
        EI
        OR      A               ; clear carry = success
        RET

.cmd_error:
        CALL    RESTORE_PORTS
        EI
        SCF                     ; set carry = error
        RET

;------------------------------------------------------------------
; Low-level TPI byte I/O (thin wrappers around port $0E)
;------------------------------------------------------------------
TPI_TX:
        OUT     (IO_PORT),A     ; send byte to TS-PICO
        RET

TPI_RX:
        IN      A,(IO_PORT)     ; receive byte from TS-PICO
        RET

TPI_WAIT_CONTINUE:
        ; Poll for continue signal (bit 6 set)
        ; Uses same approach as WF_NPH in the EXROM
        LD      B,$E2           ; timeout counter (226 iterations)
.wait_loop:
        IN      A,(IO_PORT)     ; read port
        BIT     6,A             ; continue flag?
        JR      NZ,.wait_ok     ; yes - done
        DJNZ    .wait_loop      ; keep polling
        SCF                     ; timeout - set carry
        RET
.wait_ok:
        OR      A               ; clear carry
        RET

RESTORE_PORTS:
        LD      A,(SAVE_HSR)
        OUT     ($F4),A
        LD      A,(SAVE_DECR)
        OUT     ($FF),A
        RET

;------------------------------------------------------------------
; RECV_AND_DISPLAY - Receive text response and print to screen
;
; The Pico sends back a "D" data block containing text.
; For directory listings, this is formatted text with CR/LF.
; We display it line by line with scroll control.
;------------------------------------------------------------------
RECV_AND_DISPLAY:
        ; Wait for the Pico to send the response
        CALL    TPI_WAIT_CONTINUE
        RET     C

        ; Read "D" header
        CALL    TPI_RX          ; should be $44
        CP      $44
        JR      NZ,.recv_err
        CALL    TPI_RX          ; length low
        LD      C,A
        CALL    TPI_RX          ; length high
        LD      B,A

        ; BC = number of bytes to receive
        LD      A,B
        OR      C
        RET     Z               ; zero length = nothing to display

        ; Receive and print each byte
.recv_loop:
        PUSH    BC
        CALL    TPI_RX
        CP      $00             ; null = end of string
        JR      Z,.recv_done
        RST     $10             ; print character (in HOME ROM context)
                                ; NOTE: need bank switch here in practice
        POP     BC
        DEC     BC
        LD      A,B
        OR      C
        JR      NZ,.recv_loop
        RET

.recv_done:
        POP     BC
        ; Read and discard remaining bytes + CRC
        ; (simplified - real code needs to drain the buffer)
        RET

.recv_err:
        SCF
        RET

;==================================================================
; Stub routines (would need full implementation)
;==================================================================
EVAL_STRING:
        ; Evaluate BASIC string expression
        ; Returns HL = string address, BC = string length
        ; Would call through to HOME ROM expression evaluator
        RET

CHECK_EOL:
        ; Check if current char is end-of-line ($0D) or colon
        LD      A,(HL)
        CP      $0D
        RET     Z
        CP      ':'
        RET

BUILD_OPEN_CMD:
        ; Build "TPI:filename.tap" command to select a file
        ; before operations like DELETE
        RET

ERR_NO_DEVICE:
        RST     $08
        DEFB    $12             ; error: Invalid I/O device
ERR_SYNTAX:
        RST     $08
        DEFB    $0B             ; error: Nonsense in BASIC

;==================================================================
; Data areas
;==================================================================
CMD_BUFFER:     DEFS 256,0      ; Command string buffer
CMD_LENGTH:     DEFW 0          ; Length of command in buffer
PREHDR_BUF:     DEFS 10,0      ; Pre-header build area (9 bytes + CRC)
SAVE_DECR:      DEFB 0          ; Saved DECR port value
SAVE_HSR:       DEFB 0          ; Saved HSR port value


;******************************************************************
;
;  IMPLEMENTATION NOTES
;
;  1. WHERE THIS CODE LIVES
;     The FDD 3000 used a DOCK cartridge. For TS-PICO, we have
;     options:
;     a) Put this in the modified EXROM (space is tight but some
;        room exists between $22AE and the jump table)
;     b) Load it as a machine code program in RAM
;     c) Put it in a DOCK cartridge ROM image on the SD card
;        that the Pico loads at boot
;
;  2. COMMAND INTERCEPTION
;     The Gus EXROM already intercepts SAVE/LOAD for TPI. We need
;     to add interception for CAT, FORMAT, MOVE, ERASE tokens.
;     The cleanest approach: extend the TPI filename parser at
;     EXROM $1AB6 to also recognize these keyword tokens and
;     dispatch to appropriate handlers.
;
;  3. WHAT'S ALREADY DONE FOR US
;     - SAVE/LOAD/VERIFY/MERGE already work via TPI when SDCARD
;       mode is active — no changes needed
;     - The "B" frame protocol for BASIC commands is implemented
;     - TPI:DIR, TPI:DELETE, TPI:CD, TPI:CLOSE already exist
;     - The Pico already handles all these operations
;
;  4. WHAT WE NEED TO ADD
;     - Token interception for CAT, FORMAT, MOVE, ERASE, CLOSE
;     - Parsing the arguments for each command
;     - Building the appropriate TPI command string
;     - Sending it via the existing protocol
;     - Displaying responses (especially for CAT)
;
;  5. MINIMAL APPROACH
;     The absolute simplest implementation: intercept each FDD
;     keyword token and translate it to the equivalent
;     SAVE "TPI:xxx" call internally. The existing EXROM code
;     already handles the full TPI command string parsing and
;     protocol. We just need to synthesize the right string and
;     feed it into the existing parser at EXROM $1AB6.
;
;  6. PHASE 2: OPEN/CLOSE WITH STREAMS
;     The file system API has OPEN ($02), READ_BLOCK ($03),
;     WRITE_BLOCK ($04), SEEK ($05), CLOSE ($06). These map
;     to Sinclair BASIC streams/channels. Implementation needs:
;     - A channel handler installed in the channels area
;     - OPEN #n;"file" to create the channel
;     - INPUT #n and PRINT #n to read/write
;     - CLOSE #n to release the channel
;     This is the hard part and can wait.
;
;******************************************************************
