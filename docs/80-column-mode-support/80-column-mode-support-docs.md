<!-- PDF page 1 (cover; no printed page number) -->

# Application Software Component 002 — 80-COLUMN MODE

TIMEX COMPUTER CORPORATION

APPLICATION DEVELOPMENT LIBRARY

- **Date:** 12/16/83
- **ASC Number:** 002
- **Version:** 001
- **Author:** C. Corcoran/D. Boyle
- **Name:** 80 Column Mode Support

**Description:**

This component provides support to the application programmer for using the 80-column mode feature of the TS 2068. The services include opening/closing the second display file (moving the machine stack, OS RAM routines and BASIC structures), PRINT position control, attribute control, clear screen and scroll screen services and display of characters. For ease of use from BASIC, status is returned in the BC register pair, usually zero for successful completion and designated non-zero values for other conditions. The interface from BASIC is by means of storing the input parameters in designated RAM locations prior to invoking the service via the USR function.

---

<!-- PDF page 2 (printed page "Page 2") -->

ASC Number: 002

---

## Version Control

---

| Version | Description | Date |
|---------|-------------|------|
| 001 | Original | 12/16/83 |

---

<!-- PDF page 3 (printed page "Page 3") -->

ASC Number: 002

---

## Application Services

---

## SETMODE

**Name:** SETMODE (SETMDB from BASIC - parameter to VIMODE)

**Input:** MODE (0=normal , 8=80 column mode)

- From machine code: Register A
- From BASIC: In VIMODE

**Description:**

Sets specified video mode, opening or closing the second display file where needed. This involves determining if there is enough free RAM to open the second display file and if so, moving the BASIC structures and machine language variables area up and the UDG area down to make space for the machine stack and OS RAM routines at the top of memory. The second display file is cleared to zeroes. The affected system and internal variables are updated or initialized (see Usage Section). When returning to Mode 0 from 80 Column mode, the structures are returned to their normal locations.

**Output:**

- BC = 0 Successful
- BC = 1 Invalid parameters (not equal to 0 or 8)
- BC = 2 Not enough memory

---

<!-- PDF page 4 (printed page "Page 4") -->

ASC Number: 002

---

## CLRSCN

**Name:** CLRSCN (CLRSCB from BASIC - parameters to CLSCTL)

**Input:**

- Line Count (1-24)
- Starting Line Number (0-23)

**From Machine Code:**

- Line Count In Register B
- Starting Line In Register C

**From BASIC:**

- Starting Line Number in CLSCTL
- Line Count in CLSCTL + 1

**Description:**

Clears to background color (PAPER) the designated number of lines, beginning with the Starting Line Number. Line 0 with a count of 24 clears the entire screen. Upon return, the cursor position is at the beginning of the first line cleared.

**Output:**

- BC = 0 for successful completion
- BC = 1 invalid parameters  
  (Line Number + Line Count <1 or >24)

---

<!-- PDF page 5 (printed page "Page 5") -->

ASC Number: 002

---

## SETCUR

**Name:** SETCUR (SETCUB from BASIC - parameters to LINCOL)

**Input:**

- Line Number (0-23)
- Column Number (0-79) or (0-84)

**From Machine Code:**

- Line Number In Register B
- Column Number In Register C

**From BASIC:**

- Column Number In LINCOL
- Line Number In LINCOL + 1

**Description:**

Converts the requested position to internal format, determines display file address, and stores the values for use by the next display character operation. Note that once established, the position is updated automatically when a character is displayed so that it is only necessary to set the position when sequential display is not desired.

**Output:**

- BC = 0 for successful completion
- BC = 1 for invalid parameters (Line Number > 23 ,  
  Column Number > Line Length-1)

---

<!-- PDF page 6 (printed page "Page 6") -->

ASC Number: 002

---

## SETATT

**Name:** SETATT (SETATB from BASIC - parameter to ATTCTL)

**Input:** Attribute Byte -

| Bit | Meaning |
|-----|---------|
| bit 7 | FLASH |
| bit 6 | BRIGHT |
| bit 5 | P |
| bit 4 | A |
| bit 3 | PER |
| bit 2 | I |
| bit 1 | N |
| bit 0 | K |

> *Transcriber's note:* In the original, the letters for bits 5–0 are staggered so that they read vertically as "PAPER" (bits 5–3) and "INK" (bits 2–0).

- From Machine Code: Register A
- From BASIC: In ATTCTL

**Description:**

The specified INK color (0-7) is used to set the video mode hardware and to update VIDMOD. The complementary PAPER color is fixed by the INK selection. FLASH and BRIGHT are fixed at zero by the hardware. Note that in 80 column mode the entire screen has the same attributes.

**Output:** BC = 0 Successful

---

<!-- PDF page 7 (printed page "Page 7") -->

ASC Number: 002

---

## SETMSK

**Name:** SETMSK (SETMSB from BASIC - paramters to MSKCTL)

**Input:** Mask Byte

- bit 0 - OVER
- bit 2 - INVERSE

- From Machine Code: Register A
- From BASIC: MSKCTL

**Description:**

The specified mask is stored for application to all subsequent display character operations. (OVER = 1 implies new character combined with old using an XOR operation; INVERSE = 1 implies character is inverted).

**Output:** BC = 0 for successful completion

---

<!-- PDF page 8 (printed page "Page 8") -->

ASC Number: 002

---

## WRCHR

**Name:** WRCHR (WRCHB from BASIC - parameter to DATAB)

**Input:** Character code for character to be displayed

- 20H TO 7FH - Std. TS2068 Character Set
- 80H TO 8FH - Std. Graphics Set
- 90H TO A4H - User-Defined Graphics Set

- From Machine Code: Register A
- From BASIC: in DATAB

**Description:**

Displays character at current cursor position, applying current mask. Moves cursor position on to next sequential position. If character would start a new line after BOTLN (see Usage section) and the scroll count (variable SCRLCT) decrements to zero, the character will not be displayed and return will be made with BC = 3 (screen full). If the scroll count does not decrement to zero, the screen will be scrolled up one line using the information in SCRCTL and the new line started at the vacated line.

**Output:**

- BC = 0 for successful completion
- BC = 1 invalid character code
- BC = 3 for screen full

---

<!-- PDF page 9 (printed page "Page 9") -->

ASC Number: 002

---

## WRSTRG

**Name:** WRSTRG (WRSTRB from BASIC - String Identifier to PARAM$)

**Input:** Character Code String

- From machine code: Address of string in HL  
  Count in BC
- From BASIC: String Variable Identifier in  
  System Variable PARAM$ - 23747 (5CC3H)

**Description:**

Displays the characters from the string, beginning at the current cursor location and continuing sequentially until the count expires, or 'Screen Full' is detected (see WRCHR description and Usage Section on Automatic Scrolling). For the Screen Full condition the remaining count is stored in the internal variable STRGCT for access by the user.

**NOTE:** Characters within the string which are outside of the supported range (32 through 164 (20H-A4H) ) will be ignored. E.g., BASIC Token codes and control codes embedded in an INPUT string will not be displayed or decoded.

From BASIC, POKE the code for the string variable identifier into PARAM$ prior to invoking WRSTRB, e.g.

```basic
0005  LET a$="-----string------"
0010  POKE 23747,CODE "a"
0015  IF USR (WRSTRB)<>0 THEN -----
         (continue)
```

**Output:**

- BC = 0 Successful
- BC = 2 BASIC - String not found
- BC = 3 Screen Full - Remaining Count in STRGCT  
  (HL =Current Address in String)

---

<!-- PDF page 10 (printed page "Page 10") -->

ASC Number: 002

---

## SCROLL

**Name:** SCROLL (SCRLB from BASIC - parameters to SCRCTL)

**Input:**

- Line Count (1-23)
- Starting Line Number (1-23)

**From Machine Code:**

- Line Count In B
- Starting Line In C

**From BASIC:**

- Starting Line In SCRCTL
- Line Count In SCRCTL + 1

**Description:**

Scrolls the designated number of lines up 1 position, starting at the specified line number and inserts a blank line at the bottom of the scrolled area. Line 1 with a count of 23 will scroll the entire screen up 1 line. Upon return, the cursor position is at the beginning of the inserted blank line.

**Note:** See Usage Section on 'automatic' scrolling.

**Output:**

- BC = 0 Successful
- BC = 1 Invalid Parameters  
  (Line Number + Line Count < 1 or > 24)

---

<!-- PDF page 11 (printed page "Page 11") -->

ASC Number: 002

---

## GTCHAR

**Name:** GTCHAR (GTCHRB from BASIC - parameters to GETCTL)

**Input:** Line/Column position as for SETCUR

**From Machine Code:**

- Line Number in B
- Column Number in C

**From BASIC:**

- Column Number in GETCTL
- Line Number in GETCTL + 1

**Description:**

Returns in register C of the BC register pair the character code for the character at the designated screen position. If no match against the character set (including the standard and user-defined graphics) is found, zero is returned. (Character code or zero also returned in A.)

**Note:** Positions 'printed' using the OVER technique will return zero if they do not match against any single character.

**Output:**

- BC = 0 for no find
- BC = 1 invalid parameters
- BC = character code (20H-A4H)

---

<!-- PDF page 12 (printed page "Page 12") -->

ASC Number: 002

---

## GETATT

**Name:** GETATT (GETATB from BASIC - parameters to GETCTL)

**Input:** As for GTCHAR

**Description:**

Returns in register C of the BC register pair the attribute byte for the character at the designated screen position. Note that in 80 column mode the entire screen has common attributes. The value returned will describe the current selection:

**Output:**

- BC = 1 for invalid parameters
- BC = attribute byte (as for SETATT)

---

<!-- PDF page 13 (printed page "Page 13") -->

ASC Number: 002

---

## GETCUR

**Name:** GETCUR (GETCUB from BASIC)

**Input:** None

**Description:**

Returns in the BC register pair and in the BASIC parameter location LINCOL, the current print position (where the next character would be displayed).

**Output:**

- B = Line number (0-23)
- C = Column number (0-79) or (0-84)

**BASIC:**

- LINCOL - Column number
- LINCOL + 1 - Line number

**NOTE:** If the last character was printed at Col.79 (84) of Line 23 (last position on the screen), then Col.0/Line 23 will be returned.

---

<!-- PDF page 14 (printed page "Page 14") -->

ASC Number: 002

---

## Usage

**Memory Usage:**

This package of machine code routines includes the following internal variables:

| Name | Size | Description |
|------|------|-------------|
| SCRCTL | 2 | Scroll Control<br>LSB = Starting line number<br>MSB = Number of lines to be scrolled |
| BOTLN | 1 | Bottom Line - Line number (0-23) after which test for scroll will be made. |
| SCRLCT | 1 | Scroll Count- Number of times + 1 that automatic scroll will be done. When decremented to zero, data will not be displayed and a condition code will be returned to user. |
| CHTBL | 2 | Character Table (Base Address-100H) |
| GRTBL | 2 | Std.Graphics Character Table (Base-100H) |
| LINLEN | 1 | Line Length - (80 or 85 when in 80-Col.Mode) |
| CURPOS | 2 | Current Position (Internal Format)<br>LSB = Column Position<br>MSB = Line Position |
| DFADDR | 2 | Current Display File Address |
| MASKB | 1 | Mask Byte (bit 0 = OVER)<br>(bit 2 = INVERSE) |
| ATTBYT | 1 | Attribute Byte (bits 0 - 2 - INK)<br>(bits 3 - 5 - PAPER)<br>(bit 6 - BRIGHT (Set to zero<br>(bit 7 - FLASH by H/W in 80-col.mode) |
| GTINDX | 1 | 'Get' Index - Used by GTCHAR |
| STRGCT | 2 | String Count - Contains remaining byte count when BC=3 (Screen Full) is returned from the Write String service WRSTRG (WRSTRB). |

> *Transcriber's note:* In the ATTBYT row the original prints the bit list in one column and "(Set to zero by H/W in 80-col.mode)" as a separate column to the right of the BRIGHT and FLASH lines; the parentheses on the BRIGHT and FLASH lines are not closed in the original.

<!-- PDF page 15 (printed page "Page 15") -->

| Name | Size | Description |
|------|------|-------------|
| MARGIN | 1 | Margin - Margin Adjust (0-2) |
| DFBIT | 1 | Display File Bit - Current Bit Position |

Initial values set via SETMODE (SETMDB) are as follows:

| Variable Name | Value |
|---------------|-------|
| SCRCTL | 1701H |
| BOTLN | 17H |
| SCRLCT | 1H |
| CHTBL | (Internal to Module) |
| GRTBL | (Internal to Module) |
| LINLEN | 50H |
| CURPOS | 1851H |
| DFADDR | 4000H |
| MASKB | 0H |
| ATTBYT | 38H |
| GTINDX | 80H |
| STRGCT | 0H |
| MARGIN | 1H |
| DFBIT | 7H |

The following are the variables used for passing parameters in BASIC. The * indicates those initialized by SETMDB:

| Variable Name | Size | Value |
|---------------|------|-------|
| \* DATAB | 1 | 0H |
| \* LINCOL | 2 | 0H |
| \* CLRCTL | 2 | 1800H |
| \* ATTCTL | 1 | 38H |
| \* MSKCTL | 1 | 0H |
| \* GETCTL | 2 | 0H |
| VIMODE | 1 | |

In addition, VIDMOD, PARAM$ and other system variables must be available to these routines. At minimum, chunks 0-3 and chunk 7 must be enabled in the Home Bank.

**Location:**

This package can be incorporated into a machine code program within the memory range from chunk 4 through 7, taking into consideration the remapping of certain structures when the second display file is open. NOTE: Machine code above RAMTOP is not moved.

The routine SETMODE (SETMDB) cannot be executed from a cartridge because of the necessity to enable the ROM Extension which disables the DOCK Bank.

<!-- PDF page 16 (printed page "Page 16") -->

**Registers:**

Other than as documented for output values, no claims are made as to preservation of any register contents except for the IY Register which must always contain the value 5C3AH for access to the standard system variables.

**Automatic Scrolling:**

As initialized, test for scrolling will be made when the print position goes to the next line following the bottom line on screen (BOTLN=23=24th line). Condition Code 3 (Screen Full) will be returned since SCRLCT will decrement to zero. If SCRLCT is set to some larger value, then the parameters in SCRCTL will be used to automatically scroll the designated number of lines beginning at the specified line number. As initialized, this will scroll the entire screen up. By performing a POKE or setting the variables BOTLN and SCRCTL to the desired values, automatic scrolling can be done using smaller sections of the screen. When working from BASIC it is recommended that BOTLN be set to Line 21 (15H) and SCRCTL+1 be set to 21 (15H) to avoid conflict with the Edit Line which uses the bottom two lines of the screen. Note that once SCRLCT expires, it will be set to 1. If a different value is desired, it must be reinitialized by the user after receiving the 'Screen Full' condition.

By setting the SCRCTL variable and invoking the SCROLL (SCRLB) routine any portion of the screen may be scrolled at any time.

**Margin Control:**

In 80-Column Mode, there are actually 85 character positions per line. The variable MARGIN determines the offset of the beginning of the 80 column line from the left side of the screen and has valid offset values of 0, 1 or 2. An offset value of 1 centers the 80 column line on the screen; 0 begins at the extreme left side; 2 terminates at the extreme right side. The default value is 1. When MARGIN is set to 0, the variable LINLEN can be set to 85 to permit access to the 5 extra print positions. Whenever MARGIN and/or LINLEN are modified, a 'Set Cursor' operation should be done to insure the integrity of the print position.

**NOTE:** Since the different MARGIN values result in different pixel positions for the columns, care must be taken in mixing line length and margin values on the same line.

**Saving BASIC Programs:**

To SAVE a BASIC program which is using these routines you must first put the TS 2068 in normal video mode by inputting '0' to SETMDB. This returns the system variables to values compatible with the state of the machine when the program will be loaded

<!-- PDF page 17 (printed page "Page 17") -->

(second display file closed and machine stack in Chunk 3).

> *Transcriber's note:* The rest of page 17 is blank. The documentation ends here; the assembler listing ("ADL - ASC 002 80-COL.MODE SUPPORT ... CRZ80/11 version 10.36.14 3-Jan-84", listing "Page 1") begins on PDF page 18.
