# TS 2068 Technical Reference Manual — chapter text

Markdown extraction of the **narrative half** of
[`../Timex Sinclair 2068 Technical Manual (best).pdf`](../Timex%20Sinclair%202068%20Technical%20Manual%20%28best%29.pdf),
for grepping and for reading in an editor. The PDF remains the authority; every
passage below carries an `<!-- PDF page N -->` marker so any claim can be traced
back to it.

## Chapters

| File | Manual section | PDF pages |
|------|----------------|-----------|
| [`00-front-matter.md`](00-front-matter.md) | Title, preface, table of contents | 1–5 |
| [`01-introduction.md`](01-introduction.md) | 1. Introduction — hardware, software and cartridge overviews | 6–11 |
| [`02-hardware-guide.md`](02-hardware-guide.md) | 2. Hardware Guide — SCLD, banking, keyboard, video, **port map**, connectors | 12–48 |
| [`03-system-software-guide.md`](03-system-software-guide.md) | 3. System Software Guide — ROM organization, RAM services, system variables | 49–63 |
| [`04-system-io-guide.md`](04-system-io-guide.md) | 4. System I/O Guide — channels, keyboard, screen, cassette, joysticks, sound | 64–74 |
| [`05-advanced-concepts.md`](05-advanced-concepts.md) | 5. Advanced Concepts — LROS/AROS cartridges, advanced video modes | 75–89 |
| [`06-known-bugs.md`](06-known-bugs.md) | 6. Known "Bugs" and Corrections | 90–104 |

`figures/` holds page renders for the diagrams. They are vector artwork from the
original Word document and carry no extractable text, so the whole page is
rendered at 150 dpi rather than the image being pulled out.

## What is deliberately not here

**Sections 7, 8 and 9 — PDF pages 105–401, about three quarters of the
document.** Those are the Home ROM source, the EXROM source and the assembler
include file. They are the *same disassembly project* already in
`../../disassemblies/`, rendered for a different assembler (`DFB`/`DWL` with
synthetic `Mxxxx:` labels, versus `DEFB`/`DEFW` with real addresses). Identical
distinctive comments confirm the shared lineage — right down to
`; POP HL and AF - WHY???`. Use these instead:

- `disassemblies/ts2068_home_rom_U16_stock.txt`
- `disassemblies/ts2068_exrom_U20_stock.txt`
- `disassemblies/2068_DEFS.ASM`

They are the better copies for reference work, because they carry the address
column that the manual's appendix omits entirely.

## Health warnings

**This edition is a second-hand reconstruction.** The PDF was made in 2016 by
cutting and pasting from an earlier PDF into Microsoft Word. Its own preface
warns that the paste "would sometimes mix text up in a way that word groups from
a particular sentence would be transposed to different locations". That is
visible on page 6, where the bullet list of hardware components has fragments of
the preceding sentence spliced into it. **The corruption is in the PDF, not in
this extraction** — verified by rendering the page. Clean markdown reads as more
authoritative than a PDF, so treat surprising statements as suspect and check
the page.

Known gaps and errors in the source document:

| Where | Problem |
|-------|---------|
| §2.2 Schematic Diagram (p37) | Text reads only "Under construction" — there is no schematic |
| §2.1.13.4 Sound Chip and Joystick I/O (p37) | The bit table is a duplicate of the printer table from the previous page. Real `$F5`/`$F6` bit assignments are not given |
| Figure 4.1.1-2 (p67) | Missing — the page contains only the placeholder "Keyboard flowcharts here" |
| Figure 4.1.2-2 (p70) | Missing — the page contains only the placeholder "FIGURE 4.1.2-2 Here" |
| Figure numbering (p43) | J4 signal layout is labelled "FIGURE 2.2.2-2" although it sits in §2.4.2 |
| §1.1 preface note | The detailed sound-chip and Z80 descriptions were removed from this edition |
| §4.2 Cassette Tape (p71–72) | The frequencies are the ZX Spectrum's at 3.5 MHz. The cycle counts are right (4032 / 1612 leader cycles = $1F80 / $0C98 half-cycles), but the EXROM's timing loops (W_TAPE, $0068–$00E4, identical to the Spectrum's) at the 2068's 3.528 MHz (§2.1) give 2168 T per leader half-cycle = **813.7 Hz** (not 806.5), 1710 T per zero-bit cycle = **2063 Hz** (not 2040), 3420 T per one-bit cycle = **1032 Hz** (not 1020), and a 667 + 735 T sync cycle = **2516 Hz** (not 2400). Leader durations 4.96 s and 1.98 s match the stated 5 s and 2 s |
| §4.3 Joysticks (p74) | Says "PSG Register 7, **Bit 5** is assumed to be zero, enabling I/O Port A for input". The port-A direction bit is **bit 6**, as §2.1.6.1 and the next sentence ("R7,B6=1") say. Note also that the stock HOME ROM writes $FF to R7 on its error-report path ($0EC8: `LD A,$07 / OUT ($F5),A / LD A,$FF / OUT ($F6),A`), so bit 6 is not in fact left at zero; how joystick reads behave afterwards on real hardware is **(unverified)** |
| §3.3.3 Machine Stack (note) | Says CHNG VID relocates the stack to "0F7C0H to 0F8BFH" with MSTBOT "0F8C0H" — only 256 bytes, contradicting the 512-byte stack ($6000–$61FF, MSTBOT $6200) in the same section. The stock ROMs give **$F7C0–$F9BF, MSTBOT $F9C0**: OPDFIL moves the whole $6000–$683F block up by $97C0 (EXROM $0DDD, `LD BC,$0840` copy to $F7C0) and CHG_V adds $97C0 to MSTBOT ($0EE4–$0EE8: $6200 + $97C0 = $F9C0) |
| §5.2.2 PLOTXY listing (p86–87) | After `OR (HL)` the listing goes straight to `LD A,20H`, so the pixel is never written back — a `LD (HL),A` is missing. The two bit-layout boxes above it are labelled the wrong way round: the Block / Line / Scan-row box is the (reversed) **Y** coordinate and the Column / Bit box is **X**, as the code itself uses them |

## One correction this conversion produced

The manual's DECR table (§2.1.13.1, page 35) gives D2–D0 as a **3-bit video mode
field**: `000` normal, `001` second display file, `010` hi-res graphics,
`110` 64-column. Three files in this repository previously described 64-column
mode as "DECR bit 2", i.e. `$04`. **It is `$06`.** Corroborated by the Zebra
OS-64 ROM, a shipping 64-column operating system, which does
`LD C,$06 / ADD A,C / OUT ($FF),A` and calls `$06` the "64-col mode enable bits"
(`../zebra_os64_analysis.md`). `ts2068_video_and_cartridges.md`,
`ts2068_memory_map.md` and `CLAUDE.md` have been corrected.

## How this was produced

Text with `pdftotext -layout`, one page at a time, footers stripped, blocks
classified as heading / preformatted / prose. Tables that matter for programming
— the port map, DECR, port `$FE`, the printer port, absolute ratings and the
connector list — were transcribed into real markdown tables by hand and each one
checked against a 150 dpi render of its page. Everything else is left inside
```text fences exactly as extracted, so nothing is silently reformatted.

A word-level diff between the raw per-page extraction and these chapters shows
78 differing word-instances, all of them on the five pages carrying hand-made
tables, and all of them intentional (`40c` → `−40 °C`, `Ink/Paper` → `ink/paper`
and so on). No text was dropped anywhere else.
