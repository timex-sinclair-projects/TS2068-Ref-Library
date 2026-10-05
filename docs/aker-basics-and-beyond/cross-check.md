# Aker (1985) cross-checked against the library and the stock ROM

Checked against `docs/` and `disassemblies/ts2068_home_rom_U16_stock.txt`
(stock `TS2068_U16.BIN`). Page numbers are Aker's printed pages.

## 1. Contradictions — the ROM or library says otherwise

| # | Aker says | What the ROM / library shows | Evidence |
|---|-----------|------------------------------|----------|
| C1 | `NOT a<b` is `(NOT a)<b`; NOT binds only to the operand on its right (p132) | **Wrong.** NOT is stacked with priority 4 (`LD BC,$04F0` at HOME $2AB0); every comparison operator has priority 5 in `OPPRI` ($2B6E). Comparisons therefore bind tighter: `NOT a<b` = `NOT (a<b)`. Same as the Spectrum. | HOME $2AA6–$2AB3, `OPPRI` |
| C2 | Non-integer PLOT, PRINT AT, TAB, INK arguments are INTed / rounded down (p78, p90) | **Rounded to nearest**, not truncated. PLOT, PRINT AT (`CP $AC` → `CALL $2660` at $21A4), POINT, ATTR, DRAW and STICK all go through `GET_XY` → `FP2A` → `FP2BC`, which adds 0.5 and takes INT. So `PLOT 10.6,0` plots x = 11. | `FP2BC` $3160–$316A |
| C3 | A letter already used as a simple numeric variable cannot be a FOR control variable (p10) | **Wrong.** FOR assigns the start value, then tests bit 7 of the variable's name byte; if it isn't already a loop variable it sets the bit and `INSERT`s 13 bytes, converting the existing simple variable in place. | FOR, HOME $1C95–$1CA7 |
| C4 | There are 20 user-definable graphics (p111) | **21** (A–U), 168 bytes, codes $90–$A4. | `ts2068_system_variables.md` (UDG), `ts2068_tokens_and_keyboard.md` |
| C5 | Table 9-2: fine-tune 209 = middle C … 104 = high C (p145) | With the 2068's PSG clock of 1.76475 MHz (Technical Manual §2.1.6), f = clock / (16 × N): 209 → 527.7 Hz, 124 → 889.5 Hz. That is **C5–C6, an octave above middle C**, and about 15–20 cents sharp. Middle C (261.6 Hz) needs N ≈ 422: coarse 1, fine 166. BEEP 0 *is* middle C, so Aker's BEEP and SOUND "middle C" are an octave apart. The values fit a 1.75 MHz clock exactly, which may be where they came from **(unverified)**. | `technical-manual/02-hardware-guide.md` |
| C6 | Attribute file for the 22-line area ends at 23232 (p176) | Off by one: 22528 + 704 − 1 = **23231**. The full 24-line file runs to 23295 ($5AFF). | `ts2068_memory_map.md` |

## 2. Book errors (internal, not ROM)

- p54 line note: GRAPHICS key code 15 is called "shifted 8". It is CAPS+9
  (`$0F` GRAPHICS, `ts2068_tokens_and_keyboard.md`); Aker's own body text on
  p53 says 9.
- p118: the contrasting-ink example uses INK 8 (transparent) where the text
  describes INK 9 (contrast).
- p202 renumber utility: it assumes every byte 13 is followed by a line number.
  A 13 can also occur inside a line's length bytes or a 5-byte number slug, so
  it can corrupt a program. Use the line-length field (bytes 2–3 of each line,
  `ts2068_tokens_and_keyboard.md`) to walk lines instead. It also leaves GO TO
  and GO SUB targets unchanged, which Aker does say.

## 3. Confirmed by the ROM or the library

| Aker claim | Confirmation |
|------------|--------------|
| PRINT AT and PLOT use the absolute value of negative coordinates (p6, p92) | `GET_XY` returns the sign separately in B/C; PLOT and PRINT AT ignore it. (Rounding happens first — see C2.) |
| The ROM switches sound off when a program ends (p146) | After every report the error/exit path writes R7 = `$FF` (HOME $0EC8–$0ECE). Aker's own idiom uses 63 (`$3F`); both disable all six tone/noise channels. |
| STICK argument order: first = what (1 direction / 2 fire), second = which stick (1 left / 2 right) (p184) | Matches the ROM ($2902–$2929) and corrects the misreading of the BASIC manual recorded in `ts2068_errata_and_notes.md`. |
| STICK values 1 up, 2 down, 4 left, 8 right, diagonals summed; fire 0/1 (p185–187) | Matches: R14 bits 0–3 complemented, fire = bit 7. **Library adds:** all four directions at once (15) is returned as 0. |
| AY register map, R7 enable bits, R13 shape bits, 16 = envelope mode (Ch. 9, App. C) | Matches `ts2068_tokens_and_keyboard.md`. **Library adds:** R14 is the joystick port, R15 has no pins, and SOUND accepts register numbers up to 16. |
| PAUSE and FRAMES count at 60 Hz (p13, p181) | FRAMES at $5C78–$5C7A, incremented at 60 Hz. |
| REPDEL 23561 = 35, REPPER 23562 = 5, in 60ths (p169) | Match `ts2068_system_variables.md`. |
| CHARS 23606 = 15360; character set at 15616 (p180) | $5C36 = $3C00; set at $3D00. |
| USR "a" = 65368 (p112) | UDG = $FF58 at power-on. |
| DF SZ 23659 defaults to 2 and is reset after each command (p172) | Set to 2 by NEW ($0DDB) and after each command ($0E28). |
| SCR CT 23692 is normally 1 after output (p170) | After each command the ROM sets SCRCT = $19 − S_POSN line ($0E7B–$0E81); on a normal screen that comes to 1. |
| ATTR P 23693 normally 56; attribute bit layout (p173–175) | Matches. |
| PROG 23635 (p202); line number stored high byte first | PROG = $5C53; line format matches. |
| ON ERR GO TO also traps BREAK, so a trapped loop can't be broken into (p60) | ERRLN bit 15 arms the trap; on error the ROM jumps to the ERRLN line; BREAK is ignored outright while the handler flag (bit 14) is set ($200F). |
| ON ERR CONTINUE resumes at the failing statement (p61) | Consistent: the ROM saves the failing line and statement in ERRC/ERRS ($0EA4–$0EAE) and CONTINUE clears the handler flag ($20A3). Exact resume point (retry vs. next statement) **(unverified)** — not traced. |
| CHR$ 9 = cursor right (p50) | `$09` Cursor Right. |
| FREE ≈ 38652 on an empty machine (p197) | FREE = RAMTOP − STKEND ($2939–$2945). With RAMTOP $FF57 and PROG $6856 that is about 38,650; the exact figure is **(unverified)**. |

## 4. What the library adds that Aker doesn't mention

- **ON ERR report variables**: after a trapped error, ERRT ($5CBB) holds the
  report code, ERRC ($5CB8) the line and ERRS ($5CBA) the statement, so a BASIC
  handler can PEEK what went wrong and where.
- **UDG relocation**: opening the second display file moves the UDGs down $0840
  bytes (to $F718), so `USR "a"` = 65368 holds only while VIDMOD = 0. Code that
  POKEs 65368 directly breaks in dual-screen modes; `USR "a"` does not.
- **FRAMES has a third byte** at 23674 (FRAMES2), incremented by the interrupt
  handler.

## 5. Open questions

- **STICK with R7 = `$FF`.** The Technical Manual says R7 bit 6 must be 0 to
  read port A, and the ROM's end-of-program write sets it to 1. STICK itself
  never touches R7 ($2902–$2929), and the ROM has no other write to `$F6`
  outside SOUND. So after any program ends, port A is configured as output.
  Whether STICK still reads the joysticks correctly in that state, or only
  after a `SOUND 7,n` with bit 6 clear (as Aker's 63 has), is
  **(unverified)**. Worth a hardware test.
- **PIP default 0** (p168): not checked against INIT.
- **The "middle C" tuning values** (C5): check the Timex user's manual
  Chapter 21 table to see whether the error originates there.
