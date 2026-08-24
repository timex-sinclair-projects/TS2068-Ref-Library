<!--
  DERIVED FILE — do not treat as authoritative.

  Source: docs/Timex Sinclair 2068 Technical Manual (best).pdf, pages 64-74
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

# 4. System I/O Guide

*Timex Sinclair 2068 Technical Reference Manual — pages 64-74.*
*[Full PDF](../Timex%20Sinclair%202068%20Technical%20Manual%20%28best%29.pdf) · [chapter index](README.md)*

---

<!-- PDF page 64 -->

## 4 System I/O Guide

### 4.1 I/O Channels

The TS 2068 software architecture supports up to 19 I/O Channels or "Streams',
numbered from -3 through 15. Those numbered less than 0 are "hidden" or reserved for
system use; Channels 0 through 15 are available for assignment via the OPEN #
command which has the following format:

OPEN # n,s

where n is the Channel number (O-15) and s is the Device Specification, e.g. "K"
(keyboard), "S" (screen) or "P" (printer).

Channels 0 through 3 are initialized at power-on or execution of a NEW command to
support the standard system devices and character I/O functions as shown in Figure 4.1-1.
Channels 4-15 are considered "Closed". You can re-assign the standard I/O, e.g. OPEN #
2,"P" will direct all PRINT and LIST commands to the 2040 Printer instead of the screen.
You can also assign Channels 4-15 and then direct I/O by including the Channel number
(or a variable equated to the channel number) in the I/O statement, e.g. PRINT # Above
Support for other than the standard system devices described is not implemented in the
original version of the TS 2068 and attempts to OPEN Channels or "Streams" using other
than the standard device specifications ("K", "S" or "P") will result in an error message.
One possibility for adding BASIC support for new devices is to intercept the I/O error on
OPEN and other commands such as CAT and FORMAT via ON ERR and interpret the
BASIC program line using your own machine code routines.

```text
                                     Figure 4.1-1
 Channel/         Status           Device                   Command/Function
 Stream #                        Specification
-3          Reserved for OS   "K"                   Keyboard/Lower Screen
-2          Reserved for OS   "S"                   Main Screen
-1          Reserved for OS   "R"                   RAM Write (not used)
0           User available    "K"                   Output to Lower Screen
1           User available    "K"                   INPUT command
2           User available    "S"                   PRINT/LIST commands
3           User available    "P"                   LPRINT/LLIST commands
```

<!-- PDF page 65 -->

The Channel architecture is implemented by a number of tables located in both ROM and
RAM.

A. STRMS       STRMS is a 38 byte table (2 bytes for each of the 19 channels)
located in the System Variables area beginning at 23568 (5C10H).
It is initialized at power-on or NEW to the following values:

```text
Location     Value       Channel                 Notes
 5C10H       0100       Channel -3      Copied from SMINIT in
 5C12H       0600       Channel -2     module EDIT of the Home
 5C14H       0600       Channel -1               ROM
 5C16H       0100       Channel 0
 5C18H       0100       Channel 1
5C1AH        0600       Channel 2
5C1CH        1000       Channel 3
5C1EH        0000       Channel 4
  ***         ***          ***            Remaining streams
 5C34H       0000       Channel 15
```

This table is accessed using ((Ch.# * 2) + 16H) as an index added to 5C00H. The 2-byte
value in the table is an index into the CHANS area of memory which contains the
addresses of the I/O routines for the selected channel. If the 2-byte value is zero, the
Channel is closed. The STRMS table is modified via the OPEN # and CLOSE #
commands. When a Channel is OPENed, the device specification is used to obtain the 2-
byte value to be inserted. This value is taken from the table STRMINIT in module EDIT
of the Home ROM. When Channels 0 through 3 are CLOSEed, the values are restored to
those used at power-on time. All others are cleared to zero.

B. CHANS The CHANS System Variable at 23631 (5C4FH) contains the address of a
21-byte table initialized at power-on or execution of a NEW command to support
"stream" I/O to the four standard system devices ("K", "S", "R" and "P"). Each table
entry is 5 bytes long and is indexed by the value obtained from the STRMS table added
to (CHANS)-1. Each entry has the following format:

```text
Output Routine Address        2 Bytes
Input Routine Address         2 Bytes
Device Specification          1 Byte
```

This table is copied from CHINIT in module EDIT of the Home ROM. The last byte of
the table contains an 80H which will immediately precede the first line of the BASIC
Program (PROG). Whenever an I/O operation is performed, the appropriate Channel is
"selected", i.e. its number is used as an index into STRMS to obtain the offset into the
CHANS table. This offset is added to (CHANS)-1 and the resultant pointer is loaded into
the System Variable CURCHL for use by the next character I/O operation
(WRCH/RDCH). The device specification from CHANS is used to find and execute the
initialization routine in SELTAB.

<!-- PDF page 66 -->

C. SELTAB     The Select Table is located in the EDIT module of the Home ROM and
contains offsets to device dependent initialization routines for
the standard devices "K", "S" and "P".

D. SPEC_T     The Specification Table is located in the CHANS module of the Home
ROM and contains offsets to device dependent OPEN routines for the
standard devices "K", "S" and "P". It is accessed whenever an OPEN # is
executed.

E. CL_TAB     The Close Table is located in the CHANS module of the Home ROM and
contains offsets to device dependent CLOSE routines for the standard
system devices "K", "S" and "P". It is accessed whenever a CLOSE # is
executed.

The following sections describe the standard system I/O devices supported via Channel
I/O.

#### 4.1.1 Keyboard

The low-level routines supporting keyboard input are executed every l/60 of a second out
of the Interruption Handler (Location 56 (38H)). The controlling routine is labelled UPD
K. This routine calls K SCAN to determine if any key(s) are currently being depressed,
controls the debouncing and repeat algorithms, calls K BASE to determine the Base
Code, calls CHCODE to translate the Base Code based on Mode (e.g. "K", "G" or "E"
Mode), and finally, stores the resultant keystroke code in LAST K and sets the flag
KEYHIT. Figure 4.1.1-l illustrates the mode control variable and associated flags and
Figure 4.1.1-2 contains flowcharts of the keyboard support routines.

The character input routine associated with Device Spec. "K" is labeled IN K. The entry
address is obtained using the pointer in CURCHL when Channel 1 has been Selected and
the Character I/O Input routines RDCH/INCH are executed. The IN K routine tests the
KEYHIT flag to detect the presence of input from the keyboard. When the KEYHIT
flag=l, the contents of LAST K are returned to the requestor.

<!-- PDF page 67 -->

> **Missing figure.** Figure 4.1.1-2, the keyboard support routine flowcharts, is **missing from this edition of the manual**. Page 67 of the PDF contains only the placeholder text "Keyboard flowcharts here".

Keyboard flowcharts here

<!-- PDF page 68 -->

#### 4.1.2 Video Screen

The TS 2068 system software supports I/O in the primary display file only. See Section
2.1.10 for the display file organization. The screen, which is 32 columns X 24 lines, is
partitioned into two parts, the main or upper screen (22 lines1 and the lower screen (2
lines). The lower portion of the screen is used for output of system messages and to echo
input from the keyboard of BASIC commands, BASIC program lines, or data. The lower
screen expands as needed for multi-line input, scrolling the entire screen upwards. The
variable DF SZ reflects the number of lines in the lower screen (default=2).

Character output to the screen is done using the Channel I/O described in Section 4.1
using device specification "K" for the lower screen and "S" for the upper screen. Each
character is defined by an 8 X 8 group of pixels. The 8 bytes needed for each of the 133
characters supported by the TS 2068 are located as shown in Figure 4.1.2-1. Note that by
constructing your own pixel data and placing (base address-100H) into CHARS, you can
define your own character set.

Associated with each character position is an Attribute Byte controlling the background
(PAPER) color, the foreground (INK) color, the intensity (BRIGHT), and whether the
position is constant or alternates between true and inverse video (FLASH). Two other
"attributes", OVER and INVERSE, are implemented by software at the time the
character(s) are placed into the display file.

```text
                                            Figure 4.1.2-1
                                  TS2068 Standard Character Tables
Character Set      Nr Chars        Char         Location
                                   Codes
Standard           96              32-127       Home ROM (3D00-3FFFH)
                                   (20-7FH)     (Address-100H in CHARS)
Std. Graphics      16              128-143      Dynamically Generated by Software
                                   (80-8FH)
User Defined       21              144-164      Home RAM (Address in UDG)
Graphics                           (90-A4H)
```

The screen output routine, SENDTV, is in Module IO 1 of the Home ROM. This routine
is used for output to-both the screen (upper and lower) and the dot matrix printer. The
following sequence illustrates the major operations involved in executing a PRINT "A"
statement:
1.      Channel 2 is Selected (normal assignment assumed)

loads CURCHL with pointer into CHANS area for Channel 2 (first 2 bytes are
address of Output Routine - SENDTV).

clears printer and lower screen flags

sets ATTR T to values based on ATTR_P (current "permanent'"*attribute values
are transferred to the system variable used by the screen output routine). If the

<!-- PDF page 69 -->

PRINT statement contained temporary attribute controls, they would override the
settings established via Select.

2.     The character code for "A" (65/41H) is placed in Register A and a RESTART 16
(10H) is executed (WRCH). This jumps to SENDCH in module EDIT of the
Home ROM which passes control to the SENDTV routine based on (CURCHL).

3.     The registers are loaded from the System Variables with the current Row/Column
position (S_POSN) and Display File address (DF_CC) for the main screen.

4.     The character code is determined to be from the standard character set so the
registers are loaded with the address from CHARS and the offset to the pixel
pattern for "A" is calculated using the character code X 8 (shift left 3 places).

5.     The first pixel row (8X1) from the character table is copied to the display file. The
character table address is incremented by 1 and the display file address is
incremented by 256 (100H). The next pixel row (8X1) is copied to the display
file. This process is repeated until the 8 pixel rows have been copied. Masking of
the data going into the display file is done based on the flags from P_FLAG thus
controlling the OVER and INVERSE attributes.

6.     The attribute. byte controlling the character position just written is updated based
on the value in ATTR_T and other flags.

7.     The variables S POSN and DF CC are updated to reflect the nexfscreen position
and return is made from the WRCH operation.

In the above sequence, if the print position for the "A" had started a new line following
the 22 lines of the main screen, the SCROLL? prompt would have been outputted to the
lower screen and, assuming a positive response, the upper screen would be scrolled up 1
line, a blank line inserted at the bottom of the upper screen, and the "A" printed at the
start of the new line.

Graphics I/O using pixel coordinates is supported in the primary display file by the
PLOT, DRAW and CIRCLE commands. The Home R O M module GRAPHS contains
the major routines which implement these commands. They are limited to the 22 lines of
the upper screen (256 X 176 pixels).

Figure 4.1.2-2 shows the internal representation used to designate row (line) and column
positions. See Section 2.1.10 for details on the organization of the Display Pixel and
Attribute Files. See Section 5.2 for details on software support necessary for the
advanced video modes.

<!-- PDF page 70 -->

> **Missing figure.** Figure 4.1.2-2 is **missing from this edition of the manual**. Page 70 of the PDF contains only the placeholder text "FIGURE 4.1.2-2 Here".

FIGURE 4.1.2-2
Here

<!-- PDF page 71 -->

#### 4.1.3 2040 Dot Matrix Printer

Character output to the 2040 Printer is handled by the same routine used for the screen,
SENDTV. When the Printer Flag=l, set by initialization for device "P", the pixel data is
written into the Print Buffer instead of into the Display File. There is no Attribute Byte.
The "attributes" OVER and INVERSE which are software controlled can be active. Since
the Print Buffer is always precleared to zeros, OVER has no effect. INVERSE works
exactly as it does for the screen, i.e. INK pixels are zero and PAPER pixels are 1.

The Print Buffer is located at 23296 (5B00H) and is 256 (100H) bytes long, the data
needed to print one line of 32 characters, each character comprised of 8 bytes (8 X 8
pixels/character). The buffer is cleared to zeros and the flag PRLEFT set to zero at
power-on time (or execution of a NEW command). The PRLEFT flag is set to 1
whenever pixel data is written to the buffer. This flag is used when exit is made from a
program to print any unprinted data prior to program termination. As the pixel data for a
particular character is entered into the buffer, the buffer address is incremented by 32
(20H); the sequential data in the buffer therefore represents 8 complete scan lines of 32
characters. When the Print Buffer is full, or upon processing an End-of-Line (0DH), or at
program termination, the contents of the buffer are written to the Printer, the buffer is
cleared and the PRLEFT flag is set to zero.

Printer I/O is done via Port 0FBH, but the Printer responds to any I/O Read/Write with
Address Bit 7=1 and Address Bit 2=0. Therefore, any Port providing this combination,
e.g. Ports 0FA through 0F8 and Ports 0F3 through 0F0 as well as others, will interface to
the Printer. See Section 2.1.13.3 for the bit definitions for Printer I/O. The pixel data is
written to the device by the routine PRSCAN in module IO_2 of the Home ROM which
outputs 1 scan line (32 bytes), one bit at a time on each call to the routine.

There are two controlling routines for output to the printer. DUMPPR is called from
SENDTV based on buffer full or End-of-Line control. This routine will call PRSCAN 8
times to output the 256 bytes of the Print Buffer (8 scan lines). The other routine is K
DUMP which implements the COPY command. This routine calls PRSCAN 176 times to
write the contents of the primary display file for the main screen to the printer (8 X 22).
All of the low level print routines are in module IO_2 of the Home ROM.

### 4.2 Cassette Tape

Tape I/O is done via Port 0FEH. An I/O read of Port 0FEH pulls in the cassette input on
Bit 6. An I/O write of Port 0FEH Bit 3 controls the tape output with Bit 3 = 1 generating
a high output and Bit 3 = 0 generating a low output. Data is written to the tape under
software control creating the following frequencies and format:

Sync Pattern of 4032 cycles at 806.5 Hz. (5 sec.)
Header:        17 bytes of data identifying the following data block as either
Program, Number Array, Character Array, or Binary Code and
containing other control information.

<!-- PDF page 72 -->

The header is written as Data, i.e. the Most Significant Bit first in
each byte, 1 cycle at 2040 Hz. for a Zero and 1 cycle at 1020 Hz.
for a One. The first byte is zero identifying the header. The final
byte is a Checksum calculated by XOR of all preceding data bytes.

Software delay of approximately 835 milliseconds.
Sync Pattern of 1612 cycles at 806.5 Hz. (2 secs.)
Transition Pattern of 1 cycle at 2400 Hz.
Data Block: Written as Data (see above) with first byte = -1 (FFH) and a final
Checksum byte.

Figure 4.2-l shows the header formats for the various types of data.

The routines used to actually write and read the tape (W TAPE and R TAPE) are in the
TAPE Module of the Extension ROM (see map in Appendix A). They are accessible via
the Extension ROM Interface Routine listed in Figure 3.2.2-2. The general flow required
to write a header and data block is:
1.     Call W TAPE with A=0. IX contains the address of the header and DE
contains the length.
2.     Delay loop approximately 1 second.
3.     Call W TAPE with A=FFH. IX contains the address of the data block and
DE contains the length.

The R TAPE routine performs either a LOAD (transfers data from tape to memory) or
VERIFY (compare data from tape against data in memory) operation, based on the status
at entry: Carry Set for Load and No Carry if Verify. As for the Write, A=Block Type (0
for Header and -1 (FFH) for Data Block). IX contains the memory address.
and DE contains the length of the block to be read (DE = 17 for the header and DE =
HDLEN for data). See Fig. 4.2-l for a definition of HDLEN.

The tape routines return Carry=1 for successful completion and No Carry for error or
Break Key detected, Roth W TAPE and R TAPE exit via the routine W BORD which
restores the Border color based on bits 3-5 of the system variable BORDCR. If the Break
Key is detected during this exit routine, a RESTART 8 (ERROR) is
executed.

NOTE:          The write to Port 0FEH in the exit routine restoring the Border Color has
hit 3 = 0. This creates a final transition on the tape following a write
operation. This transition is necessary in order to successfully read back
the final data bit from some tape recording devices. If you are calling the
W TAPE routine so as to bypass the normal exit path, you must perform
this final write to Port OFEH with Bit 3 = 0 within a similar timeframe.

<!-- PDF page 73 -->

```text
                                   FIGURE 4.2-1
                                Tape Header Formats
                            Header layout - 17 bytes long
HDTYPE HDNAME                 HDLEN               HDADD                HDVARS
  1 byte     10 bytes 2 bytes LSB/MSB 2 bytes LSB/MSB 2 bytes LSB/MSB
                         Field values for the tape file types
Program
        HDTYPE       0
        HDNAME       Up to 10 ASCII characters
        HDLEN        Length of program + variables (E_LINE) - (PROG)
        HDADD        Start line number e.g. 0500 = line 5 or 0080H if no start line
                              number
        HDVARS       Length of program = Offset to Variables (VARS) - (PROG)
Number array
        HDTYPE       1
        HDNAME       Up to 10 ASCII characters
        HDLEN        Length field from data structure
        HDADD        LSB = 00, MSB = Array ID (100x xxxx binary vale)
                                    where x xxxx is (ASCII - 60H)
        HDVARS       N/A = 0
Character array
        HDTYPE       2
        HDNAME       Up to 10 ASCII characters
        HDLEN        Length field from data structure
        HDADD        LSB = 00, MSB = Array ID (110x xxxx binary vale)
                                    where x xxxx is (ASCII - 60H)
        HDVARS       N/A = 0
Code (Binary)
        HDTYPE       3
        HDNAME       Up to 10 ASCII characters
        HDLEN        Length specified in SAVE
        HDADD        Address specified in SAVE
        HDVARS       N/A = 0
```

<!-- PDF page 74 -->

### 4.3 Joysticks

The two joysticks are controlled via Register 14 (I/O Port A) of the Programmable Sound
Generator Chip (see Sections 2.1.6 and 2.1.7). Address and data are passed via Ports
0F5H and 0F6H respectively. The joysticks are read by first addressing Register 14 in the
PSG by writing a 14 (0EH) to Port 0F5H. The data is then read by executing an IN from
Port 0F6H, having the port address in 280 Register C and the joystick (player) number
in Register B (number = 1 or 2). Note that PSG Register 7, Bit 5 is assumed to be zero,
enabling I/O Port A for input. If you ever use I/O Port A for output (R7,B6=1), you will
want to clear Bit 6 prior to any input operation,

```text
Sample routine:
GETJOY        LD A,OEH                ;Load A = 14
               OUT A,(0F5H)           ;Address the joystick port
               LD B,playerno
               LD C,0F6H              ;Data Port address to C
               IN A,(C)               ;Joystick data to A
               CPL                    ;Complement to High Active
               AND 8FH                ;Get significant bits
```

The data read is LOW ACTIVE, i.e. all bits = 1 (byte=FFH) when the stick is at center
and the button is not depressed. Figure 4.3-l shows the interpretation of the data byte.

```text
             FIGURE 4.3-1
             Joystick Data
Bit      Function
7        BUTTON DEPRESSED
6        Unused - always '1'
5        Unused - always '1'
4        Unused - always '1'
3        STICK RIGHT
2        STICK LEFT
1        STICK DOWN
0        STICK UP
```

### 4.4 Software Generated Sound (BEEP)

The BEEP command produces sound using the speaker by toggling Bit 4 of I/O Port
0FEH to generate a signal of a calculated frequency and duration based on the command
parameters. It uses the routine PARP which takes as input two parameters, one defining
the period of the signal (HL) and the other defining the number of cycles to be generated
(DE) and outputs DE+1 cycles of a tone having the period 8N+236 to 8N+246 T-States
where (HL) = N. Both the BEEP and PARP routines are in the K SCAN module of the
Home ROM. The PARP routine is also used to generate the keyboard "click" and the
