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
$6000–$7FFF       3     RAM — machine stack, dispatcher code, CHANS, start of BASIC program
$8000–$9FFF       4     RAM — BASIC program, variables, workspace (continued)
$A000–$BFFF       5     RAM
$C000–$DFFF       6     RAM
$E000–$FFFF       7     RAM — UDG at the top ($FF58–$FFFF), RAMTOP just below
```

The EXROM (Extension ROM) is a separate 8K chip paged into the chunk space by the
Horizontal Select Register ($F4) and Display Enhancement Control Register ($FF).

---

## HOME ROM Internal Layout ($0000–$3FFF)

| Address      | Section |
|-------------|---------|
| $0000–$0073 | Restart routines (RST 0, 8, 10, 18, 20, 28, 30, 38), error entry, NMI handler at $0066 |
| $0074–$0097 | NEXTCH, NC_HL, TC_HL (CH_ADD+1), TEST_CH (skip-over of control codes) |
| $0098–$0226 | BASIC keyword table (`TOKENS`) — token value = $A4 + table index, so it covers $A5 RND … $FF COPY, then the six 2068-only keywords (DELETE, ON ERR, STICK, SOUND, FREE, RESET) in keyword-table-2 order. Token values are identical to the ZX Spectrum's; see `ts2068_tokens_and_keyboard.md` |
| $0227–$024D | Main keys table (LCKEYS) |
| $024E–$0267 | Unshifted extended mode keys (EKEYS) |
| $0268–$0281 | Shifted extended mode keys (SEKEYS) |
| $0282–$028B | Control codes — digit+CAPS (NUMFNTBL) |
| $028C–$02A5 | Symbol shift keys (KKEYS) |
| $02A6–$02AF | Extended-mode digit keys (E-DIGITS: FORMAT, DEF FN, FN, LINE, OPEN #, CLOSE #, MOVE, ERASE, POINT, CAT). No label of its own in the listing — it is the tail of the KKEYS data block |
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
| $0000–$0007 | XRST0 — `DI / JR $0049` (cold start with EXROM active); $0003–$0007 are $FF |
| $0008–$001F | XRST8 — RST 8 error handler when EXROM is active; falls through to XRST20 |
| $0020–$002F | XRST20 / XRST28 — VIDMOD-aware call to the RAM GOTO_BANK ($6572 or $FD32) |
| $0030–$0037 | XRST30 — $FF filler |
| $0038–$0048 | XRST38 — interrupt; VIDMOD-aware jump to the RAM INT service ($62AE or $FA6E) |
| $0049–$0067 | EXROM-STARTUP / MOVE-TO-$6000 reboot fragment |
| $0068–$08E6 | Cassette handling routines (W_TAPE $0068 … SAVE $0851, AKEY $08AA) and BADBAS $08D9 (bad-BASIC-command error exit) |
| $08E7–$0DAF | Extension ROM initialization (EXTINIT $08E7, NORMSVAR $096C, BLDSCT $09F4, RESSCT) |
| $0DB0–$0E26 | OPEN-DFILE (OPDFIL) — open second display file |
| $0E27–$0E8D | CLOSE-DFILE (CLDFIL) — close second display file |
| $0E8E–$0F42 | CHNG_VID (CHG_V) — video mode change |
| $0F43–$0F89 | PASSING routine |
| $0F8A–$0FA7 | GOTO_B / CALL_B — VIDMOD-aware jumps to the RAM GOTO_BANK / CALL_BANK |
| $1000–$162F | Function dispatcher / bank-switching code — the HOME ROM init copies these $0630 bytes to $6200–$682F (HOME $0E15–$0E1E). Code ends at $1623; $1624–$162F are zeros |
| $1630–$1CFF | Unused filler ($00 / $FF; one stray $80 at $174F) |
| $1D00–$1D7B | Fix table for dispatcher relocation — 61 words + $0000 terminator |
| $1EDC–$1FFF | Dispatcher jump table (JMPTBL) — service *n*'s address is the word at $1FFE − 2*n* (`$0068` W_TAPE at $1FFE) |

---

## RAM Layout (Default, No Cartridge)

```
$5C00–$5CBB   System variables  (see ts2068_system_variables.md)
$5CBC–$5CCB   TS-2068-specific system variables
$5CCC–$5EE9   Reserved expansion area (not used by OS)
$5EEA–$5FFF   SYSCON table      (see ts2068_video_and_cartridges.md)

$6000–$61FF   Machine stack (512 bytes, grows down from $6200; SP starts at $61FE)
$61FC         Default ERRSP — error recovery stack pointer
$6200         MSTBOT — base of machine stack, and the dispatcher entry point
$6200–$682F   Function dispatcher / bank-switching code ($0630 bytes, copied
              from EXROM $1000–$162F at boot — HOME $0E15–$0E1E)

$6840–$6854   CHANS area (21 bytes: 4 channels K/S/R/P × 5 bytes + $80 end marker)
$6855         DATADD at start-up
$6856         BASIC program start (PROG = VARS when empty; EXROM $096C–$097A)
              Variables area (VARS) — immediately after program
              Workspace (WORKSP) — after variables
              Calculator stack (STKBOT → STKEND) — after workspace

...

$FF57         RAMTOP (power-on value — UDG − 1; HOME $0D73–$0D7F)
$FF58–$FFFF   UDG — 21 user-definable graphics × 8 bytes = 168 bytes
$FFFF         PRAMT (physical RAM top)
```

On power-up INIT finds the top of RAM (PRAMT, $FFFF on a stock machine),
copies the 168 UDG bytes to just below it and sets RAMTOP one byte under them,
so RAMTOP is $FF57 (65367). NEW keeps the existing RAMTOP. With less RAM, both
move down by the same amount.

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
$6000–$77FF   Second pixel data      (same layout as $4000–$57FF, +$2000)
$7800–$7AFF   Second attribute data  (same layout as $5800–$5AFF, +$2000)
```

OPEN-DFILE clears exactly $6000–$7AFF (EXROM $0E0B–$0E14 loops until H = $7B).
Before calling it, CHNG_VID opens $12C0 bytes at $6840 (via HOME REMGSZ), so
CHANS moves to $7B00 and PROG to $7B16 while the second file is open.

Because this overlaps the normal dispatcher/stack area, OPEN-DFILE (EXROM $0DB0):
1. Moves the UDG **down** by $0840 bytes (UDG $FF58 → $F718 with the power-on
   layout) to make room at the top of RAM
2. Copies the whole $6000–$683F block (machine stack + dispatcher code) to
   $F7C0–$FFFF, i.e. +$97C0, and moves SP with it
3. Patches the absolute addresses inside the moved code from the fix table at
   EXROM $1D00 (each listed word gets +$97C0)
4. Stores the mode in VIDMOD, clears the new display file, and writes DECR
   preserving bit 7

CHNG_VID then adds $97C0 to ERRSP, LISTSP and MSTBOT (EXROM $0ED3–$0EE8).
RAMTOP is **not** lowered by either routine.

After OPEN-DFILE:
- Machine stack $F7C0–$F9BF; dispatcher code $F9C0–$FFEF
- Dispatcher entry point and MSTBOT: **$F9C0** (instead of $6200)
- Always re-check VIDMOD ($5CC2) before calling the dispatcher

---

## I/O Port Map

| Port  | Dir | Name | Description |
|-------|-----|------|-------------|
| $FE   | W   | ULA  | Border color (bits 2-0); MIC (bit 3); speaker (bit 4) |
| $FE   | R   | ULA  | Keyboard half-row (bits 4-0, 0=pressed); EAR (bit 6) |
| $FF   | R/W | DECR | Display Enhancement Control Register — video modes, EXROM |
| $F4   | R/W | HSR  | Horizontal Select — maps chunks to HOME or DOCK/EXROM |
| $F5   | W   |      | AY-3-8912 register address (SOUND: address port) |
| $F6   | W   |      | AY-3-8912 data write |
| $F6   | R   |      | AY-3-8912 data read (joystick via register 14) |
| $FB   | R/W |      | Printer, ZX Printer protocol: read bit 0 encoder, bit 6 = 1 no printer, bit 7 stylus; write bit 1 slow, bit 2 motor stop, bit 7 stylus (HOME $0A4A–$0A7A) |
| $FC, $FD | — |    | Reserved for bank switching — "not implemented" (Technical Manual Table 2.1.13-1). The stock ROMs never address them |

### Bus Expansion Unit registers — memory-mapped, not I/O ports

The BEU (never produced) is reached through **memory addresses**, not ports.
EXROM `WRITE_BS_REG` / `READ_BS_REG` (RAM copies at $635C / $63AD) take the
register's high address byte in D, do `LD H,D / LD L,0`, and then `LD (HL),A`
or `LD A,(HL)` one nybble at a time, after setting AY register 7 so I/O port A
is an output, writing 0 to register 14, and writing 2 to the nybble-steering
location LOWNYB = $C000. The register symbols in the EXROM source are:

| Address high byte | Symbols |
|------|------|
| $40 | `HS`, `HS_LSN` |
| $80 | `BNA`, `HS_MSN` |
| $A0 | `ABN`, `HSP`, `STA_L` |
| $C0 | `CMD`, `STA_O` |

What each register does on the BEU hardware is **(unverified)** — there is no
hardware to check against.

### DECR — Display Enhancement Control Register (port $FF)

| Bits | Function |
|------|----------|
| D2-D0 | **Video mode field** (not independent flags): `000` normal · `001` second display file · `010` ultra-high-resolution colour · `110` 64-column. Other combinations are undefined. |
| D5-D3 | Ink/paper colour for 64-column mode: `000` black/white · `001` blue/yellow · `010` red/cyan · `011` magenta/green · `100` green/magenta · `101` cyan/red · `110` yellow/blue · `111` white/black |
| D6 | Inhibit the 17 ms interrupt — **0 enables** it |
| D7 | Enable EXROM in the EXROM bank |

> **Corrected.** An earlier revision listed D0/D1/D2 as separate flags and gave
> 64-column mode as bit 2 (`$04`). D2-D0 is one 3-bit field and 64-column is
> `110` = `$06`, per the Technical Manual §2.1.13.1 and the Zebra OS-64 ROM.

Bit 7 must be preserved. The stock ROMs do this by reading the port back, not
from a RAM copy (they keep none): `IN A,($FF) / AND $80 / OR mode / OUT ($FF),A`
in OPEN-DFILE (EXROM $0E1B) and CHNG_VID ($0EF4); `IN A,($FF) / SET 7,A /
OUT ($FF),A` in the HOME init copier ($0E0F) and GOTO_EXT (EXROM $1618). The
Technical Manual port table lists $FF as R/W.

### HSR — Horizontal Select Register (port $F4)

Bit N = 0 → chunk N from HOME ROM / home RAM
Bit N = 1 → chunk N from DOCK/EXROM space (DECR bit 7 picks which)

Default: $00 (all from HOME). The EXROM is a single 8K ROM mapped at
$0000–$1FFF of the extension bank (Technical Manual §2.1.4), and the stock ROMs
only ever select it through HSR bit 0 (chunk 0) — `LD A,1 / OUT ($F4),A` in the
HOME init copier and GOTO_EXT, `SET 0` / `RES 0` in BANK_ENABLE. What chunks
1–7 return with DECR bit 7 set is **(unverified)**. The EXROM's bank-switching code reads the HSR
back with `IN A,($F4)` (e.g. GET_STATUS, BANK_ENABLE); the Technical Manual
port table lists it as R/W.

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

| VIDMOD | Entry Point | Dispatcher Code | Machine Stack Area | Machine Stack Base |
|--------|------------|-----------------|--------------------|-------------------|
| 0      | $6200      | $6200–$682F     | $6000–$61FF        | $6200 (grows down)|
| non-0  | $F9C0      | $F9C0–$FFEF     | $F7C0–$F9BF        | $F9C0 (grows down)|

The entry point is the first byte of the code; the stack sits directly below
it. OPEN-DFILE moves the two together as one $0840-byte block ($6000–$683F →
$F7C0–$FFFF).

Test: `LD A,(VIDMOD)` / `OR A` / `JR Z, use_6200`