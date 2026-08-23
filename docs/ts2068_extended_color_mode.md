# TS2068 Extended Color Mode (ECM)

Reference for working with the Timex Extended Color Mode — also called hi-color or
ultra-high-resolution color. Covers the memory layout, how to enter and leave the mode
safely, the constraints it imposes, and the failure modes that are easy to hit.

## What it is

| Property | Value |
|---|---|
| DECR bit (port `$FF`) | 1 |
| Mode byte passed to CHNG_VID | `$02` |
| `VIDMOD` (`$5CC2`) when active | non-zero (`2`) |
| Pixel resolution | 256×192 — unchanged from standard |
| Attribute granularity | **one byte per 8×1 pixel strip** |

Standard mode gives one attribute byte per 8×8 character cell (768 bytes). ECM gives one
per 8×1 strip: 49,152 pixels ÷ 8 = **6144 attribute bytes**. Eight times finer color
resolution vertically, unchanged horizontally.

The practical consequence: ECM largely eliminates the attribute clash that constrains
Spectrum-family graphics, because color can change on every pixel row rather than every
eighth one.

> The reference note in `ts2068_video_and_cartridges.md` describing this as "one attribute
> byte per pixel pair" is imprecise — that would require 24,576 bytes. It is 8×1.

## Memory layout

| Region | Address | Size | Notes |
|---|---|---:|---|
| Pixel data (D_FILE_1) | `$4000`–`$57FF` | 6144 | same as standard mode |
| Standard attributes | `$5800`–`$5AFF` | 768 | **ignored in ECM** |
| ECM attributes | `$6000`–`$77FF` | 6144 | a second full-size bitmap, for color |

**Attribute address = pixel address + `$2000`.** The two files share an identical layout,
so a single address computation serves both.

### Banded layout

The display is three bands of eight character rows. Both files are banded identically:

| Band | Char rows | Pixel rows | Pixel data | ECM attributes |
|---:|---|---|---|---|
| 0 | 0–7 | 0–63 | `$4000`–`$47FF` | `$6000`–`$67FF` |
| 1 | 8–15 | 64–127 | `$4800`–`$4FFF` | `$6800`–`$6FFF` |
| 2 | 16–23 | 128–191 | `$5000`–`$57FF` | `$7000`–`$77FF` |

Each third is a **contiguous 2048-byte block in both files**. This makes partial-screen
images practical (see below).

### Address formula

```
pixel_addr = $4000
           | ((Y & $C0) << 5)     ; band select
           | ((Y & $07) << 8)     ; scan line within band
           | ((Y & $38) << 2)     ; character row within band
           | (X >> 3)             ; byte within row

bit_mask   = $80 >> (X & 7)       ; bit 7 = leftmost pixel
attr_addr  = pixel_addr + $2000   ; ECM attribute for those 8 pixels
```

## Entering ECM

**Do not just set DECR bit 1.** `$6000`–`$77FF` is load-bearing RAM in standard mode: it
holds the function dispatcher, the machine stack, `CHANS`, and the start of the BASIC
program. Displaying it as color without relocating those first will crash the machine.

Go through the ROM's `CHNG_VID` at **EXROM `$0E8E`**, which does the relocation for you:

| Step | Address | Action |
|---|---|---|
| 1 | `$0E9D`–`$0EB2` | Check `STKEND + $1B00 ≤ RAMTOP`; if not, jump to error exit `$0F3A` and **do not enter ECM** |
| 2 | `$0EC5` | `CALL $65D0` — RAM dispatcher helper, updates `PROG`/`VARS`/`STKEND` |
| 3 | `$0ECC` | `LDDR` — moves the BASIC area up, out of `$6000`–`$7BFF` |
| 4 | `$0ED0` | `CALL $0DB0` (OPEN-DFILE) — moves dispatcher + stack `$6000` → `$F7C0`, clears `$6000`–`$7AFF` |
| 5 | `$0ED3`–`$0EEB` | `ERRSP`, `LISTSP`, `MSTBOT` += `$97C0` |
| 6 | — | Set `VIDMOD`; set DECR preserving bit 7 |

`CHNG_VID` lives in the EXROM, so it must be paged in before the call: HSR (port `$F4`)
bit 0 = 1, and DECR bit 7 = 1. Restore both afterwards.

### Working call sequence

From Jon Becker's ECMViewer (`ecmroutine.asm`), which is known-good on hardware:

```z80
        DI
        LD      A,1
        OUT     ($F4),A         ; HSR: EXROM into chunk 0
        IN      A,($FF)
        SET     7,A
        OUT     ($FF),A         ; DECR bit 7: enable EXROM
        LD      A,2             ; mode byte: ECM
        PUSH    AF
        EI
        CALL    $0E8E           ; CHNG_VID
        DI
        IN      A,($FF)
        RES     7,A
        OUT     ($FF),A         ; disable EXROM
        XOR     A
        OUT     ($F4),A         ; HSR back to all-HOME
        POP     AF
        CP      $80
        JR      NZ,$+3
        LD      ($5CC2),A       ; VIDMOD
        EI
        RET
```

Interrupts are enabled across the `CALL` because `CHNG_VID` manages `DI`/`EI` internally.

## What changes once ECM is active

| | Standard | ECM |
|---|---|---|
| Dispatcher entry | `$6200` | **`$F9C0`** |
| Dispatcher + stack | `$6000`–`$683F` | **`$F7C0`–`$FFFF`** |
| `PROG` | `$6856` | relocated up by `$1B00`, into chunk 4 |
| Attribute source | `$5800`–`$5AFF` | `$6000`–`$77FF` |

Three rules follow:

1. **`$F7C0`–`$FFFF` is off limits while ECM is on.** It holds the relocated stack and
   dispatcher. Machine code and image buffers must live below it — `$C000` is a good home.
   A buffer placed at `$E800`–`$FFFF` will reset the machine.
2. **Always re-check `VIDMOD` before calling the dispatcher**, since the entry point moves.
3. **Program + variables must end at least `$1B00` (6912) bytes below `RAMTOP`**, or step 1
   above fails and ECM silently never engages. If ECM stops working as a program grows,
   suspect this first.

## Failure modes

### 1. Black on black — the most common surprise

After OPEN-DFILE, `$6000`–`$77FF` is **zeroed**: ink black, paper black. Anything written
to the display file is invisible until the ECM attributes are filled in.

`PRINT` and the ROM's character output write color to `$5800`–`$5AFF`, which ECM does not
read. So text appears to do nothing at all.

Fix: fill the ECM attribute region covering whatever area you print into. For a text UI,
a uniform fill at startup is usually enough:

```z80
        LD      HL,$6800        ; band 1 + band 2 attributes
        LD      DE,$6801
        LD      BC,$0FFF
        LD      (HL),$47        ; bright white ink on black paper
        LDIR
```

Because attributes are per-pixel-row, individual text lines can be recolored cheaply —
useful for highlighting a selected menu entry.

### 2. CLOSE-DFILE is broken

`ts2068_errata_and_notes.md` documents this: once the second display file is opened it
cannot be reliably closed. The recommended approach is to not close it at all.

Options, cheapest first:

- **Stay in ECM for the program's whole run.** Draw the standard UI in ECM too.
- **Use a minimal mode-restore of your own.** Becker's `USR 49225` zeroes `VIDMOD` and
  restores the video mode without attempting to move the stack back.
- **Write a full CLOSE-DFILE** modeled on OPEN-DFILE. Most work, most risk.

Do not assume repeated round trips between ECM and standard mode will work.

### 3. DECR is write-only

Bit 7 must be preserved across writes. The OS keeps a RAM copy of the register; do the
same rather than trying to read it back.

## Loading ECM images

Use two `CODE` blocks. **`SCREEN$` cannot work** — it is fixed at 6912 bytes to `$4000`
(pixels plus *standard* attributes) and validates the block type.

### Artifact-free load order

Loading attributes straight to `$6000` shows the previous image's colors, then garbage,
while the new pixels stream in. Instead:

1. Blank the visible ECM attributes to black
2. `LOAD` attributes into an **off-screen buffer**, not `$6000`
3. `LOAD` pixels to `$4000` — they appear as a black silhouette while loading
4. Copy buffer → `$6000`, instantly or as a wipe animation

In BASIC, with a buffer at `$C800`:

```basic
LOAD "ecm-atr" CODE 51200
LOAD "ecm-pix" CODE 16384
```

The `CODE addr` form takes the length from the tape header.

### Two practical notes

- **Save attributes first in the TAP.** Attributes second corrupts the display with the
  filename text on a standard machine.
- **A length argument does not speed loading.** `LOAD "x" CODE addr,len` limits what is
  stored, but the block still streams in full. To load less, make the block shorter on the
  host — see below.

## Partial-screen images

Because each third is a contiguous 2048-byte block in both files, an image occupying one
band costs **2 × 2048 = 4096 bytes** instead of 12,288.

For a top-third image: pixels to `$4000`, attributes to `$6000`, 2048 bytes each. Slice
on the host and rewrite the TAP headers so the blocks genuinely are 2048 bytes with those
load addresses — that is where the ~3× reduction in load time comes from.

Source images should be authored at 256×64 for a single band, which is exactly 4:1.

## Toolchain

- **Retro Pixel Converter** — https://factus10.github.io/retro-pixel-converter/ — converts
  images to ECM assets. Use a build that writes attributes first.
- **ECMViewer** by Jon Becker — reference viewer and slideshow, with wipe animations and a
  TS-Pico variant. Its `ecmroutine.asm` is the practical model for mode entry.
- **zmakebas** / **ZMakebas+** — https://timex-sinclair-projects.github.io/zmakebas-plus/

## Sources

Verified against:

- `gus-home.rom` / `gus-exrom.rom` disassembly — note these are the **TS-Pico modified
  ROMs**; addresses agree with the sysvar reference but a stock machine is worth a check
- `docs/ts2068_memory_map.md`, `ts2068_video_and_cartridges.md`,
  `ts2068_system_variables.md`, `ts2068_errata_and_notes.md`
- Jon Becker's ECMViewer `ecmroutine.asm` and accompanying notes
- Fuse 1.7.0 `display.c` / `display.h` — confirms the second file is the same Home RAM at
  `screen[offset + ALTDFILE_OFFSET]`, `ALTDFILE_OFFSET` = `$2000`
