<!--
  DERIVED FILE — do not treat as authoritative.

  Source: docs/Timex Sinclair 2068 Technical Manual (best).pdf, pages 49-63
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

# 3. System Software Guide

*Timex Sinclair 2068 Technical Reference Manual — pages 49-63.*
*[Full PDF](../Timex%20Sinclair%202068%20Technical%20Manual%20%28best%29.pdf) · [chapter index](README.md)*

---

<!-- PDF page 49 -->

## 3 System Software Guide

### 3.1 Identifier

Location 13 (13H) of the Home Bank ROM is used to identify the revision level of the
System Software. The initial version is identified by this location having a value of 255
(FFH). Any subsequent versions will decrement this value by 1, e.g., the first revision
would be identified by a value of 254 (FEH). This identifier should be used to
conditionally apply patches or execute "workarounds" identified as necessary with a
particular version of the System Software.

### 3.2 ROM Organization and Services

#### 3.2.1 Home ROM Organization and Services

##### 3.2.1.1 Fixed Entry Points

Home ROM Location 0 is the entry to the system initialization code upon power-up (Ref.
Figure 1.1-4). Locations 8 through 48 (8H through 30H) are the Z80 RESTART entry
points for the following functions:

```text
RESTART        FUNCTION
8              ERROR - Error exit from BASIC (Address on Stack points to Error
               Number)
```

15 (0FH)       WRCH - Write Character (Code in A) to Current Output Channel as
established by SELECT (Address of output routine pointed to by System
Variable CURCHL). (See Section 4.0).

24 (18H)       IGN SP - Return in A the current significant character in the Program Line
(Address in System Variable CH ADD) skipping over spaces and- control
characters except End-of-Line (0DH=ENTER)

32 (20H)       NXT_IS - Like IGN SP but returns in A the Next Significant Character.

```text
40 (28H)       CALCTR - Entry to CalculatorRoutines.
48 (30H)       COPYUP - Make room for BC Bytes of temporary workspace just before
               address in System Variable STKBOT by copying up memory between
               there and the address in STKEND, adjusting affected pointers. Returns
               DE=lst Byte of Space; HL=Last.
```

<!-- PDF page 50 -->

Location 56 (38H) is the entry to service the hardware generated interruption which
occurs approximately every l/60 of a second (16.67ms). Z80 Int. Mode 1 is used. This
interruption is used to scan the keyboard (call to routine UPD K - see Section 4.1.1). It is
also used to update the Frame Counter (3 bytes pointed to by the System Variable
FRAMES) used by the RANDOMIZE instruction.

Location 102 (66H) is the entry point for the NMI interruption, but this interruption is not
used in the TS2068 design. (See Section 2.1.3.8 NMI Interruption.)

##### 3.2.1.2 BASIC AROS Support

BASIC Application Cartridges are supported by special code in the Home ROM. A
program line is copied from the cartridge to a buffer in the Home RAM (ARSBUF) and is
then executed from there by the BASIC Interpreter. When a READ command is
executed, the line containing the appropriate DATA statement is also copied from the
cartridge to the RAM. The cartridge memory is enabled only fur search and copy
operations for both program lines and DATA statements, and when executing a USR
function, otherwise the entire Home Bank is enabled while executing in the BASIC
Interpreter. There is no support for User-Defined Functions which insert the expanded
definition parameters directly into the program and then require search of the program
area to find these parameters whenever a function is invoked. See Section 5.1, Cartridge
Software/Hardware, for additional details on BASIC AROS.

#### 3.2.2 Extension ROM

##### 3.2.2.1 Fixed Entry Points

Extension ROM Location 0 contains code to pass control to the initialization code in the
Home ROM. (Figure 1.1-4).

Extension ROM Location 56 (38H) is the interruption fielder. Control is passed to the
System RAM code (See Section 3.3.3) to bank switch to the Home Bank and call the
interruption service routines after which the state of the machine is restored and control
returns to the interrupted process. Figure 3.2.2-l shows the Extension ROM Interruption
Fielder code.

##### 3.2.2.2 General

The balance of the Extension ROM contains thefollowing major components:
- Final Phase of System Initialization (See Figure 1.1-4)
- Cassette tape I/O (see Section 4.2)
- Change Video Mode Service
- OS RAM routines including the Function Dispatcher (copied to RAM at System
Initialization) (see Section 3.3.3)
- Function Dispatcher Jump Table

<!-- PDF page 51 -->

FIGURE 3.2.2-l
Extension ROM Interruption Fielder

```text
LOCATION       OBJECT CODE    SOURCE CODE                   COMMENTS
0038           F5                    PUSH AF                ;Save AF
0039           F3                    DI
003A           3AC25C                LD   A,(VIDMOD)        ;Disable Ints.
003D           A7                    AND A                  ;Test Vidmod
003E           00                    NOP
003F           2804                  JR   Z,CHK3            ;Vidmod=O
0041           Fl                    POP AF                 ;Restore AF
0042           C36EFA                JP   INT7              ;Chunk7 if Vidmod not 0
0045           Fl             CHK3 POP     AF               ;Restore AF
0046           C3AE62         JP     INT3                   ;Chunk 3 if Vidmod = 0
```

##### 3.2.2.3 Video Mode Change Service

The routine CHNG VID takes as input a single byte in Register3 which designates the
desired video mode as shown in Table 3.2.2-1. All non-zero values involve access to the
second display file located at 6000H-7AFFH. When the mode change requires remapping
of the RAM (see Figure 1.1-3), the necessary relocation (BASIC program, machine stack,
OS RAM code, UDG area, etc.) and modifications (system variables, RAM code internal
addresses, stack pointer, etc.) are done by this service. The desired video mode is written
to Port OFFH, Bits O-5, and the System Variable VIDMOD (5CC2H) is updated. The
second display file is cleared to zeros on initial access (for Dual Screen Mode and High
Resolution Graphics Mode, this results in a black screen since 0 yields attributes of black
ink on black paper). If there is not enough free memory to do the necessary remapping,
Error 4, Out of Memory is given.

Access to this service via the Function Dispatcher cannot be made consistently for
various reasons. An Interface Routine is given in Section 3.2.2.4, to be executed from the
Home RAM, which provides access to the Video Mode Change Service as well as other
Extension ROM routines.

See Sections 4.1.2 and 5.2 for discussion of video screen support software. See Section
6.4 for details on known problems and corrections related to the Video Mode Change
Service.

<!-- PDF page 52 -->

TABLE 3.2.2-l
INPUT TO VIDEO MODE CHANGE SERVICE

```text
Value         Video
In A          Mode                   DESCRIPTION
0             Normal                 Primary Display File Only(Close 2nd Display File
                                     if Open)
128 (80H)     Dual Screen            Two Display Files Available. Primary Display File
                                     Active at Screen.
1             Dual Screen            Two Display Files Available. Second Display File
                                     Active at Screen
2             High Resolution        Primary Display File contains data for
              Graphics               256X192 pixels. Second Display File contains 6144
                                     Attribute Bytes, each one controlling 8X1 pixels.
                                     NOTE 1.
```

```text
      64-Column Modes
            Ink   Paper              The two display files are combined to provide
6           Black White              a 64 column X 24 line screen. Even columns are
14 (0EH)    Blue Yellow              derived from data in the Primary Display File and
22 (16H)    Red Cyan                 odd columns from the 2nd Display File. Bits 3-5 of
30 (lEH)    Magenta Green            the mode select the ink color which determines the
38 (26H)   Green Magenta             complementary paper color. The Flash and Bright
46 (2EH)    Cyan Red                 Attributes are fixed at 0; the Border is fixed at the
54 (36H)   Yellow Blue               paper color. NOTE 1.
62 (3EH)    White Black
```

NOTE 1:       The areas of memory normally used for Attribute Bytes are not accessed
by the video hardware in this mode.

##### 3.2.2.4 Extension ROM Interface Routine

The Extension ROM routines W TAPE (Write from RAM to Tape), R-TAPE (Read from
Tape to RAM) (see Section 4.2) and CHNG VID (see Section 3.2.2.2) may be of interest
to the machine code programmer. Because of a conflict with the use of the IX Register,
the tape routines cannot be successfully accessed via the Function Dispatcher. Because
the Change Video Mode Service may involve relocating the OS RAM routines (including
the Function Dispatcher), and for other reasons, it also cannot be consistently accessed
using the Function Dispatcher. Figure 3.2.2-2 gives a sample routine, to be executed from
the Home RAM, which can be used to bank switch to the Extension ROM and call
directly to the desired service. Appendix A contains an Extension ROM Map giving the
addresses of these and other routines.

<!-- PDF page 53 -->

FIGURE 3.2.2-2
EXTENSION ROM INTERFACE ROUTINE

```text
; EXTENSION ROM INTERFACE ROUTINE
R_TAPE       EQU    00FCH        ; READ TAPE ROUTINE
W_TAPE       EQU    0068H        ; WRITE TAPE ROUTINE
CHNG_VID     EQU    0E8EH        ; CHANGE VIDEO MODE ROUTINE
VIDMOD       EQU    5CC2H        ; VIDEO MODE SYSTEM VARIABLE
;
;                                ; CALL READTP WITH REGISTERS SET
                                 ; UP FOR R_TAPE ROUTINE
READTP LD    HL, R_TAPE          ; ADDRESS TO HL
             CALL IFRTN          ; ENABLE EXT./EXECUTE QTN
             JR     EXIT         ; RESTORE HOME BANK AND RETURN
;
WRITETP      LD     HL, W_TAPE   ; ADDRESS TO HL
             CALL IFRTN          ;
             JR     EXIT
;
CHGVID LD    HL, CHG_VID
             PUSH AF             ; SAVE VIDEO MODE
             CALL IFRTN
                                 ; COMPENSATE FOR BUG IN
                                 ; CHNG_VID RTN WHICH SETS
                                 ; VIDMOD = 0 INSTEAD OF 80H
                                 ; WHEN BOTH DISPLAY FILES
                                 ; ARE OPEN
```

```text
             POP      AF            ; TEST VIDEIO MODE
             CP       80H           ; AGAINST 80H
             JR       NZ, EXIT      ;
             LD       (VIDMOD), A   ; SET VIDMOD = 80H
EXIT         LD       A, (HSSAVE)   ; GET PREV HSR
             OUT      (0F4H), A     ; RESTORE
             IN       A, (0FFH)     ; READ PORT 0FFH
             RES      7, A          ; TURN OFF ROM SEL
             OUT      (0FFH), A     ;
             EI                     ;
             RET
```

HSSAVE       DEFB 0                 ; SAVE HOR. SEL. (PORT 0F4H)

```text
IFRTN        DI                     ; MASK INTERRUPTS
             PUSH AF                ; PRESERVE CALLER'S ACCUM
             IN     A, (0FFH)       ; EXT. ROM SELECT BIT
             SET    7, A            ; SEL EXT. ROM
             OUT    (0FFH), A       ;
             IN     A, (0F4H)       ; HSR FOR DOCK/EXT.
             LD     (HSSAV), A      ; SAVE
             LD     A, 1            ; SELECT CHUNK 0 IN EXT. ROM
             OUT    (0F4H), A       ;
             POP    AF              ; RESTORE CALLER'S ACCUM
             JP     (HL)            ; EXECUTE TARGET SUBROUTINE
                                    ; RETURN TO CALLER OF IFRTN
```

<!-- PDF page 54 -->

### 3.3 RAM Organization and Services

#### 3.3.1 System Variables

RAM beginning at 23552 (5COOH) is dedicated to the BASIC System Variables as
defined in Appendix D of the TS 2068 User Manual and in Appendix B of this document.
The area from the end of the defined variables (STRMNM - 23755 (5CCB) ) to 24297
(5EE9H) is reserved for expansion of the System Variables, but is not used by the
Operating System in the current TS 2068.

#### 3.3.2 System Configuration Table

The area from 24298 (5EEAH) to 24575 (5FFFH) is reserved for the System
Configuration Table (SYSCON). This table is built at system initialization time and is
comprised of an 8 byte entry for AROS, a 4 byte entry for LROS, followed by eleven 24-
byte entries for proposed expansion banks and an End-of-Table marker. In the original
TS 2068 the actual usage of this table is limited to the 12 bytes for software cartridge
identification (see Section 5.1 for details of the LROS and AROS Overhead Bytes).

#### 3.3.3 Machine Stack

The TS 2068 reserves 512 (200H) bytes of RAM for the Machine Stack. The Machine
Stack pointer is initialized to a value of 6200H (value also in System Variable
(MSTBOT); the pointer is decremented as items are pushed onto the stack (the pointer
may also be modified directly by software). While the area reserved for the stack extends
to 6000H, there is no actual check made to enforce this limit.

Note: The Machine Stack is located in the same memory area as the second display file.
The CHNG VID routine relocates the stack to the memory area from 0F7C0H to
0F8BFH, and modifies the Stack Pointer and MSTBOT (0F8C0H), as well as
other affected system variables, when initializing the second display file. (See
Section 3.2.2.3.)

#### 3.3.4 OS Ram Routines

The code for the following Operating System functions is copied from the Extension
ROM to Chunk 3 of the RAM at System initialization time. Since this is in the same
memory area as the second display file, this code must be relocated, along with the
machine stack, if the second display file is to be used. The CHNG VID routine does
the necessary relocation and modifications. (Section 3.2.2.3.)

Because this code is not in a fixed location, access to the OS RAM routines is conditional
on the current video mode. The standard technique employed is to test the value in the
System Variable VIDMOD at location 23746 (5CC2H). A zero indicates that the second
display file is not in use and that the OS RAM routines are therefore in Chunk 3; any
non-zero value indicates that the routines are in Chunk 7.

NOTE:          This design implies that Chunks 2, 3 and 7 are always enabled in the
Home Bank RAM whenever the System ROM and/or RAM routines are
being used.

<!-- PDF page 55 -->

The OS RAM routines are contained in Module "Dispatch" which is included in
Appendix A.

##### 3.3.4.1 RAM Interruption Handler

Chunk 3 Entry:        62AEH

Chunk 7 Entry:        FA6EH

The user must enter with bank status and Z80 registers intact, with address from point of
interruption on the stack. The RAM interruption handler saves state, including memory
selection, enables the Home Bank, updates the Frame Counter, calls the keyboard scan
routine in the Home ROM, restores state, and returns to the interrupted process. The
RAM Interruption handler is used whenever the interruption occurs while the Extension
ROM is enabled, See Figure 3.2.2-1, Extension ROM Interruption Fielder. This same
technique can he used for interruption processing in another bank, e.g. if an LROS
wanted to use the standard system ROM keyboard scanning routines.

##### 3.3.4.2 RAM Service Routines

Table 3.3.4-l lists the RAM service routines which are designed to facilitate
communication between memory banks. Those with Service Codes are accessible via the
Function Dispatcher.

Label            Service      Location (Hex)                  Description
Code       1 Disp    2 Disp
(Decimal)     File      Files
GET_WORD                           6316       FAD6       Returns in HL the word from the
address in HL in the bank specified in
B.
PUT_WORD                           6336       FAFB       Writes the word in DE to the address
in HL in the bank specified in B.
GET_STATUS             14          6405       FBC5       Returns current memory selection
(Horizontal Select byte - low active) in
C for the bank specified in B.
Preserves Bank # in B for Home, Ext.
or Dock.
GET_CHUNK                          644D       FC0D       Returns a single byte mask in A with
all bits 0 except the one corresponding
to the chunk for the address in HL.
GET_NUMBER             15          645E       FClE       Returns in Reg. A the bank number
currently controlling the address
in HL .
BANK_ENABLE                        6499       FC59       Enables the memory selected
(Horizontal Select byte - low active) in
the specified bank. (Bank # in B;
Mem.Sel.in C)

<!-- PDF page 56 -->

Label              Service        Location (Hex)                     Description
Code         1 Disp    2 Disp
(Decimal)       File      Files
GOTO_BANK                               6572         F032        Transfers control to the specified
address after enabling the memory
selected in the specified bank.
Parameters passed on stack by pushing
target address, then Bank
#/Mem.Select prior to calling GOT0
BANK. (Return address is discarded).
CALL_BANK                               65D0         FD90        Like GOTO BANK except saves
current bankstatus, calls target
address, and restores status prior to
returning to user. Two additional
parameters are passed on stack prior to
doing call to CALL BANK. These are
PRM OUT (16-bits) following by
PRM_IN (16 bits) as described for the
function dispatcher
XFER_BYTES                              6722         FEE2        Copies n byte(s) from specified source
to specified destination in either
ascending or descending order. Source
and destination can be in the same or
different banks and can be in
shadowing chunks, but neither source
nor destination can pass a "chunk"
(8K) boundary since only the chunks
containing the starting source and
destination addresses are explicitly
enabled.

Parameters passed on stack by
pushing:
Source Bank/Dest.Bank
Source Address
Dest. Address
Length
Direction:
0 = Ascending
1 = Descending)
NOTE: See Appendix A for listing of these routines. See Section 6.0 for known corrections to the
routines.

<!-- PDF page 57 -->

##### 3.3.4.3 Function Dispatcher

Chunk 3 Entry: 6200H

Chunk 7 Entry: F9C0H

The Function Dispatcher provides, a common interface to a number of system routines
via a Service Code and Jump Flag parameter passed on the machine stack. Table 3.3.4-2
lists the routines in Service Code order. Codes for routines that are known to not be
successfully accessible via the Function Dispatcher have been deleted (marked
Reserved). However, there is no guarantee that those on the list can be accessed without
problems. Some ROM routines require data in a particular format, e.g. BASIC floating
point number(s), both standard and special integer format, on the Calculator Stack which
is located between (STKBOT) and (STKEND) (see Appendix C of the TS 2068 User
Manual). An effort has been made to include information on register usage and
functionality, but some of the ROM routines are so tightly tied to the BASIC Interpreter
that they would require analysis which is beyond the scope of this document. These have
been flagged with an Asterisk, but included in the list for documentation purposes only.
Most of the routines which are directly implementing a BASIC command or function
have two different action sequences based on the INTPT Flag (Bit 7 of FLAGS) which
distinguishes syntax checking (Flag=0) from actual execution (Flag=l).

In order to use the Function Dispatcher, first set up any memory and stack (both machine
and/or calculator) locations as if invoking the desired service directly. Then push the
parameter(s) for the Dispatcher on the machine stack in the order outlined below. Finally,
set up the registers as if invoking the desired service directly and call the Dispatcher
based on its current location (Chunk 3 if VIDMOD=0 or Chunk 7 if VIDMOD has a non-
zero value).

1.        PRM OUT      16 bits - Number of bytes of parameter data being passed
on the stack to the specified Service (number of stack
"pushes" * 2). Zero if no parameters being passed. E.g., to
pass 4 bytes:
LD HL,4
PUSH HL
This parameter is passed to the Dispatcher only if the Jump
Flag (SVC CODE) Bit 15) is not set. NOTE: This
parameter refers to machine stack entries only, not to the
Calculator Stack.

2.      PRM IN         16 bits - Number of bytes of parameter data to be passed
back from the specified Service (number of stack "pushes"
* 2). Zero if no parameters to be passed back. This
parameter is passed to the Dispatcher only if the Jump Flag
(SVC CODE Bit 15) is not set.

<!-- PDF page 58 -->

NOTE: This parameter-refers to machine stack entries only,
not to the Calculator Stack.

```text
3.       SVC_CODE 16 bits - Bits O-14 identify the Service to be
                  invoked. Bit 15 (Jump Flag) is set if no return is desired
                  (jump to Service rather than call). Bit 15 is zero if return is
                  desired. E.g, to call K SCAN using Service Code 136:
                          LD HL,136 or           LD HL,88H
                          PUSH HL                PUSH HL
```

Addendum To TS 2068 Function Dispatcher Services:
On page 84, COLOR and HIFLSH (service codes 85 and 86) cannot always be accessed through the
Function Dispatcher, due to resetting of the carry flag by the FD. COLOR may be accessed by setting the
registers as described in the manual, and then coding CALL #23DE. HIFLSH can be accessed similarly by
coding CALL #2410.

```text
                                      TABLE 3.3.4-2
                            TS 2068 Function Dispatcher Services
   Service          Service                          Description
                     Code
                  1-13           Reserved
                  01H-0DH
GET STATUS        14 (0EH)       Returns Memory Selection (Low Active) in C for Bank # in B
GET NUMBER        15 (0FH)       Returns Bank # in A for Address in HL
                  16-24          Reserved
                  (10-18H)
UPD K             25 (19H)       Process Keyboard Input (See Section 4.1 . 1 )
PARP              26 (1AH)       Generates DE+1 Cycles of a Tone having the Period 8N+236 to 8N+246
                                 T-States. HL=N. (See 4.4)
BEEP              27 (1BH)       BEEP Command - processes parameters on Calculator Stack.
                                 Exits via PARP. (See 4.4)
K_DUMP            28 (1CH)       COPY Command. Dumps Primary Display File to Printer. (See 4.1.3)
SENDTV            29 (1DH)       Char. Output to Screen/Printer. Character Code in A. (See 4.1.2)
SETAT             30 (1EH)       Set Print Position to value in BC. C = Line # (0-23); C=Column # (0-31)
ATTBYT            31 (1FH)       Set Attribute Byte for Display File Address in HL using ATTR_T,
                                 MASK_T and P-FLAG.
R_ATTS            32 (20H)       Permanent Attribute Info. to Temporary Attribute Variables
CLLHS             33 (21H)       Clear Lower Screen (Primary Display File)
CLS               34 (22H)       Clear Entire Screen(Primary Display File)
DUMPPR            35 (23H)       Print/Clear Print Buffer. (See 4.1.3)
PRSCAN            36 (24H)       Send scan line (32 bytes to printer)
                                 Pixel address in HL
                                 Number of scans remaining in B (1-8)
                                  (See 4.1.3)
DESLUG            37 (25H)       Remove Number Slugs from Edit Line Buffer (Address in HL)
K_NEW             38 (26H)       NEW command. See Fig. 1.1-4
INIT              39 (27H)       Initialize: DE=Maximum RAM
                                 Address. A=0 for Power-On; = -1
                                 (FFH) for NEW. (See Fig.l.l-4)
```

<!-- PDF page 59 -->

TABLE 3.3.4-2
TS 2068 Function Dispatcher Services
Service         Service                          Description
Code
INCH             40 (28H)   Input Character to A from currently Selected Channel. Returns NC if no
input.
SELECT           41 (29H)   Select Channel (Stream) - # in A. (See 4.1)
INSERT           42 (2AH)   Insert BC Bytes before byte whose address is in HL. Copies up all from
HL to (STKEND) and updates affected system variables.
Returns BC = 0; DE = address of last byte of inserted space;
HL = address of byte before first.
RESET            43 (2BH)   Reset Calculator Stack. Sets (STKEND) =(STKBOT)
(MEM)=MEMBOT (5C92H).
CLOSE            44 (2CH)   CLOSE # Command. Channel # on Calculator Stack.
(See 4.1 for more info. on OPEN and CLOSE)
CLCHAN           45 (2DH)   Close Channel. BC=Value from STRMS (Index into CHANS).
OPEN             46 (2EH)   OPEN # Command. Channel # and Device Spec. on Calculator Stack
OPCHAN           47 (2FH)   Open Channel. Device Spec. on Calculator Stack. DE=pointer
into STRMS based on Ch.#.
(See 4.1 for more info. on OPEN and CLOSE)
CAT              48 (30H)   CAT Command (Not Applicable)
ERASE            49 (31H)   ERASE Comnand (Not Applicable)
FORMAT           50 (32H)   FORMAT Command (Not Applicable)
MOVE             51 (33H)   MOVE Command (Not Applicable)
FLASHA           52 (34H)   Flash Char.in A to Screen. (Calls SENDTV; assumes Lower Screen
selected. Used to Flash Cursor.)
FIND_L           53 (35H)   Find BASIC Program Line with the number in HL. If Line found,
returns Z and Address of Line in HL, else returns NZ and HL
contains either address of line with next larger line number or
points to the Variables area if there is no larger line number.
Requested Line No. returned in BC and Address of Preceding Line in
DE (DE=HL if no preceding line).
SUBL_IN          54 (36H)   Finds either the D'th statement (D=Statement #; E=0) or 1st
statement whose keyword token matches E (D=0), in a line
pointed to by HL. If the D'th statement is found, returns Z and
HL and (CH ADD) both point to 1 byte before-statement. (If line
contains exactly D-l statements, then the next line counts as the
D'th.). If match on E is found, then returns NZ,NC and both HL
and (CH ADD) point to keyword. D is decremented by the number of
statements looked at (e.g. D= -2 if two statements). If no match on E
then returns NZ,C with both HL and (CH ADD) pointing to End-of-Line
byte (0DH).
RECLEN           55 (37H)   Returns in BC the lenqth of the record pointed to by HL. Sets DE to
HL+BC. The record can be a program line, or a string or numeric
variable or array.
DELREC           56 (38H)   Delete record pointed to by HL having length BC from Program or
Variables memory. Updates affected system variables.
PUT_BC           57 (39H)   Converts number in BC from binary to ASCII and outputs to currently
selected channel, If BC less than 0, outputs a 0.
SYNTAX           58 (3AH)   Check syntax of command or program line in Edit Line Buffer
(E_LINE). ERR NR= -1 if no errors, otherwise contains Error Number-
l.
EXCUTE           59 (3BH)   Execute command(s) from Edit Line buffer.
FOR              60 (3CH)   FOR command. *

<!-- PDF page 60 -->

TABLE 3.3.4-2
TS 2068 Function Dispatcher Services
Service         Service                          Description
Code
STOP             61 (3DH)   STOP command. Does RESTART 8 with Error No. 9.
NEXT             62 (3EH)   NEXT command. *
READ             63 (3FH)   READ command. *
DATA             64 (40H)   DATA statement. *
RESTBC           65 (41H)   RESTORE command - Line No. in BC
RAND             66 (42H)   RANDomize command. Sets seed for Random Number Generator based
on Parameter on Calculator Stack. If parameter is non-zero, value is
loaded to SEED; if zero, value in FRAMES is loaded to SEED.
CONT             67 (43H)   CONT command. Loads values from OLDPPC and OSPPC to EWPPC
and NSPPC and returns. Inside the BASIC Interpreter, this results in
executing from Line No. in NEWPPC, Statement No. in NSPPC.
JUMP             68 (44H)   Jump to Line - Loads Line Number from Calculator Stack to NEWPPC
and sets NSPPC to 0 and returns.
FIX_U1           69 (45H)   Converts Floating Point number on Calculator Stack to a single byte
unsigned binary value in A (uses FP2A). Does RESTART 8 for Error
B if number out of range.
FIX_U            70 (46H)   Converts Floating Point number on Calculator Stack to a 2-byte
unsigned binary value in BC (uses FP2BC). Error B if number out of
range.
CLEAR            71 (47H)   CLEAR command. Processes parameter on Calculator Stack to value in
BC for CLR BC.
CLR_BC           72 (48H)   Value in BC is new RAMTOP. Deletes Variables, clears screen, and
Calculator Stack, etc.
GO_SUB           73 (49H)   GO SUB command. Inserts a 3-byte GO-SUB Block into the machine
stack above the 2 most recent entries. The Block consists of current Line
No. (2 bytes) and Statement No. (1 byte) to be used when RETURN is
executed. Then calls JUMP to process GO SUB parameter and returns.
At return to caller, machine stack consists of top of stack at point GO
SUB was called, followed by 3-byte entry (Line No. MSB/Line No.
LSB/Statement No.).
CHK_SZ           74 (4AH)   Checks if room for BC 80 (50H) bytes between (STK;ND) and
(RAMTOP). Addition of 80 bytes is "left-over" from Spectrum to
guarantee minimum machine stack where the stack was at the top of
RAM. Error 4 if not enough room.
RETURN           75 (4BH)   RETURN command. Retrieves most recent GO SUB Block from
Machine Stack (SP+4), loads data to NEWPPC and NSPPC and returns.
Error 7 if MSB Line No.=3EH (End of Stack Marker).
PAUSE            76 (4CH)   PAUSE command. Processes parameter on Calculator Stack to BC then
waits BC frames or until key is depressed. (Uses HALT instruction, so
interruptions must be enabled)
BREAK?           77 (4DH)   Reads BREAK key. Returns NC if it is pressed and ON ERROR is not
active.
DEF              78 (4EH)   Define Function.*
K_LPR            79 (4FH)   LPRINT - Selects Channel 3 and processes items in LPRINT statement
for output via WRCH.
K_PRIN           80 (50H)   PRINT - Selects Channel 2 and processes items in PRINT statement for
output via WRCH (same code used for K_LPR).
P_SEQ            81 (51H)   Code used by K LPR and K PRIN to process output-data and controls in
BASIC statement (address in CH ADD).

<!-- PDF page 61 -->

TABLE 3.3.4-2
TS 2068 Function Dispatcher Services
Service         Service                          Description
Code
INPUT            82 (52H)    INPUT command. Selects Channel 1 and processes I/O for
Keyboard/Lower Screen using a buffer at (WORKSP) for input. *
I_SEQ            83 (53H)    Code used by INPUT to process input items and controls in BASIC
statement (address in CH ADD).
NOTKB?           84 (54H)    Returns Z if current channel is Keyboard/Lower Screen (device
specification="K").
COLOR            85 (55H)    Adjusts system variables ATTR T, MASK T and P FLAG for color code
in D (0-9). Enter with C set to set Ink or NC set to set Paper. Error K if
D is invalid.
HIFLSH           86 (56H)    Adjusts system variables (ATTR T and MASK T) for Flash/Bright code
in D (0, 1 or 8) else Error K. Enter with C for Flash or NC for
Bright.
SCRMBL           87 (57H)    Returns in HL the primary display file address for the pixel with
coordinates in BC (B=Y;C=X). Returns in A the bit no (0-7) where
0=lefthand or most significant bit. Error B if Y is greater than 175.
PLOT             88 (58H)    PLOT command. Processes X/Y parameters on the Calculator Stack to
BC for plotting of pixel via PLOTBC.
PLOTBC           89 (59H)    Deals with pixel for coordinates in BC (B=Y; C=X). Processes using P
FLAG for Inverse and Over attributes. Updates Attribute File and sets
COORDS=BC.
GET_XY           90 (5AH)    Converts a pair of numbers from the Calculator Stack to 2 single byte
numbers. Top number goes to B and second to C. D=sign of B and
E=sign of C (+l or -1). Used by PLOT and other routines.
CIRCLE           91 (5BH)    CIRCLE command. Calculates successive plot positions from the
parameters in the BASIC statement. *
DRAW             92 (5CH)    DRAW command. Calculates successive plot positions from the
parameters in the BASIC statement. *
DRAW_L           93 (5DH)    Plots a straight line from current position (COORDS) based on
parameters from Calculator Stack (X,Y). *
EXPRN            94 (5EH)    Evaluates expression in BASIC program line (CH ADD), putting value
on Calculator Stack. *
F_SCRN           95 (5FH)    SCREEN$ function. Matches screen line/col. position (parameters on
Calculator Stack) against standard ASCII character set. Returns BC=0 if
no find. BC=l and DE points to Char. Code byte if match found.
F_ATTR           96 (60H)    ATTR function. Returns attribute byte value controlling screen pixel
position based on parameters on Calculator Stack (X,Y).
RND              97 (61H)    RND function. Uses value in SEED to generate a pseudo-random
number which is placed on the Calculator Stack (Floating Point
number).
F_PI             98 (62H)    PI function. Places value of PI on Calculator Stack.
F_INKY           99 (63H)    INKEY$ function. Scans keyboard and puts character code byte in
(WORKSP) if key detected. In any case, pushes Regs. AEDCB onto
Calculator Stack - BC=0 if no input; =l if char. code stored; DE=address
of char. code byte.
FIND_N           100 (64H)   Find Variable. Searches Variables area for match against identifier
pointed to by CH ADD. Adjusts bit NO of FLAGS (Bit 6) for type
(l=numeric; 0=string). Also used to find formal parameters for User
Defined Functions. *

<!-- PDF page 62 -->

TABLE 3.3.4-2
TS 2068 Function Dispatcher Services
Service           Service                          Description
Code
PSHSTR          101 (65H)      Push String - Clears bit NO of FLAGS and pushes Regs. AEDCB onto
Calculator Stack adjusting (STKNXT) upwards. DE contains address of
string; BC contains length.
PAEDCB        102 (66H)        Same code as for PSHSTR but preserves state of bit NO of FLAGS (Bit
6).
LET              103 (67H)        LET command. Processes existing or creates new variables. *
POPSTR           104 (68H)        Pop String - Pops end of Calculator Stack ( (STKNXT)-1 through
(STKNXT)-5 ) to Regs. BCDEA, adjusting (STKNXT) downwards.
DIM              105 (69H)        DIM statement. Creates or initializes numeric or string arrays. *
STKUSN           106 (6AH)        Stack Unsigned Number - inputs a floating point number onto the
Calculator Stack from a series of ASCII characters addressed by
(CH_ADD). The first character is already in Reg. A (either decimal
point, binary token or digit).
STK_A            107 (6BH)        l-byte unsigned integer in A to top of Calculator Stack (binary to
floating point). Loads 0 to B and A to C, then executes STK BC.
STK_BC           108 (6CH)        2-byte unsigned integer in BC to top of Calculator Stack (binary
to floating point).
ININT            109 (6DH)        Converts a series of ASCII digits pointed to by (CH ADD) into an
unsigned floating point integer on the Calculator Stack. First
character is in A on entry. Terminates when non-digit found.
FP2BC            110 (6EH)        Pops top of Calculator Stack (floating point number) and puts in BC,
rounded to nearest integer. Returns NZ if value is negative. Returns C if
number exceeded maximum 2-byte value (65535).
Range: -65535 to +65535.
FP2A             111 (6FH)        Pops top of Calculator Stack (floating point number) and puts in A,
rounded to nearest integer. Returns NZ if value is negative. Returns C if
number exceeded maximum l-byte value (255). Range: -255 to +255.
OUTPUT           112 (70H)        outputs number on top of Calculator Stack to currently selected channel
via WRCH. (Converts from floating point to ASCII.)
Full explanation of the following Calculator Routines is beyond the scope of this document.
SUB              113 (71H)        Subtract floating point format numbers (HL) minus (DE). (DE) assumed
to be (HL) + 5
ADD              114 (72H)        Add (HL) + (DE). See SUB.
MULT             115 (73H)        Integer multiply HL * DE. Returns C if overflow.
TIMES            116 (74H)        Floating Point Multiply (HL) * (DE).
DIVIDE           117 (75H)        Floating Point Divide (HL)/(DE).
TRUNC            118 (76H)        Truncates a floating point number (HL) towards zero to an integer.
Assumes (DE) = (HL) + 5.
FLOAT            119 (77H)        Converts number (HL) to floating point format. Assumes HL points
to an integer in 5-byte format.
INTDIV           120 (78H)        Replaces top two numbers on Calculator Stack (X and Y) by X
Mod Y and the integer quotient INT (X/Y). Returns with DE and
HL = Calc.Stack Pointers.
INT              121 (79H)        Replaces the top of the Calculator Stack by its integer
part. Returns with HL = top of Calc. Stack and DE = next free space.
EXP              122 (7AH)        Replaces the top of the Calculator Stack, X, by EXP(X).
Returns with DE and HL = Calc. Stack Pointers.
LN               123 (7BH)        Replaces the top of the Calculator Stack by its natural logarithm.
Returns DE and HL = Calc. Stack Pointers.

<!-- PDF page 63 -->

```text
                                    TABLE 3.3.4-2
                          TS 2068 Function Dispatcher Services
  Service         Service                          Description
                   Code
ANGLE            124 (7CH)   Replaces the top of the Calculator Stack (X) by Y where Y is greater
                             than or equal to -1 and less than or equal to +l and the
                             SIN X = SIN (PI/2 * Y).
COS              125 (7DH)   Replaces the top of the calculator stack by its COSINE
SIN              126 (7EH)   Replaces the top of the Calculator Stack by its SINE.
TAN              127 (7FH)   Replaces the top of the Calculator Stack by its TANGENT.
ATN              128 (80H)   Replaces the top of the Calculator Stack by its inverse TANGENT.
ASN              129 (81H)   Replaces the top of the Calculator Stack by its inverse SINE.
ACS              130 (82H)   Replaces the top of the Calculator Stack by its inverse COSINE.
ROOT             131 (83H)   Replaces the top of the Calculator Stack by its Square Root.
TO_THE           132 (84H)   Replaces the top two numbers on the Calculator Stack (X, Y) by x**y.
                                  End of floating point routines
RDCH             133 (85H)   Wait for character from currently selected channel (calls INCH).
                             Returns character code in A. See 4.1.1.
SENDCH           134 (86H)   Write character whose code is in A to currently selected output channel.
                             See 4.1.2.
WRCH             135 (87H)   See 3.2.1.1, RESTART 16.
K_SCAN           136 (88H)   Keyboard Scan. See 4.1.1
P_LFT            137 (89H)   Backspace. Sets current column position back 1 for selected device.
                             (System Variable updated is S POSN, SPOSNL, or P POSN for Screen,
                             Lower Screen or Printer respectively.)
P_RT             138 (8AH)   Outputs a space to currently selected device.
P_NL             139 (8BH)   End-of-Line. Sets current position to start of next line if screen, or
                             outputs printer buffer if printer.
PUTMES           140 (8CH)   output message to currently selected device. DE points to base of
                             message table which contains variable length ASCII coded messages.
                             The first byte of the table and the last byte of each message must have
                             the most significant bit set. Register A contains the message number,
                             numbered from 0 upwards.
K_CLS            141 (8DH)   CLS command. Executes both CLS and CLLHS.
SCRL             142 (8EH)   Scrolls entire screen (primary display file) up 1 line.
F_PNT            143 (8FH)   POINT function. Processes X,Y parameters from Calculator Stack to
                             BC. Returns unsigned integer value = 0 or 1 on Calculator Stack
                             reflecting state of pixel at coordinates X/Y.
DRAWLN           144 (90H)   Same as DRAW L but enter with BC register containing coordinates,
                             B=Y and C=X.
PUT_LN           145 (91H)   Output Line Number as 4 digits, right aligned and space filled to
                             currently selected output channel. HL points to MSB of Z-byte Line
                             Number.
```
