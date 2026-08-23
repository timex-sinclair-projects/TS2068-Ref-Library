# The Most Colorful Mode Nobody Used

At the end of 1983, Timex shipped a home computer with a graphics mode more colorful than
anything else you could buy. Not "competitive with." More colorful than the Commodore 64,
the Atari 8-bits, the Apple II, the BBC Micro, the IBM PC, and the Spectrum it was derived
from. Only the MSX1 and the TI-99/4A came close.

Almost nothing ever used it.

The Timex Sinclair 2068's Extended Color Mode — ECM, sometimes called hi-color — has been
sitting in the machine for forty years waiting for someone to notice. It is not difficult
to use. It is just undocumented enough, and surrounded by enough sharp edges, that most
people who tried it once concluded the machine was broken and moved on.

It isn't broken. Here is how it actually works.

## The problem ECM solves

If you have written graphics code for a ZX Spectrum, you know about attribute clash.

The Spectrum stores pixels and color separately. Pixels live in a 6144-byte bitmap: one
bit per pixel, 256×192. Color lives in a much smaller 768-byte block, and this is where
the trouble starts — there is only **one color byte for every 8×8 block of pixels**. That
byte holds an ink color, a paper color, a bright flag and a flash flag, and all 64 pixels
in the block have to share it.

So you can draw a red spaceship against a blue starfield, but the moment the ship's edge
crosses into a character cell that also contains a star, something has to give. Either the
star turns red or the ship's edge turns blue. Spectrum artists spent a decade designing
around this, aligning sprites to the 8×8 grid and choosing palettes that made the
collisions less ugly.

ECM's answer is direct: give color its own full-size bitmap.

In Extended Color Mode there are **6144 color bytes instead of 768** — one for every 8×1
strip of pixels rather than every 8×8 block. Color can change on every single pixel row.
Vertically, the clash simply disappears. Horizontally you still have 8-pixel granularity,
so it is not a true 1:1 color mode, but in practice it transforms what the machine can
draw.

That is the whole idea. Two bitmaps of identical size and shape: one for pixels, one for
color.

## Where it lives

The pixel bitmap sits where it always does, at `$4000`–`$57FF`. The ECM color bitmap sits
at `$6000`–`$77FF`.

The elegant part is that the two are laid out identically. The Spectrum's display file has
a famously strange address arrangement — three bands of eight character rows, with scan
lines interleaved within each band, which is why writing a straight vertical line takes
more arithmetic than you would expect. ECM does not invent a second scheme. The color byte
for any 8 pixels is simply:

```
attribute address = pixel address + $2000
```

Whatever address calculation you already have for pixels, add `$2000` and you have the
color. That is it.

The banding turns out to be useful rather than merely awkward. Because the screen is three
bands of eight character rows, each third of the display is a **contiguous 2048-byte block
in both bitmaps**:

| Third | Character rows | Pixels | Color |
|---|---|---|---|
| Top | 0–7 | `$4000`–`$47FF` | `$6000`–`$67FF` |
| Middle | 8–15 | `$4800`–`$4FFF` | `$6800`–`$6FFF` |
| Bottom | 16–23 | `$5000`–`$57FF` | `$7000`–`$77FF` |

If you only want a picture across the top third of the screen with text below it, you need
to load 4 KB, not 12 KB. On real hardware loading from storage, that is a three-fold
difference in how long the user waits.

## Turning it on, and why you can't just poke a port

ECM is bit 1 of the Display Enhancement Control Register, port `$FF`. It would be
reasonable to assume you enable it with a single `OUT`.

Do that and the machine will crash.

Look again at where the color bitmap lives: `$6000`–`$77FF`. In normal operation that
region is not spare RAM. It holds the TS2068's function dispatcher, the machine stack,
the channel information table, and the first few kilobytes of your BASIC program. Switching
the video hardware to display it as color does not move any of that out of the way — it
just starts showing your stack on screen while the CPU continues to use it.

The ROM has a routine that does this properly. It is called `CHNG_VID`, it lives in the
EXROM at `$0E8E`, and it does considerably more than set a register:

1. It checks there is enough free memory — specifically that `STKEND + $1B00` is still
   below `RAMTOP`. If not, it gives up and **does not enter the mode at all**.
2. It block-moves your BASIC program upward, out of the way, and fixes up the system
   variables that point into it.
3. It relocates the dispatcher and the machine stack from `$6000` all the way up to
   `$F7C0`–`$FFFF`, adjusting `SP`, `ERRSP`, `LISTSP` and `MSTBOT` to match.
4. It clears the new color bitmap, sets the mode, and returns.

There is one wrinkle: `CHNG_VID` is in the EXROM, which is not normally paged in. You have
to map it before the call and unmap it after. Jon Becker's ECMViewer does this, and its
sequence is the one to copy:

```
        DI
        LD      A,1
        OUT     ($F4),A         ; page EXROM into chunk 0
        IN      A,($FF)
        SET     7,A
        OUT     ($FF),A         ; enable EXROM
        LD      A,2             ; mode 2 = Extended Color
        PUSH    AF
        EI
        CALL    $0E8E           ; CHNG_VID
        DI
        IN      A,($FF)
        RES     7,A
        OUT     ($FF),A
        XOR     A
        OUT     ($F4),A         ; restore normal paging
        POP     AF
        CP      $80
        JR      NZ,$+3
        LD      ($5CC2),A       ; record the mode in VIDMOD
        EI
        RET
```

Two things worth remembering afterward. The stack now lives at `$F7C0`–`$FFFF`, so any
buffer you place up there will destroy it — a machine that resets mysteriously while
loading an image is almost always this. And your program plus its variables must stay at
least 6912 bytes below `RAMTOP`, or step 1 above quietly refuses and you never get the
mode at all.

## The thing that makes everyone think it's broken

You enter ECM. You `PRINT` something. Nothing appears.

The screen is not broken and neither is your code. When the mode is opened, the color
bitmap is **zeroed** — and zero means black ink on black paper. Your text is on the screen.
It is black, on black.

Worse, the fix is not where you would look for it. `PRINT` writes its colors to the *old*
768-byte attribute area at `$5800`, which ECM does not read. Changing `INK` and `PAPER`
does nothing at all. The color has to be written into the new bitmap at `$6000`–`$77FF`.

For a text interface, filling it once at startup is usually all you need:

```
        LD      HL,$6800        ; middle and bottom thirds
        LD      DE,$6801
        LD      BC,$0FFF
        LD      (HL),$47        ; bright white ink, black paper
        LDIR
```

After that, ordinary `PRINT` works — pixels go to the display file as usual and pick up
the color you filled in. And because color is per-pixel-row here, you can recolor a single
line of text cheaply, which is a nicer highlighting mechanism than standard mode offers.

## The one-way door

There is a real bug to know about. The ROM routine that closes the second display file and
puts everything back does not work correctly. Once you have opened ECM, you cannot reliably
return to standard mode using the ROM.

This sounds worse than it is. The practical answer is to stay in ECM for the whole run of
your program and draw your normal interface there too — you keep the finer color and lose
nothing except the ability to switch back. Failing that, a minimal routine of your own that
just restores the video mode and zeroes `VIDMOD`, without trying to move the stack back,
works fine; that is what ECMViewer does. What you should not do is design around switching
in and out of the mode repeatedly and assume it will hold.

## Displaying a picture without the mess

One last practical note. If you load a color bitmap straight into `$6000`, the user watches
the previous image's colors get overwritten by new ones while the pixels are still
arriving. It looks like a fault.

The trick is to load out of order:

1. Blank the visible color bitmap to black
2. Load the new colors into an **off-screen buffer** somewhere safe, like `$C800`
3. Load the pixels to `$4000` — with colors black, they arrive as a silhouette
4. Copy the buffer into `$6000` in one go

The image appears complete, all at once. And since step 4 is just a memory copy, you can
make it a wipe, a curtain, or a shutter for free.

## Why bother now

The reason ECM went unused in 1983 is not mysterious. The TS2068 arrived late into a
market that was already collapsing under Timex's feet, the mode was barely documented,
software houses were targeting the Spectrum's installed base rather than a US variant, and
the sharp edges above were enough to stop a curious programmer in an afternoon.

None of that applies anymore. The tooling exists — you can convert modern artwork to ECM
assets in a browser, and the TS-Pico gives you storage that makes 12 KB images
inconsequential. The mode is genuinely capable, and it is one of the few things the 2068
does that its more famous cousin cannot.

Forty years is long enough. Go use it.

---

*With thanks to Jon Becker, whose ECMViewer is the reference implementation for everything
described here, and whose notes on the mode's memory layout saved considerable
disassembly. ECMViewer's own acknowledgements go to Lloyd Dreger's* Introduction to 2068
Machine Code *(1986), the TS2068 Technical Manual, and Ryan Gray.*
