# ADL - ASC 003 40-Column Mode Support (Timex, 1983–84): assembler listing

Transcription of the CRZ80/11 assembler listing of `IO40.SRC` (with the included character set `CHST80.SRC`), Timex Application Development Library ASC No. 003, version 001, by Carol Corcoran, 12/19/83, assembled 9-Jan-84. PDF pages 16–60. Each listing line keeps its address (LOC, `'` = relocatable), object code, line number and source. **Read `README.md` first.** The module's printed documentation (PDF pages 1–15) is in `40-column-mode-support-docs.md`.

---

<!-- PDF page 16 — listing "Page 1" — DEFINITIONS — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                          1          NAME    ADL - ASC 003 40-COL.MODE SUPPORT
                          2  ;
                          3  ;
                          4  ;
                          5  ;
                          6  ;
                          7  ;
                          8  ;
                          9  ;
                         10  ;               ***********************************
                         11  ;               *                                 *
                         12  ;               *             TIMEX               *
                         13  ;               * APPLICATION DEVELOPMENT LIBRARY *
                         14  ;               *                                 *
                         15  ;               * NAME: 40-COL.MODE SUPPORT       *
                         16  ;               *                                 *
                         17  ;               * ASC NO:  003                    *
                         18  ;               * VERSION: 001                    *
                         19  ;               * AUTHOR:  C. CORCORAN            *
                         20  ;               * DATE:    12/19/83               *
                         21  ;               ***********************************
```

> *Transcriber's note:* This is the title page of the listing (header "Page 1"). It is printed as listing lines 1–21: a `NAME` directive and a comment-block banner, so it is transcribed inside the code block. The header subtitle reads DEFINITIONS, the `SUBTTL` that line 23 sets on the next page. Header: `ADL - ASC 003 40-COL.MODE SUPPORT   CRZ80/11 version 10.36.14   9-Jan-84  12:18:14`. On line 1 the operand is printed one space after `NAME` (source column 13). Here it is re-spaced to column 16. The banner keeps its printed columns: stars at source columns 16–50, `TIMEX` at column 30, and the field values at column 27. The banner date (12/19/83) is earlier than the assembly date in the header (9-Jan-84). A dark vertical scanner band runs down the middle of the sheet, but every character is legible. Line 22 is not printed; it is probably a page-eject directive. The rest of the sheet is blank.

<!-- PDF page 17 — listing "Page 2" — DEFINITIONS — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                         23          SUBTTL  DEFINITIONS
                         24  ;
                         25  ;
                         26  ;                       ****DEFINITIONS****
                         27  ;
                         28          INTERN  WRCHAR, WRSTRG, SETCUR, CLRSCN, SCROLL
                         29          INTERN  GTCHAR, GETATT, GETCUR
                         30  ;
                         31          INTERN  WRCHRB, WRSTRB, SETCUB, CLRSCB, SCRLB
                         32          INTERN  GTCHRB, GETATB, GETCUB
                         33  ;
                         34          INTERN  INIT40,INIT4B
                         35  ;
                         36  ;
=0018                    37  SCRSZ   EQU     24              ; 24 LINES
=1701                    38  SCINIT  EQU     1701H           ; SCROLL CONTROL INITIALIZATION
=1800                    39  CLINIT  EQU     1800H           ; CLEAR SCREEN CTL. INIT.
=0429'                   40  CHRSET  EQU     ((CHRST)-100H)  ;CHAR.TABLE-100H
=0729'                   41  GRPHST  EQU     ((GRPST)-100H)  ; STD.GRAPHICS TABLE
                         42  ;
=1720                    43  RECLEN  EQU     1720H           ; ROUTINE IN HOME ROM
                         44  ;
=5C4B                    45  VARS    EQU     5C4BH           ; SYSTEM VARIABLES
=5C7B                    46  UDG     EQU     5C7BH           ;
=5C7D                    47  COORDS  EQU     5C7DH           ;
=5C8D                    48  ATTR_P  EQU     5C8DH           ;
=5C8E                    49  MASK_P  EQU     5C8EH           ;
=5C91                    50  P_FLAG  EQU     5C91H           ;
=5CC2                    51  VIDMOD  EQU     5CC2H           ;
=5CC3                    52  PARAM$  EQU     5CC3H           ;  (Location 23747)
                         53
```

> *Transcriber's note:* The `SUBTTL` operand on line 23 is printed at source column 15, one space after the opcode, and is re-spaced to column 16. On the `EQU` lines (37–52) the opcode is printed at source column 16 and the operand at column 24; they are re-spaced to columns 8 and 16. On line 40 the comment is printed at column 40 with no space after the `;` (`;CHAR.TABLE-100H`). On line 41 it is printed at column 39. Both are placed at column 32, as the conventions require. Line 26 keeps its printed indent: `****DEFINITIONS****` starts at column 24. Line 52 has two spaces after the `;`, and its comment is printed in mixed case, `(Location 23747)`. 5CC3H = 23747, so the comment is correct. There is a speck between `24` and `;` on line 37. Line 54 is not printed; it is probably a page-eject directive.

<!-- PDF page 18 — listing "Page 3" — INPUTS AND ENTRIES — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                         55          SUBTTL  INPUTS AND ENTRIES
                         56  ;
                         57  ;
                         58  ;
                         59  ;               **PARAMETER INPUTS AND ENTRY POINTS FROM BASIC**
                         60  ;
                         61  ;                                                            WITH
                         62  ;                                                         MODULE LOADED
                         63  ;                                                         AT 57344(E000H)
                         64  ;                                                         DECIMAL ADDRESS
                         65  ;                                                       ---------------
0000'  20                66  DATAB   DEFB    20H             ; CHAR.CODE FROM BASIC         57344
0001'  C3 0040'          67  WRCHRB: JP      WRCH0           ; ENTRY TO WRITE CHARACTER     57345
0004'  C3 0169'          68  WRSTRB: JP      WRSTR0          ; ENTRY TO WRITE STRING        57348
0007'  0000              69  LINCOL  DEFW     0              ; SET CURSOR PARAMETERS
                         70                                  ;   LINCOL=COL. (0-39)         57351
                         71                                  ;   LINCOL+1=LINE (0-23)       57352
0009'  C3 0192'          72  SETCUB: JP      SETCB0          ; ENTRY TO SET CURSOR POSN.    57353
000C'  1800              73  CLRCTL  DEFW    1800H           ; CLEAR SCREEN CONTROLS
                         74                                  ;   CLRCTL=STARTING LINE NO.   57356
                         75                                  ;   CLRCTL+1=LINE COUNT        57357
000E'  C3 024F'          76  CLRSCB: JP      CLRSB0          ; ENTRY TO CLEAR SCREEN        57358
0011'  0000              77  SPARE0  DEFW     0              ; NOT USED (ALIGNMENT ONLY)
0013'  0000              78  SPARE1  DEFW     0              ;
0015'  0000              79  SPARE2  DEFW     0              ;
0017'  0000              80  SPARE3  DEFW     0              ;
0019'  0000              81  GETCTL  DEFW     0              ; 'GET' CONTROL FROM BASIC     57369
                         82                                  ; FORMAT IS AS FOR LINCOL
001B'  C3 02D7'          83  GTCHRB: JP       GTCHB0         ; ENTRY TO GET CHARACTER       57371
001E'  C3 037E'          84  GETATB: JP       GETAB0         ; ENTRY TO GET ATTRIBUTE       57374
0021'  C3 039C'          85  GETCUB: JP       GETCB0         ; ENTRY TO GET CURSOR POSN.    57377
0024'  00                86  SPARE4  DEFB     0              ; NOT USED                     57380
0025'  C3 03B9'          87  INIT4B  JP       INIT40         ; ENTRY TO INITIALIZE 40-COL.  57381
0028'  1701              88  SCRCTL  DEFW     1701H          ; SCROLL CONTROL
                         89                                  ;   SCRCTL=STARTING LINE NO.   57384
                         90                                  ;   SCRCTL+1=LINE COUNT        57385
002A'  C3 01A2'          91  SCRLB:  JP       SCRLB0         ; ENTRY TO SCROLL              57386
```

> *Transcriber's note:* On the printed page the opcodes sit at source column 16 and the operands at column 24. Here they are re-spaced to columns 8 and 16. The comments keep column 32, and the right-hand decimal addresses keep their printed source column 63. The header block on lines 61–65 is also at its printed columns: `WITH` at 61, the next three lines at 58, and the 15 dashes at 56, which is two columns left of `DECIMAL`. Several operands are printed one column right of the others, at column 25. That leading space is kept, on lines 69, 77–81, 83–88 and 91. On lines 83–85, 87 and 91 the operand runs to column 30, so only one space comes before the `;`. Labels with a colon: `WRCHRB:` `WRSTRB:` `SETCUB:` `CLRSCB:` `GTCHRB:` `GETATB:` `GETCUB:` `SCRLB:`. `INIT4B` has no colon. In the jump targets (`WRCH0`, `WRSTR0`, `SETCB0`, `CLRSB0`, `GTCHB0`, `GETAB0`, `GETCB0`, `INIT40`, `SCRLB0`) and in `SPARE0`, the final character is the oval digit zero, not the squared letter O. `C3 0040'` and `C3 0169'` match the labels `WRCH0:` (0040', PDF page 20) and `WRSTR0` (0169', PDF page 24). Line 92 is not printed; it is probably a page-eject directive.

> *Transcriber's note:* The decimal addresses all equal 57344 (E000H) + LOC: 0000→57344, 0001→57345, 0004→57348, 0007/0008→57351/57352, 0009→57353, 000C/000D→57356/57357, 000E→57358, 0019→57369, 001B→57371, 001E→57374, 0021→57377, 0024→57380, 0025→57381, 0028/0029→57384/57385, 002A→57386.

<!-- PDF page 19 — listing "Page 4" — OTHER VARIABLES — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                         93          SUBTTL  OTHER VARIABLES
                         94  ;
002D'  17                95  BOTLN   DEFB     17H            ; BOTTOM LINE (LINE AFTER      57389
                         96                                  ; WHICH SCREEN IS CONSIDERED
                         97                                  ; FULL.  AUTOMATIC SCROLL
                         98                                  ; WILL BE DONE IF SCRLCT
                         99                                  ; DOES NOT DECREMENT TO 0.
002E'  01               100  SCRLCT  DEFB     1              ; SCROLL COUNT - 1 PLUS NO.    57390
                        101                                  ; OF TIMES AUTOMATIC SCROLL
                        102                                  ; WILL BE DONE.
002F'  0429'            103  CHTBL   DEFW    CHRSET          ; CHARACTER TABLE              57391
0031'  0729'            104  GRTBL   DEFW    GRPHST          ; GRAPHICS TABLE               57393
0033'  28               105  LINLEN  DEFB      28H           ; LINE LENGTH (40/42)          57395
0034'  1829             106  CURPOS  DEFW    1829H           ; CURRENT POSITION             57396
                        107  ;                               ; (INTERNAL FORMAT)
0036'  4000             108  DFADRS  DEFW    4000H           ; CURRENT DISPLAY FILE ADDRS.  57398
0038'  00               109  MASKB   DEFB    0               ; MASK TO BE APPLIED TO        57400
                        110  ;                               ; DISPLAY CHARACTERS
0039'  00               111  ATTBYT  DEFB    0               ; CURRENT ATTRIBUTES           57401
                        112  ;                               ;
003A'  80               113  GTINDX  DEFB    80H             ; INDEX FOR ADJUSTING          57402
                        114  ;                               ; CH.CODE IN GTCHAR
003B'  0000             115  STRGCT  DEFW    0               ; REMAINING COUNT FROM WRSTRG
                        116                                  ; WHEN 'SCREEN FULL'           57403
003D'  01               117  MARGIN  DEFB    1               ; MARGIN ADJUST (0/1)          57405
003E'  07               118  DFBIT   DEFB    7               ; BIT POSN.IN LINE(7,1,3,5)    57406
003F'  00               119  ATTMSK  DEFB    0               ; ATTRIBUTE MASK               57407;
```

> *Transcriber's note:* Re-spaced as on page 3; the decimal addresses stay at source column 63. The operand is printed at column 25 on lines 95 (`17H`) and 100 (`1`), and at column 26 on line 105 (`28H`). Those leading spaces are kept. Lines 107, 110, 112 and 114 have a `;` in column 0 as well as the comment `;`. Line 116 has only the comment `;`. Line 119's decimal address is printed with a trailing semicolon, `57407;`. On line 108 a small dot follows `DEFW`. It is a speck, not a character. A pen stroke runs vertically through the `4` of `57406` on line 118 (handwriting). Line 114 has a speck after the left-hand `;`. The decimal addresses all equal 57344 + LOC: 002D→57389, 002E→57390, 002F→57391, 0031→57393, 0033→57395, 0034→57396, 0036→57398, 0038→57400, 0039→57401, 003A→57402, 003B→57403, 003D→57405, 003E→57406, 003F→57407. `CHTBL`/`GRTBL` assemble to `0429'`/`0729'`, matching the `CHRSET`/`GRPHST` EQUs on page 2. Line 120 is not printed; it is probably a page-eject directive.

<!-- PDF page 20 — listing "Page 5" — WRITE CHARACTER — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        121          SUBTTL  WRITE CHARACTER
                        122  ;
0040'                   123  WRCH0:                          ; HERE FROM BASIC ENTRY TO DISPLAY THE
                        124                                  ; CHARACTER WHOSE CODE IS IN 'DATAB'
0040'  3A 0000'         125          LD      A,(DATAB)
                        126  ;
0043'                   127  WRCHAR:                         ; ENTRY WITH CODE IN A
0043'  CD 04FD'         128          CALL    LDATTR          ; GET ATTRIBUTE AND MASK CONTROLS
                        129                                  ;
                        130                                  ; ENTRY TO USE ATTRIBUTE VALUES IN
                        131                                  ; INTERNAL VARIABLES WITHOUT RELOADING
0046'  CD 04A1'         132  WRCH01: CALL    LDPOSN          ; LOAD REGISTERS FOR CURRENT POSITION
                        133                                  ;   BC=CURSOR POSITION FROM 'CURPOS'
                        134                                  ;   HL=DISPLAY FILE ADDRESS FROM 'DFADRS
                        135                                  ;   A=CODE FOR CHAR. TO BE DISPLAYED
0049'  FE 20            136          CP      20H             ; TEST VALID RANGE
004B'  DA 013F'         137          JP      C,INVPAR        ; < 20H
004E'  FE A5            138          CP      0A5H            ;
0050'  D2 013F'         139          JP      NC,INVPAR       ; > 0A4H
0053'  C5               140          PUSH    BC              ; SAVE CURSOR POSITION
0054'  FE 80            141          CP      80H             ; TEST IF ASCII PRINTABLE (20H-7FH)
0056'  38 15            142          JR      C,WRCH12        ; YES
0058'  FE 90            143          CP      90H             ; TEST IF STD.GRAPHICS(80-8FH)
005A'  38 09            144          JR      C,WRCH11
005C'  ED 4B 5C7B       145          LD      BC,(UDG)        ; USER -DEFINED GRAPHICS(90-A4H)
0060'  05               146          DEC     B               ; ADJUST ADDRESS-100H
0061'  D6 70            147          SUB     70H             ; ADJUST FOR INDEX INTO TABLE
0063'  18 0C            148          JR      WRCH13
0065'  ED 4B 0031'      149  WRCH11  LD      BC,(GRTBL)      ; ADDRESS OF GRAPHICS TABLE
0069'  D6 60            150          SUB     60H             ; ADJUST FOR INDEX INTO TABLE
006B'  18 04            151          JR      WRCH13
006D'  ED 4B 002F'      152  WRCH12  LD      BC,(CHTBL)      ; CHARACTER TABLE
0071'  EB               153  WRCH13  EX      DE,HL           ; DE=POSN.IN DISPLAY FILE
0072'  26 00            154          LD      H,0
0074'  6F               155          LD      L,A             ; CODE IS INDEX INTO TABLE
0075'  29               156          ADD     HL,HL
0076'  29               157          ADD     HL,HL
0077'  29               158          ADD     HL,HL
0078'  09               159          ADD     HL,BC           ; HL=PIXEL PATTERN IN TABLE
0079'  C1               160          POP     BC
007A'  EB               161          EX      DE,HL           ; DE=PIXEL PATTERN IN TABLE/HL=DF
007B'  79               162          LD      A,C             ; TEST IF END OF LINE
007C'  3D               163          DEC     A
007D'  3A 0033'         164          LD      A,(LINLEN)
0080'  20 05            165          JR      NZ,WRCH14
0082'  3C               166          INC     A               ; START OF NEW LINE
0083'  05               167          DEC     B               ; BUMP LINE NO.
0084'  4F               168          LD      C,A             ; LINLEN+1=START OF LINE
0085'  18 01            169          JR      WRCH15
0087'  3C               170  WRCH14  INC     A
0088'  B9               171  WRCH15  CP      C               ; TEST IF START OF LINE
0089'  D5               172          PUSH    DE
```

> *Transcriber's note:* On this page the opcodes are printed at source column 8 and most operands at column 14. `A,(DATAB)` on line 125 is at column 13. The operands are re-spaced to column 16; the comments stay at column 32. Line 129 is a lone `;` at column 32. The local labels `WRCH11`–`WRCH15` have no colon; `WRCH0:`, `WRCHAR:` and `WRCH01:` do. The comment on line 134 has no closing quote (`'DFADRS`), and line 145 reads `USER -DEFINED` with a space, both as printed. There is a small pen dot under the `H` of `WRCH0:` on line 123. The page ends at line 172; the routine continues on "Page 5-1".

<!-- PDF page 21 — listing "Page 5-1" — WRITE CHARACTER — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
008A'  CC 0143'         173          CALL    Z,TVFULQ        ; TEST IF PAST 'BOTTOM' LINE
008D'  D1               174          POP     DE
                        175                                  ; HERE TO PUT CHARACTER IN DISPLAY FILE
008E'  C5               176  WRCH2   PUSH    BC              ; CURSOR POSITION
008F'  E5               177          PUSH    HL              ; DF ADDRESS
0090'  3A 0038'         178          LD      A,(MASKB)       ; GET OVER AND INVERSE CONTROLS
0093'  06 FF            179          LD      B,-1
0095'  1F               180          RRA
0096'  38 01            181          JR      C,WRCH3         ; IF XORING NEW INTO OLD
0098'  04               182          INC     B               ; B=-1 IF XORING  =0 IF NOT
0099'  1F               183  WRCH3   RRA
009A'  1F               184          RRA
009B'  9F               185          SBC     A,A
009C'  4F               186          LD      C,A             ; C=-1 FOR INVERSE  =0 IF NOT
009D'  3E 08            187          LD      A,8             ; SCAN COUNT
009F'  08               188  WRCH5   EX      AF,AF'          ; SAVE SCAN COUNT IN ALTERNATE
00A0'  C5               189          PUSH    BC              ; SAVE MASK VALUES
00A1'  D5               190          PUSH    DE              ; SAVE CHAR.TABLE ADRS
00A2'  DD 21 0000       191          LD      IX,0            ; SAVE PTR.TO STACK
00A6'  DD 39            192          ADD     IX,SP
00A8'  56               193          LD      D,(HL)          ; READ SCAN LINE FROM DF
00A9'  E5               194          PUSH    HL              ; SAVE ADDRESS
00AA'  23               195          INC     HL              ; NEXT BYTE
00AB'  5E               196  WRCH6   LD      E,(HL)          ; READ SCAN LINE FROM NEXT BYTE
00AC'  EB               197          EX      DE,HL           ; SCANS TO HL. LAST OF POS.IN DE
00AD'  78               198          LD      A,B             ; TEST IF 'OVER' IS ACTIVE
00AE'  A7               199          AND     A
00AF'  20 1A            200          JR      NZ,NOXOR        ; YES-RETAIN OLD DATA
00B1'  3A 003E'         201          LD      A,(DFBIT)       ; NO- CLEAR OLD DATA AT CHAR.POSN.
00B4'  D6 07            202          SUB     7               ;
00B6'  ED 44            203          NEG
00B8'  01 03FF          204          LD      BC,03FFH        ; MASK
00BB'  28 08            205          JR      Z,NORR1         ; NO NEED TO ADJUST(CHAR.STARTS AT BIT 7)
00BD'  37               206          SCF
00BE'  CB 18            207  NEXT1   RR      B               ; SHIFT MASK 'A' TIMES
00C0'  CB 19            208          RR      C               ; (6 0'S START AT BIT 1 OF B, BIT 3 OF B,
00C2'  3D               209          DEC     A               ;  OR BIT 5 OF B)
00C3'  20 F9            210          JR      NZ,NEXT1
00C5'  7C               211  NORR1   LD      A,H             ; SCAN LINE FROM DF
00C6'  A0               212          AND     B
00C7'  67               213          LD      H,A             ; RETAIN ADJACENT CHAR.PIXELS
00C8'  7D               214          LD      A,L             ; CLEAR CURRENT CHAR.PIXELS
00C9'  A1               215          AND     C
00CA'  6F               216          LD      L,A             ; HL=OLD BIT ROW
00CB'  3A 003E'         217  NOXOR   LD      A,(DFBIT)       ; GET STARTING BIT POSN.
00CE'  D6 07            218          SUB     7
00D0'  ED 44            219          NEG
00D2'  E5               220          PUSH    HL              ; SAVE SCANS
00D3'  DD 6E 00         221          LD      L,(IX)          ; PTR. TO CHAR.SET
00D6'  DD 66 01         222          LD      H,(IX+1)
00D9'  46               223          LD      B,(HL)          ; SCAN LINE FROM CHAR.SET TO BC
00DA'  0E 00            224          LD      C,0             ; (PIXELS IN B, BITS 7-2)
```

> *Transcriber's note:* Operands are printed at source column 14 and re-spaced to 16. Line 175 is a comment-only line with no `;` in column 0. Lines 182 and 186 have two spaces before `=0`. Line 209 has two spaces after the `;`. In the `LD IX,0` object code on line 191, `0000` has no relocation mark.

<!-- PDF page 22 — listing "Page 5-2" — WRITE CHARACTER — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
00DC'  F5               225          PUSH    AF              ; SAVE A AND FLAGS
00DD'  78               226          LD      A,B             ; PIXELS FROM CHAR.SET
00DE'  E6 FC            227          AND     0FCH            ; LIMIT TO 6 PIXELS
00E0'  47               228          LD      B,A             ;
00E1'  F1               229          POP     AF              ; RESTORE A AND FLAGS
00E2'  E1               230          POP     HL              ; RESTORE SCANS
00E3'  28 08            231          JR      Z,NORR2         ; NO SHIFT NEEDED
00E5'  A7               232          AND     A               ; CLEAR CARRY
00E6'  CB 18            233  NEXT2   RR      B               ; SHIFT 'A' TIMES
00E8'  CB 19            234          RR      C
00EA'  3D               235          DEC     A
00EB'  20 F9            236          JR      NZ,NEXT2
00ED'  7C               237  NORR2   LD      A,H             ; SCAN FROM DF
00EE'  A8               238          XOR     B               ; INSERT/COMBINE NEW CHAR.
00EF'  67               239          LD      H,A
00F0'  7D               240          LD      A,L
00F1'  A9               241          XOR     C
00F2'  6F               242          LD      L,A             ; DF XOR CH.SET->HL
00F3'  DD 7E 02         243          LD      A,(IX+2)        ; TEST IF INVERSE ACTIVE
00F6'  A7               244          AND     A
00F7'  28 1A            245          JR      Z,NOINVERT
00F9'  3A 003E'         246          LD      A,(DFBIT)
00FC'  D6 07            247          SUB     7
00FE'  ED 44            248          NEG
0100'  01 FC00          249          LD      BC,0FC00H       ; MASK TO INVERT
0103'  28 08            250          JR      Z,NORR3
0105'  A7               251          AND     A
0106'  CB 18            252  NEXT3   RR      B               ; SHIFT MASK 'A' TIMES
0108'  CB 19            253          RR      C
010A'  3D               254          DEC     A
010B'  20 F9            255          JR      NZ,NEXT3
010D'  7C               256  NORR3   LD      A,H
010E'  A8               257          XOR     B               ; INVERT CHARACTER
010F'  67               258          LD      H,A
0110'  7D               259          LD      A,L
0111'  A9               260          XOR     C
0112'  6F               261          LD      L,A
0113'  EB               262  NOINVERT EX     DE,HL           ; DF ADRS. TO HL-SCAN LINE IN DE
0114'  73               263          LD      (HL),E          ; WRITE SCAN LINE TO DF
0115'  E1               264          POP     HL              ; PREVIOUS BYTE
0116'  72               265          LD      (HL),D          ; WRITE SCAN LINE TO DF
0117'  D1               266          POP     DE              ; CHAR.SET
0118'  C1               267          POP     BC              ; OVER/INVERSE INDICATORS
0119'  08               268          EX      AF,AF'          ; RESTORE SCAN COUNT
011A'  24               269          INC     H               ; NEXT SCAN IN DF
011B'  13               270          INC     DE              ; NEXT BYTE IN CHAR.FILE
011C'  3D               271          DEC     A               ; TEST IF MORE SCANS
011D'  C2 009F'         272          JP      NZ,WRCH5
0120'  25               273  WRCH7   DEC     H               ; LAST CHAR.SCAN
0121'  CD 04A9'         274          CALL    UPDATT          ; UPDATE ATTRIBUTE BYTE
0124'  E1               275          POP     HL              ; STARTING ADRS.
0125'  C1               276          POP     BC              ; CURSOR POSITION
```

> *Transcriber's note:* Operands are printed at source column 14 and re-spaced to 16. The label `NOINVERT` on line 262 is eight characters, so `EX` is printed at column 9, one space after it. The operand is still placed at column 16.

<!-- PDF page 23 — listing "Page 5-3" — WRITE CHARACTER — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0126'  0D               277          DEC     C               ; ADJUST CURSOR POSITION
0127'  3A 003E'         278          LD      A,(DFBIT)       ; ADJUST BIT POSITION
012A'  D6 06            279          SUB     6
012C'  32 003E'         280          LD      (DFBIT),A       ; STORE UPDATED POSITION
012F'  30 06            281          JR      NC,WRCHXT       ; NEXT CHAR.IN SAME BYTE
0131'  C6 08            282          ADD     A,8             ; NEXT CHAR.IN NEXT BYTE
0133'  32 003E'         283          LD      (DFBIT),A       ; STORE ADJUSTED VALUE
0136'  23               284          INC     HL              ; ADJUST DF ADRS.
0137'  CD 0499'         285  WRCHXT  CALL    STPOSN          ; STORE NEW POSITION
013A'  0E 00            286  GOODRET LD      C,0             ; RETURN BC=0
013C'  06 00            287  ERRRET  LD      B,0             ; ENTER HERE WITH C NON-ZERO
013E'  C9               288          RET
                        289  ;
013F'  0E 01            290  INVPAR  LD      C,1             ; RETURN BC=1 FOR INVALID PARAMETERS
0141'  18 F9            291          JR      ERRRET
                        292  ;
0143'  3E 18            293  TVFULQ  LD      A,SCRSZ         ; TEST IF NEW LINE IS OFF SCREEN
0145'  90               294          SUB     B               ; A=LINE NO.
0146'  57               295          LD      D,A             ; SAVE IN D
0147'  3A 002D'         296          LD      A,(BOTLN)       ; GET BOTTOM LINE
014A'  BA               297          CP      D
014B'  D2 0452'         298          JP      NC,UPDPOSN      ; ON SCREEN - RETURN TO WRITE CHAR.
                        299                                  ;  VIA UPDATE AND STORE POSITION
014E'  3A 002E'         300          LD      A,(SCRLCT)      ; TEST SCROLL COUNT
0151'  3D               301          DEC     A
0152'  20 0B            302          JR      NZ,TVFUL1       ; DO AUTOMATIC SCROLL USING SCRCTL
0154'  3E 01            303          LD      A,1             ; REINITIALIZE TO 1
0156'  32 002E'         304          LD      (SCRLCT),A
0159'  C1               305          POP     BC
015A'  C1               306          POP     BC              ; DISCARD RETURN TO WRITE CHAR.
015B'  0E 03            307          LD      C,3             ; RETURN BC=3 FOR SCREEN FULL
015D'  18 DD            308          JR      ERRRET
015F'  32 002E'         309  TVFUL1  LD      (SCRLCT),A      ; UPDATE VARIABLE
0162'  ED 4B 0028'      310          LD      BC,(SCRCTL)     ; GET SCROLL CONTROLS (STARTING LINE
                        311                                  ;    AND LINE COUNT)
0166'  C3 01BC'         312          JP      SCRL0           ; RETURN TO WRITE CHAR. VIA SCROLL
```

> *Transcriber's note:* This sheet is printed noticeably lighter and thinner than the others, but every character is legible. Operands are printed at source column 14, except on lines 309 and 312, where they are at column 13. All are re-spaced to column 16. On line 296 the comment is printed immediately after the operand (`A,(BOTLN) ; GET BOTTOM LINE`); it is re-spaced to column 32 per the conventions. Line 299 has two spaces after the `;` and line 311 has four. The labels `GOODRET`, `ERRRET`, `TVFULQ`, `TVFUL1`, `WRCHXT` and `INVPAR` have no colons. `SCRL0` on line 312 ends in an oval digit zero. Line 313 is not printed; it is probably a page-eject directive.

<!-- PDF page 24 — listing "Page 6" — WRITE STRING — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        314          SUBTTL  WRITE STRING
                        315  ;                               ; HERE FROM BASIC ENTRY TO
                        316  ;                               ; WRITE CHARACTER STRING TO SCREEN.
                        317  ;                               ; STRING IDENTIFIER (CH.CODE) IN
                        318  ;                               ; SYSTEM VARIABLE PARAM$ AT 5CC3H
0169'  CD 040E'         319  WRSTR0  CALL    GETSTRG         ; GET STRING VAR.ADRS. TO HL
016C'  C8               320          RET     Z               ; NO STRING FOUND OR NULL STRING
                        321  ;                               ; (BC CONTAINS STATUS)
                        322  ;
                        323  ;                               ; ENTRY FROM MACHINE CODE WITH
                        324  ;                               ; ADDRESS OF CHAR.CODE 'STRING'
                        325  ;                               ; IN HL AND LENGTH IN BC
                        326  ;
016D'  CD 04FD'         327  WRSTRG  CALL    LDATTR          ; GET ATTRIBUTE AND MASK CONTROLS
0170'  7E               328  WRSTLP  LD      A,(HL)          ; GET CODE
0171'  E5               329          PUSH    HL              ; SAVE ADRS. AND
0172'  C5               330          PUSH    BC              ; COUNT
0173'  CD 0046'         331          CALL    WRCH01          ; WRITE 'A'
0176'  79               332          LD      A,C             ; TEST IF GOOD
0177'  B0               333          OR      B
0178'  20 09            334          JR      NZ,WRSTX1       ; EXIT IF INVALID CODE OR
                        335                                  ; IF SCREEN FULL
017A'  C1               336  WRSTR3  POP     BC              ; COUNT
017B'  E1               337          POP     HL              ; ADDRESS
017C'  23               338          INC     HL              ; NEXT CHAR.
017D'  0B               339          DEC     BC              ; ADJUST COUNT
017E'  78               340          LD      A,B             ; TEST IF DONE
017F'  B1               341          OR      C
0180'  20 EE            342          JR      NZ,WRSTLP       ; WRITE NEXT CHAR.
0182'  C9               343          RET                     ; RETURN BC=0
                        344  ;
0183'  79               345  WRSTX1  LD      A,C             ; SAVE ERROR
0184'  FE 01            346          CP      1               ; TEST IF UNRECOGNIZED CODE
0186'  28 F2            347          JR      Z,WRSTR3        ; CONTINUE
0188'  E1               348          POP     HL              ; REMAINING COUNT TO HL
0189'  22 003B'         349          LD      (STRGCT),HL     ; STORE REMAINING COUNT
018C'  E1               350          POP     HL              ; ADDRESS TO HL
018D'  0E 03            351          LD      C,3             ; RETURN BC=3 FOR SCREEN FULL
018F'  06 00            352          LD      B,0             ;
0191'  C9               353          RET
                        354  ;
                        355
                        356  ;
                        357  ;
                        358  ;
```

> *Uncertain:* line 328: a short, thin dash is printed or marked immediately before the comment `;` (`-; GET CODE`, at source column 31). It is fainter and thinner than the printed hyphens, so it is taken as a stray mark and not transcribed.

> *Transcriber's note:* Operands are printed at source column 14 and re-spaced to 16. Lines 315–318, 321 and 323–325 have a `;` in column 0 and a comment `;` at column 32. Line 355 is blank (line number only). `WRSTR0` on line 319 ends in an oval digit zero, and its address 0169' matches the `JP WRSTR0` (`C3 0169'`) entry on page 3. The routine ends at `RET` (0191'), followed by comment lines 354–358. The rest of the sheet is blank.

<!-- PDF page 25 — listing "Page 7" — POSITION CONTROL — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        360          SUBTTL  POSITION CONTROL
                        361  ;
0192'                   362  SETCB0:                         ; HERE FROM BASIC ENTRY.  PARAMETERS
                        363                                  ; IN LINCOL
0192'  ED 4B 0007'      364          LD      BC,(LINCOL)
                        365  ;
0196'                   366  SETCUR:                         ; ENTRY WITH LINE/COL. IN BC REG.
0196'  CD 0436'         367          CALL    TSTPAR          ; TEST PARAMETERS FOR VALIDITY
0199'  CD 0447'         368          CALL    CONVFM          ; CONVERT TO INTERNAL FORMAT
019C'  CD 0452'         369          CALL    UPDPOSN         ; CALCULATE AND STORE POSITION
019F'  C3 013A'         370          JP      GOODRET         ; RETURN BC=0
                        371  ;
```

> *Transcriber's note:* only lines 360–371 are printed; the rest of the sheet is blank. Line 372 is not printed (371 → 373 on the next page); it is probably a page-eject directive.

<!-- PDF page 26 — listing "Page 8" — SCROLL — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        373          SUBTTL  SCROLL
                        374  ;
                        375  ;
01A2'                   376  SCRLB0:                         ; HERE FROM BASIC ENTRY TO SCROLL
                        377  ;                               ; SCREEN
01A2'  ED 4B 0028'      378          LD      BC,(SCRCTL)     ; GET CONTROL INFO.
                        379  ;
01A6'                   380  SCROLL:                         ; HERE WITH CONTROLS IN BC
                        381                                  ;  B=NO. OF LINES
                        382                                  ;  C=STARTING LINE NO.
01A6'  78               383          LD      A,B             ; TEST VALIDITY
01A7'  A7               384          AND     A
01A8'  CA 013F'         385          JP      Z,INVPAR        ; ERROR IF COUNT=0
01AB'  81               386          ADD     A,C
01AC'  FE 01            387          CP      1
01AE'  DA 013F'         388          JP      C,INVPAR        ; ERROR IF B+C<1
01B1'  FE 19            389          CP      25
01B3'  D2 013F'         390          JP      NC,INVPAR       ; ERROR IF B+C>24
01B6'  CD 01BC'         391          CALL    SCRL0           ; DO SCROLL
01B9'  C3 013A'         392          JP      GOODRET         ; RETURN BC=0
                        393  ;
01BC'  C5               394  SCRL0   PUSH    BC
01BD'  3E 18            395          LD      A,SCRSZ         ; GET STARTING LINE IN INTERNAL FORMAT
01BF'  91               396          SUB     C
01C0'  47               397          LD      B,A
01C1'  3A 0033'         398          LD      A,(LINLEN)
01C4'  3C               399          INC     A               ; COL. 0
01C5'  4F               400          LD      C,A
01C6'  CD 047E'         401          CALL    LNBU
01C9'  C1               402          POP     BC
01CA'  E5               403          PUSH    HL              ; SAVE STARTING ADRS.
01CB'  C5               404          PUSH    BC              ; SAVE ORIG.BC FOR EXIT
01CC'  7D               405  TESTAD  LD      A,L             ; TEST IF AT START OF BLOCK
01CD'  A7               406          AND     A
01CE'  28 5C            407          JR      Z,STBLK         ; YES
01D0'  07               408          RLCA
01D1'  07               409          RLCA
01D2'  07               410          RLCA
01D3'  4F               411          LD      C,A             ; GET NO. OF LINES THIS BLOCK
01D4'  3E 08            412          LD      A,8
01D6'  91               413          SUB     C
01D7'  B8               414          CP      B               ; TEST AGAINST TOTAL LINES
01D8'  38 4A            415          JR      C,GRBLK         ; TOTAL GREATER THAN THIS BLOCK
01DA'  78               416  INSDBLK LD      A,B
01DB'  06 00            417          LD      B,0             ; REMAINING COUNT
01DD'  C5               418          PUSH    BC
01DE'  47               419  LOOP    LD      B,A             ; B=LINES THIS BLOCK
01DF'  0E 08            420          LD      C,8             ; C=SCAN COUNT
01E1'  78               421  LOOP0   LD      A,B
01E2'  C5               422          PUSH    BC              ; SAVE SCAN COUNT
01E3'  0F               423          RRCA
01E4'  0F               424          RRCA
```

> *Transcriber's note:* line 377 is a `;` at col 0 with the continuation of line 376's comment (`; SCREEN`) at col 32. The page continues mid-routine on Page 8-1.

<!-- PDF page 27 — listing "Page 8-1" — SCROLL — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
01E5'  0F               425          RRCA                    ; CALCULATE NO. OF BYTES
01E6'  4F               426          LD      C,A
01E7'  06 00            427          LD      B,0             ; BC=32*# OF LINES
01E9'  EB               428  LOOP1   EX      DE,HL
01EA'  21 FFE0          429          LD      HL,-20H         ; GET ADRS. OF PREV. LINE
01ED'  19               430          ADD     HL,DE
01EE'  EB               431          EX      DE,HL           ; TO DE
01EF'  E5               432          PUSH    HL              ; SAVE DF ADRS.
01F0'  ED B0            433          LDIR                    ; DO MOVE
01F2'  E1               434          POP     HL              ; GET ADRS.
01F3'  24               435          INC     H               ; NEXT SCAN LINE
01F4'  C1               436          POP     BC              ; SCAN COUNT
01F5'  0D               437          DEC     C
01F6'  20 E9            438          JR      NZ,LOOP0        ; MORE SCANS
01F8'  C1               439          POP     BC              ; RESIDUAL LINE COUNT
01F9'  78               440          LD      A,B
01FA'  A7               441          AND     A
01FB'  28 04            442          JR      Z,SCRLXT        ; DONE
01FD'  2E 00            443          LD      L,0             ; START OF NEXT BLOCK
01FF'  18 CB            444          JR      TESTAD          ; DO REMAINING LINE(S)
0201'  C1               445  SCRLXT  POP     BC              ; ORIG.BC
0202'  D1               446          POP     DE              ; STARTING ADRS.
0203'  C5               447          PUSH    BC              ; SAVE ORIG.BC
0204'  68               448          LD      L,B             ; NO. OF LINES SCROLLED
0205'  26 00            449          LD      H,0             ;
0207'  29               450          ADD     HL,HL           ; 32*NO. OF LINES=
0208'  29               451          ADD     HL,HL           ; NO OF ATTRIBUTE BYTES
0209'  29               452          ADD     HL,HL           ; TO BE SCROLLED
020A'  29               453          ADD     HL,HL           ;
020B'  29               454          ADD     HL,HL           ;
020C'  44               455          LD      B,H             ; COUNT TO BC
020D'  4D               456          LD      C,L             ;
020E'  62               457          LD      H,D             ; ADRS. TO HL
020F'  6B               458          LD      L,E             ;
0210'  CD 04ED'         459          CALL    CALCATT         ; ATTRIBUTE ADRS. TO HL
0213'  EB               460          EX      DE,HL           ;
0214'  21 FFE0          461          LD      HL,-20H         ; ADRS. OF PREV.ATTR.BYTE
0217'  19               462          ADD     HL,DE
0218'  EB               463          EX      DE,HL           ; PREV.BYTE DE
0219'  ED B0            464          LDIR                    ; SCROLL ATTRIBUTES
021B'  C1               465          POP     BC              ; ORIG. BC
021C'  79               466          LD      A,C             ; STARTING LINE
021D'  80               467          ADD     A,B             ; ADD NO. OF LINES MOVED
021E'  3D               468          DEC     A               ; LAST LINE SCROLLED
021F'  4F               469          LD      C,A
0220'  06 01            470          LD      B,1             ; CLEAR 1 LINE
0222'  18 45            471          JR      CLRSC0          ; CLEAR VACATED LINE AND RETURN
                        472  ;
0224'  4F               473  GRBLK   LD      C,A
0225'  78               474          LD      A,B
0226'  91               475          SUB     C               ; ADJUST TOTAL LINE COUNT BY NO.
0227'  47               476          LD      B,A             ; OF LINES THIS BLOCK
```

<!-- PDF page 28 — listing "Page 8-2" — SCROLL — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0228'  C5               477          PUSH    BC
0229'  79               478          LD      A,C             ; LOAD A NO. OF LINES THIS BLOCK
022A'  18 B2            479          JR      LOOP
                        480  ;
022C'  05               481  STBLK   DEC     B               ; ADJUST TOTAL LINE COUNT-1
022D'  C5               482          PUSH    BC
022E'  0E 08            483          LD      C,8             ; SCAN COUNT
0230'  C5               484  STBLK0  PUSH    BC              ; SAVE SCAN COUNT
0231'  EB               485  STBLK1  EX      DE,HL
0232'  21 F8E0          486          LD      HL,-720H
0235'  19               487          ADD     HL,DE
0236'  EB               488          EX      DE,HL           ; ADRS. OF PREV. LINE
0237'  01 0020          489          LD      BC,32           ; BYTE COUNT
023A'  E5               490          PUSH    HL
023B'  ED B0            491          LDIR                    ; DO MOVE
023D'  E1               492          POP     HL
023E'  24               493          INC     H               ; TO NEXT SCAN LINE
023F'  C1               494          POP     BC
0240'  0D               495          DEC     C               ; TEST IF MORE SCANS
0241'  20 ED            496          JR      NZ,STBLK0
0243'  C1               497          POP     BC              ; REMAINING LINE COUNT
0244'  78               498          LD      A,B
0245'  A7               499          AND     A
0246'  28 B9            500          JR      Z,SCRLXT
0248'  11 F820          501          LD      DE,-7E0H        ; ADJUST TO LINE 1
024B'  19               502          ADD     HL,DE
024C'  C3 01CC'         503          JP      TESTAD          ; BC=LINE COUNT
                        504                                  ; HL=DF ADDRESS
                        505  ;
```

> *Transcriber's note:* only lines 477–505 are printed; the rest of the sheet is blank. Line 506 is not printed (505 → 507); it is probably a page-eject directive.

<!-- PDF page 29 — listing "Page 9" — CLEAR SCREEN — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        507          SUBTTL  CLEAR SCREEN
                        508  ;
                        509  ;
024F'                   510  CLRSB0:                         ; HERE FROM BASIC ENTRY TO CLEAR SCREEN
024F'  ED 4B 000C'      511          LD      BC,(CLRCTL)     ; GET CONTROL INFO.
                        512  ;
0253'                   513  CLRSCN:                         ; ENTRY WITH BC=LINE COUNT AND
                        514                                  ; STARTING LINE NO. FOR CLEAR
0253'  78               515          LD      A,B
0254'  A7               516          AND     A               ; TEST VALIDITY
0255'  CA 013F'         517          JP      Z,INVPAR        ; ERROR IF COUNT=0
0258'  81               518          ADD     A,C
0259'  FE 01            519          CP      1               ;
025B'  DA 013F'         520          JP      C,INVPAR        ; ERROR IF B+C<1
025E'  FE 19            521          CP      25
0260'  D2 013F'         522          JP      NC,INVPAR       ; ERROR IF B+C>24
0263'  CD 0269'         523          CALL    CLRSC0          ; DO SERVICE
0266'  C3 013A'         524          JP      GOODRET         ; RETURN BC=0
                        525  ;
                        526  ;
0269'  CD 04FD'         527  CLRSC0  CALL    LDATTR          ; GET ATTRIBUTE CTL
026C'  C5               528          PUSH    BC              ; ORIGINAL BC
026D'  3E 18            529          LD      A,SCRSZ         ; CONVERT TO INTERNAL FORMAT
026F'  91               530          SUB     C
0270'  47               531          LD      B,A
0271'  3A 0033'         532          LD      A,(LINLEN)
0274'  3C               533          INC     A               ; SET TO COL.0
0275'  4F               534          LD      C,A
0276'  CD 047E'         535          CALL    LNBU            ; GET ADDRESS
0279'  50               536          LD      D,B
027A'  59               537          LD      E,C             ; SAVE POSITION
027B'  C1               538          POP     BC              ; ORIG. BC
027C'  D5               539          PUSH    DE              ; SAVE CURSOR POSITION
027D'  7D               540  CLRSC1  LD      A,L             ; GET # OF LINES THIS BLOCK
027E'  07               541          RLCA
027F'  07               542          RLCA
0280'  07               543          RLCA
0281'  4F               544          LD      C,A
0282'  3E 08            545          LD      A,8
0284'  91               546          SUB     C
0285'  B8               547          CP      B               ; COMPARE TO TOTAL LINE COUNT
0286'  38 47            548          JR      C,CLRSC7
0288'  78               549  CLRSC2  LD      A,B             ; NO. OF LINES
0289'  06 00            550          LD      B,0             ; REMAINING LINES
028B'  C5               551          PUSH    BC
028C'  47               552  CLRSC3  LD      B,A
028D'  0E 08            553          LD      C,8             ; SCAN COUNT
028F'  78               554  CLRSC4  LD      A,B
0290'  C5               555          PUSH    BC              ; SAVE LINE CNT./SCAN CNT.
0291'  E6 07            556          AND     7
0293'  0F               557          RRCA
0294'  0F               558          RRCA
```

<!-- PDF page 30 — listing "Page 9-1" — CLEAR SCREEN — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0295'  0F               559          RRCA
0296'  4F               560          LD      C,A             ; BC=32*NO. OF LINES
0297'  06 00            561          LD      B,0             ; (=0 IF 256 FOR 8 LINES)
0299'  0D               562          DEC     C               ; ADJUST
029A'  E5               563  CLRSC5  PUSH    HL
029B'  54               564          LD      D,H
029C'  5D               565          LD      E,L
029D'  36 00            566          LD      (HL),00         ; CLEAR DF
029F'  13               567          INC     DE
02A0'  ED B0            568          LDIR
02A2'  E1               569          POP     HL
02A3'  24               570          INC     H               ; NEXT SCAN ROW
02A4'  C1               571          POP     BC              ; POP LINE/SCAN COUNT
02A5'  0D               572          DEC     C               ; DECR. SCAN COUNT
02A6'  20 E7            573          JR      NZ,CLRSC4       ; NEXT SCAN
02A8'  E5               574          PUSH    HL              ; SAVE NEXT DF ADRS.
02A9'  25               575          DEC     H               ; LAST SCAN OF CHAR.
02AA'  CD 04ED'         576          CALL    CALCATT         ; GET ADRS. IN ATTRIBUTE FILE
02AD'  78               577          LD      A,B             ; NO. OF LINES THIS BLOCK
02AE'  E6 07            578          AND     7
02B0'  0F               579          RRCA
02B1'  0F               580          RRCA
02B2'  0F               581          RRCA
02B3'  4F               582          LD      C,A             ; BC=32*NO. OF LINES
02B4'  06 00            583          LD      B,0
02B6'  0D               584          DEC     C               ; ADJUST
02B7'  54               585          LD      D,H
02B8'  5D               586          LD      E,L
02B9'  3A 0039'         587          LD      A,(ATTBYT)      ; ATTRIBUTE VALUE
02BC'  77               588          LD      (HL),A          ; UPDATE ATTRIBUTE FILE
02BD'  13               589          INC     DE              ;
02BE'  ED B0            590          LDIR                    ;
02C0'  E1               591          POP     HL              ; DF ADRS.(LAST SCAN+100H)
02C1'  C1               592          POP     BC              ; TOTAL LINE COUNT
02C2'  78               593          LD      A,B
02C3'  A7               594          AND     A
02C4'  28 05            595          JR      Z,CLRSXT
02C6'  2E 00            596          LD      L,0             ; HL=START OF NEXT BLOCK
02C8'  C3 027D'         597          JP      CLRSC1          ; B=REMAINING LINE COUNT
02CB'  C1               598  CLRSXT  POP     BC              ; CURSOR POSITION
02CC'  C3 0452'         599          JP      UPDPOSN         ; RETURN VIA UPDATE AND STORE POSITION
02CF'  4F               600  CLRSC7  LD      C,A             ; SAVE NO. LINES THIS BLOCK
02D0'  78               601          LD      A,B
02D1'  91               602          SUB     C               ; ADJUST TOTAL LINE COUNT
02D2'  47               603          LD      B,A
02D3'  C5               604          PUSH    BC              ; REMAINING LINE COUNT
02D4'  79               605          LD      A,C             ; LINES THIS BLOCK
02D5'  18 B5            606          JR      CLRSC3          ;
                        607  ;
```

> *Transcriber's note:* line 566's operand is printed `(HL),00`, with two zeros (as in the sibling module). Only lines 559–607 are printed. Line 608 is not printed (607 → 609); it is probably a page-eject directive.

<!-- PDF page 31 — listing "Page 10" — 'GET' ROUTINES — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        609          SUBTTL  'GET' ROUTINES
                        610  ;
                        611  ;
02D7'                   612  GTCHB0:                         ; HERE FROM BASIC ENTRY TO GET CHARACTER
                        613                                  ; (RETURNS CODE FOR CHARACTER AT
                        614                                  ;  POSITION SPECIFIED IN GETCTL)
02D7'  ED 4B 0019'      615          LD      BC,(GETCTL)     ; GET CONTROL INFO.
                        616  ;
02DB'                   617  GTCHAR:                         ; ENTRY WITH POSITION IN BC
02DB'  CD 0436'         618          CALL    TSTPAR          ; TEST PARAMETERS
02DE'  3A 003E'         619          LD      A,(DFBIT)       ; SAVE CURRENT BIT POSITION
02E1'  F5               620          PUSH    AF
02E2'  CD 0447'         621          CALL    CONVFM          ; CONVERT TO INTERNAL FORMAT
02E5'  CD 0457'         622          CALL    CALCPOS         ; GET DF ADDRESS AND BIT POS.
02E8'  ED 5B 002F'      623          LD      DE,(CHTBL)      ; CHAR.TABLE
02EC'  06 60            624          LD      B,96            ; NO. OF PRINTABLE CHARACTERS
02EE'  3E 80            625          LD      A,80H           ; SET ADJUSTMENT INDEX
02F0'  32 003A'         626  GTCH1   LD      (GTINDX),A
02F3'  14               627          INC     D               ; ADJUST TO START OF TABLE
02F4'  C5               628  GTCH2   PUSH    BC              ; SAVE COUNT
02F5'  E5               629          PUSH    HL              ; SAVE ADRS. IN DF
02F6'  D5               630          PUSH    DE              ; SAVE ADRS. IN CHAR.TABLE
02F7'  CD 0513'         631          CALL    GTC2BC          ; GET SCAN LINE FROM DF TO REG.B
                        632                                  ; BITS 7-2
02FA'  78               633  GTCH22  LD      A,B
02FB'  E6 FC            634          AND     0FCH            ; 6 BITS TO A
02FD'  47               635          LD      B,A             ; DF CHAR.SCAN ROW IN B
02FE'  EB               636          EX      DE,HL           ; CHAR.SET PTR. TO HL
02FF'  7E               637          LD      A,(HL)          ; PIXEL ROW FROM CHAR.SET
0300'  E6 FC            638          AND     0FCH            ; MASK TO 6 BITS
0302'  A8               639          XOR     B               ; TEST AGAINS DF IMAGE
0303'  28 10            640          JR      Z,GTCH3         ; MATCH
0305'  F5               641          PUSH    AF
0306'  3A 003A'         642          LD      A,(GTINDX)      ; TEST IF LOOKING AT STD.GRAPHICS
0309'  FE 90            643          CP      90H
030B'  20 03            644          JR      NZ,GTCH23
030D'  F1               645          POP     AF
030E'  18 3B            646          JR      GTCH4           ; DO NOT TEST INVERSE IF STD.GR.
0310'  F1               647  GTCH23  POP     AF
0311'  FE FC            648          CP      0FCH            ; TEST IF INVERSE
0313'  20 36            649          JR      NZ,GTCH4        ; DOES NOT MATCH
0315'  4F               650  GTCH3   LD      C,A             ; C=0 FOR MATCH  -4 FOR INVERSE
0316'  06 07            651          LD      B,7             ; SCAN COUNT
0318'  EB               652  GTCH31  EX      DE,HL           ; DF ADRS.TO HL
0319'  C5               653          PUSH    BC              ; SAVE MATCH AND SCAN COUNT
031A'  24               654          INC     H               ; NEXT SCAN IN DF
031B'  13               655          INC     DE              ; NEXT ROW IN CHAR.SET
031C'  CD 0513'         656          CALL    GTC2BC          ; NEXT SCAN ROW TO BC
031F'  78               657          LD      A,B
0320'  E6 FC            658          AND     0FCH
0322'  47               659          LD      B,A
0323'  EB               660          EX      DE,HL           ; CHAR.SET PTR. TO HL
```

> *Transcriber's note:* line 639's comment is printed `TEST AGAINS DF IMAGE` (sic). Lines 618 and 619 have a single space between opcode and operand in the printout (`CALL TSTPAR`, `LD  A,(DFBIT)`); re-spaced. The comments on lines 653–655 are printed about eight columns left of col 32 (at ~col 24) and line 656's comment about four columns right of it; all re-spaced to col 32. The sheet ends at line 660; the bottom third is blank.

<!-- PDF page 32 — listing "Page 10-1" — 'GET' ROUTINES — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0324'  7E               661          LD      A,(HL)          ; PIXEL ROW TO A
0325'  E6 FC            662          AND     0FCH
0327'  A8               663          XOR     B               ; TEST MATCH
0328'  C1               664          POP     BC              ; GET PREV.MATCH AND SCAN COUNT
0329'  A9               665          XOR     C
032A'  20 1F            666          JR      NZ,GTCH4        ; NO MATCH-START AGAIN AT NEXT
032C'  10 EA            667          DJNZ    GTCH31          ; DO NEXT SCAN
032E'  79               668          LD      A,C             ; A=-4 IF MATCH ON INVERSE
032F'  C6 03            669          ADD     A,3             ; SET TO -1 IF MATCH ON INVERSE
0331'  C1               670          POP     BC              ; HERE IF MATCH- (SP)=PTR.TO CHAR.
0332'  C1               671          POP     BC              ; IN TABLE;(SP+2)=CHAR.IN DF;
0333'  C1               672          POP     BC              ; (SP+4)=CHAR.COUNT
0334'  4F               673          LD      C,A             ; B=COUNT C=-1 IF MATCH ON INVERSE
0335'  3A 003A'         674          LD      A,(GTINDX)      ; CONVERT MATCH TO CHAR.CODE
0338'  90               675          SUB     B
0339'  FE 20            676          CP      20H             ; TEST IF MATCH ON SPACE
033B'  20 05            677          JR      NZ,GTCH32       ; NO
033D'  0C               678          INC     C               ; TEST IF MATCH ON INVERSE
033E'  20 02            679          JR      NZ,GTCH32
0340'  3E 8F            680          LD      A,8FH           ; LOAD CODE FOR GRAPHICS BLOCK
0342'  4F               681  GTCH32  LD      C,A             ; RETURN IN REG. C OF BC PAIR
0343'  06 00            682          LD      B,0             ; AND IN REG. A
0345'  F1               683          POP     AF
0346'  32 003E'         684          LD      (DFBIT),A       ; RESTORE DFBIT
0349'  79               685          LD      A,C             ; CHAR.CODE TO A
034A'  C9               686          RET
                        687  ;
034B'  E1               688  GTCH4   POP     HL              ; PTR. TO CHR. SET
034C'  11 0008          689          LD      DE,8            ; MOVE ON TO NEXT CHARACTER
034F'  19               690          ADD     HL,DE
0350'  5D               691          LD      E,L
0351'  54               692          LD      D,H
0352'  E1               693          POP     HL              ; DF ADDRESS
0353'  C1               694          POP     BC              ; CHAR. COUNT
0354'  10 9E            695          DJNZ    GTCH2           ; DECREMENT CHAR.COUNT AND LOOK AGAIN
                        696  ;
0356'  3A 003A'         697          LD      A,(GTINDX)      ; TEST IF DONE
0359'  FE 80            698          CP      80H             ; TEST IF STD.CHR.SET
035B'  20 0A            699          JR      NZ,GTCH5        ; TRY GRAPHICS
035D'  ED 5B 0031'      700          LD      DE,(GRTBL)      ; GRAPHICS TABLE
0361'  06 10            701          LD      B,16            ; NO. OF ENTRIES
0363'  3E 90            702          LD      A,90H
0365'  18 89            703          JR      GTCH1
0367'  FE 90            704  GTCH5   CP      90H             ; TEST IF STD.GRAPHICS
0369'  20 0C            705          JR      NZ,GTCH6        ;
036B'  ED 5B 5C7B       706          LD      DE,(UDG)        ; TRY USER-DEFINED GRAPHICS
036F'  15               707          DEC     D               ; ADJUST ADDRESS-100H
0370'  06 15            708          LD      B,21            ; NO. OF ENTRIES
0372'  3E A5            709          LD      A,0A5H          ; INDEX ADJUST
0374'  C3 02F0'         710          JP      GTCH1
                        711
                        712  ;                               ; NO MATCH AT ALL
```

> *Transcriber's note:* line 706's OBJ word `5C7B` carries no relocation mark, which is correct for the absolute UDG system variable. Line 711 is blank; line 712 is a `;` at col 0 with `; NO MATCH AT ALL` at col 32 (the comment heads GTCH6 on the next page).

<!-- PDF page 33 — listing "Page 10-2" — 'GET' ROUTINES — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0377'  F1               713  GTCH6   POP     AF              ; RESTORE ORIG. DFBIT
0378'  32 003E'         714          LD      (DFBIT),A
037B'  48               715          LD      C,B             ; BC=0
037C'  AF               716          XOR     A               ; A=0
037D'  C9               717          RET
                        718
                        719                                  ; GET ATTRIBUTE BYTE
                        720  ;
                        721  ;                               ; HERE FROM BASIC ENTRY
037E'  ED 4B 0019'      722  GETAB0: LD      BC,(GETCTL)
                        723  ;                               ; HERE WITH LINE/COL. IN BC
0382'                   724  GETATT:
0382'  CD 0436'         725          CALL    TSTPAR          ; TEST PARAMETERS
0385'  3A 003E'         726          LD      A,(DFBIT)       ; SAVE CURRENT BIT POSITION
0388'  F5               727          PUSH    AF
0389'  CD 0447'         728          CALL    CONVFM          ; CONVERT TO INTERNAL FORMAT
038C'  CD 0457'         729          CALL    CALCPOS         ; CALCULATE DF POSITION
038F'  CD 04ED'         730          CALL    CALCATT         ; CALCULATE ATTRIBUTE POSITION
0392'  7E               731          LD      A,(HL)          ; ATTRIBUTE BYTE TO A
0393'  4F               732          LD      C,A             ; PASS BACK IN BC
0394'  06 00            733          LD      B,0
0396'  F1               734          POP     AF              ; RESTORE (DFBIT)
0397'  32 003E'         735          LD      (DFBIT),A       ;
039A'  79               736          LD      A,C             ; ATTRIBUTE ALSO IN A
039B'  C9               737          RET
                        738  ;
                        739  ;
                        740  ;                               ; GET CURSOR POSITION
039C'                   741  GETCB0:                         ; HERE FROM BASIC ENTRY
039C'                   742  GETCUR:
039C'  ED 4B 0034'      743          LD      BC,(CURPOS)     ; GET INTERNAL POSITION
03A0'  CD 0447'         744          CALL    CONVFM          ; CONVERT TO USER FORMAT
03A3'  3A 0033'         745          LD      A,(LINLEN)      ; TEST IF END OF LINE
03A6'  B9               746          CP      C               ; IF =40 OR 42
03A7'  20 0B            747          JR      NZ,GETC1        ; NO
03A9'  0E 00            748          LD      C,0             ; NEXT POSN.START OF NEXT LINE
03AB'  78               749          LD      A,B
03AC'  3C               750          INC     A               ; BUMP TO NEXT LINE
03AD'  47               751          LD      B,A
03AE'  FE 18            752          CP      24              ; TEST IF OFF SCREEN
03B0'  38 02            753          JR      C,GETC1         ; NO
03B2'  06 17            754          LD      B,23            ; POSN. IS AT BOTTOM LINE
03B4'  ED 43 0007'      755  GETC1   LD      (LINCOL),BC     ; STORE FOR BASIC PROGRAM
03B8'  C9               756          RET                     ; VALUES ALSO IN BC
                        757  ;
```

> *Transcriber's note:* in the printout the comments on lines 725–736 start at about source col 24 (straight after the operand), not col 32; they have been re-spaced to col 32. Line 735 prints a bare `;` after its operand. A stray dot follows `TEST PARAMETERS` on line 725 and is not transcribed. Line 744 has a single space in `CALL CONVFM`; re-spaced. Lines 721, 723 and 740 are a `;` at col 0 with a comment at col 32. The listing ends at line 757 with the lower half of the sheet blank.

<!-- PDF page 34 — listing "Page 11" — INITIALIZE 40-COL.MODE — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        759          SUBTTL  INITIALIZE 40-COL.MODE
                        760  ;
                        761  ;
                        762  ;
03B9'                   763  INIT40:
03B9'  21 1701          764          LD      HL,SCINIT       ; INITIALIZE VARIABLES
03BC'  22 0028'         765          LD      (SCRCTL),HL     ; SCROLL CONTROL
03BF'  3E 17            766          LD      A,23            ;
03C1'  32 002D'         767          LD      (BOTLN),A       ; BOTTOM LINE
03C4'  3E 01            768          LD      A,1             ;
03C6'  32 002E'         769          LD      (SCRLCT),A      ; SCROLL COUNT
03C9'  3E 28            770          LD      A,40            ;
03CB'  32 0033'         771          LD      (LINLEN),A      ; LINE LENGTH
03CE'  3E 01            772          LD      A,1             ;
03D0'  32 003D'         773          LD      (MARGIN),A      ; MARGIN
03D3'  21 1800          774          LD      HL,CLINIT       ;
03D6'  22 000C'         775          LD      (CLRCTL),HL     ; CLEAR SCREEN CONTROL
03D9'  AF               776          XOR     A
03DA'  32 003B'         777          LD      (STRGCT),A      ; STRING COUNT
03DD'  32 003C'         778          LD      (STRGCT+1),A    ;
03E0'  21 0429'         779          LD      HL,CHRSET       ; STD. 40-COL.CHAR.SET
03E3'  22 002F'         780          LD      (CHTBL),HL      ;
03E6'  21 0729'         781          LD      HL,GRPHST       ; STD. 40-COL.GRAPHICS SET
03E9'  22 0031'         782          LD      (GRTBL),HL      ;
                        783  ;                               ; INITIALIZE BASIC INPUTS
                        784  ;
03EC'  32 0000'         785          LD      (DATAB),A       ; DATA BYTE
03EF'  32 0007'         786          LD      (LINCOL),A      ; COLUMN
03F2'  32 0008'         787          LD      (LINCOL+1),A    ; LINE
03F5'  32 0019'         788          LD      (GETCTL),A      ; 'GET' COLUMN
03F8'  32 001A'         789          LD      (GETCTL+1),A    ; 'GET' LINE
                        790  ;
03FB'  21 0000          791          LD      HL,0            ;
03FE'  22 5C7D          792          LD      (COORDS),HL     ; PLOT POSITION
0401'  3A 0033'         793          LD      A,(LINLEN)      ;
0404'  3C               794          INC     A               ; HOME POSITION TO BC
0405'  4F               795          LD      C,A
0406'  06 18            796          LD      B,SCRSZ         ; = LINE 0/COL.0
0408'  CD 0452'         797          CALL    UPDPOSN         ; CALCULATE AND STORE HOME POSITION
040B'  C3 013A'         798          JP      GOODRET         ; RETURN BC=0
                        799  ;
                        800  ;
                        801  ;
```

> *Transcriber's note:* The page header reads `ADL - ASC 003 40-COL.MODE SUPPORT   CRZ80/11 version 10.36.14   9-Jan-84 12:18:14   Page 11` with subtitle `INITIALIZE 40-COL.MODE   IO40.SRC`. On the printed page the operands of lines 777–782 and 785–789 sit a few columns further right than those of the neighbouring lines, and `XOR A` / `INC A` are printed with a single space. All are re-spaced to the standard columns here. The rest of the sheet below line 801 is blank. Line 802 is not printed; it is probably a page-eject directive. `CHRSET` assembles to `0429'`, which is exactly 100H below `CHRST` (`0529'`, line 1056). That fits a table indexed from character code 0 (code x at CHRSET+8x), so it is not a misprint.

<!-- PDF page 35 — listing "Page 12" — INTERNAL SUB-RTNS. — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        803          SUBTTL  INTERNAL SUB-RTNS.
                        804  ;
                        805  ;
040E'  3A 5CC3          806  GETSTRG LD      A,(PARAM$)      ; GET STRING ID
0411'  E6 1F            807          AND     1FH             ; MASK OFF UPPER BITS
0413'  F6 40            808          OR      40H             ; STRING VARIABLE IDENTIFIER
0415'  57               809          LD      D,A             ; SAVE IN D
0416'  2A 5C4B          810          LD      HL,(VARS)       ; FIND STRING
0419'  7E               811  GTSTR1  LD      A,(HL)          ;
041A'  E6 7F            812          AND     07FH            ; TEST IF END OF VARS AREA
041C'  28 13            813          JR      Z,NOSTRG        ; NO FIND - RETURN BC=2
041E'  BA               814          CP      D               ; TEST IF MATCH
041F'  28 08            815          JR      Z,GTSTR2        ; FOUND STRING
0421'  D5               816          PUSH    DE              ; SAVE STRING ID
0422'  CD 1720          817          CALL    RECLEN          ; RETURNS ADRS. OF NEXT VAR. IN DE
0425'  EB               818          EX      DE,HL           ; ADRS. TO HL
0426'  D1               819          POP     DE              ; RESTORE STRING ID
0427'  18 F0            820          JR      GTSTR1          ; LOOK AGAIN
0429'  23               821  GTSTR2  INC     HL              ; GET LENGTH
042A'  4E               822          LD      C,(HL)
042B'  23               823          INC     HL
042C'  46               824          LD      B,(HL)
042D'  23               825          INC     HL              ; FIRST TEXT CODE
042E'  78               826          LD      A,B             ; TEST IF NULL STRING
042F'  B1               827          OR      C
0430'  C9               828          RET                     ; RETURN (Z IF NULL STRING/NZ IF NOT)
                        829  ;
0431'  0E 02            830  NOSTRG  LD      C,2
0433'  06 00            831          LD      B,0
0435'  C9               832          RET                     ; (Z AND BC=2 FOR NO FIND)
                        833  ;
                        834  ;
                        835
                        836  ;
                        837  ;
                        838                                  ; TEST PARAMETER VALIDITY
                        839                                  ; IF NOT VALID, DISCARDS RETURN
                        840                                  ; AND EXITS VIA INVPAR
0436'  3E 17            841  TSTPAR  LD      A,23            ; TEST LINE >23
0438'  B8               842          CP      B
0439'  30 04            843          JR      NC,TSTPR1
043B'  F1               844  PARERR  POP     AF
043C'  C3 013F'         845          JP      INVPAR
043F'  3A 0033'         846  TSTPR1  LD      A,(LINLEN)
0442'  3D               847          DEC     A
0443'  B9               848          CP      C               ; TEST COL. >LINE LENGTH-1
0444'  38 F5            849          JR      C,PARERR
0446'  C9               850          RET
                        851  ;
                        852                                  ; CONVERT LINE/COL. FROM USER TO
                        853                                  ; INTERNAL FORMAT AND VICE VERSA
                        854                                  ; USER FORMAT: LINES 0-23
```

> *Transcriber's note:* The comment on line 848 is printed at source column 24, not 32. It is moved to column 32 here, as for other code lines. The comment-only lines 838–840 and 852–854 have their `;` at column 32, as printed. Line 835 is blank.

<!-- PDF page 36 — listing "Page 12-1" — INTERNAL SUB-RTNS. — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        855                                  ;              COL. 0-39(41)
                        856                                  ; INTERNAL FORMAT:
                        857                                  ;              LINES 24-1
                        858                                  ;              COL. (43)41-2
                        859                                  ;              (COL.1 END OF LINE)
                        860  ;
                        861  ;
0447'  3A 0033'         862  CONVFM  LD      A,(LINLEN)
044A'  3C               863          INC     A
044B'  91               864          SUB     C
044C'  4F               865          LD      C,A             ; CONVERT
044D'  3E 18            866          LD      A,SCRSZ
044F'  90               867          SUB     B
0450'  47               868          LD      B,A
0451'  C9               869          RET
                        870  ;
                        871  ;
                        872  ;
0452'                   873  UPDPOSN:                        ; ENTER HERE WITH BC=LINE/COL.IN
                        874                                  ; INTERNAL FORMAT
0452'  CD 0457'         875          CALL    CALCPOS         ; CALCULATE POSITION
0455'  18 42            876          JR      STPOSN          ; STORE UPDATED POSITION AND RETURN
                        877  ;
                        878  ;                               ; ROUTINE TO CALCULATE POSITION IN DF
                        879  ;                               ; UPDATES BIT POSITION IN VARIABLE DFBIT
                        880  ;                               ; RETURNS DF ADDRESS IN HL.  PRESERVES
                        881  ;                               ; LINE/COL.POSITION IN BC
                        882  ;
0457'  CD 047E'         883  CALCPOS CALL    LNBU            ; GET DISPLAY FILE ADRS.FOR LINE
045A'  3A 0033'         884          LD      A,(LINLEN)
045D'  3C               885          INC     A
045E'  91               886          SUB     C               ; GET COL. NO.
045F'  F5               887          PUSH    AF              ; SAVE COL. NO.(0-(LINLEN-1))
0460'  5F               888          LD      E,A
0461'  87               889          ADD     A,A
0462'  83               890          ADD     A,E             ; 3 *<40-COL.POS> /4 = 32-COL.POS
0463'  CB 3F            891          SRL     A
0465'  CB 3F            892          SRL     A
0467'  5F               893          LD      E,A             ;
0468'  3A 003D'         894          LD      A,(MARGIN)      ; GET ADJUSTMENT VALUE
046B'  83               895          ADD     A,E
046C'  5F               896          LD      E,A
046D'  16 00            897          LD      D,0             ; DE CONTAINS OFFSET INTO LINE
046F'  19               898          ADD     HL,DE           ; HL CONTAINS DF ADDRESS
0470'  1E 07            899          LD      E,7
0472'  F1               900          POP     AF              ; A=COL.POSN.FOR 40 COLS.
0473'  E6 03            901          AND     3               ;
0475'  28 02            902          JR      Z,CALCP2        ; STARTS AT BIT 7
0477'  5F               903          LD      E,A             ; STARTS AT BIT 1,3 OR 5
0478'  3D               904          DEC     A
0479'  83               905  CALCP2  ADD     A,E
047A'  32 003E'         906          LD      (DFBIT),A
```

> *Transcriber's note:* In lines 855 and 857–859 the text after the `;` is indented to line up under `LINES` in line 854, as printed. Lines 878–881 have a `;` at column 0 and the comment text at column 32, as printed.

<!-- PDF page 37 — listing "Page 12-2" — INTERNAL SUB-RTNS. — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
047D'  C9               907          RET                     ; BC=POS. HL=DF ADDRESS
                        908  ;
                        909  ;
047E'                   910  LNBU:                           ; GET DISPLAY FILE ADDRESS
                        911                                  ; FOR START OF LINE IN B
047E'  3E 18            912          LD      A,SCRSZ
0480'  90               913          SUB     B
0481'  57               914          LD      D,A
0482'  0F               915          RRCA
0483'  0F               916          RRCA
0484'  0F               917          RRCA
0485'  E6 E0            918          AND     0E0H
0487'  6F               919          LD      L,A
0488'  7A               920          LD      A,D
0489'  E6 18            921          AND     18H
048B'  F6 40            922          OR      40H
048D'  67               923          LD      H,A
048E'  3A 5CC2          924          LD      A,(VIDMOD)      ; TEST IF USING DF1
0491'  CB 47            925          BIT     0,A
0493'  C8               926          RET     Z
0494'  3E 20            927          LD      A,20H           ; USING DF2
0496'  B4               928          OR      H
0497'  67               929          LD      H,A
0498'  C9               930          RET
                        931
0499'                   932  STPOSN:                         ; STORE CURSOR POSITION
0499'  ED 43 0034'      933          LD      (CURPOS),BC
049D'  22 0036'         934          LD      (DFADRS),HL
04A0'  C9               935          RET
                        936  ;
04A1'                   937  LDPOSN:                         ; LOAD CURSOR POSITION
04A1'  ED 4B 0034'      938          LD      BC,(CURPOS)
04A5'  2A 0036'         939          LD      HL,(DFADRS)
04A8'  C9               940          RET
                        941  ;
                        942  ;
04A9'                   943  UPDATT:                 ; UPDATE ATTRIBUTE BYTE FOR CHARACTER
                        944  ;                       ; JUST PRINTED
                        945  ;                       ; HL = ANY SCAN OF CHAR.IN DF
                        946  ;                       ;
                        947  ;                       ; IF CHARACTER SPANS ATTRIBUTE BYTE
                        948  ;                       ; BOUNDARY, BOTH ATTRIBUTE BYTES WILL
                        949  ;                       ; BE ADJUSTED
                        950  ;
                        951  ;
04A9'  CD 04ED'         952          CALL    CALCATT         ; ADDRS. OF ATTRIBUTE BYTE TO HL
04AC'  3A 003E'         953          LD      A,(DFBIT)       ; SAVE BIT POSITION
04AF'  F5               954          PUSH    AF              ;
04B0'  3A 0039'         955          LD      A,(ATTBYT)      ; CURRENT ATTRIBUTE BYTE VALUE
04B3'  5F               956          LD      E,A             ; TO E
04B4'  3A 003F'         957          LD      A,(ATTMSK)      ; MASK TO D
04B7'  57               958          LD      D,A
```

> *Transcriber's note:* The comments on lines 943–949 (the `UPDATT:` header block) are printed at source column 24, not 32. That position is kept here, because these are label-only and comment-only lines and the block stays aligned. Line 931 is blank.

<!-- PDF page 38 — listing "Page 12-3" — INTERNAL SUB-RTNS. — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
04B8'  3A 0038'         959          LD      A,(MASKB)       ; FLAGS
04BB'  47               960          LD      B,A             ; TO B
04BC'  7E               961  UPDAT0  LD      A,(HL)          ; BYTE FROM ATTRIBUTE FILE
04BD'  AB               962          XOR     E
04BE'  A2               963          AND     D
04BF'  AB               964          XOR     E               ; NEW ATTR.FOR 0; OLD FOR 1
04C0'  CB 60            965          BIT     4,B             ; SET INK COMPLEMENT OF PAPER?
04C2'  28 08            966          JR      Z,UPDAT1        ;
04C4'  E6 F8            967          AND     0F8H            ; SET INK TO BLACK
04C6'  CB 6F            968          BIT     5,A             ; IS PAPER 4-7
04C8'  20 02            969          JR      NZ,UPDAT1       ; YES - USE BLACK INK
04CA'  F6 07            970          OR      7               ; NO  - USE WHITE INK
04CC'  CB 70            971  UPDAT1  BIT     6,B             ; SET PAPER COMPLEMENT OF INK?
04CE'  28 08            972          JR      Z,UPDAT2        ;
04D0'  E6 C7            973          AND     0C7H            ; SET PAPER TO BLACK
04D2'  CB 57            974          BIT     2,A             ; IS INK 4-7
04D4'  20 02            975          JR      NZ,UPDAT2       ; YES - USE BLACK PAPER
04D6'  F6 38            976          OR      38H             ; NO  - USE WHITE PAPER
04D8'  77               977  UPDAT2  LD      (HL),A          ; TO ATTRIBUTE FILE
04D9'  3A 003E'         978          LD      A,(DFBIT)       ; TEST BIT POSITION
04DC'  FE 05            979          CP      5
04DE'  30 08            980          JR      NC,UPDAT3       ; CHAR.IN SINGLE BYTE IF STARTS
                        981  ;                               ; IN BIT 7 OR 5
04E0'  23               982          INC     HL              ; CHAR.SPANS 2 BYTES IF STARTS
04E1'  3E 07            983          LD      A,7             ; IN BIT 3 OR 1
04E3'  32 003E'         984          LD      (DFBIT),A       ; TEMPORARILY SET TO 7
04E6'  18 D4            985          JR      UPDAT0          ; UPDATE NEXT BYTE
                        986                                  ; (DFBIT=7 WILL FORCE EXIT AND
                        987                                  ;  ORIGINAL VALUE OF DFBIT WILL
                        988                                  ;  BE RESTORED)
                        989  ;
04E8'  F1               990  UPDAT3  POP     AF              ; ORIGINAL DFBIT
04E9'  32 003E'         991          LD      (DFBIT),A       ; RESTORE
04EC'  C9               992          RET
                        993  ;
                        994
                        995  ;                               ; SUB-RTN. TO CALCULATE ADRS. OF
                        996  ;                               ; ATTRIBUTE BYTE FROM ADRS. OF
                        997  ;                               ; ANY SCAN ROW IN DF
                        998  ;
                        999  ;                               ; USED BY UPDATT AND GETATT
                       1000  ;
04ED'  7C              1001  CALCATT LD      A,H             ; UPPER BYTE OF ADDRESS
04EE'  0F              1002          RRCA
04EF'  0F              1003          RRCA
04F0'  0F              1004          RRCA
04F1'  E6 03           1005          AND     03H
04F3'  F6 58           1006          OR      58H             ; ADRS. OF ATTRIBUTE BYTE
04F5'  CB 6C           1007          BIT     5,H             ; TEST WHICH DF
04F7'  28 02           1008          JR      Z,CALCA1        ; DF1
04F9'  F6 20           1009          OR      20H             ; DF2
04FB'  67              1010  CALCA1  LD      H,A             ; ADRS. OF ATTRIBUTE
```

> *Uncertain:* line 980 operand `NC,UPDAT3`. The second letter looks like a `G` because of a diagonal mark inside the `C`, but it lacks the horizontal bar of this font's `G`, and the object byte `30` is `JR NC`.
>
> *Transcriber's note:* In the label `UPDAT0` (lines 961 and 985) the last character is the digit zero (the narrow oval zero glyph, not this font's letter O). That matches `UPDAT1`–`UPDAT3`. On lines 987–988 there are two spaces after the `;`, as printed. Line 994 is blank.

<!-- PDF page 39 — listing "Page 12-4" — INTERNAL SUB-RTNS. — IO40.SRC -->

```text
LOC    OBJ            LINE  SOURCE
04FC'  C9              1011          RET
                       1012  ;
04FD'                  1013  LDATTR:                         ; LOAD INTERNAL ATTRIBUTE VARIABLES
                       1014                                  ; FROM SYSTEM VARIABLES
                       1015                                  ;
04FD'  F5              1016          PUSH    AF              ; SAVE A
04FE'  3A 5C8D         1017          LD      A,(ATTR_P)      ;
0501'  32 0039'        1018          LD      (ATTBYT),A      ;
0504'  3A 5C8E         1019          LD      A,(MASK_P)      ;
0507'  32 003F'        1020          LD      (ATTMSK),A      ;
050A'  3A 5C91         1021          LD      A,(P_FLAG)
050D'  0F              1022          RRCA                    ; SHIFT ODD BITS TO EVEN
050E'  32 0038'        1023          LD      (MASKB),A       ;
0511'  F1              1024          POP     AF
0512'  C9              1025          RET
                       1026  ;
                       1027  ;                               ; RTN. USED BY GTCHAR TO PUT
                       1028  ;                               ; 6 PIXELS FROM DF IN B REG.BITS 7-2
                       1029  ;                               ; FOR MATCHING AGAINST CHAR.SET
                       1030  ;
0513'  E5              1031  GTC2BC  PUSH    HL              ; SAVE DF ADRS.
0514'  46              1032          LD      B,(HL)          ; SCAN LINE FROM DF
0515'  23              1033          INC     HL              ; NEXT BYTE
0516'  4E              1034  GTC2B1  LD      C,(HL)          ; BC CONTAINS CHAR.AT DFBIT
0517'  3A 003E'        1035          LD      A,(DFBIT)
051A'  D6 07           1036          SUB     7
051C'  ED 44           1037          NEG                     ; A=NO.OF BITS OFFSET IN BC
051E'  28 07           1038          JR      Z,GTC2B2        ; STARTS AT BIT 7
0520'  CB 11           1039  GTCSHFT RL      C
0522'  CB 10           1040          RL      B               ; SHIFT 6 PIXELS FOR CHARACTER
0524'  3D              1041          DEC     A               ; TO B, BITS 7-2
0525'  20 F9           1042          JR      NZ,GTCSHFT
0527'  E1              1043  GTC2B2  POP     HL              ;
0528'  C9              1044          RET                     ; CHAR.IN B, BITS 7-2
                       1045  ;
                       1046
                       1047          INCLUDE CHST80
                       1048          SUBTTL  CHAR.SET FOR 40/80 COL.MODES
                       1049
                       1050  ;
                       1051  ; Dot patterns for characters on the TV screen:
                       1052  ;       character with code x is at offsets 8x (top line) to 8x+7 (bottom line)
                       1053  ;       0 = white, 1 = black, no margins between character spaces either
                       1054  ;               vertically or horizontally
                       1055
0529'  00              1056  CHRST   defb    00000000b       ; code 20       space
052A'  00              1057          defb    00000000b
052B'  00              1058          defb    00000000b
052C'  00              1059          defb    00000000b
052D'  00              1060          defb    00000000b
052E'  00              1061          defb    00000000b
052F'  00              1062          defb    00000000b
```

> *Transcriber's note:* From line 1047 (`INCLUDE CHST80`) the listing switches to the included file. The next pages carry the subtitle `CHAR.SET FOR 40/80 COL.MODES   CHST80.SRC`. Lines 1051–1054 and all of the character data are printed in lower case (`defb`, `b` suffix, `code`, `space`), and that case is kept. On the printed page `defb` is followed by one space and the operand. The operand is moved to column 16 here. The `; code NN` comment is at column 32 and the character glyph is at column 48, both as printed. Lines 1046, 1049 and 1055 are blank. Every object byte was checked against its binary operand, and all of them agree.

<!-- PDF page 40 — listing "Page 12-5" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0530'  00              1063          defb    00000000b
                       1064
0531'  00              1065          defb    00000000b       ; code 21       !
0532'  10              1066          defb    00010000b
0533'  10              1067          defb    00010000b
0534'  10              1068          defb    00010000b
0535'  10              1069          defb    00010000b
0536'  00              1070          defb    00000000b
0537'  10              1071          defb    00010000b
0538'  00              1072          defb    00000000b
                       1073
0539'  00              1074          defb    00000000b       ; code 22       "
053A'  48              1075          defb    01001000b
053B'  48              1076          defb    01001000b
053C'  00              1077          defb    00000000b
053D'  00              1078          defb    00000000b
053E'  00              1079          defb    00000000b
053F'  00              1080          defb    00000000b
0540'  00              1081          defb    00000000b
                       1082
0541'  00              1083          defb    00000000b       ; code 23       #
0542'  28              1084          defb    00101000b
0543'  7C              1085          defb    01111100b
0544'  28              1086          defb    00101000b
0545'  28              1087          defb    00101000b
0546'  7C              1088          defb    01111100b
0547'  28              1089          defb    00101000b
0548'  00              1090          defb    00000000b
                       1091
0549'  00              1092          defb    00000000b       ; code 24       $
054A'  10              1093          defb    00010000b
054B'  7C              1094          defb    01111100b
054C'  50              1095          defb    01010000b
054D'  7C              1096          defb    01111100b
054E'  14              1097          defb    00010100b
054F'  7C              1098          defb    01111100b
0550'  10              1099          defb    00010000b
                       1100
0551'  00              1101          defb    00000000b       ; code 25       %
0552'  64              1102          defb    01100100b
0553'  68              1103          defb    01101000b
0554'  10              1104          defb    00010000b
0555'  10              1105          defb    00010000b
0556'  2C              1106          defb    00101100b
0557'  4C              1107          defb    01001100b
0558'  00              1108          defb    00000000b
                       1109
0559'  00              1110          defb    00000000b       ; code 26       &
055A'  10              1111          defb    00010000b
055B'  28              1112          defb    00101000b
055C'  10              1113          defb    00010000b
055D'  2C              1114          defb    00101100b
```

> *Transcriber's note:* Header subtitle `CHAR.SET FOR 40/80 COL.MODES   CHST80.SRC`. Every object byte agrees with its binary operand.

<!-- PDF page 41 — listing "Page 12-6" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
055E'  48              1115          defb    01001000b
055F'  34              1116          defb    00110100b
0560'  00              1117          defb    00000000b
                       1118
0561'  00              1119          defb    00000000b       ; code 27       '
0562'  10              1120          defb    00010000b
0563'  20              1121          defb    00100000b
0564'  00              1122          defb    00000000b
0565'  00              1123          defb    00000000b
0566'  00              1124          defb    00000000b
0567'  00              1125          defb    00000000b
0568'  00              1126          defb    00000000b
                       1127
0569'  00              1128          defb    00000000b       ; code 28       (
056A'  08              1129          defb    00001000b
056B'  10              1130          defb    00010000b
056C'  10              1131          defb    00010000b
056D'  10              1132          defb    00010000b
056E'  10              1133          defb    00010000b
056F'  08              1134          defb    00001000b
0570'  00              1135          defb    00000000b
                       1136
0571'  00              1137          defb    00000000b       ; code 29       )
0572'  20              1138          defb    00100000b
0573'  10              1139          defb    00010000b
0574'  10              1140          defb    00010000b
0575'  10              1141          defb    00010000b
0576'  10              1142          defb    00010000b
0577'  20              1143          defb    00100000b
0578'  00              1144          defb    00000000b
                       1145
0579'  00              1146          defb    00000000b       ; code 2A       *
057A'  00              1147          defb    00000000b
057B'  28              1148          defb    00101000b
057C'  10              1149          defb    00010000b
057D'  7C              1150          defb    01111100b
057E'  10              1151          defb    00010000b
057F'  28              1152          defb    00101000b
0580'  00              1153          defb    00000000b
                       1154
0581'  00              1155          defb    00000000b       ; code 2B       +
0582'  00              1156          defb    00000000b
0583'  10              1157          defb    00010000b
0584'  10              1158          defb    00010000b
0585'  7C              1159          defb    01111100b
0586'  10              1160          defb    00010000b
0587'  10              1161          defb    00010000b
0588'  00              1162          defb    00000000b
                       1163
0589'  00              1164          defb    00000000b       ; code 2C       ,
058A'  00              1165          defb    00000000b
058B'  00              1166          defb    00000000b
```

> *Transcriber's note:* On line 1137 there is a small dash-like speck just right of the object byte `00`. It is not part of the listing. Every object byte agrees with its binary operand.

<!-- PDF page 42 — listing "Page 12-7" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
058C'  00              1167          defb    00000000b
058D'  00              1168          defb    00000000b
058E'  10              1169          defb    00010000b
058F'  10              1170          defb    00010000b
0590'  20              1171          defb    00100000b
                       1172
0591'  00              1173          defb    00000000b       ; code 2D       -
0592'  00              1174          defb    00000000b
0593'  00              1175          defb    00000000b
0594'  00              1176          defb    00000000b
0595'  7C              1177          defb    01111100b
0596'  00              1178          defb    00000000b
0597'  00              1179          defb    00000000b
0598'  00              1180          defb    00000000b
                       1181
0599'  00              1182          defb    00000000b       ; code 2E       .
059A'  00              1183          defb    00000000b
059B'  00              1184          defb    00000000b
059C'  00              1185          defb    00000000b
059D'  00              1186          defb    00000000b
059E'  30              1187          defb    00110000b
059F'  30              1188          defb    00110000b
05A0'  00              1189          defb    00000000b
                       1190
05A1'  00              1191          defb    00000000b       ; code 2F       /
05A2'  00              1192          defb    00000000b
05A3'  04              1193          defb    00000100b
05A4'  08              1194          defb    00001000b
05A5'  10              1195          defb    00010000b
05A6'  20              1196          defb    00100000b
05A7'  40              1197          defb    01000000b
05A8'  00              1198          defb    00000000b
                       1199
05A9'  00              1200          defb    00000000b       ; code 30       0
05AA'  38              1201          defb    00111000b
05AB'  4C              1202          defb    01001100b
05AC'  54              1203          defb    01010100b
05AD'  54              1204          defb    01010100b
05AE'  64              1205          defb    01100100b
05AF'  38              1206          defb    00111000b
05B0'  00              1207          defb    00000000b
                       1208
05B1'  00              1209          defb    00000000b       ; code 31       1
05B2'  30              1210          defb    00110000b
05B3'  50              1211          defb    01010000b
05B4'  10              1212          defb    00010000b
05B5'  10              1213          defb    00010000b
05B6'  10              1214          defb    00010000b
05B7'  7C              1215          defb    01111100b
05B8'  00              1216          defb    00000000b
                       1217
05B9'  00              1218          defb    00000000b       ; code 32       2
```

> *Transcriber's note:* Every object byte agrees with its binary operand. The page ends on the first row of `code 32` (line 1218), and the character continues on the next page.

<!-- PDF page 43 — listing "Page 12-8" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
05BA'  38              1219          defb    00111000b
05BB'  44              1220          defb    01000100b
05BC'  04              1221          defb    00000100b
05BD'  38              1222          defb    00111000b
05BE'  40              1223          defb    01000000b
05BF'  7C              1224          defb    01111100b
05C0'  00              1225          defb    00000000b
                       1226
05C1'  00              1227          defb    00000000b       ; code 33       3
05C2'  38              1228          defb    00111000b
05C3'  44              1229          defb    01000100b
05C4'  18              1230          defb    00011000b
05C5'  04              1231          defb    00000100b
05C6'  44              1232          defb    01000100b
05C7'  38              1233          defb    00111000b
05C8'  00              1234          defb    00000000b
                       1235
05C9'  00              1236          defb    00000000b       ; code 34       4
05CA'  08              1237          defb    00001000b
05CB'  18              1238          defb    00011000b
05CC'  28              1239          defb    00101000b
05CD'  48              1240          defb    01001000b
05CE'  7C              1241          defb    01111100b
05CF'  08              1242          defb    00001000b
05D0'  00              1243          defb    00000000b
                       1244
05D1'  00              1245          defb    00000000b       ; code 35       5
05D2'  7C              1246          defb    01111100b
05D3'  40              1247          defb    01000000b
05D4'  78              1248          defb    01111000b
05D5'  04              1249          defb    00000100b
05D6'  44              1250          defb    01000100b
05D7'  38              1251          defb    00111000b
05D8'  00              1252          defb    00000000b
                       1253
05D9'  00              1254          defb    00000000b       ; code 36       6
05DA'  38              1255          defb    00111000b
05DB'  40              1256          defb    01000000b
05DC'  78              1257          defb    01111000b
05DD'  44              1258          defb    01000100b
05DE'  44              1259          defb    01000100b
05DF'  38              1260          defb    00111000b
05E0'  00              1261          defb    00000000b
                       1262
05E1'  00              1263          defb    00000000b       ; code 37       7
05E2'  7C              1264          defb    01111100b
05E3'  04              1265          defb    00000100b
05E4'  08              1266          defb    00001000b
05E5'  10              1267          defb    00010000b
05E6'  20              1268          defb    00100000b
05E7'  20              1269          defb    00100000b
05E8'  00              1270          defb    00000000b
```

> *Transcriber's note:* The source on these character-set pages is printed in lower case (`defb`, `; code 33`) and is copied that way. On the page each `defb` has a single space before its operand; it is re-spaced here to the standard columns. The comment on the first byte of each character gives its hex code, then the character itself 16 columns after the `;` (consistent with a tab stop), and that spacing is kept. The page opens partway through the character for code 32 (`2`): lines 1219–1225 are its last seven rows; its first row is on the previous page. All 52 lines are clearly legible.

<!-- PDF page 44 — listing "Page 12-9" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       1271
05E9'  00              1272          defb    00000000b       ; code 38       8
05EA'  38              1273          defb    00111000b
05EB'  44              1274          defb    01000100b
05EC'  38              1275          defb    00111000b
05ED'  44              1276          defb    01000100b
05EE'  44              1277          defb    01000100b
05EF'  38              1278          defb    00111000b
05F0'  00              1279          defb    00000000b
                       1280
05F1'  00              1281          defb    00000000b       ; code 39       9
05F2'  38              1282          defb    00111000b
05F3'  44              1283          defb    01000100b
05F4'  44              1284          defb    01000100b
05F5'  3C              1285          defb    00111100b
05F6'  04              1286          defb    00000100b
05F7'  38              1287          defb    00111000b
05F8'  00              1288          defb    00000000b
                       1289
05F9'  00              1290          defb    00000000b       ; code 3A       :
05FA'  00              1291          defb    00000000b
05FB'  00              1292          defb    00000000b
05FC'  10              1293          defb    00010000b
05FD'  00              1294          defb    00000000b
05FE'  00              1295          defb    00000000b
05FF'  10              1296          defb    00010000b
0600'  00              1297          defb    00000000b
                       1298
0601'  00              1299          defb    00000000b       ; code 3B       ;
0602'  00              1300          defb    00000000b
0603'  10              1301          defb    00010000b
0604'  00              1302          defb    00000000b
0605'  00              1303          defb    00000000b
0606'  10              1304          defb    00010000b
0607'  10              1305          defb    00010000b
0608'  20              1306          defb    00100000b
                       1307
0609'  00              1308          defb    00000000b       ; code 3C       <
060A'  00              1309          defb    00000000b
060B'  08              1310          defb    00001000b
060C'  10              1311          defb    00010000b
060D'  20              1312          defb    00100000b
060E'  10              1313          defb    00010000b
060F'  08              1314          defb    00001000b
0610'  00              1315          defb    00000000b
                       1316
0611'  00              1317          defb    00000000b       ; code 3D       =
0612'  00              1318          defb    00000000b
0613'  00              1319          defb    00000000b
0614'  7C              1320          defb    01111100b
0615'  00              1321          defb    00000000b
0616'  7C              1322          defb    01111100b
```

> *Transcriber's note:* All lines are clearly legible.

<!-- PDF page 45 — listing "Page 12-10" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0617'  00              1323          defb    00000000b
0618'  00              1324          defb    00000000b
                       1325
0619'  00              1326          defb    00000000b       ; code 3E       >
061A'  00              1327          defb    00000000b
061B'  20              1328          defb    00100000b
061C'  10              1329          defb    00010000b
061D'  08              1330          defb    00001000b
061E'  10              1331          defb    00010000b
061F'  20              1332          defb    00100000b
0620'  00              1333          defb    00000000b
                       1334
0621'  00              1335          defb    00000000b       ; code 3F       ?
0622'  38              1336          defb    00111000b
0623'  44              1337          defb    01000100b
0624'  08              1338          defb    00001000b
0625'  10              1339          defb    00010000b
0626'  00              1340          defb    00000000b
0627'  10              1341          defb    00010000b
0628'  00              1342          defb    00000000b
                       1343
0629'  00              1344          defb    00000000b       ; code 40       @
062A'  38              1345          defb    00111000b
062B'  44              1346          defb    01000100b
062C'  5C              1347          defb    01011100b
062D'  5C              1348          defb    01011100b
062E'  40              1349          defb    01000000b
062F'  3C              1350          defb    00111100b
0630'  00              1351          defb    00000000b
                       1352
0631'  00              1353          defb    00000000b       ; code 41       A
0632'  38              1354          defb    00111000b
0633'  44              1355          defb    01000100b
0634'  44              1356          defb    01000100b
0635'  7C              1357          defb    01111100b
0636'  44              1358          defb    01000100b
0637'  44              1359          defb    01000100b
0638'  00              1360          defb    00000000b
                       1361
0639'  00              1362          defb    00000000b       ; code 42       B
063A'  78              1363          defb    01111000b
063B'  44              1364          defb    01000100b
063C'  78              1365          defb    01111000b
063D'  44              1366          defb    01000100b
063E'  44              1367          defb    01000100b
063F'  78              1368          defb    01111000b
0640'  00              1369          defb    00000000b
                       1370
0641'  00              1371          defb    00000000b       ; code 43       C
0642'  38              1372          defb    00111000b
0643'  44              1373          defb    01000100b
0644'  40              1374          defb    01000000b
```

> *Transcriber's note:* The page opens with the last two rows of code 3D (`=`), lines 1323–1324. All lines are clearly legible.

<!-- PDF page 46 — listing "Page 12-11" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0645'  40              1375          defb    01000000b
0646'  44              1376          defb    01000100b
0647'  38              1377          defb    00111000b
0648'  00              1378          defb    00000000b
                       1379
0649'  00              1380          defb    00000000b       ; code 44       D
064A'  70              1381          defb    01110000b
064B'  48              1382          defb    01001000b
064C'  44              1383          defb    01000100b
064D'  44              1384          defb    01000100b
064E'  48              1385          defb    01001000b
064F'  70              1386          defb    01110000b
0650'  00              1387          defb    00000000b
                       1388
0651'  00              1389          defb    00000000b       ; code 45       E
0652'  7C              1390          defb    01111100b
0653'  40              1391          defb    01000000b
0654'  78              1392          defb    01111000b
0655'  40              1393          defb    01000000b
0656'  40              1394          defb    01000000b
0657'  7C              1395          defb    01111100b
0658'  00              1396          defb    00000000b
                       1397
0659'  00              1398          defb    00000000b       ; code 46       F
065A'  7C              1399          defb    01111100b
065B'  40              1400          defb    01000000b
065C'  78              1401          defb    01111000b
065D'  40              1402          defb    01000000b
065E'  40              1403          defb    01000000b
065F'  40              1404          defb    01000000b
0660'  00              1405          defb    00000000b
                       1406
0661'  00              1407          defb    00000000b       ; code 47       G
0662'  38              1408          defb    00111000b
0663'  44              1409          defb    01000100b
0664'  40              1410          defb    01000000b
0665'  5C              1411          defb    01011100b
0666'  44              1412          defb    01000100b
0667'  38              1413          defb    00111000b
0668'  00              1414          defb    00000000b
                       1415
0669'  00              1416          defb    00000000b       ; code 48       H
066A'  44              1417          defb    01000100b
066B'  44              1418          defb    01000100b
066C'  7C              1419          defb    01111100b
066D'  44              1420          defb    01000100b
066E'  44              1421          defb    01000100b
066F'  44              1422          defb    01000100b
0670'  00              1423          defb    00000000b
                       1424
0671'  00              1425          defb    00000000b       ; code 49       I
0672'  7C              1426          defb    01111100b
```

> *Transcriber's note:* All lines are clearly legible.

<!-- PDF page 47 — listing "Page 12-12" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0673'  10              1427          defb    00010000b
0674'  10              1428          defb    00010000b
0675'  10              1429          defb    00010000b
0676'  10              1430          defb    00010000b
0677'  7C              1431          defb    01111100b
0678'  00              1432          defb    00000000b
                       1433
0679'  00              1434          defb    00000000b       ; code 4A       J
067A'  04              1435          defb    00000100b
067B'  04              1436          defb    00000100b
067C'  04              1437          defb    00000100b
067D'  44              1438          defb    01000100b
067E'  44              1439          defb    01000100b
067F'  3C              1440          defb    00111100b
0680'  00              1441          defb    00000000b
                       1442
0681'  00              1443          defb    00000000b       ; code 4B       K
0682'  48              1444          defb    01001000b
0683'  50              1445          defb    01010000b
0684'  60              1446          defb    01100000b
0685'  50              1447          defb    01010000b
0686'  48              1448          defb    01001000b
0687'  44              1449          defb    01000100b
0688'  00              1450          defb    00000000b
                       1451
0689'  00              1452          defb    00000000b       ; code 4C       L
068A'  40              1453          defb    01000000b
068B'  40              1454          defb    01000000b
068C'  40              1455          defb    01000000b
068D'  40              1456          defb    01000000b
068E'  40              1457          defb    01000000b
068F'  7C              1458          defb    01111100b
0690'  00              1459          defb    00000000b
                       1460
0691'  00              1461          defb    00000000b       ; code 4D       M
0692'  44              1462          defb    01000100b
0693'  6C              1463          defb    01101100b
0694'  54              1464          defb    01010100b
0695'  44              1465          defb    01000100b
0696'  44              1466          defb    01000100b
0697'  44              1467          defb    01000100b
0698'  00              1468          defb    00000000b
                       1469
0699'  00              1470          defb    00000000b       ; code 4E       N
069A'  44              1471          defb    01000100b
069B'  64              1472          defb    01100100b
069C'  54              1473          defb    01010100b
069D'  54              1474          defb    01010100b
069E'  4C              1475          defb    01001100b
069F'  44              1476          defb    01000100b
06A0'  00              1477          defb    00000000b
                       1478
```

> *Transcriber's note:* The page opens with the last six rows of code 49 (`I`). All lines are clearly legible.

<!-- PDF page 48 — listing "Page 12-13" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
06A1'  00              1479          defb    00000000b       ; code 4F       O
06A2'  38              1480          defb    00111000b
06A3'  44              1481          defb    01000100b
06A4'  44              1482          defb    01000100b
06A5'  44              1483          defb    01000100b
06A6'  44              1484          defb    01000100b
06A7'  38              1485          defb    00111000b
06A8'  00              1486          defb    00000000b
                       1487
06A9'  00              1488          defb    00000000b       ; code 50       P
06AA'  78              1489          defb    01111000b
06AB'  44              1490          defb    01000100b
06AC'  44              1491          defb    01000100b
06AD'  78              1492          defb    01111000b
06AE'  40              1493          defb    01000000b
06AF'  40              1494          defb    01000000b
06B0'  00              1495          defb    00000000b
                       1496
06B1'  00              1497          defb    00000000b       ; code 51       Q
06B2'  38              1498          defb    00111000b
06B3'  44              1499          defb    01000100b
06B4'  44              1500          defb    01000100b
06B5'  44              1501          defb    01000100b
06B6'  54              1502          defb    01010100b
06B7'  38              1503          defb    00111000b
06B8'  00              1504          defb    00000000b
                       1505
06B9'  00              1506          defb    00000000b       ; code 52       R
06BA'  78              1507          defb    01111000b
06BB'  44              1508          defb    01000100b
06BC'  44              1509          defb    01000100b
06BD'  78              1510          defb    01111000b
06BE'  48              1511          defb    01001000b
06BF'  44              1512          defb    01000100b
06C0'  00              1513          defb    00000000b
                       1514
06C1'  00              1515          defb    00000000b       ; code 53       S
06C2'  38              1516          defb    00111000b
06C3'  40              1517          defb    01000000b
06C4'  38              1518          defb    00111000b
06C5'  04              1519          defb    00000100b
06C6'  44              1520          defb    01000100b
06C7'  38              1521          defb    00111000b
06C8'  00              1522          defb    00000000b
                       1523
06C9'  00              1524          defb    00000000b       ; code 54       T
06CA'  7C              1525          defb    01111100b
06CB'  10              1526          defb    00010000b
06CC'  10              1527          defb    00010000b
06CD'  10              1528          defb    00010000b
06CE'  10              1529          defb    00010000b
06CF'  10              1530          defb    00010000b
```

> *Transcriber's note:* A thin curved stroke runs down between the OBJ and LINE columns beside lines 1519–1524. It looks like a hair or fibre on the scanner glass, not handwriting, and it touches no characters. The character after `; code 4F` is the letter `O`.

<!-- PDF page 49 — listing "Page 12-14" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
06D0'  00              1531          defb    00000000b
                       1532
06D1'  00              1533          defb    00000000b       ; code 55       U
06D2'  44              1534          defb    01000100b
06D3'  44              1535          defb    01000100b
06D4'  44              1536          defb    01000100b
06D5'  44              1537          defb    01000100b
06D6'  44              1538          defb    01000100b
06D7'  38              1539          defb    00111000b
06D8'  00              1540          defb    00000000b
                       1541
06D9'  00              1542          defb    00000000b       ; code 56       V
06DA'  44              1543          defb    01000100b
06DB'  44              1544          defb    01000100b
06DC'  44              1545          defb    01000100b
06DD'  44              1546          defb    01000100b
06DE'  28              1547          defb    00101000b
06DF'  10              1548          defb    00010000b
06E0'  00              1549          defb    00000000b
                       1550
06E1'  00              1551          defb    00000000b       ; code 57       W
06E2'  44              1552          defb    01000100b
06E3'  44              1553          defb    01000100b
06E4'  44              1554          defb    01000100b
06E5'  54              1555          defb    01010100b
06E6'  54              1556          defb    01010100b
06E7'  28              1557          defb    00101000b
06E8'  00              1558          defb    00000000b
                       1559
06E9'  00              1560          defb    00000000b       ; code 58       X
06EA'  44              1561          defb    01000100b
06EB'  28              1562          defb    00101000b
06EC'  10              1563          defb    00010000b
06ED'  10              1564          defb    00010000b
06EE'  28              1565          defb    00101000b
06EF'  44              1566          defb    01000100b
06F0'  00              1567          defb    00000000b
                       1568
06F1'  00              1569          defb    00000000b       ; code 59       Y
06F2'  44              1570          defb    01000100b
06F3'  44              1571          defb    01000100b
06F4'  28              1572          defb    00101000b
06F5'  10              1573          defb    00010000b
06F6'  10              1574          defb    00010000b
06F7'  10              1575          defb    00010000b
06F8'  00              1576          defb    00000000b
                       1577
06F9'  00              1578          defb    00000000b       ; code 5A       Z
06FA'  7C              1579          defb    01111100b
06FB'  04              1580          defb    00000100b
06FC'  08              1581          defb    00001000b
06FD'  10              1582          defb    00010000b
```

> *Transcriber's note:* A thin curved stroke (hair or fibre, as on the previous page) sweeps under the OBJ byte of line 1570 (`44` at 06F2') and up beside line 1569. The digits are not obscured.

<!-- PDF page 50 — listing "Page 12-15" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
06FE'  20              1583          defb    00100000b
06FF'  7C              1584          defb    01111100b
0700'  00              1585          defb    00000000b
                       1586
0701'  00              1587          defb    00000000b       ; code 5B       [
0702'  38              1588          defb    00111000b
0703'  20              1589          defb    00100000b
0704'  20              1590          defb    00100000b
0705'  20              1591          defb    00100000b
0706'  20              1592          defb    00100000b
0707'  38              1593          defb    00111000b
0708'  00              1594          defb    00000000b
                       1595
0709'  00              1596          defb    00000000b       ; code 5C       \
070A'  00              1597          defb    00000000b
070B'  40              1598          defb    01000000b
070C'  20              1599          defb    00100000b
070D'  10              1600          defb    00010000b
070E'  08              1601          defb    00001000b
070F'  04              1602          defb    00000100b
0710'  00              1603          defb    00000000b
                       1604
0711'  00              1605          defb    00000000b       ; code 5D       ]
0712'  70              1606          defb    01110000b
0713'  10              1607          defb    00010000b
0714'  10              1608          defb    00010000b
0715'  10              1609          defb    00010000b
0716'  10              1610          defb    00010000b
0717'  70              1611          defb    01110000b
0718'  00              1612          defb    00000000b
                       1613
0719'  00              1614          defb    00000000b       ; code 5E       ^
071A'  10              1615          defb    00010000b
071B'  38              1616          defb    00111000b
071C'  54              1617          defb    01010100b
071D'  10              1618          defb    00010000b
071E'  10              1619          defb    00010000b
071F'  10              1620          defb    00010000b
0720'  00              1621          defb    00000000b
                       1622
0721'  00              1623          defb    00000000b       ; code 5F       _
0722'  00              1624          defb    00000000b
0723'  00              1625          defb    00000000b
0724'  00              1626          defb    00000000b
0725'  00              1627          defb    00000000b
0726'  00              1628          defb    00000000b
0727'  00              1629          defb    00000000b
0728'  FC              1630          defb    11111100b
                       1631
0729'  00              1632          defb    00000000b       ; code 60       pound sign
072A'  18              1633          defb    00011000b
072B'  24              1634          defb    00100100b
```

> *Transcriber's note:* The comment for code 60 spells out `pound sign` instead of printing the character. Code 5F's underline row is `FC` (`11111100b`), as printed. A thin curved stroke (hair or fibre) sits in the left margin beside lines 1617–1621, clear of the text.

<!-- PDF page 51 — listing "Page 12-16" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
072C'  70              1635          defb    01110000b
072D'  20              1636          defb    00100000b
072E'  20              1637          defb    00100000b
072F'  7C              1638          defb    01111100b
0730'  00              1639          defb    00000000b
                       1640
0731'  00              1641          defb    00000000b       ; code 61       a
0732'  00              1642          defb    00000000b
0733'  38              1643          defb    00111000b
0734'  04              1644          defb    00000100b
0735'  3C              1645          defb    00111100b
0736'  44              1646          defb    01000100b
0737'  3C              1647          defb    00111100b
0738'  00              1648          defb    00000000b
                       1649
0739'  00              1650          defb    00000000b       ; code 62       b
073A'  20              1651          defb    00100000b
073B'  20              1652          defb    00100000b
073C'  38              1653          defb    00111000b
073D'  24              1654          defb    00100100b
073E'  24              1655          defb    00100100b
073F'  38              1656          defb    00111000b
0740'  00              1657          defb    00000000b
                       1658
0741'  00              1659          defb    00000000b       ; code 63       c
0742'  00              1660          defb    00000000b
0743'  1C              1661          defb    00011100b
0744'  20              1662          defb    00100000b
0745'  20              1663          defb    00100000b
0746'  20              1664          defb    00100000b
0747'  1C              1665          defb    00011100b
0748'  00              1666          defb    00000000b
                       1667
0749'  00              1668          defb    00000000b       ; code 64       d
074A'  08              1669          defb    00001000b
074B'  08              1670          defb    00001000b
074C'  38              1671          defb    00111000b
074D'  48              1672          defb    01001000b
074E'  48              1673          defb    01001000b
074F'  38              1674          defb    00111000b
0750'  00              1675          defb    00000000b
                       1676
0751'  00              1677          defb    00000000b       ; code 65       e
0752'  00              1678          defb    00000000b
0753'  38              1679          defb    00111000b
0754'  44              1680          defb    01000100b
0755'  78              1681          defb    01111000b
0756'  40              1682          defb    01000000b
0757'  3C              1683          defb    00111100b
0758'  00              1684          defb    00000000b
                       1685
0759'  00              1686          defb    00000000b       ; code 66       f
```

> *Transcriber's note:* The print on this page is heavier, and the `e` of `defb` fills in so it looks like `dafb`/`d•fb` on most lines; it is the same `defb` as elsewhere. A thin curved stroke (hair or fibre) runs from beside the OBJ byte of line 1671 down to line 1673, clear of the digits. The page ends after line 1686, the first row of code 66 (`f`); the rest of the sheet is blank.

<!-- PDF page 52 — listing "Page 12-17" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
075A'  10              1687          defb    00010000b
075B'  28              1688          defb    00101000b
075C'  70              1689          defb    01110000b
075D'  20              1690          defb    00100000b
075E'  20              1691          defb    00100000b
075F'  20              1692          defb    00100000b
0760'  00              1693          defb    00000000b
                       1694
0761'  00              1695          defb    00000000b       ; code 67       g
0762'  00              1696          defb    00000000b
0763'  38              1697          defb    00111000b
0764'  48              1698          defb    01001000b
0765'  48              1699          defb    01001000b
0766'  38              1700          defb    00111000b
0767'  08              1701          defb    00001000b
0768'  30              1702          defb    00110000b
                       1703
0769'  00              1704          defb    00000000b       ; code 68       h
076A'  40              1705          defb    01000000b
076B'  40              1706          defb    01000000b
076C'  70              1707          defb    01110000b
076D'  48              1708          defb    01001000b
076E'  48              1709          defb    01001000b
076F'  48              1710          defb    01001000b
0770'  00              1711          defb    00000000b
                       1712
0771'  00              1713          defb    00000000b       ; code 69       i
0772'  10              1714          defb    00010000b
0773'  00              1715          defb    00000000b
0774'  30              1716          defb    00110000b
0775'  10              1717          defb    00010000b
0776'  10              1718          defb    00010000b
0777'  38              1719          defb    00111000b
0778'  00              1720          defb    00000000b
                       1721
0779'  00              1722          defb    00000000b       ; code 6A       j
077A'  08              1723          defb    00001000b
077B'  00              1724          defb    00000000b
077C'  08              1725          defb    00001000b
077D'  08              1726          defb    00001000b
077E'  08              1727          defb    00001000b
077F'  48              1728          defb    01001000b
0780'  30              1729          defb    00110000b
                       1730
0781'  00              1731          defb    00000000b       ; code 6B       k
0782'  20              1732          defb    00100000b
0783'  28              1733          defb    00101000b
0784'  30              1734          defb    00110000b
0785'  30              1735          defb    00110000b
0786'  28              1736          defb    00101000b
0787'  24              1737          defb    00100100b
0788'  00              1738          defb    00000000b
```

> *Transcriber's note:* Codes 66 (tail, from line 1687) through 6B (`g h i j k`). Every `defb` hex byte agrees with its binary operand. Blank lines (no `;`) separate the characters. Throughout these pages `defb` is printed with a single space before its operand; re-spaced here. A hand-drawn pen curve runs down over the LOC/OBJ columns at lines 1699–1702 (0765'–0768'); it obscures nothing. A vertical scanner shadow band runs through the operand column, and the bottom of the page has a dark band; nothing is lost.

<!-- PDF page 53 — listing "Page 12-18" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       1739
0789'  00              1740          defb    00000000b       ; code 6C       l
078A'  20              1741          defb    00100000b
078B'  20              1742          defb    00100000b
078C'  20              1743          defb    00100000b
078D'  20              1744          defb    00100000b
078E'  20              1745          defb    00100000b
078F'  18              1746          defb    00011000b
0790'  00              1747          defb    00000000b
                       1748
0791'  00              1749          defb    00000000b       ; code 6D       m
0792'  00              1750          defb    00000000b
0793'  28              1751          defb    00101000b
0794'  54              1752          defb    01010100b
0795'  54              1753          defb    01010100b
0796'  54              1754          defb    01010100b
0797'  54              1755          defb    01010100b
0798'  00              1756          defb    00000000b
                       1757
0799'  00              1758          defb    00000000b       ; code 6E       n
079A'  00              1759          defb    00000000b
079B'  70              1760          defb    01110000b
079C'  48              1761          defb    01001000b
079D'  48              1762          defb    01001000b
079E'  48              1763          defb    01001000b
079F'  48              1764          defb    01001000b
07A0'  00              1765          defb    00000000b
                       1766
07A1'  00              1767          defb    00000000b       ; code 6F       o
07A2'  00              1768          defb    00000000b
07A3'  38              1769          defb    00111000b
07A4'  44              1770          defb    01000100b
07A5'  44              1771          defb    01000100b
07A6'  44              1772          defb    01000100b
07A7'  38              1773          defb    00111000b
07A8'  00              1774          defb    00000000b
                       1775
07A9'  00              1776          defb    00000000b       ; code 70        p
07AA'  00              1777          defb    00000000b
07AB'  70              1778          defb    01110000b
07AC'  48              1779          defb    01001000b
07AD'  48              1780          defb    01001000b
07AE'  70              1781          defb    01110000b
07AF'  40              1782          defb    01000000b
07B0'  40              1783          defb    01000000b
                       1784
07B1'  00              1785          defb    00000000b       ; code 71        q
07B2'  00              1786          defb    00000000b
07B3'  38              1787          defb    00111000b
07B4'  48              1788          defb    01001000b
07B5'  48              1789          defb    01001000b
07B6'  38              1790          defb    00111000b
```

> *Transcriber's note:* Codes 6C–71 (`l m n o p q`). Every `defb` hex byte agrees with its binary operand. A hand-drawn pen arc sits beside the OBJ column at lines 1747–1752; it obscures nothing. For codes 70 and 71, the character (`p`, `q`) is printed one column further right than on the other lines; that offset is kept here.

<!-- PDF page 54 — listing "Page 12-19" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
07B7'  08              1791          defb    00001000b
07B8'  0C              1792          defb    00001100b
                       1793
07B9'  00              1794          defb    00000000b       ; code 72       r
07BA'  00              1795          defb    00000000b
07BB'  18              1796          defb    00011000b
07BC'  20              1797          defb    00100000b
07BD'  20              1798          defb    00100000b
07BE'  20              1799          defb    00100000b
07BF'  20              1800          defb    00100000b
07C0'  00              1801          defb    00000000b
                       1802
07C1'  00              1803          defb    00000000b       ; code 73       s
07C2'  00              1804          defb    00000000b
07C3'  30              1805          defb    00110000b
07C4'  40              1806          defb    01000000b
07C5'  30              1807          defb    00110000b
07C6'  08              1808          defb    00001000b
07C7'  70              1809          defb    01110000b
07C8'  00              1810          defb    00000000b
                       1811
07C9'  00              1812          defb    00000000b       ; code 74       t
07CA'  20              1813          defb    00100000b
07CB'  70              1814          defb    01110000b
07CC'  20              1815          defb    00100000b
07CD'  20              1816          defb    00100000b
07CE'  20              1817          defb    00100000b
07CF'  18              1818          defb    00011000b
07D0'  00              1819          defb    00000000b
                       1820
07D1'  00              1821          defb    00000000b       ; code 75       u
07D2'  00              1822          defb    00000000b
07D3'  48              1823          defb    01001000b
07D4'  48              1824          defb    01001000b
07D5'  48              1825          defb    01001000b
07D6'  48              1826          defb    01001000b
07D7'  30              1827          defb    00110000b
07D8'  00              1828          defb    00000000b
                       1829
07D9'  00              1830          defb    00000000b       ; code 76       v
07DA'  00              1831          defb    00000000b
07DB'  44              1832          defb    01000100b
07DC'  44              1833          defb    01000100b
07DD'  28              1834          defb    00101000b
07DE'  28              1835          defb    00101000b
07DF'  10              1836          defb    00010000b
07E0'  00              1837          defb    00000000b
                       1838
07E1'  00              1839          defb    00000000b       ; code 77       w
07E2'  00              1840          defb    00000000b
07E3'  44              1841          defb    01000100b
07E4'  54              1842          defb    01010100b
```

> *Transcriber's note:* Codes 71 (tail) through 77 (`r s t u v w`). Every `defb` hex byte agrees with its binary operand. The tail end of the pen arc from the previous page shows at the top left. It obscures nothing.

<!-- PDF page 55 — listing "Page 12-20" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
07E5'  54              1843          defb    01010100b
07E6'  54              1844          defb    01010100b
07E7'  28              1845          defb    00101000b
07E8'  00              1846          defb    00000000b
                       1847
07E9'  00              1848          defb    00000000b       ; code 78       x
07EA'  00              1849          defb    00000000b
07EB'  44              1850          defb    01000100b
07EC'  28              1851          defb    00101000b
07ED'  10              1852          defb    00010000b
07EE'  28              1853          defb    00101000b
07EF'  44              1854          defb    01000100b
07F0'  00              1855          defb    00000000b
                       1856
07F1'  00              1857          defb    00000000b       ; code 79       y
07F2'  00              1858          defb    00000000b
07F3'  48              1859          defb    01001000b
07F4'  48              1860          defb    01001000b
07F5'  48              1861          defb    01001000b
07F6'  38              1862          defb    00111000b
07F7'  08              1863          defb    00001000b
07F8'  70              1864          defb    01110000b
                       1865
07F9'  00              1866          defb    00000000b       ; code 7A       z
07FA'  00              1867          defb    00000000b
07FB'  7C              1868          defb    01111100b
07FC'  08              1869          defb    00001000b
07FD'  10              1870          defb    00010000b
07FE'  20              1871          defb    00100000b
07FF'  7C              1872          defb    01111100b
0800'  00              1873          defb    00000000b
                       1874
0801'  00              1875          defb    00000000b       ; code 7B       {
0802'  1C              1876          defb    00011100b
0803'  10              1877          defb    00010000b
0804'  60              1878          defb    01100000b
0805'  10              1879          defb    00010000b
0806'  10              1880          defb    00010000b
0807'  1C              1881          defb    00011100b
0808'  00              1882          defb    00000000b
                       1883
0809'  00              1884          defb    00000000b       ; code 7C       
080A'  10              1885          defb    00010000b
080B'  10              1886          defb    00010000b
080C'  10              1887          defb    00010000b
080D'  10              1888          defb    00010000b
080E'  10              1889          defb    00010000b
080F'  10              1890          defb    00010000b
0810'  00              1891          defb    00000000b
                       1892
0811'  00              1893          defb    00000000b       ; code 7D       }
0812'  70              1894          defb    01110000b
```

> *Transcriber's note:* Codes 77 (tail) through 7D (`x y z { | }`). Every `defb` hex byte agrees with its binary operand. The code 7C character is printed as a solid vertical bar, given here as `|`.

<!-- PDF page 56 — listing "Page 12-21" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0813'  10              1895          defb    00010000b
0814'  08              1896          defb    00001000b
0815'  10              1897          defb    00010000b
0816'  10              1898          defb    00010000b
0817'  70              1899          defb    01110000b
0818'  00              1900          defb    00000000b
                       1901
0819'  00              1902          defb    00000000b       ; code 7E .     ~
081A'  28              1903          defb    00101000b
081B'  50              1904          defb    01010000b
081C'  00              1905          defb    00000000b
081D'  00              1906          defb    00000000b
081E'  00              1907          defb    00000000b
081F'  00              1908          defb    00000000b
0820'  00              1909          defb    00000000b
                       1910
0821'  78              1911          defb    01111000b       ; code 7F       COPYRIGHT
0822'  84              1912          defb    10000100b
0823'  94              1913          defb    10010100b
0824'  A4              1914          defb    10100100b
0825'  A4              1915          defb    10100100b
0826'  94              1916          defb    10010100b
0827'  84              1917          defb    10000100b
0828'  78              1918          defb    01111000b
                       1919
0829'  00              1920  GRPST   defb    00000000b       ; code 80       graphics space
082A'  00              1921          defb    00000000b
082B'  00              1922          defb    00000000b
082C'  00              1923          defb    00000000b
082D'  00              1924          defb    00000000b
082E'  00              1925          defb    00000000b
082F'  00              1926          defb    00000000b
0830'  00              1927          defb    00000000b
                       1928  ;
0831'  1C              1929          defb    00011100b       ; code 81       graphics
0832'  1C              1930          defb    00011100b
0833'  1C              1931          defb    00011100b
0834'  1C              1932          defb    00011100b
0835'  00              1933          defb    00000000b
0836'  00              1934          defb    00000000b
0837'  00              1935          defb    00000000b
0838'  00              1936          defb    00000000b
                       1937  ;
                       1938
0839'  E0              1939          defb    11100000b       ; code 82       graphics
083A'  E0              1940          defb    11100000b
083B'  E0              1941          defb    11100000b
083C'  E0              1942          defb    11100000b
083D'  00              1943          defb    00000000b
083E'  00              1944          defb    00000000b
083F'  00              1945          defb    00000000b
0840'  00              1946          defb    00000000b
```

> *Transcriber's note:* Codes 7D (tail), 7E (`~`), 7F (`COPYRIGHT`, the © glyph) and the start of the graphics block: `GRPST` (code 80, 0829') and codes 81–82. Every `defb` hex byte agrees with its binary operand. Line 1902 is printed `; code 7E .`, with a full stop before the `~`; kept. From line 1928 on, the separators between characters become `;` lines rather than blank lines (1938 is blank). The graphics patterns here are 6 pixels wide (`00011100b` / `11100000b` / `11111100b`), unlike the 8-pixel `0F`/`F0`/`FF` patterns in ASC 004.

<!-- PDF page 57 — listing "Page 12-22" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       1947
0841'  FC              1948          defb    11111100b       ; code 83       graphics
0842'  FC              1949          defb    11111100b
0843'  FC              1950          defb    11111100b
0844'  FC              1951          defb    11111100b
0845'  00              1952          defb    00000000b
0846'  00              1953          defb    00000000b
0847'  00              1954          defb    00000000b
0848'  00              1955          defb    00000000b
                       1956
                       1957  ;
0849'  00              1958          defb    00000000b       ; code 84       graphics
084A'  00              1959          defb    00000000b
084B'  00              1960          defb    00000000b
084C'  00              1961          defb    00000000b
084D'  1C              1962          defb    00011100b
084E'  1C              1963          defb    00011100b
084F'  1C              1964          defb    00011100b
0850'  1C              1965          defb    00011100b
                       1966  ;
0851'  1C              1967          defb    00011100b       ; code 85       graphics
0852'  1C              1968          defb    00011100b
0853'  1C              1969          defb    00011100b
0854'  1C              1970          defb    00011100b
0855'  1C              1971          defb    00011100b
0856'  1C              1972          defb    00011100b
0857'  1C              1973          defb    00011100b
0858'  1C              1974          defb    00011100b
                       1975
                       1976
0859'  E0              1977          defb    11100000b       ; code 86        graphics
085A'  E0              1978          defb    11100000b
085B'  E0              1979          defb    11100000b
085C'  E0              1980          defb    11100000b
085D'  1C              1981          defb    00011100b
085E'  1C              1982          defb    00011100b
085F'  1C              1983          defb    00011100b
0860'  1C              1984          defb    00011100b
                       1985  ;
0861'  FC              1986          defb    11111100b       ;code 87        graphics
0862'  FC              1987          defb    11111100b
0863'  FC              1988          defb    11111100b
0864'  FC              1989          defb    11111100b
0865'  1C              1990          defb    00011100b
0866'  1C              1991          defb    00011100b
0867'  1C              1992          defb    00011100b
0868'  1C              1993          defb    00011100b
                       1994  ;
0869'  00              1995          defb    00000000b       ; code 88       graphics
086A'  00              1996          defb    00000000b
086B'  00              1997          defb    00000000b
086C'  00              1998          defb    00000000b
```

> *Transcriber's note:* Codes 83–88, graphics. Every `defb` hex byte agrees with its binary operand. Lines 1947, 1956, 1975 and 1976 are blank, and 1957, 1966, 1985 and 1994 are `;`. Line 1986 is printed `;code 87`, with no space. For code 86, `graphics` is printed one column further right than on the other lines; that offset is kept here.

<!-- PDF page 58 — listing "Page 12-23" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
086D'  E0              1999          defb    11100000b
086E'  E0              2000          defb    11100000b
086F'  E0              2001          defb    11100000b
0870'  E0              2002          defb    11100000b
                       2003  ;
0871'  1C              2004          defb    00011100b       ; code 89        graphics
0872'  1C              2005          defb    00011100b
0873'  1C              2006          defb    00011100b
0874'  1C              2007          defb    00011100b
0875'  E0              2008          defb    11100000b
0876'  E0              2009          defb    11100000b
0877'  E0              2010          defb    11100000b
0878'  E0              2011          defb    11100000b
                       2012  ;
0879'  E0              2013          defb    11100000b       ; code 8A       graphics
087A'  E0              2014          defb    11100000b
087B'  E0              2015          defb    11100000b
087C'  E0              2016          defb    11100000b
087D'  E0              2017          defb    11100000b
087E'  E0              2018          defb    11100000b
087F'  E0              2019          defb    11100000b
0880'  E0              2020          defb    11100000b
                       2021  ;
0881'  FC              2022          defb    11111100b       ; code 8B       graphics
0882'  FC              2023          defb    11111100b
0883'  FC              2024          defb    11111100b
0884'  FC              2025          defb    11111100b
0885'  E0              2026          defb    11100000b
0886'  E0              2027          defb    11100000b
0887'  E0              2028          defb    11100000b
0888'  E0              2029          defb    11100000b
                       2030  ;
0889'  00              2031          defb    00000000b       ; code 8C       graphics
088A'  00              2032          defb    00000000b
088B'  00              2033          defb    00000000b
088C'  00              2034          defb    00000000b
088D'  FC              2035          defb    11111100b
088E'  FC              2036          defb    11111100b
088F'  FC              2037          defb    11111100b
0890'  FC              2038          defb    11111100b
                       2039  ;
0891'  1C              2040          defb    00011100b       ; code 8D       graphics
0892'  1C              2041          defb    00011100b
0893'  1C              2042          defb    00011100b
0894'  1C              2043          defb    00011100b
0895'  FC              2044          defb    11111100b
0896'  FC              2045          defb    11111100b
0897'  FC              2046          defb    11111100b
0898'  FC              2047          defb    11111100b
                       2048  ;
0899'  E0              2049          defb    11100000b       ;code 8E        graphics
089A'  E0              2050          defb    11100000b
```

> *Uncertain:* line 2021 is a `;` followed by a small dot (`;.`). The dot looks like a speck rather than a printed character, so it is omitted.

> *Transcriber's note:* Codes 88 (tail) through 8E, graphics. Every `defb` hex byte agrees with its binary operand. Line 2049 is printed `;code 8E`, with no space. For code 89, `graphics` is printed one column further right than on the other lines; that offset is kept here.

<!-- PDF page 59 — listing "Page 12-24" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC -->

```text
LOC    OBJ            LINE  SOURCE
089B'  E0              2051          defb    11100000b
089C'  E0              2052          defb    11100000b
089D'  FC              2053          defb    11111100b
089E'  FC              2054          defb    11111100b
089F'  FC              2055          defb    11111100b
08A0'  FC              2056          defb    11111100b
                       2057  ;
08A1'  FC              2058          defb    11111100b       ;code 8F        graphics
08A2'  FC              2059          defb    11111100b
08A3'  FC              2060          defb    11111100b
08A4'  FC              2061          defb    11111100b
08A5'  FC              2062          defb    11111100b
08A6'  FC              2063          defb    11111100b
08A7'  FC              2064          defb    11111100b
08A8'  FC              2065          defb    11111100b
                       2066          END
Additional input after END statement ignored
```

> *Transcriber's note:* Codes 8E (tail) and 8F. Every `defb` hex byte agrees with its binary operand. Line 2057 is `;`, and line 2066 is `END` (the last byte is 08A8'). The assembler message `Additional input after END statement ignored` is printed flush with the left margin, under the LOC column. It is not a numbered line. The rest of the page is blank. In the header, `CHST80.SRC` has a stray overstrike mark on the `RC`.

<!-- PDF page 60 — listing "Page S-1" — CHAR.SET FOR 40/80 COL.MODES — CHST80.SRC (symbol table) -->

```text
A       Reserved   ATTBYT   0039      ATTMSK   003F      ATTR$P   5C8D      B       Reserved
BOTLN    002D      C       Reserved   CALCAT   04ED      CALCA1   04FB      CALCPO   0457
CALCP2   0479      CHRSET   0429      CHRST    0529      CHTBL    002F      CLINIT   1800
CLRCTL   000C      CLRSB0   024F      CLRSCB   000E IN   CLRSCN   0253 IN   CLRSC0   0269
CLRSC1   027D      CLRSC2   0288      CLRSC3   028C      CLRSC4   028F      CLRSC5   029A
CLRSC7   02CF      CLRSXT   02CB      CONVFM   0447      COORDS   5C7D      CURPOS   0034
D       Reserved   DATAB    0000      DFADRS   0036      DFBIT    003E      E       Reserved
ERRRET   013C      GETAB0   037E      GETATB   001E IN   GETATT   0382 IN   GETCB0   039C
GETCTL   0019      GETCUB   0021 IN   GETCUR   039C IN   GETC1    03B4      GETSTR   040E
GOODRE   013A      GRBLK    0224      GRPHST   0729      GRPST    0829      GRTBL    0031
GTCHAR   02DB IN   GTCHB0   02D7      GTCHRB   001B IN   GTCH1    02F0      GTCH2    02F4
GTCH22   02FA      GTCH23   0310      GTCH3    0315      GTCH31   0318      GTCH32   0342
GTCH4    034B      GTCH5    0367      GTCH6    0377      GTCSHF   0520      GTC2BC   0513
GTC2B1   0516      GTC2B2   0527      GTINDX   003A      GTSTR1   0419      GTSTR2   0429
H       Reserved   INIT4B   0025 IN   INIT40   03B9 IN   INSDBL   01DA      INVPAR   013F
L       Reserved   LDATTR   04FD      LDPOSN   04A1      LINCOL   0007      LINLEN   0033
LNBU     047E      LOOP     01DE      LOOP0    01E1      LOOP1    01E9      M       Reserved
MARGIN   003D      MASKB    0038      MASK$P   5C8E      NEXT1    00BE      NEXT2    00E6
NEXT3    0106      NOINVE   0113      NORR1    00C5      NORR2    00ED      NORR3    010D
NOSTRG   0431      NOXOR    00CB      PARAM$   5CC3      PARERR   043B      PSW     Reserved
P$FLAG   5C91      RECLEN   1720      SCINIT   1701      SCRCTL   0028      SCRLB    002A IN
SCRLB0   01A2      SCRLCT   002E      SCRLXT   0201      SCRL0    01BC      SCROLL   01A6 IN
SCRSZ    0018      SETCB0   0192      SETCUB   0009 IN   SETCUR   0196 IN   SP      Reserved
SPARE0   0011      SPARE1   0013      SPARE2   0015      SPARE3   0017      SPARE4   0024
STBLK    022C      STBLK0   0230      STBLK1   0231      STPOSN   0499      STRGCT   003B
TESTAD   01CC      TSTPAR   0436      TSTPR1   043F      TVFULQ   0143      TVFUL1   015F
UDG      5C7B      UPDATT   04A9      UPDAT0   04BC      UPDAT1   04CC      UPDAT2   04D8
UPDAT3   04E8      UPDPOS   0452      VARS     5C4B      VIDMOD   5CC2      WRCHAR   0043 IN
WRCHRB   0001 IN   WRCHXT   0137      WRCH0    0040      WRCH01   0046      WRCH11   0065
WRCH12   006D      WRCH13   0071      WRCH14   0087      WRCH15   0088      WRCH2    008E
WRCH3    0099      WRCH5    009F      WRCH6    00AB      WRCH7    0120      WRSTLP   0170
WRSTRB   0004 IN   WRSTRG   016D IN   WRSTR0   0169      WRSTR3   017A      WRSTX1   0183

     No errors detected
```

> *Uncertain:* `CALCPO 0457`: the final character has the square letter-O shape (as in `NOSTRG`/`NOXOR`), not the oval zero, so it is read as the letter O, matching ASC 004. Both readings sort correctly before `CALCP2`. `GETC1 03B4`: the third digit is read as `B` from its flat left side. It also fits the ASC 004 layout, where GETC1 = GETCUR + 18h, and 039C + 18 = 03B4. `NOINVE`: the last letter is read as `E` (the name may have been truncated to six characters).

> *Transcriber's note:* This page is the symbol table, which the listing-line format does not cover. It is given in its printed five-column, row-major layout (32 rows), with no LOC/OBJ header row. `IN` is printed after some values. The names are sorted with letters before digits before `$`, and every row checks against that order. Column 5 is printed slightly lower than columns 1–4 (paper skew). Values check against the listing: GRPST 0829 (line 1920); CHRST 0529 is the code-20 start (0529 + 47h×8 = 0761, code 67 on page 52); GRPHST 0729 = code 60. `CHRSET 0429` and `GTSTR2 0429` share a value, as printed. `GETCB0`/`GETCUR` share 039C, as `GETCB0`/`GETCUR` share 02F1 in ASC 004. No handwriting.
