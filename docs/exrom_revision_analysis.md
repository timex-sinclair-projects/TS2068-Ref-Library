# 2068 EPROM Revision Analysis

Comparison of the two EXROM images in this repository:

| Role | File in this repo | md5 |
|------|-------------------|-----|
| Original | `2068 ROMS/TS2068_U20.BIN` (stock U20 chip) | `575d203c6e15e679fba0b73f854ec7a2` |
| Revised | `2068 ROMS/2068Exrom.BIN` (from `2068ROMS.zip` as `2068MODU20.BIN`) | `e3863481d1273af637922415e96dbb0b` |

> **Provenance note.** An earlier revision of this document named the files
> `2068 EPROM Revision.BIN` and `tc2068-1.rom`, neither of which is in this
> repository, and gave the diff as 95 bytes. Every one of the 39 individually
> listed byte changes below has since been re-checked against the two files
> named above and **all 39 match exactly**, so this analysis is of this pair.
> The true diff is **99 bytes**; the old total omitted a four-byte change in
> BANK_ENABLE (group 14, added below) and undercounted the two rewrite blocks.
> Beware if you obtained `tc2068-1.rom` elsewhere — that filename normally
> denotes the European **TC2068**, which is not guaranteed to carry the same
> EXROM as a US TS2068.

This is a **community revision** (not by Timex) that modifies 99 bytes across the 8,192-byte EXROM. All changes target the dispatcher and bank-switching subsystem ($0A52+, $1000+), plus the dispatch/fix tables. Everything below $0A52 — the RST vectors, tape I/O, and BASIC parsing — is byte-identical, as are OPEN-DFILE and CLOSE-DFILE.

The Bus Expansion Unit (BEU) services were the most complex part of the EXROM and were never tested against real hardware since the BEU was never commercially produced. Most of these changes target that code.

**To reproduce the diff:**

```python
A = open("2068 ROMS/TS2068_U20.BIN","rb").read()   # original
B = open("2068 ROMS/2068Exrom.BIN","rb").read()    # revised
print([(hex(i), A[i], B[i]) for i in range(8192) if A[i] != B[i]])
```

---

## Verified Fixes

These changes are confirmed correct by examining the surrounding code and comparing against documented behavior.

### 1. NMI Handler Bug Fix ($110E) — 1 byte

| Address | Original | Revised |
|---------|----------|---------|
| $110E | $20 (`JR NZ`) | $28 (`JR Z`) |

The well-documented NMI branch inversion bug. With `JR NZ`, a zero NMIADD falls through to `JP (HL)` with HL = 0 — a jump to $0000, i.e. a reset — while a non-zero NMIADD returns without ever calling the user handler. Exactly backwards. See `ts2068_errata_and_notes.md`. This is the EXROM's dispatcher-area copy of the NMI handler (the HOME ROM copy at $0066 is in a separate chip).

### 2. Dispatch Table Off-by-One Fixes ($1FD8-$1FDC) — 3 entries

| Address | Original | Revised | Service | Verified |
|---------|----------|---------|---------|----------|
| $1FD8 | $6721 | $6722 | XFER_BYTES | Original points to RET ($C9) at end of previous routine |
| $1FDA | $65CF | $65D0 | CALL_BANK | Original points to $FF padding byte |
| $1FDC | $6571 | $6572 | GOTO_BANK | Original points to RET ($C9) at end of previous routine |

Confirmed by examining the actual bytes at the original addresses:
- $1521 = $C9 (RET), $1522 = $F5 (PUSH AF) — XFER_BYTES starts at $1522
- $13CF = $FF (padding), $13D0 = $E3 (EX (SP),HL) — CALL_BANK starts at $13D0
- $1371 = $C9 (RET), $1372 = $DD (LD IX,...) — GOTO_BANK starts at $1372

RAM addresses are ROM + $5200. The original source disassembly already noted the XFER_BYTES discrepancy: `DEFW $6721 ;XFER_BYTES?($6722)`.

These services were only reachable through the BEU dispatcher interface, so the bugs had no effect in practice.

### 3. CHG_V (CHNG_VID) Wrong Entry Point ($1FEE) — 1 entry

| Address | Original | Revised | Service |
|---------|----------|---------|---------|
| $1FEE | $0EA3 | $0E8E | CHG_V (service $08) |

Confirmed: CHG_V's prologue `PUSH BC; PUSH DE; PUSH HL; PUSH AF` ($C5 D5 E5 F5) is at $0E8E. The original dispatch entry $0EA3 is 21 bytes past the prologue, skipping the register saves entirely. Calling CHG_V through the dispatcher with the original table would corrupt BC/DE/HL/AF on return.

**Note:** CHG_V is also called directly (not through the dispatch table) by the OPEN-DFILE code, so the direct-call path was unaffected.

### 4. CALL_BANK Parameter Offset ($1410) — 1 byte

| Address | Original | Revised |
|---------|----------|---------|
| $1410 | $08 | $09 |

Original: `LD C,(IX+$08) / LD B,(IX+$08)` — loads both B and C from offset +8 (DEST_BANK), never reading SRC_BANK at offset +9.

Revised: `LD C,(IX+$08) / LD B,(IX+$09)` — correctly reads DEST_BANK into C and SRC_BANK into B.

### 5. Interrupt Protection During Bank Switching — 4 bytes

| Address | Original | Revised | Context |
|---------|----------|---------|---------|
| $129A | $C5 (`PUSH BC`) | $F3 (`DI`) | BANK_ENABLE entry |
| $131B | $C1 (`POP BC`) | $FB (`EI`) | BANK_ENABLE exit |
| $134A | $F5 (`PUSH AF`) | $F3 (`DI`) | SAVE_STATUS entry |
| $1370 | $F1 (`POP AF`) | $FB (`EI`) | RESTORE_STATUS exit |

Adds DI/EI bracketing around bank-switch operations. An interrupt occurring mid-switch could execute code from a partially-configured bank mapping, causing a crash. The replaced PUSH/POP instructions appear to have been redundant saves (the registers are saved elsewhere in these routines).

---

## Plausible Fixes (Not Independently Verified)

These changes look like they address real issues, but the correctness of the new code cannot be confirmed without BEU hardware or a comprehensive test suite.

### 6. MOVE_BYTES Destination Pointer ($14DF, $14E2) — 2 bytes

| Address | Original | Revised |
|---------|----------|---------|
| $14DF | $75 (`LD (IX+4),L`) | $73 (`LD (IX+4),E`) |
| $14E2 | $74 (`LD (IX+5),H`) | $72 (`LD (IX+5),D`) |

After LDIR, DE points to the updated destination and HL to the updated source. The original saves HL (source) to the destination address field — the revision saves DE (destination) instead. This looks correct for maintaining the dest pointer across multi-block transfers, but depends on the calling convention.

### 7. PRSCAN Register Swap ($0A52-$0A59, $0A88-$0A89) — 7 bytes

Swaps B and C register usage in the cartridge/bank scanning routine:

| Address | Original | Revised |
|---------|----------|---------|
| $0A52 | `LD B,A` | `LD C,A` |
| $0A54 | `SET 7,B` | `SET 7,C` |
| $0A55 | `LD (HL),B` | `LD (HL),C` |
| $0A57 | `RES 7,B` | `RES 7,C` |
| $0A59 | `LD C,$FE` | `LD B,$FE` |
| $0A88-$0A89 | `LD C,$FE` | `NOP; NOP` |

Appears to fix which register carries the bank number vs the EXROM bank ID ($FE) for subsequent PUSH BC / XFER_BYTES calls. The NOPs at $0A88 suggest the second `LD C,$FE` was redundant once B and C were swapped.

### 8. XFER_BYTES Register Fix ($156A) — 1 byte

| Address | Original | Revised |
|---------|----------|---------|
| $156A | `LD B,A` | `LD E,A` |

When source and destination are in the same bank, the combined bitmap goes into E instead of B, avoiding clobbering the bank number stored in B.

### 9. XFER_BYTES Direction Parameter ($0B1B, $0B49) — 2 bytes

| Address | Original | Revised |
|---------|----------|---------|
| $0B1B | `LD C,$00` | `LD C,$FF` |
| $0B49 | `LD C,$00` | `LD C,$FF` |

Changes the chunk selection parameter from $00 (no chunks) to $FF (all chunks) in two locations within the cartridge initialization code.

### 10. CREATE_BITMAP Direction Check ($14F3-$14F5) — 3 bytes

| Address | Original | Revised |
|---------|----------|---------|
| $14F3 | `RLCA` | `DEC BC` |
| $14F4 | `RRCA` | `INC A` |
| $14F5 | `JR C` | `JR Z` |

Changes the direction field test from a bit-7 sign check (`RLCA/RRCA/JR C`) to a value-equals-$FF check (`INC A/JR Z`), and also adjusts BC (the length) with a DEC.

---

### 14. BANK_ENABLE — EXT bank path replaced ($12D1-$12D4) — 4 bytes

**Not present in earlier revisions of this document.** Found by diffing the two
images directly; the surrounding code is `X_BANK_ENABLE`, branch `BE_NTDOCK`,
in `disassemblies/ts2068_exrom_U20_stock.txt`.

| Address | Original | Revised |
|---------|----------|---------|
| $12D1-$12D2 | `17` `CB 19` — `RLA` / `RR C` | `CB FF` — `SET 7,A` |
| $12D3-$12D4 | `3F` — `CCF` (then `1F` `RRA` at $12D5) | `18 ED` — `JR $12C2` |

Original (bank = $FE, i.e. the EXT/EXROM bank):

```z80
        IN   A,(HREXPT)      ; $12CF  read DECR
        RLA                  ; rotate DECR bit 7 out into carry
        RR   C               ; ...and into C bit 7
        CCF                  ; complement it
        RRA                  ; ...and back into A bit 7
        OUT  (HREXPT),A      ; $12D6  write DECR back
        BIT  7,A
        JR   NZ,BE_SET
        IN   A,(DKHSPT)      ; clear HSR bit 0
        RES  0,A
        OUT  (DKHSPT),A
        JR   BE_EXIT
BE_SET: IN   A,(DKHSPT)      ; or set HSR bit 0
        SET  0,A
        OUT  (DKHSPT),A
        JR   BE_EXIT
```

Revised:

```z80
        IN   A,(HREXPT)      ; $12CF  read DECR
        SET  7,A             ; $12D1  unconditionally enable EXROM
        JR   $12C2           ; $12D3  -> OUT (HREXPT),A / LD A,C / CPL
                             ;           / OUT (DKHSPT),A / JR BE_EXIT
```

The revision drops the bit-shuffling between DECR bit 7 and C bit 7 entirely: it
just sets the EXROM-enable bit and falls into the shared `BE_EXT_OK` tail, which
writes DECR and then programs the HSR straight from the chunk mask in C. That
makes everything from $12D5 to the end of `BE_SET` dead code, which is why only
four bytes needed to change.

**Assessment:** the mechanism is clear from the bytes; whether it is *correct*
depends on whether any caller relied on the original's manipulation of C bit 7,
which cannot be settled without BEU hardware. Treat as **unverified**.

---

## Uncertain / Complex Rewrites

These are substantial logic changes to routines that can only be tested against BEU hardware.

### 11. GET_STATUS Rewrite ($1230-$1249) — 23 bytes changed within a 26-byte span

Major restructuring of the routine that reads the current bank configuration. Changes include:
- Result register moved from B to C (to match the documented API: `STATUS: B, HORIZONTAL_SELECT: C`)
- Different port-reading sequences for DOCK and EXT bank detection
- Changed conditional branching throughout

### 12. GET_NUMBER Rewrite ($1271-$1298) — 33 bytes changed within a 40-byte span

Restructured logic for determining which bank (HOME/DOCK/EXT) owns a given memory chunk. The revised code ends with 4 bytes of NOPs ($1295-$1298), suggesting the new logic is more compact. Includes changed port read ordering and mask operations.

### 13. Fix Table Updates ($1D34, $1D38, $1D3A, $1D68) — 4 entries

| Address | Original | Revised |
|---------|----------|---------|
| $1D34 | $64AC | $64A9 |
| $1D38 | $650E | $650F |
| $1D3A | $6516 | $6517 |
| $1D68 | $674F | $6744 |

The fix table contains addresses that need patching when the dispatcher relocates from $6200 to $F7C0 (for second display file mode). These adjustments are necessary consequences of the code changes in Groups 5 and 11-12, but their correctness depends on those rewrites being correct.

---

## What Was NOT Changed

- **CLOSE-DFILE ($0E27):** Known bug persists (cannot reliably close second display file)
- **Tape routines ($0068-$01AA):** No timing adjustments for 3.528 MHz clock
- **HOME ROM NMI handler ($0066):** Separate chip, not addressed here
- **All BASIC parsing and execution code:** Unchanged
- **OPEN-DFILE ($0DB0):** Unchanged
- **All code below $0A00:** Unchanged (RST vectors, tape I/O)

---

## Byte-Level Diff

**99 bytes** differ between the original and revised EXROM, in 22 clusters:

```
$0A52-$0A59  (5)   $0A88-$0A89  (2)   $0B1B  (1)   $0B49  (1)
$110E        (1)   $1140        (1)   $1150-$1155  (6)
$120B-$1212  (3)   $1230-$1249 (23)   $1271-$129A (34)
$12D1-$12D4  (4)   $131B        (1)   $134A        (1)   $1370  (1)
$1410        (1)   $14DF-$14E2  (2)   $14F3-$14F5  (3)   $156A  (1)
$1D34-$1D3A  (3)   $1D68        (1)   $1FD8-$1FDC  (3)   $1FEE  (1)
```

Accounting: 39 individually listed bytes + 23 in the GET_STATUS rewrite
+ 33 in the GET_NUMBER rewrite + 4 in BANK_ENABLE = **99**. (The $1271-$129A
cluster spans the GET_NUMBER rewrite plus the separately listed $129A.)

Individual byte changes:

```
Address  Orig  Rev   Context
-------  ----  ----  -------
$0A52    $47   $4F   PRSCAN: LD B,A → LD C,A
$0A54    $F8   $F9   PRSCAN: SET 7,B → SET 7,C  (CB prefix at $0A53)
$0A55    $70   $71   PRSCAN: LD (HL),B → LD (HL),C
$0A57    $B8   $B9   PRSCAN: RES 7,B → RES 7,C  (CB prefix at $0A56)
$0A59    $0E   $06   PRSCAN: LD C,$FE → LD B,$FE
$0A88    $0E   $00   PRSCAN: LD C,$FE → NOP
$0A89    $FE   $00   PRSCAN: (operand) → NOP
$0B1B    $00   $FF   Cart init: LD C,$00 → LD C,$FF
$0B49    $00   $FF   Cart init: LD C,$00 → LD C,$FF
$110E    $20   $28   NMI handler: JR NZ → JR Z
$1140    $F5   $D5   GET_WORD: PUSH AF → PUSH DE
$1150    $73   $C1   GET_WORD: LD (HL),E → POP BC
$1151    $23   $D1   GET_WORD: INC HL → POP DE
$1152    $72   $73   GET_WORD: LD (HL),D → LD (HL),E
$1153    $2B   $23   GET_WORD: DEC HL → INC HL
$1154    $C1   $72   GET_WORD: POP BC → LD (HL),D
$1155    $F1   $2B   GET_WORD: POP AF → DEC HL
$120B    $2E   $24   GET_STATUS: branch target
$120F    $1D   $37   GET_STATUS: branch target
$1212    $1F   $27   GET_STATUS: branch target
$129A    $C5   $F3   BANK_ENABLE: PUSH BC → DI
$131B    $C1   $FB   BANK_ENABLE: POP BC → EI
$134A    $F5   $F3   SAVE_STATUS: PUSH AF → DI
$1370    $F1   $FB   RESTORE_STATUS: POP AF → EI
$1410    $08   $09   CALL_BANK: LD B,(IX+8) → LD B,(IX+9)
$14DF    $75   $73   MOVE_BYTES: LD (IX+4),L → LD (IX+4),E
$14E2    $74   $72   MOVE_BYTES: LD (IX+5),H → LD (IX+5),D
$14F3    $07   $0B   CREATE_BITMAP: RLCA → DEC BC
$14F4    $0F   $3C   CREATE_BITMAP: RRCA → INC A
$14F5    $38   $28   CREATE_BITMAP: JR C → JR Z
$156A    $47   $5F   XFER_BYTES: LD B,A → LD E,A
$1D34    $AC   $A9   Fix table: $64AC → $64A9
$1D38    $0E   $0F   Fix table: $650E → $650F
$1D3A    $16   $17   Fix table: $6516 → $6517
$1D68    $4F   $44   Fix table: $674F → $6744
$1FD8    $21   $22   Dispatch: XFER_BYTES $6721 → $6722
$1FDA    $CF   $D0   Dispatch: CALL_BANK $65CF → $65D0
$1FDC    $71   $72   Dispatch: GOTO_BANK $6571 → $6572
$1FEE    $A3   $8E   Dispatch: CHG_V $0EA3 → $0E8E
$12D1    $17   $CB   BANK_ENABLE: RLA → SET 7,A          (group 14)
$12D2    $CB   $FF   BANK_ENABLE: (RR C) → (SET 7,A)     (group 14)
$12D3    $19   $18   BANK_ENABLE: (RR C) → JR            (group 14)
$12D4    $3F   $ED   BANK_ENABLE: CCF → (JR displacement)(group 14)
```

The two rewrite blocks are not listed byte by byte:
`$1230-$1249` (23 of those 26 addresses differ) and `$1271-$1298`
(33 of those 40 differ).
