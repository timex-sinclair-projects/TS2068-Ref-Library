# TS 2068 ROM Entry Points and Restart Vectors

All addresses are HOME ROM addresses unless marked [EXROM].
Many routines are also accessible via the function dispatcher — prefer the
dispatcher for future-compatible code. Direct ROM addresses are provided for
reference and for cases where the dispatcher cannot be used.

---

## RST (Restart) Vectors — HOME ROM

| Address | Name         | Function |
|---------|--------------|----------|
| $0000   | START/RST0   | Power-on / reset. Disables interrupts, sets DE=$FFFF, jumps to START-NEW |
| $0008   | ERROR-1/RST8 | Error handler. HL←CH_ADD, X_PTR←HL, then ERROR-2. On-stack byte = error code−1 |
| $0010   | PRINT-A-1/RST10 | Write character in A to current output channel (JP PRINT-A-2) |
| $0013   | SYS-VERSION  | Single byte $FF — ROM version identifier |
| $0018   | GET-CHAR/RST18 | Fetch character at CH_ADD into A |
| $001C   | TEST-CHAR    | Test if character is printable (called by GET-CHAR) |
| $0020   | NEXT-CHAR/RST20 | Advance CH_ADD and fetch next character |
| $0028   | CALCULATE/RST28 | Enter floating-point calculator interpreter |
| $0030   | BC-SPACES/RST30 | Create BC free bytes in workspace (ALLOCBC) |
| $0038   | MASK-INT/RST38 | Maskable interrupt: increment FRAMES, scan keyboard |

## RST Vectors — EXROM (when EXROM is mapped in)

| Address | Name         | Function |
|---------|--------------|----------|
| $0000   | XRST0        | Cold start with EXROM active — jumps to EXROM-STARTUP |
| $0008   | XRST8        | RST 8 with EXROM active — routes error back to HOME ROM via dispatcher |
| $0038   | XRST38       | Keyboard interrupt with EXROM active — routes to RAM INT service |

---

## Key HOME ROM Subroutines by Category

### Startup and Initialization

| Address | Name        | Description |
|---------|-------------|-------------|
| ~$11CB  | START-NEW   | Main init entry. DE=$FFFF=cold start; A=$FF=warm. Sets up memory, clears BASIC, runs MAIN-EXEC |
| ~$1219  | SET-MIN     | Set minimum workspace: clear vars, reset calc stack, set system variable defaults |

### Error Handling

| Address | Name    | Description |
|---------|---------|-------------|
| $0053   | ERROR-2 | Pop error address from stack, load error code to ERR_NR, restore SP from ERRSP, jump SET-STK |
| $0055   | ERROR-3 | Store L to ERR_NR, restore SP from ERRSP, jump SET-STK |
| ~$1354  | SET-STK | Reset calculator stack and memory pointers; return to MAIN loop |

### Character I/O

| Address | Name        | Description |
|---------|-------------|-------------|
| $0010   | PRINT-A-1   | JP to PRINT-A-2 (stream output) |
| ~$0F2C  | PRINT-A-2   | Write A to current output stream (the actual implementation) |
| $0018   | GET-CHAR    | Fetch char at CH_ADD → A |
| $0020   | NEXT-CHAR   | Advance CH_ADD, fetch next char → A |
| $0074   | CH_ADD+1    | Increment CH_ADD, return new char in A |
| $0077   | TEMP-PTR1   | Set CH_ADD = HL+1, return char |
| $0078   | TEMP-PTR2   | Set CH_ADD = HL, return char |
| $007D   | SKIP-OVER   | Advance past control codes ($10–$17); return NC if printable |

### Keyboard

| Address | Name       | Description |
|---------|------------|-------------|
| ~$02B5  | KEYBOARD   | Full keyboard scan: reads all half-rows, debounces, returns in KSTATE/LASTK |
| ~$0333  | K-DECODE   | Decode raw key reading to character code |
| ~$028C  | KKEYS      | Symbol-shift key table base |
| ~$024E  | EKEYS      | Extended-mode key table base |

### Screen Output

| Address | Name         | Description |
|---------|--------------|-------------|
| ~$0F2C  | PRINT-OUT    | Main character output dispatcher (handles control codes and printable chars) |
| ~$0A4E  | CLS-LOWER    | Clear lower screen |
| ~$0DAF  | CLS          | Clear entire screen |
| ~$0D6B  | SCROLL       | Scroll screen up one line |
| ~$0DD9  | PRINT-A-2    | Output A to stream |
| ~$0BDB  | OPEN-CHAN    | Open channel for I/O |
| ~$0BA2  | SELECT-S    | Select stream by number |

### Memory Management

| Address | Name      | Description |
|---------|-----------|-------------|
| $0030   | BC-SPACES | Create BC free bytes in workspace |
| ~$1655  | RESERVE   | Allocate workspace (called by BC-SPACES) |
| ~$19E5  | RECLAIM-1 | Reclaim memory: HL=start, DE=end |
| ~$19E8  | RECLAIM-2 | Reclaim BC bytes from DE |
| ~$1A29  | MAKE-ROOM | Insert BC bytes at HL |

### BASIC Interpreter

| Address | Name        | Description |
|---------|-------------|-------------|
| ~$1B55  | MAIN-EXEC   | BASIC main execution loop (MAIN-1 through MAIN-9) |
| ~$1B5A  | MAIN-1      | Test BREAK, print report, clear lower screen |
| ~$1B6A  | MAIN-2      | Get BASIC line for execution |
| ~$1B7A  | MAIN-4      | Execute current BASIC line |
| ~$1B8A  | MAIN-G      | Error reporting and screen reset |
| ~$1B9E  | MAIN-9      | Wait for keypress |
| ~$1A7A  | LINE-SCAN   | Scan/execute a BASIC statement |
| ~$1A1B  | NEXT-STATEMENT | Advance to next statement |

### Expression Evaluation

| Address | Name        | Description |
|---------|-------------|-------------|
| ~$28B2  | SCANNING    | Evaluate expression; result on calculator stack |
| ~$2A7E  | S-NUMERIC   | Mark result as numeric |

### Floating Point Calculator

| Address | Name       | Description |
|---------|------------|-------------|
| $0028   | CALCULATE  | Calculator entry point (RST $28) |
| ~$335E  | CALC-ENTRY | Main calculator interpreter loop |

### Tape Routines (HOME ROM remnants; most are in EXROM)

| Address | Name      | Description |
|---------|-----------|-------------|
| ~$0605  | BEEPER    | Generate tone (PARP equivalent in HOME ROM) |
| ~$0507  | BEEP      | BEEP command implementation |

---

## Key EXROM Subroutines

| Address [EXROM] | Name         | Description |
|-----------------|--------------|-------------|
| $006B           | SA-BYTES     | Save bytes to tape (SAVE subroutine) |
| ~$0100          | LD-BYTES     | Load bytes from tape (LOAD subroutine) |
| ~$053F          | SA-ALL       | SAVE — build header, save program/data |
| ~$0605          | LD-ALL       | LOAD — load program/data |
| ~$0700          | VF-BYTES     | VERIFY bytes |
| $1000           | DISPATCHER   | Function dispatcher (copied to RAM; do not call directly) |
| $1100           | AROS-INIT    | CART-INIT — scan and build SYSCON table from cartridge |
| ~$1400          | INIT-RAM     | Initialize RAM and system variables |
| $0DB0           | OPEN-DFILE   | Open second display file |
| $0E27           | CLOSE-DFILE  | Close second display file (has known bug) |

---

## Floating Point Calculator Opcodes

Called via RST $28 followed by a byte sequence; terminated by $38 (END-CALC).

| Byte | Name       | Operation |
|------|------------|-----------|
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
| $1A  | read-in    | |
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
| $32  | n-mod-m    | X = Y MOD X |
| $33  | jump       | Unconditional jump (next byte = signed offset) |
| $34  | stk-data   | Push literal value(s) onto stack |
| $35  | dec-jr-nz  | Decrement BREG; jump if non-zero |
| $36  | less-0     | X = (X < 0) |
| $37  | greater-0  | X = (X > 0) |
| $38  | end-calc   | **End of calculator sequence** |
| $39  | get-argt   | Get argument (for trig, convert to radians if needed) |
| $3A  | truncate   | Truncate to integer |
| $3B  | fp-calc-2  | Used internally |
| $3C  | e-to-fp    | |
| $3D  | re-stack   | |
| $3E  | series-06  | Calculate series (6 terms) |
| $3F  | series-08  | Calculate series (8 terms) |
| $A0–$BF | (memory operations) | Store/recall calculator memory 0-5 |
| $C0–$DF | (exchange memory) | |

**Memory opcodes:**
- $C0–$C5: Store to MEM0–MEM5
- $E0–$E5: Recall from MEM0–MEM5
- $A0–$A5: Store to MEM; stack top replaced

---

## NMI Handler ($0066)

The NMI routine checks NMIADD ($5CB0). If NMIADD = $0000, it jumps to that address
(intended as reset). Otherwise it returns with RETN.

**Known bug:** The code uses `JR NZ, NO-RESET` where it should use `JR Z`. As a result,
setting NMIADD to non-zero triggers a reset, and zero does not. This is the opposite
of the documented behavior.

To use NMI for a custom handler: set NMIADD to your handler's address. The handler
fires when the NMI line is asserted (no standard hardware asserts it on the base 2068).

---

## ON ERROR / ONERR

TS 2068 extension. ERRLN ($5CB6) holds the line number for ON ERROR GOTO.

When an error occurs and ERRLN is non-zero (bit 15 of ERRLN+1 is clear):
- The BASIC interpreter jumps to the line in ERRLN
- ERRC ($5CB8), ERRS ($5CBA), and ERRT ($5CBB) hold the error details
- ONERR is entered with token $C1 in BASIC

To disable error trapping from machine code: set (ERRLN+1) bit 7.