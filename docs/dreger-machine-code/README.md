# Dreger — *Introduction to 2068 Machine Code* (1986)

A corrected, ROM-checked transcription of Dr. Lloyd Dreger's self-study manual,
*Introduction to 2068 Machine Code — A Self Study Manual For The Beginning Assembly
Language Student That Bridges The Gap Between Advanced Basic and Machine Code*
(© 1986 Dr. Lloyd Dreger; distributed by S.M.U.G., the Sinclair Milwaukee Users Group).

**This is a secondary source.** It is a 1986 tutorial, written before the ROM had been fully
disassembled, and it contains errors. Every checkable claim in it has now been checked against
the stock ROM images in this repository — but where this book and the library's own docs
(`../ts2068_*.md`, `../../CLAUDE.md`) differ, **the library docs and the ROM win.** Read the
footnotes: they are where the corrections live.

Source scan: <https://archive.org/details/introduction-to-2068-machine-code/>
(224-page, 300 dpi bilevel scan of the dot-matrix original; read page by page, no OCR).

## Chapters

| File | Covers | Printed pp. | Corrected | Library notes | (unverified) |
|---|---|---|---|---|---|
| [`00-front-matter.md`](00-front-matter.md) | Title page and colophon | — | 0 | 0 | 0 |
| [`01-introduction.md`](01-introduction.md) | Why machine code; how to use the book | 1–2 | 0 | 0 | 0 |
| [`02-chapter-01-numbers-and-counting.md`](02-chapter-01-numbers-and-counting.md) | Generic binary/hex teaching; **the 5-byte number format** (“slug”) — ROM-checked | 3–22 | 17 | 12 | 4 |
| [`03-chapter-02-memory-mapping.md`](03-chapter-02-memory-mapping.md) | Chunks, banks, home-RAM map, CHANS/PROG/VARS, UDG, RAMTOP | 23–34 | 6 | 14 | 5 |
| [`04-chapter-03-screen-printing.md`](04-chapter-03-screen-printing.md) | Display file and attribute addressing, PLOT maths, OVER/INVERSE masks, VIDMOD and video modes, second display file | 35–46 | 11 | 5 | 3 |
| [`05-chapter-04-system-variables.md`](05-chapter-04-system-variables.md) | Walk-through of the system variables, BASIC line storage, streams and channels, FLAGS bits | 47–66 | 7 | 29 | 7 |
| [`06-chapter-05-beep-and-sound.md`](06-chapter-05-beep-and-sound.md) | BEEP and port 254, tape, the AY-3-8912 registers, note tables, envelopes, joysticks | 67–84 | 10 | 15 | 6 |
| [`07-chapter-06-the-cpu.md`](07-chapter-06-the-cpu.md) | Z80 internals and bus cycles (generic), first machine-code program | 85–98 | 4 | 10 | 1 |
| [`08-chapter-07-assembly-language.md`](08-chapter-07-assembly-language.md) | Z80 instruction set by group (generic, mostly duplicates `z80_combined_reference.md`), Spectrum-to-2068 conversion advice, RSTs | 99–126 | 17 | 44 | 5 |
| [`09-chapter-08-floating-point-calculator.md`](09-chapter-08-floating-point-calculator.md) | **RST 28h calculator**: op-code table (checked entry by entry against the ROM jump table at $3696), stacking/unstacking routines, PLOT/DRAW | 127–146 | 13 | 13 | 1 |
| [`10-chapter-09-peripherals.md`](10-chapter-09-peripherals.md) | Printers, keyboard routines and matrix reads, BREAK, pixel generation; period notes on microdrives, modems, disks | 147–168 | 7 | 11 | 5 |
| [`11-chapter-10-io-and-bank-switching.md`](11-chapter-10-io-and-bank-switching.md) | **SCLD, HSR/DECR, function dispatcher** (all 146 service codes checked against the EXROM table), RAM-resident routines, cartridge set-up | 169–190 | 11 | 9 | 4 |
| [`12-appendixes.md`](12-appendixes.md) | A timing tables, B print & input routine, C/D/E complete code tables (every cell disassembler-checked), F bibliography | 191–213 | 46 | 1 | 0 |
| [`13-original-index.md`](13-original-index.md) | Dreger’s index with its 1986 page numbers (kept for reference; the page markers in each file map to it) | — | 1 | 0 | 0 |

Bold entries are the parts with the most 2068-specific value. Chapters 1, 6 and 7 are largely
generic number-system and Z80 teaching.

## How to read the footnotes

Every correction or caveat is a pandoc footnote at the end of the chapter file. The first words
say what kind it is:

| Footnote begins | Meaning | Text in the chapter |
|---|---|---|
| `Corrected.` | Printing error found during transcription (arithmetic, a wrong byte, a typo in a listing), settled by the page itself or by assembly | Corrected; footnote records what was printed |
| `Corrected against the ROM.` | A value (address, bit, code, byte count, port) that the stock ROM contradicts | Corrected; footnote gives the original and the ROM evidence |
| `Library note:` | Dreger's *explanation* is contradicted by the ROM, but there is no single value to swap | **Dreger's wording kept** — read the note before relying on the passage |
| `(unverified)` | A claim neither the ROMs nor the library can settle (third-party hardware, the never-produced BEU, Owner's Manual page references, etc.) | As printed |
| `Not corrected.` | An error the page cannot settle — two readings, no evidence for either | As printed |

Markers cannot go inside code blocks, so footnotes about a listing or table hang off a short
line right after it (*Notes on the listing above:* / *Corrections in the table above:*).

`<!-- p. N (pdf M) -->` comments mark the start of printed page *N* (scan page *M*) so any
passage can be checked against the scan.

## Verification

- **Transcription (2026-10):** every machine-code listing with a byte column disassembled and
  checked against its mnemonics, address chain and jump targets; BASIC DATA loaders compared
  byte-for-byte with their assembly listings; Appendix A timings against Zilog's figures;
  Appendixes C and D cell by cell against a Z80 disassembler; every numeric table and worked
  example recomputed. 121 printing errors found: 115 corrected, 6 that the page cannot settle.
- **Library audit (2026-10):** 736 checkable claims checked against `TS2068_U16.BIN` /
  `TS2068_U20.BIN` (stock; md5s in `CLAUDE.md`), their disassemblies and this library.
  484 confirmed; 35 values corrected in the text; 163 library notes; 41 marked (unverified).
  The same audit found 57 errors in the library itself, all since corrected.

### Errors in the original most likely to bite

Corrected in the text — listed here because readers of other copies of the book will meet them:

- DF CCL is 23686–23687, not 23684–23685 (Ch. 4).
- 64-column video is mode value **6** (DECR D2–D0 = `110`), not "MODE 3", and not "bit 2 with bit 0" (Chs. 3, 10).
- The AT print control code is **22**, not 27 (Ch. 7).
- `OUT 244,15` enables the **bottom** 32K of the dock bank; the top is 240 (Ch. 10).
- The RST 28h set-up on p. 175 must store into MEM (23656), not MEMBOT (Ch. 10).
- The "To enable ExROM" sequence on p. 188 ended with port 244 = 0, which hides the EXROM (Ch. 10).
- Calculator op 08 (number AND) leaves 0, not 1, when Y = 0; op 10 (string AND) is reversed (Ch. 8).
- 0.1 is stored `7D 4C CC CC CD` (the ROM rounds), not `… CC` (Ch. 1).

Kept with a library note (the method, not a value, is wrong) — check the note before using:

- `STK DATA` (op $34) takes a *compressed* literal, not a plain 5-byte number (Ch. 8).
- Negating a 16-bit number needs `INC` of the whole pair, not just the low byte (Ch. 7).
- CPIR leaves HL one *past* the match (Ch. 7).
- The BANK ENABLE patch in the p. 173 correction program no longer preserves A and the flags (Ch. 10).
- The p. 173 relocation POKE list is incomplete: the stock fix table misses further operands; the
  note gives the extra POKEs (Ch. 10, and `../exrom_revision_analysis.md`).

### Not corrected (the page cannot settle them)

- p. 18 — remainder after 36 bits of 0.1 matches no truncation; two readings.
- p. 102 — `(IY+245)` example: either the displacement or the address is wrong.
- p. 113 — a fourth `EX DE,IX` line repeats with the IY prefix; no such instruction exists.
- p. 158 — the keyboard loader READs 79 values but prints 76.
- pp. 193–194 (Appendix B data) — "Computer." full stop and AT 12 vs 13 differ between the data and the BASIC line.

## Rights

See [NOTICE.md](NOTICE.md). In short: the original text is © 1986 Dr. Lloyd Dreger. The author
is deceased with no known heirs; the text is included here for preservation and reference and is
**not** covered by this repository's GPL licence. The transcription, corrections and editorial
notes are dedicated to the public domain under CC0 1.0.

## How this was produced

Read directly from the page images (no OCR) and assembled as one pandoc Markdown master with
YAML metadata; these files are that master split at chapter headings, each with a header and its
own footnotes. The same master builds the corrected-reprint PDF and the timexsinclair.com HTML.
