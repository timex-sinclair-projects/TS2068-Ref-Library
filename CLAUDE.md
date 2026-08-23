# TS2068 Reference Library

This project is a workspace for **disassembling and writing new Z80 assembly code** for the **Timex/Sinclair 2068** computer (adapted from the Sinclair ZX Spectrum 48K).

## Installed Tools

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

### z80asm Usage

```sh
# Assemble a single file
z80asm -o output.bin source.asm

# With listing file
z80asm -l -o output.bin source.asm
```

### z88dk

Installed at `~/z88dk/z88dk/`. Environment variables configured in `~/.zshrc`:
- `Z88DK_HOME=$HOME/z88dk/z88dk`
- `ZCCCFG=$Z88DK_HOME/lib/config`
- `PATH` includes `$Z88DK_HOME/bin`

Key binaries: `zcc` (C compiler frontend), `z88dk-z80asm` (assembler), `z88dk-appmake` (binary packaging), `z88dk-dis` (disassembler), `z88dk-z80nm` (object inspector).

To update z88dk, re-download from `http://nightly.z88dk.org/z88dk-osx-latest.zip`.

## Reference Documentation

All reference materials are in `docs/`. Consult these when working with TS2068 code:

| File | Contents |
|------|----------|
| `z80_combined_reference.md` | Z80 instruction set with opcodes, T-states, and flag effects |
| `ts2068_memory_map.md` | 64K chunked memory layout, ROM/RAM regions, I/O ports |
| `ts2068_system_variables.md` | System variables ($5C00–$5CCB) with IY-relative offsets |
| `ts2068_dispatcher.md` | Function dispatcher API — 100+ stable service calls |
| `ts2068_rom_entry_points.md` | HOME ROM and EXROM subroutine addresses |
| `ts2068_video_and_cartridges.md` | Video modes, DECR register, cartridge types, SYSCON table |
| `ts2068_tokens_and_keyboard.md` | BASIC tokens, keyboard layout, AY sound chip registers |
| `ts2068_errata_and_notes.md` | Known bugs (NMI handler, CLOSE-DFILE) and uncertain areas |
| `ts2068_quick_reference.md` | Cheat sheet of key addresses, ports, formulas |
| `ts2068_vs_spectrum48_comparison.md` | Differences from ZX Spectrum 48K (tokens, tape, I/O, frame rate) |
| `spectrum48_rom_entry_points.md` | ZX Spectrum 48K ROM entry points (for comparison/porting) |
| `Timex Sinclair 2068 HOME ROM.txt` | Full HOME ROM disassembly (TASM format) |
| `Timex Sinclair 2068 EXROM.txt` | Full EXROM disassembly (TASM format) |

## Key TS2068 Facts

- **CPU:** Z80A at 3.528 MHz
- **Frame rate:** 60 Hz (~58,800 T-states/frame)
- **IY register:** Always $5C3A (points to ERR_NR) — never modify
- **Memory:** 8 chunks of 8K each; HOME ROM (chunks 0–1), display (chunk 2), dispatcher/stack (chunk 3), RAM (chunks 4–7)
- **ROM version byte:** $0013 = $FF (only released version)

### I/O Ports

| Port | Direction | Purpose |
|------|-----------|---------|
| $FE | W | Border color (bits 2–0), MIC (bit 3), speaker (bit 4) |
| $FE | R | Keyboard half-row (bits 4–0, active low), EAR (bit 6) |
| $FF | W | DECR — video mode, paper color, KB interrupt disable, EXROM select |
| $F4 | W | HSR — chunk selection (bit=0 HOME, bit=1 DOCK cartridge) |
| $F5 | W | AY-3-8910 register select |
| $F6 | R/W | AY-3-8910 data |
| $FB | R | Printer BUSY |

### Display File

- **Primary:** Pixels $4000–$57FF, attributes $5800–$5AFF (256x192, 32x24 attrs)
- **Secondary:** $6000–$7BFF (when VIDMOD != 0); relocates dispatcher to $F7C0 and stack
- **Video modes:** Standard ($00), dual-file ($01), hi-color ($02), 64-column ($04)

### Dispatcher (Preferred API)

Located at $6200 (normal) or $F9C0 (extended video). Use the dispatcher instead of direct ROM calls for version independence. Calling convention:

```z80
    PUSH word       ; PRM_OUT (result space)
    PUSH word       ; PRM_IN (input parameter)
    LD   A,svc_code
    CALL dispatcher_addr
    POP  word       ; retrieve result from PRM_OUT
```

Key services: SENDTV ($1D), CLS ($22), SELECT ($29), WRCH ($50), PLOT ($58), BEEP ($1B), LOAD ($05), SAVE ($07).

### Spectrum Compatibility Notes

- RST vectors $00–$38 are identical
- System variables $5C00–$5CB5 are identical
- Tape routines moved to EXROM — use dispatcher, not direct ROM calls
- TS2068 adds 5 tokens ($C0–$C4: DELETE, ON ERR, STICK, SOUND, FREE) which shift all command tokens by +5
- FRAMES counter increments at 60 Hz (not 50 Hz)
- Character set at $3D00 is identical

### Known Bugs

- **NMI handler ($0066):** Inverted branch logic — `JR NZ` should be `JR Z`. Non-zero NMIADD triggers reset instead of user handler.
- **CLOSE-DFILE (EXROM $0E27):** Cannot reliably close second display file. Avoid unless display stays open.

## Binary Files

- `Zebra OS-64.BIN` — 16K binary ROM/OS image (likely a 64-column OS variant)

## Assembly Format

ROM disassemblies use **TASM format** with standard Z80 mnemonics. Expect `DEFB`/`DEFW` pseudo-ops, `ORG` directives, and a `2068_DEFS.ASM` include for symbol definitions.
