# ADL ASC 003 — 40 Column Mode Support (Timex, 1983–84)

A transcription of **Timex Application Development Library (ADL) Application
Software Component 003, "40-Column Mode"**: version 001, author Carol
Corcoran, dated 12/19/83. It has two parts, both transcribed here:

- the typed documentation (15 pages): services, parameters, status codes and
  usage notes;
- the assembler listing (45 pages) of the source file `IO40.SRC`, which
  `INCLUDE`s `CHST80.SRC`, the character set shared with ASC 002. It was
  assembled with CRZ80/11 version 10.36.14, and the listing is dated
  9-Jan-84 12:18:14.

It is a relocatable Z80 module (`INTERN` entry points, addresses marked `'`)
of 08A9h (2,217) bytes. It puts 40 columns of text on the **ordinary
256-pixel screen** by drawing 6-pixel-wide characters in software. It changes
no video hardware and does no port I/O. A line actually holds 42 positions:
`MARGIN` = 1 (the default) centres 40 columns, and `MARGIN` = 0 with
`LINLEN` = 42 gives all 42.

The services are:

- initialize (`INIT40`)
- clear screen and scroll, by line range
- set cursor, get cursor
- write character, write string (string named in `PARAM$`)
- get character, get attribute
- a 6-pixel character set, codes 20h–8Fh, including the 2×2 block graphics
  (80h–8Fh)

Colour, INVERSE and OVER are taken from the system variables `ATTR_P`,
`MASK_P` and `P_FLAG`, so BASIC's own PAPER, INK, INVERSE and OVER apply.
The documentation warns that a 6-pixel character crosses attribute-cell
boundaries: every four columns share three attribute bytes.

The module writes to whichever display file `VIDMOD` selects. With ASC 004
Dual Screen Mode Support (`../dual-screen-mode-support/`) it can therefore
write to the second display file. It does not itself open one.

| File | Contents |
|---|---|
| [`40-column-mode-support-docs.md`](40-column-mode-support-docs.md) | The documentation, PDF pages 1–15 |
| [`40-column-mode-support.md`](40-column-mode-support.md) | The listing, one section per scan page (PDF pages 16–60), with every line's address, object code, line number and source |
| [`build/`](build/) | The module assembled from the transcription at E000h, as a tape image and a raw binary (see [Builds](#builds-in-build)) |
| `README.md` | This file |
| [`NOTICE.md`](NOTICE.md) | Rights |

Source: the scan at
<https://archive.org/details/timex-computer-corp/40%20Column%20Mode>.

## Calling it from BASIC

Line 63 of the listing documents the module as loaded at **57344 (E000h)**.
The jump table and parameter block at its start give these addresses (from
listing lines 66–91):

| Address | Name | What it is |
|---|---|---|
| 57344 | `DATAB` | Character code for write character |
| 57345 | `WRCHRB` | USR: write character |
| 57348 | `WRSTRB` | USR: write string (string named in `PARAM$`, 23747) |
| 57351 / 57352 | `LINCOL` | Column (0–39) / line (0–23) for set cursor |
| 57353 | `SETCUB` | USR: set cursor |
| 57356 / 57357 | `CLRCTL` | Starting line / line count for clear screen |
| 57358 | `CLRSCB` | USR: clear screen |
| 57369 / 57370 | `GETCTL` | Column / line for the 'get' routines |
| 57371 | `GTCHRB` | USR: get character |
| 57374 | `GETATB` | USR: get attribute |
| 57377 | `GETCUB` | USR: get cursor position |
| 57381 | `INIT4B` | USR: initialize 40-column mode |
| 57384 / 57385 | `SCRCTL` | Starting line / line count for scroll |
| 57386 | `SCRLB` | USR: scroll |

57361–57368 and 57380 are spare (`SPARE0`–`SPARE4`, "not used (alignment
only)"). Every other entry is at the same address as in ASC 002, where those
spare slots hold its attribute, mask and video-mode entries. Status comes back in BC, as the documentation
describes: 0 for success, other values for errors and "screen full".

The documentation also says:

- the module can sit anywhere in chunks 4–7;
- chunks 0–3 and 7 of the Home bank must be enabled;
- IY must hold 5C3Ah.

## Sections of the listing

| PDF pages | Listing pages | Section (page header) | Lines |
|---|---|---|---|
| 16–17 | 1–2 | Definitions (title banner, `INTERN` list, EQUs, system variables) | 1–53 |
| 18 | 3 | Inputs and entries: the BASIC jump table and parameter block, with decimal addresses | 55–91 |
| 19 | 4 | Other variables | 93–119 |
| 20–23 | 5 – 5-3 | Write character | 121–312 |
| 24 | 6 | Write string | 314–358 |
| 25 | 7 | Position control | 360–371 |
| 26–28 | 8 – 8-2 | Scroll | 373–505 |
| 29–30 | 9 – 9-1 | Clear screen | 507–607 |
| 31–33 | 10 – 10-2 | 'Get' routines | 609–757 |
| 34 | 11 | Initialize 40-col. mode | 759–801 |
| 35–39 | 12 – 12-4 | Internal subroutines (`INCLUDE CHST80` at line 1047) | 803–1062 |
| 40–59 | 12-5 – 12-24 | Character set for 40/80 col. modes (`CHST80.SRC`) | 1063–2066 (`END`) |
| 60 | S-1 | Symbol table ("No errors detected") | — |

## ROM and system addresses it uses, checked against this library

| Listing symbol | Value | Library |
|---|---|---|
| `RECLEN` "routine in HOME ROM" | `1720` | Dispatcher entry `$1720` (`../../disassemblies/2068_DEFS.ASM`) |
| `VARS`, `UDG`, `COORDS`, `ATTR_P`, `MASK_P`, `P_FLAG`, `VIDMOD`, `PARAM$` | `5C4B`, `5C7B`, `5C7D`, `5C8D`, `5C8E`, `5C91`, `5CC2`, `5CC3` | System variables, as in `../ts2068_system_variables.md` |

Unlike ASC 002 and ASC 004, this module does not call the EXROM and touches
no ports.

## How to read the transcription

The two files follow the same conventions as `../dual-screen-mode-support/`.

Each listing page starts with
`<!-- PDF page N — listing "Page X" — SECTION — IO40.SRC -->` and holds one
`text` block:

```text
LOC    OBJ            LINE  SOURCE
0001'  C3 0040'          67  WRCHRB: JP      WRCH0           ; ENTRY TO WRITE CHARACTER     57345
```

- **LOC:** the module-relative address. `'` means relocatable; `=XXXX` is an
  EQU value.
- **OBJ:** the object bytes as printed. A 16-bit operand is printed as one
  word, high byte first (`0040'` is the bytes `40 00`).
- **SOURCE:** re-spaced to fixed columns (label 0, opcode 8, operand 16,
  comment 32). The printout uses a few different column layouts, and each
  page's notes say where. Wording, case and spelling are as printed.
- The `LOC OBJ LINE SOURCE` header row is not printed on the original; it was
  added as a guide.
- Uncertain readings are listed after each block as `> *Uncertain:* …`, never
  inside it, so the blocks stay machine-readable. There are four
  such notes, all minor: a faint dash and a speck in comments, `NC` versus
  `NG` in `JR NC,UPDAT3` (line 980, settled by the opcode byte `30`), and letter O
  versus zero in `CALCPO` in the symbol table.

The documentation pages each start with
`<!-- PDF page N (printed page "Page N") -->`. Tables are given as Markdown
tables, and the transcriber's notes say where the layout differs.

**Unprinted line numbers.** Eleven line numbers never appear: 22, 54, 92,
120, 313, 359, 372, 506, 608, 758 and 802. Each falls just before a page's
opening `SUBTTL`, so they are the assembler's page-eject lines, not lost
text.

**Marks on the scans.** A pen stroke runs through the `4` of `57406` on
line 118. A hand-drawn pen arc runs beside the address and object-code
columns on PDF pages 52–54. Thin curved strokes on pages 48–51 look like a
hair on the scanner glass. None of them hides a character, and there is no
handwritten text.

## Verification

The listing was checked by machine:

- **Object code against source:** all 749 instructions were disassembled
  from their printed bytes (z80dis) and compared with the printed mnemonic
  and register operands. No mismatches.
- **Address chain:** for every line, LOC plus its byte count equals the next
  LOC, from `0000'` to the last byte at `08A8'`. No breaks.
- **Labels against the assembler's symbol table** (PDF page 60): all 150
  labels and EQUs have the value the symbol table gives them.
- **Jump and call targets:** all 127 symbolic `JR`, `JP`, `CALL` and `DJNZ`
  targets decode to the address of the label named in the source.
- **Character set:** every `DEFB` byte matches its binary operand. The
  896 bytes of font data (codes 20h–8Fh) are byte-for-byte identical to the
  same `CHST80.SRC` data in the ASC 002 listing, which was transcribed
  separately. That is an independent check on both.

The checks found one misreading in the page markers, `ID40.SRC` for
`IO40.SRC`, which was corrected against the scan.

## Running it

The object code was relocated to E000h (140 relocatable words) and run in the
same TS2068 emulation used for ASC 004: stock HOME ROM and EXROM, 48K RAM,
HSR/DECR bank switching, 60 Hz IM1 interrupts. The relocator was checked first
by rebuilding the ASC 004 image, which came out byte-for-byte identical. Each
test was a BASIC program run on a freshly booted machine. The screen was read
back by matching each 6×8 cell against the module's own font, so output was
checked character by character, not just by eye.

Every BASIC entry point was exercised, and everything works as the
documentation says:

- **Write string** wraps at column 40. A missing string returns 2 and an empty
  string returns 0.
- **Set cursor** accepts column 39 and line 23. It returns 1 for column 40 or
  line 24.
- **Write character** returns 1 for codes 31 and 165. It draws the block
  graphics (80h–8Fh) and the UDGs (90h–A4h).
- **Get character** returns the code at a position: letters, block graphics
  and UDGs, normal or inverse. An inverse space reads back as 143. **Get
  attribute** and **get cursor** return the documented values.
- BASIC's PAPER, INK, INVERSE and OVER are honoured. A character that
  straddles attribute cells colours part of its neighbour, as the
  documentation warns.
- **Clear** and **scroll** work on any line range. A count of 0, or a range
  past line 23, returns 1.
- **Automatic scrolling** works as described:
  - At the defaults, writing a long string stops after exactly 960 characters
    (24 × 40) and returns 3, with the remaining count in `STRGCT`.
  - With the usage section's suggested settings (`BOTLN` 21, `SCRCTL` 1/21)
    and a larger `SCRLCT`, it scrolls lines 1–21 and keeps writing.
- **Margins:** `MARGIN` 0 with `LINLEN` 42 gives 42 columns from the left
  edge. (`MARGIN` 1 with `LINLEN` 42, which the documentation rules out,
  splits the 42nd character across the edge onto the next line.)
- **Second display file:** with ASC 004 relocated to D000h and its output set
  to screen 2, all of this module's output went to screen 2 and screen 1 was
  untouched.

### Bugs found by running it

All three are in code this module shares with ASC 004, and they behave as
they do there (`../dual-screen-mode-support/`).

- **CLRSCN and SCROLL miss 8-bit overflow.** Both check `first + count` with
  `ADD A,C / CP 1 / CP 25` and no carry test (lines 386–390 and 518–522). A
  first line of 250 with a count of 10 sums to 4 and passes. With that input:
  - CLRSCN overwrote the system variables, BASIC's workspace and 959 of the
    module's 2,153 code bytes, and BASIC stopped with report 4;
  - SCROLL also stopped BASIC with report 4.

  A first line of 255 with a count of 1 sums to 0 and is rejected correctly.
- **Automatic scroll uses `SCRCTL` unchecked.** When the scroll count allows
  it, write character jumps straight to `SCRL0` with whatever is in `SCRCTL`
  (`TVFUL1`, lines 309–312). With a count of 0 it overwrote the module's code,
  and BASIC stopped with report 1. A range past line 23 (20/10) and the
  overflow case (250/10) each stopped BASIC with report 4.
- **SCROLL accepts a first line of 0.** The documentation gives 1–23, but the
  code checks only the sum. Scrolling moves each line into the one above, and
  the top block is moved with `HL−720h` (line 486), eight pixel rows, 100h
  apart. The results depend on the display file:
  - **Screen 1:** the destination is ROM (38E0h onwards), so the writes are
    lost. Line 0 simply drops off, which is harmless.
  - **Screen 2:** the writes land at 58E0h, 59E0h … 5FE0h. In the test they
    changed two of screen 1's attribute rows, the end of the printer buffer
    and the reserved area at 5CE0h–5EF6h, which includes the start of the
    SYSCON table at 5EEAh. It still returned 0, and BASIC kept running.

Nothing else misbehaved. Loading from tape and real hardware have not been
tested; the emulation placed the code in memory directly.

### Builds in `build/`

| File | What it is |
|---|---|
| `col40.tap` | The original module, relocated to E000h (57344) from the transcription's object code: `LOAD "col40" CODE 57344`. 2,217 bytes, E000h–E8A8h; md5 of the code `b63bf92dcc02b8e4f67e9d72be605aea`. Use `CLEAR 57343` first. |
| `col40_E000.bin` | The same code as a raw binary. |
| `col40-patched.tap` | The same, with the three bugs fixed: 2,268 bytes, E000h–E8DBh; md5 of the code `a7f90ef1a472019f07f8f2305aec3c88`. Same header name, so the same `LOAD "col40" CODE 57344` loads either. The fixes are absolute, so this build runs only at E000h. |
| `col40_E000_patched.bin` | The patched code as a raw binary. |
| `patch.py` | Builds the patched image from the original (`python3 patch.py 40` beside `col40_E000.bin`). It checks the original bytes at every patch site before changing them, then lists the new code. It covers ASC 002 and ASC 003. |

The patch changes three instruction sites. Each is replaced by a jump, with NOPs over the rest of the
replaced bytes, to checking code appended at E8A9h:

| Site | Was | Now |
|---|---|---|
| `E1AB` SCROLL (line 386) | `ADD A,C / CP 1 / JP C,INVPAR` | `JP CHKSCR`: carry test, first + count ≤ 24, first line ≠ 0 |
| `E258` CLRSCN (line 518) | `ADD A,C / CP 1 / JP C,INVPAR` | `JP CHKCLR`: carry test, first + count ≤ 24 |
| `E166` automatic scroll (line 312) | `JP SCRL0` | `JP CHKAUTO`: check `SCRCTL` as SCROLL does; if it is invalid, take the existing "screen full" exit (BC = 3, `SCRLCT` reset to 1) |

The patched build was put through every test above.
- **Valid input:** every case gave results identical to the original's.
- **Bad input:** every failure case now returns 1, or 3 for a bad `SCRCTL`
  during automatic scroll. In each one BASIC keeps running and the module's
  code is unchanged. Those cases are the overflowing clear and scroll ranges,
  scroll from line 0 (on either screen), and a `SCRCTL` with a count of 0, a
  first line of 0, a range past line 23 or an overflow.

One deliberate change: on screen 1, scroll from line 0 used to drop the top
line harmlessly. It now returns 1, matching the documented range of 1–23.

## Inconsistencies in the original

These are left as printed:

- Documentation page 5 (SETCUR) is headed "ASC Number: 002"; every other page
  says 003.
- The CLRSCN service page names its BASIC parameter area `CLSCTL`. The
  BASIC-parameter table (page 13) and the listing call it `CLRCTL`.
- `SCRCTL`, the scroll parameter, is missing from the BASIC-parameter table on
  page 13. It is listed with the internal variables on page 12 instead.
- The SCROLL page (page 8) gives the starting line as 1–23, but its error
  condition reads "Line Number + Line Count < 1 or > 24", the wording used for
  CLRSCN, whose lines run 0–23.

## Rights

See [NOTICE.md](NOTICE.md).
