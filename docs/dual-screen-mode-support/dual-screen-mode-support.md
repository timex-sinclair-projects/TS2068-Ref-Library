# ADL - ASC 004 Dual Screen Mode Support (Timex, 1984)

Transcription of a CRZ80/11 assembler listing of `IODS.SRC`, Timex Application Development Library ASC No. 004, version 002, by C. Corcoran, 22-Feb-84. One section per scan page (38 pages). Each listing line keeps its address (LOC, `'` = relocatable), object code, line number and source. **Read `README.md` first.**

---

<!-- PDF page 1 — listing "Page 1" — VERSION LEVEL CONTROL — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                          1          NAME    ADL - ASC 004 DUAL SCREEN MODE SUPPORT
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
                         15  ;               * NAME: DUAL SCREEN MODE SUPPORT  *
                         16  ;               *                                 *
                         17  ;               * ASC NO:  004                    *
                         18  ;               * VERSION: 002                    *
                         19  ;               * AUTHOR:  C. CORCORAN            *
                         20  ;               * DATE:    2/22/84                 *
                         21  ;               ***********************************
```

> *Transcriber's note:* This is the title page of the listing, but it is printed as listing lines 1–21 (a `NAME` directive and a comment-block banner), so it is transcribed inside the code block. The header's subtitle reads VERSION LEVEL CONTROL, the `SUBTTL` that line 23 sets on the next page. Line 22 is not printed (lines 21 to 23 skip it); it is probably a page-eject directive. In the banner the right-hand `*` on the DATE line (line 20) is printed one column further right than the other right-hand stars, as shown. The page is heavily mottled, but every character is legible.

<!-- PDF page 2 — listing "Page 2" — VERSION LEVEL CONTROL — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                         23          SUBTTL  VERSION LEVEL CONTROL
                         24  ;
                         25  ;
                         26  ;       VERSION         DATE            COMMENTS
                         27  ;       -------         ----            --------
                         28  ;
                         29  ;         001           1/6/84          ORIGINAL
                         30  ;
                         31  ;         002           2/22/84         ADD EXCHANGE RTN.
                         32
```

> *Transcriber's note:* Only lines 23–32 are printed. The rest of the page is blank. Line 33 is not printed; it is probably a page-eject directive.

<!-- PDF page 3 — listing "Page 3" — DEFINITIONS — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                         34          SUBTTL  DEFINITIONS
                         35  ;
                         36  ;
                         37  ;
                         38  ;                     ****DEFINITIONS****
                         39  ;
                         40          INTERN  WRCHAR,WRSTRG,SETCUR,CLRSCN,SCROLL
                         41          INTERN  GTCHAR,GETATT,GETCUR
                         42          INTERN  WRCHRB,WRSTRB,SETCUB,CLRSCB,SCRLB
                         43          INTERN  GTCHRB,GETATB,GETCUB
                         44          INTERN  SETMODE,SETMDB
                         45          INTERN  COPYSC,COPYSB
                         46          INTERN  EXCHSC,EXCHSB
                         47  ;
=0018                    48  SCRSZ   EQU     24              ; 24 LINES
=1701                    49  SCINIT  EQU     1701H           ; SCROLL CONTROL INITIALIZATION
=1800                    50  CLINIT  EQU     1800H           ; CLEAR SCREEN CTL. INIT.
=3C00                    51  CHRSET  EQU     3C00H           ; ROM CHAR.TABLE-100H
=05E0'                   52  GRPHST  EQU     ((GRPST)-100H)  ;STD.GRAPHICS CHARS.
                         53  ;
=0E8E                    54  CHNGVID EQU     0E8EH           ; ROUTINE IN ROM EXTENSION
=1720                    55  RECLEN  EQU     1720H           ; ROUTINE IN HOME ROM
=30F9                    56  ININT   EQU     30F9H           ; ROUTINE IN HOME ROM
=3193                    57  FP2A    EQU     3193H           ; ROUTINE IN HOME ROM
                         58  ;
=00FF                    59  HREXPT  EQU     0FFH            ; HOME ROM EXT.SELECT PORT (BIT 7)
=00F4                    60  DKHSPT  EQU     0F4H            ; DOCK HORIZONTAL SELECT PORT
                         61  ;
=5C4B                    62  VARS    EQU     5C4BH           ; SYSTEM VARIABLES
=5C5D                    63  CH_ADD  EQU     5C5DH           ;
=5C65                    64  STKEND  EQU     5C65H           ;
=5C7B                    65  UDG     EQU     5C7BH           ;
=5C7D                    66  COORDS  EQU     5C7DH           ;
=5C8D                    67  ATTR_P  EQU     5C8DH           ;
=5C8E                    68  MASK_P  EQU     5C8EH           ;
=5C91                    69  P_FLAG  EQU     5C91H           ;
=5CB2                    70  RAMTOP  EQU     5CB2H           ;
=5CB4                    71  PRAMT   EQU     5CB4H           ;
=5CC2                    72  VIDMOD  EQU     5CC2H           ;
=5CC3                    73  PARAM$  EQU     5CC3H           ; (LOCATION 23747)
=6840                    74  DRIVES  EQU     6840H           ;
=12C0                    75  INSERTSZ EQU    7B00H-DRIVES
=0840                    76  MOVESZ  EQU     DRIVES-6000H
=F7C0                    77  DEST7   EQU     0FFFFH-MOVESZ+1
=97C0                    78  FIX     EQU     DEST7-6000H
                         79
=1D00                    80  FIXTBL  EQU     1D00H
                         81
                         82
```

> *Transcriber's note:* On the printed page every `EQU` sits at source column 16, its operand at column 24 and its comment at column 32. Here they are re-spaced to columns 8, 16 and 32 as the conventions require. `INSERTSZ` (line 75) is 8 characters long, so its `EQU` follows one space after the label. Line 52's comment starts one space after its long operand, as printed. Line 36 has a short curved pen stroke to the right of the `;` (handwriting, not text). Line 83 is not printed; it is probably a page-eject directive.

> *Transcriber's note:* The EQU values are consistent: 7B00H−6840H = 12C0, 6840H−6000H = 0840, 0FFFFH−0840H+1 = F7C0, F7C0H−6000H = 97C0, and 5CC3H = 23747. Line 52's value `=05E0'` carries the relocatable mark (GRPST is a relocatable symbol).

<!-- PDF page 4 — listing "Page 4" — INPUTS AND ENTRIES — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                         84          SUBTTL  INPUTS AND ENTRIES
                         85  ;
                         86  ;
                         87  ;
                         88  ;
                         89  ;
                         90  ;
                         91  ;               **PARAMETER INPUTS AND ENTRY POINTS FROM BASIC**
                         92  ;
                         93  ;                                                          WITH
                         94  ;                                                       MODULE LOADED
                         95  ;                                                       AT 57344(E000H)
                         96  ;                                                       DECIMAL ADDRESS
                         97  ;                                                       ---------------
0000'  20                98  DATAB   DEFB    20H             ; DATA BYTE FROM BASIC        57344
0001'  C3 0046'          99  WRCHRB: JP      WRCH0           ; ENTRY TO WRITE CHARACTER    57345
0004'  C3 00EE'         100  WRSTRB: JP      WRSTR0          ; ENTRY TO WRITE STRING       57348
                        101  ;                               ; (see PARAM$ above)
0007'  0000             102  LINCOL  DEFW     0              ; SET CURSOR PARAMETERS
                        103                                  ;   LINCOL=COL. (0-31)        57351
                        104                                  ;   LINCOL+1=LINE (0-23)      57352
0009'  C3 0117'         105  SETCUB: JP      SETCB0          ; ENTRY TO SET CURSOR POSN.   57353
000C'  1800             106  CLRCTL  DEFW    1800H           ; CLEAR SCREEN CONTROLS
                        107                                  ;   CLRCTL=STARTING LINE NO.  57356
                        108                                  ;   CLRCTL+1=LINE COUNT       57357
000E'  C3 01D4'         109  CLRSCB: JP      CLRSB0          ; ENTRY TO CLEAR SCREEN       57358
0011'  0000             110  SPARE0  DEFW     0              ; NOT USED (ALIGNMENT ONLY)
0013'  0000             111  SPARE1  DEFW     0              ;
0015'  0000             112  SPARE2  DEFW     0              ;
0017'  0000             113  SPARE3  DEFW     0              ;
0019'  0000             114  GETCTL  DEFW     0              ; 'GET' CONTROL FROM BASIC    57369
                        115                                  ; FORMAT IS AS FOR LINCOL
001B'  C3 025C'         116  GTCHRB: JP      GTCHB0          ; ENTRY TO GET CHARACTER      57371
001E'  C3 02DC'         117  GETATB: JP      GETAB0          ; ENTRY TO GET ATTRIBUTE      57374
0021'  C3 02F1'         118  GETCUB: JP      GETCB0          ; ENTRY TO GET CURSOR POSN.   57377
0024'  00               119  VIMODE  DEFB     0              ; VIDEO MODE CONTROL          57380
0025'  C3 030E'         120  SETMDB: JP      STMDB0          ; ENTRY TO SET VIDEO MODE     57381
0028'  1701             121  SCRCTL  DEFW     1701H          ; SCROLL CONTROL
                        122                                  ;   SCRCTL=STARTING LINE NO.  57384
                        123                                  ;   SCRCTL+1=LINE COUNT       57385
002A'  C3 0127'         124  SCRLB:  JP      SCRLB0          ; ENTRY TO SCROLL             57386
                        125  ;
                        126  ;COPYSB                         ; ENTRY TO COPY FROM DF       57408
                        127  ;                               ; (SEE NEXT PAGE)
                        128  ;EXCHSB                         ; ENTRY TO EXCHANGE SCREEN    57411
                        129  ;                               ; (SEE NEXT PAGE)
                        130  ;
```

> *Transcriber's note:* On the printed page the opcodes sit at source column 16 and the operands at column 24. Here they are re-spaced to columns 8 and 16. The comments keep column 32, so the right-hand decimal addresses stay at source column 62 as printed. Several operands are printed with a leading space, one column right of the others (`DEFW` ` 0` on lines 102 and 110–114, `DEFB` ` 0` on line 119, and ` 1701H` on line 121). That space is kept.

> *Transcriber's note:* The listing font draws the digit zero as an oval and the letter O as a squared shape. By that test the jump targets end in the digit zero: `WRCH0`, `WRSTR0`, `SETCB0`, `CLRSB0`, `GTCHB0`, `GETAB0`, `GETCB0`, `STMDB0`, `SCRLB0`. This agrees with the label `WRCH0:` defined at 0046' on PDF page 6, which is the target of `C3 0046'` here. Line 101 is printed in lower case, `(see PARAM$ above)`.

> *Transcriber's note:* There is a vertical pen stroke at about source column 10 across lines 90–92 (handwriting). The `I` of `INPUTS` on line 91 is slightly malformed, but it is legible. Line 119 has a tiny speck just left of `DEFB`, which is not a character. Line 131 is not printed; it is probably a page-eject directive.

> *Transcriber's note:* The decimal addresses in the comments all equal 57344 (E000H) + LOC: 0000→57344, 0001→57345, 0004→57348, 0007/0008→57351/57352, 0009→57353, 000C/000D→57356/57357, 000E→57358, 0019→57369, 001B→57371, 001E→57374, 0021→57377, 0024→57380, 0025→57381, 0028/0029→57384/57385, 002A→57386. COPYSB 57408 and EXCHSB 57411 match the 0040'/0043' entries on the next page.

<!-- PDF page 5 — listing "Page 5" — OTHER VARIABLES — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        132          SUBTTL  OTHER VARIABLES
                        133  ;
                        134  ;
                        135  ;
                        136  ;
002D'  17               137  BOTLN   DEFB    17H             ; BOTTOM LINE (LINE AFTER     57389
                        138                                  ; WHICH SCREEN IS CONSIDERED
                        139                                  ; FULL.  AUTOMATIC SCROLL
                        140                                  ; WILL BE DONE IF SCRLCT
                        141                                  ; DOES NOT DECREMENT TO 0.
002E'  01               142  SCRLCT  DEFB    1               ; SCROLL COUNT - 1 PLUS NO.   57390
                        143                                  ; OF TIMES AUTOMATIC SCROLL
                        144                                  ; WILL BE DONE.
                        145  ;
                        146  ;
                        147  ;
                        148  ;
002F'  3C00             149  CHTBL   DEFW    CHRSET          ; ADDRESS OF CHARACTER TABLE  57391
                        150                                  ; (DEFAULTS TO TS2068 SYSTEM
                        151                                  ;  ROM)
0031'  05E0'            152  GRTBL   DEFW    GRPHST          ; ADDRESS OF STD.GRAPHICS TBL.57393
0033'  20               153  LINLEN  DEFB    20H             ; LINE LENGTH (32)            57395
0034'  1821             154  CURPOS  DEFW    1821H           ; CURRENT POSITION (INTERNAL  57396
                        155                                  ;  FORMAT)
0036'  4000             156  DFADRS  DEFW    4000H           ; CURRENT DISPLAY FILE ADDRS. 57398
0038'  00               157  MASKB   DEFB    0               ; MASK TO BE APPLIED TO       57400
                        158                                  ; DISPLAY CHARACTERS
0039'  00               159  ATTBYT  DEFB    0H              ; CURRENT ATTRIBUTES          57401
                        160  ;
003A'  80               161  GTINDX  DEFB    80H             ; INDEX FOR ADJUSTING         57402
                        162                                  ; CH.CODE IN GTCHAR
003B'  0000             163  STRGCT  DEFW    0               ; REMAINING COUNT FROM WRSTRG
                        164  ;                               ; WHEN 'SCREEN FULL'          57403
003D'  0000             165  SPARE4  DEFW    0               ;                             57405
003F'  00               166  ATTMSK  DEFB    0               ; ATTRIBUTE MASK              57407
                        167  ;
0040'  C3 03DA'         168  COPYSB  JP      COPYS0          ; BASIC ENTRY TO COPY DF      57408
0043'  C3 04F5'         169  EXCHSB  JP      EXCHS0          ; BASIC ENTRY TO EXCHANGE DF  57411
```

> *Transcriber's note:* The opcode, operand and comment columns are re-spaced as on page 4; the decimal addresses stay at source column 62. On line 152 the address runs straight on from the comment text (`TBL.57393`), as printed. The decimal address for STRGCT (57403) is printed on line 164, not on line 163. The labels `COPYSB` and `EXCHSB` have no trailing colon, unlike the entry labels on page 4. There is a vertical pen stroke in the left margin beside lines 132–134, plus a small pen curve near the LOC of line 137 (handwriting). Line 170 is not printed; it is probably a page-eject directive.

> *Transcriber's note:* The decimal addresses all equal 57344 + LOC: 002D→57389, 002E→57390, 002F→57391, 0031→57393, 0033→57395, 0034→57396, 0036→57398, 0038→57400, 0039→57401, 003A→57402, 003B→57403, 003D→57405, 003F→57407, 0040→57408, 0043→57411.

<!-- PDF page 6 — listing "Page 6" — WRITE CHARACTER — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        171          SUBTTL  WRITE CHARACTER
                        172  ;
                        173  ;
0046'                   174  WRCH0:                          ; HERE FROM BASIC ENTRY TO DISPLAY THE
                        175                                  ; CHARACTER WHOSE CODE IS IN 'DATAB'
0046'  3A 0000'         176          LD      A,(DATAB)
                        177  ;
0049'                   178  WRCHAR:                         ; ENTRY WITH CODE IN A
0049'  CD 06A2'         179          CALL    LDATTR          ; GET ATTRIBUTE AND MASK CONTROLS
                        180  ;
                        181  ;                               ; ENTRY TO USE ATTRIBUTE VALUES IN
                        182  ;                               ; INTERNAL VARIABLES WITHOUT RELOADING
004C'  CD 065D'         183  WRCH01: CALL    LDPOSN          ; LOAD REGISTERS FOR CURRENT POSITION
                        184                                  ;   BC=CURSOR POSITION FROM 'CURPOS'
                        185                                  ;   HL=DISPLAY FILE ADDRESS FROM 'DFADRS
                        186                                  ;   A=CODE FOR CHAR. TO BE DISPLAYED
004F'  FE 20            187          CP      20H             ; TEST VALID RANGE
0051'  DA 00C4'         188          JP      C,INVPAR        ; < 20H
0054'  FE A5            189          CP      0A5H            ;
0056'  D2 00C4'         190          JP      NC,INVPAR       ; > A4H
0059'  C5               191          PUSH    BC              ; SAVE CURSOR POSITION
005A'  FE 80            192          CP      80H             ; TEST IF ASCII PRINTABLE (20H-7FH)
005C'  38 15            193          JR      C,WRCH12        ; YES
005E'  FE 90            194          CP      90H             ; TEST IF STD.GRAPHICS(80H-8FH)
0060'  38 09            195          JR      C,WRCH11
0062'  ED 4B 5C7B       196          LD      BC,(UDG)        ; USER-DEFINED GRAPHICS(90H-A4H)
0066'  05               197          DEC     B               ; ADJUST ADDRESS-100H
0067'  D6 70            198          SUB     70H             ; ADJUST FOR INDEX INTO TABLE
0069'  18 0C            199          JR      WRCH13
006B'  ED 4B 0031'      200  WRCH11  LD      BC,(GRTBL)      ; ADDRESS OF GRAPHICS TABLE
006F'  D6 60            201          SUB     60H             ; ADJUST FOR INDEX INTO TABLE
0071'  18 04            202          JR      WRCH13
0073'  ED 4B 002F'      203  WRCH12  LD      BC,(CHTBL)      ; CHARACTER TABLE
0077'  EB               204  WRCH13  EX      DE,HL           ; DE=POSN.IN DISPLAY FILE
0078'  26 00            205          LD      H,0
007A'  6F               206          LD      L,A             ; CODE IS INDEX INTO TABLE
007B'  29               207          ADD     HL,HL
007C'  29               208          ADD     HL,HL
007D'  29               209          ADD     HL,HL
007E'  09               210          ADD     HL,BC           ; HL=PIXEL PATTERN IN TABLE
007F'  C1               211          POP     BC
0080'  EB               212          EX      DE,HL
0081'  79               213          LD      A,C             ; TEST IF END OF LINE
0082'  3D               214          DEC     A
0083'  3A 0033'         215          LD      A,(LINLEN)
0086'  20 05            216          JR      NZ,WRCH14
0088'  3C               217          INC     A               ; START OF NEW LINE
0089'  05               218          DEC     B               ; BUMP LINE NO.
008A'  4F               219          LD      C,A             ; LINLEN+1=START OF LINE
008B'  18 01            220          JR      WRCH15
008D'  3C               221  WRCH14  INC     A
008E'  B9               222  WRCH15  CP      C               ; TEST IF START OF LINE
```

> *Transcriber's note:* On this page the opcodes are printed at source column 8 and most operands at column 14 (`A,(DATAB)` on line 176 is at column 13). The operands are re-spaced to column 16; the comments stay at column 32. The local labels `WRCH11`–`WRCH15` have no colon; `WRCH0:`, `WRCHAR:` and `WRCH01:` do. The comment on line 185 is printed without a closing quote (`'DFADRS`). Pen strokes cross the page header through `MODE` and after `IODS.SRC` (handwriting). The listing continues on "Page 6-1".

<!-- PDF page 7 — listing "Page 6-1" — WRITE CHARACTER — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
008F'  D5              223          PUSH    DE
0090'  CC 00C8'        224          CALL    Z,TVFULQ        ; TEST IF OFF SCREEN
0093'  D1              225          POP     DE
                       226                                  ; HERE TO PUT CHARACTER IN DISPLAY FILE
0094'  C5              227  WRCH2   PUSH    BC              ; CURSOR POSITION
0095'  E5              228          PUSH    HL              ; DISPLAY FILE ADRS.
0096'  3A 0038'        229          LD      A,(MASKB)
0099'  06 FF           230          LD      B,-1
009B'  1F              231          RRA
009C'  38 01           232          JR      C,WRCH3         ; IF XORING NEW INTO OLD
009E'  04              233          INC     B               ; B=-1 IF XORING  =0 IF NOT
009F'  1F              234  WRCH3   RRA
00A0'  1F              235          RRA
00A1'  9F              236          SBC     A,A
00A2'  4F              237          LD      C,A             ; C=-1 FOR INVERSE  =0 IF NOT
00A3'  3E 08           238          LD      A,8             ; SCAN COUNT
00A5'  A7              239          AND     A
00A6'  EB              240          EX      DE,HL
00A7'  08              241  WRCH5   EX      AF,AF'
00A8'  1A              242          LD      A,(DE)          ; OLD BIT ROW
00A9'  A0              243          AND     B
00AA'  AE              244          XOR     (HL)
00AB'  A9              245          XOR     C               ; INVERT IF C=-1
00AC'  12              246          LD      (DE),A          ; UPDATE DISPLAY FILE
00AD'  08              247          EX      AF,AF'
00AE'  14              248          INC     D               ; NEXT SCAN
00AF'  23              249          INC     HL              ; NEXT BYTE IN CHAR.FILE
00B0'  3D              250          DEC     A               ; TEST IF MORE SCANS
00B1'  20 F4           251          JR      NZ,WRCH5
00B3'  15              252  WRCH7   DEC     D               ; ADJUST DF ADRS.
00B4'  EB              253          EX      DE,HL           ; DF ADRS. TO HL
00B5'  CD 0665'        254          CALL    UPDATT          ; UPDATE ATTRIBUTE BYTE
00B8'  E1              255          POP     HL              ; STARTING ADDRESS
00B9'  C1              256          POP     BC              ; CURSOR POSITION
00BA'  0D              257          DEC     C               ; ADJUST CURSOR POSITION
00BB'  23              258          INC     HL              ; ADJUST DF ADDRESS
00BC'  CD 0655'        259  WRCHXT  CALL    STPOSN          ; STORE NEW POSITION
00BF'  0E 00           260  GOODRET LD      C,0             ; RETURN BC=0
00C1'  06 00           261  ERRRET  LD      B,0             ; ENTER HERE WITH C NON-ZERO
00C3'  C9              262          RET
                       263  ;
00C4'  0E 01           264  INVPAR  LD      C,1             ; RETURN BC=1 FOR INVALID PARAMETERS
00C6'  18 F9           265          JR      ERRRET
                       266  ;
00C8'  3E 18           267  TVFULQ  LD      A,SCRSZ         ; TEST IF NEW LINE IS OFF SCREEN
00CA'  90              268          SUB     B               ; A=LINE NO.
00CB'  57              269          LD      D,A             ; SAVE IN D
00CC'  3A 002D'        270          LD      A,(BOTLN)       ; GET BOTTOM LINE
00CF'  BA              271          CP      D
00D0'  D2 0628'        272          JP      NC,UPDPOSN      ; ON SCREEN - RETURN TO WRITE CHAR.
                       273                                  ;  VIA UPDATE AND STORE POSITION
00D3'  3A 002E'        274          LD      A,(SCRLCT)      ; TEST SCROLL COUNT
```

> *Uncertain:* line 259 OBJ `0655'` (a stray mark sits between the two 5s, printed like `065,5`; `0655` fits the LOC chain and STPOSN).

> *Transcriber's note:* line 270's comment `; GET BOTTOM LINE` is printed immediately after the operand (`A,(BOTLN) ; GET BOTTOM LINE`); re-spaced to col 32 here per conventions. The foot of the sheet carries the next page's header ("Page 6-2"), from the continuous-form printout.

<!-- PDF page 8 — listing "Page 6-2" — WRITE CHARACTER — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
00D6'  3D              275          DEC     A
00D7'  20 0B           276          JR      NZ,TVFUL1       ; DO AUTOMATIC SCROLL USING SCRCTL
00D9'  3E 01           277          LD      A,1             ; REINITIALIZE TO 1
00DB'  32 002E'        278          LD      (SCRLCT),A
00DE'  C1              279          POP     BC
00DF'  C1              280          POP     BC              ; DISCARD RETURN TO WRITE CHAR.
00E0'  0E 03           281          LD      C,3             ; RETURN BC=3 FOR SCREEN FULL
00E2'  18 DD           282          JR      ERRRET
00E4'  32 002E'        283  TVFUL1  LD      (SCRLCT),A      ; UPDATE VARIABLE
00E7'  ED 4B 0028'     284          LD      BC,(SCRCTL)     ; GET SCROLL CONTROLS (STARTING LINE
                       285                                  ;   AND LINE COUNT)
00EB'  C3 0141'        286          JP      SCRL0           ; RETURN TO WRITE CHAR. VIA SCROLL
                       287  ;
```

> *Uncertain:* line 286 operand `SCRL0` vs `SCRLO` (final glyph read as zero by its shape; consistent with label SCRL0 at 0141', line 366).

> *Transcriber's note:* heavy paper noise across the whole page; lower two-thirds of the sheet is blank.

<!-- PDF page 9 — listing "Page 7" — WRITE STRING — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       289          SUBTTL  WRITE STRING
                       290  ;                               ; HERE FROM BASIC ENTRY TO
                       291  ;                               ; WRITE CHARACTER STRING TO SCREEN.
                       292  ;                               ; STRING IDENTIFIER (CH.CODE) IN
                       293  ;                               ; SYSTEM VARIABLE PARAM$ AT 5CC3H
00EE'  CD 06B8'        294  WRSTR0  CALL    GETSTRG         ; GET STRING VAR.ADRS. TO HL
00F1'  C8              295          RET     Z               ; STRING NOT FOUND OR NULL STRING
                       296  ;                               ; (BC CONTAINS STATUS)
                       297  ;
                       298  ;                               ; ENTRY FROM MACHINE CODE WITH
                       299  ;                               ; ADDRESS OF CHAR.CODE 'STRING'
                       300  ;                               ; IN HL AND LENGTH IN BC
                       301  ;
00F2'  CD 06A2'        302  WRSTRG: CALL    LDATTR          ; GET ATTRIBUTE AND MASK CONTROLS
00F5'  7E              303  WRSTLP  LD      A,(HL)          ; GET CODE
00F6'  E5              304          PUSH    HL              ; SAVE ADDRESS
00F7'  C5              305          PUSH    BC              ; AND COUNT
00F8'  CD 004C'        306          CALL    WRCH01          ; WRITE 'A'
00FB'  79              307          LD      A,C             ; TEST IF GOOD
00FC'  B0              308          OR      B
00FD'  20 09           309          JR      NZ,WRSTX1       ; EXIT IF INVALID CODE OR
                       310  ;                               ; IF SCREEN FULL
00FF'  C1              311  WRSTR3  POP     BC              ; COUNT
0100'  E1              312          POP     HL              ; ADDRESS
0101'  23              313          INC     HL              ; NEXT CHAR.
0102'  0B              314          DEC     BC              ; ADJUST COUNT
0103'  78              315          LD      A,B             ; TEST IF DONE
0104'  B1              316          OR      C
0105'  20 EE           317          JR      NZ,WRSTLP       ; WRITE NEXT CHAR.
0107'  C9              318          RET                     ; RETURN BC=0
                       319  ;
0108'  79              320  WRSTX1  LD      A,C             ; SAVE ERROR
0109'  FE 01           321          CP      1               ; TEST IF UNRECOGNIZED CODE
010B'  28 F2           322          JR      Z,WRSTR3        ; CONTINUE
010D'  E1              323          POP     HL              ; REMAINING COUNT TO HL
010E'  22 003B'        324          LD      (STRGCT),HL     ; STORE REMAINING COUNT
0111'  E1              325          POP     HL              ; ADDRESS TO HL
0112'  0E 03           326          LD      C,3             ; RETURN BC=3
0114'  06 00           327  WRSTX2  LD      B,0
0116'  C9              328          RET
                       329  ;
```

> *Uncertain:* line 294 label `WRSTR0` vs `WRSTRO`; line 306 operand `WRCH01` vs `WRCHO1` (both read as zero by glyph shape).

> *Transcriber's note:* line 288 is not printed (page break). Line 294 operand is printed one space after `CALL` (col 13) and line 302's label carries a colon (`WRSTRG:`); both kept/re-spaced per conventions. Lower half of sheet blank.

<!-- PDF page 10 — listing "Page 8" — POSITION CONTROL — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       331          SUBTTL  POSITION CONTROL
                       332  ;
0117'                  333  SETCB0:                         ; HERE FROM BASIC ENTRY.  PARAMETERS
                       334                                  ; IN LINCOL
0117'  ED 4B 0007'     335          LD      BC,(LINCOL)
                       336  ;
011B'                  337  SETCUR:                         ; ENTRY WITH LINE/COL. IN BC REG.
011B'  CD 060C'        338          CALL    TSTPAR          ; TEST PARAMETERS FOR VALIDITY
011E'  CD 061D'        339          CALL    CONVFM          ; CONVERT TO INTERNAL FORMAT
0121'  CD 0628'        340          CALL    UPDPOSN         ; CALCULATE AND STORE POSITION
0124'  C3 00BF'        341          JP      GOODRET         ; RETURN BC=0
                       342  ;
```

> *Uncertain:* line 335 OBJ `4B` (printed glyph looks closer to `48` through the noise; `ED 4B` is the only encoding of LD BC,(nn) and line 284/350 print `4B` clearly); line 333 label `SETCB0` vs `SETCBO` (read as zero by glyph shape).

> *Transcriber's note:* line 330 not printed (page break). Heavy paper noise; a curved pencil stroke runs down beside the OBJ column (lines 333–340), not part of the listing. Rest of sheet blank.

<!-- PDF page 11 — listing "Page 9" — SCROLL — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       344          SUBTTL  SCROLL
                       345  ;
                       346  ;
                       347  ;
0127'                  348  SCRLB0:                         ; HERE FROM BASIC ENTRY TO SCROLL
                       349  ;                               ; SCREEN
0127'  ED 4B 0028'     350          LD      BC,(SCRCTL)     ; GET CONTROL INFO.
                       351  ;
012B'                  352  SCROLL:                         ; HERE WITH CONTROLS IN BC
                       353                                  ;  B=NO. OF LINES
                       354                                  ;  C=STARTING LINE NO.
012B'  78              355          LD      A,B             ; TEST VALIDITY
012C'  A7              356          AND     A               ;
012D'  CA 00C4'        357          JP      Z,INVPAR        ; ERROR IF COUNT=0
0130'  81              358          ADD     A,C
0131'  FE 01           359          CP      1
0133'  DA 00C4'        360          JP      C,INVPAR        ; ERROR IF B+C<1
0136'  FE 19           361          CP      25
0138'  D2 00C4'        362          JP      NC,INVPAR       ; ERROR IF B+C>24
013B'  CD 0141'        363          CALL    SCRL0           ; DO SCROLL
013E'  C3 00BF'        364          JP      GOODRET         ; RETURN BC=0
                       365  ;
0141'  C5              366  SCRL0   PUSH    BC
0142'  3E 18           367          LD      A,SCRSZ         ; GET STARTING LINE IN INTERNAL FORMAT
0144'  91              368          SUB     C
0145'  47              369          LD      B,A
0146'  3A 0033'        370          LD      A,(LINLEN)
0149'  3C              371          INC     A               ; COL. 0
014A'  4F              372          LD      C,A
014B'  CD 063A'        373          CALL    LNBU
014E'  C1              374          POP     BC
014F'  E5              375          PUSH    HL              ; SAVE STARTING ADRS.
0150'  C5              376          PUSH    BC              ; SAVE ORIG.BC FOR EXIT
0151'  7D              377  TESTAD  LD      A,L             ; TEST IF AT START OF BLOCK
0152'  A7              378          AND     A
0153'  28 5C           379          JR      Z,STBLK         ; YES
0155'  07              380          RLCA
0156'  07              381          RLCA
0157'  07              382          RLCA
0158'  4F              383          LD      C,A             ; GET NO. OF LINES THIS BLOCK
0159'  3E 08           384          LD      A,8
015B'  91              385          SUB     C
015C'  B8              386          CP      B               ; TEST AGAINST TOTAL LINES
015D'  38 4A           387          JR      C,GRBLK         ; TOTAL GREATER THAN THIS BLOCK
015F'  78              388  INSDBLK LD      A,B
0160'  06 00           389          LD      B,0             ; REMAINING COUNT
0162'  C5              390          PUSH    BC
0163'  47              391  LOOP    LD      B,A             ; B=LINES THIS BLOCK
0164'  0E 08           392          LD      C,8             ; C=SCAN COUNT
0166'  78              393  LOOP0   LD      A,B
0167'  C5              394          PUSH    BC              ; SAVE SCAN COUNT
0168'  0F              395          RRCA
```

> *Uncertain:* line 348 label `SCRLB0` vs `SCRLBO`; lines 363/366 `SCRL0` vs `SCRLO`; line 393 label `LOOP0` vs `LOOPO` (all read as zero by glyph shape; the LOC/JR targets are consistent either way).

> *Transcriber's note:* line 343 not printed (page break). Lines 363–364 operands are printed one column further right than usual; re-spaced. A faint pencil curve near the OBJ column at lines 346–350.

<!-- PDF page 12 — listing "Page 9-1" — SCROLL — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0169'  0F              396          RRCA
016A'  0F              397          RRCA                    ; CALCULATE NO. OF BYTES
016B'  4F              398          LD      C,A
016C'  06 00           399          LD      B,0             ; BC=32*# OF LINES
016E'  EB              400  LOOP1   EX      DE,HL
016F'  21 FFE0         401          LD      HL,-20H         ; GET ADRS. OF PREV. LINE
0172'  19              402          ADD     HL,DE
0173'  EB              403          EX      DE,HL           ; TO DE
0174'  E5              404          PUSH    HL              ; DISPLAY FILE ADRS.
0175'  ED B0           405          LDIR                    ; DO MOVE
0177'  E1              406          POP     HL
0178'  24              407          INC     H               ; NEXT SCAN LINE
0179'  C1              408          POP     BC              ; SCAN COUNT
017A'  0D              409          DEC     C
017B'  20 E9           410          JR      NZ,LOOP0        ; MORE SCANS
017D'  C1              411          POP     BC              ; RESIDUAL LINE COUNT
017E'  78              412          LD      A,B
017F'  A7              413          AND     A
0180'  28 04           414          JR      Z,SCRLXT        ; DONE
0182'  2E 00           415          LD      L,0             ; START OF NEXT BLOCK
0184'  18 CB           416          JR      TESTAD          ; DO REMAINING LINE(S)
0186'  C1              417  SCRLXT  POP     BC              ; ORIG.BC
0187'  D1              418          POP     DE              ; STARTING ADRS. TO DE
0188'  C5              419          PUSH    BC              ; SAVE ORIG.BC
0189'  68              420          LD      L,B             ; NO. OF LINES SCROLLED
018A'  26 00           421          LD      H,0             ;
018C'  29              422          ADD     HL,HL           ; 32*NO. OF LINES=
018D'  29              423          ADD     HL,HL           ; NO. OF ATTRIBUTE BYTES
018E'  29              424          ADD     HL,HL           ; TO BE SCROLLED
018F'  29              425          ADD     HL,HL           ;
0190'  29              426          ADD     HL,HL           ;
0191'  44              427          LD      B,H             ; COUNT TO BC
0192'  4D              428          LD      C,L             ;
0193'  62              429          LD      H,D             ; ADRS. TO HL
0194'  6B              430          LD      L,E             ;
0195'  CD 0692'        431          CALL    CALCATT         ; ATTRIBUTE ADRS. TO HL
0198'  EB              432          EX      DE,HL           ;
0199'  21 FFE0         433          LD      HL,-20H         ; ADRS. OF PREV.ATTR.BYTE
019C'  19              434          ADD     HL,DE           ;
019D'  EB              435          EX      DE,HL           ; PREV.BYTE DE
019E'  ED B0           436          LDIR                    ; SCROLL ATTRIBUTES
01A0'  C1              437          POP     BC              ; ORIG. BC
01A1'  79              438          LD      A,C             ; STARTING LINE
01A2'  80              439          ADD     A,B             ; ADD NO. OF LINES MOVED
01A3'  3D              440          DEC     A               ; LAST LINE SCROLLED
01A4'  4F              441          LD      C,A
01A5'  06 01           442          LD      B,1             ; CLEAR 1 LINE
01A7'  18 45           443          JR      CLRSC0          ; CLEAR VACATED LINE AND RETURN
                       444  ;
01A9'  4F              445  GRBLK   LD      C,A
01AA'  78              446          LD      A,B
01AB'  91              447          SUB     C               ; ADJUST TOTAL LINE COUNT BY NO.
```

> *Uncertain:* line 410 operand `LOOP0` vs `LOOPO` (same label as line 393).

> *Transcriber's note:* lines 401 and 433 OBJ `FFE0` carry no relocation mark (absolute constant), as printed. Line 431 operand printed one space after `CALL`; re-spaced. Faint pencil curve near the OBJ column at lines 401–405.


<!-- PDF page 13 — listing "Page 9-2" — SCROLL — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
01AC'  47               448          LD      B,A             ; OF LINES THIS BLOCK
01AD'  C5               449          PUSH    BC
01AE'  79               450          LD      A,C             ; LOAD A NO. OF LINES THIS BLOCK
01AF'  18 B2            451          JR      LOOP
                        452  ;
01B1'  05               453  STBLK   DEC     B               ; ADJUST TOTAL LINE COUNT-1
01B2'  C5               454          PUSH    BC
01B3'  0E 08            455          LD      C,8             ; SCAN COUNT
01B5'  C5               456  STBLK0  PUSH    BC              ; SAVE SCAN COUNT
01B6'  EB               457  STBLK1  EX      DE,HL
01B7'  21 F8E0          458          LD      HL,-720H
01BA'  19               459          ADD     HL,DE
01BB'  EB               460          EX      DE,HL           ; ADRS. OF PREV. LINE
01BC'  01 0020          461          LD      BC,32           ; BYTE COUNT
01BF'  E5               462          PUSH    HL
01C0'  ED B0            463          LDIR                    ; DO MOVE
01C2'  E1               464          POP     HL
01C3'  24               465          INC     H               ; TO NEXT SCAN LINE
01C4'  C1               466          POP     BC
01C5'  0D               467          DEC     C               ; TEST IF MORE SCANS
01C6'  20 ED            468          JR      NZ,STBLK0
01C8'  C1               469          POP     BC              ; REMAINING LINE COUNT
01C9'  78               470          LD      A,B
01CA'  A7               471          AND     A
01CB'  28 B9            472          JR      Z,SCRLXT
01CD'  11 F820          473          LD      DE,-7E0H        ; ADJUST TO LINE 1
01D0'  19               474          ADD     HL,DE
01D1'  C3 0151'         475          JP      TESTAD          ; BC=LINE COUNT
                        476                                  ; HL=DF ADDRESS
                        477  ;
```

> *Transcriber's note:* lines 448–477 only; the rest of the sheet is blank. The bottom edge of the scan shows the header of the next sheet ("Page 10"), which is transcribed under PDF page 14. A stray pen stroke runs between the OBJ and LINE columns beside lines 448–449; it does not touch any characters.

<!-- PDF page 14 — listing "Page 10" — CLEAR SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        479          SUBTTL  CLEAR SCREEN
                        480  ;
                        481  ;
01D4'                   482  CLRSB0:                         ; HERE FROM BASIC ENTRY TO CLEAR SCREEN
01D4'  ED 4B 000C'      483          LD      BC,(CLRCTL)     ; GET CONTROL INFO.
                        484  ;
01D8'                   485  CLRSCN:                         ; ENTRY WITH BC=LINE COUNT AND
                        486                                  ; STARTING LINE NO. FOR CLEAR
01D8'  78               487          LD      A,B
01D9'  A7               488          AND     A               ; TEST VALIDITY
01DA'  CA 00C4'         489          JP      Z,INVPAR        ; ERROR IF COUNT=0
01DD'  81               490          ADD     A,C
01DE'  FE 01            491          CP      1
01E0'  DA 00C4'         492          JP      C,INVPAR        ; ERROR IF B+C<1
01E3'  FE 19            493          CP      25
01E5'  D2 00C4'         494          JP      NC,INVPAR       ; ERROR IF B+C>24
01E8'  CD 01EE'         495          CALL    CLRSC0          ; DO SERVICE
01EB'  C3 00BF'         496          JP      GOODRET         ; RETURN BC=0
                        497  ;
                        498  ;
01EE'  CD 06A2'         499  CLRSC0: CALL    LDATTR          ; GET ATTRIBUTE CTL
01F1'  C5               500          PUSH    BC
01F2'  3E 18            501          LD      A,SCRSZ         ; CONVERT TO INTERNAL FORMAT
01F4'  91               502          SUB     C
01F5'  47               503          LD      B,A
01F6'  3A 0033'         504          LD      A,(LINLEN)
01F9'  3C               505          INC     A               ; SET TO COL.0
01FA'  4F               506          LD      C,A
01FB'  CD 063A'         507          CALL    LNBU            ; GET ADDRESS
01FE'  50               508          LD      D,B
01FF'  59               509          LD      E,C             ; SAVE POSITION
0200'  C1               510          POP     BC              ; ORIG. BC
0201'  D5               511          PUSH    DE              ; SAVE CURSOR POSITION
0202'  7D               512  CLRSC1  LD      A,L             ; GET # OF LINES THIS BLOCK
0203'  07               513          RLCA
0204'  07               514          RLCA
0205'  07               515          RLCA
0206'  4F               516          LD      C,A
0207'  3E 08            517          LD      A,8
0209'  91               518          SUB     C
020A'  B8               519          CP      B               ; COMPARE TO TOTAL LINE COUNT
020B'  38 47            520          JR      C,CLRSC7
020D'  78               521  CLRSC2  LD      A,B             ; NO. OF LINES
020E'  06 00            522          LD      B,0             ; REMAINING LINES
0210'  C5               523          PUSH    BC
0211'  47               524  CLRSC3  LD      B,A
0212'  0E 08            525          LD      C,8             ; SCAN COUNT
0214'  78               526  CLRSC4  LD      A,B
0215'  C5               527          PUSH    BC
0216'  E6 07            528          AND     7
0218'  0F               529          RRCA
0219'  0F               530          RRCA
```

> *Transcriber's note:* line 478 is not printed. The listing goes from 477 on Page 9-2 to 479 here, most likely a PAGE/EJECT directive that the assembler does not list. A short pen stroke sits left of the LINE column beside line 524 and touches nothing. The bottom of the scan shows the next sheet's header ("Page 10-1").

<!-- PDF page 15 — listing "Page 10-1" — CLEAR SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
021A'  0F               531          RRCA
021B'  4F               532          LD      C,A             ; BC=32*NO. OF LINES
021C'  06 00            533          LD      B,0             ; (=0 IF 256 FOR 8 LINES)
021E'  0D               534          DEC     C               ; ADJUST
021F'  E5               535  CLRSC5  PUSH    HL
0220'  54               536          LD      D,H
0221'  5D               537          LD      E,L
0222'  36 00            538          LD      (HL),00         ; CLEAR DF
0224'  13               539          INC     DE
0225'  ED B0            540          LDIR
0227'  E1               541          POP     HL
0228'  24               542          INC     H               ; NEXT SCAN ROW
0229'  C1               543          POP     BC              ; POP SCAN COUNT
022A'  0D               544          DEC     C
022B'  20 E7            545          JR      NZ,CLRSC4
022D'  E5               546          PUSH    HL              ; SAVE NEXT DF ADRS.
022E'  25               547          DEC     H               ; LAST SCAN ROW
022F'  CD 0692'         548          CALL    CALCATT         ; GET ADRS. IN ATTRIBUTE FILE
0232'  78               549          LD      A,B             ; NO. OF LINES THIS BLOCK
0233'  E6 07            550          AND     7
0235'  0F               551          RRCA
0236'  0F               552          RRCA
0237'  0F               553          RRCA
0238'  4F               554          LD      C,A             ; BC=32*NO. OF LINES
0239'  06 00            555          LD      B,0
023B'  0D               556          DEC     C               ; ADJUST
023C'  54               557          LD      D,H
023D'  5D               558          LD      E,L
023E'  3A 0039'         559          LD      A,(ATTBYT)      ; ATTRIBUTE VALUE
0241'  77               560          LD      (HL),A          ; UPDATE ATTRIBUTE FILE
0242'  13               561          INC     DE              ; NEXT BYTE
0243'  ED B0            562          LDIR                    ;
0245'  E1               563          POP     HL              ; DF ADRS.(LAST SCAN+100H)
0246'  C1               564          POP     BC              ; TOTAL LINE COUNT
0247'  78               565          LD      A,B
0248'  A7               566          AND     A
0249'  28 05            567          JR      Z,CLRSXT
024B'  2E 00            568          LD      L,0             ; HL=START OF NEXT BLOCK
024D'  C3 0202'         569          JP      CLRSC1          ; B=REMAINING LINE COUNT
0250'  C1               570  CLRSXT  POP     BC              ; POSITION
0251'  C3 0628'         571          JP      UPDPOSN         ; RETURN VIA UPDATE AND STORE POSITION
0254'  4F               572  CLRSC7  LD      C,A             ; SAVE NO. LINES THIS BLOCK
0255'  78               573          LD      A,B
0256'  91               574          SUB     C               ; ADJUST TOTAL LINE COUNT
0257'  47               575          LD      B,A
0258'  C5               576          PUSH    BC              ; REMAINING LINE COUNT
0259'  79               577          LD      A,C             ; LINES THIS BLOCK
025A'  18 B5            578          JR      CLRSC3          ;
```

> *Transcriber's note:* line 538's operand is printed `(HL),00`, with two zeros. A pen stroke crosses the line numbers 573–575; it touches the digits but they are still clear. The bottom of the scan shows the next sheet's header ("Page 11").

<!-- PDF page 16 — listing "Page 11" — 'GET' ROUTINES — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        580          SUBTTL  'GET' ROUTINES
                        581  ;
                        582  ;
025C'                   583  GTCHB0:                         ; HERE FROM BASIC ENTRY TO GET CHARACTER
                        584                                  ; (RETURNS CODE FOR CHARACTER AT
                        585                                  ;  POSITION SPECIFIED IN GETCTL)
025C'  ED 4B 0019'      586          LD      BC,(GETCTL)     ; GET CONTROL INFO.
                        587  ;
0260'                   588  GTCHAR:                         ; ENTRY WITH POSITION IN BC
0260'  CD 060C'         589          CALL    TSTPAR          ; TEST PARAMETERS
0263'  CD 061D'         590          CALL    CONVFM          ; CONVERT TO INTERNAL FORMAT
0266'  CD 062D'         591          CALL    CALCPOS         ; GET DISPLAY FILE ADRS.
0269'  ED 5B 002F'      592          LD      DE,(CHTBL)      ; CHAR.TABLE
026D'  06 60            593          LD      B,96            ; NO. OF PRINTABLE CHARACTERS
026F'  3E 80            594          LD      A,80H           ; SET ADJUSTMENT INDEX
0271'  32 003A'         595  GTCH1   LD      (GTINDX),A
0274'  14               596          INC     D               ; ADJUST TO START OF TABLE
0275'  EB               597          EX      DE,HL           ; DF ADRS.IN DE;CHAR.SET IN HL
0276'  C5               598  GTCH2   PUSH    BC              ; SAVE COUNT
0277'  D5               599          PUSH    DE              ; SAVE ADRS. IN DF
0278'  E5               600          PUSH    HL              ; SAVE ADRS. IN CHAR.TABLE
0279'  1A               601          LD      A,(DE)          ; SCAN ROW FROM DF
027A'  AE               602          XOR     (HL)            ; TEST AGAINST CHAR. SET
027B'  28 10            603          JR      Z,GTCH3         ; MATCH
027D'  F5               604          PUSH    AF
027E'  3A 003A'         605          LD      A,(GTINDX)
0281'  FE 90            606          CP      90H             ; TEST IF STD.GRAPHICS
0283'  20 03            607          JR      NZ,GTCH23
0285'  F1               608          POP     AF
0286'  18 27            609          JR      GTCH4           ; DO NOT TEST FOR INVERSE
0288'  F1               610  GTCH23  POP     AF
0289'  3C               611          INC     A               ; TEST INVERSE
028A'  20 23            612          JR      NZ,GTCH4
028C'  3D               613          DEC     A               ; A=-1 FOR INVERSE
028D'  4F               614  GTCH3   LD      C,A             ; C=0 FOR MATCH  -1 FOR INVERSE
028E'  06 07            615          LD      B,7
0290'  14               616  GTCH31  INC     D               ; NEXT SCAN IN DF
0291'  23               617          INC     HL              ; NEXT BYTE IN CHAR.SET
0292'  1A               618          LD      A,(DE)
0293'  AE               619          XOR     (HL)
0294'  A9               620          XOR     C
0295'  20 18            621          JR      NZ,GTCH4        ; NO MATCH
0297'  10 F7            622          DJNZ    GTCH31          ; FOR NEXT SCAN
                        623                          ;
                        624                          ; HERE IF MATCH WITH (SP)=CHAR IN CHAR SET
                        625                          ; (SP+2)=CHAR.IN DISPLAY FILE (SP+5)=CHAR.
                        626                          ; COUNT
0299'  79               627          LD      A,C             ; A=-1 IF MATCH ON INVERSE
029A'  C1               628          POP     BC
029B'  C1               629          POP     BC
029C'  C1               630          POP     BC
029D'  4F               631          LD      C,A             ; B=COUNT C=-1 IF MATCH ON INVERSE
```

> *Transcriber's note:* line 579 is not printed (578 → 580), the same as line 478 at the previous page break. In the listing the comment on lines 622 and 631 starts about two columns early (source col ~24, not 32), lined up with the comment-only lines 623–626. Those comment-only lines are placed at col 24, and the comments on 622/631 have been re-spaced to col 32 under the conventions. The comments on lines 617 and 621 are printed about two columns right of col 32, and line 617 has a stray dot just before its `;`. A pen tick touches line number 630. The bottom of the scan shows the next sheet's header ("Page 11-1").

<!-- PDF page 17 — listing "Page 11-1" — 'GET' ROUTINES — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
029E'  3A 003A'         632          LD      A,(GTINDX)      ; ADJUST CHAR.CODE
02A1'  90               633          SUB     B               ; A=CHAR.CODE
02A2'  FE 20            634          CP      20H             ; TEST IF SPACE
02A4'  20 05            635          JR      NZ,GTCH32
02A6'  0C               636          INC     C               ; TEST IF MATCH ON INVERSE SPACE
02A7'  20 02            637          JR      NZ,GTCH32
02A9'  3E 8F            638          LD      A,8FH           ; SET CODE FOR GRAPHICS BLOCK
02AB'  4F               639  GTCH32  LD      C,A
02AC'  06 00            640          LD      B,0
02AE'  C9               641          RET                     ; CHAR.CODE IN A AND IN BC
                        642  ;
02AF'  E1               643  GTCH4   POP     HL              ; HERE WHEN NO MATCH
02B0'  11 0008          644          LD      DE,8            ; LOOK AT NEXT CHAR. IN SET
02B3'  19               645          ADD     HL,DE           ; CHAR. SET
02B4'  D1               646          POP     DE              ; CHAR. IN DF
02B5'  C1               647          POP     BC              ; CHAR.COUNT
02B6'  10 BE            648          DJNZ    GTCH2           ; LOOK AGAIN
                        649                          ;
                        650                          ; HERE TO TEST IF DONE
02B8'  EB               651          EX      DE,HL           ; DF ADRS.TO HL
02B9'  3A 003A'         652          LD      A,(GTINDX)
02BC'  FE 80            653          CP      80H             ; TEST IF STD.CHR.SET
02BE'  20 0A            654          JR      NZ,GTCH5        ; TRY GRAPHICS
02C0'  ED 5B 0031'      655          LD      DE,(GRTBL)      ; STD.GRAPHICS TABLE
02C4'  06 10            656          LD      B,16            ; NO. OF ENTRIES
02C6'  3E 90            657          LD      A,90H           ; INDEX
02C8'  18 A7            658          JR      GTCH1           ;
02CA'  FE 90            659  GTCH5   CP      90H             ; TEST IF STD.GRAPHICS
02CC'  20 0B            660          JR      NZ,GTCH6        ; DONE IF NOT
02CE'  ED 5B 5C7B       661          LD      DE,(UDG)        ; TRY USER-DEFINED GRAPHICS AREA
02D2'  15               662          DEC     D               ; ADJUST ADDRESS-100H
02D3'  06 15            663          LD      B,21            ; NO OF ENTRIES
02D5'  3E A5            664          LD      A,0A5H          ; INDEX
02D7'  18 98            665          JR      GTCH1
02D9'  48               666  GTCH6   LD      C,B             ; HERE WHEN NO MATCH ANYWHERE
02DA'  AF               667          XOR     A               ; SET BC AND A=ZERO
02DB'  C9               668          RET
                        669
                        670                          ; GET ATTRIBUTE BYTE
                        671  ;                       ; HERE FROM BASIC ENTRY TO GET ATTRIBUTE
                        672  ;
02DC'  ED 4B 0019'      673  GETAB0: LD      BC,(GETCTL)
                        674  ;                       ; HERE WITH LIN/COL IN BC
                        675  ;
02E0'  CD 060C'         676  GETATT: CALL    TSTPAR          ; TEST PARAMETERS
02E3'  CD 061D'         677          CALL    CONVFM          ; CONVERT TO INTERNAL FORMAT
02E6'  CD 062D'         678          CALL    CALCPOS         ; CALCULATE DF POSITION
02E9'  CD 0692'         679          CALL    CALCATT         ; CALCULATE ATTRIBUTE POSITION
02EC'  7E               680          LD      A,(HL)          ; ATTRIBUTE BYTE TO A
02ED'  4F               681          LD      C,A             ; PASS BACK IN BC
02EE'  06 00            682          LD      B,0
02F0'  C9               683          RET
```

> *Transcriber's note:* most comments on this page sit at about source col 24 in the printout, not col 32. Only the comment-only lines (649, 650, 670, 671, 674) keep that position here; the comments on code lines have been re-spaced to col 32. The comments on lines 645–647 are indented a further ~10 columns in the printout. On line 655 the printout has no space between the operand and the comment (`DE,(GRTBL);`). Line 661's OBJ word `5C7B` carries no relocation mark, which is correct for the absolute UDG system variable. A pen stroke sits left of the LINE column beside line 657 and touches nothing. The bottom of the scan shows the next sheet's header ("Page 11-2").

<!-- PDF page 18 — listing "Page 11-2" — 'GET' ROUTINES — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        684  ;                               ; GET CURSOR POSITION
02F1'                   685  GETCB0:                         ; HERE FROM BASIC ENTRY
02F1'                   686  GETCUR:
02F1'  ED 4B 0034'      687          LD      BC,(CURPOS)     ; GET INTERNAL POSITION
02F5'  CD 061D'         688          CALL    CONVFM          ; CONVERT TO USER FORMAT
02F8'  3A 0033'         689          LD      A,(LINLEN)
02FB'  B9               690          CP      C               ; TEST IF END OF LINE(=32)
02FC'  20 0B            691          JR      NZ,GETC1        ; NO
02FE'  0E 00            692          LD      C,0             ; NEXT POSN.START OF NEXT LINE
0300'  78               693          LD      A,B
0301'  3C               694          INC     A               ; BUMP TO NEXT LINE
0302'  47               695          LD      B,A
0303'  FE 18            696          CP      24              ; TEST IF OFF SCREEN
0305'  38 02            697          JR      C,GETC1         ; NO
0307'  06 17            698          LD      B,23            ; POSN. IS AT BOTTOM LINE
0309'  ED 43 0007'      699  GETC1   LD      (LINCOL),BC     ; STORE FOR BASIC PROGRAM
030D'  C9               700          RET                     ; VALUES ALSO IN BC
                        701  ;
```

> *Transcriber's note:* lines 684–701 only; the rest of the sheet is blank, apart from a pen stroke in the empty area. The print on this sheet is darker and blotchier than on the others. In this font the line 700 OBJ `C9` looks like "CS", but the zoomed glyph is the font's curled 9. The bottom of the scan shows the next sheet's header ("Page 12").

<!-- PDF page 19 — listing "Page 12" — VIDEO MODE CONTROL — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        703          SUBTTL  VIDEO MODE CONTROL
                        704  ;
                        705  ;
030E'                   706  STMDB0:                         ; HERE FROM BASIC ENTRY WITH MODE IN
                        707                                  ; 'VIMODE'
030E'  3A 0024'         708          LD      A,(VIMODE)
                        709  ;
0311'                   710  SETMODE:                        ; ENTRY WITH MODE IN A
                        711  ;
0311'  47               712          LD      B,A             ; MODE TO B
0312'  A7               713          AND     A
0313'  28 15            714          JR      Z,SETMD0        ; TEST FOR VALIDITY
0315'  FE 80            715          CP      80H             ;
0317'  28 11            716          JR      Z,SETMD0        ;
0319'  FE 01            717          CP      1
031B'  28 0D            718          JR      Z,SETMD0
031D'  FE 04            719          CP      4
031F'  CA 03BA'         720          JP      Z,FRFV          ; HANDLE 4 AND 5
0322'  FE 05            721          CP      5
0324'  CA 03BA'         722          JP      Z,FRFV          ;
0327'  C3 00C4'         723          JP      INVPAR          ; INVALID PARAMETER
032A'  3A 5CC2          724  SETMD0  LD      A,(VIDMOD)      ; TEST CURRENT MODE
032D'  A7               725          AND     A
032E'  20 5A            726          JR      NZ,SETMD2       ; DF2 OPEN
0330'  B0               727          OR      B               ; CURRENT MODE=0 - TEST IF NEW MODE=0
0331'  CA 00BF'         728          JP      Z,GOODRET       ; NO ACTION
                        729  ;
                        730  ;                               ; INITIAL OPENING OF 2ND DF
0334'  21 1701          731  SETMD1  LD      HL,SCINIT       ; INITIALIZE VARIABLES
0337'  22 0028'         732          LD      (SCRCTL),HL     ; SCROLL CONTROL
033A'  3E 17            733          LD      A,23            ;
033C'  32 002D'         734          LD      (BOTLN),A       ; BOTTOM LINE
033F'  3E 01            735          LD      A,1             ;
0341'  32 002E'         736          LD      (SCRLCT),A      ; SCROLL COUNT
0344'  3E 20            737          LD      A,32            ;
0346'  32 0033'         738          LD      (LINLEN),A      ; LINE LENGTH
0349'  21 1800          739          LD      HL,CLINIT       ;
034C'  22 000C'         740          LD      (CLRCTL),HL     ; CLEAR SCREEN CONTROL
034F'  AF               741          XOR     A
0350'  32 003B'         742          LD      (STRGCT),A      ; WRSTRG REMAINING COUNT
0353'  32 003C'         743          LD      (STRGCT+1),A    ;
0356'  21 3C00          744          LD      HL,CHRSET       ; STD.CHAR.SET
0359'  22 002F'         745          LD      (CHTBL),HL      ;
035C'  21 05E0'         746          LD      HL,GRPHST       ; STD. GRAPHICS SET
035F'  22 0031'         747          LD      (GRTBL),HL      ;
                        748  ;                               ;
                        749  ;                               ; INITIALIZE BASIC INPUTS
0362'  32 0000'         750          LD      (DATAB),A       ; DATA BYTE
0365'  32 0007'         751          LD      (LINCOL),A      ; COLUMN
0368'  32 0008'         752          LD      (LINCOL+1),A    ; LINE
036B'  32 0019'         753          LD      (GETCTL),A      ; 'GET' COLUMN
036E'  32 001A'         754          LD      (GETCTL+1),A    ; 'GET' LINE
```

> *Transcriber's note:* line 724 has a hand-drawn pen stroke running under/through the OBJ field `3A 5CC2`; the printed digits are unaffected. A stray dot sits in the gutter left of line 754.

> *Transcriber's note:* labels `STMDB0` (706) and `SETMD0` (714, 716, 718, 724) end in the narrow oval digit 0, not the squarer letter O (compared at 5x zoom against `COPY01` on page 13).

<!-- PDF page 20 — listing "Page 12-1" — VIDEO MODE CONTROL — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        755  ;                               ; TEST IF ENOUGH MEMORY
0371'  21 12C0          756          LD      HL,INSERTSZ
0374'  11 0840          757          LD      DE,MOVESZ
0377'  19               758          ADD     HL,DE           ; HL=TOTAL ROOM NEEDED
0378'  ED 5B 5C65       759          LD      DE,(STKEND)
037C'  19               760          ADD     HL,DE           ; ADD MEMORY IN USE
037D'  DA 03B5'         761          JP      C,EXTNRM        ; NOT ENOUGH MEMORY TO OPEN DF2
0380'  ED 5B 5CB2       762          LD      DE,(RAMTOP)
0384'  A7               763          AND     A
0385'  ED 52            764          SBC     HL,DE
0387'  D2 03B5'         765          JP      NC,EXTNRM       ; NOT ENOUGH MEMORY
038A'  78               766  SETMD2  LD      A,B             ; MODE TO A
038B'  CD 05F3'         767          CALL    ENBLEXT         ; ENABLE ROM EXT.
038E'  CD 05CD'         768          CALL    GETVAL          ; H/W VALUE TO B; VIDMOD VALUE TO C
0391'  C5               769          PUSH    BC              ; SAVE
0392'  78               770          LD      A,B
0393'  A7               771          AND     A               ; TEST IF 0
0394'  20 01            772          JR      NZ,SETM21
0396'  79               773          LD      A,C             ; VALUE FOR CHNGVID IN C
0397'  CD 0E8E          774  SETM21  CALL    CHNGVID         ; CALL RTN. TO OPEN/CLOSE 2ND DF
039A'  CD 0600'         775          CALL    ENBLHOME        ; REENABLE HOME BANK
039D'  C1               776          POP     BC
039E'  79               777          LD      A,C
039F'  32 5CC2          778  SETMD3  LD      (VIDMOD),A      ; UPDATE VIDMOD
03A2'  3A 0033'         779  UPDATE  LD      A,(LINLEN)      ; GET LINE LENGTH
03A5'  3C               780          INC     A
03A6'  4F               781          LD      C,A             ; COLUMN
03A7'  06 18            782          LD      B,SCRSZ         ; BC=HOME POSITION (LN.0/COL.0)
03A9'  21 0000          783          LD      HL,0
03AC'  22 5C7D          784          LD      (COORDS),HL     ; INITIALIZE PLOT POSITION
03AF'  CD 0628'         785          CALL    UPDPOSN         ; UPDATE AND STORE HOME POSITION
03B2'  C3 00BF'         786          JP      GOODRET         ; RETURN BC=0
03B5'  0E 02            787  EXTNRM  LD      C,2             ; RETURN BC=2 FOR NO ROOM
03B7'  C3 00C1'         788          JP      ERRRET
                        789  ;
                        790  ;                               ; MODE = 4 OR 5 USED TO DIRECT DATA/
                        791  ;                               ; ATTRIBUTES TO DISPLAY FILE 1 OR 2
                        792  ;                               ; WHILE THE ALTERNATE FILE IS AT THE
                        793  ;                               ; SCREEN.  NO CHANGE TO H/W SETTING
                        794  ;
                        795  ;                               ; INPUT     CURRENT VIDMOD   NEW VIDMOD
                        796  ;                               ; -----     --------------   ----------
                        797  ;
                        798  ;                               ;   4            80             80
                        799  ;                               ;   4            81             84
                        800  ;                               ;   4            84             84
                        801  ;                               ;   4            85             80
                        802  ;
                        803  ;                               ;   5            80             85
                        804  ;                               ;   5            81             81
                        805  ;                               ;   5            84             81
                        806  ;                               ;   5            85             85
```

> *Uncertain:* line 788 OBJ `00C1'` — a speck sits inside the `C`; reads as `C` (and ERRRET between GOODRET `00BF` and INVPAR `00C4` fits).

> *Transcriber's note:* a pen stroke runs from the OBJ field of line 782 down toward line 783. The comment table on lines 795–806 is transcribed with its internal spacing measured from the print (approximate).

<!-- PDF page 21 — listing "Page 12-2" — VIDEO MODE CONTROL — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        807  ;
03BA'  3A 5CC2          808  FRFV    LD      A,(VIDMOD)      ; ONLY VALID IF VIDMOD=80,81,84 OR 85
03BD'  4F               809          LD      C,A             ; CURRENT VIDMOD TO C
03BE'  CB 7F            810          BIT     7,A
03C0'  CA 00C4'         811          JP      Z,INVPAR        ; INVALID PARAMETER
03C3'  78               812          LD      A,B             ; MODE 4 OR 5 TO A
03C4'  FE 04            813          CP      4
03C6'  20 0A            814          JR      NZ,DTADF2       ; MODE 5 - DATA TO DF2
                        815  ;                               ; MODE 4 - DATA TO DF1
03C8'  CB 41            816  DTADF1  BIT     0,C             ; TEST IF DF1 ALREADY DEST.
03CA'  CA 00BF'         817          JP      Z,GOODRET       ; NO ACTION
03CD'  A9               818          XOR     C               ; SET VIDMOD=80 OR 84
03CE'  E6 FE            819          AND     0FEH            ; BIT 0=0
03D0'  18 CD            820          JR      SETMD3          ; UPDATE VARIABLES
                        821  ;
                        822  ;                               ; MODE 5 - DATA TO DF2
03D2'  CB 41            823  DTADF2  BIT     0,C             ; TEST IF DF2 ALREADY DEST.
03D4'  C2 00BF'         824          JP      NZ,GOODRET      ; NO ACTION
03D7'  A9               825          XOR     C               ; SET VIDMOD=81 OR 85
03D8'  18 C5            826          JR      SETMD3          ; UPDATE VARIABLES
                        827  ;
```

> *Transcriber's note:* the listing ends at line 827, about a quarter of the way down; the rest of the sheet is blank (page eject before the next SUBTTL). Stray dot left of line 819.

<!-- PDF page 22 — listing "Page 13" — COPY SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                        829          SUBTTL  COPY SCREEN
                        830  ;
                        831  ;
                        832  ;                               ; COPY LINES WITHIN OR BETWEEN
                        833  ;                               ; DISPLAY FILES
                        834  ;
                        835  ;
03DA'                   836  COPYS0:                         ; HERE FROM BASIC ENTRY
03DA'  2A 5C5D          837          LD      HL,(CH_ADD)     ; SAVE CURRENT POINTER
03DD'  E5               838          PUSH    HL
03DE'  CD 06B8'         839          CALL    GETSTRG         ; GET STRING OF PARAMETERS
03E1'  20 09            840          JR      NZ,COPY01       ; FOUND STRING
03E3'  E1               841          POP     HL              ; RESTORE CH_ADD AND RETURN
03E4'  22 5C5D          842          LD      (CH_ADD),HL     ; ERROR (NO STRING OR NULL STRING)
03E7'  C9               843          RET                     ; (BC CONTAINS STATUS)
                        844  ;
03E8'  =0004            845  COPYWK  DEFS    4               ; WORK AREA FOR BASIC PARAMETERS
                        846  ;
                        847  ;
03EC'  22 5C5D          848  COPY01  LD      (CH_ADD),HL     ; ADRS. OF STRING TO CH_ADD
03EF'  CD 0418'         849          CALL    GETNO           ; GET PARAMETERS
03F2'  32 03E9'         850          LD      (COPYWK+1),A    ; SOURCE LINE NO.
03F5'  CD 0418'         851          CALL    GETNO           ;
03F8'  32 03E8'         852          LD      (COPYWK),A      ; DEST. LINE NO.
03FB'  CD 0418'         853          CALL    GETNO
03FE'  32 03EB'         854          LD      (COPYWK+3),A    ; SOURCE DF
0401'  CD 0418'         855          CALL    GETNO
0404'  32 03EA'         856          LD      (COPYWK+2),A    ; DEST. DF
0407'  CD 0418'         857          CALL    GETNO
040A'  E1               858          POP     HL              ; RESTORE CH_ADD
040B'  22 5C5D          859          LD      (CH_ADD),HL
040E'  ED 4B 03E8'      860          LD      BC,(COPYWK)
0412'  ED 5B 03EA'      861          LD      DE,(COPYWK+2)
0416'  18 25            862          JR      COPYSC          ; TEST VALIDITY AND DO COPY
                        863  ;
0418'  2A 5C5D          864  GETNO   LD      HL,(CH_ADD)     ; LOAD ADDRESS
041B'  7E               865          LD      A,(HL)          ; GET CHAR. FROM STRING
041C'  FE 2C            866          CP      2CH             ; TEST IF COMMA
041E'  28 0F            867          JR      Z,GETN2
0420'  FE 30            868          CP      30H             ; TEST IF DIGIT
0422'  38 11            869          JR      C,COPERR        ; INVALID PARAMETER
                        870  ;                               ; OR END OF STRING
0424'  FE 3A            871          CP      3AH
0426'  30 0D            872          JR      NC,COPERR
0428'  CD 30F9          873  GETN1   CALL    ININT           ; CONVERT TO BINARY
042B'  CD 3193          874          CALL    FP2A
042E'  D0               875          RET     NC              ; VALID DIGIT IN A
042F'  23               876  GETN2   INC     HL
0430'  22 5C5D          877          LD      (CH_ADD),HL
0433'  18 E3            878          JR      GETNO           ; TEST NEXT CHAR.
                        879  ;
0435'  E1               880  COPERR  POP     HL              ; DISCARD RETURN FROM GETNO
```

> *Uncertain:* label `GETNO` (lines 849, 851, 853, 855, 857, 864, 878, 880) — in this font the last character is hard to tell from `D`; read as `GETNO` ("get number") with GETN1/GETN2 siblings.

> *Transcriber's note:* source line 828 is not printed anywhere (page 12-2 ends at 827, this page starts at 829) — presumably a listing-control line such as PAGE. Label `COPYS0` (836) ends in the digit 0. A pen stroke crosses the gutter beside lines 868–869.

<!-- PDF page 23 — listing "Page 13-1" — COPY SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0436'  E1               881  COPER1  POP     HL              ; RESTORE CH_ADD
0437'  22 5C5D          882          LD      (CH_ADD),HL
043A'  C3 00C4'         883          JP      INVPAR          ; RETURN BC=1 FOR INVALID
                        884                                  ; PARAMETER(S)
                        885  ;
                        886  ;
043D'                   887  COPYSC:                         ; ENTRY WITH PARAMETERS IN REGS.
                        888  ;                               ; AS ABOVE
043D'  A7               889          AND     A               ; TEST VALIDITY
043E'  CA 00C4'         890          JP      Z,INVPAR        ; ERROR IF LINE COUNT=0
0441'  FE 19            891          CP      25              ;
0443'  D2 00C4'         892          JP      NC,INVPAR       ; ERROR IF > 24
0446'  F5               893          PUSH    AF
0447'  CD 05A8'         894          CALL    GTADRS          ; GET DF ADRS. FOR SOURCE
044A'  DA 00C4'         895          JP      C,INVPAR        ; INVALID PARAMETER DETECTED
044D'  E5               896          PUSH    HL              ; SAVE SOURCE ADDRESS
044E'  41               897          LD      B,C             ; DEST. LINE
044F'  53               898          LD      D,E             ; DEST. DF
0450'  CD 05A8'         899          CALL    GTADRS          ; GET DF ADRS. FOR DESTINATION
0453'  DA 00C4'         900          JP      C,INVPAR
0456'  D1               901          POP     DE              ; SOURCE ADRS.
0457'  EB               902          EX      DE,HL           ; HL=SOURCE  DE=DEST.
0458'  F1               903          POP     AF              ; GET COUNT
0459'  47               904          LD      B,A
045A'  E5               905          PUSH    HL              ; SAVE STARTING ADDRESSES
045B'  D5               906          PUSH    DE              ;
045C'  C5               907          PUSH    BC              ; SAVE ORIG. LINE COUNT
045D'  7D               908  COPYS1  LD      A,L             ; CALCULATE # OF LINES SOURCE BLOCK
045E'  07               909          RLCA
045F'  07               910          RLCA
0460'  07               911          RLCA
0461'  4F               912          LD      C,A             ;
0462'  3E 08            913          LD      A,8
0464'  91               914          SUB     C
0465'  4F               915          LD      C,A             ; # OF LINES THIS BLOCK
0466'  C5               916          PUSH    BC              ; SAVE NO.OF LINES/# OF LINES SOURCE BLK.
0467'  B8               917          CP      B               ; COMPARE TO TOTAL LINES
0468'  38 71            918          JR      C,COPYS5        ; TOTAL LINES > THIS BLOCK
046A'  7B               919          LD      A,E             ; CALCULATE # OF LINES DEST.BLOCK
046B'  07               920          RLCA
046C'  07               921          RLCA
046D'  07               922          RLCA
046E'  4F               923          LD      C,A
046F'  3E 08            924          LD      A,8
0471'  91               925          SUB     C               ; A=# OF LINES DEST.BLOCK
0472'  C1               926          POP     BC              ; B=TOTAL LINES
0473'  4F               927          LD      C,A             ; C=# OF LINES DEST BLOCK
0474'  B8               928          CP      B               ; B=TOTAL LINES TO BE COPIED
0475'  38 79            929          JR      C,COPYS7        ; TOTAL > DEST.BLOCK - USE DEST.LINE CNT.
                        930  ;
                        931  ;                               ; COPY IS WITHIN BOTH SOURCE AND DEST.BLOCKS
                        932  ;
```

> *Transcriber's note:* a short horizontal pen stroke sits in the gutter between lines 919 and 920.

<!-- PDF page 24 — listing "Page 13-2" — COPY SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0477'  78               933  COPYS2  LD      A,B             ; NO. OF LINES
0478'  06 00            934          LD      B,0             ; REMAINING LINES
047A'  C5               935          PUSH    BC              ; SAVE REMAINING LINE COUNT
047B'  47               936  COPYS3  LD      B,A             ; NO. OF LINES
047C'  0E 08            937          LD      C,8             ; SCAN COUNT
047E'  78               938  COPYS4  LD      A,B             ; NO. OF LINES
047F'  C5               939          PUSH    BC              ; SAVE SCAN COUNT
0480'  E6 07            940          AND     7
0482'  0F               941          RRCA
0483'  0F               942          RRCA
0484'  0F               943          RRCA
0485'  4F               944          LD      C,A             ; BC=32 * NO. OF LINES
0486'  06 00            945          LD      B,0             ; (C=0 IF 256 FOR 8 LINES)
0488'  A7               946          AND     A               ; TEST IF 0
0489'  20 02            947          JR      NZ,COPY41
048B'  06 01            948          LD      B,1             ; SET TO 256
048D'  E5               949  COPY41  PUSH    HL              ; SAVE ADDRESSES
048E'  D5               950          PUSH    DE
048F'  ED B0            951          LDIR                    ; COPY 'BC' BYTES
0491'  D1               952          POP     DE              ; RESTORE ADDRESSES
0492'  E1               953          POP     HL
0493'  14               954          INC     D               ; ADJUST FOR NEXT SCAN LINE
0494'  24               955          INC     H               ; (+100H)
0495'  C1               956          POP     BC              ; SCAN COUNT
0496'  0D               957          DEC     C               ; DECREMENT SCAN COUNT
0497'  20 E5            958          JR      NZ,COPYS4       ; NEXT SCAN ROW
0499'  78               959          LD      A,B             ; SAVE # OF LINES JUST MOVED
049A'  C1               960          POP     BC              ; RESIDUAL LINE COUNT
049B'  4F               961          LD      C,A             ;
049C'  78               962          LD      A,B             ;
049D'  A7               963          AND     A
049E'  28 22            964          JR      Z,COPYXT        ; DONE
04A0'  C5               965          PUSH    BC              ; B=REMAINING LINE COUNT
04A1'  79               966          LD      A,C
04A2'  E6 07            967          AND     7
04A4'  0F               968          RRCA
04A5'  0F               969          RRCA
04A6'  0F               970          RRCA
04A7'  4F               971          LD      C,A
04A8'  06 00            972          LD      B,0
04AA'  A7               973          AND     A
04AB'  20 02            974          JR      NZ,COPY42
04AD'  06 01            975          LD      B,1             ; BC = NO. OF BYTES JUST MOVED
04AF'  25               976  COPY42  DEC     H               ; ADJUST ADDRESSES TO START
04B0'  09               977          ADD     HL,BC           ; OF NEXT LINE IN EACH FILE
04B1'  3E 78            978          LD      A,78H
04B3'  A4               979          AND     H
04B4'  67               980          LD      H,A
04B5'  E5               981          PUSH    HL              ; SAVE ADJUSTED SOURCE ADRS
04B6'  15               982          DEC     D
04B7'  EB               983          EX      DE,HL           ; DEST. ADRS. TO HL
04B8'  09               984          ADD     HL,BC
```

> *Transcriber's note:* a pen stroke crosses the gutter beside lines 976–978; stray dot after the OBJ on line 941. The page ends mid-routine at line 984 (continues on Page 13-3).

<!-- PDF page 25 — listing "Page 13-3" — COPY SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
04B9'  3E 78            985          LD      A,78H
04BB'  A4               986          AND     H
04BC'  67               987          LD      H,A
04BD'  D1               988          POP     DE              ; SOURCE ADRS. TO DE
04BE'  EB               989          EX      DE,HL           ; HL=SOURCE  DE=DEST.
04BF'  C1               990          POP     BC
04C0'  18 9B            991          JR      COPYS1          ; B=REMAINING LINE COUNT
04C2'  C1               992  COPYXT  POP     BC              ; ORIG.LINE COUNT
04C3'  68               993          LD      L,B             ; CALCULATE # OF ATTRIBUTE BYTES
04C4'  26 00            994          LD      H,0
04C6'  29               995          ADD     HL,HL
04C7'  29               996          ADD     HL,HL
04C8'  29               997          ADD     HL,HL
04C9'  29               998          ADD     HL,HL
04CA'  29               999          ADD     HL,HL           ; 32 * NO. OF LINES
04CB'  44              1000          LD      B,H
04CC'  4D              1001          LD      C,L
04CD'  E1              1002          POP     HL              ; DEST.ADDRESS TO HL
04CE'  CD 0692'        1003          CALL    CALCATT         ; ADRS. OF ATTRIBUTE FILE
04D1'  EB              1004          EX      DE,HL           ; DEST.ADRS. TO DE
04D2'  E1              1005          POP     HL              ; SOURCE ADDRESS
04D3'  CD 0692'        1006          CALL    CALCATT         ; ADRS. OF ATTRIBUTE FILE
04D6'  ED B0           1007          LDIR                    ; COPY ATTRIBUTES
04D8'  C3 00BF'        1008          JP      GOODRET         ; RETURN BC=0
                       1009  ;
04DB'  41              1010  COPYS5  LD      B,C             ; # OF LINES SOURCE BLOCK TO B
04DC'  7B              1011          LD      A,E             ; CALCULATE # OF LINES DEST. BLOCK
04DD'  07              1012          RLCA
04DE'  07              1013          RLCA
04DF'  07              1014          RLCA
04E0'  4F              1015          LD      C,A
04E1'  3E 08           1016          LD      A,8
04E3'  91              1017          SUB     C               ; A=# LINES DEST.BLOCK
04E4'  4F              1018          LD      C,A             ; SAVE IN C
04E5'  B8              1019          CP      B               ; COMPARE TO LINES SOURCE BLOCK
04E6'  38 08           1020          JR      C,COPYS7        ; DEST.SIZE SMALLER - USE DEST.LINE CNT
04E8'  C1              1021          POP     BC              ; B=TOTAL LINE COUNT/C=SOURCE LINE CNT.
04E9'  78              1022  COPYS6  LD      A,B
04EA'  91              1023          SUB     C
04EB'  47              1024          LD      B,A             ; B=REMAINING LINECOUNT
04EC'  C5              1025          PUSH    BC
04ED'  79              1026          LD      A,C             ; # OF LINES
04EE'  18 8B           1027          JR      COPYS3          ; COPY 'A' LINES
04F0'  79              1028  COPYS7  LD      A,C             ; # LINES DEST.BLK
04F1'  C1              1029          POP     BC              ; B=TOTAL LINE COUNT
04F2'  4F              1030          LD      C,A             ; C=DEST. LINE CNT.
04F3'  18 F4           1031          JR      COPYS6
                       1032
                       1033
                       1034          SUBTTL  EXCHANGE SCREEN
                       1035  ;
                       1036  ;                               ; EXCHANGE LINES WITHIN OR BETWEEN
```

> *Uncertain:* none.
> *Transcriber's note:* a hand-drawn pen stroke runs diagonally through the line-number column at lines 1032–1034; no text is obscured. Lines 1032 and 1033 are printed as line numbers with no source.

<!-- PDF page 26 — listing "Page 13-4" — EXCHANGE SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       1037  ;                               ; DISPLAY FILES
                       1038  ;
04F5'                  1039  EXCHS0                          ; ENTRY FROM BASIC - GET PARAMETERS
                       1040  ;                               ; FROM STRING TO APPROPRIATE REGS.
                       1041  ;
04F5'  2A 5C5D         1042          LD      HL,(CH_ADD)     ; SAVE CURRENT POINTER
04F8'  E5              1043          PUSH    HL
04F9'  CD 06B8'        1044          CALL    GETSTRG         ; GET STRING OF PARAMETERS
04FC'  20 05           1045          JR      NZ,EXCH01       ; FOUND STRING
04FE'  E1              1046          POP     HL              ; RESTORE CH_ADD AND RETURN
04FF'  22 5C5D         1047          LD      (CH_ADD),HL     ; ERROR (NO STRING OR NULL STRING)
0502'  C9              1048          RET                     ; (BC CONTAINS STATUS)
                       1049  ;
0503'  22 5C5D         1050  EXCH01  LD      (CH_ADD),HL     ; ADDRESS OF STRING
0506'  CD 0418'        1051          CALL    GETNO           ; GET PARAMETERS
0509'  32 03E8'        1052          LD      (COPYWK),A      ; SOURCE LINE NO.
050C'  CD 0418'        1053          CALL    GETNO
050F'  32 03EA'        1054          LD      (COPYWK+2),A    ; DEST. LINE NO.
0512'  CD 0418'        1055          CALL    GETNO           ;
0515'  32 03E9'        1056          LD      (COPYWK+1),A    ; SOURCE DF (1 OR 2)
0518'  CD 0418'        1057          CALL    GETNO
051B'  32 03EB'        1058          LD      (COPYWK+3),A    ; DEST. DF
051E'  CD 0418'        1059          CALL    GETNO           ; NO. OF LINES
0521'  E1              1060          POP     HL              ; RESTORE CH_ADD
0522'  22 5C5D         1061          LD      (CH_ADD),HL     ;
0525'  ED 4B 03E8'     1062          LD      BC,(COPYWK)     ; LOAD REGS.
0529'  ED 5B 03EA'     1063          LD      DE,(COPYWK+2)
                       1064  ;                               ;
                       1065  ;
052D'                  1066  EXCHSC:                         ; ROUTINE TO EXCHANGE LINES IN THE
                       1067  ;                               ; DISPLAY FILE(S).
                       1068  ;                               ;
                       1069  ;                               ; INPUTS:  B=DF FOR SOURCE 1 (1 OR 2)
                       1070  ;                               ;          C=LINE NO. FOR SOURCE 1
                       1071  ;                               ;          D=DF FOR SOURCE 2 (1 OR 2)
                       1072  ;                               ;          E=LINE NO. FOR SOURCE 2
                       1073  ;                               ;          A=COUNT (# OF LINES TO BE
                       1074  ;                               ;            EXCHANGED
                       1075  ;
                       1076  ;
                       1077  ;
                       1078  ;
                       1079  ;
052D'  A7              1080          AND     A               ; TEST VALI COUNT
052E'  CA 00C4'        1081          JP      Z,INVPAR
0531'  FE 19           1082          CP      25
0533'  D2 00C4'        1083          JP      NC,INVPAR
0536'  F5              1084          PUSH    AF              ; SAVE LINE COUNT
0537'  D5              1085          PUSH    DE              ; SAVE SOURCE 2 INFO.
0538'  50              1086          LD      D,B             ; DF
0539'  41              1087          LD      B,C             ; LINE NO
053A'  CD 05A8'        1088          CALL    GTADRS          ; GET DF ADRS.FOR SOURCE 1
```

> *Uncertain:* none.
> *Transcriber's note:* "TEST VALI COUNT" (line 1080) is printed so — a typo in the source for "VALID". A hand-drawn pen stroke crosses the line numbers 1062–1063 (digits still legible). A small `<` mark is pencilled between LOC and OBJ on line 1047, and a stray dot precedes `D=DF` on line 1071; neither is part of the listing.

<!-- PDF page 27 — listing "Page 13-5" — EXCHANGE SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
053D'  DA 00C4'        1089          JP      C,INVPAR        ; ERROR DETECTED
0540'  D1              1090          POP     DE              ; SOURCE 2 INFO.
0541'  E5              1091          PUSH    HL              ; SAVE SOURCE 1 ADRS.
0542'  43              1092          LD      B,E             ; LINE NO.
0543'  CD 05A8'        1093          CALL    GTADRS          ; GET DF ADRS. FOR SOURCE 2
0546'  DA 00C4'        1094          JP      C,INVPAR
0549'  D1              1095          POP     DE              ; ADDRESSES IN DE AND HL
054A'  F1              1096          POP     AF              ; LINE COUNT IN A
054B'  E5              1097          PUSH    HL              ; SOURCE 2 STARTING ADRS. FOR EXIT
054C'  D5              1098          PUSH    DE              ; SOURCE 1 STARTING ADRS. FOR EXIT
054D'  F5              1099          PUSH    AF              ; ORIG.LINE COUNT FOR EXIT
054E'  F5              1100          PUSH    AF              ; WORKING LINE COUNT
054F'  06 08           1101  EXCH0   LD      B,8             ; SCAN COUNT
0551'  E5              1102  EXCH1   PUSH    HL              ; SAVE ADDRESSES AND SCAN COUNT
0552'  D5              1103          PUSH    DE
0553'  C5              1104          PUSH    BC
0554'  01 0020         1105          LD      BC,32           ; NO.OF BYTES IN SCAN ROW FOR
                       1106  ;                               ; A LINE ON THE SCREEN
0557'  CD 0593'        1107          CALL    EXCHLP          ; EXCHANGE BYTES
055A'  C1              1108          POP     BC              ; SCAN COUNT IN B
055B'  D1              1109          POP     DE
055C'  E1              1110          POP     HL              ; ADDRESSES
055D'  14              1111          INC     D               ; ADJUST TO NEXT SCAN ROW
055E'  24              1112          INC     H
055F'  10 F0           1113          DJNZ    EXCH1           ; DO NEXT ROW
0561'  F1              1114          POP     AF              ; LINE COUNT IN A
0562'  15              1115          DEC     D               ; ADJUST ADDRESSES BACK 1 SCAN ROW
0563'  25              1116          DEC     H
0564'  3D              1117          DEC     A               ; ADJUST LINE COUNT
0565'  28 12           1118          JR      Z,EXCHXT        ; DONE
0567'  F5              1119          PUSH    AF              ; REMAINING LINE COUNT
0568'  01 0020         1120          LD      BC,32           ; ADJUST ADDRESSES TO START
056B'  09              1121          ADD     HL,BC           ; OF NEXT LINE
056C'  3E 78           1122          LD      A,78H
056E'  A4              1123          AND     H
056F'  67              1124          LD      H,A
0570'  EB              1125          EX      DE,HL
0571'  09              1126          ADD     HL,BC
0572'  3E 78           1127          LD      A,78H
0574'  A4              1128          AND     H
0575'  67              1129          LD      H,A
0576'  EB              1130          EX      DE,HL
0577'  18 D6           1131          JR      EXCH0           ; DO NEXT LINE
0579'  F1              1132  EXCHXT  POP     AF              ; A=ORIG. LINE COUNT
057A'  6F              1133          LD      L,A             ; LINE COUNT
057B'  26 00           1134          LD      H,0
057D'  29              1135          ADD     HL,HL           ; # OF ATTRIBUTE BYTES TO EXCHANGE
057E'  29              1136          ADD     HL,HL
057F'  29              1137          ADD     HL,HL
0580'  29              1138          ADD     HL,HL
0581'  29              1139          ADD     HL,HL           ; (32*NO. OF LINES)
0582'  44              1140          LD      B,H
```

> *Uncertain:* none in the surviving text. The LOC column is damaged (see next note); every LOC on this page is reconstructed from the LOC chain, which is unambiguous because every byte count on the page is fixed.
> *Transcriber's note:* this page was scanned shifted left by roughly 14 character positions. The left margin is cut off, taking the first one or two characters of every LOC field: only the last two digits plus `'` survive (e.g. `3D'`, `40'`, `82'`, with a sliver of the preceding digit on some lines), and the headers read `SC 004 DUAL SCREEN MODE SUPPORT …` and `E SCREEN   IODS.SRC` (the `ADL - A` and `EXCHANG` were lost). The full LOCs above are restored from the chain: 053A' + 3 = 053D' from the previous page, through 0582' + 1 = 0583', which is where the next page starts. OBJ, LINE and SOURCE are complete. A solid black bar fills the right edge of this scan, beyond the tractor-feed holes. It covers no listing text: the longest comment ends well short of the holes, and the header's `Page 13-5` is intact. The print is very faint, but every character could be read after enhancement. Two curved pen strokes appear in the margin, one between the LINE and SOURCE columns at lines 1107–1110 and one across the OBJ field at lines 1120–1121. Both bytes they cross are legible.

<!-- PDF page 28 — listing "Page 13-6" — EXCHANGE SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0583'  4D              1141          LD      C,L             ; COUNT TO BC
0584'  E1              1142          POP     HL              ; SOURCE 1 ADRS.
0585'  CD 0692'        1143          CALL    CALCATT         ; GET ADRS. OF ATTRIBUTE FILE
0588'  EB              1144          EX      DE,HL           ; SOURCE 1 ATTRIBUTE ADRS. IN DE
0589'  E1              1145          POP     HL              ; SOURCE 2 ADRS.
058A'  CD 0692'        1146          CALL    CALCATT         ; SOURCE 2 ATTRIBUTE ADRS. IN HL
058D'  CD 0593'        1147          CALL    EXCHLP          ; EXCHANGE ATTRIBUTE BYTES
0590'  C3 00BF'        1148          JP      GOODRET         ; RETURN B=0
                       1149  ;
                       1150  ;
                       1151  ;                               ; EXCHANGE LOOP
                       1152  ;
                       1153  ;                               ; EXCHANGES DATA BETWEEN TWO
                       1154  ;                               ; MEMORY AREAS.  ADDRESSES IN
                       1155  ;                               ; DE AND HL, BYTE COUNT IN BC
                       1156  ;
0593'  C5              1157  EXCHLP  PUSH    BC              ; SAVE COUNT
0594'  7E              1158          LD      A,(HL)          ; DATA FROM SOURCE 2
0595'  4F              1159          LD      C,A             ; TO WKG.REG.
0596'  1A              1160          LD      A,(DE)          ; DATA FROM SOURCE 1
0597'  A9              1161          XOR     C               ; EXCHANGE VIA XOR
0598'  F5              1162          PUSH    AF              ; SAVE INTERMEDIATE RESULT
0599'  A9              1163          XOR     C               ; A NOW CONTAINS DATA FOR SOURCE 2
059A'  4F              1164          LD      C,A             ; C=NEW DATA FOR SOURCE 2
059B'  F1              1165          POP     AF              ; INTERMEDIATE RESULT
059C'  A9              1166          XOR     C               ; A=NEW DATA FOR SOURCE 1
059D'  12              1167          LD      (DE),A          ; WRITE NEW DATA
059E'  71              1168          LD      (HL),C
059F'  13              1169          INC     DE              ; ADJUST TO NEXT BYTE
05A0'  23              1170          INC     HL
05A1'  C1              1171          POP     BC              ;
05A2'  0B              1172          DEC     BC              ; DECREMENT COUNT
05A3'  78              1173          LD      A,B             ; TEST IF DONE
05A4'  B1              1174          OR      C
05A5'  20 EC           1175          JR      NZ,EXCHLP
05A7'  C9              1176          RET
                       1177
                       1178  ;
                       1179  ;                               ; SUB-RTN. TO GET
                       1180  ;                               ; DF ADRS. OF LINE IN B (0-23)
                       1181  ;                               ; FOR DF IN D (1 OR 2)
                       1182  ;                               ; RETURNS CARRY IF INVALID PARAMETER
05A8'  78              1183  GTADRS  LD      A,B
05A9'  FE 18           1184          CP      24              ; TEST VALID LINE NO.
05AB'  30 1E           1185          JR      NC,GAERR
05AD'  0F              1186          RRCA
05AE'  0F              1187          RRCA
05AF'  0F              1188          RRCA
05B0'  E6 E0           1189          AND     0E0H
05B2'  6F              1190          LD      L,A
05B3'  78              1191          LD      A,B
05B4'  E6 18           1192          AND     18H
```

> *Uncertain:* none.
> *Transcriber's note:* a pen stroke runs diagonally between the OBJ and LINE columns at lines 1158–1159, and a small mark follows `E1` on line 1145. Neither obscures any characters.

<!-- PDF page 29 — listing "Page 13-7" — EXCHANGE SCREEN — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
05B6'  F6 40           1193          OR      40H
05B8'  67              1194          LD      H,A
05B9'  7A              1195          LD      A,D
05BA'  A7              1196          AND     A
05BB'  28 0E           1197          JR      Z,GAERR         ; ERROR IF NOT 1 OR 2
05BD'  FE 03           1198          CP      3
05BF'  30 0A           1199          JR      NC,GAERR
05C1'  CB 47           1200          BIT     0,A             ; TEST WHICH DF
05C3'  20 04           1201          JR      NZ,GTADR1       ; DF1
05C5'  7C              1202          LD      A,H
05C6'  F6 20           1203          OR      20H             ; DF2
05C8'  67              1204          LD      H,A
05C9'  A7              1205  GTADR1  AND     A               ; RETURN NO CARRY
05CA'  C9              1206          RET
                       1207  ;
05CB'  37              1208  GAERR   SCF                     ; SET CARRY
05CC'  C9              1209          RET
                       1210  ;
```

> *Uncertain:* none.
> *Transcriber's note:* the listing ends at line 1210 about a quarter of the way down; the rest of the sheet is blank. This scan is heavily mottled (dark, noisy background) but the printed text is dark enough to read. There is no black bar on this page; the black bar in this range is on PDF page 27 (see its notes). Line 1211 is not printed anywhere; the next page starts at 1212 with a `SUBTTL`, so 1211 is presumably the page-eject directive that forced the new page.

<!-- PDF page 30 — listing "Page 14" — INTERNAL SUB-RTNS. — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       1212          SUBTTL  INTERNAL SUB-RTNS.
                       1213  ;
                       1214  ;
                       1215  ;
                       1216                          ; INPUT:  VIDEO MODE IN A
                       1217                          ; OUTPUT: H/W SETTING IN B
                       1218                          ;         VIDMOD SETTING IN C
                       1219                          ; RETURNS NZ STATUS IF MODE INVALID
                       1220                          ;
                       1221                          ;  VALID VALUES:  INPUT     H/W     VIDMOD
                       1222                          ;                 -----     ---     ------
                       1223                          ;   *=DISPLAY FILE ACTIVE AT SCREEN
                       1224                          ;
                       1225                          ;    DF1 ONLY          0        0         0
                       1226                          ;   DF1*& DF2         80        0        80
                       1227                          ;   DF1 & DF2*         1        1        81
                       1228                          ;  HIGH RES.GR.        2        2         2
                       1229                          ;  64/80-COLUMN  06 - 3E  06 - 3E    46 - 7E
05CD'  4F              1230  GETVAL  LD      C,A
05CE'  CB 47           1231          BIT     0,A
05D0'  20 16           1232          JR      NZ,TST01
05D2'  FE 80           1233          CP      80H
05D4'  28 1A           1234          JR      Z,SET0
05D6'  CB 7F           1235          BIT     7,A
05D8'  C0              1236          RET     NZ
05D9'  47              1237          LD      B,A
05DA'  FE 02           1238          CP      2
05DC'  C8              1239          RET     Z
05DD'  E6 C6           1240          AND     0C6H
05DF'  EE 06           1241          XOR     6
05E1'  C0              1242          RET     NZ
05E2'  3E 40           1243          LD      A,40H
05E4'  B1              1244          OR      C
05E5'  4F              1245          LD      C,A
05E6'  AF              1246          XOR     A
05E7'  C9              1247          RET
05E8'  FE 01           1248  TST01   CP      1
05EA'  C0              1249          RET     NZ
05EB'  06 01           1250          LD      B,1
05ED'  0E 81           1251          LD      C,81H
05EF'  C9              1252          RET
05F0'  AF              1253  SET0    XOR     A
05F1'  47              1254          LD      B,A
05F2'  C9              1255          RET
                       1256  ;
                       1257  ;
                       1258                          ; ROUTINES TO ENABLE CHUNK 0 IN ROM EXT.
                       1259                          ; FOR ACCESS TO CHNGVID ROUTINE
05F3'  F5              1260  ENBLEXT PUSH    AF
05F4'  DB FF           1261          IN      A,(HREXPT)
05F6'  F6 80           1262          OR      80H             ; SELECT ROM EXT.
05F8'  D3 FF           1263          OUT     (HREXPT),A
```

> *Uncertain:* none.
> *Transcriber's note:* on this page the comment-only lines (1216–1229, 1258–1259) and the inline comment on 1262 are printed at source column 24, not 32; the comment-only lines are kept at column 24 as printed, and the inline comment is normalised to column 32. The internal spacing of the VALID VALUES table (lines 1221–1229) was measured off the scan character by character. In the table, `*` marks the display file active at the screen. Labels `SET0` and `TST01` and `CHUNK 0` use the round digit zero, not the boxy letter O. A short pen stroke in the left margin points at line 1242.

<!-- PDF page 31 — listing "Page 14-1" — INTERNAL SUB-RTNS. — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
05FA'  3E 03           1264          LD      A,3
05FC'  D3 F4           1265          OUT     (DKHSPT),A
05FE'  F1              1266          POP     AF
05FF'  C9              1267          RET
                       1268  ;
0600'  F5              1269  ENBLHOME PUSH   AF
0601'  AF              1270          XOR     A
0602'  D3 F4           1271          OUT     (DKHSPT),A
0604'  DB FF           1272          IN      A,(HREXPT)
0606'  E6 3F           1273          AND     03FH
0608'  D3 FF           1274          OUT     (HREXPT),A
060A'  F1              1275          POP     AF
060B'  C9              1276          RET
                       1277  ;
                       1278                                  ; TEST PARAMETER VALIDITY
                       1279                                  ; IF NOT VALID, DISCARDS RETURN
                       1280                                  ; AND EXITS VIA INVPAR
060C'  3E 17           1281  TSTPAR  LD      A,23            ; TEST LINE >23
060E'  B8              1282          CP      B
060F'  30 04           1283          JR      NC,TSTPR1
0611'  F1              1284  PARERR  POP     AF
0612'  C3 00C4'        1285          JP      INVPAR
0615'  3A 0033'        1286  TSTPR1  LD      A,(LINLEN)
0618'  3D              1287          DEC     A
0619'  B9              1288          CP      C               ; TEST COL. >31
061A'  38 F5           1289          JR      C,PARERR
061C'  C9              1290          RET
                       1291  ;                               ; CONVERT LINE/COL. FROM USER TO
                       1292                                  ; INTERNAL FORMAT AND VICE VERSA
                       1293                                  ; USER FORMAT:  LINES 0-23
                       1294                                  ;               COL.0-31
                       1295                                  ; INTERNAL FORMAT: LINES 24-1
                       1296                                  ;                  COL.  33-2
                       1297                                  ;                 (COL.1 END OF LINE)
061D'  3A 0033'        1298  CONVFM  LD      A,(LINLEN)
0620'  3C              1299          INC     A
0621'  91              1300          SUB     C
0622'  4F              1301          LD      C,A
0623'  3E 18           1302          LD      A,SCRSZ
0625'  90              1303          SUB     B
0626'  47              1304          LD      B,A
0627'  C9              1305          RET
                       1306  ;
                       1307  ;
                       1308  ;
0628'                  1309  UPDPOSN                         ; ENTER HERE WITH BC=LINE/COL.IN
                       1310                                  ; INTERNAL FORMAT
0628'  CD 062D'        1311          CALL    CALCPOS         ; CALCULATE POSITION
062B'  18 28           1312          JR      STPOSN          ; STORE UPDATED POSITION AND RETURN
                       1313  ;
                       1314  ;
                       1315  ;                               ; ROUTINE TO CALCULATE POSITION IN DF
```

> *Uncertain:* none.
> *Transcriber's note:* on line 1288 the inline comment is printed at source column 24 and is normalised to 32 here. The comment-only lines 1278–1280 and 1292–1297 are printed at column 32 and kept there, with their internal alignment measured off the scan. `ENBLHOME` (line 1269) is 8 characters long, so its opcode is separated by a single space.

<!-- Transcription of ADL - ASC 004 DUAL SCREEN MODE SUPPORT, CRZ80/11 version 10.36.14, 22-Feb-84 11:42:6 — PDF pages 32–38 -->

<!-- PDF page 32 — listing "Page 14-2" — INTERNAL SUB-RTNS. — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       1316                                  ; RETURNS DF ADRS. IN HL.  PRESERVES
                       1317                                  ; LINE/COLUMN POSITION IN BC
                       1318  ;
062D'  CD 063A'        1319  CALCPOS CALL    LNBU            ; GET DISPLAY FILE ADRS.
0630'  3A 0033'        1320          LD      A,(LINLEN)      ; ADD COLUMN OFFSET
0633'  3C              1321          INC     A
0634'  91              1322          SUB     C
0635'  5F              1323          LD      E,A
0636'  16 00           1324          LD      D,0
0638'  19              1325          ADD     HL,DE
0639'  C9              1326          RET
                       1327  ;
                       1328  ;
063A'                  1329  LNBU:                           ; GET DISPLAY FILE ADDRESS
                       1330                                  ; FOR START OF LINE IN B
063A'  3E 18           1331          LD      A,SCRSZ
063C'  90              1332          SUB     B
063D'  57              1333          LD      D,A
063E'  0F              1334          RRCA
063F'  0F              1335          RRCA
0640'  0F              1336          RRCA
0641'  E6 E0           1337          AND     0E0H
0643'  6F              1338          LD      L,A
0644'  7A              1339          LD      A,D
0645'  E6 18           1340          AND     18H
0647'  F6 40           1341          OR      40H
0649'  67              1342          LD      H,A
064A'  3A 5CC2         1343          LD      A,(VIDMOD)
064D'  CB 47           1344          BIT     0,A             ; TEST IF DF1
064F'  C8              1345          RET     Z
0650'  3E 20           1346          LD      A,20H           ; SET TO DF2
0652'  B4              1347          OR      H
0653'  67              1348          LD      H,A
0654'  C9              1349          RET
                       1350
0655'                  1351  STPOSN:                         ; STORE CURSOR POSITION
0655'  ED 43 0034'     1352          LD      (CURPOS),BC
0659'  22 0036'        1353          LD      (DFADRS),HL
065C'  C9              1354          RET
                       1355  ;
065D'                  1356  LDPOSN:                         ; LOAD CURSOR POSITION
065D'  ED 4B 0034'     1357          LD      BC,(CURPOS)
0661'  2A 0036'        1358          LD      HL,(DFADRS)
0664'  C9              1359          RET
                       1360  ;
                       1361  ;
                       1362  ;
                       1363  ;
0665'                  1364  UPDATT:                         ; UPDATE ATTRIBUTE BYTE FOR CHARACTER
                       1365                                  ; JUST PRINTED
                       1366                                  ; HL = ANY SCAN OF CHAR.IN DF
                       1367  ;
```

> *Transcriber's note:* Lines 1316–1317 continue a comment block from the previous page. Lines 1331–1333 are printed with the operand one space after the mnemonic (`LD A,SCRSZ`, `SUB B`, `LD D,A`); re-spaced here to the standard operand column.

<!-- PDF page 33 — listing "Page 14-3" — INTERNAL SUB-RTNS. — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0665'  CD 0692'        1368          CALL    CALCATT         ; ADRS. OF ATTRIBUTE BYTE TO HL
0668'  3A 0039'        1369          LD      A,(ATTBYT)      ;
066B'  5F              1370          LD      E,A             ; CURRENT ATTR.VALUE TO E
066C'  3A 003F'        1371          LD      A,(ATTMSK)      ;
066F'  57              1372          LD      D,A             ; MASK TO D
0670'  3A 0038'        1373          LD      A,(MASKB)
0673'  47              1374          LD      B,A             ; FLAGS TO B
0674'  7E              1375          LD      A,(HL)          ; BYTE FROM ATTRIBUTE FILE
0675'  AB              1376          XOR     E
0676'  A2              1377          AND     D
0677'  AB              1378          XOR     E               ; NEW ATTR.FOR 0; OLD FOR 1
0678'  CB 60           1379          BIT     4,B             ; SET INK COMPLEMENT OF PAPER?
067A'  28 08           1380          JR      Z,UPDAT1        ;
067C'  E6 F8           1381          AND     0F8H            ; SET INK TO BLACK
067E'  CB 6F           1382          BIT     5,A             ; IS PAPER 4-7
0680'  20 02           1383          JR      NZ,UPDAT1       ; YES - USE BLACK INK
0682'  F6 07           1384          OR      7               ; NO -  USE WHITE INK
0684'  CB 70           1385  UPDAT1  BIT     6,B             ; SET PAPER COMPLEMENT OF INK?
0686'  28 08           1386          JR      Z,UPDAT2        ;
0688'  E6 C7           1387          AND     0C7H            ; SET PAPER TO BLACK
068A'  CB 57           1388          BIT     2,A             ; IS INK 4-7
068C'  20 02           1389          JR      NZ,UPDAT2       ; YES - USE BLACK PAPER
068E'  F6 38           1390          OR      38H             ; NO -  USE WHITE PAPER
0690'  77              1391  UPDAT2  LD      (HL),A          ; TO ATTRIBUTE FILE
0691'  C9              1392          RET
                       1393  ;
                       1394  ;                               ; SUB-RTN. TO CALCULATE ADRS. OF
                       1395  ;                               ; ATTRIBUTE BYTE FROM ADRS. OF
                       1396  ;                               ; ANY SCAN ROW IN DF
                       1397  ;
0692'  7C              1398  CALCATT LD      A,H             ; UPPER BYTE OF ADDRESS
0693'  0F              1399          RRCA
0694'  0F              1400          RRCA
0695'  0F              1401          RRCA
0696'  E6 03           1402          AND     03H
0698'  F6 58           1403          OR      58H
069A'  CB 6C           1404          BIT     5,H             ; TEST WHICH DF
069C'  28 02           1405          JR      Z,CALCA1
069E'  F6 20           1406          OR      20H             ; DF2
06A0'  67              1407  CALCA1  LD      H,A             ; ADRS. OF ATTRIBUTE IN DF2
06A1'  C9              1408          RET
                       1409  ;
06A2'                  1410  LDATTR                          ; LOAD INTERNAL ATTRIBUTE VARIABLES
                       1411                                  ; FROM SYSTEM VARIABLES
06A2'  F5              1412          PUSH    AF              ; SAVE A
06A3'  3A 5C8D         1413          LD      A,(ATTR_P)      ;
06A6'  32 0039'        1414          LD      (ATTBYT),A      ;
06A9'  3A 5C8E         1415          LD      A,(MASK_P)      ;
06AC'  32 003F'        1416          LD      (ATTMSK),A      ;
06AF'  3A 5C91         1417          LD      A,(P_FLAG)      ;
06B2'  0F              1418          RRCA                    ; SHIFT ODD BITS TO EVEN
06B3'  32 0038'        1419          LD      (MASKB),A       ;
```

> *Transcriber's note:* Line 1373 has no comment; there is a stray dot on the paper where the `;` would be. Line 1410 label `LDATTR` is printed without a colon. `NO -  USE WHITE INK/PAPER` (lines 1384, 1390) has two spaces after the dash, as printed.

<!-- PDF page 34 — listing "Page 14-4" — INTERNAL SUB-RTNS. — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
06B6'  F1              1420          POP     AF
06B7'  C9              1421          RET
                       1422  ;
06B8'  3A 5CC3         1423  GETSTRG LD      A,(PARAM$)      ; GET STRING ID
06BB'  E6 1F           1424          AND     1FH             ; MASK OFF UPPER BITS
06BD'  F6 40           1425          OR      40H             ; STRING VARIABLE IDENTIFIER
06BF'  57              1426          LD      D,A             ; SAVE IN D
06C0'  2A 5C4B         1427          LD      HL,(VARS)       ; FIND STRING
06C3'  7E              1428  GTSTR1  LD      A,(HL)          ;
06C4'  E6 7F           1429          AND     07FH            ; TEST IF END OF VARS AREA
06C6'  28 13           1430          JR      Z,NOSTRG        ; NO FIND - RETURN BC=2
06C8'  BA              1431          CP      D               ; TEST IF MATCH
06C9'  28 08           1432          JR      Z,GTSTR2        ; FOUND STRING
06CB'  D5              1433          PUSH    DE              ; SAVE STRING ID
06CC'  CD 1720         1434          CALL    RECLEN          ; RETURNS ADRS. OF NEXT VAR. IN DE
06CF'  EB              1435          EX      DE,HL           ; ADRS. TO HL
06D0'  D1              1436          POP     DE              ; RESTORE STRING ID
06D1'  18 F0           1437          JR      GTSTR1          ; LOOK AGAIN
06D3'  23              1438  GTSTR2  INC     HL              ; GET LENGTH
06D4'  4E              1439          LD      C,(HL)
06D5'  23              1440          INC     HL
06D6'  46              1441          LD      B,(HL)
06D7'  23              1442          INC     HL              ; FIRST TEXT CODE
06D8'  78              1443          LD      A,B             ; TEST IF NULL STRING
06D9'  B1              1444          OR      C
06DA'  C9              1445          RET                     ; RETURN (Z IF NULL STRING/NZ IF NOT)
                       1446  ;
06DB'  0E 02           1447  NOSTRG  LD      C,2
06DD'  06 00           1448          LD      B,0
06DF'  C9              1449          RET                     ; (Z AND BC=2 FOR NO FIND)
                       1450  ;
                       1451  ;
```

> *Transcriber's note:* The listing ends at line 1451; the rest of the page is blank. Line 1452 does not appear anywhere (gap between this page and the next). It was probably a page-eject or title directive that the assembler does not list.

<!-- PDF page 35 — listing "Page 15" — GRAPHICS CHAR.SET — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
                       1453          SUBTTL  GRAPHICS CHAR.SET
                       1454  ;
                       1455  ;                               ;PIXEL PATTERNS FOR STD.GRAPHICS SET
                       1456  ;                               ; 0=BACKGROUND(PAPER) 1=FOREGROUND(INK)
                       1457  ;
06E0'  00              1458  GRPST   defb    00000000b       ; code 80       graphics space
06E1'  00              1459          defb    00000000b
06E2'  00              1460          defb    00000000b
06E3'  00              1461          defb    00000000b
06E4'  00              1462          defb    00000000b
06E5'  00              1463          defb    00000000b
06E6'  00              1464          defb    00000000b
06E7'  00              1465          defb    00000000b
                       1466  ;
06E8'  0F              1467          defb    00001111b       ; code 81       graphics
06E9'  0F              1468          defb    00001111b
06EA'  0F              1469          defb    00001111b
06EB'  0F              1470          defb    00001111b
06EC'  00              1471          defb    00000000b
06ED'  00              1472          defb    00000000b
06EE'  00              1473          defb    00000000b
06EF'  00              1474          defb    00000000b
                       1475  ;
                       1476
06F0'  F0              1477          defb    11110000b       ; code 82       graphics
06F1'  F0              1478          defb    11110000b
06F2'  F0              1479          defb    11110000b
06F3'  F0              1480          defb    11110000b
06F4'  00              1481          defb    00000000b
06F5'  00              1482          defb    00000000b
06F6'  00              1483          defb    00000000b
06F7'  00              1484          defb    00000000b
                       1485
06F8'  FF              1486          defb    11111111b       ; code 83       graphics
06F9'  FF              1487          defb    11111111b
06FA'  FF              1488          defb    11111111b
06FB'  FF              1489          defb    11111111b
06FC'  00              1490          defb    00000000b
06FD'  00              1491          defb    00000000b
06FE'  00              1492          defb    00000000b
06FF'  00              1493          defb    00000000b
                       1494
                       1495  ;
0700'  00              1496          defb    00000000b       ; code 84       graphics
0701'  00              1497          defb    00000000b
0702'  00              1498          defb    00000000b
0703'  00              1499          defb    00000000b
0704'  0F              1500          defb    00001111b
0705'  0F              1501          defb    00001111b
0706'  0F              1502          defb    00001111b
0707'  0F              1503          defb    00001111b
                       1504  ;
```

> *Transcriber's note:* A new section, GRAPHICS CHAR.SET. A vertical scanner shadow band runs down the page between the operand and comment columns; nothing is lost under it. Every `defb` hex byte agrees with its binary operand. Lines 1476, 1485 and 1494 are blank, with no `;`. `SUBTTL` is printed with one space before its operand; re-spaced here. In the comments, `graphics` sits 16 columns after the `;`.

<!-- PDF page 36 — listing "Page 15-1" — GRAPHICS CHAR.SET — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0708'  0F              1505          defb    00001111b       ; code 85       graphics
0709'  0F              1506          defb    00001111b
070A'  0F              1507          defb    00001111b
070B'  0F              1508          defb    00001111b
070C'  0F              1509          defb    00001111b
070D'  0F              1510          defb    00001111b
070E'  0F              1511          defb    00001111b
070F'  0F              1512          defb    00001111b
                       1513
                       1514
0710'  F0              1515          defb    11110000b       ; code 86        graphics
0711'  F0              1516          defb    11110000b
0712'  F0              1517          defb    11110000b
0713'  F0              1518          defb    11110000b
0714'  0F              1519          defb    00001111b
0715'  0F              1520          defb    00001111b
0716'  0F              1521          defb    00001111b
0717'  0F              1522          defb    00001111b
                       1523  ;
0718'  FF              1524          defb    11111111b       ;code 87        graphics
0719'  FF              1525          defb    11111111b
071A'  FF              1526          defb    11111111b
071B'  FF              1527          defb    11111111b
071C'  0F              1528          defb    00001111b
071D'  0F              1529          defb    00001111b
071E'  0F              1530          defb    00001111b
071F'  0F              1531          defb    00001111b
                       1532  ;
0720'  00              1533          defb    00000000b       ; code 88       graphics
0721'  00              1534          defb    00000000b
0722'  00              1535          defb    00000000b
0723'  00              1536          defb    00000000b
0724'  F0              1537          defb    11110000b
0725'  F0              1538          defb    11110000b
0726'  F0              1539          defb    11110000b
0727'  F0              1540          defb    11110000b
                       1541  ;
0728'  0F              1542          defb    00001111b       ; code 89        graphics
0729'  0F              1543          defb    00001111b
072A'  0F              1544          defb    00001111b
072B'  0F              1545          defb    00001111b
072C'  F0              1546          defb    11110000b
072D'  F0              1547          defb    11110000b
072E'  F0              1548          defb    11110000b
072F'  F0              1549          defb    11110000b
                       1550  ;
0730'  F0              1551          defb    11110000b       ; code 8A       graphics
0731'  F0              1552          defb    11110000b
0732'  F0              1553          defb    11110000b
0733'  F0              1554          defb    11110000b
0734'  F0              1555          defb    11110000b
0735'  F0              1556          defb    11110000b
```

> *Transcriber's note:* Same shadow band as the previous page. Every `defb` hex byte agrees with its binary operand. Lines 1513–1514 are blank, with no `;`. Line 1524 is printed `;code 87`, with no space. For codes 86 and 89, `graphics` is printed one column further right than on the other lines; that offset is kept here.

<!-- PDF page 37 — listing "Page 15-2" — GRAPHICS CHAR.SET — IODS.SRC -->

```text
LOC    OBJ            LINE  SOURCE
0736'  F0              1557          defb    11110000b
0737'  F0              1558          defb    11110000b
                       1559  ;
0738'  FF              1560          defb    11111111b       ; code 8B       graphics
0739'  FF              1561          defb    11111111b
073A'  FF              1562          defb    11111111b
073B'  FF              1563          defb    11111111b
073C'  F0              1564          defb    11110000b
073D'  F0              1565          defb    11110000b
073E'  F0              1566          defb    11110000b
073F'  F0              1567          defb    11110000b
                       1568  ;
0740'  00              1569          defb    00000000b       ; code 8C       graphics
0741'  00              1570          defb    00000000b
0742'  00              1571          defb    00000000b
0743'  00              1572          defb    00000000b
0744'  FF              1573          defb    11111111b
0745'  FF              1574          defb    11111111b
0746'  FF              1575          defb    11111111b
0747'  FF              1576          defb    11111111b
                       1577  ;
0748'  0F              1578          defb    00001111b       ; code 8D       graphics
0749'  0F              1579          defb    00001111b
074A'  0F              1580          defb    00001111b
074B'  0F              1581          defb    00001111b
074C'  FF              1582          defb    11111111b
074D'  FF              1583          defb    11111111b
074E'  FF              1584          defb    11111111b
074F'  FF              1585          defb    11111111b
                       1586  ;
0750'  F0              1587          defb    11110000b       ;code 8E        graphics
0751'  F0              1588          defb    11110000b
0752'  F0              1589          defb    11110000b
0753'  F0              1590          defb    11110000b
0754'  FF              1591          defb    11111111b
0755'  FF              1592          defb    11111111b
0756'  FF              1593          defb    11111111b
0757'  FF              1594          defb    11111111b
                       1595  ;
0758'  FF              1596          defb    11111111b       ;code 8F        graphics
0759'  FF              1597          defb    11111111b
075A'  FF              1598          defb    11111111b
075B'  FF              1599          defb    11111111b
075C'  FF              1600          defb    11111111b
075D'  FF              1601          defb    11111111b
075E'  FF              1602          defb    11111111b
075F'  FF              1603          defb    11111111b
                       1604
                       1605          END
```

> *Transcriber's note:* This page is much fainter, a lighter print pass, and the horizontal registration differs from the earlier pages. Shadow band on the right. Every `defb` hex byte agrees with its binary operand. Lines 1587 and 1596 are printed `;code 8E` / `;code 8F`, with no space. Line 1604 is blank, and line 1605 is `END`. The 16 characters on pages 35–37 (codes 80h–8Fh) are the standard Sinclair 2×2 block graphics.

<!-- PDF page 38 — listing "Page S-1" — GRAPHICS CHAR.SET — IODS.SRC (symbol table) -->

```text
A       Reserved   ATTBYT   0039      ATTMSK   003F      ATTR$P   5C8D      B       Reserved
BOTLN    002D      C       Reserved   CALCAT   0692      CALCA1   06A0      CALCPO   062D
CHNGVI   0E8E      CHRSET   3C00      CHTBL    002F      CH$ADD   5C5D      CLINIT   1800
CLRCTL   000C      CLRSB0   01D4      CLRSCB   000E IN   CLRSCN   01D8 IN   CLRSC0   01EE
CLRSC1   0202      CLRSC2   020D      CLRSC3   0211      CLRSC4   0214      CLRSC5   021F
CLRSC7   0254      CLRSXT   0250      CONVFM   061D      COORDS   5C7D      COPERR   0435
COPER1   0436      COPYSB   0040 IN   COPYSC   043D IN   COPYS0   03DA      COPYS1   045D
COPYS2   0477      COPYS3   047B      COPYS4   047E      COPYS5   04DB      COPYS6   04E9
COPYS7   04F0      COPYWK   03E8      COPYXT   04C2      COPY01   03EC      COPY41   048D
COPY42   04AF      CURPOS   0034      D       Reserved   DATAB    0000      DEST7    F7C0
DFADRS   0036      DKHSPT   00F4      DRIVES   6840      DTADF1   03C8      DTADF2   03D2
E       Reserved   ENBLEX   05F3      ENBLHO   0600      ERRRET   00C1      EXCHLP   0593
EXCHSB   0043 IN   EXCHSC   052D IN   EXCHS0   04F5      EXCHXT   0579      EXCH0    054F
EXCH01   0503      EXCH1    0551      EXTNRM   03B5      FIX      97C0      FIXTBL   1D00
FP2A     3193      FRFV     03BA      GAERR    05CB      GETAB0   02DC      GETATB   001E IN
GETATT   02E0 IN   GETCB0   02F1      GETCTL   0019      GETCUB   0021 IN   GETCUR   02F1 IN
GETC1    0309      GETNO    0418      GETN1    0428      GETN2    042F      GETSTR   06B8
GETVAL   05CD      GOODRE   00BF      GRBLK    01A9      GRPHST   05E0      GRPST    06E0
GRTBL    0031      GTADRS   05A8      GTADR1   05C9      GTCHAR   0260 IN   GTCHB0   025C
GTCHRB   001B IN   GTCH1    0271      GTCH2    0276      GTCH23   0288      GTCH3    028D
GTCH31   0290      GTCH32   02AB      GTCH4    02AF      GTCH5    02CA      GTCH6    02D9
GTINDX   003A      GTSTR1   06C3      GTSTR2   06D3      H       Reserved   HREXPT   00FF
ININT    30F9      INSDBL   015F      INSERT   12C0      INVPAR   00C4      L       Reserved
LDATTR   06A2      LDPOSN   065D      LINCOL   0007      LINLEN   0033      LNBU     063A
LOOP     0163      LOOP0    0166      LOOP1    016E      M       Reserved   MASKB    0038
MASK$P   5C8E      MOVESZ   0840      NOSTRG   06DB      PARAM$   5CC3      PARERR   0611
PRAMT    5CB4      PSW     Reserved   P$FLAG   5C91      RAMTOP   5CB2      RECLEN   1720
SCINIT   1701      SCRCTL   0028      SCRLB    002A IN   SCRLB0   0127      SCRLCT   002E
SCRLXT   0186      SCRL0    0141      SCROLL   012B IN   SCRSZ    0018      SETCB0   0117
SETCUB   0009 IN   SETCUR   011B IN   SETMDB   0025 IN   SETMD0   032A      SETMD1   0334
SETMD2   038A      SETMD3   039F      SETMOD   0311 IN   SETM21   0397      SET0     05F0
SP      Reserved   SPARE0   0011      SPARE1   0013      SPARE2   0015      SPARE3   0017
SPARE4   003D      STBLK    01B1      STBLK0   01B5      STBLK1   01B6      STKEND   5C65
STMDB0   030E      STPOSN   0655      STRGCT   003B      TESTAD   0151      TSTPAR   060C
TSTPR1   0615      TST01    05E8      TVFULQ   00C8      TVFUL1   00E4      UDG      5C7B
UPDATE   03A2      UPDATT   0665      UPDAT1   0684      UPDAT2   0690      UPDPOS   0628
VARS     5C4B      VIDMOD   5CC2      VIMODE   0024      WRCHAR   0049 IN   WRCHRB   0001 IN
WRCHXT   00BC      WRCH0    0046      WRCH01   004C      WRCH11   006B      WRCH12   0073
WRCH13   0077      WRCH14   008D      WRCH15   008E      WRCH2    0094      WRCH3    009F
WRCH5    00A7      WRCH7    00B3      WRSTLP   00F5      WRSTRB   0004 IN   WRSTRG   00F2 IN
WRSTR0   00EE      WRSTR3   00FF      WRSTX1   0108      WRSTX2   0114

     No errors detected
```

> *Uncertain:* `GETNO` (col 2) and `ENBLHO` (col 3): the last character has the square letter-O shape, not the oval zero, so it is read as the letter O (D is just possible). `GTCHRB 001B` has a stray mark on the `B`. `STBLK 01B1` / `STBLK0 01B5` / `STBLK1 01B6`: the third digit is read as `B` from its flat left side (`8` is just possible). `FIXTBL 1D00` is read with `D`, not `0`.

> *Transcriber's note:* This page is the symbol table, which the listing-line format does not cover. It is given in its printed five-column, row-major layout, with no LOC/OBJ header row. `IN` is printed after some values, and its meaning is not stated on the page. The names are sorted with letters before digits before `$`, and every row checks against that order. A heavy vertical scanner shadow band runs through column 4; the image was background-flattened to read it. The code-label values agree with the listing on pages 32–37: LNBU 063A, CALCAT 0692, CALCA1 06A0, UPDATT 0665, UPDAT1 0684, UPDAT2 0690, LDATTR 06A2, GETSTR 06B8, GTSTR1 06C3, GTSTR2 06D3, NOSTRG 06DB, STPOSN 0655, LDPOSN 065D, CALCPO 062D, GRPST 06E0, and LINLEN, CURPOS, DFADRS, ATTBYT, ATTMSK, MASKB, SCRSZ, VIDMOD, VARS, PARAM$ and RECLEN.

> *Transcriber's note:* Handwriting at the right edge, written vertically (rotated 90°) in ink: **George Kibby** / **Amity Consultants** / **372-4316**. The final letter of "Kibby" is overwritten or corrected (the `y` is written over another letter or crossed through). The bottom margin has a dark scanner band.

