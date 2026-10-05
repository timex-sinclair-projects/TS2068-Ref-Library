# Aker, *T/S 2068 Basics and Beyond* (1985) — technical digest

Own-words restatement of the book's technical claims. Not a transcription.
`pN` = printed page. ⚠ = contradicted or doubtful; see `cross-check.md`.
Pedagogical material (sorting, flowcharts, music theory, game walkthroughs) is
summarised in one line or omitted.

---

## Ch. 1 — Basics Plus (pp. 3–14)

### Print position
- Upper screen: 22 printable lines (0–21) × 32 columns (0–31); print position
  starts at 0,0. p3
- A PRINT that ends without a separator moves to the start of the next line,
  even an empty PRINT. p3
- **Comma** moves to column 16; if already in the right half, to column 0 of
  the next line. It can stand between items, after the last item, or directly
  after PRINT. p4
- **Apostrophe** moves to the start of the next line; usable in the same places
  as the comma. p4–5
- **Semicolon** suppresses the end-of-PRINT line feed. p5
- **TAB n** works modulo 32. A TAB to a column left of the current position
  wraps to that column on the next line. p6
- TAB and comma advance by **printing spaces**, so they erase what they pass
  over and paint the current attributes on those cells. p6, p8
- PRINT AT takes the **absolute value** of a negative row or column. p6–7
  (Confirmed against the ROM — see cross-check.)

### Attributes
- Six attributes: INK, PAPER (colour 0–7), FLASH, BRIGHT, OVER, INVERSE (0/1).
  p7
- As a statement, an attribute is permanent; embedded after PRINT, PLOT, DRAW
  or CIRCLE (`CIRCLE INK 2;…`, `PLOT INVERSE 1;…`) it is temporary. p7
- Colour applies to the whole 8×8 cell, which is why lines drawn through a cell
  recolour all ink pixels in it. Matching INK and PAPER turns DRAW into a
  chunky "low-resolution" pen. p7–9

### Quick tips
- FOR loops: any start value, fractional bounds and STEP are allowed; the loop
  runs while the next step stays in range; on exit the control variable is one
  STEP past the limit. p9–10
- Variable names are case-insensitive; strings are case-sensitive. p10, p42
- One letter can serve as a simple numeric variable, a string variable and an
  array at once. p10
- ⚠ Aker: a letter already used as a simple numeric variable cannot also be a
  FOR control variable or a DEF FN name. p10
- ⚠ Aker: a string name can be used for only one of simple string, string
  array, or `FN a$`. p10
- LET requires the variable on the left. p10–11
- DATA items may be expressions and earlier-defined variables; numbers and
  strings may be mixed; a sentinel value can end a variable-length read. p11–12
- GO TO always lands on the first statement of the target line. p13
- After a true IF, every remaining statement on the line runs; after a false
  IF, none do — so `IF INKEY$="" THEN GO TO n: LET k$=INKEY$` never reaches
  the LET. p13
- Lines longer than about three screen lines are hard to edit or renumber. p13
- **PAUSE n** counts screen frames at **60 per second**; any keypress ends it;
  PAUSE 0 waits for a key. An empty FOR loop is an uninterruptible delay. p13–14

## Ch. 2 — Numbers (pp. 15–33)

- RND returns a pseudorandom value 0 ≤ RND < 1 from a fixed sequence. p15
- General formula: `INT(RND*N+L)` gives N integers starting at L. p17
- After NEW the sequence restarts at the same point. p21
- `RANDOMIZE n` (n ≠ 0) re-seeds to a repeatable point; `RANDOMIZE 0` (or
  bare RANDOMIZE) seeds from time since power-on. p21–22
- DIM sets every numeric element to 0; no initialisation needed. p22
- Arrays may have any number of dimensions, limited only by memory. p33
- Rest of chapter: guessing games, bubble sort, search, 2-D array bookkeeping.
  p18–33

## Ch. 3 — Strings (pp. 34–48)

- LEN, STR$, VAL; centring with `TAB (16 - LEN a$/2)`; right-justifying numbers
  via STR$ and LEN. p34–37
- `VAL INKEY$` converts a digit key to a number (e.g. to compute a GO SUB
  target). p36
- **String arrays are fixed-length ("Procrustean")**: `DIM a$(n,len)`; stored
  strings are space-padded or truncated to `len`. A single subscript,
  `DIM a$(len)`, makes one fixed-length string — useful to force INPUT to a
  maximum length and to make comparisons pad consistently. p37–40
- Comparisons against padded elements fail unless the other operand is padded
  too. p39
- CODE of a string = code of its first character; `CODE ""` = 0. Uppercase
  65–90, lowercase 97–122, digits 48–57. p42, p52
- The character set has 256 codes; most unprintable codes display as `?`. p43
- String relational operators (`<`, `>`, `<=`, `>=`) compare character codes
  left to right; a prefix sorts before the longer string. p44
- Slicing: `a$(m TO n)`, open-ended forms, single character `a$(n)`. p45–46
- Array element + slice can be written either `a$(2,3)` style or with
  separate parentheses, `a$(2)(3 TO 5)`. p48

## Ch. 4 — Techniques (pp. 49–62)

### INPUT
- Several variables in one INPUT; `;` `,` `'` position the prompts just as in
  PRINT. p49–50
- `CHR$ 9` (cursor right) inside an INPUT list spaces items one column apart.
  p50
- **INPUT LINE** removes the quotes from a string prompt, which also stops the
  user typing STOP at that prompt. LINE applies only to the next variable, so
  repeat it for each. `INPUT , LINE a$` starts the cursor mid-line. p51–52
- Aker says the Cursor-Down key (shifted 6) still stops an INPUT LINE. p51

### INKEY$
- INKEY$ returns `""` with no key; a held key reads repeatedly, so wait for
  release before taking the next key. ENTER is code 13. p52–53
- ⚠ Line note on p54 calls code 15 "shifted 8"; the body text (p53) correctly
  says shifted 9 (GRAPHICS).
- A prompt-free string input can be built by concatenating INKEY$ values until
  code 13. p54

### Sketchers, OVER
- Cursor keys 5/6/7/8 = left/down/up/right. Row/column must be clamped or
  wrapped, otherwise PRINT AT stops with "out of screen" (or mirrors negative
  values back on-screen). p55–57
- **OVER 1** combines ink pixels exclusive-OR: ink+ink → paper,
  ink+paper → ink, paper+paper → paper. p58
- `CHR$ 8` in a PRINT backspaces one position (with OVER 1, reprinting erases).
  p59

### ON ERR (TS 2068 only)
- Three forms: `ON ERR GO TO n`, `ON ERR RESET`, `ON ERR CONT[INUE]`. p59–62
- With a trap armed, BREAK and STOP are treated as errors and are also
  trapped, so a looping program cannot be broken into unless it executes
  ON ERR RESET. p60
- ON ERR RESET restores normal error handling. p60
- ON ERR CONTINUE resumes at the statement that failed (Aker uses it to retry
  a DRAW after moving the start point), acting like RETURN for a handler
  reachable from several places. p61–62

## Ch. 5 — Graphics (pp. 63–87)

- PLOT space: 256 × 176 pixels, x 0–255 left→right, y 0–175 bottom→top;
  centre ≈ 127,87. p63–64
- DRAW takes **relative** coordinates from the last point. p63
- `DRAW x,y,a` draws an arc turning through **a radians** (PI = half circle).
  Very large angles make the ROM step around the circle in visible straight
  chords, producing star/rosette figures. p71–73
- CIRCLE is drawn by ROM code (fast); a BASIC SIN/COS loop is slow but allows
  dotted, partial, clockwise, elliptical and spiral curves. p81–87
- ⚠ PLOT coordinates that are not integers are "rounded down". p78

## Ch. 6 — Functions (pp. 88–102)

- Binary/decimal conversion means some decimal results are inexact; the 2068
  does no correction. p88–89
- INT floors (−5.2 → −6); round to nearest with `INT(x+.5)`; to cents with
  `INT(x*100+.5)/100`. p89–91
- ⚠ Arguments that must be integers (PRINT AT, PLOT, TAB, INK …) are INTed
  automatically. p90
- PRINT AT and PLOT coordinates are made positive automatically (ABS). p92
- SGN, SQR, `↑` (power), roots via `x↑(1/n)`, LN (natural), `EXP`, common log
  as `LN x/LN 10`. p92–95
- SIN/COS/TAN/ASN/ACS/ATN work in **radians**; degrees × PI/180. p95–96
- DEF FN: numeric and string functions, one or more parameters (letters);
  an FN can be the argument of another FN or of TAB. DEF FN is on key 1, FN on
  key 2 (extended mode). p96–102

## Ch. 7 — More Graphics (pp. 103–120)

- Animation by print-and-erase; erase immediately before reprint to avoid
  flicker. p103–109
- A character's shape is 8 bytes in the character generator; set bits are ink.
  p110–111
- ⚠ Aker: there are **20** user-definable graphic maps. p111
- `USR "a"` is the address of UDG A's first byte = **65368** at power-on; the
  UDG maps are contiguous (B follows A, …), so one loop can POKE several. p111–113
- UDG designs persist until power-off or overwritten. p113
- Colour numbers **8** (transparent: keep the cell's existing value) and
  **9** (contrast: black or white against the cell's paper) are valid for INK
  and PAPER. p117–118
- ⚠ The INK 9 example on p118 is printed with INK 8.
- BRIGHT doubles the palette to 16; checkerboard UDGs dither further shades.
  p118–120

## Ch. 8 — Truth and Logic (pp. 121–133)

- AND binds tighter than OR. p123
- Numeric `x AND c` = x if c is true (≠ 0), else 0; `x OR c` = 1 if c is true,
  else x. p124, p128
- String `a$ AND c` = a$ if c true, else `""`; strings can be concatenated
  (`+`) but not subtracted. p127
- Computed branches built as a sum of `(line AND condition)` terms require the
  conditions to be mutually exclusive, or the line numbers add up. p124–125
- Every term of a logical expression is always evaluated, so these forms are
  smaller but slower than IF chains. p127, p197
- Any non-zero value is true; a relation evaluates to 1 or 0 and can be
  assigned (`LET b=5<10` → 1). p129–131
- ⚠ Aker: `NOT a<b` means `(NOT a)<b` because NOT applies only to the
  operand on its right. p132
- `LET x=NOT x` toggles a flag 0/1. p132

## Ch. 9 — Sound (pp. 134–165)

### BEEP
- `BEEP duration,pitch`: duration in seconds up to 10; pitch −60 to 69 in
  semitones, fractional values allowed; **0 = middle C**. Very short beeps
  (≈ .005 s; ≈ .0005 s at high pitch) sound as clicks. p134–138
- BEEP halts the program for its duration. p163

### SOUND — AY-3-8912 registers (with App. C, p223–224)

| Reg | Use (Aker) | Range |
|----:|------------|-------|
| 0/1 | Channel A tone, fine / coarse | 0–255 / 0–15 |
| 2/3 | Channel B tone, fine / coarse | 0–255 / 0–15 |
| 4/5 | Channel C tone, fine / coarse | 0–255 / 0–15 |
| 6 | Noise period (higher = lower pitch) | 0–31 |
| 7 | Enable: start from 63 (all off) and subtract 1/2/4 for tone A/B/C, 8/16/32 for noise A/B/C | |
| 8/9/10 | Volume A/B/C; 0 = silent; **16 = envelope control** | 0–15, 16 |
| 11/12 | Envelope period fine / coarse (coarse ≈ 256× fine) | 0–255 each |
| 13 | Envelope shape | 0–15 |

- `SOUND r,v;r,v;…` takes any number of register/value pairs. p146
- Higher tone values give lower pitch; tone pitch is not linear in the
  register value. p145
- ⚠ Table 9-2 gives fine values (coarse 0) **209 … 104** for "middle C to
  high C"; App. C extends natural notes across octaves. p145, p223
- Registers keep their values until changed or power-off; the ROM switches all
  sound off when a program ends. p146, p150
- To get two separate notes of the same pitch, disable the channel briefly
  between them. p152–153
- Load tone/volume registers **before** enabling a channel in R7, otherwise
  the previous note sounds briefly. p150–151
- Full reset idiom: zero R0–R13, then R7 = 63. p151
- **Envelope shape (R13)**: add 4 = attack (build), 2 = alternate, 1 = hold,
  8 = continue. Without 8 the envelope runs once and the volume ends at zero.
  All channels under envelope control share one shape and period. p156–161
  (Table 9-3, p159, describes each value; they agree with the AY datasheet.)
- A channel can be enabled for tone and noise at the same time. p163
- Recipes: gunshot, explosion, falling bomb, roar, tone+noise sweep. p162–165

## Ch. 10 — PEEK and POKE (pp. 166–183)

- 0–16383 ROM, 16384–65535 RAM (simplified; ignores bank switching). p166
- Two-byte values are stored low byte first. p167–168
- System variables start at **23552**. p168

| Name | Address | Aker's notes | Page |
|------|--------:|--------------|------|
| REPDEL | 23561 | Delay before key repeat, 60ths of a second; default 35 | p169 |
| REPPER | 23562 | Interval between repeats, 60ths; default 5 | p169 |
| CHARS | 23606–7 | Character set − 256; default 15360 (set begins 15616) | p180 |
| PIP | 23609 | Keyboard click length; default 0 | p168 |
| PROG | 23635–6 | Start of BASIC program | p202 |
| DF SZ | 23659 | Lines reserved for lower screen; default 2 | p171 |
| FRAMES | 23672–4 | 3-byte frame counter, 60 Hz; PAUSE uses it | p181 |
| SCR CT | 23692 | One more than scrolls allowed before "scroll?"; normally 1; POKE 255 to scroll freely | p170 |
| ATTR P | 23693 | Permanent attributes; normal value 56 | p175 |

- DF SZ: POKE 0 crashes the machine; a large value restricts PRINT to the top
  lines; the ROM resets it after each command. p171–172
- Attribute byte: bits 0–2 INK, 3–5 PAPER (×8), 6 BRIGHT (64), 7 FLASH (128).
  p173–175
- Attribute file for the normal screen begins at **22528**; the 2068 has a
  second one not reachable from BASIC. POKEing attributes recolours without
  erasing. ⚠ End address given as 23232. p176
- Character generator at **15616** (space first, then by code); a character's
  map is at CHARS + 8 × code. Moving CHARS by 8 shifts every displayed character
  by one code; pointing CHARS at RAM allows a custom font. p177–181
- Timing with FRAMES: zero the low two bytes, read them later, divide by 60
  (two bytes ≈ 18 minutes). p181–183

## Ch. 11 — More Techniques (pp. 184–200)

### STICK (TS 2068 only)
- `STICK (what, stick)`: what = 1 direction, 2 fire button; stick = 1 left,
  2 right. p184
- Fire: 0 up / 1 pressed. Direction: 0 centred, 1 up, 2 down, 4 left, 8 right;
  diagonals are sums (5, 6, 9, 10). p185–187
- The port is read only at the moment STICK is evaluated; the two sticks
  cannot be read simultaneously, so the first one read has an edge. p185–188

### Screen reading
- `SCREEN$(r,c)` returns the character in a cell; an inverse character reads as
  its normal form; graphics and UDGs read as `""`, except the solid block,
  which reads as a space. p188–190
- `ATTR(r,c)` returns the attribute byte (FLASH at 10,15 on a default screen →
  184). Distinct attributes can tag objects that SCREEN$ cannot read. p191,
  p213–215
- `POINT(x,y)` is 1 for an ink pixel, 0 for paper, in PLOT coordinates. p191

### Housekeeping
- ⚠ `PRINT FREE` reports 38652 bytes on an empty machine. p197
- Tape: `LOAD ""` loads the first program heard; LOADing a name that isn't on
  the tape lists every header it passes; `SAVE … LINE n` auto-runs;
  `SAVE/LOAD … SCREEN$`; `SAVE/LOAD … DATA a$()` saves one array (no
  subscripts; no DIM needed before loading, and a later DIM of the same name
  wipes it); MERGE combines programs with disjoint line numbers; SAVE/LOAD
  work inside programs for chaining. p197–200

## Ch. 12 — Annotated programs (pp. 201–219)

Renumber, UDG designer, SOUND register utility, and seven games. Technical
points only:

- BASIC line storage: two-byte line number (**high byte first**), body ends in
  code 13; PROG gives the start. Aker's renumberer finds lines by looking for
  a 13 followed by a line number. ⚠ p202
- The SOUND utility zeroes R0–R13 and writes 63 to R7 before and after
  playing. p206

## Appendixes (pp. 220–224)

- A: character codes for digits and letters (same as ASCII).
- B: DATA for 30-odd ready-made UDG shapes (boxes, card suits, arrows,
  dither patterns, line-drawing blocks).
- C: natural-note fine-tune values across octaves with coarse = 0, the SOUND
  register table, and the R7 subtraction values. The book refers to Chapter 21
  of the Timex user's manual for the full tuning range.
