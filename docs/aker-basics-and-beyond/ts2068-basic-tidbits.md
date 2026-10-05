# TS 2068 BASIC programming tidbits

Short, checked notes on how TS 2068 BASIC actually behaves, and what that
means for speed, size and correctness. The first set is drawn from Sharon
Zardetto Aker, *T/S 2068 Basics and Beyond* (1985), reworded and re-checked
against the stock HOME ROM. Code snippets are new illustrations, not Aker's
listings.

**Source tags:** `[Aker pN]` = the idea is in Aker at printed page N.
`[ROM $xxxx]` = verified in `disassemblies/ts2068_home_rom_U16_stock.txt`.
**Corrected** = Aker's version was wrong and the ROM version is given.
**(unverified)** = not checked against the ROM.

---

## Speed and size

### 1. Logical-sum expressions are smaller, not faster
`LET x=x+(k$="8")-(k$="5")` replaces two IF lines, but **every term is always
evaluated**: Sinclair BASIC doesn't short-circuit AND and OR. A chain of IFs
stops at each false condition and skips the rest of that line. Aker measured
her two sketcher versions at about 310 vs 224 bytes and about 5.5 vs 6 s per
100 loops: the compact form was smaller but slower. `[Aker p127, p197]`

### 2. Guard the expensive part with one cheap IF
If clamp or wrap arithmetic is needed only at the screen edges, skip it with a
single range test that is usually true:

```basic
40 IF x>0 AND x<255 AND y>0 AND y<175 THEN GO TO 60
50 LET x=x+(x<0)-(x>255): LET y=y+(y<0)-(y>175)
60 PLOT x,y
```
`[Aker p127]`

### 3. Split a big logical expression by a cheap test
If a long `(a AND c1)+(b AND c2)+…` table falls into two halves on a cheap
condition (odd/even row, say), put each half behind its own IF so that only
half the terms are evaluated per pass. `[Aker p217]`

### 4. Drop INT where the ROM integerises anyway — mind the rounding
Coordinate arguments to PLOT, DRAW, PRINT AT, POINT, ATTR and STICK are
converted by the ROM (all through `GET_XY`), so `INT(...)` around them only
costs time. Other integer arguments (INK, PAPER, TAB …) are also converted, but
their exact path is (unverified).
**Corrected:** the ROM **rounds to nearest**; it doesn't truncate. It adds 0.5
before INT. Aker's shortcut `PRINT AT RND*22,RND*32` can therefore produce row
22 or column 32 and stop with *Out of screen*. Scale to one less:

```basic
10 PRINT AT RND*21,RND*31;"*"     : REM rows 0-21, cols 0-31
20 PLOT RND*255,RND*175
```
`[Aker p90; ROM FP2BC $3160]`

### 5. Negative coordinates are silently made positive
PLOT and PRINT AT discard the sign (`GET_XY` returns it separately and they
ignore it), so `PLOT -10,5` plots at 10,5. A bounds bug that drives a
coordinate below 0 makes the cursor bounce back on-screen rather than raising
an error. Clamp explicitly. `[Aker p6, p55, p92; ROM GET_XY $2660]`

### 6. Use one PAUSE in place of an empty loop, unless the user mustn't skip it
PAUSE counts 60 Hz frames and takes no interpreter time per frame, but any
keypress ends it. An empty `FOR … NEXT` can't be skipped, but its length
depends on interpreter speed. Use PAUSE for display holds and a loop only when
a keypress must not cut the delay short. `[Aker p13–14]`

### 7. SOUND runs in the background; BEEP blocks
BEEP stops the program for its whole duration. SOUND sets the AY registers and
returns at once: the tone continues while BASIC moves sprites. Use SOUND for
music or effects that accompany motion. `[Aker p163]`

### 8. Recolour without reprinting: POKE the attribute file
The normal-screen attribute file starts at 22528 (row r, column c at
`22528+32*r+c`). POKEing a cell changes its colour instantly and leaves the
pixels alone, which is far cheaper than reprinting text. The byte is
`INK + 8*PAPER + 64*BRIGHT + 128*FLASH`. `[Aker p173–176]`

### 9. Fixed-length strings do the truncating for you
`DIM n$(10)` creates one 10-character string. Assigning or INPUTting into it pads
with spaces or truncates, so there's no LEN check to write. Remember that
comparisons see the padding: compare against an equally padded value.
`[Aker p38–39]`

### 10. Measure, don't guess: time code with FRAMES
```basic
10 POKE 23672,0: POKE 23673,0
20 REM ... code under test ...
30 PRINT (PEEK 23672+256*PEEK 23673)/60;" s"
```
Two bytes give about 18 minutes at 60 Hz. Interrupts must be running (the
counter is updated by the 60 Hz interrupt). `[Aker p181–182]`

---

## Expressions and logic

### 11. Relations are numbers: true = 1, false = 0
`LET hit=(x=tx AND y=ty)` stores 1 or 0; `IF hit THEN …` works, and any non-zero
value counts as true. `LET f=NOT f` toggles a 0/1 flag. `[Aker p129–132]`

### 12. `n AND cond` and `n OR cond`
`n AND c` gives n when c is true, else 0. `n OR c` gives 1 when c is true,
else n. Strings: `a$ AND c` gives a$ or `""`. This allows computed GO TO
targets and branch-free messages:

```basic
PRINT ("HIGH" AND g>n)+("LOW" AND g<n)
GO TO 1000+(100 AND k=1)+(200 AND k=2)
```
The conditions in a computed GO TO must be mutually exclusive, or the targets
add up. `[Aker p124–128]`

### 13. Operator priority: AND before OR; comparisons before NOT
`a OR b AND c` means `a OR (b AND c)`. Use brackets when you mean otherwise.
**Corrected:** Aker says `NOT a<b` means `(NOT a)<b`. In the ROM NOT has
priority 4 and comparisons 5, so it means `NOT (a<b)`, as on the Spectrum.
`[Aker p123, p132; ROM $2AB0, OPPRI $2B6E]`

### 14. Even/odd without IF
`n/2-INT(n/2)` is 0 for even n and 0.5 for odd n, and so works directly as a
condition. Note that INT floors toward minus infinity (`INT -5.2` = −6), which
matters for negative n. `[Aker p89, p130]`

---

## Variables and data

### 15. One letter, three namespaces — with limits
`a`, `a$` and `a()` can coexist. A string name, though, is either a simple
string or a string array, not both: DIM replaces one with the other.
**Corrected:** a simple numeric variable can be reused as a FOR control
variable; FOR converts it in place. `[Aker p10; ROM FOR $1C95–$1CA7]`

### 16. A finished FOR loop leaves the variable one STEP past the limit
After `FOR i=1 TO 5: NEXT i`, i = 6. Code that reuses i after the loop must
allow for that. `[Aker p10]`

### 17. Read INKEY$ and STICK once per decision
Each use of INKEY$ or STICK rescans the hardware, and the answer can change
between two reads in the same line. Copy the value into a variable and test
the copy. Re-read it in the loop, though, or the variable never updates.
`[Aker p53, p185–186]`

### 18. Never chain statements after an IF you expect to fall through
Everything after THEN on that line runs only when the condition is true. A
statement after `IF INKEY$="" THEN GO TO n` on the same line is unreachable.
Put the work on the next line. `[Aker p13]`

### 19. Keep arrays as data files
`SAVE "name" DATA q$()` saves just that array; `LOAD "name" DATA q$()` recreates
it without a DIM. A later DIM of the same name wipes the loaded data. One
program shell can then serve many data sets. `[Aker p199]`

---

## Screen, keyboard and system variables

### 20. Stop the "scroll?" prompt
SCR CT (23692) counts scrolls remaining before the prompt. The ROM resets it
after each command, so a long listing or output needs `POKE 23692,255`, and
re-POKE it inside long output loops because it counts down. `[Aker p170–171;
ROM $0E7B]`

### 21. Key repeat and click
REPDEL (23561, default 35) and REPPER (23562, default 5) are in 60ths of a
second; PIP (23609) lengthens the key click. Raising REPDEL is a simple guard
against double key presses by young users. Values near 1 make the keyboard
unusable. `[Aker p168–170]`

### 22. INPUT LINE blocks STOP
Without quotes on the prompt, a typed STOP is just text. LINE applies only to
the variable right after it, so write `INPUT LINE a$; LINE b$`. `[Aker p51–52]`

### 23. Transparent and contrast colour
INK/PAPER 8 keep a cell's existing value; INK 9 picks black or white to
contrast with the cell's paper. Printing with INK 8 over a coloured
background inherits the background's ink. `[Aker p117–118]`

### 24. SCREEN$ can't see graphics; use ATTR as a tag
SCREEN$ matches only the character set, so UDGs and block graphics read as
`""` (an inverse character reads as its normal form). Give each object type a
unique attribute and test `ATTR(r,c)`. `[Aker p190–191, p213–215]`

### 25. Custom fonts through CHARS
CHARS (23606–7) holds the font address − 256 (default 15360 → font at 15616).
Copy the ROM font to RAM, edit it, and point CHARS at the copy − 256. Each
glyph is at `CHARS + 8*code`. `[Aker p177–181]`

### 26. Use `USR "a"`, not 65368
UDG A is at 65368 only while the second display file is closed. Opening it
moves the UDGs down $0840 bytes. `USR "a"` follows the move; hard-coded 65368
doesn't. There are 21 UDGs (A–U), not Aker's 20. `[Aker p111–113; library
ts2068_system_variables.md]`

---

## ON ERR

### 27. Let the error trap do the bounds checking
`ON ERR GO TO` around a random DRAW or CIRCLE is shorter than testing every
endpoint: an off-screen draw jumps to the handler, which picks new values.
`ON ERR CONTINUE` resumes at the failed statement, so the handler can fix the
inputs and retry. `[Aker p59–62]`

### 28. …but it also swallows BREAK
With a trap armed, BREAK and STOP are errors too, and BREAK is ignored outright
while a handler is running. Provide an exit (a key test that runs
`ON ERR RESET: STOP`) before testing a trapped loop. `[Aker p60; ROM $200F]`

### 29. Find out what failed
Inside the handler, `PEEK 23739` (ERRT) is the report code, and
`PEEK 23736+256*PEEK 23737` (ERRC) with `PEEK 23738` (ERRS) give the line and
statement. Aker doesn't cover these. `[library ts2068_system_variables.md:
ERRT $5CBB, ERRC $5CB8, ERRS $5CBA]`

---

## Sound (AY-3-8912)

### 30. Set up first, enable last
Load tone (R0–R5) and volume (R8–R10) before writing R7. Registers keep their
old values, so enabling first replays the previous note for an instant.
`[Aker p150–151]`

### 31. Same pitch twice = one long note
Re-writing an unchanged tone register doesn't retrigger anything. To separate
two equal notes, disable the channel in R7 briefly between them. `[Aker p152]`

### 32. R7 is "subtract to enable"
Start from 63 and subtract 1/2/4 (tone A/B/C) and 8/16/32 (noise A/B/C).
`SOUND 7,63` silences everything. The ROM itself writes `$FF` to R7 when a
program ends. Keep bit 6 clear (values ≤ 63) if you'll read the joysticks: the
Technical Manual requires it for port A input. Whether STICK fails with bit 6
set is (unverified). `[Aker p144; ROM $0EC8]`

### 33. Envelope: volume 16, period R11/R12, shape R13
Shape bits: 8 continue, 4 attack, 2 alternate, 1 hold. Without 8 the envelope
runs once and goes silent. All enveloped channels share one shape and period,
but each keeps its own pitch. `[Aker p155–161]`

### 34. Tuning numbers: Aker's table is an octave high
**Corrected:** the PSG runs at 1.76475 MHz and f = 1,764,750 / (16 × N).
Aker's "middle C" N = 209 is about 528 Hz (C5). For true middle C use coarse 1,
fine 166 (N = 422). BEEP 0, by contrast, *is* middle C. `[Aker p145, p223;
Technical Manual §2.1.6]`

---

## Not from Aker — candidates to add next (unverified)

Classic Sinclair BASIC optimisations that Aker doesn't cover. They apply to the
Spectrum ROM the 2068 inherits, but they **haven't yet been checked in the 2068
ROM**:

- GO TO and GO SUB search for the target line from the start of the program,
  so frequently called subroutines run faster at low line numbers.
- Every numeric literal is stored as its digits plus a hidden 6 bytes (`$0E` +
  5-byte float), so a constant used often is cheaper as a variable
  (`LET z=0`), and `NOT PI` / `SGN PI` / `VAL "…"` are the traditional
  memory-saving spellings of 0, 1 and long constants.
- Variables are found by a linear search of the variables area, so variables
  created first are found fastest.
