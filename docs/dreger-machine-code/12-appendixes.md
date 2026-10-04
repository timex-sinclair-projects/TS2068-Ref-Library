<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 191–213. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Appendixes.*
*[← previous](11-chapter-10-io-and-bank-switching.md) · [book README](README.md) · [next →](13-original-index.md)*

---

<!-- p. 191 (pdf 201) -->

# Appendixes

These appendixes are designed to give you an easy and quick reference to most of the things you will want to look up.

A detailed list of the precise effects of each Z80 instruction may be found in Chapters 6 and 7 and should be treated as an addition to these tables.

The appendixes are as follows:

| | |
|---|---|
| APPENDIX A | TIMING TABLES |
| APPENDIX B | A MACHINE CODE PRINT and INPUT Routine |
| APPENDIX C | MACHINE CODES BY NUMBERS |
| APPENDIX D | MACHINE CODES BY FUNCTIONS (DEC and HEX) |
| APPENDIX E | ADDRESS and NUMBER CONVERSION TABLES |
| APPENDIX F | Bibliography and Copyright acknowledgements |

<!-- p. 192 (pdf 202) -->

## Appendix A: Timing Tables

```text
Abbreviations: r = register   i = Index register(IX,IY)
               n = number     b = bit number
               ct = condition true   cf = condition false

LD r, r        4    ADD r          4    OUT (n), A/IN A, (n)  11
LD r, n/(HL)   7    ADD n          7    OUT (C), r/IN r, (C)  12
LD (HL), r     7    ADD (HL)       7
LD A, (rr)     7    ADD (i+d)     19    LDI/LDD/CPI/CPD/INI
LD (rr), A     7                        IND/OUTI/OUTD         16
LD (HL), n    10    ADC   as
LD A, (nn)    13    SUB   in            LDIR/LDDR
LD (nn), A    13    SBC   the           CPIR/CPDR  BC <> 0    21
LD r, (i+d)   19    AND   four          INIR/INDR  BC  = 0    16
LD (i+d), r   19    OR    cases         OTIR/OTDR
LD (i+d), n   19    CP    above
LD A, I/R      9                        nop             4
LD I/R, A      9    DEC/INC r       4   HALT            4
LD rr, nn     10    DEC/INC (HL)   11   DI/EI           4
LD HL, (nn)   16    DEC/INC (i+d)  23   IM0/IM1/IM2     8
LD rr, (nn)   20    DEC/INC rr      6
LD i, (nn)    20    DEC/INC i      10   PUSH rr        11
LD (nn), HL   16                        POP rr         10
LD (nn), i    20    ADD HL, rr     11   PUSH i         15
LD SP, HL      6    ADC HL, rr     15   POP i          14
LD SP, i      10    SBC HL, rr     15
                    ADD i, rr      15   EX DE, HL       4
JP nn         10                        EX AF, AF'      4
JP c, nn      10    RLC r           8   EXX             4
JR ct, d      12    RLC (HL)       15   EX (SP), HL    19
   cf, d       7    RLC (i+d)      23   EX (SP), i     23
JR d          12
JP (HL)        4    RL    as            BIT b, r        8
JP (i)         8    RR    in            BIT b, (HL)    12
DJNZ B = 0     8    RRC   the           BIT b, (i+d)   20
     B <> 0   13    SLA   three         RES/SET b, r        8
                    SRA   cases         RES/SET b, (HL)    15
CALL nn       17    SRL   above         RES/SET b, (i+d)   23
CALL cf, nn   10
     ct, nn   17    RLCA/RLA/RRCA/RRA   4
                    RLD/RRD            18
RST           11    DAA                 4
RET           10    CPL                 4
RET cf         5    NEG                 8
    ct        11    SCF/CCF             4
RET I/R       14
```

*Corrections in the table above:* LD HL, (nn)[^c10-3]; SRL[^c10-4].

The extra instruction set involving the High or Low bit of the Index Registers have cycle times 4 T states longer than their H and L equivalents.[^c10-5]

<!-- p. 193 (pdf 203) -->

## Appendix B: A Machine Code Print & Input Routine

### A Print Routine That Works Like a Basic Print Statement

This routine is address independent. It will print normal letters, numbers and characters as well as graphics and UDG's but not tokens. Tokens not activated will print as "?".

However, the following tokens are activated and can be used in data statements:

```text
     INK   217  Follow by color 1-7 in next byte
   PAPER   218  Follow by color 1-7 in next byte
   FLASH   219  Follow by 0 for off, 1 for on in next byte
  BRIGHT   220  Follow by 0 for off, 1 for on in next byte
 INVERSE   221  Follow by 0 for off, 1 for on in next byte
    OVER   222  Follow by 0 for off, 1 for on in next byte
NEW LINE    13  Start a new line--Print apostrophe.
      AT   172  Follow by line # and column # in next two bytes
     TAB   173  Follow by column # in next byte
     END     0  To indicate end of message.
```

```text
TO SETUP: LD DE with your data base address.
          LD HL with your print start address (or start your
            data with an AT statement).
```

The following Basic line:

```basic
PRINT AT 1,13; PAPER 6; INK 4; FLASH 1; "Hello.";
FLASH 0; TAB 7; INK 2; PAPER 5; "I'm your friendly";
PAPER 6; INK 0; '' TAB 5; "                      ";
TAB 5; " "; INVERSE 1; "TIMEX/SINCLAIR 2068"; INVERSE
0; " "; TAB 5; "                      "; '' TAB 11; INK
1; BRIGHT 1; "Computer"; '' TAB 5; "What is your
name?"; AT 13,14; OVER 1; "____ ____"; OVER 0;
BRIGHT 0      NOTE: Graphic A is [box symbol].
```

Would be encoded as: (Underlines show the print control characters encoded.)

```text
64000  172,1,13,218,6,217,4,219,1,72
       -------- ----- ----- -----
64010  101,108,108,111,46,219,0,173,7,217
                          ----- ----- ---
64020  2,218,5,73,39,109,32,121,111,117
       - -----
64030  114,32,102,114,105,101,110,100,108,121
64040  218,6,217,0,13,13,173,5,139,131
       ----- ----- -- -- -----
64050  131,131,131,131,131,131,131,131,131,131
64060  131,131,131,131,131,131,131,131,135,173
                                           ---
64070  5,138,221,1,84,73,77,69,88,47
       -     -----
64080  83,73,78,67,76,65,73,82,32,50
64090  48,54,56,221,0,133,173,5,142,140
                -----     -----
64100  140,140,140,140,140,140,140,140,140,140
64110  140,140,140,140,140,140,140,140,141,13
64120  13,173,11,217,1,220,1,67,111,109
       -- ------ ----- -----
64130  112,117,116,101,114,46,13,13,173,5
                              -- -- -----
```

*Corrections in the data above:* 64024[^c10-6]; 64030[^c10-7]; 64046[^c10-8]; 64087[^c10-9]; "Computer."[^c10-10].

<!-- p. 194 (pdf 204) -->

```text
64140  144,87,104,97,116,32,105,115,32,121
64150  111,117,114,32,110,97,109,101,63,172
                                        ---
64160  12,14,222,1,95,95,95,95,32,95
       ----- -----
64170  95,95,95,222,0,220,0,0
                ----- -----
```

*Corrections in the data above:* "name?"[^c10-11]; AT 12,14[^c10-12]; BRIGHT 0[^c10-13].

The main differences are the omission of all quote marks, commas, and semi-colons.

NOTE: This routine will print to all 24 lines of the screen. However, the last 2 lines will disappear as soon as the program returns to Basic and the computer needs to print an error message on them. It will also return when out of screen rather than prompt for a scroll. A CLS routine, not part of the above PRINT program is also included at address 65152. An INPUT routine to answer the question asked by the text is given at address 65184. I use this routine in my basic machine code class to familiarize students with the operation of registers and other techniques common to writing code. The explanation of what is going on and why are part of the class presentation and are not included in the program. I, therefore, leave it up to the student to supply them. Start reading at address 65000. Should you wish a tape of this program, kindly send $4 in care of SMUG at the address on the title page.

```z80
64724  26              INK  LD A, (DE)
64725  254,8                CP 8
64727  48,66                JR NC, OUT
64729  79                   LD C, A
64730  58,143,92            LD A, (23695) ATTR T
64733  230,248              AND 248
64735  177                  OR C
64736  24,54                JR  LD ATTR 1

64738  26            PAPER  LD A, (DE)
64739  254,8                CP 8
64741  48,52                JR NC, OUT
64743  167                  AND A
64744  23                   RLA
64745  23                   RLA
64746  23                   RLA
64747  79                   LD C, A
64748  58,143,92            LD A, (23695) ATTR T
64751  230,199              AND 199
64753  177                  OR C
64754  24,36                JR  LD ATTR 1

64756  26            FLASH  LD A, (DE)
64757  254,0                CP 0
64759  32,7                 JR NZ, SET F
64761  58,143,92     Reset  LD A, (23695) ATTR T
64764  230,127              AND 127
64766  24,24                JR  LD ATTR 1
```

*Corrections in the listing above:* 64725[^c10-14].

<!-- p. 195 (pdf 205) -->

```z80
64768  58,143,92     SET F  LD A, (23695)  ATTR T
64771  246,128              OR 128
64773  24,17                JR  LD ATTR 1

64775  26           BRIGHT  LD A, (DE)
64776  254,0                CP 0
64778  32,7                 JR NZ, SET B
64780  58,143,92     Reset  LD A, (23695) ATTR T
64783  230,191              AND 191
64785  24,5                 JR  LD ATTR 1
64787  58,143,92     SET B  LD A, (23695)
64790  246,64               OR 64
64792  50,143,92 LD ATTR 1  LD (23695), A
64795  24,62                JR  RET NEXT CHAR

64797  167        TOKENS 3  AND A
64798  254,217              CP 217
64800  40,178               JR Z,  INK
64802  254,218              CP 218
64804  40,188               JR Z, PAPER
64806  254,219              CP 219
64808  40,202               JR Z, FLASH
64810  254,220              CP 220
64812  40,217               JR Z, BRIGHT
64814  254,221              CP 221
64816  40,2                 JR Z, INVERSE
64818  24,19                JR  OVER

64820  26          INVERSE  LD A, (DE)
64821  254,0                CP 0
64823  32,7                 JR NZ, SET I
64825  58,145,92     Reset  LD A, (23697) P(rint) FLAG
64828  230,251              AND 251
64830  24,24                JR  LD ATTR 2
64832  58,145,92     SET I  LD A, (23697)
64835  246,4                OR 4
64837  24,17                JR  LD ATTR 2

64839  26             OVER  LD A, (DE)
64840  254,0                CP 0
64842  32,7                 JR NZ, SET O
64844  58,145,92     Reset  LD A, (23697) P(rint) FLAG
64847  230,254              AND 254
64849  24,5                 JR  LD ATTR 2
64851  58,145,92     SET O  LD A, (23697)
64854  246,1                OR 1
64856  50,145,92 LD ATTR 2  LD (23697), A
64859  209   RET NEXT CHAR  POP DE
64860  19                   INC DE
64861  24,125               JR  NXT CHAR

64863  167             TAB  AND A
64864  125                  LD A, L
64865  214,32     SUB LINE  SUB 32
```

<!-- p. 196 (pdf 206) -->

```z80
64867  48,252               JR NC, SUB LINE
64869  198,32               ADD A, 32
64871  79                   LD C, A    SAVE PART OF LINE
64872  209                  POP DE
64873  26                   LD A, (DE)
64874  19                   INC DE
64875  71                   LD B, A   SAVE TAB #
64876  254,32               CP 32
64878  208                  RET NC  = OUT
64879  185                  CP C
64880  125                  LD A, L
64881  56,5                 JR C,  NXT LINE
64883  145                  SUB C  SUB PART OF LINE
64884  128    NOT END OF 8  ADD A, B   ADD TAB
64885  111                  LD L, A
64886  24,112               JR  NXT CHAR
64888  145        NXT LINE  SUB C
64889  198,32               ADD 32  ADD A LINE
64891  32,247               JR  NZ, NOT END OF 8
64893  0                    nop  (my goof)
64894  128          ADJ PR  ADD A, B
64895  111                  LD L, A
64896  124                  LD A, H
64897  198,8                ADD A, 8
64899  254,88               CP 88  END OF SCREEN?
64901  200                  RET Z    = OUT
64902  103                  LD H, A
64903  24,95                JR  NXT CHAR

64905  167          TOKENS  AND A
64906  254,217              CP 217
64908  56,4                 JR C, TO TOKENS 2
64910  254,223              CP 223
64912  56,139               JR C, TOKENS 3
64914  254,172 TO TOKENS 2  CP 172
64916  40,8                 JR Z, AT
64918  254,173              CP 173
64920  40,197               JR Z, TAB
64922  62,63 UNPRINTABLE ?  LD A, 63
64924  24,112               JR  REG CHAR

64926  167              AT  AND A
64927  209                  POP DE
64928  26                   LD A, (DE)
64929  19                   INC DE
64930  254,24               CP 24
64932  208                  RET NC  = OUT
64933  71                   LD B, A
64934  26                   LD A, (DE)
64935  19                   INC DE
64936  254,32               CP 32
64938  208                  RET NC   = OUT
64939  79                   LD C, A
64940  38,64                LD H, 64
```

*Corrections in the listing above:* 64897[^c10-15].

<!-- p. 197 (pdf 207) -->

```z80
64942  120                  LD A, B
64943  214,8                SUB A, 8
64945  56,10                JR C, 1ST 8
64947  214,8                SUB A, 8
64949  56,4                 JR C, 2ND 8
64951  203,228              SET 4, H
64953  24,4                 JR NEXT
64955  203,220       2ND 8  SET 3, H
64957  198,8         1ST 8  ADD A, 8
64959  167            NEXT  AND A
64960  23                   RLA
64961  23                   RLA
64962  23                   RLA
64963  23                   RLA
64964  23                   RLA
64965  129                  ADD A, C  ADD COLUMN AMT
64966  111                  LD L, A
64967  24,31                JR  NXT CHAR

64969  167        NEW LINE  AND A
64970  125                  LD A, L
64971  214,32       SUB LN  SUB 32
64973  48,252               JR NC, SUB LN
64975  198,32               ADD A, 32
64977  79                   LD C, A
64978  125                  LD A, L
64979  145                  SUB C  SUB PART OF LINE
64980  198,32               ADD A, 32  NEW LINE
64982  111                  LD L, A
64983  254,0                CP 0
64985  40,3                 JR Z, ADJUST
64987  209                  POP DE
64988  24,10                JR  NXT CHAR
64990  167          ADJUST  AND A
64991  124                  LD A, H
64992  198,8                ADD A, 8
64994  254,88               CP 88   END OF SCREEN?
64996  40,123               JR Z, OUT
64998  103                  LD H, A
64999  209                  POP DE

65000  26 PRINT = NXT CHAR  LD A, (DE)
65001  167                  AND A
65002  19                   INC DE  UPDATE DATA FILE POSN
65003  213                  PUSH DE
65004  254,0                CP 0
65006  40,113               JR Z, OUT
65008  254,13               CP 13
65010  40,213               JR Z, NEW LINE
65012  254,32               CP 32
65014  56,162               JR C, UNPRINTABLE ?
65016  254,165              CP 165
65018  48,141               JR NC, TOKEN
65020  254,128              CP 128
```

*Corrections in the listing above:* 64942[^c10-16]; 64957[^c10-17].

<!-- p. 198 (pdf 208) -->

```z80
65022  56,6                 JR C,  REG CHAR F&S
65024  254,144              CP 144
65026  56,95                JR C, GRAPHIC
65028  214,133              SUB 133   A UDG
65030  254,124 REG CHAR F&S CP 124
65032  40,144               JR Z, UNPRINTABLE ?
65034  254,126              CP 126
65036  40,140               JR Z, UNPRINTABLE ?

65038  22,0       REG CHAR  LD D, 0
65040  167                  AND A
65041  23                   RLA
65042  23                   RLA
65043  203,18               RL D
65045  23                   RLA
65046  203,18               RL D
65048  95                   LD E, A
65049  122                  LD A, D
65050  0                    nop
65051  32,4                 JR NZ, NOT UDG
65053  22,255               LD D, 255
65055  24,3                 JR  OVER?
65057  198,60      NOT UDG  ADD A, 60
65059  87                   LD D, A

65060  58,145,92     OVER?  LD A, (23697) P  FLAG
65063  6,255                LD B, 255
65065  31                   RRA
65066  56,1                 JR C, INVERSE?  OVER ON--B = 255
65068  4                    INC B             OFF--B = 0
65069  31         INVERSE?  RRA
65070  31                   RRA
65071  159                  SBC A,A   = 0 IF OFF, ELSE 255
65072  79                   LD C, A
65073  62,8                 LD A, 8  COUNT
65075  167                  AND A
65076  235                  EX DE, HL
65077  245        PIX LINE  PUSH AF   SAVE COUNT
65078  26                   LD A, (DE) GET SCREEN BYTE
65079  160                  AND B
65080  174                  XOR (HL) CHAR BYTE
65081  169                  XOR C   INVERT
65082  18                   LD (DE), A
65083  20                   INC D
65084  35                   INC HL
65085  241                  POP AF   GET COUNT
65086  61                   DEC A
65087  32,244               JR NZ, PIX LINE

65089  21          DO ATTR  DEC D
65090  122                  LD A, D
65091  15                   RRCA
65092  15                   RRCA
65093  15                   RRCA
```

*Corrections in the listing above:* 65032 and 65036[^c10-18].

<!-- p. 199 (pdf 209) -->

```z80
65094  230,3                          AND 3  MASK 2 LOWEST BITS
65096  246,88                         OR 88
65098  103                            LD H, A
65099  107                            LD L, E
65100  58,143,92                      LD A, (23695)  ATTR T
65103  119                            LD (HL), A
65104  235                            EX DE, HL

65105  35   UPDATE PR POSN            INC HL
65106  125                            LD A, L
65107  40,7                           JR Z, SKIP
65109  124                            LD A, H
65110  214,7                          SUB A, 7
65112  103                            LD H, A
65113  209                    RETURN  POP DE
65114  24,140                         JR  NXT CHAR
65116  124                      SKIP  LD A, H
65117  254,88                         CP 88    END OF SCREEN?
65119  32,248                         JR NZ, RETURN
65121  209                       OUT  POP DE
65122  201                            RET

65123  71                   GRAPHICS  LD B, A
65124  22,2                           LD D, 2
65126  167                    NEXT 4  AND A
65127  203,24                         RR B
65129  159                            SBC A, A IF BIT = 1, A = 255, ELSE
65130  230,15                         AND 15     MASK LOW NYBBLE      0
65132  79                             LD C, A
65133  203,24                         RR B
65135  159                            SBC A, A  AS ABOVE
65136  230,240                        AND 240   MASK HIGH NYBBLE
65138  177                            OR C      ADD LOW NYBBLE
65139  14,4                           LD C, 4  COUNT
65141  119                     AGAIN  LD (HL), A
65142  36                             INC H
65143  13                             DEC C
65144  32,251                         JR NZ, AGAIN
65146  21                             DEC D
65147  32,233                         JR NZ, NEXT 4
65149  235                            EX DE, HL
65150  24, 193                        JR   DO ATTR

65152  33,0,64                   CLS  LD HL,  D FILE
65155  1,0,24                         LD BC, 6144
65158  62,0                     LOOP  LD A, 0
65160  119                            LD (HL), A
65161  35                             INC HL
65162  11                             DEC BC
65163  120                            LD A, B
65164  177                            OR C
65165  32,247                         JR NZ, LOOP
65167  1,0,3                 CL ATTR  LD BC, 768
65170  58,141,92                      LD A, (23693) ATTR P
```

*Corrections in the table above:* 65110[^c11-1]. *Notes:* JR Z, SKIP at 65107[^v13-1].

<!-- p. 200 (pdf 210) -->

```z80
65173  87                             LD D, A
65174  122                    LOOP 2  LD A, D
65175  119                            LD (HL), A
65176  35                             INC HL
65177  11                             DEC BC
65178  120                            LD A, B
65179  177                            OR C
65180  32,248                         JR NZ, LOOP 2
65182  201                            RET

65183  0                              nop

65184  17,0,255                INPUT  LD DE, INPUT STORE
65187  62,0                           LD A, 0  CLEAR STORE
65189  6,32                           LD B, 32 COUNT
65191  18                       LOOP  LD (DE), A
65192  19                             INC DE
65193  16,252                         DJNZ, LOOP
65195  17,0,255                       LD DE, INPUT STORE
65198  253,203,1,174             KEY  RES 5, (IY+1)  KEYHIT
65202  213                            PUSH DE
65203  205,225,2                WAIT  CALL 737  UPDATE KEYBOARD
65206  167                            AND A
65207  253,203,1,110                  BIT 5, (IY+1) HIT?
65211  40,246                         JR Z, WAIT
65213  1,0,80                         LD BC, 20480
65216  11                   DEBOUNCE  DEC BC
65217  120                            LD A, B
65218  177                            OR C
65219  32,251                         JR NZ, DEBOUNCE
65221  58,8,92                        LD A, (23560) LAST KEY
65224  167                            AND A
65225  254,13                         CP 13  ENTER?
65227  209                            POP DE
65228  200                            RET Z
65229  254,12                         CP 12  DELETE?
65231  40,23                          JR Z, DELETE
65233  254,32                         CP 32,  CHECK KEY
65235  56,217                         JR C, KEY    UNPRINTABLE
65237  254,123                        CP 123
65239  48,213                         JR NC, KEY
65241  18                             LD (DE), A  STORE LETTER
65242  19                             INC DE
65243  213                    PR INP  PUSH DE
65244  17,0,255                       LD DE, INPUT START
65247  33,224,80                      LD HL, BOTTOM LINE
65250  205,232,253                    CALL 65000   PRINT
65253  209                            POP DE
65254  24,198                         JR  KEY
65256  62,0                   DELETE  LD A, 0 CLEAR HOLD FILE
65258  27                             DEC DE
65259  18                             LD (DE), A
65260  33,224,80           CL BOT LN  LD HL; 20704 CLEAR SCREEN LINE
65263  14,8                           LD C, 8  BOTTOM LINE
```

<!-- p. 201 (pdf 211) -->

```z80
65265  6,31                      ROW  LD B, 31
65267  119                      LINE  LD (HL), A
65268  35                             INC HL
65269  16,252                         DJNZ, LINE
65271  36                             INC H
65272  46,224                         LD L, 224
65274  13                             DEC C
65275  32,244                         JR NZ, ROW
65277  24,220                         JR PR INP
65279  0
65280-65312                           DATA BASE  INPUT STORE
```

The above input only allows for a name of 32 characters. It is printed to the bottom line of the screen and allows for deletes of a wrong character. It CALLs the PRINT routine at 65000 so if relocated, that line must be changed. Now that you have your input stored it's up to you do with it what you want. In our class we do:

```z80
63000  243                            DI
63001  17,0,250                       LD DE, DATA 1
63004  205,232,253                    CALL PRINT
63007  0                              nop
63008  205,160,254                    CALL INPUT
63011  17,186,250                     LD DE, 64186  XFER NAME TO DATA B
63014  33,0,255                       LD HL, 65280
63017  1,32,0                         LD BC, 32
63020  237,176                        LDIR
63022  33,224,80           CL BOT LN  LD HL, 20704
63025  62,0                           LD A, 0
63027  14,8                           LD C, 8
63029  6,31                      ROW  LD B, 31
63031  119                      LINE  LD (HL), A
63032  35                             INC HL
63033  16,252                         DJNZ, LINE
63035  36                             INC H
63036  46,224                         LD L, 224
63038  13                             DEC C
63039  32,244                         JR NZ, ROW
63041  58,72,92              CL ATTR  LD A, (23624)
63044  230,56                         AND 56
63046  33,224,90                      LD HL, LAST LINE ATTR ADDR
63049  6,32                           LD B, 32
63051  119                      LOOP  LD (HL), A
63052  35                             INC HL
63053  16,252                         DJNZ, LOOP
63055  17,179,250            PR NAME  LD DE, 64179
63058  205,232,253                    CALL PRINT
63061  17,219,250            PR MESS  LD DE, 64219
63064  205,232,253                    CALL PRINT
63067  251                            EI
63068  201                            RET
```

<!-- p. 202 (pdf 212) -->

## Appendix C: A Complete Code Table

Codes with \* are not verified by manufacturer.

```text
DEC HEX  CODE       NORMAL       AFTER CB    AFTER ED     AFTER DD      AFTER FD
  0 00  ----       nop          RLC B
  1 01  ----       LD BC, NN    RLC C
  2 02  ----       LD (BC),A    RLC D
  3 03  ----       INC BC       RLC E
  4 04  ----       INC B        RLC H
  5 05  ----       DEC B        RLC L
  6 06  PRINT ,    LD B, N      RLC (HL)
  7 07  EDIT       RLCA         RLC A
  8 08  C LEFT     EX AF,AF'    RRC B
  9 09  C RIGHT    ADD HL,BC    RRC C                    ADD IX,BC     ADD IY,BC
 10 0A  C DOWN     LD A,(BC)    RRC D
 11 0B  C UP       DEC BC       RRC E
 12 0C  DELETE     INC C        RRC H
 13 0D  ENTER      DEC C        RRC L
 14 0E  SLUG       LD C, N      RRC (HL)
 15 0F  ----       RRCA         RRC A
 16 10  INK CTR    DJNZ, d      RL B
 17 11  PAPER CTR  LD DE,NN     RL C
 18 12  FLASH CTR  LD (DE),A    RL D
 19 13  BRIGHT CT  INC DE       RL E
 20 14  INVERSE C  INC D        RL H
 21 15  OVER CTR   DEC D        RL L
 22 16  AT CTR     LD D, N      RL (HL)
 23 17  TAB CTR    RLA          RL A
 24 18  ----       JR d         RR B
 25 19  ----       ADD HL,DE    RR C                     ADD IX,DE     ADD IY,DE
 26 1A  ----       LD A, (DE)   RR D
 27 1B  ----       DEC DE       RR E
 28 1C  ----       INC E        RR H
 29 1D  ----       DEC E        RR L
 30 1E  ----       LD E, N      RR (HL)
 31 1F  ----       RRA          RR A
 32 20  SPACE      JR NZ, d     SLA B
 33 21  !          LD HL, NN    SLA C                    LD IX,NN      LD IY,NN
 34 22  "          LD(NN),HL    SLA D                    LD(NN),IX     LD(NN),IY
 35 23  #          INC HL       SLA E                    INC IX        INC IY
 36 24  $          INC H        SLA H                    INC HIX*      INC HIY*
 37 25  %          DEC H        SLA L                    DEC HIX*      DEC HIY*
 38 26  &          LD H, N      SLA (HL)                 LD HIX,N*     LD HIY,N*
 39 27  '          DAA          SLA A
 40 28  (          JR Z, d      SRA B
 41 29  )          ADD HL,HL    SRA C                    ADD IX,IX     ADD IY,IY
 42 2A  *          LD HL,(NN)   SRA D                    LD IX,(NN)    LD IY,(NN)
 43 2B  +          DEC HL       SRA E                    DEC IX        DEC IY
 44 2C  ,          INC L        SRA H                    INC LIX*      INC LIY*
 45 2D  -          DEC L        SRA L                    DEC LIX*      DEC LIY*
 46 2E  .          LD L, N      SRA (HL)                 LD LIX, N*    LD LIY, N*
 47 2F  /          CPL          SRA A
 48 30  0          JR NC, d     SLL B*
```

*Corrections in the table above:* 09 AFTER FD[^c11-2].

<!-- p. 203 (pdf 213) -->

```text
DEC HEX  CODE       NORMAL       AFTER CB    AFTER ED     AFTER DD      AFTER FD
 49 31  1          LD SP,NN     SLL C*
 50 32  2          LD(NN), A    SLL D*
 51 33  3          INC SP       SLL E*
 52 34  4          INC (HL)     SLL H*                   INC(IX+d)     INC(IY+d)
 53 35  5          DEC (HL)     SLL L*                   DEC(IX+d)     DEC(IY+d)
 54 36  6          LD(HL),N     SLL (HL)*                LD(IX+d),N    LD(IY+d),N
 55 37  7          SCF          SLL A*
 56 38  8          JR C, d      SRL B
 57 39  9          ADD HL,SP    SRL C                    ADD IX,SP     ADD IY,SP
 58 3A  :          LD A, (NN)   SRL D
 59 3B  ;          DEC SP       SRL E
 60 3C  <          INC A        SRL H
 61 3D  =          DEC A        SRL L
 62 3E  >          LD A, N      SRL (HL)
 63 3F  ?          CCF          SRL A
 64 40  @          LD B, B      BIT 0, B    IN B,(C)
 65 41  A          LD B, C      BIT 0, C    OUT(C),B
 66 42  B          LD B, D      BIT 0, D    SBC HL,BC
 67 43  C          LD B, E      BIT 0, E    LD(NN),BC
 68 44  D          LD B, H      BIT 0, H    NEG          LD B,HIX*     LD B,HIY*
 69 45  E          LD B, L      BIT 0, L    RET N        LD B,LIX*     LD B,LIY*
 70 46  F          LD B,(HL)    BIT 0,(HL)  IM0          LD B,(IX+d)   LD B,(IY+d)
 71 47  G          LD B, A      BIT 0, A    LD I, A
 72 48  H          LD C, B      BIT 1, B    IN C,(C)
 73 49  I          LD C, C      BIT 1, C    OUT(C),C
 74 4A  J          LD C, D      BIT 1, D    ADC HL,BC
 75 4B  K          LD C, E      BIT 1, E    LD BC,(NN)
 76 4C  L          LD C, H      BIT 1, H    NEG*         LD C,HIX*     LD C,HIY*
 77 4D  M          LD C, L      BIT 1, L    RET I        LD C,LIX*     LD C,LIY*
 78 4E  N          LD C, (HL)   BIT 1,(HL)               LD C,(IX+d)   LD C,(IY+d)
 79 4F  O          LD C, A      BIT 1, A    LD R, A
 80 50  P          LD D, B      BIT 2, B    IN D,(C)
 81 51  Q          LD D, C      BIT 2, C    OUT(C),D
 82 52  R          LD D, D      BIT 2, D    SBC HL,DE
 83 53  S          LD D, E      BIT 2, E    LD(NN),DE
 84 54  T          LD D, H      BIT 2, H    NEG*         LD D,HIX*     LD D,HIY*
 85 55  U          LD D, L      BIT 2, L    RET N*       LD D,LIX*     LD D,LIY*
 86 56  V          LD D, (HL)   BIT 2,(HL)  IM 1         LD D,(IX+d)   LD D,(IY+d)
 87 57  W          LD D, A      BIT 2, A    LD A, I
 88 58  X          LD E, B      BIT 3, B    IN E,(C)
 89 59  Y          LD E, C      BIT 3, C    OUT(C),E
 90 5A  Z          LD E, D      BIT 3, D    ADC HL,DE
 91 5B  [          LD E, E      BIT 3, E    LD DE,(NN)
 92 5C  \          LD E, H      BIT 3, H    NEG*         LD E,HIX*     LD E,HIY*
 93 5D  ]          LD E, L      BIT 3, L    RET N*       LD E,LIX*     LD E,LIY*
 94 5E  ^          LD E, (HL)   BIT 3,(HL)  IM 2         LD E,(IX+d)   LD E,(IY+d)
 95 5F  _          LD E, A      BIT 3, A    LD A, R
 96 60  £          LD H, B      BIT 4, B    IN H,(C)     LD HIX, B*    LD HIY, B*
 97 61  a          LD H, C      BIT 4, C    OUT(C),H     LD HIX, C*    LD HIY, C*
 98 62  b          LD H, D      BIT 4, D    SBC HL,HL    LD HIX, D*    LD HIY, D*
 99 63  c          LD H, E      BIT 4, E    LD(NN),HL    LD HIX, E*    LD HIY, E*
```

*Corrections in the table above:* 96 60 £[^v13-2].

<!-- p. 204 (pdf 214) -->

```text
DEC HEX  CODE       NORMAL       AFTER CB    AFTER ED     AFTER DD      AFTER FD
100 64  d          LD H, H      BIT 4, H    NEG*         LD HIX,HIX*   LD HIY,HIY*
101 65  e          LD H, L      BIT 4, L    RET N*       LD HIX,LIX*   LD HIY,LIY*
102 66  f          LD H, (HL)   BIT 4,(HL)               LD H,(IX+d)   LD H,(IY+d)
103 67  g          LD H, A      BIT 4, A    RRD
104 68  h          LD L, B      BIT 5, B    IN L,(C)     LD LIX, B*    LD LIY, B*
105 69  i          LD L, C      BIT 5, C    OUT(C), L    LD LIX, C*    LD LIY, C*
106 6A  j          LD L, D      BIT 5, D    ADC HL,HL    LD LIX, D*    LD LIY, D*
107 6B  k          LD L, E      BIT 5, E    LD HL,(NN)   LD LIX, E*    LD LIY, E*
108 6C  l          LD L, H      BIT 5, H    NEG*         LD LIX,HIX*   LD LIY,HIY*
109 6D  m          LD L, L      BIT 5, L    RET N*
110 6E  n          LD L,(HL)    BIT 5,(HL)               LD L,(IX+d)   LD L,(IY+d)
111 6F  o          LD L, A      BIT 5, A    RLD
112 70  p          LD (HL),B    BIT 6, B    IN (C)*      LD(IX+d),B    LD(IY+d),B
113 71  q          LD (HL),C    BIT 6, C    OUT(C),0*    LD(IX+d),C    LD(IY+d),C
114 72  r          LD (HL),D    BIT 6, D    SBC HL,SP    LD(IX+d),D    LD(IY+d),D
115 73  s          LD (HL),E    BIT 6, E    LD(NN),SP    LD(IX+d),E    LD(IY+d),E
116 74  t          LD (HL),H    BIT 6, H    NEG*         LD(IX+d),H    LD(IY+d),H
117 75  u          LD (HL),L    BIT 6, L    RET N*       LD(IX+d),L    LD(IY+d),L
118 76  v          HALT         BIT 6,(HL)
119 77  w          LD (HL),A    BIT 6, A                 LD(IX+d),A    LD(IY+d),A
120 78  x          LD A, B      BIT 7, B    IN A,(C)
121 79  y          LD A, C      BIT 7, C    OUT(C),A
122 7A  z          LD A, D      BIT 7, D    ADC HL,SP
123 7B  ON ERR     LD A, E      BIT 7, E    LD SP,(NN)
124 7C  STICK      LD A, H      BIT 7, H    NEG*         LD A,HIX*     LD A,HIY*
125 7D  SOUND      LD A, L      BIT 7, L    RET N*       LD A,LIX*     LD A,LIY*
126 7E  FREE       LD A, (HL)   BIT 7,(HL)               LD A,(IX+d)   LD A,(IY+d)
127 7F  RESET      LD A, A      BIT 7, A
128 80             ADD A, B     RES 0, B
129 81             ADD A, C     RES 0, C
130 82             ADD A, D     RES 0, D
131 83             ADD A, E     RES 0, E
132 84             ADD A, H     RES 0, H                 ADD A,HIX*    ADD A,HIY*
133 85             ADD A, L     RES 0, L                 ADD A,LIX*    ADD A,LIY*
134 86             ADD A,(HL)   RES 0,(HL)               ADD A,(IX+d)  ADD A,(IY+d)
135 87             ADD A, A     RES 0, A
136 88             ADC A, B     RES 1, B
137 89             ADC A, C     RES 1, C
138 8A             ADC A, D     RES 1, D
139 8B             ADC A, E     RES 1, E
140 8C             ADC A, H     RES 1, H                 ADC A,HIX*    ADC A,HIY*
141 8D             ADC A, L     RES 1, L                 ADC A,LIX*    ADC A,LIY*
142 8E             ADC A,(HL)   RES 1,(HL)               ADC A,(IX+d)  ADC A,(IY+d)
143 8F             ADC A, A     RES 1, A
144 90  UDG A      SUB A, B     RES 2, B
145 91  UDG B      SUB A, C     RES 2, C
146 92  UDG C      SUB A, D     RES 2, D
147 93  UDG D      SUB A, E     RES 2, E
148 94  UDG E      SUB A, H     RES 2, H                 SUB A,HIX*    SUB A,HIY*
149 95  UDG F      SUB A, L     RES 2, L                 SUB A,LIX*    SUB A,LIY*
150 96  UDG G      SUB A,(HL)   RES 2,(HL)               SUB A,(IX+d)  SUB A,(IY+d)
```

*Corrections in the table above:* 64/6C AFTER DD and AFTER FD[^c11-3]; 67/6F AFTER ED[^c11-4]; 70/71 AFTER ED[^c11-5]; 8D AFTER FD[^c11-6].

<!-- p. 205 (pdf 215) -->

```text
DEC HEX  CODE       NORMAL       AFTER CB    AFTER ED     AFTER DD      AFTER FD
151 97  UDG H      SUB A, A     RES 2, A
152 98  UDG I      SBC A, B     RES 3, B
153 99  UDG J      SBC A, C     RES 3, C
154 9A  UDG K      SBC A, D     RES 3, D
155 9B  UDG L      SBC A, E     RES 3, E
156 9C  UDG M      SBC A, H     RES 3, H                 SBC A,HIX*    SBC A,HIY*
157 9D  UDG N      SBC A, L     RES 3, L                 SBC A,LIX*    SBC A,LIY*
158 9E  UDG O      SBC A,(HL)   RES 3,(HL)               SBC A,(IX+d)  SBC A,(IY+d)
159 9F  UDG P      SBC A, A     RES 3, A
160 A0  UDG Q      AND B        RES 4, B    LDI
161 A1  UDG R      AND C        RES 4, C    CPI
162 A2  UDG S      AND D        RES 4, D    INI
163 A3  UDG T      AND E        RES 4, E    OUTI
164 A4  UDG U      AND H        RES 4, H                 AND HIX*      AND HIY*
165 A5  RND        AND L        RES 4, L                 AND LIX*      AND LIY*
166 A6  INKEY$     AND (HL)     RES 4,(HL)               AND (IX+d)    AND (IY+d)
167 A7  PI         AND A        RES 4, A
168 A8  FN         XOR B        RES 5, B    LDD
169 A9  POINT      XOR C        RES 5, C    CPD
170 AA  SCREEN$    XOR D        RES 5, D    IND
171 AB  ATTR       XOR E        RES 5, E    OUTD
172 AC  AT         XOR H        RES 5, H                 XOR HIX*      XOR HIY*
173 AD  TAB        XOR L        RES 5, L                 XOR LIX*      XOR LIY*
174 AE  VAL$       XOR (HL)     RES 5,(HL)               XOR (IX+d)    XOR (IY+d)
175 AF  CODE       XOR A        RES 5, A
176 B0  VAL        OR B         RES 6, B    LDIR
177 B1  LEN        OR C         RES 6, C    CPIR
178 B2  SIN        OR D         RES 6, D    INIR
179 B3  COS        OR E         RES 6, E    OTIR
180 B4  TAN        OR H         RES 6, H                 OR HIX*       OR HIY*
181 B5  ASN        OR L         RES 6, L                 OR LIX*       OR LIY*
182 B6  ACS        OR (HL)      RES 6,(HL)               OR (IX+d)     OR (IY+d)
183 B7  ATN        OR A         RES 6, A
184 B8  LN         CP B         RES 7, B    LDDR
185 B9  EXP        CP C         RES 7, C    CPDR
186 BA  INT        CP D         RES 7, D    INDR
187 BB  SQR        CP E         RES 7, E    OTDR
188 BC  SGN        CP H         RES 7, H                 CP HIX*       CP HIY*
189 BD  ABS        CP L         RES 7, L                 CP LIX*       CP LIY*
190 BE  PEEK       CP (HL)      RES 7,(HL)               CP (IX+d)     CP (IY+d)
191 BF  IN         CP A         RES 7, A
192 C0  USR        RET NZ       SET 0, B
193 C1  STR$       POP BC       SET 0, C
194 C2  CHR$       JP NZ, NN    SET 0, D
195 C3  NOT        JP NN        SET 0, E
196 C4  BIN        CALL NZ,NN   SET 0, H
197 C5  OR         PUSH BC      SET 0, L
198 C6  AND        ADD A, N     SET 0,(HL)
199 C7  <=         RST 0        SET 0, A
200 C8  >=         RET Z        SET 1, B
201 C9  <>         RET          SET 1, C
```

*Corrections in the table above:* B2 AFTER ED[^c11-7]; B6 AFTER FD[^c11-8].

<!-- p. 206 (pdf 216) -->

```text
DEC HEX  CODE       NORMAL       AFTER CB    AFTER ED     AFTER DD      AFTER FD
202 CA  LINE       JP Z, NN     SET 1, D
203 CB  THEN       (prefix)     SET 1, E
204 CC  TO         CALL Z, NN   SET 1, H
205 CD  STEP       CALL NN      SET 1, L
206 CE  DEF FN     ADC A, N     SET 1,(HL)
207 CF  CAT        RST 8        SET 1, A
208 D0  FORMAT     RET NC       SET 2, B
209 D1  MOVE       POP DE       SET 2, C
210 D2  ERASE      JP NC, NN    SET 2, D
211 D3  OPEN #     OUT(N), A    SET 2, E
212 D4  CLOSE #    CALL NC,NN   SET 2, H
213 D5  MERGE      PUSH DE      SET 2, L
214 D6  VERIFY     SUB N        SET 2,(HL)
215 D7  BEEP       RST 16       SET 2, A
216 D8  CIRCLE     RET C        SET 3, B
217 D9  INK        EXX          SET 3, C
218 DA  PAPER      JP C, NN     SET 3, D
219 DB  FLASH      IN A, N      SET 3, E
220 DC  BRIGHT     CALL C, NN   SET 3, H
221 DD  INVERSE    (IX prefix)  SET 3, L
222 DE  OVER       SBC A, N     SET 3,(HL)
223 DF  OUT        RST 24       SET 3, A
224 E0  LPRINT     RET PO       SET 4, B
225 E1  LLIST      POP HL       SET 4, C                 POP IX        POP IY
226 E2  STOP       JP PO, NN    SET 4, D
227 E3  READ       EX(SP),HL    SET 4, E                 EX(SP),IX     EX(SP),IY
228 E4  DATA       CALL PO,NN   SET 4, H
229 E5  RESTORE    PUSH HL      SET 4, L                 PUSH IX       PUSH IY
230 E6  NEW        AND N        SET 4,(HL)
231 E7  BORDER     RST 32       SET 4, A
232 E8  CONTINUE   RET PE       SET 5, B
233 E9  DIM        JP (HL)      SET 5, C                 JP (IX)       JP (IY)
234 EA  REM        JP PE, NN    SET 5, D
235 EB  FOR        EX DE,HL     SET 5, E
236 EC  GOTO       CALL PE,NN   SET 5, H
237 ED  GOSUB      (prefix)     SET 5, L
238 EE  INPUT      XOR N        SET 5,(HL)
239 EF  LOAD       RST 40       SET 5, A
240 F0  LIST       RET P        SET 6, B
241 F1  LET        POP AF       SET 6, C
242 F2  PAUSE      JP P, NN     SET 6, D
243 F3  NEXT       DI           SET 6, E
244 F4  POKE       CALL P,NN    SET 6, H
245 F5  PRINT      PUSH AF      SET 6, L
246 F6  PLOT       OR N         SET 6,(HL)
247 F7  RUN        RST 48       SET 6, A
248 F8  SAVE       RET M        SET 7, B
249 F9  RANDOMIZE  LD SP,HL     SET 7, C                 LD SP,IX      LD SP,IY
250 FA  IF         JP M, NN     SET 7, D
251 FB  CLS        EI           SET 7, E
252 FC  DRAW       CALL M,NN    SET 7, H
```

*Corrections in the table above:* E6 NORMAL[^c11-9]; EB AFTER DD and AFTER FD[^c11-10].

<!-- p. 207 (pdf 217) -->

```text
DEC HEX  CODE       NORMAL       AFTER CB    AFTER ED     AFTER DD      AFTER FD
253 FD  CLEAR      (IY prefix)  SET 7, L
254 FE  RETURN     CP N         SET 7,(HL)
255 FF  COPY       RST 56       SET 7, A
```

### Double Prefix Codes

```text
DEC HEX   AFTER DDCBdd   AFTER FDCBdd
  6 06    RLC(IX+d)      RLC(IY+d)
 14 0E    RRC(IX+d)      RRC(IY+d)
 22 16    RL(IX+d)       RL(IY+d)
 30 1E    RR(IX+d)       RR(IY+d)
 38 26    SLA(IX+d)      SLA(IY+d)
 46 2E    SRA(IX+d)      SRA(IY+d)
 54 36    SLL(IX+d)      SLL(IY+d)
 62 3E    SRL(IX+d)      SRL(IY+d)
 70 46    BIT 0,(IX+d)   BIT 0,(IY+d)
 78 4E    BIT 1,(IX+d)   BIT 1,(IY+d)
 86 56    BIT 2,(IX+d)   BIT 2,(IY+d)
 94 5E    BIT 3,(IX+d)   BIT 3,(IY+d)
102 66    BIT 4,(IX+d)   BIT 4,(IY+d)
110 6E    BIT 5,(IX+d)   BIT 5,(IY+d)
118 76    BIT 6,(IX+d)   BIT 6,(IY+d)
126 7E    BIT 7,(IX+d)   BIT 7,(IY+d)
134 86    RES 0,(IX+d)   RES 0,(IY+d)
142 8E    RES 1,(IX+d)   RES 1,(IY+d)
150 96    RES 2,(IX+d)   RES 2,(IY+d)
158 9E    RES 3,(IX+d)   RES 3,(IY+d)
166 A6    RES 4,(IX+d)   RES 4,(IY+d)
174 AE    RES 5,(IX+d)   RES 5,(IY+d)
182 B6    RES 6,(IX+d)   RES 6,(IY+d)
190 BE    RES 7,(IX+d)   RES 7,(IY+d)
198 C6    SET 0,(IX+d)   SET 0,(IY+d)
206 CE    SET 1,(IX+d)   SET 1,(IY+d)
214 D6    SET 2,(IX+d)   SET 2,(IY+d)
222 DE    SET 3,(IX+d)   SET 3,(IY+d)
230 E6    SET 4,(IX+d)   SET 4,(IY+d)
238 EE    SET 5,(IX+d)   SET 5,(IY+d)
246 F6    SET 6,(IX+d)   SET 6,(IY+d)
254 FE    SET 7,(IX+d)   SET 7,(IY+d)
```

*Corrections in the table above:* 190 BE AFTER FDCBdd[^c11-11].

<!-- p. 208 (pdf 218) -->

## Appendix D: Machine Codes for Encoding

### Machine Codes for Encoding--Decimal

```text
   with    A   B   C   D   E   H   L  (HL)  n  (IX,IY+d)(nn)(BC)(DE)
LD   A    127 120 121 122 123 124 125 126  62n   126d    58nn 10  26
     B     71  64  65  66  67  68  69  70   6n    70d
     C     79  72  73  74  75  76  77  78  14n    78d     LDI 237,160
     D     87  80  81  82  83  84  85  86  22n    86d     LDD 237,168
     E     95  88  89  90  91  92  93  94  30n    94d     CPI 237,161
     H    103  96  97  98  99 100 101 102  38n   102d     CPD 237,169
     L    111 104 105 106 107 108 109 110  46n   110d    LDIR 237,176
   (HL)   119 112 113 114 115 116 117 ---  54n           LDDR 237,184
(IX,IY+d)119d112d113d114d115d116d117d      54dn          CPIR 237,177
   (nn)   50                                             CPDR 237,185
   (BC)    2     PREFACE ALL IX with 221             LD R, A 237,79
   (DE)   18             ALL IY with 253             LD A, I 237,87
                                                     LD A, R 237,95
    with nn      (nn)          LD (nn) with:         LD I, A 237,71
LD BC       1nn 237,75nn       BC         237,67nn   LD SP, HL/IX/IY
   DE      17nn 237,91nn       DE         237,83nn          249
IX,IY,HL   33nn 237,107nn    HL/IX/IY     237,99nn
                 or 42nn                   or 34nn
   SP      49nn 237,123nn      SP         237,115nn

       A   B   C   D   E   H   L (HL)  n  (IX,IY+d) nop  0
ADD r 135 128 129 130 131 132 133 134 198n   134d    CPL  47
ADC r 143 136 137 138 139 140 141 142 206n   142d    NEG  237,68
SUB r 151 144 145 146 147 148 149 150 214n   150d    CCF  63
SBC r 159 152 153 154 155 156 157 158 222n   158d    SCF  55
AND r 167 160 161 162 163 164 165 166 230n   166d    HALT 118
XOR r 175 168 169 170 171 172 173 174 238n   174d    DI   243
OR  r 183 176 177 178 179 180 181 182 246n   182d    EI   251
CP  r 191 184 185 186 187 188 189 190 254n   190d    IM0  237HL)     n
 (IX,IY+d) nop  0
ADD r 135 128 129 130 131 132 133 134 198n   134d    CPL  47
ADC r 143 136 137 138 139 140 141 142 206n   142d    NEG  237,68
SUB r 151 144 145 146 147 148 149 150 214n   150d    CCF  63
SBC r 159 152 153 154 155 156 157 158 222n   158d    SCF  55
AND r 167 160 161 162 163 164 165 166 230n   166d    HALT 118
XOR r 175 168 169 170 171 172 173 174 238n   174d    DI   243
OR  r 183 176 177 178 179 180 181 182 246n   182d    EI   251
CP  r 191 184 185 186 187 188 189 190 254n   190d    IM0  237,70
INC    60   4  12  20  28  36  44  52         52d    IM1  237,86
DEC    61   5  13  21  29  37  45  53         53d    IM2  237,94

               BC      DE      HL      SP    IX/IY      AF  BC  DE  HL*
ADD HL,rr*      9      25      41      57         PUSH 245 197 213 229
ADC HL,rr  237,74  237,90  237,106 237,122         POP 241 193 209 225
SBC HL,rr  237,66  237,82  237,98  237,114
INC rr          3      19      35      51     35  EX AF, AF'  8
DEC rr         11      27      43      59     43  EX DE, HL       235
 * also to IX and IY.                             EX SP, HL/IX/IY 227
                                                  EXX             217
2          A  B  C  D  E  H  L (HL) (IX,IY+d)
0 RLC r    7  0  1  2  3  4  5   6     6d      RLCA  7
3 RRC r   15  8  9 10 11 12 13  14    14d      RRCA 15
P Rl  r   23 16 17 18 19 20 21  22    22d      RLA  23
R RR  r   31 24 25 26 27 28 29  30    30d      RRA  31
E SLA r   39 32 33 34 35 36 37  38    38d      RLD 237,111
F SRA r   47 40 41 42 43 44 45  46    46d      RRD 237,103
```

*Corrections in the table above:* LD HL,(nn)[^c11-12]; the repeated ALU block and CCF[^c11-13]; DEC B[^c11-14]; EX DE,IX/IY[^c11-15].

<!-- p. 209 (pdf 219) -->

```text
  SLL r   55 48 49 50 51 52 53  54    54d      DAA  39
X SRL r   63 56 57 58 59 60 61  62    62d

                                                             (HL)
          Z      NZ     C      NC     M      P      PE     PO (IX,IY)
  JP 195nn 202nn  194nn  218nn  210nn  250nn  242nn  234nn  226nn 233
CALL 205nn 204nn  196nn  220nn  212nn  252nn  244nn  236nn  228nn
 RET 201   200    192    216    208    248    240    232    224
  JR  24d   40d    32d    56d    48d   DJNZ = 16d
```

```text
Preface with 237(ED)
              A  B  C  D  E  H   L  (HL)    No prefix
IN r, (C)   120 64 72 80 88 96 104 112   IN A, (n)   219n
OUT (C), r  121 65 73 81 89 97 105 113   OUT (n), A  211n

IND  237,170  INI  237,162  INDR 237,186  INIR 237,178
OUTD 237,171  OUTI 237,163  OTDR 237,187  OTIR 237,179

2           A   B   C   D   E   H   L  (HL)(IX,IY)
0 BIT 0    71  64  65  66  67  68  69  70     d70    RST  0 RESET 199
3     1    79  72  73  74  75  76  77  78     d78    RST  8 ERROR 207
P     2    87  80  81  82  83  84  85  86     d86    RST 16 PRINT 215
R     3    95  88  89  90  91  92  93  94     d94    RST 24 GET C 223
E     4   103  96  97  98  99 100 101 102     d102   RST 32 NXT C 231
      5   111 104 105 106 107 108 109 110     d110   RST 40 FP CL 239
.     6   119 112 113 114 115 116 117 118     d118   RST 48 BC SP 247
X     7   127 120 121 122 123 124 125 126     d126   RST 56 KEYBD 255

2           A   B   C   D   E   H   L  (HL)(IX,IY+d)
0 RES 0   135 128 129 130 131 132 133 134    d134
3     1   143 136 137 138 139 140 141 142    d142
P     2   151 144 145 146 147 148 149 150    d150
R     3   159 152 153 154 155 156 157 158    d158
E     4   167 160 161 162 163 164 165 166    d166
F     5   175 168 169 170 171 172 173 174    d174
I     6   183 176 177 178 179 180 181 182    d182
X     7   191 184 185 186 187 188 189 190    d190

2           A   B   C   D   E   H   L  (HL)(IX,IY+d)
0 SET 0   199 192 193 194 195 196 197 198    d198
3     1   207 200 201 202 203 204 205 206    d206
P     2   215 208 209 210 211 212 213 214    d214
R     3   223 216 217 218 219 220 221 222    d222
E     4   231 224 225 226 227 228 229 230    d230
F     5   239 232 233 234 235 236 237 238    d238
I     6   247 240 241 242 243 244 245 246    d246
X     7   255 248 249 250 251 252 253 254    d254
```

The following commands may be unsupported:

```text
                A   B   C   D   E  n  LIX,LIY HIX,HIY
LD H(IX,IY)   103  96  97  98  99 38    101     ---
LD L(IX,IY)   111 104 105 106 107 46    ---     108

     H(IX,IY) L(IX,IY)          H(IX,IY) L(IX,IY)   RET N   NEG
LD A    124      125       ADD     132      133     237,85 237,76
LD B     68       69       ADC     140      141         93     84
LD C     76       77       SUB     148      149        101     92
LD D     84       85       SBC     156      157        117    100
LD E     92       93       CP      188      189        125    108
INC      36       44       AND     164      165               116
DEC      37       45       OR      180      181               124
                           XOR     172      173
```

*Corrections in the table above:* OUT (C),L[^c11-16]; INDR[^c11-17]; RES table[^c11-18]; LD L(IX,IY),n[^c11-19].

<!-- p. 210 (pdf 220) -->

### Machine Code for Encoding--Hex

```text
    with A  B  C  D  E  H  L (HL) n (IX,IY+d)(nn)(BC)(DE)
LD    A  7F 78 79 7A 7B 7C 7D 7E 3En  7Ed    3Ann 0A  1A
      B  47 40 41 42 43 44 45 46 06n  46d
      C  4F 48 49 4A 4B 4C 4D 4E 0En  4Ed           LDD EDA8
      D  57 50 51 52 53 54 55 56 16n  56d           LDI EDA0
      E  5F 58 59 5A 5B 5C 5D 5E 1En  5Ed           CPD EDA9
      H  67 60 61 62 63 64 65 66 26n  66d           CPI EDA1
      L  6F 68 69 6A 6B 6C 6D 6E 2En  6Ed          LDIR EDB0
    (HL) 77 70 71 72 73 74 75 -- 36n               LDDR EDB8
(IX,IY+d)77d70d71d72d73d74d75d   36dn              CPIR EDB1
    (nn) 32nn                                      CPDR EDB9
    (BC) 02       PREFACE ALL IX with DD         LD I,A ED47
    (DE) 12               ALL IY with FD         LD R,A ED4F
                                                 LD A,I ED57
    with nn     (nn)          LD (nn), with:     LD A,R ED5F
LD BC     01nn ED4Bnn         BC       ED43nn
   DE     11nn ED5Bnn         DE       ED53nn
IX,IY,HL  21nn ED6Bnn/2Ann    HL/IX/IY ED63nn/22nn
   SP     31nn ED7Bnn            SP    ED73nn  LD SP, HL/IX/IY

      A  B  C  D  E  H  L (HL) n (IX,IY+d)  nop  00
ADD r 87 80 81 82 83 84 85 86 C6n   86d     CPL  2F
ADC r 8F 88 89 8A 8B 8C 8D 8E CEn   8Ed     NEG  ED44
SUB r 97 90 91 92 93 94 95 96 D6n   96d     CCF  3F
SBC r 9F 98 99 9A 9B 9C 9D 9E DEn   9Ed     SCF  37
AND r A7 A0 A1 A2 A3 A4 A5 A6 E6n   A6d     HALT 76
XOR r AF A8 A9 AA AB AC AD AE EEn   AEd     DI   F3
OR  r B7 B0 B1 B2 B3 B4 B5 B6 F6n   B6d     EI   FB
CP  r BF B8 B9 BA BB BC BD BE FEn   BEd     IM0  ED46
INC   3C 04 0C 14 1C 24 2C 34       34d     IM1  ED56
DEC   3D 05 0D 15 1D 25 2D 35       35d     IM2  ED5E

             BC   DE   HL   SP IX,IY       AF BC DE HL IX,IY
ADD HL,rr*   09   19   29   39         PUSH F5 C5 D5 E5  E5
ADC HL,rr  ED4A ED5A ED6A ED7A          POP F1 C1 D1 E1  E1
SBC HL,rr  ED42 ED52 ED62 ED72
INC rr       03   13   23   33         EX AF,AF' 08
DEC rr       0B   1B   2B   3B         EX DE,HL       EB
 * also to IX and IY. LD HL,HL.        EX SP,HL/IX/IY E3
                                       EXX            D9
C        A  B  C  D  E  H  L (HL)(IX,IY+d)
B RLC r 07 00 01 02 03 04 05 06   06d       RLCA  07
  RRC r 0F 08 09 0A 0B 0C 0D 0E   0Ed       RRCA  0F
P RL  r 17 10 11 12 13 14 15 16   16d       RLA   17
R RR  r 1F 18 19 1A 1B 1C 1D 1E   1Ed       RRA   1F
E SLA r 27 20 21 22 23 24 25 26   26d       RLD   ED6F
F SRA r 2F 28 29 2A 2B 2C 2D 2E   2Ed       RRD   ED67
I SLL r 37 30 31 32 33 34 35 36   36d       DAA   27
X SRL r 3F 38 39 3A 3B 3C 3D 3E   3Ed

          Z    NZ   C    NC   M    P    PE   PO  (HL,IX,IY)
  JP C3nn CAnn C2nn DAnn D2nn FAnn F2nn EAnn E2nn    E9
CALL CDnn CCnn C4nn DCnn D4nn FCnn F4nn ECnn E4nn
 RET C9   C8   C0   D8   D0   F8   F0   E8   E0
  JR 18d  28d  20d  38d  30d   DJNZ = 10d
```

*Corrections in the table above:* LD A,(nn)/(BC)/(DE)[^c11-20]; DIR[^c11-21]; LD rr,(nn)[^c11-22]; EX DE,IX/IY[^c11-23]; SLR[^c11-24]; CALL P/PE/PO[^c11-25].

<!-- p. 211 (pdf 221) -->

```text
             A    B    C    D    E    H    L   (HL)
IN r, (C)  ED78 ED40 ED48 ED50 ED58 ED60 ED68 ED70  IN A,(n) DBn
OUT (C),r  ED79 ED41 ED49 ED51 ED59 ED61 ED69 ED71  OUT(n),A D3n

IND  EDAA INI  EDA2   INDR EDBA  INIR EDB2
OUTD EDAB OUTI EDA3   OTDR EDBB  OTIR EDB3

C        A  B  C  D  E  H  L (HL)(IX,IY+d)
B BIT 0 47 40 41 42 43 44 45 46   d46       RST 0  RESET C7
      1 4F 48 49 4A 4B 4C 4D 4E   d4E       RST 8  ERROR CF
P     2 57 50 51 52 53 54 55 56   d56       RST 16 PRINT D7
R     3 5F 58 59 5A 5B 5C 5D 5E   d5E       RST 24 GET C DF
E     4 67 60 61 62 63 64 65 66   d66       RST 32 NXT C E7
F     5 6F 68 69 6A 6B 6C 6D 6E   d6E       RST 40 FP CL EF
I     6 77 70 71 72 73 74 75 76   d76       RST 48 BC SP F7
X     7 7F 78 79 7A 7B 7C 7D 7E   d7E       RST 56 KEYBD FF

C        A  B  C  D  E  H  L (HL)(IX,IY+d)
B RES 0 87 80 81 82 83 84 85 86   d86
      1 8F 88 89 8A 8B 8C 8D 8E   d8E
P     2 97 90 91 92 93 94 95 96   d96
R     3 9F 98 99 9A 9B 9C 9D 9E   d9E
E     4 A7 A0 A1 A2 A3 A4 A5 A6   dA6
F     5 AF A8 A9 AA AB AC AD AE   dAE
I     6 B7 B0 B1 B2 B3 B4 B5 B6   dB6
X     7 BF B8 B9 BA BB BC BD BE   dBE

C        A  B  C  D  E  H  L (HL)(IX,IY+d)
B SET 0 C7 C0 C1 C2 C3 C4 C5 C6   dC6
      1 CF C8 C9 CA CB CC CD CE   dCE
P     2 D7 D0 D1 D2 D3 D4 D5 D6   dD6
R     3 DF D8 D9 DA DB DC DD DE   dDE
E     4 E7 E0 E1 E2 E3 E4 E5 E6   dE6
F     5 EF E8 E9 EA EB EC ED EE   dEE
I     6 F7 F0 F1 F2 F3 F4 F5 F6   dF6
X     7 FF F8 F9 FA FB FC FD FE   dFE
```

The following commands may be unsupported:

```text
               A  B  C  D  E  n  LIX,LIY HIX,HIY
LD H(IX,IY)   67 60 61 62 63 26    65      --
LD L(IX,IY)   6F 68 69 6A 6B 2E    --      6C

    H(IX,IY)   L(IX,IY)        H(IX,IY)   L(IX,IY)
LD A    7C         7D       ADD    84         85
LD B    44         45       ADC    8C         8D
LD C    4C         4D       SUB    94         95
LD D    54         55       SBC    9C         9D
LD E    5C         5D       AND    A4         A5
INC     24         2C       XOR    AC         AD
DEC     25         2D       OR     B4         B5
                            CP     BC         BD
```

*Corrections in the table above:* OUT(C),A D3n[^c11-26]; the "ED PREFIX" margin label[^c11-27]; LD L(IX,IY),n[^c11-28]; H(IX,IY) and L(IX,IY) column headings[^v13-3].

<!-- p. 212 (pdf 222) -->

## Appendix E: Decimal/Hex Conversion Tables

### Address Conversion

```text
HEX DECIMAL      HEX DECIMAL     HEX DECIMAL     HEX DECIMAL
 0                0    0          0    0          0    0
 1     4096       1  256          1   16          1    1
 2     8192       2  512          2   32          2    2
 3    12288       3  768          3   48          3    3
 4    16384       4 1024          4   64          4    4
 5    20480       5 1280          5   80          5    5
 6    24576       6 1536          6   96          6    6
 7    28672       7 1792          7  112          7    7
 8    32768       8 2048          8  128          8    8
 9    36864       9 2304          9  144          9    9
 A    40960       A 2560          A  160          A   10
 B    45056       B 2816          B  176          B   11
 C    49152       C 3072          C  192          C   12
 D    53248       D 3328          D  208          D   13
 E    57344       E 3584          E  224          E   14
 F    61440       F 3840          F  240          F   15
      65535         4095             255              15
```

*Corrections in the table above:* fourth column, third row[^c11-29]; second column total[^c11-30].

### Negative Number Conversion Table

```text
    __0___1___2___3___4___5___6___7___8___9_
0      0 255 254 253 252 251 250 249 248 247
    _00__FF__FE__FD__FC__FB__FA__F9__F8__F7_
10   246 245 244 243 242 241 240 239 238 237
    _F6__F5__F4__F3__F2__F1__F0__EF__EE__ED_
20   236 235 234 233 232 231 230 229 228 227
    _EC__EB__EA__E9__E8__E7__E6__E5__E4__E3_
30   226 225 224 223 222 221 220 219 218 217
    _E2__E1__E0__DF__DE__DD__DC__DB__DA__D9_
40   216 215 214 213 212 211 210 209 208 207
    _D8__D7__D6__D5__D4__D3__D2__D1__D0__CF_
50   206 205 204 203 202 201 200 199 198 197
    _CE__CD__CC__CB__CA__C9__C8__C7__C6__C5_
60   196 195 194 193 192 191 190 189 188 187
    _C4__C3__C2__C1__C0__BF__BE__BD__BC__BB_
70   186 185 184 183 182 181 180 179 178 177
    _BA__B9__B8__B7__B6__B5__B4__B3__B2__B1_
80   176 175 174 173 172 171 170 169 168 167
    _B0__AF__AE__AD__AC__AB__AA__A9__A8__A7_
90   166 165 164 163 162 161 160 159 158 157
    _A6__A5__A4__A3__A2__A1__A0__9F__9E__9D_
100  156 155 154 153 152 151 150 149 148 147
    _9C__9B__9A__99__98__97__96__95__94__93_
110  146 145 144 143 142 141 140 139 138 137
    _92__91__90__8F__8E__8D__8C__8B__8A__89_
120  136 135 134 133 132 131 130 129 128
    _88__87__86__85__84__83__82__81__80_
```

<!-- p. 213 (pdf 223) -->

## Appendix F: Bibliography

Baker, Toni, "Mastering Machine Code on Your ZX81", Reston Publishing Co. Inc., 11480 Sunset Hills Rd., Reston, Va. 22090 \$12.95.

Carr, Joseph P., "Timex Sinclair 2068,1500 and 1000 Machine Language Programming and Interfacing", Reston Publishing Co. Inc., 11480 Sunset Hills Rd., Reston, Va. 22090.

Corcoran, V. C., and Branigin, M. H., "Timex Sinclair 2068 Personal Color Computer Technical Manual", Timex Computer Corporation, Waterbury, CT. 06720 \$25.00.

Dreger, Lloyd H., "The Timex/Sinclair 2068 ROM Manuscript", S.M.U.G., Box 101, Butler, WI. 53007 \$16.95.

Leventhal, Lance A., "Z80 Assembly Language Programing", Osborn/McGraw Hill, 2600 10th St., Berkley, CA. \$18.95.

Logan, Dr. Ian, & O'Hara, Dr. Frank, "The Complete Timex TS1000/Sinclair ZX81 ROM Disassembly", Melbourn House Publisher.

Mazur, Jeff, "Timex Sinclair 2068 Intermediate/Advanced Guide", Howard W. Sams & Co. Inc., 4300 W 62nd St., Indianapolis, IN. 46268 \$9.95.

Naylor, Jeff., and Rogers, Diane, "Inside The Timex Sinclair 2000 Computer", Sunshine Books, 12-13 Little Newport St., London WC2R 3LD \$11.95.

Spracklen, Kathe, "Z-80 Assembly Language Programing", Osborn/McGraw Hill, 2600 10th St., Berkley, CA. 94710 \$9.70.

The following are Copyrights of the companies listed:

T/S 2068 Timex Computer Corporation.

MSCRIPT Micro Systems Inc.

TASWORD II Tasman Software, Leeds, England.

AERCO Acme Electric Robot Co.

MTERM Micro Systems Software Inc.

<!-- p. ? (pdf 224) -->

[^c10-3]: Corrected. The original printed 13 for LD HL, (nn); LD HL,(nn) (2AH) takes 16 T states in the Zilog tables, the same as LD (nn),HL, which the table gives correctly as 16.

[^c10-4]: Corrected. The original printed "RRL"; there is no RRL instruction, and SRL (CB 38-3F, 8/15/23 T states as in the three cases above) is the only shift/rotate missing from the list.

[^c10-5]: Corrected. The original printed "7 T states longer"; the DD/FD prefix adds 4 T states to the undocumented IXH/IXL/IYH/IYL instructions (e.g. LD A,IXH is 8 T states against 4 for LD A,H).

[^c10-6]: Corrected. The original printed 44 (a comma) at 64024 for the apostrophe in "I'm", which would print "I,m"; the apostrophe is character code 39.

[^c10-7]: Corrected. The original printed line 64030 with 11 bytes, 114,32,102,114,105,101,110,110,100,108,121, spelling "frienndly" and pushing every following byte one address past its line label; the Basic line has "friendly", and with the extra 110 removed every line again starts at its label.

[^c10-8]: Corrected. The original printed `'' TAB 7` in the Basic line, where the data has 173,5 (TAB 5); the data is right, because the 21-character top border must start at column 5 to line up with the middle and bottom rows of the box, which the Basic line itself places at TAB 5.

[^c10-9]: Corrected. The original printed "82n32" at 64087/64088; the "n" is a typing slip for a comma (82 = "R" ending "SINCLAIR", 32 = the space before "2068").

[^c10-10]: Not corrected. At 64135 the data has 46 (a full stop) after "Computer", but the Basic line has "Computer" with no full stop; either one could be the slip, and nothing on the page decides which.

[^c10-11]: Corrected. The original printed a stray 114 ("r") at 64159 after "name?", so that "name?r" would be printed; the Basic line has no such character. With it removed, the last three lines are rewrapped so that each starts at its label.

[^c10-12]: Not corrected. The data has 172,12,14 (AT 12,14) where the Basic line has AT 13,14; both rows are valid for the routine (which accepts lines 0-23), and nothing on the page shows which row the answer field was meant to occupy.

[^c10-13]: Corrected. The original printed the final control pair as a second 222,0 (OVER 0, a duplicate of the one before it); the Basic line ends BRIGHT 0, which is 220,0, and is needed to undo the BRIGHT 1 set before "Computer".

[^c10-14]: Corrected. The original printed "254,6" at 64725 with mnemonic "CP 8"; CP 8 assembles as 254,8 (as in the PAPER routine at 64739), and with 6 the INK routine would reject INK 6 and INK 7.

[^c10-15]: Corrected. The original printed "214,8" (SUB 8) at 64897 with mnemonic "ADD A, 8"; moving to the next third of the screen needs H + 8, and ADD A,8 is 198,8, as at 64992 in the identical ADJUST code.

[^c10-16]: Corrected. The original printed the address as "65942"; it follows LD H,64 (2 bytes) at 64940 and precedes 64943, so it is 64942.

[^c10-17]: Corrected. The original printed "198,2" at 64957 with mnemonic "ADD A, 8"; the code subtracts 8 from the line number and must add the 8 back here when the subtraction borrows, and ADD A,8 is 198,8.

[^c10-18]: Corrected. The original printed the displacements at 65032 and 65036 as 40,143 and 40,139, which land at 64921, inside JR Z,TAB; to reach UNPRINTABLE ? at 64922 they must be 40,144 and 40,140 (the JR C,UNPRINTABLE ? at 65014, 56,162, is correct).

[^c11-1]: Corrected. The original printed `SUB A, 8` against the bytes 214,7; the bytes (SUB 7) are right, because DO ATTR has already stepped D back to the 8th pixel row of the cell (H = top row + 7), so subtracting 7 returns H to the top pixel row for the next print position (SUB 8 would land in the wrong screen third).

[^v13-1]: Library note: neither `INC HL` nor `LD A, L` affects the flags, so Z still holds the result of `OR 88` at 65096, which is never zero, and SKIP is never taken: after a character is printed in the last cell of a screen third (L = 255), H, which INC HL has already carried into the next third, is reduced by 7, so printing resumes at the start of the same third one pixel row low instead of moving on to the next third. Inserting `AND A` (167) after `LD A, L` makes the JR Z test L, at the cost of moving everything after 65106 up one byte (the backward jumps that cross the insertion, such as JR NXT CHAR at 65114 and JR DO ATTR at 65150, and forward jumps into the moved code, such as JR C, GRAPHIC at 65026, need their displacements adjusted). See docs/z80_combined_reference.md (flags affected by LD and 16-bit INC).

[^c11-2]: Corrected. The original printed "ADD IY,DE" for 09 AFTER FD; FD 09 disassembles as ADD IY,BC (ADD IY,DE is FD 19, listed correctly at 25).

[^v13-2]: Corrected against the ROM. The original printed "\`" (backquote) for character 96; in the TS2068 character set code 96 (60H) is the pound sign £ (HOME ROM character bitmap at 3F00H). See docs/ts2068_tokens_and_keyboard.md.

[^c11-3]: Corrected. The original printed "LD HIX, H\*"/"LD HIY, H\*" at 64 and "LD LIX, H\*"/"LD LIY, H\*" at 6C AFTER DD/FD; after a DD/FD prefix the H operand is itself replaced by the index-register half, so DD 64 and DD 6C disassemble as LD IXH,IXH and LD IXL,IXH (likewise for IY).

[^c11-4]: Corrected. The original printed "RR D" and "RL D" at 67 and 6F AFTER ED; ED 67 and ED 6F are RRD and RLD, single mnemonics with no operand, as Appendix D lists them (RR D and RL D are CB 1A and CB 12).

[^c11-5]: Corrected. The original printed "IN(HL),(C)" and "OUT(C),(HL)" at 70 and 71 AFTER ED, with no \*; these undocumented codes disassemble as IN (C) (the input sets the flags but is stored nowhere) and OUT (C),0 (it outputs 0 on NMOS Z80s, not the contents of (HL)), and are now marked \* like the other undocumented codes.

[^c11-6]: Corrected. The original printed "ADC A,LIX\*" for 8D AFTER FD; FD 8D disassembles as ADC A,IYL, and every other FD entry uses the IY halves.

[^c11-7]: Corrected. The original printed "IRIR" for B2 AFTER ED; ED B2 is INIR.

[^c11-8]: Corrected. The original printed "OR )IY+d)" for B6 AFTER FD; a typo for OR (IY+d), as FD B6 disassembles.

[^c11-9]: Corrected. The original printed "AND A" for E6 NORMAL; E6 nn is AND N (AND A is A7, listed at 167).

[^c11-10]: Corrected. The original printed "EX DE,IX" and "EX DE,IY" for EB AFTER DD and AFTER FD; the Z80 has no such instructions (DD EB and FD EB disassemble as plain EX DE,HL), so these cells are left blank like the other codes the prefix does not affect.

[^c11-11]: Corrected. The original printed "RES 6,(IY+d)" for 190 BE AFTER FDCBdd; FD CB d BE disassembles as RES 7,(IY+d), matching the DD column (RES 6 is B6, listed at 182).

[^c11-12]: Corrected. The original printed "237,106nn" for LD HL,(nn); ED 6B is 237,107 (237,106 is ADC HL,HL, as the ADC HL,rr row shows).

[^c11-13]: Corrected. The original printed CCF as 65 in the second copy of the ADD...CP block; CCF is 3F = 63, as in the first copy. The block itself is printed twice on this page, the first copy ending in a garbled "IM0 237HL)     n" line with its INC/DEC rows missing; this paste-up duplication is left as printed.

[^c11-14]: Corrected. The original printed DEC B as 4; DEC B is 05 = 5 (4 is INC B, in the row above), matching the hex page.

[^c11-15]: Corrected. The original printed "EX DE, HL/IX/IY 235"; only EX DE,HL exists, since DD EB and FD EB execute as plain EX DE,HL (see note [c11-10]).

[^c11-16]: Corrected. The original printed OUT (C),L as 195; it is ED 69 = 105, as on the hex page (195 is JP nn).

[^c11-17]: Corrected. The original printed INDR as "237,178", the same as INIR; INDR is ED BA = 237,186, as on the hex page.

[^c11-18]: Corrected. The original RES table jumped from row 2 to row 5, ran a stray fragment "229 230   d230" (SET 4,L and SET 4,(HL)) onto the end of row 2, and printed the SET 5-7 codes (239..., 247..., 255...) as RES rows 5-7, with no SET table at all; the RES rows 3-7 and the full SET table (rows 0-7, the printed 239/247/255 rows being its rows 5-7) were missing or misplaced in the original and are restored here from the CB opcode pattern (RES = 128 + 8b + r, SET = 192 + 8b + r), checked against a Z80 disassembler and the hex page.

[^c11-19]: Corrected. The original printed LD L(IX,IY),n as 39; it is DD 2E = 46 (39 is DAA), consistent with LD H(IX,IY),n = 38 in the row above.

[^c11-20]: Corrected. The original printed the LD A,(nn)/(BC)/(DE) codes as "58nn 10  26", the decimal values; in hex they are 3Ann, 0A and 1A.

[^c11-21]: Corrected. The original printed "DIR EDB0"; ED B0 is LDIR, as on the decimal page.

[^c11-22]: Corrected. The original printed "ED48nn", "ED58nn", "ED68nn/42nn" and "ED78nn" for LD rr,(nn); these are ED 4B, ED 5B, ED 6B or 2A, and ED 7B (decimal 237,75 / 237,91 / 237,107 or 42 / 237,123), while ED 48/58/68/78 are IN C/E/L/A,(C) and 42 is LD B,D (the glyphs were checked at high magnification and are 8, not B).

[^c11-23]: Corrected. The original printed "EX DE,HL/IX/IY EB"; only EX DE,HL exists (see note [c11-10]).

[^c11-24]: Corrected. The original printed "SLR r"; the mnemonic for CB 38-3F is SRL, and the codes were already right.

[^c11-25]: Corrected. The original printed CALL P, CALL PE and CALL PO as F0nn, E8nn and E0nn, which are the RET P/PE/PO codes in the row below; they are F4nn, ECnn and E4nn (decimal 244, 236 and 228, as on the decimal page).

[^c11-26]: Corrected. The original printed "OUT(C),A D3n"; D3 n is OUT (n),A, as on the decimal page (OUT (C),A is ED79, at the start of the row).

[^c11-27]: Corrected. The original margin label beside the BIT, RES and SET tables spelled "ED PREFIX"; these are CB-prefixed instructions, labelled "CB PREFIX" on the rotate/shift table on p. 210 and "203 PREFIX" on the decimal page.

[^c11-28]: Corrected. The original printed LD L(IX,IY),n as 27; it is DD 2E (27 is DAA), consistent with LD H(IX,IY),n = 26 in the row above.

[^v13-3]: Corrected. The original printed the column headings as "H(IX,IY+d) L(IX,IY+d)"; the codes listed (7C/7D, 84/85, ...) are the undocumented IXH/IXL (IYH/IYL) half-register forms, which take no displacement, as the decimal tables label them (LD A,HIX\*, LD A,LIX\*).

[^c11-29]: Corrected. The original printed "1    2" in the third row of the fourth column; the hex digit is 2, since every other row pairs the digit with itself (2 = 2).

[^c11-30]: Corrected. The original printed the second column's closing total as 4096; like the other totals (FFFF = 65535, FF = 255, F = 15), it is FFF = F00 + FF = 3840 + 255 = 4095.
