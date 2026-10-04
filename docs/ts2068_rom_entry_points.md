# TS 2068 ROM Entry Points and Restart Vectors

All addresses are HOME ROM addresses unless marked [EXROM].
Many routines are also accessible via the function dispatcher — prefer the
dispatcher for future-compatible code. Direct ROM addresses are provided for
reference and for cases where the dispatcher cannot be used.

Every address below has been checked against the stock ROM images
(`TS2068_U16.BIN`, `TS2068_U20.BIN`) and the stock disassemblies. Names in the
second column are the Spectrum 48K names where the routine is a direct
equivalent; the label used in `disassemblies/ts2068_home_rom_U16_stock.txt` is
given in parentheses. An earlier revision of this file gave approximate
(`~$xxxx`) addresses taken from the Spectrum layout; most of them pointed into
unrelated code and have been replaced.

---

## RST (Restart) Vectors — HOME ROM

| Address | Name         | Function |
|---------|--------------|----------|
| $0000   | START/RST0   | Power-on / reset. `DI`, `XOR A`, `LD DE,$FFFF`, `JP $0D31` (INIT). The 2068 has no routine at the Spectrum's START-NEW address $11CB |
| $0008   | ERROR-1/RST8 | Error handler. HL←CH_ADD, X_PTR←HL, `JR $0053` (ERROR-2). On-stack byte = error code−1 |
| $0010   | PRINT-A-1/RST10 | `JP $11ED` (SENDCH): write character in A to the current channel |
| $0013   | SYS-VERSION  | Single byte $FF (a `RST $38` filler byte). Technical Manual §3.1 says location $13 identifies the ROM revision ($FF = initial version); nothing in either stock ROM reads it — **(unverified)** beyond the manual; see CLAUDE.md |
| $0018   | GET-CHAR/RST18 | Fetch character at CH_ADD into A |
| $001C   | TEST-CHAR    | `CALL $007D` (SKIP-OVER); loops via NEXT-CHAR while the character is skippable |
| $0020   | NEXT-CHAR/RST20 | Advance CH_ADD and fetch next character |
| $0028   | CALCULATE/RST28 | `JP $371A` — floating-point calculator interpreter |
| $0030   | BC-SPACES/RST30 | Create BC free bytes in workspace (ALLOCBC): `PUSH BC`, `LD HL,(WORKSP)`, `PUSH HL`, `JP $132D` (RESERVE) |
| $0038   | MASK-INT/RST38 | Maskable interrupt: increment the 3-byte FRAMES, `CALL $02E1` (UPD_K), `EI`, `RET` |

## RST Vectors — EXROM (when EXROM is mapped in)

| Address | Name         | Function |
|---------|--------------|----------|
| $0000   | XRST0        | `DI`, `JR $0049`: sets the HSR, copies an 11-byte stub from EXROM $004F to RAM $6000 and jumps to it; the stub pages HOME back in and does `LD DE,$FFFF` / `JP $0D31` (HOME INIT) |
| $0008   | XRST8        | Error with EXROM paged: stores the error byte in ERR_NR, reloads SP from ERR_SP, then GOTO_BANK ($6572, or $FD32 when VIDMOD ≠ 0) to HOME $1354 (SET-STK) |
| $0038   | XRST38       | Keyboard interrupt with EXROM active — `JP $62AE` (RAM INT service), or `JP $FA6E` when VIDMOD ≠ 0 |

---

## Key HOME ROM Subroutines by Category

### Startup and Initialization

| Address | Name        | Description |
|---------|-------------|-------------|
| $0D31   | START-NEW (INIT) | Main init. Enter with interrupts disabled, DE = top of RAM to test ($FFFF), A = 0 for power-on; A = $FF (from K_NEW) keeps P_RAMT/RASP/UDG. Dispatcher service $27 |
| $0D1D   | NEW (K_NEW) | NEW command: `DI`, `LD A,$FF`, `LD DE,(RAMTOP)`, saves P_RAMT/RASP/UDG in the alternate registers, falls into INIT |
| $0D7F   | RAM-SET     | `LD (RAMTOP),HL`; falls into $0D82, which sets CHARS=$3C00, MSTBOT=$6200, SP, ERR_SP, IY, CHANS=$6840 |
| $0DF1   | —           | Copies a 29-byte stub to RAM $6000 and calls it; the stub copies the dispatcher (EXROM $1000–$162F, $0630 bytes) to RAM $6200 ($0E15: `LD HL,$1000` / `LD DE,$6200` / `LD BC,$0630` / `LDIR`) |
| $133F   | SET-MIN     | Clear the edit line (`(E_LINE)`←$0D, K_CUR, $80 terminator, WORKSP), then falls into SET-WORK ($134E) and SET-STK ($1354) |

### Error Handling

| Address | Name    | Description |
|---------|---------|-------------|
| $0053   | ERROR-2 | Pop error address from stack, load error code to ERR_NR, restore SP from ERRSP, `JP $1354` (SET-STK) |
| $0055   | ERROR-3 | Store L to ERR_NR, restore SP from ERRSP, `JP $1354` |
| $1354   | SET-STK (RESET) | STKEND←STKBOT, MEM←MEMBOT ($5C92); returns with HL = STKBOT. Dispatcher service $2B |

### Character I/O

| Address | Name        | Description |
|---------|-------------|-------------|
| $0010   | PRINT-A-1   | `JP $11ED` (stream output) |
| $11ED   | PRINT-A-2 (SENDCH) | Write A to the current channel (the actual implementation). Dispatcher service $86 |
| $11CF   | (RDCH)      | Wait for a character from the current channel → A. Dispatcher service $85 |
| $11E1   | (INCH)      | Input one character from the current channel. Dispatcher service $28 |
| $0018   | GET-CHAR    | Fetch char at CH_ADD → A |
| $0020   | NEXT-CHAR   | Advance CH_ADD, fetch next char → A |
| $0074   | CH_ADD+1    | Increment CH_ADD, return new char in A |
| $0077   | TEMP-PTR1   | `INC HL`, falls into TEMP-PTR2 |
| $0078   | TEMP-PTR2   | Set CH_ADD = HL, return char in A |
| $007D   | SKIP-OVER   | Return NC for a significant character (≥ `!`, $0D, or $0C), otherwise C; control codes $10–$17 also step HL past their operands. The 2068 adds `CP $0C` / `RET Z`, so SKIPS (Spectrum $0090) is at $0093 |

### Keyboard

| Address | Name       | Description |
|---------|------------|-------------|
| $02B0   | KEY-SCAN (K_SCAN) | Scan all half-rows; returns key value in E and shift in D (Z = valid). Dispatcher service $88 |
| $02E1   | KEYBOARD (UPD_K) | Full keyboard handler called from MASK-INT: calls K_SCAN, debounces via KSTATE, sets LASTK. Dispatcher service $19 |
| $035C   | K-TEST (K_BASE) | Convert key value/shift to a main code (`LD B,D` / `LD D,0` / `LD A,E` / `CP $27`) |
| $0371   | K-DECODE (CHCODE) | Final character code from main code, MODE (C), shift (B) and flags |
| $0227   | MAIN-KEYS (LCKEYS) | 39-byte unshifted key table |
| $024E   | E-UNSHIFT (EKEYS) | 26 extended-mode letter codes |
| $0268   | EXT-SHIFT (SEKEYS) | 26 extended-mode + shift letter codes |
| $0282   | CTL-CODES (NUMFNTBL) | 10 CAPS SHIFT + digit control codes |
| $028C   | SYM-CODES (KKEYS) | 26 symbol-shift letter codes |
| $02A6   | E-DIGITS   | 10 extended-mode digit codes (no separate label; continues the KKEYS block) |

### Screen Output

| Address | Name         | Description |
|---------|--------------|-------------|
| $0500   | PRINT-OUT (SENDTV) | Output routine of the K, S and P channels (channel table at $11AA); handles control codes and printable chars. Dispatcher service $1D |
| $08A6   | CLS (K_CLS)  | CLS command: `CALL $08EA` then falls into CLLHS. Dispatcher service $8D |
| $08A9   | CLS-LOWER (CLLHS) | Clear lower screen. Dispatcher service $21 |
| $08EA   | CL-ALL (CLS) | Clear the whole primary display file. Dispatcher service $22 |
| $0939   | (SCRL1)      | `LD B,$17`, falls into SCRLB: scroll the upper 23 lines up one line. Dispatcher service $8E |
| $093B   | CL-SCROLL (SCRLB) | Scroll B lines up one line |
| $05B2   | (SET_AT)     | Set print position. Dispatcher service $1E |
| $1230   | CHAN-OPEN (SELECT) | Select stream A: `ADD A,A` / `ADD A,$16` indexes STRMS; Error O if closed. Dispatcher service $29 |
| $1248   | (SEL_HL)     | Make the channel at HL current (`LD (CURCHL),HL`) |
| $142A   | OPEN #       | OPEN # command (OPEN). Dispatcher service $2E |

### Memory Management

| Address | Name      | Description |
|---------|-----------|-------------|
| $0030   | BC-SPACES | Create BC free bytes in workspace |
| $132D   | RESERVE (LCU2) | Allocate workspace (tail of BC-SPACES): `LD HL,(STKBOT)` / `DEC HL` / `CALL $12BB` |
| $12B8   | ONE-SPACE (INSI) | `LD BC,1`, falls into MAKE-ROOM |
| $12BB   | MAKE-ROOM (INSERT) | Insert BC bytes at HL (checks room via $1FBB, updates pointers via $12CA). Dispatcher service $2A |
| $12CA   | POINTERS (REMGSZ) | Update system pointers after an insertion/deletion |
| $174D   | RECLAIM-1 (DEL_DE) | Reclaim HL..DE: `CALL $1745` (DIFFER), falls into $1750 |
| $1750   | RECLAIM-2 (DELREC) | Reclaim BC bytes at HL. Dispatcher service $38 |

### BASIC Interpreter

| Address | Name        | Description |
|---------|-------------|-------------|
| $0E28   | MAIN-EXEC   | DF_SZ←2, `CALL $14E1` (auto-list), then MAIN-1 |
| $0E2F   | MAIN-1      | `CALL $133F` (SET-MIN) |
| $0E32   | MAIN-2      | Select stream 0, `CALL $0A82` (editor), `CALL $1A27` (LINE-SCAN), then run or store the line |
| $0E8D   | MAIN-4      | `HALT` after execution; ON ERR trap test (TS 2068 addition, see below) |
| $0EC8   | —           | No trap: silence the AY (register 7 ← $FF), flush printer buffer, report follows |
| $0EE3   | MAIN-G      | Report printing (`PUSH AF` = report code; prints code, message, line:statement) |
| $0F56   | —           | NSPPC←$FF, then `JP $0E32` (back to MAIN-2) |
| $1A27   | LINE-SCAN (SYNTAX) | Syntax-check the edit line. Dispatcher service $3A |
| $1A44   | STMT-LOOP (LS4) | `RST $20`, falls into $1A45 (`CALL $134E`, next statement) |
| $1AB9   | STMT-RET (ENDBTT) | Test BREAK, then next line/statement |
| $1AD8   | LINE-RUN (EXECUTE) | Run the edit line as a direct command (PPC←$FFFE). Dispatcher service $3B |
| $1B4A   | STMT-NEXT (ENDTEM) | End-of-statement test: `$0D` → next line, `:` → next statement, else Error C |

### Expression Evaluation

| Address | Name        | Description |
|---------|-------------|-------------|
| $2854   | SCANNING (EXPRN) | Evaluate expression; result on calculator stack. Dispatcher service $5E |
| $2A81   | S-NUMERIC   | `SET 6,(IY+1)` (mark result numeric) |

### Floating Point Calculator

| Address | Name       | Description |
|---------|------------|-------------|
| $0028   | CALCULATE  | Calculator entry point (RST $28 → `JP $371A`) |
| $371A   | CALCULATE  | Calculator interpreter: `CALL $39DA` (STK-PNTRS) then the opcode loop |
| $371D   | GEN-ENT-1  | Re-entry with B = opcode/parameter (`LD A,B` / `LD ($5C67),A`); used by the series generator ($3809) |
| $3721   | GEN-ENT-2  | Re-entry continuing an existing literal sequence |
| $3696   | tbl-addrs  | Opcode address table, 66 words ($00–$41) |
| $3684   | stk-zero…  | Five compressed constants used by $A0–$A4: 0, 1, ½, π/2, 10 |

### Sound (HOME ROM)

| Address | Name      | Description |
|---------|-----------|-------------|
| $03F3   | BEEPER (PARP) | Generate tone: HL = period (8·HL+236 T-states), DE = cycles−1. Dispatcher service $1A |
| $0436   | BEEP      | BEEP command implementation. Dispatcher service $1B |

---

## Key EXROM Subroutines

| Address [EXROM] | Name         | Description |
|-----------------|--------------|-------------|
| $0068           | SA-BYTES (W_TAPE) | Write a block to tape. Dispatcher service $00 |
| $00FC           | LD-BYTES (R_TAPE) | Read a block from tape (IX = destination, DE = length). Dispatcher service $01 |
| $01AB           | SAVE-ETC (SLVM) | Parse SAVE/LOAD/VERIFY/MERGE command lines (TADDR selects which). Dispatcher service $04 |
| $05CC           | (LOAD)       | Load program text / data after the header. Dispatcher service $05 |
| $06E5           | (MERGE)      | Merge program lines. Dispatcher service $06 |
| $0851           | (SAVE)       | Save header and data block. Dispatcher service $07 |
| —               | VERIFY       | No separate entry: VERIFY runs through SLVM/LOAD (TADDR = 2) |
| $08E7           | (EXTINIT)    | Called at the end of HOME INIT: SYSCON←$5EEA, build the configuration table, start LROS/AROS cartridges |
| $09F4           | (BLDSCT)     | Build the system configuration (SYSCON) table |
| $096C / $0973   | (NORMSVAR / INITSYSVAR) | Initialise DATADD and related system variables |
| $0DB0           | OPEN-DFILE (OPDFIL) | Open second display file |
| $0E27           | CLOSE-DFILE (CLDFIL) | Close second display file (reported buggy — **(unverified)**; see `ts2068_errata_and_notes.md`) |
| $0E8E           | (CHG_V)      | Change video mode (A = mode). Note: the stock dispatcher entry for service $08 points to $0EA3, not here — see `ts2068_dispatcher.md` |
| $1000           | DISPATCHER   | Function dispatcher; copied with the bank-switching code ($1000–$162F) to RAM $6200 by HOME INIT. Do not call in place |

---

## Floating Point Calculator Opcodes

Called via RST $28 followed by a byte sequence; terminated by $38 (END-CALC).
Verified against the address table at $3696 and the dispatch code at $372B–$3755.
"X" is the last value (top of stack), "Y" the one below it.

| Byte | Name       | Operation |
|------|------------|-----------|
| $00  | jump-true  | Remove X; if it was non-zero, jump by the signed offset in the next byte |
| $01  | exchange   | Exchange top two stack entries |
| $02  | delete     | Delete top entry |
| $03  | subtract   | X = Y − X |
| $04  | multiply   | X = Y × X |
| $05  | division   | X = Y / X |
| $06  | to_power   | X = Y ** X |
| $07  | or         | X = Y OR X (boolean) |
| $08  | no-&-no    | X = Y AND X (numeric) |
| $09  | no-l-eql   | X = (Y <= X) |
| $0A  | no-gr-eql  | X = (Y >= X) |
| $0B  | nos-neql   | X = (Y <> X) |
| $0C  | no-grtr    | X = (Y > X) |
| $0D  | no-less    | X = (Y < X) |
| $0E  | nos-eql    | X = (Y = X) |
| $0F  | addition   | X = Y + X |
| $10  | str-&-no   | |
| $11  | str-l-eql  | |
| $12  | str-gr-eql | |
| $13  | strs-neql  | |
| $14  | str-grtr   | |
| $15  | str-less   | |
| $16  | strs-eql   | |
| $17  | strs-add   | String concatenation |
| $18  | val$       | VAL$ |
| $19  | usr-$      | USR with string |
| $1A  | read-in    | INKEY$ # (read from a stream) |
| $1B  | negate     | X = −X |
| $1C  | code       | CODE |
| $1D  | val        | VAL |
| $1E  | len        | LEN |
| $1F  | sin        | SIN(X) |
| $20  | cos        | COS(X) |
| $21  | tan        | TAN(X) |
| $22  | asn        | ASN(X) |
| $23  | acs        | ACS(X) |
| $24  | atn        | ATN(X) |
| $25  | ln         | LN(X) |
| $26  | exp        | EXP(X) |
| $27  | int        | INT(X) |
| $28  | sqr        | SQR(X) |
| $29  | sgn        | SGN(X) |
| $2A  | abs        | ABS(X) |
| $2B  | peek       | PEEK(X) |
| $2C  | in         | IN(X) (port read) |
| $2D  | usr-no     | USR(X) (call address X) |
| $2E  | str$       | STR$(X) |
| $2F  | chr$       | CHR$(X) |
| $30  | not        | NOT(X) |
| $31  | duplicate  | Duplicate top of stack |
| $32  | n-mod-m    | Replace Y, X with Y − X·INT(Y/X) (remainder, now second) and INT(Y/X) (quotient, now last). Two results; uses MEM 0 ($3ABB: `C0 02 31 E0 05 27 E0 01 C0 04 03 E0 38`) |
| $33  | jump       | Unconditional jump (next byte = signed offset) |
| $34  | stk-data   | Push literal value(s) onto stack |
| $35  | dec-jr-nz  | Decrement BREG; jump if non-zero |
| $36  | less-0     | X = (X < 0) |
| $37  | greater-0  | X = (X > 0) |
| $38  | end-calc   | **End of calculator sequence** |
| $39  | get-argt   | Reduce angle X to Y (−1…+1) with SIN(X) = SIN(Y·π/2); used before SIN/COS |
| $3A  | truncate   | Truncate to integer |
| $3B  | fp-calc-2  | Execute the single opcode held in BREG |
| $3C  | e-to-fp    | |
| $3D  | re-stack   | |
| $80–$9F | series-xx | Series generator ($3808); low 5 bits = number of terms. The ROM uses $86 (SIN), $88 (EXP), $8C (LN, ATN) |
| $A0–$BF | stk-const-xx | Stack a constant from the table at $3684 ($37DA): $A0 = 0, $A1 = 1, $A2 = ½, $A3 = π/2, $A4 = 10 |
| $C0–$DF | st-mem-xx | Copy X into MEM slot n ($37EC); X stays on the stack |
| $E0–$FF | get-mem-xx | Push a copy of MEM slot n ($37CE) |

**Memory opcodes:** MEM ($5C68) normally points to MEMBOT ($5C92), which holds
six slots: $C0–$C5 store to MEM 0–5, $E0–$E5 recall MEM 0–5. Slot n is at
MEM + 5n ($37C5), so codes above $C5/$E5 reach beyond MEMBOT. Table entries
$3E–$41 are reached only through codes $80–$FF; bytes $3E–$7F are not valid
opcodes.

---

## NMI Handler ($0066)

The NMI routine pushes AF and HL, loads HL from NMIADD ($5CB0), tests it for
zero, and branches with `JR NZ,$0070` (byte $20 at $006D).

As coded in the stock ROM: **NMIADD = $0000** falls through to `JP (HL)` — a jump to
$0000, i.e. a reset. **NMIADD ≠ 0** branches to `POP HL` / `POP AF` / `RETN` and
returns without calling anything.

**Known bug:** the branch should be `JR Z`, so that zero is ignored and a non-zero
NMIADD is jumped to. With the stock ROM, NMIADD cannot install an NMI handler;
leaving it non-zero is what makes an NMI harmless. See the Known Bugs section of
`CLAUDE.md` and `ts2068_errata_and_notes.md`. No standard hardware asserts NMI on
the base 2068.

---

## ON ERROR / ONERR

TS 2068 extension. ERRLN ($5CB6) holds the line number for ON ERR GO TO, with two
flag bits in its high byte. Verified against HOME $0E8D–$0EC7 and the ON ERR
statement code at $2080–$20D0.

- **Bit 15 (bit 7 of ERRLN+1) set = trapping armed.** `ON ERR GO TO n` stores
  `(n AND $3FFF) OR $8000` ($20C6–$20CC).
- **Bit 14 (bit 6 of ERRLN+1)** is set when a trap is taken; while it is set the
  BREAK test at $2009 ignores BREAK. `ON ERR CONTINUE` and `ON ERR RESET` clear it.

When an error occurs and bit 15 is set ($0E95: `BIT 7,(IY+$7D)`), the main loop:
- sets bit 14, stores the report code (ERR_NR+1) in ERRT ($5CBB), PPC in ERRC ($5CB8)
  and SUBPPC in ERRS ($5CBA), and resets ERR_NR to $FF
- jumps to the line in ERRLN (bits 14–15 masked off), statement 1

`ON ERR` is the character code $7B in a BASIC line (not a token above $A5);
`ON ERR RESET` is $7B followed by $7F, `ON ERR CONTINUE` is $7B followed by $E8.

To disable error trapping from machine code: **reset** bit 7 of ERRLN+1 ($5CB7),
as `ON ERR RESET` does ($20B2: `RES 7,(IY+$7D)`).
