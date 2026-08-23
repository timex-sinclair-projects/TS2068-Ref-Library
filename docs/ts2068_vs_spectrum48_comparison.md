# ZX Spectrum 48K vs TS 2068 ROM Comparison

This document maps ZX Spectrum 48K ROM routines, tokens, and system variables
to their TS 2068 equivalents. Sourced from the annotated Spectrum48 disassembly
(TASM cross-assembler format, last updated 13-DEC-2004) and the TS 2068 ROM
disassembly notes in this project.

---

## Quick Summary of Differences

| Area | Spectrum 48K | TS 2068 | Notes |
|------|-------------|---------|-------|
| RST vectors $0000–$007F | — | Identical | Byte-for-byte the same |
| Token table location | $0095 | $0098 | Slightly offset |
| Function tokens $86–$A5 | — | **Identical** | RND through BIN — same byte values on both |
| Command tokens $A6–$E0 (Spec) / $C5–$FF (TS2068) | | Offset +$1F | TS2068 commands are $1F higher due to 5 inserted tokens |
| TS 2068-only tokens | none | $C0–$C4 | DELETE, ON ERR, STICK, SOUND, FREE (inserted before OR) |
| Token range $A6–$BF | none | unknown | Not documented in project files; needs verification |
| Tape routines | HOME ROM | EXROM | Major relocation |
| Character set | $3D00 | $3D00 | Identical |
| System variables $5C00–$5CB5 | — | Identical | Same names, same addresses |
| System variables $5CB6+ | — | TS 2068 only | ERRLN, ERRC, ERRS, ERRT, SYSCON, VIDMOD… |
| NMI bug at $0066 | Present | Present | Same inverted-logic bug in both |

---

## ROM Routine Address Map

The left column is the Spectrum 48K address (from the annotated disassembly).
The right column is the TS 2068 HOME ROM address (approximate for non-fixed
entry points). Entries marked **[EXROM]** are in the TS 2068 Extension ROM.

### Fixed Entry Points (RST Vectors) — IDENTICAL in both machines

| Addr | Name | Description |
|------|------|-------------|
| $0000 | START / RST 0 | Power-on reset. `DI`, XOR A, `LD DE,$FFFF`, `JP START-NEW` |
| $0008 | ERROR-1 / RST 8 | Error: `HL←CH_ADD`, `X_PTR←HL`, `JR ERROR-2`. Byte after call = error code−1 |
| $0010 | PRINT-A-1 / RST 10 | `JP PRINT-A-2` — write char in A to current stream |
| $0013 | SYS-VERSION | Single byte; Spectrum = $FF; TS 2068 = $FF (v1) |
| $0018 | GET-CHAR / RST 18 | Fetch char at CH_ADD → A |
| $001C | TEST-CHAR | Test if char is relevant (called by GET-CHAR) |
| $0020 | NEXT-CHAR / RST 20 | Advance CH_ADD, fetch next char → A |
| $0028 | FP-CALC / RST 28 | Enter floating-point calculator |
| $0030 | BC-SPACES / RST 30 | Create BC free bytes in workspace |
| $0038 | MASK-INT / RST 38 | Maskable interrupt: increment FRAMES, scan keyboard |
| $0053 | ERROR-2 | Pop return addr, load error code → ERR_NR, restore SP, JP SET-STK |
| $0055 | ERROR-3 | Load L → ERR_NR, restore SP, JP SET-STK |
| $0066 | NMI (RESET) | NMI handler — checks NMIADD; **branch logic inverted** in both ROMs |
| $0074 | CH-ADD+1 | Increment CH_ADD, return char in A |
| $0077 | TEMP-PTR1 | INC HL, fall through to TEMP-PTR2 |
| $0078 | TEMP-PTR2 | Store HL → CH_ADD, return char in A |
| $007D | SKIP-OVER | Skip control codes; return NC if printable char |
| $0090 | SKIPS | Set carry, update CH_ADD — tail of SKIP-OVER |

### Key Tables — Structure similar but positions differ slightly

| Spectrum Addr | Name | TS 2068 Approx | Notes |
|--------------|------|----------------|-------|
| $0095 | TKN-TABLE | ~$0098 | Token keyword text; Spectrum has 32-entry function block starting at $A5, TS 2068 starts at $86 |
| $0205 | MAIN-KEYS | ~$0227 | 39-key unshifted table (LCKEYS in TS 2068) |
| $022C | E-UNSHIFT | ~$024E | Unshifted extended mode keys (EKEYS) |
| $0246 | EXT-SHIFT | ~$0268 | Shifted extended mode keys (SEKEYS) |
| $0260 | CTL-CODES | ~$0282 | CAPS+digit control codes (NUMFNTBL) |
| $026A | SYM-CODES | ~$028C | Symbol-shift key codes (KKEYS) |
| $0284 | E-DIGITS | ~$02A6 | Extended+digit keys (SSKEYS) |

### Keyboard Routines

| Spectrum Addr | Name | TS 2068 Approx | Notes |
|--------------|------|----------------|-------|
| $028E | KEY-SCAN | ~$02B0 | Hardware row-scanning loop |
| $02BF | KEYBOARD | ~$02B5 | Full keyboard scan entry point |
| $0333 | K-DECODE | ~$0333 | Decode raw reading to character code; address nearly identical |

### Sound / Speaker

| Spectrum Addr | Name | TS 2068 Approx | Notes |
|--------------|------|----------------|-------|
| $03B5 | BEEPER | ~$0605 | Low-level tone generator (uses EAR/speaker) |
| $03F8 | beep | ~$0507 | BEEP command implementation |

### Tape Routines — MOVED TO EXROM in TS 2068

| Spectrum Addr | Name | TS 2068 Location | Notes |
|--------------|------|-----------------|-------|
| $04C2 | SA-BYTES | EXROM ~$006B | Save block of bytes to tape |
| $0556 | LD-BYTES | EXROM ~$0100 | Load block of bytes from tape |
| $0605 | SAVE-ETC / LD-ALL | EXROM ~$053F / ~$0605 | Main SAVE/LOAD dispatcher |

**Critical:** On the TS 2068, never call Spectrum tape routine addresses directly.
Use the function dispatcher services instead:
- LOAD = service $05
- MERGE = service $06  
- SAVE = service $07

### Screen / Output Routines

| Spectrum Addr | Name | TS 2068 Approx | Notes |
|--------------|------|----------------|-------|
| $09F4 | PRINT-OUT | ~$0F2C | Main character output router; handles control codes |
| $0D6B | CLS | ~$0DAF | Clear entire screen |
| $0D6E | CLS-LOWER | ~$0A4E | Clear lower screen only |
| $0E00 | CL-SCROLL | ~$0D6B | Scroll screen up one line |
| $15F2 | PRINT-A-2 | ~$0DD9 | Write char in A to current stream (actual impl.) |
| $0BDB | OPEN-CHAN | ~$0BDB | Open channel for I/O (similar position) |
| $0BA2 | SELECT-S | ~$0BA2 | Select stream by number (similar position) |

Note: PRINT-A-2 moved significantly earlier in the TS 2068 (from $15F2 to ~$0DD9)
because tape routines were relocated to EXROM, freeing HOME ROM space.

### Initialization and BASIC Main Loop

| Spectrum Addr | Name | TS 2068 Approx | Notes |
|--------------|------|----------------|-------|
| $11CB | START-NEW | ~$11CB | Main init; **SAME ADDRESS** in both ROMs |
| $12A2 | MAIN-EXEC | ~$1B55 | BASIC main execution loop; moved later in TS 2068 |
| $16C5 | SET-STK | ~$1354 | Reset calculator stack; moved earlier in TS 2068 |
| $1219 | — | ~$1219 | SET-MIN (TS 2068 only; sets minimum workspace) |

### Memory Management

| Spectrum Addr | Name | TS 2068 Approx | Notes |
|--------------|------|----------------|-------|
| $169E | RESERVE | ~$1655 | Allocate workspace bytes |
| $1655 | MAKE-ROOM | ~$1A29 | Insert BC bytes at HL |
| $19E5 | RECLAIM-1 | ~$19E5 | Reclaim memory HL–DE; **SAME ADDRESS** |
| $19E8 | RECLAIM-2 | ~$19E8 | Reclaim BC bytes from DE; **SAME ADDRESS** |

### BASIC Interpreter

| Spectrum Addr | Name | TS 2068 Approx | Notes |
|--------------|------|----------------|-------|
| $1B17 | LINE-SCAN | ~$1A7A | Scan/execute one BASIC statement |
| $24FB | SCANNING | ~$28B2 | Evaluate expression; result on calculator stack |

### Floating-Point Calculator

The calculator entry point (RST $28) is identical. The calculator opcode set is
identical — see `ts2068_rom_entry_points.md` for the full opcode table.

| Spectrum Addr | Name | TS 2068 Approx | Notes |
|--------------|------|----------------|-------|
| $0028 | CALCULATE (RST 28) | $0028 | Entry via RST; **IDENTICAL** |
| $335B | CALC-ENTRY | ~$335E | Main calculator interpreter loop |

### Character Set

| Address | Contents | Notes |
|---------|----------|-------|
| $3D00 | CHRSET | **IDENTICAL** in both machines — 96 chars × 8 bytes |

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
| ERRLN | $5CB6 | 2 | ON ERR target line. Bit 15 set = trapping disabled |
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
| DTLNLN | $5CC8 | 2 | AROS current DATA line length |
| STRMN | $5CCB | 1 | Current stream number (bus expansion) |

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
| $FF  | W   | DECR | Display Enhancement Control Register |
| $F4  | W   | HSR  | Horizontal Select Register (bank mapping) |
| $F5  | W   | —    | AY-3-8910 register select |
| $F6  | W   | —    | AY-3-8910 data write |
| $F6  | R   | —    | AY-3-8910 data read (also joystick) |
| $FB  | R   | —    | Printer BUSY (bit 0) |

### DECR ($FF write) — TS 2068 Only

```
Bit 0: 1 = enable second display file
Bit 1: 1 = ultra-high-resolution color (expanded attributes)
Bit 2: 1 = 64-column mode
Bit 7: 1 = EXROM enabled  ← must always preserve this bit
```

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
$5EEA–$5FFF   SYSCON table
$6000–$61FF   Function dispatcher (2K, copied from EXROM at boot)
$6200         Machine stack base (MSTBOT; grows down from here)
$6800+        CHANS, BASIC program, variables, workspace, calc stack
$3D00–$3FFF   Character set (end of HOME ROM chunk 1)
EXROM         Extension ROM (8K; contains tape routines, dispatcher code, AROS-INIT)
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
- Code that uses Spectrum MAIN-EXEC address ($12A2) — TS 2068 is ~$1B55
- Code that uses PRINT-A-2 at Spectrum address ($15F2) — TS 2068 is ~$0DD9
- Code that reads FRAMES at 50 Hz timing (TS 2068 runs at 60 Hz)

### Use the dispatcher instead of direct ROM calls

On TS 2068, prefer the function dispatcher for all OS services. This is
version-independent. See `ts2068_dispatcher.md` for the full service table.

Key dispatcher alternatives for common Spectrum ROM calls:
- CLS → dispatcher service $22 (K_CLS) or $8D
- PRINT char → service $87 (WRCH) or $1D (SENDTV)
- LOAD/SAVE/MERGE → services $05 / $07 / $06
- Select stream → service $29 (SELECT)
- Set print position → service $1E (SETAT)

---

## Floating-Point Number Format

**Identical in both machines.** Five bytes:

```
Byte 0: Exponent (biased by 128; 0 = number is 0)
Byte 1: Mantissa byte 0 (bit 7 = sign of mantissa when exponent ≠ 0)
Byte 2: Mantissa byte 1
Byte 3: Mantissa byte 2
Byte 4: Mantissa byte 3
```

Integer shorthand: exponent = $00, bytes 1-4 = 00, [sign], [hi], [lo]
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
        JR   NZ, NO-RESET  ; BUG: should be JR Z
        JP   (HL)          ; jump to handler
NO-RESET:
        POP  HL
        POP  AF
        RETN
```

Effect: non-zero NMIADD triggers reset; zero NMIADD returns (opposite of documented).
Sinclair acknowledged the bug but never fixed it in either ROM.

---

## Source File Notes

The Spectrum 48K disassembly in `Spectrum48.txt` uses TASM cross-assembler directives:
- `DEFB` = `.BYTE`, `DEFW` = `.WORD`, `DEFM` = `.TEXT`, `ORG` = `.ORG`
- Labels are `Lxxxx:` format (e.g., `L0000:`, `L15F2:`)
- Section markers use `;;` double-semicolon prefix

The TS 2068 disassembly notes use `~$xxxx` for approximate addresses where the
exact value is not confirmed. Fixed entry points (RST vectors and explicitly
anchored code) are given as exact hex addresses.