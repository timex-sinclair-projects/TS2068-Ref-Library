# TS 2068 System Variables

System variables begin at **$5C00** (decimal 23552). The Z80's IY register is
permanently set to **$5C3A** (ERR_NR), enabling efficient indexed addressing.

Default values are $00 unless noted in the Default column.

The Default column is the state the stock ROM pair (`TS2068_U16.BIN` / `TS2068_U20.BIN`)
leaves at the K cursor after power-on, 48K RAM, no cartridge or BEU: INIT ($0D31),
NEW ($0D82), EXROM EXTINIT ($08E7) and the screen clear and copyright message they
run. The RAM test at $0D42–$0D53 zeroes $4000–$FFFF, so anything init never writes
is $00. Each listed value was traced to the instruction that writes it and checked
with an emulated boot. Working variables that change as soon as BASIC runs (line
pointers, CH_ADD, FRAMES, lower-screen print positions, scroll count) are left
blank. An
earlier version of this column came from a memory snapshot of a running program
(e.g. RAMTOP $E100, MASKP/MASKT $38, CH_ADD $9A25); those values were not
power-on defaults.

---

## Complete Variable Table

| Name       | Default | Addr  | IY+  | Sz | Description |
|------------|---------|-------|------|----|-------------|
| KS_A1      | $FF     | $5C00 |      | 1  | Keyboard upper block: key value ($FF = no key) |
| KS_C1      |         | $5C01 |      | 1  | Upper block: debounce count |
| KS_D1      |         | $5C02 |      | 1  | Upper block: repeat countdown |
| KS_B1      |         | $5C03 |      | 1  | Upper block: ASCII code of key |
| KS_A2      | $FF     | $5C04 |      | 1  | Lower block: key value ($FF = no key) |
| KS_C2      |         | $5C05 |      | 1  | Lower block: debounce count |
| KS_D2      |         | $5C06 |      | 1  | Lower block: repeat countdown |
| KS_B2      |         | $5C07 |      | 1  | Lower block: ASCII code of key |
| LASTK      |         | $5C08 |      | 1  | Newly pressed key code |
| REPDEL     | $23(35) | $5C09 |      | 1  | Hold time before key repeats (60ths/sec) |
| REPPER     | $05     | $5C0A |      | 1  | Repeat interval (60ths/sec between repeats) |
| DEFADD     |         | $5C0B |      | 2  | Address of first argument of user-defined FN |
| KDATA      |         | $5C0D |      | 1  | Last color change info for edited line |
| TVDATA     |         | $5C0E |      | 2  | Color/AT/TAB controls queued for display |
| STRMS      |         | $5C10 |      | 38 | Stream→channel table (19 × 2 bytes) |
| CH_M3      | $0001   | $5C10 |      | 2  | Stream –3: keyboard + lower screen |
| CH_M2      | $0006   | $5C12 |      | 2  | Stream –2: main screen |
| CH_M1      | $000B   | $5C14 |      | 2  | Stream –1: RAM write |
| CH_0       | $0001   | $5C16 |      | 2  | Stream 0: lower screen output |
| CH_1       | $0001   | $5C18 |      | 2  | Stream 1: INPUT |
| CH_2       | $0006   | $5C1A |      | 2  | Stream 2: PRINT / LIST |
| CH_3       | $0010   | $5C1C |      | 2  | Stream 3: LPRINT / LLIST |
| CH_4–15    |         | $5C1E–$5C35 |  | 2  | User channels 4–15 |
| CHARS      | $3C00   | $5C36 |      | 2  | Char set base − 256. Change to use custom chars |
| RASP       | $40     | $5C38 |      | 1  | Length of editor buffer-full buzz |
| PIP        |         | $5C39 |      | 1  | Length of keyboard click |
| **ERR_NR** | **$00** | **$5C3A** | **$00** | 1 | **Error code − 1. $FF = no error. IY→here.** The editor sets $FF before each typed line runs (ROM $0E7D); power-on leaves $00 until then |
| FLAGS      | $10     | $5C3B | $01  | 1  | BASIC control flags — see bit table below |
| TVFLAG     | $21     | $5C3C | $02  | 1  | TV/screen flags — see bit table below |
| ERRSP      | $61FC   | $5C3D |      | 2  | Machine-stack pointer used for error recovery. NEW sets $61FC (ROM $0D95); reads $61F8 while the editor waits for a key (ROM $0A8A) |
| LISTSP     |         | $5C3F |      | 2  | Return address for automatic listing |
| MODE       |         | $5C41 | $07  | 1  | Cursor: 0=K or L, 1=F, 2=G |
| NEWPPC     |         | $5C42 |      | 2  | Line to jump to (GOTO/GOSUB/RUN) |
| NSPPC      |         | $5C44 | $0A  | 1  | Statement# for jump; bit 7 clear forces jump |
| PPC        |         | $5C45 |      | 2  | Line number being interpreted |
| SUBPPC     |         | $5C47 | $0D  | 1  | Statement# within current line |
| BORDCR     | $38     | $5C48 | $0E  | 1  | Border color × 8; also lower-screen attributes |
| EPPC       |         | $5C49 | $0F  | 2  | Line# of current line in listing (program cursor) |
| VARS       | $6856   | $5C4B |      | 2  | Address of variables area |
| DEST       |         | $5C4D |      | 2  | Address of variable being assigned |
| CHANS      | $6840   | $5C4F |      | 2  | Address of channel table |
| CURCHL     | $6840   | $5C51 |      | 2  | Pointer to current channel data |
| PROG       | $6856   | $5C53 |      | 2  | Address of BASIC program start |
| NXTLIN     |         | $5C55 |      | 2  | Address of next BASIC line |
| DATADD     | $6855   | $5C57 |      | 2  | Address of last DATA item terminator |
| ELINE      | $6857   | $5C59 |      | 2  | Address of edit line (input buffer) |
| KCUR       | $6857   | $5C5B |      | 2  | Address of cursor in edit buffer |
| CH_ADD     |         | $5C5D |      | 2  | Address of next char to interpret |
| X_PTR      |         | $5C5F |      | 2  | Address after '?' syntax marker; 0 = no error |
| WORKSP     | $6859   | $5C61 |      | 2  | Address of temporary workspace |
| STKBOT     | $6859   | $5C63 |      | 2  | Bottom of calculator stack |
| STKEND     | $6859   | $5C65 |      | 2  | Next free space on calculator stack (= STKNXT) |
| BREG       |         | $5C67 | $2D  | 1  | Calculator's B register |
| MEM        | $5C92   | $5C68 |      | 2  | Address of calculator memory area (usu. MEMBOT) |
| FLAGS2     | $10     | $5C6A | $30  | 1  | More flags — see bit table below |
| DFSZ       | $02     | $5C6B | $31  | 1  | Lines in lower screen (including blank line). Set to 2 by NEW (ROM $0DDB) and after each command ($0E28); the power-on copyright message leaves it at 4 until the first key |
| STOP       | $0000   | $5C6C |      | 2  | Top program line in automatic listings |
| OLDPPC     |         | $5C6E |      | 2  | Line to CONTINUE from |
| OSPCC      |         | $5C70 | $36  | 1  | Statement# for OLDPPC |
| FLAGX      |         | $5C71 | $37  | 1  | Assignment flags — see bit table below |
| STRLEN     |         | $5C72 | $38  | 2  | Length of string destination |
| TADDR      |         | $5C74 |      | 2  | Address of next item in syntax table |
| SEED       |         | $5C76 |      | 2  | RND seed (RANDOMIZE sets this) |
| FRAMES     |         | $5C78 | $3E  | 2  | Frame counter low 2 bytes (increments at 60 Hz) |
| FRAMES2    |         | $5C7A | $40  | 1  | Frame counter high byte (interrupt handler `INC (IY+$40)` at ROM $0045) |
| UDG        | $FF58   | $5C7B |      | 2  | Address of first UDG (21 chars × 8 bytes) |
| XCOORD     |         | $5C7D |      | 1  | X of last PLOTted point |
| YCOORD     |         | $5C7E |      | 1  | Y of last PLOTted point |
| PPOSN      | $21     | $5C7F | $45  | 1  | Printer column (33-column numbering) |
| PRCC       | $5B00   | $5C80 | $46  | 2  | Address of next char in printer buffer |
| ECHOE      |         | $5C82 |      | 2  | End position of keyboard input buffer |
| DFCC       | $4000   | $5C84 |      | 2  | Display file address of PRINT position |
| DFCCL      |         | $5C86 |      | 2  | Like DFCC, for lower screen |
| SPOSNCOL   | $21     | $5C88 |      | 1  | PRINT column (33-col) |
| SPOSNLIN   | $18     | $5C89 | $4F  | 1  | PRINT row (24-row) |
| SPOSNLCOL  |         | $5C8A | $50  | 1  | Lower screen output column |
| SPOSNLLIN  |         | $5C8B |      | 1  | Lower screen output row |
| SCRCT      |         | $5C8C | $52  | 1  | Scroll count; decrements each scroll; 0 → "scroll?" |
| ATTRP      | $38     | $5C8D |      | 1  | Permanent print attributes (see format below) |
| MASKP      |         | $5C8E |      | 1  | Permanent attribute mask (transparent bits) |
| ATTRT      | $38     | $5C8F |      | 1  | Temporary print attributes |
| MASKT      |         | $5C90 |      | 1  | Temporary attribute mask |
| PFLAG      |         | $5C91 | $57  | 1  | Print flags: even bits=temp, odd bits=permanent |
| MEM0–MEM5  |         | $5C92–$5CAF | | 5  | Calculator memory locations 0–5 (6 × 5 bytes) |
| NMIADD     |         | $5CB0 |      | 2  | NMI routine address ($0000 = system reset) |
| RAMTOP     | $FF57   | $5CB2 |      | 2  | Last byte of BASIC system area. Power-on: UDG − 1 (ROM $0D77 `DEC HL` / $0D7F `LD (RAMTOP),HL`); NEW keeps the existing value |
| PRAMT      | $FFFF   | $5CB4 |      | 2  | Last byte of physical RAM |
| ERRLN      |         | $5CB6 | $7C  | 2  | ON ERR GO TO line number in bits 0–13. Bit 15 (IY+$7D bit 7) = trap armed: set by `ON ERR GO TO` ($20C6–$20CC: `AND $3F / OR $80`), tested on error ($0E95), cleared by `ON ERR RESET` ($20B2). Bit 14 (IY+$7D bit 6) = trap being handled: set at $0E9B, BREAK is ignored while set ($200F), cleared by RESET ($20B6) and CONTINUE ($20A3) |
| ERRC       |         | $5CB8 |      | 2  | Line number where error occurred |
| ERRS       |         | $5CBA |      | 1  | Statement number where error occurred |
| ERRT       |         | $5CBB |      | 1  | Error number / report code |
| SYSCON     | $5EEA   | $5CBC |      | 2  | Pointer to SYSCON table |
| MAXBNK     |         | $5CBE |      | 1  | Number of expansion banks in system |
| CRCBN      |         | $5CBF |      | 1  | Current channel bank number |
| MSTBOT     | $6200   | $5CC0 |      | 2  | Address above machine stack base |
| VIDMOD     |         | $5CC2 |      | 1  | **Video mode: 0=normal; non-zero=2nd display active** |
| ARSBUF     |         | $5CC4 |      | 2  | Pointer to AROS buffer |
| ARSFLAG    |         | $5CC6 |      | 1  | AROS flags — see bit table below |
| ADATLN     |         | $5CC7 |      | 2  | Start of current DATA line (AROS only) |
| DTLNLN     |         | $5CC9 |      | 2  | Length of current DATA line (AROS only). The ROM uses $5CC9–$5CCA (`LD (DTLNLN+1),BC` at $1DE0; also $1DEA, $1E04, $1E13, $1E45); `2068_DEFS.ASM` defines DTLNLN as $5CC8, the high byte of ADATLN |
| STRMN      |         | $5CCB |      | 1  | Stream number last given to `#n`, OPEN # or CLOSE # (ROM $1412, $221E); passed to a bank channel's routine when it is called ($1215, $13F1, $14A3). Not updated when the ROM selects a stream internally |
| BNADD      |         | $5FE9 |      | 2  | Highest priority bank number address |
| BANKP      |         | $5FEB |      | 1  | Highest bank priority |

---

## Bit Definitions

### FLAGS ($5C3B / IY+$01)

| Bit | Name    | 1 = |
|-----|---------|-----|
|  0  | SPC     | Suppress space before tokens |
|  1  | PR      | Output to printer, not screen |
|  2  | LMODE1  | L-mode (not K) at current char |
|  3  | LMODE2  | L-mode (not K) at cursor |
|  4  | TOKEN   | Token mode on (**TS 2068 only**) |
|  5  | KEYHIT  | A key has been pressed |
|  6  | NUM     | Expression is numeric (not string) |
|  7  | INTPT   | Interpret (not syntax-check) |

### TVFLAG ($5C3C / IY+$02)

| Bit | Name   | 1 = |
|-----|--------|-----|
|  0  | LHS    | Printing to lower half of screen |
|  1  | EDIT   | Outputting line for editing |
|  3  | ECHREQ | Echo requested (keyboard input) |
|  4  | TVLIST | Automatic listing in progress |
|  5  | CLHS   | Clear lower screen when key pressed |

### FLAGS2 ($5C6A / IY+$30)

| Bit | Name   | 1 = |
|-----|--------|-----|
|  0  | ALOS   | Automatic listing on screen |
|  1  | PRLEFT | Printer buffer not empty |
|  2  | L_STR  | Inside string in LISTCH KB-mode |
|  3  | CAPS_L | Capitals lock on |
|  4  | RETPOS | Retype possible after syntax error. Mechanically: K channel in use — set only when the K channel is selected (ROM $12A2), cleared on every other channel selection ($1250, $1273) |
|  5  | DELREP | DELETE key held down (auto-repeat) |

### FLAGX ($5C71 / IY+$37)

| Bit | Name   | 1 = |
|-----|--------|-----|
|  0  | FLEX   | Flexible-length assignment required |
|  1  | UNFND  | Assignment destination not found |
|  5  | INPLN  | Require input value (not program line) |
|  6  | NO     | Required type is numeric |
|  7  | LINPLN | Input-line mode (not straight input) |

### PFLAG ($5C91 / IY+$57)

| Bit | Name  | 1 = |
|-----|-------|-----|
|  0  | XOR_CH | New chars XORed (OVER mode) into old |
|  2  | INV_CH | New chars inverted |
|  4  | F_CB   | Foreground = complement of background |
|  6  | B_CF   | Background = complement of foreground |

### ARSFLAG ($5CC6)

| Bit | Name      | 1 = |
|-----|-----------|-----|
|  0  | BANKCH    | INPUT (1) / PRINT (0) in progress: set by INPUT (ROM $222E), cleared by PRINT ($215C; LPRINT leaves it). When the current channel is in an expansion bank (CRCBN ≥ 2), selects that channel's input or output routine (ROM $120C). Name **(unverified)** |
|  1  | AROSQTE   | Quoted string in AROS (toggled on `"` at ROM $25A5–$25AE, reset at $256C) |
|  2  | AROSKCUR  | KCUR pointing to AROS **(unverified: no stock-ROM code tests this bit)** |
|  3  | AROSDTA   | DATADD pointing to AROS **(unverified: no stock-ROM code tests this bit)** |
|  4  | AROSNXT   | NXTLIN pointing to AROS **(unverified: no stock-ROM code tests this bit)** |
|  6  | AROSDST   | DEST pointing to AROS **(unverified: no stock-ROM code tests this bit)** |
|  7  | AROS      | AROS present (EXTINIT sets $80 for a BASIC AROS, EXROM $095B; tested throughout the HOME ROM) |

---

## Attribute Byte Format (ATTRP / ATTRT / $5800+ display)

```
Bit:  7      6      5    4    3    2    1    0
      FLASH  BRIGHT PAPER-G  P-R  P-B  INK-G  INK-R  INK-B
```

Color index: 0=Black 1=Blue 2=Red 3=Magenta 4=Green 5=Cyan 6=Yellow 7=White

BORDCR = border_color × 8 (bits 5-3 hold the color, same position as PAPER in attributes).

---

## IY Offset Quick Reference

```
IY+$00  ERR_NR       IY+$01  FLAGS        IY+$02  TVFLAG
IY+$07  MODE         IY+$0A  NSPPC        IY+$0D  SUBPPC
IY+$0E  BORDCR       IY+$0F  EPPC         IY+$21  KCUR
IY+$25  X_PTR        IY+$2D  BREG         IY+$30  FLAGS2
IY+$31  DFSZ         IY+$36  OSPCC        IY+$37  FLAGX
IY+$38  STRLEN       IY+$3E  FRAMES       IY+$40  FRAMES2
IY+$45  PPOSN        IY+$46  PRCC         IY+$4F  SPOSNLIN
IY+$50  SPOSNLCOL    IY+$52  SCRCT        IY+$57  PFLAG
IY+$7C  ERRLN        IY+$FE  RASP         IY+$FF  PIP
```

---

## Channel Table (CHANS, pointed to by $5C4F)

Each entry is 5 bytes:

| Offset | Content |
|--------|---------|
| 0–1    | Output routine address (for WRCH) |
| 2–3    | Input routine address (for WAIT-KEY) |
| 4      | Device identifier (ASCII: 'K', 'S', 'R', 'P') |

The STRMS table ($5C10) stores 2-byte offsets into CHANS for each stream.
Formula: CHANS_offset = STRMS[(stream + 3) × 2]; add to (CHANS – 1) to get entry.

---

## KSTATE Detail

Two 4-byte blocks handle dual-key tracking (normal key in lower block; second
simultaneous key in upper block).

```
Lower block (most-recently pressed single key or first of two):
  KS_A2 ($5C04)  Key value uppercase; $FF = no key
  KS_C2 ($5C05)  Debounce counter (counts down from 5)
  KS_D2 ($5C06)  Repeat countdown
  KS_B2 ($5C07)  ASCII code

Upper block (used when a second key is pressed while first is held):
  KS_A1 ($5C00)  Key value; $FF = not in use
  KS_C1 ($5C01)  Debounce counter
  KS_D1 ($5C02)  Repeat countdown
  KS_B1 ($5C03)  ASCII code
```

To use keyboard from machine code (LROS/AROS): set MODE ($5C41) = 0 and
FLAGS bit 3 (LMODE2) = 1 before using LASTK or the standard key routines.