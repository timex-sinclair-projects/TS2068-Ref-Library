# TS 2068 Video Modes, Cartridges, and SYSCON

---

## Video Modes

The SCLD chip in the TS 2068 supports several display modes beyond the standard
Spectrum mode. The mode is controlled by writing to the Display Enhancement Control
Register (DECR, port $FF).

### Mode Summary

DECR bits **D2-D0 are a 3-bit mode field, not three independent flags** — see the
table on page 35 of the Technical Manual (`technical-manual/02-hardware-guide.md`).

| D2-D0 | Mode | Description |
|-------|------|-------------|
| `000` ($00) | Standard | 256×192 pixels, 32×24 color cells (Spectrum compatible) |
| `001` ($01) | Dual-file | Two display files; allows page-flipping or overlay effects |
| `010` ($02) | Hi-color | 256×192, one attribute byte per 8×1 pixel strip (ultra-high-resolution color) |
| `110` ($06) | 64-column | 64×24 text on a 512-dot line; each character is 8 half-width dots |

The manual notes that other combinations "may produce unpredictable results".

> **Corrected.** An earlier revision of this file listed 64-column mode as `$04`
> and described it as "DECR bit 2", and gave 2 pixels per character; a later one
> said "4 pixels per character". The mode value is `110` = `$06` — the Zebra
> OS-64 ROM, a shipping 64-column OS, does `LD C,$06 / ADD A,C / OUT ($FF),A`
> and calls `$06` the "64-col mode enable bits" (see `zebra_os64_analysis.md`).
> Each character is a whole display-file byte (8 dots) taken alternately from
> the two display files (Technical Manual §5.2.3), so "4 pixels" is true only as
> a width: 4 standard pixels' width, 8 dots.

**Bit 7 of DECR must be preserved** — it selects EXROM (1) or DOCK (0) for the
chunks the HSR switches. The stock ROMs keep no RAM copy; they read the port
back and OR the mode in: `IN A,($FF) / AND $80 / OR mode / OUT ($FF),A`
(EXROM OPEN-DFILE $0E1B, CHNG_VID $0EF4). The Technical Manual port table lists
$FF as R/W.

### Standard Mode ($00)

- 256 × 192 pixels
- 32 × 24 attribute cells (8×8 pixels each)
- Display file at $4000–$57FF (pixels) and $5800–$5AFF (attributes)
- Standard ZX Spectrum layout; most Spectrum software uses this

### Second Display File Mode (DECR D2-D0 = `001`, i.e. `$01`)

Opening the second display file via CHNG_VID (EXROM $0E8E), which calls OPEN-DFILE.
(Dispatcher service $08 is meant to reach CHNG_VID, but in the stock EXROM its
jump-table word is $0EA3, mid-instruction — see `ts2068_dispatcher.md`; call
$0E8E with the EXROM paged in, as `ts2068_extended_color_mode.md` does.)

1. CHNG_VID opens $12C0 bytes at $6840, moving CHANS to $7B00 and PROG to $7B16
2. UDG is moved **down** by $0840 bytes ($FF58 → $F718 with the power-on layout)
3. The $6000–$683F block (machine stack $6000–$61FF + dispatcher code
   $6200–$682F) is copied to $F7C0–$FFFF (+$97C0)
4. Second display file occupies $6000–$7AFF (pixels $6000–$77FF, attributes
   $7800–$7AFF) and is cleared
5. VIDMOD ($5CC2) is set to the requested mode (non-zero)

**After opening second display file:**
- VIDMOD ≠ 0 → use dispatcher at $F9C0 (not $6200); code is $F9C0–$FFEF
- Machine stack is $F7C0–$F9BF; MSTBOT = $F9C0 (CHNG_VID adds $97C0)
- UDG at new address (read from UDG system variable at $5C7B)
- RAMTOP is not changed

**Closing:** CLOSE-DFILE moves everything back. It is often reported not to work
properly; that report is **(unverified)** — the stock code mirrors OPEN-DFILE and
no failure mechanism has been found (see `ts2068_errata_and_notes.md`).

### 64-Column Mode (DECR D2-D0 = `110`, i.e. `$06`)

- 64 characters per row × 24 rows
- Each character is one display-file byte — 8 dots × 8 lines — from the primary
  file for even columns and the second file for odd columns, so a line is 512
  dots, each half the width of a standard pixel (Technical Manual §5.2.3)
- DECR bits 5-3 select one ink colour, with its complementary paper, for the
  whole screen; BRIGHT and FLASH are fixed at 0 and the border follows the paper
- The attribute areas ($5800–$5AFF, $7800–$7AFF) are not read

### Ultra-High-Resolution Color (DECR D2-D0 = `010`, i.e. `$02`)

- One attribute byte per 8×1 pixel strip — 6144 attribute bytes
- Same pixel resolution as standard mode
- Attributes live in the second display file at $6000–$77FF, with exactly the
  pixel file's layout: attribute address = pixel address + $2000. See
  `ts2068_extended_color_mode.md`

---

## OPEN-DFILE Sequence (EXROM $0DB0)

```
1. Save registers
2. Calculate bytes used by UDG (PRAMT - UDG)
3. Calculate new UDG position = current UDG - $0840 (space for dispatcher + stack)
4. Move UDG to new location (LDIR)
5. Update UDG pointer
6. Disable interrupts (DI)
7. Adjust SP by +$97C0 (move stack to high memory)
8. Move the $6000–$683F block (machine stack $6000–$61FF + dispatcher code $6200–$682F)
   to $F7C0–$FFFF (BC=$0840 bytes); the dispatcher entry goes $6200 → $F9C0
9. Walk fix table at $1D00 to update all internal addresses in moved code
10. Store video mode in VIDMOD
11. Enable interrupts (EI)
12. Clear second display file ($6000–$7AFF → all zeros)
13. Set DECR register (preserve bit 7, OR in requested mode bits 0-6)
14. Restore registers, RET
```

The fix table at EXROM $1D00 is a list of single words — 61 of them, then a $0000
terminator at $1D7A. Each word is the low-memory address of a 16-bit operand in
the dispatcher code; OPEN-DFILE adds $97C0 to that address to find the moved
operand, then adds $97C0 to the operand itself (EXROM $0DEE–$0E03). CLOSE-DFILE
walks the same table subtracting $97C0.

OPEN-DFILE does not touch ERRSP, LISTSP or MSTBOT; CHNG_VID adds $97C0 to all
three after it returns (EXROM $0ED3–$0EE8).

---

## Cartridge System

The TS 2068 supports ROM and RAM cartridges via the DOCK connector.

### Cartridge Types

| Type | Name | Description |
|------|------|-------------|
| LROS | Language ROM | Replaces or augments the OS; jumps to cartridge code after init |
| AROS | Autorun ROM  | Contains BASIC programs or MC that runs from cartridge space |
| DOCK | General      | Any code/data mapped into DOCK memory chunks |

### Memory Chunk Layout with Cartridges

The HSR (port $F4) and DECR (port $FF) control which chunks come from which source.

For a cartridge in all 8 chunks: HSR = $FF (all chunks from DOCK), DECR bit 7 = 0.
For the EXROM: HSR = $01 with DECR bit 7 = 1. The EXROM is one 8K ROM at
$0000–$1FFF of the extension bank (Technical Manual §2.1.4) and the stock ROMs
only ever select it through HSR bit 0; what chunk 1 (or any higher chunk)
returns with DECR bit 7 set is **(unverified)**.

A cartridge can occupy any subset of the 8 chunks. The chunk specification in
SYSCON (byte 4 of AROS entry, byte 4 of LROS entry) uses a bitmask:
- Bit N = 0 means chunk N IS used by the cartridge
- Bit N = 1 means chunk N is NOT used (free)
- **Bits 0-3 must be set to 1** (chunks 0-3 not used) for BASIC AROS autostart

### LROS Behavior

After OS initialization completes, if an LROS is detected in SYSCON:
- The OS jumps to the address in SYSCON LROS bytes 02-03
- Bits 5-3 of chunk spec should mark chunk 3 as available (bit 3 = 1) for the JP to work
- LROS replaces or supplements the OS; it typically sets up its own environment

### AROS Behavior

BASIC AROS (language type = 1):
- Cartridge contains BASIC program lines
- OS loads and runs the BASIC program from cartridge space
- CH_ADD, NXTLIN, DATADD may point into cartridge (DOCK) space
- ARSFLAG bit 7 (AROS) is set; other bits indicate which pointers are in cartridge

Machine code AROS (language type = 2):
- OS jumps to the address in SYSCON AROS bytes 02-03
- Code runs in cartridge space

---

## SYSCON Table Format ($5EEA–$5FFF)

The SYSCON table is at the address stored in the SYSCON system variable ($5CBC), default $5EEA.

### AROS Entry (8 bytes at SYSCON+0)

| Offset | Content |
|--------|---------|
| 00 | Language type: 1=BASIC, 2=Machine code |
| 01 | Cartridge type: 2=AROS |
| 02-03 | Starting address (LSB/MSB). BASIC: first program line. MC: first instruction |
| 04 | Chunk specification (low-active bitmask; 0=in use, 1=not used). Bits 0-3 must be 1 |
| 05 | Autostart: 0=no autostart, 1=autostart |
| 06-07 | Bytes of RAM to reserve for MC variables (LSB/MSB) |

### LROS Entry (4+1 bytes at SYSCON+8)

| Offset | Content |
|--------|---------|
| 00 | Not used |
| 01 | Cartridge type: 1=LROS |
| 02-03 | Starting address (LSB/MSB) — jump target after OS init |
| 04 | Chunk specification (low-active). Bit 3 must be 1 for JP to work |

### Expansion Bank Entry (24 bytes each, follows LROS entry)

| Offset | Content |
|--------|---------|
| 00 | Type: 01=ROM, 02=RAM, 00=Inactive |
| 01 | Bank number (MSB set = not yet renumbered) |
| 02 | For RAM: chunks available (hi-true). For ROM: channel specifier (ASCII, uppercase) |
| 03-04 | Address of OPEN routine |
| 05-06 | Address of CLOSE routine (call with RAM Res Code, PRM_OUT=2, stream# on stack) |
| 07-08 | Address of SELECT routine |
| 09-0A | Address of device INPUT routine |
| 0B-0C | Address of device OUTPUT routine |
| 0D-0E | Address of disk command handler |
| 0F-10 | Address of device interrupt handler (92 bytes of code) |
| 11-12 | Address of device initialization code (cold start) |
| 13-14 | Address of device reset routine (warm start) |
| 15 | Device type: bit 0: 0=bootable, 1=initializable; bit 1: 0=non-storage, 1=storage |
| 16 | Boot priority (lower = higher priority; HOME bank = $80) |
| 17 | Interrupt priority (RAM=255; ROM gets lower value = higher priority) |

Up to 11 expansion bank entries follow the LROS entry.
A zero byte at the start of an entry (type=Inactive) acts as end-of-table.

---

## ROM Version Byte

**(unverified)** Timex-derived documentation describes $0013 (decimal 19) as a
version byte — $FF = version 1, with later revisions counting down. The stock
disassembly (`disassemblies/ts2068_home_rom_U16_stock.txt`) has no such label:
$0013 is one of the `RST $38` ($FF) filler bytes after `WRCH` at $0010. It is
$FF in both HOME ROM images in this repository, so it cannot tell them apart.
See the $0013 note in `CLAUDE.md`.

---

## PASSING Routine (EXROM)

The PASSING routine enables the dispatcher to call routines that span the HOME ROM
and EXROM. It handles the bank switch needed when a service call must reach code in
a different ROM bank than the caller's context.

When EXROM is active and RST 8 fires (error), XRST8 routes back to the HOME ROM
via GOTO_BANK at the appropriate dispatcher location ($6200 or $F9C0 depending on VIDMOD).

The GOTO_BANK / CALL_BANK dispatcher services ($11 / $12) handle cross-bank calls
for expansion bank cartridges.

---

## Machine Stack Location and ERRSP

ERRSP ($5C3D) holds the stack pointer value used when an error occurs. It points
to the machine stack frame that will be restored on any BASIC error.

Default: $61FC (just below the machine stack base at $6200).

When the second display file is open, CHNG_VID adds $97C0 to MSTBOT ($5CC0),
ERRSP and LISTSP, so MSTBOT = $F9C0 and the default ERRSP becomes $F9BC.

Machine code programs that use the OS error system should save and restore ERRSP:
```asm
    LD   HL, (ERRSP)   ; save current ERRSP
    PUSH HL
    LD   HL, my_error_handler
    LD   (ERRSP), HL   ; redirect errors to my handler
    ; ... do stuff ...
    POP  HL
    LD   (ERRSP), HL   ; restore
```