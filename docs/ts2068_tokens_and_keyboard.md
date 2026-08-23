# TS 2068 BASIC Tokens, Keywords, and Keyboard

> **Correction note (verified against the HOME ROM).** An earlier version of this
> file listed the BASIC *function* tokens starting at `$86` (RND=$86 … USR=$A1)
> and claimed `$C0–$C4` were the TS2068-only commands DELETE/ON ERR/STICK/SOUND/
> FREE. **Both were wrong.** `$90–$A4` is the **UDG** range, not function tokens.
> The TS2068's standard keyword tokens are **identical to the ZX Spectrum's**
> (`$A5`–`$FF`), and the extended commands live at `$0C` and `$7B–$7F`. The tables
> below are derived from the HOME ROM keyword table (`TOKENS`, value = `$A4 +`
> table index) and the executor at `$1A6x`. If in doubt, trust the ROM, not a
> summary.

---

## BASIC Token Map at a Glance

| Range | Meaning |
|-------|---------|
| `$00–$1F` | Control codes (some double as edit keys / the DELETE statement) |
| `$20–$7F` | Printable ASCII — **but `$0C` and `$7B–$7F` are overloaded as TS2068 keyword tokens in keyword context** |
| `$80–$8F` | Block-graphic characters |
| `$90–$A4` | **UDG characters A–U** (21 user-defined graphics) |
| `$A5–$C4` | Function tokens (RND … BIN) — same values as ZX Spectrum |
| `$C5–$CF` | Operator / compound tokens (OR … CAT) |
| `$D0–$FF` | Command tokens (FORMAT … COPY) |

> **This is why a ZX Spectrum `.tap` BASIC loader works on the 2068:** the standard
> keyword tokens match. The byte `$C0` is `USR` (not `DELETE`); `$B0` is `VAL`;
> `$AF` is `CODE`. The bytes `$90/$91/$A1` are UDG **A/B/R**, which is exactly what
> appears on screen if you mistakenly use them for CODE/VAL/USR.

---

## Control Codes (`$00–$1F` in BASIC lines)

| Code | Meaning |
|------|---------|
| `$00` | (not used as printable) |
| `$06` | CAPS LOCK toggle / comma-tab in PRINT |
| `$07` | EDIT key |
| `$08` | Cursor Left |
| `$09` | Cursor Right |
| `$0A` | Cursor Down |
| `$0B` | Cursor Up |
| `$0C` | DELETE — edit key **and** the DELETE *statement* token (context-disambiguated) |
| `$0D` | NEWLINE (end of BASIC line) |
| `$0E` | Number marker (followed by a 5-byte float in a program line) |
| `$0F` | GRAPHICS mode |
| `$10` | INK — followed by colour byte |
| `$11` | PAPER — followed by colour byte |
| `$12` | FLASH — followed by 0/1 |
| `$13` | BRIGHT — followed by 0/1 |
| `$14` | INVERSE — followed by 0/1 |
| `$15` | OVER — followed by 0/1 |
| `$16` | AT — followed by row, col |
| `$17` | TAB — followed by col |

---

## UDG Characters (`$90–$A4`)

Codes `$90`–`$A4` (144–164) are the 21 user-defined graphics **A–U**:
`$90`=UDG-A, `$91`=UDG-B, … `$A4`=UDG-U. With no custom UDGs loaded they display
as their default glyphs. The base of UDG data is the `UDG` system variable
(`$5C7B`). These codes are **not** BASIC keyword tokens — confusing them with
function tokens is the classic mistake.

---

## Function Tokens (`$A5–$C4`)

Same values as the ZX Spectrum. Printed with **no** leading space.

| Token | Keyword | Token | Keyword |
|-------|---------|-------|---------|
| `$A5` | RND     | `$A6` | INKEY$  |
| `$A7` | PI      | `$A8` | FN      |
| `$A9` | POINT   | `$AA` | SCREEN$ |
| `$AB` | ATTR    | `$AC` | AT      |
| `$AD` | TAB     | `$AE` | VAL$    |
| `$AF` | CODE    | `$B0` | VAL     |
| `$B1` | LEN     | `$B2` | SIN     |
| `$B3` | COS     | `$B4` | TAN     |
| `$B5` | ASN     | `$B6` | ACS     |
| `$B7` | ATN     | `$B8` | LN      |
| `$B9` | EXP     | `$BA` | INT     |
| `$BB` | SQR     | `$BC` | SGN     |
| `$BD` | ABS     | `$BE` | PEEK    |
| `$BF` | IN      | `$C0` | USR     |
| `$C1` | STR$    | `$C2` | CHR$    |
| `$C3` | NOT     | `$C4` | BIN     |

---

## Operator / Compound Tokens (`$C5–$CF`)

Take a leading space if they begin with a letter.

| Token | Keyword | Token | Keyword |
|-------|---------|-------|---------|
| `$C5` | OR      | `$C6` | AND     |
| `$C7` | `<=`    | `$C8` | `>=`    |
| `$C9` | `<>`    | `$CA` | LINE    |
| `$CB` | THEN    | `$CC` | TO      |
| `$CD` | STEP    | `$CE` | DEF FN  |
| `$CF` | CAT     |       |         |

---

## Command Tokens (`$D0–$FF`)

Same values as ZX Spectrum (+ Interface 1 for `$CF`/`$D0–$D4`). Take a leading
space if they begin with a letter.

| Token | Keyword | Token | Keyword |
|-------|---------|-------|---------|
| `$D0` | FORMAT  | `$D1` | MOVE    |
| `$D2` | ERASE   | `$D3` | OPEN #  |
| `$D4` | CLOSE # | `$D5` | MERGE   |
| `$D6` | VERIFY  | `$D7` | BEEP    |
| `$D8` | CIRCLE  | `$D9` | INK     |
| `$DA` | PAPER   | `$DB` | FLASH   |
| `$DC` | BRIGHT  | `$DD` | INVERSE |
| `$DE` | OVER    | `$DF` | OUT     |
| `$E0` | LPRINT  | `$E1` | LLIST   |
| `$E2` | STOP    | `$E3` | READ    |
| `$E4` | DATA    | `$E5` | RESTORE |
| `$E6` | NEW     | `$E7` | BORDER  |
| `$E8` | CONTINUE| `$E9` | DIM     |
| `$EA` | REM     | `$EB` | FOR     |
| `$EC` | GO TO   | `$ED` | GO SUB  |
| `$EE` | INPUT   | `$EF` | LOAD    |
| `$F0` | LIST    | `$F1` | LET     |
| `$F2` | PAUSE   | `$F3` | NEXT    |
| `$F4` | POKE    | `$F5` | PRINT   |
| `$F6` | PLOT    | `$F7` | RUN     |
| `$F8` | SAVE    | `$F9` | RANDOMIZE |
| `$FA` | IF      | `$FB` | CLS     |
| `$FC` | DRAW    | `$FD` | CLEAR   |
| `$FE` | RETURN  | `$FF` | COPY    |

---

## TS 2068–Only Extended Keywords (overloaded codes)

The 2068 added six keywords but had no free single-byte slots in `$A5–$FF`, so it
**overloads low character codes**, disambiguated by parse context (the executor at
`$1A6x` recognises `$0C` and `$7B–$7F` as keyword tokens when a statement is
expected). `$7B–$7F` are otherwise the symbols `{ | } ~ ©`.

| Token | Keyword | Normal meaning of the code |
|-------|---------|----------------------------|
| `$0C` | DELETE  | delete (edit/control code) |
| `$7B` | ON ERR  | `{` |
| `$7C` | STICK   | `|` |
| `$7D` | SOUND   | `}` |
| `$7E` | FREE    | `~` |
| `$7F` | RESET   | `©` |

ROM evidence: `$063B` loads `$7A` for the DELETE keyword-table-2 lookup; `$0643`
tests `CP $7C` (STICK) / `CP $7E` (FREE); `$1A87` does `SUB $7A` giving index
1/3/5 for ON ERR/SOUND/RESET. Keyword-table-2 order is DELETE, ON ERR, STICK,
SOUND, FREE, RESET.

---

## Keyboard Layout and Token Entry

### Main Keyboard (unshifted)

```
  1    2    3    4    5    6    7    8    9    0
  Q    W    E    R    T    Y    U    I    O    P
  A    S    D    F    G    H    J    K    L   ENTER
CAPS   Z    X    C    V    B    N    M    .  SYM  SPACE
```

### Key Entry Modes

| Mode | How to Enter | Cursor |
|------|-------------|--------|
| K | Default at line start | K |
| L | After entering any character | L |
| C | CAPS LOCK on | C |
| E | Extended: CAPS+SYM together | E |
| G | GRAPHICS: CAPS+9 | G |

### Symbol Shift Combinations (SYM+letter)

| Key | Result | Key | Result |
|-----|--------|-----|--------|
| A | STOP | B | * |
| C | ? | D | STEP |
| E | >= | F | TO |
| G | THEN | H | ↑ |
| I | AT | J | − |
| K | + | L | = |
| M | . | N | , |
| O | ; | P | " |
| Q | <= | R | < |
| S | NOT | T | > |
| U | OR | V | / |
| W | <> (≠) | X | £ |
| Y | AND | Z | : |

### Extended Mode (CAPS+SYM, then key) — selected keywords

The extended-mode tables map keys to the token bytes above. For example the
keyword-entry tables (`EKEYS`) store `CODE=$AF, VAL=$B0, LEN=$B1, USR=$C0,
PI=$A7, INKEY$=$A6, PEEK=$BE, TAB=$AD` — confirming the Spectrum-identical
function token values.

### Digit Keys with Symbol Shift (colours)

| Key | Result | Key | Result |
|-----|--------|-----|--------|
| 1 | BLUE | 2 | RED |
| 3 | MAGENTA | 4 | GREEN |
| 5 | CYAN | 6 | YELLOW |
| 7 | WHITE | 0 | BLACK |

---

## AY-3-8910 Sound Chip Register Map

The `SOUND` command writes register/value pairs to the AY-3-8910 via ports `$F5`
(register address) and `$F6` (data). Registers 1–16 are valid (`$01–$10`);
register 0 is invalid and causes Report C.

| Reg | Name | Description |
|-----|------|-------------|
| 1 | `$01` | Channel A tone period low byte |
| 2 | `$02` | Channel A tone period high nibble (bits 3-0) |
| 3 | `$03` | Channel B tone period low byte |
| 4 | `$04` | Channel B tone period high nibble |
| 5 | `$05` | Channel C tone period low byte |
| 6 | `$06` | Channel C tone period high nibble |
| 7 | `$07` | Noise period (bits 4-0) |
| 8 | `$08` | Mixer control / I/O enable |
| 9 | `$09` | Channel A amplitude (bit 4 = envelope mode) |
| 10 | `$0A` | Channel B amplitude |
| 11 | `$0B` | Channel C amplitude |
| 12 | `$0C` | Envelope period low byte |
| 13 | `$0D` | Envelope period high byte |
| 14 | `$0E` | Envelope shape / cycle |
| 15 | `$0F` | I/O port A data (joystick 1 when reg 8 sets port A output) |
| 16 | `$10` | I/O port B data (joystick 2) |

### Register 8 — Mixer Control

| Bit | Function |
|-----|----------|
| 0 | 0 = Channel A tone enabled |
| 1 | 0 = Channel B tone enabled |
| 2 | 0 = Channel C tone enabled |
| 3 | 0 = Channel A noise enabled |
| 4 | 0 = Channel B noise enabled |
| 5 | 0 = Channel C noise enabled |
| 6 | 1 = I/O port A is output |
| 7 | 1 = I/O port B is output |

### Reading Joysticks via STICK

`STICK` reads a joystick by reading AY register 14 (`$0E`) via port `$F6`.

```
STICK(joystick, direction):
  joystick  = 1 or 2
  direction = 1 or 2

BASIC: LET j = STICK 1,1
```

Raw joystick bits (AY register 14, complemented, masked):

```
Bits 3-0: Joystick 1 directions (inverted: 0 = active)
Bits 7-4: Joystick 2 directions (inverted: 0 = active)
```

---

## BASIC Program Line Format in Memory

```
Byte 0-1:   Line number (MSB first)
Byte 2-3:   Line length in bytes (LSB first), not counting these 4 bytes
Byte 4+:    BASIC text (tokens and ASCII), terminated by $0D (NEWLINE)
```

A numeric literal in a line is stored as its ASCII digits followed by `$0E`
(14) and a 5-byte floating-point value.

---

## Variable Storage Formats

### Numeric variable (A–Z)
```
Byte 0:    $60 | (letter − 'A')   ('A' = $60, 'Z' = $79)
Bytes 1-5: Floating point value
```

### Numeric array
```
Byte 0:    $80 | (letter − 'A')
Bytes 1-2: Total length of array data (LSB first)
Byte 3:    Number of dimensions
Bytes 4+:  Dimension sizes (2 bytes each, LSB first), then 5-byte floats, row-major
```

### String variable (A$–Z$)
```
Byte 0:    $40 | (letter − 'A')   ('A$' = $40)
Bytes 1-2: String length (LSB first)
Bytes 3+:  String characters
```

### String array
```
Byte 0:    $C0 | (letter − 'A')
Bytes 1-2: Total length
Byte 3:    Number of dimensions
Bytes 4+:  Dimension sizes (2 bytes each); string length is one dimension
```

### FOR/NEXT control variable
```
Byte 0:      $E0 | (letter − 'A')
Bytes 1-5:   Current value (float)
Bytes 6-10:  Limit (float)
Bytes 11-15: Step (float)
Byte 16:     Statement number of FOR
Bytes 17-18: Line number of FOR (LSB first)
```

### End of variables marker
```
Byte 0: $80
```
