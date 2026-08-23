;******************************************************************
;
;  FDD 3000 DOCK Cartridge ROM - Fully Annotated Disassembly
;
;  TMX Portugal, 1985
;  TOS (Timex Operating System) for FDD 3000 Floppy Disk Drive
;
;  4KB DOCK cartridge ROM for the Timex/Sinclair 2068
;  Adds disk commands to Sinclair BASIC:
;    CAT, FORMAT, MOVE, ERASE, SAVE, LOAD, VERIFY,
;    OPEN, CLOSE
;
;  FDD I/O via nibble-wide handshaked parallel protocol on
;  port $EF.
;
;  Source: z80dasm 1.2.0 disassembly of 3000_2068.ROM
;  Annotated with meaningful labels and comments.
;
;******************************************************************

        ORG $0000

;==================================================================
; RAM WORKSPACE EQUATES ($2000-$2155)
;==================================================================
IO_BUFFER       EQU $2000       ; 256-byte data/sector I/O buffer
FDD_CMD         EQU $2100       ; FDD command code byte
SAVED_AF        EQU $2101       ; Saved AF register pair
SAVED_BC        EQU $2103       ; Saved BC register pair
SAVED_DE        EQU $2105       ; Saved DE register pair
SAVED_HL        EQU $2107       ; Saved HL register pair
SAVED_IX        EQU $2109       ; Saved IX register pair
SAVED_IY        EQU $210B       ; Saved IY register pair
MSG_BUFFER      EQU $210D       ; Message/error text buffer (32 bytes)
PKT_SIZE        EQU $212D       ; Data packet size code
DRIVE_NUM       EQU $212E       ; Current drive number
FRAME_TYPE      EQU $212F       ; Frame type ($C0=cmd, $D0=data)
PAYLOAD_LEN     EQU $2130       ; Payload length
RESP_BYTE       EQU $2131       ; Response/checksum byte
RETRY_CTR       EQU $2132       ; Retry counter (init $0A)
LOAD_SUBTYPE    EQU $2133       ; LOAD sub-type (0=prog,2=code+addr,etc)
FILE_TYPE       EQU $2134       ; File type/format flag
VAR_NAME        EQU $2136       ; Variable name / channel mode char
PROG_LOAD_FLG   EQU $2138       ; Program load flag
SECONDARY_FLG   EQU $2139       ; Secondary flag (verify, OPEN dir)
FDD_FLAGS       EQU $213A       ; FDD system flags
DEFAULT_RET     EQU $213B       ; Default return addr (HOME ROM)
INDIRECT_RET    EQU $213D       ; Indirect return pointer
SAVED_CH_ADD    EQU $213F       ; Saved CH_ADD
SAVED_DE_TRAMP  EQU $2141       ; Saved DE for trampoline
DATA_LEN_REM    EQU $2145       ; Data length remaining (multi-sector)
MEM_ADDR        EQU $2147       ; Memory dest/source address
VAR_ENTRY       EQU $2149       ; Pointer to variable entry
FILE_SIZE       EQU $214B       ; File size / start line
LOAD_MODE       EQU $214D       ; LOAD mode flags
LOAD_ADDR       EQU $214E       ; Load address (CODE)
LOAD_LENGTH     EQU $2150       ; Load length (CODE)
SAVE_VAR_INFO   EQU $2155       ; Variable info for SAVE

;==================================================================
; TS-2068 System Variable Equates
;==================================================================
LAST_K          EQU $5C08       ; Last key pressed
ERR_SP          EQU $5C3D       ; Error stack pointer
NEWPPC          EQU $5C42       ; Line to be jumped to (2 bytes)
NSPPC           EQU $5C44       ; Statement number in new line
SUBPPC          EQU $5C47       ; Statement number in current line
PROG            EQU $5C53       ; Start of BASIC program
CH_ADD          EQU $5C5D       ; Address of next char to interpret
X_PTR           EQU $5C5F       ; Address of char after ? in errors
E_LINE          EQU $5C59       ; Address of command being typed
VARS            EQU $5C4B       ; Start of variables area
SCR_CT          EQU $5C8C       ; Scroll counter
RASP_PIP        EQU $5CB0       ; Rasp/pip lengths
RAMTOP          EQU $5CB1       ; Top of RAM in use

;==================================================================
; FDD Command Code Equates
;==================================================================
FDD_CLOSE       EQU $00         ; Close file
FDD_FLUSH       EQU $01         ; Flush buffer
FDD_SAVE        EQU $02         ; Save file
FDD_CAT         EQU $03         ; Catalog / directory
FDD_LOAD        EQU $05         ; Load file
FDD_INIT        EQU $07         ; Initialize
FDD_VERIFY      EQU $09         ; Verify file
FDD_ERASE       EQU $0A         ; Erase file
FDD_ERROR_Q     EQU $0B         ; Query error
FDD_FILE_INFO   EQU $0C         ; File information
FDD_CAT_STRM    EQU $0D         ; CAT with stream number
FDD_CAT_NOSTRM  EQU $0E         ; CAT without stream
FDD_XFER        EQU $0F         ; Transfer data block
FDD_RD_SECTOR   EQU $10         ; Read sector
FDD_PREPARE     EQU $12         ; Prepare for transfer
FDD_FORMAT      EQU $13         ; Format disk
FDD_DRIVE_SEL   EQU $14         ; Drive select
FDD_OPEN_FILE   EQU $15         ; Open file
FDD_OPEN_ADDR   EQU $16         ; Open with address
FDD_PROBE       EQU $17         ; Probe controller

;==================================================================
; Port Equates
;==================================================================
PORT_FDD        EQU $EF         ; FDD 3000 data/control port
PORT_HSR        EQU $F4         ; Horizontal select register
PORT_BORDER     EQU $FE         ; Border/speaker/keyboard
PORT_DECR       EQU $FF         ; Display/bank select register

;******************************************************************
;******************************************************************
;
;  RST VECTORS AND LOW MEMORY ($0000-$0038)
;
;******************************************************************
;******************************************************************

;==================================================================
; RST $00 - Cold Start Vector
; DI then jump to hardware initialization
;==================================================================
RST_00:
        DI                              ;0000 disable interrupts
        JP COLD_START                   ;0001 jump to cold start init

;------------------------------------------------------------------
; $0004-$0007: Unused padding
;------------------------------------------------------------------
        DEFB $FF                        ;0004
        DEFB $FF                        ;0005
        DEFB $FF                        ;0006
        DEFB $FF                        ;0007

;==================================================================
; RST $08 - Error Handler Vector
; Jumps to error handler at $0039
;==================================================================
RST_08:
        JR ERROR_HANDLER                ;0008

;==================================================================
; $000A - Bank Return Landing Pad
; After a HOME ROM call via CALL_HOME, execution returns here
; when the bank switches back to DOCK space.
; The $FF bytes are just padding; they are never executed.
;==================================================================
BANK_RETURN_PAD:
        DEFB $FF                        ;000A
        DEFB $FF                        ;000B
        DEFB $FF                        ;000C
        DEFB $FF                        ;000D
        DEFB $FF                        ;000E
        DEFB $FF                        ;000F

;==================================================================
; RST $10 - Bank Switch Trampoline to HOME ROM
; NOT the usual "print character" RST $10!
; Usage: RST $10 / DW target_addr
; Calls a routine in the HOME ROM via bank switching.
;==================================================================
RST_10:
        JP CALL_HOME                    ;0010 trampoline to HOME ROM

;==================================================================
; READ_KEY ($0013)
; Read a key from the keyboard with case conversion.
; Clears bit 5 of FLAGS (new key available), sets bit 3 (L mode).
; Calls HOME ROM $02B0 to scan keyboard.
; Returns: A = key code (uppercase if alpha)
;          Z flag set if no key pressed
;==================================================================
READ_KEY:
        RES 5,(IY+$01)                 ;0013 clear "new key" flag in FLAGS
        SET 3,(IY+$01)                 ;0017 set L mode (keyword input)
        RST $10                         ;001B call HOME ROM...
        DEFW $02B0                      ;001C ...keyboard scan routine
        XOR A                           ;001E clear A
        BIT 5,(IY+$01)                 ;001F test if new key was pressed
        RET Z                           ;0023 return Z if no key
        LD A,(LAST_K)                   ;0024 get the key code
        CP 'a'                          ;0027 is it lowercase alpha?
        RET C                           ;0029 return if below 'a' (not lowercase)
        AND $DF                         ;002A convert to uppercase (clear bit 5)
        RET                             ;002C done

;==================================================================
; PRINT_CR ($002D)
; Print a carriage return character to the current output stream.
; Uses RST $10 to call HOME ROM print routine.
;==================================================================
PRINT_CR:
        LD A,$0D                        ;002D carriage return character
        RST $10                         ;002F call HOME ROM...
        DEFW $0010                      ;0030 ...RST $10 print char in HOME ROM
        RET                             ;0032 done

;------------------------------------------------------------------
; $0033-$0037: Unused padding
;------------------------------------------------------------------
        DEFB $FF                        ;0033
        DEFB $FF                        ;0034
        DEFB $FF                        ;0035
        DEFB $FF                        ;0036
        DEFB $FF                        ;0037

;==================================================================
; RST $38 - Maskable Interrupt Handler
; Just returns - no interrupt processing in DOCK ROM.
;==================================================================
RST_38:
        RET                             ;0038

;******************************************************************
;******************************************************************
;
;  ERROR HANDLER ($0039-$0044)
;
;  Continuation of RST $08. Checks if IY is valid (non-zero),
;  then returns to caller. The error byte follows the RST $08
;  instruction in the calling code.
;
;******************************************************************
;******************************************************************

ERROR_HANDLER:
        PUSH HL                         ;0039 save HL
        PUSH AF                         ;003A save AF
        PUSH IY                         ;003B get IY into HL...
        POP HL                          ;003D ...via stack
        LD A,H                          ;003E test if IY is zero
        OR L                            ;003F (would indicate uninit state)
        INC HL                          ;0040 \ These bytes also encode
        INC BC                          ;0041 | the error number offset
        POP AF                          ;0042 restore AF
        POP HL                          ;0043 restore HL
        RET                             ;0044 return to caller

;******************************************************************
;******************************************************************
;
;  COMMAND INTERCEPT ($0045-$008E)
;
;  This is the main command dispatcher. Called when a BASIC line
;  is being executed. Checks FDD_FLAGS bits to determine what
;  action to take:
;    bit 2 = numeric expression evaluation pending
;    bit 4 = token mode (redirect to HOME ROM token handler)
;    bit 5 = string expression evaluation pending
;    bit 0 = pending return from HOME ROM call
;
;  If none of those, scans backward in the BASIC line for a
;  keyword token >= $A5 and looks it up in the COMMAND_TABLE.
;  Unrecognized commands fall through to HOME ROM via DEFAULT_RET.
;
;******************************************************************
;******************************************************************

CMD_INTERCEPT:
        POP AF                          ;0045 discard return address from stack
        LD HL,FDD_FLAGS                 ;0046 point to FDD system flags
        BIT 2,(HL)                      ;0049 numeric expression eval pending?
        JP NZ,$022A                     ;004B yes - jump to numeric eval return
        BIT 4,(HL)                      ;004E token mode active?
        JP NZ,TOKEN_RETURN              ;0050 yes - jump to token handler return
        BIT 5,(HL)                      ;0053 string expression eval pending?
        JP NZ,STRING_EVAL_DONE          ;0055 yes - jump to string eval return
        BIT 0,(HL)                      ;0058 pending return from HOME ROM?
        RES 0,(HL)                      ;005A clear the pending flag
        POP HL                          ;005C get return address
        RET NZ                          ;005D if was pending, return now

;------------------------------------------------------------------
; No flags set - scan current BASIC line for a keyword token
;------------------------------------------------------------------
        LD HL,(CH_ADD)                  ;005E get current BASIC character pointer
        LD (SAVED_CH_ADD),HL            ;0061 save it for later restoration

SCAN_FOR_TOKEN:
        DEC HL                          ;0064 scan backwards
        LD A,(HL)                       ;0065 get character
        CP $A5                          ;0066 is it a keyword token? (>= $A5)
        JR NC,TOKEN_FOUND               ;0068 yes - go process it
        CP $80                          ;006A end-of-line marker?
        JR Z,CMD_NOT_FOUND              ;006C yes - command not in our table
        JR SCAN_FOR_TOKEN               ;006E keep scanning backwards

;------------------------------------------------------------------
; Found a keyword token - look it up in command table
;------------------------------------------------------------------
TOKEN_FOUND:
        LD (CH_ADD),HL                  ;0070 set CH_ADD to token position
        LD DE,COMMAND_TABLE             ;0073 point to our command table
        LD A,(HL)                       ;0076 get the token byte
        LD B,A                          ;0077 save in B for comparison
        EX DE,HL                        ;0078 HL = table pointer
        LD A,(HL)                       ;0079 get first table entry token

TABLE_COMPARE:
        CP B                            ;007A does token match?
        JR Z,TOKEN_MATCH                ;007B yes - found our command

TABLE_SKIP:
        CP $FE                          ;007D is this the $FE terminator?
        INC HL                          ;007F advance pointer
        LD A,(HL)                       ;0080 get next byte
        JR NZ,TABLE_SKIP                ;0081 not terminator - keep skipping
        INC HL                          ;0083 skip past exec addr low
        INC HL                          ;0084 skip past exec addr high
        INC HL                          ;0085 skip to next entry's token
        LD A,(HL)                       ;0086 get it
        CP $FF                          ;0087 end of table marker?
        JR NZ,TABLE_COMPARE             ;0089 no - compare next entry

;------------------------------------------------------------------
; Command not found in our table - pass to HOME ROM
;------------------------------------------------------------------
CMD_NOT_FOUND:
        LD HL,(DEFAULT_RET)             ;008B get default return address
        JP (HL)                         ;008E jump to HOME ROM handler

;******************************************************************
;******************************************************************
;
;  PARAMETER PASSING / PARSE ENGINE ($008F-$00D9)
;
;  When a token is matched, this engine processes the parse
;  descriptors that follow the token in the command table.
;  Each descriptor byte indexes into the PARSE_FUNC_TABLE
;  to call the appropriate parsing subroutine.
;
;******************************************************************
;******************************************************************

;------------------------------------------------------------------
; Restore CH_ADD and bank-switch to continue
;------------------------------------------------------------------
RESTORE_CH_ADD:
        LD HL,BANK_RETURN_PAD+1         ;008F push $000B as return addr...
        PUSH HL                         ;0092 ...so we return to DOCK space
        LD HL,(SAVED_CH_ADD)            ;0093 restore original CH_ADD
        JP BANK_RETURN                  ;0096 switch to HOME ROM (EI+RET)

;------------------------------------------------------------------
; Token matched - begin parsing descriptors
;------------------------------------------------------------------
TOKEN_MATCH:
        INC DE                          ;0099 skip past matched token
        LD (CH_ADD),DE                  ;009A update CH_ADD past token
        LD A,(DE)                       ;009E get next byte
        CP ' '                          ;009F skip whitespace
        JR Z,TOKEN_MATCH                ;00A1 keep skipping spaces
        CP '*'                          ;00A3 is it the '*' separator?
        JR NZ,CMD_NOT_FOUND             ;00A5 no - not a valid command entry

;------------------------------------------------------------------
; Found '*' marker - advance to parse descriptors
;------------------------------------------------------------------
        INC HL                          ;00A7 advance past '*' in table
        PUSH HL                         ;00A8 save table position
        RST $10                         ;00A9 call HOME ROM...
        DEFW $0020                      ;00AA ...RST $20 get next char
        POP HL                          ;00AC restore table position

;------------------------------------------------------------------
; Parse descriptor loop - process each descriptor byte
;------------------------------------------------------------------
PARSE_LOOP:
        LD DE,PARSE_FUNC_TABLE          ;00AD point to parse function table
        LD A,(HL)                       ;00B0 get descriptor byte
        CP $FE                          ;00B1 is it $FE terminator?
        JR Z,PARSE_DONE                 ;00B3 yes - parsing complete

;------------------------------------------------------------------
; Index into parse function table and call handler
;------------------------------------------------------------------
        ADD A,E                         ;00B5 add descriptor to table base low
        LD E,A                          ;00B6 update low byte
        JR NC,NO_CARRY                  ;00B7 no overflow
        INC D                           ;00B9 handle carry to high byte
NO_CARRY:
        PUSH HL                         ;00BA save table position
        LD HL,PARSE_RETURN              ;00BB push return address for parse func
        PUSH HL                         ;00BE (will return to PARSE_RETURN)
        EX DE,HL                        ;00BF HL = function table entry

;------------------------------------------------------------------
; Read function address from table and call it
;------------------------------------------------------------------
CALL_PARSE_FUNC:
        LD E,(HL)                       ;00C0 low byte of function addr
        INC HL                          ;00C1
        LD D,(HL)                       ;00C2 high byte of function addr
        PUSH DE                         ;00C3 push function address (will RET to it)
        LD HL,(CH_ADD)                  ;00C4 get current parse position
        LD A,(HL)                       ;00C7 get current character
        RET                             ;00C8 "call" the parse function

;------------------------------------------------------------------
; Return from parse function - advance to next descriptor
;------------------------------------------------------------------
PARSE_RETURN:
        POP HL                          ;00C9 restore table position
        INC HL                          ;00CA advance past descriptor
        JR PARSE_LOOP                   ;00CB process next descriptor

;------------------------------------------------------------------
; Parse complete ($FE found) - extract and call exec address
;------------------------------------------------------------------
PARSE_DONE:
        CALL STACK_ADJUST               ;00CD adjust stack for parameters
        INC HL                          ;00D0 point to exec addr low
        LD E,(HL)                       ;00D1 get low byte
        INC HL                          ;00D2
        LD D,(HL)                       ;00D3 get high byte
        EX DE,HL                        ;00D4 HL = execution address
        LD DE,RETURN_INDIRECT           ;00D5 push return-through-indirect
        PUSH DE                         ;00D8 as return address
        JP (HL)                         ;00D9 jump to command handler

;******************************************************************
;******************************************************************
;
;  PARSE FUNCTION JUMP TABLE ($00DA-$00F9)
;
;  This is DATA, not code. Each 2-byte entry is the address
;  of a parsing subroutine. Indexed by descriptor bytes from
;  the command table entries.
;
;  Table entries (byte pairs = addresses):
;    [0] $00FD  - Parse with string eval
;    [1] $010E  - Parse string expression
;    [2] $0129  - Parse single char param
;    [3] $0158  - Parse expression with line number
;    [4] $0182  - Parse numeric + optional LINE
;    [5] $01B9  - Parse format flag
;    [6] $01C5  - Parse verify/open flag
;    [7] $01F7  - Parse secondary flag
;    [8] $0202  - Parse optional keyword
;    [9] $0219  - Check semicolon separator
;    [A] $09F0  - (reserved)
;    [B] $0952  - LOAD parse
;    [C] $097F  - LOAD CODE parse
;    [D] $0B67  - (reserved)
;    [E] $089E  - (reserved)
;    [F] $0807  - (reserved)
;
;******************************************************************
;******************************************************************

PARSE_FUNC_TABLE:
        DEFW $00FD                      ;00DA [0] Parse with string eval
        DEFW $010E                      ;00DC [1] Parse string expression
        DEFW $0129                      ;00DE [2] Parse single char param
        DEFW $0158                      ;00E0 [3] Parse expr with line number
        DEFW $0182                      ;00E2 [4] Parse numeric + LINE
        DEFW $01B9                      ;00E4 [5] Parse format flag
        DEFW $01C5                      ;00E6 [6] Parse verify/open flag
        DEFW $01D0                      ;00E8 [7] (continuation)
        DEFW $0202                      ;00EA [8] Parse optional keyword
        DEFW $0219                      ;00EC [9] Check semicolon
        DEFW $09F0                      ;00EE [A] (reserved)
        DEFW $01F7                      ;00F0 [B] Parse secondary flag
        DEFW $0952                      ;00F2 [C] LOAD parse main
        DEFW $0B7F                      ;00F4 [D] LOAD CODE/SCREEN$/DATA syntax
        DEFW $0867                      ;00F6 [E] CAT parse
        DEFW $089E                      ;00F8 [F] (reserved)

;==================================================================
; ERROR_EXIT ($00FA)
; Jump to general error handler
;==================================================================
ERROR_EXIT:
        JP SET_ERROR_AND_RET            ;00FA

;******************************************************************
;******************************************************************
;
;  COMMAND SYNTAX HANDLERS ($00FD-$0217)
;
;  Each handler parses the parameters for a specific command
;  during the syntax-checking phase. They validate syntax
;  and prepare workspace variables for the execution phase.
;
;******************************************************************
;******************************************************************

;==================================================================
; PARSE_STR_EVAL ($00FD)
; Evaluate a string expression. Check if in execution mode.
; On exec: call HOME ROM $3ECD to evaluate, store type in FILE_TYPE
;==================================================================
PARSE_STR_EVAL:
        CALL EVAL_NUMERIC               ;00FD evaluate expression
        JR Z,ERROR_EXIT                 ;0100 error if end-of-statement
        BIT 7,(IY+$01)                 ;0102 execution mode? (FLAGS bit 7)
        JP Z,$3ECD                      ;0106 syntax check - call HOME ROM evaluator
        LD (FILE_TYPE),A                ;010A store result as file type
        RET                             ;010D done

;==================================================================
; PARSE_STRING ($010E)
; Parse a string expression (filename). Checks for '$' or '"'
; delimiters.
;==================================================================
PARSE_STRING:
        CALL EVAL_NUMERIC               ;010E evaluate expression
        JR NZ,ERROR_EXIT                ;0111 must be end-of-statement
        LD HL,(CH_ADD)                  ;0113 get parse position
        LD A,(HL)                       ;0116 get current char
        CP '$'                          ;0117 dollar sign?
        JR Z,$+9                        ;0119 yes - skip ahead
        CP '"'                          ;011B double quote?
        JR Z,$+5                        ;011D yes - skip ahead
        DEC HL                          ;011F back up
        LD A,(DE)                       ;0120 \ These bytes encode RST $10
        CALL P,$5D22                    ;0121 | call HOME ROM to update CH_ADD
        LD E,H                          ;0124 /
        RST $10                         ;0125 call HOME ROM...
        DEFW $0020                      ;0126 ...get next char
        RET                             ;0128 done

;==================================================================
; PARSE_CHAR_PARAM ($0129)
; Parse a single character parameter from a lookup string.
; Used for drive letters (P/U/V/I) and channel modes (I/O/R/A).
; The lookup string address is on the stack (from command table).
;==================================================================
PARSE_CHAR_PARAM:
        CALL CHECK_EOL                  ;0129 check for end of statement
        JR Z,ERROR_EXIT                 ;012C error if at end
        CP '['                          ;012E uppercase boundary check
        JR C,NO_CASE_ADJ               ;0130 skip if already uppercase
        SUB $20                         ;0132 convert to uppercase
NO_CASE_ADJ:
        LD HL,$0000                     ;0134 get stack pointer into HL
        ADD HL,SP                       ;0137
        INC HL                          ;0138 skip past return address to
        INC HL                          ;0139 get the parameter passed on stack
        LD E,(HL)                       ;013A (address of valid char list)
        INC HL                          ;013B
        LD D,(HL)                       ;013C
        INC DE                          ;013D skip length byte
        LD B,A                          ;013E save char to match in B

CHAR_SEARCH:
        LD A,(DE)                       ;013F get char from list
        AND A                           ;0140 end of list? (zero terminator)
        JR Z,ERROR_EXIT                 ;0141 yes - char not found, error
        CP B                            ;0143 match?
        JR Z,CHAR_FOUND                 ;0144 yes
        INC DE                          ;0146 next char in list
        JR CHAR_SEARCH                  ;0147 keep looking

CHAR_FOUND:
        LD (VAR_NAME),A                 ;0149 store matched character

SKIP_PAST_LIST:
        INC DE                          ;014C advance to end of list
        LD A,(DE)                       ;014D get byte
        AND A                           ;014E zero terminator?
        JR NZ,SKIP_PAST_LIST            ;014F no - keep going
        LD (HL),D                       ;0151 update stack to skip past
        DEC HL                          ;0152 the lookup string
        LD (HL),E                       ;0153
        RST $10                         ;0154 call HOME ROM...
        DEFW $0020                      ;0155 ...get next char
        RET                             ;0157 done

;==================================================================
; PARSE_EXPR_LINE ($0158)
; Parse expression, then optional LINE number for SAVE.
;==================================================================
PARSE_EXPR_LINE:
        CALL CHECK_EOL                  ;0158 check end of statement
        JR Z,PARSE_NO_LINE              ;015B at end - no LINE specified
        CALL CHECK_SEMICOLON            ;015D expect semicolon separator
        CALL EVAL_NUMERIC               ;0160 evaluate expression
        JP Z,SET_ERROR_AND_RET          ;0163 error if at end
        BIT 7,(IY+$01)                 ;0166 execution mode?
        RET Z                           ;016A return if syntax check
        CALL EVAL_STR_TO_BC            ;016B evaluate string, result in BC
        LD (FILE_SIZE),BC               ;016E store as file size / start line
        LD A,(FDD_FLAGS)                ;0172 get FDD flags
        SET 3,A                         ;0175 set "drive specified" flag

STORE_FLAGS:
        LD (FDD_FLAGS),A                ;0177 update flags
        RET                             ;017A done

PARSE_NO_LINE:
        LD A,(FDD_FLAGS)                ;017B get FDD flags
        RES 3,A                         ;017E clear "drive specified" flag
        JR STORE_FLAGS                  ;0180 store and return

;==================================================================
; PARSE_NUM_LINE ($0182)
; Parse numeric expression with optional LINE clause.
; Used for SAVE with auto-start line.
;==================================================================
PARSE_NUM_LINE:
        CALL CHECK_SEMICOLON            ;0182 expect semicolon
        CALL EVAL_NUMERIC               ;0185 evaluate expression
        JP NZ,SET_ERROR_AND_RET         ;0188 error if not at end

PARSE_OPT_LINE:
        LD HL,(CH_ADD)                  ;018B get current position
        LD A,(HL)                       ;018E get current char
        CALL CHECK_EOL                  ;018F check end of statement
        JR Z,LINE_ZERO                  ;0192 at end - default line = 0
        CALL CHECK_SEMICOLON            ;0194 expect semicolon
        CP $AC                          ;0197 LINE token?
        JP NZ,SET_ERROR_AND_RET         ;0199 no - syntax error
        RST $10                         ;019C call HOME ROM...
        DEFW $0020                      ;019D ...get next char
        CALL EVAL_NUMERIC               ;019F evaluate line number
        JP Z,SET_ERROR_AND_RET          ;01A2 error if at end
        BIT 7,(IY+$01)                 ;01A5 execution mode?
        RET Z                           ;01A9 return if syntax check
        CALL EVAL_STR_TO_BC            ;01AA evaluate, result in BC
        LD (FILE_SIZE),BC               ;01AD store line number
        RET                             ;01B1 done

LINE_ZERO:
        LD HL,$0000                     ;01B2 default line = 0
        LD (FILE_SIZE),HL               ;01B5 store it
        RET                             ;01B8

;==================================================================
; PARSE_FORMAT_FLAG ($01B9)
; Check if format flag is present, store in FILE_TYPE.
;==================================================================
PARSE_FORMAT_FLAG:
        CALL CHECK_EOL                  ;01B9 check end of statement
        JP NZ,PARSE_STR_EVAL            ;01BC not at end - parse expression
        LD A,$80                        ;01BF set "format" flag
        LD (FILE_TYPE),A                ;01C1 store it
        RET                             ;01C4

;==================================================================
; PARSE_VERIFY_FLAG ($01C5)
; Parse optional verify/direction flag. Handles "N"/"D" chars
; for supersede confirmation.
;==================================================================
PARSE_VERIFY_FLAG:
        CALL CHECK_EOL                  ;01C5 check end of statement
        LD A,$80                        ;01C8 default = verify enabled
        LD (FILE_TYPE),A                ;01CA store default
        JP NZ,PARSE_STRING              ;01CD not at end - parse string

CHECK_YN_CHAR:
        LD A,(HL)                       ;01D0 get current char
        AND $DF                         ;01D1 convert to uppercase
        CP 'N'                          ;01D3 is it 'N' (no)?

CHECK_YN_JUMP:
        JR Z,SET_FILE_YES               ;01D5 yes - handle 'N' response
        CP $0D                          ;01D7 carriage return?
        JR Z,CLEAR_FILE_TYPE            ;01D9 yes - default (no verify)
        CP $1A                          ;01DB another terminator?
        JR Z,CLEAR_FILE_TYPE            ;01DD yes - default
        JP SET_ERROR_AND_RET            ;01DF error - invalid char

CLEAR_FILE_TYPE:
        XOR A                           ;01E2 clear file type
        LD (FILE_TYPE),A                ;01E3 store it
        RET                             ;01E6

SET_FILE_YES:
        LD A,$01                        ;01E7 set file type = 1 (confirmed)
        LD (FILE_TYPE),A                ;01E9 store it
        RST $10                         ;01EC call HOME ROM...
        DEFW $0020                      ;01ED ...get next char
        RET                             ;01EF

;------------------------------------------------------------------
; Check for 'D' character (data type check)
;------------------------------------------------------------------
CHECK_D_CHAR:
        LD A,(HL)                       ;01F0 get current char
        AND $DF                         ;01F1 convert to uppercase
        CP 'D'                          ;01F3 is it 'D'?
        JR CHECK_YN_JUMP                ;01F5 reuse Y/N logic

;==================================================================
; PARSE_SECONDARY ($01F7)
; Store FILE_TYPE as SECONDARY_FLG. If non-zero, check for 'D'.
;==================================================================
PARSE_SECONDARY:
        LD A,(FILE_TYPE)                ;01F7 get current file type
        LD (SECONDARY_FLG),A            ;01FA store as secondary flag
        AND A                           ;01FD is it zero?
        JR NZ,CHECK_D_CHAR             ;01FE no - check for 'D' char
        JR CLEAR_FILE_TYPE              ;0200 yes - clear and return

;==================================================================
; PARSE_OPTIONAL_KW ($0202)
; Parse optional keyword. If SCREEN$ token found, store it.
;==================================================================
PARSE_OPTIONAL_KW:
        XOR A                           ;0202 clear A
        LD (FILE_TYPE),A                ;0203 clear file type
        LD A,(HL)                       ;0206 get current char
        CALL CHECK_EOL                  ;0207 check end of statement
        RET Z                           ;020A return if at end
        CP $CC                          ;020B is it SCREEN$ token?
        JP NZ,SET_ERROR_AND_RET         ;020D no - error
        LD (FILE_TYPE),A                ;0210 store SCREEN$ token
        RST $10                         ;0213 call HOME ROM...
        DEFW $0022                      ;0214 ...skip past token
        LD C,$03                        ;0217 set count

;==================================================================
; CHECK_SEMICOLON ($0219)
; Expect a semicolon ';' separator in the BASIC line.
;==================================================================
CHECK_SEMICOLON:
        CP ';'                          ;0219 is it semicolon?
        JP NZ,SET_ERROR_AND_RET         ;021B no - syntax error
        RST $10                         ;021E call HOME ROM...
        DEFW $0020                      ;021F ...get next char
        RET                             ;0221

;==================================================================
; EVAL_NUMERIC ($0222)
; Evaluate a numeric expression. Sets flag bit 2 in FDD_FLAGS,
; then calls HOME ROM calculator via RST $10.
; Returns: Z flag indicates end-of-statement
;==================================================================
EVAL_NUMERIC:
        LD HL,FDD_FLAGS                 ;0222 point to FDD flags
        SET 2,(HL)                      ;0225 set numeric eval flag
        RST $10                         ;0227 call HOME ROM...
        DEFW $1E54                      ;0228 ...numeric expression evaluator
; -- Returns here after bank switch back --
        RES 2,(HL)                      ;022B clear numeric eval flag (actually at $022A)
        RES 0,(HL)                      ;022C clear pending return flag
        POP HL                          ;022E get return address from stack
        POP DE                          ;022F get previous caller
        LD HL,$022A                     ;0230 expected return point
        AND A                           ;0233 clear carry
        SBC HL,DE                       ;0234 did we return to expected addr?
        JP NZ,RETURN_TO_BASIC           ;0236 no - something went wrong
        BIT 6,(IY+$03)                 ;0239 check TVFLAG bit 6
        RET                             ;023D done

;==================================================================
; EVAL_STRING ($023E)
; Evaluate a string expression.
;==================================================================
EVAL_STRING:
        LD HL,FDD_FLAGS                 ;023E point to FDD flags
        SET 5,(HL)                      ;0241 set string eval flag
        RST $10                         ;0243 call HOME ROM...
        DEFW $1E1F                      ;0244 ...string expression evaluator

;==================================================================
; EVAL_STR_TO_BC ($0246)
; Evaluate string and return result in BC.
;==================================================================
EVAL_STR_TO_BC:
        LD HL,FDD_FLAGS                 ;0246 point to FDD flags
        SET 5,(HL)                      ;0249 set string eval flag
        RST $10                         ;024B call HOME ROM...
        DEFW $1F23                      ;024C ...string-to-number evaluator

;------------------------------------------------------------------
; String eval completion handler
;------------------------------------------------------------------
STRING_EVAL_DONE:
        RES 5,(HL)                      ;024E clear string eval flag
        RES 0,(HL)                      ;0250 clear pending return flag
        POP HL                          ;0252 get return info
        POP DE                          ;0253
        LD HL,$1EA0                     ;0254 expected return point
        AND A                           ;0257 clear carry
        SBC HL,DE                       ;0258 did we return correctly?
        RET NZ                          ;025A yes if NZ - continue
        JP RETURN_TO_BASIC              ;025B no - error, return to BASIC

;==================================================================
; CHECK_EOL ($025E)
; Check for end of BASIC statement (CR or ':').
; Returns: Z set if at end of statement
;==================================================================
CHECK_EOL:
        CP $0D                          ;025E carriage return?
        RET Z                           ;0260 yes - at end
        CP ':'                          ;0261 colon (statement separator)?
        RET                             ;0263 Z set if colon

;******************************************************************
;******************************************************************
;
;  COMMAND TABLE ($0264-$0304)
;
;  Format of each entry:
;    token_byte, parse_descriptors..., $FE, exec_addr_lo, exec_addr_hi
;
;  The table ends with $FF.
;
;  Token values are TS-2068 BASIC tokens (shifted +5 from Spectrum).
;  Parse descriptors index into PARSE_FUNC_TABLE.
;
;  Commands defined:
;    $CF = CAT        $D3 = FORMAT     $EF = SAVE
;    $CE = ERASE      $C9 = VERIFY     $D4 = MOVE
;    $E5 = OPEN       $E6 = CLOSE      $CC = LOAD
;    $AC = (LINE)     $EC = (PUVI drv)
;
;******************************************************************
;******************************************************************

COMMAND_TABLE:
; CAT: token $CF, descriptors: $0C, parse, $FE, exec $0715
        DEFB $CF                        ;0264 CAT token
        DEFB $0C,$FE,$0A,$15,$07       ;0265 descriptors + exec addr $0715

; SAVE: token $EF, descriptors, $FE, exec $061A (data area)
        DEFB $EF                        ;026A SAVE token
        DEFB $1A,$FE,$06,$08,$0C,$F8   ;026B

; VERIFY: $C9 token
        DEFB $18,$FE,$06,$C9,$09       ;0271

; FORMAT: $D3
        DEFB $D3,$00,$12,$02,$12,$04   ;0276
        DEFB "IOAR"                     ;027C channel mode chars
        DEFB $00                        ;0280 terminator

; Various command entries continue...
; (The raw bytes encode token + parse descriptors + exec addresses)
; Each entry terminated by $FE, followed by 2-byte exec address

        DEFB $06,$FE,$0A               ;0281
        DEFB $CE,$08,$D4,$0A,$FE,$0A   ;0284 ERASE, MOVE tokens
        DEFB $BE,$08,$F5,$04,$23       ;028A

        DEFB $00,$00,$08,$FE,$0C       ;028F
        DEFB $44,$07,$EE,$04,$23       ;0294
        DEFB $00,$00,$12,$1E,$FE       ;0299
        DEFB $00,$00,$00,$F0,$1C       ;029E

        DEFB $FE,$00,$71,$08,$E5       ;02A3 OPEN token area
        DEFB $06,$23,$00,$00           ;02A8
        DEFB $FE,$0C,$48,$08,$D5       ;02AC
        DEFB $02,$FE,$06,$76,$0C       ;02B1

        DEFB $EC,$02,$14,$FE,$0A       ;02B6 PUVI drive select
        DEFB $39,$08,$ED,$0C           ;02BB
        DEFB $16,$FE,$0A,$29,$08       ;02BF

        DEFB $FC,$FE,$0C,$43,$0A       ;02C4 CLOSE
        DEFB $D0,$02,$10,$16           ;02C9
        DEFB $FE,$0A,$6D,$0E,$D2       ;02CD
        DEFB $02,$0E,$FE,$0A           ;02D2
        DEFB $A6,$08,$F1,$02           ;02D6

        DEFB $04,$AC,$00,$02           ;02DA LINE token
        DEFB $FE,$08,$4E,$09,$D1       ;02DE
        DEFB $02,$06,$AC,$00,$02       ;02E3
        DEFB $FE,$0A,$16,$09,$E9       ;02E8
        DEFB $02,$FE,$06,$AF,$08       ;02ED
        DEFB $AB,$02,$04               ;02F2

; PUVI drive letter lookup string
        DEFB "PUVI"                     ;02F5
        DEFB $00                        ;02F9 terminator

        DEFB $FE,$04,$89,$0E           ;02FA
        DEFB $F3,$0C,$FE,$08           ;02FE
        DEFB $53,$08                    ;0302

; End of table
        DEFB $FF                        ;0304 table end marker

;******************************************************************
;******************************************************************
;
;  CALL_HOME - Bank Switch Trampoline ($0305-$034C)
;
;  Called via RST $10. The 2-byte address following the RST $10
;  instruction is the target routine in HOME ROM space.
;
;  Saves HL, DE, sets pending-return flag, pushes DOCK return
;  address ($000A), pushes HOME ROM target, then switches banks
;  via BANK_RETURN (EI; RET).
;
;******************************************************************
;******************************************************************

CALL_HOME:
        LD (SAVED_CH_ADD),HL            ;0305 save HL
        LD (SAVED_DE_TRAMP),DE          ;0308 save DE
        POP HL                          ;030C get return address (points to inline addr)
        LD E,(HL)                       ;030D get target addr low byte
        INC HL                          ;030E
        LD D,(HL)                       ;030F get target addr high byte
        INC HL                          ;0310 advance past inline data
        PUSH HL                         ;0311 save updated return address
        LD HL,FDD_FLAGS                 ;0312 point to FDD flags
        SET 0,(HL)                      ;0315 set "pending return" flag
        LD HL,BANK_RETURN_PAD           ;0317 DOCK return landing pad ($000A)
        PUSH HL                         ;031A push as return addr in DOCK space
        PUSH DE                         ;031B push HOME ROM target address
        LD HL,(SAVED_CH_ADD)            ;031C restore HL
        LD DE,($2341)                   ;031F restore DE (note: may use $2141)
        JP BANK_RETURN                  ;0323 switch to HOME ROM (EI; RET)

;==================================================================
; STACK_ADJUST ($0326)
; Adjust stack by removing N bytes, where N is read from the
; command table. Used to clean up parameters after parsing.
;==================================================================
STACK_ADJUST:
        INC HL                          ;0326 advance past $FE terminator
        LD (SAVED_CH_ADD),HL            ;0327 save position
        LD A,(HL)                       ;032A get byte count
        OR A                            ;032B zero?
        JR Z,STACK_ADJ_DONE            ;032C yes - nothing to remove

        LD B,A                          ;032E count in B
STACK_POP:
        POP HL                          ;032F get return address
STACK_POP_LOOP:
        INC SP                          ;0330 remove one byte from stack
        DJNZ STACK_POP_LOOP             ;0331 loop for B bytes
        PUSH HL                         ;0333 restore return address

STACK_ADJ_DONE:
        LD HL,(CH_ADD)                  ;0334 get current parse position
        LD A,(HL)                       ;0337 get current char
        CALL CHECK_EOL                  ;0338 check for end of statement
        JP NZ,SET_ERROR_AND_RET         ;033B error if not at end
        LD HL,(SAVED_CH_ADD)            ;033E restore table position
        BIT 7,(IY+$01)                 ;0341 execution mode?
        RET NZ                          ;0345 yes - return to execute
        LD HL,$1B4A                     ;0346 syntax check - push HOME ROM return
        EX (SP),HL                      ;0349 swap with current return addr
        JP BANK_RETURN                  ;034A switch to HOME ROM

;******************************************************************
;******************************************************************
;
;  FDD PROTOCOL: SEND_CMD, SEND_DATA, RECV_RESPONSE ($034D-$03C0)
;
;  These routines handle the communication protocol with the
;  FDD 3000 controller. They save/restore all registers and
;  send command frames with checksum verification.
;
;  Frame format: 3-byte header (type + length + extra),
;                N-byte payload, checksum
;
;  Frame types: $C0 = command from host
;               $D0 = data from host
;               $B0 = ACK/response from FDD
;
;******************************************************************
;******************************************************************

;==================================================================
; SEND_CMD ($034D)
; Save all registers, then send a command frame to the FDD.
; The command byte is at FDD_CMD ($2100), parameters follow.
;==================================================================
SEND_CMD:
        LD (SAVED_BC),BC                ;034D save BC
        LD (SAVED_DE),DE                ;0351 save DE
        LD (SAVED_HL),HL                ;0355 save HL
        PUSH AF                         ;0358 save AF via stack
        POP HL                          ;0359
        LD (SAVED_AF),HL                ;035A store AF
        LD (SAVED_IX),IX                ;035D save IX
        LD (SAVED_IY),IY                ;0361 save IY

;==================================================================
; SEND_CMD_FRAME ($0365)
; Construct and send a command frame ($C0 type) to the FDD.
; Payload is 13 bytes from $2100 (command + saved registers).
;==================================================================
SEND_CMD_FRAME:
        LD A,$C0                        ;0365 frame type = command from host
        LD (FRAME_TYPE),A               ;0367 store frame type
        LD A,$0D                        ;036A payload = 13 bytes
        LD (PAYLOAD_LEN),A              ;036C store payload length
        LD HL,FDD_CMD                   ;036F point to command data ($2100)
        CALL FDD_SEND_FRAME             ;0372 send the frame
        RET Z                           ;0375 return if successful (Z set)

;------------------------------------------------------------------
; Send failed - retry or handle error
; These bytes encode: RST $10 / DW $0938 = call HOME ROM error
; followed by: CALL P,$40C3 (bank switch back)
;------------------------------------------------------------------
        RST $10                         ;0376 call HOME ROM...
        DEFW $0938                      ;0377 ...error handler
        CALL P,$40C3                    ;0379 (encoded bank-switch sequence)

;==================================================================
; SEND_DATA ($037E)
; Send a data frame ($D0 type) with payload from IO_BUFFER ($2000).
; A = payload length on entry.
;==================================================================
SEND_DATA:
        LD (PAYLOAD_LEN),A              ;037E store payload length
        LD A,$D0                        ;0381 frame type = data from host
        LD (FRAME_TYPE),A               ;0383 store frame type
        LD HL,IO_BUFFER                 ;0386 point to data buffer
        CALL FDD_SEND_FRAME             ;0389 send the frame
        RET Z                           ;038C return if successful

;------------------------------------------------------------------
; Data send failed - retry with error reporting
;------------------------------------------------------------------
        RST $10                         ;038D call HOME ROM...
        DEFW $0938                      ;038E ...error handler
        CALL P,$40C3                    ;0390 (bank-switch sequence)

;------------------------------------------------------------------
; After send attempts, receive response from FDD
;------------------------------------------------------------------
        LD B,$CD                        ;0394 (encoded instruction bytes)
        SUB L                           ;0396
        INC B                           ;0397
        JR Z,CHECK_RESPONSE_TYPE        ;0398 got response

;------------------------------------------------------------------
; Another retry path
;------------------------------------------------------------------
        RST $10                         ;039A call HOME ROM...
        DEFW $0938                      ;039B ...error handler
        OR $C3                          ;039E
        LD A,$04                        ;03A0

;==================================================================
; CHECK_RESPONSE_TYPE ($03A2)
; Check if response was a command frame ($C0). If so, restore
; all saved registers and return with carry set.
;==================================================================
CHECK_RESPONSE_TYPE:
        LD A,(FRAME_TYPE)               ;03A2 get frame type
        CP $C0                          ;03A5 was it a command response?
        JR Z,RESTORE_REGS              ;03A7 yes - restore registers
        AND A                           ;03A9 clear carry (data response)
        RET                             ;03AA return

RESTORE_REGS:
        LD HL,(SAVED_AF)                ;03AB restore AF
        PUSH HL                         ;03AE
        POP AF                          ;03AF
        LD BC,(SAVED_BC)                ;03B0 restore BC
        LD DE,(SAVED_DE)                ;03B4 restore DE
        LD HL,(SAVED_HL)                ;03B8 restore HL
        LD IX,(SAVED_IX)                ;03BB restore IX
        SCF                             ;03BF set carry = success
        RET                             ;03C0 done

;******************************************************************
;******************************************************************
;
;  DISPLAY_BUF ($03C1-$03F6)
;
;  Print a buffer of text to the screen with scroll control.
;  Handles paging by waiting for 'S' to start and 'Q' to quit.
;  Counts lines and pauses for user keypress at screen bottom.
;
;******************************************************************
;******************************************************************

DISPLAY_BUF:
        PUSH HL                         ;03C1 save buffer pointer
        LD A,$02                        ;03C2 stream 2 = upper screen
        RST $10                         ;03C4 call HOME ROM...
        DEFW $1230                      ;03C5 ...open channel/stream

        LD A,$FF                        ;03C7 set scroll counter to max
        LD (SCR_CT),A                   ;03C9 (system var $5C8C)
        CALL READ_KEY                   ;03CC read a keypress
        CP 'S'                          ;03CF 'S' = start scrolling?
        JR NZ,SCROLL_RESUME             ;03D1 no - resume display

WAIT_FOR_QUIT:
        CALL READ_KEY                   ;03D3 read another key
        CP 'Q'                          ;03D6 'Q' = quit?
        JR NZ,WAIT_FOR_QUIT             ;03D8 no - keep waiting

SCROLL_RESUME:
        CALL PRINT_CR                   ;03DA print carriage return
        POP HL                          ;03DD restore buffer pointer
        PUSH HL                         ;03DE save it again
        LD A,H                          ;03DF get high byte of address
        RRA                             ;03E0 divide by 2 for line count
        LD B,$00                        ;03E1 init line counter
        JR C,PRINT_LOOP                 ;03E3 odd - start printing
        LD B,$21                        ;03E5 even - set 33 lines (full screen)

PRINT_LOOP:
        POP HL                          ;03E7 get buffer pointer
        INC B                           ;03E8 increment line counter
        LD A,B                          ;03E9 get count
        CP $21                          ;03EA reached 33 lines?
        RET Z                           ;03EC yes - done (screen full)
        LD A,(HL)                       ;03ED get character
        OR A                            ;03EE zero terminator?
        RET Z                           ;03EF yes - done
        INC HL                          ;03F0 advance pointer
        PUSH HL                         ;03F1 save pointer
        RST $10                         ;03F2 call HOME ROM...
        DEFW $0010                      ;03F3 ...print character
        JR PRINT_LOOP                   ;03F5 next character

;******************************************************************
;******************************************************************
;
;  SET_ERROR ($03F7-$0414)
;
;  Store an error message in the message buffer ($210D).
;  A = error code on entry.
;  Copies appropriate message text to MSG_BUFFER.
;
;******************************************************************
;******************************************************************

SET_ERROR:
        LD (FDD_CMD+2),A               ;03F7 store error code at $2102
        AND A                           ;03FA is it zero?
        RET Z                           ;03FB yes - no error
        CP $81                          ;03FC "Supersede" error?
        LD DE,STR_SUPERSEDE             ;03FE point to "Supersede" message
        JR Z,COPY_ERROR_MSG            ;0401 yes - copy it
        CP $4B                          ;0403 "Wrong data type" error?
        LD DE,STR_WRONG_TYPE            ;0405 point to "Wrong data type" msg
        RET NZ                          ;0408 other error - return without copy

COPY_ERROR_MSG:
        PUSH HL                         ;0409 save HL
        LD HL,MSG_BUFFER                ;040A destination = $210D
        EX DE,HL                        ;040D swap source and dest
        LD BC,$0020                     ;040E 32 bytes to copy
        LDIR                            ;0411 copy message text
        POP HL                          ;0413 restore HL
        RET                             ;0414

;******************************************************************
;******************************************************************
;
;  STRING DATA ($0415-$0437)
;
;******************************************************************
;******************************************************************

STR_SUPERSEDE:
        DEFM "Supersede (Y/N) ?"        ;0415 19 chars
        DEFB $00                        ;0426 terminator
        DEFB $00                        ;0427 padding

STR_WRONG_TYPE:
        DEFM "Wrong data type"          ;0428 15 chars
        DEFB $00                        ;0437 terminator

;******************************************************************
;******************************************************************
;
;  ERROR REPORTING / RETURN TO BASIC ($0438-$0453)
;
;******************************************************************
;******************************************************************

;==================================================================
; RETURN_TO_BASIC ($0438)
; Return control to BASIC with error indication.
; Calls HOME ROM error display routine.
;==================================================================
RETURN_TO_BASIC:
        EX DE,HL                        ;0438 swap registers
        RST $10                         ;0439 call HOME ROM...
        DEFW $007B                      ;043A ...error display routine
        LD A,(DE)                       ;043C
        LD (BC),A                       ;043D

;==================================================================
; SET_ERROR_AND_RET ($043E)
; Set error code $0B (nonsense in BASIC) and return to BASIC.
; Restores SP from ERR_SP and jumps to HOME ROM error handler.
;==================================================================
SET_ERROR_AND_RET:
        LD A,$0B                        ;043E error $0B = "Nonsense in BASIC"

ERROR_RETURN:
        LD SP,(ERR_SP)                  ;0440 restore stack pointer
        LD (IY+$02),A                  ;0444 store error code in ERR_NR+2
        LD HL,(CH_ADD)                  ;0447 get current parse position
        LD (X_PTR),HL                   ;044A store in X_PTR (error position)
        LD HL,$1354                     ;044D HOME ROM error handler address
        PUSH HL                         ;0450 push as return target
        JP BANK_RETURN                  ;0451 switch to HOME ROM

;******************************************************************
;******************************************************************
;
;  FDD I/O DRIVER ($0454-$057C)
;
;  Low-level nibble-wide handshaked parallel I/O protocol.
;  All communication with the FDD 3000 goes through port $EF.
;
;  Write protocol:
;    1. Send low nibble to port $EF
;    2. Wait for ACK (bit 6 = 1)
;    3. Send high nibble OR $82 to port $EF
;    4. Drop strobe, wait for completion
;
;  Read protocol:
;    1. Write $40 to port $EF (request read)
;    2. Wait for ready (bit 7 = 1)
;    3. Read low nibble
;    4. Write $C0 to port $EF (acknowledge)
;    5. Wait for completion
;    6. Read high nibble
;    7. Combine nibbles into byte
;
;  Framing: 3-byte header + N-byte payload + checksum
;
;******************************************************************
;******************************************************************

;==================================================================
; FDD_SEND_FRAME ($0454)
; Send a complete frame to the FDD controller.
; HL = pointer to payload data
; Uses FRAME_TYPE, PAYLOAD_LEN from workspace.
; Implements retry logic (10 attempts).
; Returns: Z = success, NZ = failure
;==================================================================
FDD_SEND_FRAME:
        PUSH DE                         ;0454 save registers
        PUSH BC                         ;0455
        PUSH HL                         ;0456
        LD A,$0A                        ;0457 retry counter = 10
        LD (RETRY_CTR),A                ;0459 store it

SEND_RETRY:
        LD HL,FRAME_TYPE                ;045C point to 3-byte header
        LD B,$03                        ;045F 3 header bytes to send
        LD C,$00                        ;0461 init checksum = 0
        CALL FDD_WRITE_BYTES            ;0463 send header bytes

        LD A,(PAYLOAD_LEN)              ;0466 get payload length
        LD B,A                          ;0469 byte count
        POP HL                          ;046A restore payload pointer
        PUSH HL                         ;046B save it again
        CALL FDD_WRITE_DATA             ;046C send payload bytes

        LD A,C                          ;046F get accumulated checksum
        NEG                             ;0470 negate (two's complement)
        CALL FDD_WRITE_BYTE             ;0472 send checksum byte

        LD HL,RESP_BYTE                 ;0475 point to response byte
        CALL FDD_READ_1BYTE             ;0478 read 1-byte response
        LD A,(RESP_BYTE)                ;047B get response
        CP $B0                          ;047E $B0 = ACK from FDD?
        JR NZ,SEND_CHECK_RETRY         ;0480 no - check retry

        XOR A                           ;0482 success - Z flag set
SEND_EXIT:
        POP HL                          ;0483 restore registers
        POP BC                          ;0484
        POP DE                          ;0485
        RET                             ;0486

SEND_CHECK_RETRY:
        LD A,(RETRY_CTR)                ;0487 get retry counter
        DEC A                           ;048A decrement
        LD (RETRY_CTR),A                ;048B store updated count
        JR NZ,SEND_RETRY                ;048E retries remaining - try again

SEND_FAIL:
        LD A,$03                        ;0490 error code 3 = comms failure
        AND A                           ;0492 set NZ flag
        JR SEND_EXIT                    ;0493 return with error

;==================================================================
; FDD_RECV_FRAME ($0495)
; Receive a complete frame from the FDD controller.
; Validates frame type and checksum.
; Returns: Z = success, NZ = failure
;==================================================================
FDD_RECV_FRAME:
        PUSH DE                         ;0495 save registers
        PUSH BC                         ;0496
        PUSH HL                         ;0497
        LD A,$0A                        ;0498 retry counter = 10
        LD (RETRY_CTR),A                ;049A store it

RECV_RETRY:
        LD HL,FRAME_TYPE                ;049D point to header buffer
        LD B,$03                        ;04A0 3 header bytes to receive
        LD C,$00                        ;04A2 init checksum = 0
        CALL FDD_READ_BYTES             ;04A4 read header

        LD A,(FRAME_TYPE)               ;04A7 get frame type
        CP $C0                          ;04AA command response?
        JR Z,RECV_CMD_FRAME             ;04AC yes
        CP $D0                          ;04AE data response?
        JR Z,RECV_DATA_FRAME            ;04B0 yes
        JR RECV_RETRY                   ;04B2 unknown - retry

RECV_CMD_FRAME:
        LD HL,FDD_CMD                   ;04B4 destination = $2100
        JR RECV_PAYLOAD                 ;04B7

RECV_DATA_FRAME:
        LD HL,IO_BUFFER                 ;04B9 destination = $2000

RECV_PAYLOAD:
        LD A,(PAYLOAD_LEN)              ;04BC get payload length
        LD B,A                          ;04BF byte count
        CALL FDD_READ_BYTES             ;04C0 read payload
        LD HL,RESP_BYTE                 ;04C3 point to checksum byte
        CALL FDD_READ_1BYTE             ;04C6 read checksum

        LD A,C                          ;04C9 get accumulated checksum
        AND A                           ;04CA should be zero if valid
        JR Z,RECV_OK                    ;04CB yes - frame valid

;------------------------------------------------------------------
; Checksum error - send NAK ($E0) and retry
;------------------------------------------------------------------
        LD A,(RETRY_CTR)                ;04CD get retry counter
        DEC A                           ;04D0 decrement
        LD (RETRY_CTR),A                ;04D1 store
        JR Z,RECV_TIMEOUT               ;04D4 no retries left

        LD A,$E0                        ;04D6 NAK byte
        CALL FDD_WRITE_BYTE             ;04D8 send NAK
        JR RECV_RETRY                   ;04DB retry receive

RECV_TIMEOUT:
        LD A,$04                        ;04DD error code 4 = timeout
        AND A                           ;04DF set NZ
        JR SEND_EXIT                    ;04E0 return with error

RECV_OK:
        LD A,$B0                        ;04E2 ACK byte
        CALL FDD_WRITE_BYTE             ;04E4 send ACK
        JR SEND_EXIT                    ;04E7 return success (previous XOR A)

;==================================================================
; FDD_WRITE_BYTE ($04E9)
; Write a single byte to port $EF using nibble protocol.
; A = byte to send
;==================================================================
FDD_WRITE_BYTE:
        LD B,$01                        ;04E9 1 byte to send
        JR FDD_WR_ENTRY                 ;04EB

;==================================================================
; FDD_WRITE_DATA ($04ED)
; Write B bytes from (HL) with running checksum in C.
;==================================================================
FDD_WRITE_DATA:
        LD A,(HL)                       ;04ED get byte from buffer

;==================================================================
; FDD_WR_ENTRY ($04EE)
; Core write routine. Sends one byte via nibble protocol.
; D = byte being sent, C = running checksum
;==================================================================
FDD_WR_ENTRY:
        LD D,A                          ;04EE save byte in D

;==================================================================
; FDD_WRITE_BYTES ($04EF)
; Write B bytes with checksum accumulation.
; Entry: D = current byte, HL = data pointer, C = checksum
;==================================================================
FDD_WRITE_BYTES:
        ADD A,C                         ;04EF accumulate checksum
        LD C,A                          ;04F0 update checksum
        PUSH BC                         ;04F1 save count and checksum

;------------------------------------------------------------------
; Send low nibble
;------------------------------------------------------------------
        LD A,D                          ;04F2 get byte to send
        AND $0F                         ;04F3 mask low nibble
        OUT (PORT_FDD),A                ;04F5 send to FDD port
        LD E,A                          ;04F7 save low nibble

;------------------------------------------------------------------
; Prepare high nibble
;------------------------------------------------------------------
        LD A,D                          ;04F8 get byte again
        AND $F0                         ;04F9 mask high nibble
        RRCA                            ;04FB rotate right 4 times
        RRCA                            ;04FC to move bits 7-4
        RRCA                            ;04FD to bits 3-0
        RRCA                            ;04FE
        LD D,A                          ;04FF save prepared high nibble

;------------------------------------------------------------------
; Wait for ACK on low nibble (bit 6 = 1)
;------------------------------------------------------------------
        LD BC,$00C0                     ;0500 B=0 (timeout), C=$C0 (mask)
WAIT_ACK_LO:
        IN A,(PORT_FDD)                 ;0503 read FDD status
        AND C                           ;0505 mask bits 7-6
        CP $40                          ;0506 bit 6 set? (ACK)
        JR Z,ACK_LO_OK                 ;0508 yes - proceed
        LD (DE),A                       ;050A (dummy - timing/side effect)
        RST $30                         ;050B (dummy - timing)
        JR WRITE_FAIL                   ;050C timeout - fail

ACK_LO_OK:
;------------------------------------------------------------------
; Send high nibble with strobe (OR $80)
;------------------------------------------------------------------
        LD A,E                          ;050E get low nibble back
        OR $80                          ;050F set bit 7 (strobe high)
        OUT (PORT_FDD),A                ;0511 send with strobe
        LD B,$00                        ;0513 timeout counter

WAIT_ACK_HI:
        IN A,(PORT_FDD)                 ;0515 read FDD status
        AND C                           ;0517 mask bits 7-6
        CP $C0                          ;0518 both bits set? (ready for high)
        JR Z,SEND_HI_NIBBLE            ;051A yes
        DJNZ WAIT_ACK_HI               ;051C loop until timeout
        JR WRITE_FAIL                   ;051E timeout - fail

SEND_HI_NIBBLE:
;------------------------------------------------------------------
; Send high nibble OR $82 (strobe + data valid)
;------------------------------------------------------------------
        LD A,D                          ;0520 get prepared high nibble
        OR $82                          ;0521 set strobe + valid bits
        OUT (PORT_FDD),A                ;0523 send high nibble

;------------------------------------------------------------------
; Drop strobe, wait for completion
;------------------------------------------------------------------
        LD A,D                          ;0525 high nibble without strobe
        OUT (PORT_FDD),A                ;0526 drop strobe
        LD B,$00                        ;0528 timeout counter

WAIT_DONE_WR:
        IN A,(PORT_FDD)                 ;052A read FDD status
        AND C                           ;052C mask bits 7-6
        JR Z,WRITE_BYTE_OK             ;052D both clear = done
        DJNZ WAIT_DONE_WR              ;052F loop until timeout

;------------------------------------------------------------------
; Write failure - reset port and return error
;------------------------------------------------------------------
WRITE_FAIL:
        LD A,$00                        ;0531 clear port
        OUT (PORT_FDD),A                ;0533 reset FDD port
        POP BC                          ;0535 restore checksum/count
        POP HL                          ;0536 abort: pop saved HL
        JP SEND_FAIL                    ;0537 return failure

;------------------------------------------------------------------
; Byte written successfully - advance to next
;------------------------------------------------------------------
WRITE_BYTE_OK:
        POP BC                          ;053A restore checksum/count
        INC HL                          ;053B advance data pointer
        DJNZ FDD_WRITE_DATA             ;053C loop for remaining bytes
        XOR A                           ;053E success - Z flag
        RET                             ;053F done

;==================================================================
; FDD_READ_1BYTE ($0540)
; Read a single byte from port $EF.
;==================================================================
FDD_READ_1BYTE:
        LD B,$01                        ;0540 1 byte to read

;==================================================================
; FDD_READ_BYTES ($0542)
; Read B bytes from FDD via nibble protocol into (HL).
; C = running checksum.
;==================================================================
FDD_READ_BYTES:
        PUSH BC                         ;0542 save count and checksum

;------------------------------------------------------------------
; Request read: write $40 to port
;------------------------------------------------------------------
        LD A,$40                        ;0543 read request
        OUT (PORT_FDD),A                ;0545 send to FDD
        LD BC,$00C2                     ;0547 B=0 (timeout), C=$C2 (mask)

;------------------------------------------------------------------
; Wait for ready (bit 7 = 1)
;------------------------------------------------------------------
WAIT_READY:
        IN A,(PORT_FDD)                 ;054A read FDD status
        LD E,A                          ;054C save full status (has low nibble)
        AND C                           ;054D mask bits
        CP $80                          ;054E bit 7 set? (data ready)
        JR Z,READ_LO_OK                ;0550 yes
        DJNZ WAIT_READY                 ;0552 loop until timeout
        JR WRITE_FAIL                   ;0554 timeout - fail

READ_LO_OK:
;------------------------------------------------------------------
; Acknowledge and request high nibble: write $C0
;------------------------------------------------------------------
        LD A,$C0                        ;0556 acknowledge
        OUT (PORT_FDD),A                ;0558 send ACK
        LD B,$00                        ;055A timeout counter

WAIT_HI_NIBBLE:
        IN A,(PORT_FDD)                 ;055C read FDD status
        LD D,A                          ;055E save (has high nibble)
        AND C                           ;055F mask bits
        JR Z,READ_HI_OK                ;0560 both clear = high nibble ready
        DJNZ WAIT_HI_NIBBLE            ;0562 loop
        JR WRITE_FAIL                   ;0564 timeout

READ_HI_OK:
;------------------------------------------------------------------
; Clear port and combine nibbles
;------------------------------------------------------------------
        OUT (PORT_FDD),A                ;0566 clear port (A=0 from AND)
        LD A,E                          ;0568 get low nibble data
        AND $0F                         ;0569 mask to low 4 bits
        LD E,A                          ;056B save low nibble
        LD A,D                          ;056C get high nibble data
        AND $0F                         ;056D mask to low 4 bits
        RLCA                            ;056F shift left 4 times
        RLCA                            ;0570 to put in bits 7-4
        RLCA                            ;0571
        RLCA                            ;0572
        OR E                            ;0573 combine with low nibble
        LD (HL),A                       ;0574 store complete byte
        POP BC                          ;0575 restore count/checksum
        ADD A,C                         ;0576 accumulate checksum
        LD C,A                          ;0577 update checksum
        INC HL                          ;0578 advance buffer pointer
        DJNZ FDD_READ_BYTES             ;0579 loop for remaining bytes
        XOR A                           ;057B success - Z flag
        RET                             ;057C done

;******************************************************************
;******************************************************************
;
;  COLD START ($057D-$05A4)
;
;  Hardware initialization on power-up or reset.
;  Sets border color, clears RAM workspace, configures I register,
;  sets default return addresses, then jumps to FDD probe.
;
;******************************************************************
;******************************************************************

COLD_START:
        LD A,$07                        ;057D border = white
        OUT (PORT_BORDER),A             ;057F set border color
        XOR A                           ;0581 A = 0
        OUT (PORT_DECR),A               ;0582 DECR = 0 (standard video mode)
        OUT (PORT_HSR),A                ;0584 HSR = 0 (all HOME ROM chunks)

;------------------------------------------------------------------
; Clear RAM workspace from $2000 to $FFFF
;------------------------------------------------------------------
        LD DE,$2001                     ;0586 destination = $2001
        LD HL,$2000                     ;0589 source = $2000
        LD (HL),A                       ;058C store 0 at $2000
        LD BC,$E002                     ;058D count = 57346 bytes (fills to $FFFF)
        LDIR                            ;0590 clear entire workspace

;------------------------------------------------------------------
; Set I register for interrupt vector table
;------------------------------------------------------------------
        LD A,$3F                        ;0592 I = $3F (vector table at $3F00)
        LD I,A                          ;0594 set interrupt register

;------------------------------------------------------------------
; Initialize workspace pointers
;------------------------------------------------------------------
        LD HL,$028F                     ;0596 default return = cmd table area
        LD (DEFAULT_RET),HL             ;0599 store as HOME ROM fallback

        LD HL,WARM_START                ;059C warm start address ($06D2)
        LD (INDIRECT_RET),HL            ;059F store as indirect return

        JP HW_INIT                      ;05A2 jump to FDD hardware probe

;******************************************************************
;******************************************************************
;
;  RST $08 RELAY AND EMBEDDED BASIC LINE ($05A5-$05BB)
;
;  $05A5: Entry point that pushes POST_BOOT address and triggers
;         RST $08 (error/command handler). Used during boot to
;         install the hook and then return to BASIC.
;
;  $05AC: Embedded BASIC line containing 'RUN "START"'
;         This gets copied into the BASIC program area during boot
;         to auto-run a startup program from disk.
;
;******************************************************************
;******************************************************************

RST8_RELAY:
        LD HL,POST_BOOT                 ;05A5 push POST_BOOT as return
        PUSH HL                         ;05A8
        JP RST_08                       ;05A9 trigger RST $08

;------------------------------------------------------------------
; Embedded BASIC line: RUN "START"
; The bytes encode a tokenized BASIC line
;------------------------------------------------------------------
BASIC_RUN_START:
        DEFB $EF                        ;05AC RST $28 (calculator - token RUN)
        DEFM "*\"START\""               ;05AD the filename
        DEFB $FF,$FF                    ;05B5 line terminator
        DEFB $FF                        ;05B7 padding

;------------------------------------------------------------------
; $05BC-$0602: Unused padding (all $FF)
;------------------------------------------------------------------
        DEFS 71,$FF                     ;05BC-$0602 padding

;******************************************************************
;******************************************************************
;
;  BANK_RETURN ($0603-$0604)
;
;  Bank switch completion point. EI re-enables interrupts
;  after the bank switch, then RET transfers control to the
;  address on top of the stack (either HOME ROM or DOCK ROM).
;
;******************************************************************
;******************************************************************

BANK_RETURN:
        EI                              ;0603 enable interrupts
BANK_RETURN_RET:
        RET                             ;0604 return (bank switch complete)

;******************************************************************
;******************************************************************
;
;  JUMP TABLE ($0605-$0627)
;
;  10 JP instructions providing stable entry points to key
;  routines. External code (e.g., boot code loaded into RAM)
;  can call these by address.
;
;******************************************************************
;******************************************************************

JUMP_TABLE:
        JP SEND_DATA                    ;0605 [0] Send data frame
        JP SEND_CMD                     ;0608 [1] Send command frame
        JP $0395                        ;060B [2] Receive response
        JP FDD_SEND_FRAME               ;060E [3] Send frame (low-level)
        JP FDD_RECV_FRAME               ;0611 [4] Receive frame
        JP $0F7F                        ;0614 [5] (boot helper)
        JP READ_MULTI                   ;0617 [6] Multi-sector read
        JP WRITE_BLOCK                  ;061A [7] Block write
        JP CALL_HOME                    ;061D [8] Bank-switch trampoline
        JP SAVE_LOAD_ENGINE             ;0620 [9] Save/load engine
        JP LOAD_DIR_ENTRY               ;0623 [A] Load directory entry
        JP FDD_CMD_LOOP                 ;0626 [B] FDD command loop

;******************************************************************
;******************************************************************
;
;  GET_VAR_INFO ($0629-$065F)
;
;  Get variable information for SAVE command.
;  Reads the variable name from VAR_NAME ($2136).
;  For array variables (bit 7 set), looks up in variables area.
;  Returns variable entry pointer and size in BC.
;
;******************************************************************
;******************************************************************

GET_VAR_INFO:
        LD A,(VAR_NAME)                 ;0629 get variable name
        BIT 7,A                         ;062C is it an array? (bit 7 set)
        JP NZ,$492A                     ;062E yes - jump to array handler

;------------------------------------------------------------------
; Simple variable - find in variables area
; These bytes encode HOME ROM calls via RST $10
;------------------------------------------------------------------
        LD HL,$CBFD                     ;0631 (encoded instruction sequence)
        LD BC,$C87E                     ;0634 (for HOME ROM variable lookup)
        PUSH HL                         ;0637
        INC HL                          ;0638 walk the variable entry
        LD C,(HL)                       ;0639 get length low byte
        INC HL                          ;063A
        LD B,(HL)                       ;063B get length high byte
        INC BC                          ;063C add 3 for header bytes
        INC BC                          ;063D
        INC BC                          ;063E
        POP HL                          ;063F restore variable pointer
        RST $10                         ;0640 call HOME ROM...
        DEFW $1750                      ;0641 ...variable lookup
        RET                             ;0643

;==================================================================
; SET_TOKEN_MODE ($0644)
; Set token mode flag (bit 4) in FDD_FLAGS, then call HOME
; ROM to get the next token.
;==================================================================
SET_TOKEN_MODE:
        LD HL,FDD_FLAGS                 ;0644 point to flags
        SET 4,(HL)                      ;0647 set token mode
        RST $10                         ;0649 call HOME ROM...
        DEFW $2C70                      ;064A ...token evaluation

;==================================================================
; TOKEN_RETURN ($064C)
; Return from token mode. Clears flags and verifies return address.
;==================================================================
TOKEN_RETURN:
        RES 4,(HL)                      ;064C clear token mode flag
        RES 0,(HL)                      ;064E clear pending return flag
        POP HL                          ;0650 get return info
        EX (SP),HL                      ;0651
        PUSH AF                         ;0652
        LD DE,TOKEN_RETURN              ;0653 expected return point
        EX DE,HL                        ;0656
        AND A                           ;0657
        SBC HL,DE                       ;0658 verify return address
        JP NZ,RETURN_TO_BASIC           ;065A mismatch - error
        POP AF                          ;065D restore AF
        POP HL                          ;065E restore HL
        RET                             ;065F done

;******************************************************************
;******************************************************************
;
;  BUFFER MANAGEMENT ($0660-$067D)
;
;  Prepare the $2000 I/O buffer for use.
;
;******************************************************************
;******************************************************************

;==================================================================
; PREP_BUFFER ($0660)
; Call HOME ROM to get string result, then prepare buffer.
;==================================================================
PREP_BUFFER:
        RST $10                         ;0660 call HOME ROM...
        DEFW $2FAF                      ;0661 ...get string result (DE=addr,BC=len)

;==================================================================
; PREP_BUFFER_2 ($0663)
; Prepare buffer at $2000 with string data.
;==================================================================
PREP_BUFFER_2:
        LD HL,IO_BUFFER                 ;0663 buffer at $2000

;==================================================================
; COPY_TO_BUF ($0666)
; Copy BC bytes from DE to HL, then zero-terminate.
; If BC=0 or source empty, just zero-terminates.
;==================================================================
COPY_TO_BUF:
        PUSH HL                         ;0666 save destination
        AND A                           ;0667 clear carry

CHECK_BUF_LEN:
        LD HL,$0040                     ;0668 max = 64 bytes
        SBC HL,BC                       ;066B check if BC > 64
        POP HL                          ;066D restore destination
        LD A,($7808)                    ;066E (flag/config byte)
        OR C                            ;0671 combine with low byte of length
        JR Z,ZERO_TERM                  ;0672 zero length - just terminate

        EX DE,HL                        ;0674 swap source/dest for LDIR
        LDIR                            ;0675 copy BC bytes
        EX DE,HL                        ;0677 restore pointers

ZERO_TERM:
        LD (HL),$00                     ;0678 zero-terminate buffer
        INC HL                          ;067A advance past terminator
        INC A                           ;067B
        LD B,A                          ;067C save count
        RET                             ;067D done

;******************************************************************
;******************************************************************
;
;  FDD COMMAND LOOP ($067E-$06D1)
;
;  Main loop for receiving and processing FDD responses.
;  Handles status codes:
;    $80 = OK (success)
;    $81 = Error (display error message)
;    $82 = Prompt (wait for user input)
;    $83 = List/data (display and continue)
;
;******************************************************************
;******************************************************************

FDD_CMD_LOOP:
        CALL $0395                      ;067E receive response from FDD
        JR NC,FDD_CMD_LOOP              ;0681 no response yet - keep polling

        LD A,(FDD_CMD)                  ;0683 get response status code
        CP $80                          ;0686 $80 = OK?
        RET Z                           ;0688 yes - return success

        CP $83                          ;0689 $83 = list/data?
        JR Z,HANDLE_LIST                ;068B yes - display listing

        CP $82                          ;068D $82 = prompt?
        JR Z,$+11                       ;068F yes - handle prompt

        CP $81                          ;0691 $81 = error?
        JR NZ,FDD_CMD_LOOP             ;0693 unknown - keep polling

;------------------------------------------------------------------
; Handle error ($81) - display error, check for Break
;------------------------------------------------------------------
        CALL DISPLAY_RESPONSE           ;0695 display error message
        LD A,(DE)                       ;0698 \ These bytes encode a
        JR NZ,CHECK_BUF_LEN            ;0699 | conditional jump sequence
        RST $00                         ;069B | for error handling
        LD B,$3E                        ;069C |
        CP A                            ;069E |
        IN A,(PORT_BORDER)              ;069F | check BREAK key
        BIT 0,A                         ;06A1 | bit 0 = BREAK
        JR NZ,$-6                       ;06A3 | loop if not pressed
        JR SEND_USER_RESPONSE           ;06A5 send response to FDD

;------------------------------------------------------------------
; Handle list ($83) - display buffer and continue
;------------------------------------------------------------------
HANDLE_LIST:
        CALL DISPLAY_RESPONSE           ;06A7 display the data

DISPLAY_LIST_LOOP:
        RST $10                         ;06AA call HOME ROM...
        DEFW $02B0                      ;06AB ...keyboard scan
        INC DE                          ;06AD advance pointer
        LD A,D                          ;06AE check if more data
        OR E                            ;06AF
        JR NZ,DISPLAY_LIST_LOOP         ;06B0 more to display

;------------------------------------------------------------------
; Wait for keypress then send user response
;------------------------------------------------------------------
WAIT_KEY_LOOP:
        CALL READ_KEY                   ;06B2 read keyboard
        JR Z,WAIT_KEY_LOOP             ;06B5 no key - keep waiting
        RST $10                         ;06B7 call HOME ROM...
        DEFW $0010                      ;06B8 ...print the key

SEND_USER_RESPONSE:
        LD A,$91                        ;06BA response code = user reply
        LD (FDD_CMD),A                  ;06BC store as command
        LD A,(LAST_K)                   ;06BF get last key pressed
        CALL SEND_CMD                   ;06C2 send to FDD with key in A
        JR FDD_CMD_LOOP                 ;06C5 continue polling

;==================================================================
; DISPLAY_RESPONSE ($06C7)
; Display the content of IO_BUFFER using DISPLAY_BUF.
;==================================================================
DISPLAY_RESPONSE:
        LD HL,IO_BUFFER                 ;06C7 point to data buffer
        CALL DISPLAY_BUF               ;06CA display it
        RET                             ;06CD

;==================================================================
; RETURN_INDIRECT ($06CE)
; Return through the indirect pointer at $213D.
; Used as the return address after command execution.
;==================================================================
RETURN_INDIRECT:
        LD HL,(INDIRECT_RET)            ;06CE get indirect return address
        JP (HL)                         ;06D1 jump to it

;******************************************************************
;******************************************************************
;
;  WARM START / BASIC PROMPT LOOP ($06D2-$0714)
;
;  Main BASIC prompt loop after FDD initialization.
;  Processes FDD command results, displays errors, and
;  returns control to BASIC's main loop.
;
;******************************************************************
;******************************************************************

WARM_START:
        CALL FDD_CMD_LOOP              ;06D2 process FDD responses

BASIC_PROMPT:
        LD A,$02                        ;06D5 stream 2 = upper screen
        RST $10                         ;06D7 call HOME ROM...
        DEFW $1230                      ;06D8 ...open channel

        BIT 7,(IY+$0C)                 ;06DA check if output needed
        JR Z,NO_CR_NEEDED              ;06DE no - skip CR

        CALL PRINT_CR                   ;06E0 print carriage return

NO_CR_NEEDED:
        LD A,(FDD_CMD+2)               ;06E3 get error code from response
        LD B,A                          ;06E6 save it
        LD A,(RAMTOP)                   ;06E7 get RAMTOP value
        CP $02                          ;06EA is it $02? (special state)

        LD A,B                          ;06EC restore error code
        JR NZ,STORE_RASP               ;06ED not special - store and continue
        OR A                            ;06EF error code zero?
        JR Z,RETURN_TO_BASIC_LOOP       ;06F0 yes - no error to show

;------------------------------------------------------------------
; Display error message
;------------------------------------------------------------------
        CALL PRINT_CR                   ;06F2 blank line
        CALL PRINT_CR                   ;06F5 another blank line
        LD HL,MSG_BUFFER                ;06F8 point to error message
        CALL DISPLAY_BUF               ;06FB display it
        CALL PRINT_CR                   ;06FE trailing CR
        CALL PRINT_CR                   ;0701
        JP SET_ERROR_AND_RET            ;0704 return to BASIC with error

STORE_RASP:
        LD (RASP_PIP),A                ;0707 store in RASP/PIP system var

RETURN_TO_BASIC_LOOP:
        LD (IY+$02),$FF                ;070A set ERR_NR to $FF (no error)
        LD HL,$1AB9                     ;070E HOME ROM main loop address
        PUSH HL                         ;0711 push as return target
        JP BANK_RETURN                  ;0712 switch to HOME ROM

;******************************************************************
;******************************************************************
;
;  COMMAND EXECUTION HELPERS ($0715-$079D)
;
;  Various helper routines for SAVE, FORMAT, and other commands.
;
;******************************************************************
;******************************************************************

;==================================================================
; CAT/ERASE/VERIFY PREP ($0715)
; Check FILE_TYPE, send appropriate FDD command.
;==================================================================
CAT_ERASE_PREP:
        LD A,(FILE_TYPE)                ;0715 get file type flag
        OR A                            ;0718 is it zero?
        LD A,FDD_ERROR_Q                ;0719 default = query error ($0B)
        JR Z,SET_CMD_AND_SEND           ;071B zero - send error query

        CALL PREP_BUFFER                ;071D prepare buffer with filename
        RST $08                         ;0720 \ error handler (if needed)
        LD A,(HL)                       ;0721 | inline error data
        INC BC                          ;0722 /
        LD A,FDD_FILE_INFO              ;0723 file info command ($0C)

SET_CMD_AND_SEND:
        LD (FDD_CMD),A                  ;0725 store command code
        JP SEND_CMD                     ;0728 send to FDD

;==================================================================
; FORMAT_HANDLER ($072B)
; Send FORMAT command to FDD, wait for response.
;==================================================================
FORMAT_HANDLER:
        LD A,FDD_FORMAT                 ;072B format command ($13)
        LD (FDD_CMD),A                  ;072D store command
        LD A,(FILE_TYPE)                ;0730 get format type
        LD (DRIVE_NUM),A                ;0733 store as drive number
        CALL SEND_CMD                   ;0736 send format command

FORMAT_WAIT:
        CALL $0395                      ;0739 receive response
        JR NC,FORMAT_WAIT               ;073C not ready - wait
        RET                             ;073E done

;==================================================================
; REPLACE_RETURN ($073F)
; Replace the return address on stack with RETURN_INDIRECT.
; Used to redirect execution flow.
;==================================================================
REPLACE_RETURN:
        LD HL,RETURN_INDIRECT           ;073F point to indirect return
        EX (SP),HL                      ;0742 swap with stack top
        RET                             ;0743 return to original target

;------------------------------------------------------------------
; FORMAT execution - call handler, check response
;------------------------------------------------------------------
FORMAT_EXEC:
        CALL FORMAT_HANDLER             ;0744 send format command
        JR NZ,REPLACE_RETURN            ;0747 error - replace return

        LD A,(IO_BUFFER+4)             ;0749 check format result
        OR A                            ;074C zero = already formatted?
        JR Z,FORMAT_NO_SUPER           ;074D yes - skip supersede check

;------------------------------------------------------------------
; Disk has data - check if user wants to supersede
;------------------------------------------------------------------
        LD HL,(FILE_SIZE)               ;074F get file size / line num
        LD A,H                          ;0752 check if non-zero
        OR L                            ;0753
        JR NZ,REPLACE_RETURN            ;0754 non-zero - abort

        CALL COPY_STRING                ;0756 copy filename to buffer
        JR NC,REPLACE_RETURN            ;0759 failed - abort

        LD (FILE_SIZE),BC               ;075B store string length
        LD A,C                          ;075F

FORMAT_CONTINUE:
        CALL SEND_DATA                  ;0760 send data to FDD
        LD C,$00                        ;0763 clear C
        LD A,(FILE_TYPE)                ;0765 get file type
        LD B,A                          ;0768 in B
        LD DE,($234B)                   ;0769 get additional params
        LD A,$0F                        ;076D transfer command
        JR SET_CMD_AND_SEND             ;076F send it

FORMAT_NO_SUPER:
        LD A,(IO_BUFFER+$0C)           ;0771 get disk info
        PUSH AF                         ;0774 save it
        CALL COPY_STRING                ;0775 copy string to buffer
        POP AF                          ;0778 restore info
        JR FORMAT_CONTINUE              ;0779 continue

;==================================================================
; COPY_STRING ($077B)
; Copy string parameter to $2000 buffer.
; Fills buffer with spaces first, then copies string data.
; Returns: carry set if string was non-empty
;==================================================================
COPY_STRING:
        LD HL,IO_BUFFER                 ;077B destination = $2000
        LD B,$00                        ;077E counter = 256

FILL_SPACES:
        LD (HL),' '                     ;0780 fill with spaces
        INC HL                          ;0782
        DJNZ FILL_SPACES                ;0783 loop 256 times

        RST $10                         ;0785 call HOME ROM...
        DEFW $2FAF                      ;0786 ...get string (DE=addr, BC=len)
        LD A,B                          ;0788 check if empty
        OR C                            ;0789
        JR NZ,STRING_NOT_EMPTY          ;078A not empty
        RET                             ;078C return (carry clear = empty)

STRING_NOT_EMPTY:
        LD A,B                          ;078D check if > 255 bytes
        OR A                            ;078E
        JR Z,STRING_LEN_OK             ;078F no - length fits in C
        LD BC,$0100                     ;0791 cap at 256 bytes

STRING_LEN_OK:
        PUSH BC                         ;0794 save length
        LD HL,IO_BUFFER                 ;0795 destination
        EX DE,HL                        ;0798 DE=dest, HL=source
        LDIR                            ;0799 copy string data
        POP BC                          ;079B restore length
        SCF                             ;079C set carry = success
        RET                             ;079D done

;******************************************************************
;******************************************************************
;
;  SAVE HANDLER ($079E-$080B)
;
;  Parse variable for SAVE, prepare header, and send to FDD.
;  Handles both simple and array variables.
;
;******************************************************************
;******************************************************************

SAVE_HANDLER:
        CALL SET_TOKEN_MODE             ;079E get variable token
        LD A,(HL)                       ;07A1 get first char of var name
        JR NC,SAVE_NOT_ARRAY            ;07A2 not array - skip

;------------------------------------------------------------------
; Possible array variable name - convert to uppercase, set bit 7
;------------------------------------------------------------------
        CP 'a'                          ;07A4 lowercase?
        JR C,SAVE_NOT_LOWER            ;07A6 no
        SUB $20                         ;07A8 convert to uppercase
SAVE_NOT_LOWER:
        OR $80                          ;07AA set array flag (bit 7)
        LD B,A                          ;07AC save name
        INC HL                          ;07AD check next char
        LD A,(HL)                       ;07AE
        CP '$'                          ;07AF is it a string array? (name$)
        JP NZ,SET_ERROR_AND_RET         ;07B1 no '$' after name - error
        DEC HL                          ;07B4 back to start
        LD A,B                          ;07B5 restore name with flag

SAVE_NOT_ARRAY:
        LD (VAR_NAME),A                 ;07B6 store variable name
        LD (VAR_ENTRY),HL               ;07B9 store pointer to variable

        BIT 7,(HL)                      ;07BC is it an array?
        JR Z,SAVE_SIMPLE_VAR           ;07BE no - simple variable

;------------------------------------------------------------------
; Array variable - get length from header
;------------------------------------------------------------------
        INC HL                          ;07C0 skip name byte
        INC HL                          ;07C1 skip to length
        INC HL                          ;07C2
        LD A,(HL)                       ;07C3 get dimension count
        DEC A                           ;07C4 should be 1
        JP NZ,SET_ERROR_AND_RET         ;07C5 multi-dim arrays not supported

SAVE_SIMPLE_VAR:
        LD A,C                          ;07C8 get variable type flags
        AND $60                         ;07C9 mask type bits
        CP $40                          ;07CB is it numeric type?
        JP NZ,SET_ERROR_AND_RET         ;07CD no - wrong type, error

;------------------------------------------------------------------
; Parse optional LINE number, prepare save buffer
;------------------------------------------------------------------
        CALL PARSE_OPT_LINE             ;07D0 parse optional LINE
        LD B,$10                        ;07D3 remove 16 bytes from stack
        CALL STACK_POP                  ;07D5

        LD HL,BASIC_PROMPT              ;07D8 push prompt as return addr
        PUSH HL                         ;07DB

        CALL FORMAT_HANDLER             ;07DC send format/prepare command
        RET NZ                          ;07DF error - return

;------------------------------------------------------------------
; Check if disk already has file (supersede check)
;------------------------------------------------------------------
        LD A,(IO_BUFFER+4)             ;07E0 response flag
        OR A                            ;07E3 zero?
        LD (SAVED_HL+$1F),HL           ;07E4 \ These bytes encode
        LD E,E                          ;07E7 | register save operations
        LD C,E                          ;07E8 | and HOME ROM calls
        LD HL,$000E                     ;07E9 /

SAVE_READ_DIR:
        CALL READ_SECTOR               ;07EC read directory sector
        PUSH BC                         ;07EF save BC
        CALL GET_VAR_INFO              ;07F0 get variable info
        POP BC                          ;07F3 restore BC
        CALL MAKE_ROOM                  ;07F4 make room in workspace

;------------------------------------------------------------------
; Build file header in buffer
;------------------------------------------------------------------
        LD A,(VAR_NAME)                 ;07F7 get variable name
        AND $7F                         ;07FA clear array flag
        LD (HL),A                       ;07FC store name in header
        INC HL                          ;07FD
        LD (HL),C                       ;07FE store length low
        INC HL                          ;07FF
        LD (HL),B                       ;0800 store length high
        INC HL                          ;0801
        LD DE,$2300                     ;0802 source address for data
        EX DE,HL                        ;0805
        LD A,B                          ;0806 check if any data
        OR C                            ;0807
        RET Z                           ;0808 no data - done
        LDIR                            ;0809 copy variable data
        RET                             ;080B done

;------------------------------------------------------------------
; SAVE variant entry - alternate entry point
;------------------------------------------------------------------
SAVE_VARIANT:
        LD DE,$0000                     ;080C no offset
        LD A,(SAVE_VAR_INFO)            ;080F get saved var info
        DEC A                           ;0812
        LD C,A                          ;0813
        JR SAVE_READ_DIR                ;0814 continue with save

;==================================================================
; MAKE_ROOM ($0816)
; Expand BASIC workspace by BC+3 bytes.
; Calls HOME ROM BC_SPACES via RST $10.
;==================================================================
MAKE_ROOM:
        PUSH BC                         ;0816 save length
        LD A,C                          ;0817 add 3 to BC
        ADD A,$03                       ;0818 (for header bytes)
        LD C,A                          ;081A
        JR NC,NO_BC_CARRY              ;081B
        INC B                           ;081D carry into B

NO_BC_CARRY:
        LD HL,(E_LINE)                  ;081E get end-of-edit-line
        DEC HL                          ;0821 point to last byte
        PUSH HL                         ;0822 save position
        RST $10                         ;0823 call HOME ROM...
        DEFW $12BB                      ;0824 ...BC_SPACES (make room)
        POP HL                          ;0826 restore position
        POP BC                          ;0827 restore original length
        RET                             ;0828

;******************************************************************
;******************************************************************
;
;  ERASE / VERIFY / FORMAT HANDLERS ($0829-$0866)
;
;******************************************************************
;******************************************************************

;==================================================================
; ERASE_HANDLER ($0829)
; Erase a file from disk. Sends ERASE command ($0A).
;==================================================================
ERASE_HANDLER:
        LD A,FDD_ERASE                  ;0829 erase command ($0A)
        CALL SET_CMD_AND_SEND           ;082B send it

        LD A,(SECONDARY_FLG)            ;082E get secondary flag
        OR A                            ;0831 is verify requested?
        RET Z                           ;0832 no - done

;------------------------------------------------------------------
; Verify after erase
;------------------------------------------------------------------
        CALL FDD_CHECK_OK               ;0833 check FDD response
        JP NZ,BASIC_PROMPT              ;0836 error - return to prompt
        CALL PREP_BUFFER                ;0839 prepare buffer
        CALL SEND_DATA                  ;083C send data
        LD A,FDD_INIT                   ;083F init command ($07)
        JR SEND_CMD_CODE                ;0841 send it

;==================================================================
; VERIFY_HANDLER ($0843)
; Verify a file on disk.
;==================================================================
VERIFY_HANDLER:
        LD A,FDD_VERIFY                 ;0843 verify command ($09)
        JP SET_CMD_AND_SEND             ;0845 send it

;==================================================================
; OPEN_PREP ($0848)
; Prepare and send OPEN command.
;==================================================================
OPEN_PREP:
        LD A,$16                        ;0848 open with address command

SEND_CMD_CODE:
        LD (FDD_CMD),A                  ;084A store command code
        LD A,(FILE_TYPE)                ;084D get file type
        JP SEND_CMD                     ;0850 send with file type in A

;==================================================================
; FORMAT_CONFIRM ($0853)
; Format with confirmation. If FILE_TYPE is set, prepare buffer
; and send extended format command.
;==================================================================
FORMAT_CONFIRM:
        LD A,(FILE_TYPE)                ;0853 get file type
        AND A                           ;0856 zero?
        LD A,$1F                        ;0857 extended format command
        JP Z,SET_CMD_AND_SEND           ;0859 zero - send simple format

        CALL PREP_BUFFER                ;085C prepare filename buffer
        CALL SEND_DATA                  ;085F send data
        LD A,$20                        ;0862 format with name
        JP SET_CMD_AND_SEND             ;0864 send it

;******************************************************************
;******************************************************************
;
;  CAT HANDLER ($0867-$08A3)
;
;  Display disk directory listing.
;  Handles CAT, CAT #n (with stream), and CAT with filename.
;
;******************************************************************
;******************************************************************

CAT_HANDLER:
        CP '#'                          ;0867 CAT #n syntax?
        JR Z,CAT_WITH_STREAM           ;0869 yes

        CALL CHECK_EOL                  ;086B check end of statement
        JP NZ,SET_ERROR_AND_RET         ;086E not at end - syntax error

        LD A,FDD_CAT                    ;0871 CAT command ($03)

CAT_SEND:
        LD (FDD_CMD),A                  ;0873 store command
        LD B,$0E                        ;0876 remove 14 bytes from stack
        CALL STACK_POP                  ;0878

        LD HL,RETURN_INDIRECT           ;087B push indirect return
        PUSH HL                         ;087E
        JP SEND_CMD_FRAME               ;087F send command frame

CAT_WITH_STREAM:
        RST $10                         ;0882 call HOME ROM...
        DEFW $0020                      ;0883 ...get next char

        CALL CHECK_EOL                  ;0885 check end of statement
        JR NZ,CAT_WITH_EXPR            ;0888 more to parse

        LD A,FDD_CAT_NOSTRM            ;088A CAT without stream ($0E)
        JR CAT_SEND                     ;088C send it

CAT_WITH_EXPR:
        CALL EVAL_NUMERIC               ;088E evaluate stream number
        JP Z,ERROR_RETURN               ;0891 error
        BIT 7,(IY+$01)                 ;0894 execution mode?
        JR Z,CAT_SEND                  ;0898 syntax check - skip

        CALL EVAL_STRING                ;089A evaluate string expression
        LD (SAVED_BC+1),A              ;089D store stream number
        LD A,FDD_CAT_STRM              ;08A0 CAT with stream ($0D)
        JR CAT_SEND                     ;08A2 send it

;******************************************************************
;******************************************************************
;
;  MOVE HANDLER ($08A4-$08BD)
;
;  Move/rename a file on disk.
;
;******************************************************************
;******************************************************************

MOVE_HANDLER:
        CALL PREP_BUFFER                ;08A4 prepare source filename
        CALL SEND_DATA                  ;08A7 send it
        LD A,$04                        ;08AA move command
        JP SEND_CMD_CODE                ;08AC send command

;==================================================================
; SAVE_FILE ($08AF)
; Main SAVE execution - prepare buffer and send SAVE command ($02).
;==================================================================
SAVE_FILE:
        CALL PREP_BUFFER                ;08AF prepare filename buffer
        CALL SEND_DATA                  ;08B2 send filename
        LD A,FDD_SAVE                   ;08B5 SAVE command ($02)
        LD (FDD_CMD),A                  ;08B7 store command
        XOR A                           ;08BA clear A (no params)
        JP SEND_CMD                     ;08BB send to FDD

;******************************************************************
;******************************************************************
;
;  OPEN HANDLER ($08BE-$0915)
;
;  Parse OPEN #n channel mode (I/O/R/A).
;  I = Input, O = Output, R = Read (bidirectional), A = Append
;
;******************************************************************
;******************************************************************

OPEN_HANDLER:
        LD A,(FILE_TYPE)                ;08BE get file type
        CP $82                          ;08C1 extended open?
        JR NC,OPEN_EXTENDED            ;08C3 yes

        LD A,FDD_FLUSH                  ;08C5 flush command ($01)
        JP SEND_CMD_CODE                ;08C7 send it

OPEN_EXTENDED:
        LD A,$1D                        ;08CA extended open code
        LD A,(DE)                       ;08CC (get channel mode byte)
        LD SP,HL                        ;08CD (restore stack - encoded sequence)

;------------------------------------------------------------------
; Parse channel direction letter
;------------------------------------------------------------------
        LD A,(VAR_NAME)                 ;08CE get the mode character
        LD D,$00                        ;08D1 init direction flags

        CP 'I'                          ;08D3 Input?
        JR NZ,NOT_INPUT                 ;08D5
        SET 0,D                         ;08D7 set input flag
        JR OPEN_SET_MODE                ;08D9

NOT_INPUT:
        CP 'O'                          ;08DB Output?
        JR NZ,NOT_OUTPUT                ;08DD
        SET 1,D                         ;08DF set output flag
        JR OPEN_SET_MODE                ;08E1

NOT_OUTPUT:
        CP 'R'                          ;08E3 Read (bidirectional)?
        JR NZ,NOT_READ                  ;08E5
        SET 0,D                         ;08E7 set input flag
        SET 1,D                         ;08E9 set output flag
        JR OPEN_SET_MODE                ;08EB

NOT_READ:
        CP 'A'                          ;08ED Append?
        JP NZ,SET_ERROR_AND_RET         ;08EF no match - error

OPEN_SET_MODE:
        LD A,D                          ;08F2 get direction flags
        LD (VAR_NAME),A                 ;08F3 store mode flags

;------------------------------------------------------------------
; Prepare buffer and send OPEN command
;------------------------------------------------------------------
        RST $10                         ;08F6 call HOME ROM...
        DEFW $2FAF                      ;08F7 ...get string result
        CALL PREP_BUFFER_2              ;08F9 prepare buffer
        CALL SEND_DATA                  ;08FC send filename/data

        LD E,$01                        ;08FF default drive flag
        LD A,(FDD_FLAGS)                ;0901 get FDD flags
        BIT 3,A                         ;0904 drive specified?
        JR Z,OPEN_SEND                 ;0906 no - use default

        DEC E                           ;0908 clear drive flag
        LD IX,(FILE_SIZE)               ;0909 get drive params

OPEN_SEND:
        LD A,(VAR_NAME)                 ;090D get mode flags
        LD D,A                          ;0910 in D
        LD A,$00                        ;0911 clear A
        JP SEND_CMD_CODE                ;0913 send OPEN command

;******************************************************************
;******************************************************************
;
;  CLOSE HANDLER ($0916-$0951)
;
;  Close a file/stream. Restores HOME ROM stream table entries
;  to their default values, then sends CLOSE command to FDD.
;
;******************************************************************
;******************************************************************

CLOSE_HANDLER:
        LD HL,$1720                     ;0916 default stream 3 address
        LD ($5C82),HL                   ;0919 restore STRMS entry 3
        LD HL,$50E0                     ;091C default stream 4 address
        LD ($5C86),HL                   ;091F restore STRMS entry 4
        LD HL,$1721                     ;0922 default stream 5 address
        LD ($5C8A),HL                   ;0925 restore STRMS entry 5

        LD A,$06                        ;0928 close command ($06)

CLOSE_SEND:
        LD (FDD_CMD),A                  ;092A store command
        RST $10                         ;092D call HOME ROM...
        DEFW $2FAF                      ;092E ...get string result

;------------------------------------------------------------------
; Build close/open parameter block
;------------------------------------------------------------------
        LD HL,$2080                     ;0930 secondary buffer
        PUSH BC                         ;0933 save length
        PUSH HL                         ;0934 save buffer addr
        CALL COPY_TO_BUF               ;0935 copy string to buffer
        CALL PREP_BUFFER                ;0938 prepare main buffer
        EX DE,HL                        ;093B
        POP HL                          ;093C restore secondary buffer
        POP BC                          ;093D restore length
        ADD A,C                         ;093E calculate total size
        INC A                           ;093F
        LDIR                            ;0940 copy secondary data
        EX DE,HL                        ;0942
        LD (HL),$02                     ;0943 terminator
        CALL SEND_DATA                  ;0945 send to FDD
        LD A,(FDD_CMD+2)               ;0948 get response
        JP SEND_CMD                     ;094B send final command

;------------------------------------------------------------------
; Alternate CLOSE entry for stream 5
;------------------------------------------------------------------
CLOSE_STREAM5:
        LD A,$05                        ;094E close stream 5
        JR CLOSE_SEND                   ;0950

;******************************************************************
;******************************************************************
;
;  LOAD PARSE ($0952-$09C6)
;
;  Syntax parsing phase for the LOAD command.
;  Determines the sub-type:
;    0 = LOAD "name" (program)
;    2 = LOAD "name" CODE addr
;    3 = LOAD "name" CODE addr,len
;    4 = LOAD "name" SCREEN$
;    5 = LOAD "name" DATA a$()
;
;******************************************************************
;******************************************************************

LOAD_PARSE:
        CALL EVAL_NUMERIC               ;0952 evaluate filename expression
        JR NZ,LOAD_PARSE_ERROR         ;0955 error

;------------------------------------------------------------------
; Check what follows the filename
;------------------------------------------------------------------
        LD HL,(CH_ADD)                  ;0957 get parse position
        LD A,(HL)                       ;095A get current char
        LD (LOAD_SUBTYPE),A             ;095B save as initial sub-type

        CP $CA                          ;095E CODE token? ($CA on TS-2068)
        JR Z,LOAD_CODE_PARSE           ;0960 yes

        CP $AF                          ;0962 SCREEN$ token? ($AF on TS-2068)
        JR Z,LOAD_SCREEN_PARSE         ;0964 yes

        CP $AA                          ;0966 LINE token? ($AA on TS-2068)
        JR Z,LOAD_LINE_PARSE            ;0968 yes

        CP $E4                          ;096A DATA token? ($E4 on TS-2068)
        JR Z,$+54                       ;096C yes - handle DATA
        JR LOAD_PROGRAM                 ;096E plain LOAD (program)

LOAD_PARSE_ERROR:
        JP SET_ERROR_AND_RET            ;0970

;==================================================================
; LOAD CODE parse
;==================================================================
LOAD_CODE_PARSE:
        RST $10                         ;0973 call HOME ROM...
        DEFW $0020                      ;0974 ...get next char

        CALL EVAL_NUMERIC               ;0976 evaluate address
        JR Z,LOAD_PARSE_ERROR          ;0979 error
        LD A,$02                        ;097B sub-type 2 = CODE + addr
        JR LOAD_PROGRAM                 ;097D

;==================================================================
; LOAD SCREEN$ parse
;==================================================================
LOAD_SCREEN_PARSE:
        RST $10                         ;097F call HOME ROM...
        DEFW $0020                      ;0980 ...get next char

        CALL EVAL_NUMERIC               ;0982 evaluate expression
        JR Z,LOAD_PARSE_ERROR          ;0985 error

        LD HL,(CH_ADD)                  ;0987 check for comma
        LD A,(HL)                       ;098A
        CP ','                          ;098B comma present?
        JR NZ,LOAD_PARSE_ERROR         ;098D no - error (need addr,len)

        RST $10                         ;098F call HOME ROM...
        DEFW $0020                      ;0990 ...get next char

        CALL EVAL_NUMERIC               ;0992 evaluate length
        JR Z,LOAD_PARSE_ERROR          ;0995 error
        LD A,$03                        ;0997 sub-type 3 = CODE + addr + len
        JR LOAD_PROGRAM                 ;0999

;==================================================================
; LOAD LINE parse (auto-run line number)
;==================================================================
LOAD_LINE_PARSE:
        RST $10                         ;099B call HOME ROM...
        DEFW $0020                      ;099C ...get next char

        LD A,$04                        ;099E sub-type 4 = SCREEN$
        LD A,(DE)                       ;09A0 \ These bytes encode
        LD E,$D7                        ;09A1 | RST $10 / DEFW $0020
        JR NZ,$+2                       ;09A3 /

;==================================================================
; LOAD DATA parse
;==================================================================
LOAD_DATA_PARSE:
        CALL SET_TOKEN_MODE             ;09A5 get variable token
        JR C,LOAD_PARSE_ERROR          ;09A8 error
        LD A,C                          ;09AA get variable type
        AND $60                         ;09AB mask type bits
        JR Z,LOAD_DATA_NUMERIC         ;09AD zero = numeric
        CP $40                          ;09AF string type?
        JR NZ,LOAD_PARSE_ERROR         ;09B1 no - error

LOAD_DATA_NUMERIC:
        LD (DATA_LEN_REM),HL            ;09B3 store variable pointer
        LD HL,(CH_ADD)                  ;09B6 advance past "()"
        INC HL                          ;09B9
        INC HL                          ;09BA
        LD (CH_ADD),HL                  ;09BB update CH_ADD
        LD A,$05                        ;09BE sub-type 5 = DATA

LOAD_PROGRAM:
        LD (LOAD_SUBTYPE),A             ;09C0 store sub-type
        LD HL,(CH_ADD)                  ;09C3 get current position
        JP CHECK_YN_CHAR                ;09C6 check for trailing chars

;******************************************************************
;******************************************************************
;
;  LOAD EXECUTION DISPATCH ($09C9-$0A3B)
;
;  Execution phase for LOAD command. Dispatches based on
;  the sub-type determined during parsing.
;
;******************************************************************
;******************************************************************

LOAD_EXEC:
        LD HL,BASIC_PROMPT              ;09C9 set return to prompt
        EX (SP),HL                      ;09CC swap onto stack

        LD A,(LOAD_SUBTYPE)             ;09CD get sub-type
        CP $05                          ;09D0 DATA?
        JP Z,LOAD_DATA_EXEC            ;09D2 yes

        CP $04                          ;09D5 SCREEN$?
        JP Z,LOAD_SCREEN_EXEC          ;09D7 yes

        CP $03                          ;09DA CODE addr,len?
        JP Z,LOAD_CODE_ADDRLEN         ;09DC yes

        CP $02                          ;09DF CODE addr only?
        JP Z,LOAD_CODE_ADDR            ;09E1 yes

;------------------------------------------------------------------
; Sub-type 0: LOAD program (default)
;------------------------------------------------------------------
        LD HL,$0200                     ;09E4 program load flag
        PUSH HL                         ;09E7

LOAD_PROG_EXEC:
        CALL PREP_BUFFER                ;09E8 prepare filename buffer
        EX AF,AF'                       ;09EB save flags
        LD HL,(PROG)                    ;09EC get start of BASIC program
        EX DE,HL                        ;09EF DE = PROG
        LD HL,(E_LINE)                  ;09F0 get edit line address
        SCF                             ;09F3 set carry
        SBC HL,DE                       ;09F4 calculate program length
        LD B,H                          ;09F6 length in BC
        LD C,L                          ;09F7
        POP HL                          ;09F8 restore load flag
        LD A,$00                        ;09F9 type 0 = program
        JR SAVE_LOAD_ENGINE             ;09FB jump to engine

;==================================================================
; LOAD_CODE_ADDR ($09FD)
; LOAD "name" CODE addr
;==================================================================
LOAD_CODE_ADDR:
        CALL EVAL_STR_TO_BC            ;09FD evaluate address
        PUSH BC                         ;0A00 save address
        JR LOAD_PROG_EXEC              ;0A01 continue

;==================================================================
; LOAD_CODE_ADDRLEN ($0A03)
; LOAD "name" CODE addr,len
;==================================================================
LOAD_CODE_ADDRLEN:
        CALL EVAL_STR_TO_BC            ;0A03 evaluate length
        PUSH BC                         ;0A06 save length
        CALL EVAL_STR_TO_BC            ;0A07 evaluate address
        PUSH BC                         ;0A0A save address

LOAD_CODE_COMMON:
        CALL PREP_BUFFER                ;0A0B prepare filename
        EX AF,AF'                       ;0A0E save flags
        POP DE                          ;0A0F get address
        POP BC                          ;0A10 get length
        LD HL,$0000                     ;0A11 no auto-start line
        LD A,$03                        ;0A14 type 3 = CODE with addr+len
        JR SAVE_LOAD_ENGINE             ;0A16

;==================================================================
; LOAD_SCREEN_EXEC ($0A18)
; LOAD "name" SCREEN$
; Screen is 6912 bytes at $4000.
;==================================================================
LOAD_SCREEN_EXEC:
        LD HL,$1B00                     ;0A18 length = 6912 ($1B00)
        PUSH HL                         ;0A1B
        LD HL,$4000                     ;0A1C address = $4000 (screen)
        PUSH HL                         ;0A1F
        JR LOAD_CODE_COMMON             ;0A20 treat as CODE

;==================================================================
; LOAD_DATA_EXEC ($0A22)
; LOAD "name" DATA a$()
;==================================================================
LOAD_DATA_EXEC:
        CALL PREP_BUFFER                ;0A22 prepare filename
        EX AF,AF'                       ;0A25 save flags
        LD HL,(DATA_LEN_REM)            ;0A26 get variable pointer
        BIT 6,(HL)                      ;0A29 string array?
        LD A,$01                        ;0A2B type 1 = numeric array
        JR Z,LOAD_DATA_TYPE_SET        ;0A2D no - numeric

        LD A,$02                        ;0A2F type 2 = string array

LOAD_DATA_TYPE_SET:
        INC HL                          ;0A31 skip name byte
        LD C,(HL)                       ;0A32 get length low
        INC HL                          ;0A33
        LD B,(HL)                       ;0A34 get length high
        DEC HL                          ;0A35 back to start
        INC BC                          ;0A36 add 3 for header
        INC BC                          ;0A37
        EX DE,HL                        ;0A38
        LD HL,$0000                     ;0A39 no auto-start line

;******************************************************************
;******************************************************************
;
;  SAVE/LOAD ENGINE ($0A3C-$0B15)
;
;  Core engine for SAVE and LOAD operations.
;  Prepares headers, communicates with FDD, handles supersede
;  prompts, and performs block data transfers.
;
;  Entry: A = file type, HL = auto-start/flag
;         BC = data length, DE = source/dest address
;
;******************************************************************
;******************************************************************

SAVE_LOAD_ENGINE:
        PUSH HL                         ;0A3C save auto-start line
        PUSH DE                         ;0A3D save address
        PUSH BC                         ;0A3E save length
        PUSH AF                         ;0A3F save file type

;------------------------------------------------------------------
; Store memory address and length in workspace
;------------------------------------------------------------------
        LD (MEM_ADDR),DE                ;0A40 store memory address
        LD (DATA_LEN_REM),BC            ;0A44 store data length

;------------------------------------------------------------------
; Send PREPARE command ($12) to FDD
;------------------------------------------------------------------
        LD A,FDD_PREPARE                ;0A48 prepare command ($12)
        LD (FDD_CMD),A                  ;0A4A store command
        CALL SEND_CMD                   ;0A4D send to FDD
        CALL FDD_CHECK_OK               ;0A50 check response
        JR NZ,SL_ERROR                  ;0A53 error

;------------------------------------------------------------------
; Send drive number and filename data
;------------------------------------------------------------------
        LD A,(SAVED_BC+1)              ;0A55 get saved parameter
        LD (DRIVE_NUM),A                ;0A58 store as drive number
        EX AF,AF'                       ;0A5B restore original flags
        CALL SEND_DATA                  ;0A5C send data frame

;------------------------------------------------------------------
; Set up SAVE command ($02)
;------------------------------------------------------------------
        LD A,FDD_SAVE                   ;0A5F SAVE command
        LD (FDD_CMD),A                  ;0A61 store command

;------------------------------------------------------------------
; Send file header
;------------------------------------------------------------------
        LD A,$01                        ;0A64 header block
        CALL FDD_SECTOR_IO             ;0A66 send header
        JR Z,SL_HEADER_OK              ;0A69 success

;------------------------------------------------------------------
; Check response codes
;------------------------------------------------------------------
        CP '#'                          ;0A6B file exists - supersede?
        JR Z,SL_HEADER_OK              ;0A6D treat as OK
        CP ' '                          ;0A6F space = proceed
        JR Z,SL_HEADER_OK              ;0A71 OK
        CP '#'                          ;0A73 double-check
        JR NZ,SL_ERROR                  ;0A75 real error

;------------------------------------------------------------------
; File exists, no auto-supersede - prompt user
;------------------------------------------------------------------
        LD A,(FILE_TYPE)                ;0A77 check file type
        AND A                           ;0A7A zero = no supersede
        JR NZ,SL_SUPERSEDE_YES         ;0A7B non-zero = auto-supersede

;------------------------------------------------------------------
; Display "Supersede (Y/N) ?" prompt
;------------------------------------------------------------------
        LD HL,MSG_BUFFER                ;0A7D point to message buffer
        PUSH HL                         ;0A80 save it
        CALL DISPLAY_BUF               ;0A81 display current message
        LD A,$81                        ;0A84 error $81 = supersede
        LD (FDD_CMD+2),A               ;0A86 store error code
        CALL SET_ERROR                  ;0A89 set error message
        POP HL                          ;0A8C restore buffer pointer
        CALL DISPLAY_BUF               ;0A8D display "Supersede (Y/N) ?"

WAIT_YN:
        CALL READ_KEY                   ;0A90 wait for keypress
        CP 'Y'                          ;0A93 'Y' = yes?
        JR Z,SL_SUPERSEDE_YES          ;0A95 yes - supersede

        CP 'N'                          ;0A97 'N' = no?
        JR NZ,WAIT_YN                   ;0A99 neither - keep waiting

;------------------------------------------------------------------
; User said NO - cancel operation
;------------------------------------------------------------------
        RST $10                         ;0A9B call HOME ROM...
        DEFW $0010                      ;0A9C ...print 'N'
        XOR A                           ;0A9E clear error
        LD (FDD_CMD+2),A               ;0A9F clear error code

SL_ERROR:
        JP SL_CLEANUP                   ;0AA2 clean up and return

;------------------------------------------------------------------
; User said YES (or auto-supersede) - proceed
;------------------------------------------------------------------
SL_SUPERSEDE_YES:
        RST $10                         ;0AA5 call HOME ROM...
        DEFW $0010                      ;0AA6 ...print 'Y'

SL_WRITE_DIR:
        CALL FDD_WRITE_DIR              ;0AA8 write directory entry
        CALL Z,FDD_CLOSE_FILE          ;0AAB close file if OK
        JR NZ,SL_ERROR                  ;0AAE error

;------------------------------------------------------------------
; Directory written OK - write data blocks
;------------------------------------------------------------------
SL_HEADER_OK:
        CALL FDD_WRITE_DIR              ;0AB0 write directory
        JR NZ,SL_ERROR                  ;0AB3 error

;------------------------------------------------------------------
; Build data packet header
;------------------------------------------------------------------
        POP AF                          ;0AB5 restore file type
        POP BC                          ;0AB6 restore length
        POP DE                          ;0AB7 restore address
        POP HL                          ;0AB8 restore auto-start line
        PUSH HL                         ;0AB9 save them all back
        PUSH DE                         ;0ABA
        PUSH BC                         ;0ABB
        PUSH AF                         ;0ABC

        LD (IO_BUFFER),A               ;0ABD store type at $2000
        CP $00                          ;0AC0 program type?
        JR NZ,SL_NOT_PROGRAM            ;0AC2 no

;------------------------------------------------------------------
; Program header: type, auto-start, prog_len, var_offset
;------------------------------------------------------------------
        LD (IO_BUFFER+1),HL            ;0AC4 store auto-start line
        LD HL,(VARS)                    ;0AC7 get VARS address
        AND A                           ;0ACA clear carry
        SBC HL,DE                       ;0ACB HL = VARS - PROG (var offset)
        LD (IO_BUFFER+5),HL            ;0ACD store variables offset
        LD (IO_BUFFER+3),BC            ;0AD0 store program length
        LD A,$07                        ;0AD4 packet size = 7
        JR SL_SEND_HEADER              ;0AD6

;------------------------------------------------------------------
; Non-program header: type, address, length
;------------------------------------------------------------------
SL_NOT_PROGRAM:
        LD (IO_BUFFER+1),BC            ;0AD8 store length
        LD (IO_BUFFER+3),DE            ;0ADC store address
        LD A,$05                        ;0AE0 packet size = 5

SL_SEND_HEADER:
        LD (PKT_SIZE),A                 ;0AE2 store packet size
        CALL SEND_DATA                  ;0AE5 send header packet

;------------------------------------------------------------------
; Now send actual data blocks via FDD transfer
;------------------------------------------------------------------
        LD A,(DRIVE_NUM)                ;0AE8 get drive number
        LD B,A                          ;0AEB
        LD C,$00                        ;0AEC
        LD D,C                          ;0AEE D = 0
        LD A,(PKT_SIZE)                 ;0AEF get packet size
        LD E,A                          ;0AF2

        LD A,FDD_XFER                   ;0AF3 transfer command ($0F)
        LD (FDD_CMD),A                  ;0AF5 store command
        CALL FDD_SECTOR_IO             ;0AF8 send data
        JR NZ,SL_DATA_ERROR            ;0AFB error

;------------------------------------------------------------------
; Write data blocks
;------------------------------------------------------------------
        CALL WRITE_BLOCK               ;0AFD write block to disk
        JR NZ,SL_DATA_ERROR            ;0B00 error
        XOR A                           ;0B02 success

SL_DATA_ERROR:
        PUSH AF                         ;0B03 save status
        CALL FDD_CLOSE_FILE            ;0B04 close file
        JR Z,SL_CLOSE_OK              ;0B07 close succeeded
        POP HL                          ;0B09 discard saved status
        JR SL_CLEANUP                   ;0B0A

SL_CLOSE_OK:
        POP AF                          ;0B0C restore status

SL_CLEANUP:
        OR A                            ;0B0D set flags from error code
        CALL SET_ERROR                  ;0B0E set error message
        POP AF                          ;0B11 clean up stack
        POP BC                          ;0B12
        POP DE                          ;0B13
        POP HL                          ;0B14
        RET                             ;0B15

;******************************************************************
;******************************************************************
;
;  FDD SECTOR I/O ($0B16-$0B7E)
;
;  Block read/write with retry logic. Transfers data in
;  256-byte sectors between memory and FDD.
;
;******************************************************************
;******************************************************************

;==================================================================
; FDD_WRITE_DIR ($0B16)
; Write directory entry to FDD.
;==================================================================
FDD_WRITE_DIR:
        LD DE,$0201                     ;0B16 command + direction flags

;==================================================================
; FDD_SECTOR_CMD ($0B19)
; Send a sector-level command to FDD.
; A = sub-command
;==================================================================
FDD_SECTOR_CMD:
        LD A,$00                        ;0B19 sector command
        JR FDD_SECTOR_ENTRY             ;0B1B

;==================================================================
; FDD_CLOSE_FILE ($0B1D)
; Close the current file on FDD.
;==================================================================
FDD_CLOSE_FILE:
        LD A,$01                        ;0B1D close file command

FDD_SECTOR_ENTRY:
        LD (FDD_CMD),A                  ;0B1F store command
        LD A,(DRIVE_NUM)                ;0B22 get drive number

;==================================================================
; FDD_SECTOR_IO ($0B25)
; Send sector I/O command and check response.
;==================================================================
FDD_SECTOR_IO:
        CALL SEND_CMD                   ;0B25 send command
        JP FDD_CHECK_OK                 ;0B28 check and return status

;==================================================================
; WRITE_BLOCK ($0B2B)
; Write a block of data to FDD, splitting into 256-byte sectors.
; Uses DATA_LEN_REM and MEM_ADDR from workspace.
;==================================================================
WRITE_BLOCK:
        PUSH BC                         ;0B2B save registers
        PUSH DE                         ;0B2C
        PUSH HL                         ;0B2D

WRITE_BLOCK_LOOP:
        LD HL,(DATA_LEN_REM)            ;0B2E get remaining length
        LD BC,$0100                     ;0B31 256 bytes per sector
        OR A                            ;0B34 clear carry
        SBC HL,BC                       ;0B35 subtract 256
        JR NC,WRITE_FULL_SECTOR        ;0B37 >= 256 bytes remain

;------------------------------------------------------------------
; Less than 256 bytes remaining
;------------------------------------------------------------------
        LD HL,(DATA_LEN_REM)            ;0B39 get actual remaining
        LD A,H                          ;0B3C check if zero
        OR L                            ;0B3D
        JR Z,WRITE_DONE                 ;0B3E zero - all done
        LD C,L                          ;0B40 use actual remaining
        LD B,H                          ;0B41 as byte count
        LD HL,$0000                     ;0B42 remaining = 0

WRITE_FULL_SECTOR:
        LD (DATA_LEN_REM),HL            ;0B45 update remaining length

;------------------------------------------------------------------
; Copy from memory to I/O buffer and send
;------------------------------------------------------------------
        LD DE,IO_BUFFER                 ;0B48 destination = $2000
        LD HL,(MEM_ADDR)                ;0B4B get source address
        PUSH BC                         ;0B4E save count
        LDIR                            ;0B4F copy to buffer
        LD (MEM_ADDR),HL                ;0B51 update source pointer
        POP BC                          ;0B54 restore count

        LD A,C                          ;0B55 payload length
        PUSH BC                         ;0B56 save count
        CALL SEND_DATA                  ;0B57 send data frame
        POP DE                          ;0B5A restore count in DE
        JR NZ,WRITE_ERROR               ;0B5B send failed

;------------------------------------------------------------------
; Send sector write command
;------------------------------------------------------------------
        LD A,(DRIVE_NUM)                ;0B5D get drive number
        LD B,A                          ;0B60
        LD C,$00                        ;0B61
        LD A,FDD_XFER                   ;0B63 transfer command
        LD (FDD_CMD),A                  ;0B65 store command
        CALL SEND_CMD                   ;0B68 send command
        JR NZ,WRITE_ERROR               ;0B6B error

        CALL FDD_CHECK_OK               ;0B6D check response
        JR C,WRITE_ERROR                ;0B70 carry = error
        JR NZ,WRITE_RETRY              ;0B72 NZ = retry needed
        JR WRITE_BLOCK_LOOP             ;0B74 success - next sector

WRITE_ERROR:
        SCF                             ;0B76 set carry = error
        JR WRITE_EXIT                   ;0B77

WRITE_DONE:
        XOR A                           ;0B79 success

WRITE_RETRY:
        OR A                            ;0B7A set flags

WRITE_EXIT:
        POP HL                          ;0B7B restore registers
        POP DE                          ;0B7C
        POP BC                          ;0B7D
        RET                             ;0B7E

;******************************************************************
;******************************************************************
;
;  LOAD CODE/SCREEN$/DATA SYNTAX ($0B7F-$0C07)
;
;  Additional syntax parsing for LOAD sub-types.
;  Handles CODE, CODE addr, CODE addr,len, SCREEN$, and DATA.
;
;******************************************************************
;******************************************************************

LOAD_CODE_SYNTAX:
        CALL EVAL_NUMERIC               ;0B7F evaluate expression
        JR NZ,LOAD_SYNTAX_ERROR        ;0B82 error

        LD HL,(CH_ADD)                  ;0B84 get parse position
        LD A,(HL)                       ;0B87 get current char
        LD (LOAD_SUBTYPE),A             ;0B88 store initial sub-type

        CALL CHECK_EOL                  ;0B8B check end of statement
        RET Z                           ;0B8E at end - done

        CP $AF                          ;0B8F CODE token?
        JR Z,LOAD_CODE_SYN2            ;0B91 yes

        CP $AA                          ;0B93 SCREEN$ token?
        JR Z,LOAD_SCREEN_SYN           ;0B95 yes

        CP $E4                          ;0B97 DATA token?
        JR Z,LOAD_DATA_SYN             ;0B99 yes

LOAD_SYNTAX_ERROR:
        JP SET_ERROR_AND_RET            ;0B9B

;==================================================================
; LOAD CODE syntax parsing
;==================================================================
LOAD_CODE_SYN2:
        RST $10                         ;0B9E call HOME ROM...
        DEFW $0020                      ;0B9F ...get next char

        CALL CHECK_EOL                  ;0BA1 check end of statement
        JR Z,LOAD_CODE_NOADDR         ;0BA4 no address - use default

        CALL EVAL_NUMERIC               ;0BA6 evaluate address
        JR Z,LOAD_SYNTAX_ERROR         ;0BA9 error

        LD HL,(CH_ADD)                  ;0BAB check for comma
        LD A,(HL)                       ;0BAE
        CP ','                          ;0BAF comma?
        JR Z,LOAD_CODE_COMMA           ;0BB1 yes - length follows

        LD A,$02                        ;0BB3 sub-type 2 = CODE + addr
        JR LOAD_STORE_TYPE              ;0BB5

LOAD_CODE_NOADDR:
        LD A,$15                        ;0BB7 sub-type $15 = CODE no addr
        JR LOAD_STORE_TYPE              ;0BB9

LOAD_CODE_COMMA:
        RST $10                         ;0BBB call HOME ROM...
        DEFW $0020                      ;0BBC ...get next char

        CALL EVAL_NUMERIC               ;0BBE evaluate length
        JR Z,LOAD_SYNTAX_ERROR         ;0BC1 error
        LD A,$16                        ;0BC3 sub-type $16 = CODE addr,len
        JR LOAD_STORE_TYPE              ;0BC5

;==================================================================
; LOAD SCREEN$ syntax
;==================================================================
LOAD_SCREEN_SYN:
        RST $10                         ;0BC7 call HOME ROM...
        DEFW $0020                      ;0BC8 ...get next char
        LD A,$03                        ;0BCA sub-type 3 = SCREEN$
        JR LOAD_STORE_TYPE              ;0BCC

;==================================================================
; LOAD DATA syntax
;==================================================================
LOAD_DATA_SYN:
        RST $10                         ;0BCE call HOME ROM...
        DEFW $0020                      ;0BCF ...get next char

        CALL SET_TOKEN_MODE             ;0BD1 get variable token
        LD (LOAD_ADDR),HL               ;0BD4 store variable pointer
        LD A,$00                        ;0BD7 default = no flag
        JR C,LOAD_DATA_FLAG            ;0BD9 carry set = numeric

        LD A,$80                        ;0BDB flag = string array

LOAD_DATA_FLAG:
        LD (SECONDARY_FLG),A            ;0BDD store flag
        LD A,C                          ;0BE0 get variable type
        SET 7,A                         ;0BE1 set bit 7
        LD (VAR_NAME),A                 ;0BE3 store variable name

        AND $60                         ;0BE6 mask type bits
        JR Z,LOAD_DATA_SIMPLE          ;0BE8 zero = simple var

        CP $40                          ;0BEA string?
        JR Z,LOAD_DATA_STRING          ;0BEC yes

        POP AF                          ;0BEE error - clean stack
        JR LOAD_SYNTAX_ERROR            ;0BEF

LOAD_DATA_STRING:
        LD A,$02                        ;0BF1 type 2 = string array
        JR LOAD_DATA_STORE              ;0BF3

LOAD_DATA_SIMPLE:
        LD A,$01                        ;0BF5 type 1 = numeric array

LOAD_DATA_STORE:
        LD (FILE_TYPE),A                ;0BF7 store file type
        LD HL,(CH_ADD)                  ;0BFA advance past "()"
        INC HL                          ;0BFD
        INC HL                          ;0BFE
        LD (CH_ADD),HL                  ;0BFF update CH_ADD
        LD A,$04                        ;0C02 sub-type 4 = DATA

LOAD_STORE_TYPE:
        LD (LOAD_SUBTYPE),A             ;0C04 store sub-type
        RET                             ;0C07

;******************************************************************
;******************************************************************
;
;  LOAD CODE/SCREEN$/DATA EXECUTION ($0C08-$0CAB)
;
;  Execution phase for LOAD CODE, SCREEN$, and DATA.
;
;******************************************************************
;******************************************************************

LOAD_CODE_EXEC:
        LD HL,BASIC_PROMPT              ;0C08 set return address
        EX (SP),HL                      ;0C0B swap onto stack

        LD A,(LOAD_SUBTYPE)             ;0C0C get sub-type
        CP $04                          ;0C0F DATA?
        JR Z,$+90                       ;0C11 yes - handle DATA load

        CP $03                          ;0C13 SCREEN$?
        JR Z,LOAD_SCREEN_DO            ;0C15 yes

        CP $16                          ;0C17 CODE addr,len?
        JR Z,LOAD_CODE_ADDRLEN_DO      ;0C19 yes

        CP $15                          ;0C1B CODE no addr?
        JR Z,LOAD_CODE_NOADDR_DO       ;0C1D yes

        CP $02                          ;0C1F CODE addr only?
        JR Z,$+8                        ;0C21 yes

;------------------------------------------------------------------
; Default LOAD CODE handler
;------------------------------------------------------------------
LOAD_CODE_DEFAULT:
        LD A,$00                        ;0C23 mode = default
        JR LOAD_CODE_COMMON_DO          ;0C25

;------------------------------------------------------------------
; CODE addr - evaluate address
;------------------------------------------------------------------
        CALL EVAL_STR_TO_BC            ;0C27 evaluate address
        LD (LOAD_LENGTH),BC             ;0C2A store as length (temp)
        LD BC,$0000                     ;0C2E address = 0 (will be from header)
        LD (LOAD_ADDR),BC               ;0C31 store address

LOAD_CODE_SET3:
        LD A,$03                        ;0C35 mode = 3

LOAD_CODE_COMMON_DO:
        LD (LOAD_MODE),A               ;0C37 store load mode
        CALL PREP_BUFFER                ;0C3A prepare filename
        JR LOAD_DIR_ENTRY               ;0C3D jump to directory read

;==================================================================
; LOAD CODE (no addr specified) - use defaults
;==================================================================
LOAD_CODE_NOADDR_DO:
        LD HL,$FFFF                     ;0C3F addr = $FFFF (use file's addr)
        LD (LOAD_ADDR),HL               ;0C42 store
        LD HL,$0000                     ;0C45 length = 0 (use file's length)
        LD (LOAD_LENGTH),HL             ;0C48 store
        JR LOAD_CODE_SET3               ;0C4B

;==================================================================
; LOAD CODE addr,len - evaluate both
;==================================================================
LOAD_CODE_ADDRLEN_DO:
        CALL EVAL_STR_TO_BC            ;0C4D evaluate address
        LD (LOAD_ADDR),BC               ;0C50 store address
        CALL EVAL_STR_TO_BC            ;0C54 evaluate length
        LD (LOAD_LENGTH),BC             ;0C57 store length
        JR LOAD_CODE_SET3               ;0C5B

;==================================================================
; LOAD SCREEN$ execution
; Fixed: 6912 bytes at $4000
;==================================================================
LOAD_SCREEN_DO:
        LD HL,$1B00                     ;0C5D length = 6912
        LD (LOAD_ADDR),HL               ;0C60 store (temp, will be addr)
        LD HL,$4000                     ;0C63 address = $4000
        LD (LOAD_LENGTH),HL             ;0C66 store

;------------------------------------------------------------------
; These bytes encode a complex sequence for SCREEN$ loading
; involving mode flags and buffer preparation
;------------------------------------------------------------------
        RRA                             ;0C69
        JP Z,$343A                      ;0C6A (conditional jump)
        LD HL,$4D32                     ;0C6D (encoded sequence)
        LD HL,$60CD                     ;0C70
        LD B,$18                        ;0C73
        LD (HL),$3E                     ;0C75
        ADD A,B                         ;0C77

;------------------------------------------------------------------
; Set program load flag and continue
;------------------------------------------------------------------
        LD (PROG_LOAD_FLG),A            ;0C78 set load flag
        LD HL,BASIC_PROMPT              ;0C7B return address
        EX (SP),HL                      ;0C7E swap onto stack

        CALL LOAD_CODE_DEFAULT          ;0C7F call default loader
        LD A,(FDD_CMD+2)               ;0C82 get response
        OR A                            ;0C85 error?
        RET NZ                          ;0C86 yes - return

;------------------------------------------------------------------
; Install auto-run code after successful LOAD
;------------------------------------------------------------------
        LD DE,$6830                     ;0C87 destination in RAM
        LD HL,AUTO_RUN_CODE             ;0C8A source code
        LD BC,$0012                     ;0C8D 18 bytes
        LDIR                            ;0C90 copy auto-run code

        LD DE,(FILE_SIZE)               ;0C92 get auto-start line
        RST $10                         ;0C96 call HOME ROM...
        DEFW $6830                      ;0C97 ...execute auto-run code
        RET                             ;0C99

;------------------------------------------------------------------
; AUTO_RUN_CODE ($0C9A)
; Small code block copied to RAM and executed to set up
; auto-run of a loaded BASIC program.
;------------------------------------------------------------------
AUTO_RUN_CODE:
        LD HL,$0713                     ;0C9A HOME ROM address
        PUSH HL                         ;0C9D
        LD HL,$FEFE                     ;0C9E sentinel value
        PUSH HL                         ;0CA1
        LD HL,$0000                     ;0CA2 line 0
        PUSH HL                         ;0CA5
        PUSH HL                         ;0CA6
        EX DE,HL                        ;0CA7
        CALL $65D0                      ;0CA8 HOME ROM routine
        RET                             ;0CAB

;******************************************************************
;******************************************************************
;
;  LOAD CONTINUATION ($0CAC-$0D7E)
;
;  Read directory from FDD, compare file types, and dispatch
;  to appropriate loader (BASIC program, CODE, or DATA).
;
;******************************************************************
;******************************************************************

LOAD_DIR_ENTRY:
        LD IX,LOAD_MODE                 ;0CAC point to load parameters
        LD A,FDD_PREPARE                ;0CB0 prepare command ($12)
        LD (FDD_CMD),A                  ;0CB2 store command
        CALL FDD_SECTOR_IO             ;0CB5 send prepare command
        JP NZ,LOAD_DONE                 ;0CB8 error - done

;------------------------------------------------------------------
; Send drive number and filename
;------------------------------------------------------------------
        LD A,(SAVED_BC+1)              ;0CBB get parameter
        LD (DRIVE_NUM),A                ;0CBE store drive number
        LD A,B                          ;0CC1 get B
        CALL SEND_DATA                  ;0CC2 send data

;------------------------------------------------------------------
; Send LOAD command
;------------------------------------------------------------------
        LD DE,$0101                     ;0CC5 command parameters
        CALL FDD_SECTOR_CMD             ;0CC8 send sector command
        JP NZ,LOAD_DONE                 ;0CCB error

;------------------------------------------------------------------
; Read directory entry
;------------------------------------------------------------------
        LD DE,$0001                     ;0CCE parameters
        CALL READ_SECTOR               ;0CD1 read one sector
        JP NZ,LOAD_TYPE_ERROR           ;0CD4 error

;------------------------------------------------------------------
; Compare file type with expected type
;------------------------------------------------------------------
        LD A,(HL)                       ;0CD7 get file type from disk
        CP (IX+$00)                     ;0CD8 compare with expected
        JR NZ,LOAD_WRONG_TYPE         ;0CDB mismatch

        CP $00                          ;0CDD program type?
        JR Z,LOAD_PROG_CONT           ;0CDF yes

        CP $04                          ;0CE1 DATA type (< 4)?
        JR C,LOAD_CODE_CONT            ;0CE3 yes - code/data

LOAD_WRONG_TYPE:
        LD A,$4B                        ;0CE5 error = "Wrong data type"
        JP LOAD_TYPE_ERROR              ;0CE7

;------------------------------------------------------------------
; LOAD program - read header fields
;------------------------------------------------------------------
LOAD_PROG_CONT:
        LD DE,$0006                     ;0CEA 6 bytes of header info
        JR LOAD_READ_HEADER             ;0CED

LOAD_CODE_CONT:
        LD DE,$0004                     ;0CEF 4 bytes of header info

LOAD_READ_HEADER:
        LD A,E                          ;0CF2 save header size
        LD (PKT_SIZE),A                 ;0CF3 store packet size
        CALL READ_SECTOR               ;0CF6 read header sector
        JR NZ,LOAD_TYPE_ERROR           ;0CF9 error

;------------------------------------------------------------------
; Dispatch by file type
;------------------------------------------------------------------
        LD A,(IX+$00)                   ;0CFB get file type

LOAD_TYPE_DISPATCH:
        CP $00                          ;0CFE program?
        JR Z,LOAD_BASIC                 ;0D00 yes

        CP $03                          ;0D02 CODE with addr+len?
        JR Z,LOAD_CODE_DO              ;0D04 yes

        JR C,LOAD_ARRAY                 ;0D06 < 3 = array data

        LD A,$4B                        ;0D08 error = "Wrong data type"
        JR LOAD_TYPE_ERROR              ;0D0A

;==================================================================
; LOAD_BASIC ($0D0C)
; Load a BASIC program. Sets up workspace and calls LOAD_BASIC_PROG.
;==================================================================
LOAD_BASIC:
        PUSH IX                         ;0D0C get IX into DE
        POP DE                          ;0D0E
        INC DE                          ;0D0F point to data after type byte

        LD BC,$0006                     ;0D10 6 bytes of program info
        LDIR                            ;0D13 copy to workspace

        CALL LOAD_BASIC_PROG            ;0D15 load the BASIC program
        OR A                            ;0D18
        JR NZ,LOAD_TYPE_ERROR           ;0D19 error

;------------------------------------------------------------------
; Set up program length and jump to multi-sector read
;------------------------------------------------------------------
        LD L,(IX+$03)                   ;0D1B get program length low
        LD H,(IX+$06)                   ;0D1E get program length high
        LD (DATA_LEN_REM),HL            ;0D21 store as remaining bytes
        JR LOAD_TRANSFER                ;0D24

;==================================================================
; LOAD_ARRAY ($0D26)
; Load array data. Handles variable allocation and sizing.
;==================================================================
LOAD_ARRAY:
        LD HL,(LOAD_ADDR)               ;0D26 get load address
        LD A,(SECONDARY_FLG)            ;0D29 check flag
        OR A                            ;0D2C
        CALL NZ,$0632                   ;0D2D call helper if flag set

;------------------------------------------------------------------
; Get data length and allocate space
;------------------------------------------------------------------
        LD HL,(IO_BUFFER)               ;0D30 get data from buffer
        LD (DATA_LEN_REM),HL            ;0D33 store as remaining length
        LD C,L                          ;0D36 length in BC
        LD B,H                          ;0D37
        DEC BC                          ;0D38 subtract 2 for header
        DEC BC                          ;0D39
        CALL MAKE_ROOM                  ;0D3A allocate space

;------------------------------------------------------------------
; Store variable name and continue
;------------------------------------------------------------------
        LD A,(VAR_NAME)                 ;0D3D get variable name
        LD (HL),A                       ;0D40 store in allocated space
        INC HL                          ;0D41
        JR LOAD_SET_ADDR                ;0D42

;==================================================================
; LOAD_CODE_DO ($0D44)
; Load CODE data. Handles address/length from file header.
;==================================================================
LOAD_CODE_DO:
        LD E,(IX+$01)                   ;0D44 get address from header low
        LD D,(IX+$02)                   ;0D47 get address from header high
        LD HL,(IO_BUFFER)               ;0D4A get length from buffer
        LD (DATA_LEN_REM),HL            ;0D4D store remaining length

        LD A,E                          ;0D50 check if user specified address
        OR D                            ;0D51
        JR Z,LOAD_USE_FILE_ADDR        ;0D52 no user addr - use file's

;------------------------------------------------------------------
; User specified address - check if it fits
;------------------------------------------------------------------
        SBC HL,DE                       ;0D54 check if file fits
        JR C,LOAD_USE_FILE_ADDR        ;0D56 too large - use file addr

        LD (DATA_LEN_REM),DE            ;0D58 use user's length

LOAD_USE_FILE_ADDR:
        LD L,(IX+$03)                   ;0D5C get dest address low
        LD H,(IX+$04)                   ;0D5F get dest address high
        LD A,L                          ;0D62 check if zero
        OR H                            ;0D63
        JR NZ,LOAD_SET_ADDR            ;0D64 non-zero - use it

        LD HL,(IO_BUFFER+2)             ;0D66 get default address from buffer

LOAD_SET_ADDR:
        LD (MEM_ADDR),HL                ;0D69 store destination address

LOAD_TRANSFER:
        CALL READ_MULTI                 ;0D6C read multi-sector data

LOAD_TYPE_ERROR:
        PUSH AF                         ;0D6F save error code
        CALL FDD_CLOSE_FILE            ;0D70 close file
        JR NZ,LOAD_CLOSE_ERR          ;0D73 close failed

        POP AF                          ;0D75 restore error code
        LD (FDD_CMD+2),A               ;0D76 store in response
        JR LOAD_DONE                    ;0D79

LOAD_CLOSE_ERR:
        POP HL                          ;0D7B discard saved error

LOAD_DONE:
        JP SET_ERROR                    ;0D7C set error and return

;******************************************************************
;******************************************************************
;
;  READ_SECTOR ($0D7F-$0DA9)
;
;  Read a single sector from FDD using command $10.
;  DE = parameters, results stored at IO_BUFFER.
;
;  Returns: Z = success, A = status code
;           HL = pointer to data, BC = byte count
;
;******************************************************************
;******************************************************************

READ_SECTOR:
        PUSH DE                         ;0D7F save parameters
        LD A,(DRIVE_NUM)                ;0D80 get drive number
        LD B,A                          ;0D83 in B
        LD A,FDD_RD_SECTOR              ;0D84 read sector command ($10)
        LD (FDD_CMD),A                  ;0D86 store command
        CALL SEND_CMD                   ;0D89 send to FDD
        JR NZ,READ_SEC_FAIL            ;0D8C error

READ_SEC_WAIT:
        CALL $0395                      ;0D8E receive response
        JR NC,READ_SEC_WAIT             ;0D91 not ready - wait

        LD A,(FDD_CMD)                  ;0D93 get response status
        CP $80                          ;0D96 $80 = OK?
        JR NZ,READ_SEC_FAIL            ;0D98 no - fail

;------------------------------------------------------------------
; Sector read OK - return data info
;------------------------------------------------------------------
        LD A,(FDD_CMD+2)               ;0D9A get status byte
        LD BC,(SAVED_DE)                ;0D9D get byte count
        LD HL,IO_BUFFER                 ;0DA1 point to data
        OR A                            ;0DA4 set flags from status
        POP DE                          ;0DA5 restore parameters
        RET                             ;0DA6

READ_SEC_FAIL:
        SCF                             ;0DA7 set carry = error
        POP DE                          ;0DA8 restore parameters
        RET                             ;0DA9

;******************************************************************
;******************************************************************
;
;  READ_MULTI ($0DAA-$0DEB)
;
;  Multi-sector sequential read. Reads data from FDD in
;  256-byte chunks until DATA_LEN_REM bytes have been
;  transferred to MEM_ADDR.
;
;******************************************************************
;******************************************************************

READ_MULTI:
        PUSH BC                         ;0DAA save registers
        PUSH DE                         ;0DAB
        PUSH HL                         ;0DAC

READ_MULTI_LOOP:
        DEC HL                          ;0DAD \ These bytes encode:
        LD B,L                          ;0DAE | setup for 256-byte chunk read
        LD HL,$0011                     ;0DAF | DE parameter
        LD BC,$EDB7                     ;0DB2 | (LDIR prefix in encoded form)
        LD D,D                          ;0DB5 |

        JR NC,READ_MULTI_CHUNK         ;0DB6 have data to read

;------------------------------------------------------------------
; Check remaining length
;------------------------------------------------------------------
        LD HL,(DATA_LEN_REM)            ;0DB8 get remaining bytes
        LD A,L                          ;0DBB check if zero
        OR H                            ;0DBC
        JR Z,READ_MULTI_DONE           ;0DBD zero - all done

        EX DE,HL                        ;0DBF DE = remaining
        LD HL,$0200                     ;0DC0 256-byte chunk

READ_MULTI_CHUNK:
        LD (DATA_LEN_REM),HL            ;0DC3 update remaining
        CALL READ_SECTOR               ;0DC6 read one sector
        JR C,READ_MULTI_ERR            ;0DC9 error
        JR Z,READ_MULTI_COPY           ;0DCB success

        CP $48                          ;0DCD status $48?
        JR NZ,READ_MULTI_STATUS        ;0DCF no - other status

READ_MULTI_COPY:
        PUSH AF                         ;0DD1 save status
        LD A,B                          ;0DD2 check byte count
        OR C                            ;0DD3
        JR Z,READ_MULTI_DONE2         ;0DD4 zero bytes - done

;------------------------------------------------------------------
; Copy sector data to destination
;------------------------------------------------------------------
        LD DE,(MEM_ADDR)                ;0DD6 get destination
        LDIR                            ;0DDA copy data
        LD (MEM_ADDR),DE                ;0DDC update destination pointer
        POP AF                          ;0DE0 restore status
        JR READ_MULTI_LOOP              ;0DE1 next sector

READ_MULTI_DONE:
        XOR A                           ;0DE3 success
        JR READ_MULTI_ERR              ;0DE4

READ_MULTI_DONE2:
        POP AF                          ;0DE6 restore status

READ_MULTI_STATUS:
        OR A                            ;0DE7 set flags

READ_MULTI_ERR:
        POP HL                          ;0DE8 restore registers
        POP DE                          ;0DE9
        POP BC                          ;0DEA
        RET                             ;0DEB

;******************************************************************
;******************************************************************
;
;  LOAD_BASIC_PROG ($0DEC-$0E4A)
;
;  Load a BASIC program into memory.
;  Adjusts PROG, VARS, NEWPPC system variables.
;  Calls HOME ROM to make space and update pointers.
;
;******************************************************************
;******************************************************************

LOAD_BASIC_PROG:
        LD A,(PROG_LOAD_FLG)            ;0DEC check program load flag
        OR A                            ;0DEF
        JR NZ,$+69                      ;0DF0 non-zero - alternate path

;------------------------------------------------------------------
; Standard BASIC program load
;------------------------------------------------------------------
        PUSH IX                         ;0DF2 save IX

        LD DE,(PROG)                    ;0DF4 get PROG address
        LD HL,(E_LINE)                  ;0DF8 get E_LINE address
        DEC HL                          ;0DFB point to last byte

;------------------------------------------------------------------
; Delete existing program
;------------------------------------------------------------------
        LD C,(IX+$03)                   ;0DFC get new program length low
        LD B,(IX+$04)                   ;0DFF get new program length high
        PUSH BC                         ;0E02 save length
        RST $10                         ;0E03 call HOME ROM...
        DEFW $174D                      ;0E04 ...RECLAIM (delete old program)
        POP BC                          ;0E06 restore length

;------------------------------------------------------------------
; Make room for new program
;------------------------------------------------------------------
        RST $10                         ;0E07 call HOME ROM...
        DEFW $12BB                      ;0E08 ...BC_SPACES (make room)
        INC HL                          ;0E0A adjust pointer

;------------------------------------------------------------------
; Set VARS pointer
;------------------------------------------------------------------
        LD C,(IX+$05)                   ;0E0B get VARS offset low
        LD B,(IX+$06)                   ;0E0E get VARS offset high
        ADD HL,BC                       ;0E11 calculate VARS address
        LD (VARS),HL                    ;0E12 store VARS

;------------------------------------------------------------------
; Set auto-start line (NEWPPC)
;------------------------------------------------------------------
        LD L,(IX+$01)                   ;0E15 get auto-start line low
        LD H,(IX+$02)                   ;0E18 get auto-start line high
        LD (NEWPPC),HL                  ;0E1B store in NEWPPC

;------------------------------------------------------------------
; Set NSPPC (statement number)
;------------------------------------------------------------------
        LD A,H                          ;0E1E check if line is zero
        OR L                            ;0E1F
        LD A,$00                        ;0E20 default NSPPC = 0
        JR NZ,SET_NSPPC                 ;0E22 non-zero line
        DEC A                           ;0E24 line 0 -> NSPPC = $FF

SET_NSPPC:
        LD (NSPPC),A                    ;0E25 store statement number

;------------------------------------------------------------------
; Set MEM_ADDR to PROG for data transfer
;------------------------------------------------------------------
        LD HL,(PROG)                    ;0E28 get program start
        LD (MEM_ADDR),HL                ;0E2B store as destination

        POP HL                          ;0E2E restore IX (was pushed as HL)

LOAD_BASIC_OK:
        XOR A                           ;0E2F success
        RET                             ;0E30

;------------------------------------------------------------------
; Alternate BASIC load path (PROG_LOAD_FLG != 0)
;------------------------------------------------------------------
LOAD_BASIC_ALT:
        LD A,$FF                        ;0E31 flag = $FF
        POP HL                          ;0E33 restore IX

        SET 3,L                         ;0E34 (flag manipulation)
        LD C,(HL)                       ;0E36
        INC BC                          ;0E37
        LD B,(IX+$04)                   ;0E38
        INC BC                          ;0E3B

        RST $10                         ;0E3C call HOME ROM...
        DEFW $0030                      ;0E3D ...make space

        EX DE,HL                        ;0E3F swap pointers
        LD (MEM_ADDR),HL                ;0E40 store destination
        LD (FILE_SIZE),HL               ;0E43 store for later

        XOR A                           ;0E46 clear flag
        LD (PROG_LOAD_FLG),A            ;0E47 clear program load flag
        RET                             ;0E4A

;******************************************************************
;******************************************************************
;
;  FDD_CHECK_OK ($0E4B-$0E6C)
;
;  Receive a response frame from FDD and verify it was
;  successful ($80 status with zero error code).
;
;  Returns: Z = success, NZ = failure, C = comms error
;
;******************************************************************
;******************************************************************

FDD_CHECK_OK:
        CALL FDD_RECV_FRAME             ;0E4B receive response frame
        JR Z,CHECK_OK_GOT_FRAME        ;0E4E got a frame

;------------------------------------------------------------------
; Receive failed - report to HOME ROM
;------------------------------------------------------------------
        RST $10                         ;0E50 call HOME ROM...
        DEFW $0938                      ;0E51 ...error handler
        DEFW $0440                      ;0E53 (error address)
        JR FDD_CHECK_OK                 ;0E56 retry

CHECK_OK_GOT_FRAME:
        LD A,(FRAME_TYPE)               ;0E58 get frame type
        CP $C0                          ;0E5B command response?
        JR NZ,CHECK_OK_FAIL            ;0E5D no - not what we expected

        LD A,(FDD_CMD)                  ;0E5F get status code
        CP $80                          ;0E62 $80 = OK?
        JR NZ,CHECK_OK_FAIL            ;0E64 no

        LD A,(FDD_CMD+2)               ;0E66 get error code
        OR A                            ;0E69 zero = no error
        RET                             ;0E6A Z if success, NZ if error

CHECK_OK_FAIL:
        SCF                             ;0E6B set carry = comms error
        RET                             ;0E6C

;******************************************************************
;******************************************************************
;
;  OPEN EXEC / PUVI DRIVE SELECT ($0E6D-$0EAF)
;
;  OPEN execution handler and PUVI (drive letter) selection.
;  Maps P/U/V/I to drive numbers 0-3.
;
;******************************************************************
;******************************************************************

;==================================================================
; OPEN_EXEC ($0E6D)
; Execute OPEN command. If SECONDARY_FLG set, sends drive select.
; Otherwise prepares buffer and sends OPEN command.
;==================================================================
OPEN_EXEC:
        LD A,(SECONDARY_FLG)            ;0E6D get secondary flag
        OR A                            ;0E70 set?
        JR Z,OPEN_DEFAULT               ;0E71 no - default open

;------------------------------------------------------------------
; Drive-specific OPEN
;------------------------------------------------------------------
        LD A,(FILE_TYPE)                ;0E73 get file type
        LD (FDD_CMD+2),A               ;0E76 store as parameter
        LD A,$11                        ;0E79 extended open command
        JP CLOSE_SEND                   ;0E7B send it

OPEN_DEFAULT:
        CALL PREP_BUFFER                ;0E7E prepare buffer
        CALL SEND_DATA                  ;0E81 send data
        LD A,FDD_OPEN_FILE              ;0E84 open file command ($15)
        JP SET_CMD_AND_SEND             ;0E86 send it

;==================================================================
; PUVI_HANDLER ($0E89)
; Drive select handler. Maps drive letter to number:
;   P = drive 1, U = drive 0, V = drive 2, I = drive 3
;==================================================================
PUVI_HANDLER:
        LD A,(VAR_NAME)                 ;0E89 get drive letter
        LD B,$01                        ;0E8C default = drive 1

        CP 'P'                          ;0E8E P = drive 1
        JR Z,PUVI_SEND                 ;0E90

        LD B,$00                        ;0E92
        CP 'U'                          ;0E94 U = drive 0
        JR Z,PUVI_SEND                 ;0E96

        LD B,$02                        ;0E98
        CP 'V'                          ;0E9A V = drive 2
        JR Z,PUVI_SEND                 ;0E9C

        LD B,$03                        ;0E9E I = drive 3

PUVI_SEND:
        PUSH BC                         ;0EA0 save drive number
        CALL PREP_BUFFER                ;0EA1 prepare buffer
        CALL SEND_DATA                  ;0EA4 send buffer

        LD A,FDD_DRIVE_SEL              ;0EA7 drive select command ($14)
        LD (FDD_CMD),A                  ;0EA9 store command
        POP AF                          ;0EAC get drive number
        JP SEND_CMD                     ;0EAD send to FDD

;******************************************************************
;******************************************************************
;
;  HW_INIT ($0EB0-$0EF5)
;
;  Hardware initialization. Probes the FDD 3000 controller by
;  sending PROBE command ($17). Retries up to 255 times.
;  On success, receives boot code from FDD and executes it.
;  On failure, falls through to HOME ROM.
;
;******************************************************************
;******************************************************************

HW_INIT:
        LD SP,$6200                     ;0EB0 set stack in safe area
        LD B,$FF                        ;0EB3 255 retry attempts

PROBE_RETRY:
        LD A,$C0                        ;0EB5 frame type = command
        LD (FRAME_TYPE),A               ;0EB7 store
        LD A,$0D                        ;0EBA payload = 13 bytes
        LD (PAYLOAD_LEN),A              ;0EBC store
        LD HL,FDD_CMD                   ;0EBF point to command buffer
        LD (HL),FDD_PROBE               ;0EC2 store PROBE command ($17)
        CALL FDD_SEND_FRAME             ;0EC4 try to send
        JR Z,PROBE_OK                   ;0EC7 success - FDD responded

        DJNZ PROBE_RETRY                ;0EC9 retry

;------------------------------------------------------------------
; Probe failed - no FDD found, fall through to HOME ROM
;------------------------------------------------------------------
PROBE_FAIL:
        LD HL,$0001                     ;0ECB push $0001 as address
        PUSH HL                         ;0ECE (will RET to HOME ROM RST 0)
        JP BANK_RETURN_RET              ;0ECF switch to HOME ROM

;------------------------------------------------------------------
; FDD probe successful - receive boot code
;------------------------------------------------------------------
PROBE_OK:
        CALL $0395                      ;0ED2 receive response
        OR A                            ;0ED5
        JR NZ,PROBE_FAIL               ;0ED6 error - give up

;------------------------------------------------------------------
; Copy boot program to RAM and execute it
;------------------------------------------------------------------
        LD (IO_BUFFER),HL               ;0ED8 save HL
        LD HL,BOOT_PROGRAM              ;0EDB source = boot program in ROM
        LD DE,$6880                     ;0EDE destination in RAM
        LD BC,$005F                     ;0EE1 95 bytes
        LDIR                            ;0EE4 copy to RAM

        LD A,$01                        ;0EE6 set pending return flag
        LD (FDD_FLAGS),A                ;0EE8 store in flags

        LD HL,$6880                     ;0EEB push boot program address
        PUSH HL                         ;0EEE
        LD DE,(IO_BUFFER)               ;0EEF restore saved HL in DE
        JP BANK_RETURN_RET              ;0EF3 execute boot program

;******************************************************************
;******************************************************************
;
;  INSTALL_HOOK ($0EF6-$0F0D)
;
;  Patch the EXROM at $658C to redirect command processing
;  to the FDD ROM. Copies the RST8_RELAY code ($05A5) over
;  the EXROM's command dispatch point.
;
;  This is how the FDD intercepts BASIC commands.
;
;******************************************************************
;******************************************************************

INSTALL_HOOK:
        LD DE,$658C                     ;0EF6 EXROM patch point
        LD HL,RST8_RELAY                ;0EF9 source = our hook code
        LD BC,$0007                     ;0EFC 7 bytes
        LDIR                            ;0EFF copy hook code

        LD A,$01                        ;0F01 set pending return flag
        LD (FDD_FLAGS),A                ;0F03

        LD HL,$6815                     ;0F06 return address in RAM
        PUSH HL                         ;0F09
        LD HL,$0AE7                     ;0F0A HOME ROM continuation
        JP BANK_RETURN_RET              ;0F0D switch to HOME ROM

;******************************************************************
;******************************************************************
;
;  POST_BOOT ($0F10-$0F5E)
;
;  Called after initial boot code executes. Restores the EXROM
;  patch point with DD E9 (JP (IX)), sends INIT command ($07)
;  to FDD, and installs a BASIC auto-run program.
;
;******************************************************************
;******************************************************************

POST_BOOT:
;------------------------------------------------------------------
; Restore EXROM patch: write DD E9 = JP (IX) at $658C
;------------------------------------------------------------------
        LD HL,$658C                     ;0F10 EXROM patch point
        LD (HL),$DD                     ;0F13 write $DD (IX prefix)
        INC HL                          ;0F15
        LD (HL),$E9                     ;0F16 write $E9 (JP (IX))

;------------------------------------------------------------------
; Send INIT command ($07) to FDD
;------------------------------------------------------------------
        LD A,FDD_INIT                   ;0F18 init command ($07)
        LD (FDD_CMD),A                  ;0F1A store command

;------------------------------------------------------------------
; Copy "START" string to buffer
;------------------------------------------------------------------
        LD HL,$05AF                     ;0F1D source = "START" in ROM
        LD DE,IO_BUFFER                 ;0F20 destination = $2000
        LD BC,$0005                     ;0F23 5 bytes
        LDIR                            ;0F26 copy

;------------------------------------------------------------------
; Send data and init command
;------------------------------------------------------------------
        LD A,$06                        ;0F28 6-byte payload
        CALL SEND_DATA                  ;0F2A send data
        CALL SEND_CMD                   ;0F2D send init command

;------------------------------------------------------------------
; Receive response and check
;------------------------------------------------------------------
        CALL $0395                      ;0F30 receive response
        CP '!'                          ;0F33 success marker?
        JR NZ,POST_BOOT_NOAUTO        ;0F35 no - skip auto-run

;------------------------------------------------------------------
; Install auto-run BASIC program
;------------------------------------------------------------------
        LD HL,(E_LINE)                  ;0F37 get edit line address
        LD BC,$0009                     ;0F3A 9 bytes to insert
        CALL CALL_HOME                  ;0F3D call HOME ROM...
        DEFW $12BB                      ;0F40 ...BC_SPACES (make room)
        INC HL                          ;0F42 adjust pointer
        EX DE,HL                        ;0F43

;------------------------------------------------------------------
; Copy embedded RUN "START" line into BASIC area
;------------------------------------------------------------------
        LD HL,BASIC_RUN_START           ;0F44 source = RUN "START" line
        LD BC,$0009                     ;0F47 9 bytes
        LDIR                            ;0F4A copy

;------------------------------------------------------------------
; Set up for program execution
;------------------------------------------------------------------
        LD DE,$0E55                     ;0F4C continuation address
        JR POST_BOOT_CONTINUE           ;0F4F

POST_BOOT_NOAUTO:
        LD DE,LOAD_BASIC_OK             ;0F51 no auto-run - simple return

POST_BOOT_CONTINUE:
        LD SP,$6200                     ;0F54 reset stack
        LD HL,$003E                     ;0F57 HOME ROM return point
        PUSH HL                         ;0F5A
        PUSH DE                         ;0F5B push continuation
        JP BANK_RETURN                  ;0F5C switch to HOME ROM

;******************************************************************
;******************************************************************
;
;  BOOT PROGRAM ($0F5F-$0F97)
;
;  Auto-run startup code that gets copied to RAM at $6880
;  and executed during the boot process. Displays the
;  copyright message and version info, then transfers to
;  the copyright string display.
;
;******************************************************************
;******************************************************************

BOOT_PROGRAM:
;------------------------------------------------------------------
; Format version number from FDD response
;------------------------------------------------------------------
        LD HL,$68D8                     ;0F5F target in RAM for version digit
        LD A,D                          ;0F62 get version byte
        RRD                             ;0F63 rotate nibbles (BCD)
        ADD A,'1'                       ;0F65 convert to ASCII
        LD (HL),A                       ;0F67 store first digit
        INC HL                          ;0F68
        INC HL                          ;0F69
        LD A,D                          ;0F6A get version again
        AND $0F                         ;0F6B mask low nibble
        ADD A,$B1                       ;0F6D convert to printable
        LD (HL),A                       ;0F6F store second digit

;------------------------------------------------------------------
; Copy copyright string to RAM
;------------------------------------------------------------------
        LD HL,$0D55                     ;0F70 source address (in ROM space)
        LD DE,$68DF                     ;0F73 destination in RAM
        LD BC,$00B3                     ;0F76 179 bytes
        LDIR                            ;0F79 copy

;------------------------------------------------------------------
; Copy additional data
;------------------------------------------------------------------
        LD HL,$68DC                     ;0F7B source
        LD BC,$0003                     ;0F7E 3 bytes
        LDIR                            ;0F81 copy

;------------------------------------------------------------------
; Jump to display routine in RAM
;------------------------------------------------------------------
        LD HL,$0000                     ;0F83 line number 0
        LD B,$00                        ;0F86 statement 0
        JP $68DF                        ;0F88 execute display code in RAM

;------------------------------------------------------------------
; Additional boot helper (called during init)
;------------------------------------------------------------------
BOOT_HELPER:
        LD DE,$68B9                     ;0F8B destination
        CALL REPLACE_RETURN             ;0F8E replace return addr
        LD HL,INSTALL_HOOK              ;0F91 push hook installer
        PUSH HL                         ;0F94
        JP RST_08                       ;0F95 trigger RST $08

;******************************************************************
;******************************************************************
;
;  COPYRIGHT STRING ($0F98-$0FBD)
;
;  "1985 TMX Portugal - TOS V  ."
;  Stored as raw ASCII with control bytes.
;  The version number digits are patched in by BOOT_PROGRAM.
;
;******************************************************************
;******************************************************************

COPYRIGHT:
        DEFB $80                        ;0F98 control byte (inverse/highlight)
        DEFB $0D,$0D                    ;0F99 two carriage returns
        DEFB $7F                        ;0F9B copyright symbol
        DEFM " 1985 TMX Portugal"       ;0F9C
        DEFM " - TOS V  ."             ;0FAE version (digits patched)
        DEFB $8D                        ;0FBA control byte
        JP $68AC                        ;0FBB jump to continuation in RAM

;------------------------------------------------------------------
; $0FBE-$0FFF: Unused padding (all $FF)
;------------------------------------------------------------------
        DEFS 66,$FF                     ;0FBE-$0FFF end of 4KB ROM

; End of FDD 3000 ROM disassembly
