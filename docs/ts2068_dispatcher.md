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

**Reach the dispatcher with `CALL`, and pass the service code on the stack.**
It is not passed in `A`.

The dispatcher source (EXROM $1000, copied to $6200 by HOME INIT — HOME $0E15:
`LD HL,$1000` / `LD DE,$6200` / `LD BC,$0630` / `LDIR`) begins:

```z80
        LD   IX,0
        ADD  IX,SP        ; IX = SP on entry
        ...
        LD   E,(IX+2)
        LD   D,(IX+3)     ; DE = SVC_CODE
```

and the CALL path later reads `(IX+4)/(IX+5)` as PRM_IN and `(IX+6)/(IX+7)` as
PRM_OUT, treating `(IX+0)/(IX+1)` as the return address. That fixes the layout:

```
   (IX+0)  return address     <- pushed by your CALL
   (IX+2)  SVC_CODE           <- pushed last
   (IX+4)  PRM_IN
   (IX+6)  PRM_OUT
   (IX+8)  parameter data for the service, if any  <- pushed first
```

Push in this order: parameter data, PRM_OUT, PRM_IN, SVC_CODE — then CALL.

SVC_CODE is 16-bit: bits 0-14 = service number, bit 15 = jump flag. With bit 15
set the dispatcher does a GOTO_BANK instead of a CALL_BANK: it moves your return
address into the SVC_CODE slot and jumps to the service (EXROM $1052–$1071;
GOTO_BANK discards its own return address and does `JP (IX)`), so PRM_IN /
PRM_OUT are not used, only SVC_CODE need be pushed, and the service's `RET`
comes straight back to the instruction after your `CALL`.

**Standard call template (no stack parameters):**
```asm
    LD   DE, 0
    PUSH DE              ; PRM_OUT = 0
    PUSH DE              ; PRM_IN  = 0
    LD   DE, SVC_NUMBER
    PUSH DE              ; SVC_CODE
    LD   A, (VIDMOD)
    OR   A
    JR   NZ, hi
    CALL $6200           ; normal video
    JR   done
hi: CALL $F9C0           ; VIDMOD <> 0 (dispatcher relocated)
done:
```

(Not `CALL Z,$6200` / `CALL NZ,$F9C0`: the second test would see the flags the
service returned.)

> An earlier revision of this file gave the template as `JP $6200`. That cannot
> work: with a JP there is no return address on the stack, so `(IX+2)` would
> hold PRM_IN rather than SVC_CODE. The naming of PRM_IN vs PRM_OUT — which
> direction each counts — has **not** been independently verified against the
> CALL_BANK code; treat the two counts with care until it is.

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
| $08  | CHNG_VID | —               | Change video mode — mis-targeted in the stock EXROM (table word $0EA3 is the operand of `LD DE,$0840` at $0EA2, skipping the prologue; see the note under Bank Switching) |
| $09  | W_BORD   | —               | Write border color |
| $0A–$0D | —   | —               | Reserved |
| $1D  | SENDTV   | A = char code   | Output character to screen or printer |
| $1E  | SETAT    | B = line (0–23), C = col (0–31) | Set print position |
| $1F  | ATTBYT   | HL = display address | Set attribute byte using ATTRT/MASKT/PFLAG |
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
| $13  | XFER_BYTES  | stack: banks, source, destination, length, direction | Copy a block of bytes between banks (EXROM $1522). Does not transfer control |
| $14–$18 | —       | —     | Reserved |

> **Stock-ROM table defects.** In the stock EXROM jump table the words for $11, $12
> and $13 are one byte low — $6571, $65CF, $6721 instead of $6572, $65D0, $6722
> (EXROM $1FDC/$1FDA/$1FD8). $11 and $13 land on a `RET` and do nothing; $12 lands
> on an $FF byte, so it executes `RST $38` before falling into CALL_BANK. The word
> for $08 is $0EA3, mid-instruction inside CHG_V ($0E8E). The community EXROM
> revision fixes all four (`exrom_revision_analysis.md`). On a stock machine call
> GOTO_BANK / CALL_BANK / XFER_BYTES directly at $6572 / $65D0 / $6722 (chunk 3;
> $FD32 / $FD90 / $FEE2 in chunk 7), as the ROMs themselves do (EXROM $002D
> `CALL $6572`, HOME $25FD `CALL $65D0`).

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
| $37  | RECLEN  | HL→record | BC=length | Return length of program line, variable, or array |
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
| $30  | CAT     | —     | CAT (not implemented: $30–$33 load B with the keyword token, skip the statement when syntax-checking, and give Error J when run — HOME $25C8–$25E1) |
| $31  | ERASE   | —     | ERASE (not implemented) |
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

## Jump Table (EXROM $1EDC–$1FFF)

Checked word by word against `TS2068_U20.BIN`. The word for code n is at
EXROM $1FFE − 2n. The dispatcher picks the bank by code range only: codes
$00–$0D run in the EXROM, $0E–$18 in the RAM-resident code (addresses $6xxx =
EXROM + $5200), $19 and above in the HOME ROM. Codes $0A–$0D and $14–$18 hold
$FFFF (reserved). The table ends at code $91; there is no upper range check, so
a larger code reads whatever precedes the table ($0000 for $92–$9F).

```
$00=0068  $01=00FC  $02=0189  $03=018D  $04=01AB  $05=05CC  $06=06E5  $07=0851
$08=0EA3  $09=00E5  $0E=6405  $0F=645E  $10=6499  $11=6571  $12=65CF  $13=6721
$19=02E1  $1A=03F3  $1B=0436  $1C=0A02  $1D=0500  $1E=05B2  $1F=0710  $20=0888
$21=08A9  $22=08EA  $23=0A23  $24=0A4A  $25=0D0D  $26=0D1D  $27=0D31  $28=11E1
$29=1230  $2A=12BB  $2B=1354  $2C=139F  $2D=13BE  $2E=142A  $2F=1465  $30=25C8
$31=25D4  $32=25CC  $33=25D0  $34=160D  $35=16D6  $36=16F0  $37=1720  $38=1750
$39=1788  $3A=1A27  $3B=1AD8  $3C=1C78  $3D=1C59  $3E=1D55  $3F=1D97  $40=1E82
$41=1ECA  $42=1ED4  $43=1EE4  $44=1EF1  $45=1F1E  $46=1F23  $47=1F36  $48=1F39
$49=1F99  $4A=1FBB  $4B=1FD4  $4C=1FEB  $4D=2009  $4E=201D  $4F=2155  $50=2159
$51=217E  $52=222B  $53=226B  $54=2380  $55=23DE  $56=241D  $57=2603  $58=2635
$59=263E  $5A=2660  $5B=2679  $5C=26DB  $5D=2810  $5E=2854  $5F=288E  $60=28D7
$61=29B6  $62=29E5  $63=29F2  $64=2C70  $65=2E70  $66=2E74  $67=2EBD  $68=2FAF
$69=2FC0  $6A=3059  $6B=30E6  $6C=30E9  $6D=30F9  $6E=3160  $6F=3193  $70=31A1
$71=33CE  $72=33D3  $73=3468  $74=3489  $75=356E  $76=35D3  $77=3656  $78=3ABB
$79=3ACA  $7A=3ADF  $7B=3B2E  $7C=3B9E  $7D=3BC5  $7E=3BD0  $7F=3BF5  $80=3BFD
$81=3C4E  $82=3C5E  $83=3C65  $84=3C6C  $85=11CF  $86=11ED  $87=0010  $88=02B0
$89=053A  $8A=0554  $8B=0566  $8C=073F  $8D=08A6  $8E=0939  $8F=2624  $90=2813
$91=1795
```

$08, $11, $12 and $13 are the stock-ROM defects described under Bank Switching
Services.

---

## SUBLIN Detail ($36)

Searches a BASIC line (HL) for a statement.

- **D=statement#, E=0**: Find the D'th statement. Returns Z; HL and CH_ADD point 1 byte before it. If line has exactly D−1 statements, the next line counts as D'th.
- **D=0, E=keyword token**: Find first statement whose keyword matches E. Returns NZ,NC; HL and CH_ADD point to keyword. D is decremented by number of statements examined.
- **Not found (E mode)**: Returns NZ,C; HL and CH_ADD → end-of-line byte ($0D).

---

## Floating Point Number Format (5 bytes)

```
Byte 0: Exponent (biased by $80); $00 = small-integer form (below), not "zero"
Bytes 1-4: 32-bit mantissa, most significant byte first. Bit 7 of byte 1 is the
           sign (1 = negative), standing in for the mantissa's implied leading 1
```

For small integers (−65535 to +65535), the format is:
```
Byte 0: $00 (integer form)
Byte 1: sign ($00 = positive, $FF = negative)
Bytes 2-3: 16-bit value, LSB first (two's complement when negative)
Byte 4: $00
```

Zero is the integer form `00 00 00 00 00`. Evidence: STK_BC ($30E9) stores
`A=0, E=0, D=C, C=B, B=0` through $2E74 (AEDCB), i.e. `00 00 lo hi 00`; STDE_S
($314C) writes `00, sign, lo, hi, 00` with the value negated when the sign is $FF.

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