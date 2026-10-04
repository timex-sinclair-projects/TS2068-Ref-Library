<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 169–190. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 10: Advanced Concepts--I/O Porting and Bank Switching.*
*[← previous](10-chapter-09-peripherals.md) · [book README](README.md) · [next →](12-appendixes.md)*

---

<!-- p. 169 (pdf 179) -->

# Chapter 10: Advanced Concepts--I/O Porting and Bank Switching

In Basic, we didn't worry too much about how doing a `PRINT` got a signal to the screen or how the keyboard gave the right code for a number, letter or token, or as far as that goes why pressing Caps Shift and Break at the same time stopped some programs. We also didn't care how the cassette tape recorder interfaced to the computer other than MIC goes with MIC and EAR goes with EAR. On the ZX81 or TS1000, machine code was put in the first statement of the program as a REM line so there were no machine code saves and loads. The 2068 changed that with its machine code saves, loads and merges of programs, codes and screens. The BEEP command seemed easy enough but using SOUND commands seemed unduly complicated. How the JOYSTICK worked through the sound chip was a mystery we never did really understand but the commands were easy enough.

When we got our 2040 printer we just plugged that into the back bus and all of a sudden could do `LPRINT`, `LLIST` and `COPY` without really worrying about buffers, ports and interfacing. Things got a little more complicated when we bought a Dot Matrix Printer. All of a sudden we had to have a printer interface but we also had to load a program called the Printer Driver. Setting up the printer driver was easy enough but sending some of the other codes for changing type faces, margins and something called linefeed was a bit difficult with word processors like Tasword II especially when we wanted to do something the program wasn't set up to do. However, once done, life again became simple and even more enjoyable. Life became even easier with the addition of a disk drive or microdrive.

The fact is that all the complicated work of switching was done for us by the firmware that came with the equipment. Since these programs were in machine code we didn't bother to look at them. If we had, we would have found the code to be a lot more difficult to understand than code not having all those INs and OUTs. Even with the aid of a port map we have difficulty understanding how the same port can be used for several devices, not at the same time, but one after the other.

The truth of the matter is that the screen, keyboard, sound and joysticks, cassette MIC and EAR, printers, disk drives, modem and anything else we may wish to add are all addressed through ports and ports only. This includes the topic of bank switching which is also done through ports.

You have also probably heard of parallel, serial, centronics, <!-- p. 170 (pdf 180) --> 232C and IEEE ports, just to mention a few. These are names of different ways and standardizations of the use of a port or ports.

What handles all this port switching and porting?

## The SCLD

SCLD stands for "Standard Cell Logic Device". It is sometimes considered the workhorse of the computer. It handles:

1. Bank Switching--the Horizontal Select register.
2. Z-80 clock.
3. Video Display.
    - Display Timing.
    - DMA Display File access
    - Attribute control
4. Interrupt generator.
5. BEEP output.
6. Sound chip control, joystick reading.
7. Cassette I/O.
8. Any other porting to other peripheral device.

This chip is manufactured exclusively for Sinclair--well, at least partly. What the chip manufacturer does is make a chip of standard groupings of gates, flip-flops, inverters, buffers, internal memory, etc. and leaves them unconnected. Then, when a computer manufacturer like Sinclair finally finalizes its design, the wiring diagram of the SCLD is designed and the wiring added to the chips. All micros use the same standard cell logic chip (or the equivalent chips) but with different internal wiring. Thus Apples handle switching differently from IBMs which is still different from Timex etc. If you open your 2068 (not recommended as it voids your warranty), you will find the SCLD chip bristling with contacts on all sides--68 to be exact. You can't miss it.

There is nothing magic inside the SCLD. Its role could be undertaken by a collection of logic chips just as well, but its use greatly compacts things. One reason why the 2068 circuit board looks relatively simple and uncluttered is the fact that the SCLD chip replaces 15 to 20 normal ICs. The SCLD is attached to both the data and address buses, and it also receives most of the Z80's control signals. Using this information, it generates more specific signals of its own which control the whole computer. Because of its small size, not all the components can be located inside the SCLD so it is surrounded with the more bulky components it needs. For an example, the Z80 clock signal requires a quartz crystal and a trimmer to get it exactly the right frequency. These are too bulky to include inside the package. Other connections include the EAR and MIC sockets for cassette operations, the output to activate the sound chip, extension memory banks and keyboard. Additionally, the SCLD reads the Display File along with the Attribute File in memory and gener<!-- p. 171 (pdf 181) -->ates the signal for the screen.

Since the SCLD works independently of the CPU to generate the screen signal, it must read memory at the same time the CPU may need it. To facilitate this, chips known as multiplexers are used (74LS157). They have two inputs for each bit of the address bus, one from the Z80 and one from the SCLD. A control signal from the SCLD determines which of these addresses is passed onto the RAM chips.

The sound chip, (AY-3 8912) also connects to the data bus, but since this chip is port addressed, access to its registers is via the SCLD. The sound chip also interfaces to the joysticks.

Signals for or from anything else that you have to address through a port also goes through the SCLD.

## Bank Switching--An Overview

Bank switching of memory is done in chunks of 8k at a time using a BYTE that has the correct BITS zero for all chunks to be enabled for that bank (active low format).[^v12-1] The HOME bank is the bank of default and will have all those chunks enabled that are not enabled elsewhere.

What we are allowed to enable will depend upon the type of program we are writing. Although plugin cartridges containing programs have to be ROMs or EPROMs we can also use the DOCK bank as a RAM. It can plug in through the front door or on the back bus. In the case of a RAM we have an extended bank of memory in the DOCK that we can read or write to.

Since memory, either RAM or ROM is enabled in chunks, we don't have to enable all of a bank at one time if we don't want to. In the case of a CARTRIDGE written in Basic (with or without some machine code), we have to keep CHUNK 3 in HOME RAM because it contains the necessary routines for bank switching and the machine stack. Also, since we are using the ROM routines to interpret our Basic, we need CHUNKS 0 and 1 with CHUNK 2 for our screen display. (Having just read about the SCLD we note that even in an LROS program we have to supply the same type of pixel mapped display for the SCLD to interpret to generate a signal for the screen). AROS thus is limited to the use of the top 4 chunks of memory only. LROS probably is restricted from using CHUNKS 2 and 3 with part of chunk 0 being needed for interrupt handling routines.

With both AROS and LROS we need some RAM somewhere to write to while our program is running to store variables in. In the case of AROS, the DOCK bank is just activated long enough to write the next program line into the ARSBUF and then the HOME bank is completely activated again to RUN the line. A somewhat similar situation, without deactivation of the complete LROS BANK must be provided in LROS situations.

<!-- p. 172 (pdf 182) -->

Since we can have as many banks of memory as we want, (or our power supply can handle on refresh), but since only 8 chunks can be active at any one time, it's the chunks that are in control, not the banks. Granted, we can designate the active chunk to be from whatever bank we want whenever we desire, but it's still only one Chunk 0, one chunk 1, etc.

If we are in Basic we have to call the changes through what is called the Horizontal Select Register (addressed through port 244) located in the SCLD chip. Since this register is port addressed the only way we can send it information is with an OUT statement. We receive information back with an IN statement. This does not mean we can get along without the bank switching routines in Chunk 3 as they are used by the ROM to find out which chunk a certain address is in. Remember that all banks have the same 0 to 65535 address numbers so we have to know which, say, address 12345 we want, if chunk 1 is active in bank 0, it's bank 0 we want, not bank 255. The horizontal select register finds which chunk is active for us in what bank and turns that bank on for us. This is what `OUT 244, 1` does for us when we wanted to use our Aerco disk drives back in Chapter 9--it found out that we specified Chunk 0 in Bank 0 and so gave us that...the DOS program.[^v12-2]

Writing in machine code we can of course call the functions of the dispatcher directly. However we have to know how to set them up on the machine stack.

## The Function Dispatcher

### RAM Resident Code (25088-26688)

Better known as the Function Dispatcher and the Bank Switching routines. As we said, it is a disgrace to Timex as it is full of errors. DO NOT USE it until you run the following program to make the necessary corrections. The Function Dispatcher is the first of several routines that permanently reside in the top part of Chunk 0 of the Extended ROM. Upon start up the computer transfers these routines to chunk 3, addresses 25088 to 26671 of the Home RAM.[^v12-3] While it was in ROM we couldn't do much with it unless we decided to write a new Extended ROM chip. Once it's in RAM we can change it. This program must be run while in Video Mode 0 (the normal one screen mode), while these routines are in their low addresses. ALSO NOTE: If you have an Aerco Disk Drive don't bother entering and running this program as the corrections have already been made for you in the disk startup program.[^c09-3][^c09-4][^c09-5]

```z80
65000  F3                          DI
65001  21,24,FE                    LD HL, DATA B  Fix GET STATUS
```

<!-- p. 173 (pdf 183) -->

```z80
65004  11,0A,64                    LD DE, 25610
65007  01,09,00                    LD BC, 9       For 9 bytes
65010  ED,B0                       LDIR
65012  11,30,64                    LD DE, 25648
65015  01,1A,00                    LD BC, 26      For 26 bytes
65018  ED,B0                       LDIR
65020  3E,D5                       LD A, 213      Fix PUT WORD
65022  32,40,63                    LD (25408), A
65025  11,50,63                    LD DE, 25424
65028  01,06,00                    LD BC, 6       For 6 bytes
65031  ED,B0                       LDIR
65033  3E,09                       LD A, 9        Fix CALL BANK
65035  32,10,66                    LD (26128), A
65038  AF                          XOR A          Fix BANK ENABLE
65039  32,99,64                    LD (25753), A  and RESTORE STATUS
65042  3E,F3                       LD A, 243
65044  32,9D,64                    LD (25757), A
65047  32,4A,65                    LD (25930), A
65050  3E,FB                       LD A, 251
65052  32,1C,65                    LD (25884), A
65055  32,70,65                    LD (25968), A
65058  FB                          EI
65059  C9                          RET
65060  28,24,FE,FF,28,37,A7,28,27,  DATA B
65069  0E,FF,DB,FF,E6,80,28,12,18,
       08,0E,FF,DB,FF,E6,80,20,08,
       DB,F4,2F,18,02,DB,F4,4F,
65095  C1,D1,73,23,72,2B
```

*Notes on the listing above:* the BANK ENABLE fix at 65038-65055[^v12-4].

The errors you have just corrected stay corrected no matter if you are in single screen mode or double screen mode. The trouble comes in the introduction of new errors each and every time you transfer the code from 25088 to 63936 or back down again. The following POKEs correct the 3 errors introduced on switching program locations:

```basic
      DOWN                    UP
POKE 25870,205          POKE 64718,205
POKE 25871,92           POKE 64719,28
POKE 25872,99           POKE 64720,251
POKE 25878,205          POKE 64726,205
POKE 25879,92           POKE 64727,28
POKE 25880,99           POKE 64728,251
POKE 26447,205          POKE 65295,205
POKE 26448,232          POKE 65296,168
POKE 26449,102          POKE 65297,254
```

*Notes on the listing above:* a fourth relocation error[^v12-5].

Why do these routines have to be moved when in dual screen modes? If you consult your Memory Map of the home bank and look at the right (dual screen) map, you will note that Display File 2 occupies the space where the Machine Stack and the Ram Resident Code normally reside. If you also look at the top part of the map, you will see that these two have been moved up to the very top of RAM with the User Defined Graphics (UDG) being moved <!-- p. 174 (pdf 184) --> just below them. Additionally, the remaining routines (Machine Code Variables, ARSBUF and CHANS) are moved up a bit as well. The start of the Basic program is now at 31510 rather than 26710.

## AROS and Bank Switching

It was Timex's great idea to build a computer with the ability to address more than 64k of RAM (although not more than 64k at any one time) and still use the ROM to operate plugin cartridges. To do this it developed a system of activating chunks of 8k RAM or ROM at a time. Since AROS cartridges can be written in Basic, Chunks 0 and 1 which contain the main ROM, Chunk 2 which contains the Display File and Chunk 3 which has the Bank Switching can't be used leaving only the top 4 chunks (32768 and above) for use. The AROS routine does not support having the Bank Switching Routines in high memory so you are restricted to only the single screen mode. That means programs no longer than 32k. Since the cartridge by necessity has to be ROM memory (nonvolatile) more memory has to be made available in the home bank to allow for the VARiable table. What really happens is that the AROS chunks are only activated to get a Basic line and copy it to the ARSBUF, along with a data line if a READ statement. Then memory is switched back to the home bank where address 32553 is designated as the start of the VARS table and the line is executed.[^v12-6] The process then repeats. Should you switch to machine code by using a USER function, this code must be limited to the SAME Chunk.[^v12-7] If you cross a chunk boundary, the computer will think that the code continues in the next chunk of the home RAM. Machine code routines are the only time the computer stays in the dock bank for any length of time.

## Cartridge Initialization

When you plug in a cartridge, your computer should be off. As you turn it on, it begins to set itself up and one of the things it does is check for a cartridge. It checks both Chunk 0 and 4 of the dock for an LROS or an AROS cartridge respectively. The first 8 bytes of Chunk 4 must contain the following information.

```text
32768 Language type  1 = Basic (and code)
                     2 = code only
32769 Cartridge type 2 = AROS
32770/1 Starting address of Basic (LSB/MSB)
32772 Memory Chunks active (low) by Bit
          00001111 = Chunks 4 to 7
32773 Auto start  0= no, 1 = yes.
32774/5 Number of bytes of RAM to be reserved for ma-
     chine code (LSB/MSB). This saves space in the
     Home RAM which must first be written there.
```

### Errors in AROS Routine

The following omissions and malfunctions have been found:

<!-- p. 175 (pdf 185) -->

- USR function sometimes gives wrong address.
- If the variable specified in a FOR statement is already beyond its final limit the program may not find the line after the next statement. This can be avoided merely by setting the variable within the FOR limits.

The overhead bytes for an LROS cartridge are:

```text
0  Not used
1  Cartridge type  1 = LROS
2/3  Starting address (LSB/MSB) to be jumped to  after
     initialization is complete.
4  Memory Chunks active (low) by bit as in AROS.
```

In addition, Interrupt mode 1 is specified by the computer for LROS cartridges. Instructions written at 56(38H) must handle these interrupts. Instructions at 102(66H) must handle non-maskable interrupts. Should you want to use RST 40 (floating point calculator) it must be enabled with:

```z80
LD HL, 23698 (5C92H) MEM BOT
LD (23656), HL
```

*Corrections in the listing above:* LD (23656), HL[^v12-8].

Should you use an extended video mode, the routine doesn't check to see if there is sufficient memory nor is RAMtop set.

Should Chunk 3 be specified as active for LROS, when the memory chunk specification is written to port 244 (F4H) by the Bank Enable code, execution will continue from that point in Chunk 3 of the Dock Bank with the stack pointer addressing ROM.

Since you are in complete control with LROS, what you do is your own business. However, remember that somewhere you have to put your VARS file and other things that constantly change--they certainly cannot be located in non-volatile Cartridge memory.

If you want to do AROS from your LROS cartridge you also have to tell your computer to check for an AROS application as once it finds an LROS it will not continue to check for an AROS. Also note that Chunk 0 of the Dock and the EXROM are mutually exclusive. If in LROS you cannot get to EXROM.

**LROS Display File.** Since the SCLD chip still is active you still must use a Display File just as you do if no cartridge were present--or a double screen mode if you like. A relocatable Mode 0 (normal 32 column screen) routine for printing to the screen, including all screen tokens is given in Appendix B. I use this routine as a class exercise to introduce students to the operation and use of the various registers and a hands on study of a machine code routine.

### Cartridge Setup

<!-- p. 176 (pdf 186) -->

Several things happen when the computer has sensed the presence of a cartridge, one of the first of which is to set up the Cartridge Flag (23750). Setting Bit 7 tells the computer from now on that a cartridge is present. Many of the routines have a cartridge check written into them which checks this flag and then moves accordingly. Bits 3 and 4 contain flags for Next Line and Data Line, Bit 0 a flag for use of upper or lower screen.[^v12-9] Also addresses:

```text
23751/2   Store the current data line address if any.
23753/4   Store the length of the data line.
23755     The stream number in use.
23748/9   The address of the next program line.
```

*Notes on the list above:* 23748/9[^v12-10].

Further information is stored in the System Configuration Table which is pointed to by Addresses 23740/1.

The full set of routines in the RAM Resident Code are:

```text
        NAME                ADDRESS (IN HEX)
Function Dispatcher           6200  F9C0
INT (for RST 38H)             62AE  FA6E
INT NMI                       6307  FAC7
GET WORD                      6316  FAD6
PUT WORD                      633B  FAFB
WRITE BANK STATUS REG         635C  FB1C
READ BANK STATUS REG          63AD  FB6D
GET BANK STATUS               6405  FBC5
GET CHUNK                     644D  FC0D
GET BANK NUMBER               645E  FC1E
BANK ENABLE                   6499  FC59
SAVE STATUS                   651E  FCDE
RESTORE STATUS                654A  FD0A
GOTO BANK                     6572  FD32
CALL BANK                     65D0  FD90
XFER BANK                     6722  FEE2
GO EX                         6815  FFD5
```

The Function Dispatcher and Bank Switching Routines cannot be used from Basic since it cannot be set up in Basic. It can only be used from machine code. Looking at some of the routines in the Bank Switching Routines we get some idea of what it all can do. The CALL address is listed along with the routine. Both low and high locations are given.

GET WORD--Returns in HL the word from the address in HL in the Bank specified in B.

PUT WORD--Writes the word in DE to the address in HL in the Bank specified by B.

GET BANK STATUS--Returns in A the bank number controlling the address in HL. Literally answers the <!-- p. 177 (pdf 187) --> question of what Bank hold the active chunk of this address.[^v12-11]

BANK ENABLE--With Bank in B and Memory Selection (Chunk # low) in C, enables that bank through the horizontal select register.

GOTO BANK--Push Target Address, then Bank #/memory select on to the stack. Then call GOTO BANK. Works like Basic GOTO without a return to call bank.

CALL BANK--As above but with a return to CALLing BANK and ADDRESS. Set up with target address, then Bank #/ Chunk # low, then # of parameters to be passed IN, then number of parameters to be passed OUT. Parameters IN and OUT are 2 bytes each--use zero if none. Then CALL CALL BANK.[^v12-12]

XFER BYTES--Copies n byte(s) from specified source to specified destination in ascending or descending order. Can be in different banks but cannot cross chunk boundaries.[^v12-13] Push as follows:

```text
Source Bank/Destination Bank
Source Address
Destination Address
Length (2 bytes)
0/ Direction  0 = ascending, 255 = descending.
```

FUNCTION DISPATCHER--Call Basic routines from Home ROM by use of a Service Code Number.

1. Set up memory and stacks (machine and calculator as if invoking service directly.
2. Push parameters for Dispatcher on stack.
3. Set up registers as if invoking directly especially the Interpret Flag (Bit 7 of FLAGS, 0 = syntax check, 1 = execute.)
4. Use Parameters IN and OUT if using CALL. Don't use if Jump.
5. Set Bit 15 if a GOTO. Don't if CALL. Other byte is service code.
6. Make CALL or GOTO BANK.
7. Pop off only the number of parameters of returned bytes.

From this description, one can see that using the function dispatcher requires extensive knowledge of the routines being called. This gets compounded when dealing with the floating point calculator.

Here is the list of Service Codes. Some with an asterisk are supposed to work but have been found to have problems.

<!-- p. 178 (pdf 188) -->

```text
CODE SERVICE              SETUP and RETURN

00*  SAVE data

01*  LOAD data

02*  READ BIT

03*  READ EDGE

04*  SAVE, LOAD, VERIFY, MERGE

05*  LOAD

06*  MERGE

07*  SAVE

08*  CHANGE VIDEO

09*  WRITE BORDER COLOR

10-13  Not assigned or assignment unknown.

14   GET STATUS           Returns Chunk in C for Bank in B.

15   GET BANK NUMBER      Returns Bank in A for address in HL.

16*  BANK ENABLE          See routine page 177.

17*  GOTO BANK            See routine page 177.

18*  CALL BANK            See routine page 177.

19*  XFER BYTES           See routine page 177.

20-24  Not assigned or assignment unknown.

25   UPDATE KEYBOARD      Answer in Last K.

26   PARP                 Generates DE+1 cycles of tone 8N+236 to
                          8N+246 T states long. HL = N.

27   BEEP COMMAND         Process parameters on calculator stack.
                          Exit via PARP.

28   K DUMP (COPY)        Dumps Display File 1 to printer.

29   SEND TV              Character code in A to screen/printer.

30   SET AT               B = Line #, C = Column #. Sets AT.

31   ATTR BYTE            Address in HL. Sets byte Attr  T,  Mask
                          T and P flag.
```

*Notes on the table above:* 14 GET STATUS[^v12-14].

<!-- p. 179 (pdf 189) -->

```text
32   R ATTS               Permanent ATTR INFO to TEMP ATTR VARi-
                          able.

33   CLLHS                CLEAR lower screen in Display File 1
                          only.

34   CLS                  CLEAR entire screen. Display File 1
                          only.

35   DUMP PR              PRINT/Clear entire buffer.

36   PR SCAN              Pixel Address in HL. Number of scans
                          remaining in B (1-8) SENDs 32 bytes of
                          pixels to printer.

37   DESLUG               Address in HL. Remove number slugs from
                          Edit line buffer.

38   K NEW                NEW command.

39   INITialize           A = 0 for power on, FF for NEW. DE =
                          Max RAM address.

40   IN CHannel           Input CHARacter to A from currently
                          selected Channel. NC if no input.

41   SELECT               Stream # in A. Selects channel.

42   INSERT BC Bytes      Insert BC bytes before byte whose add-
                          ress is in HL. Copies up all from HL to
                          STKEND. Updates all affected system
                          variables. Returns BC = 0; DE = address
                          of last byte inserted space; HL address
                          of byte before spaces.

43   RESET                Reset calculator stack. STKEND = STK-
                          BOT. MEM=MEMBOT.

44   CLOSE # command      Channel # on calculator stack.

45   CL CHANnel           BC = value from streams. Closes that
                          channel.

46   OPEN                 Channel and device spec on calculator
                          stack.

47   OPen CHANnel         DE = pointer into STRMS based on Chan-
                          nel #. Device # on calculator stack.

48*  CAT command          Needs Disk Drive ROM.

49*  ERASE command        Needs Disk Drive ROM.
```

<!-- p. 180 (pdf 190) -->

```text
50*  FORMAT command       Needs Disk Drive ROM.

51*  MOVE command         Needs Disk Drive ROM.

52   FLASH A              Flash CHAR in A to lower screen (cursor
                          flash).

53   FIND Line            Number in HL. Returns address in HL
                          with Z if found. Else next line number
                          address (or VARS if none higher).

54   SUB LINe             D = statement #, E = 0 (or keyword with
                          D = 0) HL = line. Returns HL and CH ADD
                          pointing at address one before keyword
                          if Dth statement found and Z set. If
                          match on E, HL and CH ADD pointing to
                          address of E with NZ, NC set and D de-
                          cremented by number of statements look-
                          ed at. If no match on E, returns NZ, C
                          and HL and CH ADD at end-of-line byte.

55   RECord LENgth        HL at address of line, string or numer-
                          ic variable or array. Returns LEN in
                          BC. DE = HL + BC = next line or vari-
                          able.

56   DELete RECord        HL = address of record start. BC = len-
                          gth of record. Deletes from VARS or
                          Program (if line). Recovers spaces and
                          adjusts all affected system variables.

57   PUT BC               BC = number in binary. Converts to ASC-
                          II code and outputs to currently active
                          channel. If less than zero, prints 0.

58   SYNTAX               Check syntax of command or program line
                          in E Line. ERR 255 if none, else ERR #
                          - 1.

59   EXECUTE              Executes commands from E LINE (Direct
                          mode).

60*  FOR                  FOR command--complex use of calculator
                          stack.

61   STOP command         RESTART 8 with error # 9.

62*  NEXT command         Complex use of calculator stack.

63*  READ command         Complex use of calculator stack.

64*  DATA command         Complex use of calculator stack.

65   RESTore BC           BC = Line number to restore to.
```

<!-- p. 181 (pdf 191) -->

```text
66   RANDomize command    Set SEED for RAND number generator. Pa-
                          rameters on calculator stack loaded to
                          SEED. If zero, FRAMES loaded to seed.

67   CONTinue             OLDPPC and OSPPC to NEWPPC and NSPPC.
                          Startup at NEWPPC and NSPPC.

68   JUMP(GOTO)           Line # in calculator stack loaded to
                          NEWPPC with NSPPC set to zero. Just
                          sets up GOTO, not runs.

69   FIX U1               Number on calculator stack to A. RST 8
                          with ERR B for too big a number. Number
                          is unsigned.

70   FIX U                Floating point number on calculator
                          stack to BC (unsigned). ERR B if out of
                          range.

71   CLEAR command        Parameter on calculator stack to BC for
                          use in CLR BC.

72   CLR BC               BC = New RAMTOP. Deletes VARS, CLEARS
                          screen and calculator stack as in Basic
                          CLEAR.

73   GOSUB command        With parameters of GOSUB on calculator
                          stack, puts present line # (LSB/MSB) on
                          machine stack followed by statement
                          number. Then CALLS JUMP(68) to process
                          GOSUB parameters and returns. Does not
                          do GOSUB--just sets up.

74   CHecK SiZe           Checks to see if BC + 80 bytes left be-
                          tween STKEND and RAMTOP. (The 80 is
                          "left over" from T/S 1000 code where
                          machine stack was at top of RAM.) ERR
                          4 if not enough room. Used when adding
                          a new variable to VARS table or a new
                          line to program or bringing down an
                          EDIT Line.

75   RETURN command       Retrieves GOSUB block from machine
                          stack and loads data to NEWPPC and
                          NSPPC and returns. ERR 7 if line number
                          MSB = 62 (end of stack marker).

76   PAUSE command        Parameters on calculator stack to BC.
                          Then waits BC frames or key pressed.
                          (Uses HALT so interrupts must be
                          enabled.)

77   BREAK?               Reads BREAK key. NC if pressed and ON
```

<!-- p. 182 (pdf 192) -->

```text
                          ERROR not active.

78*  DEF                  Define function uses complex calculator
                          stack operations.

79   K LPRint             Selects Channel 3 and processes items
                          in LPRINT statement or output via WRCH.

80   K PRINT              Selects Channel 2 and processes items
                          in PRINT statement for output via WRCH.

81   Print SEQuence       Address in CH ADD. Code used by K LPR
                          and K PRIT to process output data and
                          controls in Basic statement.

82*  INPUT command        Selects Channel 1 and processes I/O for
                          KEYboard/lower screen using a buffer at
                          WORKSP for input.

83   Input SEQuence       Line Address in CH ADD. Code used by
                          INPUT to process input items and con-
                          trols in Basic statement.

84   NOT KB?              Returns Z if current channel is key-
                          board/lower screen (device specifica-
                          tion K).

85   COLOR                D = 0-9 Color desired. Set C for INK.
                          NC for PAPER. Adjusts ATTR-T, MASK-T
                          and P FLAG for color change. ERR K if
                          D invalid.

86   HIFLASH              D = 0, 1 or 8. Set Carry for flash. NC
                          for Bright. Adjusts ATTR-T, MASK-T and
                          P FLAG for FLASH or BRIGHT. ERR K if D
                          invalid.

87   SCRaMBLe             B = Y, C = X. Returns to HL the Display
                          File 1 address with A holding the pix-
                          el of the address--reading left to
                          right. ERR B if Y > 175.

88   PLOT command         Process X/Y parameters on calculator
                          stack to BC. Ready for plotting pixel
                          via PLOT BC.

89   PLOT BC              B = Y, C = X. P FLAG set for INVERSE
                          and OVER. Sets pixel, updates attri-
                          bute and sets COORD = BC.

90   GET XY               Top # on calculator stack will go to B,
                          sign in D. Next # on calculator stack
                          to C, Sign in E (+1 or -1).
```

<!-- p. 183 (pdf 193) -->

```text
91*  CIRCLE command       Calculates successive plot positions
                          from parameters in Basic statement.
                          Uses complex calculator operations.

92*  DRAW command         Calculates successive plot positions
                          from parameters in Basic statement.
                          Uses complex calculator operations.

93*  DRAW Line            Parameters (X,Y) on calculator stack.
                          Plots straight line from current posit-
                          ion (COORD) to X,Y. Uses complex cal-
                          culator operations.

94*  EXPRessioN           CH ADD = Line address. Evaluates ex-
                          pression in Basic line putting value on
                          calculator stack.

95   Find SCReeN          Line and column positions on calculator
                          stack. Will try to find ASCII charact-
                          er. BC = 0 if not found, 1 if found. DE
                          = address of code in Character table if
                          found.

96   Find ATTRibute       X,Y on calculator stack. ATTR in A for
                          that pixel position.

97   RND function         Puts pseudo-random number on calculat-
                          or stack using SEED. ERROR IN THIS CALL
                          WILL CAUSE MALFUNCTION. DO NOT USE.

98   Find PI              PI to calculator stack.

99   Find INKeY           Scans keyboard and puts CHAR code in
                          WORKSP if detected. Pushes registers
                          AEDCB onto calculator stack. BC = 0 if
                          no input, 1 if CHAR. DE = address of
                          CHAR code byte.

100* FIND Number          Find Variable. CH ADD = address of VAR-
                          iable. Searches VARS table for match.
                          Flags Bit 6 = 1 set for numeric, 0 for
                          string. Also used to find parameters
                          for User Defined Functions.

101  PuSH STRing          Clears Bit 6 of FLAGS. Pushes registers
                          AEDCB on calculator stack adjusting
                          STKNXT upwards. DE = address of string;
                          BC = LEN of string.

102  PUT AEDCB            As with Push String but no change to
                          Bit 6 of FLAGS.

103* LET command          Processes existing or creates new vari-
```

<!-- p. 184 (pdf 194) -->

```text
                          ables. Uses complex calculator stack
                          operations.

104  POP STRing           Pops STKNEXT-1 to STKNEXT-5 to regist-
                          ers BCDEA, clearing calculator stack
                          down to STKNEXT-5.

105* DIM statement        Creates numeric or string arrays or re-
                          sets old arrays. Complex calculator
                          stack operations.

106  STack Unsigned Number CH ADD = address of first number
                          (which is in A, as a number, decimal
                          point token or binary token). Processes
                          number to floating point number on cal-
                          culator stack (converts ASCII string of
                          numbers into the numbers of a slug.
                          Does not do slug insertion).

107  STacK A              A = unsigned integer of 1 byte. Loads
                          A to C, sets B to 0 and executes STK
                          BC. Leaves number on calculator stack.

108  STacK BC             BC = unsigned 2 byte number. Places on
                          top of calculator stack.

109  IN INTeger           CH ADD = address of 1st number. A holds
                          1st number as ASCII code. Converts
                          string of numbers into an unsigned
                          floating point number on calculator
                          stack. Terminates when non-digit
                          found.

110  FP2BC                Pops top of calculator stack to INT in
                          BC, rounded to nearest number. NZ if
                          value negative. C if number greater
                          than 65535.

111  FP2A                 Pops top of calculator stack to INT in
                          A (rounded to nearest number). NZ if
                          value negative, C if number greater
                          than 255.

112  OUTPUT               Number on top of stack converted to
                          ASCII code and written via WRCH to
                          current channel output.
```

The following routines all use the floating point calculator. Full explanations are too complex to detail fully.

```text
113  SUBtract             Subtracts top FP number (DE) from 2nd
                          from top (HL) leaving answer on stack
                          top.
```

<!-- p. 185 (pdf 195) -->

```text
114  ADD                  Adds two top numbers on calculator
                          stack leaving answer on top of stack.

115  MULTiply             Integer multiply (HL)*(DE). Carry set
                          if overflow.

116  TIMES                Floating Point multiply two top numbers
                          on the calculator stack.

117  DIVIDE               Floating point divides top number on
                          calculator stack into 2nd number on
                          stack leaving answer on stack.

118  TRUNCate             Truncate top FP number to zero leaving
                          integer.

119  FLOAT                HL = address of start of slug. Puts on
                          stack.

120  INTeger DIVide       Replaces top 2 numbers (X,Y) on calcul-
                          ator stack with X Mod Y and INT (X/Y).
                          DE and HL point to stack addresses.

121  INTeger              Top of calculator stack replaced with
                          INT value. HL set to this address.

122  EXPonent             Top number x, on calculator stack re-
                          placed with EXP (x). HL = address of
                          stack pointer.

123  LN                   Top number on calculator stack replaced
                          with natural logarithm. HL points to
                          it.

124  ANGLE                Top number on calculator stack replaced
                          by results of the calculation of Y from
                          SIN # = SIN (PI/2*Y).

125  COSine               Top number on calculator stack replaced
                          by its COSINE.

126  SINe                 Top number on calculator stack replaced
                          by its SINE.

127  TANgent              Top number on calculator stack replaced
                          by its TANGENT.

128  ATN                  Top number on calculator stack replaced
                          by its inverse tangent. (ARC TANGENT).

129  ARS                  Top number on calculator stack replaced
                          by its inverse sine. (ARC SINE).

130  ACS                  Top number on calculator stack replaced
```

<!-- p. 186 (pdf 196) -->

```text
                          by its inverse cosine. (ARC COSINE).

131  ROOT                 Top number on calculator stack replaced
                          by its square root.

132  TO THE               Y in top of calculator stack, X in 2nd
                          position. Replaced by X^Y.

133  ReaD CHaracter       Wait for character from currently se-
                          lected channel (Calls IN CH) and puts
                          in A.

134  SEND CHaracter       A = ASCII code for Character. Writes it
                          using current channel.

135  WRite CHaracter      A = ASCII code for Character. RESTART
                          16 (to screen).

136  K SCAN               Scan keyboard for key being depressed
                          if any. State returned in A.

137  Pointer LeFT         Cursor moved 1 column left for selected
                          device. S POSN, SPOSN L or P POSN up-
                          dated (screen, lower screen or printer
                          respectively).

138  Pointer RighT        Outputs a space to currently selected
                          device and updates as above.

139  Pointer NewLine      End of Line. Sets current position to
                          start of next line if screen, or
                          outputs printer buffer if printer.

140  PUT MESsage          Outputs message to currently selected
                          device. DE points to start of Message
                          Table. A set for message number (0
                          upwards). First byte of table and last
                          byte of each message must have Bit 7
                          set.

141  K CLS                CLS command. Executes both CLS and
                          CLLHS.

142  SCRolL               Scrolls entire screen (top) up 1 line.

143  Find PoiNT           POINT function. X and Y on calculator
                          stack. Processes to BC. Returns unsign-
                          ed 0 or 1 to stack indicating state of
                          pixel.

144  DRAW LiNe            B = Y, C = X. Else same as DRAW L(93).

145  PUT LiNe             Output line number as 4 digits to cur-
                          rently selected channel (right justi-
```

*Notes on the table above:* 135 WRite CHaracter[^v12-15].

<!-- p. 187 (pdf 197) -->

```text
                          fied and spaced if necessary). HL =
                          address of MSB of line number.
```

Some of these routines are not going to be too useful as they call for the interpretation of a Basic line while being in machine code. Others require entries to already be made to the calculator stack and then processing these entries. Some just set up routines, others having to be called to execute them. Many of the more complex routines result in multiple set up and use of numbers processed on the calculator stack. This is especially true of the draw graphics (line, circle, etc.) routines, where they are done a pixel at a time across the screen.

You will also note that most of the routines are pieces of Basic so your code will resemble machine code written in a Basic format. This may or may not be the fastest way to do things, only you can decide that. At least you will know some of the setup for Basic type routines and even if you don't use the function dispatcher you will know how to set up some of the registers to call the routines directly. The actual address called can be found in the "2068 ROM Manuscript" previously mentioned.

Routines 0-9 are in Extended ROM and although assigned, no data on setup is given. This is because these routines experienced some difficulties. With proper setup they should work but I'm afraid you will have to do your own "woodshedding" on these and maybe some of the others with asterisks.

## Horizontal Select Register

### Bank Switching

Bank switching is done in chunks. Each Bank of 64k is divided into eight Chunks of 8k each--labeled from 0 to 7. The HOME bank is the bank of default--that is, its chunks are enabled if no other bank has already had that chunk enabled. The next lowest priority bank is the Dock or Cartridge bank. All other banks have higher priorities.[^v12-16]

Switching is done with the aid of a device called the Horizontal Select Register. Whenever we use the number 244 as a port number we are using the Horizontal Select Register. Setting up this register is done through the following ports:[^v12-17]

```text
DKSPT 244(F4H)   DocK Horizontal Select PorT. Which chunks of
                 DOCK bank are Enabled. Chunks enabled are by Bit
                 number-- Bit 0 "on" = Chunk 0 of dock bank
                 enabled.

BDATPT 252(FCH)  Expansion Bank DATa PorT. The data you want to
                 store.

BCMDPT 253(FDH)  Expansion Bank CoMmanD (address) PorT.
```

<!-- p. 188 (pdf 198) -->

```text
HREXPT 255(FFH)  Home ROM EXtension select PorT. Setting Bit 7
                 gets the Extended ROM in Chunk 0 of the DOCK
                 bank (if no other Bank has enabled Chunk 0).
```

There are also 5 control registers to hold data for the Horizontal Select Register. These are:

```text
      HOLD    Temporary hold register
      ABN     Assigned Bank number (one per expansion port).
      BNA     Bank Number accessed register.
      HS      Expansion bank Horizontal Select Register (one for
                each expansion bank).
      Status  Status Nybble.
                Bit 0  Set to 0 if bank used an IRQ interrupt.
                Bit 1  Not used.
                Bit 2  Set to 0 if bank is responding to memory
                  read/write.
                Bit 3  Not used.
```

These registers cannot be addressed directly but must be addressed through ports 253 (BCMDPT) and 252 (BDATPT).[^c10-1] They also must be used to READ the registers if that is desired. OUT obviously WRITEs, IN obviously READs.

### Enabling the EXROM

This is quite simple to do--all we have to do is set bit 7 in an OUT 255 command. Unfortunately, PORT 255 just doesn't control the switching in and out of the EXROM. Each bit, or a group of bits controls something. They are:

```text
      Bit 0       Enable D-File 2 (Dual screen modes).
      Bit 1       Enable high color resolution mode.
      Bit 2       Enable 64 column display (with Bit 1).
      Bit 3, 4 and 5   Paper color for 64 column mode.
      Bit 6       Disable keyboard interrupts.
      Bit 7       Enable EXROM.
```

*Corrections in the table above:* Bit 2[^v12-18].

Looking at all of these we are in good shape if we are NOT in the Dual Screen mode. So all we have to do is OUT 255, 128 (Bit 7 on, rest off). Getting back after we are done with the EXROM is done with OUT 255, 0 (all bits off). If we happen to be in Dual Screen mode, we have to make sure that all the bits that are on stay on as we enable the EXROM and again when we Disable the EXROM. What this actually does is switch the EXROM to Chunk 0 of the Dock Bank and run it as if there. THUS EXROM and CHUNK 0 of the DOCK are mutually exclusive.

```z80
To enable:  IN A, (255)        To Disable:  IN A, (255)
            SET 7, A                        RES 7, A
            OUT (255), A                    OUT (255), A
            LD A, 1                         XOR A
            OUT (244), A                    OUT (244), A
```

*Corrections in the listing above:* LD A, 1[^v12-19].

<!-- p. 189 (pdf 199) -->

### Port 254

Port 254 is quite busy as well. On the input side, Bits 0-4 are used to read the keyboard signal, with Bit 6 reading the Cassette Tape Signal. On the output side (writing) Bits 0-2 set the Border Color, Bit 3 the cassette Tape output signal, and Bit 4 toggles the speaker (BEEP).

### Enabling a Bank of Extended Memory

Turning on and off the EXROM was quite easy as the Horizontal Select Register didn't have to be used except to turn the HOME ROM CHUNK 0 back on. But, suppose that you have some ROM attached to a peripheral device that you want to operate in an extension memory bank. Also suppose that it's 8k long and is memory mapped from 0 to 8k addresses and you wish to put it in Bank 1. With that information, it has to be Chunk 0 of Bank 1.

We have to work with the BCMDPT and the BDATPT registers. These out commands are as follows:

```text
     OUT 253 (BCMDPT)               OUT 252 (BDATPT)
0  Write command Type I       14  Reset controller--prepare to in-
                                    itialize.
                              13  Start Interrupt REG sequence
                              11  Initialization done-move to next.
                               7  Reset Interrupt Flag.

1  Write command Type II      14  Dump Hold to ABN
                              13  Dump Hold to BNA
                              11  Dump Hold to HS
                               7  Not used.
2  Write hold low nybble.
3  Write hold high nybble.
```

There are 4 Type I commands with the numbers 14, 13, 11 and 7. There are 3 Type II commands with the same numbers (7 is not used). From the BCMDPT commands we see that we are dealing with nybbles in all these cases. In fact, the Type I and Type II commands of BDATPT are what we call ACTIVE when LOW nybbles. 7 is equivalent to Bit 3 low, 11 is Bit 2 low, 13 is Bit 1 low and 14 is Bit 0 low.

The general procedure is to get the correct numbers to the Hold register and then DUMP them to the other registers (ABN, BNA, and HS). It might take a few steps to accomplish each move.

```text
     OUT 253, 0     These 2 steps start initialization by reset-
     OUT 252, 14      ting the controller.

     OUT 253, 2     Since HOLD is now zero, all we have to do is
     OUT 252, 1       write to the low nybble our BANK 1 (it will
                      also be our Chunk 0 on number).
```

<!-- p. 190 (pdf 200) -->

```text
     OUT 253, 3     Just to make sure, let's write the Hi nybble
     OUT 252, 0       as well.
     OUT 253, 1     Move HOLD to BNA
     OUT 252, 13
     OUT 252, 11    HOLD to HS as well.
```

We are now into Bank 1, Chunk 0. We will stay there until we switch back with another series of OUT commands.

This routine is doing a bank switch directly. There is another way of doing it using the Bank Switching routines which is somewhat simpler.

Before leaving the topic of bank switching, we can also READ the status of the Horizontal Select Register with the following in commands.

```text
     IN 253 (BCMDPT)
        0  read status--as per status nybble.
        1  not used.
        2  Read HS low nybble
        3  Read HS high nybble
```

These commands also can be handled through the Bank Switching routine called GET STATUS.

### Enabling Chunks in the Dock Bank

The DOCK (Cartridge) Bank is the Bank of Preferred RAM or ROM additions. It is BANK 0. To activate it you have to set BNA to 0 and then do an OUT 244, with the Chunks enabled in that Bank. Keep in mind AROs or LROS type cartridges--OUT 244, 240 will turn on all top 32k of the cartridge.[^c10-2] Fortunately, when turning on your computer, one of the first things it does is check to see if you have plugged in a cartridge. If you have, it reads the first 8 bytes at the start of the 32k mark and automatically sets itself up to work from the cartridge port.

### Enabling More Chunks of the EXROM

At present, only chunk 0 can be activated. This contains the EXROM. Only a hardware change will allow you to use higher chunks in Bank 254 as address lines 13, 14 and 15 are not interpreted. Another 74LS32 chip must be added to handle that. The implementation of this is available thanks to John Olliger. His article appeared in Syncware News, Vol. 2, #3, Jan-Feb 1985. An advantage to doing this is that the EXROM bank is native to the computer whereas other banks are not. The Disadvantage is that the 254 bank cannot be used at the same time as the Dock (0) bank. However, with 253 other banks available one may also wonder why one should bother making a hardware change when all the others just require software changes.

[^v12-1]: Library note: active low is right for the software memory-selection byte (the cartridge header byte and the C register given to BANK ENABLE), but port 244 itself is active high, bit *n* = 1 selecting Chunk *n* of the Dock/EXROM, as the DKSPT entry on p. 187 says; BANK ENABLE complements the byte before writing it (`LD A,C / CPL / OUT (F4H),A`, RAM copy $64C4). See CLAUDE.md (I/O ports) and docs/technical-manual/02-hardware-guide.md §2.1.13.5.

[^v12-2]: Corrected against the ROM. The original printed "we specified Chunk 1 in Bank 0"; `OUT 244, 1` sets bit 0, and bit *n* of port 244 selects Chunk *n*, so it switches in Chunk 0 (0-8191) of the Dock bank in place of the HOME ROM's first 8k, which is where the disk ROM sits (the DKSPT entry on p. 187 agrees: Bit 0 = Chunk 0). The register is a plain latch: it does not "find" anything. See CLAUDE.md (I/O ports) and docs/technical-manual/02-hardware-guide.md §2.1.13.5.

[^v12-3]: Corrected against the ROM. The original printed "25088 to 26646"; the HOME ROM start-up copier does `LD HL,1000H / LD DE,6200H / LD BC,0630H / LDIR` with the EXROM switched in (`OUT (F4H),1` and bit 7 of port 255 set), so EXROM 4096-5679 (the upper half of its 8k) lands at 25088-26671 ($6200-$682F); 26646 ($6816) is inside GO EX. The 26688 in the heading above is where CHANS begins ($6840, set by the HOME ROM), so the reserved area runs to 26687. See disassemblies/ts2068_home_rom_U16_stock.txt and docs/ts2068_memory_map.md.

[^c09-3]: Corrected. The original printed the bytes `21,30,FE` (LD HL,65072); DATA B starts at 65060 = FE24h, and the three LDIRs (9 + 26 + 6 bytes) consume the 41 data bytes 65060-65100 exactly only from that address.

[^c09-4]: Corrected. The original printed `LD BC, 25` and "For 25 bytes" over the bytes `01,1A,00`; the bytes are right, since the second data group (65069-65094) is 26 bytes and exactly fills 25648-25673 of the TS2068 ROM's resident code up to its `POP DE`/`POP AF`/`RET`.

[^c09-5]: Corrected. The original printed `LD A, 253` over the bytes `3E,FB`; the TS2068 ROM's resident code has `POP AF` (F1h) at both 25884 and 25968, at the ends of the BANK ENABLE and RESTORE STATUS routines whose `PUSH AF` the program replaces with NOP/DI (243), so the matching value is 251 (FBh, EI), as the bytes say.

[^v12-4]: Library note: this fix replaces BANK ENABLE's `PUSH AF` at 25753 ($6499) with NOP and its `POP AF` at 25884 ($651C) with EI, and puts the DI over `LD H,B` at 25757 ($649D), whose result is never used, so the stack stays balanced but BANK ENABLE no longer preserves A and the flags. Its callers rely on them: GOTO BANK ($6572) jumps to the target straight after `CALL BANK_ENABLE`, so a dispatcher JUMP reaches the service with A clobbered, and MOVE_BYTES ($668C, used by XFER BYTES) tests the transfer direction in A (`RLCA / RRCA / JR C`) right after its `CALL BANK_ENABLE`, so the direction becomes arbitrary. A safer form, used by the community EXROM revision, is to leave 25753, 25757 and 25884 alone and put DI/EI over `PUSH BC`/`POP BC` instead (POKE 25754,243: POKE 25883,251) together with that revision's BE_NTDOCK rewrite (POKE 25809,203: POKE 25810,255: POKE 25811,24: POKE 25812,237) so that C is no longer altered; the RESTORE STATUS half of the fix (25930, 25968) is unaffected. See docs/exrom_revision_analysis.md and disassemblies/ts2068_exrom_U20_stock.txt (GOTO_BANK, MOVE_BYTES).

[^v12-5]: Library note: the nine POKE values in each column are correct, but there are four bad entries in the EXROM relocation fix table, not three: besides the three repaired above, the entry $64AC (EXROM $1D34) should be $64A9, so moving the code leaves `CALL 635CH` at 25768 unrelocated and adds 97C0H to the two bytes at 25772-25773 (`LD D,A0H` operand, `PUSH AF`). Add to UP: POKE 64617,28: POKE 64618,251: POKE 64620,160: POKE 64621,245, and to DOWN: POKE 25769,92: POKE 25770,99: POKE 25772,160: POKE 25773,245 (the DOWN set is needed only if the UP set was applied). This site runs only when expansion banks exist (BS_MAX_BANK not 0), like those at 25870 and 25878. A simulation of the relocation also shows that `CALL 651EH` at 26435 in XFER BYTES is missing from the table altogether (its entry $674F should be $6744), so after the UP POKEs its operand still points at low RAM; to complete the repair add POKE 65284,222: POKE 65285,252 to UP and POKE 26436,30: POKE 26437,101 to DOWN. See docs/ts2068_errata_and_notes.md (Relocation Fix Table Misses Four Operands) and docs/exrom_revision_analysis.md (group 13).

[^v12-6]: (unverified) The AROS set-up in the HOME ROM places the line buffer ARSBUF at 26688 ($6840, 208 bytes) followed by the machine-code area the cartridge header asks for, so the start of VARS depends on that header value; a fixed 32553 cannot be derived from the ROM.

[^v12-7]: (unverified) Whether USR code in an AROS cartridge is confined to one chunk cannot be tested from the ROM listings; the Technical Manual (docs/technical-manual/06-known-bugs.md §6.3.1) records a related USR fault: the wrong nibble of the memory-selection byte is tested, so a valid cartridge address can be treated as a Home bank address.

[^v12-8]: Corrected against the ROM. The original printed `LD (23698), HL`; the address of MEMBOT (23698, 5C92H) must be stored in the system variable MEM at 23656 (5C68H). Storing it in MEMBOT itself leaves MEM unset and overwrites calculator memory 0. See docs/technical-manual/06-known-bugs.md §6.1.2 and docs/ts2068_system_variables.md (MEM).

[^v12-9]: Corrected against the ROM. The original printed "Bit 1"; INPUT sets bit 0 of the cartridge flag (HOME ROM $222E) and PRINT clears it ($215C). Bit 1 is the AROS quoted-string flag, toggled on each `"` by SKIPIT ($25A5-$25AE). See docs/ts2068_system_variables.md (ARSFLAG).

[^v12-10]: Library note: 23748/9 is ARSBUF, the pointer to the Home RAM buffer (26688, $6840) that the next AROS line is copied into; the address of the next line in the cartridge itself is kept in NXTLIN (23637/8). See docs/ts2068_system_variables.md and the HOME ROM AROS routine (`LD HL,6840H / LD (ARSBUF),HL`).

[^v12-11]: Library note: what this paragraph describes is GET BANK NUMBER ($645E, service 15). GET BANK STATUS ($6405, service 14) takes a bank number in B and returns that bank's memory selection (active low) in C, as the service table on p. 178 says. See disassemblies/ts2068_exrom_U20_stock.txt (GET_STATUS, GET_NUMBER) and docs/ts2068_dispatcher.md.

[^v12-12]: Library note: the counts are numbers of bytes of stack data, not numbers of parameters. CALL BANK takes them as ADDR, BANK/HS, PRM OUT, PRM IN (PRM IN on top): PRM OUT, pushed first, is the number of bytes passed to the routine (copied with LDIR before the call) and PRM IN the number it passes back (copied with LDDR afterwards), so the order above is right only if "IN" means "into the routine". Each count is itself a 2-byte word. See disassemblies/ts2068_exrom_U20_stock.txt (CALL_BANK) and docs/technical-manual/03-system-software-guide.md (§3.3.4).

[^v12-13]: Library note: the push order and the direction byte are right (bit 7 of the direction byte set = descending), but XFER BYTES is written to cross chunk boundaries: CREATE_BITMAP maps every chunk from start to end and the move is made in buffered pieces. The stock code for this is unreliable (see note [v12-4] on the direction test in MOVE_BYTES), which may be what was observed. See disassemblies/ts2068_exrom_U20_stock.txt (XFER_BYTES, CREATE_BITMAP).

[^v12-14]: Library note: that is the documented interface, and it holds for the HOME and expansion banks, but the stock GET STATUS ($6405) returns the DOCK and EXROM status in B with C = 0 (GS_DOCK, GS_EXT); it returns them in C only after the correction program on p. 172-173 has been run (its DATA B second group rewrites this code at 25648). See disassemblies/ts2068_exrom_U20_stock.txt (GET_STATUS) and docs/exrom_revision_analysis.md (group 11).

[^v12-15]: Library note: code 135 enters RESTART 16 ($0010 = `JP 11EDH`, SENDCH), which outputs to the current channel, not necessarily the screen, the same as 134. See disassemblies/ts2068_home_rom_U16_stock.txt and docs/ts2068_dispatcher.md.

[^v12-16]: (unverified) Bank priorities above the Dock concern the expansion-bank (Bus Expansion Unit) hardware, which was never produced, so neither the ROM nor the library can confirm them. See docs/ts2068_memory_map.md.

[^v12-17]: (unverified) BDATPT/BCMDPT and the HOLD/ABN/BNA/HS/Status registers belong to the never-produced Bus Expansion Unit. The Technical Manual (Table 2.1.13-1) lists ports 252 and 253 as reserved for bank switching, "not implemented", and the stock ROM never uses them: its WRITE_BS_REG/READ_BS_REG reach the BEU registers as memory addresses (high bytes $40, $80, $A0, $C0) strobed through the sound chip's I/O port A. The names ABN, BNA and HS match ROM symbols; HOLD and the command codes on p. 189 do not appear in the ROM. See CLAUDE.md (I/O ports) and docs/ts2068_memory_map.md.

[^c10-1]: Corrected. The original printed "ports 253 (BDATPT) and 252 (BCMDPT)"; the port list on the previous page and the OUT 253 (BCMDPT) / OUT 252 (BDATPT) command table that follows both define BCMDPT as 253 (FDH) and BDATPT as 252 (FCH).

[^v12-18]: Corrected against the ROM. The original printed "(with Bit 0)"; bits 0-2 are a single 3-bit video mode field (000 normal, 001 dual screen, 010 high colour resolution, 110 64 column, other values undefined), so 64-column mode is Bits 1 and 2 together (6), not Bits 0 and 2. Bits 3-5 give the 64-column ink, with paper its complement; Bit 6 set inhibits the 17 ms interrupt that drives the keyboard scan. See docs/ts2068_video_and_cartridges.md and CLAUDE.md (DECR).

[^v12-19]: Corrected against the ROM. The original printed `XOR A` before the `OUT (244), A` of the "To enable" sequence; with port 244 at 0 every chunk comes from HOME, so the EXROM is not visible. The ROM maps it with bit 7 of port 255 set and port 244 bit 0 set (HOME ROM start-up copier: `LD A,1 / OUT (F4H),A / IN A,(FFH) / SET 7,A / OUT (FFH),A`, undone with `RES 7,A / OUT (FFH),A / XOR A / OUT (F4H),A`). For the same reason `OUT 255, 128` alone (p. 188) does not bring in the EXROM, and the HSR is needed to enable it, not only to turn HOME chunk 0 back on (p. 189). The code must run from RAM, not from HOME ROM chunk 0. See docs/technical-manual/05-advanced-concepts.md (§5.3.1) and CLAUDE.md (I/O ports).

[^c10-2]: Corrected against the ROM. The original printed "OUT 244, 15"; port 244 is active high, bit *n* enabling Chunk *n* of the Dock bank, so 15 enables Chunks 0-3 (the bottom 32k) and the top 32k (Chunks 4-7, the AROS area) needs 240. The ROM's BANK ENABLE writes the complement of the active-low memory-selection byte to the port (RAM copy $64C4, EXROM $12C4: `LD A,C / CPL / OUT (F4H),A`), and 15 is the AROS header's active-low value for Chunks 4-7 (p. 174: 00001111), so 15 is that byte uncomplemented. See CLAUDE.md (I/O ports) and docs/technical-manual/02-hardware-guide.md.
