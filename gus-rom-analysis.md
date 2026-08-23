# Analysis of Gustavo Pane's TS-PICO Modified ROMs

**Author of modifications:** Gustavo Pane (Buenos Aires, Argentina)
**Copyright string in EXROM:** "© 2024 Timex Pico Interface"
**TPI BIOS version reported:** $0015 (decimal 21)
**Purpose:** Add TPI (Timex Protocol Interface) support for the TS-PICO peripheral — a Raspberry Pi Pico-based SD card and communication interface for the TS-2068. Launched for the 40th anniversary of the TS-2068.

---

## Overview

Both the HOME ROM and EXROM have been modified to intercept SAVE/LOAD/VERIFY/MERGE operations and redirect them through a new protocol layer that communicates with the TS-PICO peripheral via two I/O ports:

- **Port $0E (14)** — 8-bit bidirectional data port (WR-DAT / RD-DAT)
- **Port $0F (15)** — Status/control port (bit 6 = continue flag: 0=busy, 1=continue)

When the system variable `TP_MODE` at address **$5DDB** indicates SD card mode, tape operations are replaced with serial byte-transfer to/from the Pico; when in tape mode, the original tape routines are called unmodified.

The protocol communicates via structured message blocks with XOR CRC integrity checking. Each command exchange follows a multi-phase pattern: pre-header message → status/ACK → wait for execution (2.8ms timeout, reading bit 6 of port $0F) → data block → status/ACK → wait → final status.

New system variables occupy **$5DCD–$5DDB** (the "VARS2" area), which must be reserved when using TS-PICO features. Addresses $5DDD–$633F are reserved for future releases.

---

## EXROM Differences (gus-exrom.rom vs. original TS-2068 EXROM)

### 1. New Entry Point at $0003

| Address | Original | Gus Modified |
|---------|----------|--------------|
| $0003 | `DEFB $FF,$FF,$FF,$FF,$FF` (padding) | `JP $1CBC` |

The unused padding between RST 0 and RST 8 now holds a jump to a **video-mode-aware function dispatcher**:
```
$1CBC: PUSH AF
       LD A,($5CC2)       ; VIDMOD
       AND A
       JR NZ,$1CC7
       POP AF
       JP $6307           ; normal video: CALL_BANK dispatcher
$1CC7: POP AF
       JP $FAC7           ; extended video dispatcher
```

### 2. Power-Up Chunk Select Changed at $0049

| Address | Original | Gus Modified |
|---------|----------|--------------|
| $0049 | `LD A,$01` | `LD A,$03` |

Changes the Horizontal Select Register value written to port $F4 during cold boot. Value $03 (binary 00000011) activates EXROM in **both chunk 0 and chunk 1** instead of just chunk 0. This likely enables the EXROM's extended code area to be accessible during initialization.

### 3. Reset Code Relocated at $005A

| Address | Original | Gus Modified |
|---------|----------|--------------|
| $005A | `LD HL,$004F; LD DE,$6000; LD BC,$000B; LDIR; JP $6000` (inline) | `JP $1CAE` |

The reset bootstrap (which copies a small trampoline to RAM at $6000 and jumps to it) has been relocated to $1CAE to free space. The code at $1CAE performs the identical LDIR + JP $6000 operation.

### 4. W_TAPE (Write Tape) Intercepted at $0068

| Address | Original | Gus Modified |
|---------|----------|--------------|
| $0068 | `LD HL,$00E5; PUSH HL` (standard tape leader output) | `JP $1879` |

**This is the core TPI write intercept.** The new code at $1879:

```
$1879: PUSH AF
       LD A,($5DDB)       ; check TP_MODE
       AND $02            ; bit 1 = SD card mode
       JR Z,$1872         ; if zero, fall through to original W_TAPE
       POP AF             ; SD card mode active...
       ...                ; TPI serial write protocol follows
```

When TP_MODE bit 1 is clear (tape mode), it restores the original flow by jumping back to `$006B` (the instruction after the original entry point). When bit 1 is set (SD card mode), it:

1. Sends a command byte (header=$01, data=$03, or general=$09) via port $0E
2. Transmits the file type byte, parameters from system variables ($5C74, $5DCF, $5DD1)
3. Sends the IX pointer (data address) and DE (block length)
4. Transmits the actual data bytes with a running XOR checksum
5. Waits for ACK from the Pico (WF_NPH routine at $1A54)
6. Checks status response

### 5. R_TAPE (Read Tape) Intercepted at $00FC

| Address | Original | Gus Modified |
|---------|----------|--------------|
| $00FC | `INC D; EX AF,AF'` (standard tape edge detection start) | `JP $196D` |

**The TPI read intercept.** The code at $196D:

```
$196D: PUSH AF
       LD A,($5DDB)       ; check TP_MODE
       AND $02
       JP Z,$1A4D         ; if zero, jump to original R_TAPE
       POP AF             ; SD card mode active...
       ...                ; TPI serial read protocol follows
```

When in SD card mode, it:
1. Sends a read command (header=$05, data=$07, or general=$0A)
2. Transmits file parameters and addressing info
3. Receives data byte-by-byte from port $0E
4. Verifies a running XOR checksum
5. Supports both header reads and data block reads
6. Handles filename comparison for LOAD (matching behavior)

### 6. TPI BIOS Jump Table at $1840

A new callable API for machine-code programs, matching the documentation:

| Address | Entry | Function |
|---------|-------|----------|
| $1840 | `JR $1856` | **G_MODE** — Get output mode. Returns TP_MODE lower nibble in BC |
| $1842 | `JR $1862` | **S_MODE** — Set output mode. A = mode value, stored to $5DDB |
| $1844 | `JR $1852` | **G_VERS** — Get BIOS version. Returns $0015 in BC |
| $1846 | `JR $186D` | **TX_A** — Transmit byte in A to Pico via `OUT ($0E),A` |
| $1848 | `JR $186A` | **RX_A** — Receive byte from Pico via `IN A,($0E)` |
| $184A | `JR $184F` | **C_END** — Command end. Jumps to $2279 (wait & finalize) |
| $184C | `JP $1A54` | **WF_NPH** — Wait for peripheral handshake (timeout = carry set) |
| $184F | `JP $2279` | **EWAIT** — Command wait & exit |

### 7. Serial I/O Routines

```
; TX_A at $229D — Transmit byte
OUT ($0E),A        ; Write byte to TS-PICO via I/O port $0E (WR-DAT)
AND A              ; Clear carry (success)
RET

; RX_A at $2298 — Receive byte  
IN A,($0E)         ; Read byte from TS-PICO via I/O port $0E (RD-DAT)
AND A              ; Clear carry (success)
RET
```

Two I/O ports are used:
- **Port $0E (14)** — Bidirectional 8-bit data (WR-DAT for writes, RD-DAT for reads)
- **Port $0F (15)** — Status port (RD-STA). Bit 6 = continue flag (0=busy/processing, 1=continue/ready). Also used for reset (`OUT ($0F),A` with A=0 at $2236).

### 8. Wait/Handshake Routine (WF_NPH) at $1A54

```
$1A54: PUSH AF
       PUSH BC
       LD B,$E2           ; timeout counter (226 iterations)
$1A58: CALL $0655         ; read keyboard/status
       BIT 6,A            ; check bit 6 (handshake signal)
       JR NZ,$1A6E        ; jump if ready (success)
       DJNZ $1A58         ; loop until timeout
       ; timeout path:
       LD A,$40
       POP BC; POP AF
       LD A,$02
       SCF                ; carry = error
       RET
       ; success path:
$1A6E: POP BC; POP AF
       SCF; CCF           ; clear carry = no error
       RET
```

### 9. TPI Command String Parsing (EXROM $1A73–$1AF8)

This code parses the filename string after "TPI:" or "NET:" to identify TPI local commands. The parser at $1AB6 checks for:

- **"TPI:"** prefix — sets bit 7 of TP_MODE, clears bit 6
- **"NET:"** prefix — sets bits 7+6 of TP_MODE (network mode flag)

After the colon, further parsing identifies sub-commands (handled at $208E–$2191):

| Command String | Handler | Effect |
|----------------|---------|--------|
| `"TPI:TAPE"` | $208E | Clears TP_MODE to 0 (standard tape I/O) |
| `"TPI:SDCARD"` | $20C3 | Sets TP_MODE bit 1 (SD card I/O via Pico) |
| `"TPI:PICOPT"` | $2111 | Sets TP_MODE bit 0 (Pico virtual printer) |
| `"TPI:TS2040"` | $2155 | Clears TP_MODE bit 0 (standard TS-2040 printer) |

Additional sub-commands are parsed for file modes (FMODE=TAP, FMODE=DOS, FMODE=TPI, FMODE=FDD, FMODE=RAW) and operations (CLOSE, MEMBOOT) as documented in the TSPICO manual.

### 10. New Code/Data Areas

| Range | Size | Purpose |
|-------|------|---------|
| $1840–$1870 | 49 bytes | TPI BIOS jump table + mode routines |
| $1872–$1935 | 196 bytes | W_TAPE intercept (TPI write protocol) |
| $1936–$196C | 55 bytes | Serialization helpers (send DE, send IX, XOR checksum) |
| $196D–$1A52 | 230 bytes | R_TAPE intercept (TPI read protocol) |
| $1A54–$1A72 | 31 bytes | WF_NPH wait/handshake |
| $1A73–$1C4A | 472 bytes | Filename/command parsing, TPI command dispatch, error handling |
| $1C49–$1CAE | 102 bytes | Initialization helpers, copyright string, reset bootstrap |
| $1CBC–$1CCB | 16 bytes | Video-mode function dispatcher ($0003 target) |
| $1D00–$1D7A | 123 bytes | Dispatcher service address table (updated) |
| $208E–$22AD | 544 bytes | TPI sub-command parsers, BIOS routines, serial I/O |

### 11. Copyright/Identification

At $1C6C: `" 2024 Timex Pico Interfac"` (last byte has bit 7 set, Spectrum-style string terminator)

This replaces what was presumably unused space or part of the original dispatcher tables.

### 12. Error Code Dispatch ($1BF3–$1C22)

A comprehensive error handler that decodes status codes returned by the Pico:
```
$1BF3: EI
       DEC A          ; status 1 = invalid device
       JP Z,$1C3E     
       DEC A          ; status 2 = break
       JP Z,$1C39     
       DEC A          ; status 3 = specific error
       JP Z,$1C3C
       DEC A          ; status 4 = file not found  
       JP Z,$1C35
       DEC A          ; status 5 → RST 8 error $05
       ...            ; etc.
```

Maps Pico-returned error codes to standard Sinclair error messages (RST 8 calls).

---

## HOME ROM Differences (gus-home.rom vs. original TS-2068 HOME ROM)

### 1. DOSAVE/CALL_BANK Reworked at $2547

The entire DOSAVE routine has been rewritten:

**Original:**
```
DOSAVE: POP AF
        LD BC,SLVM         ; $01AB
        PUSH BC
        LD BC,$FEFE         ; dock bank select
        PUSH BC
        LD BC,$0000         ; no params
        PUSH BC
        PUSH BC
        LD A,(VIDMOD)
        AND A
        JR NZ,$2562
        CALL $65D0          ; CALL_BANK
```

**Gus Modified:**
```
$2547: POP AF
       EXX                  ; save main registers
       LD HL,$01AB          ; SLVM address in EXROM
       JP $3CE3             ; jump to new CALL_BANK trampoline
```

The new routine uses EXX to preserve registers and calls a unified trampoline at $3CE3 that handles both normal and extended video mode dispatching.

### 2. New CALL_BANK Trampoline at $3CE3

```
$3CE3: PUSH HL              ; push EXROM target address
       LD HL,$FEFC          ; bank select ($FE=EXROM, $FC=chunks)
       PUSH HL
       PUSH AF
       LD A,($5CC2)         ; VIDMOD
       AND A
       EXX                  ; restore main registers
       JR NZ,$3CF4          ; extended video mode
       POP AF
       CALL $6572           ; CALL_BANK (normal video)
$3CF4: POP AF
       CALL $FD32           ; CALL_BANK (extended video)
$3CF8: LD ($5DCD),HL        ; save returned HL to TPI variable
       JP $04F8             ; continue processing
```

This trampoline is used by multiple callers in the home ROM to invoke EXROM routines. It:
- Takes the EXROM target address in HL (via EXX)
- Sets up the CALL_BANK stack frame ($FEFC for EXROM bank)
- Dispatches based on video mode
- Saves the result to the TPI system variable area

### 3. Multiple New EXROM Entry Points

The home ROM now calls into three different EXROM addresses:

| HL Value | EXROM Routine | Context |
|----------|---------------|---------|
| $01AB | SLVM (original) | Standard SAVE/LOAD/VERIFY/MERGE |
| $01CC | Unknown (new?) | Secondary tape operation |
| $1855 | Inside TPI BIOS | Direct TPI operation |

### 4. Output Character Handler Modified at $0A09

```
sub_0A09: LD C,A
          LD A,($5DDB)     ; check TP_MODE
          RRCA              ; test bit 0 (PICOPT mode)
          LD A,C
          JP NC,$061A       ; if not PICOPT, use standard output
          ...               ; otherwise route to Pico printer
```

This intercepts character output to redirect it to the TS-PICO virtual printer when TP_MODE bit 0 is set (PICOPT mode).

### 5. Initialization/Reset Changes

At $0A02, new code sets up a call via the $3CE3 trampoline to EXROM address $1630, which appears to be a TPI initialization or mode-query routine called during the home ROM's startup sequence.

### 6. Other Modified Areas

- **$03F3–$041B**: New trampoline code for EXROM calls using $5DCD variable storage
- **$04E8–$04FE**: Extended EXROM entry point handlers (stores DE to $5DD7, dispatches via $0A1D)
- **$0500**: Output character routing now goes through sub_0A09 (the TP_MODE checker)
- **$3CDF–$3CFE**: The CALL_BANK trampoline + post-return handler (new code in previously unused space near the character set)

---

## New System Variables (VARS2: $5DCD–$5DDB)

| Address | Name | Purpose |
|---------|------|---------|
| $5DCD | TPBCL | Block count low / general parameter |
| $5DCE | TPBCH | Block count high |
| $5DCF | TPTYPE | File/block type byte |
| $5DD1 | TPLEN | Block length (2 bytes) |
| $5DD3 | TPNAME | Filename pointer (2 bytes) |
| $5DD5 | TPNLEN | Filename length (2 bytes) |
| $5DD7 | TPARG1 | Argument 1 / CODE start address (2 bytes) |
| $5DD9 | TPARG2 | Argument 2 / CODE length (2 bytes) |
| $5DDB | TPMODE | TPI mode flags |

### TPMODE Bit Flags ($5DDB)

| Bit | Meaning |
|-----|---------|
| 0 | Printer channel: 0=TS-2040, 1=PICOPT (Pico virtual printer) |
| 1 | Storage channel: 0=tape, 1=SD card (via Pico) |
| 3:2 | File mode (FMODE): 0=TAP, 1=DOS, 2=TPI, 3=FDD, 4=RAW |
| 6 | NET mode flag (set when "NET:" prefix used) |
| 7 | TPI command active flag (set during "TPI:" parsing) |

---

## TPI Protocol Details (from official documentation)

### Message Frame Types

| ID Byte | Type | Usage |
|---------|------|-------|
| $00 | Pre-header | SLVM header block (SAVE/LOAD/VERIFY/MERGE) |
| $FF | Data block | SLVM data block |
| $42 "B" | BASIC command | TPI: commands from BASIC (SDCARD, TAPE, CD, DIR, etc.) |
| $43 "C" | CP/M CBIOS | CP/M commands (for future CP/M 2.2/3.0 support) |
| $44 "D" | Data block | Response/parameter data blocks |
| $45 "E" | Extra data | Reserved |

### SLVM Command Header (9 bytes + CRC)

| Byte | Field | Description |
|------|-------|-------------|
| 0 | BLOCK_TYPE | $00=header, $FF=data |
| 1 | TADDR | 00=SAVE, 01=LOAD, 02=VERIFY, 03=MERGE |
| 2 | BANK | $FF=HOME |
| 3-4 | SESSION_ID | Assigned by system, must match between header and data blocks |
| 5-6 | MEMORY_ADDRESS | Start address of data in Z80 memory |
| 7-8 | BLOCK_LEN | Length of data block |
| 9 | CRC | XOR of bytes 0-8 |

### BASIC "B" Command Block (9 bytes + CRC + data)

| Byte | Field | Description |
|------|-------|-------------|
| 0 | $42 "B" | BASIC command frame |
| 1 | TADDR | Command ID (00=SAVE, 01=LOAD, 04=COPY, 05=LPRINT) |
| 2 | BANK | $FF=HOME |
| 3-4 | PMR1/PMR2 | Parameters (command-dependent) |
| 5-6 | PMR2_H/unused | Additional parameters |
| 7-8 | COMND_LEN | Length of following command string |
| 9 | CRC | XOR of bytes 0-8 |

Then a "D" data block follows with the command string (e.g., "TPI:SDCARD", "TPI:MEMBOOT", etc.)

### Command Exchange Phases (typical SAVE)

1. **Pre-header** → Send 9-byte header + CRC via WR-DAT (port $0E)
2. **Status** ← Read status byte (01 = OK)
3. **Wait** ← Poll RD-STA (port $0F) bit 6 until set (2.8ms timeout)
4. **Header block** → Send 17-byte tape header + type/name/length + CRC
5. **Status** ← Read status (01 = OK)
6. **Wait** ← Poll continue flag
7. **Data block** → Send actual data bytes + CRC
8. **Status** ← Read status (01 = OK)
9. **Wait** ← Poll continue flag → Final status

### Extended Status Codes (Pico → TS-2068)

Status codes > $80 trigger additional communication:

| Code | Function | Description |
|------|----------|-------------|
| $81 | PRINT_STRING | Pico sends null-terminated string to display on screen |
| $82 | PRINT_STRING_RET_KEY | Print string, then wait for keypress, send key back |
| $83 | PRINT_CHARACTER | Print single character and send it back |
| $84 | RETURN_KEY | Wait for keypress, send ASCII code back to Pico |
| $85 | GET_STATUS | Return device status byte (b0=keyboard, b1=aux, b2=printer, b3=disk) |
| $86 | PRINT_STRING_LOOP | Print string ending with "Continue (Y/N)", loop until N pressed |

### Error Codes (mapped to TS-2068 BASIC errors)

| TPI Code | BASIC Error | Meaning |
|----------|-------------|---------|
| $00 | Report J | Invalid I/O device |
| $01 | OK | No error |
| $02 | Report R | Tape loading error |
| $03 | Report F | Invalid file name |
| $04 | Report Q | Parameter error |
| $05 | Report C | Nonsense in BASIC |
| $06 | Report 6 | Number too big |
| $07 | Report 8 | End of file |
| $08 | Report A | Invalid argument |
| $09 | Report 9 | Stop |
| $0A | Report J | Invalid I/O device |
| $0A+ | Report D | Break - CONT repeats |

### File System Error Codes (from Pico firmware)

| Code | Meaning |
|------|---------|
| $A0 | Invalid I/O device |
| $A1 | CMD OK - No error |
| $A2 | Media removed |
| $A3 | Media not recognized |
| $A4 | Media was changed |
| $A5 | Media failure |
| $A6 | Media is write protected |
| $A7 | Media set R/O mode automatically |
| $A8 | Media is full |
| $A9 | Media is empty |
| $AA | Invalid file name |
| $AC | File is write protected |
| $AD | File is not opened |
| $AE | File is not closed |
| $AF | File R/W operation out of range |
| $B0 | File R/W pointer at end of file |
| $B1 | Invalid function ID |
| $B2 | Invalid session ID |
| $B5 | Invalid block size |
| $B6 | Parameter is too big |
| $B9 | Invalid directory name |
| $BA | No directory found |
| $BC | Directory is write protected |
| $BD | Directory is not empty |
| $BE | Block error |
| $BF | Disk not mounted |
| $C0 | Function fail - unknown error |

---

## Complete TPI BASIC Command Reference (V1.4)

### Storage Commands

| Command | Description |
|---------|-------------|
| `SAVE "TPI:SDCARD"` | Select SD storage (TP_MODE bit 1 set) |
| `SAVE "TPI:TAPE"` | Select standard tape storage (TP_MODE = 0) |
| `SAVE "TPI:<FILENAME.TAP>"` | Create/open a .TAP file on SD |
| `SAVE "TPI:CLOSE"` | Close current TAP file |
| `SAVE "TPI:DELETE"` | Delete current TAP file & close |
| `SAVE "TPI:REWIND"` | Rewind tape pointer |
| `SAVE "TPI:NEXT"` | Move to next program block |
| `SAVE "TPI:APPEND"` | Move pointer to end of file |
| `SAVE "TPI:CD [PATH]"` | Change directory |
| `SAVE "TPI:CD\"` | Change to root directory |
| `SAVE "TPI:STOP"` | Stop SD storage & unmount |
| `SAVE "TPI:FRESET"` | Factory reset configuration |
| `SAVE "TPI:MEMINFO"` | Display memory configuration |
| `SAVE "TPI:MEMBOOT"` | Setup memory config during boot |
| `SAVE "TPI:MEMDOCK"` | Setup cartridge memory |
| `SAVE "TPI:STATUS"` | Check operational mode & status report |
| `SAVE "TPI:VERBOSE"` | Set verbose response mode |
| `SAVE "TPI:AUTORW"` | Set autorewind pointer in current TAP |

### File Mode Commands

| Command | TPMODE Value | Description |
|---------|-------------|-------------|
| `SAVE "TPI:FMODE=TAP"` | +0 | Default mode (TAP format with header) |
| `SAVE "TPI:FMODE=DOS"` | +4 | MSDOS 8.3 filename, without header |
| `SAVE "TPI:FMODE=TPI"` | +8 | Windows long filenames, with header |
| `SAVE "TPI:FMODE=FDD"` | +12 | CP/M - TOS 8.3 filename, with header |
| `SAVE "TPI:FMODE=RAW"` | +16 | Windows long filenames, without header |

### Virtual Printer Commands

| Command | Description |
|---------|-------------|
| `SAVE "TPI:PICOPT"` | Select TS-PICO virtual printer |
| `SAVE "TPI:TS2040"` | Select Timex TS-2040 thermal printer |
| `SAVE "TPI:OPPRINT"` | Open LPRINT capture file |
| `SAVE "TPI:CLPRINT"` | Close LPRINT capture file |
| `SAVE "TPI:VP=EPSON80"` | Set printer emulation: Epson standard |
| `SAVE "TPI:VP=ESCP2"` | Set printer emulation: Epson ESC/P2 |
| `SAVE "TPI:VP=HPLJET"` | Set printer emulation: HP LaserJet |
| `SAVE "TPI:VP=HPCL5"` | Set printer emulation: HP PCL5 |
| `SAVE "TPI:VP=PSCRIPT"` | Set printer emulation: PostScript |
| `SAVE "TPI:VP=PDF"` | Set printer emulation: PDF |
| `SAVE "TPI:VP=<FF>"` | Send form feed to virtual printer |
| `SAVE "TPI:VP=<CR>"` | Send carriage return |
| `SAVE "TPI:VP=<EOP>"` | Send end of page |
| `SAVE "TPI:VP=<EOD>"` | Send end of document |
| `SAVE "TPI:TCAPST"` | Start capture in text file |
| `SAVE "TPI:TCAPEN"` | End capture in text file |
| `SAVE "TPI:BMPSIZE" CODE x,y` | Set BMP capture resolution (256x192 to 2048x1596) |
| `SAVE "TPI:TXTLIN" CODE xx` | Set lines per page (e.g., 72) |
| `SAVE "TPI:TXTCOL" CODE xxx` | Set characters per line (e.g., 132) |
| `SAVE "TPI:TXTFON" CODE xxx` | Set font number (from PRNFONT.SYS) |
| `SAVE "TPI:TXTEOP"` | Send end of page |

### Tandem Commands (Directory/Config)

| Command | Description |
|---------|-------------|
| `SAVE "TPI:DIR *.*" DATA A$()` | Prepare directory listing into array |
| `SAVE "TPI:DIR *.TAP" DATA A$()` | Directory listing filtered to .TAP files |
| `LOAD "<DIR>" DATA A$` | Load directory data into array |
| `SAVE "TPI:CONFIG.SYS" DATA A$()` | Prepare config file for array load |
| `LOAD "<SYS>" DATA A$()` | Load CONFIG.SYS into array |
| `SAVE "<SYS>" DATA A$` | Save CONFIG.SYS file |

### File System Commands (Machine Code API)

| Cmd | ID | Description |
|-----|----|-------------|
| GET_STATUS | $00 | Get storage device status, media info, paths |
| BOOT | $01 | Report/set boot condition (cold/warm/restart) |
| OPEN | $02 | Open file (R/O, W/O, R/W; block sizes 256-16384) |
| READ_BLOCK | $03 | Read 256-byte block from open file |
| WRITE_BLOCK | $04 | Write 256-byte block to open file |
| SEEK | $05 | Move file pointer (get/set/set-to-begin/set-to-end) |
| CLOSE | $06 | Close open file (default or force) |
| CREATE_FILE | $07 | Create new file without opening |
| ERASE | $08 | Erase closed file or directory |
| CREATE_DIR | $09 | Create directory / get current path |
| CHANGE_DIR | $0A | Change current directory |
| DIR_LISTING | $0B | Get formatted directory listing (63 col/line) |
| MOUNT_MEDIA | $0C | Mount/insert media, get mount status |
| REMOVE_MEDIA | $0D | Unmount/eject media for safe power-down |

---

## Summary of Key Design Decisions

1. **Minimal ROM surgery**: The W_TAPE and R_TAPE entry points are intercepted with single JP instructions (3 bytes each), preserving the original tape code intact. When TP_MODE says "tape," the original routines run unmodified.

2. **Two I/O ports ($0E/$0F)**: Communication with the Raspberry Pi Pico uses port $0E (14) for 8-bit data transfer and port $0F (15) for status/control (bit 6 = continue flag). Simple byte-at-a-time IN/OUT instructions — no DMA. The WF_NPH routine provides polled timeout-based handshake by reading port $0F bit 6 with a 2.8ms timeout window.

3. **Backward compatibility**: The ROM version byte at $0013 remains $FF. Original SAVE/LOAD programs work unchanged when TP_MODE=0. The dispatcher service table is preserved (with additions).

4. **New code footprint**: Approximately **1,800 bytes** of new code in the EXROM (from $1840 to $22AD) and approximately **100 bytes** in the HOME ROM (mainly the trampoline at $3CE3 and the output intercept at $0A09), plus scattered small patches at entry points.

5. **Protocol**: The TPI protocol sends structured command blocks (header byte + parameters + data + XOR checksum) with ACK/status handshaking, supporting SAVE, LOAD, VERIFY, MERGE, COPY, and LPRINT operations.
