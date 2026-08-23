# TS 2068 Known Issues, Errata, and Disassembly Notes

This file documents known bugs in the TS 2068 ROM, places where the behavior
differs from documentation, and areas of the disassembly where the interpretation
is uncertain — particularly around Timex-specific features.

---

## Confirmed ROM Bugs

### NMI Handler Direction Inverted ($0066)

**Location:** HOME ROM $0066 (NMI routine)
**Bug:** The branch condition is `JR NZ, NO-RESET` but should be `JR Z, NO-RESET`.
**Effect:** The NMI triggers a reset when NMIADD is non-zero, and does NOT reset
when NMIADD is zero — the opposite of documented behavior.
**Workaround:** Set NMIADD to your desired handler address and accept that the
branch logic is inverted. There is no software workaround that preserves the
documented interface.

### CLOSE-DFILE Does Not Work (EXROM $0E27)

**Location:** EXROM $0E27 (CLOSE-DFILE routine)
**Bug:** The CLOSE-DFILE routine that closes the second display file and moves the
stack and dispatcher back from high memory to chunk 3 does not work correctly.
**Effect:** Once the second display file is opened, it cannot be reliably closed
via this routine.
**Workaround:** Avoid opening the second display file unless you intend for it to
remain open for the duration of the program's execution. If you need to close it,
write your own relocation code modeled on OPEN-DFILE.

### STICK Function Argument Handling

**Location:** HOME ROM, STICK command (~$28F8)
**Uncertainty:** The disassembly shows TEST-STICK-ARG subtracts 2 and uses ADC
to detect out-of-range. The BASIC manual implies `STICK n,d` where n=joystick(1-2)
and d=direction(1-2), but the exact encoding of the return value and the mapping
of direction bits to joystick hardware is not completely clear.
**What is known:**
- Reads AY-3-8912 register 14 via port $F6
- Complements the value and masks appropriately
- Returns stick state; stick 2 uses a right-shift path (DJNZ STICK-BITS / RLCA)
- Values 1 and 2 are valid for both arguments; others give Report A (Invalid argument)

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

**Command:** FREE (token $7E / ~$C4 range)
**Location:** HOME ROM ~$2934 (FREE)
**Behavior:** Returns (RAMTOP − STKEND) as a floating point number on the
calculator stack. This represents free memory between the BASIC working area
and the top of BASIC RAM. Machine stack and OS overhead are not accounted for,
so the value is an approximation.

### RESET Command

**Command:** RESET (token $7F / SEKEYS table, SHIFT+SYMSHIFT+O)
**Behavior:** Appears to perform a warm reset. The exact mechanism — whether it
jumps to $0000 or uses another reset path — is uncertain from the disassembly alone.

### Bank Switching Expansion Services ($0E–$13)

**Dispatcher services:** GET_STATUS, GET_NUMBER, BANK_ENABLE, GOTO_BANK, CALL_BANK, XFER_BANK
**Note:** These services were designed for the Bus Expansion Unit (BEU) which was
never produced. The services exist in the dispatcher but may not function correctly
without the expansion hardware present. The exact parameter passing conventions
for GOTO_BANK and CALL_BANK are inferred from the code and may have edge cases.

### Cassette Routines (EXROM)

**Location:** EXROM $006B–$0FAF
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
2. **BASIC token numbering differences** — the TS 2068 has additional tokens
   (DELETE, ON ERR, STICK, SOUND, FREE, RESET) which shift token numbers for
   some commands compared to later Spectrum models.
3. **Different ULA** — the SCLD behaves differently from the Spectrum ULA for
   some timing-sensitive operations.
4. **Port $FE timing** — some Spectrum software relies on exact timing of port $FE
   writes for border effects; the SCLD may handle this differently.

### Compatible Elements

- **BASIC syntax and floating point** — standard Sinclair BASIC syntax is the same
- **System variable layout** — $5C00–$5CB5 is identical to the Spectrum
- **Display file format** — standard mode ($4000–$5AFF) is identical
- **Character set** — identical to Spectrum ($3D00 location differs but same data)
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
   when the dispatcher moves from $6000 to $F7C0. If code behaves unexpectedly
   when VIDMOD ≠ 0, check whether all JP/CALL targets in the dispatcher were
   correctly updated by the fix table.

2. **Cartridge initialization sequence** — the AROS-INIT / CART-INIT routine
   builds the SYSCON table by scanning cartridge memory. The exact trigger
   conditions for LROS jump vs AROS autostart are documented but the interaction
   with partial cartridges (cartridges using only some chunks) is complex.

3. **TOKEN mode flag** — as noted above, this TS-2068-specific FLAGS bit is not
   fully explained in available documentation.

4. **ON ERR line number encoding** — ERRLN ($5CB6) stores the ON ERR target line.
   Bit 7 of ERRLN+1 (the high byte) being set appears to disable error trapping.
   The exact encoding of `ON ERR GOTO 0` (to clear the handler) vs other forms
   is inferred but not confirmed.