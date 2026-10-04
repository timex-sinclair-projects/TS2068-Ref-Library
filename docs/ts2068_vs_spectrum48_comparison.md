# ZX Spectrum 48K vs TS 2068 ROM Comparison

This document maps ZX Spectrum 48K ROM routines, tokens, and system variables
to their TS 2068 equivalents. Sourced from the annotated Spectrum48 disassembly
(TASM cross-assembler format, last updated 13-DEC-2004) and the TS 2068 ROM
disassembly notes in this project.

---

## Quick Summary of Differences

| Area | Spectrum 48K | TS 2068 | Notes |
|------|-------------|---------|-------|
| RST vectors $0000–$007F | — | Same entry addresses | Same code shape, but jump targets differ: $0005 `JP $0D31`, $0010 `JP $11ED`, $0028 `JP $371A`, $0035 `JP $132D`, $004A `CALL $02E1`, $005C `JP $1354`; SKIP-OVER also passes $0C, moving SKIPS to $0093 |
| Token table location | $0095 | $0098 | Slightly offset |
| Function tokens $A5–$C4 | — | **Identical** | RND through BIN — same byte values on both |
| Command tokens $C5–$FF | — | **Identical** | OR through COPY — same byte values on both |
| TS 2068-only keywords | none | $0C, $7B–$7F | DELETE, ON ERR, STICK, SOUND, FREE, RESET — character codes below $A5, not new tokens (see below). ROM token table at $0098: token = $A4 + entry number, $A5 = RND … $FF = COPY, then the six TS 2068 words |
| Tape routines | HOME ROM | EXROM | Major relocation |
| Character set | $3D00 | $3D00 | Same address; byte-identical **(unverified — no Spectrum ROM image in this library)** |
| System variables $5C00–$5CB5 | — | Identical | Same names, same addresses |
| System variables $5CB6+ | — | TS 2068 only | ERRLN, ERRC, ERRS, ERRT, SYSCON, VIDMOD… |
| NMI bug at $0066 | Present | Present | Same inverted-logic bug in both |

---

## ROM Routine Address Map

The left column is the Spectrum 48K address (from the annotated disassembly).
The right column is the TS 2068 HOME ROM address, checked against the stock ROM
(`TS2068_U16.BIN`) and its disassembly; the 2068 label is given in parentheses.
Entries marked **[EXROM]** are in the TS 2068 Extension ROM. An earlier revision
of this file gave approximate (`~$xxxx`) addresses; most pointed into unrelated
code and have been replaced.

### Fixed Entry Points (RST Vectors) — same addresses in both machines (jump targets differ)

| Addr | Name | Description |
|------|------|-------------|
| $0000 | START / RST 0 | Power-on reset. `DI`, XOR A, `LD DE,$FFFF`, `JP START-NEW` (2068: `JP $0D31`, INIT) |
| $0008 | ERROR-1 / RST 8 | Error: `HL←CH_ADD`, `X_PTR←HL`, `JR ERROR-2`. Byte after call = error code−1 |
| $0010 | PRINT-A-1 / RST 10 | `JP PRINT-A-2` — write char in A to current stream (2068: `JP $11ED`) |
| $0013 | SYS-VERSION | TS 2068: byte $FF, one of the `RST $38` filler bytes after `JP $11ED`. Technical Manual §3.1 names location $13 the revision identifier ($FF = initial version, later revisions count down); no code in either stock ROM reads it, so the meaning is **(unverified)** beyond the manual. Spectrum: $FF filler, no documented role |
| $0018 | GET-CHAR / RST 18 | Fetch char at CH_ADD → A |
| $001C | TEST-CHAR | Test if char is relevant (called by GET-CHAR) |
| $0020 | NEXT-CHAR / RST 20 | Advance CH_ADD, fetch next char → A |
| $0028 | FP-CALC / RST 28 | Enter floating-point calculator (2068: `JP $371A`) |
| $0030 | BC-SPACES / RST 30 | Create BC free bytes in workspace (2068: `JP $132D` at $0035) |
| $0038 | MASK-INT / RST 38 | Maskable interrupt: increment FRAMES, scan keyboard (2068: `CALL $02E1`) |
| $0053 | ERROR-2 | Pop return addr, load error code → ERR_NR, restore SP, JP SET-STK (2068: `JP $1354`) |
| $0055 | ERROR-3 | Load L → ERR_NR, restore SP, JP SET-STK |
| $0066 | NMI (RESET) | NMI handler — checks NMIADD; **branch logic inverted** in both ROMs |
| $0074 | CH-ADD+1 | Increment CH_ADD, return char in A |
| $0077 | TEMP-PTR1 | INC HL, fall through to TEMP-PTR2 |
| $0078 | TEMP-PTR2 | Store HL → CH_ADD, return char in A |
| $007D | SKIP-OVER | Skip control codes; return NC if printable char. The 2068 also returns NC for $0C (DELETE keyword) |
| $0090 | SKIPS | Set carry, update CH_ADD — tail of SKIP-OVER. **2068: $0093** (shifted by the extra `CP $0C` / `RET Z`) |

### Key Tables — Same structure, positions differ

| Spectrum Addr | Name | TS 2068 Addr | Notes |
|--------------|------|----------------|-------|
| $0095 | TKN-TABLE | $0098 (TOKENS) | Token keyword text; function block starts at $A5 on both machines |
| $0205 | MAIN-KEYS | $0227 | 39-key unshifted table (LCKEYS in TS 2068) |
| $022C | E-UNSHIFT | $024E | Unshifted extended mode keys (EKEYS) |
| $0246 | EXT-SHIFT | $0268 | Shifted extended mode keys (SEKEYS) |
| $0260 | CTL-CODES | $0282 | CAPS+digit control codes (NUMFNTBL) |
| $026A | SYM-CODES | $028C | Symbol-shift key codes (KKEYS) |
| $0284 | E-DIGITS | $02A6 | Extended+digit keys (no separate label; continues the KKEYS block) |

### Keyboard Routines

| Spectrum Addr | Name | TS 2068 Addr | Notes |
|--------------|------|----------------|-------|
| $028E | KEY-SCAN | $02B0 (K_SCAN) | Hardware row-scanning loop |
| $02BF | KEYBOARD | $02E1 (UPD_K) | Keyboard handler called from MASK-INT ($004A `CALL $02E1`) |
| $031E | K-TEST | $035C (K_BASE) | Key value → main code |
| $0333 | K-DECODE | $0371 (CHCODE) | Main code + mode → final character code |

### Sound / Speaker

| Spectrum Addr | Name | TS 2068 Addr | Notes |
|--------------|------|----------------|-------|
| $03B5 | BEEPER | $03F3 (PARP) | Low-level tone generator; dispatcher service $1A |
| $03F8 | beep | $0436 (BEEP) | BEEP command implementation; dispatcher service $1B |

### Tape Routines — MOVED TO EXROM in TS 2068

| Spectrum Addr | Name | TS 2068 Location | Notes |
|--------------|------|-----------------|-------|
| $04C2 | SA-BYTES | EXROM $0068 (W_TAPE) | Save block of bytes to tape; service $00 |
| $0556 | LD-BYTES | EXROM $00FC (R_TAPE) | Load block of bytes from tape; service $01 |
| $0605 | SAVE-ETC | EXROM $01AB (SLVM) | SAVE/LOAD/VERIFY/MERGE command parser; service $04 |

**Critical:** On the TS 2068, never call Spectrum tape routine addresses directly.
Use the function dispatcher services instead:
- LOAD = service $05
- MERGE = service $06  
- SAVE = service $07

### Screen / Output Routines

| Spectrum Addr | Name | TS 2068 Addr | Notes |
|--------------|------|----------------|-------|
| $09F4 | PRINT-OUT | $0500 (SENDTV) | Output routine of the K, S and P channels (channel data at $11AA); service $1D |
| $0D6B | CLS | $08A6 (K_CLS) | CLS command: `CALL $08EA`, then clear lower screen; service $8D |
| $0D6E | CLS-LOWER | $08A9 (CLLHS) | Clear lower screen only; service $21 |
| $0DAF | CL-ALL | $08EA (CLS) | Clear the whole primary display file; service $22 |
| $0E00 | CL-SCROLL | $093B (SCRLB) | Scroll B lines up one line; $0939 (SCRL1) does `LD B,$17` first; service $8E |
| $15F2 | PRINT-A-2 | $11ED (SENDCH) | Write char in A to current stream (RST $10 target); service $86 |
| $1601 | CHAN-OPEN | $1230 (SELECT) | Select stream A; Error O if closed; service $29 |

The 2068 output routines sit lower in the HOME ROM than the Spectrum's
($11ED vs $15F2) because the tape routines were moved to the EXROM.

### Initialization and BASIC Main Loop

| Spectrum Addr | Name | TS 2068 Addr | Notes |
|--------------|------|----------------|-------|
| $11B7 | NEW | $0D1D (K_NEW) | NEW command: A=$FF, DE=(RAMTOP), falls into INIT; service $26 |
| $11CB | START-NEW | $0D31 (INIT) | Main init (RST 0 → `JP $0D31`); service $27. $11CB on the 2068 is inside stream data |
| $1219 | RAM-SET | $0D7F | `LD (RAMTOP),HL`, then CHARS, MSTBOT, SP, CHANS… |
| $12A2 | MAIN-EXEC | $0E28 | BASIC main loop: DF_SZ←2, auto-list, then $0E2F (MAIN-1), $0E32 (MAIN-2) |
| $16B0 | SET-MIN | $133F | Clear edit line and workspace, then SET-WORK ($134E) and SET-STK |
| $16C5 | SET-STK | $1354 (RESET) | Reset calculator stack; service $2B |

### Memory Management

| Spectrum Addr | Name | TS 2068 Addr | Notes |
|--------------|------|----------------|-------|
| $169E | RESERVE | $132D (LCU2) | Allocate workspace bytes (RST $30 → `JP $132D`) |
| $1652 | ONE-SPACE | $12B8 (INSI) | `LD BC,1`, falls into MAKE-ROOM |
| $1655 | MAKE-ROOM | $12BB (INSERT) | Insert BC bytes at HL; service $2A |
| $19E5 | RECLAIM-1 | $174D (DEL_DE) | Reclaim memory HL–DE |
| $19E8 | RECLAIM-2 | $1750 (DELREC) | Reclaim BC bytes at HL; service $38 |

### BASIC Interpreter

| Spectrum Addr | Name | TS 2068 Addr | Notes |
|--------------|------|----------------|-------|
| $1B17 | LINE-SCAN | $1A27 (SYNTAX) | Syntax-check the edit line; service $3A |
| $1B8A | LINE-RUN | $1AD8 (EXECUTE) | Run the edit line as a direct command; service $3B |
| $24FB | SCANNING | $2854 (EXPRN) | Evaluate expression; result on calculator stack; service $5E |

### Floating-Point Calculator

The RST $28 entry address is the same; on the 2068 it jumps to $371A. The
calculator opcode set and its 66-entry address table (2068: $3696) are the same —
see `ts2068_rom_entry_points.md` for the full opcode table.

| Spectrum Addr | Name | TS 2068 Addr | Notes |
|--------------|------|----------------|-------|
| $0028 | FP-CALC (RST 28) | $0028 | Entry via RST; jumps to $371A on the 2068 |
| $335B | CALCULATE | $371A | Calculator interpreter (`$0028: JP $371A`) |
| $335E | GEN-ENT-1 | $371D | Re-entry with B = opcode (used by the series generator) |

### Character Set

| Address | Contents | Notes |
|---------|----------|-------|
| $3D00 | CHRSET | Same address in both machines — 96 chars × 8 bytes; byte-identity **(unverified)** |

---

## BASIC Token Values

### All shared tokens — IDENTICAL in both machines

Every token value from RND ($A5) through COPY ($FF) is the same on the Spectrum 48K
and the TS2068. This is confirmed by two independent facts: Spectrum BASIC programs
run unaltered on the TS2068, and TAP files extracted from Spectrum software list
correctly. All token comparisons, `POKE`s into BASIC lines, and code that tests
token bytes need **no changes** when moving between the two machines.

```
; Function tokens (no leading space when listed)
$A5=RND    $A6=INKEY$ $A7=PI     $A8=FN     $A9=POINT  $AA=SCREEN$
$AB=ATTR   $AC=AT     $AD=TAB    $AE=VAL$   $AF=CODE   $B0=VAL
$B1=LEN    $B2=SIN    $B3=COS    $B4=TAN    $B5=ASN    $B6=ACS
$B7=ATN    $B8=LN     $B9=EXP    $BA=INT    $BB=SQR    $BC=SGN
$BD=ABS    $BE=PEEK   $BF=IN     $C0=USR    $C1=STR$   $C2=CHR$
$C3=NOT    $C4=BIN

; Operator/command tokens (leading space before letters when listed)
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

### TS2068-only keywords — use sub-$A5 character codes

The TS2068's added keywords do **not** occupy a new token range above $FF.
They reuse existing character codes below $A5 that Spectrum BASIC programs
would never contain as bare statement keywords. The TOKEN flag (FLAGS bit 4,
IY+$01 bit 4) controls whether these codes are interpreted as keywords or as
their Spectrum character meanings.

| Char code | TS2068 keyword | Spectrum meaning of same code |
|-----------|---------------|-------------------------------|
| $0C | DELETE | Control code (keyboard delete) |
| $7B | ON ERR | `{` character |
| $7C | STICK | `\|` (pipe) character |
| $7D | SOUND | `}` character |
| $7E | FREE | `~` character |
| $7F | RESET | `©` (copyright) character |

The TS2068 TKN-TABLE (at $0098) has six extra entries appended after COPY,
used by the BASIC lister to expand these codes into their keyword text.

**Source note:** The comment in `Spectrum48.txt` at the TKN-TABLE says
`"134d (RND)"` — 134 decimal = $86. This is an error in that document.
The EKEYS tables in both the Spectrum and TS2068 disassemblies confirm
RND = $A5 (165 decimal) and COPY = $FF (255 decimal = "255d (COPY)" ✓).
The "$86" figure has no bearing on actual token values.

---

## System Variable Differences

### Identical ($5C00–$5CB5)

The entire Spectrum system variable area from $5C00 through $5CB5 (PRAMT+1)
is byte-for-byte identical in layout and meaning. All standard Sinclair BASIC
code that uses IY-relative addressing into this area is fully compatible.

Key reminders:
- IY permanently = $5C3A (ERR_NR) in both machines
- FRAMES at $5C78 increments at **60 Hz** on TS 2068 (not 50 Hz as on UK Spectrums)
- CHARS at $5C36 holds character base address − 256; default $3C00 on both

### TS 2068-Only Variables ($5CB6–$5CCB)

| Name | Addr | Size | Description |
|------|------|------|-------------|
| ERRLN | $5CB6 | 2 | ON ERR target line. Bit 15 set = trapping armed (`ON ERR GO TO` sets it, `ON ERR RESET` clears it; HOME $0E95, $20B2, $20C9); bit 14 set while a trap is being handled |
| ERRC | $5CB8 | 2 | Line number where last error occurred |
| ERRS | $5CBA | 1 | Statement number of last error |
| ERRT | $5CBB | 1 | Error report code of last error |
| SYSCON | $5CBC | 2 | Pointer to SYSCON cartridge table (default $5EEA) |
| MAXBNK | $5CBE | 1 | Number of expansion banks |
| CRCBN | $5CBF | 1 | Current channel bank number |
| MSTBOT | $5CC0 | 2 | Machine stack base address (default $6200) |
| VIDMOD | $5CC2 | 1 | Video mode: 0=normal, non-zero=2nd display active |
| ARSBUF | $5CC4 | 2 | AROS buffer pointer |
| ARSFLAG | $5CC6 | 1 | AROS status flags |
| ADATLN | $5CC7 | 2 | AROS current DATA line start |
| DTLNLN | $5CC9 | 2 | AROS current DATA line length. The DEFS file says $5CC8, but the ROM uses $5CC9 (e.g. HOME $1DE0 `LD ($5CC9),BC`) |
| STRMN | $5CCB | 1 | Stream number last named by `#n`, OPEN # or CLOSE # (HOME $1412, $221E); read only on the bank-channel paths ($1215, $13F1, $14A3), i.e. used for bus-expansion devices but set for every stream |

---

## I/O Port Differences

### Spectrum 48K Ports

| Port | Dir | Function |
|------|-----|----------|
| $FE  | W   | Border color (bits 2-0), MIC (bit 3), speaker (bit 4) |
| $FE  | R   | Keyboard (bits 4-0, 0=pressed); EAR (bit 6) |

### TS 2068 Additional Ports

| Port | Dir | Name | Function |
|------|-----|------|----------|
| $FE  | W/R | ULA  | Same as Spectrum |
| $FF  | R/W | DECR | Display Enhancement Control Register (read back by the ROMs: HOME $0E0F, EXROM $0E1B `IN A,($FF)`; Technical Manual Table 2.1.13-1) |
| $F4  | R/W | HSR  | Horizontal Select Register (bank mapping; read back by EXROM bank switching, e.g. $1232 `IN A,($F4)`) |
| $F5  | W   | —    | AY-3-8912 register select |
| $F6  | W   | —    | AY-3-8912 data write |
| $F6  | R   | —    | AY-3-8912 data read (also joystick) |
| $FB  | R/W | —    | Printer port, same protocol as the Spectrum's ZX Printer port $FB: read bit 0 = encoder pulse, bit 6 = 1 no printer, bit 7 = stylus ready; write bit 1 = slow, bit 2 = motor stop (HOME $0A4A–$0A7A) |

### DECR (port $FF, read/write) — TS 2068 Only

```
Bits 2-0: video mode field (not independent flags):
          000 = standard, 001 = second display file,
          010 = hi-colour (8x1 attributes), 110 = 64-column ($06)
Bits 5-3: 64-column ink colour (paper is the complement)
Bit 6:    1 = inhibit the frame interrupt ("17 ms" in the manual; 0 enables it)
Bit 7:    1 = EXROM, 0 = DOCK for HSR-switched chunks  ← preserve: read the port, change the mode bits, write it back
```

See `ts2068_video_and_cartridges.md` for the mode table and its evidence.

---

## Memory Map Differences

### Spectrum 48K

```
$0000–$3FFF   ROM (16K, single contiguous block)
$4000–$57FF   Display file pixel data
$5800–$5AFF   Display attribute data
$5B00–$5BFF   Unused
$5C00–$5CBF   System variables
$5CC0–$FFFF   RAM (general purpose)
```

### TS 2068

```
$0000–$1FFF   HOME ROM chunk 0 (first 8K)
$2000–$3FFF   HOME ROM chunk 1 (second 8K)
$4000–$57FF   Display pixel data (primary)
$5800–$5AFF   Display attribute data (primary)
$5C00–$5CCB   System variables (Spectrum-compat + TS 2068-specific)
$5EEA–        SYSCON table (SYSCON ← $5EEA, EXROM $08E7)
$6000–$61FF   Machine stack (MSTBOT = $6200; the stack grows down from $6200)
$6200–$682F   RAM-resident dispatcher and bank-switching code (EXROM $1000–$162F,
              $0630 bytes, copied by HOME INIT at $0E15)
$6840+        CHANS (HOME $0D9F: `LD HL,$6840` / `LD (CHANS),HL`), BASIC program,
              variables, workspace, calc stack
$3D00–$3FFF   Character set (end of HOME ROM chunk 1)
EXROM         Extension ROM (8K; tape routines, dispatcher code, cartridge start-up EXTINIT $08E7)
```

No equivalent of the Spectrum's contiguous 16K ROM. Code that uses addresses
above $3FFF for ROM data must be rewritten for the TS 2068.

---

## Compatibility Rules for Porting Spectrum Code to TS 2068

### Will work without changes

- BASIC programs that use only standard Sinclair BASIC commands ($C5–$FF tokens)
- Code that accesses system variables at $5C00–$5CB5 by address
- Code that uses RST $08 / $10 / $18 / $20 / $28 / $30 / $38 (all identical)
- The floating-point calculator opcode sequences (all identical)
- Display file access at $4000 standard layout
- Port $FE reads/writes for keyboard and border

### Will break without changes

- **Direct calls to Spectrum ROM addresses** for any routine that moved (most of them)
- Token storage in custom BASIC line editors (TS2068-only commands use $7B–$7F and $0C)
- Tape routines called at HOME ROM addresses ($04C2, $0556, $0605, etc.)
- Any code that assumes a single contiguous 16K ROM at $0000–$3FFF
- Code that uses Spectrum MAIN-EXEC address ($12A2) — TS 2068 is $0E28
- Code that uses PRINT-A-2 at Spectrum address ($15F2) — TS 2068 is $11ED (use RST $10 instead)
- Code that reads FRAMES at 50 Hz timing (TS 2068 runs at 60 Hz)

### Use the dispatcher instead of direct ROM calls

On TS 2068, prefer the function dispatcher for all OS services. This is
version-independent. See `ts2068_dispatcher.md` for the full service table.

Key dispatcher alternatives for common Spectrum ROM calls:
- CLS → dispatcher service $8D (K_CLS, the CLS command) or $22 (CLS, primary display file only)
- PRINT char → service $87 (WRCH) or $1D (SENDTV)
- LOAD/SAVE/MERGE → services $05 / $07 / $06
- Select stream → service $29 (SELECT)
- Set print position → service $1E (SETAT)

---

## Floating-Point Number Format

**Identical in both machines.** Five bytes:

```
Byte 0: Exponent (biased by 128; 0 = small-integer form, see below)
Byte 1: Mantissa byte 0 (bit 7 = sign of mantissa when exponent ≠ 0)
Byte 2: Mantissa byte 1
Byte 3: Mantissa byte 2
Byte 4: Mantissa byte 3
```

Integer form (exponent byte $00): `00, sign ($00/$FF), lo, hi, 00` — the 16-bit
value is LSB first and two's complement when the sign byte is $FF, so the range is
−65535…+65535. Zero is the integer `00 00 00 00 00`. (2068 STK_BC $30E9 stores
`00 00 lo hi 00` via $2E74; STDE_S $314C writes `00, sign, lo, hi, 00`.)
Full range: ±(~1.7 × 10^38); precision: ~9.5 decimal digits.

---

## NMI Handler Bug — Present in Both Machines

Both the ZX Spectrum 48K and the TS 2068 have the same inverted-logic NMI bug
at address $0066:

```asm
L0066:  PUSH AF
        PUSH HL
        LD   HL,($5CB0)    ; fetch NMIADD
        LD   A,H
        OR   L
        JR   NZ, NO-RESET  ; BUG: should be JR Z   (2068: $006D = $20)
        JP   (HL)          ; reached only when HL = 0, i.e. JP $0000
NO-RESET:
        POP  HL
        POP  AF
        RETN
```

Effect: zero NMIADD falls through to `JP (HL)` = `JP $0000`, a reset; non-zero NMIADD
returns without calling the handler (the opposite of the intent). See the Known Bugs
section of `CLAUDE.md`.
Sinclair acknowledged the bug but never fixed it in either ROM.

---

## Source File Notes

The Spectrum 48K disassembly in `Spectrum48.txt` uses TASM cross-assembler directives:
- `DEFB` = `.BYTE`, `DEFW` = `.WORD`, `DEFM` = `.TEXT`, `ORG` = `.ORG`
- Labels are `Lxxxx:` format (e.g., `L0000:`, `L15F2:`)
- Section markers use `;;` double-semicolon prefix

TS 2068 addresses in this file are exact and were checked against the stock ROM
images; the 2068 labels are those of `disassemblies/ts2068_home_rom_U16_stock.txt`
and `ts2068_exrom_U20_stock.txt`.