# ADL - ASC 002 80-Column Mode Support (Timex, 1983–84): assembler listing

Transcription of the CRZ80/11 assembler listing of `IO80.SRC` (with the included character set `CHST80.SRC`), Timex Application Development Library ASC No. 002, version 001, by C. Corcoran and D. Boyle, 12/16/83, assembled 3-Jan-84. PDF pages 18–64. Each listing line keeps its address (LOC, `'` = relocatable), object code, line number and source. **Read `README.md` first.** The module's printed documentation (PDF pages 1–17) is in `80-column-mode-support-docs.md`.

---

<!-- PDF page 18 — listing "Page 1" — DEFINITIONS — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                          1          NAME    ADL - ASC 002 80-COL.MODE SUPPORT
                          2  ;
                          3  ;
                          4  ;
                          5  ;
                          6  ;
                          7  ;
                          8  ;
                          9  ;               ***********************************
                         10  ;               *                                 *
                         11  ;               *             TIMEX               *
                         12  ;               * APPLICATION DEVELOPMENT LIBRARY *
                         13  ;               *                                 *
                         14  ;               * NAME: 80-COL.MODE SUPPORT       *
                         15  ;               *                                 *
                         16  ;               * ASC NO:  002                    *
                         17  ;               * VERSION: 001                    *
                         18  ;               * AUTHOR:  C. CORCORAN/D. BOYLE   *
                         19  ;               * DATE:    12/16/83               *
                         20  ;               ***********************************
```

> *Transcriber's note:* The title page of the listing, printed as lines 1–20 (a `NAME` directive and a comment-block banner); the header reads `ADL - ASC 002 80-COL.MODE SUPPORT   CRZ80/11 version 10.36.14   3-Jan-84 19:10:4   Page 1` with subtitle `DEFINITIONS   IO80.SRC`. The banner's internal spacing is normalised to match the sibling ASC 004 listing; the words are as printed. A speck before `12/16/83` on line 19 is not a character. The rest of the sheet is blank.

<!-- PDF page 19 — listing "Page 2" — DEFINITIONS — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                         22          SUBTTL  DEFINITIONS
                         23  ;
                         24  ;
                         25  ;                       ****DEFINITIONS****
                         26  ;
                         27          INTERN  WRCHAR, WRSTRG, SETCUR, SETATT, SETMSK, CLRSCN, SCROLL
                         28          INTERN  GTCHAR, GETATT, GETCUR
                         29  ;
                         30          INTERN  WRCHRB, WRSTRB, SETCUB, SETATB, SETMSB, CLRSCB, SCRLB
                         31          INTERN  GTCHRB, GETATB, GETCUB
                         32  ;
                         33          INTERN  SETMODE, SETMDB
                         34  ;
                         35  ;
=0018                    36  SCRSZ   EQU     24              ; 24 LINES
=1701                    37  SCINIT  EQU     1701H           ; SCROLL CONTROL INITIALIZATION
=1800                    38  CLINIT  EQU     1800H           ; CLEAR SCREEN CTL. INIT.
=047E'                   39  CHRSET  EQU     ((CHRST)-100H)  ;CHAR.TABLE-100H
=077E'                   40  GRPHST  EQU     ((GRPST)-100H)  ; GRAPHICS TABLE
                         41  ;
=0E8E                    42  CHNGVID EQU     0E8EH           ; ROUTINE IN ROM EXTENSION
=1720                    43  RECLEN  EQU     1720H           ; ROUTINE IN HOME ROM
                         44  ;
=00FF                    45  HREXPT  EQU     0FFH            ; HOME ROM EXT.SELECT PORT (BIT 7)
=00F4                    46  DKHSPT  EQU     0F4H            ; DOCK HORIZONTAL SELECT PORT
                         47  ;
=5C4B                    48  VARS    EQU     5C4BH           ; SYSTEM VARIABLES
=5C65                    49  STKEND  EQU     5C65H           ;
=5C7B                    50  UDG     EQU     5C7BH           ;
=5C7D                    51  COORDS  EQU     5C7DH           ;
=5CB2                    52  RAMTOP  EQU     5CB2H           ;
=5CB4                    53  PRAMT   EQU     5CB4H           ;
=5CC2                    54  VIDMOD  EQU     5CC2H           ;
=5CC3                    55  PARAM$  EQU     5CC3H           ; (Location 23747)
=6840                    56  DRIVES  EQU     6840H           ;
=12C0                    57  INSERTSZ EQU    7B00H-DRIVES
=0840                    58  MOVESZ  EQU     DRIVES-6000H
=F7C0                    59  DEST7   EQU     0FFFFH-MOVESZ+1
=97C0                    60  FIX     EQU     DEST7-6000H
                         61
=1D00                    62  FIXTBL  EQU     1D00H
                         63
```

> *Transcriber's note:* PDF page 19 is a listing page (listing "Page 2"), not a title page. On the printed page the EQU lines have the opcode at source column 16, the operand at column 24 and the comment at column 32. Here they are re-spaced to columns 8, 16 and 32. On line 22 `SUBTTL` is followed by a single space before `DEFINITIONS`. On lines 39 and 40 the comment follows the operand directly (printed at source columns 40 and 39); it is moved to column 32 here. Line 39 has no space after the `;`, and line 55 is printed in mixed case, `(Location 23747)`. The INTERN lists are printed with a space after each comma. Lines 61 and 63 are blank. Line 64 is not printed; it is probably a page-eject directive.

> *Transcriber's note:* The EQU values are consistent: 7B00H−6840H = 12C0, 6840H−6000H = 0840, 0FFFFH−0840H+1 = F7C0, F7C0H−6000H = 97C0, and 5CC3H = 23747. Lines 39–40 (`=047E'`, `=077E'`) carry the relocatable mark. Specks beside `WRSTRG` on line 27 and before `WRSTRB` on line 30 are not characters.

> *Transcriber's note:* Like the other scans in this batch, the bottom margin of this PDF page also shows the running header of the next listing page (here "Page 3"). It is not transcribed.

<!-- PDF page 20 — listing "Page 3" — INPUTS AND ENTRIES — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                         65          SUBTTL  INPUTS AND ENTRIES
                         66  ;
                         67  ;
                         68  ;
                         69  ;               **PARAMETER INPUTS AND ENTRY POINTS FROM BASIC**
                         70  ;
                         71  ;                                                            WITH
                         72  ;                                                         MODULE LOADED
                         73  ;                                                         AT 57344(E000H)
                         74  ;                                                         DECIMAL ADDRESS
                         75  ;                                                       ---------------
0000'  20                76  DATAB   DEFB    20H             ; CHAR.CODE FROM BASIC         57344
0001'  C3 003F'          77  WRCHRB: JP      WRCH0           ; ENTRY TO WRITE CHARACTER     57345
0004'  C3 0171'          78  WRSTRB: JP      WRSTR0          ; ENTRY TO WRITE STRING        57348
                         79  ;                               ; (see PARAM$ above)
0007'  0000              80  LINCOL  DEFW     0              ; SET CURSOR PARAMETERS
                         81                                  ;   LINCOL=COL. (0-79)         57351
                         82                                  ;   LINCOL+1=LINE (0-23)       57352
0009'  C3 01BA'          83  SETCUB: JP      SETCB0          ; ENTRY TO SET CURSOR POSN.    57353
000C'  1800              84  CLRCTL  DEFW    1800H           ; CLEAR SCREEN CONTROLS
                         85                                  ;   CLRCTL=STARTING LINE NO.   57356
                         86                                  ;   CLRCTL+1=LINE COUNT        57357
000E'  C3 0278'          87  CLRSCB: JP      CLRSB0          ; ENTRY TO CLEAR SCREEN        57358
0011'  38                88  ATTCTL  DEFB    38H             ; ATTRIBUTE CONTROL            57361
                         89                                  ;   BIT 7=FLASH (0 IN 80-COL.)
                         90                                  ;       6=BRIGHT(0 IN 80-COL.)
                         91                                  ;       5
                         92                                  ;       4=PAPER COLOR
                         93                                  ;       3
                         94                                  ;       2
                         95                                  ;       1= INK COLOR
                         96                                  ;       0
0012'  C3 02F3'          97  SETATB: JP      SETAB0          ; ENTRY TO SET ATTRIBUTES      57362
0015'  00                98  MSKCTL  DEFB    0               ; MASK CONTROL FROM BASIC:     57365
                         99                                  ;   BIT 2=INVERSE
                        100                                  ;       0=OVER
0016'  C3 031D'         101  SETMSB: JP       SETMB0         ; ENTRY TO SET MASK CONTROLS   57366
0019'  0000             102  GETCTL  DEFW     0              ; 'GET' CONTROL FROM BASIC     57369
                        103                                  ; FORMAT IS AS FOR LINCOL
001B'  C3 0326'         104  GTCHRB: JP       GTCHB0         ; ENTRY TO GET CHARACTER       57371
001E'  C3 03CD'         105  GETATB: JP       GETAB0         ; ENTRY TO GET ATTRIBUTE       57374
0021'  C3 03D4'         106  GETCUB: JP       GETCB0         ; ENTRY TO GET CURSOR POSN.    57377
0024'  00               107  VIMODE  DEFB     0              ; VIDEO MODE CONTROL           57380
                        108                                  ;       0=NORMAL
                        109                                  ;       8=80-COL.MODE
0025'  C3 03F1'         110  SETMDB: JP       STMDB0         ; ENTRY TO SET VIDEO MODE      57381
0028'  1701             111  SCRCTL  DEFW     1701H          ; SCROLL CONTROL
                        112                                  ;   SCRCTL=STARTING LINE NO.   57384
                        113                                  ;   SCRCTL+1=LINE COUNT        57385
002A'  C3 01CA'         114  SCRLB:  JP       SCRLB0         ; ENTRY TO SCROLL              57386
```

> *Transcriber's note:* On the printed page the opcodes sit at source column 16 and the operands at column 24. Here they are re-spaced to columns 8 and 16. The comments keep column 32, so the right-hand decimal addresses stay at source column 63 as printed. The heading block (lines 71–75) keeps its printed columns: `WITH` at column 61, the next three lines at column 58, and the 15-dash rule at column 56. Several operands are printed with a leading space, one column right of the others: ` 0` on lines 80, 102 and 107, ` 1701H` on line 111, and the jump targets on lines 101, 104, 105, 106, 110 and 114. That space is kept. `SUBTTL` on line 65 is followed by a single space. Line 79 is printed in lower case, `(see PARAM$ above)`, and the quotes around `GET` on line 102 are printed as acute accents. Specks before `38H` and before the `;` on line 88 are not characters. Line 115 is not printed; it is probably a page-eject directive.

> *Transcriber's note:* The decimal addresses all equal 57344 (E000H) + LOC: 0000→57344, 0001→57345, 0004→57348, 0007/0008→57351/57352, 0009→57353, 000C/000D→57356/57357, 000E→57358, 0011→57361, 0012→57362, 0015→57365, 0016→57366, 0019→57369, 001B→57371, 001E→57374, 0021→57377, 0024→57380, 0025→57381, 0028/0029→57384/57385, 002A→57386. The jump targets are consistent with the later pages: `C3 003F'` reaches `WRCH0:` (003F', PDF page 22) and `C3 0171'` reaches `WRSTR0` (0171', PDF page 26).

<!-- PDF page 21 — listing "Page 4" — OTHER VARIABLES — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        116          SUBTTL  OTHER VARIABLES
                        117  ;
002D'  17               118  BOTLN   DEFB     17H            ; BOTTOM LINE (LINE AFTER      57389
                        119                                  ; WHICH SCREEN IS CONSIDERED
                        120                                  ; FULL.  AUTOMATIC SCROLL
                        121                                  ; WILL BE DONE IF SCRLCT
                        122                                  ; DOES NOT DECREMENT TO 0.
002E'  01               123  SCRLCT  DEFB     1              ; SCROLL COUNT - 1 PLUS NO.    57390
                        124                                  ; OF TIMES AUTOMATIC SCROLL
                        125                                  ; WILL BE DONE.
002F'  047E'            126  CHTBL   DEFW    CHRSET          ; ADDRESS OF CHARACTER TABLE   57391
0031'  077E'            127  GRTBL   DEFW    GRPHST          ; ADDRESS OF STD.GRAPHICS TBL. 57393
0033'  50               128  LINLEN  DEFB     50H            ; LINE LENGTH(80 OR 85)        57395
0034'  1851             129  CURPOS  DEFW    1851H           ; CURRENT POSITION             57396
                        130  ;                               ; (INTERNAL FORMAT)
0036'  4000             131  DFADRS  DEFW    4000H           ; CURRENT DISPLAY FILE ADDRS.  57398
0038'  00               132  MASKB   DEFB    0               ; MASK TO BE APPLIED TO        57400
                        133  ;                               ; DISPLAY CHARACTERS
0039'  38               134  ATTBYT  DEFB    38H             ; CURRENT ATTRIBUTES           57401
                        135  ;                               ; (38=BLACK ON WHITE)
003A'  80               136  GTINDX  DEFB    80H             ; INDEX FOR ADJUSTING          57402
                        137  ;                               ; CH.CODE IN GTCHAR
003B'  0000             138  STRGCT  DEFW     0H             ; REMAINING COUNT FROM WRSTRG
                        139  ;                               ; WHEN 'SCREEN FULL'           57403
003D'  01               140  MARGIN  DEFB    1               ; MARGIN ADJUST (0-2)          57405
003E'  07               141  DFBIT   DEFB    7               ; BIT POSN.IN LINE(7,1,3,5)    57406
```

> *Transcriber's note:* The opcode, operand and comment columns are re-spaced as on listing page 3; the decimal addresses stay at source column 63. Operands printed one column right of the others keep a leading space: ` 17H` (line 118), ` 1` (line 123), ` 50H` (line 128) and ` 0H` (line 138). Line 120 has two spaces after `FULL.`. The decimal address for STRGCT (57403) is printed on line 139, not on line 138. The quotes around `SCREEN FULL` on line 139 are printed as acute accents. Line 142 is not printed; it is probably a page-eject directive.

> *Transcriber's note:* The decimal addresses all equal 57344 + LOC: 002D→57389, 002E→57390, 002F→57391, 0031→57393, 0033→57395, 0034→57396, 0036→57398, 0038→57400, 0039→57401, 003A→57402, 003B→57403, 003D→57405, 003E→57406. `CHTBL` and `GRTBL` assemble to `047E'` and `077E'`, the values of CHRSET and GRPHST on PDF page 19. The variables run to 003E', so `WRCH0` starts at 003F' on the next page.

<!-- PDF page 22 — listing "Page 5" — WRITE CHARACTER — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        143          SUBTTL  WRITE CHARACTER
                        144  ;
003F'                   145  WRCH0:                          ; HERE FROM BASIC ENTRY TO DISPLAY THE
                        146                                  ; CHARACTER WHOSE CODE IS IN 'DATAB'
003F'  3A 0000'         147          LD      A,(DATAB)
                        148  ;
0042'                   149  WRCHAR:                         ; ENTRY WITH CODE IN A
0042'  CD 0558'         150          CALL    LDPOSN          ; LOAD REGISTERS FOR CURRENT POSITION
                        151                                  ;   BC=CURSOR POSITION FROM 'CURPOS'
                        152                                  ;   HL=DISPLAY FILE ADDRESS FROM 'DFADRS
                        153                                  ;   A=CODE FOR CHAR. TO BE DISPLAYED
0045'  FE 20            154          CP      20H             ; TEST VALID RANGE
0047'  DA 0147'         155          JP      C,INVPAR        ; < 20H
004A'  FE A5            156          CP      0A5H            ;
004C'  D2 0147'         157          JP      NC,INVPAR       ; > A4H
004F'  C5               158          PUSH    BC              ; SAVE CURSOR POSITION
0050'  FE 80            159          CP      80H             ; TEST IF ASCII PRINTABLE (20H-7FH)
0052'  38 15            160          JR      C,WRCH12        ; YES
0054'  FE 90            161          CP      90H             ; TEST IF STD.GRAPHICS(80-8FH)
0056'  38 09            162          JR      C,WRCH11
0058'  ED 4B 5C7B       163          LD      BC,(UDG)        ; USER -DEFINED GRAPHICS(90-A4H)
005C'  05               164          DEC     B               ; ADJUST ADDRESS-100H
005D'  D6 70            165          SUB     70H             ; ADJUST FOR INDEX INTO TABLE
005F'  18 0C            166          JR      WRCH13
0061'  ED 4B 0031'      167  WRCH11  LD      BC,(GRTBL)      ; STD. GRAPHICS TABLE
0065'  D6 60            168          SUB     60H             ; ADJUST FOR INDEX INTO TABLE
0067'  18 04            169          JR      WRCH13
0069'  ED 4B 002F'      170  WRCH12  LD      BC,(CHTBL)      ; CHARACTER TABLE
006D'  EB               171  WRCH13  EX      DE,HL           ; DE=POSN.IN DISPLAY FILE
006E'  26 00            172          LD      H,0
0070'  6F               173          LD      L,A             ; CODE IS INDEX INTO TABLE
0071'  29               174          ADD     HL,HL
0072'  29               175          ADD     HL,HL
0073'  29               176          ADD     HL,HL
0074'  09               177          ADD     HL,BC           ; HL=PIXEL PATTERN IN TABLE
0075'  C1               178          POP     BC
0076'  EB               179          EX      DE,HL           ; DE=PIXEL PATTERN IN TABLE/HL=DF
0077'  79               180          LD      A,C             ; TEST IF END OF LINE
0078'  3D               181          DEC     A
0079'  3A 0033'         182          LD      A,(LINLEN)
007C'  20 05            183          JR      NZ,WRCH14
007E'  3C               184          INC     A               ; START OF NEW LINE
007F'  05               185          DEC     B               ; BUMP LINE NO.
0080'  4F               186          LD      C,A             ; LINLEN+1=START OF LINE
0081'  18 01            187          JR      WRCH15
0083'  3C               188  WRCH14  INC     A
0084'  B9               189  WRCH15  CP      C               ; TEST IF START OF LINE
0085'  D5               190          PUSH    DE
0086'  CC 014B'         191          CALL    Z,TVFULQ        ; TEST IF PAST 'BOTTOM' LINE
0089'  D1               192          POP     DE
                        193                                  ; HERE TO PUT CHARACTER IN DISPLAY FILE
008A'  C5               194  WRCH2   PUSH    BC              ; CURSOR POSITION
```

> *Transcriber's note:* From this page on, the listing prints opcodes at source column 8, operands at column 14 and comments at column 32. Here operands are re-spaced to column 16. The operand of line 147 (`A,(DATAB)`) is printed one column further left, at column 13. `SUBTTL` on line 143 is followed by a single space. Line 152 ends `'DFADRS` with no closing quote, as printed. The quotes in comments (lines 146, 151, 152, 191) are printed as acute accents. Line 163 is printed `USER -DEFINED`, with a space before the hyphen. Specks at the start of `PUSH .BC` on line 194 are not characters.

<!-- PDF page 23 — listing "Page 5-1" — WRITE CHARACTER — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
008B'  E5               195          PUSH    HL              ; DF ADDRESS
008C'  3A 0038'         196          LD      A,(MASKB)       ; GET OVER AND INVERSE CONTROLS
008F'  06 FF            197          LD      B,-1
0091'  1F               198          RRA
0092'  38 01            199          JR      C,WRCH3         ; IF XORING NEW INTO OLD
0094'  04               200          INC     B               ; B=-1 IF XORING  =0 IF NOT
0095'  1F               201  WRCH3   RRA
0096'  1F               202          RRA
0097'  9F               203          SBC     A,A
0098'  4F               204          LD      C,A             ; C=-1 FOR INVERSE  =0 IF NOT
0099'  3E 08            205          LD      A,8             ; SCAN COUNT
009B'  08               206  WRCH5   EX      AF,AF'          ; SAVE SCAN COUNT IN ALTERNATE
009C'  C5               207          PUSH    BC              ; SAVE MASK VALUES
009D'  D5               208          PUSH    DE              ; SAVE CHAR.TABLE ADRS
009E'  DD 21 0000       209          LD      IX,0            ; SAVE PTR.TO STACK
00A2'  DD 39            210          ADD     IX,SP
00A4'  56               211          LD      D,(HL)          ; READ SCAN LINE FROM DF
00A5'  E5               212          PUSH    HL              ; SAVE ADDRESS
00A6'  7C               213          LD      A,H
00A7'  EE 20            214          XOR     20H             ; TOGGLE TO ALTERNATE DF
00A9'  67               215          LD      H,A
00AA'  CB 6F            216          BIT     5,A             ; TEST WHICH DF
00AC'  20 01            217          JR      NZ,WRCH6        ; IN DF2
00AE'  23               218          INC     HL              ; NEXT BYTE
00AF'  5E               219  WRCH6   LD      E,(HL)          ; READ SCAN LINE FROM ALTERNATE DF
00B0'  EB               220          EX      DE,HL           ; SCANS TO HL. LAST DF POS.IN DE
00B1'  78               221          LD      A,B             ; TEST IF 'OVER' IS ACTIVE
00B2'  A7               222          AND     A
00B3'  20 1A            223          JR      NZ,NOXOR        ; YES-RETAIN OLD DATA
00B5'  3A 003E'         224          LD      A,(DFBIT)       ; NO- CLEAR OLD DATA AT CHAR.POSN.
00B8'  D6 07            225          SUB     7               ;
00BA'  ED 44            226          NEG
00BC'  01 03FF          227          LD      BC,03FFH        ; MASK
00BF'  28 08            228          JR      Z,NORR1         ; NO NEED TO ADJUST(CHAR.STARTS AT BIT 7)
00C1'  37               229          SCF
00C2'  CB 18            230  NEXT1   RR      B               ; SHIFT MASK 'A' TIMES
00C4'  CB 19            231          RR      C               ; (6 0'S START AT BIT 1 OF B, BIT 3 OF B,
00C6'  3D               232          DEC     A               ;  OR BIT 5 OF B)
00C7'  20 F9            233          JR      NZ,NEXT1
00C9'  7C               234  NORR1   LD      A,H             ; SCAN LINE FROM DF
00CA'  A0               235          AND     B
00CB'  67               236          LD      H,A             ; RETAIN ADJACENT CHAR.PIXELS
00CC'  7D               237          LD      A,L             ; CLEAR CURRENT CHAR.PIXELS
00CD'  A1               238          AND     C
00CE'  6F               239          LD      L,A             ; HL=OLD BIT ROW
00CF'  3A 003E'         240  NOXOR   LD      A,(DFBIT)       ; GET STARTING BIT POSN.
00D2'  D6 07            241          SUB     7
00D4'  ED 44            242          NEG
00D6'  E5               243          PUSH    HL              ; SAVE SCANS
00D7'  DD 6E 00         244          LD      L,(IX)          ; PTR. TO CHAR.SET
00DA'  DD 66 01         245          LD      H,(IX+1)
00DD'  46               246          LD      B,(HL)          ; SCAN LINE FROM CHAR.SET TO BC
```

> *Transcriber's note:* Operands are re-spaced from printed column 14 to 16. Lines 200 and 204 have two spaces before `=0`. On line 204 a faint dot after `INVERSE` is lower and smaller than the listing's period, so it is treated as a speck. Line 231's `0'S` uses the digit zero, and line 232 has two spaces after the `;`. A mark between the `;` and `GET` on line 240 is a speck. The primes in `AF,AF'` (line 206) and the quotes on lines 221 and 230 are printed as acute accents.

<!-- PDF page 24 — listing "Page 5-2" — WRITE CHARACTER — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
00DE'  0E 00            247          LD      C,0             ; (PIXELS IN B, BITS 7-2)
00E0'  F5               248          PUSH    AF              ; SAVE A AND FLAGS
00E1'  78               249          LD      A,B             ; PIXELS FROM CHAR. SET
00E2'  E6 FC            250          AND     0FCH            ; LIMIT TO 6 PIXELS
00E4'  47               251          LD      B,A             ;
00E5'  F1               252          POP     AF              ; RESTORE A AND FLAGS
00E6'  E1               253          POP     HL              ; RESTORE SCANS
00E7'  28 08            254          JR      Z,NORR2         ; NO SHIFT NEEDED
00E9'  A7               255          AND     A               ; CLEAR CARRY
00EA'  CB 18            256  NEXT2   RR      B               ; SHIFT 'A' TIMES
00EC'  CB 19            257          RR      C
00EE'  3D               258          DEC     A
00EF'  20 F9            259          JR      NZ,NEXT2
00F1'  7C               260  NORR2   LD      A,H             ; SCAN FROM DF
00F2'  A8               261          XOR     B               ; INSERT/COMBINE NEW CHAR.
00F3'  67               262          LD      H,A
00F4'  7D               263          LD      A,L
00F5'  A9               264          XOR     C
00F6'  6F               265          LD      L,A             ; DF XOR CH.SET->HL
00F7'  DD 7E 02         266          LD      A,(IX+2)        ; TEST IF INVERSE ACTIVE
00FA'  A7               267          AND     A
00FB'  28 1A            268          JR      Z,NOINVERT
00FD'  3A 003E'         269          LD      A,(DFBIT)
0100'  D6 07            270          SUB     7
0102'  ED 44            271          NEG
0104'  01 FC00          272          LD      BC,0FC00H       ; MASK TO INVERT
0107'  28 08            273          JR      Z,NORR3
0109'  A7               274          AND     A
010A'  CB 18            275  NEXT3   RR      B               ; SHIFT MASK 'A' TIMES
010C'  CB 19            276          RR      C
010E'  3D               277          DEC     A
010F'  20 F9            278          JR      NZ,NEXT3
0111'  7C               279  NORR3   LD      A,H
0112'  A8               280          XOR     B               ; INVERT CHARACTER
0113'  67               281          LD      H,A
0114'  7D               282          LD      A,L
0115'  A9               283          XOR     C
0116'  6F               284          LD      L,A
0117'  EB               285  NOINVERT EX     DE,HL           ; DF ADRS. TO HL-SCAN LINE IN DE
0118'  73               286          LD      (HL),E          ; WRITE SCAN LINE TO DF
0119'  E1               287          POP     HL              ; ALTERNATE DF
011A'  72               288          LD      (HL),D          ; WRITE SCAN LINE TO DF
011B'  D1               289          POP     DE              ; CHAR.SET
011C'  C1               290          POP     BC              ; OVER/INVERSE INDICATORS
011D'  08               291          EX      AF,AF'          ; RESTORE SCAN COUNT
011E'  24               292          INC     H               ; NEXT SCAN IN DF
011F'  13               293          INC     DE              ; NEXT BYTE IN CHAR.FILE
0120'  3D               294          DEC     A               ; TEST IF MORE SCANS
0121'  C2 009B'         295          JP      NZ,WRCH5
0124'  E1               296  WRCH7   POP     HL              ; TOP SCAN IN DF
0125'  C1               297          POP     BC              ; CURSOR POSITION
0126'  0D               298          DEC     C               ; ADJUST CURSOR POSITION
```

> *Transcriber's note:* Operands are re-spaced from printed column 14 to 16. The 8-character label `NOINVERT` (line 285) pushes `EX` one column right, so `EX` is printed at source column 9 and is kept there. Line 249 reads `CHAR. SET`, with a space after the period. Specks before the `;` on line 286 and left of `LD` on line 288 are not characters.

<!-- PDF page 25 — listing "Page 5-3" — WRITE CHARACTER — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0127'  3A 003E'         299          LD      A,(DFBIT)       ; ADJUST BIT POSITION
012A'  D6 06            300          SUB     6
012C'  32 003E'         301          LD      (DFBIT),A       ; STORE UPDATED POSITION
012F'  30 0E            302          JR      NC,WRCHXT       ; NEXT CHAR.IN SAME BYTE
0131'  C6 08            303          ADD     A,8             ; NEXT CHAR.IN NEXT BYTE
0133'  32 003E'         304          LD      (DFBIT),A       ; STORE ADJUSTED VALUE
0136'  7C               305          LD      A,H             ; ADJUST DF ADRS TO NEXT BYTE
0137'  EE 20            306          XOR     20H             ; TOGGLE TO ALTERNATE DF
0139'  67               307          LD      H,A
013A'  CB 6F            308          BIT     5,A             ; TEST WHICH DF
013C'  20 01            309          JR      NZ,WRCHXT       ; DONE IF DF2
013E'  23               310          INC     HL              ; NEXT BYTE IN DF1
013F'  CD 0550'         311  WRCHXT  CALL    STPOSN          ; STORE NEW POSITION
0142'  0E 00            312  GOODRET LD      C,0             ; RETURN BC=0
0144'  06 00            313  ERRRET  LD      B,0             ; ENTER HERE WITH C NON-ZERO
0146'  C9               314          RET
                        315  ;
0147'  0E 01            316  INVPAR  LD      C,1             ; RETURN BC=1 FOR INVALID PARAMETERS
0149'  18 F9            317          JR      ERRRET
                        318  ;
014B'  3E 18            319  TVFULQ  LD      A,SCRSZ         ; TEST IF NEW LINE IS OFF SCREEN
014D'  90               320          SUB     B               ; A=LINE NO.
014E'  57               321          LD      D,A             ; SAVE IN D
014F'  3A 002D'         322          LD      A,(BOTLN)       ; GET BOTTOM LINE
0152'  BA               323          CP      D
0153'  D2 0507'         324          JP      NC,UPDPOSN      ; ON SCREEN - RETURN TO WRITE CHAR.
                        325                                  ;  VIA UPDATE AND STORE POSITION
0156'  3A 002E'         326          LD      A,(SCRLCT)      ; TEST SCROLL COUNT
0159'  3D               327          DEC     A
015A'  20 0B            328          JR      NZ,TVFUL1       ; DO AUTOMATIC SCROLL USING SCRCTL
015C'  3E 01            329          LD      A,1             ; REINITIALIZE TO 1
015E'  32 002E'         330          LD      (SCRLCT),A
0161'  C1               331          POP     BC
0162'  C1               332          POP     BC              ; DISCARD RETURN TO WRITE CHAR.
0163'  0E 03            333          LD      C,3             ; RETURN BC=3 FOR SCREEN FULL
0165'  18 DD            334          JR      ERRRET
0167'  32 002E'         335  TVFUL1  LD      (SCRLCT),A      ; UPDATE VARIABLE
016A'  ED 4B 0028'      336          LD      BC,(SCRCTL)     ; GET SCROLL CONTROLS (STARTING LINE
                        337                                  ;   AND LINE COUNT)
016E'  C3 01E4'         338          JP      SCRL0           ; RETURN TO WRITE CHAR. VIA SCROLL
                        339  ;
```

> *Transcriber's note:* Operands are re-spaced from printed column 14 to 16. The operands of lines 335 (`(SCRLCT),A`) and 338 (`SCRL0`) are printed one column further left, at column 13. On line 322 the comment `; GET BOTTOM LINE` follows the operand directly (printed at source column 24); it is moved to column 32 here. Comment lines 325 and 337 are printed with two and three spaces after the `;`. A speck left of `0139'` (line 307) is not a character. Line 340 is not printed; it is probably a page-eject directive.

<!-- PDF page 26 — listing "Page 6" — WRITE STRING — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        341          SUBTTL  WRITE STRING
                        342  ;                               ; HERE FROM BASIC ENTRY TO
                        343  ;                               ; WRITE CHARACTER STRING TO SCREEN.
                        344  ;                               ; STRING IDENTIFIER (CH.CODE) IN
                        345  ;                               ; SYSTEM VARIABLE PARAM$ AT 5CC3H
0171'  3A 5CC3          346  WRSTR0  LD      A,(PARAM$)
0174'  E6 1F            347          AND     1FH             ; MASK OFF UPPER BITS
0176'  F6 40            348          OR      40H             ; STRING VARIABLE IDENTIFIER
0178'  57               349          LD      D,A             ; SAVE IN D
0179'  2A 5C4B          350          LD      HL,(VARS)       ; FIND STRING
017C'  7E               351  WRSTR1  LD      A,(HL)          ;
017D'  E6 7F            352          AND     07FH            ; TEST IF END OF VARS AREA
017F'  28 35            353          JR      Z,NOSTRG        ; NO FIND - RETURN BC=2
0181'  BA               354          CP      D               ; TEST IF MATCH
0182'  28 08            355          JR      Z,WRSTR2        ; FOUND STRING
0184'  D5               356          PUSH    DE              ; SAVE STRING ID
0185'  CD 1720          357          CALL    RECLEN          ; RETURNS ADRS.OF NEXT VAR.IN DE
0188'  EB               358          EX      DE,HL           ; ADRS. TO HL
0189'  D1               359          POP     DE              ; RESTORE STRING ID
018A'  18 F0            360          JR      WRSTR1
018C'  23               361  WRSTR2  INC     HL              ; GET LENGTH
018D'  4E               362          LD      C,(HL)
018E'  23               363          INC     HL
018F'  46               364          LD      B,(HL)
0190'  23               365          INC     HL              ; FIRST TEXT CODE
0191'  78               366          LD      A,B             ; TEST IF NULL STRING
0192'  B1               367          OR      C               ;
0193'  C8               368          RET     Z               ; RETURN IF SO
                        369  ;
                        370  ;                               ; ENTRY FROM MACHINE CODE WITH
                        371  ;                               ; ADDRESS OF CHAR.CODE 'STRING'
                        372  ;                               ; IN HL AND LENGTH IN BC
                        373  ;
0194'  7E               374  WRSTRG  LD      A,(HL)          ; GET CODE
0195'  E5               375          PUSH    HL              ; SAVE ADRS. AND
0196'  C5               376          PUSH    BC              ; COUNT
0197'  CD 0042'         377          CALL    WRCHAR          ; WRITE 'A'
019A'  79               378          LD      A,C             ; TEST IF GOOD
019B'  B0               379          OR      B
019C'  20 09            380          JR      NZ,WRSTX1       ; EXIT IF INVALID CODE OR
                        381                                  ; IF SCREEN FULL
019E'  C1               382  WRSTR3  POP     BC              ; COUNT
019F'  E1               383          POP     HL              ; ADDRESS
01A0'  23               384          INC     HL              ; NEXT CHAR.
01A1'  0B               385          DEC     BC              ; ADJUST COUNT
01A2'  78               386          LD      A,B             ; TEST IF DONE
01A3'  B1               387          OR      C
01A4'  20 EE            388          JR      NZ,WRSTRG       ; WRITE NEXT CHAR.
01A6'  C9               389          RET                     ; RETURN BC=0
                        390  ;
01A7'  79               391  WRSTX1  LD      A,C             ; SAVE ERROR
01A8'  FE 01            392          CP      1               ; TEST IF UNRECOGNIZED CODE
```

> *Transcriber's note:* Operands are re-spaced from printed column 14 to 16. `SUBTTL` on line 341 is followed by a single space. The quotes on lines 371 and 377 are printed as acute accents. A speck after the lone `;` on line 351 and a dash-like speck before `Z` on line 368 (`RET Z`) are not characters. `RECLEN` (`CD 1720`) and `PARAM$`/`VARS` (`3A 5CC3`, `2A 5C4B`) are absolute, matching their EQU values on PDF page 19.

<!-- PDF page 27 — listing "Page 6-1" — WRITE STRING — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
01AA'  28 F2            393          JR      Z,WRSTR3        ; CONTINUE
01AC'  E1               394          POP     HL              ; REMAINING COUNT TO HL
01AD'  22 003B'         395          LD      (STRGCT),HL     ; STORE REMAINING COUNT
01B0'  E1               396          POP     HL              ; ADDRESS TO HL
01B1'  0E 03            397          LD      C,3             ; RETURN BC=3 FOR SCREEN FULL
01B3'  06 00            398  WRSTX2  LD      B,0             ;
01B5'  C9               399          RET
                        400  ;
01B6'  0E 02            401  NOSTRG  LD      C,2             ; RETURN BC=2 IF STRING NOT FOUND
01B8'  18 F9            402          JR      WRSTX2
                        403  ;
                        404  ;
                        405  ;
```

> *Transcriber's note:* This page is printed much darker and is mottled. Every listing character is legible, but on line 395 the `;` looks like `$` in the noise. Only lines 393–405 are printed, and the rest of the page is blank. As on the other pages, the bottom margin shows the next listing page's running header ("Page 7").

<!-- PDF page 28 — listing "Page 7" — POSITION CONTROL — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       407          SUBTTL  POSITION CONTROL
                       408  ;
01BA'                  409  SETCB0:                         ; HERE FROM BASIC ENTRY.  PARAMETERS
                       410                                  ; IN LINCOL
01BA'  ED 4B 0007'     411          LD      BC,(LINCOL)
                       412  ;
01BE'                  413  SETCUR:                         ; ENTRY WITH LINE/COL. IN BC REG.
01BE'  CD 04EB'        414          CALL    TSTPAR          ; TEST PARAMETERS FOR VALIDITY
01C1'  CD 04FC'        415          CALL    CONVFM          ; CONVERT TO INTERNAL FORMAT
01C4'  CD 0507'        416          CALL    UPDPOSN         ; CALCULATE AND STORE POSITION
01C7'  C3 0142'        417          JP      GOODRET         ; RETURN BC=0
                       418  ;
```

> *Uncertain:* line 409 label `SETCB0`: read as `B` (flat left side, not `8`) and zero (oval, not the squared letter O), as in the sibling ASC 004 listing.

> *Transcriber's note:* On these pages the opcodes print at source column 8, the operands at about column 13–14 and the comments at column 32. The operands are re-spaced to column 16. Line 419 is not printed; it is probably a page-eject directive. The rest of the sheet is blank. The foot of the scan carries the next sheet's header ("Page 8"), from the continuous-form printout.

<!-- PDF page 29 — listing "Page 8" — SCROLL — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       420          SUBTTL  SCROLL
                       421  ;
                       422  ;
01CA'                  423  SCRLB0:                         ; HERE FROM BASIC ENTRY TO SCROLL
                       424  ;                               ; SCREEN
01CA'  ED 4B 0028'     425          LD      BC,(SCRCTL)     ; GET CONTROL INFO.
                       426  ;
01CE'                  427  SCROLL:                         ; HERE WITH CONTROLS IN BC
                       428                                  ;  B=NO. OF LINES
                       429                                  ;  C=STARTING LINE NO.
01CE'  78              430          LD      A,B             ; TEST VALIDITY
01CF'  A7              431          AND     A               ;
01D0'  CA 0147'        432          JP      Z,INVPAR        ; ERROR IF COUNT=0
01D3'  81              433          ADD     A,C
01D4'  FE 01           434          CP      1
01D6'  DA 0147'        435          JP      C,INVPAR        ; ERROR IF B+C<1
01D9'  FE 19           436          CP      25
01DB'  D2 0147'        437          JP      NC,INVPAR       ; ERROR IF B+C>24
01DE'  CD 01E4'        438          CALL    SCRL0           ; DO SCROLL
01E1'  C3 0142'        439          JP      GOODRET         ; RETURN BC=0
                       440  ;
01E4'  C5              441  SCRL0   PUSH    BC
01E5'  3E 18           442          LD      A,SCRSZ         ; GET STARTING LINE IN INTERNAL FORMAT
01E7'  91              443          SUB     C
01E8'  47              444          LD      B,A
01E9'  3A 0033'        445          LD      A,(LINLEN)
01EC'  3C              446          INC     A               ; COL. 0
01ED'  4F              447          LD      C,A
01EE'  CD 053F'        448          CALL    LNBU
01F1'  C1              449          POP     BC
01F2'  C5              450          PUSH    BC              ; SAVE ORIG.BC FOR EXIT
01F3'  7D              451  TESTAD  LD      A,L             ; TEST IF AT START OF BLOCK
01F4'  A7              452          AND     A
01F5'  28 51           453          JR      Z,STBLK         ; YES
01F7'  07              454          RLCA
01F8'  07              455          RLCA
01F9'  07              456          RLCA
01FA'  4F              457          LD      C,A             ; GET NO. OF LINES THIS BLOCK
01FB'  3E 08           458          LD      A,8
01FD'  91              459          SUB     C
01FE'  B8              460          CP      B               ; TEST AGAINST TOTAL LINES
01FF'  38 3F           461          JR      C,GRBLK         ; TOTAL GREATER THAN THIS BLOCK
0201'  78              462  INSDBLK LD      A,B
0202'  06 00           463          LD      B,0             ; REMAINING COUNT
0204'  C5              464          PUSH    BC
0205'  47              465  LOOP    LD      B,A             ; B=LINES THIS BLOCK
0206'  0E 08           466          LD      C,8             ; C=SCAN COUNT
0208'  78              467  LOOP0   LD      A,B
0209'  C5              468          PUSH    BC              ; SAVE SCAN COUNT
020A'  0F              469          RRCA
020B'  0F              470          RRCA
020C'  0F              471          RRCA                    ; CALCULATE NO. OF BYTES
```

> *Uncertain:* line 423 label `SCRLB0` (`B` by its flat left side, final character read as zero); lines 438/441 `SCRL0` and line 467 `LOOP0` (read as zero by the oval glyph shape, versus the squared letter O in `GOODRET`/`LOOP`).

> *Transcriber's note:* The foot of the scan carries the top of the next sheet's header.

<!-- PDF page 30 — listing "Page 8-1" — SCROLL — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
020D'  4F              472          LD      C,A
020E'  06 00           473          LD      B,0             ; BC=32*# OF LINES
0210'  EB              474  LOOP1   EX      DE,HL
0211'  21 FFE0         475          LD      HL,-20H         ; GET ADRS. OF PREV. LINE
0214'  19              476          ADD     HL,DE
0215'  EB              477          EX      DE,HL           ; TO DE
0216'  C5              478          PUSH    BC              ; SAVE COUNT
0217'  E5              479          PUSH    HL              ; SAVE ADDRESS
0218'  ED B0           480          LDIR                    ; DO MOVE
021A'  E1              481          POP     HL
021B'  C1              482          POP     BC
021C'  7C              483          LD      A,H
021D'  CB 6F           484          BIT     5,A             ; TEST IF DF1.
021F'  20 05           485          JR      NZ,NXTSC        ; NO
0221'  F6 20           486          OR      20H
0223'  67              487          LD      H,A             ; DO DF2
0224'  18 EA           488          JR      LOOP1
0226'  E6 DF           489  NXTSC   AND     0DFH            ; BACK TO DF1
0228'  67              490          LD      H,A
0229'  24              491          INC     H               ; NEXT SCAN LINE
022A'  C1              492          POP     BC              ; SCAN COUNT
022B'  0D              493          DEC     C
022C'  20 DA           494          JR      NZ,LOOP0        ; MORE SCANS
022E'  C1              495          POP     BC              ; RESIDUAL LINE COUNT
022F'  78              496          LD      A,B
0230'  A7              497          AND     A
0231'  28 04           498          JR      Z,SCRLXT        ; DONE
0233'  2E 00           499          LD      L,0             ; START OF NEXT BLOCK
0235'  18 BC           500          JR      TESTAD          ; DO REMAINING LINE(S)
0237'  C1              501  SCRLXT  POP     BC              ; ORIG.BC
0238'  79              502          LD      A,C             ; STARTING LINE
0239'  80              503          ADD     A,B             ; ADD NO. OF LINES MOVED
023A'  3D              504          DEC     A               ; LAST LINE SCROLLED
023B'  4F              505          LD      C,A
023C'  06 01           506          LD      B,1             ; CLEAR 1 LINE
023E'  18 52           507          JR      CLRSC0          ; CLEAR VACATED LINE AND RETURN
                       508  ;
0240'  4F              509  GRBLK   LD      C,A
0241'  78              510          LD      A,B
0242'  91              511          SUB     C               ; ADJUST TOTAL LINE COUNT BY NO.
0243'  47              512          LD      B,A             ; OF LINES THIS BLOCK
0244'  C5              513          PUSH    BC
0245'  79              514          LD      A,C             ; LOAD A NO. OF LINES THIS BLOCK
0246'  18 BD           515          JR      LOOP
                       516  ;
0248'  05              517  STBLK   DEC     B               ; ADJUST TOTAL LINE COUNT-1
0249'  C5              518          PUSH    BC
024A'  0E 08           519          LD      C,8             ; SCAN COUNT
024C'  C5              520  STBLK0  PUSH    BC              ; SAVE SCAN COUNT
024D'  EB              521  STBLK1  EX      DE,HL
024E'  21 F8E0         522          LD      HL,-720H
0251'  19              523          ADD     HL,DE
```

> *Uncertain:* line 484 comment `; TEST IF DF1.`: the final period is small and set slightly apart, so it could be a speck; lines 494 `LOOP0`, 507 `CLRSC0` and 520 `STBLK0` (read as zero by glyph shape).

> *Transcriber's note:* The comments on lines 478–480 print at source column 24, not 32. They are re-spaced to column 32 here, as the conventions require. The foot of the scan carries the next sheet's header ("Page 8-2").

<!-- PDF page 31 — listing "Page 8-2" — SCROLL — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0252'  EB              524          EX      DE,HL           ; ADRS. OF PREV. LINE
0253'  01 0020         525          LD      BC,32           ; BYTE COUNT
0256'  E5              526          PUSH    HL
0257'  ED B0           527          LDIR                    ; DO MOVE
0259'  E1              528          POP     HL
025A'  7C              529          LD      A,H
025B'  CB 6F           530          BIT     5,A
025D'  20 05           531          JR      NZ,STBLK2
025F'  F6 20           532          OR      20H             ; DO DF2
0261'  67              533          LD      H,A
0262'  18 E9           534          JR      STBLK1
0264'  E6 DF           535  STBLK2  AND     0DFH            ; BACK TO DF1
0266'  67              536          LD      H,A
0267'  24              537          INC     H               ; TO NEXT SCAN LINE
0268'  C1              538          POP     BC
0269'  0D              539          DEC     C               ; TEST IF MORE SCANS
026A'  20 E0           540          JR      NZ,STBLK0
026C'  C1              541          POP     BC              ; REMAINING LINE COUNT
026D'  78              542          LD      A,B
026E'  A7              543          AND     A
026F'  28 C6           544          JR      Z,SCRLXT
0271'  11 F820         545          LD      DE,-7E0H        ; ADJUST TO LINE 1
0274'  19              546          ADD     HL,DE
0275'  C3 01F3'        547          JP      TESTAD          ; BC=LINE COUNT
                       548                                  ; HL=DF ADDRESS
                       549  ;
```

> *Uncertain:* line 540 operand `STBLK0` (read as zero by glyph shape).

> *Transcriber's note:* Line 525 has a short dash-like speck between `LD` and `BC,32`, which is not part of the source. Line 538 has a small slash-like speck before `POP`. Line 550 is not printed; it is probably a page-eject directive. The rest of the sheet is blank. The foot of the scan carries the next sheet's header ("Page 9").

<!-- PDF page 32 — listing "Page 9" — CLEAR SCREEN — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       551          SUBTTL  CLEAR SCREEN
                       552  ;
                       553  ;
0278'                  554  CLRSB0:                         ; HERE FROM BASIC ENTRY TO CLEAR SCREEN
0278'  ED 4B 000C'     555          LD      BC,(CLRCTL)     ; GET CONTROL INFO.
                       556  ;
027C'                  557  CLRSCN:                         ; ENTRY WITH BC=LINE COUNT AND
                       558                                  ; STARTING LINE NO. FOR CLEAR
027C'  78              559          LD      A,B
027D'  A7              560          AND     A               ; TEST VALIDITY
027E'  CA 0147'        561          JP      Z,INVPAR        ; ERROR IF COUNT=0
0281'  81              562          ADD     A,C
0282'  FE 01           563          CP      1
0284'  DA 0147'        564          JP      C,INVPAR        ; ERROR IF B+C<1
0287'  FE 19           565          CP      25
0289'  D2 0147'        566          JP      NC,INVPAR       ; ERROR IF B+C>24
028C'  CD 0292'        567          CALL    CLRSC0          ; DO SERVICE
028F'  C3 0142'        568          JP      GOODRET         ; RETURN BC=0
                       569  ;
                       570  ;
0292'  C5              571  CLRSC0  PUSH    BC
0293'  3E 18           572          LD      A,SCRSZ         ; CONVERT TO INTERNAL FORMAT
0295'  91              573          SUB     C
0296'  47              574          LD      B,A
0297'  3A 0033'        575          LD      A,(LINLEN)
029A'  3C              576          INC     A               ; SET TO COL.0
029B'  4F              577          LD      C,A
029C'  CD 053F'        578          CALL    LNBU            ; GET ADDRESS
029F'  50              579          LD      D,B
02A0'  59              580          LD      E,C             ; SAVE POSITION
02A1'  C1              581          POP     BC              ; ORIG. BC
02A2'  D5              582          PUSH    DE
02A3'  7D              583  CLRSC1  LD      A,L             ; GET # OF LINES THIS BLOCK
02A4'  07              584          RLCA
02A5'  07              585          RLCA
02A6'  07              586          RLCA
02A7'  4F              587          LD      C,A
02A8'  3E 08           588          LD      A,8
02AA'  91              589          SUB     C
02AB'  B8              590          CP      B               ; COMPARE TO TOTAL LINE COUNT
02AC'  38 3D           591          JR      C,CLRSC7
02AE'  78              592  CLRSC2  LD      A,B             ; NO. OF LINES
02AF'  06 00           593          LD      B,0             ; REMAINING LINES
02B1'  C5              594          PUSH    BC
02B2'  47              595  CLRSC3  LD      B,A
02B3'  0E 08           596          LD      C,8             ; SCAN COUNT
02B5'  78              597  CLRSC4  LD      A,B
02B6'  C5              598          PUSH    BC
02B7'  E6 07           599          AND     7
02B9'  0F              600          RRCA
02BA'  0F              601          RRCA
02BB'  0F              602          RRCA
```

> *Uncertain:* line 554 label `CLRSB0`; lines 567/571 `CLRSC0` (both read as zero by glyph shape).

> *Transcriber's note:* The foot of the scan carries the next sheet's header ("Page 9-1").

<!-- PDF page 33 — listing "Page 9-1" — CLEAR SCREEN — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
02BC'  4F              603          LD      C,A             ; BC=32*NO. OF LINES
02BD'  06 00           604          LD      B,0             ; (=0 IF 256 FOR 8 LINES)
02BF'  0D              605          DEC     C               ; ADJUST
02C0'  C5              606  CLRSC5  PUSH    BC
02C1'  E5              607          PUSH    HL
02C2'  54              608          LD      D,H
02C3'  5D              609          LD      E,L
02C4'  36 00           610          LD      (HL),00         ; CLEAR DF
02C6'  13              611          INC     DE
02C7'  ED B0           612          LDIR
02C9'  E1              613          POP     HL
02CA'  C1              614          POP     BC
02CB'  7C              615          LD      A,H
02CC'  CB 6F           616          BIT     5,A
02CE'  20 05           617          JR      NZ,CLRSC6
02D0'  F6 20           618          OR      20H
02D2'  67              619          LD      H,A             ; DO DF2
02D3'  18 EB           620          JR      CLRSC5
02D5'  E6 DF           621  CLRSC6  AND     0DFH            ; RESTORE DF1
02D7'  67              622          LD      H,A
02D8'  24              623          INC     H               ; NEXT SCAN ROW
02D9'  C1              624          POP     BC              ; POP SCAN COUNT
02DA'  0D              625          DEC     C
02DB'  20 D8           626          JR      NZ,CLRSC4
02DD'  C1              627          POP     BC              ; TOTAL LINE COUNT
02DE'  78              628          LD      A,B
02DF'  A7              629          AND     A
02E0'  28 05           630          JR      Z,CLRSXT
02E2'  2E 00           631          LD      L,0             ; HL=START OF NEXT BLOCK
02E4'  C3 02A3'        632          JP      CLRSC1          ; B=REMAINING LINE COUNT
02E7'  C1              633  CLRSXT  POP     BC              ; POSITION
02E8'  C3 0507'        634          JP      UPDPOSN         ; RETURN VIA UPDATE AND STORE POSITION
02EB'  4F              635  CLRSC7  LD      C,A             ; SAVE NO. LINES THIS BLOCK
02EC'  78              636          LD      A,B
02ED'  91              637          SUB     C               ; ADJUST TOTAL LINE COUNT
02EE'  47              638          LD      B,A
02EF'  C5              639          PUSH    BC              ; REMAINING LINE COUNT
02F0'  79              640          LD      A,C             ; LINES THIS BLOCK
02F1'  18 BF           641          JR      CLRSC3          ;
```

> *Transcriber's note:* Line 642 is not printed; it is probably a page-eject directive. The rest of the sheet is blank. The foot of the scan carries the next sheet's header ("Page 10").

<!-- PDF page 34 — listing "Page 10" — ATTRIBUTE CONTROL — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       643          SUBTTL  ATTRIBUTE CONTROL
                       644  ;
                       645  ;
                       646  ;
02F3'                  647  SETAB0:                         ; HERE FROM BASIC ENTRY TO SET ATTRIBUTES
02F3'  3A 0011'        648          LD      A,(ATTCTL)      ; GET CONTROL INFO.
                       649  ;
02F6'                  650  SETATT:                         ; ENTRY WITH ATTRIBUTE BYTE IN A
02F6'  E6 07           651          AND     7               ; GET INK SELECTION
02F8'  4F              652          LD      C,A             ; SAVE
02F9'  3A 5CC2         653          LD      A,(VIDMOD)      ; TEST IF DF2 OPEN
02FC'  A7              654          AND     A
02FD'  CA 0147'        655          JP      Z,INVPAR        ; INVALID IF DF2 NOT OPEN
0300'  79              656          LD      A,C
0301'  17              657          RLA
0302'  17              658          RLA
0303'  17              659          RLA                     ; SHIFT TO H/W POSITION
0304'  F5              660          PUSH    AF              ; SAVE ROTATED VALUE
0305'  F6 06           661          OR      6               ; SET H/W MODE
0307'  47              662          LD      B,A             ; VALUE FOR H/W
0308'  DB FF           663          IN      A,(HREXPT)      ;
030A'  E6 C0           664          AND     0C0H            ; PRESERVE BITS 7 AND 6
030C'  B0              665          OR      B               ; SET VIDEO MODE VALUE
030D'  D3 FF           666          OUT     (HREXPT),A      ; SET H/W
030F'  F6 40           667          OR      40H             ; UPDATE VIDMOD
0311'  32 5CC2         668          LD      (VIDMOD),A      ;
0314'  F1              669          POP     AF              ; INK SEL.IN BITS 3-5
0315'  2F              670          CPL                     ; GET COMPLEMENTARY COLOR
0316'  B1              671          OR      C               ; COMBINE WITH INK
0317'  32 0039'        672          LD      (ATTBYT),A      ; SAVE IN VARIABLE
031A'  C3 0142'        673          JP      GOODRET         ; RETURN BC=0
                       674  ;
                       675  ;
                       676  ;
031D'                  677  SETMB0:                         ; HERE FROM BASIC ENTRY TO SET MASK
031D'  3A 0015'        678          LD      A,(MSKCTL)      ; GET CONTROL INFO.
                       679  ;
0320'                  680  SETMSK:                         ; ENTRY WITH MASK VALUE IN A
0320'  32 0038'        681          LD      (MASKB),A       ; STORE MASK FOR APPLICATION TO FUTURE
0323'  C3 0142'        682          JP      GOODRET         ; DISPLAYS
                       683  ;
```

> *Uncertain:* line 647 label `SETAB0` and line 677 label `SETMB0` (read as zero by glyph shape).

> *Transcriber's note:* Line 666 has a small speck just left of the `;`, which is not a character. Line 684 is not printed; it is probably a page-eject directive. The rest of the sheet is blank. The foot of the scan carries the next sheet's header ("Page 11").

<!-- PDF page 35 — listing "Page 11" — 'GET' ROUTINES — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       685          SUBTTL  'GET' ROUTINES
                       686  ;
                       687  ;
0326'                  688  GTCHB0:                         ; HERE FROM BASIC ENTRY TO GET CHARACTER
                       689                                  ; (RETURNS CODE FOR CHARACTER AT
                       690                                  ;  POSITION SPECIFIED IN GETCTL)
0326'  ED 4B 0019'     691          LD      BC,(GETCTL)     ; GET CONTROL INFO.
                       692  ;
032A'                  693  GTCHAR:                         ; ENTRY WITH POSITION IN BC
032A'  CD 04EB'        694          CALL    TSTPAR          ; TEST PARAMETERS
032D'  3A 003E'        695          LD      A,(DFBIT)       ; SAVE CURRENT BIT POSITION
0330'  F5              696          PUSH    AF
0331'  CD 04FC'        697          CALL    CONVFM          ; CONVERT TO INTERNAL FORMAT
0334'  CD 050C'        698          CALL    CALCPOS         ; GET DF ADDRESS AND BIT POS.
0337'  ED 5B 002F'     699          LD      DE,(CHTBL)      ; CHAR.TABLE
033B'  06 60           700          LD      B,96            ; NO. OF PRINTABLE CHARACTERS
033D'  3E 80           701          LD      A,80H           ; SET ADJUSTMENT INDEX
033F'  32 003A'        702  GTCH1   LD      (GTINDX),A
0342'  14              703          INC     D               ; ADJUST TO START OF TABLE
0343'  C5              704  GTCH2   PUSH    BC              ; SAVE COUNT
0344'  E5              705          PUSH    HL              ; SAVE ADRS. IN DF
0345'  D5              706          PUSH    DE              ; SAVE ADRS. IN CHAR.TABLE
0346'  CD 0560'        707          CALL    GTC2BC          ; GET SCAN LINE FROM DF TO REG.B
                       708                                  ; BITS 7-2
0349'  78              709  GTCH22  LD      A,B
034A'  E6 FC           710          AND     0FCH            ; 6 BITS TO A
034C'  47              711          LD      B,A
034D'  EB              712          EX      DE,HL           ; CHAR.SET PTR. TO HL
034E'  7E              713          LD      A,(HL)          ; PIXEL ROW TO A
034F'  E6 FC           714          AND     0FCH            ; MASK TO 6 BITS
0351'  A8              715          XOR     B               ; TEST AGAINST DF
0352'  28 10           716          JR      Z,GTCH3         ; MATCH
0354'  F5              717          PUSH    AF
0355'  3A 003A'        718          LD      A,(GTINDX)      ; TEST IF LOOKING AT STD.GRAPHICS
0358'  FE 90           719          CP      90H
035A'  20 03           720          JR      NZ,GTCH23
035C'  F1              721          POP     AF
035D'  18 3B           722          JR      GTCH4           ; DO NOT TEST INVERSE IF STD.GR.
035F'  F1              723  GTCH23  POP     AF
0360'  FE FC           724          CP      0FCH            ; TEST IF MATCH ON INVERSE
0362'  20 36           725          JR      NZ,GTCH4        ; DOES NOT MATCH
0364'  4F              726  GTCH3   LD      C,A             ; C=0 FOR MATCH  -4 FOR INVERSE
0365'  06 07           727          LD      B,7             ; SCAN COUNT
0367'  EB              728  GTCH31  EX      DE,HL           ; DF ADRS.TO HL
0368'  C5              729          PUSH    BC              ; SAVE MATCH AND SCAN COUNT
0369'  24              730          INC     H               ; NEXT SCAN IN DF
036A'  13              731          INC     DE              ; NEXT ROW IN CHAR.SET
036B'  CD 0560'        732          CALL    GTC2BC          ; NEXT SCAN ROW TO BC
036E'  78              733          LD      A,B
036F'  E6 FC           734          AND     0FCH
0371'  47              735          LD      B,A             ;
0372'  EB              736          EX      DE,HL           ; CHAR.SET PTR. TO HL
```

> *Uncertain:* line 688 label `GTCHB0` (read as zero by glyph shape).

> *Transcriber's note:* The quote marks in the `SUBTTL` on line 685 (and in the page header) print as an acute-like tick, transcribed as `'`. The comments on lines 729–731 print at source column 24, not 32. They are re-spaced to column 32 here. The foot of the scan carries the start of the next sheet's header.

<!-- PDF page 36 — listing "Page 11-1" — 'GET' ROUTINES — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0373'  7E              737          LD      A,(HL)          ; CHAR.SET ROW
0374'  E6 FC           738          AND     0FCH            ; MASK TO 6 BITS
0376'  A8              739          XOR     B               ; TEST MATCH
0377'  C1              740          POP     BC              ; GET PREV.MATCH AND SCAN COUNT
0378'  A9              741          XOR     C
0379'  20 1F           742          JR      NZ,GTCH4        ; NO MATCH-START AGAIN AT NEXT
037B'  10 EA           743          DJNZ    GTCH31          ; DO NEXT SCAN
037D'  79              744          LD      A,C             ; A=-4 IF MATCH ON INVERSE
037E'  C6 03           745          ADD     A,3             ; SET TO -1 IF MATCH ON INVERSE
0380'  C1              746          POP     BC              ; HERE IF MATCH- (SP)=PTR.TO CHAR.
0381'  C1              747          POP     BC              ; IN TABLE;(SP+2)=CHAR.IN DF;
0382'  C1              748          POP     BC              ; (SP+4)=CHAR.COUNT
0383'  4F              749          LD      C,A             ; B=COUNT C=-1 IF MATCH ON INVERSE
0384'  3A 003A'        750          LD      A,(GTINDX)      ; CONVERT MATCH TO CHAR.CODE
0387'  90              751          SUB     B
0388'  FE 20           752          CP      20H             ; TEST IF MATCH ON SPACE
038A'  20 05           753          JR      NZ,GTCH32       ; NO
038C'  0C              754          INC     C               ; TEST IF MATCH ON INVERSE
038D'  20 02           755          JR      NZ,GTCH32
038F'  3E 8F           756          LD      A,8FH           ; LOAD CODE FOR GRAPHICS BLOCK
0391'  4F              757  GTCH32  LD      C,A             ; RETURN IN REG. C OF BC PAIR
0392'  06 00           758          LD      B,0             ; AND IN REG. A
0394'  F1              759          POP     AF
0395'  32 003E'        760          LD      (DFBIT),A       ; RESTORE DFBIT
0398'  79              761          LD      A,C             ; CHAR.CODE TO A
0399'  C9              762          RET
                       763  ;
039A'  E1              764  GTCH4   POP     HL              ; PTR. TO CHR. SET
039B'  11 0008         765          LD      DE,8            ; MOVE ON TO NEXT CHARACTER
039E'  19              766          ADD     HL,DE
039F'  5D              767          LD      E,L
03A0'  54              768          LD      D,H
03A1'  E1              769          POP     HL              ; DF ADDRESS
03A2'  C1              770          POP     BC              ; CHAR. COUNT
03A3'  10 9E           771          DJNZ    GTCH2           ; DECREMENT CHAR.COUNT AND LOOK AGAIN
                       772  ;
03A5'  3A 003A'        773          LD      A,(GTINDX)      ; TEST IF DONE
03A8'  FE 80           774          CP      80H             ; TEST IF STD.CHR.SET
03AA'  20 0A           775          JR      NZ,GTCH5        ; TRY GRAPHICS
03AC'  ED 5B 0031'     776          LD      DE,(GRTBL)      ; GRAPHICS TABLE
03B0'  06 10           777          LD      B,16            ; NO. OF ENTRIES
03B2'  3E 90           778          LD      A,90H
03B4'  18 89           779          JR      GTCH1
03B6'  FE 90           780  GTCH5   CP      90H             ; TEST IF STD.GRAPHICS
03B8'  20 0C           781          JR      NZ,GTCH6        ;
03BA'  ED 5B 5C7B      782          LD      DE,(UDG)        ; TRY USER-DEFINED GRAPHICS
03BE'  15              783          DEC     D               ; ADJUST ADDRESS-100H
03BF'  06 15           784          LD      B,21            ; NO. OF ENTRIES
03C1'  3E A5           785          LD      A,0A5H          ; INDEX ADJUST
03C3'  C3 033F'        786          JP      GTCH1
                       787
                       788  ;                               ; NO MATCH AT ALL
```

> *Transcriber's note:* The sheet is scanned about 1° off square, so the comment column runs progressively lower than the code. The page was deskewed before the comments were matched to lines. Line 776's comment prints at source column 40 (indented 8 past the usual column 32); it is re-spaced to column 32. Line 788 holds a `;` at column 0 and the comment `; NO MATCH AT ALL` on the same printed row, so it is transcribed as one line. Line 781's target `GTCH6` (03C6') is on the next sheet. The rest of the sheet is blank. The foot of the scan carries the next sheet's header (page number cut off).

<!-- PDF page 37 — listing "Page 11-2" — 'GET' ROUTINES — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
03C6'  F1               789  GTCH6   POP     AF              ; RESTORE ORIG. DFBIT
03C7'  32 003E'         790          LD      (DFBIT),A
03CA'  48               791          LD      C,B             ; BC=0
03CB'  AF               792          XOR     A               ; A=0
03CC'  C9               793          RET
                        794
                        795                          ; GET ATTRIBUTE BYTE
                        796                          ; NOTE THAT IN 80-COL.MODE ALL SCREEN POSITIONS
                        797                          ; HAVE THE SAME ATTRIBUTES, THEREFORE IT IS
                        798                          ; NOT NECESSARY TO USE THE 'GETCTL' POSITION
                        799                          ; PARAMETERS
                        800  ;
03CD'                   801  GETAB0:                         ; HERE FROM BASIC ENTRY TO GET ATTRIBUTE
                        802  ;
03CD'  3A 0039'         803  GETATT: LD      A,(ATTBYT)      ; GET ATTRIBUTE BYTE
03D0'  4F               804          LD      C,A             ; PUT IN BC
03D1'  06 00            805          LD      B,0
03D3'  C9               806          RET
                        807  ;                       ; GET CURSOR POSITION
03D4'                   808  GETCB0:                         ; HERE FROM BASIC ENTRY
03D4'                   809  GETCUR:
03D4'  ED 4B 0034'      810          LD      BC,(CURPOS)     ; GET INTERNAL POSITION
03D8'  CD 04FC'         811          CALL    CONVFM          ; CONVERT TO USER FORMAT
03DB'  3A 0033'         812          LD      A,(LINLEN)      ; TEST IF END OF LINE
03DE'  B9               813          CP      C               ; IF =80 OR 85
03DF'  20 0B            814          JR      NZ,GETC1        ; NO
03E1'  0E 00            815          LD      C,0             ; NEXT POSN.START OF NEXT LINE
03E3'  78               816          LD      A,B
03E4'  3C               817          INC     A               ; BUMP TO NEXT LINE
03E5'  47               818          LD      B,A
03E6'  FE 18            819          CP      24              ; TEST IF OFF SCREEN
03E8'  38 02            820          JR      C,GETC1         ; NO
03EA'  06 17            821          LD      B,23            ; POSN. IS AT BOTTOM LINE
03EC'  ED 43 0007'      822  GETC1   LD      (LINCOL),BC     ; STORE FOR BASIC PROGRAM
03F0'  C9               823          RET                     ; VALUES ALSO IN BC
                        824  ;
```

> *Transcriber's note:* On this page the opcodes are at source column 8 and most operands at column 13 to 14; the operands are re-spaced to column 16. The comments on lines 801, 803, 804, 807 and 808 are printed at source column 24, and the rest at column 32. The comment-only lines 795–799 and 807 are kept at column 24 as printed; the inline comments on 801, 803, 804 and 808 are normalised to column 32. The labels `GETAB0` and `GETCB0` end in the oval digit zero, not the squarer letter O (compared at 3× zoom with `SETMODE` on the next page). The listing ends at line 824, about two-thirds of the way down; the rest of the sheet is blank. Line 825 is not printed anywhere; it is probably a page-eject directive.

<!-- PDF page 38 — listing "Page 12" — VIDEO MODE CONTROL — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        826          SUBTTL  VIDEO MODE CONTROL
                        827  ;
                        828  ;
03F1'                   829  STMDB0:                         ; HERE FROM BASIC ENTRY WITH MODE IN
                        830                          ; 'VIMODE'
03F1'  3A 0024'         831          LD      A,(VIMODE)
                        832  ;
03F4'                   833  SETMODE:                        ; ENTRY WITH MODE IN A
                        834  ;
03F4'  A7               835          AND     A
03F5'  28 4F            836          JR      Z,SETMD1        ; TEST FOR VALIDITY
03F7'  FE 08            837          CP      8               ; 8=80 COL.MODE
03F9'  C2 0147'         838          JP      NZ,INVPAR       ; INVALID PARAMETERS
                        839  ;                       ;
                        840  ;                       ;
03FC'  21 1701          841          LD      HL,SCINIT       ; INITIALIZE VARIABLES
03FF'  22 0028'         842          LD      (SCRCTL),HL     ; SCROLL CONTROL
0402'  3E 17            843          LD      A,23            ;
0404'  32 002D'         844          LD      (BOTLN),A       ; BOTTOM LINE
0407'  3E 01            845          LD      A,1             ;
0409'  32 002E'         846          LD      (SCRLCT),A      ; SCROLL COUNT
040C'  3E 50            847          LD      A,80            ;
040E'  32 0033'         848          LD      (LINLEN),A      ; LINE LENGTH
0411'  3E 01            849          LD      A,1             ;
0413'  32 003D'         850          LD      (MARGIN),A      ; MARGIN
0416'  21 1800          851          LD      HL,CLINIT       ;
0419'  22 000C'         852          LD      (CLRCTL),HL     ; CLEAR SCREEN CONTROL
041C'  AF               853          XOR     A
041D'  32 0038'         854          LD      (MASKB),A       ; MASK BYTE
0420'  32 003B'         855          LD      (STRGCT),A      ; WRSTRG REMAINING COUNT
0423'  32 003C'         856          LD      (STRGCT+1),A    ;
0426'  21 047E'         857          LD      HL,CHRSET       ; STD. CHAR. SET
0429'  22 002F'         858          LD      (CHTBL),HL      ;
042C'  21 077E'         859          LD      HL,GRPHST       ; STD. GRAPHICS SET
042F'  22 0031'         860          LD      (GRTBL),HL      ;
                        861  ;                       ;
                        862  ;                       ; INITIALIZE BASIC INPUTS
                        863  ;                       ;
0432'  32 0000'         864          LD      (DATAB),A       ; DATA BYTE
0435'  32 0007'         865          LD      (LINCOL),A      ; COLUMN
0438'  32 0008'         866          LD      (LINCOL+1),A    ; LINE
043B'  32 0015'         867          LD      (MSKCTL),A      ; MASK CONTROL
043E'  32 0019'         868          LD      (GETCTL),A      ; 'GET' COL.
0441'  32 001A'         869          LD      (GETCTL+1),A    ; 'GET' LINE
0444'  3E 06            870          LD      A,6             ; SET H/W TO 64-COL.MODE
0446'  47               871  SETMD1  LD      B,A             ; SAVE MODE
0447'  3A 5CC2          872          LD      A,(VIDMOD)
044A'  A7               873          AND     A               ; TEST CURRENT MODE
044B'  20 1D            874          JR      NZ,SETMD2
044D'  B0               875          OR      B               ; CURRENT MODE=0  TEST IF NEW MODE=0
044E'  CA 0142'         876          JP      Z,GOODRET       ; RETURN BC=0
0451'  21 12C0          877          LD       HL,INSERTSZ
```

> *Transcriber's note:* On this page the opcodes are at source column 8, the operands at column 12 to 13 and the comments at column 24. The operands are re-spaced to column 16 and the inline comments to column 32; the comment-only lines (830, 839–840, 861–863) are kept at column 24 as printed. Line 877's operand is printed with a leading space (`LD    HL,INSERTSZ`, one column right of the others); that space is kept. Line 826 has a small speck just before `SUBTTL`, which is not a character. `STMDB0` ends in the oval digit zero. The listing ends at line 877, about four-fifths of the way down. The bottom of the scan shows a dark fold band and the header of the next sheet.

<!-- PDF page 39 — listing "Page 12-1" — VIDEO MODE CONTROL — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0454'  11 0840          878          LD      DE,MOVESZ
0457'  19               879          ADD     HL,DE           ; HL=TOTAL ROOM NEEDED
0458'  ED 5B 5C65       880          LD      DE,(STKEND)
045C'  19               881          ADD     HL,DE           ; ADD MEMORY IN USE
045D'  DA 04A7'         882          JP      C,EXTNRM        ; NOT ENOUGH MEMORY TO OPEN DF2
0460'  ED 5B 5CB2       883          LD      DE,(RAMTOP)
0464'  A7               884          AND     A
0465'  ED 52            885          SBC     HL,DE
0467'  D2 04A7'         886          JP      NC,EXTNRM       ; NOT ENOUGH MEMORY
046A'  CD 04D2'         887  SETMD2  CALL    ENBLEXT         ; ENABLE ROM EXT.
046D'  78               888          LD      A,B             ; MODE TO A
046E'  CD 04AC'         889          CALL    GETVAL          ; H/W VALUE TO B; VIDMOD VALUE TO C
0471'  C5               890          PUSH    BC              ; SAVE
0472'  78               891          LD      A,B
0473'  CD 0E8E          892          CALL    CHNGVID         ; CALL RTN. TO OPEN/CLOSE 2ND DF
0476'  CD 04DF'         893          CALL    ENBLHOME        ; REENABLE HOME BANK
0479'  C1               894          POP     BC              ; VALUE FOR VIDMOD
047A'  79               895          LD      A,C
047B'  32 5CC2          896          LD      (VIDMOD),A      ; UPDATE VIDMOD
047E'  CB 77            897  UPDATE  BIT     6,A             ; UPDATE SYSTEM VARS. BASED ON MODE
0480'  CA 0142'         898          JP      Z,GOODRET       ; DONE IF MODE 0
0483'  3E C1            899  SXT4    LD      A,0C1H          ; 64/80-COL. MODE
0485'  B0               900          OR      B               ; STORE ATTRIBUTE BYTE BASED
0486'  2F               901          CPL                     ; ON INK SELECTION
0487'  CB 38            902          SRL     B
0489'  CB 38            903          SRL     B
048B'  CB 38            904          SRL     B
048D'  B0               905          OR      B
048E'  32 0039'         906          LD      (ATTBYT),A      ; ATTRIBUTE BYTE
0491'  32 0011'         907          LD      (ATTCTL),A      ; BASIC PARAMETER
0494'  3A 0033'         908          LD      A,(LINLEN)
0497'  3C               909          INC     A
0498'  4F               910          LD      C,A
0499'  06 18            911          LD      B,18H           ; BC=HOME POSITION (LN.0/COL.0)
049B'  21 0000          912          LD      HL,0
049E'  22 5C7D          913          LD      (COORDS),HL     ; PLOT POSITION
04A1'  CD 0507'         914          CALL    UPDPOSN         ; UPDATE AND STORE HOME POSITION
04A4'  C3 0142'         915          JP      GOODRET         ; RETURN BC=0
04A7'  0E 02            916  EXTNRM  LD      C,2             ; RETURN BC=2 FOR NO ROOM
04A9'  C3 0144'         917          JP      ERRRET
                        918  ;
```

> *Transcriber's note:* Line 896 is printed with no space before the comment (`(VIDMOD),A; UPDATE VIDMOD`); it is re-spaced to column 32. The label on line 899 is printed `SXT4` (confirmed at 4× zoom). The comments on lines 897–917 are printed at about source column 32 and the earlier ones at column 24; all inline comments are normalised to column 32. The listing ends at line 918, about two-thirds of the way down. Line 919 is not printed anywhere; it is probably a page-eject directive. The bottom of the scan shows the header of the next sheet ("Page 13").

<!-- PDF page 40 — listing "Page 13" — INTERNAL SUB-RTNS. — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        920          SUBTTL  INTERNAL SUB-RTNS.
                        921  ;
                        922  ;
                        923  ;
                        924                          ; INPUT:  VIDEO MODE IN A
                        925                          ; OUTPUT: H/W SETTING IN B
                        926                          ;         VIDMOD SETTING IN C
                        927                          ; RETURNS NZ STATUS IF MODE INVALID
                        928                          ;
                        929                          ;  VALID VALUES:  INPUT     H/W     VIDMOD
                        930                          ;                 -----     ---     ------
                        931                          ;   *=DISPLAY FILE ACTIVE AT SCREEN
                        932                          ;
                        933                          ;    DF1 ONLY       0        0         0
                        934                          ;   DF1*& DF2      80        0        80
                        935                          ;   DF1 & DF2*      1        1        81
                        936                          ;  HIGH RES.GR.     2        2         2
                        937                          ;  64/80-COLUMN   06 - 3E  06 - 3E   46 - 7E
04AC'  4F               938  GETVAL  LD      C,A
04AD'  CB 47            939          BIT     0,A
04AF'  20 16            940          JR      NZ,TST01
04B1'  FE 80            941          CP      80H
04B3'  28 1A            942          JR      Z,SET0
04B5'  CB 7F            943          BIT     7,A
04B7'  C0               944          RET     NZ
04B8'  47               945          LD      B,A
04B9'  FE 02            946          CP      2
04BB'  C8               947          RET     Z
04BC'  E6 C6            948          AND     0C6H
04BE'  EE 06            949          XOR     6
04C0'  C0               950          RET     NZ
04C1'  3E 40            951          LD      A,40H
04C3'  B1               952          OR      C
04C4'  4F               953          LD      C,A
04C5'  AF               954          XOR     A
04C6'  C9               955          RET
04C7'  FE 01            956  TST01   CP      1
04C9'  C0               957          RET     NZ
04CA'  06 01            958          LD      B,1
04CC'  0E 81            959          LD      C,81H
04CE'  C9               960          RET
04CF'  AF               961  SET0    XOR     A
04D0'  47               962          LD      B,A
04D1'  C9               963          RET
                        964  ;
                        965  ;
                        966                          ; ROUTINES TO ENABLE CHUNK 0 IN ROM EXT.
                        967                          ; FOR ACCESS TO CHNGVID ROUTINE
04D2'  F5               968  ENBLEXT PUSH    AF
04D3'  DB FF            969          IN      A,(HREXPT)
04D5'  F6 80            970          OR      80H             ; SELECT ROM EXT.
04D7'  D3 FF            971          OUT     (HREXPT),A
```

> *Transcriber's note:* The comment block on lines 924–937 is printed at source column 24 and kept there; the internal spacing of the VALID VALUES table (929–937) was measured off the scan and is approximate. Lines 966–967 are also at column 24. In line 934 `DF1*& DF2` is printed with no space after the `*`, as shown. In line 933 a speck sits just left of the VIDMOD `0`; it is not a character. The labels `TST01` and `SET0` (lines 940, 942, 956, 961) end in the oval digit zero; `SET0` was compared at 4× zoom against the zero of `TST01` and the letter O of `XOR`. The listing ends at line 971, about four-fifths of the way down.

<!-- PDF page 41 — listing "Page 13-1" — INTERNAL SUB-RTNS. — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
04D9'  3E 03            972          LD      A,3
04DB'  D3 F4            973          OUT     (DKHSPT),A
04DD'  F1               974          POP     AF
04DE'  C9               975          RET
                        976  ;
04DF'  F5               977  ENBLHOME PUSH   AF
04E0'  AF               978          XOR     A
04E1'  D3 F4            979          OUT     (DKHSPT),A
04E3'  DB FF            980          IN      A,(HREXPT)
04E5'  E6 3F            981          AND     03FH
04E7'  D3 FF            982          OUT     (HREXPT),A
04E9'  F1               983          POP     AF
04EA'  C9               984          RET
                        985  ;
                        986                                  ; TEST PARAMETER VALIDITY
                        987                                  ; IF NOT VALID, DISCARDS RETURN
                        988                                  ; AND EXITS VIA INVPAR
04EB'  3E 17            989  TSTPAR  LD      A,23            ; TEST LINE >23
04ED'  B8               990          CP      B
04EE'  30 04            991          JR      NC,TSTPR1
04F0'  F1               992  PARERR  POP     AF
04F1'  C3 0147'         993          JP      INVPAR
04F4'  3A 0033'         994  TSTPR1  LD      A,(LINLEN)
04F7'  3D               995          DEC     A
04F8'  B9               996          CP      C               ; TEST COL. >LINE LENGTH-1
04F9'  38 F5            997          JR      C,PARERR
04FB'  C9               998          RET
                        999  ;
                       1000                                  ; CONVERT LINE/COL. FROM USER TO
                       1001                                  ; INTERNAL FORMAT AND VICE VERSA
                       1002                                  ; USER FORMAT: LINES 0-23
                       1003                                  ;              COL. 0-79(84)
                       1004                                  ; INTERNAL FORMAT:
                       1005                                  ;              LINES 24-1
                       1006                                  ;              COL. (86)81-2
                       1007                                  ;              (COL.1 END OF LINE)
                       1008  ;
                       1009  ;
04FC'  3A 0033'        1010  CONVFM  LD      A,(LINLEN)
04FF'  3C              1011          INC     A
0500'  91              1012          SUB     C
0501'  4F              1013          LD      C,A             ; CONVERT
0502'  3E 18           1014          LD      A,SCRSZ
0504'  90              1015          SUB     B
0505'  47              1016          LD      B,A
0506'  C9              1017          RET
                       1018  ;
                       1019  ;
                       1020  ;
0507'                  1021  UPDPOSN:                        ; ENTER HERE WITH BC=LINE/COL.IN
                       1022                                  ; INTERNAL FORMAT
0507'  CD 050C'        1023          CALL    CALCPOS         ; CALCULATE POSITION
```

> *Transcriber's note:* On lines 977–984 (the `ENBLHOME` routine) the opcodes are printed at about source column 10 and the operands at column 16, two columns right of the rest of the page, because `ENBLHOME` is 8 characters long; they are re-spaced to the standard columns 8 and 16 (the opcode on line 977 follows the label after one space). The comment-only lines 986–988, 1000–1007 and 1022 are printed at source column 32 and kept there. The continuation lines 1003 and 1005–1007 are indented to about column 47, under `LINES` on line 1002; this spacing is measured from the scan and is approximate. The bottom of the scan shows the header of the next sheet.

<!-- PDF page 42 — listing "Page 13-2" — INTERNAL SUB-RTNS. — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
050A'  18 44           1024          JR      STPOSN          ; STORE UPDATED POSITION AND RETURN
                       1025  ;
                       1026  ;                               ; ROUTINE TO CALCULATE POSITION IN DF
                       1027  ;                               ; UPDATES BIT POSITION IN VARIABLE DFBIT
                       1028  ;                               ; RETURNS DF ADDRESS IN HL.  PRESERVES
                       1029  ;                               ; LINE/COL.POSITION IN BC
                       1030  ;
050C'  CD 053F'        1031  CALCPOS CALL    LNBU            ; GET DISPLAY FILE ADRS.FOR LINE
050F'  3A 0033'        1032          LD      A,(LINLEN)      ; TEST WHICH DF
0512'  3C              1033          INC     A
0513'  91              1034          SUB     C
0514'  F5              1035          PUSH    AF              ; SAVE COL.NO.(0-(LINLEN-1))
0515'  5F              1036          LD      E,A
0516'  87              1037          ADD     A,A
0517'  83              1038          ADD     A,E             ; 3*<80-COL.POS.> / 4 = 64-COL.POS.
0518'  CB 3F           1039          SRL     A
051A'  CB 3F           1040          SRL     A
051C'  CB 47           1041          BIT     0,A
051E'  28 06           1042          JR      Z,CALCP1
0520'  F5              1043          PUSH    AF              ; ODD COLS.ARE IN DF2
0521'  3E 20           1044          LD      A,20H
0523'  B4              1045          OR      H               ; IN DF2
0524'  67              1046          LD      H,A
0525'  F1              1047          POP     AF
0526'  A7              1048  CALCP1  AND     A               ; CLEAR CARRY
0527'  1F              1049          RRA                     ; COL/2 IS POSITION IN DISPLAY FILE
0528'  5F              1050          LD      E,A
0529'  3A 003D'        1051          LD      A,(MARGIN)      ; GET ADJUSTMENT VALUE
052C'  83              1052          ADD     A,E
052D'  5F              1053          LD      E,A
052E'  16 00           1054          LD      D,0             ; DE CONTAINS OFFSET INTO LINE
0530'  19              1055          ADD     HL,DE           ; HL CONTAINS DF ADDRESS
0531'  1E 07           1056          LD      E,7
0533'  F1              1057          POP     AF              ; A=COL.POSN.FOR 80 COLS.
0534'  E6 03           1058          AND     3               ;
0536'  28 02           1059          JR      Z,CALCP2        ; STARTS AT BIT 7
0538'  5F              1060          LD      E,A             ; STARTS AT BIT 1,3 OR 5
0539'  3D              1061          DEC     A
053A'  83              1062  CALCP2  ADD     A,E
053B'  32 003E'        1063          LD      (DFBIT),A
053E'  C9              1064          RET                     ; BC=POS. HL=DF ADDRESS
                       1065  ;
                       1066  ;
053F'                  1067  LNBU:                           ; GET DISPLAY FILE ADDRESS
                       1068                                  ; FOR START OF LINE IN B
053F'  3E 18           1069          LD      A,SCRSZ
0541'  90              1070          SUB     B
0542'  57              1071          LD      D,A
0543'  0F              1072          RRCA
0544'  0F              1073          RRCA
0545'  0F              1074          RRCA
0546'  E6 E0           1075          AND     0E0H
```

> *Transcriber's note:* On this page most operands are printed at source column 15 and are re-spaced to column 16. Lines 1069–1071 are printed with the operand one space after the mnemonic (`LD A,SCRSZ`, `SUB B`, `LD D,A`); they are re-spaced too. Line 1028 has two spaces after `HL.`, as printed. The listing ends at line 1075, about four-fifths of the way down. The bottom of the scan shows the header of the next sheet.

<!-- PDF page 43 — listing "Page 13-3" — INTERNAL SUB-RTNS. — IO80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0548'  6F              1076          LD      L,A
0549'  7A              1077          LD      A,D
054A'  E6 18           1078          AND     18H
054C'  F6 40           1079          OR      40H
054E'  67              1080          LD      H,A
054F'  C9              1081          RET
                       1082
0550'                  1083  STPOSN:                         ; STORE CURSOR POSITION
0550'  ED 43 0034'     1084          LD      (CURPOS),BC
0554'  22 0036'        1085          LD      (DFADRS),HL
0557'  C9              1086          RET
                       1087  ;
0558'                  1088  LDPOSN:                         ; LOAD CURSOR POSITION
0558'  ED 4B 0034'     1089          LD      BC,(CURPOS)
055C'  2A 0036'        1090          LD      HL,(DFADRS)
055F'  C9              1091          RET
                       1092  ;
                       1093  ;
                       1094  ;                               ; RTN. USED BY GTCHAR TO PUT
                       1095  ;                               ; 6 PIXELS FROM DF IN B REG.BITS 7-2
                       1096  ;                               ; FOR MATCHING AGAINST CHAR.SET
                       1097  ;
0560'  E5              1098  GTC2BC  PUSH    HL              ; SAVE DF ADRS.
0561'  46              1099          LD      B,(HL)          ; SCAN LINE FROM DF
0562'  7C              1100          LD      A,H
0563'  EE 20           1101          XOR     20H
0565'  67              1102          LD      H,A             ; TOGGLE TO ALTERNATE DF
0566'  CB 6F           1103          BIT     5,A             ; TEST WHICH DF
0568'  20 01           1104          JR      NZ,GTC2B1
056A'  23              1105          INC     HL
056B'  4E              1106  GTC2B1  LD      C,(HL)          ; BC CONTAINS CHAR.AT DFBIT
056C'  3A 003E'        1107          LD      A,(DFBIT)
056F'  D6 07           1108          SUB     7
0571'  ED 44           1109          NEG                     ; A=NO.OF BITS OFFSET IN BC
0573'  28 07           1110          JR      Z,GTC2B2        ; STARTS AT BIT 7
0575'  CB 11           1111  GTCSHFT RL      C
0577'  CB 10           1112          RL      B               ; SHIFT 6 PIXELS FOR CHARACTER
0579'  3D              1113          DEC     A               ; TO B, BITS 7-2
057A'  20 F9           1114          JR      NZ,GTCSHFT
057C'  E1              1115  GTC2B2  POP     HL              ;
057D'  C9              1116          RET                     ; CHAR.IN B, BITS 7-2
                       1117  ;
                       1118
                       1119          INCLUDE CHST80
                       1120          SUBTTL  CHAR.SET FOR 40/80 COL.MODES
                       1121
                       1122  ;
                       1123  ; Dot patterns for characters on the TV screen:
                       1124  ;       character with code x is at offsets 8x (top line) to 8x+7 (bottom line)
                       1125  ;       0 = white, 1 = black, no margins between character spaces either
                       1126  ;              vertically or horizontally
                       1127
```

> *Transcriber's note:* This page is the end of IO80.SRC and the start of the included file. Line 1119 `INCLUDE CHST80` pulls in the character set, and line 1120 sets the subtitle that the next pages carry (CHAR.SET FOR 40/80 COL.MODES, source file CHST80.SRC). Lines 1123–1126 are printed in lower case, as shown, and the indentation of 1124–1126 was measured from the scan (approximate). Lines 1082, 1118, 1121 and 1127 are blank. The listing ends at line 1127, about four-fifths of the way down. A dark fold band crosses the lower part of the scan, and the next sheet's header shows at the bottom.

<!-- PDF page 44 — listing "Page 13-4" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
057E'  00              1128  CHRST   defb    00000000b       ; code 20       space
057F'  00              1129          defb    00000000b
0580'  00              1130          defb    00000000b
0581'  00              1131          defb    00000000b
0582'  00              1132          defb    00000000b
0583'  00              1133          defb    00000000b
0584'  00              1134          defb    00000000b
0585'  00              1135          defb    00000000b
                       1136
0586'  00              1137          defb    00000000b       ; code 21       !
0587'  10              1138          defb    00010000b
0588'  10              1139          defb    00010000b
0589'  10              1140          defb    00010000b
058A'  10              1141          defb    00010000b
058B'  00              1142          defb    00000000b
058C'  10              1143          defb    00010000b
058D'  00              1144          defb    00000000b
                       1145
058E'  00              1146          defb    00000000b       ; code 22       "
058F'  48              1147          defb    01001000b
0590'  48              1148          defb    01001000b
0591'  00              1149          defb    00000000b
0592'  00              1150          defb    00000000b
0593'  00              1151          defb    00000000b
0594'  00              1152          defb    00000000b
0595'  00              1153          defb    00000000b
                       1154
0596'  00              1155          defb    00000000b       ; code 23       #
0597'  28              1156          defb    00101000b
0598'  7C              1157          defb    01111100b
0599'  28              1158          defb    00101000b
059A'  28              1159          defb    00101000b
059B'  7C              1160          defb    01111100b
059C'  28              1161          defb    00101000b
059D'  00              1162          defb    00000000b
                       1163
059E'  00              1164          defb    00000000b       ; code 24       $
059F'  10              1165          defb    00010000b
05A0'  7C              1166          defb    01111100b
05A1'  50              1167          defb    01010000b
05A2'  7C              1168          defb    01111100b
05A3'  14              1169          defb    00010100b
05A4'  7C              1170          defb    01111100b
05A5'  10              1171          defb    00010000b
                       1172
05A6'  00              1173          defb    00000000b       ; code 25       %
05A7'  64              1174          defb    01100100b
05A8'  68              1175          defb    01101000b
05A9'  10              1176          defb    00010000b
05AA'  10              1177          defb    00010000b
05AB'  2C              1178          defb    00101100b
05AC'  4C              1179          defb    01001100b
```

> *Transcriber's note:* This is the first character-set data page (CHST80.SRC). It covers codes 20–25 and the first seven bytes of code 25; the eighth (line 1180) is on the next page. The table label is `CHRST` (line 1128). In the printout each `defb` operand follows one space after the mnemonic (`defb 00000000b`); it is re-spaced to column 16. The `; code NN` comment is at source column 32, as printed, and the character it draws is at column 48. Every object byte agrees with its binary operand, and the LOC chain is unbroken (057E'–05AC'). The blank lines between characters (1136, 1145, 1154, 1163, 1172) are printed as line numbers with no source. The data agrees with the code on PDF page 38: `CHRSET` = 047E' = `CHRST` − 100H (code 20H × 8 = 100H).

<!-- PDF page 45 — listing "Page 13-5" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
05AD'  00              1180          defb    00000000b
                       1181
05AE'  00              1182          defb    00000000b       ; code 26       &
05AF'  10              1183          defb    00010000b
05B0'  28              1184          defb    00101000b
05B1'  10              1185          defb    00010000b
05B2'  2C              1186          defb    00101100b
05B3'  48              1187          defb    01001000b
05B4'  34              1188          defb    00110100b
05B5'  00              1189          defb    00000000b
                       1190
05B6'  00              1191          defb    00000000b       ; code 27       '
05B7'  10              1192          defb    00010000b
05B8'  20              1193          defb    00100000b
05B9'  00              1194          defb    00000000b
05BA'  00              1195          defb    00000000b
05BB'  00              1196          defb    00000000b
05BC'  00              1197          defb    00000000b
05BD'  00              1198          defb    00000000b
                       1199
05BE'  00              1200          defb    00000000b       ; code 28       (
05BF'  08              1201          defb    00001000b
05C0'  10              1202          defb    00010000b
05C1'  10              1203          defb    00010000b
05C2'  10              1204          defb    00010000b
05C3'  10              1205          defb    00010000b
05C4'  08              1206          defb    00001000b
05C5'  00              1207          defb    00000000b
                       1208
05C6'  00              1209          defb    00000000b       ; code 29       )
05C7'  20              1210          defb    00100000b
05C8'  10              1211          defb    00010000b
05C9'  10              1212          defb    00010000b
05CA'  10              1213          defb    00010000b
05CB'  10              1214          defb    00010000b
05CC'  20              1215          defb    00100000b
05CD'  00              1216          defb    00000000b
                       1217
05CE'  00              1218          defb    00000000b       ; code 2A       *
05CF'  00              1219          defb    00000000b
05D0'  28              1220          defb    00101000b
05D1'  10              1221          defb    00010000b
05D2'  7C              1222          defb    01111100b
05D3'  10              1223          defb    00010000b
05D4'  28              1224          defb    00101000b
05D5'  00              1225          defb    00000000b
                       1226
05D6'  00              1227          defb    00000000b       ; code 2B       +
05D7'  00              1228          defb    00000000b
05D8'  10              1229          defb    00010000b
05D9'  10              1230          defb    00010000b
05DA'  7C              1231          defb    01111100b
```

> *Uncertain:* line 1191 (code 27) glyph is read as an apostrophe `'`; the printed mark is a short slanted tick, the same shape as the relocation mark in the LOC column.

> *Transcriber's note:* This page continues the character set: the last byte of code 25 (line 1180), then codes 26–2B. The listing ends at line 1231 partway through code 2B, so its last three bytes are on the next page. The `&` for code 26 is printed in the font's open-`&`/epsilon-like shape. Every object byte agrees with its binary operand, and the LOC chain is unbroken (05AD'–05DA'). The layout is re-spaced as on page 13-4.

<!-- PDF page 46 — listing "Page 13-6" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
05DB'  10              1232          defb    00010000b
05DC'  10              1233          defb    00010000b
05DD'  00              1234          defb    00000000b
                       1235
05DE'  00              1236          defb    00000000b       ; code 2C       ,
05DF'  00              1237          defb    00000000b
05E0'  00              1238          defb    00000000b
05E1'  00              1239          defb    00000000b
05E2'  00              1240          defb    00000000b
05E3'  10              1241          defb    00010000b
05E4'  10              1242          defb    00010000b
05E5'  20              1243          defb    00100000b
                       1244
05E6'  00              1245          defb    00000000b       ; code 2D       -
05E7'  00              1246          defb    00000000b
05E8'  00              1247          defb    00000000b
05E9'  00              1248          defb    00000000b
05EA'  7C              1249          defb    01111100b
05EB'  00              1250          defb    00000000b
05EC'  00              1251          defb    00000000b
05ED'  00              1252          defb    00000000b
                       1253
05EE'  00              1254          defb    00000000b       ; code 2E       .
05EF'  00              1255          defb    00000000b
05F0'  00              1256          defb    00000000b
05F1'  00              1257          defb    00000000b
05F2'  00              1258          defb    00000000b
05F3'  30              1259          defb    00110000b
05F4'  30              1260          defb    00110000b
05F5'  00              1261          defb    00000000b
                       1262
05F6'  00              1263          defb    00000000b       ; code 2F       /
05F7'  00              1264          defb    00000000b
05F8'  04              1265          defb    00000100b
05F9'  08              1266          defb    00001000b
05FA'  10              1267          defb    00010000b
05FB'  20              1268          defb    00100000b
05FC'  40              1269          defb    01000000b
05FD'  00              1270          defb    00000000b
                       1271
05FE'  00              1272          defb    00000000b       ; code 30       0
05FF'  38              1273          defb    00111000b
0600'  4C              1274          defb    01001100b
0601'  54              1275          defb    01010100b
0602'  54              1276          defb    01010100b
0603'  64              1277          defb    01100100b
0604'  38              1278          defb    00111000b
0605'  00              1279          defb    00000000b
                       1280
0606'  00              1281          defb    00000000b       ; code 31       1
0607'  30              1282          defb    00110000b
0608'  50              1283          defb    01010000b
```

> *Transcriber's note:* The listing on these pages is printed in lower case (`defb`, `b` suffix, `; code`), and that case is kept. On the printed page `defb` and its operand are separated by a single space; here they are re-spaced to source columns 8 and 16. The comment starts at source column 32. Inside the comment, the character glyph is printed 16 columns after the `;`, and that spacing is kept. Lines 1232–1234 are the last three rows of the code 2B character (`+`), which starts on the previous page. The foot of the scan shows the header of listing page 13-7 (continuous-form overlap). It is not transcribed here, because the next PDF page carries it in full.

<!-- PDF page 47 — listing "Page 13-7" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0609'  10              1284          defb    00010000b
060A'  10              1285          defb    00010000b
060B'  10              1286          defb    00010000b
060C'  7C              1287          defb    01111100b
060D'  00              1288          defb    00000000b
                       1289
060E'  00              1290          defb    00000000b       ; code 32       2
060F'  38              1291          defb    00111000b
0610'  44              1292          defb    01000100b
0611'  04              1293          defb    00000100b
0612'  38              1294          defb    00111000b
0613'  40              1295          defb    01000000b
0614'  7C              1296          defb    01111100b
0615'  00              1297          defb    00000000b
                       1298
0616'  00              1299          defb    00000000b       ; code 33       3
0617'  38              1300          defb    00111000b
0618'  44              1301          defb    01000100b
0619'  18              1302          defb    00011000b
061A'  04              1303          defb    00000100b
061B'  44              1304          defb    01000100b
061C'  38              1305          defb    00111000b
061D'  00              1306          defb    00000000b
                       1307
061E'  00              1308          defb    00000000b       ; code 34       4
061F'  08              1309          defb    00001000b
0620'  18              1310          defb    00011000b
0621'  28              1311          defb    00101000b
0622'  48              1312          defb    01001000b
0623'  7C              1313          defb    01111100b
0624'  08              1314          defb    00001000b
0625'  00              1315          defb    00000000b
                       1316
0626'  00              1317          defb    00000000b       ; code 35       5
0627'  7C              1318          defb    01111100b
0628'  40              1319          defb    01000000b
0629'  78              1320          defb    01111000b
062A'  04              1321          defb    00000100b
062B'  44              1322          defb    01000100b
062C'  38              1323          defb    00111000b
062D'  00              1324          defb    00000000b
                       1325
062E'  00              1326          defb    00000000b       ; code 36       6
062F'  38              1327          defb    00111000b
0630'  40              1328          defb    01000000b
0631'  78              1329          defb    01111000b
0632'  44              1330          defb    01000100b
0633'  44              1331          defb    01000100b
0634'  38              1332          defb    00111000b
0635'  00              1333          defb    00000000b
                       1334
0636'  00              1335          defb    00000000b       ; code 37       7
```

<!-- PDF page 48 — listing "Page 13-8" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0637'  7C              1336          defb    01111100b
0638'  04              1337          defb    00000100b
0639'  08              1338          defb    00001000b
063A'  10              1339          defb    00010000b
063B'  20              1340          defb    00100000b
063C'  20              1341          defb    00100000b
063D'  00              1342          defb    00000000b
                       1343
063E'  00              1344          defb    00000000b       ; code 38       8
063F'  38              1345          defb    00111000b
0640'  44              1346          defb    01000100b
0641'  38              1347          defb    00111000b
0642'  44              1348          defb    01000100b
0643'  44              1349          defb    01000100b
0644'  38              1350          defb    00111000b
0645'  00              1351          defb    00000000b
                       1352
0646'  00              1353          defb    00000000b       ; code 39       9
0647'  38              1354          defb    00111000b
0648'  44              1355          defb    01000100b
0649'  44              1356          defb    01000100b
064A'  3C              1357          defb    00111100b
064B'  04              1358          defb    00000100b
064C'  38              1359          defb    00111000b
064D'  00              1360          defb    00000000b
                       1361
064E'  00              1362          defb    00000000b       ; code 3A       :
064F'  00              1363          defb    00000000b
0650'  00              1364          defb    00000000b
0651'  10              1365          defb    00010000b
0652'  00              1366          defb    00000000b
0653'  00              1367          defb    00000000b
0654'  10              1368          defb    00010000b
0655'  00              1369          defb    00000000b
                       1370
0656'  00              1371          defb    00000000b       ; code 3B       ;
0657'  00              1372          defb    00000000b
0658'  10              1373          defb    00010000b
0659'  00              1374          defb    00000000b
065A'  00              1375          defb    00000000b
065B'  10              1376          defb    00010000b
065C'  10              1377          defb    00010000b
065D'  20              1378          defb    00100000b
                       1379
065E'  00              1380          defb    00000000b       ; code 3C       <
065F'  00              1381          defb    00000000b
0660'  08              1382          defb    00001000b
0661'  10              1383          defb    00010000b
0662'  20              1384          defb    00100000b
0663'  10              1385          defb    00010000b
0664'  08              1386          defb    00001000b
0665'  00              1387          defb    00000000b
```

<!-- PDF page 49 — listing "Page 13-9" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       1388
0666'  00              1389          defb    00000000b       ; code 3D       =
0667'  00              1390          defb    00000000b
0668'  00              1391          defb    00000000b
0669'  7C              1392          defb    01111100b
066A'  00              1393          defb    00000000b
066B'  7C              1394          defb    01111100b
066C'  00              1395          defb    00000000b
066D'  00              1396          defb    00000000b
                       1397
066E'  00              1398          defb    00000000b       ; code 3E       >
066F'  00              1399          defb    00000000b
0670'  20              1400          defb    00100000b
0671'  10              1401          defb    00010000b
0672'  08              1402          defb    00001000b
0673'  10              1403          defb    00010000b
0674'  20              1404          defb    00100000b
0675'  00              1405          defb    00000000b
                       1406
0676'  00              1407          defb    00000000b       ; code 3F       ?
0677'  38              1408          defb    00111000b
0678'  44              1409          defb    01000100b
0679'  08              1410          defb    00001000b
067A'  10              1411          defb    00010000b
067B'  00              1412          defb    00000000b
067C'  10              1413          defb    00010000b
067D'  00              1414          defb    00000000b
                       1415
067E'  00              1416          defb    00000000b       ; code 40       @
067F'  38              1417          defb    00111000b
0680'  44              1418          defb    01000100b
0681'  5C              1419          defb    01011100b
0682'  5C              1420          defb    01011100b
0683'  40              1421          defb    01000000b
0684'  3C              1422          defb    00111100b
0685'  00              1423          defb    00000000b
                       1424
0686'  00              1425          defb    00000000b       ; code 41       A
0687'  38              1426          defb    00111000b
0688'  44              1427          defb    01000100b
0689'  44              1428          defb    01000100b
068A'  7C              1429          defb    01111100b
068B'  44              1430          defb    01000100b
068C'  44              1431          defb    01000100b
068D'  00              1432          defb    00000000b
                       1433
068E'  00              1434          defb    00000000b       ; code 42       B
068F'  78              1435          defb    01111000b
0690'  44              1436          defb    01000100b
0691'  78              1437          defb    01111000b
0692'  44              1438          defb    01000100b
0693'  44              1439          defb    01000100b
```

> *Transcriber's note:* The glyph for code 40 is printed in the printer's `@` form (a small `a` inside a ring). It is transcribed as `@`.

<!-- PDF page 50 — listing "Page 13-10" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0694'  78              1440          defb    01111000b
0695'  00              1441          defb    00000000b
                       1442
0696'  00              1443          defb    00000000b       ; code 43       C
0697'  38              1444          defb    00111000b
0698'  44              1445          defb    01000100b
0699'  40              1446          defb    01000000b
069A'  40              1447          defb    01000000b
069B'  44              1448          defb    01000100b
069C'  38              1449          defb    00111000b
069D'  00              1450          defb    00000000b
                       1451
069E'  00              1452          defb    00000000b       ; code 44       D
069F'  70              1453          defb    01110000b
06A0'  48              1454          defb    01001000b
06A1'  44              1455          defb    01000100b
06A2'  44              1456          defb    01000100b
06A3'  48              1457          defb    01001000b
06A4'  70              1458          defb    01110000b
06A5'  00              1459          defb    00000000b
                       1460
06A6'  00              1461          defb    00000000b       ; code 45       E
06A7'  7C              1462          defb    01111100b
06A8'  40              1463          defb    01000000b
06A9'  78              1464          defb    01111000b
06AA'  40              1465          defb    01000000b
06AB'  40              1466          defb    01000000b
06AC'  7C              1467          defb    01111100b
06AD'  00              1468          defb    00000000b
                       1469
06AE'  00              1470          defb    00000000b       ; code 46       F
06AF'  7C              1471          defb    01111100b
06B0'  40              1472          defb    01000000b
06B1'  78              1473          defb    01111000b
06B2'  40              1474          defb    01000000b
06B3'  40              1475          defb    01000000b
06B4'  40              1476          defb    01000000b
06B5'  00              1477          defb    00000000b
                       1478
06B6'  00              1479          defb    00000000b       ; code 47       G
06B7'  38              1480          defb    00111000b
06B8'  44              1481          defb    01000100b
06B9'  40              1482          defb    01000000b
06BA'  5C              1483          defb    01011100b
06BB'  44              1484          defb    01000100b
06BC'  38              1485          defb    00111000b
06BD'  00              1486          defb    00000000b
                       1487
06BE'  00              1488          defb    00000000b       ; code 48       H
06BF'  44              1489          defb    01000100b
06C0'  44              1490          defb    01000100b
06C1'  7C              1491          defb    01111100b
```

<!-- PDF page 51 — listing "Page 13-11" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
06C2'  44              1492          defb    01000100b
06C3'  44              1493          defb    01000100b
06C4'  44              1494          defb    01000100b
06C5'  00              1495          defb    00000000b
                       1496
06C6'  00              1497          defb    00000000b       ; code 49       I
06C7'  7C              1498          defb    01111100b
06C8'  10              1499          defb    00010000b
06C9'  10              1500          defb    00010000b
06CA'  10              1501          defb    00010000b
06CB'  10              1502          defb    00010000b
06CC'  7C              1503          defb    01111100b
06CD'  00              1504          defb    00000000b
                       1505
06CE'  00              1506          defb    00000000b       ; code 4A       J
06CF'  04              1507          defb    00000100b
06D0'  04              1508          defb    00000100b
06D1'  04              1509          defb    00000100b
06D2'  44              1510          defb    01000100b
06D3'  44              1511          defb    01000100b
06D4'  3C              1512          defb    00111100b
06D5'  00              1513          defb    00000000b
                       1514
06D6'  00              1515          defb    00000000b       ; code 4B       K
06D7'  48              1516          defb    01001000b
06D8'  50              1517          defb    01010000b
06D9'  60              1518          defb    01100000b
06DA'  50              1519          defb    01010000b
06DB'  48              1520          defb    01001000b
06DC'  44              1521          defb    01000100b
06DD'  00              1522          defb    00000000b
                       1523
06DE'  00              1524          defb    00000000b       ; code 4C       L
06DF'  40              1525          defb    01000000b
06E0'  40              1526          defb    01000000b
06E1'  40              1527          defb    01000000b
06E2'  40              1528          defb    01000000b
06E3'  40              1529          defb    01000000b
06E4'  7C              1530          defb    01111100b
06E5'  00              1531          defb    00000000b
                       1532
06E6'  00              1533          defb    00000000b       ; code 4D       M
06E7'  44              1534          defb    01000100b
06E8'  6C              1535          defb    01101100b
06E9'  54              1536          defb    01010100b
06EA'  44              1537          defb    01000100b
06EB'  44              1538          defb    01000100b
06EC'  44              1539          defb    01000100b
06ED'  00              1540          defb    00000000b
                       1541
06EE'  00              1542          defb    00000000b       ; code 4E       N
06EF'  44              1543          defb    01000100b
```

<!-- PDF page 52 — listing "Page 13-12" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
06F0'  64              1544          defb    01100100b
06F1'  54              1545          defb    01010100b
06F2'  54              1546          defb    01010100b
06F3'  4C              1547          defb    01001100b
06F4'  44              1548          defb    01000100b
06F5'  00              1549          defb    00000000b
                       1550
06F6'  00              1551          defb    00000000b       ; code 4F       O
06F7'  38              1552          defb    00111000b
06F8'  44              1553          defb    01000100b
06F9'  44              1554          defb    01000100b
06FA'  44              1555          defb    01000100b
06FB'  44              1556          defb    01000100b
06FC'  38              1557          defb    00111000b
06FD'  00              1558          defb    00000000b
                       1559
06FE'  00              1560          defb    00000000b       ; code 50       P
06FF'  78              1561          defb    01111000b
0700'  44              1562          defb    01000100b
0701'  44              1563          defb    01000100b
0702'  78              1564          defb    01111000b
0703'  40              1565          defb    01000000b
0704'  40              1566          defb    01000000b
0705'  00              1567          defb    00000000b
                       1568
0706'  00              1569          defb    00000000b       ; code 51       Q
0707'  38              1570          defb    00111000b
0708'  44              1571          defb    01000100b
0709'  44              1572          defb    01000100b
070A'  44              1573          defb    01000100b
070B'  54              1574          defb    01010100b
070C'  38              1575          defb    00111000b
070D'  00              1576          defb    00000000b
                       1577
070E'  00              1578          defb    00000000b       ; code 52       R
070F'  78              1579          defb    01111000b
0710'  44              1580          defb    01000100b
0711'  44              1581          defb    01000100b
0712'  78              1582          defb    01111000b
0713'  48              1583          defb    01001000b
0714'  44              1584          defb    01000100b
0715'  00              1585          defb    00000000b
                       1586
0716'  00              1587          defb    00000000b       ; code 53       S
0717'  38              1588          defb    00111000b
0718'  40              1589          defb    01000000b
0719'  38              1590          defb    00111000b
071A'  04              1591          defb    00000100b
071B'  44              1592          defb    01000100b
071C'  38              1593          defb    00111000b
071D'  00              1594          defb    00000000b
                       1595
```

> *Transcriber's note:* Line 1560 has a speck of noise on the first digit of the operand, so it looks a little like `Q`. It reads `00000000b`, which agrees with object byte `00`.

<!-- PDF page 53 — listing "Page 13-13" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
071E'  00              1596          defb    00000000b       ; code 54       T
071F'  7C              1597          defb    01111100b
0720'  10              1598          defb    00010000b
0721'  10              1599          defb    00010000b
0722'  10              1600          defb    00010000b
0723'  10              1601          defb    00010000b
0724'  10              1602          defb    00010000b
0725'  00              1603          defb    00000000b
                       1604
0726'  00              1605          defb    00000000b       ; code 55       U
0727'  44              1606          defb    01000100b
0728'  44              1607          defb    01000100b
0729'  44              1608          defb    01000100b
072A'  44              1609          defb    01000100b
072B'  44              1610          defb    01000100b
072C'  38              1611          defb    00111000b
072D'  00              1612          defb    00000000b
                       1613
072E'  00              1614          defb    00000000b       ; code 56       V
072F'  44              1615          defb    01000100b
0730'  44              1616          defb    01000100b
0731'  44              1617          defb    01000100b
0732'  44              1618          defb    01000100b
0733'  28              1619          defb    00101000b
0734'  10              1620          defb    00010000b
0735'  00              1621          defb    00000000b
                       1622
0736'  00              1623          defb    00000000b       ; code 57       W
0737'  44              1624          defb    01000100b
0738'  44              1625          defb    01000100b
0739'  44              1626          defb    01000100b
073A'  54              1627          defb    01010100b
073B'  54              1628          defb    01010100b
073C'  28              1629          defb    00101000b
073D'  00              1630          defb    00000000b
                       1631
073E'  00              1632          defb    00000000b       ; code 58       X
073F'  44              1633          defb    01000100b
0740'  28              1634          defb    00101000b
0741'  10              1635          defb    00010000b
0742'  10              1636          defb    00010000b
0743'  28              1637          defb    00101000b
0744'  44              1638          defb    01000100b
0745'  00              1639          defb    00000000b
                       1640
0746'  00              1641          defb    00000000b       ; code 59       Y
0747'  44              1642          defb    01000100b
0748'  44              1643          defb    01000100b
0749'  28              1644          defb    00101000b
074A'  10              1645          defb    00010000b
074B'  10              1646          defb    00010000b
074C'  10              1647          defb    00010000b
```

<!-- PDF page 54 — listing "Page 13-14" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
074D'  00              1648          defb    00000000b
                       1649
074E'  00              1650          defb    00000000b       ; code 5A       Z
074F'  7C              1651          defb    01111100b
0750'  04              1652          defb    00000100b
0751'  08              1653          defb    00001000b
0752'  10              1654          defb    00010000b
0753'  20              1655          defb    00100000b
0754'  7C              1656          defb    01111100b
0755'  00              1657          defb    00000000b
                       1658
0756'  00              1659          defb    00000000b       ; code 5B       [
0757'  38              1660          defb    00111000b
0758'  20              1661          defb    00100000b
0759'  20              1662          defb    00100000b
075A'  20              1663          defb    00100000b
075B'  20              1664          defb    00100000b
075C'  38              1665          defb    00111000b
075D'  00              1666          defb    00000000b
                       1667
075E'  00              1668          defb    00000000b       ; code 5C       \
075F'  00              1669          defb    00000000b
0760'  40              1670          defb    01000000b
0761'  20              1671          defb    00100000b
0762'  10              1672          defb    00010000b
0763'  08              1673          defb    00001000b
0764'  04              1674          defb    00000100b
0765'  00              1675          defb    00000000b
                       1676
0766'  00              1677          defb    00000000b       ; code 5D       ]
0767'  70              1678          defb    01110000b
0768'  10              1679          defb    00010000b
0769'  10              1680          defb    00010000b
076A'  10              1681          defb    00010000b
076B'  10              1682          defb    00010000b
076C'  70              1683          defb    01110000b
076D'  00              1684          defb    00000000b
                       1685
076E'  00              1686          defb    00000000b       ; code 5E       ^
076F'  10              1687          defb    00010000b
0770'  38              1688          defb    00111000b
0771'  54              1689          defb    01010100b
0772'  10              1690          defb    00010000b
0773'  10              1691          defb    00010000b
0774'  10              1692          defb    00010000b
0775'  00              1693          defb    00000000b
                       1694
0776'  00              1695          defb    00000000b       ; code 5F       _
0777'  00              1696          defb    00000000b
0778'  00              1697          defb    00000000b
0779'  00              1698          defb    00000000b
077A'  00              1699          defb    00000000b
```

> *Transcriber's note:* For code 5E the printer shows `^`. The bitmap itself is an up-arrow (10 38 54 10 10 10). The glyph for code 5F is printed as a low `_`.

<!-- PDF page 55 — listing "Page 13-15" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
077B'  00              1700          defb    00000000b
077C'  00              1701          defb    00000000b
077D'  FC              1702          defb    11111100b
                       1703
077E'  00              1704          defb    00000000b       ; code 60       pound sign
077F'  18              1705          defb    00011000b
0780'  24              1706          defb    00100100b
0781'  70              1707          defb    01110000b
0782'  20              1708          defb    00100000b
0783'  20              1709          defb    00100000b
0784'  7C              1710          defb    01111100b
0785'  00              1711          defb    00000000b
                       1712
0786'  00              1713          defb    00000000b       ; code 61       a
0787'  00              1714          defb    00000000b
0788'  38              1715          defb    00111000b
0789'  04              1716          defb    00000100b
078A'  3C              1717          defb    00111100b
078B'  44              1718          defb    01000100b
078C'  3C              1719          defb    00111100b
078D'  00              1720          defb    00000000b
                       1721
078E'  00              1722          defb    00000000b       ; code 62       b
078F'  20              1723          defb    00100000b
0790'  20              1724          defb    00100000b
0791'  38              1725          defb    00111000b
0792'  24              1726          defb    00100100b
0793'  24              1727          defb    00100100b
0794'  38              1728          defb    00111000b
0795'  00              1729          defb    00000000b
                       1730
0796'  00              1731          defb    00000000b       ; code 63       c
0797'  00              1732          defb    00000000b
0798'  1C              1733          defb    00011100b
0799'  20              1734          defb    00100000b
079A'  20              1735          defb    00100000b
079B'  20              1736          defb    00100000b
079C'  1C              1737          defb    00011100b
079D'  00              1738          defb    00000000b
                       1739
079E'  00              1740          defb    00000000b       ; code 64       d
079F'  08              1741          defb    00001000b
07A0'  08              1742          defb    00001000b
07A1'  38              1743          defb    00111000b
07A2'  48              1744          defb    01001000b
07A3'  48              1745          defb    01001000b
07A4'  38              1746          defb    00111000b
07A5'  00              1747          defb    00000000b
                       1748
07A6'  00              1749          defb    00000000b       ; code 65       e
07A7'  00              1750          defb    00000000b
07A8'  38              1751          defb    00111000b
```

> *Transcriber's note:* The comment for code 60 reads `pound sign` in words, not as a glyph, and it starts in the same column as the glyphs. Lines 1749–1751 begin the code 65 character (`e`), which continues on listing page 13-16.

<!-- PDF page 56 — listing "Page 13-16" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
07A9'  44              1752          defb    01000100b
07AA'  78              1753          defb    01111000b
07AB'  40              1754          defb    01000000b
07AC'  3C              1755          defb    00111100b
07AD'  00              1756          defb    00000000b
                       1757
07AE'  00              1758          defb    00000000b       ; code 66       f
07AF'  10              1759          defb    00010000b
07B0'  28              1760          defb    00101000b
07B1'  70              1761          defb    01110000b
07B2'  20              1762          defb    00100000b
07B3'  20              1763          defb    00100000b
07B4'  20              1764          defb    00100000b
07B5'  00              1765          defb    00000000b
                       1766
07B6'  00              1767          defb    00000000b       ; code 67       g
07B7'  00              1768          defb    00000000b
07B8'  38              1769          defb    00111000b
07B9'  48              1770          defb    01001000b
07BA'  48              1771          defb    01001000b
07BB'  38              1772          defb    00111000b
07BC'  08              1773          defb    00001000b
07BD'  30              1774          defb    00110000b
                       1775
07BE'  00              1776          defb    00000000b       ; code 68       h
07BF'  40              1777          defb    01000000b
07C0'  40              1778          defb    01000000b
07C1'  70              1779          defb    01110000b
07C2'  48              1780          defb    01001000b
07C3'  48              1781          defb    01001000b
07C4'  48              1782          defb    01001000b
07C5'  00              1783          defb    00000000b
                       1784
07C6'  00              1785          defb    00000000b       ; code 69       i
07C7'  10              1786          defb    00010000b
07C8'  00              1787          defb    00000000b
07C9'  30              1788          defb    00110000b
07CA'  10              1789          defb    00010000b
07CB'  10              1790          defb    00010000b
07CC'  38              1791          defb    00111000b
07CD'  00              1792          defb    00000000b
                       1793
07CE'  00              1794          defb    00000000b       ; code 6A       j
07CF'  08              1795          defb    00001000b
07D0'  00              1796          defb    00000000b
07D1'  08              1797          defb    00001000b
07D2'  08              1798          defb    00001000b
07D3'  08              1799          defb    00001000b
07D4'  48              1800          defb    01001000b
07D5'  30              1801          defb    00110000b
                       1802
07D6'  00              1803          defb    00000000b       ; code 6B       k
```

> *Transcriber's note:* Every `defb` hex byte agrees with its binary operand. In the printout `defb` is followed by one space and then the operand. It is re-spaced here to put the operand at source col 16, and this applies to every listing page in this batch. The comment `;` is printed at source col 32 and the character at col 48, so 16 columns after the `;`. Lines 1757, 1766, 1775, 1784, 1793 and 1802 are blank, with no `;`. The page is continuous fanfold with tractor holes, and the next page's header shows at the bottom edge. It is not transcribed here.

<!-- PDF page 57 — listing "Page 13-17" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
07D7'  20              1804          defb    00100000b
07D8'  28              1805          defb    00101000b
07D9'  30              1806          defb    00110000b
07DA'  30              1807          defb    00110000b
07DB'  28              1808          defb    00101000b
07DC'  24              1809          defb    00100100b
07DD'  00              1810          defb    00000000b
                       1811
07DE'  00              1812          defb    00000000b       ; code 6C       l
07DF'  20              1813          defb    00100000b
07E0'  20              1814          defb    00100000b
07E1'  20              1815          defb    00100000b
07E2'  20              1816          defb    00100000b
07E3'  20              1817          defb    00100000b
07E4'  18              1818          defb    00011000b
07E5'  00              1819          defb    00000000b
                       1820
07E6'  00              1821          defb    00000000b       ; code 6D       m
07E7'  00              1822          defb    00000000b
07E8'  28              1823          defb    00101000b
07E9'  54              1824          defb    01010100b
07EA'  54              1825          defb    01010100b
07EB'  54              1826          defb    01010100b
07EC'  54              1827          defb    01010100b
07ED'  00              1828          defb    00000000b
                       1829
07EE'  00              1830          defb    00000000b       ; code 6E       n
07EF'  00              1831          defb    00000000b
07F0'  70              1832          defb    01110000b
07F1'  48              1833          defb    01001000b
07F2'  48              1834          defb    01001000b
07F3'  48              1835          defb    01001000b
07F4'  48              1836          defb    01001000b
07F5'  00              1837          defb    00000000b
                       1838
07F6'  00              1839          defb    00000000b       ; code 6F       o
07F7'  00              1840          defb    00000000b
07F8'  38              1841          defb    00111000b
07F9'  44              1842          defb    01000100b
07FA'  44              1843          defb    01000100b
07FB'  44              1844          defb    01000100b
07FC'  38              1845          defb    00111000b
07FD'  00              1846          defb    00000000b
                       1847
07FE'  00              1848          defb    00000000b       ; code 70        p
07FF'  00              1849          defb    00000000b
0800'  70              1850          defb    01110000b
0801'  48              1851          defb    01001000b
0802'  48              1852          defb    01001000b
0803'  70              1853          defb    01110000b
0804'  40              1854          defb    01000000b
0805'  40              1855          defb    01000000b
```

> *Transcriber's note:* Every `defb` hex byte agrees with its binary operand. Lines 1811, 1820, 1829, 1838 and 1847 are blank, with no `;`. On line 1848 (`code 70`), the `p` is printed one column further right than the other characters (col 49, not col 48), and that offset is kept here. Blank line 1856, which separates `p` from `q`, is printed at the top of the next page.

<!-- PDF page 58 — listing "Page 13-18" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       1856
0806'  00              1857          defb    00000000b       ; code 71        q
0807'  00              1858          defb    00000000b
0808'  38              1859          defb    00111000b
0809'  48              1860          defb    01001000b
080A'  48              1861          defb    01001000b
080B'  38              1862          defb    00111000b
080C'  08              1863          defb    00001000b
080D'  0C              1864          defb    00001100b
                       1865
080E'  00              1866          defb    00000000b       ; code 72        r
080F'  00              1867          defb    00000000b
0810'  18              1868          defb    00011000b
0811'  20              1869          defb    00100000b
0812'  20              1870          defb    00100000b
0813'  20              1871          defb    00100000b
0814'  20              1872          defb    00100000b
0815'  00              1873          defb    00000000b
                       1874
0816'  00              1875          defb    00000000b       ; code 73        s
0817'  00              1876          defb    00000000b
0818'  30              1877          defb    00110000b
0819'  40              1878          defb    01000000b
081A'  30              1879          defb    00110000b
081B'  08              1880          defb    00001000b
081C'  70              1881          defb    01110000b
081D'  00              1882          defb    00000000b
                       1883
081E'  00              1884          defb    00000000b       ; code 74        t
081F'  20              1885          defb    00100000b
0820'  70              1886          defb    01110000b
0821'  20              1887          defb    00100000b
0822'  20              1888          defb    00100000b
0823'  20              1889          defb    00100000b
0824'  18              1890          defb    00011000b
0825'  00              1891          defb    00000000b
                       1892
0826'  00              1893          defb    00000000b       ; code 75        u
0827'  00              1894          defb    00000000b
0828'  48              1895          defb    01001000b
0829'  48              1896          defb    01001000b
082A'  48              1897          defb    01001000b
082B'  48              1898          defb    01001000b
082C'  30              1899          defb    00110000b
082D'  00              1900          defb    00000000b
                       1901
082E'  00              1902          defb    00000000b       ; code 76       v
082F'  00              1903          defb    00000000b
0830'  44              1904          defb    01000100b
0831'  44              1905          defb    01000100b
0832'  28              1906          defb    00101000b
0833'  28              1907          defb    00101000b
```

> *Transcriber's note:* Every `defb` hex byte agrees with its binary operand. Line 1856 is blank, as are 1865, 1874, 1883, 1892 and 1901. For codes 71–75 (`q r s t u`), the character is printed one column further right, the same as `p` on the previous page. That offset is kept here. `v` (code 76) is back at the usual column.

<!-- PDF page 59 — listing "Page 13-19" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0834'  10              1908          defb    00010000b
0835'  00              1909          defb    00000000b
                       1910
0836'  00              1911          defb    00000000b       ; code 77       w
0837'  00              1912          defb    00000000b
0838'  44              1913          defb    01000100b
0839'  54              1914          defb    01010100b
083A'  54              1915          defb    01010100b
083B'  54              1916          defb    01010100b
083C'  28              1917          defb    00101000b
083D'  00              1918          defb    00000000b
                       1919
083E'  00              1920          defb    00000000b       ; code 78       x
083F'  00              1921          defb    00000000b
0840'  44              1922          defb    01000100b
0841'  28              1923          defb    00101000b
0842'  10              1924          defb    00010000b
0843'  28              1925          defb    00101000b
0844'  44              1926          defb    01000100b
0845'  00              1927          defb    00000000b
                       1928
0846'  00              1929          defb    00000000b       ; code 79       y
0847'  00              1930          defb    00000000b
0848'  48              1931          defb    01001000b
0849'  48              1932          defb    01001000b
084A'  48              1933          defb    01001000b
084B'  38              1934          defb    00111000b
084C'  08              1935          defb    00001000b
084D'  70              1936          defb    01110000b
                       1937
084E'  00              1938          defb    00000000b       ; code 7A       z
084F'  00              1939          defb    00000000b
0850'  7C              1940          defb    01111100b
0851'  08              1941          defb    00001000b
0852'  10              1942          defb    00010000b
0853'  20              1943          defb    00100000b
0854'  7C              1944          defb    01111100b
0855'  00              1945          defb    00000000b
                       1946
0856'  00              1947          defb    00000000b       ; code 7B       {
0857'  1C              1948          defb    00011100b
0858'  10              1949          defb    00010000b
0859'  60              1950          defb    01100000b
085A'  10              1951          defb    00010000b
085B'  10              1952          defb    00010000b
085C'  1C              1953          defb    00011100b
085D'  00              1954          defb    00000000b
                       1955
085E'  00              1956          defb    00000000b       ; code 7C       |
085F'  10              1957          defb    00010000b
0860'  10              1958          defb    00010000b
0861'  10              1959          defb    00010000b
```

> *Transcriber's note:* Every `defb` hex byte agrees with its binary operand. Lines 1910, 1919, 1928, 1937, 1946 and 1955 are blank, with no `;`. The comment characters for codes 7B and 7C are `{` and `|`.

<!-- PDF page 60 — listing "Page 13-20" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0862'  10              1960          defb    00010000b
0863'  10              1961          defb    00010000b
0864'  10              1962          defb    00010000b
0865'  00              1963          defb    00000000b
                       1964
0866'  00              1965          defb    00000000b       ; code 7D       }
0867'  70              1966          defb    01110000b
0868'  10              1967          defb    00010000b
0869'  08              1968          defb    00001000b
086A'  10              1969          defb    00010000b
086B'  10              1970          defb    00010000b
086C'  70              1971          defb    01110000b
086D'  00              1972          defb    00000000b
                       1973
086E'  00              1974          defb    00000000b       ; code 7E       ~
086F'  28              1975          defb    00101000b
0870'  50              1976          defb    01010000b
0871'  00              1977          defb    00000000b
0872'  00              1978          defb    00000000b
0873'  00              1979          defb    00000000b
0874'  00              1980          defb    00000000b
0875'  00              1981          defb    00000000b
                       1982
0876'  78              1983          defb    01111000b       ; code 7F       COPYRIGHT
0877'  84              1984          defb    10000100b
0878'  94              1985          defb    10010100b
0879'  A4              1986          defb    10100100b
087A'  A4              1987          defb    10100100b
087B'  94              1988          defb    10010100b
087C'  84              1989          defb    10000100b
087D'  78              1990          defb    01111000b
                       1991
087E'  00              1992  GRPST   defb    00000000b       ; code 80       graphics space
087F'  00              1993          defb    00000000b
0880'  00              1994          defb    00000000b
0881'  00              1995          defb    00000000b
0882'  00              1996          defb    00000000b
0883'  00              1997          defb    00000000b
0884'  00              1998          defb    00000000b
0885'  00              1999          defb    00000000b
                       2000  ;
0886'  1C              2001          defb    00011100b       ; code 81       graphics
0887'  1C              2002          defb    00011100b
0888'  1C              2003          defb    00011100b
0889'  1C              2004          defb    00011100b
088A'  00              2005          defb    00000000b
088B'  00              2006          defb    00000000b
088C'  00              2007          defb    00000000b
088D'  00              2008          defb    00000000b
                       2009  ;
                       2010
088E'  E0              2011          defb    11100000b       ; code 82       graphics
```

> *Transcriber's note:* Every `defb` hex byte agrees with its binary operand. Code 7F is the copyright symbol, with the comment `COPYRIGHT` and the bytes 78 84 94 A4 A4 94 84 78. Line 1992 carries the label `GRPST` at source col 0, which starts the graphics characters (`graphics space`, code 80). Lines 1964, 1973, 1982, 1991 and 2010 are blank. From line 2000 on, most separator lines are a lone `;` at source col 0, as here at 2000 and 2009. Line 2009 (`;`) is followed by blank line 2010.

<!-- PDF page 61 — listing "Page 13-21" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
088F'  E0              2012          defb    11100000b
0890'  E0              2013          defb    11100000b
0891'  E0              2014          defb    11100000b
0892'  00              2015          defb    00000000b
0893'  00              2016          defb    00000000b
0894'  00              2017          defb    00000000b
0895'  00              2018          defb    00000000b
                       2019
0896'  FC              2020          defb    11111100b       ; code 83       graphics
0897'  FC              2021          defb    11111100b
0898'  FC              2022          defb    11111100b
0899'  FC              2023          defb    11111100b
089A'  00              2024          defb    00000000b
089B'  00              2025          defb    00000000b
089C'  00              2026          defb    00000000b
089D'  00              2027          defb    00000000b
                       2028
                       2029  ;
089E'  00              2030          defb    00000000b       ; code 84       graphics
089F'  00              2031          defb    00000000b
08A0'  00              2032          defb    00000000b
08A1'  00              2033          defb    00000000b
08A2'  1C              2034          defb    00011100b
08A3'  1C              2035          defb    00011100b
08A4'  1C              2036          defb    00011100b
08A5'  1C              2037          defb    00011100b
                       2038  ;
08A6'  1C              2039          defb    00011100b       ; code 85       graphics
08A7'  1C              2040          defb    00011100b
08A8'  1C              2041          defb    00011100b
08A9'  1C              2042          defb    00011100b
08AA'  1C              2043          defb    00011100b
08AB'  1C              2044          defb    00011100b
08AC'  1C              2045          defb    00011100b
08AD'  1C              2046          defb    00011100b
                       2047
                       2048
08AE'  E0              2049          defb    11100000b       ; code 86        graphics
08AF'  E0              2050          defb    11100000b
08B0'  E0              2051          defb    11100000b
08B1'  E0              2052          defb    11100000b
08B2'  1C              2053          defb    00011100b
08B3'  1C              2054          defb    00011100b
08B4'  1C              2055          defb    00011100b
08B5'  1C              2056          defb    00011100b
                       2057  ;
08B6'  FC              2058          defb    11111100b       ;code 87        graphics
08B7'  FC              2059          defb    11111100b
08B8'  FC              2060          defb    11111100b
08B9'  FC              2061          defb    11111100b
08BA'  1C              2062          defb    00011100b
08BB'  1C              2063          defb    00011100b
```

> *Transcriber's note:* Every `defb` hex byte agrees with its binary operand. Lines 2019, 2028, 2047 and 2048 are blank, with no `;`. Lines 2029, 2038 and 2057 are `;`. Line 2049 (`code 86`) has a stray speck just under and after the `;` that looks like a comma, and it is not transcribed. On that line, `graphics` is printed one column further right (col 49), and the offset is kept. Line 2058 is printed `;code 87`, with no space.

<!-- PDF page 62 — listing "Page 13-22" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
08BC'  1C              2064          defb    00011100b
08BD'  1C              2065          defb    00011100b
                       2066  ;
08BE'  00              2067          defb    00000000b       ; code 88       graphics
08BF'  00              2068          defb    00000000b
08C0'  00              2069          defb    00000000b
08C1'  00              2070          defb    00000000b
08C2'  E0              2071          defb    11100000b
08C3'  E0              2072          defb    11100000b
08C4'  E0              2073          defb    11100000b
08C5'  E0              2074          defb    11100000b
                       2075  ;
08C6'  1C              2076          defb    00011100b       ; code 89        graphics
08C7'  1C              2077          defb    00011100b
08C8'  1C              2078          defb    00011100b
08C9'  1C              2079          defb    00011100b
08CA'  E0              2080          defb    11100000b
08CB'  E0              2081          defb    11100000b
08CC'  E0              2082          defb    11100000b
08CD'  E0              2083          defb    11100000b
                       2084  ;
08CE'  E0              2085          defb    11100000b       ; code 8A       graphics
08CF'  E0              2086          defb    11100000b
08D0'  E0              2087          defb    11100000b
08D1'  E0              2088          defb    11100000b
08D2'  E0              2089          defb    11100000b
08D3'  E0              2090          defb    11100000b
08D4'  E0              2091          defb    11100000b
08D5'  E0              2092          defb    11100000b
                       2093  ;
08D6'  FC              2094          defb    11111100b       ; code 8B       graphics
08D7'  FC              2095          defb    11111100b
08D8'  FC              2096          defb    11111100b
08D9'  FC              2097          defb    11111100b
08DA'  E0              2098          defb    11100000b
08DB'  E0              2099          defb    11100000b
08DC'  E0              2100          defb    11100000b
08DD'  E0              2101          defb    11100000b
                       2102  ;
08DE'  00              2103          defb    00000000b       ; code 8C       graphics
08DF'  00              2104          defb    00000000b
08E0'  00              2105          defb    00000000b
08E1'  00              2106          defb    00000000b
08E2'  FC              2107          defb    11111100b
08E3'  FC              2108          defb    11111100b
08E4'  FC              2109          defb    11111100b
08E5'  FC              2110          defb    11111100b
                       2111  ;
08E6'  1C              2112          defb    00011100b       ; code 8D       graphics
08E7'  1C              2113          defb    00011100b
08E8'  1C              2114          defb    00011100b
08E9'  1C              2115          defb    00011100b
```

> *Transcriber's note:* Every `defb` hex byte agrees with its binary operand. Every separator line on this page is `;` at source col 0: 2066, 2075, 2084, 2093, 2102 and 2111. On line 2076 (`code 89`), `graphics` is printed one column further right (col 49), the same as code 86, and the offset is kept.

<!-- PDF page 63 — listing "Page 13-23" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
08EA'  FC              2116          defb    11111100b
08EB'  FC              2117          defb    11111100b
08EC'  FC              2118          defb    11111100b
08ED'  FC              2119          defb    11111100b
                       2120  ;
08EE'  E0              2121          defb    11100000b       ;code 8E        graphics
08EF'  E0              2122          defb    11100000b
08F0'  E0              2123          defb    11100000b
08F1'  E0              2124          defb    11100000b
08F2'  FC              2125          defb    11111100b
08F3'  FC              2126          defb    11111100b
08F4'  FC              2127          defb    11111100b
08F5'  FC              2128          defb    11111100b
                       2129  ;
08F6'  FC              2130          defb    11111100b       ;code 8F        graphics
08F7'  FC              2131          defb    11111100b
08F8'  FC              2132          defb    11111100b
08F9'  FC              2133          defb    11111100b
08FA'  FC              2134          defb    11111100b
08FB'  FC              2135          defb    11111100b
08FC'  FC              2136          defb    11111100b
08FD'  FC              2137          defb    11111100b
                       2138          END
Additional input after END statement ignored
```

> *Transcriber's note:* This page has a darker grey background than the others but is fully legible. Every `defb` hex byte agrees with its binary operand. Lines 2121 and 2130 are printed `;code 8E` / `;code 8F`, with no space. `END` (line 2138) is printed at source col 4. It is re-spaced here to the opcode column, col 8. The assembler message `Additional input after END statement ignored` is printed on the next line, starting about five columns left of the LOC column. It is given at the block's left margin. The 16 graphics characters on pages 60–63 (codes 80h–8Fh) are the Sinclair 2×2 block graphics drawn in a 6-pixel-wide cell: `E0` is the left half, `1C` is the right half and `FC` is both halves.

<!-- PDF page 64 — listing "Page S-1" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC (symbol table) -->

```text
A       Reserved   ATTBYT   0039      ATTCTL   0011      B       Reserved   BOTLN    002D
C       Reserved   CALCPO   050C      CALCP1   0526      CALCP2   053A      CHNGVI   0E8E
CHRSET   047E      CHRST    057E      CHTBL    002F      CLINIT   1800      CLRCTL   000C
CLRSB0   0278      CLRSCB   000E IN   CLRSCN   027C IN   CLRSC0   0292      CLRSC1   02A3
CLRSC2   02AE      CLRSC3   02B2      CLRSC4   02B5      CLRSC5   02C0      CLRSC6   02D5
CLRSC7   02EB      CLRSXT   02E7      CONVFM   04FC      COORDS   5C7D      CURPOS   0034
D       Reserved   DATAB    0000      DEST7    F7C0      DFADRS   0036      DFBIT    003E
DKHSPT   00F4      DRIVES   6840      E       Reserved   ENBLEX   04D2      ENBLHO   04DF
ERRRET   0144      EXTNRM   04A7      FIX      97C0      FIXTBL   1D00      GETAB0   03CD
GETATB   001E IN   GETATT   03CD IN   GETCB0   03D4      GETCTL   0019      GETCUB   0021 IN
GETCUR   03D4 IN   GETC1    03EC      GETVAL   04AC      GOODRE   0142      GRBLK    0240
GRPHST   077E      GRPST    087E      GRTBL    0031      GTCHAR   032A IN   GTCHB0   0326
GTCHRB   001B IN   GTCH1    033F      GTCH2    0343      GTCH22   0349      GTCH23   035F
GTCH3    0364      GTCH31   0367      GTCH32   0391      GTCH4    039A      GTCH5    03B6
GTCH6    03C6      GTCSHF   0575      GTC2BC   0560      GTC2B1   056B      GTC2B2   057C
GTINDX   003A      H       Reserved   HREXPT   00FF      INSDBL   0201      INSERT   12C0
INVPAR   0147      L       Reserved   LDPOSN   0558      LINCOL   0007      LINLEN   0033
LNBU     053F      LOOP     0205      LOOP0    0208      LOOP1    0210      M       Reserved
MARGIN   003D      MASKB    0038      MOVESZ   0840      MSKCTL   0015      NEXT1    00C2
NEXT2    00EA      NEXT3    010A      NOINVE   0117      NORR1    00C9      NORR2    00F1
NORR3    0111      NOSTRG   01B6      NOXOR    00CF      NXTSC    0226      PARAM$   5CC3
PARERR   04F0      PRAMT    5CB4      PSW     Reserved   RAMTOP   5CB2      RECLEN   1720
SCINIT   1701      SCRCTL   0028      SCRLB    002A IN   SCRLB0   01CA      SCRLCT   002E
SCRLXT   0237      SCRL0    01E4      SCROLL   01CE IN   SCRSZ    0018      SETAB0   02F3
SETATB   0012 IN   SETATT   02F6 IN   SETCB0   01BA      SETCUB   0009 IN   SETCUR   01BE IN
SETMB0   031D      SETMDB   0025 IN   SETMD1   0446      SETMD2   046A      SETMOD   03F4 IN
SETMSB   0016 IN   SETMSK   0320 IN   SET0     04CF      SP      Reserved   STBLK    0248
STBLK0   024C      STBLK1   024D      STBLK2   0264      STKEND   5C65      STMDB0   03F1
STPOSN   0550      STRGCT   003B      SXT4     0483      TESTAD   01F3      TSTPAR   04EB
TSTPR1   04F4      TST01    04C7      TVFULQ   014B      TVFUL1   0167      UDG      5C7B
UPDATE   047E      UPDPOS   0507      VARS     5C4B      VIDMOD   5CC2      VIMODE   0024
WRCHAR   0042 IN   WRCHRB   0001 IN   WRCHXT   013F      WRCH0    003F      WRCH11   0061
WRCH12   0069      WRCH13   006D      WRCH14   0083      WRCH15   0084      WRCH2    008A
WRCH3    0095      WRCH5    009B      WRCH6    00AF      WRCH7    0124      WRSTRB   0004 IN
WRSTRG   0194 IN   WRSTR0   0171      WRSTR1   017C      WRSTR2   018C      WRSTR3   019E
WRSTX1   01A7      WRSTX2   01B3

     No errors detected
```

> *Uncertain:* `CALCPO` (col 2) and `ENBLHO` (col 5): in this font the last character's letter-O and D shapes are nearly identical at this print density. O is chosen to match the sibling module's symbol table. `CLRSB0` (col 1) has a tail-like mark on its last character, so it looks like `Q`. It is read as the zero digit, from the oval shape and from the `...B0` naming pattern.

> *Transcriber's note:* This page is the symbol table. It is given in its printed five-column, row-major layout, with no LOC/OBJ header row and the same cell spacing as the sibling module. `IN` is printed after some values, and its meaning is not stated on the page. All 177 names check against the printed sort order, which puts letters before digits before `$`. Checks against the listing: `GRPST 087E` agrees with line 1992. `CHRST 057E` is consistent with code 66 (`f`) at 07AE', since 057E + (66h−20h)×8 = 07AE. That makes `CHRST` the code-20h start of the character set, and `GRPHST 077E` falls at code 60h on the same arithmetic. Below the table is `No errors detected`. The page has no handwriting.
