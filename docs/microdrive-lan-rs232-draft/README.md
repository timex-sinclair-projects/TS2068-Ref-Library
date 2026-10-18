# Draft Microdrive, LAN and RS232 Software Documentation (M. J. Brennan, 1983)

A transcription of a 9-page typed draft headed *DRAFT MICRODRIVE, LAN and
RS232 SOFTWARE DOCUMENTATION*, "M.J.BRENNAN 20/4/83". It covers:

- the Microdrive recording format (tape, sectors, timings)
- the file-handling system and its limitations
- the Microdrive channel buffer (595 bytes) and sector MAPs
- the network protocol and network channel (276 bytes)
- the RS232 settings
- the system variables
- procedures called by code number: 27 CONSOLE INPUT through 49 CREATE SYSTEM
  VARIABLES

| File | Contents |
|---|---|
| [`microdrive-lan-rs232-draft.md`](microdrive-lan-rs232-draft.md) | The transcription, with `<!-- PDF page N -->` markers |
| [`NOTICE.md`](NOTICE.md) | Rights |

Source scan: <https://archive.org/details/timex-computer-corp/Draft%20Microdrive%2C%20LAN%20and%20RS232%20Software%20Documentation/>
— catalogued at <https://timexsinclair.com/document/draft-microdrive-lan-and-rs232-software-documentation/>.
The catalog dates it April 4, 1983. The document itself is typed "20/4/83",
which in day/month order is 20 April 1983.

## Read this before using it on a TS2068

**This documents the ZX Spectrum software, not the TS2068.** The text speaks
of "SPECTRUM computers", stations, and the "SPECTRUM keyboard". Its system
variables start at **23734** (`$5CB6`, FLAGS3), with the map area from about
23791.

On the TS2068, `$5CB6` onward is where the 2068's own extra system variables
begin. VIDMOD is `$5CC2` and PARAM$ is `$5CC3`, for example (see
`../ts2068_system_variables.md`; CLAUDE.md records that only `$5C00–$5CB5` is
shared with the Spectrum). So **none of these system-variable addresses can be
used on a 2068 as written.** How Timex would have placed them for the TS2060
or the Timex Microdrive Operating System is **(unverified)** here.

The procedure codes 27–49 look like the ZX Interface 1 "hook codes" used with
`RST 8`. That is **(unverified)**: there is no Interface 1 ROM in this library
to check against.

## Problems in the document (kept as printed)

The draft has gaps and contradictions of its own:

- **Timings left blank:** "2-3mS ?????" and "1mS ??????".
- **MAP start:** 23791 on one page; COPIES at 23791 and maps from 23792 on
  another.
- **Variable name:** "NTHUMB" vs "NCNUMB".
- **Unfinished sentence:** "MAPs are" breaks off on page 7.
- **Station range:** given as 1–64, but 0 is used as the broadcast address.
- **Data block (GET PACKET):** said to start at NCB, which the channel table
  gives as the byte count.
- **RS232 stop bits:** input is 1 stop bit, output is 2.
- **Handwriting:** a handwritten correction on page 1 replaces the tape width
  "1/16" with ".073" inch.

Typos are kept ("harware", "ommitted", "temporarilly", "an SAVE type").

## Verification

Read page by page from the 300 dpi scan at 240 dpi, with no OCR. All decimal
addresses, offsets and timings were re-read on zoomed crops. The internal
arithmetic checks out: sector timings total 31.62 mS, both channel lengths
(595 and 276) match their tables, and the 8-byte network header matches
offsets 11–18. There is one uncertain reading, the struck "1/16" on page 1. No
independent second reading has been done.

## Rights

See [NOTICE.md](NOTICE.md).
