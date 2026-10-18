# TS2060 Bus Expansion Unit — Timex specifications (1983–84)

Markdown transcriptions of two typed Timex Computer Corp. documents about the
**TS2060**, the bus expansion unit for the TS2068 that was never produced:

| File | Document | Scan pages |
|---|---|---|
| [`bscc-functional-spec.md`](bscc-functional-spec.md) | *Bank Switching Controller Chip — Functional Specification*, David B. Ornstein (1983). The four memory-mapped BSCC registers, the 4-bit nybble-steering scheme, the command set (RESET, STEP, LOWNYB, RINT), local/global status, interrupts and the initialization daisy chain | 7 |
| [`ts2060-interface-product-spec.md`](ts2060-interface-product-spec.md) | *TS2060 Interface Product Specification* (Preliminary, January 24, 1984). The interface unit as a product: Microdrive controller, CP/M module, Centronics printer, RS-232-C, LAN, RGB, audio, system buss expansion pinout, power, **I/O port map (E4h–E7h, EFh)**, software support, regulatory requirements | 26 |
| `figures/` | Page renders of the drawings: block diagram, rear-panel connector drawing, two FCC test configurations, the BSCC daisy chain | — |

They sit alongside [`../hildreth-beu-notes/`](../hildreth-beu-notes/), Lon
Hildreth's working notes on the ROM code for the same unit.

Source scans (local copies in [`../bus expansion unit/`](../bus%20expansion%20unit/)):

- BSCC: <https://archive.org/details/timex-computer-corp/Bank%20Switching%20Controller%20Chip%20Functional%20Specification/>
  — catalogued at <https://www.timexsinclair.com/document/bank-switching-controller-chip-functional-specification/>
- TS2060: <https://archive.org/details/timex-computer-corp/TS2060%20Interface%20Product%20Specification/>
  — catalogued at <https://www.timexsinclair.com/document/ts2060-interface-product-specification-preliminary/>

**These are design documents for hardware that was never built.** They record
what Timex intended. Where they disagree with the stock ROMs, the ROM records
what was actually coded, and neither can be checked against real hardware.

## The register addresses do not match the shipped EXROM

This is the single most important thing to know before using these documents
with the ROM.

| BSCC reg | Read | Write | **BSCC spec** (Figure One) | **Stock EXROM** (`2068_DEFS.ASM`) |
|---|---|---|---|---|
| 0 | HS-LSN | HS | `4000h` | `$40xx` (`HS`, `HS_LSN`) |
| 1 | HS-MSN | BNA | **`A000h`** | **`$80xx`** (`BNA`, `HS_MSN`) |
| 2 | STATUS-L | ABN / HS' | **`C000h`** | **`$A0xx`** (`ABN`, `HSP`, `STA_L`) |
| 3 | STATUS-G | CMD | **`E000h`** | **`$C0xx`** (`CMD`, `STA_O`) |

- The register names and their order are the same in both. Registers 1–3 are
  `$2000` lower in the ROM than in the spec.
- The spec agrees with itself: its page 2 example resets the steering logic by
  writing 2 to `E000h` (CMD) and writes BNA nybbles to `A000h`.
- The ROM agrees with itself too: CLAUDE.md records the nybble-steering
  location as `$C000`, which is the ROM's CMD.
- **Hildreth's notes follow the spec, not the ROM.** He writes ABN at `C0h`
  and reset/STEP through `E0h` (`../hildreth-beu-notes/`, PDF page 5).
- Why the shipped code differs is **(unverified)**. The spec cannot tell us
  which layout the hardware would have used.

The spec does say what each register does, and the library had marked that
**(unverified)** (`../ts2068_memory_map.md`). Here it is from the BSCC
document:

- **HS / HS-LSN / HS-MSN:** the Horizontal Select register, which chunks of a
  bank are enabled.
- **BNA:** Bank Number Accessed. A global write that selects which bank a
  following local operation applies to.
- **ABN:** Assigned Bank Number, set during initialization.
- **HS':** Horizontal Select, protect mode.
- **STATUS-L:** local status. Bit 0 is interrupt caused, bit 1 is unused,
  bit 2 is bank responding, and bit 3 is INIT mode. Bits 0 and 2 are active
  low.
- **STATUS-G:** global status.
- **CMD commands:**

  | Code | Command |
  |---|---|
  | 0 | RESET |
  | 1 | STEP |
  | 2 | LOWNYB (reset the nybble-steering logic) |
  | 3–4 | reserved |
  | 5 | RINT |
  | 6–15 | unused |

These are the spec's definitions, not confirmed behaviour.

## What the ROM itself shows: Brzozowski (1986)

Wes Brzozowski reverse-engineered the EXROM's bank-switching code in "The
Mystery of the Missing 253", *Time Designs Magazine* v2 n5 (July/August 1986),
pp. 21–26
([timexsinclair.com](https://www.timexsinclair.com/article/the-mystery-of-the-missing-253/index.html)).
It is a secondary source, worked out from the ROM without the Timex documents.
He never mentions a Bank Switching Controller Chip, and he assumed that each
expansion bank "would likely have contained its own SCLD". It is useful here
because it shows what the shipped code expects, alongside what the chip spec
defines.

**Register addresses.** He uses the ROM's addresses ("registers C0, A0, 80,
and 40"), not the spec's. He also says that "only address lines A13-A15 need
to be tested to see if a register is being accessed".

**Register writes** match the spec's functions:

| Register | Brzozowski | Spec equivalent |
|---|---|---|
| 40 | "Horizontal Select" | HS |
| 80 | "Bank Number Access. Sets the 'presently accessed bank'" | BNA |
| A0, setup mode | "Receives the assigned bank number" | ABN |
| A0, normal mode | "Receives the universal deselect byte" | HS' |
| C0 | "Command Register" | CMD |

**Commands differ.** He found four in the ROM:

| Code | ROM use (Brzozowski) | BSCC spec Table One |
|---|---|---|
| 00 | "Reset daisy chain & enter the setup mode" | 0 RESET |
| 01 | "Step the daisy chain to the next bank" | 1 STEP |
| 02 | "Reset the nybble steering logic" | 2 LOWNYB |
| 04 | "End the setup mode & enter the normal mode" | **no command 4** (3–4 reserved) |
| — | — | 5 RINT |

**Register reads differ for the top register.** His reads are:

- 40: the low nybble of the horizontal select.
- 80: the high nybble of register 40.
- A0: "Least significant nybble – bank status".
- C0: "Most significant nybble — for register A0".

The spec reads reg 2 as STATUS-L (local status) and reg 3 as STATUS-G (global
status), so it does not treat reg 3 as the high half of reg 2. Which reading
the hardware would have matched is **(unverified)**.

**Ports FC and FD.** He notes that "An early map of TS2068 I/O port
assignments shows ports FC and FD reserved for bank switching", and that these
"are never used in either ROMs". Hildreth's notes use exactly those ports:
`BDATPT = FCH` and `BCMDPT = FDH` ("exp bank 'data' port" / "'cmd'",
`../hildreth-beu-notes/`, PDF page 49). His BLDSCT and POLLEB code polls the
banks with `OUT (BCMDPT)` / `IN (BDATPT)` (PDF pages 53 and 73). Other pages
of his notes use the memory-mapped `C0h`/`E0h` registers. So the notes span
both designs. Which came first is **(unverified)**.

## Other things to know

- **The TS2060 port map lists only `E4h`, `E5h`, `E6h`, `E7h` and `EFh`:**
  Microdrive data and control/status, RS-232-C, select/parallel status, and
  parallel data. It does not list `F4h`/`FCh`/`FDh`, which Hildreth's notes
  use for the dock HSR and the bank data/command ports. CLAUDE.md records
  `$FC`/`$FD` as reserved and never addressed by the stock ROMs.
- **The TS2060 "System Buss Expansion" pinout** is on PDF pages 17–18. Two
  signal names are printed oddly (`SP/T O` at B2, `O*` "CLK P/T" at B9) and
  are kept as printed.
- **Placeholders the TS2060 document never filled in:**
  - Block Diagram, Connector Locations and Memory Map are all "T B S".
  - "Drawing XXX-XXXXX", "(XX) ns" and "XX MA MAX".
  - The +5 V current is "TBD".
  - The unnumbered drawings on PDF pages 9 and 11 are probably the missing
    block diagram and connector figure, but nothing on them says so.
- **Internal inconsistencies in the TS2060 document, kept as printed:**
  - Firmware ROM: "16k byte ROM" in §3.1, but "8K ROM TS ONLY" on the block
    diagram.
  - RS-232: "9 wire" on a "standard DB-25".
  - Columns: "80 column output possible from the TS2068", but the 2068's
    widest mode is 64 columns.
  - LAN input: "25 VAC max." in §4.2.2, but 24 VAC in §4.3.4.
  - Power pack: 17.5 V in §4.5, but 17 V DC in Figure 6.3-1.
  - The block diagram shows no RGB or audio outputs.
- **Handwritten revisions on the BSCC document:**
  - "DAVID BOYLE" is written at the top of page 1.
  - On page 6, the sentence tying the LOCALIAK pulse to the Z80
    interrupt-acknowledge is struck out by typewriter overstrike. A
    handwritten margin note then says that resetting the interrupt-caused bit
    "also causes the LOCALIA[K] line to be pulsed".
  - On page 4, "'s HS register" is written in to complete the two HS-MSN
    read-back paragraphs. The first of those two headings is a typing error:
    its title and text are the LSN read-back.

  Each revision is marked where it occurs.

## How to read the transcriptions

| Markup | Meaning |
|---|---|
| `<!-- PDF page N (printed page "Pg. X") -->` | Start of scan page *N*. TS2060 printed page numbers lag the PDF by 1–3, because the title page and the drawing sheets are unnumbered. |
| Headings | The documents' own section numbers and titles. The running page headers are not repeated. |
| `[handwritten: …]` | A handwritten addition on the typed page |
| `~~text~~` | Struck through on the page |
| `word[?]` / `[A? B?]` / `[illegible]` | Uncertain / two possible readings / unreadable |
| > *Transcriber's note:* | Layout, stamps, rotated pages, tables split across pages |
| `![…](figures/…)` + *[Diagram: …]* | A drawing: the page render, a one-line description, and every label on it |

Text is transcribed as printed, typos included ("Sspecification", "Buss",
"seperator", "algorythm"). Slashed zeros in the BSCC typescript are written
`0`. Active-low signals keep the document's own notation: a trailing `*` in
the TS2060 document, and an overbar in the BSCC document (rendered as an HTML
`<span>`, which some viewers show as plain text).

## Verification

- **Transcription (2026-10):** read page by page from the 300 dpi scans at
  220–400 dpi, with no OCR. The rotated drawings were turned upright before
  reading.
- **Independent check:** a second reader re-read the reference-data pages from
  the scans and compared them row by row with the transcriptions. Those were
  all of BSCC pages 2–7 (page 1's table was checked separately), and TS2060
  pages 13–18 and 21: the unit specifications, every pin table including all
  64 bus rows, and the I/O port map. No character errors were found. One
  transcriber's note was corrected (a strike-through on BSCC page 6 is
  typewriter overstrike, not pen). The remaining TS2060 prose pages and the
  figure label lists have had only the first careful reading.
- **Document errors the check found** (left as printed):
  - BSCC page 6 says INTRQ "sets bit 0" of STATUS-L, though Table Two and the
    polling paragraph treat that bit as active low.
  - The page 2 example shifts with `SRA` where `SRL` would be expected. That
    is harmless, since only the low nybble reaches the bus.
- The BSCC Figure One addresses (`4000h`, `A000h`, `C000h`, `E000h`) were
  checked a third time at 400 dpi because of the conflict with the ROM.
- The EXROM comparison above was made against
  `../../disassemblies/2068_DEFS.ASM` and `../ts2068_memory_map.md`.

## Rights

See [NOTICE.md](NOTICE.md). The original documents are Timex Computer Corp.
material, included for preservation and reference. They are **not** covered
by this repository's GPL licence. The transcriptions and notes are CC0 1.0.
