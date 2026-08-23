# TS 2068 Video Modes, Cartridges, and SYSCON

---

## Video Modes

The SCLD chip in the TS 2068 supports several display modes beyond the standard
Spectrum mode. The mode is controlled by writing to the Display Enhancement Control
Register (DECR, port $FF).

### Mode Summary

| DECR bits | Mode | Description |
|-----------|------|-------------|
| $00       | Standard | 256×192 pixels, 32×24 color cells (Spectrum compatible) |
| $01       | Dual-file | Two display files; allows page-flipping or overlay effects |
| $02       | Hi-color  | 256×192, one attribute byte per pixel pair (ultra-high-resolution color) |
| $04       | 64-column | 64×24 text, 2 pixels per character width |
| $01+$02   | Dual + hi-color | Combined |

**Bit 7 of DECR must be preserved** — it controls EXROM selection. Always keep a RAM
copy of the current DECR value and OR your mode bits into it.

### Standard Mode ($00)

- 256 × 192 pixels
- 32 × 24 attribute cells (8×8 pixels each)
- Display file at $4000–$57FF (pixels) and $5800–$5AFF (attributes)
- Standard ZX Spectrum layout; most Spectrum software uses this

### Second Display File Mode (DECR bit 0 = 1)

Opening the second display file via OPEN-DFILE ($08 dispatcher / CHNG_VID):

1. UDG is moved to high RAM
2. Dispatcher code and machine stack relocated from $6000 to $F7C0
3. Second display file occupies $6000–$7BFF (pixels + attributes)
4. VIDMOD ($5CC2) is set to the requested mode (non-zero)

**After opening second display file:**
- VIDMOD ≠ 0 → use dispatcher at $F9C0 (not $6200)
- Machine stack base moves to ~$F9C0
- UDG at new address (read from UDG system variable at $5C7B)

**Closing:** CLOSE-DFILE moves everything back. Note: the disassembly indicates
the CLOSE-DFILE routine has a bug and does not work properly.

### 64-Column Mode (DECR bit 2 = 1)

- 64 characters per row × 24 rows
- Each character is 4 pixels wide × 8 pixels tall
- Paper color for the entire display set by DECR bits 5-3
- Ink color determined by individual pixel pairs within cells

### Ultra-High-Resolution Color (DECR bit 1 = 1)

- One attribute byte per pixel pair (every 2 horizontal pixels gets its own color)
- Same pixel resolution as standard mode
- Attribute file layout differs from standard

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
8. Move dispatcher code + stack from $6000 to $F7C0 (BC=$0840 bytes)
9. Walk fix table at $1D00 to update all internal addresses in moved code
10. Store video mode in VIDMOD
11. Enable interrupts (EI)
12. Clear second display file ($6000–$7AFF → all zeros)
13. Set DECR register (preserve bit 7, OR in requested mode bits 0-6)
14. Restore registers, RET
```

The fix table at EXROM $1D00 contains address pairs: (offset-into-moved-code, value-to-fix).
Each entry has the old address in the code replaced by old + $97C0 (the relocation offset).
A zero entry terminates the table.

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

For a cartridge in all 8 chunks: HSR = $FF (all chunks from DOCK).
For EXROM in chunks 0-1 only: HSR = $03.

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

The HOME ROM contains a version byte at $0013 (decimal 19):
```
M0013   DEFB $FF    ; Version identifier. Would count down with ROM revisions.
```
Value $FF = version 1 (the only version released). Future ROM upgrades would have
used lower values. Software can detect the ROM version by reading address $0013.

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

When the second display file is open, MSTBOT ($5CC0) and ERRSP are updated to
reflect the stack's new location near $F9C0.

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