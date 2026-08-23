;******************************************************************
;
;  FDD-to-TPI Bridge — EXROM Extension
;
;  Adds CAT, ERASE, MOVE, FORMAT, CLOSE as native BASIC keywords
;  that route to existing TPI commands on the TS-PICO.
;
;  Lives in free EXROM space at $22AE-$3FFF.
;
;  Assembled with z80asm:  z80asm -o bridge.bin fdd_tpi_bridge.asm
;
;  (C) 2026 — TS-PICO Project
;
;******************************************************************

        ORG $22AE

;==================================================================
; TS-2068 System Equates
;==================================================================
CH_ADD          EQU $5C5D       ; current BASIC char pointer (2 bytes)
X_PTR           EQU $5C5F       ; error pointer
ERR_SP          EQU $5C3D       ; error stack pointer
ERR_NR          EQU $5C3A       ; IY+0, error number
FLAGS           EQU $5C3B       ; IY+1, FLAGS
TVFLAG          EQU $5C3C       ; IY+2
RESET           EQU $1354       ; HOME ROM error/reset entry
VIDMOD          EQU $5CC2       ; video mode

;==================================================================
; TPI System Equates
;==================================================================
TPMODE          EQU $5DDB       ; TPI mode variable
TPNAME          EQU $5DD3       ; filename pointer (2 bytes)
TPNLEN          EQU $5DD5       ; filename length (2 bytes)
IO_PORT         EQU $0E         ; TS-PICO data port

; TPI BIOS entry points (in this EXROM)
TPI_TX          EQU $229D       ; OUT (IO_PORT),A; AND A; RET
TPI_RX          EQU $2298       ; IN A,(IO_PORT); AND A; RET
TPI_WAIT        EQU $1A54       ; WF_NPH - wait for handshake
TPI_S_MODE      EQU $1862       ; Set output mode (S_MODE entry)

; Existing TPI command parsing (in this EXROM)
; The parser at $1A73 handles the filename after SAVE/LOAD
; and looks for "TPI:" prefix to dispatch commands.
; We'll call into the existing SLVM machinery where possible.

; EXROM bank-switch helpers
CALL_BANK       EQU $6572       ; normal video CALL_BANK
CALL_BANK_EXT   EQU $FD32       ; extended video CALL_BANK
GOTO_BANK       EQU $62AE       ; normal video GOTO_BANK

;==================================================================
; TS-2068 BASIC Token Values
;==================================================================
TOK_CAT         EQU $CF         ; CAT
TOK_FORMAT      EQU $D0         ; FORMAT
TOK_MOVE        EQU $D1         ; MOVE
TOK_ERASE       EQU $D2         ; ERASE
TOK_OPEN        EQU $D3         ; OPEN # (Phase 2)
TOK_CLOSE       EQU $D4         ; CLOSE #
TOK_VERIFY      EQU $D6         ; VERIFY (already handled by SLVM)
TOK_SAVE        EQU $C9         ; SAVE (already handled)
TOK_LOAD        EQU $CA         ; LOAD (already handled)

; HOME ROM routines we need to call (via CALL_BANK or RST trampoline)
; These addresses are in the HOME ROM address space.
HOME_EXPT_STR   EQU $1C8C       ; expect string expression
HOME_NEXT_CH    EQU $0020       ; RST $20 - get next character
HOME_GET_CH     EQU $0018       ; RST $18 - get current character
HOME_STK_FETCH  EQU $2BF1       ; fetch string params from calc stack


;******************************************************************
;******************************************************************
;
;  HOOK ENTRY POINT
;
;  This routine is called when the BASIC command dispatcher
;  encounters a token it doesn't recognize in the normal
;  SAVE/LOAD/VERIFY/MERGE path. We check if it's one of our
;  FDD commands and redirect accordingly.
;
;  HOW TO INSTALL THIS HOOK:
;  In the existing EXROM, at the point where an unrecognized
;  command would fall through to error, insert:
;
;      CALL FDD_CMD_CHECK    ; ($22AE)
;      RET NZ                ; handled - return normally
;      ; ...original error path continues...
;
;  Or alternatively, patch the RST 8 handler to check tokens
;  before generating the error.
;
;  See INSTALL NOTES at the bottom of this file for the exact
;  bytes to patch.
;
;******************************************************************
;******************************************************************

;==================================================================
; FDD_CMD_CHECK — Check if current token is an FDD command
;
; Entry: Called during BASIC command dispatch
;        CH_ADD points to current position in BASIC line
; Exit:  Z flag clear (NZ) if command was handled
;        Z flag set if not our command (caller should continue
;        with normal error path)
;==================================================================
FDD_CMD_CHECK:
        ; Get the keyword token from the BASIC line
        LD      HL,(CH_ADD)
        LD      A,(HL)

        ; Check if we're in SD card mode first
        PUSH    AF
        LD      A,(TPMODE)
        BIT     1,A             ; SD card mode?
        JR      NZ,.mode_ok
        POP     AF
        XOR     A               ; set Z = not handled
        RET
.mode_ok:
        POP     AF

        ; Scan backwards to find the keyword token
        ; (CH_ADD may be past the token, pointing at arguments)
        LD      HL,(CH_ADD)
.scan_back:
        LD      A,(HL)
        CP      $A5             ; tokens are >= $A5 in TS-2068
        JR      NC,.found_token
        DEC     HL
        ; Safety: don't scan back more than 32 bytes
        LD      A,(CH_ADD)
        SUB     L
        CP      32
        JR      C,.scan_back
        XOR     A               ; not found, set Z
        RET

.found_token:
        ; A = token byte, HL = points to it
        ; Look it up in our dispatch table
        LD      DE,CMD_DISPATCH_TABLE
        LD      B,CMD_DISPATCH_COUNT

.check_loop:
        PUSH    HL
        LD      HL,DE           ; can't do LD A,(DE) and compare
        EX      DE,HL
        LD      C,A             ; save token in C
        LD      A,(DE)          ; get table token
        CP      C               ; match?
        JR      Z,.found_cmd
        ; Skip to next entry (3 bytes per entry: token + 2-byte addr)
        INC     DE
        INC     DE
        INC     DE
        POP     HL
        LD      A,C             ; restore token
        DJNZ    .check_loop

        ; Not one of our commands
        XOR     A               ; set Z = not handled
        RET

.found_cmd:
        POP     HL              ; discard saved HL
        ; DE points to matched table entry
        ; Get handler address from table
        INC     DE              ; skip token byte
        EX      DE,HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        EX      DE,HL           ; HL = handler address

        ; Advance CH_ADD past the token
        LD      DE,(CH_ADD)
.skip_token:
        LD      A,(DE)
        CP      $A5
        JR      C,.past_token
        INC     DE
        JR      .skip_token
.past_token:
        ; Skip any spaces after the token
        CP      ' '
        JR      NZ,.no_space
        INC     DE
        LD      A,(DE)
        JR      .past_token
.no_space:
        LD      (CH_ADD),DE

        ; Check syntax vs execution
        ; FLAGS bit 7: 0 = syntax checking, 1 = execution
        BIT     7,(IY+1)        ; FLAGS bit 7
        JR      Z,.syntax_ok    ; during syntax check, just validate

        ; EXECUTION — jump to the handler
        JP      (HL)

.syntax_ok:
        ; During syntax check, we need to consume the arguments
        ; but not execute. For simplicity, we just skip to end
        ; of statement.
        ; (A more thorough implementation would validate arg syntax)
        OR      $FF             ; set NZ = handled
        RET

;==================================================================
; Command Dispatch Table
; Each entry: 1 byte token, 2 bytes handler address
;==================================================================
CMD_DISPATCH_TABLE:
        DEFB    TOK_CAT
        DEFW    CMD_CAT
        DEFB    TOK_ERASE
        DEFW    CMD_ERASE
        DEFB    TOK_MOVE
        DEFW    CMD_MOVE
        DEFB    TOK_FORMAT
        DEFW    CMD_FORMAT
        DEFB    TOK_CLOSE
        DEFW    CMD_CLOSE
CMD_DISPATCH_COUNT EQU 5


;******************************************************************
;******************************************************************
;
;  COMMAND HANDLERS
;
;******************************************************************
;******************************************************************

;==================================================================
; CMD_CAT — Directory Listing
;
; Syntax:  CAT                  (list all files)
;          CAT "pattern"        (list matching files)
;
; Maps to: SAVE "TPI:DIR *.*"  or  SAVE "TPI:DIR pattern"
;==================================================================
CMD_CAT:
        ; Check for optional filename/pattern argument
        LD      A,(DE)          ; current char (DE = CH_ADD)
        CP      $0D             ; end of line?
        JR      Z,.cat_all
        CP      ':'             ; end of statement?
        JR      Z,.cat_all
        CP      '"'             ; quoted string?
        JR      Z,.cat_pattern

        ; No valid argument — list all
.cat_all:
        LD      HL,STR_DIR_ALL
        LD      BC,STR_DIR_ALL_END - STR_DIR_ALL
        JR      .cat_send

.cat_pattern:
        ; Parse the quoted string
        ; Skip opening quote
        INC     DE
        LD      (CH_ADD),DE
        LD      HL,CMD_BUF
        ; Copy "TPI:DIR " prefix
        PUSH    HL
        LD      DE,STR_TPI_DIR
        LD      BC,STR_TPI_DIR_END - STR_TPI_DIR
        LDIR
        ; HL now points past prefix in CMD_BUF
        ; Copy the pattern from BASIC line
        LD      DE,(CH_ADD)
.copy_pattern:
        LD      A,(DE)
        CP      '"'             ; closing quote?
        JR      Z,.pattern_done
        CP      $0D             ; end of line? (missing close quote)
        JR      Z,.pattern_done
        LD      (HL),A
        INC     HL
        INC     DE
        JR      .copy_pattern
.pattern_done:
        CP      '"'
        JR      NZ,.no_close_quote
        INC     DE              ; skip closing quote
.no_close_quote:
        LD      (CH_ADD),DE     ; update BASIC pointer
        LD      (HL),0          ; null terminate
        ; Calculate total length
        POP     DE              ; DE = start of CMD_BUF
        OR      A
        SBC     HL,DE           ; HL = length
        LD      B,H
        LD      C,L
        LD      HL,CMD_BUF      ; point to the built string
        JR      .cat_send

.cat_send:
        ; HL = command string, BC = length
        ; Send as a TPI "B" frame BASIC command
        ; TADDR = $00 (SAVE), command string = "TPI:DIR ..."
        CALL    SEND_TPI_BASIC_CMD
        RET     C               ; error

        ; Receive and display the response
        ; The Pico sends status codes; $81 = PRINT_STRING
        ; means it will send text to display
        CALL    HANDLE_TPI_RESPONSE
        OR      $FF             ; set NZ = handled
        RET


;==================================================================
; CMD_ERASE — Delete a File
;
; Syntax:  ERASE "filename"
;
; Maps to: We send a TPI "B" frame with the filename as a
;          "TPI:DELETE" style command. The simplest approach is
;          to first select the file, then delete it.
;
; Alternative: Use the file system ERASE command ($08) directly.
;==================================================================
CMD_ERASE:
        ; Parse the filename
        LD      A,(DE)
        CP      '"'
        JP      NZ,BRIDGE_ERR_SYNTAX

        ; Build "TPI:DELETE" is tricky because DELETE needs the
        ; file already selected. Instead, build a composite:
        ; First open the file with "TPI:filename.tap"
        INC     DE
        LD      (CH_ADD),DE

        ; Build "TPI:<filename>" to select the file
        LD      HL,CMD_BUF
        LD      DE,STR_TPI_PREFIX
        LD      BC,STR_TPI_PREFIX_END - STR_TPI_PREFIX
        LDIR
        ; Copy filename
        LD      DE,(CH_ADD)
.erase_copy:
        LD      A,(DE)
        CP      '"'
        JR      Z,.erase_fname_done
        CP      $0D
        JR      Z,.erase_fname_done
        LD      (HL),A
        INC     HL
        INC     DE
        JR      .erase_copy
.erase_fname_done:
        CP      '"'
        JR      NZ,.erase_no_close
        INC     DE
.erase_no_close:
        LD      (CH_ADD),DE
        LD      (HL),0          ; null terminate

        ; Send the file selection command
        LD      HL,CMD_BUF
        CALL    STRLEN
        CALL    SEND_TPI_BASIC_CMD
        JR      C,.erase_fail
        CALL    HANDLE_TPI_RESPONSE
        JR      C,.erase_fail

        ; Now send the DELETE command
        LD      HL,STR_TPI_DELETE
        LD      BC,STR_TPI_DELETE_END - STR_TPI_DELETE
        CALL    SEND_TPI_BASIC_CMD
        JR      C,.erase_fail
        CALL    HANDLE_TPI_RESPONSE

.erase_fail:
        ; Set NZ regardless (we handled the command, even if error)
        OR      $FF
        RET


;==================================================================
; CMD_MOVE — Change Directory
;
; Syntax:  MOVE "dirname"       (change to directory)
;          MOVE "\"             (change to root)
;
; Maps to: SAVE "TPI:CD dirname"
;
; Note: Could also support MOVE "src" TO "dst" for rename in
; a future version. For now, MOVE = CD.
;==================================================================
CMD_MOVE:
        LD      A,(DE)
        CP      '"'
        JP      NZ,BRIDGE_ERR_SYNTAX

        ; Build "TPI:CD <dirname>"
        INC     DE
        LD      (CH_ADD),DE
        LD      HL,CMD_BUF
        LD      DE,STR_TPI_CD
        LD      BC,STR_TPI_CD_END - STR_TPI_CD
        LDIR
        LD      DE,(CH_ADD)
.move_copy:
        LD      A,(DE)
        CP      '"'
        JR      Z,.move_done
        CP      $0D
        JR      Z,.move_done
        LD      (HL),A
        INC     HL
        INC     DE
        JR      .move_copy
.move_done:
        CP      '"'
        JR      NZ,.move_no_close
        INC     DE
.move_no_close:
        LD      (CH_ADD),DE
        LD      (HL),0

        LD      HL,CMD_BUF
        CALL    STRLEN
        CALL    SEND_TPI_BASIC_CMD
        CALL    NC,HANDLE_TPI_RESPONSE
        OR      $FF             ; NZ = handled
        RET


;==================================================================
; CMD_FORMAT — Factory Reset
;
; Syntax:  FORMAT              (reset TPI configuration)
;
; Maps to: SAVE "TPI:FRESET"
;
; SD cards don't need formatting. This resets the TS-PICO
; configuration to factory defaults.
;==================================================================
CMD_FORMAT:
        LD      HL,STR_TPI_FRESET
        LD      BC,STR_TPI_FRESET_END - STR_TPI_FRESET
        CALL    SEND_TPI_BASIC_CMD
        CALL    NC,HANDLE_TPI_RESPONSE
        OR      $FF
        RET


;==================================================================
; CMD_CLOSE — Close Current TAP File
;
; Syntax:  CLOSE               (close current file)
;
; Maps to: SAVE "TPI:CLOSE"
;==================================================================
CMD_CLOSE:
        LD      HL,STR_TPI_CLOSE
        LD      BC,STR_TPI_CLOSE_END - STR_TPI_CLOSE
        CALL    SEND_TPI_BASIC_CMD
        CALL    NC,HANDLE_TPI_RESPONSE
        OR      $FF
        RET


;******************************************************************
;******************************************************************
;
;  TPI PROTOCOL INTERFACE
;
;  These routines send commands to the TS-PICO using the
;  existing "B" frame BASIC command protocol.
;
;******************************************************************
;******************************************************************

;==================================================================
; SEND_TPI_BASIC_CMD — Send a TPI command via "B" frame protocol
;
; Entry: HL = pointer to null-terminated command string
;              (e.g., "TPI:DIR *.*" or "TPI:CLOSE")
;        BC = string length
;
; Exit:  Carry clear = pre-header and data sent OK
;        Carry set = communication error
;
; Protocol:
;   1. Send "B" pre-header: $42, $00(SAVE), $FF(HOME), 0,0,0,0,
;      len_lo, len_hi  + CRC
;   2. Read status (expect $01)
;   3. Wait continue
;   4. Send "D" data block: $44, len_lo, len_hi, <string>, CRC
;   5. Read status
;   6. Wait continue
;==================================================================
SEND_TPI_BASIC_CMD:
        PUSH    HL              ; save string pointer
        PUSH    BC              ; save length

        ; Store length for later
        LD      (CMD_LENGTH),BC

        DI                      ; critical section

        ; Enable EXROM access for TPI BIOS routines
        ; (we're already in EXROM context, but ensure chunk 0)
        LD      A,(TPMODE)
        OR      $02             ; ensure SD card flag
        LD      (TPMODE),A

        ;------------------------------------------------------
        ; Phase 1: Send "B" pre-header (9 bytes + CRC)
        ;------------------------------------------------------
        ; Byte 0: $42 "B" = BASIC command
        LD      A,$42
        CALL    TPI_TX
        LD      D,A             ; D = running XOR checksum

        ; Byte 1: $00 = TADDR (SAVE command)
        XOR     A
        CALL    TPI_TX
        XOR     D
        LD      D,A

        ; Byte 2: $FF = BANK (HOME)
        LD      A,$FF
        CALL    TPI_TX
        XOR     D
        LD      D,A

        ; Bytes 3-6: PMR1, PMR2 (all zeros)
        XOR     A
        CALL    TPI_TX          ; byte 3
        XOR     D
        LD      D,A
        XOR     A
        CALL    TPI_TX          ; byte 4
        XOR     D
        LD      D,A
        XOR     A
        CALL    TPI_TX          ; byte 5
        XOR     D
        LD      D,A
        XOR     A
        CALL    TPI_TX          ; byte 6
        XOR     D
        LD      D,A

        ; Bytes 7-8: command string length
        LD      A,(CMD_LENGTH)  ; low byte
        CALL    TPI_TX
        XOR     D
        LD      D,A
        LD      A,(CMD_LENGTH+1) ; high byte
        CALL    TPI_TX
        XOR     D
        LD      D,A

        ; Byte 9: CRC (XOR of bytes 0-8)
        LD      A,D
        CALL    TPI_TX

        ; Read status — expect $01 (OK)
        CALL    TPI_RX
        CP      $01
        JR      NZ,.send_fail

        ; Wait for continue
        CALL    TPI_WAIT
        JR      C,.send_fail

        ;------------------------------------------------------
        ; Phase 2: Send "D" data block
        ;------------------------------------------------------
        ; Byte 0: $44 "D" = data block
        LD      A,$44
        CALL    TPI_TX
        LD      D,A             ; D = running CRC

        ; Bytes 1-2: data length
        LD      BC,(CMD_LENGTH)
        LD      A,C             ; length low
        CALL    TPI_TX
        XOR     D
        LD      D,A
        LD      A,B             ; length high
        CALL    TPI_TX
        XOR     D
        LD      D,A

        ; Bytes 3+: command string data
        POP     BC              ; restore length
        POP     HL              ; restore string pointer
        PUSH    BC              ; save again for return
        PUSH    HL
.send_loop:
        LD      A,B
        OR      C
        JR      Z,.send_crc
        LD      A,(HL)
        CALL    TPI_TX
        XOR     D
        LD      D,A
        INC     HL
        DEC     BC
        JR      .send_loop

.send_crc:
        ; Send CRC
        LD      A,D
        CALL    TPI_TX

        ; Read status
        CALL    TPI_RX
        CP      $01
        JR      NZ,.send_fail2

        ; Wait for continue
        CALL    TPI_WAIT
        JR      C,.send_fail2

        ; Success
        POP     HL
        POP     BC
        EI
        OR      A               ; clear carry
        RET

.send_fail:
        POP     BC
        POP     HL
.send_fail2:
        POP     HL              ; balance stack if needed
        POP     BC
        EI
        SCF                     ; set carry = error
        RET


;==================================================================
; HANDLE_TPI_RESPONSE — Process the Pico's response
;
; After sending a command, the Pico may respond with:
;   $01 = OK, command complete
;   $81 = PRINT_STRING — Pico sends text to display
;   $82 = PRINT_STRING_RET_KEY — display text, wait for key
;   $83 = PRINT_CHARACTER — print single char
;   $84 = RETURN_KEY — wait for keypress, send back
;   $85 = GET_STATUS — return device status
;   $86 = PRINT_STRING_LOOP — display with Y/N prompt
;
; For CAT, the typical flow is:
;   Status $81: Pico sends directory text line by line
;   We receive and print each line until status $01 (done)
;
; Entry: Previous command sent successfully
; Exit:  Carry clear = OK, Carry set = error
;==================================================================
HANDLE_TPI_RESPONSE:
        ; Read the final status byte
        CALL    TPI_RX
        LD      B,A             ; save status

        ; Check for simple OK
        CP      $01
        JR      Z,.resp_ok

        ; Check for extended status codes (>= $80)
        BIT     7,A
        JR      Z,.resp_error   ; < $80 and not $01 = error code

        ;------------------------------------------------------
        ; Handle PRINT_STRING ($81)
        ; Pico sends: status_code, then null-terminated chars
        ;------------------------------------------------------
        CP      $81
        JR      Z,.resp_print_string
        CP      $83
        JR      Z,.resp_print_char
        CP      $82
        JR      Z,.resp_print_key

        ; Other extended codes — just acknowledge and continue
        LD      A,$01           ; send OK back
        CALL    TPI_TX
        JR      HANDLE_TPI_RESPONSE ; loop for more

.resp_print_string:
        ; Send the return error code ($01 = OK)
        LD      A,$01
        CALL    TPI_TX

        ; Receive and print characters until $00
.print_loop:
        CALL    TPI_RX
        OR      A               ; null terminator?
        JR      Z,.print_done
        ; Print character to screen
        ; We need to call the HOME ROM's RST $10 (print char)
        ; Since we're in EXROM context, we can use the standard
        ; output mechanism
        PUSH    AF
        LD      A,(VIDMOD)
        OR      A
        JR      NZ,.print_ext
        POP     AF
        CALL    $6572           ; CALL_BANK to HOME ROM print char
        JR      .print_loop
.print_ext:
        POP     AF
        CALL    $FD32           ; extended video CALL_BANK
        JR      .print_loop

.print_done:
        ; Check if there's more data (next status)
        CALL    TPI_WAIT
        JR      C,.resp_ok      ; timeout = done
        JR      HANDLE_TPI_RESPONSE ; loop for more status

.resp_print_char:
        ; $83: Print single character, send it back
        LD      A,$01           ; send OK
        CALL    TPI_TX
        CALL    TPI_RX          ; receive the character
        PUSH    AF
        ; Print it (simplified — needs bank switch in practice)
        POP     AF
        CALL    TPI_TX          ; echo back to Pico
        JR      HANDLE_TPI_RESPONSE

.resp_print_key:
        ; $82: Print string, then wait for keypress
        LD      A,$01
        CALL    TPI_TX
        ; Print the string
.pk_loop:
        CALL    TPI_RX
        OR      A
        JR      Z,.pk_wait_key
        ; Print char (simplified)
        JR      .pk_loop
.pk_wait_key:
        ; Wait for a key (simplified — reads LAST_K)
        LD      A,($5C08)       ; LAST_K
        OR      A
        JR      Z,.pk_wait_key
        CALL    TPI_TX          ; send key to Pico
        JR      HANDLE_TPI_RESPONSE

.resp_error:
        ; Error status code (1-10 range)
        ; Map to BASIC error and report
        ; For now, just set carry and return
        SCF
        RET

.resp_ok:
        OR      A               ; clear carry
        RET


;==================================================================
; STRLEN — Calculate length of null-terminated string
; Entry: HL = string pointer
; Exit:  BC = string length (not including null)
;        HL preserved
;==================================================================
STRLEN:
        PUSH    HL
        LD      BC,0
.sl_loop:
        LD      A,(HL)
        OR      A
        JR      Z,.sl_done
        INC     HL
        INC     BC
        JR      .sl_loop
.sl_done:
        POP     HL
        RET


;==================================================================
; Error entry points
;==================================================================
BRIDGE_ERR_SYNTAX:
        EI
        RST     $08
        DEFB    $0B             ; "C Nonsense in BASIC"

BRIDGE_ERR_DEVICE:
        EI
        RST     $08
        DEFB    $12             ; "J Invalid I/O device"


;******************************************************************
;
;  STRING CONSTANTS
;
;******************************************************************

STR_TPI_DIR:
        DEFM    "TPI:DIR "
STR_TPI_DIR_END:

STR_DIR_ALL:
        DEFM    "TPI:DIR *.*"
        DEFB    0
STR_DIR_ALL_END:

STR_TPI_PREFIX:
        DEFM    "TPI:"
STR_TPI_PREFIX_END:

STR_TPI_DELETE:
        DEFM    "TPI:DELETE"
        DEFB    0
STR_TPI_DELETE_END:

STR_TPI_CD:
        DEFM    "TPI:CD "
STR_TPI_CD_END:

STR_TPI_CLOSE:
        DEFM    "TPI:CLOSE"
        DEFB    0
STR_TPI_CLOSE_END:

STR_TPI_FRESET:
        DEFM    "TPI:FRESET"
        DEFB    0
STR_TPI_FRESET_END:


;******************************************************************
;
;  VARIABLES (in free EXROM space — or could use RAM workspace)
;
;******************************************************************

CMD_BUF:
        DEFS    128,0           ; command build buffer
CMD_LENGTH:
        DEFW    0               ; command string length


;******************************************************************
;
;  INSTALL NOTES
;
;  To activate this bridge, we need ONE patch in the existing
;  EXROM code. The cleanest insertion point is at the SLVM
;  routine ($01AB), which is where SAVE/LOAD/VERIFY/MERGE
;  are dispatched. Before the existing token check:
;
;  OPTION A: Patch SLVM entry ($01AB)
;  ----------------------------------
;  Currently $01AB is: JP $0210 (the existing SLVM handler)
;
;  Change to: CALL FDD_CMD_CHECK ($22AE)
;             RET NZ              (command was handled)
;             JP $0210            (not ours, continue to SLVM)
;
;  This requires 7 bytes at $01AB. The current JP is 3 bytes.
;  We'd need to relocate 4 bytes of existing code. Alternatively:
;
;  OPTION B: Patch at the HOME ROM call site ($2547)
;  -------------------------------------------------
;  The HOME ROM DOSAVE at $2547 calls into the EXROM.
;  We could redirect that to check our tokens first.
;
;  OPTION C: Extend the error handler (RST 8)
;  -------------------------------------------
;  Patch the RST 8 handler at $0008 to check for our tokens
;  when error $0B (Nonsense in BASIC) occurs. This is the
;  traditional Interface 1 / FDD 3000 approach.
;
;  At $0010 (after loading error code into L):
;    LD (IY+0),L          ; store error number (existing)
;    ; INSERT: check if this is a "nonsense" error on our token
;    LD A,L
;    CP $0B                ; error $0B = Nonsense in BASIC?
;    CALL Z,FDD_CMD_CHECK  ; yes — check if it's our command
;    JR NZ,.handled        ; NZ = we handled it, skip error
;    ; ...continue with normal error path...
;
;  This needs ~8 bytes inserted into the RST 8 handler.
;  The handler at $0008-$001F is tight, but we could redirect:
;
;  $0010: JP FDD_ERROR_HOOK   (3 bytes, replacing existing code)
;
;  Then FDD_ERROR_HOOK (in free space) does:
;    LD (IY+0),L           ; do what we replaced
;    LD A,L
;    CP $0B
;    JR NZ,.not_ours
;    CALL FDD_CMD_CHECK
;    RET NZ                ; handled — don't generate error
;  .not_ours:
;    LD SP,(ERR_SP)        ; continue original error path
;    JP RESET
;
;  RECOMMENDATION: Option C is the safest because it doesn't
;  change the SLVM flow at all. It only catches commands that
;  would have errored anyway. This is proven technology — it's
;  exactly what the FDD 3000 and Interface 1 did.
;
;  EXACT PATCH FOR OPTION C:
;
;  In gus-exrom.rom at offset $0010 (EXROM address $0010):
;
;  Original bytes: FD 75 00    (LD (IY+0),L)
;  Replace with:   C3 xx yy    (JP FDD_ERROR_HOOK)
;
;  Where xxyy = address of FDD_ERROR_HOOK in the $22AE+ area.
;
;  Then FDD_ERROR_HOOK contains:
;
FDD_ERROR_HOOK:
        LD      (IY+0),L       ; do what we replaced at $0010
        LD      A,L
        CP      $0B             ; Nonsense in BASIC?
        JR      NZ,.not_fdd_cmd
        ; It's a "nonsense" error — check if token is ours
        PUSH    HL
        CALL    FDD_CMD_CHECK   ; check and maybe handle
        POP     HL
        JR      NZ,.was_handled ; NZ = we handled it
.not_fdd_cmd:
        ; Continue original error path (code from $0013 onwards)
        LD      SP,(ERR_SP)     ; $5C3D
        LD      HL,RESET        ; $1354
        PUSH    HL
        LD      H,$FF
        LD      L,$00
        PUSH    HL
        ; Fall through to GOTO_BANK (existing code at $0020)
        PUSH    AF
        LD      A,(VIDMOD)
        AND     A
        JR      NZ,.ext_vid
        POP     AF
        CALL    $6572           ; CALL_BANK normal
        RET                     ; (won't reach here)
.ext_vid:
        POP     AF
        CALL    $FD32           ; CALL_BANK extended
        RET

.was_handled:
        ; Command was handled successfully by our bridge.
        ; Return to BASIC main loop cleanly.
        EI
        LD      SP,(ERR_SP)
        ; Signal OK (error 0 = OK, -1 in the error number)
        LD      (IY+0),$FF     ; ERR_NR = -1 = OK
        JP      RESET           ; return to BASIC prompt

;
;  END OF FILE
;
;******************************************************************
