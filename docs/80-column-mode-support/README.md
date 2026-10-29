# ADL ASC 002 — 80 Column Mode Support (Timex, 1983–84)

A transcription of **Timex Application Development Library (ADL) Application
Software Component 002, "80-Column Mode"**: version 001, by C. Corcoran and
D. Boyle, dated 12/16/83. It has two parts, both transcribed here:

- the typed documentation (17 pages): services, parameters, status codes and
  usage notes;
- the assembler listing (47 pages) of the source file `IO80.SRC`, which
  `INCLUDE`s `CHST80.SRC`, the character set shared with ASC 003. It was
  assembled with CRZ80/11 version 10.36.14, and the listing is dated
  3-Jan-84 19:10:4.

It is a relocatable Z80 module (`INTERN` entry points, addresses marked `'`)
of 08FEh (2,302) bytes. It drives the TS2068's **64-column hardware mode**
(512 dots per line), but draws 6-dot-wide characters in software, which
gives 80 columns. A line actually holds 85 positions. `MARGIN` = 1 (the
default) centres 80 columns, 0 starts at the left edge and 2 ends at the
right. `MARGIN` = 0 with `LINLEN` = 85 gives all 85.

The services are:

- set video mode (`SETMODE`): 0 = normal, 8 = 80-column. This opens or
  closes the second display file through the EXROM's CHNG_VID routine,
  after checking there is room.
- clear screen and scroll, by line range
- set cursor, get cursor
- set attributes (`SETATT`): the ink colour, with paper as its complement.
  Only valid while the second display file is open.
- set mask (`SETMSK`): INVERSE and OVER
- write character, write string (string named in `PARAM$`)
- get character, get attribute
- a 6-dot character set, codes 20h–8Fh, including the 2×2 block graphics
  (80h–8Fh)

| File | Contents |
|---|---|
| [`80-column-mode-support-docs.md`](80-column-mode-support-docs.md) | The documentation, PDF pages 1–17 |
| [`80-column-mode-support.md`](80-column-mode-support.md) | The listing, one section per scan page (PDF pages 18–64), with every line's address, object code, line number and source |
| [`build/`](build/) | The module assembled from the transcription at E000h, as a tape image and a raw binary (see [Builds](#builds-in-build)) |
| `README.md` | This file |
| [`NOTICE.md`](NOTICE.md) | Rights |

Source: the scan at
<https://archive.org/details/timex-computer-corp/80%20Column%20Mode%20Support>.

## Calling it from BASIC

Line 73 of the listing documents the module as loaded at **57344 (E000h)**.
The jump table and parameter block at its start give these addresses (from
listing lines 76–114):

| Address | Name | What it is |
|---|---|---|
| 57344 | `DATAB` | Character code for write character |
| 57345 | `WRCHRB` | USR: write character |
| 57348 | `WRSTRB` | USR: write string (string named in `PARAM$`, 23747) |
| 57351 / 57352 | `LINCOL` | Column (0–79) / line (0–23) for set cursor |
| 57353 | `SETCUB` | USR: set cursor |
| 57356 / 57357 | `CLRCTL` | Starting line / line count for clear screen |
| 57358 | `CLRSCB` | USR: clear screen |
| 57361 | `ATTCTL` | Attribute byte (bits 0–2 ink) |
| 57362 | `SETATB` | USR: set attributes |
| 57365 | `MSKCTL` | Mask: bit 2 INVERSE, bit 0 OVER |
| 57366 | `SETMSB` | USR: set mask |
| 57369 / 57370 | `GETCTL` | Column / line for the 'get' routines |
| 57371 | `GTCHRB` | USR: get character |
| 57374 | `GETATB` | USR: get attribute |
| 57377 | `GETCUB` | USR: get cursor position |
| 57380 | `VIMODE` | Video mode: 0 normal, 8 80-column |
| 57381 | `SETMDB` | USR: set video mode |
| 57384 / 57385 | `SCRCTL` | Starting line / line count for scroll |
| 57386 | `SCRLB` | USR: scroll |

Every entry that ASC 003 also has sits at the same address there. Status
comes back in BC, as the documentation describes: 0 for success, other
values for errors, "no room" and "screen full".

The documentation also says:

- the module can sit anywhere in chunks 4–7;
- chunks 0–3 and 7 of the Home bank must be enabled;
- IY must hold 5C3Ah;
- SETMODE cannot run from a cartridge, because enabling the EXROM disables
  the Dock bank;
- before SAVEing a BASIC program that uses the module, set mode 0, so that
  the system variables match a machine with the second display file closed.

## Sections of the listing

| PDF pages | Listing pages | Section (page header) | Lines |
|---|---|---|---|
| 18–19 | 1–2 | Definitions (title banner, `INTERN` list, EQUs, ROM addresses, system variables, relocation constants) | 1–63 |
| 20 | 3 | Inputs and entries: the BASIC jump table and parameter block, with decimal addresses | 65–114 |
| 21 | 4 | Other variables | 116–141 |
| 22–25 | 5 – 5-3 | Write character | 143–339 |
| 26–27 | 6 – 6-1 | Write string | 341–405 |
| 28 | 7 | Position control | 407–418 |
| 29–31 | 8 – 8-2 | Scroll | 420–549 |
| 32–33 | 9 – 9-1 | Clear screen | 551–641 |
| 34 | 10 | Attribute control (set attributes, set mask) | 643–683 |
| 35–37 | 11 – 11-2 | 'Get' routines | 685–824 |
| 38–39 | 12 – 12-1 | Video mode control | 826–918 |
| 40–43 | 13 – 13-3 | Internal subroutines (`INCLUDE CHST80` at line 1119) | 920–1127 |
| 44–63 | 13-4 – 13-23 | Character set for 40/80 col. modes (`CHST80.SRC`) | 1128–2138 (`END`) |
| 64 | S-1 | Symbol table ("No errors detected") | — |

## ROM, port and system addresses it uses, checked against this library

Every value below agrees with the library:

| Listing symbol | Value | Library |
|---|---|---|
| `CHNGVID` "routine in ROM extension" | `0E8E` | EXROM CHNG_VID (CHG_V) at `$0E8E` (`../ts2068_memory_map.md`) |
| `RECLEN` "routine in HOME ROM" | `1720` | Dispatcher entry `$1720` (`../../disassemblies/2068_DEFS.ASM`) |
| `FIXTBL` | `1D00` | EXROM relocation fix table at `$1D00` |
| `INSERTSZ` = 7B00H−DRIVES | `12C0` | CHNG_VID opens `$12C0` bytes at `$6840` |
| `MOVESZ`, `DEST7`, `FIX` | `0840`, `F7C0`, `97C0` | OPEN-DFILE moves `$6000–$683F` to `$F7C0`, offset `+$97C0` |
| `HREXPT` "home ROM ext. select port (bit 7)", `DKHSPT` "dock horizontal select port" | `FF`, `F4` | DECR port `$FF` bit 7; HSR port `$F4` |
| Hardware mode written by SETMODE / SETATT (`LD A,6`, "set H/W to 64-col. mode"; `OR 6`) | `6` | DECR D2–D0 = `110`, 64-column mode (`../ts2068_video_and_cartridges.md`) |
| Ink selection shifted left three bits by SETATT ("shift to H/W position") | D5–D3 | DECR D5–D3, ink/paper colour for 64-column mode |
| `VARS`, `STKEND`, `UDG`, `COORDS`, `RAMTOP`, `PRAMT`, `VIDMOD`, `PARAM$` | `5C4B`, `5C65`, `5C7B`, `5C7D`, `5CB2`, `5CB4`, `5CC2`, `5CC3` | System variables, as in `../ts2068_system_variables.md` |

To call CHNG_VID, `ENBLEXT` (line 968) sets DECR bit 7 and writes 3 to the
HSR, which puts the EXROM in chunks 0 and 1. `ENBLHOME` (line 977) writes 0
to the HSR and clears DECR bits 7 and 6. Like the stock ROMs, both read DECR
back with `IN` before changing it.

## How to read the transcription

The two files follow the same conventions as `../dual-screen-mode-support/`.

Each listing page starts with
`<!-- PDF page N — listing "Page X" — SECTION — IO80.SRC -->` and holds one
`text` block:

```text
LOC    OBJ            LINE  SOURCE
0025'  C3 03F1'         110  SETMDB: JP       STMDB0         ; ENTRY TO SET VIDEO MODE      57381
```

- **LOC:** the module-relative address. `'` means relocatable; `=XXXX` is an
  EQU value.
- **OBJ:** the object bytes as printed. A 16-bit operand is printed as one
  word, high byte first (`03F1'` is the bytes `F1 03`).
- **SOURCE:** re-spaced to fixed columns (label 0, opcode 8, operand 16,
  comment 32). The printout uses a few different column layouts, and each
  page's notes say where. Wording, case and spelling are as printed.
- The `LOC OBJ LINE SOURCE` header row is not printed on the original; it was
  added as a guide.
- Uncertain readings are listed after each block as `> *Uncertain:* …`, never
  inside it, so the blocks stay machine-readable. Most are zero-versus-letter-O
  calls in labels such as `SCRLB0` and `CLRSC0`, read by glyph shape. The
  others are a possible speck, the glyph for code 27h in the font, and two
  symbol-table names (`CALCPO`, `ENBLHO`).

The documentation pages each start with
`<!-- PDF page N (printed page "Page N") -->`. Tables are given as Markdown
tables, and the transcriber's notes say where the layout differs.

**Unprinted line numbers.** Twelve line numbers never appear: 21, 64, 115,
142, 340, 406, 419, 550, 642, 684, 825 and 919. Each falls just before a
page's opening `SUBTTL`, so they are the assembler's page-eject lines, not
lost text.

There is no handwriting on any page.

## Verification

The listing was checked by machine:

- **Object code against source:** all 799 instructions were disassembled
  from their printed bytes (z80dis) and compared with the printed mnemonic
  and register operands. No mismatches.
- **Address chain:** for every line, LOC plus its byte count equals the next
  LOC, from `0000'` to the last byte at `08FD'`. No breaks.
- **Labels against the assembler's symbol table** (PDF page 64): all 167
  labels and EQUs have the value the symbol table gives them.
- **Jump and call targets:** all 138 symbolic `JR`, `JP`, `CALL` and `DJNZ`
  targets decode to the address of the label named in the source.
- **Character set:** every `DEFB` byte matches its binary operand. The
  896 bytes of font data (codes 20h–8Fh) are byte-for-byte identical to the
  same `CHST80.SRC` data in the ASC 003 listing, which was transcribed
  separately. That is an independent check on both.

## Running it

The object code was relocated to E000h (138 relocatable words) and run in the
same TS2068 emulation used for ASC 004: stock HOME ROM and EXROM, 48K RAM,
HSR/DECR bank switching, 60 Hz IM1 interrupts. The emulation also draws the
64-column mode, taking even 8-dot columns from screen 1 and odd ones from
screen 2. The relocator was checked first by rebuilding the ASC 004 image,
which came out byte-for-byte identical. Each test was a BASIC program run on a
freshly booted machine. The 512-dot screen was read back by matching each
6×8 cell against the module's own font, so output was checked character by
character.

Every BASIC entry point was exercised, and everything works as the
documentation says, apart from the bugs below:

- **Set mode 8** opens the second display file through CHNG_VID and switches
  the hardware to DECR mode `06`. VIDMOD becomes 46h. Channels move to 7B00h,
  and the UDGs and machine stack move up to F7xxh–F9xxh, as
  `../ts2068_video_and_cartridges.md` describes. RAMTOP is unchanged.
- **Mode 0** closes it again, after which BASIC's PRINT works normally.
- **Bad modes:** 5, 6 and 128 return 1.
- **Repeated modes:** setting 8 twice, or 0 when already 0, returns 0.
- **Not enough memory:** with 6,015 bytes free (6,912 needed), mode 8 returns
  2 and leaves the screen alone.
- **Write string** wraps at column 80. With `MARGIN` 1 the text starts 16 dots
  in, centred.
- **Set cursor** accepts column 79 and line 23. It returns 1 for column 80 or
  line 24.
- **Write character** returns 1 for codes 31 and 165. It draws the block
  graphics and UDGs.
- **Get character** and **get cursor** return the documented values.
- **Set attributes** with ink 1 sets DECR's colour bits to 001 (blue ink on
  yellow paper). With the second display file closed it returns 1.
- **Set mask:** 4 gives inverse and 1 gives OVER. An inverse letter reads back
  as itself.
- **Margins:** `MARGIN` 0 with `LINLEN` 85 gives 85 columns from the left
  edge. `MARGIN` 2 puts the 80 columns hard against the right edge.
- **Clear** and **scroll** work on any line range. A count of 0, or a range
  past line 23, returns 1.
- **Automatic scrolling** works as described:
  - At the defaults, writing a long string stops after exactly 1,920
    characters (24 × 80) and returns 3, with the remaining count in
    `STRGCT`.
  - With `BOTLN` 21, `SCRCTL` 1/21 and a larger `SCRLCT`, it scrolls lines
    1–21.

Not a bug, but worth knowing: BASIC's own PRINT and reports still write only
to screen 1 in the old 8-pixel layout. In 80-column mode screen 1 supplies
only the even 8-dot columns, so "0 OK" comes out spread across alternate
columns at the bottom of the screen.

### Bugs found by running it

The first three are in code this module shares with ASC 004
(`../dual-screen-mode-support/`) and ASC 003. The fourth is its own.

- **CLRSCN and SCROLL miss 8-bit overflow.** Both check `first + count` with
  `ADD A,C / CP 1 / CP 25` and no carry test (lines 430–437 and 559–566). A
  first line of 250 with a count of 10 sums to 4 and passes. With that input:
  - CLRSCN overwrote the system variables (VIDMOD read 0 while the screen was
    still in 80-column mode), BASIC's workspace and 621 of the module's 2,238
    code bytes, and BASIC stopped with report 4;
  - SCROLL overwrote the module's code too, and BASIC stopped with report 1.
- **Automatic scroll uses `SCRCTL` unchecked** (`TVFUL1`, lines 335–338).
  - A count of 0 overwrote the module's code, and BASIC stopped with report 1.
  - A range past line 23 (20/10) stopped BASIC with report 4.
  - The overflow case (250/10) stopped BASIC with report 1.
- **SCROLL accepts a first line of 0.** The documentation gives 1–23. The top
  block is moved with `HL−720h` (line 522) in both display files. For screen 1
  that lands in ROM and is lost. For screen 2 it lands at 58E0h, 59E0h …
  5FE0h. In 80-column mode screen 1's attributes are not displayed, so
  nothing shows at the time. But after returning to mode 0:
  - two rows of screen 1's colours (lines 7 and 15) were wrong, with 63 of
    their 64 bytes changed;
  - the end of the printer buffer had changed;
  - so had the reserved area at 5CE1h–5EF6h, which includes the start of the
    SYSCON table at 5EEAh.

  It returned 0, and BASIC kept running.
- **SETATT stores the wrong attribute byte.** The screen colour is set
  correctly; the fault is in what get attribute reports afterwards. SETATT
  computes the paper as the complement of the shifted ink (`CPL`, line 670),
  then `OR`s in the ink without masking the other bits (lines 669–672). After
  set attributes with ink *n*, get attribute returns 255 − 8*n*: 255 for ink 0,
  247 for ink 1, down to 199 for ink 7. That is FLASH and BRIGHT set and ink
  always 7. The documented value is the ordinary attribute byte, (7 − *n*) × 8
  + *n*. SETMODE builds it correctly (lines 899–906), and get attribute
  returns 56 straight after mode 8. An `AND 38H` after the `CPL` would fix it.

Loading from tape, `SAVE` (the documentation's advice to return to mode 0
first) and real hardware have not been tested; the emulation placed the code
in memory directly.

### Builds in `build/`

| File | What it is |
|---|---|
| `col80.tap` | The original module, relocated to E000h (57344) from the transcription's object code: `LOAD "col80" CODE 57344`. 2,302 bytes, E000h–E8FDh; md5 of the code `dbc1036ac1f12c64efb985841626cc82`. Use `CLEAR 57343` first. |
| `col80_E000.bin` | The same code as a raw binary. |
| `col80-patched.tap` | The same, with the four bugs fixed: 2,363 bytes, E000h–E93Ah; md5 of the code `b87d28e5e7c85d49f9e924834df20136`. Same header name, so the same `LOAD "col80" CODE 57344` loads either. The fixes are absolute, so this build runs only at E000h. |
| `col80_E000_patched.bin` | The patched code as a raw binary. |
| `patch.py` | Builds the patched image from the original (`python3 patch.py 80` beside `col80_E000.bin`). It checks the original bytes at every patch site before changing them, then lists the new code. It covers ASC 002 and ASC 003. |

The patch changes four instruction sites. Each is replaced by a jump, with NOPs over the rest of the
replaced bytes, to checking code appended at E8FEh:

| Site | Was | Now |
|---|---|---|
| `E1D3` SCROLL (line 433) | `ADD A,C / CP 1 / JP C,INVPAR` | `JP CHKSCR`: carry test, first + count ≤ 24, first line ≠ 0 |
| `E281` CLRSCN (line 562) | `ADD A,C / CP 1 / JP C,INVPAR` | `JP CHKCLR`: carry test, first + count ≤ 24 |
| `E16E` automatic scroll (line 338) | `JP SCRL0` | `JP CHKAUTO`: check `SCRCTL` as SCROLL does; if it is invalid, take the existing "screen full" exit (BC = 3, `SCRLCT` reset to 1) |
| `E315` SETATT (lines 670–672) | `CPL / OR C / LD (ATTBYT),A` | `JP FIXATT`: `CPL / AND 38H / OR C / LD (ATTBYT),A`, then back to `GOODRET` |

The patched build was put through every test above.
- **Valid input:** every case gave results identical to the original's.
- **Bad input:** every failure case now returns 1, or 3 for a bad `SCRCTL`
  during automatic scroll. In each one BASIC keeps running and the module's
  code is unchanged. Those cases are the overflowing clear and scroll ranges,
  scroll from line 0 (on either screen), and a `SCRCTL` with a count of 0, a
  first line of 0, a range past line 23 or an overflow.

One deliberate change: on screen 1, scroll from line 0 used to drop the top
line harmlessly. It now returns 1, matching the documented range of 1–23.

With the SETATT fix, get attribute after set attributes returns 56, 49, 42 …
7 for inks 0–7, as documented.

## Inconsistencies in the original

These are left as printed:

- "paramters" in the SETMSK page's Name line (page 7).
- The CLRSCN page (page 4) names its BASIC parameter area `CLSCTL`. The
  BASIC-parameter table (page 15) and the listing call it `CLRCTL`.
- The documentation calls the write-character service `WRCHR`; the listing's
  `INTERN` line declares `WRCHAR`.
- The system variable is `VIDMOD`; the module's BASIC parameter is `VIMODE`.
  Both spellings are correct as names, but they are easy to confuse.
- The SCROLL page (page 10) gives the starting line as 1–23, but its error
  condition reads "Line Number + Line Count < 1 or > 24", the wording used for
  CLRSCN, whose lines run 0–23.
- The GETATT page (page 12) says it takes a position in `GETCTL` and returns 1
  for invalid parameters. The code (lines 795–806) ignores the position, since
  the whole screen shares one attribute, and never returns 1.

## Rights

See [NOTICE.md](NOTICE.md).
