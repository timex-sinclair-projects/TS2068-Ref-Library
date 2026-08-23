# Z80 CPU Combined Reference

Combined from two sources:
- *The Complete Z80 OP-Code Reference* by Devin Gardner (2000)
- Wikipedia: Z80 instruction set

Corrections and TS 2068-specific notes added.

---

## TS 2068 Register Constraints

**IY is permanently reserved by the OS.** On the TS 2068 (and ZX Spectrum),
IY is permanently set to $5C3A (ERR_NR) and used for IY-relative system
variable access throughout the ROM. Any code that modifies IY will silently
corrupt system variables. Never use IY as a general-purpose register in
TS 2068 programs. Use IX instead, or use the undocumented IYH/IYL half
registers for temporary scratch (with care).

**TS 2068 clock and frame timing:**
- CPU clock: 3.528 MHz
- T-states per frame: ~58,800 (60 Hz display)
- One frame ≈ 16.67 ms

Useful for BEEP timing loops, animation pacing, and interrupt-driven code.

---

## Flag Register (F)

```
Bit:  7   6   5   4   3   2   1   0
Flag: S   Z   -   H   -  P/V  N   C
```

| Symbol | Flag | Bit | Meaning |
|--------|------|-----|---------|
| S | Sign | 7 | Set if result is negative (bit 7 of result = 1) |
| Z | Zero | 6 | Set if result is zero |
| H | Half Carry | 4 | Carry from bit 3 to bit 4 (used by DAA) |
| P/V | Parity/Overflow | 2 | Parity (logical ops) or overflow (arithmetic) |
| N | Add/Subtract | 1 | Reset for ADD, set for SUB (used by DAA) |
| C | Carry | 0 | Carry out of bit 7 |

Flag effect symbols used in the table below:

| Symbol | Meaning |
|--------|---------|
| `*` | Affected (set or reset according to result) |
| `-` | Unaffected |
| `0` | Always reset (cleared) |
| `1` | Always set |
| `?` | Unknown / undefined behaviour |

Flag columns are shown in order: **S Z H P N C**

---

## Register Encoding (rb)

Used to compute opcodes for instructions of the form `OP r`:

| Register | rb value |
|----------|----------|
| B | 0 |
| C | 1 |
| D | 2 |
| E | 3 |
| H | 4 |
| L | 5 |
| (HL) | 6 |
| A | 7 |

Add `rb` to the base opcode byte shown in the table.
For `LD (IX+N),r` and `LD (IY+N),r`, add `rb` to the byte *before* the last byte.

For bit instructions (BIT, SET, RES), the bit number `b` (0–7) is encoded as `8*b`
added to the base opcode.

---

## Opcode Table

**Column key:** `Clk` = T-states | `Sz` = bytes | `SZHPNC` = flag effects | `Opcode` = hex

For conditional instructions showing two clock values (e.g. `17/1`): first value
is when the condition is met (branch taken); second is when it is not.

Flag columns are inherited from the first row of each instruction group —
rows with a blank flag column have the same flags as the group header above them.

```
Mnemonic       Clk  Sz  SZHPNC  Opcode          Description / Notes
─────────────────────────────────────────────────────────────────────────────────
ADC A,r         4   1   ***V0*  88+rb           A = A + s + CY
ADC A,N         7   2           CE XX
ADC A,(HL)      7   1           8E
ADC A,(IX+N)   19   3           DD 8E XX
ADC A,(IY+N)   19   3           FD 8E XX
ADC HL,BC      15   2   **?V0*  ED 4A           HL = HL + ss + CY
ADC HL,DE      15   2           ED 5A
ADC HL,HL      15   2           ED 6A
ADC HL,SP      15   2           ED 7A
─────────────────────────────────────────────────────────────────────────────────
ADD A,r         4   1   ***V0*  80+rb           A = A + s
ADD A,N         7   2           C6 XX
ADD A,(HL)      7   1           86
ADD A,(IX+N)   19   3           DD 86 XX
ADD A,(IY+N)   19   3           FD 86 XX
ADD HL,BC      11   1   --?-0*  09              HL = HL + ss
ADD HL,DE      11   1           19
ADD HL,HL      11   1           29
ADD HL,SP      11   1           39
ADD IX,BC      15   2   --?-0*  DD 09           IX = IX + pp
ADD IX,DE      15   2           DD 19
ADD IX,IX      15   2           DD 29
ADD IX,SP      15   2           DD 39
ADD IY,BC      15   2   --?-0*  FD 09           IY = IY + rr
ADD IY,DE      15   2           FD 19
ADD IY,IY      15   2           FD 29
ADD IY,SP      15   2           FD 39
─────────────────────────────────────────────────────────────────────────────────
AND r           4   1   ***P00  A0+rb           A = A & s
AND N           7   2           E6 XX
AND (HL)        7   1           A6
AND (IX+N)     19   3           DD A6 XX
AND (IY+N)     19   3           FD A6 XX
─────────────────────────────────────────────────────────────────────────────────
BIT b,r         8   2   ?*1?0-  CB 40+8*b+rb   Test bit b; Z = ~(m & 2^b)
BIT b,(HL)     12   2           CB 46+8*b
BIT b,(IX+N)   20   4           DD CB XX 46+8*b
BIT b,(IY+N)   20   4           FD CB XX 46+8*b
─────────────────────────────────────────────────────────────────────────────────
CALL NN        17   3   ------  CD XX XX        Unconditional call; -(SP)=PC, PC=nn
CALL C,NN    17/1   3           DC XX XX        If Carry = 1
CALL NC,NN   17/1   3           D4 XX XX        If Carry = 0
CALL M,NN    17/1   3           FC XX XX        If Sign = 1 (negative)
CALL P,NN    17/1   3           F4 XX XX        If Sign = 0 (positive)
CALL Z,NN    17/1   3           CC XX XX        If Zero = 1
CALL NZ,NN   17/1   3           C4 XX XX        If Zero = 0
CALL PE,NN   17/1   3           EC XX XX        If Parity = 1 (even)
CALL PO,NN   17/1   3           E4 XX XX        If Parity = 0 (odd)
─────────────────────────────────────────────────────────────────────────────────
CCF             4   1   --?-0*  3F              Complement Carry; CY = ~CY
─────────────────────────────────────────────────────────────────────────────────
CP r            4   1   ***V1*  B8+rb           Compare A-s; flags set, A unchanged
CP N            7   2           FE XX
CP (HL)         7   1           BE
CP (IX+N)      19   3           DD BE XX
CP (IY+N)      19   3           FD BE XX
CPD            16   2   ****1-  ED A9           A-(HL); HL=HL-1; BC=BC-1
CPDR         21/1   2           ED B9           CPD until A=(HL) or BC=0
CPI            16   2   ****1-  ED A1           A-(HL); HL=HL+1; BC=BC-1
CPIR         21/1   2           ED B1           CPI until A=(HL) or BC=0
─────────────────────────────────────────────────────────────────────────────────
CPL             4   1   --1-1-  2F              A = ~A (one's complement)
─────────────────────────────────────────────────────────────────────────────────
DAA             4   1   ***P-*  27              Decimal adjust A for BCD arithmetic
─────────────────────────────────────────────────────────────────────────────────
DEC A           4   1   ***V1-  3D              s = s - 1
DEC B           4   1           05
DEC C           4   1           0D
DEC D           4   1           15
DEC E           4   1           1D
DEC H           4   1           25
DEC L           4   1           2D              (note: size is 1 byte, not 2)
DEC (HL)       11   1           35
DEC (IX+N)     23   3           DD 35 XX
DEC (IY+N)     23   3           FD 35 XX
DEC BC          6   1   ------  0B              ss = ss - 1; no flags affected
DEC DE          6   1           1B
DEC HL          6   1           2B
DEC SP          6   1           3B
DEC IX         10   2   ------  DD 2B           xx = xx - 1
DEC IY         10   2           FD 2B
─────────────────────────────────────────────────────────────────────────────────
DI              4   1   ------  F3              Disable maskable interrupts
─────────────────────────────────────────────────────────────────────────────────
DJNZ $+2     13/8   1   ------  10 XX           B = B-1; jump if B ≠ 0 (signed offset)
─────────────────────────────────────────────────────────────────────────────────
EI              4   1   ------  FB              Enable maskable interrupts
─────────────────────────────────────────────────────────────────────────────────
EX (SP),HL     19   1   ------  E3              (SP) <-> HL
EX (SP),IX     23   2           DD E3           (SP) <-> IX
EX (SP),IY     23   2           FD E3           (SP) <-> IY
EX AF,AF'       4   1           08              AF <-> AF'
EX DE,HL        4   1           EB              DE <-> HL
EXX             4   1           D9              BC/DE/HL <-> BC'/DE'/HL' (AF unaffected)
─────────────────────────────────────────────────────────────────────────────────
HALT            4   1   ------  76              Halt; CPU executes NOPs until interrupt
─────────────────────────────────────────────────────────────────────────────────
IM 0            8   2   ------  ED 46           Interrupt mode 0 (8080 compatible)
IM 1            8   2           ED 56           Interrupt mode 1 (RST $38 on interrupt)
IM 2            8   2           ED 5E           Interrupt mode 2 (vector table via I reg)
─────────────────────────────────────────────────────────────────────────────────
IN A,(N)       11   2   ------  DB XX           A = port(A:N); upper addr byte = A
IN A,(C)       12   2   ***P0-  ED 78           A = port(BC); flags set
IN B,(C)       12   2           ED 40           r = port(BC); 16-bit port address
IN C,(C)       12   2           ED 48
IN D,(C)       12   2           ED 50
IN E,(C)       12   2           ED 58
IN H,(C)       12   2           ED 60
IN L,(C)       12   2           ED 68
IN (C)         12   2   ***P0-  ED 70           Read port to nowhere; flags only (undocumented)
─────────────────────────────────────────────────────────────────────────────────
INC A           4   1   ***V0-  3C              r = r + 1
INC B           4   1           04
INC C           4   1           0C
INC D           4   1           14
INC E           4   1           1C
INC H           4   1           24
INC L           4   1           2C
INC (HL)       11   1           34
INC (IX+N)     23   3           DD 34 XX
INC (IY+N)     23   3           FD 34 XX
INC BC          6   1   ------  03              ss = ss + 1; no flags affected
INC DE          6   1           13
INC HL          6   1           23
INC SP          6   1           33
INC IX         10   2   ------  DD 23           xx = xx + 1
INC IY         10   2           FD 23
─────────────────────────────────────────────────────────────────────────────────
IND            16   2   ?*??1-  ED AA           (HL)=port(BC); HL=HL-1; B=B-1
INDR         21/1   2   ?1??1-  ED BA           IND until B=0
INI            16   2   ?*??1-  ED A2           (HL)=port(BC); HL=HL+1; B=B-1
INIR         21/1   2   ?1??1-  ED B2           INI until B=0
─────────────────────────────────────────────────────────────────────────────────
JP NN          10   3   ------  C3 XX XX        Unconditional jump; PC=nn
JP (HL)         4   1           E9              PC = HL (not indirect — jumps to address in HL)
JP (IX)         8   2           DD E9           PC = IX
JP (IY)         8   2           FD E9           PC = IY
JP C,NN      10/1   3           DA XX XX        If Carry = 1
JP NC,NN     10/1   3           D2 XX XX        If Carry = 0
JP M,NN      10/1   3           FA XX XX        If Sign = 1 (negative)
JP P,NN      10/1   3           F2 XX XX        If Sign = 0 (positive)
JP Z,NN      10/1   3           CA XX XX        If Zero = 1
JP NZ,NN     10/1   3           C2 XX XX        If Zero = 0
JP PE,NN     10/1   3           EA XX XX        If Parity = 1 (even)
JP PO,NN     10/1   3           E2 XX XX        If Parity = 0 (odd)
─────────────────────────────────────────────────────────────────────────────────
JR $+2         12   2   ------  18 XX           Relative jump; PC = PC+2+offset (-128..+127)
JR C,$+2     12/7   2           38 XX           If Carry = 1
JR NC,$+2    12/7   2           30 XX           If Carry = 0
JR Z,$+2     12/7   2           28 XX           If Zero = 1
JR NZ,$+2    12/7   2           20 XX           If Zero = 0
─────────────────────────────────────────────────────────────────────────────────
LD I,A          9   2   ------  ED 47           I = A (interrupt vector page register)
LD R,A          9   2           ED 4F           R = A (memory refresh register)
LD A,I          9   2   **0*0-  ED 57           A = I; S,Z set from I; H,N cleared;
                                                P/V = IFF2 (current interrupt enable state)
LD A,R          9   2   **0*0-  ED 5F           A = R; same flag behaviour as LD A,I
─────────────────────────────────────────────────────────────────────────────────
LD A,r          4   1   ------  78+rb           A = r
LD A,N          7   2           3E XX
LD A,(BC)       7   1           0A
LD A,(DE)       7   1           1A
LD A,(HL)       7   1           7E
LD A,(IX+N)    19   3           DD 7E XX
LD A,(IY+N)    19   3           FD 7E XX
LD A,(NN)      13   3           3A XX XX
LD B,r          4   1           40+rb
LD B,N          7   2           06 XX
LD B,(HL)       7   1           46
LD B,(IX+N)    19   3           DD 46 XX
LD B,(IY+N)    19   3           FD 46 XX
LD C,r          4   1           48+rb
LD C,N          7   2           0E XX
LD C,(HL)       7   1           4E
LD C,(IX+N)    19   3           DD 4E XX
LD C,(IY+N)    19   3           FD 4E XX
LD D,r          4   1           50+rb
LD D,N          7   2           16 XX
LD D,(HL)       7   1           56
LD D,(IX+N)    19   3           DD 56 XX
LD D,(IY+N)    19   3           FD 56 XX
LD E,r          4   1           58+rb
LD E,N          7   2           1E XX
LD E,(HL)       7   1           5E
LD E,(IX+N)    19   3           DD 5E XX
LD E,(IY+N)    19   3           FD 5E XX
LD H,r          4   1           60+rb
LD H,N          7   2           26 XX
LD H,(HL)       7   1           66
LD H,(IX+N)    19   3           DD 66 XX
LD H,(IY+N)    19   3           FD 66 XX
LD L,r          4   1           68+rb
LD L,N          7   2           2E XX
LD L,(HL)       7   1           6E
LD L,(IX+N)    19   3           DD 6E XX
LD L,(IY+N)    19   3           FD 6E XX
LD BC,NN       10   3   ------  01 XX XX
LD BC,(NN)     20   4           ED 4B XX XX
LD DE,NN       10   3           11 XX XX
LD DE,(NN)     20   4           ED 5B XX XX
LD HL,NN       10   3           21 XX XX
LD HL,(NN)     20   3           2A XX XX
LD SP,NN       10   3           31 XX XX
LD SP,(NN)     20   4           ED 7B XX XX
LD SP,HL        6   1           F9
LD SP,IX       10   2           DD F9
LD SP,IY       10   2           FD F9
LD IX,NN       14   4           DD 21 XX XX
LD IX,(NN)     20   4           DD 2A XX XX
LD IY,NN       14   4           FD 21 XX XX
LD IY,(NN)     20   4           FD 2A XX XX
LD (HL),r       7   1   ------  70+rb
LD (HL),N      10   2           36 XX
LD (BC),A       7   1           02
LD (DE),A       7   1           12
LD (NN),A      13   3           32 XX XX
LD (NN),BC     20   4           ED 43 XX XX
LD (NN),DE     20   4           ED 53 XX XX
LD (NN),HL     16   3           22 XX XX
LD (NN),SP     20   4           ED 73 XX XX
LD (NN),IX     20   4           DD 22 XX XX
LD (NN),IY     20   4           FD 22 XX XX
LD (IX+N),r    19   3           DD 70+rb XX
LD (IX+N),N    19   4           DD 36 XX XX
LD (IY+N),r    19   3           FD 70+rb XX
LD (IY+N),N    19   4           FD 36 XX XX
─────────────────────────────────────────────────────────────────────────────────
LDD            16   2   --0*0-  ED A8           (DE)=(HL); HL=HL-1; DE=DE-1; BC=BC-1
LDDR         21/1   2   --000-  ED B8           LDD until BC=0
LDI            16   2   --0*0-  ED A0           (DE)=(HL); HL=HL+1; DE=DE+1; BC=BC-1
LDIR         21/1   2   --000-  ED B0           LDI until BC=0
─────────────────────────────────────────────────────────────────────────────────
NEG             8   2   ***V1*  ED 44           A = 0 - A (two's complement negate)
─────────────────────────────────────────────────────────────────────────────────
NOP             4   1   ------  00              No operation
─────────────────────────────────────────────────────────────────────────────────
OR r            4   1   ***P00  B0+rb           A = A | s
OR N            7   2           F6 XX
OR (HL)         7   1           B6
OR (IX+N)      19   3           DD B6 XX
OR (IY+N)      19   3           FD B6 XX
─────────────────────────────────────────────────────────────────────────────────
OUT (N),A      11   2   ------  D3 XX           port(A:N) = A; upper address byte = A
OUT (C),A      12   2   ------  ED 79           port(BC) = r; 16-bit port address
OUT (C),B      12   2           ED 41
OUT (C),C      12   2           ED 49
OUT (C),D      12   2           ED 51
OUT (C),E      12   2           ED 59
OUT (C),H      12   2           ED 61
OUT (C),L      12   2           ED 69
OUT (C),0      12   2           ED 71           Output 0 to port(BC) (undocumented)
─────────────────────────────────────────────────────────────────────────────────
POP AF         10   1   ------  F1              qq = (SP); SP = SP + 2
POP BC         10   1           C1
POP DE         10   1           D1
POP HL         10   1           E1
POP IX         14   2           DD E1           xx = (SP)
POP IY         14   2           FD E1
PUSH AF        11   1   ------  F5              SP = SP - 2; (SP) = qq
PUSH BC        11   1           C5
PUSH DE        11   1           D5
PUSH HL        11   1           E5
PUSH IX        15   2           DD E5
PUSH IY        15   2           FD E5
─────────────────────────────────────────────────────────────────────────────────
RES b,r         8   2   ------  CB 80+8*b+rb   Reset bit b in m
RES b,(HL)     15   2           CB 86+8*b
RES b,(IX+N)   23   4           DD CB XX 86+8*b
RES b,(IY+N)   23   4           FD CB XX 86+8*b
─────────────────────────────────────────────────────────────────────────────────
RET            10   1   ------  C9              PC = (SP); SP = SP + 2
RET C        11/5   1           D8              If Carry = 1
RET NC       11/5   1           D0              If Carry = 0
RET M        11/5   1           F8              If Sign = 1
RET P        11/5   1           F0              If Sign = 0
RET Z        11/5   1           C8              If Zero = 1
RET NZ       11/5   1           C0              If Zero = 0
RET PE       11/5   1           E8              If Parity = 1
RET PO       11/5   1           E0              If Parity = 0
─────────────────────────────────────────────────────────────────────────────────
RETI           14   2   ------  ED 4D           Return from maskable interrupt; IFF1=IFF2
RETN           14   2           ED 45           Return from NMI; IFF1=IFF2
─────────────────────────────────────────────────────────────────────────────────
RLA             4   1   --0-0*  17              A = {CY,A} rotated left; A0 <- CY <- A7
RL r            8   2   **0P0*  CB 10+rb        m = {CY,m} rotated left
RL (HL)        15   2           CB 16
RL (IX+N)      23   4           DD CB XX 16
RL (IY+N)      23   4           FD CB XX 16
RLCA            4   1   --0-0*  07              A rotated left circular; A0 <- A7 -> CY
RLC r           8   2   **0P0*  CB 00+rb        m rotated left circular
RLC (HL)       15   2           CB 06
RLC (IX+N)     23   4           DD CB XX 06
RLC (IY+N)     23   4           FD CB XX 06
RLD            18   2   **0P0-  ED 6F           {A[3:0],(HL)[7:0]} rotated left 4 bits
RRA             4   1   --0-0*  1F              A = {CY,A} rotated right; A7 <- CY <- A0
RR r            8   2   **0P0*  CB 18+rb        m = {CY,m} rotated right
RR (HL)        15   2           CB 1E
RR (IX+N)      23   4           DD CB XX 1E
RR (IY+N)      23   4           FD CB XX 1E
RRCA            4   1   --0-0*  0F              A rotated right circular; A7 <- A0 -> CY
RRC r           8   2   **0P0*  CB 08+rb        m rotated right circular
RRC (HL)       15   2           CB 0E
RRC (IX+N)     23   4           DD CB XX 0E
RRC (IY+N)     23   4           FD CB XX 0E
RRD            18   2   **0P0-  ED 67           {A[3:0],(HL)[7:0]} rotated right 4 bits
─────────────────────────────────────────────────────────────────────────────────
RST 00H        11   1   ------  C7              Call $0000 (TS 2068: power-on reset)
RST 08H        11   1           CF              Call $0008 (TS 2068: ERROR-1 / RST 8)
RST 10H        11   1           D7              Call $0010 (TS 2068: PRINT-A-1)
RST 18H        11   1           DF              Call $0018 (TS 2068: GET-CHAR)
RST 20H        11   1           E7              Call $0020 (TS 2068: NEXT-CHAR)
RST 28H        11   1           EF              Call $0028 (TS 2068: FP-CALC)
RST 30H        11   1           F7              Call $0030 (TS 2068: BC-SPACES)
RST 38H        11   1           FF              Call $0038 (TS 2068: MASK-INT / interrupt)
─────────────────────────────────────────────────────────────────────────────────
SBC A,r         4   1   ***V1*  98+rb           A = A - s - CY
SBC A,N         7   2           DE XX
SBC A,(HL)      7   1           9E
SBC A,(IX+N)   19   3           DD 9E XX
SBC A,(IY+N)   19   3           FD 9E XX
SBC HL,BC      15   2   **?V1*  ED 42           HL = HL - ss - CY
SBC HL,DE      15   2           ED 52
SBC HL,HL      15   2           ED 62
SBC HL,SP      15   2           ED 72
─────────────────────────────────────────────────────────────────────────────────
SCF             4   1   --0-01  37              Set Carry Flag; CY = 1
─────────────────────────────────────────────────────────────────────────────────
SET b,r         8   2   ------  CB C0+8*b+rb   Set bit b in m
SET b,(HL)     15   2           CB C6+8*b
SET b,(IX+N)   23   4           DD CB XX C6+8*b
SET b,(IY+N)   23   4           FD CB XX C6+8*b
─────────────────────────────────────────────────────────────────────────────────
SLA r           8   2   **0P0*  CB 20+rb        Shift left arithmetic; CY <- m7; m0 <- 0
SLA (HL)       15   2           CB 26
SLA (IX+N)     23   4           DD CB XX 26
SLA (IY+N)     23   4           FD CB XX 26
SRA r           8   2   **0P0*  CB 28+rb        Shift right arithmetic; m7 preserved; CY <- m0
SRA (HL)       15   2           CB 2E
SRA (IX+N)     23   4           DD CB XX 2E
SRA (IY+N)     23   4           FD CB XX 2E
SLL r           8   2   **0P0*  CB 30+rb        Shift left logical; CY <- m7; m0 <- 1
SLL (HL)       15   2           CB 36           (UNDOCUMENTED — use .db $CB,$xx to assemble)
SLL (IX+N)     23   4           DD CB XX 36
SLL (IY+N)     23   4           FD CB XX 36
SRL r           8   2   **0P0*  CB 38+rb        Shift right logical; m7 <- 0; CY <- m0
SRL (HL)       15   2           CB 3E
SRL (IX+N)     23   4           DD CB XX 3E
SRL (IY+N)     23   4           FD CB XX 3E
─────────────────────────────────────────────────────────────────────────────────
SUB r           4   1   ***V1*  90+rb           A = A - s
SUB N           7   2           D6 XX
SUB (HL)        7   1           96
SUB (IX+N)     19   3           DD 96 XX
SUB (IY+N)     19   3           FD 96 XX
─────────────────────────────────────────────────────────────────────────────────
XOR r           4   1   ***P00  A8+rb           A = A ^ s
XOR N           7   2           EE XX
XOR (HL)        7   1           AE
XOR (IX+N)     19   3           DD AE XX
XOR (IY+N)     19   3           FD AE XX
─────────────────────────────────────────────────────────────────────────────────
```

---

## Opcode Prefix System

The Z80 uses four of the 256 root opcodes as prefixes to extend the instruction set:

| Prefix | Effect |
|--------|--------|
| `CB` | Enables bit manipulation and rotate/shift instructions |
| `ED` | Enables extended instructions (block ops, 16-bit I/O, etc.) |
| `DD` | Overrides: HL becomes IX; `(HL)` becomes `(IX+d)` |
| `FD` | Overrides: HL becomes IY; `(HL)` becomes `(IY+d)` |

`DD` and `FD` can be combined with `CB` to give DDCB and FDCB forms, which apply
the IX or IY displacement to CB instructions. The 4-byte encoding for these is:
`prefix, CB, displacement, opcode` — note the displacement comes *before* the opcode byte.

---

## Undocumented Instructions

These work on all real Z80 hardware (including the TS 2068) but were not in
the original Zilog documentation. Most assemblers require explicit `.db` bytes
or a special syntax to generate them.

### IXH, IXL, IYH, IYL — Index Register Half-Bytes

The DD/FD prefix that redirects HL operations to IX/IY also exposes the high
and low bytes of IX and IY individually. Any instruction that normally operates
on H or L can be redirected to IXH, IXL, IYH, or IYL using a DD or FD prefix.

**Available IXH/IXL operations (replace DD with FD for IYH/IYL):**

```
Mnemonic       Clk  Sz  Opcode      Notes
─────────────────────────────────────────────────────
LD IXH,N        11   3  DD 26 XX    IXH = immediate byte
LD IXL,N        11   3  DD 2E XX    IXL = immediate byte
LD IXH,r         8   2  DD 60+rb    IXH = register (r ≠ H or L)
LD IXL,r         8   2  DD 68+rb    IXL = register (r ≠ H or L)
LD r,IXH         8   2  DD 44+rb    register = IXH (r ≠ H or L)
LD r,IXL         8   2  DD 4C+rb    register = IXL (r ≠ H or L)
LD IXH,IXH       8   2  DD 64       IXH = IXH
LD IXH,IXL       8   2  DD 65       IXH = IXL
LD IXL,IXH       8   2  DD 6C       IXL = IXH
LD IXL,IXL       8   2  DD 6D       IXL = IXL
INC IXH          8   2  DD 24       IXH = IXH + 1
INC IXL          8   2  DD 2C       IXL = IXL + 1
DEC IXH          8   2  DD 25       IXH = IXH - 1
DEC IXL          8   2  DD 2D       IXL = IXL - 1
ADD A,IXH        8   2  DD 84       A = A + IXH
ADD A,IXL        8   2  DD 85       A = A + IXL
ADC A,IXH        8   2  DD 8C       A = A + IXH + CY
ADC A,IXL        8   2  DD 8D       A = A + IXL + CY
SUB IXH          8   2  DD 94       A = A - IXH
SUB IXL          8   2  DD 95       A = A - IXL
SBC A,IXH        8   2  DD 9C       A = A - IXH - CY
SBC A,IXL        8   2  DD 9D       A = A - IXL - CY
AND IXH          8   2  DD A4       A = A & IXH
AND IXL          8   2  DD A5       A = A & IXL
XOR IXH          8   2  DD AC       A = A ^ IXH
XOR IXL          8   2  DD AD       A = A ^ IXL
OR IXH           8   2  DD B4       A = A | IXH
OR IXL           8   2  DD B5       A = A | IXL
CP IXH           8   2  DD BC       Compare A - IXH
CP IXL           8   2  DD BD       Compare A - IXL
─────────────────────────────────────────────────────
```

**Restrictions:** You cannot mix the halves of different index registers in
one instruction. `LD IXH,IYH` is not encodable. Also, `LD H,(IX+d)` and
`LD IXH,(IX+d)` are *not* the same instruction — `DD 66 XX` reads from
`(IX+d)` into H, not into IXH.

**Practical use on TS 2068:** Since IY is reserved, IYH/IYL are available as
scratch registers but be cautious — modifying IYH or IYL individually is safe,
but any code that restores IY as a 16-bit value must restore it to $5C3A.

**Speed advantage example:**

```asm
; Load DE into IX — official method: 25 T-states, 2 bytes of code
PUSH DE       ; 11 T-states
POP IX        ; 14 T-states

; Load DE into IX — half-register method: 16 T-states, 4 bytes of code
LD IXH,D      ; 8 T-states  (DD 62)
LD IXL,E      ; 8 T-states  (DD 6B)
```

### SLL (Shift Left Logical, sets bit 0)

`SLL r` (CB 30+rb) shifts left and sets bit 0 to 1 (unlike SLA which clears it).
Useful for multiplication by 2 with a guaranteed set low bit. Flags: S Z - P 0 C.
Most assemblers don't recognise the mnemonic; use `.db $CB, $30+rb`.

### IN (C) / OUT (C),0

`IN (C)` (ED 70) reads port BC and sets flags without storing the result.
`OUT (C),0` (ED 71) outputs 0 to port BC.

---

## Important Instruction Notes

### LD A,I and LD A,R — the only flag-setting LD instructions

```
LD A,I  (ED 57)  and  LD A,R  (ED 5F)
```

These are the only LD instructions that affect flags. After execution:
- **S** — set if I (or R) is negative (bit 7 set)
- **Z** — set if I (or R) is zero
- **H** — always cleared
- **P/V** — set to the value of **IFF2** (the current maskable interrupt enable state)
- **N** — always cleared
- **C** — unaffected

The P/V = IFF2 copy is the standard way to test whether interrupts are enabled
without modifying any other state.

### IN r,(C) sets flags; IN A,(N) does not

`IN A,(N)` (DB XX) loads port data into A but sets no flags.
`IN r,(C)` (ED 4x/78) loads port data into a register AND sets S, Z, H, P, N flags
based on the value read. Useful for testing port state without a separate CP or AND.

### RETN and RETI are functionally identical

Both restore IFF1 from IFF2 and pop the return address from the stack.
The distinction matters only to Z80-compatible interrupt controller chips that
watch the data bus for the RETI opcode (ED 4D) during M1 fetch cycles.
On the TS 2068 there are no such external devices, so RETN and RETI behave
identically in practice.

### Block instructions — P/V flag as loop indicator

For LDI / LDD and CPI / CPD, the **P/V flag is set if BC−1 ≠ 0** after
the operation. This allows loop control without using the repeat forms:

```asm
; Copy BC bytes from (HL) to (DE), stopping early if a match is found
loop:
    LDI              ; copy one byte; P/V set if BC-1 ≠ 0
    JP PO, done      ; P/V clear means BC reached 0
    ; (add early-exit test here)
    JR loop
done:
```

### JP (HL) — mnemonic is misleading

`JP (HL)` does **not** jump to the address stored at the memory location
pointed to by HL. It jumps directly to the *value* of HL. The parentheses
in the mnemonic are a Zilog convention inconsistency. Same applies to
`JP (IX)` and `JP (IY)`.

### JR vs JP — when to use which

`JR` (2 bytes, signed 8-bit offset) is smaller but limited to ±127 bytes from
the instruction following the JR. It is also 3 T-states faster than JP when
the branch is *not* taken. Use `JP` when the target may be far, or when you
need conditions beyond NZ/Z/NC/C (JR only supports those four).

### OUT (N),A port addressing

`OUT (N),A` places the immediate byte N on the low address bus and the
*current value of A* on the high address bus. So the actual 16-bit port
address is `(A << 8) | N`. This differs from `OUT (C),r` which puts the
full BC register pair on the address bus.

For TS 2068 I/O ports, use the correct form:
- `OUT ($FE),A` — border / speaker / MIC (standard ULA port, high byte = A)
- `OUT (C),A` with BC = $xxFF — DECR register at port $FF
- `OUT (C),A` with BC = $xxF4 — HSR (horizontal select) at port $F4
- `OUT (C),A` with BC = $xxF5 / $F6 — AY-3-8910 register/data

---

## Addressing Mode Summary

| Mode | Example | Description |
|------|---------|-------------|
| Immediate | `LD A,n` | Operand is the next byte |
| Immediate extended | `LD HL,nn` | Operand is the next two bytes |
| Relative | `JR e` | PC = PC + 2 + signed offset byte |
| Extended | `LD A,(nn)` | Operand at absolute address nn |
| Indexed | `LD A,(IX+d)` | Operand at IX (or IY) + signed displacement |
| Register | `LD A,B` | Operand is a register |
| Register indirect | `LD A,(HL)` | Operand at address in register pair |
| Implied | `RLA` | Operand implied by instruction |
| Bit | `BIT b,r` | Bit number encoded in opcode |
| Modified page zero | `RST p` | Call to fixed address (p × 8) |

---

## Register Quick Reference

| Register | Width | Notes |
|----------|-------|-------|
| A | 8-bit | Accumulator; destination for most arithmetic |
| F | 8-bit | Flags (S Z - H - P/V N C); not directly addressable |
| B, C, D, E, H, L | 8-bit | General purpose |
| BC, DE, HL | 16-bit | Register pairs; HL is the default pointer |
| AF, BC, DE, HL | 16-bit | Alternate set (exchanged with EXX / EX AF,AF') |
| IX, IY | 16-bit | Index registers; **IY reserved on TS 2068** |
| SP | 16-bit | Stack pointer; grows downward |
| PC | 16-bit | Program counter; not directly accessible |
| I | 8-bit | Interrupt vector page (high byte for IM 2 table) |
| R | 8-bit | Memory refresh counter; lower 7 bits auto-increment |