<!--
  DERIVED FILE — do not treat as authoritative.

  Source: docs/Timex Sinclair 2068 Technical Manual (best).pdf, pages 90-104
  Extracted mechanically with `pdftotext -layout`; tables in this chapter were
  then transcribed by hand and checked against the rendered page.

  The PDF itself is a 2016 Microsoft Word reconstruction of the 1986 Second
  Edition, and its own preface warns that the cut-and-paste used to make it
  "would sometimes mix text up in a way that word groups from a particular
  sentence would be transposed to different locations". That corruption is in
  the PDF, not in this extraction — see for example the bullet list on page 6.
  <!-- PDF page N --> markers below give the source page for every passage, so
  anything surprising can be checked against the original.
-->

# 6. Known "Bugs" and Corrections

*Timex Sinclair 2068 Technical Reference Manual — pages 90-104.*
*[Full PDF](../Timex%20Sinclair%202068%20Technical%20Manual%20%28best%29.pdf) · [chapter index](README.md)*

---

<!-- PDF page 90 -->

## 6 Known "Bugs" and corrections

This section describes the known problems in the TS 2068 System Software and gives
corrections or workarounds where these have been defined.

### 6.1 LROS and Autostart Machine Code AROS

#### 6.1.1 Keyboard

If you will be using the System ROM Keyboard routines and accessing the input
character code from system variable LAST K (5C08H), you must initialize the TS
2068 to "L" mode by setting the system variable MODE at 23617(5C41H) to zero and
setting Bit 3 of FLAGS (23611 -5C3BH) to 1. (The TS 2068 is in "K" mode when control
is passed from System Initialization to the Cartridge; Keyword Token codes will be
placed in LAST K instead of character codes.

#### 6.1.2 Calculator

If you will be using the System ROM Calculator routines (RESTART 40 (28H) ) or any
ROM routines that invoke them, you must initialize the System Variable YEM by
doing the following:

```text
LD HL,5C92H            ;Set HL=MEMBOT
LD (5C68H),HL          ;Initialize MEM
```

#### 6.1.3 Chunk 3

Chunk 3 must not be designated as "in use" by the Cartridge Memory Selection
specification byte. This will cause de-selection of the bank switching code prior to
completion of the transfer of control to the cartridge starting address. Once control has
been transferred, the cartridge code may then enable Chunk 3 in the Dock Bank if
desired. (See Section 5.1.)

#### 6.1.4 AROS under LROS

No entry is made in the System Configuration Table for an RROS if an LROS is present.
This means that an LROS designed to support either RAM based or cartridge based
applications must include code for detection of an AROS.

### 6.2 Machine Code AROS

When setting the AROS Overhead parameter requesting RAM space for machine code
variables, 21 + n bytes (15H + n) must be requested where n is the number of bytes
needed. The machine language variables area then starts at 6 8 5 5 H immediately
following the 21-byte CHANS area. (See Section 5.1.2.3.)

NOTE: This does not apply to an AROS that contains both BASIC and machine code.

<!-- PDF page 91 -->

### 6.3 BASIC AROS

#### 6.3.1 USR Function

When testing the USR address against the Cartridge Memory Selection byte to determine
if the address is in the Home Bank or the Dock Bank, the wrong nibble is tested in the
register thus a valid cartridge address could be erroneously processed as a Home Bank
address. Since the ROM code cannot be corrected, the machine code in the cartridge
would have to be moved to an address that does not cause a problem.

#### 6.3.2 FOR/NEXT

If the limit of the FOR statement has already been passed on its initial execution, (e.g.
FOR A=1 TO 10 and A has been set to 12), control is passed to the statement following
the corresponding NEXT. In the AROS support code, the address of this statement is lost
giving unpredictable results. Since the ROM code cannot be corrected, care must be
taken not to use this technique in an AROS Cartridge. Normal usage of FOR/NEXT
loops is not affected.

#### 6.3.3 Advanced Video Modes

Because the BASIC AROS support code interfaces directly to the Bank Switching code
in Chunk 3 (does not access based on its relocatability), the second display file cannot be
open when executing BASIC program from an AROS.

### 6.4 Video Mode Change Service

#### 6.4.1 Available Memory Test

When the size of memory needed is calculated by adding the size of the second display
file (6912 bytes or 1BOOH) to the memory now in use (address in System Variable
STKEND), the code fails to check for overflow. Thus if the address in STKEND is
greater than 58623 (E4FFH), the fact that there is not enough free memory to open the
second display file will not be detected and the system will "crash". If your BASIC
program and/or variables area are large, you may want to make this test yourself prior to
invoking the Video Mode Change Service in order to avoid this problem. The size of
memory needed is subsequently tested against the contents of RAMTOP and if there is
not sufficient space (value in RAMTOP is less than size needed), you will get Error 4,
Out of Memory.

#### 6.4.2 RAMTOP

When the machine stack and OS RAM code is moved to Chunk 7, the User Defined
Graphics area is moved down in RAM by 2112 bytes (840H) to make room for the stack
and OS RAM routines at the top of memory. The pointer in UDG is updated, however,
the value in RAMTOP is not modified to insure that the relocated UDG area as well as
the OS code and stack are protected from expansion of the BASIC program. You can
avoid problems by setting RAMTOP via a CLEAR command specifying an address no
greater than 63255 (F717H) prior to invoking the Video Mode Change Service. This

<!-- PDF page 92 -->

reserves space between RAMTOP and the end of memory of 2280 bytes (8E8H) utilized
as:

## 168 bytes ( A8H) User Defined Graphics (21 X 8)

## 2112 bytes (840H) Machine Stack and OS Routines

________________
## 2280 (8E8H)


```text
Example:        RAMTOP = 63255 (F717H)
     + Reserved Area      2280 (08E8H)
                         65535 (FFFFH)
```

The software packages in Appendix C are written assuming that RAMTOP is set to
57343 (DFFFH) or lower to protect the machine code which is loaded beginning
at 57344 (E000H).

#### 6.4.3 New Command

If you have used the Video Mode Change Service to open the second display file and
now wish to execute the NEW command, you should first return the computer to
"normal" mode by calling the video mode service with A=zero. This returns the User
Defined Graphics and other RAM structures to their normal locations. If you don't do
this, the UDG area will remain in the alternate location and, if you have
not corrected RAMTOP as explained above, part or all of your UDG area could he
cleared to zeros by the NEW command.

#### 6.4.4 VIDMOD

When Mode 128 (80H) is designated for activating the Primary Display File in Dual
Screen Mode the System Variable VIDMOD at 23746 (5CC2H) is set to zero instead of
to 128. This creates a potential problem if the 17 ms. interruption occurs before
VIDMOD can be corrected since the interruption fielder will branch to Chunk 3 instead
of to Chunk 7 and Chunk 3 is now in use for the second display file. This problem is
corrected by disabling the interruption prior to calling the Video Mode Change Service
and setting VIDMOD to the correct value prior to re-enabling it. These corrections are
included in the Extension ROM Interface Routine in Figure 3.2.2-2.

NOTE: On an initial access changing video mode from normal to Mode 128, the
interruption is re-enabled within the Video Mode Change Service itself after copying the
stack and other Chunk 3 data to Chunk 7. This cannot be corrected, but has not proven to
present a problem in actual use. At the point where the interruption is first enabled, the
Chunk 3 code is still intact allowing for correct processing of one interruption, and the
path length from there to the point of correcting VIDMOD is apparently less than 17ms.
The interruption is also re-enabled within the Video Mode Change Service if you have
applied the patches for the BANK ENABLE and RESTORE STATUS routines (Section
6.5.4) which are executed in connection with inserting space into the RAM to open the
second display file. Again, this has not proven to be a problem in actual use.

<!-- PDF page 93 -->

#### 6.4.5 Interrupt Inhibit

By setting Bit 6 of Port 0FFH to a 1, the normal 17 ms. interruption generated from
the SCLD to the Z80A CPU will be inhibited. When Port 0FFH is written to by the Video
Mode Change Service, Bit 6 is forced to zero. If you wish to inhibit the normal
interruption via this mechanism, and also plan to use the Video Mode Change Service, it
is recommended that you first invoke the service to remap the RAM and open the second
display file, then set Bit 6 of Port 0FFH to inhibit the normal interruption and write your
own routine(s) for subsequent changing of the video mode setting that do not involve
remapping the RAM. In this way you can maintain the value in Bit 6.

### 6.5 OS RAM ROUTINES

In patching the OS RAM routines, care must be taken not to relocate CALL and JP
instructions since this affects the modification of the code when it is moved between
Chunks 3 and 7. All of the code containing actual addresses must be modified to reflect
the relocation and this is done using a table in the Extension ROM. Since the table cannot
be changed, none of these instructions can be moved. Also, any CALL or JP instructions
added must be modified by you when the code is relocated.

#### 6.5.1 Function Dispatcher

For a variety of reasons such as conflict with use of the IX Register, incorrect entries in
the ROM Function Dispatcher Jump Table, etc. some Service Codes have been deleted
from the Function Dispatcher table (Table 3.3.4-z). In addition, the following correction
to the GET STATUS routine' is required in order to successfully utilize the Function
Dispatcher from a cartridge.

#### 6.5.2 Get Status

Returns invalid memory selection status for-the Home Bank, ROM Extension and Dock.
This results in switching out of either the Home Bank or the Dock when status is
"restored". This affects use of the Function Dispatcher and GET WORD routines, and
any other code using GET STATUS. Figure 6.5-l shows the patches and additions
necessary to correct this routine.

#### 6.5.3 Put Word

Write data passed in Reg. Pair DE is overwritten prior to use. Figure 6.5-2 shows
corrections.

#### 6.5.4 Bank Enable and Restore Status

If the 17ms interruption occurs during update of the memory selection hardware, it can
cause the system to hang and RAM to be overwritten. This occurs when the interruption
happens in an interval when Port FF Bit 7 is zero (thus selecting the Dock Bank) and Port
F4 Bit 0 is one (thus enabling Chunk 0 in the Dock Bank) and there is no memory in
Chunk 0 of the Dock Bank. This can be true when there is no cartridge installed, or

<!-- PDF page 94 -->

if the cartridge installed is an AROS. This problem is corrected by disabling or masking
the interruption while updating the memory selection hardware. Figure 6.5-3 shows one
implementation of this correction.

#### 6.5.5 Save Status and Restore Status

The value of Port FFH which includes video mode and interruption inhibit as well as Ext.
ROM/Dock Select is saved and restored as a full 8-bits. Therefore any modification of
this port by code accessed between execution of SAVE STATUS and subsequent
execution of RESTORE STATUS (erg. via CALL BANK or use of the Function
Dispatcher) is "undone". This is one reason the Video Mode Change Service and some of
the bank switching routines such as BANK ENABLE cannot be meaningfully accessed
via the Function Dispatcher.

#### 6.5.6 Call Bank

Does not correctly retrieve the stack entry designating the count of parameters being
passed. Memory is overwritten in the case where this count is not zero. This is corrected
by setting Location 6610H = 9 (POKE 26128,9). You only need to apply the correction
once; it will be duplicated in Chunk 7 if the code is relocated.

FIGURE 6.5-1
GET_STATUS CORRECTIONS

```text
GET_STATUS     PUSH   AF             ; save regs
               PUSH   DE
               LD     A, B           ; get bank number
               CP     0FEH           ; test if extension (254)
               JR     Z, GS_EXT
               CP     0FFH           ; test if home (255)
               JR     Z, GS_HOME
               AND    A
               JR     Z, GS_DOCK     ; test if dock (0)
```

***      MORE CODE HERE THAT IS NOT AFFECTED ***

```text
GS_EXT         LD     C, 0FFH        ; assume none
               IN     A, (0FFH)      ; test if selected
               AND    80H
               JR     Z, GS_XT1      ; not active
               JR     GETHS          ; get hsr
GS_DOCK        LD     C, 0FFH        ; assume none
               IN     A, (0FFH)      ; test if selected
               AND    80H
               JR     NZ, GS_XT1     ; not active
GETHS          IN     A, (0F4H)      ; get hsr
               CPL                   ; invert to low active
               JR     GX_XT0         ; exit
GS_HOME        IN     A, (0F4H)      ; all bits set are not active in home bank
GS_XT0         LD     C, A           ; memory select C
GS_XT1         POP    DE             ; restore regs
               POP    AF
               RET
```

<!-- PDF page 95 -->

FIGURE 6.5-1
GET_STATUS CORRECTIONS
(Continued)

From BASIC:
POKE 25610,40 (Location 640AH)
POKE 25611,36
POKE 25614,40 (Location 640EH)
POKE 25615,55
POKE 25617,40 (Location 6411H)
POKE 25618,39
POKE 25648,14 (Location 6430H)
POKE 25649,255
POKE 25650,219
POKE 25651,255
POKE 25652,230
POKE 25653,128
POKE 25654,40
POKE 25655,18
POKE 25656,24
POKE 25657,8
POKE 25658,14
POKE 25659,255
POKE 25660,219
POKE 25661,255
POKE 25662,230
POKE 25663,128
POKE 25664,32
POKE 25665,8
POKE 25666,219
POKE 25667,244
POKE 25668,47
POKE 25669,24
POKE 25670,2
POKE 25671,219
POKE 25672,244
POKE 25673,79

<!-- PDF page 96 -->

FIGURE 6.5-2
PUT WORD CORRECTIONS

```text
PUT_WORD     PUSH AF            ; save regs
             PUSH BC
             CALL GET_NUMBER    ; bank # of owner
             PUSH DE            ; save data
             LD     D, B        ; save target bank #
             LD     B, A        ; bank # of owner
             CALL GET_STATUS    ; get bank status
             PUSH BC            ; save it
             CALL GET_CHUNK     ; get bit map
             CPL                ; set active high
             LD     B, D        ; target bank # in B
             LD     C, A        ; memory select byte
             CALL BANK_ENABLE   ; enable target memory
             POP    BC          ; saved bank status
             POP    DE          ; saved data
             LD     (HL), E     ; write LSB
             INC    HL          ;
             LD     (HL), D     ; write MSB
             DEC    HL          ; restore HL
             CALL BANK_ENABLE   ; restore bank
             POP    BC          ; restore registers
             POP    AF
             RET
```

From BASIC:
POKE 25408,213
POKE 25424,193
POKE 25425,209
POKE 25426,115
POKE 25427,35
POKE 25428,114
POKE 25429,43

NOTE: The corrections to GET-STATUS and BANK-ENABLE are also required.

<!-- PDF page 97 -->

FIGURE 6.5-3
BANK- ENABLE AND RESTORE STATUS CORRECTIONS

```text
From BASIC
BANK ENABLE: Location         Object Code     POKE Address Value
             6499H            00     NOP      25753        0
             649DH            F3     DI       25757        243
             651CH            FB     EI       25884        251
```

```text
RESTORE -STATUS:
             654AH            F3      DI      25930          243
             6570H            FB      EI      25968          251
```

In both cases, the Disable Interrupt and Enable Interrupt are being done by deleting the
preservation of the AF Registers (PUSH AF/POP AF). If your code requires AF to be
saved, you must do it prior to calling either of these routines or any other system routines
that use them. Note also that if you already have the interruption masked when these
routines are entered, it will be enabled when they are exited. If this proves to be a
problem, replace the Enable Interruption (EI) instruction with a NOP and do the enable at
a more appropriate place in your own code.

#### 6.5.7 GET_NUMBER

Always returns the Dock Bank # for any memory enabled in the ROM Extension.
Unlikely to be a problem because of limited use of the ROM Extension.

#### 6.5.8 XFER_BYTES

Improperly passes memory select byte for the case where source and destination are in
the same bank. This is corrected by setting Location 676AH = 5FH (POKE 26474,951).

### 6.6 General

#### 6.6.1 Enter Key Anomalies

Pressing ENTER multiple times with an invalid tape command on the edit line (syntax
error) causes the system to reset. This is due to overflowing the Bank Status Stack in
RAM Chunk 3/7 due to the multiple calls to and from the Extension ROM via the Call
Bank code without normal termination (the error causes-a RESTART 8 to be executed
out of Home ROM code called from the ROM Extension). It shouldn't take anybody that
many tries to get a tape command right, so this is not a real problem, but you may want to
keep it in mind. For any call made through the OS RAM services, you should have a
corresponding return to keep the structures clean.

#### 6.6.2 ON_ERR_GOTO

If a non-existent line number is specified, followed by an error, the system will hang.

<!-- PDF page 98 -->

The ROM code is in an endless loop trying to report the absence of a valid error handler
to the non-existent error handler!!! On some errors, you will get an unexpected 0 OK
termination showing the line number of your Error Handler. This is because some ROM
routines temporarily clear the INTPT Flag (Bit 7 of FLAGS). This flag is set to 0 when
checking syntax and set to 1 when executing; if an error is detected while the
Flag=0, the error handler code is branched to but is not executed.

#### 6.6.3 Sound Command Parameters

Parameters to the SOUND command are not fully validated, therefore you can specify a
number beyond the valid range for a given operation and not get an error, for example,
you can write a value greater than 63 to the Enable Register (Reg.7), possibly changing
the I/O Port used for reading the joysticks from input to output. If you specify a number
larger than 255 (FFH), only the least significant byte will be actually written to the
Programmable Sound Generator. Access to PSG Reg. 14 (IO-A) used for the Joysticks is
also not precluded via the SOUND command.

If you experience difficulty in reading the joystick(s), do a write to PSG Reg. 7 clearing
Bit 6 to 0 to guarantee that the joystick path is enabled for input (see Section 4.3). This
write can be done by executing a SOUND 7,63 (or any value less than 63).

The INTEGER function for (-65536) gives an incorrect result of -1, and for other cases
where the result should be -65536, it gives -lE-38. Since the ROM code cannot be
changed, there is no correction.

#### 6.6.4 Scroll? User Responses

If you respond to the SCROLL? message using multiple keys such as Cap Shift/Z or Cap
Shift/Symbol Shift, you will get strange results like dumping of the Edit Line with the
"C" or "E cursor, display of ROM data, or multiple scrolls. Stick to single key responses
and you won't have any problems!

#### 6.6.5 Delete Key Anomalies

When DELETE (Cap Shift/O) is held down to do deletion of characters in the Edit Line,
sometimes it outputs the DELETE Keyword instead (it should not do this in auto-repeat
mode). This is especially noticeable when the input line is long. Since the ROM code
cannot be corrected, you must try releasing and pressing the DELETE key at differing
frequencies and you will be able to get past this "Bug".

<!-- PDF page 99 -->

Appendix A
Home ROM Map

```text
Module           Origin         Length
BLOCK            0000           0000
BASIC            0000           0227
KBSCAN           0227           02D9
IO_1             0500           0502
IO_2             0A02           031B
EDIT             0D1D           0682
CHANS            139F           0142
LIST             14E1           02D4
AROS             17B5           0190
SYNTAX           1945           080A
SYNTWO           214F           04B4
GRAPHS           2603           0251
EXPRN            2854           041C
IDENT            2C70           03E9
INOUT            3059           0301
SUMS             335A           032A
CALC             3684           0437
FUNCTS           3ABB           01CE
TAPEMSG          3C89           0053
CH_SET           3D00           0300
```

<!-- PDF page 100 -->

```text
Global            Address   Global         Address
ACS               3C5E      DIGIT?         30D9
ADD               33D3      DIM            2FC0
ALNUM?            3046      DIVIDE         356E
ALPHA?            304B      DRAW           26DB
ANGLE             3B9E      DRAWLN         2813
AROS              18C6      DRAW_L         2810
ARRAY             37C5      DUMPPTR        0A23
AR_LN             17EA      DYADIC         1BDC
AR_NXT            17FF      ECHO           0CA3
ASN               3C4E      EDIT_K         0A82
ATN               3BFD      END?           1B44
ATTBYT            0710      ENDSTT         1AB9
BEEP              0436      ENDTEM         1B4A
BORDER            2436      ERASE          25D4
BREAK?            2009      ERR2           1B91
CAT               25C8      ERR4           1FCF
CHCODE            0371      ERR5           07C1
CHINIT            11AA      ERR6           356C
CHK_SZ            1FBB      ERRB           1F29
CIRCLE            2679      ERRH           237E
CLCHAN            13BE      ERRO           123D
CLEAR             1F36      EXECUTE        1AD8
CLEL              13FF      EXPRN          2854
CLLHS             08A9      EIND_L         16D6
CLOSE             139F      FIND_N         2C70
GLPR              0035      FIX_U          1F23
CLR_BC            1F39      INS_U1         1F1E
CLS               08EA      FLASHA         160D
CLS_B             097F      FLOAT          3656
COLITM            23A6      FOR            1C78
COLOUR            23DE      FORMAT         25CC
CONT              1EE4      FP2A           3193
COS               3BC5      FP2BC          3160
EP_EC             16E8      F_ATTR         28D7
CTRO              37A1      F_INKY         29F2
DATA              1E82      F_PI           29E5
DEF               201D      F_PNT          2624
DELREC            1750      F_SCRN         288E
DELSYM            0B7E      GETAL          17CF
DEL_DE            174D      GET_EL         2D54
DEL_C             0BFD      GET_LN         1324
DESLUG            0D0D      GET_XY         2660
DE_HL             1668      GO_SUB         1F99
```

<!-- PDF page 101 -->

```text
Global            Address   Global        Address
GR_COL            238C      NEXTCH        0074
HIFLSH            241D      NEXT_L        165B
INGH              11E1      NOTKB?        2380
ININT             30F9      NXT_HL        2C69
INIT              0D31      OPCHAN        1465
INPUT             222B      OPEN          142A
INSI              12B8      OPTNO         1C49
INSA              0AE7      OUTPUT        31A1
INSERT            12BB      PAEDCB        2E74
INT               3ACA      PARP          03F3
INTDIV            3ABB      PASSEM        25B9
INPT?             2889      PAUSE         1FEB
IN_K              0C0E      PHLAF         004F
I_SEQ             226B      PLOT          2635
JUMP              1EF1      PLOTBC        263E
K_BASE            035C      PLUGIN        0000
K_CLS             08A6      PGPSTR        2FAF
K_DUMP            0A02      PRSCAN        0A4A
K_LIST            1545      PR_CUR        162D
K_LLST            1541      PR_TV2        0776
K_LPR             2155      PSHSTR        2E70
K_NEW             0D1D      PUT           15C9
K_PRIN            2159      PUTDIG        11EA
K_SCAN            02B0      PUTMES        073F
LCU2              132D      PUT_BC        1788
LDMES             3CA8      PUT_LN        1795
LDTVCU            061A      PUT_SR        15A1
LE3               0055      P_LFT         053A
LED18             0E2F      P_NL          0566
LED4              038D      P_RT          0554
LET               2EBD      P_SEQ         217E
LINNG             1768      RAMNO         377F
LIST              14E1      RAND          1ED4
LN                3B2E      RDCH          11CF
LPO               15AC      READ          1D97
LS4               1A44      RECLEN        1720
LT22              1BBC      REMGSZ        12CA
MOVE              25D0      RESET         1354
MULT              3468      RESTBC        1ECA
NC_HL             0077      RETURN        1FD4
NEGATE            382D      RND           29B6
NEW               0D82      ROOM?         3768
NEWDEV            24D2      ROOT          3C65
NEXT              1D55      RSET          2454
```

<!-- PDF page 102 -->

```text
Global            Address   Global         Address
RSTSTR            13A8      STRITO         220F
R_ATTS            0898      STTVCU         05F3
SCRL              0939      SUB            33CE
SCRMBL            2603      SUBLIN         16F0
SEARCH            136B      SUBLIN1        16F3
SELECT            1230      SUMSLD         3379
SEL_HL            1248      SYNERR         1BED
SENDCH            11ED      SYNTAX         1A27
SENDTV            0500      TAN            3BF5
SEPRMT            3C89      TC_HL          0078
SETCUR            0914      TEM1           1B82
STTVC             0914      TEM10          1BEF
SET_AT            05B2      TEM6           1BE5
SHIFT             339C      TEMP38         19E0
SIN               3BD0      TEMP39         19E1
SKIP              1D28      TERM?          21E7
SKIPIT            2569      TEST0          3904
SLICER            2E10      TIMES          3489
SMINIT            11C1      TOKENS         0098
SOUND             2128      TO_THE         3C6C
SRCHSC            1374      TRUNC          35D3
STBOOL            3926      TVFUL?         0790
STDE_S            314C      TV_COL         23BB
STDE_U            314A      UPD_K          02E1
STKUSN            3059      USRRET         3882
STK_O             1C41      WRCH           0010
STK_A             30E6      XEV            310D
STK_EC            30E9      X_CALC         134E
STK_M             3773      X_T_HL         1363
STOP              1C59
```

<!-- PDF page 103 -->

Extension ROM Map

```text
Module            Origin             Length
XBASIC            0000               0068
TAPE              0068               087F
INIT              08E7               04C9
CHNG_VID          0DB0               0193
PASSING           0F43               0047
BS                0F8A               001E
```

```text
Global            Address
AKEY              08AA
BLDSCT            09F4
CALL_B            0F99
CHNG_V            0E8E
CLDFIL            0E27
EXINIT            08E7
GOTO_B            0F8A
LOAD              05CC
MERGE             06E5
OPDFIL            0DB0
PASSIN            0F43
RD_BIT            0189
RESSCT            0CRC
R_EDGE            018D
R_TAPE            00FC
SAVE              0851
SLVM              01AB
W_BORD            00E5
W_TAPE            0068
```

<!-- PDF page 104 -->

Dispatch table
This module is copied to RAM 6200H (space reserved 6200H-683FH) and relocated to
(FC90H-FFFFH) when the second display file is used

```text
Global               Address
BANK_E               6499
BS_MAX               6315
BS_SP                65CE
CALL_B               65D0
CREATE               66E8
DISPAT               6200
GET_CH               6440
GET_NU               645E
GET_ST               6405
GET_WO               6316
GOTO_B               6572
GOTO_E               6815
INT                  62AE
```
