# TS 2068 Function Dispatcher

The dispatcher is a body of code copied from EXROM $1000 to RAM at boot. It provides
a stable, version-independent calling interface to OS routines. Code written to use
the dispatcher should survive ROM updates.

---

## Dispatcher Location

```
VIDMOD ($5CC2) = 0     →  entry point $6200   (normal, single display file)
VIDMOD ($5CC2) ≠ 0     →  entry point $F9C0   (second display file active)
```

Always read VIDMOD before calling. The second display file moves the dispatcher and
machine stack from chunk 3 to chunk 7; failing to check causes a crash.

---

## Calling Convention

**Without jump flag (CALL — returns to caller):**

Push in this order (last item pushed = top of stack at CALL):
```
1. Parameter data for the service (if any)
2. PRM_OUT  — 16-bit: bytes of data you are passing on the stack (pushes × 2)
3. PRM_IN   — 16-bit: bytes of data the service will return on the stack (pushes × 2)
4. SVC_CODE — 16-bit: bits 0-14 = service number; bit 15 = 0 (CALL mode)
```

**With jump flag (JP — no return):**

Push only SVC_CODE with bit 15 SET:
```
1. SVC_CODE | $8000  — service number with jump flag set
```

**Standard call template (no stack parameters):**
```asm
    LD   DE, 0
    PUSH DE              ; PRM_OUT = 0
    PUSH DE              ; PRM_IN  = 0
    LD   DE, SVC_NUMBER
    PUSH DE              ; SVC_CODE
    LD   A, (VIDMOD)
    OR   A
    JP   Z,  $6200       ; normal video
    JP   $F9C0           ; extended video
```

---

## Service Code Table

### Tape Services

| Code | Name    | Description |
|------|---------|-------------|
| $00  | W_TAPE  | Write block to tape |
| $01  | R_TAPE  | Read block from tape |
| $02  | RD_BIT  | Read one bit from tape |
| $03  | R_EDGE  | Read one edge from tape |
| $04  | SLVM    | General-purpose tape routine |
| $05  | LOAD    | LOAD command |
| $06  | MERGE   | MERGE command |
| $07  | SAVE    | SAVE command |

### Video and Display Services

| Code | Name     | Entry conditions | Description |
|------|----------|-----------------|-------------|
| $08  | CHNG_VID | —               | Change video mode |
| $09  | W_BORD   | —               | Write border color |
| $0A–$0D | —   | —               | Reserved |
| $1D  | SENDTV   | A = char code   | Output character to screen or printer |
| $1E  | SETAT    | B = line (0–23), C = col (0–31) | Set print position |
| $1F  | STTBYT   | HL = display address | Set attribute byte using ATTRT/MASKT/PFLAG |
| $20  | R_ATTS   | —               | Copy permanent attributes → temporary attribute vars |
| $21  | CLLHS    | —               | Clear lower half of primary display file |
| $22  | CLS      | —               | Clear entire primary display file |
| $23  | DUMPPR   | —               | Print/clear printer buffer |
| $24  | PRSCAN   | HL = pixel addr, B = scans remaining (1–8) | Send 32-byte scan to printer |
| $25  | DESLUG   | HL = address    | Remove number slugs from edit line buffer |
| $34  | FLASHA   | A = char code   | Flash char to screen (lower screen must be selected) |
| $57  | SCRMBL   | B = Y, C = X    | Returns display address in HL, bit number in A. Error B if Y > 175 |
| $5F  | F_SCRN   | stack: line, col | SCREEN$. BC=0 if none; BC=1, DE→char code if match |
| $60  | F_ATTR   | stack: Y, X     | ATTR. Returns attribute byte value on calc stack |
| $8D  | K_CLS    | —               | CLS command (calls CLS + CLLHS) |
| $8E  | SCRL     | —               | Scroll primary display file up 1 line |
| $8F  | F_PNT    | stack: X, Y     | POINT. Returns 0 or 1 on calc stack |
| $90  | DRAWLN   | B = Y, C = X    | Same as DRAW_L via register entry |

### Bank Switching Services (Expansion Hardware)

| Code | Name        | Entry | Description |
|------|-------------|-------|-------------|
| $0E  | GET_STATUS  | B = bank# | Returns memory selection (low active) in C |
| $0F  | GET_NUMBER  | —     | Get bank number |
| $10  | BANK_ENABLE | —     | Enable a bank |
| $11  | GOTO_BANK   | —     | JP to routine in another bank (no return) |
| $12  | CALL_BANK   | —     | CALL routine in another bank (returns) |
| $13  | XFER_BANK   | —     | Transfer execution to another bank |
| $14–$18 | —       | —     | Reserved |

### Keyboard Services

| Code | Name    | Entry | Returns | Description |
|------|---------|-------|---------|-------------|
| $19  | UPD_K   | —     | —       | Process keyboard input |
| $63  | F_INKY  | —     | BC=1+DE→code if key, BC=0 if none | INKEY$ |
| $88  | K_SCAN  | —     | —       | Raw keyboard scan |
| $4D  | BREAK?  | —     | NC = BREAK pressed | Test CAPS-SHIFT + SPACE |

### Sound Services

| Code | Name | Entry | Description |
|------|------|-------|-------------|
| $1A  | PARP | HL = N, DE = cycles−1 | Generate tone: period = 8N+236 T-states, DE+1 cycles |
| $1B  | BEEP | calc stack: duration, pitch | BEEP command; exits via PARP |
| $1C  | K_DUMP | — | COPY: dump primary display to printer |

### Memory / System Services

| Code | Name    | Entry | Returns | Description |
|------|---------|-------|---------|-------------|
| $26  | K_NEW   | —     | —       | NEW command |
| $27  | INIT    | DE=max RAM, A=0 cold/A=$FF NEW | — | Initialize system |
| $2A  | INSERT  | HL=addr, BC=bytes | BC=0, DE=last inserted, HL=before first | Insert BC bytes before HL |
| $2B  | RESET   | —     | —       | Reset calculator stack (STKEND=STKBOT, MEM=MEMBOT) |
| $37  | RECLЕН  | HL→record | BC=length | Return length of program line, variable, or array |
| $38  | DELREC  | HL→record, BC=length | — | Delete record; update system variables |
| $47  | CLEAR   | stack: new RAMTOP | — | CLEAR command |
| $48  | CLR_BC  | BC = new RAMTOP | — | Set RAMTOP, delete vars, clear screen/calc stack |
| $4A  | CHK_SZ  | BC = needed bytes | — | Check BC+80 bytes free between STKEND and RAMTOP; Error 4 if not |

### Channel and Stream Services

| Code | Name    | Entry | Description |
|------|---------|-------|-------------|
| $28  | INCH    | —     | Input one char to A from current channel; NC if none available |
| $29  | SELECT  | A = stream# | Select stream |
| $2C  | CLOSE   | stack: channel# | CLOSE # command |
| $2D  | CLCHAN  | BC = STRMS index | Close channel |
| $2E  | OPEN    | stack: channel#, device spec | OPEN # command |
| $2F  | OPCHAN  | stack: device spec; DE = STRMS pointer | Open channel |
| $30  | CAT     | —     | CAT (not implemented) |
| $31  | DELETE  | —     | DELETE (not implemented) |
| $32  | FORMAT  | —     | FORMAT (not implemented) |
| $33  | MOVE    | —     | MOVE (not implemented) |
| $54  | NOTKB?  | —     | Z if current channel is 'K' (keyboard/lower screen) |
| $85  | RDCH    | —     | Wait for char from current channel → A; Error 8 at EOF |
| $86  | SENDCH  | A = char | Write char to current output channel |
| $87  | WRCH    | A = char | Write character |

### BASIC I/O and Formatting

| Code | Name   | Entry | Description |
|------|--------|-------|-------------|
| $3A  | SYNTAX | —     | Syntax-check ELINE; ERR_NR=$FF if clean |
| $3B  | EXCUTE | —     | Execute command(s) from ELINE |
| $39  | PUT_BC | BC = value | Convert BC to ASCII and output to current channel |
| $4F  | K_LPR  | —     | LPRINT — selects channel 3, processes statement |
| $50  | K_PRIN | —     | PRINT — selects channel 2, processes statement |
| $51  | P_SEQ  | CH_ADD = start | Process output items/controls from BASIC statement |
| $52  | INPUT  | —     | INPUT command |
| $53  | I_SEQ  | CH_ADD = start | Process input items/controls |
| $55  | COLOR  | D=color (0–9), C/NC = INK/PAPER | Adjust ATTRT/MASKT/PFLAG; Error K if invalid |
| $56  | HIFLSH | D=value (0,1,8), C/NC = FLASH/BRIGHT | Adjust attrs; Error K if invalid |
| $8C  | PUTMES | A=msg#, DE=table base | Output message from variable-length table |
| $91  | PUT_LN | HL→line# | Output 4-digit right-aligned line number to current channel |
| $89  | P_LFT  | —     | Backspace (column − 1 for selected device) |
| $8A  | P_RT   | —     | Output one space to selected device |
| $8B  | P_NL   | —     | End-of-line (next line on screen or flush printer) |

### BASIC Control Flow

| Code | Name   | Entry | Description |
|------|--------|-------|-------------|
| $3C  | FOR    | —     | FOR command |
| $3D  | STOP   | —     | STOP (RST 8, error 9) |
| $3E  | NEXT   | —     | NEXT command |
| $3F  | READ   | —     | READ command |
| $40  | DATA   | —     | DATA statement |
| $41  | RESTBC | BC = line# | RESTORE command |
| $42  | RAND   | stack: value | RANDOMIZE; 0 = use FRAMES as seed |
| $43  | CONT   | —     | CONTINUE: OLDPPC/OSPCC → NEWPPC/NSPPC |
| $44  | JUMP   | stack: line# | GOTO: line# → NEWPPC, NSPPC = 0 |
| $49  | GO_SUB | stack: line# | GOSUB: inserts 3-byte return block on machine stack |
| $4B  | RETURN | —     | RETURN: pops GOSUB block; Error 7 if not found |
| $4C  | PAUSE  | stack: frames | Wait BC frames or until key; needs EI |
| $35  | FIND_L | HL = line# | Find BASIC line. Z+HL=addr if found; NZ+HL=next larger if not |
| $36  | SUBLIN | HL→line, D=stmt#, E=0 (or D=0,E=token) | Find statement; see notes below |
| $4E  | DEF    | —     | DEF FN |

### Variables and Expressions

| Code | Name   | Entry | Returns | Description |
|------|--------|-------|---------|-------------|
| $5E  | EXPRN  | CH_ADD → expr | result on calc stack | Evaluate BASIC expression |
| $61  | RND    | —     | float on stack | RND function (uses SEED) |
| $62  | F_PI   | —     | π on stack | PI function |
| $64  | FIND_N | CH_ADD → name | FLAGS bit 6 adjusted | Parse and find variable |
| $65  | PSHSTR | DE=addr, BC=len | — | Push string onto calc stack |
| $66  | PAEDCB | DE=addr, BC=len | — | Push string; preserve FLAGS bit 6 |
| $67  | LET    | —     | —       | LET command |
| $68  | POPSTR | —     | BCDEA from stack | Pop string from calc stack |
| $69  | DIM    | —     | —       | DIM statement |

### Floating Point / Math

| Code | Name   | Entry | Returns | Description |
|------|--------|-------|---------|-------------|
| $6A  | STKUSN | A = first digit/char, CH_ADD→rest | float on stack | Stack unsigned number from ASCII |
| $6B  | STK_A  | A = value | — | Push 1-byte unsigned int as float |
| $6C  | STK_BC | BC = value | — | Push 2-byte unsigned int as float |
| $6D  | ININT  | A = first digit, CH_ADD→rest | — | Convert ASCII digits to unsigned float |
| $6E  | FP2BC  | — | BC = value | Pop float → BC rounded. NZ if negative, C if > 65535 |
| $6F  | FP2A   | — | A = value | Pop float → A rounded. NZ if negative, C if > 255 |
| $45  | FIX_U1 | — | A | Pop float → A (unsigned). Error B if out of range |
| $46  | FIX_U  | — | BC | Pop float → BC (unsigned). Error B if out of range |
| $70  | OUTPUT | — | — | Print top of calc stack to current channel |
| $71  | SUB    | HL,DE→operands | — | Float subtract: (HL) − (DE); DE = HL+5 |
| $72  | ADD    | HL,DE→operands | — | Float add: (HL) + (DE) |
| $73  | MULT   | HL,DE→operands | — | Integer multiply HL × DE; C if overflow |
| $74  | TIMES  | HL,DE→operands | — | Float multiply |
| $75  | DIVIDE | HL,DE→operands | — | Float divide (HL)/(DE) |
| $76  | TRUNC  | HL→float | — | Truncate float towards zero to integer |
| $77  | FLOAT  | HL→integer | — | Convert 5-byte integer to float |
| $78  | INTDIV | — | DE,HL→stack | Replace top two (X,Y) with X mod Y and INT(X/Y) |
| $79  | INT    | — | HL→top | Replace top of stack with INT(x) |
| $7A  | EXP    | — | — | Replace top with EXP(x) |
| $7B  | LN     | — | — | Replace top with LN(x) |
| $7C  | ANGLE  | — | — | Replace top X with Y where SIN(X)=SIN(PI/2 × Y) |
| $7D  | COS    | — | — | Replace top with COS(x) |
| $7E  | SIN    | — | — | Replace top with SIN(x) |
| $7F  | TAN    | — | — | Replace top with TAN(x) |
| $80  | ATN    | — | — | Replace top with ARCTAN(x) |
| $81  | ASN    | — | — | Replace top with ARCSIN(x) |
| $82  | ACS    | — | — | Replace top with ARCCOS(x) |
| $83  | ROOT   | — | — | Replace top with SQR(x) |
| $84  | TO_THE | — | — | Replace top two (X,Y) with X ** Y |

### Graphics

| Code | Name   | Entry | Description |
|------|--------|-------|-------------|
| $58  | PLOT   | stack: X, Y | PLOT command |
| $59  | PLOTBC | B=Y, C=X    | Plot pixel; handle OVER/INVERSE via PFLAG; update COORDS |
| $5A  | GET_XY | stack: two numbers | Pop to B (top) and C; D/E = signs (+1/−1) |
| $5B  | CIRCLE | —           | CIRCLE command (params from BASIC statement) |
| $5C  | DRAW   | —           | DRAW command (params from BASIC statement) |
| $5D  | DRAW_L | stack: X, Y | Plot line from COORDS to COORDS+XY |

---

## SUBLIN Detail ($36)

Searches a BASIC line (HL) for a statement.

- **D=statement#, E=0**: Find the D'th statement. Returns Z; HL and CH_ADD point 1 byte before it. If line has exactly D−1 statements, the next line counts as D'th.
- **D=0, E=keyword token**: Find first statement whose keyword matches E. Returns NZ,NC; HL and CH_ADD point to keyword. D is decremented by number of statements examined.
- **Not found (E mode)**: Returns NZ,C; HL and CH_ADD → end-of-line byte ($0D).

---

## Floating Point Number Format (5 bytes)

```
Byte 0: Exponent (biased by $80; $00 = value is 0)
Byte 1: Sign in bit 7 (1=negative); bits 6-0 = mantissa bits 54-48
Bytes 2-4: Mantissa bits 47-24 (most significant first)
```

For small integers (0–65535), the format is:
```
Byte 0: $00 (flag: integer follows)
Byte 1: $00
Byte 2: sign (0=positive, $FF=negative)
Bytes 3-4: 2-byte integer (MSB first)
```

---

## Error Numbers (ERR_NR = code − 1)

Stored as code−1 in ERR_NR ($5C3A). ERRT ($5CBB) holds the actual code.

| Code | Report | Message |
|------|--------|---------|
| 0    | 0 | OK |
| 1    | 1 | NEXT without FOR |
| 2    | 2 | Variable not found |
| 3    | 3 | Subscript wrong |
| 4    | 4 | Out of memory |
| 5    | 5 | Out of screen |
| 6    | 6 | Number too big |
| 7    | 7 | RETURN without GOSUB |
| 8    | 8 | End of file |
| 9    | 9 | STOP statement |
| 10   | A | Invalid argument |
| 11   | B | Integer out of range |
| 12   | C | Nonsense in BASIC |
| 13   | D | BREAK - CONT repeats |
| 14   | E | Out of DATA |
| 15   | F | Invalid file name |
| 16   | G | No room for line |
| 17   | H | STOP in INPUT |
| 18   | I | FOR without NEXT |
| 19   | J | Invalid I/O device |
| 20   | K | Invalid color |
| 21   | L | BREAK into program |
| 22   | M | RAMTOP no good |
| 23   | N | Statement lost |
| 24   | O | Invalid stream |
| 25   | P | FN without DEF |
| 26   | Q | Parameter error |
| 27   | R | Tape loading error |
| 28   | S | Missing LROS |