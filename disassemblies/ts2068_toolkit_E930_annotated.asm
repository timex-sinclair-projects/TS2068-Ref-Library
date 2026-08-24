;=====================================================================
; TS 2068 TOOLKIT  —  Bob Mitchell, 1985
; Annotated disassembly of the machine-code block at $E930-$FF57
;=====================================================================
;
; WHAT IT IS
;   A menu-driven BASIC programmer's toolkit for the Timex/Sinclair
;   2068.  26 commands (A-Z) covering renumber, move/copy/delete line
;   blocks, search & replace, REM creation for machine code, a UDG
;   designer, a line sorter, memory/trace displays and a NEW-key lock.
;   The author's name appears at $F113 ("BOB MITCHELL 1985") and is
;   printed as message 51 on the bottom line of the menu.
;
; LOAD ADDRESS
;   ORG $E930.  The code runs above RAMTOP, so the host BASIC must
;   CLEAR 59695 ($E92F) or lower before loading.  Nothing is
;   relocatable — every internal reference is absolute.
;
; ENTRY POINTS
;   $E930  IM2_INIT   build the IM2 vector table, set I.  Call once
;                     after loading (e.g. RANDOMIZE USR 59696).
;   $EA60  MAIN       the toolkit itself (RANDOMIZE USR 60000).
;
; MEMORY USED OUTSIDE THE CODE BLOCK
;   $E800-$E900  257-byte IM2 vector table, every byte = $E9
;   $E9E9-$E9EB  JP $FEFF   (the actual interrupt service routine)
;
;---------------------------------------------------------------------
; A NOTE ON THE ORIGINAL DISASSEMBLY
;---------------------------------------------------------------------
;   Roughly half of this program is *inline data* following CALL
;   instructions — the routines at $ED8F/$ED92/$ED97 pop their own
;   return address and interpret the bytes that follow as a display
;   /prompt script.  A plain linear disassembler therefore runs off
;   the rails at every command handler and mis-types the following
;   code as data (and the data as code).  Every such block is marked
;   below with the pseudo-op DEFB and decoded in comments.
;
;---------------------------------------------------------------------
; THE INLINE SCRIPT LANGUAGE  (interpreted by $ED99)
;---------------------------------------------------------------------
;   Registers carried through a script:  HL = "current value",
;   DE = script pointer.
;
;   $00        end of script.  Print "\r\r EXECUTE? ", read a key;
;              "Y" prints "Y\r\r" and execution resumes at the byte
;              after the $00; anything else restores SP from
;              SAVED_SP and drops back to the main menu.
;   $01-$0F    printable control character (mainly $0D = newline)
;   $10        print "#" then HL as four hex digits
;   $11 nn     input a string (max 33 chars) into buffer 0 (nn=$00)
;              or buffer 1 (nn<>$00)
;   $12 nn     print string buffer 0 / 1
;   $13        input a number into HL.  Decimal, or "#hhhh" for hex
;   $14        print HL as decimal, leading zeros suppressed
;   $15        error 4 "Zero not Allowed" if HL = 0
;   $16        error 1 "Range Error"        if P_INCR  > 100
;   $17        error 3 "Invalid Line Number" if P_DEST or P_FINISH
;                                              > 9996
;   $18        error 2 "Numbers Reversed"   if P_START > P_FINISH
;   $19        end of script — resume execution at the next byte,
;              with stream 2 (upper screen) selected
;   $1A-$1F    store HL into parameter slot 0..5
;              ($ECCB P_START, $ECCD P_FINISH, $ECCF P_DEST,
;               $ECD1 P_INCR, $ECD3 P_WORK1, $ECD5 P_WORK2)
;   $20-$7E    printable ASCII
;   $7F        print " ©"  (only when the channel is 'S' or 'P')
;   $80-$BF    print " " + MSGTAB message (b AND $3F) + ": "
;   $C0-$FF    print " " + MSGTAB message (b AND $3F)
;
;---------------------------------------------------------------------
; MSGTAB word list (base $EFFA, index = byte AND $3F)
;---------------------------------------------------------------------
;    0 ADDRESS      1 START       2 FINISH      3 1st
;    4 UNAFFECTED   5 DESTINATION 6 INCREMENT   7 LINE
;    8 NUMBER       9 DELETE     10 MOVE       11 COPY
;   12 RENUMBER    13 BLOCK      14 OF         15 PROGRAM
;   16 MACHINE     17 CODE       18 UDGs       19 TO
;   20 DATA        21 SEARCH     22 LIST       23 REPLACE
;   24 OLD         25 NEW        26 STRING     27 REM
;   28 UPPER       29 lower      30 CASE       31 DEC
;   32 HEX         33 MERGE      34 ? (0=no)   35 CREATE
;   36 SYMBOL      37 BYTES      38 PER        39 bytes
;   40 STATUS      41 REPORT     42 MEMORY     43 LEFT
;   44 LENGTH      45 VARIABLE   46 FILE       47 USER RAM
;   48 INTERRUPTS  49 NORMAL     50 DIVERTED   51 BOB MITCHELL 1985
;   52 DESIGN      53 CHARACTER  54 USE        55 COMPACT
;   56 COLUMN      57 I/O (on/off)             58 IN QUOTES? (Y/N)
;   59 AUTO        60 ABCDEFGH   61 RESTART    62 <CR><CR>
;   63 (c)
;
;   Note: the ROM's PUTMES skips one terminator before message 0, so
;   the byte AT the table base ($EFFA = $8D) is a dummy terminator and
;   message 0 is the first string after it.  Verified two ways: $EFEB
;   +0 gives " EXECUTE? " and $F17B/$F17E give "HEX"/"DEC"+"IMAL".
;
;---------------------------------------------------------------------
; ROM ENTRY POINTS USED  (all verified against the TS2068 HOME ROM)
;---------------------------------------------------------------------
PARP    EQU $03F3   ; tone.  DE = cycles-1, HL = period
PUTMES  EQU $073F   ; print message A from table at DE
K_CLS   EQU $08A6   ; clear screen
CLLHS   EQU $08A9   ; clear/attr left-hand side
EDIT_K  EQU $0A82   ; the line editor
DELSYM  EQU $0B7E   ; delete the single byte at (HL)
PUTDIG  EQU $11EA   ; send decimal digit A to current channel
SELECT  EQU $1230   ; select stream A
SEL_HL  EQU $1248   ; select the channel whose address is in HL
INSERT  EQU $12BB   ; make BC bytes of room at (HL)
X_CALC  EQU $134E   ; STKBOT = WORKSP, reset fp stack
PUT_SR  EQU $15A1   ; ">" / current-line marker
OUTNUM  EQU $1676   ; decimal digit of HL, BC = -power of ten
SKIPNUM EQU $1602   ; if A = $0E skip the 5-byte number, reload A
FIND_L  EQU $16D6   ; find line >= HL; DE = previous line
RECLEN  EQU $1720   ; DE = next record, BC = length
DEL_DE  EQU $174D   ; delete the bytes between HL and DE
DELREC  EQU $1750   ; delete BC bytes at (HL)
PUT_BC  EQU $1788   ; print BC as a decimal line number
CHK_SZ  EQU $1FBB   ; error 4 unless BC bytes are free below RAMTOP
PAUSE   EQU $1FF2   ; HALT / decrement BC / test KEYHIT
PO_STR  EQU $21DB   ; print BC characters from (DE)
ALPHAQ  EQU $304B   ; CY set if A is a letter
STKUSN  EQU $3059   ; stack the number at CH_ADD
DIGITQ  EQU $30D9   ; NC if A is '0'-'9'
MULT    EQU $3468   ; HL = HL * DE
;
; System variables (identical to the ZX Spectrum in this range)
LASTK   EQU $5C08
FLAGS   EQU $5C3B
TVFLAG  EQU $5C3C
PPC     EQU $5C45
EPPC    EQU $5C49
VARS    EQU $5C4B
CURCHL  EQU $5C51
PROG    EQU $5C53
ELINE   EQU $5C59
KCUR    EQU $5C5B
CH_ADD  EQU $5C5D
WORKSP  EQU $5C61
STKBOT  EQU $5C63
STKEND  EQU $5C65
FLAGX   EQU $5C71
UDG     EQU $5C7B
ECHOE   EQU $5C82
SCRCT   EQU $5C8C
RAMTOP  EQU $5CB2

        ORG $E930

;=====================================================================
; IM2_INIT  ($E930)
; Build the interrupt-mode-2 vector table and point I at it.
; Does NOT enable IM2 — commands N/Q/T/W do that via SET_IM2.
;=====================================================================
IM2_INIT:
$E930  C5           PUSH BC
$E931  D5           PUSH DE
$E932  E5           PUSH HL
$E933  F5           PUSH AF
$E934  21 00 E8     LD HL,$E800        ; vector table base (I = $E8)
$E937  06 00        LD B,$00           ; 256 iterations
IM2_FILL:
$E939  36 E9        LD (HL),$E9        ; every entry byte = $E9 ...
$E93B  23           INC HL
$E93C  10 FB        DJNZ IM2_FILL
$E93E  36 E9        LD (HL),$E9        ; ... plus the 257th byte at $E900
                                       ; so any data-bus value yields $E9E9
$E940  3E C3        LD A,$C3           ; plant JP $FEFF at $E9E9
$E942  32 E9 E9     LD ($E9E9),A
$E945  21 FF FE     LD HL,$FEFF        ; = ISR
$E948  22 EA E9     LD ($E9EA),HL
$E94B  3E E8        LD A,$E8
$E94D  ED 47        LD I,A
$E94F  F1           POP AF
$E950  E1           POP HL
$E951  D1           POP DE
$E952  C1           POP BC
$E953  C9           RET

;---------------------------------------------------------------------
; $E954-$E9E8   149 spare bytes (all $00)
;---------------------------------------------------------------------
$E954  DEFS 149,$00

;---------------------------------------------------------------------
; $E9E9  the IM2 vector target itself.  Written by IM2_INIT, but the
;        loaded image already contains the finished instruction.
;---------------------------------------------------------------------
$E9E9  C3 FF FE     JP ISR

;---------------------------------------------------------------------
; $E9EC-$EA5F   116 spare bytes (all $00)
;---------------------------------------------------------------------
$E9EC  DEFS 116,$00

;=====================================================================
; MAIN  ($EA60)  —  the menu
; Stacks its own address so every command RETurns here, and records SP
; so an aborted command can unwind (see EF67/ABORT).
;=====================================================================
MAIN:
$EA60  21 60 EA     LD HL,MAIN
$EA63  E5           PUSH HL            ; command handlers RET to MAIN
$EA64  ED 73 C9 EC  LD (SAVED_SP),SP   ; unwind point for "not Y" / errors
$EA68  21 46 EF     LD HL,$EF46        ; HL -> "CALL REPORT / DEFB 0"
                                       ; ("Task Complete" trampoline, used
                                       ;  as the value seed for scripts)
$EA6B  E5           PUSH HL
$EA6C  CD 8F ED     CALL SCRIPT_CLS    ; clear screen, run the script below
;---------------------------------------------------------------------
; Inline script: the menu page.  16 rows of two 16-column halves.
;---------------------------------------------------------------------
$EA6F  DEFB $0D
$EA70  DEFM "        TS 2068  TOOLKIT"
$EA88  DEFB $0D,$0D
$EA8A  DEFM "A Alter Program N Autoline On   "
$EAAA  DEFM "B Bytes to DATA O Locate Token  "
$EACA  DEFM "C Copy Lines    P Compactor     "
$EAEA  DEFM "D Delete lines  Q Display Memory"
$EB0A  DEFM "E REM Create    R Renumber      "
$EB2A  DEFM "F REM Delete    S Search & List "
$EB4A  DEFM "G UDG Designer  T Trace on      "
$EB6A  DEFM "H Hex & Dec     U UDGs to DATA  "
$EB8A  DEFM "I Information   V List Variables"
$EBAA  DEFM "J Merge Lines   W Disable NEW   "
$EBCA  DEFM "K Upper Case    X N/Q/T/W off   "
$EBEA  DEFM "L Lower Case    Y Uncorrupt     "
$EC0A  DEFM "M Move Lines    Z Line Sort     "
$EC2A  DEFB $0D,$0D
$EC2C  DEFM " PRESS A KEY FOLLOWED BY ENTER,"
$EC4B  DEFB $0D
$EC4C  DEFM " or just ENTER anytime for menu"
$EC6B  DEFB $FE               ; MSG 62 = <CR><CR>
$EC6C  DEFB $7F               ; " ©"
$EC6D  DEFB $F3               ; MSG 51 = "BOB MITCHELL 1985"
$EC6E  DEFB $0D
$EC6F  DEFB $19               ; end of script; resume below on stream 2

;---------------------------------------------------------------------
; Read the command letter and vector through CMDTAB.
;---------------------------------------------------------------------
GETCMD:
$EC70  01 02 00     LD BC,$0002        ; accept up to 2 characters
$EC73  CD F7 EE     CALL INPUT         ; A = first char (ENTER alone aborts)
$EC76  CD 4B 30     CALL ALPHAQ
$EC79  30 F5        JR NC,GETCMD       ; not a letter — ask again
$EC7B  E6 DF        AND $DF            ; force upper case
$EC7D  D6 41        SUB 'A'
$EC7F  87           ADD A,A            ; *2
$EC80  21 1D ED     LD HL,CMDTAB
$EC83  5F           LD E,A
$EC84  16 00        LD D,$00
$EC86  19           ADD HL,DE
$EC87  5E           LD E,(HL)
$EC88  23           INC HL
$EC89  56           LD D,(HL)
$EC8A  D5           PUSH DE
$EC8B  C9           RET                ; jump to the handler
                                       ; (which RETs to MAIN)

;=====================================================================
; PRHEX4  ($EC8C)  print "#" followed by HL in hex
;=====================================================================
PRHEX4:
$EC8C  3E 23        LD A,'#'
$EC8E  D7           RST $10
$EC8F  7C           LD A,H
$EC90  CD 9E EC     CALL PRHIGH
$EC93  7C           LD A,H
$EC94  CD A2 EC     CALL PRLOW
$EC97  7D           LD A,L
$EC98  CD 9E EC     CALL PRHIGH
$EC9B  7D           LD A,L
$EC9C  18 04        JR PRLOW
PRHIGH:
$EC9E  1F           RRA                ; high nibble -> low
$EC9F  1F           RRA
$ECA0  1F           RRA
$ECA1  1F           RRA
PRLOW:
$ECA2  E6 0F        AND $0F
$ECA4  FE 0A        CP $0A
$ECA6  38 02        JR C,PRNIB
$ECA8  C6 07        ADD A,$07          ; 'A'-'F'
PRNIB:
$ECAA  C3 EA 11     JP PUTDIG          ; adds $30 and prints

;=====================================================================
; PRDEC  ($ECAD)  print HL as decimal, leading zeros suppressed
; E = $FF is the ROM's "still suppressing" flag for OUTNUM.
;=====================================================================
PRDEC:
$ECAD  1E FF        LD E,$FF
$ECAF  01 F0 D8     LD BC,-10000
$ECB2  CD 76 16     CALL OUTNUM
$ECB5  01 18 FC     LD BC,-1000
$ECB8  CD 76 16     CALL OUTNUM
$ECBB  01 9C FF     LD BC,-100
$ECBE  CD 76 16     CALL OUTNUM
$ECC1  0E F6        LD C,$F6           ; BC = -10  (B is still $FF)
$ECC3  CD 76 16     CALL OUTNUM
$ECC6  7D           LD A,L             ; units
$ECC7  18 E1        JR PRNIB

;=====================================================================
; WORKSPACE  ($ECC9-$ED1C)
; The values below are whatever the last session left behind; they are
; the program's only mutable storage.
;=====================================================================
SAVED_SP:  $ECC9  DEFW $61E2   ; SP on entry to MAIN — unwind target
P_START:   $ECCB  DEFW $0001   ; script slot $1A
P_FINISH:  $ECCD  DEFW $0FA0   ; script slot $1B
P_DEST:    $ECCF  DEFW $0FA0   ; script slot $1C
P_INCR:    $ECD1  DEFW $000A   ; script slot $1D
P_WORK1:   $ECD3  DEFW $7747   ; script slot $1E
P_WORK2:   $ECD5  DEFW $0006   ; script slot $1F
STR0_LEN:  $ECD7  DEFW $0001   ; string buffer 0 (script codes $11/$12 nn=0)
STR0:      $ECD9  DEFB $4E,$00,$38,$30   ; "N" + stale bytes from last run
           $ECDD  DEFS 29,$00            ; STR0 is 33 bytes: $ECD9-$ECF9
STR1_LEN:  $ECFA  DEFW $0000   ; string buffer 1 (script codes $11/$12 nn<>0)
STR1:      $ECFC  DEFS 33,$00  ; $ECFC-$ED1C, ends exactly at CMDTAB

;=====================================================================
; CMDTAB  ($ED1D)  26 handler addresses, indexed by (letter-'A')*2
;=====================================================================
CMDTAB:
$ED1D  AD F1        DEFW $F1AD   ; A  Alter Program   (search & replace)
$ED1F  EE F6        DEFW $F6EE   ; B  Bytes to DATA
$ED21  9A F5        DEFW $F59A   ; C  Copy Lines
$ED23  10 F6        DEFW $F610   ; D  Delete lines
$ED25  3F F6        DEFW $F63F   ; E  REM Create
$ED27  EF F9        DEFW $F9EF   ; F  REM Delete
$ED29  81 FA        DEFW $FA81   ; G  UDG Designer
$ED2B  77 F1        DEFW $F177   ; H  Hex & Dec
$ED2D  25 F8        DEFW $F825   ; I  Information
$ED2F  A4 FC        DEFW $FCA4   ; J  Merge Lines
$ED31  F7 FC        DEFW $FCF7   ; K  Upper Case
$ED33  03 FD        DEFW $FD03   ; L  Lower Case
$ED35  24 F3        DEFW $F324   ; M  Move Lines
$ED37  74 FD        DEFW $FD74   ; N  Autoline On
$ED39  91 FE        DEFW $FE91   ; O  Locate Token
$ED3B  3C FC        DEFW $FC3C   ; P  Compactor
$ED3D  EB FD        DEFW $FDEB   ; Q  Display Memory
$ED3F  5C F3        DEFW $F35C   ; R  Renumber
$ED41  85 F9        DEFW $F985   ; S  Search & List
$ED43  F7 FD        DEFW $FDF7   ; T  Trace on
$ED45  B0 F6        DEFW $F6B0   ; U  UDGs to DATA
$ED47  DE F8        DEFW $F8DE   ; V  List Variables
$ED49  3E FF        DEFW $FF3E   ; W  Disable NEW
$ED4B  35 FF        DEFW $FF35   ; X  N/Q/T/W off
$ED4D  52 F4        DEFW $F452   ; Y  Uncorrupt   (= rebuild line lengths)
$ED4F  19 F5        DEFW $F519   ; Z  Line Sort

;=====================================================================
; PRCHAR  ($ED51)  print one script byte
;   < $7F   straight to the print routine
;   = $7F   " ©" — but only on a screen ('S') or printer ('P') channel
;   > $7F   " " + MSGTAB[A AND $3F], plus ": " when bit 6 is clear
;=====================================================================
PRCHAR:
$ED51  FE 7F        CP $7F
$ED53  28 04        JR Z,PRCOPY
$ED55  30 1A        JR NC,PRMSG
$ED57  D7           RST $10
$ED58  C9           RET
PRCOPY:
$ED59  4F           LD C,A
$ED5A  2A 51 5C     LD HL,(CURCHL)
$ED5D  23           INC HL             ; +4 = the channel's letter
$ED5E  23           INC HL
$ED5F  23           INC HL
$ED60  23           INC HL
$ED61  7E           LD A,(HL)
$ED62  FE 53        CP 'S'
$ED64  28 05        JR Z,PRCOPY2
$ED66  FE 50        CP 'P'
$ED68  79           LD A,C
$ED69  20 07        JR NZ,PRMSG2       ; other channel: treat $7F as a message
PRCOPY2:
$ED6B  3E 20        LD A,' '
$ED6D  D7           RST $10
$ED6E  79           LD A,C
$ED6F  D7           RST $10            ; the (c) symbol
$ED70  C9           RET
PRMSG:
$ED71  4F           LD C,A
PRMSG2:
$ED72  E6 3F        AND $3F            ; message number
$ED74  47           LD B,A
$ED75  C5           PUSH BC
$ED76  3E 20        LD A,' '
$ED78  D7           RST $10
$ED79  78           LD A,B
$ED7A  11 FA EF     LD DE,MSGTAB
$ED7D  FD CB 01 C6  SET 0,(IY+$01)     ; FLAGS bit 0 - leading space handling
$ED81  CD 3F 07     CALL PUTMES
$ED84  C1           POP BC
$ED85  CB 71        BIT 6,C
$ED87  C0           RET NZ             ; $C0-$FF: no colon
$ED88  3E 3A        LD A,':'
$ED8A  D7           RST $10
$ED8B  3E 20        LD A,' '
$ED8D  D7           RST $10
$ED8E  C9           RET

;=====================================================================
; THE SCRIPT ENGINE
;   SCRIPT_CLS ($ED8F)  clear screen, select stream $FE, run script
;   SCRIPT_FE  ($ED92)  select stream $FE, run script
;   SCRIPT     ($ED97)  run the script that follows the CALL
; None of these return to the instruction after the CALL: the return
; address IS the script, and control resumes at the $19 / $00 byte.
;=====================================================================
SCRIPT_CLS:
$ED8F  CD A6 08     CALL K_CLS
SCRIPT_FE:
$ED92  3E FE        LD A,$FE           ; stream $FE = whole screen, no scroll
$ED94  CD 30 12     CALL SELECT
SCRIPT:
$ED97  D1           POP DE             ; DE = address of the script bytes
$ED98  1B           DEC DE
SCR_LOOP:
$ED99  13           INC DE
$ED9A  1A           LD A,(DE)
$ED9B  A7           AND A
$ED9C  CA 34 EE     JP Z,SCR_END       ; $00 - "EXECUTE?"
$ED9F  FE 20        CP $20
$EDA1  30 43        JR NC,SCR_PRINT    ; >= $20 - printable / message
$EDA3  FE 10        CP $10
$EDA5  38 3F        JR C,SCR_PRINT     ; $01-$0F - control character
$EDA7  28 2E        JR Z,SCR_HEX       ; $10
$EDA9  FE 11        CP $11
$EDAB  28 52        JR Z,SCR_INSTR     ; $11
$EDAD  FE 12        CP $12
$EDAF  28 63        JR Z,SCR_OUTSTR    ; $12
$EDB1  FE 13        CP $13
$EDB3  28 3A        JR Z,SCR_INNUM     ; $13
$EDB5  FE 14        CP $14
$EDB7  28 3D        JR Z,SCR_OUTNUM    ; $14
$EDB9  FE 15        CP $15
$EDBB  28 21        JR Z,SCR_NZ        ; $15
$EDBD  FE 19        CP $19
$EDBF  CA 57 EE     JP Z,SCR_RESUME    ; $19
$EDC2  38 67        JR C,SCR_CHECK     ; $16/$17/$18 - validators
;   $1A-$1F: store HL into parameter slot A-$1A
$EDC4  D6 1A        SUB $1A
$EDC6  87           ADD A,A
$EDC7  4F           LD C,A
$EDC8  06 00        LD B,$00
$EDCA  D5           PUSH DE            ; save the script pointer
$EDCB  EB           EX DE,HL           ; DE = value
$EDCC  21 CB EC     LD HL,P_START
$EDCF  09           ADD HL,BC
$EDD0  73           LD (HL),E
$EDD1  23           INC HL
$EDD2  72           LD (HL),D
$EDD3  EB           EX DE,HL           ; HL = value again
$EDD4  D1           POP DE
$EDD5  18 C2        JR SCR_LOOP
SCR_HEX:
$EDD7  D5           PUSH DE
$EDD8  CD 8C EC     CALL PRHEX4
$EDDB  D1           POP DE
$EDDC  18 BB        JR SCR_LOOP
SCR_NZ:
$EDDE  7C           LD A,H
$EDDF  B5           OR L
$EDE0  20 B7        JR NZ,SCR_LOOP
$EDE2  CD 4A EF     CALL REPORT
$EDE5  04           DEFB 4             ; "Zero not Allowed"
SCR_PRINT:
$EDE6  D5           PUSH DE
$EDE7  E5           PUSH HL
$EDE8  CD 51 ED     CALL PRCHAR
$EDEB  E1           POP HL
$EDEC  D1           POP DE
$EDED  18 AA        JR SCR_LOOP
SCR_INNUM:
$EDEF  D5           PUSH DE
$EDF0  CD A9 EE     CALL INNUM
$EDF3  D1           POP DE
$EDF4  18 A3        JR SCR_LOOP
SCR_OUTNUM:
$EDF6  D5           PUSH DE
$EDF7  E5           PUSH HL
$EDF8  CD AD EC     CALL PRDEC
$EDFB  E1           POP HL
$EDFC  D1           POP DE
$EDFD  18 9A        JR SCR_LOOP
SCR_INSTR:
$EDFF  13           INC DE             ; operand byte selects the buffer
$EE00  1A           LD A,(DE)
$EE01  D5           PUSH DE
$EE02  A7           AND A
$EE03  21 D7 EC     LD HL,STR0_LEN
$EE06  28 03        JR Z,SCR_IS2
$EE08  21 FA EC     LD HL,STR1_LEN
SCR_IS2:
$EE0B  01 21 00     LD BC,$0021        ; 33 characters maximum
$EE0E  CD 9A EE     CALL INSTR
$EE11  D1           POP DE
SCR_BACK:
$EE12  18 85        JR SCR_LOOP
SCR_OUTSTR:
$EE14  13           INC DE
$EE15  1A           LD A,(DE)
$EE16  D5           PUSH DE
$EE17  A7           AND A
$EE18  21 D7 EC     LD HL,STR0_LEN
$EE1B  28 03        JR Z,SCR_OS2
$EE1D  21 FA EC     LD HL,STR1_LEN
SCR_OS2:
$EE20  4E           LD C,(HL)
$EE21  23           INC HL
$EE22  46           LD B,(HL)
$EE23  23           INC HL
$EE24  EB           EX DE,HL
$EE25  CD DB 21     CALL PO_STR        ; print BC chars from (DE)
$EE28  D1           POP DE
$EE29  18 E7        JR SCR_BACK
SCR_CHECK:
$EE2B  D6 17        SUB $17            ; $16->-1  $17->0  $18->+1
$EE2D  D5           PUSH DE
$EE2E  CD 61 EE     CALL VALIDATE
$EE31  D1           POP DE
$EE32  18 DE        JR SCR_BACK

;---------------------------------------------------------------------
; SCR_END ($EE34)  script byte $00 — the "EXECUTE?" confirmation
;---------------------------------------------------------------------
SCR_END:
$EE34  D5           PUSH DE            ; DE -> byte after the $00
$EE35  E5           PUSH HL
$EE36  11 EB EF     LD DE,ASKTAB
$EE39  D5           PUSH DE
$EE3A  AF           XOR A
$EE3B  CD 3F 07     CALL PUTMES        ; "\r\r EXECUTE? "
$EE3E  01 02 00     LD BC,$0002
$EE41  CD F7 EE     CALL INPUT
$EE44  E6 DF        AND $DF
$EE46  FE 59        CP 'Y'
$EE48  28 05        JR Z,SCR_GO
$EE4A  ED 7B C9 EC  LD SP,(SAVED_SP)   ; abandon — unwind to MAIN
$EE4E  C9           RET
SCR_GO:
$EE4F  D1           POP DE
$EE50  3E 01        LD A,$01
$EE52  CD 3F 07     CALL PUTMES        ; "Y\r\r"
$EE55  E1           POP HL
$EE56  D1           POP DE
;---------------------------------------------------------------------
; SCR_RESUME ($EE57)  script byte $19 — leave the script, run on
;---------------------------------------------------------------------
SCR_RESUME:
$EE57  13           INC DE
$EE58  D5           PUSH DE            ; the resume address
$EE59  E5           PUSH HL
$EE5A  3E 02        LD A,$02
$EE5C  CD 30 12     CALL SELECT        ; back to stream 2 (upper screen)
$EE5F  E1           POP HL
$EE60  C9           RET                ; -> the byte after the script

;=====================================================================
; VALIDATE  ($EE61)  A = -1 / 0 / +1 selects the test
;=====================================================================
VALIDATE:
$EE61  28 20        JR Z,V_DEST        ; script $17
$EE63  30 0F        JR NC,V_ORDER      ; script $18
;   script $16 - increment must be 1..100
$EE65  AF           XOR A
$EE66  11 64 00     LD DE,100
$EE69  2A D1 EC     LD HL,(P_INCR)
$EE6C  37           SCF
$EE6D  ED 52        SBC HL,DE          ; HL - 101
$EE6F  D8           RET C
$EE70  CD 4A EF     CALL REPORT
$EE73  01           DEFB 1             ; "Range Error"
V_ORDER:
$EE74  2A CB EC     LD HL,(P_START)
$EE77  ED 5B CD EC  LD DE,(P_FINISH)
$EE7B  37           SCF
$EE7C  ED 52        SBC HL,DE          ; start - finish - 1
$EE7E  D8           RET C
$EE7F  CD 4A EF     CALL REPORT
$EE82  02           DEFB 2             ; "Numbers Reversed"
V_DEST:
$EE83  21 0C 27     LD HL,9996
$EE86  ED 5B CF EC  LD DE,(P_DEST)
$EE8A  ED 52        SBC HL,DE
$EE8C  38 08        JR C,V_BAD
$EE8E  19           ADD HL,DE          ; HL = 9996 again
$EE8F  ED 5B CD EC  LD DE,(P_FINISH)
$EE93  ED 52        SBC HL,DE
$EE95  D0           RET NC
V_BAD:
$EE96  CD 4A EF     CALL REPORT
$EE99  03           DEFB 3             ; "Invalid Line Number"

;=====================================================================
; INSTR  ($EE9A)  read up to BC characters into the buffer at (HL)
;=====================================================================
INSTR:
$EE9A  E5           PUSH HL
$EE9B  CD F7 EE     CALL INPUT         ; BC = length, DE = text
$EE9E  E1           POP HL
$EE9F  71           LD (HL),C
$EEA0  23           INC HL
$EEA1  70           LD (HL),B
$EEA2  23           INC HL
$EEA3  EB           EX DE,HL
$EEA4  ED B0        LDIR
$EEA6  AF           XOR A
$EEA7  12           LD (DE),A          ; NUL-terminate
$EEA8  C9           RET

;=====================================================================
; INNUM  ($EEA9)  read a number into HL.  "#" prefix = hexadecimal.
;=====================================================================
INNUM:
$EEA9  01 06 00     LD BC,$0006        ; up to 6 characters
$EEAC  CD F7 EE     CALL INPUT
$EEAF  21 00 00     LD HL,$0000
$EEB2  FE 23        CP '#'
$EEB4  28 1C        JR Z,IN_HEX
IN_DEC:
$EEB6  FE 0D        CP $0D
$EEB8  C8           RET Z
$EEB9  44           LD B,H             ; HL = HL*10 + digit
$EEBA  4D           LD C,L
$EEBB  29           ADD HL,HL
$EEBC  29           ADD HL,HL
$EEBD  09           ADD HL,BC
$EEBE  29           ADD HL,HL
$EEBF  38 0F        JR C,IN_AGAIN      ; overflow -> ask again
$EEC1  CD D9 30     CALL DIGITQ
$EEC4  38 0A        JR C,IN_AGAIN      ; not a digit -> ask again
$EEC6  D6 30        SUB '0'
$EEC8  06 00        LD B,$00
$EECA  4F           LD C,A
$EECB  13           INC DE
$EECC  1A           LD A,(DE)
$EECD  09           ADD HL,BC
$EECE  30 E6        JR NC,IN_DEC
IN_AGAIN:
$EED0  18 D7        JR INNUM
IN_HEX:
$EED2  13           INC DE
$EED3  1A           LD A,(DE)
$EED4  FE 0D        CP $0D
$EED6  C8           RET Z
$EED7  29           ADD HL,HL          ; HL = HL*16 + nibble
$EED8  29           ADD HL,HL
$EED9  29           ADD HL,HL
$EEDA  29           ADD HL,HL
$EEDB  CD D9 30     CALL DIGITQ
$EEDE  DC EB EE     CALL C,HEXLET      ; not 0-9: try A-F
$EEE1  38 ED        JR C,IN_AGAIN
$EEE3  D6 30        SUB '0'
$EEE5  06 00        LD B,$00
$EEE7  4F           LD C,A
$EEE8  09           ADD HL,BC
$EEE9  18 E7        JR IN_HEX
HEXLET:
$EEEB  E6 DF        AND $DF
$EEED  D6 41        SUB 'A'
$EEEF  D8           RET C
$EEF0  FE 06        CP $06
$EEF2  3F           CCF
$EEF3  D8           RET C
$EEF4  C6 3A        ADD A,$3A          ; map A-F to '0'+10..'0'+15
$EEF6  C9           RET

;=====================================================================
; INPUT  ($EEF7)  read a line using the ROM editor
; Entry: BC = maximum length accepted.
; Exit:  BC = length, DE = text, A = first character.
;        An empty line (just ENTER) unwinds to MAIN.
;        An over-long line loops back and asks again.
;=====================================================================
INPUT:
$EEF7  C5           PUSH BC
$EEF8  2A 51 5C     LD HL,(CURCHL)
$EEFB  E5           PUSH HL            ; remember the caller's channel
$EEFC  AF           XOR A
$EEFD  CD 30 12     CALL SELECT        ; stream 0 (lower screen)
$EF00  CD A9 08     CALL CLLHS
$EF03  FD CB 02 DE  SET 3,(IY+$02)     ; TVFLAG - input on lower screen
$EF07  CD 4E 13     CALL X_CALC
$EF0A  21 71 5C     LD HL,FLAGX
$EF0D  CB EE        SET 5,(HL)         ; INPUT mode
$EF0F  CB FE        SET 7,(HL)
$EF11  E5           PUSH HL
$EF12  01 01 00     LD BC,$0001
$EF15  F7           RST $30            ; BC-SPACES: one byte of workspace
$EF16  36 0D        LD (HL),$0D
$EF18  22 5B 5C     LD (KCUR),HL
$EF1B  CD 82 0A     CALL EDIT_K        ; hand over to the ROM editor
$EF1E  CD A9 08     CALL CLLHS
$EF21  E1           POP HL
$EF22  CB AE        RES 5,(HL)
$EF24  CB BE        RES 7,(HL)
$EF26  E1           POP HL
$EF27  CD 48 12     CALL SEL_HL        ; restore the caller's channel
$EF2A  FD 36 22 00  LD (IY+$22),$00    ; zero KCUR high byte - no cursor
$EF2E  2A 63 5C     LD HL,(STKBOT)
$EF31  ED 5B 61 5C  LD DE,(WORKSP)
$EF35  37           SCF
$EF36  ED 52        SBC HL,DE          ; HL = length typed - 1
$EF38  C1           POP BC             ; BC = maximum allowed
$EF39  ED 42        SBC HL,BC
$EF3B  30 BA        JR NC,INPUT        ; too long: start over
$EF3D  09           ADD HL,BC
$EF3E  44           LD B,H
$EF3F  4D           LD C,L             ; BC = actual length
$EF40  78           LD A,B
$EF41  B1           OR C
$EF42  1A           LD A,(DE)          ; A = first character
$EF43  C0           RET NZ
$EF44  18 21        JR ABORT           ; empty line -> back to the menu

;---------------------------------------------------------------------
; $EF46  "Task Complete" trampoline.  MAIN pushes this address so a
;        handler that just RETs lands here and reports success.
;---------------------------------------------------------------------
$EF46  CD 4A EF     CALL REPORT
$EF49  00           DEFB 0             ; "Task Complete"

;=====================================================================
; REPORT  ($EF4A)  print report message n, beep twice, return to MAIN
; Called as:   CALL REPORT
;              DEFB n
; The DEFB is read via the return address; REPORT never comes back.
;=====================================================================
REPORT:
$EF4A  CD A9 08     CALL CLLHS
$EF4D  E1           POP HL             ; HL -> the DEFB
$EF4E  7E           LD A,(HL)
$EF4F  11 6B EF     LD DE,ERRTAB
$EF52  CD 3F 07     CALL PUTMES
$EF55  21 84 01     LD HL,$0184        ; period
$EF58  11 0A 02     LD DE,$020A        ; cycles-1
$EF5B  CD F3 03     CALL PARP          ; beep
$EF5E  01 01 00     LD BC,$0001
$EF61  CD F2 1F     CALL PAUSE
$EF64  CD F2 1F     CALL PAUSE
ABORT:
$EF67  ED 7B C9 EC  LD SP,(SAVED_SP)
$EF6B  C9           RET                ; -> MAIN
;                   ^ this RET opcode ($C9) doubles as the dummy
;                     terminator that starts ERRTAB.

;=====================================================================
; ERRTAB  ($EF6B)  report messages, index 0-7
;=====================================================================
ERRTAB:
$EF6B  DEFB $C9                        ; dummy terminator
$EF6C  DEFM "Task Complete"            ; 0  -> "Task Completed"
$EF79  DEFB $E4                        ;   'd'+$80
$EF7A  DEFM "Range Erro"               ; 1
$EF84  DEFB $F2                        ;   'r'+$80
$EF85  DEFM "Numbers Reverse"          ; 2
$EF94  DEFB $E4
$EF95  DEFM "Invalid Line Numbe"       ; 3
$EFA7  DEFB $F2
$EFA8  DEFM "Zero not Allowe"          ; 4
$EFB7  DEFB $E4
$EFB8  DEFM "Lines would Overla"       ; 5
$EFCA  DEFB $F0                        ;   'p'+$80
$EFCB  DEFM "No Room at Destinatio"    ; 6
$EFE0  DEFB $EE                        ;   'n'+$80
$EFE1  DEFM "Zero Block"               ; 7

;=====================================================================
; ASKTAB  ($EFEB)  the two-entry confirmation table
;   0 = "\r\r EXECUTE? "      1 = "Y\r\r"
; Entry 1's terminator ($8D) is also the dummy terminator of MSGTAB.
;=====================================================================
ASKTAB:
$EFEB  DEFB $A1                        ; dummy terminator
$EFEC  DEFB $0D,$0D
$EFEE  DEFM " EXECUTE?"                ; 0
$EFF7  DEFB $A0                        ;   ' '+$80
$EFF8  DEFB $59,$0D                    ; 1  "Y",CR
MSGTAB:
$EFFA  DEFB $8D                        ;   CR+$80  / MSGTAB dummy terminator

;=====================================================================
; MSGTAB body ($EFFB-$F176).  64 words, see the index in the header.
; Each message ends with its last character + $80.
;=====================================================================
$EFFB  DEFM "ADDRES"      : DEFB $D3   ;  0 ADDRESS
$F002  DEFM "STAR"        : DEFB $D4   ;  1 START
$F007  DEFM "FINIS"       : DEFB $C8   ;  2 FINISH
$F00D  DEFM "1s"          : DEFB $F4   ;  3 1st
$F010  DEFM "UNAFFECTE"   : DEFB $C4   ;  4 UNAFFECTED
$F01A  DEFM "DESTINATIO"  : DEFB $CE   ;  5 DESTINATION
$F025  DEFM "INCREMEN"    : DEFB $D4   ;  6 INCREMENT
$F02E  DEFM "LIN"         : DEFB $C5   ;  7 LINE
$F032  DEFM "NUMBE"       : DEFB $D2   ;  8 NUMBER
$F038  DEFM "DELET"       : DEFB $C5   ;  9 DELETE
$F03E  DEFM "MOV"         : DEFB $C5   ; 10 MOVE
$F042  DEFM "COP"         : DEFB $D9   ; 11 COPY
$F046  DEFM "RENUMBE"     : DEFB $D2   ; 12 RENUMBER
$F04E  DEFM "BLOC"        : DEFB $CB   ; 13 BLOCK
$F053  DEFM "O"           : DEFB $C6   ; 14 OF
$F055  DEFM "PROGRA"      : DEFB $CD   ; 15 PROGRAM
$F05C  DEFM "MACHIN"      : DEFB $C5   ; 16 MACHINE
$F063  DEFM "COD"         : DEFB $C5   ; 17 CODE
$F067  DEFM "UDG"         : DEFB $F3   ; 18 UDGs
$F06B  DEFM "T"           : DEFB $CF   ; 19 TO
$F06D  DEFM "DAT"         : DEFB $C1   ; 20 DATA
$F071  DEFM "SEARC"       : DEFB $C8   ; 21 SEARCH
$F077  DEFM "LIS"         : DEFB $D4   ; 22 LIST
$F07B  DEFM "REPLAC"      : DEFB $C5   ; 23 REPLACE
$F082  DEFM "OL"          : DEFB $C4   ; 24 OLD
$F085  DEFM "NE"          : DEFB $D7   ; 25 NEW
$F088  DEFM "STRIN"       : DEFB $C7   ; 26 STRING
$F08E  DEFM "RE"          : DEFB $CD   ; 27 REM
$F091  DEFM "UPPE"        : DEFB $D2   ; 28 UPPER
$F096  DEFM "lowe"        : DEFB $F2   ; 29 lower
$F09B  DEFM "CAS"         : DEFB $C5   ; 30 CASE
$F09F  DEFM "DE"          : DEFB $C3   ; 31 DEC
$F0A2  DEFM "HE"          : DEFB $D8   ; 32 HEX
$F0A5  DEFM "MERG"        : DEFB $C5   ; 33 MERGE
$F0AA  DEFM "? (0=no"     : DEFB $A9   ; 34 ? (0=no)
$F0B2  DEFM "CREAT"       : DEFB $C5   ; 35 CREATE
$F0B8  DEFM "SYMBO"       : DEFB $CC   ; 36 SYMBOL
$F0BE  DEFM "BYTE"        : DEFB $D3   ; 37 BYTES
$F0C3  DEFM "PE"          : DEFB $D2   ; 38 PER
$F0C6  DEFM "byte"        : DEFB $F3   ; 39 bytes
$F0CB  DEFM "STATU"       : DEFB $D3   ; 40 STATUS
$F0D1  DEFM "REPOR"       : DEFB $D4   ; 41 REPORT
$F0D7  DEFM "MEMOR"       : DEFB $D9   ; 42 MEMORY
$F0DD  DEFM "LEF"         : DEFB $D4   ; 43 LEFT
$F0E1  DEFM "LENGT"       : DEFB $C8   ; 44 LENGTH
$F0E7  DEFM "VARIABL"     : DEFB $C5   ; 45 VARIABLE
$F0EF  DEFM "FIL"         : DEFB $C5   ; 46 FILE
$F0F3  DEFM "USER RA"     : DEFB $CD   ; 47 USER RAM
$F0FB  DEFM "INTERRUPT"   : DEFB $D3   ; 48 INTERRUPTS
$F105  DEFM "NORMA"       : DEFB $CC   ; 49 NORMAL
$F10B  DEFM "DIVERTE"     : DEFB $C4   ; 50 DIVERTED
$F113  DEFM "BOB MITCHELL 198" : DEFB $B5   ; 51 BOB MITCHELL 1985
$F124  DEFM "DESIG"       : DEFB $CE   ; 52 DESIGN
$F12A  DEFM "CHARACTE"    : DEFB $D2   ; 53 CHARACTER
$F133  DEFM "US"          : DEFB $C5   ; 54 USE
$F136  DEFM "COMPAC"      : DEFB $D4   ; 55 COMPACT
$F13D  DEFM "COLUM"       : DEFB $CE   ; 56 COLUMN
$F143  DEFM "I/O (on/off" : DEFB $A9   ; 57 I/O (on/off)
$F14F  DEFM "IN QUOTES? (Y/N" : DEFB $A9 ; 58 IN QUOTES? (Y/N)
$F15F  DEFM "AUT"         : DEFB $CF   ; 59 AUTO
$F163  DEFM "ABCDEFG"     : DEFB $C8   ; 60 ABCDEFGH
$F16B  DEFM "RESTAR"      : DEFB $D4   ; 61 RESTART
$F172  DEFB $0D,$8D                    ; 62 CR CR
$F174  DEFM "(c"          : DEFB $A9   ; 63 (c)

;=====================================================================
; COMMAND H  —  Hex & Dec   ($F177)
; Just an information page; the real work is INNUM's "#" prefix.
;=====================================================================
CMD_H:
$F177  CD 8F ED     CALL SCRIPT_CLS
$F17A  DEFB $0D
$F17B  DEFB $E0                        ; MSG 32 "HEX"
$F17C  DEFM " &"
$F17E  DEFB $DF                        ; MSG 31 "DEC"
$F17F  DEFM "IMAL"
$F183  DEFB $FE                        ; MSG 62 <CR><CR>
$F184  DEFM " Precede"
$F18C  DEFB $E0                        ; MSG 32 "HEX"
$F18D  DEFM " nos with ""#""."
$F19B  DEFB $19                        ; resume below
$F19C  CD 97 ED     CALL SCRIPT        ; wait-for-key script
$F19F  DEFB $13                        ;   input a number
$F1A0  DEFB $FE                        ;   <CR><CR>
$F1A1  DEFB $9F                        ;   MSG 31 "DEC" + ": "
$F1A2  DEFB $14                        ;   print it in decimal
$F1A3  DEFB $06
$F1A4  DEFB $A0                        ;   MSG 32 "HEX" + ": "
$F1A5  DEFB $10                        ;   print it in hex
$F1A6  DEFB $19                        ; resume below
$F1A7  FD 36 52 FF  LD (IY+$52),$FF    ; SCRCT - suppress "scroll?"
$F1AB  18 EF        JR $F19C           ; loop for another number

;=====================================================================
; COMMAND A  —  Alter Program  ($F1AD)   search & replace
;=====================================================================
CMD_A:
$F1AD  CD 8F ED     CALL SCRIPT_CLS
$F1B0  DEFB $0D
$F1B1  DEFB $D5                        ; MSG 21 "SEARCH"
$F1B2  DEFM " &"
$F1B4  DEFB $D7                        ; MSG 23 "REPLACE"
$F1B5  DEFB $FE                        ; <CR><CR>
$F1B6  DEFB $C1,$80                    ; " START ADDRESS: "
$F1B8  DEFB $13,$1A,$14                ; input -> P_START, echo
$F1BB  DEFB $FE
$F1BC  DEFB $C2,$80                    ; " FINISH ADDRESS: "
$F1BE  DEFB $13,$1B,$1C,$14            ; input -> P_FINISH and P_DEST
$F1C2  DEFB $FE
$F1C3  DEFB $D8,$9A                    ; " OLD STRING: "
$F1C5  DEFB $11,$00,$12,$00            ; input/echo buffer 0
$F1C9  DEFB $FE
$F1CA  DEFB $D9,$9A                    ; " NEW STRING: "
$F1CC  DEFB $11,$01,$12,$01            ; input/echo buffer 1
$F1D0  DEFB $FE
$F1D1  DEFB $D6,$A2                    ; " LIST ? (0=no): "
$F1D3  DEFB $13,$1D,$14                ; input -> P_INCR (used as a flag)
$F1D6  DEFB $16,$17,$18                ; validate
$F1D9  DEFB $00                        ; "EXECUTE?"
;---------------------------------------------------------------------
; Walk the program from P_START to P_FINISH replacing STR0 with STR1.
;---------------------------------------------------------------------
$F1DA  CD 95 F2     CALL EXPAND        ; resolve "&&&" number escapes
$F1DD  2A CB EC     LD HL,(P_START)
$F1E0  CD D6 16     CALL FIND_L
$F1E3  18 03        JR AL_LINE
AL_NEXT:
$F1E5  2A D5 EC     LD HL,(P_WORK2)    ; address of the next line
AL_LINE:
$F1E8  22 D3 EC     LD (P_WORK1),HL    ; address of this line
$F1EB  CD 20 17     CALL RECLEN
$F1EE  ED 53 D5 EC  LD (P_WORK2),DE    ; remember where the next one starts
$F1F2  56           LD D,(HL)          ; line number (big-endian)
$F1F3  23           INC HL
$F1F4  5E           LD E,(HL)
$F1F5  23           INC HL
$F1F6  E5           PUSH HL
$F1F7  2A CD EC     LD HL,(P_FINISH)
$F1FA  A7           AND A
$F1FB  ED 52        SBC HL,DE
AL_DONE:
$F1FD  E1           POP HL
$F1FE  D8           RET C              ; beyond the last wanted line
$F1FF  4E           LD C,(HL)          ; BC = line length
$F200  23           INC HL
$F201  46           LD B,(HL)
AL_TEXT:
$F202  23           INC HL             ; HL -> the line text
AL_SCAN:
$F203  11 D9 EC     LD DE,STR0
AL_CMP1:
$F206  1A           LD A,(DE)
$F207  BE           CP (HL)
$F208  28 14        JR Z,AL_CMPN       ; first character matches
AL_STEP:
$F20A  7E           LD A,(HL)
$F20B  CD 02 16     CALL SKIPNUM       ; $0E -> skip the 5-byte value
$F20E  20 06        JR NZ,AL_STEP2
$F210  2B           DEC HL             ; SKIPNUM moved HL on by 6
$F211  0B           DEC BC
$F212  0B           DEC BC
$F213  0B           DEC BC
$F214  0B           DEC BC
$F215  0B           DEC BC
AL_STEP2:
$F216  23           INC HL
$F217  0B           DEC BC
$F218  78           LD A,B
$F219  B1           OR C
$F21A  28 C9        JR Z,AL_NEXT       ; end of line
$F21C  18 E8        JR AL_CMP1
AL_CMPN:
$F21E  C5           PUSH BC
$F21F  DD E1        POP IX             ; IX = bytes left in this line
$F221  37           SCF
$F222  E5           PUSH HL
$F223  2A D7 EC     LD HL,(STR0_LEN)
$F226  ED 42        SBC HL,BC          ; does the search string still fit?
$F228  E1           POP HL
$F229  30 BA        JR NC,AL_NEXT
$F22B  E5           PUSH HL
$F22C  ED 4B D7 EC  LD BC,(STR0_LEN)
AL_CMP2:
$F230  1A           LD A,(DE)
$F231  BE           CP (HL)
$F232  13           INC DE
$F233  23           INC HL
$F234  0B           DEC BC
$F235  28 07        JR Z,AL_HIT
$F237  E1           POP HL             ; mismatch - restore and step on
$F238  DD E5        PUSH IX
$F23A  C1           POP BC
$F23B  0B           DEC BC
$F23C  18 C4        JR AL_TEXT
AL_HIT:
$F23E  78           LD A,B
$F23F  B1           OR C
$F240  20 EE        JR NZ,AL_CMP2      ; keep comparing
;   Found.  Swap STR0 for STR1 in place.
$F242  ED 4B D7 EC  LD BC,(STR0_LEN)
$F246  2A FA EC     LD HL,(STR1_LEN)
$F249  A7           AND A
$F24A  ED 42        SBC HL,BC          ; HL = growth (may be negative)
$F24C  C5           PUSH BC
$F24D  E5           PUSH HL
$F24E  44           LD B,H
$F24F  4D           LD C,L
$F250  D4 BB 1F     CALL NC,CHK_SZ     ; growing: is there room?
$F253  E1           POP HL
$F254  C1           POP BC
$F255  E3           EX (SP),HL
$F256  CD 50 17     CALL DELREC        ; remove the old text
$F259  E5           PUSH HL
$F25A  ED 4B FA EC  LD BC,(STR1_LEN)
$F25E  C5           PUSH BC
$F25F  CD BB 12     CALL INSERT        ; open a gap for the new text
$F262  C1           POP BC
$F263  D1           POP DE
$F264  21 FC EC     LD HL,STR1
$F267  ED B0        LDIR
$F269  C1           POP BC
$F26A  D5           PUSH DE
$F26B  2A D5 EC     LD HL,(P_WORK2)    ; fix up "next line" pointer
$F26E  09           ADD HL,BC
$F26F  22 D5 EC     LD (P_WORK2),HL
$F272  A7           AND A
$F273  ED 52        SBC HL,DE
$F275  E5           PUSH HL
$F276  2A D3 EC     LD HL,(P_WORK1)    ; fix up this line's length word
$F279  23           INC HL
$F27A  23           INC HL
$F27B  5E           LD E,(HL)
$F27C  23           INC HL
$F27D  56           LD D,(HL)
$F27E  EB           EX DE,HL
$F27F  09           ADD HL,BC
$F280  EB           EX DE,HL
$F281  72           LD (HL),D
$F282  2B           DEC HL
$F283  73           LD (HL),E
$F284  2B           DEC HL
$F285  2B           DEC HL
$F286  3A D1 EC     LD A,(P_INCR)      ; the LIST flag
$F289  A7           AND A
$F28A  28 04        JR Z,AL_ON
$F28C  CD A1 15     CALL PUT_SR        ; echo the altered line
$F28F  D7           RST $10
AL_ON:
$F290  C1           POP BC
$F291  E1           POP HL
$F292  C3 03 F2     JP AL_SCAN         ; keep searching the same line

;=====================================================================
; EXPAND  ($F295)
; Both search strings may contain a "&&&<number>&&&" escape.  BASIC
; keeps numeric constants as ASCII digits followed by $0E and a 5-byte
; binary value, so a plain text search would never match one.  This
; routine evaluates the digits with the ROM number parser and rewrites
; the escape as digits + $0E + the five bytes off the calculator stack.
;=====================================================================
EXPAND:
$F295  ED 4B D7 EC  LD BC,(STR0_LEN)
$F299  11 D9 EC     LD DE,STR0
$F29C  CD B6 F2     CALL FIND_AMP
$F29F  DC D3 F2     CALL C,DO_AMP
$F2A2  38 F1        JR C,EXPAND        ; another escape in buffer 0?
EXPAND1:
$F2A4  ED 4B FA EC  LD BC,(STR1_LEN)
$F2A8  11 FC EC     LD DE,STR1
$F2AB  CD B6 F2     CALL FIND_AMP
$F2AE  DC D3 F2     CALL C,DO_AMP
$F2B1  38 F1        JR C,EXPAND1
$F2B3  C9           RET
FIND_AMP1:
$F2B4  54           LD D,H
$F2B5  5D           LD E,L
FIND_AMP:
$F2B6  1A           LD A,(DE)
$F2B7  FE 26        CP '&'
$F2B9  28 07        JR Z,FA_RUN
FA_NEXT:
$F2BB  13           INC DE
$F2BC  0B           DEC BC
$F2BD  78           LD A,B
$F2BE  B1           OR C
$F2BF  C8           RET Z              ; NC = no escape found
$F2C0  18 F4        JR FIND_AMP
FA_RUN:
$F2C2  62           LD H,D             ; need three in a row
$F2C3  6B           LD L,E
$F2C4  23           INC HL
$F2C5  7E           LD A,(HL)
$F2C6  FE 26        CP '&'
$F2C8  20 F1        JR NZ,FA_NEXT
$F2CA  23           INC HL
$F2CB  7E           LD A,(HL)
$F2CC  FE 26        CP '&'
$F2CE  20 EB        JR NZ,FA_NEXT
$F2D0  23           INC HL             ; HL -> first char after "&&&"
$F2D1  37           SCF
$F2D2  C9           RET
DO_AMP:
$F2D3  D5           PUSH DE
$F2D4  E5           PUSH HL
$F2D5  E5           PUSH HL
$F2D6  2A 5D 5C     LD HL,(CH_ADD)
$F2D9  E3           EX (SP),HL         ; stack the real CH_ADD
$F2DA  22 5D 5C     LD (CH_ADD),HL     ; parse from inside the string
$F2DD  DF           RST $18            ; GET-CHAR
$F2DE  CD D9 30     CALL DIGITQ
$F2E1  30 0C        JR NC,DA_NUM
$F2E3  FE C4        CP $C4             ; BIN token
$F2E5  28 08        JR Z,DA_NUM
$F2E7  E1           POP HL             ; not a number - leave it alone
$F2E8  22 5D 5C     LD (CH_ADD),HL
$F2EB  E1           POP HL
$F2EC  E1           POP HL
$F2ED  A7           AND A
$F2EE  C9           RET
DA_NUM:
$F2EF  CD 59 30     CALL STKUSN        ; stack the value
$F2F2  DF           RST $18
$F2F3  01 01 00     LD BC,$0001
$F2F6  CD B4 F2     CALL FIND_AMP1     ; closing "&&&"?
$F2F9  E1           POP HL
$F2FA  22 5D 5C     LD (CH_ADD),HL     ; restore CH_ADD
$F2FD  E1           POP HL
$F2FE  38 06        JR C,DA_SUB
$F300  EF           RST $28            ; calculator ...
$F301  DEFB $02                        ;   delete
$F302  DEFB $38                        ;   end-calc
$F303  D1           POP DE
$F304  A7           AND A
$F305  C9           RET
DA_SUB:
$F306  EB           EX DE,HL
$F307  A7           AND A
$F308  ED 52        SBC HL,DE
$F30A  EB           EX DE,HL
$F30B  42           LD B,D
$F30C  4B           LD C,E
$F30D  D1           POP DE
$F30E  ED B0        LDIR               ; close up over the "&&&"
$F310  3E 0E        LD A,$0E           ; BASIC's number marker
$F312  12           LD (DE),A
$F313  13           INC DE
$F314  2A 65 5C     LD HL,(STKEND)     ; take the 5-byte value back
$F317  01 05 00     LD BC,$0005
$F31A  A7           AND A
$F31B  ED 42        SBC HL,BC
$F31D  22 65 5C     LD (STKEND),HL
$F320  ED B0        LDIR
$F322  37           SCF
$F323  C9           RET

;=====================================================================
; COMMAND M  —  Move Lines  ($F324)
;=====================================================================
CMD_M:
$F324  CD 8F ED     CALL SCRIPT_CLS
$F327  DEFB $0D
$F328  DEFB $CA                        ; MSG 10 "MOVE"
$F329  DEFB $19                        ; resume below
$F32A  CD 39 F3     CALL ASK_BLOCK     ; the four standard prompts
$F32D  CD 44 F5     CALL CHK_ROOM      ; will it fit at the destination?
$F330  CD 6D F3     CALL RENUM_BLK     ; give the block its new numbers
$F333  CD BB F3     CALL FIX_REFS      ; repoint GO TO / GO SUB / ...
$F336  C3 19 F5     JP CMD_Z           ; sort the lines into place

;=====================================================================
; ASK_BLOCK  ($F339)  the prompt script shared by M and R
;=====================================================================
ASK_BLOCK:
$F339  CD 92 ED     CALL SCRIPT_FE
$F33C  DEFB $CD,$CE,$CF              ; " BLOCK OF PROGRAM"
$F33F  DEFB $FE
$F340  DEFB $C1,$80                  ; " START ADDRESS: "
$F342  DEFB $13,$1A,$14              ;   -> P_START
$F345  DEFB $FE
$F346  DEFB $C3,$C4,$80              ; " 1st UNAFFECTED ADDRESS: "
$F349  DEFB $13,$1B,$14              ;   -> P_FINISH
$F34C  DEFB $FE
$F34D  DEFB $85                      ; " DESTINATION: "
$F34E  DEFB $13,$1C,$14              ;   -> P_DEST
$F351  DEFB $FE
$F352  DEFB $18,$17                  ; start<=finish, dest/finish<=9996
$F354  DEFB $86                      ; " INCREMENT: "
$F355  DEFB $13,$1D,$14              ;   -> P_INCR
$F358  DEFB $15,$16                  ; non-zero, <=100
$F35A  DEFB $00                      ; "EXECUTE?"
$F35B  C9           RET

;=====================================================================
; COMMAND R  —  Renumber  ($F35C)
;=====================================================================
CMD_R:
$F35C  CD 8F ED     CALL SCRIPT_CLS
$F35F  DEFB $0D
$F360  DEFB $CC                        ; MSG 12 "RENUMBER"
$F361  DEFB $19
$F362  CD 39 F3     CALL ASK_BLOCK
$F365  CD 6D F3     CALL RENUM_BLK
$F368  CD F6 F4     CALL CHK_ORDER     ; would the result overlap?
$F36B  18 4E        JR FIX_REFS

;=====================================================================
; RENUM_BLK  ($F36D)
; Pass 1.  Every line's 2-byte LENGTH field is used as scratch to hold
; the line's OLD number while the number field takes the new one.  The
; length field can be sacrificed because the walker (NEXT_LINE) finds
; line ends by scanning for $0D, not by using the length.  Pass 3
; (REBUILD, $F452) puts the lengths back.
;=====================================================================
RENUM_BLK:
$F36D  2A CB EC     LD HL,(P_START)
$F370  CD D6 16     CALL FIND_L
$F373  E5           PUSH HL            ; first line of the block
$F374  2A CD EC     LD HL,(P_FINISH)
$F377  CD D6 16     CALL FIND_L
$F37A  13           INC DE
$F37B  ED 53 D3 EC  LD (P_WORK1),DE    ; one past the end of the block
$F37F  ED 5B CF EC  LD DE,(P_DEST)     ; the first new line number
$F383  2A 53 5C     LD HL,(PROG)
;   Lines before the block: copy the old number into the length field
;   so that pass 2 can look every old number up.
RB_PRE:
$F386  CD CF F4     CALL IN_PROG
$F389  30 0D        JR NC,RB_BLOCK
$F38B  46           LD B,(HL)
$F38C  23           INC HL
$F38D  4E           LD C,(HL)
$F38E  23           INC HL
$F38F  71           LD (HL),C
$F390  23           INC HL
$F391  70           LD (HL),B
$F392  23           INC HL
$F393  CD C4 F4     CALL NEXT_LINE
$F396  18 EE        JR RB_PRE
RB_BLOCK:
$F398  E1           POP HL
;   Lines inside the block: swap in the new number, stash the old one.
RENUM_RUN:
$F399  E5           PUSH HL
$F39A  D5           PUSH DE
$F39B  ED 5B D3 EC  LD DE,(P_WORK1)
$F39F  A7           AND A
$F3A0  ED 52        SBC HL,DE
$F3A2  D1           POP DE
$F3A3  E1           POP HL
$F3A4  D0           RET NC             ; past the end of the block
$F3A5  46           LD B,(HL)          ; B = old high byte
$F3A6  72           LD (HL),D          ;     new high byte
$F3A7  23           INC HL
$F3A8  4E           LD C,(HL)          ; C = old low byte
$F3A9  73           LD (HL),E          ;     new low byte
$F3AA  23           INC HL
$F3AB  71           LD (HL),C          ; length field := old number
$F3AC  23           INC HL
$F3AD  70           LD (HL),B
$F3AE  23           INC HL
$F3AF  E5           PUSH HL
$F3B0  2A D1 EC     LD HL,(P_INCR)
$F3B3  19           ADD HL,DE
$F3B4  EB           EX DE,HL           ; next new number
$F3B5  E1           POP HL
$F3B6  CD C4 F4     CALL NEXT_LINE
$F3B9  18 DE        JR RENUM_RUN

;=====================================================================
; FIX_REFS  ($F3BB)
; Pass 2.  Find every line-number reference (GO TO, GO SUB, RUN, LIST,
; LLIST, RESTORE, LINE) and rewrite the digits to the new number.
;=====================================================================
FIX_REFS:
$F3BB  3E FF        LD A,$FF
$F3BD  CD 30 12     CALL SELECT        ; stream $FF - edit-buffer channel
$F3C0  2A 53 5C     LD HL,(PROG)
$F3C3  23           INC HL             ; skip the first line's header
$F3C4  23           INC HL
$F3C5  23           INC HL
$F3C6  23           INC HL
FR_LOOP:
$F3C7  CD 6E F4     CALL FIND_KEYWD
$F3CA  D2 52 F4     JP NC,REBUILD      ; end of program - pass 3
$F3CD  54           LD D,H             ; DE = first digit
$F3CE  5D           LD E,L
$F3CF  06 00        LD B,$00           ; B = digit count
FR_DIGITS:
$F3D1  04           INC B
$F3D2  23           INC HL
$F3D3  7E           LD A,(HL)
$F3D4  FE 2E        CP '.'
$F3D6  20 03        JR NZ,FR_TEST      ; a decimal point - not a line number
FR_SKIP:
$F3D8  EB           EX DE,HL
$F3D9  18 EC        JR FR_LOOP
FR_TEST:
$F3DB  FE 0E        CP $0E             ; number marker ends the digits
$F3DD  20 F2        JR NZ,FR_DIGITS
$F3DF  23           INC HL             ; step over the 5-byte value
$F3E0  23           INC HL
$F3E1  23           INC HL
$F3E2  23           INC HL
$F3E3  23           INC HL
$F3E4  23           INC HL
$F3E5  7E           LD A,(HL)
$F3E6  FE 3A        CP ':'
$F3E8  28 04        JR Z,FR_OK
$F3EA  FE 0D        CP $0D
$F3EC  20 EA        JR NZ,FR_SKIP      ; something follows - an expression
FR_OK:
$F3EE  78           LD A,B
$F3EF  FE 05        CP $05
$F3F1  30 E5        JR NC,FR_SKIP      ; more than 4 digits - not a line no.
$F3F3  D5           PUSH DE
$F3F4  21 00 00     LD HL,$0000
FR_VAL:
$F3F7  1A           LD A,(DE)          ; HL = value of the digit string
$F3F8  FE 0E        CP $0E
$F3FA  28 0F        JR Z,FR_FIND
$F3FC  D6 30        SUB '0'
$F3FE  4D           LD C,L
$F3FF  44           LD B,H
$F400  29           ADD HL,HL
$F401  29           ADD HL,HL
$F402  09           ADD HL,BC
$F403  29           ADD HL,HL          ; *10
$F404  4F           LD C,A
$F405  06 00        LD B,$00
$F407  09           ADD HL,BC
$F408  13           INC DE
$F409  18 EC        JR FR_VAL
;   Look the old number up in the stashed length fields.
FR_FIND:
$F40B  4D           LD C,L
$F40C  44           LD B,H
$F40D  2A 53 5C     LD HL,(PROG)
FR_SEEK:
$F410  23           INC HL
$F411  23           INC HL             ; HL -> stashed old number
$F412  CD CF F4     CALL IN_PROG
$F415  38 03        JR C,FR_CMP
$F417  E1           POP HL             ; not found - leave the text alone
FR_ON:
$F418  18 AD        JR FR_LOOP
FR_CMP:
$F41A  23           INC HL
$F41B  7E           LD A,(HL)
$F41C  B8           CP B
$F41D  30 07        JR NC,FR_MAYBE
FR_NEXT:
$F41F  23           INC HL
$F420  23           INC HL
$F421  CD C4 F4     CALL NEXT_LINE
$F424  18 EA        JR FR_SEEK
FR_MAYBE:
$F426  2B           DEC HL
$F427  20 04        JR NZ,FR_GOT
$F429  7E           LD A,(HL)
$F42A  B9           CP C
$F42B  38 F2        JR C,FR_NEXT
FR_GOT:
$F42D  2B           DEC HL
$F42E  4E           LD C,(HL)          ; BC = the NEW number
$F42F  2B           DEC HL
$F430  46           LD B,(HL)
$F431  E1           POP HL             ; HL -> the old digits
$F432  E5           PUSH HL
$F433  EB           EX DE,HL
$F434  C5           PUSH BC
$F435  CD 4D 17     CALL DEL_DE        ; delete the old digit string
$F438  C1           POP BC
$F439  22 5B 5C     LD (KCUR),HL       ; stream $FF writes at KCUR
$F43C  C5           PUSH BC
$F43D  CD 88 17     CALL PUT_BC        ; write the new digits
$F440  C1           POP BC
$F441  2A 5B 5C     LD HL,(KCUR)
$F444  AF           XOR A
$F445  23           INC HL             ; rebuild the hidden 5-byte value
$F446  77           LD (HL),A
$F447  23           INC HL
$F448  77           LD (HL),A
$F449  23           INC HL
$F44A  71           LD (HL),C
$F44B  23           INC HL
$F44C  70           LD (HL),B
$F44D  23           INC HL
$F44E  77           LD (HL),A
$F44F  E1           POP HL
$F450  18 C6        JR FR_ON

;=====================================================================
; REBUILD  ($F452)  = COMMAND Y "Uncorrupt"
; Pass 3.  Recompute every line's length word by measuring the gap to
; the next line.  Run on its own it repairs a program whose length
; fields have been corrupted.
;=====================================================================
CMD_Y:
REBUILD:
$F452  2A 53 5C     LD HL,(PROG)
RB_LOOP:
$F455  23           INC HL
$F456  23           INC HL
$F457  CD CF F4     CALL IN_PROG
$F45A  D0           RET NC
$F45B  54           LD D,H
$F45C  5D           LD E,L
$F45D  23           INC HL
$F45E  23           INC HL
$F45F  CD C4 F4     CALL NEXT_LINE
$F462  E5           PUSH HL
$F463  37           SCF
$F464  ED 52        SBC HL,DE
$F466  2B           DEC HL
$F467  EB           EX DE,HL
$F468  73           LD (HL),E
$F469  23           INC HL
$F46A  72           LD (HL),D
$F46B  E1           POP HL
$F46C  18 E7        JR RB_LOOP

;=====================================================================
; FIND_KEYWD  ($F46E)
; Scan the program from HL for a keyword that takes a line number,
; followed by a digit.  Returns CY with HL on the first digit; NC at
; the end of the program.  Skips REM bodies, quoted strings and the
; 5-byte binary form of every constant.
;=====================================================================
FIND_KEYWD:
$F46E  7E           LD A,(HL)
$F46F  CD CF F4     CALL IN_PROG
$F472  D0           RET NC
$F473  FE EA        CP $EA             ; REM
$F475  20 0D        JR NZ,FK_QUOTE
FK_REM:
$F477  23           INC HL             ; skip to end of line
$F478  7E           LD A,(HL)
$F479  FE 0D        CP $0D
$F47B  20 FA        JR NZ,FK_REM
FK_HDR:
$F47D  23           INC HL             ; step over the next line's header
$F47E  23           INC HL
$F47F  23           INC HL
$F480  23           INC HL
$F481  23           INC HL
$F482  18 EA        JR FIND_KEYWD
FK_QUOTE:
$F484  FE 22        CP '"'
$F486  20 09        JR NZ,FK_TOKEN
FK_STR:
$F488  23           INC HL
$F489  7E           LD A,(HL)
$F48A  FE 22        CP '"'
$F48C  20 FA        JR NZ,FK_STR
$F48E  23           INC HL
$F48F  18 DD        JR FIND_KEYWD
FK_TOKEN:
$F491  FE 0D        CP $0D
$F493  28 E8        JR Z,FK_HDR
$F495  CD 02 16     CALL SKIPNUM
$F498  28 D4        JR Z,FIND_KEYWD
$F49A  FE ED        CP $ED             ; GO SUB
$F49C  28 1B        JR Z,FK_DIGIT
$F49E  FE EC        CP $EC             ; GO TO
$F4A0  28 17        JR Z,FK_DIGIT
$F4A2  FE F7        CP $F7             ; RUN
$F4A4  28 13        JR Z,FK_DIGIT
$F4A6  FE F0        CP $F0             ; LIST
$F4A8  28 0F        JR Z,FK_DIGIT
$F4AA  FE E5        CP $E5             ; RESTORE
$F4AC  28 0B        JR Z,FK_DIGIT
$F4AE  FE E1        CP $E1             ; LLIST
$F4B0  28 07        JR Z,FK_DIGIT
$F4B2  FE CA        CP $CA             ; LINE
$F4B4  28 03        JR Z,FK_DIGIT
$F4B6  23           INC HL
$F4B7  18 B5        JR FIND_KEYWD
FK_DIGIT:
$F4B9  23           INC HL
$F4BA  7E           LD A,(HL)
$F4BB  FE 30        CP '0'
$F4BD  38 AF        JR C,FIND_KEYWD    ; keyword not followed by a digit
$F4BF  FE 3A        CP '9'+1
$F4C1  30 AB        JR NC,FIND_KEYWD
$F4C3  C9           RET                ; CY set, HL on the first digit

;=====================================================================
; NEXT_LINE  ($F4C4)  advance HL past the next $0D, skipping the
; 5-byte binary form of any embedded constant.
;=====================================================================
NEXT_LINE:
$F4C4  7E           LD A,(HL)
NL_LOOP:
$F4C5  CD 02 16     CALL SKIPNUM
$F4C8  28 FB        JR Z,NL_LOOP
$F4CA  FE 0D        CP $0D
$F4CC  23           INC HL
$F4CD  20 F5        JR NZ,NEXT_LINE

;=====================================================================
; IN_PROG  ($F4CF)  CY if HL is still below VARS (i.e. inside the
; program area).  Preserves everything.
;=====================================================================
IN_PROG:
$F4CF  E5           PUSH HL
$F4D0  D5           PUSH DE
$F4D1  ED 5B 4B 5C  LD DE,(VARS)
$F4D5  A7           AND A
$F4D6  ED 52        SBC HL,DE
$F4D8  D1           POP DE
$F4D9  E1           POP HL
$F4DA  C9           RET

;=====================================================================
; FIND_UNSORTED  ($F4DB)
; Walk the program looking for a line whose number is not greater than
; its predecessor's.  C = $00 tests "prev >= cur", C = $FF tests
; "prev > cur".  Returns NC with HL on the offender, CY if the whole
; program is in ascending order.
;=====================================================================
FIND_UNSORTED:
$F4DB  2A 53 5C     LD HL,(PROG)
$F4DE  11 00 00     LD DE,$0000        ; DE = previous line number
FU_LOOP:
$F4E1  D5           PUSH DE
$F4E2  56           LD D,(HL)
$F4E3  23           INC HL
$F4E4  5E           LD E,(HL)
$F4E5  23           INC HL             ; DE = this line number
$F4E6  E3           EX (SP),HL
$F4E7  79           LD A,C
$F4E8  87           ADD A,A            ; carry := bit 7 of C
$F4E9  ED 52        SBC HL,DE
$F4EB  E1           POP HL
$F4EC  D0           RET NC             ; out of order - HL -> length word
$F4ED  23           INC HL
$F4EE  23           INC HL
$F4EF  CD C4 F4     CALL NEXT_LINE
$F4F2  38 ED        JR C,FU_LOOP
$F4F4  37           SCF
$F4F5  C9           RET                ; all in order

;=====================================================================
; CHK_ORDER  ($F4F6)  used by R
; If the renumber left any line out of order, undo it (swap the old
; numbers back out of the length fields), rebuild the lengths and
; report "Lines would Overlap".
;=====================================================================
CHK_ORDER:
$F4F6  AF           XOR A
$F4F7  4F           LD C,A
$F4F8  CD DB F4     CALL FIND_UNSORTED
$F4FB  D8           RET C              ; fine - carry on
$F4FC  2A 53 5C     LD HL,(PROG)
CO_UNDO:
$F4FF  23           INC HL
$F500  23           INC HL
$F501  4E           LD C,(HL)          ; old number out of the length field
$F502  23           INC HL
$F503  46           LD B,(HL)
$F504  2B           DEC HL
$F505  2B           DEC HL
$F506  2B           DEC HL
$F507  70           LD (HL),B          ; put it back in the number field
$F508  23           INC HL
$F509  71           LD (HL),C
$F50A  23           INC HL
$F50B  23           INC HL
$F50C  23           INC HL
$F50D  CD C4 F4     CALL NEXT_LINE
$F510  38 ED        JR C,CO_UNDO
$F512  CD 52 F4     CALL REBUILD
$F515  CD 4A EF     CALL REPORT
$F518  05           DEFB 5             ; "Lines would Overlap"

;=====================================================================
; COMMAND Z  —  Line Sort  ($F519)
; Repeatedly take the first out-of-order line and move it, whole, to
; where FIND_L says it belongs.  Also the tail of M (Move Lines).
;=====================================================================
CMD_Z:
$F519  0E FF        LD C,$FF
$F51B  CD DB F4     CALL FIND_UNSORTED
$F51E  D8           RET C              ; sorted
$F51F  4E           LD C,(HL)          ; BC = line body length
$F520  23           INC HL
$F521  46           LD B,(HL)
$F522  2B           DEC HL
$F523  2B           DEC HL
$F524  2B           DEC HL             ; HL -> start of the line
$F525  03           INC BC             ; + the 4 header bytes
$F526  03           INC BC
$F527  03           INC BC
$F528  03           INC BC
$F529  E5           PUSH HL
$F52A  C5           PUSH BC
$F52B  EB           EX DE,HL
$F52C  CD D6 16     CALL FIND_L        ; where does it belong?
$F52F  C1           POP BC
$F530  E5           PUSH HL
$F531  C5           PUSH BC
$F532  CD BB 12     CALL INSERT        ; open a gap there
$F535  C1           POP BC
$F536  D1           POP DE
$F537  E1           POP HL
$F538  09           ADD HL,BC          ; the source moved up by BC
$F539  E5           PUSH HL
$F53A  C5           PUSH BC
$F53B  ED B0        LDIR               ; copy the line into the gap
$F53D  C1           POP BC
$F53E  E1           POP HL
$F53F  CD 50 17     CALL DELREC        ; remove the original
$F542  18 D5        JR CMD_Z

;=====================================================================
; CHK_ROOM  ($F544)  used by M and C
; Count the lines in the block, multiply by the increment and make
; sure the renumbered block will fit in the gap at the destination.
;=====================================================================
CHK_ROOM:
$F544  2A CB EC     LD HL,(P_START)
$F547  CD D6 16     CALL FIND_L
$F54A  11 00 00     LD DE,$0000        ; DE = line count
CR_COUNT:
$F54D  46           LD B,(HL)
$F54E  23           INC HL
$F54F  4E           LD C,(HL)
$F550  23           INC HL
$F551  E5           PUSH HL
$F552  2A CD EC     LD HL,(P_FINISH)
$F555  A7           AND A
$F556  ED 42        SBC HL,BC
$F558  E1           POP HL
$F559  38 0A        JR C,CR_SIZE
$F55B  28 08        JR Z,CR_SIZE
$F55D  13           INC DE
$F55E  23           INC HL
$F55F  23           INC HL
$F560  CD C4 F4     CALL NEXT_LINE
$F563  18 E8        JR CR_COUNT
CR_SIZE:
$F565  2A D1 EC     LD HL,(P_INCR)
$F568  CD 68 34     CALL MULT          ; HL = lines * increment
$F56B  38 16        JR C,CR_BAD        ; overflow
CR_FIT:
$F56D  E5           PUSH HL
$F56E  2A CF EC     LD HL,(P_DEST)
$F571  E5           PUSH HL
$F572  CD D6 16     CALL FIND_L
$F575  28 0C        JR Z,CR_BAD        ; that line already exists
$F577  56           LD D,(HL)
$F578  23           INC HL
$F579  5E           LD E,(HL)          ; DE = the next existing number
$F57A  E1           POP HL
$F57B  EB           EX DE,HL
$F57C  A7           AND A
$F57D  ED 52        SBC HL,DE          ; gap available
$F57F  C1           POP BC
$F580  ED 42        SBC HL,BC          ; gap needed
$F582  D0           RET NC
CR_BAD:
$F583  CD 4A EF     CALL REPORT
$F586  06           DEFB 6             ; "No Room at Destination"

;=====================================================================
; CHK_OUTSIDE  ($F587)  used by C
; Refuse a destination that falls inside the source block.
;=====================================================================
CHK_OUTSIDE:
$F587  2A CB EC     LD HL,(P_START)
$F58A  ED 5B CF EC  LD DE,(P_DEST)
$F58E  A7           AND A
$F58F  ED 52        SBC HL,DE
$F591  D0           RET NC             ; dest below the block - fine
$F592  2A CD EC     LD HL,(P_FINISH)
$F595  ED 52        SBC HL,DE
$F597  D8           RET C              ; dest above the block - fine
$F598  18 E9        JR CR_BAD

;=====================================================================
; COMMAND C  —  Copy Lines  ($F59A)
; Copies the block, then renumbers *only the copy* by temporarily
; faking PROG and VARS around it so RENUM_RUN/FIX_REFS see nothing
; else.
;=====================================================================
CMD_C:
$F59A  CD 8F ED     CALL SCRIPT_CLS
$F59D  DEFB $0D
$F59E  DEFB $CB                        ; MSG 11 "COPY"
$F59F  DEFB $19
$F5A0  CD 39 F3     CALL ASK_BLOCK
$F5A3  CD 87 F5     CALL CHK_OUTSIDE
$F5A6  CD 44 F5     CALL CHK_ROOM
$F5A9  2A CB EC     LD HL,(P_START)
$F5AC  CD D6 16     CALL FIND_L
$F5AF  E5           PUSH HL
$F5B0  2A CD EC     LD HL,(P_FINISH)
$F5B3  CD D6 16     CALL FIND_L
$F5B6  D1           POP DE
$F5B7  ED 52        SBC HL,DE          ; HL = block length in bytes
$F5B9  28 51        JR Z,CC_ZERO
$F5BB  E5           PUSH HL
$F5BC  D5           PUSH DE
$F5BD  2A CF EC     LD HL,(P_DEST)
$F5C0  CD D6 16     CALL FIND_L
$F5C3  D1           POP DE
$F5C4  ED 52        SBC HL,DE
$F5C6  19           ADD HL,DE
$F5C7  C1           POP BC             ; BC = block length
$F5C8  F5           PUSH AF
$F5C9  C5           PUSH BC
$F5CA  D5           PUSH DE
$F5CB  E5           PUSH HL
$F5CC  CD BB 12     CALL INSERT        ; open the gap
$F5CF  D1           POP DE
$F5D0  E1           POP HL
$F5D1  C1           POP BC
$F5D2  F1           POP AF
$F5D3  30 01        JR NC,CC_COPY
$F5D5  09           ADD HL,BC          ; source moved up
CC_COPY:
$F5D6  E5           PUSH HL
$F5D7  2A 53 5C     LD HL,(PROG)
$F5DA  E3           EX (SP),HL         ; save the real PROG
$F5DB  ED 53 53 5C  LD (PROG),DE       ; PROG := the copy
$F5DF  ED B0        LDIR
$F5E1  2A 4B 5C     LD HL,(VARS)
$F5E4  E5           PUSH HL            ; save the real VARS
$F5E5  D5           PUSH DE
$F5E6  ED 53 4B 5C  LD (VARS),DE       ; VARS := end of the copy
$F5EA  ED 53 D3 EC  LD (P_WORK1),DE
$F5EE  ED 5B CF EC  LD DE,(P_DEST)
$F5F2  2A 53 5C     LD HL,(PROG)
$F5F5  CD 99 F3     CALL RENUM_RUN     ; number the copy
$F5F8  CD BB F3     CALL FIX_REFS      ; and fix its internal jumps
$F5FB  D1           POP DE
$F5FC  2A 4B 5C     LD HL,(VARS)
$F5FF  A7           AND A
$F600  ED 52        SBC HL,DE
$F602  C1           POP BC             ; the real VARS
$F603  09           ADD HL,BC
$F604  22 4B 5C     LD (VARS),HL       ; restore, grown by the copy
$F607  E1           POP HL
$F608  22 53 5C     LD (PROG),HL       ; restore PROG
$F60B  C9           RET
CC_ZERO:
$F60C  CD 4A EF     CALL REPORT
$F60F  07           DEFB 7             ; "Zero Block"

;=====================================================================
; COMMAND D  —  Delete lines  ($F610)
;=====================================================================
CMD_D:
$F610  CD 8F ED     CALL SCRIPT_CLS
$F613  DEFB $0D
$F614  DEFB $C9,$CD,$CE,$CF            ; " DELETE BLOCK OF PROGRAM"
$F618  DEFB $FE
$F619  DEFB $C1,$80,$13,$1A,$14        ; " START ADDRESS: "  -> P_START
$F61E  DEFB $FE
$F61F  DEFB $C2,$80,$13,$1B,$1C,$14    ; " FINISH ADDRESS: " -> P_FINISH,P_DEST
$F625  DEFB $18,$17                    ; validate
$F627  DEFB $00                        ; "EXECUTE?"
$F628  2A CB EC     LD HL,(P_START)
$F62B  CD D6 16     CALL FIND_L
$F62E  E5           PUSH HL
$F62F  2A CD EC     LD HL,(P_FINISH)
$F632  23           INC HL             ; the range is inclusive
$F633  CD D6 16     CALL FIND_L
$F636  D1           POP DE
$F637  ED 52        SBC HL,DE
$F639  28 D1        JR Z,CC_ZERO       ; nothing in range
$F63B  19           ADD HL,DE
$F63C  C3 4D 17     JP DEL_DE

;=====================================================================
; COMMAND E  —  REM Create  ($F63F)
; Builds a REM line of a chosen length filled with a chosen character:
; the standard way of reserving space inside a BASIC program for
; machine code.
;=====================================================================
CMD_E:
$F63F  CD 8F ED     CALL SCRIPT_CLS
$F642  DEFB $0D
$F643  DEFB $E3,$DB,$C7                ; " CREATE REM LINE"
$F646  DEFB $FE
$F647  DEFB $C7,$88                    ; " LINE NUMBER: "
$F649  DEFB $13,$1B,$1C,$14            ;   -> P_FINISH and P_DEST
$F64D  DEFB $17                        ;   <= 9996
$F64E  DEFB $FE
$F64F  DEFB $AC                        ; " LENGTH: "
$F650  DEFB $13,$1D,$14,$15            ;   -> P_INCR, must be non-zero
$F654  DEFB $FE
$F655  DEFB $A4                        ; " SYMBOL: "
$F656  DEFB $11,$00,$12,$00            ;   -> string buffer 0
$F65A  DEFB $00                        ; "EXECUTE?"
$F65B  ED 4B D1 EC  LD BC,(P_INCR)     ; requested body length
$F65F  03           INC BC             ; + REM token
$F660  03           INC BC             ; + CR
$F661  C5           PUSH BC
$F662  03           INC BC             ; + the 4 header bytes
$F663  03           INC BC
$F664  03           INC BC
$F665  03           INC BC
$F666  21 06 00     LD HL,$0006
$F669  ED 42        SBC HL,BC
$F66B  D2 E2 ED     JP NC,$EDE2        ; too short -> "Zero not Allowed"
$F66E  2A CF EC     LD HL,(P_DEST)
$F671  E5           PUSH HL
$F672  C5           PUSH BC
$F673  CD D6 16     CALL FIND_L
$F676  C1           POP BC
$F677  CA 83 F5     JP Z,CR_BAD        ; that line already exists
$F67A  CD BB 12     CALL INSERT
$F67D  23           INC HL
$F67E  D1           POP DE
$F67F  72           LD (HL),D          ; line number, big-endian
$F680  23           INC HL
$F681  73           LD (HL),E
$F682  23           INC HL
$F683  C1           POP BC
$F684  71           LD (HL),C          ; body length, little-endian
$F685  23           INC HL
$F686  70           LD (HL),B
$F687  23           INC HL
$F688  36 EA        LD (HL),$EA        ; REM
$F68A  ED 5B D9 EC  LD DE,(STR0)       ; E = the fill character
$F68E  0B           DEC BC             ; discount the REM token ...
$F68F  0B           DEC BC             ; ... and the closing CR
CE_FILL:
$F690  0B           DEC BC
$F691  23           INC HL
$F692  73           LD (HL),E
$F693  78           LD A,B
$F694  B1           OR C
$F695  20 F9        JR NZ,CE_FILL
$F697  23           INC HL
$F698  36 0D        LD (HL),$0D
$F69A  C9           RET

;---------------------------------------------------------------------
; $F69B-$F6AF   21 spare bytes (all $00)
;---------------------------------------------------------------------
$F69B  DEFS 21,$00

;=====================================================================
; COMMAND U  —  UDGs to DATA  ($F6B0)
; Sets START/FINISH to cover n user-defined graphics (8 bytes each)
; and then falls through into the B command's generator.
;=====================================================================
CMD_U:
$F6B0  CD 8F ED     CALL SCRIPT_CLS
$F6B3  DEFB $0D
$F6B4  DEFB $D2,$D3,$D4                ; " UDGs TO DATA"
$F6B7  DEFB $FE
$F6B8  DEFB $C8,$CE,$92                ; " NUMBER OF UDGs: "
$F6BB  DEFB $13,$1F,$1D,$14,$15        ;   -> P_WORK2 and P_INCR
$F6C0  DEFB $FE
$F6C1  DEFB $C3,$C7,$88                ; " 1st LINE NUMBER: "
$F6C4  DEFB $13,$1B,$1C,$14            ;   -> P_FINISH and P_DEST
$F6C8  DEFB $17,$16                    ; validate
$F6CA  DEFB $19                        ; resume below
$F6CB  2A D5 EC     LD HL,(P_WORK2)
$F6CE  3E 15        LD A,21            ; there are only 21 UDGs
$F6D0  95           SUB L
$F6D1  DA 70 EE     JP C,$EE70         ; more than 21 -> "Range Error"
$F6D4  21 08 00     LD HL,$0008
$F6D7  22 D1 EC     LD (P_INCR),HL     ; 8 bytes per DATA line
$F6DA  2A 7B 5C     LD HL,(UDG)
$F6DD  22 CB EC     LD (P_START),HL
$F6E0  EB           EX DE,HL
$F6E1  2A D5 EC     LD HL,(P_WORK2)
$F6E4  29           ADD HL,HL          ; *8
$F6E5  29           ADD HL,HL
$F6E6  29           ADD HL,HL
$F6E7  19           ADD HL,DE
$F6E8  2B           DEC HL
$F6E9  22 CD EC     LD (P_FINISH),HL
$F6EC  18 32        JR BD_ASK          ; join the B command

;=====================================================================
; COMMAND B  —  Bytes to DATA  ($F6EE)
; Turns a block of memory into a series of DATA lines, either decimal
; or as quoted hex pairs.
;=====================================================================
CMD_B:
$F6EE  CD 8F ED     CALL SCRIPT_CLS
$F6F1  DEFB $0D
$F6F2  DEFB $D0,$D1,$D3,$D4            ; " MACHINE CODE TO DATA"
$F6F6  DEFB $FE
$F6F7  DEFB $C1,$80,$13,$1A,$14        ; " START ADDRESS: "  -> P_START
$F6FC  DEFB $FE
$F6FD  DEFB $C2,$80,$13,$1B,$14        ; " FINISH ADDRESS: " -> P_FINISH
$F702  DEFB $FE
$F703  DEFB $18                        ; start <= finish
$F704  DEFB $C3,$C7,$88                ; " 1st LINE NUMBER: "
$F707  DEFB $13,$1C,$14                ;   -> P_DEST
$F70A  DEFB $FE
$F70B  DEFB $E5,$E6,$87                ; " BYTES PER LINE: "
$F70E  DEFB $13,$1D,$14                ;   -> P_INCR
$F711  DEFB $15,$16                    ; non-zero, <= 100
$F713  DEFB $19                        ; resume below
$F714  2A CF EC     LD HL,(P_DEST)
$F717  11 0C 27     LD DE,9996
$F71A  A7           AND A
$F71B  ED 52        SBC HL,DE
$F71D  D2 96 EE     JP NC,V_BAD        ; "Invalid Line Number"
BD_ASK:
$F720  CD 92 ED     CALL SCRIPT_FE
$F723  DEFB $FE
$F724  DEFB $DF                        ; MSG 31 "DEC"
$F725  DEFM " OR"
$F728  DEFB $A0                        ; MSG 32 "HEX" + ": "
$F729  DEFB $11,$00,$12,$00            ; answer -> string buffer 0
$F72D  DEFB $00                        ; "EXECUTE?"
;   How many DATA lines will there be?
$F72E  2A CD EC     LD HL,(P_FINISH)
$F731  23           INC HL
$F732  ED 5B CB EC  LD DE,(P_START)
$F736  AF           XOR A
$F737  ED 52        SBC HL,DE          ; HL = byte count
$F739  ED 5B D1 EC  LD DE,(P_INCR)     ; bytes per line
$F73D  47           LD B,A
$F73E  4F           LD C,A
BD_COUNT:
$F73F  03           INC BC
$F740  ED 52        SBC HL,DE
$F742  30 FB        JR NC,BD_COUNT
$F744  60           LD H,B
$F745  69           LD L,C             ; HL = number of DATA lines
$F746  CD 6D F5     CALL CR_FIT        ; is there room at the destination?
;   Work out the worst-case text length of one DATA line.
$F749  3A D9 EC     LD A,(STR0)
$F74C  E6 DF        AND $DF
$F74E  2A D1 EC     LD HL,(P_INCR)
$F751  FE 44        CP 'D'
$F753  28 0F        JR Z,BD_DEC
$F755  FE 48        CP 'H'
$F757  28 04        JR Z,BD_HEX
$F759  CD 4A EF     CALL REPORT
$F75C  01           DEFB 1             ; "Range Error"
BD_HEX:
$F75D  11 13 00     LD DE,$0013
$F760  29           ADD HL,HL          ; 2n + 19
$F761  19           ADD HL,DE
$F762  18 0E        JR BD_SIZE
BD_DEC:
$F764  2A D1 EC     LD HL,(P_INCR)
$F767  4D           LD C,L
$F768  44           LD B,H
$F769  29           ADD HL,HL          ; 10n + 5
$F76A  29           ADD HL,HL
$F76B  09           ADD HL,BC
$F76C  29           ADD HL,HL
$F76D  23           INC HL
$F76E  23           INC HL
$F76F  23           INC HL
$F770  23           INC HL
$F771  23           INC HL
BD_SIZE:
$F772  22 D3 EC     LD (P_WORK1),HL    ; bytes needed per line
$F775  2A CF EC     LD HL,(P_DEST)
$F778  CD D6 16     CALL FIND_L
$F77B  22 5B 5C     LD (KCUR),HL       ; stream $FF appends at KCUR
$F77E  3E FF        LD A,$FF
$F780  CD 30 12     CALL SELECT
$F783  ED 5B CB EC  LD DE,(P_START)    ; DE walks the source bytes
BD_LOOP:
$F787  2A CD EC     LD HL,(P_FINISH)
$F78A  A7           AND A
$F78B  ED 52        SBC HL,DE
$F78D  D8           RET C              ; all done
$F78E  CD 9D F7     CALL BD_LINE
$F791  7A           LD A,D
$F792  B3           OR E
$F793  C8           RET Z              ; wrapped past $FFFF
$F794  2A CF EC     LD HL,(P_DEST)
$F797  23           INC HL
$F798  22 CF EC     LD (P_DEST),HL     ; next line number
$F79B  18 EA        JR BD_LOOP

;---------------------------------------------------------------------
; BD_LINE  ($F79D)  emit one complete DATA line at KCUR
;---------------------------------------------------------------------
BD_LINE:
$F79D  ED 4B D3 EC  LD BC,(P_WORK1)
$F7A1  D5           PUSH DE
$F7A2  CD BB 1F     CALL CHK_SZ        ; error 4 if RAM is short
$F7A5  D1           POP DE
$F7A6  2A 5B 5C     LD HL,(KCUR)
$F7A9  E5           PUSH HL            ; remember the line start
$F7AA  2A CF EC     LD HL,(P_DEST)
$F7AD  7C           LD A,H
$F7AE  D7           RST $10            ; line number, big-endian
$F7AF  7D           LD A,L
$F7B0  D7           RST $10
$F7B1  D7           RST $10            ; two placeholder length bytes
$F7B2  D7           RST $10
$F7B3  3E E4        LD A,$E4           ; DATA
$F7B5  D7           RST $10
$F7B6  2A D1 EC     LD HL,(P_INCR)     ; HL counts bytes left on this line
$F7B9  3A D9 EC     LD A,(STR0)
$F7BC  E6 DF        AND $DF
$F7BE  FE 44        CP 'D'
$F7C0  28 30        JR Z,BD_DPUT
;   Hex form: one quoted string of two-digit pairs.
$F7C2  01 00 00     LD BC,$0000
$F7C5  3E 22        LD A,'"'
$F7C7  D7           RST $10
BD_HPUT:
$F7C8  1A           LD A,(DE)
$F7C9  E5           PUSH HL
$F7CA  26 00        LD H,$00
$F7CC  6F           LD L,A
$F7CD  09           ADD HL,BC          ; running checksum
$F7CE  44           LD B,H
$F7CF  4D           LD C,L
$F7D0  E1           POP HL
$F7D1  D5           PUSH DE
$F7D2  F5           PUSH AF
$F7D3  CD 9E EC     CALL PRHIGH
$F7D6  F1           POP AF
$F7D7  CD A2 EC     CALL PRLOW
$F7DA  D1           POP DE
$F7DB  2B           DEC HL
$F7DC  7C           LD A,H
$F7DD  B5           OR L
$F7DE  13           INC DE
$F7DF  28 04        JR Z,BD_HEND
$F7E1  7A           LD A,D
$F7E2  B3           OR E
$F7E3  20 E3        JR NZ,BD_HPUT
BD_HEND:
$F7E5  3E 22        LD A,'"'
$F7E7  D7           RST $10
$F7E8  3E 2C        LD A,','
$F7EA  D7           RST $10
$F7EB  1B           DEC DE
$F7EC  23           INC HL
$F7ED  18 07        JR BD_TAIL
;   Decimal form: comma-separated values.
BD_DSEP:
$F7EF  3E 2C        LD A,','
$F7F1  D7           RST $10
BD_DPUT:
$F7F2  1A           LD A,(DE)
$F7F3  4F           LD C,A
$F7F4  06 00        LD B,$00
BD_TAIL:
$F7F6  C5           PUSH BC
$F7F7  CD C4 FE     CALL PRBC          ; the ASCII digits
$F7FA  C1           POP BC
$F7FB  3E 0E        LD A,$0E           ; then BASIC's hidden binary form
$F7FD  D7           RST $10
$F7FE  AF           XOR A
$F7FF  D7           RST $10            ; exponent 0 = small integer
$F800  AF           XOR A
$F801  D7           RST $10            ; sign
$F802  79           LD A,C
$F803  D7           RST $10            ; low byte
$F804  78           LD A,B
$F805  D7           RST $10            ; high byte
$F806  AF           XOR A
$F807  D7           RST $10
$F808  2B           DEC HL
$F809  7C           LD A,H
$F80A  B5           OR L
$F80B  13           INC DE
$F80C  28 04        JR Z,BD_EOL
$F80E  7A           LD A,D
$F80F  B3           OR E
$F810  20 DD        JR NZ,BD_DSEP
BD_EOL:
$F812  3E 0D        LD A,$0D
$F814  D7           RST $10
$F815  C1           POP BC             ; BC = the line start
$F816  2A 5B 5C     LD HL,(KCUR)
$F819  03           INC BC
$F81A  03           INC BC
$F81B  03           INC BC
$F81C  37           SCF
$F81D  ED 42        SBC HL,BC          ; HL = body length
$F81F  7C           LD A,H
$F820  02           LD (BC),A          ; fill in the placeholders
$F821  0B           DEC BC
$F822  7D           LD A,L
$F823  02           LD (BC),A
$F824  C9           RET

;=====================================================================
; COMMAND I  —  Information  ($F825)
; A status page: free RAM, program length, variables length, user RAM
; and whether the interrupt vector has been diverted.
;=====================================================================
CMD_I:
$F825  FD CB 01 CE  SET 1,(IY+$01)     ; FLAGS bit 1 - suppress leading space
$F829  3E 02        LD A,$02
$F82B  CD 30 12     CALL SELECT
$F82E  FD CB 01 4E  BIT 1,(IY+$01)
$F832  CC A6 08     CALL Z,K_CLS
$F835  3E 02        LD A,$02
$F837  CD 30 12     CALL SELECT
$F83A  CD 97 ED     CALL SCRIPT
$F83D  DEFB $0D,$E8,$E9              ; " STATUS REPORT"
$F840  DEFB $FE,$EA,$AB              ; " MEMORY LEFT: "
$F843  DEFB $19
$F844  2A B2 5C     LD HL,(RAMTOP)
$F847  00           NOP
$F848  ED 5B 59 5C  LD DE,(ELINE)
$F84C  ED 52        SBC HL,DE
$F84E  CD 97 ED     CALL SCRIPT
$F851  DEFB $14,$E7                  ; print it, then " bytes"
$F853  DEFB $FE,$CF,$AC              ; " PROGRAM LENGTH: "
$F856  DEFB $19
$F857  2A 4B 5C     LD HL,(VARS)
$F85A  ED 5B 53 5C  LD DE,(PROG)
$F85E  A7           AND A
$F85F  ED 52        SBC HL,DE
$F861  CD 97 ED     CALL SCRIPT
$F864  DEFB $14,$E7
$F866  DEFB $FE,$ED,$AE              ; " VARIABLE FILE: "
$F869  DEFB $19
$F86A  2A 59 5C     LD HL,(ELINE)
$F86D  ED 5B 4B 5C  LD DE,(VARS)
$F871  A7           AND A
$F872  ED 52        SBC HL,DE
$F874  CD 97 ED     CALL SCRIPT
$F877  DEFB $14,$E7
$F879  DEFB $FE,$AF                  ; " USER RAM: "
$F87B  DEFB $19
$F87C  2A B2 5C     LD HL,(RAMTOP)
$F87F  ED 5B 53 5C  LD DE,(PROG)
$F883  A7           AND A
$F884  ED 52        SBC HL,DE
$F886  CD 97 ED     CALL SCRIPT
$F889  DEFB $14,$E7
$F88B  DEFB $FE,$F0                  ; " INTERRUPTS"
$F88D  DEFB $19
$F88E  ED 57        LD A,I
$F890  FE 3F        CP $3F             ; the ROM's own value
$F892  28 07        JR Z,CI_NORM
$F894  CD 97 ED     CALL SCRIPT
$F897  DEFB $F2                      ; " DIVERTED"
$F898  DEFB $19
$F899  18 05        JR CI_CHAN
CI_NORM:
$F89B  CD 97 ED     CALL SCRIPT
$F89E  DEFB $F1                      ; " NORMAL"
$F89F  DEFB $19
CI_CHAN:
$F8A0  2A 51 5C     LD HL,(CURCHL)
$F8A3  23           INC HL
$F8A4  23           INC HL
$F8A5  23           INC HL
$F8A6  23           INC HL
$F8A7  7E           LD A,(HL)
$F8A8  FE 53        CP 'S'
$F8AA  28 02        JR Z,CI_UDG
$F8AC  FE 50        CP 'P'
CI_UDG:
$F8AE  CC BC F8     CALL Z,UDGRULER    ; only worth it on screen/printer
$F8B1  CD 97 ED     CALL SCRIPT
$F8B4  DEFB $FE,$7F,$F3,$0D          ; " ©BOB MITCHELL 1985"
$F8B8  DEFB $19
$F8B9  C3 70 EC     JP GETCMD          ; straight back to the prompt

;---------------------------------------------------------------------
; UDGRULER  ($F8BC)  the letters A-U over the 21 UDG glyphs
;---------------------------------------------------------------------
UDGRULER:
$F8BC  CD 97 ED     CALL SCRIPT
$F8BF  DEFB $FE,$92,$FE,$20          ; " UDGs: " <CR><CR> " "
$F8C3  DEFB $19
$F8C4  06 15        LD B,21
UR_LET:
$F8C6  3E 56        LD A,'U'+1
$F8C8  90           SUB B              ; 'A'..'U'
$F8C9  D7           RST $10
$F8CA  10 FA        DJNZ UR_LET
$F8CC  3E 0D        LD A,$0D
$F8CE  D7           RST $10
$F8CF  3E 20        LD A,$20
$F8D1  D7           RST $10
$F8D2  06 15        LD B,21
UR_UDG:
$F8D4  3E A5        LD A,$A5
$F8D6  90           SUB B              ; $90..$A4 = the UDG characters
$F8D7  D7           RST $10
$F8D8  10 FA        DJNZ UR_UDG
$F8DA  3E 0D        LD A,$0D
$F8DC  D7           RST $10
$F8DD  C9           RET

;=====================================================================
; COMMAND V  —  List Variables  ($F8DE)
; Walks the variables area printing name and value: numerics through
; the ROM's calculator print routine, strings and arrays by hand.
;=====================================================================
CMD_V:
$F8DE  CD 8F ED     CALL SCRIPT_CLS
$F8E1  DEFB $D6,$ED               ; " LIST VARIABLE"
$F8E3  DEFM "S"
$F8E4  DEFB $FE                   ; <CR><CR>
$F8E5  DEFB $19
$F8E6  2A 4B 5C     LD HL,(VARS)
$F8E9  E5           PUSH HL
CV_NEXT:
$F8EA  E1           POP HL
$F8EB  CD 20 17     CALL RECLEN        ; DE = next variable
$F8EE  D5           PUSH DE
$F8EF  7E           LD A,(HL)
$F8F0  FE 80        CP $80             ; end-of-variables marker
$F8F2  20 03        JR NZ,CV_TYPE
$F8F4  D1           POP DE
$F8F5  18 C2        JR $F8B9           ; -> JP GETCMD
CV_TYPE:
$F8F7  CB 7F        BIT 7,A
$F8F9  20 43        JR NZ,CV_LONG      ; long name / array
$F8FB  CB 6F        BIT 5,A
$F8FD  28 1A        JR Z,CV_STR
;   simple numeric: name "=" value
$F8FF  D7           RST $10
$F900  3E 3D        LD A,'='
$F902  D7           RST $10
$F903  23           INC HL
$F904  ED 5B 65 5C  LD DE,(STKEND)
$F908  01 05 00     LD BC,$0005
$F90B  ED B0        LDIR               ; push the value onto the fp stack
$F90D  ED 53 65 5C  LD (STKEND),DE
$F911  CD A1 31     CALL $31A1         ; OUTPUT - print it
$F914  3E 0D        LD A,$0D
$F916  D7           RST $10
$F917  18 D1        JR CV_NEXT
CV_STR:
$F919  CB EF        SET 5,A            ; restore the letter
$F91B  D7           RST $10
$F91C  3E 24        LD A,'$'
$F91E  D7           RST $10
$F91F  3E 3D        LD A,'='
$F921  D7           RST $10
$F922  3E 22        LD A,'"'
$F924  D7           RST $10
$F925  23           INC HL
$F926  4E           LD C,(HL)          ; BC = string length
$F927  23           INC HL
$F928  46           LD B,(HL)
CV_SLOOP:
$F929  23           INC HL
$F92A  78           LD A,B
$F92B  B1           OR C
$F92C  0B           DEC BC
$F92D  20 05        JR NZ,CV_SCHR
$F92F  3E 22        LD A,'"'
$F931  D7           RST $10
$F932  18 E0        JR $F914           ; CR, then the next variable
CV_SCHR:
$F934  7E           LD A,(HL)
$F935  FE 20        CP $20
$F937  30 02        JR NC,CV_SPUT
$F939  3E 3F        LD A,'?'           ; control codes shown as "?"
CV_SPUT:
$F93B  D7           RST $10
$F93C  18 EB        JR CV_SLOOP
CV_LONG:
$F93E  CB 77        BIT 6,A
$F940  20 11        JR NZ,CV_ARR2      ; array with a $ / long name
$F942  CB 6F        BIT 5,A
$F944  28 15        JR Z,CV_ARRN       ; numeric array
$F946  EE C0        XOR $C0            ; numeric array: recover the letter
$F948  D7           RST $10
$F949  23           INC HL
$F94A  7E           LD A,(HL)
$F94B  CB 7F        BIT 7,A
$F94D  28 F9        JR Z,$F948
$F94F  CB BF        RES 7,A
$F951  18 AC        JR $F8FF
CV_ARR2:
$F953  CB 6F        BIT 5,A
$F955  28 09        JR Z,CV_ARRS2
$F957  E6 5F        AND $5F
$F959  18 A4        JR $F8FF
CV_ARRN:
$F95B  EE E0        XOR $E0
$F95D  D7           RST $10
$F95E  18 06        JR CV_DIMS
CV_ARRS2:
$F960  EE A0        XOR $A0
$F962  D7           RST $10
$F963  3E 24        LD A,'$'
$F965  D7           RST $10
CV_DIMS:
$F966  3E 28        LD A,'('
$F968  D7           RST $10
$F969  23           INC HL
$F96A  23           INC HL
$F96B  23           INC HL
$F96C  46           LD B,(HL)          ; number of dimensions
$F96D  18 03        JR CV_DIM1
CV_DIMN:
$F96F  3E 2C        LD A,','
$F971  D7           RST $10
CV_DIM1:
$F972  23           INC HL
$F973  5E           LD E,(HL)
$F974  23           INC HL
$F975  56           LD D,(HL)
$F976  C5           PUSH BC
$F977  E5           PUSH HL
$F978  EB           EX DE,HL
$F979  CD AD EC     CALL PRDEC         ; print the dimension
$F97C  E1           POP HL
$F97D  C1           POP BC
$F97E  10 EF        DJNZ CV_DIMN
$F980  3E 29        LD A,')'
$F982  D7           RST $10
$F983  18 8F        JR $F914           ; CR, then the next variable

;=====================================================================
; COMMAND S  —  Search & List  ($F985)
; Same scan as command A, but only reports the lines that match.
;=====================================================================
CMD_S:
$F985  CD 8F ED     CALL SCRIPT_CLS
$F988  DEFB $0D
$F989  DEFB $D5,$20,$26,$D6          ; " SEARCH & LIST"
$F98D  DEFB $FE
$F98E  DEFB $C1,$80,$13,$1A,$14      ; " START ADDRESS: "
$F993  DEFB $FE
$F994  DEFB $C2,$80,$13,$1B,$1C,$14  ; " FINISH ADDRESS: "
$F99A  DEFB $FE
$F99B  DEFB $18,$17                  ; validate
$F99D  DEFB $9A                      ; " STRING: "
$F99E  DEFB $11,$00,$12,$00          ;   -> string buffer 0
$F9A2  DEFB $00                      ; "EXECUTE?"
$F9A3  2A CB EC     LD HL,(P_START)
$F9A6  CD D6 16     CALL FIND_L
CS_LINE:
$F9A9  CD 20 17     CALL RECLEN
$F9AC  D5           PUSH DE            ; next line
$F9AD  E5           PUSH HL
$F9AE  56           LD D,(HL)
$F9AF  23           INC HL
$F9B0  5E           LD E,(HL)
$F9B1  23           INC HL             ; DE = line number
$F9B2  E5           PUSH HL
$F9B3  2A CD EC     LD HL,(P_FINISH)
$F9B6  A7           AND A
$F9B7  ED 52        SBC HL,DE
$F9B9  E1           POP HL
$F9BA  30 03        JR NC,CS_SCAN
$F9BC  C1           POP BC             ; past the finish line
$F9BD  C1           POP BC
$F9BE  C9           RET
CS_SCAN:
$F9BF  23           INC HL
$F9C0  23           INC HL             ; HL -> line text
$F9C1  11 D9 EC     LD DE,STR0
$F9C4  ED 4B D7 EC  LD BC,(STR0_LEN)
CS_CMP:
$F9C8  7E           LD A,(HL)
$F9C9  FE 0D        CP $0D
$F9CB  20 07        JR NZ,CS_TEST
$F9CD  E1           POP HL             ; end of line, no match
$F9CE  E1           POP HL
$F9CF  18 D8        JR CS_LINE
CS_RETRY:
$F9D1  E1           POP HL             ; mismatch - step on one character
$F9D2  18 EC        JR CS_SCAN+1
CS_TEST:
$F9D4  E5           PUSH HL
$F9D5  7E           LD A,(HL)
$F9D6  CD 02 16     CALL SKIPNUM
$F9D9  28 FB        JR Z,$F9D6         ; skip the 5-byte number form
$F9DB  1A           LD A,(DE)
$F9DC  BE           CP (HL)
$F9DD  20 F2        JR NZ,CS_RETRY
$F9DF  13           INC DE
$F9E0  23           INC HL
$F9E1  0B           DEC BC
$F9E2  78           LD A,B
$F9E3  B1           OR C
$F9E4  20 EF        JR NZ,$F9D5        ; keep comparing
$F9E6  E1           POP HL             ; matched - list the line
$F9E7  E1           POP HL
$F9E8  CD A1 15     CALL PUT_SR
$F9EB  D7           RST $10
$F9EC  E1           POP HL
$F9ED  18 BA        JR CS_LINE

;=====================================================================
; COMMAND F  —  REM Delete  ($F9EF)
; Removes the machine-code payload from inside a REM line, leaving the
; line itself; the inverse of command E.
;=====================================================================
CMD_F:
$F9EF  CD 8F ED     CALL SCRIPT_CLS
$F9F2  DEFB $0D
$F9F3  DEFB $DB,$C9                  ; " REM DELETE"
$F9F5  DEFB $FE
$F9F6  DEFB $C1,$80,$13,$1A,$14      ; " START ADDRESS: "
$F9FB  DEFB $FE
$F9FC  DEFB $C2,$80,$13,$1B,$1C,$14  ; " FINISH ADDRESS: "
$FA02  DEFB $FE
$FA03  DEFB $18,$17                  ; validate
$FA05  DEFB $00                      ; "EXECUTE?"
$FA06  2A CB EC     LD HL,(P_START)
$FA09  CD D6 16     CALL FIND_L
$FA0C  2B           DEC HL
CF_NEXT:
$FA0D  23           INC HL
CF_LINE:
$FA0E  22 D3 EC     LD (P_WORK1),HL
$FA11  CD 20 17     CALL RECLEN
$FA14  ED 53 D5 EC  LD (P_WORK2),DE
$FA18  56           LD D,(HL)
$FA19  23           INC HL
$FA1A  5E           LD E,(HL)
$FA1B  23           INC HL
$FA1C  E5           PUSH HL
$FA1D  2A CD EC     LD HL,(P_FINISH)
$FA20  A7           AND A
$FA21  ED 52        SBC HL,DE
$FA23  E1           POP HL
$FA24  D8           RET C
$FA25  23           INC HL
CF_SKIP:
$FA26  23           INC HL
$FA27  7E           LD A,(HL)
$FA28  FE 21        CP $21
$FA2A  38 FA        JR C,CF_SKIP       ; skip leading control bytes
$FA2C  FE EA        CP $EA             ; REM as the first statement?
$FA2E  20 0C        JR NZ,CF_COLON
$FA30  ED 5B D3 EC  LD DE,(P_WORK1)
$FA34  2A D5 EC     LD HL,(P_WORK2)
$FA37  CD 4D 17     CALL DEL_DE        ; delete the whole line
$FA3A  18 D2        JR CF_LINE
;   Otherwise look for a ":REM" outside quotes and cut from there.
CF_COLON:
$FA3C  0E 00        LD C,$00           ; C counts quote marks
CF_CHAR:
$FA3E  23           INC HL
$FA3F  7E           LD A,(HL)
CF_NUM:
$FA40  CD 02 16     CALL SKIPNUM
$FA43  28 FB        JR Z,CF_NUM
$FA45  FE 0D        CP $0D
$FA47  28 C4        JR Z,CF_NEXT
$FA49  FE 22        CP '"'
$FA4B  20 01        JR NZ,CF_COL2
$FA4D  0C           INC C
CF_COL2:
$FA4E  FE 3A        CP ':'
$FA50  20 EC        JR NZ,CF_CHAR
$FA52  CB 41        BIT 0,C
$FA54  20 E8        JR NZ,CF_CHAR      ; inside a string - ignore
$FA56  5D           LD E,L
$FA57  54           LD D,H             ; DE = the ":"
CF_SEEK:
$FA58  23           INC HL
$FA59  7E           LD A,(HL)
$FA5A  FE 0D        CP $0D
$FA5C  28 AF        JR Z,CF_NEXT
$FA5E  FE 21        CP $21
$FA60  38 F6        JR C,CF_SEEK
$FA62  FE EA        CP $EA             ; REM
$FA64  EB           EX DE,HL
$FA65  20 D7        JR NZ,CF_CHAR
$FA67  EB           EX DE,HL
$FA68  2A D5 EC     LD HL,(P_WORK2)
$FA6B  2B           DEC HL
$FA6C  CD 4D 17     CALL DEL_DE        ; cut ":REM..." to end of line
$FA6F  ED 5B D3 EC  LD DE,(P_WORK1)
$FA73  13           INC DE
$FA74  13           INC DE
$FA75  13           INC DE
$FA76  A7           AND A
$FA77  ED 52        SBC HL,DE
$FA79  EB           EX DE,HL
$FA7A  72           LD (HL),D          ; rewrite the length word
$FA7B  2B           DEC HL
$FA7C  73           LD (HL),E
$FA7D  2B           DEC HL
$FA7E  2B           DEC HL
$FA7F  18 8D        JR CF_LINE

;=====================================================================
; COMMAND G  —  UDG Designer  ($FA81)
; Edits one user-defined graphic as an 8x8 grid of block characters.
; The grid is drawn at screen address $406C (char row 3, column 12);
; the eight pixel rows are $406C, $416C ... $476C, so INC H steps a
; row.  The editor reads and writes the screen directly and only
; copies the result into the UDG area when you press 9A..9U.
;=====================================================================
CMD_G:
$FA81  CD 8F ED     CALL SCRIPT_CLS
$FA84  DEFB $0D
$FA85  DEFB $F4,$D2                  ; " DESIGN UDGs"
$FA87  DEFB $FE
$FA88  DEFB $B5                      ; " CHARACTER: "
$FA89  DEFB $11,$00,$12,$00          ;   -> string buffer 0
$FA8D  DEFB $00                      ; "EXECUTE?"
$FA8E  3E FE        LD A,$FE
$FA90  CD 30 12     CALL SELECT
$FA93  3E 16        LD A,$16           ; AT
$FA95  D7           RST $10
$FA96  3E 05        LD A,$05           ; row 5
$FA98  D7           RST $10
$FA99  AF           XOR A              ; column 0
$FA9A  D7           RST $10
$FA9B  CD 97 ED     CALL SCRIPT
$FA9E  DEFB $F6,$C7,$F8,$F9          ; " USE LINE COLUMN I/O (on/off)"
$FAA2  DEFB $19
$FAA3  3E FE        LD A,$FE
$FAA5  CD 30 12     CALL SELECT
$FAA8  11 DB FB     LD DE,FUNCTAB
$FAAB  AF           XOR A
$FAAC  CD 3F 07     CALL PUTMES        ; the FUNCTIONS panel
;---------------------------------------------------------------------
; Redraw the grid and wait for a command.
;---------------------------------------------------------------------
CG_DRAW:
$FAAF  CD 66 FB     CALL CG_AT70
$FAB2  06 08        LD B,$08
CG_ROW:
$FAB4  C5           PUSH BC
$FAB5  3E 20        LD A,$20
$FAB7  D7           RST $10
$FAB8  3E 09        LD A,$09
$FABA  90           SUB B
$FABB  5F           LD E,A             ; E = row 1..8
$FABC  C6 30        ADD A,'0'
$FABE  D7           RST $10
$FABF  21 6C 3F     LD HL,$3F6C
$FAC2  7B           LD A,E
$FAC3  84           ADD A,H
$FAC4  67           LD H,A             ; HL = $406C + row*256
$FAC5  4E           LD C,(HL)
$FAC6  06 08        LD B,$08
CG_PIX:
$FAC8  CB 11        RL C
$FACA  3E 20        LD A,$20
$FACC  30 02        JR NC,CG_PUT
$FACE  3E 8F        LD A,$8F           ; solid block graphic
CG_PUT:
$FAD0  D7           RST $10
$FAD1  10 F5        DJNZ CG_PIX
$FAD3  C1           POP BC
$FAD4  7B           LD A,E
$FAD5  C6 30        ADD A,'0'
$FAD7  D7           RST $10
$FAD8  3E 0D        LD A,$0D
$FADA  D7           RST $10
$FADB  10 D7        DJNZ CG_ROW
$FADD  CD 6E FB     CALL CG_ABC
$FAE0  CD 97 ED     CALL SCRIPT
$FAE3  DEFB $0D
$FAE4  DEFM " 0 ="
$FAE8  DEFB $FD                      ; MSG 61 "RESTART"
$FAE9  DEFB $FE,$20
$FAEB  DEFB $19
$FAEC  3E FE        LD A,$FE
$FAEE  CD 30 12     CALL SELECT
$FAF1  CD C4 F8     CALL $F8C4         ; the A-U column letters
CG_CMD:
$FAF4  01 04 00     LD BC,$0004
$FAF7  21 D7 EC     LD HL,STR0_LEN
$FAFA  E5           PUSH HL
$FAFB  CD 9A EE     CALL INSTR
$FAFE  D1           POP DE
$FAFF  13           INC DE
$FB00  13           INC DE
$FB01  1A           LD A,(DE)          ; first character
$FB02  CD D9 30     CALL DIGITQ
$FB05  38 ED        JR C,CG_CMD        ; must start with a digit
$FB07  D6 30        SUB '0'
$FB09  CA 81 FA     JP Z,CMD_G         ; "0" - restart
$FB0C  FE 09        CP $09
$FB0E  28 31        JR Z,CG_FUNC       ; "9" - a function
$FB10  2E 6C        LD L,$6C           ; 1..8 = a pixel row
$FB12  C6 3F        ADD A,$3F
$FB14  67           LD H,A
$FB15  13           INC DE
CG_COL:
$FB16  1A           LD A,(DE)
$FB17  E6 DF        AND $DF
$FB19  FE 41        CP 'A'
$FB1B  38 D7        JR C,CG_CMD
$FB1D  FE 49        CP 'H'+1
$FB1F  30 D3        JR NC,CG_CMD
$FB21  D6 40        SUB '@'            ; 1..8
$FB23  47           LD B,A
$FB24  AF           XOR A
CG_MASK:
$FB25  37           SCF
CG_MSK2:
$FB26  1F           RRA                ; build the single-bit mask
$FB27  10 FD        DJNZ CG_MSK2
$FB29  4F           LD C,A
$FB2A  13           INC DE
$FB2B  1A           LD A,(DE)
$FB2C  E6 DF        AND $DF
$FB2E  FE 49        CP 'I'
$FB30  28 09        JR Z,CG_SET
$FB32  FE 4F        CP 'O'
$FB34  20 BE        JR NZ,CG_CMD
$FB36  79           LD A,C
$FB37  2F           CPL
$FB38  A6           AND (HL)           ; O = pixel off
$FB39  18 02        JR CG_STORE
CG_SET:
$FB3B  79           LD A,C
$FB3C  B6           OR (HL)            ; I = pixel on
CG_STORE:
$FB3D  77           LD (HL),A
$FB3E  C3 AF FA     JP CG_DRAW
;---------------------------------------------------------------------
; 9A..9U  store the grid into UDG n;  9V..9Z  transform it
;---------------------------------------------------------------------
CG_FUNC:
$FB41  13           INC DE
$FB42  1A           LD A,(DE)
$FB43  E6 DF        AND $DF
$FB45  FE 56        CP 'V'
$FB47  30 32        JR NC,CG_XFORM
$FB49  D6 41        SUB 'A'
$FB4B  38 A7        JR C,CG_CMD
$FB4D  87           ADD A,A            ; *8
$FB4E  87           ADD A,A
$FB4F  87           ADD A,A
$FB50  5F           LD E,A
$FB51  16 00        LD D,$00
$FB53  2A 7B 5C     LD HL,(UDG)
$FB56  19           ADD HL,DE
$FB57  EB           EX DE,HL
$FB58  21 6C 40     LD HL,$406C
$FB5B  06 08        LD B,$08
CG_SAVE:
$FB5D  7E           LD A,(HL)
$FB5E  12           LD (DE),A
$FB5F  24           INC H
$FB60  13           INC DE
$FB61  10 FA        DJNZ CG_SAVE
$FB63  C3 81 FA     JP CMD_G
CG_AT70:
$FB66  3E 16        LD A,$16           ; AT 7,0
$FB68  D7           RST $10
$FB69  3E 07        LD A,$07
$FB6B  D7           RST $10
$FB6C  AF           XOR A
$FB6D  D7           RST $10
CG_ABC:
$FB6E  CD 97 ED     CALL SCRIPT
$FB71  DEFB $20,$FC,$0D              ; " ABCDEFGH"
$FB74  DEFB $19
$FB75  3E FE        LD A,$FE
$FB77  CD 30 12     CALL SELECT
$FB7A  C9           RET
CG_XFORM:
$FB7B  21 AF FA     LD HL,CG_DRAW
$FB7E  E5           PUSH HL            ; every transform returns to the redraw
$FB7F  FE 5A        CP 'Z'
$FB81  28 4C        JR Z,CG_RESET
$FB83  D0           RET NC
$FB84  21 6C 40     LD HL,$406C
$FB87  06 08        LD B,$08
$FB89  FE 59        CP 'Y'
$FB8B  28 2B        JR Z,CG_ROT
$FB8D  FE 58        CP 'X'
$FB8F  28 18        JR Z,CG_FLIPV
$FB91  FE 57        CP 'W'
$FB93  28 07        JR Z,CG_FLIPH
CG_INV:                               ; 9V  INVERSE
$FB95  7E           LD A,(HL)
$FB96  2F           CPL
$FB97  77           LD (HL),A
$FB98  24           INC H
$FB99  10 FA        DJNZ CG_INV
$FB9B  C9           RET
CG_FLIPH:                             ; 9W  LEFT-RIGHT
$FB9C  0E 08        LD C,$08
CG_FH2:
$FB9E  CB 16        RL (HL)
$FBA0  1F           RRA                ; shift bits out one way, in the other
$FBA1  0D           DEC C
$FBA2  20 FA        JR NZ,CG_FH2
$FBA4  77           LD (HL),A
$FBA5  24           INC H
$FBA6  10 F4        DJNZ CG_FLIPH
$FBA8  C9           RET
CG_FLIPV:                             ; 9X  UP-DOWN
$FBA9  06 04        LD B,$04
$FBAB  11 6C 47     LD DE,$476C
CG_FV2:
$FBAE  4E           LD C,(HL)
$FBAF  1A           LD A,(DE)
$FBB0  77           LD (HL),A
$FBB1  79           LD A,C
$FBB2  12           LD (DE),A
$FBB3  24           INC H
$FBB4  15           DEC D
$FBB5  10 F7        DJNZ CG_FV2
$FBB7  C9           RET
CG_ROT:                               ; 9Y  ROTATE (transpose)
$FBB8  11 02 48     LD DE,$4802
CG_ROT1:
$FBBB  D5           PUSH DE
$FBBC  0E 08        LD C,$08
CG_ROT2:
$FBBE  1A           LD A,(DE)
$FBBF  87           ADD A,A
$FBC0  CB 1E        RR (HL)
$FBC2  3E 20        LD A,$20
$FBC4  83           ADD A,E
$FBC5  5F           LD E,A
$FBC6  0D           DEC C
$FBC7  20 F5        JR NZ,CG_ROT2
$FBC9  D1           POP DE
$FBCA  1C           INC E
$FBCB  24           INC H
$FBCC  10 ED        DJNZ CG_ROT1
$FBCE  C9           RET
CG_RESET:                             ; 9Z  RESET UDGs
$FBCF  21 08 3E     LD HL,$3E08        ; ROM character set, 'A'
$FBD2  ED 5B 7B 5C  LD DE,(UDG)
$FBD6  01 A8 00     LD BC,$00A8        ; 21 characters * 8 rows
$FBD9  ED B0        LDIR
$FBDB  C9           RET
;                   ^ doubles as FUNCTAB's dummy terminator

;---------------------------------------------------------------------
; FUNCTAB  ($FBDB)  the one-entry table for the FUNCTIONS panel.
; $16 r c = AT, $06 = comma tab.
;---------------------------------------------------------------------
FUNCTAB:
$FBDC  DEFB $16,$07,$10               ; AT 7,16
$FBDF  DEFM "FUNCTIONS"
$FBE8  DEFB $0D,$0D,$06
$FBEB  DEFM "9A-9U ENTER UDG"
$FBFA  DEFB $0D,$0D,$06
$FBFD  DEFM "9V INVERSE"
$FC07  DEFB $0D,$06
$FC09  DEFM "9W LEFT-RIGHT"
$FC16  DEFB $0D,$06
$FC18  DEFM "9X UP-DOWN"
$FC22  DEFB $0D,$06
$FC24  DEFM "9Y ROTATE"
$FC2D  DEFB $0D,$06
$FC2F  DEFM "9Z RESET UDG"
$FC3B  DEFB $D3                       ; 'S'+$80 terminator

;=====================================================================
; COMMAND P  —  Compactor  ($FC3C)
; Strips spaces and control characters that are outside quotes, and
; skips REM lines entirely.
;=====================================================================
CMD_P:
$FC3C  CD 8F ED     CALL SCRIPT_CLS
$FC3F  DEFB $0D
$FC40  DEFB $F7,$CF                  ; " COMPACT PROGRAM"
$FC42  DEFB $FE
$FC43  DEFB $C1,$80,$13,$1A,$14      ; " START ADDRESS: "
$FC48  DEFB $FE
$FC49  DEFB $C2,$80,$13,$1B,$1C,$14  ; " FINISH ADDRESS: "
$FC4F  DEFB $FE
$FC50  DEFB $18,$17                  ; validate
$FC52  DEFB $00                      ; "EXECUTE?"
$FC53  2A CB EC     LD HL,(P_START)
$FC56  CD D6 16     CALL FIND_L
CP_LINE:
$FC59  CD 20 17     CALL RECLEN
$FC5C  46           LD B,(HL)
$FC5D  23           INC HL
$FC5E  4E           LD C,(HL)
$FC5F  23           INC HL             ; BC = line number
$FC60  E5           PUSH HL
$FC61  2A CD EC     LD HL,(P_FINISH)
$FC64  A7           AND A
$FC65  ED 42        SBC HL,BC
$FC67  E1           POP HL
$FC68  D8           RET C              ; past the last wanted line
$FC69  E5           PUSH HL
$FC6A  4E           LD C,(HL)          ; BC = line length
$FC6B  23           INC HL
$FC6C  46           LD B,(HL)
$FC6D  23           INC HL
$FC6E  7E           LD A,(HL)
$FC6F  FE EA        CP $EA             ; a REM line?
$FC71  20 04        JR NZ,CP_START
$FC73  EB           EX DE,HL           ; yes - leave it alone
$FC74  C1           POP BC
$FC75  18 E2        JR CP_LINE
CP_START:
$FC77  1E 00        LD E,$00           ; E bit 0 = inside a string
CP_CHAR:
$FC79  CD 02 16     CALL SKIPNUM
$FC7C  28 FB        JR Z,CP_CHAR
$FC7E  FE 0D        CP $0D
$FC80  20 08        JR NZ,CP_TEST
$FC82  E1           POP HL             ; end of line: rewrite its length
$FC83  71           LD (HL),C
$FC84  23           INC HL
$FC85  70           LD (HL),B
$FC86  23           INC HL
$FC87  09           ADD HL,BC
$FC88  18 CF        JR CP_LINE
CP_TEST:
$FC8A  FE 22        CP '"'
$FC8C  20 01        JR NZ,CP_SP
$FC8E  1C           INC E
CP_SP:
$FC8F  FE 21        CP $21             ; anything below "!" is droppable
$FC91  23           INC HL
$FC92  7E           LD A,(HL)
$FC93  30 E4        JR NC,CP_CHAR
$FC95  CB 43        BIT 0,E
$FC97  20 E0        JR NZ,CP_CHAR      ; inside a string - keep it
$FC99  2B           DEC HL
$FC9A  C5           PUSH BC
$FC9B  CD 7E 0B     CALL DELSYM        ; delete this one byte
$FC9E  C1           POP BC
$FC9F  0B           DEC BC             ; line got one shorter
$FCA0  AF           XOR A
$FCA1  5F           LD E,A
$FCA2  18 EE        JR $FC92

;=====================================================================
; COMMAND J  —  Merge Lines  ($FCA4)
; Joins each line in the range onto the previous one with a ":".
;=====================================================================
CMD_J:
$FCA4  CD 8F ED     CALL SCRIPT_CLS
$FCA7  DEFB $0D
$FCA8  DEFB $E1,$CF,$C7              ; " MERGE PROGRAM LINE"
$FCAB  DEFM "S"
$FCAC  DEFB $FE
$FCAD  DEFB $C1,$80,$13,$1A,$14      ; " START ADDRESS: "
$FCB2  DEFB $FE
$FCB3  DEFB $C2,$80,$13,$1B,$1C,$14  ; " FINISH ADDRESS: "
$FCB9  DEFB $18,$17                  ; validate
$FCBB  DEFB $00                      ; "EXECUTE?"
$FCBC  2A CB EC     LD HL,(P_START)
$FCBF  CD D6 16     CALL FIND_L
$FCC2  23           INC HL
$FCC3  23           INC HL
$FCC4  54           LD D,H
$FCC5  5D           LD E,L             ; DE -> this line's length word
$FCC6  4E           LD C,(HL)
$FCC7  23           INC HL
$FCC8  46           LD B,(HL)
$FCC9  09           ADD HL,BC          ; HL -> the closing $0D
$FCCA  36 3A        LD (HL),':'        ; turn it into a statement separator
$FCCC  E5           PUSH HL
$FCCD  23           INC HL
$FCCE  46           LD B,(HL)          ; next line's number
$FCCF  23           INC HL
$FCD0  4E           LD C,(HL)
$FCD1  23           INC HL
$FCD2  E5           PUSH HL
$FCD3  2A CD EC     LD HL,(P_FINISH)
$FCD6  A7           AND A
$FCD7  ED 42        SBC HL,BC
$FCD9  E1           POP HL
$FCDA  38 17        JR C,CJ_DONE       ; past the range
$FCDC  4E           LD C,(HL)          ; next line's length
$FCDD  23           INC HL
$FCDE  46           LD B,(HL)
$FCDF  E5           PUSH HL
$FCE0  EB           EX DE,HL
$FCE1  5E           LD E,(HL)
$FCE2  23           INC HL
$FCE3  56           LD D,(HL)
$FCE4  EB           EX DE,HL
$FCE5  09           ADD HL,BC          ; combined length
$FCE6  EB           EX DE,HL
$FCE7  72           LD (HL),D
$FCE8  2B           DEC HL
$FCE9  73           LD (HL),E
$FCEA  E1           POP HL
$FCEB  D1           POP DE
$FCEC  23           INC HL
$FCED  13           INC DE
$FCEE  CD 4D 17     CALL DEL_DE        ; remove the second line's header
$FCF1  18 C9        JR CMD_J+$18       ; -> $FCBC, do it again
CJ_DONE:
$FCF3  E1           POP HL
$FCF4  36 0D        LD (HL),$0D        ; restore the final newline
$FCF6  C9           RET

;=====================================================================
; COMMANDS K / L  —  Upper Case / Lower Case  ($FCF7 / $FD03)
; C bit 7 set = force upper case;  C bit 0 set = also inside quotes.
;=====================================================================
CMD_K:
$FCF7  CD 8F ED     CALL SCRIPT_CLS
$FCFA  DEFB $0D
$FCFB  DEFB $DD,$D3,$DC              ; " lower TO UPPER"
$FCFE  DEFB $19
$FCFF  0E 80        LD C,$80
$FD01  18 0A        JR CASE_ASK
CMD_L:
$FD03  CD 8F ED     CALL SCRIPT_CLS
$FD06  DEFB $0D
$FD07  DEFB $DC,$D3,$DD              ; " UPPER TO lower"
$FD0A  DEFB $19
$FD0B  0E 00        LD C,$00
CASE_ASK:
$FD0D  C5           PUSH BC
$FD0E  CD 92 ED     CALL SCRIPT_FE
$FD11  DEFB $DE                      ; " CASE"
$FD12  DEFB $FE
$FD13  DEFB $C1,$80,$13,$1A,$14      ; " START ADDRESS: "
$FD18  DEFB $FE
$FD19  DEFB $C2,$80,$13,$1B,$1C,$14  ; " FINISH ADDRESS: "
$FD1F  DEFB $18,$17
$FD21  DEFB $FE
$FD22  DEFB $BA                      ; " IN QUOTES? (Y/N): "
$FD23  DEFB $11,$00,$12,$00
$FD27  DEFB $00                      ; "EXECUTE?"
$FD28  2A CD EC     LD HL,(P_FINISH)
$FD2B  23           INC HL
$FD2C  CD D6 16     CALL FIND_L
$FD2F  E5           PUSH HL
$FD30  2A CB EC     LD HL,(P_START)
$FD33  CD D6 16     CALL FIND_L
$FD36  D1           POP DE             ; DE = one past the block
$FD37  C1           POP BC             ; C = the direction flag
$FD38  3A D9 EC     LD A,(STR0)
$FD3B  E6 DF        AND $DF
$FD3D  FE 59        CP 'Y'
$FD3F  20 01        JR NZ,CASE_HDR
$FD41  0C           INC C              ; also convert inside strings
CASE_HDR:
$FD42  06 00        LD B,$00           ; B bit 0 = inside a string
$FD44  23           INC HL
$FD45  23           INC HL
$FD46  23           INC HL
$FD47  23           INC HL
CASE_CHAR:
$FD48  23           INC HL
$FD49  A7           AND A
$FD4A  ED 52        SBC HL,DE
$FD4C  D0           RET NC             ; reached the end
$FD4D  19           ADD HL,DE
$FD4E  7E           LD A,(HL)
CASE_NUM:
$FD4F  CD 02 16     CALL SKIPNUM
$FD52  28 FB        JR Z,CASE_NUM
$FD54  FE 0D        CP $0D
$FD56  28 EA        JR Z,CASE_HDR
$FD58  FE 22        CP '"'
$FD5A  20 01        JR NZ,CASE_TEST
$FD5C  04           INC B
CASE_TEST:
$FD5D  CD 4B 30     CALL ALPHAQ
$FD60  30 E6        JR NC,CASE_CHAR    ; not a letter
$FD62  CB 40        BIT 0,B
$FD64  28 04        JR Z,CASE_DO
$FD66  CB 41        BIT 0,C
$FD68  28 DE        JR Z,CASE_CHAR     ; in a string and told not to
CASE_DO:
$FD6A  CB EE        SET 5,(HL)         ; lower case
$FD6C  CB 79        BIT 7,C
$FD6E  28 D8        JR Z,CASE_CHAR
$FD70  CB AE        RES 5,(HL)         ; upper case
$FD72  18 D4        JR CASE_CHAR

;=====================================================================
; COMMAND N  —  Autoline On  ($FD74)
; Installs an interrupt routine that types the next line number for
; you: when the edit line is empty and you press ENTER, it feeds the
; digits of E_PPC+increment into LASTK one per interrupt.
;=====================================================================
CMD_N:
$FD74  CD 8F ED     CALL SCRIPT_CLS
$FD77  DEFB $0D
$FD78  DEFB $FB,$C7,$C8              ; " AUTO LINE NUMBER"
$FD7B  DEFB $FE
$FD7C  DEFB $86,$13,$1D,$14          ; " INCREMENT: "  -> P_INCR
$FD80  DEFB $15,$16                  ; non-zero, <= 100
$FD82  DEFB $00                      ; "EXECUTE?"
$FD83  2A D1 EC     LD HL,(P_INCR)
$FD86  22 4F FF     LD (V_INCR),HL
$FD89  21 8F FD     LD HL,AUTOLINE
$FD8C  C3 41 FF     JP SET_IM2
;---------------------------------------------------------------------
; AUTOLINE  ($FD8F)  called from the ISR, 60 times a second
;---------------------------------------------------------------------
AUTOLINE:
$FD8F  3A 52 FF     LD A,(V_DIGIT)
$FD92  A7           AND A
$FD93  20 18        JR NZ,AL_FEED      ; already part-way through
$FD95  2A 82 5C     LD HL,(ECHOE)
$FD98  3E 20        LD A,$20
$FD9A  BD           CP L
$FD9B  C0           RET NZ             ; edit line not empty
$FD9C  3E 17        LD A,$17
$FD9E  BC           CP H
$FD9F  C0           RET NZ
$FDA0  3A 08 5C     LD A,(LASTK)
$FDA3  FE 0D        CP $0D
$FDA5  C0           RET NZ             ; only after ENTER
$FDA6  3A 3B 5C     LD A,(FLAGS)
$FDA9  87           ADD A,A
$FDAA  D8           RET C
$FDAB  3E 04        LD A,$04           ; four digits to send
AL_FEED:
$FDAD  3D           DEC A
$FDAE  32 52 FF     LD (V_DIGIT),A
$FDB1  2A 49 5C     LD HL,(EPPC)       ; the line the cursor is on
$FDB4  ED 5B 4F FF  LD DE,(V_INCR)
$FDB8  19           ADD HL,DE          ; ... plus the increment
$FDB9  01 18 FC     LD BC,-1000
$FDBC  CD D4 FD     CALL AL_DIGIT
$FDBF  FE 03        CP $03
$FDC1  C8           RET Z
$FDC2  01 9C FF     LD BC,-100
$FDC5  CD D4 FD     CALL AL_DIGIT
$FDC8  FE 02        CP $02
$FDCA  C8           RET Z
$FDCB  0E F6        LD C,$F6           ; BC = -10
$FDCD  CD D4 FD     CALL AL_DIGIT
$FDD0  3D           DEC A
$FDD1  C8           RET Z
$FDD2  0E FF        LD C,$FF           ; BC = -1
AL_DIGIT:
$FDD4  AF           XOR A
AL_DIV:
$FDD5  3C           INC A
$FDD6  09           ADD HL,BC
$FDD7  38 FC        JR C,AL_DIV
$FDD9  ED 42        SBC HL,BC
$FDDB  C6 2F        ADD A,'0'-1
$FDDD  E5           PUSH HL
$FDDE  32 08 5C     LD (LASTK),A       ; pretend the user typed it
$FDE1  21 3B 5C     LD HL,FLAGS
$FDE4  CB EE        SET 5,(HL)         ; "a new key is ready"
$FDE6  E1           POP HL
$FDE7  3A 52 FF     LD A,(V_DIGIT)
$FDEA  C9           RET

;=====================================================================
; COMMAND Q  —  Display Memory  ($FDEB)
; Puts a live "memory left" figure in the top right of the screen.
;=====================================================================
CMD_Q:
$FDEB  CD 8F ED     CALL SCRIPT_CLS
$FDEE  DEFB $0D
$FDEF  DEFB $EA,$EB                  ; " MEMORY LEFT"
$FDF1  DEFB $00                      ; "EXECUTE?"
$FDF2  21 44 FE     LD HL,SHOW_FREE
$FDF5  18 27        JR $FE1E           ; -> JP SET_IM2

;=====================================================================
; COMMAND T  —  Trace on  ($FDF7)
; Shows the line number currently being interpreted, top right.
;=====================================================================
CMD_T:
$FDF7  CD 8F ED     CALL SCRIPT_CLS
$FDFA  DEFB $0D
$FDFB  DEFM " TRACE ON"
$FE04  DEFB $FE
$FE05  DEFM " SPEED: "
$FE0D  DEFB $13,$1D,$14              ;   -> P_INCR
$FE10  DEFB $16                      ; 1..100
$FE11  DEFB $00                      ; "EXECUTE?"
$FE12  3E 65        LD A,101
$FE14  2A D1 EC     LD HL,(P_INCR)
$FE17  95           SUB L
$FE18  32 51 FF     LD (V_DELAY),A     ; delay = 101 - speed
$FE1B  21 21 FE     LD HL,SHOW_LINE
$FE1E  C3 41 FF     JP SET_IM2

;---------------------------------------------------------------------
; SHOW_LINE  ($FE21)  the trace interrupt routine.
; Reads the H/J/K/L/ENTER half-row: ENTER+L holds the display,
; ENTER+K skips the delay.
;---------------------------------------------------------------------
SHOW_LINE:
$FE21  3E BF        LD A,$BF
$FE23  DB FE        IN A,($FE)
$FE25  E6 07        AND $07
$FE27  FE 04        CP $04
$FE29  28 F6        JR Z,SHOW_LINE     ; hold
$FE2B  FE 02        CP $02
$FE2D  28 10        JR Z,SL_NOW        ; no delay
$FE2F  3A 51 FF     LD A,(V_DELAY)
SL_WAIT:
$FE32  01 F4 01     LD BC,500
$FE35  21 00 00     LD HL,$0000
$FE38  54           LD D,H
$FE39  5D           LD E,L
$FE3A  ED B0        LDIR               ; a 500-iteration delay
$FE3C  3D           DEC A
$FE3D  20 F3        JR NZ,SL_WAIT
SL_NOW:
$FE3F  2A 45 5C     LD HL,(PPC)        ; the line being interpreted
$FE42  18 0A        JR PAINT
;---------------------------------------------------------------------
; SHOW_FREE  ($FE44)  the "memory left" interrupt routine
;---------------------------------------------------------------------
SHOW_FREE:
$FE44  A7           AND A
$FE45  2A B2 5C     LD HL,(RAMTOP)
$FE48  ED 5B 59 5C  LD DE,(ELINE)
$FE4C  ED 52        SBC HL,DE
;---------------------------------------------------------------------
; PAINT  ($FE4E)  write HL as five characters straight into the
; display file at $401A (top line, columns 26-30) by copying glyphs
; out of the ROM character set at $3D80 ('0').
;---------------------------------------------------------------------
PAINT:
$FE4E  11 1A 40     LD DE,$401A
$FE51  ED 53 53 FF  LD (V_SCRN),DE
$FE55  01 F0 D8     LD BC,-10000
$FE58  CD 70 FE     CALL PAINT1
$FE5B  01 18 FC     LD BC,-1000
$FE5E  CD 70 FE     CALL PAINT1
$FE61  01 9C FF     LD BC,-100
$FE64  CD 70 FE     CALL PAINT1
$FE67  01 F6 FF     LD BC,-10
$FE6A  CD 70 FE     CALL PAINT1
$FE6D  01 FF FF     LD BC,-1
PAINT1:
$FE70  AF           XOR A
PAINT2:
$FE71  3C           INC A
$FE72  09           ADD HL,BC
$FE73  38 FC        JR C,PAINT2
$FE75  ED 42        SBC HL,BC
$FE77  87           ADD A,A            ; A = digit+1, so *8 ...
$FE78  87           ADD A,A
$FE79  87           ADD A,A
$FE7A  C6 78        ADD A,$78          ; ... + $78 = $80 + 8*digit
$FE7C  5F           LD E,A
$FE7D  16 3D        LD D,$3D           ; DE = $3D80 + 8*digit
$FE7F  E5           PUSH HL
$FE80  2A 53 FF     LD HL,(V_SCRN)
$FE83  23           INC HL
$FE84  22 53 FF     LD (V_SCRN),HL
$FE87  06 08        LD B,$08
PAINT3:
$FE89  1A           LD A,(DE)
$FE8A  77           LD (HL),A
$FE8B  13           INC DE
$FE8C  24           INC H              ; next pixel row of the same cell
$FE8D  10 FA        DJNZ PAINT3
$FE8F  E1           POP HL
$FE90  C9           RET

;=====================================================================
; COMMAND O  —  Locate Token  ($FE91)
; Reports the address of the first symbol of a given BASIC line, in
; both decimal and hex — what you need before POKEing code into a REM.
;=====================================================================
CMD_O:
$FE91  CD 8F ED     CALL SCRIPT_CLS
$FE94  DEFB $0D
$FE95  DEFM " FIND"
$FE9A  DEFB $C0,$CE,$C3,$E4          ; " ADDRESS OF 1st SYMBOL"
$FE9E  DEFB $FE
$FE9F  DEFB $C7,$88                  ; " LINE NUMBER: "
$FEA1  DEFB $13,$1B,$1C,$14          ;   -> P_FINISH and P_DEST
$FEA5  DEFB $17
$FEA6  DEFB $00                      ; "EXECUTE?"
$FEA7  2A CF EC     LD HL,(P_DEST)
$FEAA  CD D6 16     CALL FIND_L
$FEAD  C4 4A EF     CALL NZ,REPORT
$FEB0  03           DEFB 3             ; "Invalid Line Number"
$FEB1  23           INC HL             ; step over the 4-byte header
$FEB2  23           INC HL
$FEB3  23           INC HL
$FEB4  23           INC HL
$FEB5  CD 97 ED     CALL SCRIPT
$FEB8  DEFB $C0                      ; " ADDRESS"
$FEB9  DEFM " IS"
$FEBC  DEFB $FE
$FEBD  DEFB $9F,$14                  ; " DEC: " + the value
$FEBF  DEFB $06                      ; comma tab
$FEC0  DEFB $A0,$10                  ; " HEX: " + "#hhhh"
$FEC2  DEFB $19
$FEC3  C9           RET

;=====================================================================
; PRBC  ($FEC4)  print BC as decimal, preserving HL/DE
;=====================================================================
PRBC:
$FEC4  E5           PUSH HL
$FEC5  D5           PUSH DE
$FEC6  60           LD H,B
$FEC7  69           LD L,C
$FEC8  CD AD EC     CALL PRDEC
$FECB  D1           POP DE
$FECC  E1           POP HL
$FECD  C9           RET

;---------------------------------------------------------------------
; $FECE-$FED7   10 spare bytes (all $00)
;---------------------------------------------------------------------
$FECE  DEFS 10,$00

;=====================================================================
; NUMBER_ALL  ($FED8)
; Rebuilds all line lengths, then renumbers every line 1,2,3...
; No reference to this routine exists anywhere in the image; it looks
; like a leftover, or something meant to be called from BASIC.
;=====================================================================
NUMBER_ALL:
$FED8  CD 52 F4     CALL REBUILD
$FEDB  11 00 00     LD DE,$0000
$FEDE  2A 53 5C     LD HL,(PROG)
NA_LOOP:
$FEE1  13           INC DE
$FEE2  72           LD (HL),D
$FEE3  23           INC HL
$FEE4  73           LD (HL),E
$FEE5  23           INC HL
$FEE6  4E           LD C,(HL)
$FEE7  23           INC HL
$FEE8  46           LD B,(HL)
$FEE9  23           INC HL
$FEEA  09           ADD HL,BC
$FEEB  E5           PUSH HL
$FEEC  ED 4B 4B 5C  LD BC,(VARS)
$FEF0  A7           AND A
$FEF1  ED 42        SBC HL,BC
$FEF3  E1           POP HL
$FEF4  38 EB        JR C,NA_LOOP
$FEF6  C9           RET

;---------------------------------------------------------------------
; $FEF7-$FEFE   8 spare bytes (all $00)
;---------------------------------------------------------------------
$FEF7  DEFS 8,$00

;=====================================================================
; ISR  ($FEFF)  the interrupt service routine reached via $E9E9.
; RST $38 runs the ROM's own maskable-interrupt handler first (FRAMES
; and the keyboard scan), then the toolkit's own work is done with
; interrupts disabled.
;=====================================================================
ISR:
$FEFF  00           NOP
$FF00  00           NOP
$FF01  FF           RST $38            ; ROM keyboard/FRAMES handler
$FF02  F3           DI
$FF03  C5           PUSH BC
$FF04  D5           PUSH DE
$FF05  E5           PUSH HL
$FF06  F5           PUSH AF
$FF07  CD 10 FF     CALL ISR_WORK
$FF0A  F1           POP AF
$FF0B  E1           POP HL
$FF0C  D1           POP DE
$FF0D  C1           POP BC
$FF0E  FB           EI
$FF0F  C9           RET

;---------------------------------------------------------------------
; ISR_WORK  ($FF10)
; 1. the NEW lock: the key decoder produces $E6 (NEW) for "A" in K
;    mode; swap it for $E2 (STOP).  Then, unless SYMBOL SHIFT is being
;    held, throw the keypress away entirely.  Net effect: NEW cannot
;    be typed by accident, and STOP still works the normal way.
; 2. call whatever routine command N/Q/T left in V_USER.
;---------------------------------------------------------------------
ISR_WORK:
$FF10  21 08 5C     LD HL,LASTK
$FF13  3E E6        LD A,$E6           ; NEW
$FF15  BE           CP (HL)
$FF16  20 02        JR NZ,IW_STOP
$FF18  36 E2        LD (HL),$E2        ; -> STOP
IW_STOP:
$FF1A  3E E2        LD A,$E2
$FF1C  BE           CP (HL)
$FF1D  20 0F        JR NZ,IW_USER
$FF1F  3E 7F        LD A,$7F           ; half-row B N M SYMSHIFT SPACE
$FF21  DB FE        IN A,($FE)
$FF23  CB 4F        BIT 1,A            ; SYMBOL SHIFT held?
$FF25  20 07        JR NZ,IW_USER
$FF27  21 3B 5C     LD HL,FLAGS
$FF2A  3E D7        LD A,$D7           ; clear bits 5 and 3
$FF2C  A6           AND (HL)
$FF2D  77           LD (HL),A          ; discard the keypress
IW_USER:
$FF2E  2A 4D FF     LD HL,(V_USER)
$FF31  7C           LD A,H
$FF32  B5           OR L
$FF33  C8           RET Z
$FF34  E9           JP (HL)

;=====================================================================
; COMMAND X  —  N/Q/T/W off  ($FF35)
; Puts the machine back on the ROM's own IM1 interrupt.
;=====================================================================
CMD_X:
$FF35  F3           DI
$FF36  3E 3F        LD A,$3F
$FF38  ED 47        LD I,A
$FF3A  ED 56        IM 1
$FF3C  FB           EI
$FF3D  C9           RET

;=====================================================================
; COMMAND W  —  Disable NEW  ($FF3E)
; Enables IM2 with no user routine, so ISR_WORK's NEW lock is the only
; thing running.
;=====================================================================
CMD_W:
$FF3E  21 00 00     LD HL,$0000
;=====================================================================
; SET_IM2  ($FF41)  install HL as the per-interrupt routine and turn
; interrupt mode 2 on.  IM2_INIT must have run first.
;=====================================================================
SET_IM2:
$FF41  F3           DI
$FF42  22 4D FF     LD (V_USER),HL
$FF45  3E E8        LD A,$E8
$FF47  ED 47        LD I,A
$FF49  ED 5E        IM 2
$FF4B  FB           EI
$FF4C  C9           RET

;=====================================================================
; Interrupt-time variables ($FF4D-$FF57).  Values shown are whatever
; the captured image happened to contain.
;=====================================================================
V_USER:   $FF4D  DEFW $FE44   ; routine called each interrupt (0 = none)
V_INCR:   $FF4F  DEFW $000A   ; N: autoline increment
V_DELAY:  $FF51  DEFB $15     ; T: trace delay, 101 - speed
V_DIGIT:  $FF52  DEFB $00     ; N: digits still to feed
V_SCRN:   $FF53  DEFW $401F   ; Q/T: next display-file cell to paint
          $FF55  DEFB $13,$00,$3E  ; spare / uninitialised
;                          end of image, $FF57

;=====================================================================
; APPENDIX  —  every prompt script rendered, straight from the bytes
; (produced by interpreting the scripts above; verifies the decode)
;=====================================================================
; ==================================================================
; A   ($F1B0)
; ------------------------------------------------------------------
; 
;  SEARCH & REPLACE  START ADDRESS: <input num><-P_START><print dec>  FINISH ADDRESS: <input num><-P_FINISH><-P_DEST><print dec>  OLD STRING: <input str0><echo str0>  NEW STRING: <input str1><echo str1>  LIST ? (0=no): <input num><-P_INCR><print dec><check 22><check 23><check 24>
; <EXECUTE? y/n>
; ==================================================================
; B   ($F6F1)
; ------------------------------------------------------------------
; 
;  MACHINE CODE TO DATA  START ADDRESS: <input num><-P_START><print dec>  FINISH ADDRESS: <input num><-P_FINISH><print dec> <check 24> 1st LINE NUMBER: <input num><-P_DEST><print dec>  BYTES PER LINE: <input num><-P_INCR><print dec><err if 0><check 22>
; <run, resume $F714>
; ==================================================================
; C   ($F59D)
; ------------------------------------------------------------------
; 
;  COPY
; <run, resume $F5A0>
; ==================================================================
; D   ($F613)
; ------------------------------------------------------------------
; 
;  DELETE BLOCK OF PROGRAM  START ADDRESS: <input num><-P_START><print dec>  FINISH ADDRESS: <input num><-P_FINISH><-P_DEST><print dec><check 24><check 23>
; <EXECUTE? y/n>
; ==================================================================
; E   ($F642)
; ------------------------------------------------------------------
; 
;  CREATE REM LINE  LINE NUMBER: <input num><-P_FINISH><-P_DEST><print dec><check 23>  LENGTH: <input num><-P_INCR><print dec><err if 0>  SYMBOL: <input str0><echo str0>
; <EXECUTE? y/n>
; ==================================================================
; F   ($F9F2)
; ------------------------------------------------------------------
; 
;  REM DELETE  START ADDRESS: <input num><-P_START><print dec>  FINISH ADDRESS: <input num><-P_FINISH><-P_DEST><print dec> <check 24><check 23>
; <EXECUTE? y/n>
; ==================================================================
; G   ($FA84)
; ------------------------------------------------------------------
; 
;  DESIGN UDGs  CHARACTER: <input str0><echo str0>
; <EXECUTE? y/n>
; ==================================================================
; H   ($F17A)
; ------------------------------------------------------------------
; 
;  HEX & DECIMAL  Precede HEX nos with "#".
; <run, resume $F19C>
; ==================================================================
; I   ($F83D)
; ------------------------------------------------------------------
; 
;  STATUS REPORT  MEMORY LEFT: 
; <run, resume $F844>
; ==================================================================
; J   ($FCA7)
; ------------------------------------------------------------------
; 
;  MERGE PROGRAM LINES  START ADDRESS: <input num><-P_START><print dec>  FINISH ADDRESS: <input num><-P_FINISH><-P_DEST><print dec><check 24><check 23>
; <EXECUTE? y/n>
; ==================================================================
; K   ($FCFA)
; ------------------------------------------------------------------
; 
;  lower TO UPPER
; <run, resume $FCFF>
; ==================================================================
; L   ($FD06)
; ------------------------------------------------------------------
; 
;  UPPER TO lower
; <run, resume $FD0B>
; ==================================================================
; M   ($F327)
; ------------------------------------------------------------------
; 
;  MOVE
; <run, resume $F32A>
; ==================================================================
; N   ($FD77)
; ------------------------------------------------------------------
; 
;  AUTO LINE NUMBER  INCREMENT: <input num><-P_INCR><print dec><err if 0><check 22>
; <EXECUTE? y/n>
; ==================================================================
; O   ($FE94)
; ------------------------------------------------------------------
; 
;  FIND ADDRESS OF 1st SYMBOL  LINE NUMBER: <input num><-P_FINISH><-P_DEST><print dec><check 23>
; <EXECUTE? y/n>
; ==================================================================
; P   ($FC3F)
; ------------------------------------------------------------------
; 
;  COMPACT PROGRAM  START ADDRESS: <input num><-P_START><print dec>  FINISH ADDRESS: <input num><-P_FINISH><-P_DEST><print dec> <check 24><check 23>
; <EXECUTE? y/n>
; ==================================================================
; Q   ($FDEE)
; ------------------------------------------------------------------
; 
;  MEMORY LEFT
; <EXECUTE? y/n>
; ==================================================================
; R   ($F35F)
; ------------------------------------------------------------------
; 
;  RENUMBER
; <run, resume $F362>
; ==================================================================
; S   ($F988)
; ------------------------------------------------------------------
; 
;  SEARCH & LIST  START ADDRESS: <input num><-P_START><print dec>  FINISH ADDRESS: <input num><-P_FINISH><-P_DEST><print dec> <check 24><check 23> STRING: <input str0><echo str0>
; <EXECUTE? y/n>
; ==================================================================
; T   ($FDFA)
; ------------------------------------------------------------------
; 
;  TRACE ON  SPEED: <input num><-P_INCR><print dec><check 22>
; <EXECUTE? y/n>
; ==================================================================
; U   ($F6B3)
; ------------------------------------------------------------------
; 
;  UDGs TO DATA  NUMBER OF UDGs: <input num><-P_WORK2><-P_INCR><print dec><err if 0>  1st LINE NUMBER: <input num><-P_FINISH><-P_DEST><print dec><check 23><check 22>
; <run, resume $F6CB>
; ==================================================================
; V   ($F8E1)
; ------------------------------------------------------------------
;  LIST VARIABLES 
; <run, resume $F8E6>
; ==================================================================
; shared ASK_BLOCK   ($F33C)
; ------------------------------------------------------------------
;  BLOCK OF PROGRAM  START ADDRESS: <input num><-P_START><print dec>  1st UNAFFECTED ADDRESS: <input num><-P_FINISH><print dec>  DESTINATION: <input num><-P_DEST><print dec> <check 24><check 23> INCREMENT: <input num><-P_INCR><print dec><err if 0><check 22>
; <EXECUTE? y/n>
; ==================================================================
; B/U second page   ($F723)
; ------------------------------------------------------------------
;   DEC OR HEX: <input str0><echo str0>
; <EXECUTE? y/n>
; ==================================================================
; K/L second page   ($FD11)
; ------------------------------------------------------------------
;  CASE  START ADDRESS: <input num><-P_START><print dec>  FINISH ADDRESS: <input num><-P_FINISH><-P_DEST><print dec><check 24><check 23>  IN QUOTES? (Y/N): <input str0><echo str0>
; <EXECUTE? y/n>
; ==================================================================
; MENU  ($EA6F)
; ------------------------------------------------------------------
; 
;         TS 2068  TOOLKIT
; 
; A Alter Program N Autoline On   B Bytes to DATA O Locate Token  C Copy Lines    P Compactor     D Delete lines  Q Display MemoryE REM Create    R Renumber      F REM Delete    S Search & List G UDG Designer  T Trace on      H Hex & Dec     U UDGs to DATA  I Information   V List VariablesJ Merge Lines   W Disable NEW   K Upper Case    X N/Q/T/W off   L Lower Case    Y Uncorrupt     M Move Lines    Z Line Sort     
; 
;  PRESS A KEY FOLLOWED BY ENTER,
;  or just ENTER anytime for menu  (c) BOB MITCHELL 1985
; 
; <run, resume $EC70>
