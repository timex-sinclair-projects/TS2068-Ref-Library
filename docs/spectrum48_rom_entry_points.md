# ZX Spectrum 48K ROM Entry Points

Reference for the ZX Spectrum 48K ROM, extracted from the annotated TASM
disassembly (last updated 13-DEC-2004). All addresses are exact ROM locations.

Labels follow the `;;` / `Lxxxx:` convention used in `Spectrum48.txt`.
For TS 2068 equivalents, see `ts2068_vs_spectrum48_comparison.md`.

---

## RST (Restart) Vectors

| Address | Name | Description |
|---------|------|-------------|
| $0000 | START | Power-on reset. `DI`, `XOR A`, `LD DE,$FFFF`, `JP START-NEW` |
| $0008 | ERROR-1 | Error handler. `HL←CH_ADD`, `X_PTR←HL`, `JR ERROR-2`. Byte after call = error code−1 |
| $0010 | PRINT-A | Write char in A to current output stream (`JP PRINT-A-2`) |
| $0018 | GET-CHAR | Fetch char at CH_ADD → A |
| $001C | TEST-CHAR | Test if char is relevant (called by GET-CHAR) |
| $0020 | NEXT-CHAR | Advance CH_ADD, fetch next char → A |
| $0028 | FP-CALC | Enter floating-point calculator |
| $0030 | BC-SPACES | Create BC free bytes in workspace |
| $0038 | MASK-INT | Maskable interrupt: increment FRAMES, call KEYBOARD |

---

## Low-ROM Utility Routines

| Address | Name | Description |
|---------|------|-------------|
| $0048 | KEY-INT | Keyboard scan entry (called from MASK-INT) |
| $0053 | ERROR-2 | Pop return addr → error code; `LD ERR_NR,L`; restore SP; `JP SET-STK` |
| $0055 | ERROR-3 | As ERROR-2 but L already holds error code (no pop) |
| $0066 | RESET | NMI handler. Checks NMIADD ($5CB0); **inverted-logic bug** — see note |
| $0074 | CH-ADD+1 | Increment CH_ADD, return new char in A |
| $0077 | TEMP-PTR1 | `INC HL`, fall into TEMP-PTR2 |
| $0078 | TEMP-PTR2 | Store HL → CH_ADD; load A ← (HL); return |
| $007D | SKIP-OVER | Skip embedded control codes $10–$17; return NC if char is printable |

**NMI bug note:** `JR NZ, NO-RESET` should be `JR Z`. Non-zero NMIADD resets
the machine; zero NMIADD returns. **Identical bug exists in TS 2068 HOME ROM.**

---

## Tables

| Address | Name | Description |
|---------|------|-------------|
| $0095 | TKN-TABLE | Token keyword text table. Functions ($A5–$C4): RND through BIN. Commands ($C5–$FF): OR through COPY |
| $0205 | MAIN-KEYS | 39-byte unshifted key table (B H Y 6 5 T G V … Q A) |
| $022C | E-UNSHIFT | 26 unshifted extended-mode letter keys (green legends) |
| $0246 | EXT-SHIFT | 26 shifted extended-mode letter keys (red legends) |
| $0260 | CTL-CODES | 10 control codes for CAPS+digit (DELETE, EDIT, CAPS LOCK…) |
| $026A | SYM-CODES | 26 symbol-shift+letter codes (STOP, *, ?, STEP, >=, TO…) |
| $0284 | E-DIGITS | 10 extended+digit codes (FORMAT, DEF FN, FN, LINE…) |

---

## Keyboard Routines

| Address | Name | Description |
|---------|------|-------------|
| $028E | KEY-SCAN | Scan all 8 half-rows; return raw reading |
| $02BF | KEYBOARD | Full keyboard scan: debounce, decode, update KSTATE/LASTK |
| $0333 | K-DECODE | Decode raw row/column → character code using tables above |

---

## Sound / Speaker

| Address | Name | Description |
|---------|------|-------------|
| $03B5 | BEEPER | Low-level tone generator. Toggles EAR bit (port $FE) at precise timing |
| $03F8 | beep | BEEP command: convert BASIC pitch/duration params, call BEEPER |

**TS 2068 note:** Both routines moved. Use dispatcher service $19 (or direct
ROM call ~$0605/$0507) on the TS 2068.

---

## Tape I/O Routines

All tape routines are in the Spectrum HOME ROM. **On TS 2068 these are in EXROM.**

| Address | Name | Description |
|---------|------|-------------|
| $04C2 | SA-BYTES | Save a block of bytes to tape |
| $0507 | SA-START | Start of byte loop (entry inside SA-BYTES) |
| $053F | SA/LD-RET | Common return point for SAVE and LOAD |
| $0556 | LD-BYTES | Load a block of bytes from tape |
| $0605 | SAVE-ETC | Main SAVE/LOAD/MERGE dispatcher |
| $075A | SA-ALL | Build tape header and save program/data |
| $0767 | LD-LOOK-H | Load and verify tape header |

---

## Screen / Print Routines

| Address | Name | Description |
|---------|------|-------------|
| $09F4 | PRINT-OUT | Main character output router. Handles all control codes ($00–$1F) and printable chars. Calls channel output routine |
| $0BDB | PO-ATTR | Set display attributes from ATTRP/ATTRT for current print position |
| $0D6B | CLS | Clear entire screen (calls CL-ALL then resets DFSZ) |
| $0D6E | CLS-LOWER | Clear lower screen only |
| $0D94 | CL-CHAN | Open channel for screen output |
| $0DD9 | CL-SET | Set up display file pointers (DFCC, DFCCL) |
| $0E00 | CL-SCROLL | Scroll screen up one line. B=number of lines to scroll |
| $15F2 | PRINT-A-2 | Write char in A to current output stream (actual implementation, called by RST $10) |

**TS 2068 mapping:**
- PRINT-OUT → ~$0F2C
- CLS → ~$0DAF
- CLS-LOWER → ~$0A4E
- PRINT-A-2 → ~$0DD9 (same name, different address)
- CL-SCROLL → ~$0D6B

---

## Editor Routines

| Address | Name | Description |
|---------|------|-------------|
| $0F2C | EDITOR | Main editor loop entry |
| $10A8 | KEY-INPUT | Process a keypress in editor context |
| $111D | ED-COPY | Copy edit line to screen |

---

## Channel / Stream Routines

| Address | Name | Description |
|---------|------|-------------|
| $15C6 | init-strm | Initialise stream table (STRMS at $5C10) |
| $15D4 | WAIT-KEY | Wait for a key, return char in A |
| $1601 | CHAN-OPEN | Open channel; A = channel identifier |
| $162D | chn-cd-lu | Channel code look-up table |
| $1634 | CHAN-K | Keyboard/lower-screen channel ('K') |
| $1642 | CHAN-S | Main screen channel ('S') |
| $164D | CHAN-P | Printer channel ('P') |

---

## Startup and Initialization

| Address | Name | Description |
|---------|------|-------------|
| $11B7 | NEW | NEW command: jump to START-NEW with A=$FF (warm start) |
| $11CB | START-NEW | **Main init entry point.** DE=$FFFF=cold; A=$FF=warm. Sets up RAM, clears BASIC, calls MAIN-EXEC. **SAME ADDRESS IN TS 2068** |
| $11DA | ram-check | RAM size detection loop |
| $1219 | RAM-SET | Set minimum system — SET-MIN equivalent |
| $121C | NMI_VECT | NMI default handler vector address |

---

## BASIC Main Loop

| Address | Name | Description |
|---------|------|-------------|
| $12A2 | MAIN-EXEC | Main BASIC execution loop entry |
| $12A9 | MAIN-1 | Test BREAK, print report |
| $12AC | MAIN-2 | Auto-list if enabled |
| $1303 | MAIN-4 | Execute current BASIC line |
| $1313 | MAIN-G | Error reporting, screen reset |
| $1386 | MAIN-9 | Wait for keypress |
| $1391 | rpt-mesgs | Report message text table (OK, NEXT without FOR, etc.) |

---

## Memory Management

| Address | Name | Description |
|---------|------|-------------|
| $1652 | ONE-SPACE | Create 1 free byte in workspace (calls MAKE-ROOM with BC=1) |
| $1655 | MAKE-ROOM | Insert BC bytes at HL; updates all pointers above HL |
| $1664 | POINTERS | Update system pointers after memory insertion/deletion |
| $169E | RESERVE | Allocate BC bytes in workspace above WORKSP; called by BC-SPACES (RST $30) |
| $16B0 | SET-MIN | Reset workspace to minimum: clear vars, reset STKBOT/STKEND/MEM |
| $16C5 | SET-STK | Reset calculator stack and MEM pointer; JP to error recovery |
| $19E5 | RECLAIM-1 | Reclaim memory from HL to DE. Calls DIFFER, then RECLAIM-2. **SAME ADDRESS IN TS 2068** |
| $19E8 | RECLAIM-2 | Reclaim BC bytes from address in DE. Updates all higher pointers. **SAME ADDRESS IN TS 2068** |

---

## BASIC Statement Execution

| Address | Name | Description |
|---------|------|-------------|
| $1B17 | LINE-SCAN | Scan and syntax-check (or execute) one BASIC statement |
| $1B28 | STMT-LOOP | Statement loop: fetch and execute statements |
| $1B55 | GET-PARAM | Get class-code parameters for current command |
| $1B76 | STMT-RET | Return from statement execution |
| $1B8A | LINE-RUN | Execute BASIC line in RUN mode |
| $1FCD | LPRINT | LPRINT command (sets PR flag then falls into PRINT) |
| $1FCF | PRINT | PRINT command entry |

---

## Expression Evaluation

| Address | Name | Description |
|---------|------|-------------|
| $24FB | SCANNING | Evaluate expression; result pushed onto calculator stack |
| $26C3 | S-NUMERIC | Signal that expression result is numeric (sets FLAGS bit 6) |
| $28B2 | LOOK-VARS | Look up a variable in the VARS area |

---

## Variable / Assignment Routines

| Address | Name | Description |
|---------|------|-------------|
| $2AFF | LET | LET command: assign expression to variable |
| $2BF1 | STK-FETCH | Fetch string descriptor from calculator stack → BC=length, DE=address |
| $2C02 | DIM | DIM command: create numeric or string array |

---

## Graphics

| Address | Name | Description |
|---------|------|-------------|
| $22AA | PIXEL-ADD | Calculate display-file address for pixel (C=col X, B=row Y) → HL=addr, A=bit mask |
| $22CB | POINT-SUB | Test if pixel at (C,B) is set; result on calc stack |
| $22DC | PLOT | PLOT command: plot pixel at screen coordinates |
| $2320 | CIRCLE | CIRCLE command |
| $2382 | DRAW | DRAW command |

---

## Floating-Point Stack Utilities

| Address | Name | Description |
|---------|------|-------------|
| $2D28 | STACK-A | Push value in A onto calculator stack as float |
| $2D2B | STACK-BC | Push 16-bit value in BC onto calculator stack as integer float |
| $2D3B | INT-TO-FP | Convert integer in DE/HL to 5-byte float |
| $2DA2 | FP-TO-BC | Pop top of calculator stack → BC (integer, must fit 16 bits) |
| $2DD5 | FP-TO-A | Pop top of calculator stack → A (integer 0–255) |
| $2DE3 | PRINT-FP | Print floating-point number on calculator stack to current channel |

---

## Floating-Point Calculator

Entry via `RST $28` followed by opcode bytes, terminated by `$38` (end-calc).

| Address | Name | Description |
|---------|------|-------------|
| $335B | CALCULATE | Calculator entry point — same as RST $28 target |
| $335E | GEN-ENT-1 | Internal calculator entry used for recursive calls |

Calculator opcode set is identical to TS 2068. See `ts2068_rom_entry_points.md`
for the full opcode table ($01–$3F plus memory opcodes $A0–$E5).

---

## Character Set

| Address | Name | Description |
|---------|------|-------------|
| $3D00 | char-set | 96-character bitmap set, 8 bytes per character. Space ($20) through © ($7F). **Identical to TS 2068** |

---

## System Variables Quick Reference

All at the same addresses as TS 2068 (identical $5C00–$5CB5 layout).
IY permanently = $5C3A (ERR_NR).

```
$5C00  KSTATE    Keyboard state (8 bytes, two 4-byte blocks)
$5C08  LASTK     Most recently pressed key
$5C3A  ERR_NR    Error code − 1 ($FF = no error). IY→here
$5C3B  FLAGS     Control flags (see below)
$5C3C  TVFLAG    TV flags
$5C3D  ERRSP     Error recovery stack pointer
$5C41  MODE      0=K, 1=F (function), 2=G (graphics)
$5C45  PPC       Current BASIC line number
$5C48  BORDCR    Border colour × 8
$5C4B  VARS      Variables area address
$5C4F  CHANS     Channel table address
$5C53  PROG      BASIC program address
$5C59  ELINE     Edit line address
$5C5D  CH_ADD    Address of next character to interpret
$5C61  WORKSP    Workspace address
$5C63  STKBOT    Calculator stack bottom
$5C65  STKEND    Calculator stack top (next free)
$5C67  BREG      Calculator B-register
$5C68  MEM       Calculator memory area (usually MEMBOT at $5C92)
$5C76  SEED      RANDOMIZE seed
$5C78  FRAMES    Frame counter (50 Hz UK / 60 Hz US, 3 bytes)
$5C7B  UDG       User-defined graphics address
$5C8D  ATTRP     Permanent attributes
$5C8F  ATTRT     Temporary attributes
$5C91  PFLAG     Print flags (OVER, INVERSE, etc.)
$5C92  MEMBOT    Calculator memory area (MEM0–MEM5, 30 bytes)
$5CB0  NMIADD    NMI handler address (inverted bug — see $0066)
$5CB2  RAMTOP    Top of BASIC system area
$5CB4  PRAMT     Top of physical RAM
```

### FLAGS ($5C3B) bit definitions

| Bit | Meaning when set |
|-----|-----------------|
| 0 | Suppress leading space before token |
| 1 | Output to printer (not screen) |
| 2 | L-mode at current character |
| 3 | L-mode at cursor |
| 5 | Key has been pressed |
| 6 | Expression result is numeric |
| 7 | Interpreting (not syntax-checking) |

**TS 2068 difference:** Bit 4 = TOKEN mode (TS 2068 only; not used on Spectrum).

---

## BASIC Token Values — Quick Reference

All values are identical on the TS2068.

### Function tokens — $A5–$C4 (no leading space when listed)

```
$A5=RND    $A6=INKEY$ $A7=PI     $A8=FN     $A9=POINT  $AA=SCREEN$
$AB=ATTR   $AC=AT     $AD=TAB    $AE=VAL$   $AF=CODE   $B0=VAL
$B1=LEN    $B2=SIN    $B3=COS    $B4=TAN    $B5=ASN    $B6=ACS
$B7=ATN    $B8=LN     $B9=EXP    $BA=INT    $BB=SQR    $BC=SGN
$BD=ABS    $BE=PEEK   $BF=IN     $C0=USR    $C1=STR$   $C2=CHR$
$C3=NOT    $C4=BIN
```

### Operator / command tokens — $C5–$FF (leading space before letters)

```
$C5=OR    $C6=AND   $C7=<=    $C8=>=    $C9=<>    $CA=LINE  $CB=THEN
$CC=TO    $CD=STEP  $CE=DEF FN $CF=CAT
$D0=FORMAT $D1=MOVE $D2=ERASE $D3=OPEN# $D4=CLOSE# $D5=MERGE $D6=VERIFY
$D7=BEEP  $D8=CIRCLE $D9=INK  $DA=PAPER $DB=FLASH  $DC=BRIGHT $DD=INVERSE
$DE=OVER  $DF=OUT   $E0=LPRINT $E1=LLIST $E2=STOP  $E3=READ  $E4=DATA
$E5=RESTORE $E6=NEW $E7=BORDER $E8=CONTINUE $E9=DIM $EA=REM  $EB=FOR
$EC=GO TO $ED=GO SUB $EE=INPUT $EF=LOAD $F0=LIST  $F1=LET   $F2=PAUSE
$F3=NEXT  $F4=POKE  $F5=PRINT $F6=PLOT  $F7=RUN   $F8=SAVE  $F9=RANDOMIZE
$FA=IF    $FB=CLS   $FC=DRAW  $FD=CLEAR $FE=RETURN $FF=COPY
```

**Source note:** The `Spectrum48.txt` TKN-TABLE comment says `"134d (RND)"`.
134 decimal = $86, which is not the token value for RND. The EKEYS table in
the same file confirms INKEY$ = $A6, placing RND at $A5 (165 decimal).
COPY = $FF = 255 decimal, matching "255d (COPY)" correctly.
The "134" is a typo in the disassembly annotation.

---

## Report Codes

Stored as ERR_NR = code − 1. A value of $FF means no error.

```
 0  OK               1  NEXT without FOR   2  Variable not found
 3  Subscript error  4  Out of memory      5  Out of screen
 6  Number too big   7  RETURN without GOSUB 8  End of file
 9  STOP statement   A  Invalid argument   B  Integer out of range
 C  Nonsense in BASIC D  BREAK into program E  Out of DATA
 F  Invalid filename G  No room for line   H  STOP in INPUT
 I  FOR without NEXT J  Invalid I/O device K  Invalid colour
 L  BREAK pressed    M  RAMTOP no good     N  Statement lost
 O  Invalid stream   P  FN without DEF FN  Q  Parameter error
 R  Tape loading error
```

**TS 2068 adds:** S = Missing LROS (cartridge required but not present)