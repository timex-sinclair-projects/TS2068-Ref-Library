;clock frequency
;14.114MHz/4 = 3.258MHz
;283.446712nS

;some useful addresses
DEFC DF1 = $4000
DEFC DF2 = $6000 ;if present
DEFC PRBUF = $5B00
DEFC FDISPZ = $6200
DEFC FDISPNZ = $F9C0

DEFC REG_F = PRBUF
DEFC REG_A = REG_F+1
DEFC REG_C = REG_A+1
DEFC REG_B = REG_C+1
DEFC REG_E = REG_B+1
DEFC REG_D = REG_E+1
DEFC REG_L = REG_D+1
DEFC REG_H = REG_L+1
DEFC REG_IXL = REG_H+1
DEFC REG_IXH = REG_IXL+1
DEFC REG_IYL = REG_IXH+1
DEFC REG_IYH = REG_IYL+1
DEFC USR_DAT = REG_IYH+1

IF NOT_HOMEROM
;HOME ROM addresses
DEFC WRCH = $0010
DEFC GETCURCH = $0018
DEFC M0020 = $0020
DEFC ALLOCBC = $0030
DEFC PUTMES = $073F
DEFC CLLHS = $08A9 ;clear the lower half screen
;
DEFC SELECT = $1230
DEFC INSERT = $12BB
DEFC REMGSZ = $12CA
;
DEFC RESET = $1354 ;reset
DEFC RECLEN = $1720
DEFC DEL_DE = $174D
DEFC DELREC = $1750
DEFC AROS = $18C6
DEFC PASAVE = $19E0
DEFC TEM6 = $1BE5
DEFC TEM10 = $1BEF
DEFC STKFP0 = $1C51
DEFC FIX_U = $1F23
DEFC CHK_SZ = $1FBB
;
DEFC TERM = $21E7
DEFC FIND_N = $2C70
DEFC PGPSTR = $2FAF
;
DEFC SEPRMT = $3C89 ;tape message table
ENDIF

;function dispatcher addresses
;DEFC DISPATCH = $6200
;DEFC INT = $62AE
;DEFC GET_WORD = $6316
;DEFC PUT_WORD = $633B
;DEFC GET_STATUS = $6405
;DEFC GET_NUMBER = $645E
DEFC BANK_ENABLE = $6499
;DEFC SAVE_STATUS = $651E
;DEFC RESTORE_STATUS = $654A
;DEFC BS_STACK = $658E
;DEFC BS_SP = $65CE
;DEFC GOTO_BANK = $6572
;DEFC CALL_BANK = $65D0
;DEFC MOVE_BYTES = $668C
;DEFC CREATE_BITMAP = $66E8
;DEFC XFER_BYTES = $6722

IF NOT_XROM
;DEFC EXROM addresses
DEFC SLVM = $01AB
ENDIF

;useful equates
DEFC HOMEROM = $FF
DEFC DOCKBANK = $00
DEFC EXROM = $FE
DEFC EDITKEY = 7

;SYSTEM VARIABLES
DEFC KSTATE = $5C00 ;
DEFC KS_A1 = $5C00 ;bit 7=1 means no key stored
DEFC KS_C1 = $5C01 ;debounce count 0
DEFC KS_D1 = $5C02 ;repeat count 0
DEFC KS_B1 = $5C03 ;char 0
DEFC KS_A2 = $5C04 ;bit 7=1 means no key stored
DEFC KS_C2 = $5C05 ;debounce count 1
DEFC KS_D2 = $5C06 ;repeat count 1
DEFC KS_B2 = $5C07 ;character 1

DEFC LASTK = $5C08 ;stores newly pressed key
DEFC REPDEL = $5C09 ;repeat delay
DEFC REPPER = $5C0A ;key repeat delay
DEFC DEFADD = $5C0B ;address of user defined function argument
DEFC KDATA = $5C0D ;stores second byte of color controls
; entered from keyboard
DEFC TVDATA = $5C0E ;
DEFC STRMS = $5C10 ;addresses of channels attached to streams
DEFC CH_M3 = STRMS ; Chan -3 = channel for keyboard and lower screen
DEFC CH_M2 = CH_M3+2 ; Chan -2 = main screen
DEFC CH_M1 = CH_M2+2 ; Chan -1: RAM write
DEFC CH_0 = CH_M1+2 ; Chan 0: output to lower screen
DEFC CH_1 = CH_0+2 ; Chan 1: INPUT command
DEFC CH_2 = CH_1+2 ; Chan 2: PRINT/LIST
DEFC CH_3 = CH_2+2 ; Chan 3: LPRINT/LLIST
DEFC CH_4 = CH_3+2 ; user chan 1 (4)
DEFC CH_5 = CH_4+2 ; user chan 2 (5)
DEFC CH_6 = CH_5+2 ; user chan 3 (6)
DEFC CH_7 = CH_6+2 ; user chan 4 (7)
DEFC CH_8 = CH_7+2 ; user chan 5 (8)
DEFC CH_9 = CH_8+2 ; user chan 6 (9)
DEFC CH_10 = CH_9+2 ; user chan 7 (10)
DEFC CH_11 = CH_10+2 ; user chan 8 (11)
DEFC CH_12 = CH_11+2 ; user chan 9 (12)
DEFC CH_13 = CH_12+2 ; user chan 10 (13)
DEFC CH_14 = CH_13+2 ; user chan 11 (14)
DEFC CH_15 = CH_14+2 ; user chan 12 (15)

DEFC CHARS = $5C36 ;address of character table - 256
DEFC RASP = $5C38 ;length of warning buzz
DEFC PIP = $5C39 ;length of keyboard click
DEFC ERRNR = $5C3A ;error number (IY points here)
DEFC Y = ERRNR ;
DEFC FLAGS = $5C3B ;various flags
DEFC SPC = 0 ; suppress space before tokens
DEFC PR = 1 ; print to printer, not TV
DEFC LMODE1 = 2 ; L mode, not K at current character
DEFC LMODE2 = 3 ; L mode, not K at cursor
DEFC UNKFLAG = 4 ; UNKNOWN FLAG: used all over the place
DEFC KEYHIT = 5 ; keyhit found
DEFC NUM = 6 ; expression is numerical, not string
DEFC INTPT = 7 ; interpret rather than check syntax

DEFC TVFLAG = $5C3C ;flags associated with the TV
DEFC LHS = 0 ; printing to lower half of screen
DEFC EDIT = 1 ; outputting line for edit or number for string

DEFC ECHREQ = 3 ; echo requested if inputting from keyboard
DEFC TVLIST = 4 ; outputting and automatic listing
DEFC CLHS = 5 ; clear lower half screen when key pressed

DEFC ERRSP = $5C3D ;bottom item on machine stack
DEFC LISTSP = $5C3F ;return address from automatic listing
DEFC MODE = $5C41 ;0 = K or L, 1 = F, 2 = G
DEFC NEWPPC = $5C42 ;line to be jumped to
DEFC NSPPC = $5C44 ;subline to be jumped to (bit 7 off forces jump)
DEFC PPC = $5C45 ;line # of instruction being interpreted
DEFC SUBPPC = $5C47 ;number within line of instruction being interpreted
DEFC BORDCR = $5C48 ;border color
DEFC EPPC = $5C49 ;line # of "current" line in listing
DEFC VARS = $5C4B ;first record for a variable (last is 1 byte of $80)
DEFC DEST = $5C4D ;var matched by template code 1 or 4 (text or record)
DEFC CHANS = $5C4F ;channel data (including floppy buffers)
; each item comprises
; the address of an output routine for WRCH
; the address of an input routine for RDCH
; a 1 byte code for the device type and where
; appropriate, a file name, additional data and
; a buffer

DEFC CURCHL = $5C51 ;pointer to data for current channel
DEFC PROG = $5C53 ;address of BASIC program start
DEFC NXTLIN = $5C55 ;next line of source code
DEFC DATADD = $5C57 ;terminator of last data item
DEFC ELINE = $5C59 ;line being edited
DEFC KCUR = $5C5B ;current char in input buffer
DEFC CHADD = $5C5D ;current char when syntax checking etc.
DEFC XPTR = $5C5F ;1st char not syntactically OK (0 of all OK)
; also stores (CHADD) during read and input
DEFC WORKSP = $5C61 ;temporary workspace
DEFC STKBOT = $5C63 ;bottom of calculator stack
DEFC STKEND = $5C65 ;next free place on calculator stack
DEFC STKNXT = STKEND ;alias for STKEND
DEFC BREG = $5C67 ;calculator's BREG
DEFC MEM = $5C68 ;pointer to calculator memory area
DEFC FLAGS2 = $5C6A ;more flags
DEFC ALOS = 0 ; automatic listing on screen
DEFC PRLEFT = 1 ; printer buffer not empty
DEFC L_STR = 2 ; inside string when doing KB mode in LISTCH
DEFC CAPS_L = 3 ; capitals shift lock on
DEFC RETPOS = 4 ; retype possible after syntax error
DEFC DELREP = 5 ; delete key repeat (key held down)

DEFC DFSZ = $5C6B ;# lines in 2nd half of screen including
; separating blank line
DEFC STOP = $5C6C ;line # (in program) of top line on screen
DEFC OLDPPC = $5C6E ;line # of E.G. interruted statement
DEFC OSPCC = $5C70 ;(old sub PPC) statement number within line for OLDPPC
DEFC FLAGX = $5C71 ;flags associated with assignment
DEFC FLEX = 0 ; flexible length assignment required
DEFC UNFND = 1 ; destination of assignment not found
DEFC INPLN = 5 ; req input value rather than line of program
DEFC NO = 6 ; reqd type is numeric
DEFC LINPLN = 7 ; linput (input line) rather than straight input

DEFC STRLEN = $5C72 ;length of destination when string type
DEFC TADDR = $5C74 ;next byte in template
DEFC SEED = $5C76 ;last random # before scaling
DEFC FRAMES = $5C78 ;ls 2 byte of 3 byte frame counter
DEFC FRAMES2 = $5C7A ;ms byte of 3 byte frame counter
DEFC UDG = $5C7B ;1st byte of UDG
DEFC XCOORD = $5C7D ;x coord of last plot, etc.
DEFC YCOORD = $5C7E ;y coord of last plot, etc.
DEFC PPOSN = $5C7F ;column no. of printer pos.
DEFC PRCC = $5C80 ;ls byte of address of next char for printer
DEFC NOT_USED = $5C81 ;
DEFC ECHOE = $5C82 ;coords in lower half of end of keyboard input buffer
DEFC DFCC = $5C84 ;screen char under print cursor
DEFC DFCCL = $5C86 ;like DFCC for lower half screen
DEFC SPOSNCOL = $5C88 ;column for next screen output
DEFC SPOSNLIN = $5C89 ;line for next screen output
DEFC SPOSNLCOL = $5C8A ;column for next screen output on lower half screen
DEFC SPOSNLLIN = $5C8B ;line for next screen output on lower half screen
DEFC SCRCT = $5C8C ;scroll count - decremented for each scroll
DEFC ATTRP = $5C8D ;current printing attributes
DEFC FOREG = 0 ;ls bit of foreground color (ink)
DEFC BLUEFG = 0 ;
DEFC REDFG = 1 ;
DEFC GRNFG = 2 ;
DEFC BACKG = 3 ;
DEFC BLUEBG = 3 ;
DEFC REDBG = 4 ;
DEFC GRNBG = 5 ;
DEFC HILITE = 6 ;
DEFC FLASH = 7 ;

DEFC MASKP = $5C8E ;current permanent printing atributes mask;
; 0 = take attrib from ATTRP, 1: take attrib from screen

DEFC ATTRT = $5C8F ;current temp. printing attributes (see ATTRP for bit definitions)
DEFC MASKT = $5C90 ;current temporary printing attributes mask
DEFC PFLAG = $5C91 ;additional flags for printing: temporary flags in even bits,
; premanent flags in odd bits
DEFC XOR_CH = 0 ; new characters XORed into old
DEFC INV_CH = 2 ; new characters inverted
DEFC F_CB = 4 ; foreground := complement of background
DEFC B_CF = 6 ; background := complement of foreground

DEFC MEMBOT = $5C92 ;bottom of calculator memory (6 numbers)
DEFC MEM0 = $5C92
DEFC MEM1 = $5C97
DEFC MEM2 = $5C9C
DEFC MEM3 = $5CA1
DEFC MEM4 = $5CA6
DEFC MEM5 = $5CAB

DEFC USRNMI = $5CB0 ;address of NMI service routine
DEFC RAMTOP = $5CB2 ;last address of BASIC system area
DEFC PRAMT = $5CB4 ;last byte of physical RAM
DEFC ERRLN = $5CB6 ;pointer to ONERROR line number for at GOTO
DEFC ERRC = $5CB8 ;store line number in which error occurred
DEFC ERRS = $5CBA ;stores statement number in which error occurred
DEFC ERRT = $5CBB ;store for "error type" after and ONERROR
DEFC SYSCON = $5CBC ;system configuration table
DEFC MAXBNK = $5CBE ;largest bank number assigned
DEFC CRCBN = $5CBF ;bank number of current channel
DEFC MSTBOT = $5CC0 ;address of location above machine stack
DEFC VIDMOD = $5CC2 ;video mode
DEFC ARSBUF = $5CC4 ;pointer to AROS buffer
DEFC ARSFLG = $5CC6 ;AROS flag
; bit 7 set indicates AROS present
; bit 4 set indicates NXTLIN pointing to AROS
; bit 3 set indicates DATADD pointing to AROS
DEFC ADATLN = $5CC7 ;pointer to the start of the current data line (AROS only)
DEFC DTLNLN = $5CC8 ;length of the current data line (AROS only)
DEFC STRMN = $5CCB ;current stream number used for bus expansion unit devices

;IY offsets
;DEFC OERRNR = $00 ;ERRNR
;DEFC OFLAGS = $01 ;FLAGS
;DEFC OTVFLAG = $02 ;TVFLAG
;DEFC OMODE = $07 ;MODE
;DEFC ONSPPC = $0A
;DEFC OSUBPPC = $0D
;DEFC OBORDCR = $0E
;DEFC OEPPC = $0F
;DEFC OKCUR = $21
;DEFC OXPTR = $25
;DEFC OBREG = $2D ;BREG
;DEFC OFLAGS2 = $30 ;FLAGS2
;DEFC ODFSZ = $31 ;DFSZ
;DEFC OOSPCC = $36
;DEFC OFLAGX = $37
;DEFC OSTRLEN = $38
;DEFC OFRAMES = $40 ;FRAMES
;DEFC OPPOSN = $45
;DEFC OPRCC = $46
;DEFC OSPOSNLIN = $4F
;DEFC OSPOSNLCOL = $50
;DEFC OSCRCT = $52
;DEFC OPFLAG = $57 ;PFLAG
;DEFC OERRLN = $7C

DEFC OERRNR = ERRNR-Y
DEFC OFLAGS = FLAGS-Y
DEFC OTVFLAG = TVFLAG-Y
DEFC OMODE = MODE-Y
DEFC ONSPPC = NSPPC-Y
DEFC OSUBPPC = SUBPPC-Y
DEFC OBORDCR = BORDCR-Y
DEFC OEPPC = EPPC-Y
DEFC OKCUR = KCUR-Y
DEFC OXPTR = XPTR-Y
DEFC OBREG = BREG-Y
DEFC OFLAGS2 = FLAGS2-Y
DEFC ODFSZ = DFSZ-Y
DEFC OOSPCC = OSPCC-Y
DEFC OFLAGX = FLAGX-Y
DEFC OSTRLEN = STRLEN-Y
DEFC OFRAMES2 = FRAMES-Y+2
DEFC OPPOSN = PPOSN-Y
DEFC OPRCC = PRCC-Y
DEFC OSPOSNLIN = SPOSNLIN-Y
DEFC OSPOSNLCOL = SPOSNLCOL-Y
DEFC OSCRCT = SCRCT-Y
DEFC OPFLAG = PFLAG-Y
DEFC OERRLN = ERRLN-Y

DEFC FD_RESERVED1 = 1 ;
DEFC FD_RESERVED2 = 2 ;
DEFC FD_RESERVED3 = 3 ;
DEFC FD_RESERVED4 = 4 ;
DEFC FD_RESERVED5 = 5 ;
DEFC FD_RESERVED6 = 6 ;
DEFC FD_RESERVED7 = 7 ;
DEFC FD_RESERVED8 = 8 ;
DEFC FD_RESERVED9 = 9
DEFC FD_RESERVED10 = 10 ;
DEFC FD_RESERVED11 = 11 ;
DEFC FD_RESERVED12 = 12 ;
DEFC FD_RESERVED13 = 13 ;
DEFC FD_GET_STATUS = 14 ;(0EH)
DEFC FD_GET_NUMBER = 15 ;(0FH)
DEFC FD_RESERVED16 = 16 ;
DEFC FD_RESERVED17 = 17 ;
DEFC FD_RESERVED18 = 18 ;
DEFC FD_RESERVED19 = 19 ;
DEFC FD_RESERVED20 = 20 ;
DEFC FD_RESERVED21 = 21 ;
DEFC FD_RESERVED22 = 22 ;
DEFC FD_RESERVED23 = 23 ;
DEFC FD_RESERVED24 = 24 ;
DEFC FD_UPD_K = 25 ;(19H)
DEFC FD_PARP = 26 ;(1AH)
DEFC FD_BEEP = 27 ;(1BH)
DEFC FD_K_DUMP = 28 ;(1CH)
DEFC FD_SENDTV = 29 ;(1DH)
DEFC FD_SETAT = 30 ;(1EH)
DEFC FD_ATTBYT = 31 ;(1FH)
DEFC FD_R_ATTS = 32 ;(20H)
DEFC FD_CLLHS = 33 ;(21H)
DEFC FD_CLS = 34 ;(22H)
DEFC FD_DUMPPR = 35 ;(23H)
DEFC FD_PRSCAN = 36 ;(24H)
DEFC FD_DESLUG = 37 ;(25H)
DEFC FD_K_NEW = 38 ;(26H)
DEFC FD_INIT = 39 ;(27H)
DEFC FD_INCH = 40 ;(28H)
DEFC FD_SELECT = 41 ;(29H)
DEFC FD_INSERT = 42 ;(2AH)
DEFC FD_RESET = 43 ;(2BH)
DEFC FD_CLOSE = 44 ;(2CH)
DEFC FD_CLCHAN = 45 ;(2DH)
DEFC FD_OPEN = 46 ;(2EH)
DEFC FD_OPCHAN = 47 ;(2FH)
DEFC FD_CAT = 48 ;(30H)
DEFC FD_ERASE = 49 ;(31H)
DEFC FD_FORMAT = 50 ;(32H)
DEFC FD_MOVE = 51 ;(33H)
DEFC FD_FLASHA = 52 ;(34H)
DEFC FD_FIND_L = 53 ;(35H)
DEFC FD_SUBLIN = 54 ;(36H)
DEFC FD_RECLEN = 55 ;(37H)
DEFC FD_DELREC = 56 ;(38H)
DEFC FD_PUT_BC = 57 ;(39H)
DEFC FD_SYNTAX = 58 ;(3AH)
DEFC FD_EXCUTE = 59 ;(3BH)
DEFC FD_FOR = 60 ;(3CH)
DEFC FD_STOP = 61 ;(3DH)
DEFC FD_NEXT = 62 ;(3EH)
DEFC FD_READ = 63 ;(3FH)
DEFC FD_DATA = 64 ;(40H)
DEFC FD_RESTBC = 65 ;(41H)
DEFC FD_RAND = 66 ;(42H)
DEFC FD_CONT = 67 ;(43H)
DEFC FD_JUMP = 68 ;(44H)
DEFC FD_FIX_Ul = 69 ;(45H)
DEFC FD_FIX_U = 70 ;(46H)
DEFC FD_CLEAR = 71 ;(47H)
DEFC FD_CLR_BC = 72 ;(48H)
DEFC FD_GO_SUB = 73 ;(49H)
DEFC FD_CHK_SZ = 74 ;(4AH)
DEFC FD_RETURN = 75 ;(4BH)
DEFC FD_PAUSE = 76 ;(4CH)
DEFC FD_BREAKQ = 77 ;(4DH)
DEFC FD_DEF = 78 ;(4EH)
DEFC FD_K_LPR = 79 ;(4FH)
DEFC FD_K_PRIN = 80 ;(50H)
DEFC FD_P_SEQ = 81 ;(51H)
DEFC FD_INPUT = 82 ;(52H)
DEFC FD_ISEQ = 83 ;(53H)
DEFC FD_NOTKBQ = 84 ;(54H)
DEFC FD_COLOR = 85 ;(55H)
DEFC FD_HIFLSH = 86 ;(56H)
DEFC FD_SCRMBL = 87 ;(57H)
DEFC FD_PLOT = 88 ;(58H)
DEFC FD_PLOTBC = 89 ;(59H)
DEFC FD_GET_XY = 90 ;(5AH)
DEFC FD_CIRCLE = 91 ;(5BH)
DEFC FD_DRAW = 92 ;(5CH)
DEFC FD_DRAW_L = 93 ;(5DH)
DEFC FD_EXPRN = 94 ;(5EH)
DEFC FD_F_SCRN = 95 ;(5FH)
DEFC FD_F_ATTR = 96 ;(60H)
DEFC FD_RND = 97 ;(61H)
DEFC FD_F_PI = 98 ;(62H)
DEFC FD_F_INKY = 99 ;(63H)
DEFC FD_FIND_N = 100 ;(64H)
DEFC FD_PSHSTR = 101 ;(65H)
DEFC FD_PAEDCB = 102 ;(66H)
DEFC FD_LET = 103 ;(67H)
DEFC FD_POPSTR = 104 ;(68H)
DEFC FD_DIM = 105 ;(69H)
DEFC FD_STKUSN = 106 ;(6AH)
DEFC FD_STK_A = 107 ;(6BH)
DEFC FD_ININT = 109 ;(6DH)
DEFC FD_FP2BC = 110 ;(6EH)
DEFC FD_FP2A = 111 ;(6FH)
DEFC FD_OUTPUT = 112 ;(70H)
DEFC FD_TSSUB = 113 ;(71H)
DEFC FD_ADD = 114 ;(72H)
DEFC FD_MULT = 115 ;(73H)
DEFC FD_TIMES = 116 ;(74H)
DEFC FD_DIVIDE = 117 ;(75H)
DEFC FD_TRUNC = 118 ;(76H)
DEFC FD_INTDIV = 120 ;(78H)
DEFC FD_INT = 121 ;(79H)
DEFC FD_EXP = 122 ;(7AH)
DEFC FD_LN = 123 ;(7BH)
DEFC FD_ANGLE = 124 ;(7CH)
DEFC FD_COS = 125 ;(7DH)
DEFC FD_SIN = 126 ;(7EH)
DEFC FD_TAN = 127 ;(7FH)
DEFC FD_ATN = 128 ;(80H)
DEFC FD_ASN = 129 ;(81H)
DEFC FD_ACS = 130 ;(82H)
DEFC FD_ROOT = 131 ;(83H)
DEFC FD_TO_THE = 132 ;(84H)
DEFC FD_RDCH = 133 ;(85H)
DEFC FD_SENDCH = 134 ;(86H)
DEFC FD_WRCH = 135 ;(87H)
DEFC FD_K_SCAN = 136 ;(88H)
DEFC FD_P_LFT = 137 ;(89H)
DEFC FD_P_RT = 138 ;(8AH)
DEFC FD_P_NL = 139 ;(8BH)
DEFC FD_PUTMES = 140 ;(8CH)
DEFC FD_K_CLS = 141 ;(8DH)
DEFC FD_SCRL = 142 ;(8EH)
DEFC FD_F_PNT = 143 ;(8FH)
DEFC FD_DRAWLN = 144 ;(90H)
DEFC FD_PUT_LN = 145 ;(91H)

DEFC SCRNCHAN = 2 ;main screen channel number

DEFC F_PUT_LN = $1795
DEFC F_DRAWLN = $2813
DEFC F_F_PNT = $2624
DEFC F_SCRL = $0939
DEFC F_K_CLS = $08A6
DEFC F_PUTMES = $073F
DEFC F_P_NL = $0566
DEFC F_P_RT = $0554
DEFC F_P_LFT = $053A
DEFC F_K_SCAN = $02B0
DEFC F_WRCH = $0010
DEFC F_SENDCH = $11ED
DEFC F_RDCH = $11CF
DEFC F_TO_THE = $3C6C
DEFC F_ROOT = $3C65
DEFC F_ACS = $3C5E
DEFC F_ASN = $3C4E
DEFC F_ATN = $3BFD
DEFC F_TAN = $3BF5
DEFC F_SIN = $3BD0
DEFC F_COS = $3BC5
DEFC F_ANGLE = $3B9E
DEFC F_LN = $3B2E
DEFC F_EXP = $3ADF
DEFC F_INT = $3ACA
DEFC F_INTDIV = $3ABB
DEFC F_FLOAT = $3656
DEFC F_TRUNC = $35D3
DEFC F_DIVIDE = $356E
DEFC F_TIMES = $3489
DEFC F_MULT = $3468
DEFC F_ADD = $33D3
DEFC F_TSSUB = $33CE
DEFC F_OUTPUT = $31A1
DEFC F_FP2A = $3193
DEFC F_FP2BC = $3160
DEFC F_ININT = $30F9
DEFC F_STK_BC = $30E9
DEFC F_STK_A = $30E6
DEFC F_STKUSN = $3059
DEFC F_DIM = $2FC0
DEFC F_POPSTR = $2FAF
DEFC F_LET = $2EBD
DEFC F_PAEDCB = $2E74
DEFC F_PSHSTR = $2E70
DEFC F_FIND_N = $2C70
DEFC F_F_INKY = $29F2
DEFC F_F_PI = $29E5
DEFC F_RND = $29B6
DEFC F_F_ATTR = $28D7
DEFC F_F_SCRN = $288E
DEFC F_EXPRN = $2854
DEFC F_DRAW_L = $2810
DEFC F_DRAW = $26DB
DEFC F_CIRCLE = $2679
DEFC F_GET_XY = $2660
DEFC F_PLOTBC = $263E
DEFC F_PLOT = $2635
DEFC F_SCRMBL = $2603
DEFC F_HIFLSH = $241D
DEFC F_COLOR = $23DE
DEFC F_NOTKBQ = $2380
DEFC F_ISEQ = $226B
DEFC F_INPUT = $222B
DEFC F_P_SEQ = $217E
DEFC F_K_PRIN = $2159
DEFC F_K_LPR = $2155
DEFC F_DEF = $201D
DEFC F_BREAKQ = $2009
DEFC F_PAUSE = $1FEB
DEFC F_RETURN = $1FD4
DEFC F_CHK_SZ = $1FBB
DEFC F_GO_SUB = $1F99
DEFC F_CLR_BC = $1F39
DEFC F_CLEAR = $1F36
DEFC F_FIX_U = $1F23
DEFC F_FIX_Ul = $1F1E
DEFC F_JUMP = $1EF1
DEFC F_CONT = $1EE4
DEFC F_RAND = $1ED4
DEFC F_RESTBC = $1ECA
DEFC F_DATA = $1E82
DEFC F_READ = $1D97
DEFC F_NEXT = $1D55
DEFC F_STOP = $1C59
DEFC F_FOR = $1C78
DEFC F_EXCUTE = $1AD8
DEFC F_SYNTAX = $1A27
DEFC F_PUT_BC = $1788
DEFC F_DELREC = $1750
DEFC F_RECLEN = $1720
DEFC F_SUBLIN = $16F0
DEFC F_FIND_L = $16D6
DEFC F_FLASHA = $160D
DEFC F_MOVE = $25D0
DEFC F_FORMAT = $25CC
DEFC F_ERASE = $25D4
DEFC F_CAT = $25C8
DEFC F_OPCHAN = $1465
DEFC F_OPEN = $142A
DEFC F_CLCHAN = $13BE
DEFC F_CLOSE = $139F
DEFC F_RESET = $1354
DEFC F_INSERT = $12BB
DEFC F_SELECT = $1230
DEFC F_INCH = $11E1
DEFC F_INIT = $0D31
DEFC F_K_NEW = $0D1D
DEFC F_DESLUG = $0D0D
DEFC F_PRSCAN = $0A4A
DEFC F_DUMPPR = $0A23
DEFC F_CLS = $08EA
DEFC F_CLLHS = $08A9
DEFC F_R_ATTS = $0888
DEFC F_ATTBYT = $0710
DEFC F_SET_AT = $05B2
DEFC F_SEND_TV = $0500
DEFC F_K_DUMP = $0A02
DEFC F_BEEP = $0436
DEFC F_PARP = $03F3
DEFC F_UD_K = $02E1

;RAM SERVICES
;DEFC F_XFER_BYTES? $6721
;DEFC F_CALL_BANK? $65CF
;DEFC F_GOTO_BANK? $6571
;DEFC F_BANK_ENABLE $6499
;DEFC F_GET_NUMBER $645E
;DEFC F_GET_STATUS $6405

;EXROM SERVICES
;DEFC F_W_BORD = $00E5
;DEFC F_RESERVED8 = $0EA3
;DEFC F_SAVE = $0851
;DEFC F_RESERVED6 = $06E5
;DEFC F_LOAD = $05CC
;DEFC F_SLVM = $01AB
;DEFC F_R_EDGE = $018D
;DEFC F_RD_BIT = $0189
;DEFC F_RD_TAPE = $00FC

;REPORT CODES

DEFC RPT_OK = 0
DEFC RPT_NEXTWOFOR = 1
DEFC RPT_VARNOTFOUND = 2
DEFC RPT_BADSUBSCR = 3
DEFC RPT_OUTOFMEM = 4
DEFC RPT_OUTOFSCRN = 5
DEFC RPT_NUMTOOBIG = 6
DEFC RPT_RTNWOGOSUB = 7
DEFC RPT_ENDOFFILE = 8
DEFC RPT_STOP = 9
DEFC RPT_INVLDARG = 10
DEFC RPT_INTTOOBIG = 11
DEFC RPT_BADBASIC = 12
DEFC RPT_BREAK = 13
DEFC RPT_OUTOFDATA = 14
DEFC RPT_BADSAVENAME = 15
DEFC RPT_NOROOM4LINE = 16
DEFC RPT_STOPININPUT = 17
DEFC RPT_FORWONEXT = 18
DEFC RPT_INVLDIODEV = 19
DEFC RPT_INVLDCOLOR = 20
DEFC RPT_BREAK1 = 21
DEFC RPT_RAMTOPBAD = 22
DEFC RPT_STMTLOST = 23
DEFC RPT_STMTNOGOOD = 24
DEFC RPT_INLDSTRM = 25
DEFC RPT_FNWODEFFN = 26
DEFC RPT_TAPELOADERR = 27

; 2068 KEYBOARD CODES
;LSN ->0 1 2 3 4 5 6 7 8 9 A B C D E F
;0 UNUSED UNUSED UNUSED UNUSED UNUSED UNUSED PRINT_COMMA EDIT CSR_LT CSR_RT CSR_DN CSR_UP DELETE CR SLUG UNUSED
;1 INK PAPER FLASH BRIGHT INVERT OVER AT TAB UNUSED UNUSED UNUSED UNUSED UNUSED UNUSED UNUSED UNUSED
;2 SPACE ! " # $ % & ' ( ) * + , - . /
;3 0 1 2 3 4 5 6 7 8 9 : ; < = > ?
;4 @ A B C D E F G H I J K L M N O
;5 P Q R S T U V W X Y Z [ \ ] ^ _
;6 POUND a b c d e f g h i j k l m n o
;7 p q r s t u v w x y z { STICK } FREE COPYRIGHT
; ONERR SOUND RESET
;8 BLKGR0 BLKGR1 BLKGR2 BLKGR3 BLKGR4 BLKGR5 BLKGR6 BLKGR7 BLKGR8 BLKGR9 BLKGR10 BLKGR11 BLKGR12 BLKGR13 BLKGR14 BLKGR15
;9 UDG0 UDG1 UDG2 UDG3 UDG4 UDG5 UDG6 UDG7 UDG8 UDG9 UDG10 UDG11 UDG12 UDG13 UDG14 UDG15
;A UDG16 UDG17 UDG18 UDG19 UDG20 RND INKEY$ PI FN POINT SCREEN$ ATTRIB AT TAB VAL$ CODE
;B VAL LEN SIN COS TAN ASN ACS ATN LN EXP INT SQR SGN ABS PEEK IN
;C USR STR$ CHR$ NOT BIN OR AND <= => <> LINE THEN TO STEP DEF CAT
;D FORMAT MOVE DELETE OPEN CLOSE MERGE VERIFY BEEP ARC FOREGND BKGND FLASH BRIGHT INVERT OVER OUT
;E LPRINT LLIST STOP READ DATA RESTORE NEW BORDER CONT DIM REM FOR GOTO GOSUB INPUT LOAD
;F LIST LET PAUSE NEXT POKE PRINT PLOT RUN SAVE RANDOM IF CLS DRAW CLEAR RETURN COPY