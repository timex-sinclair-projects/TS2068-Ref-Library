# TS 2068 Known Issues, Errata, and Disassembly Notes

This file documents known bugs in the TS 2068 ROM, places where the behavior
differs from documentation, and areas of the disassembly where the interpretation
is uncertain — particularly around Timex-specific features.

---

## Confirmed ROM Bugs

### NMI Handler Direction Inverted ($0066)

**Location:** HOME ROM $0066, branch byte at $006D. The EXROM carries its own
copy of the same routine, with the same bug, at $110E.

**The code as shipped:**

```z80
        PUSH AF
        PUSH HL
        LD   HL,(USRNMI)
        LD   A,H
        OR   L
        JR   NZ,$0070     ; <-- should be JR Z
        JP   (HL)
$0070:  POP  HL
        POP  AF
        RETN
```

**Bug:** the branch condition is `JR NZ` where it should be `JR Z`.

**Effect:** with `JR NZ`, a **zero** NMIADD falls through to `JP (HL)` with
HL = 0 — a jump to $0000, i.e. a reset. A **non-zero** NMIADD branches straight
to the exit and returns without ever calling the user handler. The user routine
is therefore never reached, and it is the *empty* vector that resets the machine.

(Earlier revisions of this file, and of CLAUDE.md, described this the other way
round. The listing above is from `disassemblies/ts2068_home_rom_U16_stock.txt`
and is
the authority.)

**Workaround:** none that preserves the documented interface on a stock ROM —
leave NMIADD non-zero if you want the NMI to be harmless. Patching $006D from
$20 to $28 fixes it; both `2068 ROMS/2068Home.BIN` and the Zebra OS-64 cartridge
ROM ship with that patch applied.

### CLOSE-DFILE Does Not Work (EXROM $0E27)

**Location:** EXROM $0E27 (CLOSE-DFILE routine)
**Bug:** The CLOSE-DFILE routine that closes the second display file and moves the
stack and dispatcher back from high memory to chunk 3 does not work correctly.
**(unverified)** — no failure mechanism has been found in the stock code, which
mirrors OPEN-DFILE (`LDDR` of $F7C0–$FFFF back to $6000–$683F, fix table walked
subtracting $97C0, UDGs moved back up by $0840). A real, verified defect in the
same mechanism is the relocation fix table — see below.
**Effect:** Once the second display file is opened, it cannot be reliably closed
via this routine.

### Relocation Fix Table Misses Four Operands (EXROM $1D34, $1D38, $1D3A, $1D68)

**Location:** EXROM fix table at $1D00 (61 words, zero-terminated), used by
OPEN-DFILE ($0DB0) and CLOSE-DFILE ($0E27).
**Bug:** four entries are one byte off: $64AC, $650E, $6516 and $674F point at a
CALL opcode or into the middle of an instruction instead of at the operand
($64A9, $650F, $6517 and $6744). The real operands are not relocated, and two
code bytes at each wrong address are altered instead.
**Effect:** while the second display file is open, the BEU paths of BANK_ENABLE
and XFER_BYTES run corrupted code or call $635C/$651E in low RAM, which is now
display file 2. CLOSE-DFILE subtracts the same amounts, so the damage is reversed
on close. Corrected in the community EXROM revision; details in
`exrom_revision_analysis.md` group 13.
**Workaround:** Avoid opening the second display file unless you intend for it to
remain open for the duration of the program's execution. If you need to close it,
write your own relocation code modeled on OPEN-DFILE.

### STICK Function Argument Handling

**Location:** HOME ROM, STICK function — entry $28F8 (`CALL $287B` checks the
parentheses, then `CALL NZ,$2902`), body $2902–$2933.
**Former uncertainty:** the BASIC manual's `STICK n,d` wording was read as
n = joystick, d = direction. The ROM shows the opposite order; it is now
resolved from the code:
- `GET_XY` ($2660) pops the **last** argument into B and the first into C (the
  same convention gives `ATTR (line,col)` at $28D7: C = line, B = column).
- STICK selects AY-3-8912 register 14 (`OUT ($F5),$0E`) and reads it with
  `IN A,(C)`, C = $F6, B = the **second** argument — so the stick (1 or 2) is
  chosen by the port's high address byte, not by different bits.
- The value is complemented. The **first** argument selects what is returned
  (`LD B,D / DJNZ`): 1 → bits 0–3 (directions; if all four are set the result is
  forced to 0); 2 → `RLCA / AND 1`, bit 7 (fire button).
- Both arguments must be 1 or 2, otherwise Report A (Invalid argument):
  `SUB 2 / ADC A,0 / JR NZ` → `RST 8 / DEFB 9`. Parentheses are required.
- So `STICK (1,s)` reads stick s's directions and `STICK (2,s)` its fire button.
  See `ts2068_tokens_and_keyboard.md` ("Reading Joysticks via STICK").

---

## Areas of Uncertainty in the Disassembly

### Token Mode (FLAGS bit 4)

**System variable:** FLAGS ($5C3B), bit 4 = TOKEN
**Note:** This flag is described as "unique to TS 2068" in the disassembly.
The exact behavior — when it is set/cleared and what it changes about BASIC
interpretation — is not fully documented. It appears to affect how the BASIC
interpreter handles tokenized input, possibly relating to the cartridge/AROS
code paths.

### FREE Function Return Value

**Command:** FREE (token $7E)
**Location:** HOME ROM $2934 (FREE)
**Behavior:** Returns (RAMTOP − STKEND) as a floating point number on the
calculator stack. This represents free memory between the BASIC working area
and the top of BASIC RAM. Machine stack and OS overhead are not accounted for,
so the value is an approximation.

### RESET Command

**Command:** RESET (token $7F / SEKEYS table, SHIFT+SYMSHIFT+O)
**Behavior:** Appears to perform a warm reset. The exact mechanism — whether it
jumps to $0000 or uses another reset path — is uncertain from the disassembly alone.

### Bank Switching Expansion Services ($0E–$13)

**Dispatcher services:** GET_STATUS, GET_NUMBER, BANK_ENABLE, GOTO_BANK, CALL_BANK, XFER_BYTES
(XFER_BYTES copies a block between banks; it does not transfer control)
**Note:** These services were designed for the Bus Expansion Unit (BEU) which was
never produced. The services exist in the dispatcher but may not function correctly
without the expansion hardware present. The exact parameter passing conventions
for GOTO_BANK and CALL_BANK are inferred from the code and may have edge cases.

### Cassette Routines (EXROM)

**Location:** EXROM $0068–$08E6 (W_TAPE $0068 … SAVE $0851, AKEY $08AA; EXTINIT starts at $08E7)
**Note:** Most cassette code was moved from HOME ROM to EXROM to make room for
cartridge code. The routines are similar to the ZX Spectrum equivalents but are
accessed via the function dispatcher (LOAD=$05, SAVE=$07, MERGE=$06). Directly
calling EXROM cassette routines requires the EXROM to be mapped in, which involves
manipulating DECR and HSR.

### DISPATCH vs Function Dispatcher

The ROM contains two related but different concepts:
1. **Function Dispatcher** — code copied to RAM; provides the service call interface
   described in ts2068_dispatcher.md. Entry at $6200 or $F9C0.
2. **DISPATCH** — a section of HOME ROM and EXROM code that provides CALL/JP
   capability from any bank context to specific HOME/EXROM routines.

The DISPATCH section (HOME ROM near end, EXROM $1000+) implements the cross-bank
calling mechanism used by the dispatcher itself. Programmers should use the
function dispatcher API rather than the DISPATCH code directly.

### AROS Pointer Management

The ARSFLAG bits indicate which system variables point into cartridge (DOCK) space
vs HOME RAM. The OS must handle these correctly to avoid corrupting BASIC data when
switching between cartridge and RAM contexts.

**Uncertain behavior:** When AROS is active and BASIC commands modify NXTLIN, DATADD,
or CH_ADD, the OS must decide whether to update the AROS pointer or create a RAM copy.
The exact rules for this are complex and may not always work correctly for all
combinations of BASIC commands.

---

## ZX Spectrum Compatibility Notes

### Incompatibilities

The TS 2068 is largely **incompatible** with ZX Spectrum software because:

1. **ROM routines at different addresses** — most Spectrum ROM subroutines have
   moved. Code that calls Spectrum ROM addresses directly will jump to wrong locations.
2. **ROM subroutine addresses** (the main problem) — see point 1. Note that
   BASIC **token numbering is NOT a source of incompatibility**: tokens
   $A5–$FF are identical to the Spectrum's, and nothing is shifted. The 2068's
   six extra keywords (DELETE, ON ERR, STICK, SOUND, FREE, RESET) had no free
   slots in $A5–$FF, so they overload the low codes $0C and $7B–$7F instead.
   See `ts2068_tokens_and_keyboard.md`.
3. **Different ULA** — the SCLD behaves differently from the Spectrum ULA for
   some timing-sensitive operations.
4. **Port $FE timing** — some Spectrum software relies on exact timing of port $FE
   writes for border effects; the SCLD may handle this differently.

### Compatible Elements

- **BASIC syntax and floating point** — standard Sinclair BASIC syntax is the same
- **System variable layout** — $5C00–$5CB5 is identical to the Spectrum
- **Display file format** — standard mode ($4000–$5AFF) is identical
- **Character set** — identical to the Spectrum, and at the same address ($3D00)
- **Calculator opcodes** — floating point calculator is compatible

### Spectrum Code That May Work

Programs that use only the standard display file, do not call ROM subroutines by
address, and use only standard Spectrum BASIC commands (not the 2068 extensions)
have a chance of running. Tape loading routines that access the TS 2068 cassette
via the standard LOAD command should work.

---

## Addressing the Disassembly Author's Concerns

The author notes uncertainty particularly around Timex-added features. The most
uncertain areas are:

1. **Video mode interaction with the dispatcher** — the relocation mechanism
   (fix table at EXROM $1D00) and the exact set of addresses that get patched
   when the $6000–$683F block (machine stack + dispatcher) moves to $F7C0–$FFFF,
   taking the dispatcher from $6200 to $F9C0. The stock table is known to miss
   four operands (see "Relocation Fix Table Misses Four Operands" above); if code
   behaves unexpectedly when VIDMOD ≠ 0, check those first.
   Also note that neither OPEN-DFILE nor CHG_V writes RAMTOP (EXROM $0DB0–$0E26,
   $0E8E–$0F42; CHG_V only checks `STKEND + $1B00 < RAMTOP` at the moment of the
   switch). With the power-on RAMTOP $FF57, the moved UDGs ($F718–$F7BF) and the
   relocated stack/dispatcher ($F7C0–$FFFF) therefore sit **below** RAMTOP, and
   nothing in the OS appears to stop BASIC's workspace growing into them
   (code-reading only — **(unverified)** on hardware). Lowering RAMTOP with
   `CLEAR` below $F718 before opening the second display file avoids the question.

2. **Cartridge initialization sequence** — EXROM EXTINIT ($08E7), which calls BLDSCT ($09F4),
   builds the SYSCON table by scanning cartridge memory. The exact trigger
   conditions for LROS jump vs AROS autostart are documented but the interaction
   with partial cartridges (cartridges using only some chunks) is complex.

3. **TOKEN mode flag** — as noted above, this TS-2068-specific FLAGS bit is not
   fully explained in available documentation.

4. **ON ERR line number encoding** — now resolved from the ROM. ERRLN ($5CB6)
   stores the target line in bits 0–13. Bit 15 (bit 7 of ERRLN+1) **set means
   trapping is armed**: `ON ERR GO TO n` stores `(n AND $3FFF) OR $8000`
   (HOME $20C6–$20CC), and the error path traps only when it is set ($0E95
   `BIT 7,(IY+$7D)` / `JR Z` → normal report). `ON ERR RESET` (codes $7B $7F)
   clears bits 15 and 14 ($20B2, $20B6) — that, not `ON ERR GO TO 0`, is the
   clear form; GO TO 0 would arm a trap to line 0. Bit 14 is set while a trap is
   being handled ($0E9B) and makes the BREAK test ignore BREAK ($200F).
   `ON ERR CONTINUE` ($E8) resumes at ERRC/ERRS ($208E–$20A0).