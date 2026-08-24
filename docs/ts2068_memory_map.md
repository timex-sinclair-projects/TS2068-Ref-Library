# TS 2068 Memory Map

## Overview

The TS 2068 uses a chunked memory architecture. The 64K address space is divided
into eight 8K **chunks** (0–7). The SCLD chip controls which physical ROM or RAM bank
occupies each chunk via two hardware registers.

```
Address Range   Chunk   Default Contents
$0000–$1FFF       0     HOME ROM (first 8K)
$2000–$3FFF       1     HOME ROM (second 8K)
$4000–$5FFF       2     Display file + attribute file (primary)
$6000–$7FFF       3     RAM — dispatcher, machine stack, UDG
$8000–$9FFF       4     RAM — BASIC program, variables, workspace
$A000–$BFFF       5     RAM
$C000–$DFFF       6     RAM
$E000–$FFFF       7     RAM
```

The EXROM (Extension ROM) is a separate 8K chip paged into the chunk space by the
Horizontal Select Register ($F4) and Display Enhancement Control Register ($FF).

---

## HOME ROM Internal Layout ($0000–$3FFF)

| Address      | Section |
|-------------|---------|
| $0000–$007B | Restart routines (RST 0, 8, 10, 18, 20, 28, 30, 38) |
| $007C–$0097 | Error-2, NMI handler, CH_ADD+1, SKIP-OVER |
| $0098–$0226 | BASIC keyword table (`TOKENS`) — token value = $A4 + table index, so it covers $A5 RND … $FF COPY, then the six 2068-only keywords (DELETE, ON ERR, STICK, SOUND, FREE, RESET) in keyword-table-2 order. Token values are identical to the ZX Spectrum's; see `ts2068_tokens_and_keyboard.md` |
| $0227–$024D | Main keys table (LCKEYS) |
| $024E–$0267 | Unshifted extended mode keys (EKEYS) |
| $0268–$0281 | Shifted extended mode keys (SEKEYS) |
| $0282–$028B | Control codes — digit+CAPS (NUMFNTBL) |
| $028C–$02A5 | Symbol shift keys (KKEYS) |
| $02A6–$02AF | Extended digit+symbol keys (SSKEYS) |
| $02B0–$04FF | Keyboard scanning routines |
| $0500–$07FF | Speaker / BEEP routines |
| $0800–$0FFF | Screen and printer handling routines |
| $1000–$17FF | Editor routines |
| $1800–$1FFF | Executive routines / BASIC main loop |
| $2000–$27FF | Cartridge-based BASIC routines (AROS/LROS) |
| $2800–$3CFF | BASIC line and command interpretation |
| $3D00–$3FFF | Character set (CHRSET) — 96 chars × 8 bytes |

---

## EXTENSION ROM Internal Layout ($0000–$1FFF, when mapped in)

| Address      | Section |
|-------------|---------|
| $0000–$0007 | XRST0 — handles cold start with EXROM active |
| $0008–$001B | XRST8 — RST 8 handler when EXROM is active |
| $001C–$0037 | XRST38 — keyboard interrupt handler (EXROM) |
| $0038–$0048 | XRST38 continued; KEYB-EXTVID / KEYB-NORMVID |
| $0049–$006A | EXROM-STARTUP / MOVE-TO-$6000 reboot fragment |
| $006B–$0FAF | Cassette handling routines |
| $1000–$10FF | Function dispatcher code (copied to RAM at boot) |
| $1100–$1CFF | Extension ROM initialization routines |
| $1D00–$1DFF | Address fix table for dispatcher relocation |
| $0DB0–$0E26 | OPEN-DFILE — open second display file |
| $0E27–$0E4F | CLOSE-DFILE — close second display file |
| $0E50–$0EFF | PASSING routine |
| $0F00–$0FFF | Bank-switching routines |

---

## RAM Layout (Default, No Cartridge)

```
$5C00–$5CBB   System variables  (see ts2068_system_variables.md)
$5CBC–$5CCB   TS-2068-specific system variables
$5CCB–$5EE9   Reserved expansion area (not used by OS)
$5EEA–$5FFF   SYSCON table      (see ts2068_syscon.md)

$6000–$61FF   Function dispatcher code (2K, copied from EXROM $1000)
$6200         MSTBOT — base of machine stack
$61FC         Default ERRSP — error recovery stack pointer

$6800+        CHANS area (21 bytes; 5 bytes per channel × 4 default channels K/S/R/P)
$6840+        BASIC program start (PROG)
              Variables area (VARS) — immediately after program
              Workspace (WORKSP) — after variables
              Calculator stack (STKBOT → STKEND) — after workspace

...

~$FF58        UDG — 21 user-definable graphics × 8 bytes = 168 bytes
$E100         RAMTOP (default — top of BASIC system area)
$FFFF         PRAMT (physical RAM top)
```

---

## Display File — Primary (Chunk 2: $4000–$5FFF)

```
$4000–$57FF   Pixel data  (6,144 bytes)
$5800–$5AFF   Attribute data  (768 bytes = 32 cols × 24 rows)
$5B00–$5BFF   (unused in standard mode)
```

### Pixel Address Formula

The display is organized as three bands of 8 character rows each. Within each band,
scan lines are interleaved by character row.

```
Given pixel column X (0–255) and row Y (0–191):

pixel_addr = $4000
           | ((Y & $C0) << 5)    ; band select
           | ((Y & $07) << 8)    ; scan line within band
           | ((Y & $38) << 2)    ; character row within band
           | (X >> 3)            ; byte within row

bit_mask   = $80 >> (X & 7)      ; bit 7 = leftmost pixel
```

### Attribute Address Formula

```
attr_addr = $5800 + ((Y >> 3) * 32) + (X >> 3)

Attribute byte: FLASH(7) | BRIGHT(6) | PAPER(5:3) | INK(2:0)
Colors: 0=Black 1=Blue 2=Red 3=Magenta 4=Green 5=Cyan 6=Yellow 7=White
```

---

## Display File — Secondary (when VIDMOD ≠ 0)

When the second display file is opened via OPEN-DFILE, it occupies chunk 3:

```
$6000–$79FF   Second pixel data
$7A00–$7BFF   Second attribute data
```

Because this overlaps the normal dispatcher/stack area, OPEN-DFILE:
1. Moves the UDG to high RAM
2. Moves the machine stack and dispatcher code to chunk 7 ($F7C0–$FFFF)
3. Updates MSTBOT, ERRSP, and all internal pointers via a fix table
4. Clears the new display file

After OPEN-DFILE:
- Dispatcher entry point: **$F9C0** (instead of $6200)
- Always re-check VIDMOD ($5CC2) before calling the dispatcher

---

## I/O Port Map

| Port  | Dir | Name | Description |
|-------|-----|------|-------------|
| $FE   | W   | ULA  | Border color (bits 2-0); MIC (bit 3); speaker (bit 4) |
| $FE   | R   | ULA  | Keyboard half-row (bits 4-0, 0=pressed); EAR (bit 6) |
| $FF   | W   | DECR | Display Enhancement Control Register — video modes, EXROM |
| $F4   | W   | HSR  | Horizontal Select — maps chunks to HOME or DOCK/EXROM |
| $F5   | W   |      | AY-3-8910 register address (SOUND: address port) |
| $F6   | W   |      | AY-3-8910 data write |
| $F6   | R   |      | AY-3-8910 data read (joystick via register 14) |
| $FB   | R   |      | Printer: bit 0 = BUSY |
| $A0   | W   |      | Universal Deselect Byte (expansion banks, normal mode) |
| $40   | W   | HS   | Horizontal Select for currently accessed expansion bank |
| $80   | W   | BNA  | Bank Number Accessed |
| $C0   | W/R | CMD  | Expansion bank command register |
| $FC   | W   | BDATPT | Expansion bank data port |
| $FD   | W   | BCMDPT | Expansion bank address port |

### DECR — Display Enhancement Control Register (port $FF, write only)

| Bits | Function |
|------|----------|
| D2-D0 | **Video mode field** (not independent flags): `000` normal · `001` second display file · `010` ultra-high-resolution colour · `110` 64-column. Other combinations are undefined. |
| D5-D3 | Ink/paper colour for 64-column mode: `000` black/white · `001` blue/yellow · `010` red/cyan · `011` magenta/green · `100` green/magenta · `101` cyan/red · `110` yellow/blue · `111` white/black |
| D6 | Inhibit the 17 ms interrupt — **0 enables** it |
| D7 | Enable EXROM in the EXROM bank |

> **Corrected.** An earlier revision listed D0/D1/D2 as separate flags and gave
> 64-column mode as bit 2 (`$04`). D2-D0 is one 3-bit field and 64-column is
> `110` = `$06`, per the Technical Manual §2.1.13.1 and the Zebra OS-64 ROM.

Bit 7 must be preserved. The OS keeps a copy in RAM; do the same in your code.

### HSR — Horizontal Select Register (port $F4, write only)

Bit N = 0 → chunk N from HOME ROM / home RAM
Bit N = 1 → chunk N from DOCK/EXROM space

Default: $00 (all from HOME). EXROM active in both 8K chunks: $03.

---

## Keyboard Half-Row Addressing

Read with `IN A,($FE)` while B holds the half-row selector. A 0 bit = key pressed.

| B value | Bit 0 | Bit 1 | Bit 2 | Bit 3 | Bit 4 |
|---------|-------|-------|-------|-------|-------|
| $FE     | CAPS-SHIFT | Z | X | C | V |
| $FD     | A | S | D | F | G |
| $FB     | Q | W | E | R | T |
| $F7     | 1 | 2 | 3 | 4 | 5 |
| $EF     | 0 | 9 | 8 | 7 | 6 |
| $DF     | P | O | I | U | Y |
| $BF     | ENTER | L | K | J | H |
| $7F     | SPACE | SYM-SHIFT | M | N | B |

Bit N of the B register selects the row whose bit is cleared (active low). Bit 0
of the read corresponds to the leftmost listed key per row -- which is the
rightmost key on the physical keyboard for the right-hand half-rows ($EF, $DF,
$BF, $7F). The OS keyboard scan starts with BC = $FEFE (B=$FE, C=$FE).

BREAK = CAPS-SHIFT (row $FE, bit 0) + SPACE (row $7F, bit 0).

---

## Dispatcher RAM Location Summary

| VIDMOD | Entry Point | Dispatcher Code | Machine Stack Base |
|--------|------------|-----------------|-------------------|
| 0      | $6200      | $6000–$61FF     | $6200 (grows down)|
| non-0  | $F9C0      | $F7C0–$F9BF     | $F9C0 (grows down)|

Test: `LD A,(VIDMOD)` / `OR A` / `JR Z, use_6200`