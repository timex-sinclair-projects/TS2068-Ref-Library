# Hildreth — BEU code development notes (Timex)

A page-by-page transcription of Lon Hildreth's working notes on the TS2068 ROM
code for the **Timex/Sinclair 2060 Bus Expansion Unit (BEU)**: bank
initialization, the System Configuration Table (SYSCON), bank renumbering by
interrupt priority, booting the highest-priority device, and BEU channel/stream
tables. Hildreth wrote them while working on the 2068 project at Timex. The
notes are undated; the only date in them is the copyright string
`' 1983 TIMEX COMPUTER C…'` on PDF page 4.

**This is a primary source, but it is working notes, not a specification.** It
holds drafts, crossed-out code, abandoned approaches and arithmetic scratch, and
it is not in any coherent order. Where it conflicts with the stock ROMs or the
library's own docs, **the ROM and the docs win**. Treat any address, register
assignment or table layout in it as what Hildreth was trying at the time, not as
what shipped.

Source scan: <https://archive.org/details/timex-computer-corp/BEU%20Code%20Development%20-%20Lon%20Hildreth/>.
A local copy is at `../bus expansion unit/BEU Code Development - Lon Hildreth.pdf`
(100 pages, 300 dpi colour). The scan was read page by page from the images,
with no OCR. timexsinclair.com catalogues it as *Bank Expansion Unit
Development Documents* (Timex Computer Corporation, 1983).

## Files

| File | Contents |
|---|---|
| [`hildreth-beu-notes.md`](hildreth-beu-notes.md) | The transcription: one section per PDF page, in scan order |
| `README.md` | This file: what is where, how to read the markup, what has been checked |
| [`NOTICE.md`](NOTICE.md) | Rights: the original notes are public with Hildreth's permission, not GPL; the transcription is CC0 |

## What's in the notes

PDF page order is the scan order and is **not** Hildreth's order. He numbered
some sheets himself (`1-1`, `1-2`, `1-3`, `2-23`, circled ①②③). Those numbers
are given in the section headings. 36 of the 100 pages are blank or
carry only show-through from the reverse of the sheet. They are kept as
one-line entries, so PDF page numbers stay aligned with the scan.

| PDF pages | What they are |
|---|---|
| 1–5 | Z80 code: RENUMBER_BANKS (1-1 to 1-3), SELECT, ROM-source patch notes keyed to line numbers (stack set-up, moving bank-switch code to RAM, AROS/LROS checks) |
| 6–15 | INIT flow traced through SYNTAX/EXECUTE (ROM addresses and stack pictures); RESSCT pseudocode and code (`TEMP_REC EQU 5FE?h`); prose description of the boot sequence and EXINIT; boot-highest-priority-device pseudocode; BLDSCT pseudocode; RESSCT-2 (NEWDEV, MOVEREC, BURYDEAD) |
| 16–25 | SYSCON record diagram; OPEN/OPCHAN via SEARCH3; interrupt-priority SORT; BLDCHT (build BEU-CH records); NEWSEARCH/SRCHSC; bank-renumbering pseudocode; a DELETE m,n note; CHANS layout and where the BEU tables go in the EDIT source |
| 26–35 | Boot-order design notes; a task estimate; SEARCH/OPEN design notes; TS2068 port equates; "New permanent devices" (sound chip and game controllers as channels, crossed out) |
| 36–45 | **SYSTEM CONFIG TABLE** layout (DEFB/DEFW and offsets); BEU channel tables and SEARCH2; OPEN via BEU_OP; boot-priority ordering (crossed out); routine-header template |
| 46–55 | Printer detection on port FBh; **GOTO_BANK / CALL_BANK / Write_BS_Reg / XFER_BYTES parameters, XFER stack frame, BEU I/O ports**; bank-port command table; table sizes and a memory map; BLDSCT code with the POLLEB status poll |
| 56–65 | Bank-initialization outline and **command/status register bit definitions**; device-polling design; open questions; home bank 255 / dock bank 0; STRMS layout and stream select |
| 66–75 | SEARCH3; CLCHAN; HL-arithmetic timings; MSTEND/MSTBOT/BSWEND and a memory map; CALLCB; BLDCHT; POLLEB; LSC2–LSC4 |
| 76–85 | CHUNK_SPEC probing (pseudocode and Z80); **typed design-spec pages** with handwritten revisions: Build_System_Configuration_Table, Build BEU channel table / Channels, Initialization (new system variables, memory map, SYSCON offset EQUs), Search2 |
| 86–100 | Routine specification forms on green grid paper (Inputs / Outputs / Globals / Services / Processing): ASSIGN, NEWRAM, CHIR, RENUM-BANKS, RESSCT, BOOTDEV, NOVARS/CONT |

## Relationship to the shipped EXROM

Checked against `disassemblies/ts2068_exrom_U20_stock.txt` and
`disassemblies/2068_DEFS.ASM`:

- The stock EXROM's INIT module has routines labelled **BLDSCT** ("build the
  system configuration table") and **RESSCT**. It calls `WRITE_BS_REG`,
  `READ_BS_REG`, `XFER_BYTES`, `GOTO_BANK` and `CALL_BANK`, and uses the system
  variables `SYSCON` ($5CBC) and `MAXBNK` ($5CBE). All of these names appear in
  the notes.
- Stock RESSCT starts at `(SYSCON)+$0C` and works through a scratch area at
  `$5FE9`. The notes' RESSCT/RENUMBER_BANKS code adds 12 to `(SYSCON)` and uses
  the `5FE8h`/`5FEAh` temporaries (PDF pages 1 and 3). On PDF page 7 the
  last digit of the `TEMP_REC EQU` value is blotted out and rewritten as what
  may be a 9 (`5FE[9? d?]h`), which would match the ROM. The two are clearly
  related, but the details differ.
- **Register assignments differ from the ROM but match the BSCC spec.** PDF
  page 5 has `ABN = C0h`, with reset/STEP written through `E0h`. The stock
  EXROM symbols are `ABN` = $A0 and `CMD` = $C0 (see `../ts2068_memory_map.md`).
  The *Bank Switching Controller Chip* functional specification puts the
  registers at `4000h`/`A000h`/`C000h`/`E000h` (ABN at `C000h`, CMD at
  `E000h`), which is what Hildreth codes to. The shipped ROM has registers 1–3
  `$2000` lower. See [`../beu-specs/README.md`](../beu-specs/README.md). Why
  the ROM differs is **(unverified)**.
- **The notes also contain an I/O-port design.** PDF page 49 defines
  `BDATPT = FCH` (bank "data" port) and `BCMDPT = FDH` ("cmd"), and the
  BLDSCT and POLLEB code on PDF pages 53 and 73 polls the banks with
  `OUT (BCMDPT)` / `IN (BDATPT)`. Wes Brzozowski (1986) reports an early
  TS2068 I/O map reserving FC and FD for bank switching. The stock ROMs never
  use them.
- Routines named in the notes but **not** found in the stock ROM listings:
  RENUMBER_BANKS/RENUM-BANKS, NEWRAM, CHIR, ASSIGN, BOOTDEV, SEARCH2,
  SEARCH3, BEU_CH/BEUSEL/BEU_OP/BEU_CL. They may exist unnamed (the stock
  RESSCT calls unlabelled helpers at $0ADB, $0BD1, $0C1F and $0CFB), or may
  never have shipped **(unverified)**.
- The notes' **EXINIT** is probably the stock EXROM's **EXTINIT** (the INIT
  routine that calls BLDSCT) **(unverified)**.

No line-by-line comparison of the notes against the EXROM has been done.

## How to read the transcription

| Markup | Meaning |
|---|---|
| `## PDF page N — Title (1-2)` | Scan page *N*. The title is Hildreth's own where he wrote one; otherwise it is a short label taken from the page's content. The number in parentheses is his own page number. |
| *Paper: …; ink/pencil.* | The sheet (yellow lined, green grid, typed) and the writing medium |
| Code in ```` ```asm ```` blocks | Hildreth's **final, as-corrected** code, with his spelling, case and hex notation (`80h`, `E0h`, `5FE8h`). Slashed zero is written `0`. |
| `; [struck: …]` | Text he crossed out. A line that is only `; [struck: …]` was deleted with no replacement. |
| `[was 22]` | A value he overwrote; the final value is in the code |
| `; [inserted from margin]` | Code written in the margin and arrowed into this spot |
| `Side note (arrow to …):` | Margin code whose intended position is ambiguous, kept separate rather than guessed |
| `[margin: n]` | A note or numeral beside that line |
| `~~text~~` | Struck-out prose or pseudocode |
| `word[?]` / `[A? B?]` | Uncertain reading / two possible readings |
| `[illegible]` | Could not be read, usually because it is scribbled out or erased |
| `[handwritten: …]` | A handwritten annotation on a typed page |
| > *Transcriber's note:* | Layout, legibility, arrows and brackets. These describe the page; they don't interpret the code. |

The code is **transcribed, not corrected.** Where Hildreth's code is
incomplete (`LD BC, ?`, `LD C, ?`), has a syntax slip, or has an arithmetic
error in a size sum, it is left as written.

## Verification

- **Transcription (2026-10):** each page was rendered at 220–300 dpi and read in
  cropped strips, with contrast enhancement on the faint pencil pages. Faint
  pages were classed as blank or show-through only after being mirrored and
  matched against the facing sheet. PDF page 19 was scanned upside-down and was
  read rotated. Upside-down arithmetic on PDF page 64 was read at 180°.
- **Independent check:** ten of the densest pages (7, 15, 17, 19, 37, 53, 65, 79,
  83, 93) were re-read from the images by a second reader, who read each image
  first and then compared it line by line with the transcription. Pages 15,
  17, 37, 79 and 93 were confirmed accurate. Fixes were made on the other five:
  - PDF page 7: "for each" → "for both".
  - PDF page 7: the `TEMP_REC EQU` value now reads `5FE[9? d?]h`. The
    replacement digit is not an 8.
  - PDF page 19: a struck digit in a comment is now recorded.
  - PDF page 65: `'P'` → `'p'`.
  - PDF page 83: an unrecorded pencil stroke is now noted.
  - PDF page 53: a third reading was added to an overwritten jump condition.

  The other 54 pages with writing have had only the first careful reading.
- The transcription carries 106 `[?]` marks, plus some two-way readings
  (`[A? B?]`), and 86 places marked illegible, almost all of them scribbled-out
  or erased text. Check those places against the scan before relying on a
  value.

## Rights

See [NOTICE.md](NOTICE.md). Hildreth lent the original notes for scanning,
and they have been public on archive.org with his permission. They are
included here on that basis and are **not** covered by this repository's GPL
licence. The transcription and editorial notes are CC0 1.0.
