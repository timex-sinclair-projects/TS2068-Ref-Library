# TS 2068 Quick Reference Cheat Sheet

---

## Key Addresses at a Glance

```
$0000  HOME ROM start / RST 0 (RESET)
$0008  RST 8  — error handler (byte after call = error code−1)
$0010  RST 10 — output char in A to current channel
$0018  RST 18 — GET-CHAR: fetch current char → A
$0020  RST 20 — NEXT-CHAR: advance CH_ADD, fetch → A
$0028  RST 28 — enter floating point calculator
$0030  RST 30 — create BC workspace bytes
$0038  RST 38 — maskable interrupt (clock + keyboard)
$0013  ROM version byte ($FF = v1)

$3D00  Character set (CHRSET) — 96 chars × 8 bytes

$4000  Primary display file — pixel data start
$5800  Primary display file — attribute data start

$5C00  System variables start (KSTATE)
$5C3A  ERR_NR  ← IY points here permanently
$5C3B  FLAGS
$5C41  MODE (cursor: 0=K/L, 1=F, 2=G)
$5C48  BORDCR (border color × 8)
$5C53  PROG (start of BASIC program)
$5C78  FRAMES (60 Hz counter)
$5C7B  UDG (address of user graphics)
$5CB2  RAMTOP
$5CBC  SYSCON pointer ($5EEA default)
$5CC2  VIDMOD (0=normal, non-0=2nd display active)
$5EEA  SYSCON table

$6000  Function dispatcher code (VIDMOD=0)
$6200  Dispatcher entry point (VIDMOD=0)  ← CALL HERE
$F7C0  Function dispatcher code (VIDMOD≠0)
$F9C0  Dispatcher entry point (VIDMOD≠0)  ← CALL HERE
```

---

## Calling the Dispatcher (most common usage)

```asm
; Call service with no parameters
    LD   DE, 0
    PUSH DE          ; PRM_OUT = 0
    PUSH DE          ; PRM_IN  = 0
    LD   DE, SVC     ; service number
    PUSH DE
    LD   A, (VIDMOD)
    OR   A
    JP   Z,  $6200
    JP   $F9C0

; Call service with JP (no return) — only push SVC | $8000
    LD   DE, SVC | $8000
    PUSH DE
    JP   $6200       ; (or $F9C0)
```

---

## Most-Used Dispatcher Services

```
$1D  SENDTV   A=char → output to screen/printer
$1E  SETAT    B=row(0-23), C=col(0-31) → set print position
$22  CLS      clear primary screen
$21  CLLHS    clear lower half screen
$29  SELECT   A=stream → select I/O stream
$87  WRCH     A=char → write to current channel
$85  RDCH     wait for char → A from current channel
$8D  K_CLS    CLS command (CLS + CLLHS)
$27  INIT     init system (DE=top of RAM, A=0 cold / $FF NEW)
$6B  STK_A    push byte in A onto calc stack as float
$6C  STK_BC   push word in BC onto calc stack as float
$6F  FP2A     pop calc stack float → A
$6E  FP2BC    pop calc stack float → BC
```

---

## I/O Ports Quick Reference

```
$FE  W  Border: bits 2-0=color, 3=MIC, 4=speaker
$FE  R  Keyboard: bits 4-0=row (0=pressed); B=row select
$FF  W  DECR: bit 0=2nd display, 2=64col, 7=EXROM
$F4  W  HSR: bit N=0→chunk N from HOME, 1→from DOCK
$F5  W  AY register select (SOUND)
$F6  W  AY data write / R = AY data read
```

---

## DECR Video Mode Bits (port $FF)

```
$00  Standard (Spectrum-compatible)
$01  Second display file enabled
$02  Ultra-high-resolution color
$04  64-column mode
$80  EXROM enabled (keep this set during normal operation)
```

Combine by OR: e.g., $81 = EXROM + second display file.

---

## Attribute Byte Format

```
 7     6     5  4  3   2  1  0
FLASH BRIGHT P2 P1 P0  I2 I1 I0

Colors: 0=Black 1=Blue 2=Red 3=Magenta
        4=Green 5=Cyan 6=Yellow 7=White
```

---

## Display Address Formulas

```asm
; Pixel address for column X (0-255), row Y (0-191):
pixel = $4000 | ((Y & $C0) << 5) | ((Y & $07) << 8) | ((Y & $38) << 2) | (X >> 3)
bit   = $80 >> (X & 7)        ; bit 7 = leftmost pixel

; Attribute address for char col X (0-31), char row Y (0-23):
attr  = $5800 + (Y * 32) + X
```

---

## Report Codes (ERR_NR = code−1)

```
0/OK  1/NEXT-FOR  2/Var-not-found  3/Subscript   4/Out-of-memory
5/Out-of-screen  6/Num-too-big   7/RETURN-GOSUB  8/End-of-file
9/STOP  A/Invalid-arg  B/Int-range  C/Nonsense  D/BREAK-CONT
E/Out-of-DATA  F/Bad-filename  G/No-room  H/STOP-INPUT
I/FOR-NEXT  J/Bad-IO  K/Bad-color  L/BREAK  M/RAMTOP
N/Statement-lost  O/Bad-stream  P/FN-no-DEF  Q/Param-error
R/Tape-error  S/Missing-LROS
```

---

## System Variable Pocket Guide

```
ERRSP  $5C3D  Error stack pointer (default $61FC)
NEWPPC $5C42  GOTO target line (NSPPC=$5C44 = statement)
PPC    $5C45  Current line number being run
BORDCR $5C48  Border color × 8
VARS   $5C4B  Variables area address
PROG   $5C53  BASIC program address
ELINE  $5C59  Edit line address
CH_ADD $5C5D  Next char to interpret
SEED   $5C76  RND seed
FRAMES $5C78  Timer (60 Hz, 3 bytes)
UDG    $5C7B  User graphics address
ATTRP  $5C8D  Current permanent attributes
ATTRT  $5C8F  Current temporary attributes
PFLAG  $5C91  OVER/INVERSE/etc. flags
RAMTOP $5CB2  Top of BASIC RAM
VIDMOD $5CC2  Video mode (0=normal)
MSTBOT $5CC0  Machine stack base
```

---

## IY Pocket Guide (IY = $5C3A = ERR_NR)

```
IY+$00  ERR_NR    IY+$01  FLAGS     IY+$02  TVFLAG
IY+$07  MODE      IY+$0E  BORDCR    IY+$2D  BREG
IY+$30  FLAGS2    IY+$37  FLAGX     IY+$40  FRAMES
IY+$52  SCRCT     IY+$57  PFLAG     IY+$7C  ERRLN
```

---

## Key FLAGS Bits (IY+$01)

```
Bit 1  PR      Output to printer
Bit 4  TOKEN   Token mode (TS 2068 only)
Bit 5  KEYHIT  Key has been pressed
Bit 6  NUM     Result is numeric
Bit 7  INTPT   Interpret (not syntax-check)
```

---

## Keyboard Half-Row Table (B value → IN A,($FE))

```
$FE: CAPS Z X C V    $FD: A S D F G
$FB: Q W E R T       $F7: 1 2 3 4 5
$EF: 0 9 8 7 6       $DF: P O I U Y
$BF: ENTER L K J H   $7F: SPACE SYM M N B
```

Bit 0 = leftmost listed key (rightmost on the physical keyboard). Zero bit = key
pressed. BREAK = CAPS-SHIFT ($FE b0) + SPACE ($7F b0). The OS keyboard scan
starts with BC = $FEFE.

---

## BASIC Program Line in Memory

```
[LINE_HI][LINE_LO][LEN_LO][LEN_HI][...tokens and ASCII...][$0D]
```

Embedded number: `$0E` followed by 5-byte floating point value.

---

## Variable Area Markers

```
$40–$5F  String variable (A$=$40 ... Z$=$5F)
$60–$79  Numeric variable (A=$60 ... Z=$79)
$80      End of variables
$80–$9F  Numeric array (A=$80 ... T=$93 approx)
$C0–$DF  String array
$E0–$FF  FOR/NEXT control variable
```