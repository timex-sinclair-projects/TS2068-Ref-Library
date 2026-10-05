# Aker, *T/S 2068 Basics and Beyond* — reference digest

**Source:** Sharon Zardetto Aker, *T/S 2068 Basics and Beyond*. Scott, Foresman
and Company, 1985. ISBN 0-673-18109-X. 229 pp. © 1985 Sharon Zardetto Aker.

**What this folder is — and is not.** This is **not a transcription**. The book is
a commercially published, in-copyright work, so nothing here reproduces its prose
or its program listings. These files are an original digest: the book's
*technical claims* restated as terse reference entries, each with a page citation,
then checked against this library and the stock ROM disassembly. To read Aker's
own explanations or programs, go to the book; the page numbers here are the
printed page numbers.

> PDF users: in the 242-page scan circulating as
> `TS 2068 Basics And Beyond - Sharon Zardetto Aker - ISBN 0-673-18109-X.pdf`,
> PDF page = printed page + 13 (printed p. 1 is PDF p. 14).

## What kind of book it is

A BASIC technique book for people who have finished the Timex user's manual. It
contains no machine code and almost nothing about the 2068's hardware beyond
BASIC-visible features (SOUND, STICK, attributes, a handful of system
variables). Its value to this library is narrow but real:

- the **AY-3-8912 from BASIC** (Ch. 9 and App. C) — the clearest period
  explanation of SOUND register use, envelopes and noise;
- a set of **BASIC-level behaviours** (print positioning, rounding, logical
  operators, ON ERR, STICK, SCREEN$) that people porting or writing BASIC
  routinely get wrong;
- **system-variable POKEs** as a 1985 author understood them (Ch. 10).

Where Aker and the ROM disagree, **the ROM wins**. Read
`cross-check.md` before relying on any entry marked ⚠ in `digest.md`.

## Files

| File | Contents |
|------|----------|
| `digest.md` | Chapter-by-chapter technical claims, own words, with page refs. ⚠ marks a claim the cross-check found wrong or doubtful |
| `cross-check.md` | Every claim compared with the library docs and the stock HOME ROM disassembly: contradictions, confirmations, additions, open questions |

## Conventions

Same as the rest of the library: **(unverified)** means the claim could not be
checked against the material in this repository; **Library note:** marks where
this library adds to or corrects the book. ROM addresses refer to the **stock**
`TS2068_U16.BIN` via `disassemblies/ts2068_home_rom_U16_stock.txt`.
