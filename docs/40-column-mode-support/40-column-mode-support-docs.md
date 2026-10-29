# Application Software Component 003 — 40-COLUMN MODE

<!-- PDF page 1 (printed page: none — cover) -->

TIMEX COMPUTER CORPORATION

APPLICATION DEVELOPMENT LIBRARY

Application Software Component 003

40-COLUMN MODE

- **Date:** 12/19/83
- **ASC Number:** 003
- **Version:** 001
- **Author:** Carol Corcoran
- **Name:** 40 Column Mode Support

**Description:**

This component provides support to the application programmer for using the 40-column mode feature of the TS 2068. The services include position control, clear screen and scroll screen services and display of characters. For ease of use from BASIC, status is returned in the BC register pair, usually zero for successful completion and designated non-zero values for other conditions. The interface from BASIC is by means of storing the input parameters in designated RAM locations prior to invoking the service via the USR function.

Attribute and other display controls such as Inverse are taken from the standard TS2068 System Variables (see Usage Section.)

This component is designed to permit use in normal video mode (Display File 1 only) or, in conjunction with ASC004 - Dual Screen Mode Support, to permit use of Display File 1 and/or Display File 2. The value of the System Variable VIDMOD is used to determine which display file is the target of the requested service.

---

> *Transcriber's note:* The cover title lines "APPLICATION DEVELOPMENT LIBRARY" and "Application Software Component 003" are underlined in the original. The scans are of continuous fanfold paper, so the top of the next sheet (with its "Page N" header) shows at the bottom of each PDF page; those bleed-in headers are not transcribed.

<!-- PDF page 2 (printed page "Page 2") -->

ASC Number:  003

---

## Version Control

| Version | Description | Date |
|---------|-------------|------|
| 001 | Original | 12/19/83 |

---

> *Transcriber's note:* "Version Control" is underlined in the original. A small grey smudge (not text) sits below the table.

<!-- PDF page 3 (printed page "Page 3") -->

ASC Number:  003

---

# Application Services

---

## INIT40 (INIT4B from BASIC)

**Input:** None

**Description:**

Initializes the internal variables to their default values for 40-column mode (see Usage Section).

---

> *Transcriber's note:* "Application Services" is underlined in the original; it is rendered here as a section heading under which the service pages follow. The lower half of the page is blank apart from faint show-through of text from another sheet.

<!-- PDF page 4 (printed page "Page 4") -->

ASC Number: 003

---

## CLRSCN  (CLRSCB from BASIC - parameters to CLSCTL)

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

> *Transcriber's note:* "002" as printed; every other page reads 003.

---

## SETCUR  (SETCUB from BASIC - parameters to LINCOL)

**Input:**
- Line Number (0-23)
- Column Number (0-39) or (0-41)

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

ASC Number: 003

---

## WRCHR  (WRCHB from BASIC - parameter to DATAB)

**Input:** Character code for character to be displayed

- 20H TO 7FH - Std. TS2068 Character Set
- 80H TO 8FH - Std. Graphics Set
- 90H TO A4H - User-Defined Graphics Set

**From Machine Code:** Register A

**From BASIC:** in DATAB

**Description:**

Displays character at current cursor position, applying current attributes and mask. Moves cursor position on to next sequential position. If character would start a new line after BOTLN (see Usage section) and the scroll count (variable SCRLCT) decrements to zero, the character will not be displayed and return will be made with BC = 3 (screen full). If the scroll count does not decrement to zero, the screen will be scrolled up one line using the information in SCRCTL and the new line started at the vacated line.

**Output:**
- BC = 0 for successful completion
- BC = 1 invalid character code
- BC = 3 for screen full

---

<!-- PDF page 7 (printed page "Page 7") -->

ASC Number: 003

---

## WRSTRG (WRSTRB from BASIC - String Identifier in PARAM$)

**Input:** Character Code String

**From machine code:**
- Address of string in HL
- Count in BC

**From BASIC:** String Variable Identifier in System Variable PARAM$ - 23747 (5CC3H)

**Description:**

Displays the characters from the string, beginning at the current cursor location and continuing sequentially until the count expires, or 'Screen Full' is detected (see WRCHR description and Usage Section on Automatic Scrolling). For the Screen Full condition, the remaining count is stored in the internal variable STRGCT for access by the user.

**NOTE:** Characters within the string which are outside of the supported range (32 through 164 (20H-A4H) ) will be ignored. E.g., BASIC Token codes and control codes embedded in an INPUT string will not be displayed or decoded.

From BASIC, POKE the code for the string variable identifier into PARAM$ prior to invoking WRSTRB, e.g.

```basic
0005  LET a$="-----string-------"
0010  POKE 23747,CODE "a"
0015  IF USR (WRSTRB)<>0 THEN -----
          (continue)
```

**Output:**
- BC = 0  Successful
- BC = 2  BASIC - String not found
- BC = 3  Screen Full - Remaining Count in STRGCT  
  (HL=Current Address in String)

---

> *Transcriber's note:* The number of dashes inside the example string was counted from a pixel profile (5 before "string", 7 after); treat the exact count as uncertain.

<!-- PDF page 8 (printed page "Page 8") -->

ASC Number: 003

---

## SCROLL  (SCRLB from BASIC - parameters to SCRCTL)

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
- BC = 0  Successful
- BC = 1  Invalid Parameters  
  (Line Number + Line Count < 1 or > 24)

---

<!-- PDF page 9 (printed page "Page 9") -->

ASC Number: 003

---

## GTCHAR  (GTCHRB from BASIC - parameters to GETCTL)

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

> *Transcriber's note:* A small mark just left of the "BC = 1" line looks like a stray speck or hyphen, not part of the printed text.

<!-- PDF page 10 (printed page "Page 10") -->

ASC Number: 003

---

## GETATT  (GETATB from BASIC - parameters to GETCTL)

**Input:** As for GTCHAR

**Description:**

Returns in register C of the BC register pair the attribute byte for the character at the designated screen position. Note that in 40 column mode the 6-pixel character width may cross attribute byte boundaries in the display file (e.g. the character may have 2 pixels in one byte and 4 in the next). The attribute bytes for these two locations may be different. The value of the attribute byte controlling the starting location of the character will be returned.

**Output:**
- BC = 1 for invalid parameters
- BC = attribute byte

```
                Bit 7 - FLASH
                Bit 6 - BRIGHT
                Bit 5
                Bit 4 - PAPER
                Bit 3 /
                Bit 2
                Bit 1 - INK
                Bit 0 /
```

---

> *Transcriber's note:* The bit list is a typed bracket diagram — Bits 5/4/3 belong to PAPER and Bits 2/1/0 to INK, with "/" closing each group; layout preserved in a code block.

<!-- PDF page 11 (printed page "Page 11") -->

ASC Number: 003

---

## GETCUR  (GETCUB from BASIC)

**Input:** None

**Description:**

Returns in the BC register pair and in the BASIC parameter location LINCOL, the current print position (where the next character would be displayed).

**Output:**
- B = Line number (0-23)
- C = Column number (0-39) or (0-41)

**BASIC:**
- LINCOL  -  Column number
- LINCOL + 1  -  Line number

**NOTE:** If the last character was printed at Col.39 (41) of Line 23 (last position on the screen), then Col.0/Line 23 will be returned.

---

<!-- PDF page 12 (printed page "Page 12") -->

ASC Number: 003

---

## Usage:

**Memory Usage:**

This package of machine code routines includes the following internal variables:

| Name | Size | Description |
|------|------|-------------|
| SCRCTL | 2 | Scroll Control<br>LSB = Starting line number<br>MSB = Number of lines to be scrolled |
| BOTLN | 1 | Bottom Line - Line number (0-23) after which test for scroll will be made. |
| SCRLCT | 1 | Scroll Count- Number of times + 1 that automatic scroll will be done. When decremented to zero, data will not be displayed and a condition code will be returned to user. |
| CHTBL | 2 | Character Table (Base Address-100H) |
| GRTBL | 2 | Std.Graphics Character Table (Base-100H) |
| LINLEN | 1 | Line Length - (40 or 42 when in 40-Col.Mode) |
| CURPOS | 2 | Current Position (Internal Format)<br>LSB = Column Position<br>MSB = Line Position |
| DFADDR | 2 | Current Display File Address |
| MASKB | 1 | Working Byte - (P FLAG Shifted Right 1)<br>(bit 0 = OVER    )<br>(bit 2 = INVERSE)<br>(bit 4 = INK Complement of PAPER<br>(bit 6 = PAPER Complement of INK |
| ATTBYT | 1 | Working Byte - (Copy of ATTR P) |
| GTINDX | 1 | 'Get' Index - Used by GTCHAR |
| STRGCT | 2 | String Count - Contains remaining byte count when BC=3 (Screen Full) is returned from the Write String service WRSTRG (WRSTRB). |

> *Transcriber's note:* "Usage:" is underlined in the original. This page uses a solid rule under the ASC Number line rather than the spaced dashes of the service pages.

<!-- PDF page 13 (printed page "Page 13") -->

| Name | Size | Description |
|------|------|-------------|
| MARGIN | 1 | Margin - Margin Adjust (0/1) |
| DFBIT | 1 | Display File Bit - Current Bit Position |
| ATTMSK | 1 | Working Byte - (Copy of MASK P) |

Initial values set via INIT40 (INIT4B) are as follows:

| Variable Name | Value |
|---------------|-------|
| SCRCTL | 1701H |
| BOTLN | 17H |
| SCRLCT | 1H |
| CHTBL | (Internal to Module) |
| GRTBL | (Internal to Module) |
| LINLEN | 28H |
| CURPOS | 1829H |
| DFADDR | 4000H |
| GTINDX | 80H |
| STRGCT | 0H |
| MARGIN | 1H |
| DFBIT | 7H |

The following are the variables used for passing parameters in BASIC and their values as initialized by INIT4B:

| Variable Name | Size | Value |
|---------------|------|-------|
| DATAB | 1 | 0H |
| LINCOL | 2 | 0H |
| CLRCTL | 2 | 1800H |
| GETCTL | 2 | 0H |

In addition, VIDMOD, PARAM$ and other system variables must be available to these routines. At minimum, chunks 0-3 and chunk 7 must be enabled in the Home Bank.

**Location:**

This package can be incorporated into a machine code program within the memory range from chunk 4 through 7, taking into consideration the remapping of certain structures when the second display file is open (Dual Screen Mode only). NOTE: Machine code above RAMTOP is not moved.

**Registers:**

Other than as documented for output values, no claims are made as to preservation of any register contents except for the IY Register which must always contain the value 5C3AH for access to

> *Transcriber's note:* Page 13 continues the internal-variables table from page 12 (no "ASC Number" header on this page). The Registers paragraph breaks mid-sentence at the foot of the page and continues on Page 14. The BASIC parameter table lists "CLRCTL", while the CLRSCN service page (Page 4) names its BASIC parameter area "CLSCTL". SCRCTL (BASIC parameter for SCRLB) is not listed in this BASIC-parameter table; it appears with the internal variables instead.

<!-- PDF page 14 (printed page "Page 14") -->

the standard system variables.

**Automatic Scrolling:**

As initialized, test for scrolling will be made when the print position goes to the next line following the bottom line on screen (BOTLN=23=24th line). Condition Code 3 (Screen Full) will be returned since SCRLCT will decrement to zero. If SCRLCT is set to some larger value, then the parameters in SCRCTL will be used to automatically scroll the designated number of lines beginning at the specified line number. As initialized, this will scroll the entire screen up. By performing a POKE or setting the variables BOTLN and SCRCTL to the desired values, automatic scrolling can be done using smaller sections of the screen. When working from BASIC it is recommended that BOTLN be set to Line 21 (15H) and SCRCTL+1 be set to 21 (15H) to avoid conflict with the Edit Line which uses the bottom two lines of the screen. Note that once SCRLCT expires, it will be set to 1. If a different value is desired, it must be reinitialized by the user after receiving the 'Screen Full' condition.

By setting the SCRCTL variable and invoking the SCROLL (SCRLB) routine any portion of the screen may be scrolled at any time.

**Margin Control:**

In 40-Column Mode, there are actually 42 character positions per line. The variable MARGIN determines the offset of the beginning of the 40 column line from the left side of the screen and has valid offset values of 0 or 1. An offset value of 1 centers the 40 column line on the screen; 0 begins at the extreme left side. The default value is 1. When MARGIN is set to 0, the variable LINLEN can be set to 42 to permit access to the 2 extra print positions. Whenever MARGIN and/or LINLEN are modified, a 'Set Cursor' operation should be done to insure the integrity of the print position.

**NOTE:** Since the different MARGIN values result in different pixel positions for the columns, care must be taken in mixing line length and margin values on the same line.

**Attribute Control:**

Attribute and masking (Inverse/Over) control information will be taken from the system variables ATTR P, MASK P and P FLAG as defined below. These variables contain the 'permanent' attribute controls set via the BASIC commands PAPER, INK, BRIGHT, FLASH, INVERSE, and OVER, or by directly writing to the specified locations.

<!-- PDF page 15 (printed page "Page 15") -->

In 40-Column Mode, the 6-pixel character width results in characters crossing attribute byte boundaries in the display file. Every four columns across a line are controlled by three attribute bytes. This constraint must be taken into consideration when mixing attributes within a line. Inverse and Over are applied to individual characters and are therefore not subject to the above limitation.

| NAME | ADDRESS | CONTENTS |
|------|---------|----------|
| ATTR P | 23693 | Bit 7 - FLASH<br>6 - BRIGHT<br>5<br>4 - PAPER<br>3/<br>2<br>1 - INK<br>0/ |
| MASK P | 23694 | SAME FORMAT AS ATTR P. USED FOR 'TRANSPARENT' DISPLAY: For each bit that is set to 1, the corresponding information will be taken from the current screen position instead of from ATTRP. |
| P FLAG | 23697 | BIT<br>7  PAPER=COMPLEMENT OF INK<br>5  INK=COMPLEMENT OF PAPER<br>3 - INVERSE<br>1 - OVER (New Characters XOR'd with Old) |

> *Transcriber's note:* In the ATTR P bit list, "5 / 4 - PAPER / 3/" and "2 / 1 - INK / 0/" are typed bracket groups (bits 5–3 = PAPER, bits 2–0 = INK). In the P FLAG list, bits 7 and 5 have no dash after the number, while bits 3 and 1 do. The lower part of the page is blank; the documentation ends here.
