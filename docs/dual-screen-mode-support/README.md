# ADL ASC 004 — Dual Screen Mode Support (Timex, 1984)

A transcription of the assembler listing for **Timex Application Development
Library (ADL) ASC No. 004, "Dual Screen Mode Support"**: version 002, author
C. Corcoran, dated 2/22/84. Version 001 is dated 1/6/84; version 002 adds the
exchange-screen routine. The source file is `IODS.SRC`. It was assembled with
CRZ80/11 version 10.36.14, and the listing is dated 22-Feb-84 11:42:6.

It is a relocatable Z80 module (`INTERN` entry points, addresses marked `'`)
of 0760h bytes. It gives TS2068 programs text output on the second display
file:

- write character / write string
- set and get cursor
- clear screen and scroll by line range
- get character / get attribute
- set video mode (VIDMOD)
- copy screen and exchange screen between the two display files
- the Sinclair 2×2 block-graphics character set (codes 80h–8Fh)

Each routine has a BASIC entry point in a jump table at the start of the
module. Line 95 documents the module as loaded at **57344 (E000h)**, and gives
each BASIC entry point and parameter address in decimal: 57345 write
character, 57348 write string, 57353 set cursor, and so on.

| File | Contents |
|---|---|
| [`dual-screen-mode-support.md`](dual-screen-mode-support.md) | The listing, one section per scan page (38 pages), with every line's address, object code, line number and source |
| `README.md` | This file |
| [`NOTICE.md`](NOTICE.md) | Rights |

## Sections of the listing

| PDF pages | Listing pages | Section (page header) | Lines |
|---|---|---|---|
| 1–2 | 1–2 | Version level control (title banner, version history) | 1–32 |
| 3 | 3 | Definitions (`INTERN` list, ROM addresses, system variables, relocation constants) | 34–82 |
| 4 | 4 | Inputs and entries: the BASIC jump table and parameter block, with decimal addresses | 84–130 |
| 5 | 5 | Other variables | 132–169 |
| 6–8 | 6 – 6-2 | Write character | 171–287 |
| 9 | 7 | Write string | 289–329 |
| 10 | 8 | Position control | 331–342 |
| 11–13 | 9 – 9-2 | Scroll | 344–477 |
| 14–15 | 10 – 10-1 | Clear screen | 479–578 |
| 16–18 | 11 – 11-2 | 'Get' routines | 580–701 |
| 19–21 | 12 – 12-2 | Video mode control | 703–827 |
| 22–25 | 13 – 13-3 | Copy screen | 829–1036 |
| 26–29 | 13-4 – 13-7 | Exchange screen | 1037–1210 |
| 30–34 | 14 – 14-4 | Internal subroutines | 1212–1451 |
| 35–37 | 15 – 15-2 | Graphics character set | 1453–1605 (`END`) |
| 38 | S-1 | Symbol table ("No errors detected") | — |

## ROM and system addresses it uses, checked against this library

The module calls into the ROMs and relies on the second-display-file layout.
Every value below agrees with the library:

| Listing symbol | Value | Library |
|---|---|---|
| `CHNGVID` "routine in ROM extension" | `0E8E` | EXROM CHNG_VID (CHG_V) at `$0E8E` (`../ts2068_memory_map.md`) |
| `RECLEN`, `ININT`, `FP2A` "routine in HOME ROM" | `1720`, `30F9`, `3193` | Dispatcher entries `$1720`, `$30F9`, `$3193` (`../../disassemblies/2068_DEFS.ASM`) |
| `FIXTBL` | `1D00` | EXROM relocation fix table at `$1D00` |
| `INSERTSZ` = 7B00H−DRIVES | `12C0` | CHNG_VID opens `$12C0` bytes at `$6840` |
| `MOVESZ`, `DEST7`, `FIX` | `0840`, `F7C0`, `97C0` | OPEN-DFILE moves `$6000–$683F` to `$F7C0`, offset `+$97C0` |
| `VIDMOD`, `PARAM$`, `PRAMT`, `RAMTOP`, `UDG`, … | `5CC2`, `5CC3`, `5CB4`, `5CB2`, `5C7B`, … | System variables, as in `../ts2068_system_variables.md` |
| `DKHSPT` "dock horizontal select port", `HREXPT` "home ROM ext. select port (bit 7)" | `F4`, `FF` | HSR port `$F4`; DECR port `$FF` bit 7 |

`DKHSPT` is also the name Hildreth uses for port F4h in his BEU notes
(`../hildreth-beu-notes/`, PDF page 49).

## How to read the transcription

Each scan page starts with
`<!-- PDF page N — listing "Page X" — SECTION — IODS.SRC -->` and holds one
`text` block:

```text
LOC    OBJ            LINE  SOURCE
00D7'  20 0B            276          JR      NZ,TVFUL1
```

- **LOC:** the module-relative address. `'` means relocatable; `=XXXX` is an
  EQU value.
- **OBJ:** the object bytes as printed. A 16-bit operand is printed as one
  word, high byte first (`002E'` is the bytes `2E 00`).
- **SOURCE:** re-spaced to fixed columns (label 0, opcode 8, operand 16,
  comment 32). The printout itself uses a few different column layouts, and
  each page's notes say where. Wording, case and spelling are as printed.
- The `LOC OBJ LINE SOURCE` header row is not printed on the original; it was
  added as a guide.
- Uncertain readings are listed after each block as `> *Uncertain:* …`, never
  inside it, so the blocks stay machine-readable.

**Unprinted line numbers.** Fourteen line numbers never appear: 22, 33, 83,
131, 170, 288, 330, 343, 478, 579, 702, 828, 1211 and 1452. Each falls just
before a page's opening `SUBTTL`, so they are the assembler's page-eject lines,
not lost text.

## Verification

This listing could be checked by machine, and was:

- **Object code against source:** all 1,018 instructions were disassembled
  from their printed bytes (z80dis) and compared with the printed mnemonic and
  register operands. No mismatches.
- **Address chain:** for every line, LOC plus its byte count equals the next
  LOC, from `0000'` to `0760` (the `DEFS 4` at `03E8'` was checked by hand). No
  breaks.
- **Labels against the assembler's symbol table** (PDF page 38): all 194
  labels and EQUs in the listing have the value the symbol table gives them.
- **Jump and call targets:** all 197 symbolic `JR`, `JP`, `CALL` and `DJNZ`
  targets decode to the address of the label named in the source.
- **Graphics data:** every `DEFB` byte matches its binary operand.

The checks found one misreading, `CONVPM` for `CONVFM` on line 339, which was
corrected against the scan.

**One reconstruction.** PDF page 27 (listing page 13-5) was scanned shifted
left, which cut off the first one or two digits of every address. Those
addresses (`053D'` to `0582'`) are rebuilt from the address chain, which pins
each one down. The object code, line numbers and source on that page survive
intact. The page's notes say so.

**Handwriting.** Page 38 has a note written sideways at the right edge:
"George Kibby / Amity Consultants / 372-4316". Pen strokes on many pages mark
lines but cover no characters, and each page's notes record them.

## Bugs found by running it

The object code was relocated to E000h (176 relocatable words) and run in an
emulation of the TS2068 on the stock HOME ROM and EXROM (md5s in
`../../CLAUDE.md`). The emulation has 48K RAM, HSR/DECR bank switching with the
EXROM mirrored in every chunk, and 60 Hz IM1 interrupts. It was driven from
BASIC programs. Every BASIC entry point was exercised, including opening and
closing the second display file through EXROM CHNG_VID. The module behaves as
its listing describes, except for four bugs in the original code:

- **COPYSC / EXCHSC unbalance the stack on an invalid line or screen number.**
  COPYSC does `PUSH AF` (line 893) before `CALL GTADRS` / `JP C,INVPAR`
  (894–895), and pushes again before the second check (896–900). EXCHSC
  pushes AF and DE before its checks (1084–1089). INVPAR exits through
  `ERRRET: LD B,0 / RET`, so the RET pops the pushed value as a return
  address. With a line ≥ 24 or a screen number other than 1 or 2, the stock
  machine resets. (The count is checked before the push and is safe. So are
  non-digit parameters, which take the COPERR path and do restore the
  stack.)
- **COPYSC / EXCHSC do not bound line + count.** Each line number and the
  count are checked separately. The attribute copy then runs past the end of
  the display file: with DF2 open, eight lines from line 20 overwrote CHANS at
  `$7B00`, and BASIC stopped with report C.
- **SCROLL accepts a starting line of 0.** It validates only count ≥ 1 and
  1 ≤ first + count ≤ 24, but it moves each line into the one above. From
  line 0 on DF2, the pixel moves for the top block use `HL−$720`. That writes
  line 0's eight pixel rows to `$58E0`, `$59E0` … `$5FE0`, one every `$100`.
  In the test, two rows of DF1 attributes were zeroed. The end of the printer
  buffer changed, and so did the reserved area at `$5CE0`–`$5EF6`, which
  includes the start of the SYSCON table at `$5EEA`. (An earlier revision of
  this note mentioned only the attributes.) It still returns 0, and BASIC kept
  running. On DF1 the same writes land in ROM and are lost.

- **CLRSCN and SCROLL miss 8-bit overflow.** Both check `first + count` with
  `ADD A,C / CP 1 / CP 25`, with no carry test, so first line 250 with count
  10 sums to 4 and passes. Run on DF1 with that input, CLRSCN overwrote 746
  bytes of the module's own code. SCROLL corrupted BASIC's memory (report 4).
  The automatic scroll from WRCHAR (`TVFUL1`, line 286) jumps straight to
  SCRL0 with whatever is in SCRCTL, with no check at all.

Two things that are not bugs, but trip up BASIC users:

- The ROM's OPEN-DFILE zeroes DF2's attributes, so DF2 must be cleared with
  the module before anything written to it is visible.
- BASIC's own PRINT/INPUT and reports always go to DF1.

### Builds in `build/`

| File | What it is |
|---|---|
| `dualscreen.tap` | The original module, relocated to E000h (57344) from the transcription's object code. 1,888 bytes; md5 of the code `a7f6528d00de88a2a46fd0cb02e06f20`. |
| `dualscreen-patched.tap` | The same, with the four bugs fixed. 2,008 bytes, E000h–E7D7h; md5 of the code `507820a99a77d689cf98dd8efc918230`. Same header name, so the same `LOAD "dualscreen" CODE 57344` loads either. |
| `patch.py` | Builds the patched image from the original. It checks the original bytes at every patch site before changing them, and lists the new code. |

The patch changes nine instruction sites. Each one is redirected (with NOPs
padding the rest of the replaced bytes) to code appended at E760h:

| Site | Was | Now |
|---|---|---|
| `E441` COPYSC count check | `CP 25 / JP NC,INVPAR` | `JP CHKCPY`: count ≤ 24, from line + count ≤ 24, to line + count ≤ 24, with a carry test on each add |
| `E44A`, `E453` COPYSC | `JP C,INVPAR` | `JP C,FIXAF` / `FIXHL`: pop what was pushed, then `JP INVPAR` |
| `E531` EXCHSC count check | `CP 25 / JP NC,INVPAR` | `JP CHKEXC`: the same, for both lines |
| `E53D`, `E546` EXCHSC | `JP C,INVPAR` | `JP C,FIXDE` / `FIXHL` |
| `E130` SCROLL | `ADD A,C / CP 1 / JP C,INVPAR` | `JP CHKSCR`: carry test, first + count ≤ 24, first line ≠ 0 |
| `E1DD` CLRSCN | `ADD A,C / CP 1 / JP C,INVPAR` | `JP CHKCLR`: carry test, first + count ≤ 24 |
| `E0EB` automatic scroll | `JP SCRL0` | `JP CHKAUTO`: validate SCRCTL as SCROLL does; if invalid, take the existing "screen full" exit (BC = 3) |

The patched build passed every test the original did, with identical
results. All eleven failure cases (bad line or screen number, overrunning
line + count, scroll from line 0, start-line overflow, and a bad SCRCTL during
automatic scroll) return 1 (or 3) and leave BASIC running.

A user-facing article for timexsinclair.com was produced from this work.
Loading from tape and real hardware have not been tested; the emulation
placed the code in memory directly.

## Rights

See [NOTICE.md](NOTICE.md).
