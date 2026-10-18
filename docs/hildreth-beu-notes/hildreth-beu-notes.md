# Lon Hildreth — BEU code development notes

Transcription of *BEU Code Development — Lon Hildreth* (100 scanned pages), working notes on TS2068 ROM code for the Timex/Sinclair 2060 Bus Expansion Unit. One section per PDF page, in scan order. **Read `README.md` first** for what the markup means and what has been checked. This is a transcription, not a correction: the code is as Hildreth left it.

---

## PDF page 1 — RENUMBER_BANKS (1-1)

*Paper: tan/yellow sheet, faint rules, torn top edge; pencil, with corrections in black ink.*

```asm
L0:     XOR A
        LD (MAX-BANK), A

L1:     LD HL, (SYSCON)
        LD DE, 12
        ADD HL,DE
L2:     LD A, (HL)          ; check for end of table
        CP 80h
        JR Z, LX
        INC HL              ; check for bank # w/ bit 7 set  [struck: >10]
        LD A, (HL)
        BIT 7, A            ; [struck: CP 11]
        JR NZ, L3           ; jump if bank # w/ bit 7 set  [struck: >10]  [was NC]
        LD DE, 23
        ADD HL,DE
        JR L2               ; check next record
L3:     LD (5FE8h), HL      ; save bank# addr
        ; [struck: illegible line, scribbled out; arrow from it to the block below]
        DEC HL              ; [inserted from margin]
        LD A, (HL)
        CP 2                ; is it RAM?
        JR NZ, L33          ; [struck: L35?]
        ; [struck: LD A, 255]
        ; [struck: LD [illegible]]
        LD DE, 23           ; [struck: illegible token at left of this line]
        ADD HL,DE
        LD A, 255           ; RAM int pri = 255
        JR L37
L33:
        LD DE, 23           ; [struck label: L35?]  [struck: 20]
        ADD HL,DE
        LD A, (HL)
L37:    LD (5FEAh), A       ; save int pri
L4:     INC HL
        LD A, (HL)          ; end of table?
        CP 80h
        JR Z, L6
        INC HL
        LD A, (HL)          ; check bank #
        CP 11   BIT 7,A
        JR NZ, L5           ; jump if bank # w/ bit 7 set  [struck: >10]  [was NC]
```

> *Transcriber's note:* In `LD (5FE8h), HL` at L3 the "E8h" is heavily retraced in ink over earlier writing; the earlier value is illegible. The block `DEC HL` … `JR L37` is written in a right-hand column; an arrow runs to it from a scribbled-out line just below L3. Its last line, `JR L37`, sits to the right of the `; save int pri` comment on the L37 line. "L33:" is written on its own line above the struck-out original label of the `LD DE, 23` line. In both `JR NZ` lines the Z is written over an earlier C. In the comments, "w/" replaces a struck ">10". On the last `CP 11` line, `CP 11` is **not** struck; `BIT 7,A` is written after it on the same line. A few dots (":") sit between the two columns next to `ADD HL,DE`/`LD A,(HL)`. Faint typed marks at the upper right are show-through from the reverse of the sheet and are not transcribed.

## PDF page 2 — SELECT

*Paper: tan/yellow sheet, faint rules, torn top edge; pencil, with some lines in black ink.*

**SELECT** — annotation written small above and to the right: "3K[?] bytes"

```asm
LST2:   CP 80H              ; Test for intelligent device  (D already in A)
        JR NC, SEL2         ; [margin: 2]
        DEC DE
        LD HL, (CHANS-)
        ADD HL, DE
SEL-HL: :   LD (CURCBN),0
JP_HL:  JP (HL)
SEL2:   LD HL, (SYSCON)     ; [margin: 3.]
        ; [struck: LD A, D]
        SUB 80H             ; subtract off intelligent marker
        LD D, A
        ADD HL, DE          ; HL points to selected channel bank# in SYSCON
        LD (CURCHL), HL     ; [margin: 3]
        LD A, (HL)          ; [inserted from margin]  [margin: 4]
        LD (CURCBN), A
        RES RETPOS (IY-Y+FLAGS2)
        INC HL
        INC HL
        INC HL
        INC HL
        INC HL
        INC HL              ; HL points to SELECT addr  [struck: device spec]
        ; [struck: LD C, (HL)]
        ; [struck: LD HL, (BEUSEL)]      [margin: 3]
        ; [struck: CALL SEARCH2]         [margin: 3]
        ; [struck: RET NC]
        LD B, (CURCBN)      ; B = bank #
        LD C, 00061000B
        ; [struck: INC HL]
        LD D, (HL)
        INC HL
        LD E, (HL)
        LD H, D
        LD L, E,
        CALL CALL-BANK      ; [margin: 3]
        RET
```

> *Transcriber's note:* The small numerals in the left margin (2, 3., 3, 4, 3, 3, 3) are Lon's; they are recorded as `[margin: n]` on the line they sit beside. "3K[?]": a faint "3", then a heavily overwritten mark that may be a "K", then "bytes". On the SEL-HL line, `LD (CURCBN),0` is written small between two vertical dots after the label. `LD A,(HL)` / `LD (CURCBN),A` are written in the left margin, bracketed, with an arrow pointing between `LD (CURCHL), HL` and `RES RETPOS`. The four lines `LD C,(HL)` through `RET NC` are crossed out with a large X. A vertical bracket runs down the left of `LD B,(CURCBN)` … `CALL CALL-BANK`. In `LD C, 00061000B` the fourth digit reads as a 6 [?]; the string is transcribed as written. A short pencil note in the left margin beside the first `INC HL` after `LD D,(HL)` is struck through and illegible. Faint marks at the right and bottom are show-through.

## PDF page 3 — (1-2)

*Paper: tan/yellow sheet, faint rules; pencil, with corrections in black ink.*

```asm
        LD DE, 23
        ADD HL,DE
        JR L4               ; check next record
L55:    EX DE,HL
        LD BC, 23           ; [struck: 20]
        ADD HL,BC
        LD A, (5FEAh)       ; get saved int pri
        LD[?] B, A
        LD A, (HL)          ; get int pri
        CP B
        JR NC, L4           ; jump if A ≥ B (saved pri is higher or equal)
        LD (5FEAh), A       ; save new int pri
        LD (5FE8h), DE      ; save new bank# addr
[illegible]: JR L4
L6:     LD A, (MAX-BANK)    ; inc MAX_BANK
        INC A
        LD (MAX-BANK), A
        LD (BS_MAX_BANK), A
        ; [struck: LD HL, (5FE8h)]
        ; [struck: LD E, (HL)]          ; saved bank#
        ; [struck: LD D, BNA]
        ; [struck: CALL WRITE_BS_REG]
        ; [struck: LD D, ABN]
        ; [struck: LD E, A]             ; new bank#
        ; [struck: CALL WRITE_BS_REG]
        ; [struck: LD (HL), A]          ; save new bank# in record
        ; [struck: LD (HL), A    ; save bank# in]   [inserted from margin]
        ; [struck: EX DE,HL[?]]
        LD HL, (5FE8h)      ; saved bank# addr
        LD (HL), A          ; save new bank# in record
        ; [struck: [illegible],HL]
        ; XFER A TO 0 of Bank A
        LD E, 255           ; puts bank# at addr 0 of RAM does nothing if ROM
        LD D, A
        PUSH DE
        LD E, (HL)
        LD D, 0
        PUSH DE
        LD E, 0
        PUSH DE
        LD E, 1
        PUSH DE
        PUSH DE
        CALL XFER_BYTES
        JR L1

LX:     ;
        ;
        ; [scribbled out: reset BSCC / LD HL, (SYSCON) / LD DE, 12]
```

Right column (top of page):

```asm
L5:     DEC HL
        LD A, (HL)
        CP 2                ; is it RAM?
        JR Z, L55
        LD DE, 23
        ADD HL, DE
        JR L4               ; check next bank
```

Side note (line to `L6: LD A, (MAX-BANK)`), crossed out with a large X:

```asm
        ; [struck: LD HL, 5FEBH[?]]
        ; [struck: XOR D]
        ; [struck: LD E, A]             ; [struck: get proper offset]
        ; [struck: ADD HL, DE]
```

> *Transcriber's note:* The labels at the left edge are partly cut off by the scan: "L6;" and "LX:" are readable, but the label before the first `JR L4` (below `LD (5FE8h),DE`) is not. In "L55:" and in `JR Z, L55`, the final 5 is retraced in ink. In `JR Z, L55` a letter before the Z is blotted out. The `LD DE, 23` in the right column has "23" in bold ink. `LD[?] B, A` is written "LI B, A" and looks like a malformed D. After that line, faint erased pencil writing is illegible. To the right of `LD (MAX-BANK), A`, "LD (BS-MAX-BANK), A" is also written in pencil with a slash after the A, and the same instruction is written again in ink on the next line as `LD (BS_MAX_BANK), A`. A curved line encloses the struck block (`LD HL,(5FE8h)` … `LD (HL),A`) and connects it to a bracket on the right. That bracket holds the struck `LD (HL),A ; save bank# in`, a struck line (probably `EX DE,HL`), `LD HL,(5FE8h)`, `LD (HL),A`, and a further struck line. Below the bracket come the `; XFER A TO 0 of Bank A` lines, which end in `CALL XFER_BYTES` right after the word "record" of the left-column comment. The bracketed and XFER material is placed where the curve connects it, after the struck lines. The pencil comments `; saved bank#`, `; new bank#` and `; save new bank# in record` are not struck. In `LD E, 1` the E is written over another letter. In the crossed-out side box, `5FEBH` may be 5FE8H. Its E is overwritten, and the last hex digit reads as B.

## PDF page 4

*Paper: tan sheet, faint rules; pencil.*

Upper left, crossed out with a large X and a looping scribble (margin notes included):

```asm
; after line 515[?]
        ; [struck: LD DE, TMXCRT]
        ; [struck: CALL PUTMES]
; after line 698
; [struck: TMXCRT: DEFB 7FH[?]]
        ; [struck: DEFM ' 1983 TIMEX COMPUTER C]
        ; [struck: DEFB 'O'.OR.80H]
```

Written near the upper right of the X: "691[?]". A "6" is in the left margin beside the TMXCRT line.

Upper right corner, written diagonally: `#REXPT=0FFh[?]`

```asm
        ; [struck: DEFM 'IMPROPER AROS/LRO']
        ; [struck: DEFB 'S'.OR.80H]      ; [struck: S- INCOMPAT LANG]
        DEFM 'MISSING LRO'
        DEFB 'S'.OR.80H     ; D
```

Boxed, with "replace 464-468" written diagonally at the left of the box and "to" inside its upper-left corner:

```asm
        LD HL, (MSTBOT)
        DEC HL
        LD SP, HL
        DEC HL
        DEC HL
        LD (ERR-SP), HL
```

```asm
; line 456[?]          ; move bank switch code to RAM
        ; [struck: illegible token]   ; MSTBOT = MSTEND + Stack size
        LD DE, (MSTBOT)
        INC DE
        LD BC, ?            ; (size of b/s code)
        LD HL, BSLABEL[?]
        LDIR
```

Left side, with "line 474[?]" in the margin, struck with a zigzag:

```asm
        ; [struck: CALL BLDSCT]
        ; [struck: CALL BLDCAT]
```

```asm
; after line 516       ; check AROS/LROS to pass control
        LD HL, (SYSCON)     ; check presence of AROS
        LD A, (HL)
        CP 0
        JR Z, CHKLRS
        ; [struck: INC HL]              ; B = language
        LD B, (HL)
        LD                  ; check for LROS  [struck: DE,5 [illegible]]
        ADD HL, DE
        LD A, (HL)
        CP 0
        JR Z, ANOL          ; jump if AROS but no LROS  [struck: illegible characters after ANOL]
        INC HL              ; check if same lang as AROS
        LD A, (HL)
        CP B
        JR NZ, ERRS[?]
```

> *Transcriber's note:* The page is faint pencil and the left edge is cut off in the scan. The margin notes read "after line 515[?]" (the first digit is crossed by the X), "after line 698", "line 456[?]", "line 474[?]", "after line 516", and "75" (left margin under "after line 516", probably cut off). The "after line 516 ; check AROS/LROS to pass control" line is very faint. In the DEFM 'IMPROPER AROS/LRO' and following DEFB lines, a wavy line runs through both and ends in a stroke through "INCOMPAT LANG". `DEFB 7FH[?]`: the first character is partly obscured. The DEFM ' 1983 TIMEX COMPUTER C string has no closing quote as written. In `#REXPT=0FFh[?]` the character after "=" is a slashed zero overwritten by another stroke. `INC DE` is written small on the same line after `LD DE, (MSTBOT)`, set off with a dot. In the struck INC HL line, the strike begins at the C of INC and runs through HL. On the next `LD` line, only the operand "DE,5 …" is struck and no replacement is written. `JR Z, CHKLRS` has a small raised mark between "JR" and "Z". `ERRS[?]`: the final S has a descender, so it may be "$". Several lines of erased or struck pencil writing in the left margin beside `CP 0` … `INC HL` are illegible. Faint marks at the lower right are show-through.

## PDF page 5 — (1-3)

*Paper: green grid (engineering) paper, three-hole punched; black ink.*

```asm
LX:     reset BSCC
        LD D, E0h           ; [inserted from margin]
        LD E, 0
        Call Write-BS-Reg
        ; [struck: LX1: read status]
        ; [struck: if [illegible] end then JR LEND]
        LD HL, (SYSCON)
        LD DE, 13
        ADD HL, DE          ; HL pts to bank # of first exp bank
LX1:
        ; [struck: read status]
        ; [struck: if end then JR LEND]
        LD D, C0h           ; [inserted from margin]
        LD E, E0h
        Call Read-BS-Reg
        BIT 2, E            ; [struck: illegible token before BIT]
        JR NZ, LEND
        LD D, ABN=C0h
        LD E, (HL)
        CALL Write-BS-Reg   ; write correct bank #
        do STEP
        LD D, E0h           ; [inserted from margin]
        LD E, 1
        Call Write-BS-Reg
        ; [struck: JR L[illegible]]
        LD DE, 24
        ADD HL, DE
        JR LX1
LEND:   :
        :
```

> *Transcriber's note:* A line is drawn through "reset BSCC". It continues right to a brace around `LD D,E0h / LD E,0 / Call Write-BS-Reg`, so "reset" reads as struck, but the line may only be the connector. A brace from the struck "read status / if end then JR LEND" (under LX1:) points to `LD D,C0h` … `JR NZ, LEND`. A line from "do STEP" leads to `LD D,E0h / LD E,1 / Call Write-BS-Reg` on the right. In `LD D, C0h` the C is written over an earlier character. In `BIT 2, E` the E is overwritten, and a token before BIT is blotted out. "ABN" is circled. The comment "write correct bank #" ends in an ink blot. The struck token below "do STEP" has a curved line running from it down to the `JR LX1` line. "LEND:" is followed by a column of dots. The rest of the sheet is blank grid.

## PDF page 6 — INIT D16

*Paper: green-tinted lined pad (National 42-381); pencil.*

> *Transcriber's note:* "INIT D16" is written in the header strip above the top rule. The page is divided by a faint vertical pencil line into a left column (address list) and a right column (notes).

Left column:

```text
END?      1A6D
ENDSTT    19DC
EXECUTE   19FF
SLVM      F743
SYNTAX    1948
```

Right column:

```text
in[?] LSM6 in TAPE
     CP
     JR Z, LSM62
  Call Bank  INTPT?
  JR NZ, to the LD inst  LSM61
    Push garbage
    Goto bank ~~[illegible]~~ END?
```

> *Transcriber's note:* "CP" and "JR Z, LSM62" are written small, one above the other, squeezed in above "Call Bank". The struck word before "END?" is blotted out. The last line ("Goto bank … END?") is underlined.

*[Diagram, left: a stack drawn as a column of cells with addresses at the left, and later values written to the right of the column.]*

```text
         +--------+
FF56     |  3E00  |   1303
FF54     |  127B  |  <-- call SYNTAX in LED 24      [cell value struck]
FF52     |  1B76  |   1B76                         [cell value struck]
FF50     |  71D   |   1B52   71D                   [cell value struck; 1B52 struck]
         +--------+   1CDB                         [1CDB struck]
```

> *Transcriber's note:* The "54" in FF54 and the "52" in FF52 are written heavily over earlier digits; the earlier digits can't be read. There is faint, unreadable earlier writing above the struck "1B76" in the cell. The right-hand "1B76" is written heavily over something (it starts with a stroke like "/" or "1"). "1303" sits a little above the FF56 row. In "SYNTAX" the "X" is written over another letter.

*[Diagram, right: a second stack column. Addresses are at the left of the lower cells. The heaviest arrow points at the 412 cell, and a curly brace on the right spans 412 to 64B0. There is a heavy double rule under 64B0.]*

```text
         +--------+
         |  3E00  |                  [written over erased text]
         |  0E15  |  <-- call to SYNTAX in LED 24
61FA     |  19DC  |  <--
61F8     |  412   |  <==             [faint line through "412"; possibly struck]
   6     |  0000  |   }
   4     |  64B0  |   }  (brace 412..64B0)
         |========|
   2     |  1A70  |
         +--------+
```

Bottom notes:

```text
                                                                     stack at[?] ~~before~~[?]
                                                                     call END?
Syntax calls SLVM to check syntax, returning to 127B -->               127B
                                                                       1B76
           jumped to                                                   071D
Then ~~called~~ from EXECUTE  ------------------------------------>   -------
                                                                       1303
        this time END? returns right away                              1B76
            to 71D since not checking syntax                            071D
```

> *Transcriber's note:* Above "call END?", "at" is written over an erased word that looks like "before". The arrow from "returning to 127B" points at the first group of three values (127B / 1B76 / 071D). A curved line under that group separates it from the second group. The arrow from "from EXECUTE" points at 1303.

---

## PDF page 7 — RESSCT

*Paper: green-tinted lined pad (National 42-381); pencil (pseudocode) and ink (code).*

> *Transcriber's note:* The first pseudocode block below is cancelled by a large zigzag scribble drawn across it. A short line above it is blacked out completely.

```text
[blacked out, ~1 word: illegible]
rec↑ := first exp bank rec

while rec↑ <> nil do
  begin
     if rec↑.pres = 1
        then xfer_BYTES (from rec↑.bank to [blot]255
```

```text
do reset cmd
while read status returns bank responding
    XFER_BYTES into TEMP_REC
    ~~[illegible]~~ is it RAM?
    search SCT for device spec
    if found
       then set bit 7 of old bank #    }  for both, assign a new bank # w/
       else LDIR to an open record     }      bit 7 set
            initialize if initializable
    do init_done

at end do renumber banks
```

> *Transcriber's note:* "while read status returns bank responding" is written small, squeezed in under "do reset cmd". A horizontal rule separates the pseudocode from the code below.

> *Transcriber's note:* In the `TEMP_REC EQU` value, the original last digit is blotted out and a replacement is written above it: a small loop with a stem that rises slightly above the loop and runs down into the blot. It reads as either `9` or `d`; it is not the `8` of the `5FE8h` used on PDF pages 1 and 3.

```asm
TEMP_REC  EQU  5FE[9? d?]h              ; [replacement digit written above a blotted-out character]
          LD A, 80h                     ; [inserted from margin]
          LD (MAX-BANK), A
          do reset
          LD D, E0h                     ; [inserted from margin]
          LD E, 0
          Call Write_BS_Reg
GOTOIT:   while read status responding  ; [struck: one letter before "read"]
          LD D, C0h                     ; [inserted from margin]
          LD E, E0h
          Call Read_BS_Reg
          BIT 2, E                      ; [E written over another character]
          JR NZ [NOMORE? WOMORE?]       ; [NZ written small above the line; struck: illegible word before JR]
          LD HL, TEMP-REC
; [struck: CALL [illegible]CHECK[?]]
; [scribbled out, ~3 lines: [illegible] / LD D, A[?] / PUSH DE[?]]
          LD A, (MAX_BANK)
          INC A
          LD (MAX-BANK), A
          CALL ASSIGN
          LD E, 255                     ; read overhead bytes
          LD [D? B?], A                 ; [register letter overwritten]
          PUSH DE
          LD DE, 0
          PUSH DE
          PUSH HL
          LD DE, 22
          PUSH DE
          LD DE, 1
          PUSH DE
          CALL XFER_BYTES
          LD C, (HL)
          LD C, 0                       ; [inserted from margin]
          LD B, 255
          LD HL, SRCHSC                 ; [LD HL written above a struck word: illegible]
          PUSH HL
          PUSH BC
          CALL CALL_BANK
; [struck: CALL SRCHSC]
          JR NC, NEWDEV
; [struck: LD A, (HL)]                  ; HL pts to bank # of found device
; [struck: SET 7, A]
          LD A, (MAX.BANK)              ; [written to the right of the struck SET line, over a struck item: illegible]
          LD (HL), A
          JR [blot]STEPON[?]
NEWDEV:
```

> *Transcriber's note:* Where the margin code goes:
> - **LD A, 80h / LD (MAX-BANK), A.** This pair is written to the right of the struck "CALL …CHECK" line and circled. A line from the circle loops around "responding" and ends in an arrowhead just under "5FE…h". That puts the pair between the EQU line and "do reset".
> - **The Write_BS_Reg block** is written at the right margin. A line from "Call Write_BS_Reg" runs to the end of the "do reset" line.
> - **The Read_BS_Reg block** is also written at the right margin. A line from "JR NZ …" runs to the end of the "while read status responding" line.
> - **The SRCHSC / CALL_BANK block** is written at the right margin. A curved line connects it to the struck "CALL SRCHSC".
> - **"PUSH HL"** in that block is written small, partly under "LD HL".
> - **"do reset" and "while read status responding"** are Lon's own pseudocode lines inside the code listing, written in script.

---

## PDF page 8

*Paper: green grid (5 squares/inch); pencil.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* The marks on this page are scattered smudges and graphite transfer with no letterforms, even after contrast enhancement. The punch holes are on the right edge.

---

## PDF page 9 — init / EXINIT (Lon's page 1, circled)

*Paper: green-tinted lined pad (National 42-381); pencil.*

~~BOOT_SRC~~

init procedes as before until ~~[?]~~CHARS~~[?]~~ ~~is~~ initialized. [RAMTOP & written above "CHARS"; "are" written above the struck "is"]

Then the machine/GOSUB stack ~~[illegible] & GOSUB stack~~[?]
is set up at MSTACK (6200h)

> *Transcriber's note:* "/GOSUB" is written small, under and after "machine". A short hatch mark (////) sits at the left end of the horizontal rule below this paragraph.

~~[illegible, ~3 words]~~

init then continues as before until the © is displayed (The © [msg written above] now includes [small box symbol with a "T"/"I" inside])

Then a routine to bootstrap [the, written above] bank switching code is moved into RAM at 6000h and is called.

  BOOT_SRC selects the home ROM extension, move the B.S. code into RAM at 6200, reselect the home ROM

  init then calls GOTO_EXT to transfer control to EXINIT, the [rest of the, written above] init routine, which resides in the extension ROM.

---

EXINIT

```text
  assigns ~~5FE[?]h~~ [FEA3? EEA3?]h to be the start of SYSCON
  calls BLDSCT
   allocate room for machine lang vars (if any) at DRIVES
                                        moving up channel data
  checks LROS cartridge type entry

     if =1 (LROS present)
        then call GOTO_BANK (bank 0, chunkspec, startaddr)

        else if AROS cartridge type = 2
             then if langtype = 1 (BASIC & machine lang)
                         then ~~if autostart = 1~~
                              ~~then~~ call GOTO_BANK
                                   (255~~[blot]~~, 0, AROS addr)
                          {else call GOTO_BANK[blot]
                                   (255, 0, LED18 addr)
              [mark]   else  if langtype = 2
                             ~~if autostart = 1~~[?]
                             ~~then~~[?] call GOTO_BANK
                                   (0, chunkspec, startaddr)
                       -->  else error - missing LROS
   else ~~call GOTO_BANK~~
      (2)  ~~(255, 0, LED18 addr)~~
```

> *Transcriber's note:* Several parts of this listing need explaining:
> - **SYSCON address.** The struck original is "5FE" followed by one or two digits that are hatched out. The replacement is written above it. Its first character is an E and an F written over each other. Its last character looks like a 3, possibly over another digit, with a loop running down to the struck text.
> - **"calls BLDSCT" lines.** "allocate room…" is written small, squeezed in under "calls BLDSCT". "moving up channel data" is written smaller still, under "(if any) at DRIVES".
> - **Bracket and arrow.** A bracket in front of "else call GOTO_BANK (255, 0, LED18 addr)" runs down past "else if langtype = 2" and ends in an arrow pointing at "else error - missing LROS".
> - **Possibly struck lines.** In the "langtype = 2" branch, the small "if autostart = 1" and "then" are written over each other under "if langtype = 2". Lines cross them in the same way as the clearly struck "if autostart = 1" / "then" in the branch above, but it isn't certain they are struck.
> - **"[mark]"** is a small looped stroke left of "else if langtype = 2", possibly a check mark or an abandoned letter.
> - **Last line.** The circled "2" at the start of the bottom line is written over the struck "(255, 0, LED18 addr)".

**Left margin note** (written at an angle beside the "else call GOTO_BANK" lines):

if RAM load interrupt handler into chunk 0 at 38H

---

## PDF page 10

*Paper: green grid (5 squares/inch).*

*(Blank page.)*

## PDF page 11 — boot highest priority device (2)

*Paper: green-ruled lined pad paper (National); pencil.*

> *Transcriber's note:* Lon's page number "2" is circled in the top right corner.

```text
boot highest priority device

save bank #, priority, and boot addr of highest pri dev,
initially these are 255, 128, LED18 addr for TS2000.

While not end of SYSCON do
    [struck: begin[?]]
        if (presence flag = 1) & (device is bootable)
        then
            if priority < current high pri        (1 is highest pri)
              then replace highs w/ currents

    call GOTO-BANK (highs) to boot device
```

> *Transcriber's note:* A short vertical pencil stroke sits in the left margin beside the "if priority" line. A pencil rule runs across the page below "call GOTO-BANK", separating the next section.

```text
REDO_BANK_NUMS

    MAX_BANK := 0
    [erased, very faint: LD [illegible]]
```

> *Transcriber's note:* The line under `MAX_BANK := 0` has been erased; only traces remain. The first word looks like `LD`. The rest of the page is blank.

## PDF page 12

*Paper: green grid paper; no writing.*

*(Blank page.)*

## PDF page 13 — BLDSCT (3)

*Paper: green-ruled lined pad paper (National); pencil.*

> *Transcriber's note:* Lon's page number "3" is circled in the top right corner. "4 bytes" and "6 bytes" are written small above the word "from" in the two XFER_BYTES lines. "(device)" is written small above the gap between "chunk" and "spec".

```text
BLDSCT

    MAX-BANK := 0
    XFER_BYTES 4 bytes from 0000 of dock bank to LROS entry of SYSCON

    if cartridge type ≠ 1
       then set cartridge type := 0                    [struck before "set": [illegible] (ends in "e")]
            XFER_BYTES 6 bytes from 8000h of dock to AROS entry of SYSCON

            if cartridge type ≠ 2
               then cartridge type := 0

    {fill in expansion bank records}

    write reset cmd to cmd port                        [struck under "cmd port": [illegible, ~2 words]]

    ~~While bit 2 of read status~~
     While read status returns bank responding do      ["s" of "responding" overwritten]
       begin
          MAX-BANK := MAX-BANK + 1
          Write_BS-Reg (ABN, MAX-BANK)
             "         (0Bh, MAX-BANK)          BNA
             "         (0Dh, 0)                 Horiz. Select (HS)
          Fill in bank # entry of SYSCON record
         *Write one byte from ext to exp at 0000
          Read overhead bytes from exp (0000) to SYSCON
          if first byte is different from what wrote
             then (* there is an intelligent device *)
                     check if initealizable
                     if so then call CALL-BANK (init addr)
             else (* test again in case of fluke *)
                     write a different byte from ext to exp
                     read one byte from exp
                     if same
                        then mark presence flag as RAM (= 2)
                             set bit 0 of chunk (device) spec entry
                             test remaining chunks setting
                                bit of chunk spec accordingly
                        else (* it was a fluke & there is an intel dev *)
                             check if initializable
                             if so then call CALL-BANK
          write init_done cmd to cmd port
       end (* while *)
    write 80h to mark end of SYSCON table
```

**Left-margin arithmetic** (beside the last lines, near the bottom hole punch):

```text
  5FEF
- 5A54
  ----
  AB          [the "B" is overwritten or traced over; uncertain]

54F3          [written separately, below the hole punch]
```

## PDF page 14

*Paper: green grid paper; no writing.*

*(Blank page.)*

## PDF page 15 — RESSCT (2)

*Paper: green-ruled lined pad paper (National); ink (black felt-tip).*

> *Transcriber's note:* The title reads "RESSCT" followed by a dash and a circled "2". "i.e. end of SYSCON" is written in the header row, above the right-hand end of the first comment. Lon's connector lines on this page are recorded as notes after the code and not acted on: (a) the `INC HL` … `LDIR`/`RET` lines are enclosed by a left bracket, and "MOVEREC", written in the left margin, has a line to that bracket; (b) a line runs from a mark after `NEWDEV:` down the left margin and ends in an arrowhead pointing at `LD HL, (SYSCON)`; (c) a line runs from a mark after `NOMORE:` down to the start of the "; remove any records…" comment above `CALL BURYDEAD`. `PUSH DE`, `RET` (under `LDIR`) and the `JR NDEV4` above `NDEV3:` are written smaller and squeezed in between lines.

```asm
                                ; i.e. end of SYSCON   [written in header row above this comment]
NEWDEV:                         ; HL pts to pres flag/at entry to NEWDEV
        INC HL
        INC HL
        EX DE, HL               ; move info from [struck: temp] record
        PUSH DE                 ; to an empty record  [struck: at end of table]
        LD HL, TEMP_REC
        LD BC, 22               ; [struck before 22: [illegible, ~2 digits]]
        LDIR
        RET
; [struck: INC [blotted] DE]      ; mark new end of table  (comment not struck)
; [struck: LD A, 80H]
; [struck: LD (DE), A]            ; ("D" overwritten in the struck line)
NDEV4:  POP HL
        DEC HL                  ; [inserted from margin]
        LD A, (MAX-BANK)
        LD (HL), A
        CALL CHIR
STEPON: do step
        LD D, E0h               ; [inserted from margin; line drawn from "do step"]
        LD E, 1
        Call Write-BS-Reg
        JR GOTOIT

NOMORE: CALL RENUM-BANKS
        RET

        ; remove any records of devices no longer there
        CALL BURYDEAD           ; 0out pres flag, bank#, + dev spec

        LD HL, (SYSCON)
        LD DE, 12
NDEV1:  ADD HL,DE               ; HL= pres flag of first record  [struck: entry]
        LD A, (HL)              ; [struck label: NDEV1[?]:]
        CP 0                    ; empty record?
        JR NZ, NDEV2
        CALL MOVEREC
        JR NDEV4                ; [blotted character before "4"]
NDEV2:  CP 80H                  ; end of table?
        JR NZ, NDEV3            ; [blotted character before "3"]
        CALL MOVEREC
        INC DE
        LD A, 80H               ; mark new end of table
        LD (DE), A
        JR NDEV4
NDEV3:
        LD DE, 24               ; check next record
; [struck: ADD HL,DE]
        JR NDEV1
```

> *Transcriber's note:* The two margin blocks above are tied in by lines: `DEC HL` / `LD A, (MAX-BANK)` / `LD (HL), A` is joined by a line to the underline of `POP HL`, and `LD D, E0h` / `LD E, 1` / `Call Write-BS-Reg` is joined by a dash to "do step" (written "EOh" on the page).

Right-hand column (to the right of the `NOMORE:` through `NDEV1:` lines):

```asm
BURYDEAD:
        LD HL, (SYSCON)
        LD DE, 12
BD1:    ADD HL, DE
        LD A, (HL)
        CP 80H
        RET Z
        INC HL
        LD A, (HL)
        BIT 7, A
        JR NZ, BD2
        XOR A
        INC HL                  ; [inserted from margin]
        LD (HL), A
        DEC HL
        LD (HL), A
        DEC HL
        LD (HL), A
BD2:    LD DE, 24
; [struck: ADD HL,DE[?]]
        JR BD1
```

> *Transcriber's note:* The margin lines `INC HL` / `LD (HL), A` / `DEC HL` are written to the right of the BURYDEAD column, inside a brace that spans the `XOR A` and `LD (HL),A` lines. A line drawn from the underline of `XOR A` joins the brace. They are placed after `XOR A` on that basis.

## PDF page 16 — HL

*Paper: green grid; ink.*

*[Diagram: a long horizontal box, "HL" written above its left end. On the left edge, tick marks labelled from the outside: "pres.", "bank#", "dev." Inside the left end: "42" (preceded by a struck mark) and "36" across the top, and "33" lower down. The right end of the box is drawn as a ragged edge, with a V-shaped stroke at the top-right corner and two small marks outside it, "5[?]" and "+[?]".]*

```text
pres. → [struck mark] 42  36
bank# →
dev.  →
        33
```

[struck, illegible: three short blacked-out groups]

| | | |
|---|---|---|
| NOTRAM, SAME ~~STEPOK[?]~~ | : 14 | 14 |
| NOTRAM, DIFF | : 13 | 14 |
| RAM OLD | : 12 | 14 |
| RAM NEW | : 14 | 14 |

> *Transcriber's note:* "SAME" is written above the struck word in the first row. The rest of the sheet is blank.

## PDF page 17 — OPEN

*Paper: yellow lined; pencil.*

Margin, upper left, next to the title: "3[?] [overwritten digit] / [overwritten digit] bytes". The digits are written over each other and cannot be read with confidence.

```asm
OPCHAN:
ERRF:
LOC2:   ⋮
        LD HL, SPEC_T
        CALL SEARCH
        JR NC, SOT          ; SEARCH OTHER TABLE  [margin: 2]
        LD C, (HL)
        ⋮
        JP (HL)
SOT:    CALL SEARCH3        ; SEARCH BEU_CH TABLE  [margin: 3]
        JR NC, ERRF         ; ERROR IF NOT FOUND - INVALID DEVICE CODE  [margin: 2]
        POP BC              ; length of device spec
        DEC BC              ; ERROR if BC <> 1
        LD A,B
        OR C
        JR NZ, ERRF         ; [margin: 2]
        LD D, 80H           ; indicates intelligent device
        PUSH DE             ; preserve DE
        LD B, (HL)          ; B = bank #
        LD C, 00001000B     ; [inserted from margin]
        INC HL
        LD D, (HL)
        INC HL
        LD E, (HL)
        LD HL, DE
        CALL CALL-BANK      ; if addr passed in HL, bank# in B  [margin: 3]
        POP DE
        POP HL
        RET
        LD C, (HL)          ; Search BEU-OP for device's open routine
        LD HL, (BEU-OP)     ; [margin: 3]
        CALL SEARCH2        ; [margin: 3]
        JR NC, ERRF         ; [margin: 2]
```

> *Transcriber's note:* The `[margin: n]` values are small numbers in the left margin, apparently byte counts. Lon's vertical dots (`⋮`) are kept as written. `LD C, 00001000B` is written to the right of `INC HL`, and a line runs from it to the point between `LD B, (HL)` and `INC HL`. `LD HL, DE` is squeezed in small between `LD E, (HL)` and `CALL CALL-BANK`. A square bracket encloses `LD B, (HL)` through `CALL CALL-BANK`, and a second bracket encloses the last four lines. A line runs from the underline of `LD D, 80H` out to the left margin, down the page, and ends in an arrow pointing at the bracketed `LD C, (HL)` block. Two long diagonal pencil strokes cross the `PUSH DE`…`POP HL` area: one runs from `PUSH DE` down-right to just past `POP HL`, and the other runs from the right end of the `80H` underline down-left to about `CALL CALL-BANK`. They may be meant as a strike-through, but this is not certain, so the lines are transcribed as live code. There is also loose pencil hatching in the left margin beside this area, and a few faint smudged marks below the last line.

## PDF page 18

*Paper: yellow lined; pencil.*

```asm
        LD HL, (SYSCON)
        LD DE, HL
        LD BC, FEh
        ADD HL,BC           ; HL pts to temp location[?]
        LD BC, 12           ; check pres flag for end of table  [struck: 3[?]]
        EX DE, HL
        ADD HL, BC
END?:   LD A, (HL)
        CP 80h
        JR Z, SORT          ; jump if end of table
        CP 2                ; check if RAM  [inserted from margin]
        JR NZ, NOTRAM
        LD A, 255           ; lowest priority
        INC HL              ; addr of bank #
        JR CONT
NOTRAM: LD BC, 21           ; get int priority
        ADD HL, BC
; [struck: EX DE, HL]
        LD A, (HL)
; [struck: EX AF, AF'[?]]
        LD BC, 20
        SBC HL, BC          ; get bank #
; [struck: LD B, (HL)]
; [struck: LD C, A]
CONT:   EX DE, HL
        LD (HL), A          ; put addr of bank # & int priority into temp area  [comment: "addr of bank #" written above a struck word, illegible]
        INC HL
        LD (HL), E
        INC HL
        LD (HL), D
        INC HL
        EX DE, HL
        INC HL
        INC HL              ; set up to check next pres. flag
        JR END?
SORT:
; [struck: LD A, 80H]
; [struck: LD (DE), A]      ; mark end of temp table
        ⋮
```

*[Diagram, right margin: a tall narrow box divided into rows labelled, from the top, "pri", "addr L", "addr H", "pri", "addr L", "addr H", then "⋮" and an empty lower part.]*

> *Transcriber's note:* `LD DE, HL` is squeezed in small between `LD HL, (SYSCON)` and `LD BC, FEh`. The `CP 2` … `JR CONT` block is written to the right of `END?`/`CP 80h`. A line with an arrowhead at each end joins it to the point just below `JR Z, SORT`, before `NOTRAM:`. In `LD (HL), A` under `CONT:`, both "(HL)" and "A" are written heavily over earlier characters, and the earlier text cannot be read. The "H" of the next `INC HL` is also written over another letter. The word "location" in the first comment is heavily retraced or scribbled and may be struck. The two `SORT:` lines are crossed out with a large X. A filled black triangle sits to the right of `ADD HL, BC` after `NOTRAM:`. In the upper right there is faint, mirror-reversed show-through of the reverse side (it reads "OPCHAN / ERRF / LOC2 …"), which is not part of this page.

## PDF page 19 — BLDCHT

*Paper: yellow lined; pencil.*

> *Transcriber's note:* This page was scanned upside-down (rotated 180°). It was rotated 180° (`convert -rotate 180`) before reading. It is not mirrored: after rotation the text reads normally from left to right.

Margin, upper left: "[illegible overwritten characters, 2B? 28?] 14[?]".

```asm
BLDCHT: LD (BEU-CH), HL
        PUSH HL
        LD C, 1
        LD HL, (SYSCON)
        LD DE, EBSTRT
        ADD HL, DE          ; [inserted from margin]
        EX DE, HL
BLDCH:  LD A, (DE)
        CP 0                ; [margin: 2]
        JR Z, BLDCP[?]      ; [margin: 2]
        POP HL
        PUSH DE
        LD (HL), C
        LD DE, 0            ; [margin: 3]
        INC HL
        PUSH HL
        LD B, 255           ; [inserted from margin]
        PUSH BC
        PUSH HL
        PUSH DE
        LD DE, 11
        PUSH DE
        LD DE, 1
        PUSH DE
        CALL XFER-BYTES     ; [margin: 3]
        POP HL
; [struck: PUSH DE]
        LD D, H
        LD E, L             ; DE & HL both are pointing to BEU-CH byte 2[?] where dev spec now is.
        INC DE
        INC DE
        INC DE

        INC DE
        LD A, (HL)          ; move device spec to offset 5
        LD (DE), A
        INC DE
        INC DE              ; move output to offset 1
        INC DE
        INC DE
        INC DE
        LD A, (DE)
        LD (HL), A
        INC HL
        INC DE
        LD A, (DE)
        LD (HL), A
        INC HL              ; move input to offset 3
        DEC DE
        DEC DE
        DEC DE
        LD A, (DE)
        LD (HL), A
        INC HL
        INC DE
        LD A, (DE)
        LD (HL), A
        INC HL              ; HL pts to offset 0 of next record  [struck: 4? 6?]
```

Side block (right column; an arrowhead ">" points at `POP DE`, and a faint line appears to come from the final `INC HL` of the main block):

```asm
        POP DE
        INC C
        PUSH HL
        EX DE, HL
        LD DE, EBSIZE       ; [margin: 3]
        ADD HL, DE
        EX DE, HL
        JR BLDCH            ; [margin: 2]
```

> *Transcriber's note:* `ADD HL, DE` / `EX DE, HL` are written at the upper right. A line runs from under `LD DE, EBSTRT` to an arrow pointing at them. The `LD B, 255` … `PUSH DE` block is written in the right column. A long curved line, with no visible arrowhead, joins it to the point after the small interlinear `PUSH HL` and before `CALL XFER-BYTES`. `POP HL` (above `PUSH DE`) and `PUSH HL` (above `CALL XFER-BYTES`) are small interlinear additions. `CALL XFER-BYTES` is written with no space ("CALLXFER-BYTES"). The `0` in `LD DE, 0` is a slashed zero, written over another mark. The `LD E, L` comment is very faint, and "DE" is written small above it, roughly over "BEU-CH". In the side block, a bracket runs from `INC C` down to an arrow pointing at `JR BLDCH`. In the right margin, about level with `PUSH DE`/`LD DE, 1`, there is a blacked-out scribble and the sideways-written marks "H-L" / "L-L[?]".

## PDF page 20 — SORT (cont)

*Paper: yellow lined; pencil.*

```asm
; [struck: SORT  (cont)]
; [struck: XOR A]
; [struck: LD (MAX_BANK), A]
```

*[Diagram, top right, scribbled out: a small grid table with column headings "Index", "Pri", "addr"; there are no entries in the cells.]*

```text
search SYSCON on int pri for smallest #
    keep temp vars for low # & addr of bank #
 -> compare against low #
|   if < low # & bank # > 10
|       then new low # & new addr of bank #
 -- test next record
    if end of table
    inc~~[illegible]~~ MAX_BANK
    Write_BS_Reg (BNA, old bank #)
    Write_BS_Reg (ABN, MAX-BANK)
    reassign bank # in table
    ~~if any~~
```

---

```text
 -> search thru table
|     [on? or?] 1ST bank # ≥[?] 10
|           low # := bank's int pri
|     search rest of table comparing int pri for bank #'s >10
|           a lower # results in a new low & new bank # addr
|     at end of table
|           give the winners a new bank #
 --         & do again
    if no[blot] bank #'s >10
        then done.
```

> *Transcriber's note:* The three code lines at the top are cancelled with large looping scribbles, and the "S" of "SORT" is cut off at the page edge. In the first line, "int" is written small above "on" and "pri". In the second line, "low" is retraced over earlier letters. Each of the two pseudocode blocks has a bracket line in the left margin that runs from an arrowhead at its first line ("compare against low #" / "search thru table") down to "test next record" / "& do again". These are shown above as `->`, `|` and `--`. In the second block, "[on? or?] 1ST" is written above a blacked-out word. The "≥" is heavily overwritten and may have been changed to or from ">". A freehand horizontal rule separates the two blocks.

## PDF page 21 — NEWSEARCH

*Paper: yellow lined (top edge torn); pencil.*

NEWSEARCH   searches SYSCON for a device spec

```asm
SRCHSC: LD      HL,(SYSCON)
        LD      DE,9            ; start of banks  [9 written over partly erased text, possibly "(SYSCON)"?]
CHKTBL: ADD     HL,DE
        LD      A,(HL)          ; check end of table
        CP      80H
        JR      Z,ENDTBL
        CP      2               ; check presence flag for int dev.
        JR      NZ,NXTONE       ; if not try next entry
        INC     HL
        INC     HL              ; else compare device spec
        LD      A,(HL)
        CP      C
        JR      Z,FOUND
NXTONE: ADD     DE,17H          ; try next entry
        ADD     HL,15H
        JR      CHKTBL
ENDTBL: AND     A               ; clear carry + return
        RET
FOUND:  SCF                     ; set carry + return  [return possibly struck?]
        DEC     HL              ; returns [struck: w/] HL pointing to [struck: dev spec]
        RET                     ;   [struck: [illegible]] bank# [struck: [illegible] HL]
```

DE returns w/ offset from SYSCON to presence flag

Side note (line drawn from the brace around NXTONE's `ADD DE,17H` / `ADD HL,15H`, in the right margin, bracketed):

```asm
        PUSH    HL
        EX      DE,HL
        LD      DE,17H
        ADD     HL,DE
        EX      DE,HL
        POP     HL
        PUSH    DE
        LD      DE,15H
        ADD     HL,DE
        POP     DE              ; [POP written over/retraced]
```

> *Transcriber's note:* An arrow runs from the `CHKTBL:` label down to the `LD A,(HL)` line. A left-hand bracket with an arrowhead runs from just under `JR Z,ENDTBL` down to the second `INC HL`; directly under `JR Z,ENDTBL` is a faint erased line (illegible). The two `INC HL` lines have marks before the `I` that may be numerals "1"[?] and "2". There is faint erased writing above the `NXTONE` line, to the right of "check end of table", and between the comments on the `SCF`/`DEC HL`/`RET` lines — all illegible. The colons after `ENDTBL` and `FOUND` look like semicolons on the page.

## PDF page 22 — bank renumbering pseudocode (X / L6)

*Paper: yellow lined (top edge torn); pencil.*

```text
X:    HL := (SYSCON)+12
             not End of table &
      while ^ bank# [scribbled out] < 10 do
          [scribbled out] HL := HL+24   (*rec := rec↑.next*)
      if not end of table
        then begin                                         if RAM
                save pri & bank# addr   <---------------   then pri = 255
                                                           else get pri
                while not end of table do  [struck: & bank# < 10]
                  begin
                  { if bank# > 10
                    then if not RAM then if priority < saved priority
                            then save pri & bank# addr
                    [scribbled-out character] rec := rec↑.next   (* HL := HL+24 *)
                  end (*while*)

L6:
                MAX_BANK := MAX_BANK + 1
                Write_BS_Reg (BNA, saved bank #) }   TEM(MAX_BANK)
                Write_BS_Reg (ABN, MAX_BANK)     }      [struck: TEM] := MAX_BANK
                                                        [struck: INC TEM]
                bank# addr [scribbled out] gets MAX_BANK
                GOTO X
             end
      else [struck: all done] reset BSCC
           For I := 1 TO MAX_BANK
               [struck: [illegible]]
               Write_BS_Reg (ABN, TEM(I))
```

> *Transcriber's note:* "not End of table &" is written above "while … bank#" with a caret. "do" is written above the struck "& bank# < 10". "begin" is written between the lines. "if not RAM then" is written above the line and inserted with a caret between "then" and "if priority". The "if RAM / then pri = 255 / else get pri" note is in the right margin, with an arrow to the circled "save pri & bank# addr". A light line runs through "if bank#"; it may or may not be a strike. "GOTO X" is written small under the "bank# addr gets MAX_BANK" line. The TEM(MAX_BANK) note sits to the right of the brace around the two Write_BS_Reg lines; "TEM(MAX_BANK)" is written above the struck "TEM".

Scratch arithmetic, lower right:

```text
7   4
4-7 = -3
7-7 = 0
8-7 = 1
```

## PDF page 23 — For DELETE m,n

*Paper: yellow lined; ink, with pencil notes.*

For DELETE m, n

Left column, crossed out with a large X:

```text
[struck: Find line m
           delete line m
           get next line
           delete line]
```

Middle column (pseudocode), with the matching calls written to its right:

```text
get line m                         HL := m
                                   CALL FIND_L
                                        (LIST p.7)
repeat
  delete line                      CALL DELREC  or DEL_DE
                                                (LIST p.10)
  get next line                    CALL NEXT_L   [NEXT written above struck FIND]
                                        (LIST p.5)  [5 overwritten; earlier digit illegible]
until line# > n                CALL GET_LN
                                    (EDIT p.12)
                               LINE# in DE
```

can probably replace loop w/ single call to DEL_DE after finding m & n, setting (HL) := n+1 [struck: [illegible]] ; (DE) := m.

Scratch arithmetic, lower left (written diagonally):

```text
  55
  .4
 ----
22.0
```

and nearby, faint: 33[?]

> *Transcriber's note:* The "can probably replace loop…" note is in pencil. A small dark mark in the left margin, about a third of the way down, is not legible as text.

## PDF page 24

*Paper: yellow lined.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* The show-through is the mirror-reversed "For DELETE m,n" text from PDF page 23.

## PDF page 25 — CHANS / channel data (2-23)

*Paper: yellow lined; ink, with some additions in darker ink.*

> *Transcriber's note:* "2-23" is written diagonally in the top-left corner and underlined.

CHANS  –  Channel Data

```text
        addr of output routine for WRCH
        addr of input routine for INCH
        1-byte code for device type
          { file name
          { additional data
          { buffer
```

Hidden streams are permanently tied to specific channels.

```text
HID STR = 3   (* # of hidden streams *)
   HID_K = -3      kbd - lower ½ of screen (LHS)
   HID_S = -2      TV - upper ½ of screen
   HID_R = -1      insertion RAM

   COM_ST = 0      cmds
   INP_ST = 1      input data
   PR_ST  = 2      print
   LPR_ST = 3      LPRINT
```

CHINIT table gets stored at P_RAMT +2 = DRIVES or after disk drive maps, if any.

CHANS_ contains addr that CHINIT is stored at.

Load BEU channel table after line 480 of EDIT(p.2). at HL

BEU select, open, close tables may follow this. at HL

Timex © after line 515

Put System Config. Table code somewhere between lines 446 and 459 exclusively since that block of code is executed only on plugin.  at?

~~Since CHANS_ comes at 475, put SCT code after 474 ~~so~~ table can ~~go~~ be loaded into location DRIVES+n, n = length of DRIVES ~~table~~,~~

> *Transcriber's note:* The last two lines ("Since CHANS_ … DRIVES table,") are crossed out with a continuous wavy line; inside them, "so", "go" and "table" (the final one) also have their own strike lines. "(LHS)" is in darker ink. A small pencil scribble below "Load BEU channel table…" is not text.

**Margin notes (darker ink):**
- Bottom left, beside the struck "go": `46N` `shift copy`
- Bottom right, written diagonally: `55N`, then a scribbled-out word, then `channel/sdd[?]`

## PDF page 26

*Paper: yellow lined; —.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* The only marks are a faint "(…)" group mid-page and small marks in the lower-left and lower-right corners. Mirrored, the mid-page group reads "(LHS)", matching "(LHS)" on PDF page 25; the corner marks sit where "55N … channel addr" and "46N shift copy" are on page 25.

## PDF page 27

*Paper: yellow lined; pencil.*

After SysConfigTab is located, ~~do BEU initialization~~<br>
&nbsp;&nbsp;poll devices to fill in table.<br>
&nbsp;&nbsp;Then boot devices in order of priority<br>
&nbsp;&nbsp;Then do ROS /Home bank initialization.

> *Transcriber's note:* "/Home bank" is written small beneath and just after "ROS", with no caret.

&nbsp;&nbsp;&nbsp;&nbsp;if ROS is present, pass control to it after<br>
&nbsp;&nbsp;&nbsp;&nbsp;displaying TIMEX © msg. &nbsp; ~ 517

Select calls Search

## PDF page 28

*Paper: yellow lined; —.*

*(Blank page.)*

## PDF page 29

*Paper: yellow lined; black ink, with pencil for the percentages and some thin connecting lines.*

```text
System init
    Sys Config Tab              |        7.7%       .9
       Poll devices             |        7.7%
       Boot devices             |        7.7%
  ←ROS/Home bank init           ||||     30.8%

Channel I/O                                         .4
    Add Tables   CHINIT         |||      23%
                 SELECT,OPEN, CLOSE
    Change Search               |        7.7%
                                              15,4%
```

> *Transcriber's note:* "Change Search" is underlined. "CHINIT" is written small above "SELECT,OPEN, CLOSE". The tally strokes and percentages are in separate columns. A thin pencil line runs from near the ".9" at the top down past the percentages to "15,4%". From there it curves down-left toward the "||" beside "Add programmable sound chip" below. Below this table, two long wavy ink lines cross the page as a divider; the lower one starts with a short downward tick (like a "T").

→ Add programmable ~~sound chip~~[?] &nbsp;|| &nbsp;( ~~channel 'N'?~~ / ~~NOISE~~[?] )<br>
&nbsp;&nbsp;& game controllers ~~to list of permanent channels.~~<br>
&nbsp;&nbsp;&nbsp;&nbsp;~~(channel 'G'?)~~ &nbsp;&nbsp;&nbsp;&nbsp;~~(means adding 2 hidden streams)~~<br>
&nbsp;&nbsp;&nbsp;&nbsp;~~(channel 'S'[?] - joystick)~~

Some examples of BEU devices are<br>
&nbsp;&nbsp;&nbsp;&nbsp;Floppy drive<br>
&nbsp;&nbsp;&nbsp;&nbsp;Stringy drive<br>
&nbsp;&nbsp;&nbsp;&nbsp;Modem<br>
&nbsp;&nbsp;&nbsp;&nbsp;LAN controller

**Left margin (written diagonally, underlined):** There are 2 game controllers

**Left margin, below that:** ~~[illegible, ~1–2 words; scribbled out solid]~~

**Right side (after "devices are", beside a heavy vertical stroke):** may not need hidden stream for game controllers

> *Transcriber's note:* In "may not need", the word "not" is in heavier ink than the words around it.

**Right column (separated by horizontal rules, crossed out with a large X):**

```text
SMINIT
-------------
CHINIT            <-- line from "(& BASIC line 294)"
-------------
SELTAB
-------------
(initialization   <-- arrow points here
  code )
-------------
CL_TAB
-------------
SPEC_T
 (OPEN_N/G)
 OPEN CP's
-------------
```

> *Transcriber's note:* "(OPEN_N/G)" has "N" written above "G" after "OPEN_". The circled note "(& BASIC line 294)" sits left of the column, and a line runs from it to "CHINIT". A looped line from the same spot circles up around the "may not need…" note toward the ")" closing "(means adding 2 hidden streams)". The block from "Add programmable" down to "LAN controller", together with the right-hand column, is crossed by two long thin diagonal lines that form a large X. The "(channel 'G'?) / (channel 'S'? - joystick)" pair is crossed out with a zig-zag line. "sound chip" falls under one of the long diagonals, so it may not be deliberately struck. A small heavy circle ("O") is drawn in the left margin below "LAN controller".

## PDF page 30

*Paper: yellow lined; —.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* The faint text is mirror-reversed. It is the "System init / Sys Config Tab / Poll devices / Boot devices / ROS/Home bank init / Channel I/O / Add Tables CHINIT SELECT,OPEN,CLOSE / Change Search" list, the wavy divider lines and the scribble from PDF page 29.

## PDF page 31

*Paper: yellow lined; pencil, with "BEU_DEV" in ink.*

<u>SEARCH</u><br>
&nbsp;&nbsp;~~replace RET Z w/ JR to search BEU-DEVICE-TABLE~~<br>
&nbsp;&nbsp;~~where HL is loaded w/ BEU-DEV-TAB & is searched~~

OPEN (p.3 CHANS)<br>
&nbsp;&nbsp;~~after line 497, throw in CP's to new devices~~<br>
&nbsp;&nbsp;&nbsp;&nbsp;~~BUT won't know what they are until runtime.~~<br>
&nbsp;&nbsp;&nbsp;&nbsp;~~Need some sort of dynamic CP~~

&nbsp;&nbsp;~~Need to dynamically add to all tables.~~<br>
&nbsp;&nbsp;~~Q: Do we know what all the possibilities are for BEU devices?~~

&nbsp;&nbsp;→ or call some routine that goes thru the OPEN [above: BEU_DEV] table<br>
&nbsp;&nbsp;&nbsp;&nbsp;~~to~~[?] CPing device specs.<br>
&nbsp;&nbsp;&nbsp;&nbsp;But how is this table built?<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Perhaps device spec has to go into Sys ConfigTab.<br>
&nbsp;&nbsp;DUMMY!<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This info is found thru channel data addr in SCT.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;similarly for SPEC-T

> *Transcriber's note:* Both lines under SEARCH, and the three lines under OPEN, are crossed out with large wavy lines. The two lines "Need to dynamically…" and "Q: Do we know…" are crossed out with a thinner wavy line. A curved bracket-arrow runs from the left of "Need to dynamically…" down to "→ or call some routine…". "BEU_DEV" is written in ink above "OPEN table", with no caret.

## PDF page 32

*Paper: yellow lined; —.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* The only marks are a faint wavy curve mid-page. It mirrors the wavy strike-through over the OPEN section on PDF page 31.

## PDF page 33

*Paper: yellow lined; pencil, with ink blots and an ink scribble-out.*

```text
BORDPT  = 0FEH    output port for setting border color      bits 0,1,2
PR_IN   = 0FBH    for input from printer
PR-OUT  = 0FBH    for output to printer
KB_PT   = 0FEH    input port from kbd                       bits 0,1,2,3,4
O_PORT  = 0FEH    output port for tape (MIC) bit 3   [MIC written above a blotted-out word, illegible; a blotted-out character before "3"]
I_PORT  = 0FEH    input port for tape (EAR) bit 6
TAPE_I  = 6       tape input bit in (I-PORT)
```

~~[illegible, ~10–12 words, scribbled out in heavy ink; fragments possibly "…configuration…", "…powers up to…"]~~

```text
Port addr  254   - kbd input  (254 + 256*(255-2^n)), n=0..7     bits D0..D4 are 5 keys in 1/2 row
           FE                                                     D6 is EAR socket
           254   - output drives loudspeaker (D4)
                     & MIC socket (D3) & border color (D2, D1, D0)
           251 FB - printer I/O
                                                      bits 5,7,[blot] on [blot] input
                                                      bits 5,6,7,[blot] on output
           254 FE \
           247 F7  } extra devices
           239 EF /
```

> *Transcriber's note:* "(255-2^n)" is written above a blotted-out term after "256*". The hex labels FE/FB/FE/F7/EF are written small beside the decimal numbers. The "7" of "F7" is heavily overwritten. A brace from 254 to 239 points to "extra devices". There is a heavy pencil scribble mark (no text) in the lower-left margin.

## PDF page 34

*Paper: yellow lined; —.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* A single fairly dark horizontal smear sits mid-page. It is the mirror image of the heavy scribbled-out line on PDF page 33: same height, same extent, with the tapered end reversed. The darkness at the top edge is the pad binding.

## PDF page 35

*Paper: yellow lined; black ink, with pencil for the SELECT/OPEN/CLOSE section and the X lines.*

~~NEW PERMANENT DEVICES~~

> *Transcriber's note:* The title is crossed through with a wavy line. The whole page is crossed out with a large X made of two long thin lines.

add to CHINIT after line 777[blot] (p.8 EDIT)

```asm
        DEFW    SOUND           ; CHANNEL N: PROGRAMMABLE SOUND CHIP
        DEFW    ERRJ
        DEFB    'N'

        DEFW                    ; CHANNEL G: GAME CONTROLLER 1
        DEFW
        DEFB    'G'
        DEFW                    ; CHANNEL J: GAME CONTROLLER 2
        DEFW
        DEFB    'J'
```

add to SMINIT

```asm
783
        DEFW    CHAN_N +1       ; STREAM -4 = CHANNEL N
790
        DEFW    CHAN-N +1       ; STREAM 4 (SOUND) INITIALIZED TO CHANNEL N    [ink blot before "(SOUND)"]
        DEFW    CHAN_G+1        ; STREAM 5 (STICK) INITIALIZED TO CHANNEL G
```

add to BASIC line 294

```asm
CHAN_N:  EQU 20
CHAN_G:  EQU 25
CHAN_G;  EQU 30
```

```text
SELECT
  SELTAB (EDIT p.10) - put into table & add initialization code (if any)

OPEN
    CP's at line 497 (p.3 CHANS)
    SPEC-T (p.4 CHANS)            OPEN_N: LD E, CHAN_N+1
                                          JR LOC 7
CLOSE
    CL_TAB (p.1 CHANS)
```

## PDF page 36

*Paper: yellow lined.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* Contrast-enhanced: all marks are mirror-reversed (DEFW/DEFB lines, "add to CHANS", "add to BASIC line …", "CHANS: …" entries); no left-to-right writing found.

## PDF page 37 — SYSTEM CONFIG TABLE

*Paper: yellow lined; ink (black and blue).*

SYSTEM CONFIG TABLE

may have up to 7 devices (i.e. expansion banks)

> *Transcriber's note:* Left column is the table definition; a vertical rule separates it from an "offsets" column at right. A brace spans the EB1 entries, with "[1?]4 bytes" in the left margin beside it (the leading digit is cut off at the page edge).

```asm
SYSC[T?]:                   ; [letter(s) after SYSC blotted out; "T" written above]
        DEFB    AROS_F      ; AROS presence flag   [struck: P-FLAG[?]]
        DEFW    BOOT_A      ; boot addr
; [struck: illegible, small]
        DEFW    A-LANG      ; AROS language
        DEFW    A-SIZE      ; AROS size
        DEFB    LROS_F      ; [LRCS? LROS?] presence flag
        DEFW    BOOT_L      ; boot addr
        DEFW    L-LANG      ; LROS language
        DEFW    L-SIZE      ; LROS size

        DEFB    EB1_F       ; Exp. bank 1 presence flag
        DEFW    EB1_BA      ; boot addr
        DEFB    EB1_PR      ; boot priority   [last letter of DEFB overwritten; final appears B]
        DEFW    EB1_CH      ; EB1 channel data addr
        DEFW    EB1SEL      ; select init addr
        DEFW    EB1_ST      ; stream open addr
        DEFW    EB1_CL      ; stream close addr
        DEFW    EB1_IH      ; int. handler addr
          :
        DEFW    EB7_IH
```

Margin beside the EB1 brace: `[1?]4 bytes`

**offsets** (right-hand column)

```text
PRES    EQU 0
BOOTAD  EQU 1
[struck?: LANG   3]
[struck?: SIZ    5]
[struck: illegible]
PRI         3
EBCH        4      [struck letters before EBCH]
EBSEL       6
EBSTOP      8      [a letter overwritten after EBST]
EBSTCL     10
EBIH       12

AROSLO      0
LROSLO      7
[struck: EBLOC  14]
EBSIZE     14
```

> *Transcriber's note:* The LANG and SIZ lines and a third fully scribbled line below them are bracketed by a heavy vertical scribble on the left, and the "3" and "5" have a heavy bar to their left. These look like deletion marks, so they are shown as struck with "?".

so loc of EB5 = (SYSCON) + 5 * EBSIZE

Boxed note (right):

> should put table in sys. vars.
> e.g.
> &nbsp;&nbsp;&nbsp;&nbsp;SYSCON EQU P_RAMT + 2
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;offsets list / make template known
> &nbsp;&nbsp;&nbsp;&nbsp;DRIVES EQU SYSCON + [blot]2
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(or 112)
> (for[?] instance location, could be anywhere)

> *Transcriber's note:* In the DRIVES line, a character before the final "2" is blotted out solid. "(or 112)" is written beneath it.

Table itself should be where CHANS now is. (maybe)

> *Transcriber's note:* A short squiggle or arrow mark follows "where".

Arithmetic (centre):

```text
 14
  7
---
 98
 14
---
112   bytes for table      [boxed]
```

somewhere in sys. vars put SYSCON EQU ?

Boxed (lower left): **offsets from (SYSCON)**

```text
AROSLO = [struck: SYSC[T?]] 0
LROSLO = [struck: AROSLO + 7] 7
EB1LOC = [struck: LROSLO + 7] 14
EB2LOC = [struck: EB1LOC + 14] 28
   :
```

Boxed (lower middle):

> put code after line ~~[illegible]~~ ~~474~~
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;455
> what needs to be done here is
> &nbsp;&nbsp;Poll devices to fill in table
> &nbsp;&nbsp;Boot devices

Lower right, entirely scribbled over and crossed with an X:

```asm
; [struck: LD (SYSCON), HL]
; [struck: LD DE, SYSCT]
; [struck: LD BC, 112]
; [struck: EX DE, HL]
; [struck: LDIR]
; [struck: EX DE, HL]
```

Arithmetic beside it:

```text
182
112
---
294

300
```

~~but CHINIT data is initialized at assemble time, SYSCON is initted at run time~~

> *Transcriber's note:* A wavy line runs through this whole bottom line. It looks like a strike-through, though it could be a stray box edge.

## PDF page 38

*Paper: yellow lined.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* Enhanced: this is a mirror-reversed image of the SYSTEM CONFIG TABLE page (PDF p. 37), including the DEFB/DEFW column, the offsets column, and "Table itself should be where CHANS now is." No left-to-right writing found.

## PDF page 39 — BEU channel tables

*Paper: yellow lined; ink (blue, with the last lines in black).*

BEU channel tables   code after line 480

&nbsp;&nbsp;&nbsp;&nbsp;Check Exp. Banks for presence

```text
  +-  LD (BEUtabtype[?]), HL
  |   FOR I := 1 TO 7  DO
  |   [struck: illegible]
  |       IF (SYSCON + (I[?])*14 [struck: illegible] •).presence
  |          THEN [struck: illegible] add info to tables
  ^   LD (HL), 0        (* terminator *)     [a character overwritten before ", 0"]
  +-  INC HL
```

> *Transcriber's note:* A bracket encloses the block from LD (BEU…) to INC HL, with an up-arrow on its left side. In the IF line, "(I…)*14" is written above a struck group; a blotted character follows the I. "LD (BEUtabtype), HL" is squeezed in above the FOR line.

Margin note at left, with a bracket arrowed to the block:

> first for channel
> ~~then~~ for select
> ~~then~~ stream open
> ~~then~~ close
> ~~[illegible] handler[?]~~

> *Transcriber's note:* The word "then" on the margin lines appears lightly struck. The last line is heavily scribbled out.

so all tables ~~[illegible]~~ are built before (DATADD) is assigned.

```text
[struck: BEUCH]  BEU_CH  }
                 BEUSEL  }  system vars indicating location of tables
                 BEU_OP  }
                 BEU_CL  }
```

*[A small scribbled-out circle sits at right, mid-page; contents illegible.]*

```asm
         LSH2:  INC HL      ; [written above the line; a line connects LSH2 to the struck text below]
                INC HL      ; [written above the line]
SEARCH2:        INC HL      ; [struck before it: illegible]  [a character blotted out between SEARCH and 2]
                LD A, (HL)
                AND A
                RET Z
                CP C
                INC HL
; [struck: INC HL]
                JR NZ, LSH2
                SCF
                RET
```

> *Transcriber's note:* The two "INC HL" lines and the "LSH2:" label are crowded above the SEARCH2 line. The order shown is top to bottom as written.

To the right of the code:

> New search routine
> is identical to existing
> one except HL gets
> incremented by 4 rather
> than 2 each time thru loop.
> &nbsp;&nbsp;& HL rets[?] to bank#

---

SEL, OP, CL are set up so that upon return from SEARCH the addr of the routine to be called is in HL.

Q: w/ new tables w/ bank #, does ~~[illegible]~~ bank have to be taken into acct.? Oh, yes.

&nbsp;&nbsp;&nbsp;&nbsp;USE&nbsp;&nbsp;&nbsp;GOTO-BANK(addr, bank)

## PDF page 40

*Paper: yellow lined.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* Enhanced: the only marks are at the bottom. They are a mirror-reversed "USE GOTO-BANK(addr, bank)" and "Oh, yes." from PDF p. 39.

## PDF page 41 — OPEN

*Paper: yellow lined; ink (blue, and black).*

OPEN&nbsp;&nbsp;&nbsp;(CHANS p.3)

> *Transcriber's note:* The pseudocode below "OPEN" is crossed out with a large X. The LD/CP/PUSH lines beneath are crossed through with long curved strokes. The "TO BOOT" paragraph is also crossed with a large X.

```text
after CP's of perm devices
    search BEU_OP
     X[overwritten] := [blot]BEU-OP
     WHILE (X <> 0) AND (X <> A)  DO
        [struck: illegible, ends "A"]      X := X+4
```

```asm
        LD HL, BEU_OP
        CP (HL)

        PUSH A
        LD HL, BEU_OP
        CP 0
```

After call to SEARCH
line 524

```asm
        LD HL, BEU_OP
        CALL NC, SEARCH2
        JR NC, ERRF
```

Q: what about jump to code to open channel?

**TO BOOT**

To determine what devices have been booted use bits of a word
In determining which device to boot compare next boot priority w/ that of current high. If higher + its booted bit is 0, it becomes current.

---

Cannot create BEU channel tables at SYSCON build time because it is not known how big the tables will be.

> *Transcriber's note:* A heavy vertical bar is drawn in the left margin beside this last note.

## PDF page 42

*Paper: yellow lined.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* Enhanced: this is the mirror-reversed "To determine what devices have been booted…" paragraph and the "Cannot create BEU channel tables…" note from PDF p. 41. No left-to-right writing found.

## PDF page 43 — ORDER EB BOOT PRIORITIES / BOOT DEVICE / INSERT_EB

*Paper: yellow lined; pencil.*

> *Transcriber's note:* The whole page is crossed out with a large pencil X. The first FOR block also has several extra diagonal strokes through it.

```text
FOR I := 1 TO 7 DO                         add sys. var.   BOOTPR
   IF EB[I].presence                           ; Boot priority of BEU devices, 7 bytes
      THEN
```

```text
ORDER EB BOOT PRIORITIES

     FOR I := 1 TO 7 DO

          IF EB[I].presence
                  [struck: illegible] INSERT_EB
          THEN [struck: IF[?] EB[I].pri[?] <- BOOTPR EB[?]]
```

> *Transcriber's note:* "INSERT_EB" is written above the struck THEN clause and replaces it.

**BOOT DEVICE**

```text
   FOR I := 1 TO 7  DO
     IF BOOTPR[I] <> 0 THEN
      CALL    EB[BOOTPR[I]].boot_addr        <- CALL-BANK (addr, bank)
```

**INSERT_EB**

```text
         x := [blot]1;
  L:  [mark] IF BOOTPR[X] = 0
           THEN BOOTPR[X] := I
           ELSE IF EB[BOOTPR[X]].pr <= [blot]EB[BOOTPR[I]].pr
                THEN X := X+1; GOTO L:
                ELSE (*copy down*) FOR Y := 7 DOWNTO X DO
                                       BOOTPR[Y] := BOOTPR[Y-1];
      BOOTPR[X] := I;
```

> *Transcriber's note:* In the ELSE IF line, "EB" is written above "[BOOTPR[X]]" as an insert. A heavy pencil stroke sits before "IF" on the L: line.

*[Diagram: small vertical array sketch to the right of INSERT_EB, labelled "0" at top and "7" at bottom, with tick marks for the slots.]*

THIS CODE GOES RIGHT AFTER SYSCONTAB IS BUILT.
&nbsp;&nbsp;PERHAPS BOOTPR SHOULD BE PRIORITIZED WHEN SYSCON IS BUILT

## PDF page 44

*Paper: yellow lined.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* Enhanced: the only marks are a faint diagonal stroke from upper right to lower left. It matches a mirror image of one arm of the large X on PDF p. 43. No writing.

## PDF page 45 — ROS INIT

*Paper: yellow lined; pencil, with some lines in black ink.*

ROS INIT&nbsp;&nbsp;&nbsp;goes right after BOOT code

*[A long horizontal curved rule is drawn under this line.]*

~~description~~

```text
ROUTINE NAME:
     INPUTS:
     OUTPUTS:
     GLOBALS ACCESSED:
     GLOBALS CHANGED:
     CALLED FROM:
     PROCS CALLED:
     DESCRIPTION:
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;give overview first of changes to be made and new system variables

```text
New sys. vars
Load SysCon
       poll
       boot
Load BEUChan.
```

*[Doodle at the bottom edge, cut off by the page edge: a small face with a dark hat and long hair.]*

## PDF page 46

*Paper: yellow lined (legal pad); no writing on this side.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* Under contrast enhancement the only marks are mirror-reversed; flipped, they read "give ROM writer list of changes to be made / and new system variables" and, lower right, "new sys vars / Load System / … / boot / Load [illegible]". A short dark vertical stroke at the top edge is a scan/paper mark, not writing.

## PDF page 47

*Paper: yellow lined (legal pad); pencil.*

To determine if printer is on port FB = PR_IN

```asm
    IN A, (PR_IN)
    ADD A, A        ; - results in M if no printer
    RET M
```

---

FOR OUTPUT TO PRINTER (AT PR_OUT)

```text
                                                              76543210
…28   BIT 7 = DOT FOR PRINTING, 1 = BLACK, 0 = WHITE
…4        2 = MOTOR OFF(1), ON (0)
…2        1 = MOTOR SLOW (1), FAST (0)
```

FOR INPUT TO PRINTER (AT PR_IN)

```text
…0    BIT 0 = TIME TO PRINT DOT
…4        6 = PRINTER ABSENT
…28       7 = START OF PAPER
```

> *Transcriber's note:* The numbers in the far left margin (shown here as `…28`, `…4`, `…2`, `…0`, `…4`, `…28`) are cut off at the left edge of the scan; only the right-hand digits are visible. "76543210" is written at the right, level with the RET M / FOR OUTPUT lines.

---

can we give port ids to expansion slots — need separate ports for each slot for each dumb device
Then we can make PR-IN & PR-OUT system vars
& do

```asm
    LD C, (PR-IN)
    IN A, (C)    or    OUT (C), A
```

PR-IN & -OUT can be set at initialization by polling all possible ports it may be on until it is found or determined to be absent

It doesn't matter — printer will work w/o <u>changes</u> regardless of where it is plugged in.

```text
~~9M~~     ~~33 T~~    ~~16.5~~ usec
~~12M~~    ~~44 T~~    ~~22.0~~
11M        39T         20.5usec   [scribbled out: illegible]
3m         18T         9
4m         24T         12
```

> *Transcriber's note:* The first two rows of the timing table are crossed through with a large X in each column. Marks to the left of the "3m" and "4m" rows are cut off at the page edge.

## PDF page 48

*Paper: yellow lined (legal pad).*

*(Blank page.)*

## PDF page 49

*Paper: small yellow lined sheet (half-size pad, red margin rule); pencil, with a boxed note in pen at bottom.*

GOTO BANK
    Bank: B    Horiz Sel.: C    addr: HL
CALL.BANK
    same
Write BS Reg    reg addr in E[?]
                reg data in E

X-FER on stack

```text
direction                 2
~~[illegible, ~2 letters]~~length   4
dest addr                 6
src addr                  8
dest bank                10    E
src bank                 11    D
```

---

```text
I/O ports   DKHSPT = F4H
            BDATPT = FCH     exp bank "data" port
            BCMDPT = FDH              "cmd"
```

*[Boxed note, lower left:]*
2N-Arch
45N-Design

> *Transcriber's note:* On "reg addr in E" the letter is darkened/overwritten and its top is partly unclear.

## PDF page 50

*Paper: small yellow lined sheet (half-size pad); pencil.*

| <u>write cmd port</u> | <u>read data port</u> | <u>write data port</u> |
|---|---|---|
| 0 | read status | write cmd ls nybble |
| 1 | none | ms |
| 2 | read HS ls nyb | hold reg ls |
| 3 | ms | ms |

> *Transcriber's note:* "nybble" in row 0 runs off the right edge of the sheet ("nybbl…" visible). The rest of the sheet is blank apart from faint specks.

## PDF page 51

*Paper: small yellow lined sheet (half-size pad, red margin rule); pencil, with figures overwritten in black ink/felt-tip.*

*Channels* (written diagonally, top left, with hatching under it)

```text
CallCB   -  ~~10~~ 12
Search2  -  12 bytes
Search3  -  ~~[illegible]~~ ~~[illegible]~~ ~~37[?]~~ [blotted] 27
Close    -  ~~35~~       29
Open     -  ~~36~~       30
Select   -  ~~38~~       32
            ---------   ----
            ~~148~~     ~~[illegible, 3 digits]~~ 142
```

> *Transcriber's note:* In the final total, the last digit "2" is written in ink over an earlier digit (0 or 8?).

Side column of figures to the right (separated by a vertical rule):

```text
 ~~12~~      12      ~~12[?]~~
 ~~27~~      27      ~~27~~
 ~~35~~      37      ~~31~~
 ~~36~~      38      ~~32~~
 ~~38~~      40      ~~34~~
 ------     ----     ------
 ~~148~~   (154)     ~~14[?]6[?]~~
```

> *Transcriber's note:* First column is crossed through by two long diagonal strokes with an X above it; third column is scribbled out vertically. "154" is circled.

---

Max table size

```text
SYSCON      73
BEU_CH      43     [ink, written over an earlier pencil value]
BEU_OP      29
BEUSEL      29
BEU_CL      29
           ----
           203
```

*[Diagram: horizontal memory strip. Left: arrow pointing left labelled "D-File and Attrs". Segment "System vars + pr.buf" between an unlabelled up-arrow boundary and a boundary up-arrow labelled "6000 H" / "MSTKEND" (the M of MSTKEND overwritten). Next a dashed boundary with up-arrow labelled "MSTKBOT"; segment "bank sw-"; a dashed boundary with a down-arrow from "BSWEND" written above; right end boundary labelled "7FFF H". A long loop is drawn from under "MSTKEND" around to the right end near 7FFF H.]*

## PDF page 52

*Paper: small yellow lined sheet (half-size pad); pencil.*

*Build BEU Channel Tables* (written at a slant, underlined)

```text
BLDSEL    50 +      61      63      69
BLDCL     49 +      60      62      70
BLDOP     48 +      59      61      68
BLDCH     55 +      66      68      71
BLDCHT    13 +      13      13      14
         -----     ----    ----    ----
          217 +    259     267     292
```

```text
TMX ©    12

AROS/LROS control passer   75

BLDSCT   121
ERRS
ERRT      14
calls  ~~148[?]~~ 6
```

```text
 150        154        154
 225        259        292
----       ----       ----
 375        413        446
             12        121
            ----      -----
            425        567
              8         14
            ----      -----
            433        581
                          6
                      -----
                        587[?]
```

> *Transcriber's note:* The sheet has heavy show-through from the reverse (mirrored marks behind the labels, around "66", and to the right of the title); these are not transcribed. The "150 / 225 / 375" column is fainter than the other two.

## PDF page 53 — BUILD SYSCON TABLE

*Paper: yellow lined (legal pad); pencil.*

*[Diagonal note, top right:]* end of SYSCON should be noted by a 80 H

BUILD SYSCON TABLE

```asm
BLDSCT: LD (SYSCON), HL
        LD (MXBANK), 0
```

*(A) — circled, at this point in the left column; a curved line runs from it up to the POLLEB block at upper right (see side block below).*

```asm
        INC (IY-Y[?] + MXBANK)
        LD D, ABN
        LD E, (MXBANK)
        CALL Write-BS-Reg
        LD C, (MAXBANK)         ; [A of MAXBANK darkened/written in]
        LD (HL), C              ; assume HL pts to next SYSCON record
        INC HL                  ; fill in SYSCON record
        LD D, 255               ; [inserted from margin]
        LD E, MXBANK
        PUSH DE
        PUSH HL
        LD DE, 0
        PUSH DE
        LD DE, 22
        PUSH DE
        LD DE, 1
        PUSH DE
        CALL XFER_BYTES         ; [struck/erased comment: illegible, ~4 items]
        LD DE, 6
        ADD HL, DE
        LD A, (HL)
        RRA                     ; [struck: CP 0]
        JR [NE? C? NC?], L2         ; jump if device type = bootable
        LD B, (MXBANK)
        LD C, 00001000B
        DEC HL                  ; get addr of init routine
        DEC HL
        LD E, (HL)
        DEC HL
        LD D, (HL)
        LD H, D
        LD L, E
        CALL CALL-BANK
L2:     LD A, 2                 ; write init done
        OUT (BCMDPT), A
        JR POLLEB
```

Side block (upper right; curved line from circled A):

```asm
        LD E, 6
        OUT (BCMDPT), E
POLLEB: IN A (BDATPT)           ; read status
        CP FFh
        JR Z, L3                ; [was L2]
```

> *Transcriber's note:* "LD D, ABN" and "LD E, (MXBANK)" are squeezed in small above "CALL Write-BS-Reg", which is fainter than the surrounding lines. The margin block (LD D,255 … PUSH DE) is enclosed by a bracket whose line runs to the left of "CALL XFER_BYTES"; it is placed there. In "LD D, 255" the comma/D is overwritten; "22" in "LD DE, 22" is darkened. The condition on "JR …, L2" is heavily overwritten — a thin "N" with a bold "E"/"C" over it; final reading uncertain.

## PDF page 54

*Paper: yellow lined (legal pad); pencil, very faint.*

```text
000000[0 written over 1?]1        1 on[?] 3
```

> *Transcriber's note:* Nearly blank sheet. Under enhancement, one line at mid-page reads left-to-right (not mirrored), so it is real writing: six very faint zeros, then a darker small "0" above a "1", then "1" (the last characters underlined), and to the right "1 on 3". A single "Ɛ"-shaped mark at upper left is mirror-reversed show-through (it matches the bold "3" of "JR Z, L3" on PDF page 53).

## PDF page 55 — (A)

*Paper: yellow lined (legal pad); pencil.*

(A) *(circled, top left)*

```asm
        LD D, 255               ; Load AROS into SYSCON
        LD E, 0
        PUSH DE
        LD D, 80h               ; [D written as DE, E smudged out; struck after 80h: illegible]
        PUSH DE
        INC HL
        PUSH HL
        LD DE, 6                ; [6 darkened/written over]
        PUSH DE
        LD DE, 1
        PUSH DE
        CALL XFER-BYTES
        INC HL                  ; load LROS into SYSCON
        LD D, 255
        LD E, 0
        PUSH DE
        LD DE, 0
        INC HL
        PUSH HL
        LD DE, 5
        PUSH DE
        LD DE, 1
        PUSH DE
        CALL X-FER-BYTES
```

## PDF page 56

*Paper: small yellow sheet, unlined, scanned skewed (rotated ~5°); ink.*

> *Transcriber's note:* The whole block is cancelled by large loose looping scribbles drawn across it. The first line has a horizontal line drawn through `WHO:` and `POP`. The rest of the sheet is blank.

```asm
WHO:    POP     BC              ; get bank to boot      [line drawn through "WHO: POP"]
        LD      A,255
        CP      B
        JR      Z,LED18         ; boot TS2000 - jump back to home ROM
; [struck: LD HL,(5[?]5[?][illegible])]
; [struck: LD DE,[illegible]]
```

## PDF page 57 — Initializing banks

*Paper: yellow lined; ink.*

```text
Initializing banks
    do reset cmd
    repeat    (* assign bank #'s *)
        read status
        write bank # to Hold reg
        dump to ABN
        do init_done cmd
    Until status = FF
    init RAMs
    call RAMs init .
    boot highest priority device
```

> *Transcriber's note:* The words "not quite" (underlined) are written diagonally in the left margin next to "dump to ABN" / "do init_done cmd". A line runs down the right side of the block and under it, closing it off from the notes on the right.

Struck notes beside "write bank # to Hold reg" and "dump to ABN":
~~(write reg 2 - write hold reg ms nybble~~
~~3 - " " " ls " )~~
~~(write reg 1)~~
From the struck "(write reg 1)", an arrow points down to:

To write to ABN do CALL Write_BS_Reg (ABN, bank#)

There are ~~[blotted]~~ cmd registers 0-3

```text
write reg 0 : least sig. nybble of cmd
        bit 0 - active low  reset
            1 - BUSACK Enable  active high
            2 - active low  init_done
            3 - not used
write reg 1 : most sig. nybble of cmd
        bit 0 - dump to ABN (assigned bank #)
            1 -  "   "  BNA  (bank # accessed)
            2 -  "   "  HS   (horizontal select register)
            3 - not used
read reg 0:  status
        bit 0 - reads back BUSACK enable  active high
            1 - device type
            2 - low if bank responding
            3 - not used
```

> *Transcriber's note:* "reset" (reg 0 bit 0) is written small and raised after "active low". The two "active high" notes were written in a different, cursive hand.

## PDF page 58

*Paper: yellow lined.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* With contrast enhanced, the marks are a mirror image of PDF page 57 ("Initializing banks", the reg 0/1 bit lists). No real writing reads left to right.

## PDF page 59

*Paper: yellow lined; ink, with some lighter pencil lines.*

Polling devices is done by sending status requests to various ports.
If FF is returned there is no device
  Else there is a device & a [inserted above: device id containing] device type code is returned
      This device type = 1 if the device has an init routine
          that returns ; = 0 if not
      If = 1 then call the init routine (which fills in
            rest of the SYSCON table info)
  When SYSCON table is complete
      ~~[blotted]~~ build channel table
  Then, ~~if any device~~
      pass control to highest priority device  (This may be the TS2000)
        (LROS, maybe AROS, maybe floppy drive)   (after © msg., I guess)

Bank #'s are assigned
    largest one is stored in sys.var.

*(pencil, lighter:)* if there is room  (this will not be in final code)

describe test routine to dump tables to printer
  *(pencil, lighter:)* done right after printer stream opened

RAM test any RAM cards on External banks
  *(pencil, small:)* shouldn't this be part of init routine of card

Diagonal note at right, set off by a line:

```text
To set up for
 jump by testing
  BIT in flag requires
   15 bytes; adding
    SEARCH2 requires
     [blotted]12 bytes.
       Testing a[?] was
        21 bytes
```

for Search2: maybe use same code but throw in check to see what kind of table is being
[illegible mark] searched, if for new tables jump to before our jump which will do 2 INC HL's.

> *Transcriber's note:* The left margin has pencil doodles (shaded shapes, a loop pointing at "describe test routine"). In "SEARCH2" the letter after "SE" is overwritten.

## PDF page 60

*Paper: yellow lined.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* With contrast enhanced, the marks are a mirror image of PDF page 59 ("Polling devices is done by...", the diagonal "To set up for jump..." note, "for Search2: ...").

## PDF page 61

*Paper: yellow lined; ink.*

what info is in a device id?
What are the port ids for BEU?
  How is boot addr determined?
How is bank # determined *(small)*

Diagonal note (written slanting up to the right):

```text
in CHANS for close & Open
& in EDIT for Select
Upon return from Search
check carry flag. If 0
call Search2
[blotted] ~~JR NC, [ERFF? ERRF?]~~  (if no carry, invalid device)
[blotted] GOTO_bank (Bank #, addr)
```

> *Transcriber's note:* The "2" of "Search2" is written heavily, possibly over another character. A line runs from the struck `JR NC` line down to the list below.

```text
Open  - [ERFF? ERRF?]         ["Open" written over struck "Select"]
Close - no check
Select - ERR0[?]              [struck: illegible; the last character is heavily written/boxed]
```

```text
MAX_BANK := 0;                [0 written over a struck value]
write reset cmd to cmdreg 0
For each device port                       ┐
  begin                                    │
    send status request                    │  Build
    If FF is returned                      │  SYSCON
       Then there is no device             │
          fill in SYSCON entry ; INC MAX_BANK
       Else if device type = 1             │
            then call init routine         │
              (which fills in rest of SYSCON entry)
              (Call Bank (MAX_BANK, bootaddr))
  end                                      ┘
write init-done cmd to cmd reg 0
Build channel tables
Pass control to highest pri device
      (perhaps by Call_Bank (bank #, addr)
```

At right: Call Write_BS_Reg (ABN, MAX_BANK)

> *Transcriber's note:* A bracket in the left margin, labelled "Build SYSCON", encloses "For each device port" through "end". "fill in SYSCON entry ;" is squeezed in between the "Then there is no device" and "Else if" lines, and a small arrow from beside "Then" points to it. A wavy line runs from "Call Write_BS_Reg (ABN, MAX_BANK)" leftward along "If FF is returned" to this arrow. A second curved arrow runs from the same note down to "INC MAX_BANK". "end" and "write init-done cmd..." are joined by a hooked stroke.

For testing, dump SYSCON & channel tables to printer
  before passing control

Arithmetic column in the left margin (written slanting):

```text
 14
  8[?]          [digit overwritten]
----
112   SYSCON
[blot]43   BEU_CH
 29   BEUSEL
 29   BEU_OP
 29   BEU_CL
----
242
 11
----
253
182
----
435             [first digit overwritten]
  3
----
438
```

## PDF page 62

*Paper: yellow lined.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* With contrast enhanced, the marks are a mirror image of PDF page 61: the questions at the top, the diagonal note, the "Build SYSCON" pseudocode and the arithmetic column.

## PDF page 63 — Build BEU Channel Table

*Paper: yellow lined; pencil (code, lower notes) and ink (right-hand notes, "255", "dock bank 0").*

```asm
Build BEU Channel Table
        LD      (BEU_CH),HL
        LD      B,0
        LD      A,MAX_BANK
        CP      B
        JR
```

At right (ink):
dumb device I/O ports
int : memory mapped *(runs off the right edge of the page)*
        (bank) *(written under "memory")*

home bank is always bank ~~0~~ 255
                    dock bank 0

At channel data address is
    device spec
    output routine addr
    input routine addr

    if no AROS in dock bank
      then while checking other banks
         if nothing at 0000 [inserted above: & AROS not found], check 8000

> *Transcriber's note:* The page also has a small shaded doodle below the last note.

## PDF page 64

*Paper: yellow lined; pencil (scratch arithmetic, written upside down).*

> *Transcriber's note:* The upper part of this side has only mirror-image show-through of PDF page 63 ("dumb device I/O ports", "int : memory mapped", "home bank is always bank 255 / dock bank 0"). The lower part has real, faint pencil arithmetic written upside down relative to the scan. It reads correctly when rotated 180° and is not mirrored. The groups below are transcribed in the rotated orientation, roughly left to right. Many figures are slanted.

```text
     14
 25)360
    25
    ---
    110
    100

 14        12
 14         12
 14          12
 ---          3
 42[?]

 14
 14
 12
 ---
 40

    27.7
 13)360
    26
    ---
    100
     91
     ---
     90[?]

 12·25 = 300
 2[?]·30 =  60
           360

 180       210[?]
 175[?]    150
 ---       ---
 355       360

 10

   4
  )120          [division sign drawn with 120; a small mark beside it]

 4[?]     8
 9        8[?]
 9        4[?]
 9        4[?]
 3        8

     9[?]
 25)240
    225
    ---
     15
```

## PDF page 65 — STRMS

*Paper: yellow lined; pencil.*

```text
STRMS    1    (-3)          (CHANS_) <- CHINIT
         6    (-2)                cmd
                                stream #0 is  'K'    ["cmd" written above "stream"; "stream" has overwritten letters]
        11    (-1)     initially device #1 is  'K'
         1    (0)                        #2 is  'S'
         1    (1)                        #3 is  'p'
         6    (2)
        16    (3)
```

OPEN & CLOSE routines in int. dev.
  may allocate/deallocate buffers[mark]
  Current hid & std streams don't

> *Transcriber's note:* Faint, apparently erased pencil marks sit to the left of and below the "may allocate" lines: "A:1[?]", "111[?]", a struck "JR[?]", and "BC". There is also a scribbled doodle below them.

Close std str puts initial values into ~~CHANS~~ STRMS
Close non-std str puts 0 into ~~CHANS_~~ STRMS

STRMS contains room for HIDSTR + 16 streams (2 byte stream data)

*[Diagram: a long, narrow row of cells labelled -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, . . . , 15. A heavy divider separates cells 3 and 4. There is an up-arrow above cell -1, and arrows below cells -3 (faint), 3 and 6.]*

At right of diagram:

```text
contains [blotted]E = channel addr (i.e. offset
                         from CHANS_
                              [struck: illegible]
                      or BEU_CH   D=0
                              [struck: illegible]
                                  D=1
```

  search SPEC_T
    if not found search BEU_OP , put offset from BEU_CH into E, ~~[illegible] into D~~ 1 into D

(1) *(circled, in the left margin)* ~~BEU_OP can be built with device spec & offset from BEU_CH~~

GETSTM returns contents of STRMS [inserted above: in BC] pointed at by HL

*(margin: "select" above the label; "30+" to the left of the byte-count column)*

```asm
LST2:   2  CP     0                   ; D is already in A      [struck: blotted character before 0]
        3  JR     Z,LST2+3            ; if D=0 search table SELTAB ; load (CHANS_) to HL    [struck: CHANS]  ["Z" and "3" overwritten]
        1  LD     HL,(BEU_CH)         ; else search table BEUSEL ; HL := (BEU_CH)
        1  DEC    D
        1  ADD    HL,DE               ; HL pts to selected channel data^ in table BEU_CH   [inserted above caret: bank#, over a struck word]
        3  LD     (CURCHL),HL
        4  RES    RETPOS[?],(IY+FLAGS2)
        5  INC    HL  5 times         ; to pt. to device spec
```

> *Transcriber's note:* The numbers before the mnemonics (2, 3, 1, 1, 1, 3, 4, 5) are Lon's, written in a column left of the code. The "3" of the `LD (CURCHL),HL` line may be written over another digit. One more line at the very bottom is cut off by the page edge, with only the tops of the characters visible. It reads approximately: `[?]+ LD C,(HL)  ...  LD HL,BEUSEL  = CALL SEARCH2 = RET NC = etc. = [struck: illegible] CALL BANK = RE[...]` ("CALL" written above the struck word).

## PDF page 66

*Paper: yellow lined; —.*

*(Blank page.)*

> *Transcriber's note:* Checked with contrast enhancement and background flattening. There are only a couple of stray specks and a dark mark along the top edge (scan/binding). No pencil writing and no show-through could be seen.

## PDF page 67 — Search3 / Close (CLCHAN)

*Paper: yellow lined; pencil.*

Search3 to search BEU-CH ; input C=dev. spec.
24 bytes      returns offset of device data from BEU-CH in DE

> *Transcriber's note:* Under "DE", at the right margin, the letters F, E, D, C, B are written in a vertical column.

```asm
SEARCH3:
3           LD HL, (BEU-CH)          3 LD DE, 0      ; [struck: 0FBh?]
            INC HL - 5 times                         ; [struck: INC?]
1   LI:     LD A, (HL)
1           AND A
1           RET Z
1           CP C
            INC HL - INC DE                          ; [written small between CP C and JR NZ]
2           JR NZ, LI
            ; [struck: INC HL  INC[?] ...]
10          INC HL                   INC DE
            INC HL                   INC DE
            INC HL                   INC DE
            INC HL                   INC DE
            INC HL                   INC DE
            ; [struck: JR LI?]
            ; [struck: DEC HL]
            ; [struck: DEC HL]
            ; [struck: DEC HL]
            ; [struck: DEC HL]
            ; [struck: DEC HL]
1           SCF
1           RET
```

> *Transcriber's note:* The numbers in the left column are Lon's byte counts. "LI" might be "L1"; it reads as LI both times. There is a heavy scribble just left of the "INC HL - 5 times" line, beside the label. From that scribble a line curves down to a brace that groups the five INC HL / INC DE lines, and the brace is labelled "10". A line also runs from the brace across the top of the INC DE column. The five DEC HL lines are hatched and crossed with a large X. Two long, faint diagonal lines form a large "V" over the code: one runs from "SEARCH3:" and one from the "3 LD DE" area, and they meet near the JR NZ line. A further faint diagonal runs down past SCF/RET.

Pseudocode at right (middle of page), left part:

```text
DE := 0
HL := HL+5
WHILE cond
  HL := HL+6
  DE := DE+6
end
```

Right part:

```text
HL := (BEU-CH)
~~DE := FBh~~
~~[illegible, heavily struck line]~~
~~REPEAT~~
~~   HL := HL + 5;~~
~~   DE := DE + 6[?];~~
UNTIL (C = (HL) OR (HL)=0)
IF C=(HL)
   THEN set carry flag
   else reset carry flag
```

> *Transcriber's note:* The lines from "DE := FBh" down to "DE := DE + 6;" are hatched and crossed with an X whose lower stroke ends at the "U" of UNTIL. The condition "C = (HL) OR (HL)=0" is circled, and an arrow runs from the circle to "WHILE cond" in the left-hand pseudocode. In "OR (HL)=0" a character before "(HL)" is blotted out.

```text
DE := 0
HL := (BEU-CH)
WHILE C <> (HL+5) AND (HL) <> 0        [AND written above struck: OR]
    HL := HL + 6
    DE := DE + 6
```

How can init read the data from the exp. banks into home RAM?

```text
CALL    5M    17T    8.5 usec
RET     3     10     5
       ----   ----   ----
        8M    27T    13.5 usec
```

Close  33 bytes  CLCHAN

```asm
1           PUSH HL                  ; [inserted above the LD line]
1           LD A, B                  ; [struck: illegible, under "LD"]
2           CP 0                     ; [struck: illegible character before 0]
1           JR NZ, C1
3   C1:     LD HL, (BEU-CL)
            ; [struck: CALL SEARCH2]
```

Continuation (an arrow runs from the end of `LD HL, (BEU-CL)` to this column):

```asm
2           LD B, 0
1           ADD HL, BC
1           INC HL
1           INC HL
1           INC HL
1           INC HL
1           INC HL
1           LD C, (HL)
1           EX DE, HL
```

Side column (a curved line runs from `EX DE, HL` up to the first line here):

```asm
3           LD HL, BEU-CL
3           CALL SEARCH2
2           JR NC, ERRF
1           LD C, (HL)
1           INC HL
3           CALL BANK (C, (HL))
1           POP HL
1           RET                      ; [cut off at bottom edge of page]
```

*[Diagram: a box at the right edge, partly cut off by the page edge:]* "Dock # 0 bank" / "Home # bank 255[?]" (the last digit is cut off at the edge).

> *Transcriber's note:* A dotted vertical line runs down from `JR NZ, C1` to the `LD HL, (BEU-CL)` line. A dashed vertical line runs down the byte-count column of the continuation column.

## PDF page 68 — timing comparisons (faint, written at an angle)

*Paper: yellow lined; pencil (very faint).*

> *Transcriber's note:* This page is very faint. After enhancement it is real pencil writing, not show-through: it reads normally left to right and is not mirrored. Everything is written at an angle, rising about 25–30° to the right, in the top third of the page. The rest of the page is blank.

Left group:

```text
3   LD DE, 5

    3  10  5
    6  22  10.5
```

Middle group:

```text
2   LD D, 0
2   LD E, 5
1   ADD HL, DE

5
    4  14   7
    3  11   5.5
    ------------
    7  25  12.5
```

Right group:

```text
          DEC HL 5 times
1  OR
3   LD HL, (BEU-CH)
1   ADD HL, DE

    3  11   5.5
    6  20  10[?]
    ------------
    9  31  15.5
    5  30  15
```

> *Transcriber's note:* A few long diagonal pencil strokes run through the right group's figures. At the right edge, about one-fifth of the way down, there is a box with only its left side drawn. Inside are two "#" marks and no other legible text. It looks similar to the "Dock # / Home #" box on page 67 but sits in a different position.

## PDF page 69 — SYS VARS / memory map / CALLCB

*Paper: yellow lined; pencil.*

SYS VARS

```asm
MSTEND   EQU 6000H
MSTBOT   EQU DEST + 2       (or somewhere - 2 bytes)
BSWEND   EQU MSTBOT + 2     (2 bytes - indicates end of bank sw. code)
```

*[Diagram: horizontal memory map, left to right.]*

```text
| D-File   | Sys Vars    | machine | bank   |          |          |
|  <--     |   &         |  stack  | switch |          |          |
| Attrs    | print.buf.  |         | code   |          |          |
                        ^          ^        ^   ^                ^
                      6000h      MSTBOT     |  DRIVES . . .    7FFFh
                      MSTEND           BSWEND
```

> *Transcriber's note:* In the map, an arrow under "D-File" points left. Just before "BSWEND" there is a struck-out label (`[struck: illegible, ~2 chars]`).

```asm
        LD HL, whatever                 ; [looping scribble across this line - struck?]
        LD (MSTBOT), HL                 ; [struck: whatever] [looping scribble across this line - struck?]
        DEC HL
        LD SP, HL
        DEC HL
        DEC HL
        LD (ERR-SP), HL
```

A brace to the right of these lines groups them, with this note:

inserted at NEW of EDIT

bank switch code should be LDIR 'd on power up only (447-45[cut off at page edge]

> *Transcriber's note:* A wavy line across the full width of the page divides it here. It ends in an arrow pointing back toward the left.

```asm
CALLCB:     LD C, (HL)
10 bytes    INC HL
            LD D, (HL)
            INC HL
            LD E, (HL)
            LD HL, (DE)
            CALL CALL-BANK
            RET
```

using this saves a total of 8 byt[es — cut off at page edge]
but overhead timing is
    8M, 27T, 13.5 usec

Consequently, don't use unless
  have to squeeze bytes

## PDF page 70

*Paper: yellow lined; —.*

*(Blank page.)*

> *Transcriber's note:* Checked with contrast enhancement and background flattening. There are only stray specks near the top. No pencil writing and no mirrored show-through could be seen.

## PDF page 71 — BUILD CHANNEL TABLES (BLDCHT)

*Paper: yellow lined; pencil.*

BUILD CHANNEL TABLES

```asm
BLDCHT:
            LD (BEU-CH), HL
            PUSH HL
            LD C, 1                          ; [C written heavily over another letter, B?]

            LD HL, SYSCON
            LD DE, EBSTRT
            ADD HL, DE                       ; DE pts to bank 1 info of syscon
BLDCH:      EX DE, HL
            LD A, (DE)
            CP 0
2           JR Z, BLDOP

            POP HL                           ; HL= loc in BEU-CH
2           LD DE, 9
            LD (HL), B
            INC HL                           ; set DE = output addr   [struck: INC DE (9 times)]
3           XFER (C, DE, 255, HL, 2)         ; output addr
            INC HL
            INC HL
            LD DE, 7                         ; [struck: DEC DE] [struck: DEC DE]
3           XFER (C, DE, 255, HL, 2)         ; input addr
            INC HL
            INC HL
            LD DE, 0
            ; [struck: DEC DE (7 times)]
3           XFER (C, DE, 255, HL, 1)         ; dev. spec
            INC HL
            INC C
            PUSH HL
            EX DE, HL
3           LD DE, EBSIZE
            ADD HL, DE
            EX DE, HL
2           JR BLDCH
```

> *Transcriber's note:* The label "BLDCH:" is written in the left margin. A curved line runs from it past the left of `ADD HL, DE` toward `EX DE, HL`. Below the label, the margin has a struck-out mark (`[struck: illegible]`) followed by "80[? go?]". The two "DEC DE" lines are crossed with an X, and "LD DE, 7" is written beside them.

Side note (bracket at right with lines to the three XFER set-ups):

```asm
            LD B, 255
            PUSH BC
            PUSH HL
            PUSH DE
            LD DE, 2
            PUSH DE
            LD DE, 1
            PUSH DE
```

> *Transcriber's note:* Three lines lead from the bracket to the code at left. One curves into a heavy line under `INC HL` / above the first XFER, ending in an arrowhead. One runs to `LD DE, 7`. One runs to the end of the struck `DEC DE (7 times)` line.

Top-right notes (pencil, partly very faint):

```text
FOR m=1 TO MXBANK
    FILL BEU-CH
FOR m=1 TO MXBANK          [very faint]
    FILL BEU-OP
```

Right-margin notes (written at an angle):

AROS & LROS
LANGUAGES
NOT SAME

IMPROPER
AROS OR LROS

INCOMPATABLE
~~[illegible, 1 word]~~
IMPROPER
AROS/LROS

## PDF page 72

*Paper: yellow lined; —.*

*(Blank page.)*

> *Transcriber's note:* Checked with contrast enhancement and background flattening. There are only stray specks and a short stray mark near the top-left. No pencil writing and no mirrored show-through could be seen.

## PDF page 73 — POLLEB

*Paper: yellow lined; pencil (faint).*

```asm
            LD E, 6
            OUT (BCMDPT), E
POLLEB:     IN (BDATPT), A
            CP FFh
            JR Z, NO DEV
```

> *Transcriber's note:* The rest of the page is blank. The writing is upright, reads normally left to right and is not mirrored.

## PDF page 74

*Paper: yellow lined; —.*

*(Blank page.)*

> *Transcriber's note:* Checked with contrast enhancement and background flattening. There are only stray specks. No pencil writing and no mirrored show-through could be seen.

## PDF page 75 — LSC2 / LSC3 / LSC4

*Paper: yellow lined; pencil (faint).*

```asm
LSC2:       ;
            EX DE, HL
            LD A, (CURCBN)
            CP 0
            JR NZ, LSC3
            CALL JP-HL
            JR LSC4
LSC3:                                    ; do CALL-BANK
            LD B, A                      ; put bank# in B
            LD C, ?                      ; put chunk in C
            CALL CALL-BANK
LSC4:       POP HL
            EXX
            RET
```

> *Transcriber's note:* The "?" in `LD C, ?` is Lon's. There is a stray ")" mark between `LD B, A` and its comment. The rest of the page is blank.

## PDF page 76

*Paper: yellow lined; no writing.*

*(Blank page.)*

## PDF page 77

*Paper: white lined (punched), with a second lined sheet overlapping the lower part of the scan; pencil.*

> *Transcriber's note:* The upper part (pseudocode, down to the final `END`) is on one sheet. Below a torn/stained edge, the `A' := I` … `JR NZ, CHUNK` material appears to be on a second lined sheet lying under/over the first in the scan.

```text
DEST := 0;
FOR I := 1 TO 7 DO
  BEGIN DEST := DEST + 2000H
                     SRC        DEST        SRC
     XFER-BYTES (254, MAX-BANK, POLLEB, DEST, ...)
     XFER-BYTES (MAX-BANK, 255, DEST, TEMP, ...)
     IF (TEMP) <> (POLLEB)
        THEN  RESET BIT I, CHUNK-SPEC
        ELSE BEGIN
                 XFER_BYTES (254, MAX_BANK, EXINIT, DEST, ...)
                 XFER-BYTES (MAX-BANK, 255, DEST, TEMP, ...)
                 IF (TEMP) = (EXINIT)
                    THEN  SET  BIT I, CHUNK_SPEC
                    ELSE  RESET  BIT I, CHUNK_SPEC
             END
  END
```

> *Transcriber's note:* `DEST := DEST + 2000H` is written small, squeezed in on the `BEGIN` line. The labels `SRC`, `DEST`, `SRC` are written small above the first three arguments of the first `XFER-BYTES` (above `254`, `MAX-BANK`, `POLLEB`). A blotted character precedes `255` in the second `XFER-BYTES` line (`[blot]255`). Lon mixes `XFER-BYTES`/`XFER_BYTES`, `MAX-BANK`/`MAX_BANK`, `CHUNK-SPEC`/`CHUNK_SPEC`; kept as written.

```text
A' := I
HL := TEMP
```

```asm
        LD DE, 0
        LD A, 1
CHUNK:  EX AF, AF'              ; [struck: a blotted character before the label]
        PUSH HL
        EX DE, HL
        LD DE, 2000H
        ADD HL, DE
        EX DE, HL
        POP HL
        XFER
        XFER
        CP
        IF THEN EX AF, AF'
                RES A, CHSP
          ELSE  XFER
                XFER
                EX AF, AF'
        INC A
        CP 8
        JR NZ, CHUNK
```

Side note (right of `LD DE, 0` / `LD A, 1`):

```text
  0
  1
[blot] 2 - HL
```

## PDF page 78

*Paper: white lined (punched), with a second lined sheet overlapping the lower part of the scan; pencil.*

have chunk # in A

```asm
        CP 1
        JR NZ, STEST2
        SET 1, b                ; [struck: a blotted character before b]
        JR SNXTCH               ; [third letter overwritten; reads SNXTCH]
STEST2: CP 2
        JR NZ, STEST3
        SET 2, b
        JR SNXTCH
          :
          :
```

Side note (right side, written at an angle):

```text
[blotted mark]  DRIVES
                to DRIVES + BC

LD HL, DRIVES
ADD HL, BC
EX DE, HL
LD HL, DRIVES
LDIR
```

> *Transcriber's note:* The `X` in `EX DE, HL` in the side note is heavily inked, possibly a correction. The lower part of the page, on the second sheet, is ruled but has no writing.

## PDF page 79 — Build_System_Configuration_Table

*Paper: typed sheet; handwritten annotations in blue ink and pencil.*

!Build_System_Configuration_Table [handwritten: "space", arrow to the `!`]

Inputs

HL - the location of the table (to be stored in SYSCON).

Outputs

HL - first available location after the table.

Globals Accessed

None. [handwritten: capital `N` written over the typed lowercase `n`]

Globals Modified

SYSCON.
MAX_BANK.

Services Called

Write_BS_Reg.
Call_Bank.

Services Called By

Init in module Edit

Processing

```text
SYSCON := (HL)
MAX_BANK := 0                                     [struck: FFh]
Write reset command to register 0
For each expansion slot do                        [struck: device port]
   begin
      read status
      if FF is returned
         then there is no device
         else begin
                 increment MAX_BANK
                 Write_BS_Reg(ABN, MAX_BANK)
                 fill in SYSCON entry (bank #, boot addr, boot prior)
                 if device has an initialization routine that returns
                    then
                       Call_Bank(MAX_BANK, device init addr)   [struck: boot]
              end (* else *)
   end (* for *)
Write init_done command to command register 0
```

> *Transcriber's note:* In the `then` line, the typed `(* device fills in rest of SYSCON entry *)` is struck through. `0` in `MAX_BANK := 0` is a handwritten slashed zero; `expansion slot` and `init` are handwritten in pencil.

**Handwritten annotations:**

- Left margin beside Inputs/Outputs, blue ink, heavily scribbled out with loops: ~~How about symbolic names~~, with arrows to the `HL` in Inputs and the `HL` in Outputs.
- Blue ink: "another blank line", with arrows pointing to the gaps before `Outputs`, `Globals Accessed`, and `Globals Modified`.
- Blue ink under "Services Called": a down-arrow, a mark resembling `≡`/`3` [?], and "etc".
- Pencil, running from the left margin across the line above `SYSCON := (HL)`: "poll dock bank & fill in AROS/LROS entries of ~~[illegible]~~ SYSCON table". After it, a diagonal pencil phrase is struck through: ~~[illegible, ~3 words; possibly "poll dock bank"]~~.
- Pencil, left margin below that: "if AROS / then if LROS / then / as spec'd". A pencil line runs down the left margin from this note and ends in an arrow pointing right, below the last typed line.
- Blue ink: a curved arrow mark at the left of `end (* for *)` / `Write init_done ...`.

## PDF page 80

*Paper: typed sheet (reverse side); no writing.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

## PDF page 81 — Build BEU channel table

*Paper: typed sheet; handwritten annotations in blue ink, pencil and black ink.*

!!Build BEU channel table [handwritten: "space", arrow to the `!!`]

Inputs

HL - starting location of channel tables.

Outputs

HL - ending location of channel tables + 1.

Globals Accessed

SYSCON. [handwritten to the right, struck/scribbled out: ~~BEU_OP[?]~~]

Globals Modified

BEU_CH.
BEUSEL.
BEU_OP.
BEU_CL.

Services Called

none.

Services Called By

Init in module Edit.

Processing

HL is loaded into BEU_CH. Then for each device present on the BEU, the device spec, bank number, and channel data address go into the table. Similarly for select, open, and close. [handwritten, pencil: `X`]

[handwritten, blue: "channel data address go into the" is underlined; arrow from "table." to the note "tell how it gets there"]

!!Channels [handwritten, blue: arrow from left margin → "pg brk"]

To accomodate the BEU device channel tables, ~~a~~ [handwritten: 2] new search routine[handwritten: s] ~~is~~ [handwritten: are] needed. [handwritten: "+ changes to open, select, close"] ~~Search is called by the Select, Open, and Close routines.~~ Upon return from Search the carry flag is set if a match was found. Otherwise, Search2 is called. If this returns with the carry flag set, control is passed to the found routine via ~~GOTO~~[handwritten below: CALL]_BANK(bank #, addr). If the carry flag is not set an invalid device was specified and control is passed to the appropriate error routine.

> *Transcriber's note:* The sentence "Search is called by the Select, Open, and Close routines." has a wavy pencil line through it. Typed "accomodate" is kept as typed.

**Handwritten annotations:**

- Right side, pencil, diagonal: "info comes from expansion bank except for bank #"
- Below that, pencil, a series of diagonal notes:

```text
BEU_CH gets  bank #
             dev spec
             input addr      [a curved two-headed arrow links "input addr" and "output addr"]
             output addr
BEU_OP gets  dev spec
             bank #
             open addr
BEU_SEL gets dev spec
             bank #
             select addr
BEU_CL gets  dev spec
             bank #
             close addr
```

- Left margin, pencil, with a bracket spanning the Channels paragraph: "work this into an individual description for all 3 (S,O,C)"

Below the typed text, pencil:

Open - if not found in Search, call Search2 on BEU-OP.

```asm
3       Call Search BEU_CH
2       JR NC, ERRF
1       LD D, 1
1       POP BC
1       DEC BC
1       LD A, B
1       OR C
2       JR NZ, ERRF
        ; [struck: illegible scribbled-out line]
```

Second column (to the right of the "Open -" line):

```asm
2       JR NC, ERRF             ; [heavy line through/under "JR NC"; possibly struck]
1       LD C, (HL)              ; [inserted from margin] [struck: blotted marks above LD, before C, and after the comma; (HL) written above]
1       INC HL
3       CALL BANK (bank#, (HL)) ; call device's open routine (must preserve DE)
1       POP HL
1       RET
```

> *Transcriber's note:* The small numerals at the left of each instruction (1, 2, 3) are written by Lon. `LD C, (HL)` / `INC HL` are written above, with a line drawn to the point after `JR NC, ERRF`. A heavily inked `C` is written below `bank#` in the `CALL BANK` line.

Left column (pencil, bottom left):

Open puts channel info into the streams data (STRMS) & ~~[illegible]~~ calls open routine in intelligent devices

Select uses the stream data to determine current I/O channel

Close ~~removes~~ [zeroes] data from STRMS or reinitializes if std stream.

## PDF page 82

*Paper: typed sheet (reverse side); no writing.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

## PDF page 83 — Initialization

*Paper: typed sheet; handwritten annotations in blue ink, pencil and dark ink.*

!!Initialization [handwritten, blue: "space", arrow to the `!!`; also "!␣Introduction", arrow pointing to the line below the heading]

The TS 2000 undergoes an initialization procedure upon power up. With the addition of the Bus Expansion Unit changes have to be made to allow for the new devices and bank switching.

This section describes the additions and modifications to the Edit module. [handwritten: "& Init"] These are the addition of a System Configuration Table, channel data tables, and some new system variables.

The new system variables are: [handwritten, blue: "blank line", arrow pointing between this line and `SYSCON`]

```text
     SYSCON - address of the System Configuration Table
     BEU_CH - address of channel information table for BEU devices
     (equivalent of CHINIT)
     BEUSEL - address of table of BEU device dependent initialization
     routines (equivalent of SELTAB)
     BEU_OP - address of table of BEU device stream open routines
     (equivalent of SPEC_T)
     BEU_CL - address of table of BEU device strean close routines
     (equivalent of CL_TAB)
     MAX_BANK - the largest bank number that has been assigned.
```

The memory map for these tables is thus:

```text
          ...DRIVES ! SYSCON ! BEU_CH ! BEUSEL ! BEU_OP ! BEU_CL ! CHANS...
```

> *Transcriber's note:* A long, faint, curved pencil stroke starts in the left margin, runs under "...DRIVES" and arcs over the rest of this line. It may be a stray mark; it does not strike any text.

The following offsets may be useful in finding the correct locations within the SYSCON table.

```asm
PRES    EQU 0           ;presence flag
BOOTAD  EQU 2           ;boot address                              [was 1]
LANG    EQU 1           ;language (AROS and LROS only)             [was 3]
SIZ     EQU 4           ;size of AROS or LROS                      [was 5?]
BANKNO  EQU 6                                                       ; [inserted from margin]
                        ;The following are for BEU devices only
PRI     EQU 16          ;boot priority                             [was 3]
; [struck: EBCH    EQU 4           ;channel data address]
EBSEL   EQU 5           ;select initialization routine address     [was 6]
EBSTOP  EQU 1           ;stream open address                       [was 8]
EBSTCL  EQU 3           ;stream close address                      [was 10]
EBIH    EQU 11          ;interrupt handler address                 [was 12]
AROSLO  EQU 0           ;offset of AROS
LROSLO  EQU 6           ;offset of LROS                            [was 7?]
EBSIZE  EQU             ;size of BEU device information            [struck: 14]
EBSTRT  EQU 19/13                                                   ; [inserted from margin]
```

> *Transcriber's note:* All the handwritten values are written over or beside the struck typed values. `BANKNO EQU 6` is written small in pencil, with an arrow pointing to the space after `SIZ`. `EBSTRT EQU` is written below the `EBSIZE` line, followed by `19` and `13` stacked one above the other. It is unclear whether one replaces the other, and whether `19` belongs to `EBSIZE`. A large pencil X runs through the words "address" in the `EBCH`–`EBSTCL` comments. A brace groups `AROSLO`, `LROSLO` and `EBSIZE`, and a dark-ink line runs from it up the left side to an arrow at `PRES`. A large pencil X, with hatching, sits in the left margin beside the system-variable list and the EQU table, and an arrow runs from it to the `BANKNO` line.

Handwritten list to the right of the EQU table:

```text
EBSPEC   0  }
[scribbled-out line]  }
EBCHIN   7  }   X
EBCHOU   9  }
EBRST   17
EBINIT  13
DEVTYP  15
```

The location of the table information pertaining to bank X is offset from SYSCON by X* EBSIZE. [handwritten: `X` bracketed and "(X-1)" written below it; a blot over a character after `X`; "+ EBSTRT" added after `EBSIZE.`]

After the Init routine in module Edit assigns a location to DRIVES, it calls Build_SYSCON_table and Build_BEU_channel_tables. [handwritten: a line under "location to DRIVES, it calls" runs to the right-margin note, and a slash marks this point] After all the initialization is complete, control is passed to the highest priority device. If this device is the TS 2000, control is passed as ~~it~~ is [handwritten, blue: "currently done"] in the Spectrum. If it is some other device (e.g. LROS) control is passed via ~~Call~~[handwritten below: Goto]_Bank(bank #, boot addr).

**Handwritten annotations:**

- Right margin, pencil: "ROS stuff / it then polls the dock bank for LROS/AROS and procedes as specified in TS 2000 System Software Architecture"

## PDF page 84

*Paper: typed sheet (reverse side); no writing.*

*(Blank page.)*

## PDF page 85 — Search2

*Paper: typed sheet; handwritten annotations in blue ink and pencil.*

!Search2

Inputs

C - device spec to be searched for.

HL - address of table to be searched.

Outputs

HL - address of routine to be called.

Globals Accessed

None. [handwritten, blue: capital `N` written over the typed lowercase `n`]

Globals Modified

none.

Services Called

none.

Services Called By

SEL_HL in module Edit. [an ink dot covers the character between "SEL" and "HL"; reading SEL_HL[?]]
CLCHAN in module Chans.
OPCHAN in module Chans.

Processing

On input HL points to the first device spec of a table (either BEUSEL, BEU_OP, or BEU_CL). Zero indicates the end of the table.

```text
while C ≠ (HL) and (HL) ≠ 0 do
   HL := HL + 4
if C = (HL)
   then set carry flag & HL := HL + 1
   else reset carry flag
```

> *Transcriber's note:* `& HL := HL + 1` is handwritten in pencil after "then set carry flag". A pencil loop encloses the note "HL rets[?] pt. to bank #" and connects to it.

~~The only difference between this and procedure Search in module Edit is that HL gets incremented by an additional 2.~~ [struck through with a wavy pencil line]

!!Dump tables to printer [handwritten, blue: arrow from left margin → "pg brk", circled together with the `!!`; "Don't need this if dev. sys. can do it"]

If there is room in the code, a short routine to dump tables SYSCON, BEU_CH, BEUSEL, BEU_OP, and BEU_CL will go into module Edit right after the printer stream is initialized. This is to ensure that the tables are being filled properly. After that is determined this code will be removed.

## PDF page 86

*Paper: plain white sheet.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

> *Transcriber's note:* The show-through is mirror-reversed form headings and lines down the right half of the sheet.

## PDF page 87 — ASSIGN

*Paper: green engineering paper (National 42-381, 5 square), ruled form side with title block; pencil.*

**INPUTS**

None.

**OUTPUTS**

carry flag set if not end of daisy chain
reset if no more exp. banks

**GLOBALS ACCESSED**

MAX_BANK

**GLOBALS MODIFIED**

MAX_BANK
BS_MAX_BANK

**SERVICES CALLED**

Write-BS-Reg
Read-BS-Reg

**Services Called By**

BLDSCT
RESSCT
RENUM-BANKS

**Processing**

```text
inc MAX_BANK & BS-MAX_BANK          [blot after "inc"]
call WRITE-BS-REG (ABN, MAX-BANK)
call WRITE-BS-REG (BNA, MAX-BANK)
call WRITE-BS-REG (HS, 0)
save whatever is at A000h
write 4 to A000h                    [scribbled-out mark after]
call Read-BS-Reg (local status)
if bit 2 set
   then  restore what was at A000h                    (* end of daisy chain *)
         dec MAX-BANK & BS-MAX-BANK
         clear carry flag
         call Write-BS-Reg (CMD, init done)
   else  restore A000h
         set carry flag

END.
```

## PDF page 88

*Paper: green engineering paper, grid side.*

*(Blank page.)*

## PDF page 89 — NEWRAM

*Paper: green engineering paper (National 42-381), ruled form side with title block; pencil.*

**Inputs**

HL pts to pres flag entry

**Outputs**

pres. [&?] chunk-spec in SYSCON table entry

**Globals accessed**

None

**Globals modified**

None

**Services called**

XFER_BYTES

**Services called by**

BLDSCT
RESSCT

**Processing**

```text
mark presence flag as RAM                    [blot before "mark"]
XFER_BYTES 16 bytes of interrupt fielder to 38h of RAM
mark chunk 0 as active in chunk spec
dest := 0
FOR I := 1 to 7 do
  begin
    dest := dest + 2000h
    XFER_BYTES (254, MAX-BANK, ABYTE, dest, ...)
    XFER_BYTES (MAX_BANK, 255, dest, Temprec, ...)
    IF (Temprec) <> (ABYTE)
       THEN RESET BIT I, CHUNK-SPEC
       ELSE begin
               XFER_BYTES (254, MAX-BANK, BBYTE, dest),
               XFER_BYTES (MAX_BANK, 255, dest, Temprec, ...)
               IF (Temprec) = (BBYTE)
                  Then set bit I, CHUNK-SPEC       [letters before "set" scribbled out]
                  Else reset bit I, CHUNK-SPEC
  end        END
  [scribbled-out word under "end"]
```

> *Transcriber's note:* "END" is written to the right of "end" on the same line.

## PDF page 90

*Paper: green engineering paper, grid side.*

*(Blank page.)*

## PDF page 91 — CHIR

*Paper: green engineering paper (National 42-381), ruled form side with title block; pencil.*

**Inputs**

HL pting to bank # entry of SYSCON table entry

**Outputs**

HL pting to next SYSCON entry (bank# entry)

**Globals accessed**

SYSCON table

**Globals modified**

None.

**SERVICES CALLED**

Call_Bank

**SERVICES CALLED BY**

BLDSCT

**Processing**

```text
mark pres. flag as intel. dev.
if device has an initialization routine
   then CALL-BANK to it
set HL to next SYSCON record
```

## PDF page 92

*Paper: green engineering paper, grid side.*

*(Blank page.)*

## PDF page 93 — RENUM-BANKS

*Paper: green engineering paper (National 42-381), ruled form side with title block; pencil.*

**INPUTS**

None

**OUTPUTS**

None

**GLOBALS ACCESSED**

SYSCON

**GLOBALS MODIFIED**

bank # entries in SYSCON table

**SERVICES CALLED**

WRITE-BS_REG
XFER_BYTES
ASSIGN

**SERVICES CALLED BY**

BLDSCT
RESSCT

*(Written to the right of the Processing heading:)*

Renumber exp. banks in order of
interrupt priorities
Banks not yet renumbered have bit 7
of bank# entry set

**Processing**

```text
HL := first exp[?]. bank entry
MAX_BANK := 0
~~While (not end of SYSCON table) and[?] (bit 7 of bank # [illegible]) do~~
While (not end of SYSCON table) & (bit 7 of bank # entry reset) do
    make HL pt to next record
If not end of table
   then begin
          TEMP_REC := addr of bank # entry
          if pres. flag = 2 (RAM)
             then INTPRI := 255
             else INTPRI := int. pri. in SYSCON record
          While (not end of table) do ~~[faint, illegible: "... 7 of bank # ..."]~~
          begin ~~[illegible]~~
              if bit 7 of bank # entry set                         [struck: illegible word at left; "if bit 7 of" written over other letters]
              then if not RAM  (* RAM cannot be higher priority *)  [struck: then be]
                   then if dev. pri < INTPRI
                        then INTPRI := dev. pri.
                             TEMP_REC := addr of bank # entry
                             HL := next record
          end
          INC MAX-BANK
          store MAX_BANK at addr in TEMP_REC  (* bank is now renumbered
          XFER-BYTES bank # to addr 0 of RAM
end
MAX-BANK := 0
BS-MAX-BANK := 0
Call Write-BS-Reg (0, cmd)  (* reset daisy chain *)
HL := bank# entry of first exp. bank
Call ASSIGN
    if not end
      then call Write-BS-Reg (ABN, HL (* new bank# *)
           call Write-BS-Reg (STEP to next bank)
           HL := next record
    end (while)
```

> *Transcriber's note:* "store" is written over an earlier word. The final `end` (left margin) sits level with the "store MAX_BANK" line, and a line runs from it to the XFER-BYTES line. "MAX-BANK := 0" and "BS-MAX-BANK := 0" are small and squeezed in at the margin under that `end`. The block "if not end ... HL := next record" is at the lower right. A long curved line from under "Call ASSIGN" leads up to it, and "end (while)" is written below it at the foot of the sheet.

Side note (left margin, arrowed/bracketed to the HL := first exp. bank entry / MAX_BANK := 0 / struck While lines at the top of Processing):

```text
while not end
  of table
  do begin
```

Side note (left margin, level with the "else INTPRI :=" and second "While" lines; underlined, with a short arrow):

```text
HL := next record
```

Side note (left margin, level with "HL := bank# entry of first exp. bank"):

```text
while not end
```

## PDF page 94

*Paper: green engineering paper, grid side.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

## PDF page 95 — RESSCT

*Paper: green engineering paper (National 42-381), ruled form side with title block; pencil.*

**INPUTS**

None.

**OUTPUTS**

Complete SYSCON table

**GLOBALS ACCESSED**

SYSCON

**GLOBALS MODIFIED**

MAX_BANK
BS-MAX-BANK

**SERVICES CALLED**

| | |
|---|---|
| WRITE_BS_REG | NEWRAM |
| ASSIGN | CHIR |
| XFER_BYTES | RENUM-BANKS |

**SERVICES CALLED BY**

RSET2 (SYNTWO)

**PROCESSING**

```text
             MAX_BANK := 0
             BS-MAX-BANK := 0
             call Write-BS-Reg (reset cmd to enter init mode on BEU)
             HL := first SYSCON record
while not end call ASSIGN
             if not end of daisy chain
                then if end of table
                        then mark next entry as end of table
                     call ASSIGN
                     XFER overhead bytes into Temporary record
                     XFER a diff. byte to device
                     XFER it back
                     if same
                        then if there wasn't RAM here before
                                then call NEWRAM
                        else compare device spec with old device
                             if not same
                                then move overhead bytes from temp rec into SYSCON record
                                     save bank# w/ bit 7 set
                                     call CHIR
                  call Write-BS-Reg (STEP to next exp. bank)
                  HL := next record
end
             mark end of SYSCON table
             call RENUM_BANKS
end
```

> *Transcriber's note:* "while not end" and the first "end" are written in the left margin, outside the ruled line. The last "end" is on the margin line at the foot of the page.

## PDF page 96

*Paper: green engineering paper, grid side.*

*(Blank page.)*

## PDF page 97 — BOOTDEV

*Paper: green engineering paper (National 42-381), ruled form side with title block; pencil.*

> *Transcriber's note:* The title has a check mark after it ("BOOTDEV ✓").

**Inputs**

None

**Outputs**

None

**Globals accessed**

SYSCON table

**Globals modified**

None

**Services called**

GOTO-BANK

**Services called by**

EXINIT

**Processing**

```text
save TS2000 boot addr, bank#, & priority on stack
                LED18[?]    255          128
HL := first SYSCON record
While not end of SYSCON table do
    if device is bootable
       then if boot pri is higher than TOS
               then trash old boot addr from stack
                    & save new boot addr, bank#, & pri on stack
    HL := next record
end (* while *)
Replace priority on stack w/ horizontal select (0 if bank 255; 88 otherwise)
Enable interrupts
call GOTO-BANK
end
```

> *Transcriber's note:* The values LED18[?], 255 and 128 are written small, under "boot addr", "bank#" and "priority". "Replace" is written over an earlier word, and there are small tick marks under "Replace" and "priority".

## PDF page 98

*Paper: green engineering paper, grid side.*

*(Blank page.)*

## PDF page 99 — NOVARS / CONT

*Paper: green engineering paper (National 42-381), ruled form side with title block; pencil.*

**Inputs**

None

**Outputs**

None

**Globals accessed**

None

**Globals modified**

DATADD
PROG
VARS
E-LINE
WORKSP
STKBOT
STKEND
ARSFLG
VIDMOD

**Services called**

None

**Services called by**

EXINIT

**Processing**

```text
inits system vars
NOVARS is entry pt. when no MLV          [scribbled-out mark between "no" and "MLV"]
CONT     "    "     "   there are MLV
```

## PDF page 100

*Paper: green engineering paper, grid side.*

*(No writing on this side; faint show-through from the reverse of the sheet.)*

