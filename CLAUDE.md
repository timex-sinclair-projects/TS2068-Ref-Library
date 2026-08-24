# TS2068 Reference Library

A workspace for **disassembling and writing new Z80 assembly code** for the
**Timex/Sinclair 2068**, and a reference set intended to be accurate enough that
an AI assistant can work from it without checking every claim.

Everything below has been checked against the ROM images and disassemblies in
this repository. Where a claim could not be verified from the material here, it
is marked **(unverified)**. Please keep that convention — a confidently stated
wrong address costs more than an admitted gap.

---

## READ THIS FIRST: which ROM image is which

`2068 ROMS/` contains **two different HOME ROMs and two different EXROMs**. They
are not interchangeable, and the disassemblies in `disassemblies/` match only
one pair.

| File | What it is | md5 |
|------|-----------|-----|
| `TS2068_U16.BIN` | **Stock HOME ROM** (U16 chip), 16K | `55d462fccc6c536037404ef4ced08bec` |
| `TS2068_U20.BIN` | **Stock EXROM** (U20 chip), 8K | `575d203c6e15e679fba0b73f854ec7a2` |
| `2068Home.BIN` | **Modified** HOME ROM, 147 bytes changed | `6843dfddc231083e2220b6b11424eb8d` |
| `2068Exrom.BIN` | **Modified** EXROM (community revision), 99 bytes changed | `e3863481d1273af637922415e96dbb0b` |

Provenance: `TS2068_ROMS_NoMod.zip` unpacks to `TS2068_U16.BIN` + `TS2068_U20.BIN`
("NoMod"). `2068ROMS.zip` unpacks to `2068MODU16.BIN` + `2068MODU20.BIN`
("MOD"), which were renamed to `2068Home.BIN` / `2068Exrom.BIN`.

**The disassemblies in `disassemblies/` are of the STOCK pair.** Verified two ways each:

- `disassemblies/ts2068_home_rom_U16_stock.txt` contains `© 1982 Sinclair Research Ltd` /
  `© 1983 Timex Computer Corp` and `RST $38` at `$0017` — both match
  `TS2068_U16.BIN`, not `2068Home.BIN` (whose copyright string is replaced with
  `T/S 2068 Computer  The Superior Machine.  (W.J.)` and whose `$0017` is `$BF`).
- `disassemblies/ts2068_exrom_U20_stock.txt` has `JR NZ` in the NMI handler and
  `GET_WORD: PUSH AF` — both match `TS2068_U20.BIN`, not `2068Exrom.BIN`.

What the modified images change:

- `2068Home.BIN` — copyright strings replaced; the NMI branch at `$006D` fixed
  (`$20` → `$28`); edits in 17 clusters including the character set
  (`$3F0E`–`$3FB4`). Purpose of the non-NMI changes is **(unverified)**.
- `2068Exrom.BIN` — the community EXROM revision analysed byte by byte in
  `docs/exrom_revision_analysis.md`: NMI fix at `$110E`, dispatch-table
  off-by-ones, a BANK_ENABLE rewrite, and other BEU bank-switching fixes.
  That document has been re-checked against these two exact images; all 99
  differing bytes are accounted for.

**Do not read a ROM address out of one image and an annotation out of the other.**
`$0013` is `$FF` in both HOME ROMs, so it cannot be used to tell them apart —
compare md5 instead.

---

## Installed Tools

*(Versions below are as recorded by the repo owner and have not been
re-verified in this environment.)*

| Tool | Version | Install | Purpose |
|------|---------|---------|---------|
| `z80dasm` | 1.2.0 | `brew install z80dasm` | Z80 disassembler — generates assembly from binary |
| `z80asm` | 1.8 | `brew install z80asm` | Standalone Z80 assembler |
| `z88dk` | nightly | `~/z88dk/z88dk/` | Z80 cross-compiler toolkit (zcc, z88dk-z80asm, z88dk-appmake, etc.) |

### z80dasm Usage

```sh
# Basic disassembly with labels and address comments
z80dasm -a -l -g 0x0000 input.bin -o output.asm

# With symbol file and block definitions
z80dasm -a -l -g 0x0000 -S symbols.sym -b blocks.def input.bin -o output.asm

# Include hex/ASCII source alongside disassembly
z80dasm -a -l -t -g 0x0000 input.bin -o output.asm
```

Key flags: `-a` (address comments), `-l` (auto-generate labels), `-g` (origin address), `-t` (hex/ASCII source), `-u` (show undocumented instructions inline), `-S` (load symbols), `-b` (block definitions for code vs data regions).

**Always use `-b`.** TS2068-era code is full of inline data placed after `CALL`
instructions (the routine pops its own return address and reads the bytes that
follow). A linear disassembler decodes that data as instructions, loses sync,
and then mis-types the *following* real code as data. `ts2068_toolkit_E930_annotated.asm`
documents a program where roughly half the image is affected.

### z80asm Usage

```sh
z80asm -o output.bin source.asm      # assemble
z80asm -l -o output.bin source.asm   # with listing
```

### z88dk

Installed at `~/z88dk/z88dk/`. Environment variables in `~/.zshrc`:
`Z88DK_HOME=$HOME/z88dk/z88dk`, `ZCCCFG=$Z88DK_HOME/lib/config`, `PATH` includes
`$Z88DK_HOME/bin`. Key binaries: `zcc`, `z88dk-z80asm`, `z88dk-appmake`,
`z88dk-dis`, `z88dk-z80nm`. Update from `http://nightly.z88dk.org/z88dk-osx-latest.zip`.

---

## Repository Map

### `docs/` — reference documentation

| File | Contents |
|------|----------|
| `z80_combined_reference.md` | Z80 instruction set with opcodes, T-states, and flag effects |
| `ts2068_memory_map.md` | 64K chunked memory layout, ROM/RAM regions, I/O ports, keyboard matrix |
| `ts2068_system_variables.md` | System variables ($5C00–$5CCB) with IY-relative offsets |
| `ts2068_dispatcher.md` | Function dispatcher API — 100+ stable service calls |
| `ts2068_rom_entry_points.md` | HOME ROM and EXROM subroutine addresses |
| `ts2068_video_and_cartridges.md` | Video modes, DECR register, cartridge types, SYSCON table |
| `ts2068_extended_color_mode.md` | Extended Color Mode (hi-colour): layout, entry/exit, failure modes |
| `ts2068_tokens_and_keyboard.md` | BASIC tokens, keyboard layout, AY sound chip registers |
| `ts2068_errata_and_notes.md` | Known bugs and areas where the disassembly is uncertain |
| `ts2068_quick_reference.md` | Cheat sheet of key addresses, ports, formulas |
| `ts2068_vs_spectrum48_comparison.md` | Differences from ZX Spectrum 48K |
| `spectrum48_rom_entry_points.md` | ZX Spectrum 48K ROM entry points (for comparison/porting) |
| `exrom_revision_analysis.md` | Byte-level analysis of the community EXROM revision |
| `zebra_os64_analysis.md` | Byte-level analysis of the Zebra OS-64 cartridge ROM |
| `Timex Sinclair 2068 Technical Manual (best).pdf` | The Technical Reference Manual, 401 pages. **Not a scan** — born-digital (Word → PostScript → Ghostscript, 2016), so the text layer is real text. See the caveats in `technical-manual/README.md` before trusting it |
| `technical-manual/` | The narrative half of that manual (pages 1–104) as markdown chapters, with page-render figures. Start at `technical-manual/README.md` |

`docs/` is prose reference only. The ROM listings and the symbol file live in
`disassemblies/`.

**`docs/technical-manual/`** holds sections 1–6 of the Technical Reference
Manual as seven markdown chapters plus a `figures/` folder. Sections 7–9 of the
manual (pages 105–401) are deliberately not converted: they are the same
disassembly already in `disassemblies/`, in a different assembler dialect and
without the address column. The manual is a 2016 reconstruction with known
transposition errors, two missing figures and an "under construction" schematic
section — `technical-manual/README.md` lists them.

### `disassemblies/`

| File | Contents |
|------|----------|
| `ts2068_home_rom_U16_stock.txt` | Full HOME ROM disassembly — of the **stock** `TS2068_U16.BIN` |
| `ts2068_exrom_U20_stock.txt` | Full EXROM disassembly — of the **stock** `TS2068_U20.BIN` |
| `2068_DEFS.ASM` | Symbol definitions — `INCLUDE`d by the two listings above, which is why it sits alongside them |
| `fdd3000_annotated.asm` | Annotated disassembly of `3000_2068.ROM` (FDD-3000 interface ROM) |
| `MasterChess disassembly.txt` | Disassembly of the MasterChess game |
| `ts2068_toolkit_E930_annotated.asm` | Annotated disassembly of *TS 2068 TOOLKIT* (Bob Mitchell, 1985), a 26-command BASIC toolkit at $E930–$FF57 |

> These three files previously existed twice, once here and once in `docs/`
> under different names. They have been collapsed to the single copies above and
> renamed so the filename records which ROM image each one disassembles.

### `tspico/` — TS-PICO peripheral

> **Local only — `tspico/` is listed in `.gitignore`,** so a fresh clone of this
> repository will not contain it.

`gus-home.rom` / `gus-exrom.rom` and their disassemblies are Gustavo Pane's
modified ROMs adding TPI (Timex Protocol Interface) support for the TS-PICO, a
Raspberry Pi Pico–based SD-card interface. `gus-rom-analysis.md` analyses them.
The four PDFs are the TPI protocol, filesystem and BASIC-extension specs.

### Root

| File | Contents |
|------|----------|
| `Zebra OS-64.BIN` | Zebra Systems OS-64 (1985) — an **LROS cartridge** image that replaces the HOME ROM with a 64-column-text version with Centronics printer support; ~1,279 bytes (7.8%) differ from stock. Includes the NMI fix. See `docs/zebra_os64_analysis.md` |
| `Zebra_OS-64.asm`, `Zebra_OS-64_annotated.asm` | Its disassembly, raw and annotated |
| `OS 64 Operating System Manual.pdf` | The matching Zebra manual |
| `3000_2068.ROM` | 4K FDD-3000 disk-interface ROM for the 2068 |
| `fdd3000.asm` | z80dasm output for the above (`-a -l -g 0 -t`) |
| `fdd_tpi_bridge.asm`, `_design.txt`, `_examples.asm` | Work in progress: adds CAT/ERASE/MOVE/FORMAT/CLOSE as native BASIC keywords routed to TPI commands, living in free EXROM space at $22AE–$3FFF |
| `eToolkit.ROM`, `eToolkit_mc.asm`, `eToolkit_listing.bas` | eToolkit EPROM by Thomas B. Woods, with extracted machine code and BASIC listing |
| `ecm-blog-post.md` | Article draft on Extended Color Mode |

---

## Key TS2068 Facts

- **CPU:** Z80A at 3.528 MHz
- **Frame rate:** 60 Hz — 3,528,000 / 60 = **58,800 T-states/frame**
- **IY register:** Always $5C3A (points to ERR_NR) — never modify. All
  `(IY+n)` offsets in the ROM are relative to this.
- **Memory:** eight 8K chunks. Chunks 0–1 HOME ROM ($0000–$3FFF); chunk 2
  display file + system variables ($4000–$5FFF); chunk 3 dispatcher, machine
  stack, channels and the start of the BASIC program ($6000–$7FFF); chunks 4–7
  RAM ($8000–$FFFF). Default RAMTOP $E100.
- **$0013:** several documents in this repo call this a "ROM version byte"
  ($FF = v1), sourced from Timex documentation. The disassembly shows no such
  label — `$0013` sits in the five `RST $38` filler bytes between `WRCH`
  ($0010: `JP $11ED`) and `GETCURCH` ($0018). The version reading is plausible
  but **(unverified)** here, and it is `$FF` in both HOME ROM images, so it is
  useless for telling images apart.

### I/O Ports

| Port | Direction | Purpose |
|------|-----------|---------|
| $FE | W | Border color (bits 2–0), MIC (bit 3), speaker (bit 4) |
| $FE | R | Keyboard half-row (bits 4–0, active low), EAR (bit 6) |
| $FF | W | DECR — video mode, paper color, KB interrupt disable, EXROM select |
| $F4 | W | HSR — chunk selection (bit N=0 HOME, bit N=1 DOCK/EXROM) |
| $F5 | W | AY-3-8912 register select |
| $F6 | W | AY-3-8912 data write |
| $F6 | R | AY-3-8912 data read (joystick via register 14) |
| $FB | R | Printer BUSY (bit 0) |
| $A0, $40, $80, $C0, $FC, $FD | W/R | Bus Expansion Unit ports — the BEU was never produced; see `ts2068_memory_map.md` |

**DECR (port $FF, write-only)** — bits 3–5 select the ink/paper colour for
64-column mode; bit 6 inhibits the 17 ms interrupt (**0 enables** it); bit 7
enables the EXROM. Bit 7 must be preserved; the OS keeps a RAM copy and so
should your code.

**D2-D0 is a 3-bit video mode field, not three independent flags:** `000`
standard ($00), `001` dual-file ($01), `010` hi-colour ($02), `110` 64-column
(**$06**, not $04). Verified against the Technical Manual §2.1.13.1 and against
the Zebra OS-64 ROM, which does `LD C,$06 / ADD A,C / OUT ($FF),A` and calls
`$06` the "64-col mode enable bits".

### Display File

- **Primary:** pixels $4000–$57FF, attributes $5800–$5AFF (256×192, 32×24 attrs)
- **Secondary (VIDMOD $5CC2 ≠ 0):** pixels $6000–$79FF, attributes $7A00–$7BFF
- Opening the second display file overwrites chunk 3, so OPEN-DFILE relocates
  the UDGs, the machine stack and the dispatcher into chunk 7:
  dispatcher **code** to $F7C0–$F9BF, dispatcher **entry point** and stack base
  to **$F9C0**.

### Dispatcher (Preferred API)

Located at **$6200** when VIDMOD ($5CC2) = 0, **$F9C0** when it is non-zero.
Always test VIDMOD before calling. Use the dispatcher rather than direct ROM
calls so code survives ROM changes.

The service code is a **16-bit word pushed on the stack**, not a value in `A`.
Verified from the dispatcher source at EXROM $1000: it does `LD IX,0 / ADD IX,SP`
on entry and then reads `(IX+2)/(IX+3)` as SVC_CODE, `(IX+4)/(IX+5)` as PRM_IN,
`(IX+6)/(IX+7)` as PRM_OUT, with `(IX+0)/(IX+1)` as the return address. So it
must be reached with `CALL`:

```z80
    ; push any stack parameters the service takes first
    LD   DE,prm_out
    PUSH DE              ; PRM_OUT
    LD   DE,prm_in
    PUSH DE              ; PRM_IN
    LD   DE,svc_code     ; bit 15 set = jump instead of call
    PUSH DE              ; SVC_CODE
    LD   A,(VIDMOD)
    OR   A
    CALL Z,$6200
    ...
```

Sample services: LOAD $05, MERGE $06, SAVE $07, PARP (tone) $1A, BEEP $1B,
SENDTV $1D, CLS $22, SELECT (stream) $29, INSERT $2A, FIND_L $35, CHK_SZ $4A,
PLOT $58, WRCH $87, K_CLS $8D. Full table in `docs/ts2068_dispatcher.md`.

### Spectrum Compatibility Notes

- RST vectors $00–$38 are identical
- System variables $5C00–$5CB5 are identical
- Tape routines moved to EXROM — use the dispatcher, not direct ROM calls
- **BASIC tokens $A5–$FF are identical to the Spectrum's — nothing is shifted.**
  Verified against the ROM keyword table (`TOKENS`, token value = $A4 + index):
  $A5 RND … $C4 BIN, $C5 OR … $CF CAT, $D0 FORMAT … $FF COPY. So $C0 is USR,
  $C4 is BIN, $E4 is DATA, $E6 is NEW, $EA is REM, $EC/$ED are GO TO/GO SUB.
  The 2068's six extra keywords had no free slots and overload low codes,
  disambiguated by parse context in the executor at $1A6x: $0C DELETE,
  $7B ON ERR, $7C STICK, $7D SOUND, $7E FREE, $7F RESET. $90–$A4 is the UDG
  character range, not tokens.
- FRAMES counter increments at 60 Hz (not 50 Hz)
- Character set at $3D00 is identical to the Spectrum's, at the same address
- Most ROM *subroutine* addresses differ, so Spectrum code that calls the ROM
  directly will not run

### Known Bugs

- **NMI handler (HOME ROM $0066, branch byte at $006D; EXROM copy at $110E).**
  The code is:

  ```z80
  PUSH AF / PUSH HL / LD HL,(USRNMI) / LD A,H / OR L
  JR NZ,$0070          ; <-- should be JR Z
  JP (HL)
  $0070: POP HL / POP AF / RETN
  ```

  With `JR NZ`, a **zero** NMIADD falls through to `JP (HL)` with HL = 0, which
  jumps to $0000 and resets the machine; a **non-zero** NMIADD branches straight
  to the exit and returns without ever calling the user handler. So the user
  handler is never reached either way, and it is the *empty* vector that
  triggers the reset. (Several documents state this the other way round; the
  ROM listing above is the authority.) Fixing it means changing `$20` to `$28`
  at $006D — which is what both `2068Home.BIN` and the Zebra OS-64 ROM do.

- **CLOSE-DFILE (EXROM $0E27):** cannot reliably close the second display file.
  Avoid opening it unless it can stay open for the life of the program, or
  write your own relocation code modelled on OPEN-DFILE.

- **BEU bank-switching services ($0E–$13):** written for hardware that was never
  produced and never tested against it. `exrom_revision_analysis.md` documents
  several genuine bugs in this code.

---

## Working With the Disassemblies

**Assembly format.** The ROM listings are **z88dk-z80asm** syntax, not TASM:
`DEFB` / `DEFM` / `DEFW`, `DEFC name = value`, `ORG`, `ASMPC` for the program
counter, and `&` for string concatenation — e.g.
`DEFM "RN"&('D'+$80)` and `DEFC BS_MAX = $5200+ASMPC`. Terminated strings use
the last character + $80. `disassemblies/2068_DEFS.ASM` supplies the symbol
definitions and is `INCLUDE`d by both listings.
(By contrast, `fdd3000.asm` is z80dasm output, which uses lower-case mnemonics
and `l0000h:` labels, and the Spectrum 48K reference *is* from a TASM listing.)

**HTML escaping.** `ts2068_home_rom_U16_stock.txt` and
`ts2068_exrom_U20_stock.txt` were passed through an HTML encoder at some
point and contain literal `&amp;` for `&`, plus `&amp;amp;lt;` / `&amp;amp;gt;`
inside comments. Decode before parsing, and do not mistake them for source.

**Inline data after CALL.** See the note under z80dasm above. When a
disassembly starts producing nonsense right after a `CALL`, suspect an inline
parameter block rather than an opcode you have misread.
