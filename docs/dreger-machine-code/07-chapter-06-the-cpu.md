<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 85–98. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 6: The Central Processing Unit (CPU).*
*[← previous](06-chapter-05-beep-and-sound.md) · [book README](README.md) · [next →](08-chapter-07-assembly-language.md)*

---

<!-- p. 85 (pdf 95) -->

# Chapter 6: The Central Processing Unit (CPU)

```text
TYPE: Z80A 8 bit DATA BUS/16 bit ADDRESS BUS
OPERATING FREQUENCY: 3.528 megaHz
PHYSICAL SIZE: Dual INLINE 0.514x2.100x0.213
CONTACTS: 40
ACTUAL SIZE OF CHIP: 0.200x0.200
MANUFACTURER: ZILOG INC., 10460 Bubb Rd., Cupertino, CA 95014
2nd SOURCE: Mostec INC., 1215 W. Crosby Rd., Carrolton, TX 75006
```

Looking at the specifications we notice that the three main functions of the plastic case are:

1. Protect the silicon chip
2. Provide heat sinking for the chip
3. Provide a means of connecting with the outside world--going from 40 connections in less than an inch of peripheral space to 4 inches of connections in 2 rows.

What are these connections? For once they are not listed in the User's Manual, but they are given in the Technical Manual or The T/S 2068 Intermediate Advanced Guide.

From what we already know, there must be 16 address lines usually labeled A0 to A15, and 8 data lines usually labeled D0 to D7. We need power, labeled +5V and a ground, labeled GRD. That's 26.

We also need a WRite line and a ReaD line along with a MREQ (Memory request) and of course RFSH (Refresh) to refresh memory.

Everything runs by the clock signal of 3.528 megaHz supplied by an outside oscillator, and comes into the CPU at the contact labeled with the Greek letter Phi (looks like a O with a CAP I through it). As we found out one clock cycle is called a T state. Generally it takes 4 T states to just read an instruction, and another 3 T states to read memory or write to it. In the case of a port input or output further delays can be encountered with a WAIT T states--that is what the WAIT line is all about. Generally we don't worry about T states when writing machine code, but timing must be considered when using inputs and outputs to or from peripherals faster or slower than the CPU. Since we are at it, IORQ is Input/Output ReQuest.

M1 is the line used to say Read An Instruction--It is active when the CPU is reading the first of a new set of instructions, or in the case of an extended instruction, the 2nd, and if necessary the 3rd instruction as well but not data bytes. M1 stands <!-- p. 86 (pdf 96) --> for MODE 1--Read an Instruction.[^v08-1]

INT (INTerrupt) is an interrupt from a device. It is honored at the end of the execution of the present instruction. It is ignored if Disable Interrupt is in force.

Another type of interrupt is the BUSRQ (BUS ReQuest). The device needs a BUS as well. Telling a device it has the bus is done with BUSAK (BUS AcKnowledge).

NMI is the Non-Maskable Interrupt--always honored at the end of the execution of the present statement even if DI is active.

RESET is the hardware equivalent of RANDOMIZE USER 0. It is the first thing done by the CPU upon receiving current.

HALT causes the computer to do nops (no operations) until it gets an interrupt. If you counted, that's a total of 40 lines.

A word about line notation. Most of these lines are written overlined--they have a line over the symbols or mnemonic. This line means "active when low". That means they have +5 volts on them when inactive, dropping to zero when active. Overlining symbols has the mathematical terminology of NOT.

Please note: There are no instructions in the machine code set that tell the CPU to turn off or on the voltages on these various lines. The CPU automatically switches them at the right times internally as needed to execute the instructions. This is what the control portion of the CPU is all about. Similarly, as it reads an instruction, the control unit knows exactly how many bytes follow with direct data for that instruction before the start of the next instruction.

Should you pry the plastic case off the top of a CPU (definitely NOT recommended except in the case of "blown" CPU that is beyond repair), you will find a spiderweb of fine gold wires leading from the edges of the centrally placed silicon chip to the various terminals. These wires are welded in place with the aid of a low powered microscope as they are too tiny to be done for very long without this magnification aid. The tininess of everything makes them impossible to repair without special equipment.

## The CPU--Internal Organization

Use the diagram on the following page when reading this discussion. The CPU has its own internal memory storage units. To differentiate them from external memory we call them registers. You have already met some of them. We have 8 main registers. F, the flag register, can't be used for storing numbers but just keeps track of the results of various math and logic operations. A, the accumulator, is the main arithmetic and only logic register in the CPU. It can use instructions that no other register has. It accumulates the result of various operations. General purpose

<!-- p. 87 (pdf 97) -->

**REGISTERS OF THE CPU**

*[Diagram: block diagram of the Z80's internal registers. A horizontal DATA BUS runs across the top. Below it, from left to right: an F/A register pair box with its alternates F'/A' beneath; a register block of B C B' C' / D E D' E' / H L H' L'; an IX/IY box; and separate small boxes for I and R. An SP box and a PC box sit to the right, both fed by an INC|DEC unit. An ALU box connects to the A/F registers; an ADD/SUB unit (trapezoid) takes input from the H/L registers and feeds the PC and IX/IY. A horizontal ADDRESS BUS runs below, connected to the PC. At bottom: a box "INTERNAL CPU", a box "INST CONTROL" connected to the data bus, ALU and address bus, and linked to a box "EXTERNAL LINES".]*

registers are B, C, D, E, H, and L. These six registers can be used individually or in the pairs BC, DE, and HL in which cases they generally are designating an address. IX and IY are special purpose address registers. IX and IY have the ability to get or send data to an offset -128 to +127[^c05-5] from where they are set to. In the 2068, IY is always pointing to 23610--right in the middle of the System Variable Table. The beginning machine code writer should not mess with these two registers until he/she knows what he/she is doing as they have to be reset before coming back to Basic.[^v08-2]

The Prime Registers: AF, BC, DE, and HL have prime registers--an alternate set where data can also be temporarily stored. You can't operate on the data in the prime registers until you switch it back to the regular registers at which time the regular registers get put in the primes. AF and AF' can be exchanged separately from the rest which must be done en mass--BC, DE, and HL exchanged with BC', DE' and HL' respectively as a group.

The Program Counter: (PC) Since there are no line numbers in machine code and each instruction follows the next, this register keeps track of the address of the next byte of information to be used or interpreted. It is added to or subtracted from in the case of JUMP RELATIVEs and changed to the address specified in CALLs and JUMPs. These instructions are the machine code equivalents of GOTOs and GOSUBs.

The Stack Pointer: (SP) Keeps track of the address of the last number stored on the machine stack. We talked about this back in Chapter 2...go back and review its operation if necessary.

Two more registers complete the set. I is the interrupt mode register and is generally set to address 0063...this is the low part of the address--generally called a VECTOR. To it is added the high byte address at the time of the interrupt which may be <!-- p. 88 (pdf 98) --> zero. The result is a jump to the interrupt routine at that address.[^v08-3] The final register is the R (Refresh register) which is another vector address to which is added the top byte to give the address of the next section of RAM to be refreshed.[^v08-4]

Also on the diagram is a space called the ALU (Arithmetic Logic Unit) which handles all the OR, AND, XOR, CP and CPL operations done on the accumulator (A) register. It also sets the various flags in the F register which also includes overflow and underflow conditions encountered in add or subtract.

The flags in the flag register are: Carry, negative, parity/overflow, half carry, zero and sign. Each occupies a bit of the F register being "on" with a "1" and "off" with a "0". We can test for the state of all except negative and half carry at any time. These last two are used by DAA (Decimal Adjust Accumulator) instructions only. Flag conditions can be used to make conditional CALLs, JUMPs and RETurns.

We see two little boxes called INST which is internal logic to read the instructions and the CONTROL unit which turns on or off all those lines like RD, WR, IORQ etc. that we talked about earlier in this chapter. The CPU itself has to handle the decoding of the instructions, so naturally has a built in ROM for this interpretation...this ROM is not the same structure as the external ROM or RAM and can't be rewritten.

## Our First Machine Code Program

We have seen machine code programs earlier but this is the first one we are going to be explaining line for line. Okay, now that we know what the internal registers are, the mnemonics of Appendix B, which I told you to make a copy of, are starting to make sense. We use these registers to do our calculations and manipulations. We may use them singly or in pairs as we desire. Although we haven't discussed the complete set of instructions as yet, we are far enough along to understand this program.

The first thing we have to decide is where we are going to store it. Since it's going to be a short program, let's choose to start at the address 65000. Therefore, as we start to enter this program, we will do, in Basic, `CLEAR 64999`. This will set RAMTOP at 64999 and prevent any Basic from ever overrunning it. We will set up a loop to POKE in the various numbers starting at 65000. Then when we are ready to run it, we will use `RANDOMIZE USER 65000` from Basic.

It is going to be easier to give you the whole program and then explain it line by line. So here is the complete program. Please refer to it as we explain it.

```z80
ADDRESS CODE          LABEL      INSTRUCTION    COMMENT
65000   62,16                    LD A, 16       ATTR byte
65002   33,0,88                  LD HL, 22528   ATTR addr
```

<!-- p. 89 (pdf 99) -->

```z80
65005   6,64                     LD B, 64       Counter
65007   119           LOOP       LD (HL), A
65008   35                       INC HL
65009   5                        DEC B
65010   200                      RET Z          DONE-back to Basic
65011   24,250                   JR LOOP        If not, loop.
```

Before explaining the program, let me explain that like Basic, machine code has three main portions. First we set things up, then we do the calculations and end with the printout of the results.

Each machine code line can consist of 5 parts but always has 3. The essential 3 parts are the Address, Code and Instruction. The Label is to put a label on a line while the comment is to assist us in remembering what that line does--memory does get a bit foggy after several years. In this particular program we are going to change the PAPER color to RED and the INK to BLACK with no FLASH or BRIGHT. From our discussion of the ATTRibute byte we recall that paper color has to be multiplied by 8. Looking at the keyboard, we see RED = 2 so 8x2 = 16. Black is 0, so we add nothing for the INK color. Our attribute value is 16. We choose the A register to hold it. We pick this register as it is the register that lets us load it to an address as we do in line 4. Other registers don't have this instruction.[^v08-5] Therefore, we write on our paper under address 65000 and under instruction:

```z80
LD A, 16
```

(Load A with 16--all load instructions are always load the first with the second, or READ "with" at the "comma" as we say). Under comments we write ATTR Byte to remind us that A holds the attr byte value.

Okay, but we haven't coded the line as yet. Although Appendix B is good for decoding code back to mnemonics, it's lousy for coding a program. Later on we will give you another format to do that. Suffice it for now that if you look long enough you will find the instruction LD A, n at code 62.

N is not a register is it? N is the symbol the table use to designate a number. A single N is a single byte number, a double N a two byte number. All direct load instructions require that the next byte after the instruction hold the value we want for n, or two bytes if nn is needed. Therefore, we can code our first line with 62,16. This used 2 bytes so the next available byte is address 65002 as we start our 2nd line.

Next we have to answer the question, where are we going to load these attributes? Obviously the Attribute file, but where is that file? You now are beginning to see how important those first chapters of this book are. If we don't remember, which is going to be 90% of the time, we have to look it up. Where do we look? How about a memory map? If you modified your map like I <!-- p. 90 (pdf 100) --> told you to do, its start is listed as 22528. If you didn't modify your map you have to consult Chapter 3...believe me that 95% of what you will ever need to know and perhaps a lot of things you will never use are in those chapters. Now, do we want the starting address of the Attribute file? Yes, we want to change the top two rows. We have a choice of registers to use to hold this address and the one we choose is purely up to the programmer. However, there are certain advantages to use the B and C registers as counters so let's avoid them to hold our address. The DE and HL register pairs also are ideal for use as address pointers so let's pick HL. We want the instruction:

```z80
LD HL, nn.
```

NN will be our 22528. We write it as LD HL, 22528 and put the comment ATTR ADDR behind it. This is instruction # 33 so under the CODE column we write "33,". We now have to convert 22528 to low and high byte format. Taking out our handy calculator we divide 22528 by 256 and get 88.00000. Our high byte is 88, and because the answer came out even our low byte is 0. Remembering that it's LOW BYTE FIRST we write a "0,88" in back of our 33,. Since this instruction took 3 bytes the next byte for line 3 is 65005.

To continue we have to know some more information. We want to set up a FOR/NEXT loop to write 16 to the top two lines of screen attributes. How are they arranged in the file? If you don't remember, where do you find it? Chapter 3 again. Okay, there is one per character and they go across the screen for the first line and then the second, the third etc. We thus find that we can do all of them in a row without anything fancy. How many are we going to do? Well, there are 32 per line and we want 2 lines which is 64. Time to set up our counter. We are used to counting up from zero to 64, but in machine code it is easier to count down as it is easier to detect a zero than any other value. Let's use B as our counter and load it with 64. We want the instruction:

```z80
LD B, n
```

which is instruction #6. We write under instruction, LD B, 64 and write under comment, counter. Under code we write 6,64. We have thus started our FOR/NEXT loop with the statement `FOR B = 64 TO 1`. We can't use a STEP in machine code but will show you how that works later on. This used 2 address bytes so the next address for line 4 is 65007.

We have now finished setting up, or initializing our program. We have no calculations or processing to do so we move on to printing out our results. At this point A contains the attribute we wanted printed to address HL. In our mnemonics, () around registers or our "nn" means "memory location pointed to by". So we want:

```z80
LD (HL), A
```

<!-- p. 91 (pdf 101) -->

There are no instructions like LD (xx), Y , where Y is any register other than A. This is why we chose A in line 1.[^v08-6]

Now another important point. After this is done, register A will still hold 16, it is not erased. HL also still contains 22528. But memory location 22528 will now hold 16 as well. This is fine as we want to write 16 to address 22529 next. So all we have to do is get HL to 22529. How do we do that? Remember INCrement? We just do:

```z80
INC HL
```

It's instruction # 35. That goes in the CODE area. We update our address to 65009 for the start of the next line.

We now have to take care of our counter with a STEP -1. Remember DECrement?

```z80
DEC B
```

It's instruction #5. Every time we do an increment or a decrement of a single register, the CPU looks at the value of that register after doing it and if "0" sets the ZERO FLAG in F. We can use this fact to get out of our FOR/NEXT loop by writing:

```z80
RET Z
```

RETurn if zero, else continue with the next line. Where does it return to? Well, we are NOT in a subroutine, so we go back to Basic. RET Z is instruction # 200. We write the comment, Done--back to Basic and update the address for the next line.

Suppose we are not done. What do we tell the computer? We really want to loop back and do another LD(HL), A. This is the machine code equivalent of NEXT B. We do a GOTO in the form of a JUMP but it is not a JUMP to an address where we give it an address, but a JUMP RELATIVE from where we are. We want the instruction:

```z80
JR, Dis
```

Dis is a displacement. It needs a signed number as it could be positive which would mean forward, or a negative number meaning backward. We want backward--to that LD (HL), A. To clarify to ourselves exactly where, we use a label. So at this point we label the line with LD (HL), A with the word "loop" and write behind JR, the same word "loop". Since "Dis" is a number just like n, it uses a byte in back of the code for JR, dis. which is code # 24.

What is the right number for the displacement? After reading the line but before executing it, the CPU increments the Program Counter to the start of the next instruction. Thus, the first byte of the next instruction becomes byte "0". The address holding our displacement will then be -1 which in signed binary is 255. That 24, will be 254. The 200 in the next line is 253. Continuing to count backwards we arrive at 250 when we hit the 119 <!-- p. 92 (pdf 102) --> of the LD(HL), A instruction. This is our displacement. Reread this paragraph again as it is very very important that you understand displacement.

What would our little program look like in Basic?

```basic
10 LET A = 16
15 LET HL = 22528
20 FOR B = 64 TO 1 STEP -1
25 POKE HL, A
30 LET HL = HL + 1
35 NEXT B
```

How many bytes does this Basic program take? Count 2 for each line number, add another 2 for line length, and another one for the enter code at the end of the line. Don't forget to add 6 extra bytes for the slug of each number. I got 105 bytes. Our machine code took 13. That's 8 times shorter.

Want to make a bet as to which runs faster? Enter it and then add the loader program below:

```basic
110 CLEAR 64999
115 FOR B = 65000 TO 65012
120 READ X
125 POKE B,X
130 NEXT B
135 DATA 62,16,33,0,88,6,64,119,35,5,200,24,250
```

Also enter the following lines:

```basic
40 PAUSE 0
45 RANDOMIZE USR 65000
59 STOP
```

Also change line 10 to `LET A = 32` so that the Basic will give you Green paper and the machine code red. Now do a `GOTO 100` and get the code entered. Then do a RUN and compare the speed of writing the attributes. Time the speed from the time you hit the enter key--`PAUSE 0` requires that. Don't blink as the machine code gets it done between one screen refresh and the next.

Saving our program: Okay, so it's not that great a program to save but at least you should know how to save code. You do:

```basic
SAVE "RED" CODE 65000, 13 for tape
MOVE "RED.BIN", 65000, 13 for disk (AERCO system).
```

*Notes on the listing above:* the length is 13 bytes;[^v08-7] the disk line is for the AERCO interface.[^v08-8]

## For Hardware Hackers Only

You don't have to know the inner workings of the CPU, what lines are turned on and off to make a program run or to write programs. But, if you are curious as to what all is happening read on.

<!-- p. 93 (pdf 103) -->

We will start with the Basic Line "RANDOMIZE USR 65000". The token USR is interpreted by the code in ROM as "GOSUB to the address which follows". PPC and SPPC at this point contain the present line number and subline number. The Basic program counter, which keeps track of the Basic address, by this time has stepped through the slug to get the number and now holds the address of the following ":" or ENTER. It increments once to get the address of either a line number or a token and puts this in OSPPC.[^v08-9] The computer itself is interpreting USER somewhere in ROM and Pushes an address to the stack then loads the program counter with the number. The next instruction it will read is at the address you gave it. By now you should know how the machine stack works with a PUSH and a POP. If not go back to Chapter 2 and review it. Whenever a pair of registers is PUSHed to the stack, the STACK POINTER gets decremented two spots to keep track of the address of the last number PUSHed. We now have gone from machine code that causes your computer to operate like Basic to your machine code. It's all machine code whether yours or ROM. It should now become obvious to you that another ROM written with machine code could interpret PASCAL, or COBOL or C or any other language one knows of or wishes to invent.

We have skipped a few details in the above description as far as hardware operations are concerned--we haven't told you which lines went on and off. We will do that from here on out. It's time to get our first instruction from memory. Use the diagram on the next page to help you through the various cycles.

## Getting An Instruction (M1 Cycle)

For the instruction LD A, 16. During the first clock cycle, the M1 line, normally high, drops low and the value of the Program Counter is put on the address bus. During the last half of clock cycle 1, MREQ and RD, also normally high, drop low, signaling a read of memory. The WAIT line is sampled for a signal. Should there be a signal, the M1 cycle is extended for more clock cycles. If no WAIT is encountered, the memory cell being addressed will be putting its value on the data bus--that is all 8 memory cells, a bit each on each different line during cycle 2. In the CPU, the Instruction Register receives the data byte. During the next two clock cycles the instruction decoder inside the CPU will be interpreting the instruction and deciding what to do next. For our reading of address 65000, it's trying to figure out what to do with 62. The Program Counter is incremented to 65001.

## Memory Refresh (Cycle 3 and 4 of M1)

While the instruction decoder is doing its work, the CPU is busy refreshing some memory by putting the address on the address bus, dropping MREQ again with RFSH. At the end of cycle 4, M1 finally goes high signaling the end of the Instruction Read Cycle. It took 4 clock cycles.[^v08-10]

<!-- p. 94 (pdf 104) -->

## M1 Cycle

**M1 CYCLE (GET OPERATION CODE)**

*[Diagram: timing diagram over four clock cycles T1-T4. Rows: Clock Cycles, A0-A15, MREQ (overlined), RD (overlined), WAIT (overlined), M1 (overlined), D0-D7, RFSH (overlined). The address bus changes at the start of T1 and again at the start of T3 (refresh address); MREQ and RD go low during T1 and return high at the end of T2; MREQ pulses low again during T3-T4; M1 is low through T1-T2; D0-D7 carries data around the end of T2; RFSH is low during T3-T4; WAIT is shown sampled during T2.]*

## Memory Read Cycle

**MEMORY READ CYCLE**

*[Diagram: timing diagram over T1-T4. Rows: Clock Cycles, A0-A15, MREQ (overlined), RD (overlined), D0-D7, WAIT (overlined). Address changes at the start of T1; MREQ and RD go low during T1 and return high late in T3; data is valid on D0-D7 during T3; WAIT is shown sampled during T2.]*

## Memory Write Cycle

**MEMORY WRITE CYCLE**

*[Diagram: timing diagram over T1-T4. Rows: Clock Cycles, A0-A15, MREQ (overlined), WR (overlined), D0-D7, WAIT (overlined). Address changes at the start of T1; MREQ goes low in T1 and high late in T3; WR goes low in T2 and high late in T3; data is held on D0-D7 from T1 into T4; WAIT is shown sampled during T2. The words "MEMORY READ" are printed below the diagram's label column at the foot of the page.]*

<!-- p. 95 (pdf 105) -->

By this time the instruction decoder has decoded that 62 into LD A, N. It notes that it has to READ the next byte of memory to get N so the first two cycles of M1 are repeated except that M1 doesn't drop low this time. WAIT again is sampled for delays if any. In cycle 3 of memory read, the value of 16 from address 65001 gets written to A and the program counter is again incremented. No memory refresh this time. Memory Read takes 3 clock cycles. We are done with the first line of instruction.

Instruction 2, (LD HL,22528). By now it should be clear that it will be one M1 cycles followed by 2 Memory Read cycles to get the data to L and H respectively. Another part of memory will be refreshed again during the last half of the M1 cycle.

Instruction 3, (LD B, 64). This is a duplicate of the first instruction with the only difference being a shunt of the data to register B.

Instruction 4, (LD (HL), A. This requires a WRITE TO MEMORY Cycle after the M1 cycle. The cycle is similar to the read memory cycle except that the WR line goes low. It also takes 3 clock cycles. Instead of the value of the program counter going onto the address bus, the value of HL is put there and the data bus gets the value of A, with the memory cells being set to write.

Instruction 5, (DEC B). Only requires an M1 cycle.

Instruction 6, (RET Z). Also only requires an M1 cycle if false and the program goes on with the next statement.[^v08-11] If the Z Flag is set, the value of the last 2 bytes in the machine code stack are put into the program counter and the stack pointer is incremented twice. Since the program counter is now pointing back to the Basic ROM we are again back in Basic.

Instruction 7, (JR, 250) will require an M1 and a Read Memory Cycle. In our case the 250 is already in 2's complemented form so it's merely sign-extended and added to the full 16-bit program counter, with any carry or borrow going into the high byte.[^c05-6][^v08-12] Thus the next instruction gotten will be LD (HL), A again.

## I/O Timing Cycle

Although our program doesn't use it, readers may find the I/O timing cycle of use. We have included a WAIT cycle which is quite prevalent when inputting or outputting to peripherals. It is on the next page.

There are several more types of cycles like:

- Interrupt (INT)
- BUS Request
- Interrupt (NMI)
- Halt

<!-- p. 96 (pdf 106) -->

They are beyond the scope of this book.

**I/O TIMING CYCLE**

*[Diagram: timing diagram over T1-T4. Rows: Clock cycles, A0-A15, IOREQ, RD, D0-D7 (in), WAIT, WR, D0-D7 (out). Address changes at the start of T1 and at the end of T4; IOREQ and RD (for input) or WR (for output) go low at the start of T2 and return high late in T4; WAIT is shown sampled during T3; input data ("IN") is valid on D0-D7 during T4; output data is held on D0-D7 from T1 through T4.]*

## Comparing the Z80 with the 8080 and the 6502 CPU's

You might think that the Z80 is quite limited in what it can do with its few registers. How would you like to do with less? The Z80 was developed from the 8080 CPU. The difference is that the 8080 has no indexing registers (no IX and IY) and no prime registers and no extension instructions (all the CB and ED instructions don't exist. Without IX and IY there is no need for FD and DD sublists).

That translates to no multiply and divide instructions except in the A register with RRCA, RLCA and RLA. There is nothing for the rest of the registers so values have to be constantly be shifted into and out of the A register. Also no bit testing, resetting and setting. And no superpowerful instructions like LDIR, CPIR, LDDR, INIR, OTIR etc. In addition, some of the commands have to be changed so all the JR conditionals don't exist including DJNZ. There are less than 256 instructions compared to 800+ for the Z80. Okay, the assembly language is more difficult to remember at the start but writing in it becomes much more effective. Actually, the Z80 assembly language is easier to learn as the mnemonics are in English, not computerese.

### 6502 vs. Z80

If you are crying over only 7 registers to work with, try working with only A, X and Y and again less than 256 instructions. The code goes on ad infinitum as values have to be stored and retrieved a lot more. In addition, the 6502 clock is down in the 1 to 2 MHz region[^c05-7] so it is no wonder that the 2068 is 4 to 10 times <!-- p. 97 (pdf 107) --> faster than the Apple II or the Atari or the Commodore (64k models)--except when they are using CP/M. Well, in CP/M you insert a Z80 CPU board and run the computer with that. My question is, why didn't they design the computer with the Z80 in the first place?

## The Future

The future belongs to the 16 bit processor. Only the reduction in memory costs will say when this will happen but 16 bit 68000 processors are already available (FAT MAC, SINCLAIR QL, etc.) The programs that these machines run are quite complex and don't leave much chance for the beginner to really write a program that can take advantage of the machine's ability. The future is also aimed at the user and not the programmer. Users have to live with their programs. With the 2068, I feel that I can change things to the way I want them which is the computer living with me, not me living with the computer. I get quite irritated with user types who say, "But you can't do it that way on the computer". Computers also will become even more user friendly. In fact, that is one of the complaints about the MAC. It is so user friendly that there is very little room to do anything useful. Voice recognition of commands really is going to gobble up memory fast.

Learning a second assembly language is going to be easier than the first time as many instructions do carry over from CPU to CPU even if the mnemonics do not.

<!-- p. 98 (pdf 108) -->

[^v08-1]: Library note: M1 means "machine cycle one", the opcode-fetch cycle, not "Mode 1"; it is asserted for each prefix byte (CB, ED, DD, FD) and the opcode byte, and in the DD CB d op / FD CB d op forms only the two prefixes get M1, so no instruction has a third M1 fetch (general Z80 behaviour from the Zilog manual; docs/z80_combined_reference.md does not describe the M1 line).

[^c05-5]: Corrected. The original printed "+ or - 127"; the Z80 index displacement is a signed byte with a range of -128 to +127.

[^v08-2]: Library note: only IY must still hold 23610 ($5C3A) on return to Basic; nothing in the ROM's USR return path depends on IX (the ROM's own PARP routine loads IX without saving it), so IX is free for user code; see docs/z80_combined_reference.md ("Use IX instead"; PARP $03F3).

[^v08-3]: Library note: I is the interrupt vector register, not an interrupt-mode register. The ROM does set it to 63 ($3F, INIT $0D36), but in interrupt mode 2 I supplies the HIGH byte of the vector-table address (the device supplies the low byte), and the 2068 runs in mode 1, where every interrupt goes to $0038 and I is not used for vectoring; see docs/z80_combined_reference.md (LD I,A).

[^v08-4]: Library note: during the refresh half of each M1 cycle the CPU puts R on the low address lines and I on the high ones; only the low 7 bits of R count up after each opcode fetch; see docs/z80_combined_reference.md (register table).

[^v08-5]: Library note: LD (HL),r exists for every 8-bit register (opcodes 70h to 75h and 77h), as do LD (IX+d),r and LD (IY+d),r; only the absolute-address store LD (nn),A and the stores through BC or DE are limited to A, so A is the natural choice here rather than the only one; see docs/z80_combined_reference.md (LD (HL),r).

[^v08-6]: Library note: as at p. 89, LD (HL),r takes any 8-bit register; the 8-bit stores limited to A are LD (nn),A, LD (BC),A and LD (DE),A, and there are also 16-bit stores LD (nn),HL/BC/DE/SP/IX/IY; see docs/z80_combined_reference.md.

[^v08-7]: Corrected against the ROM. The original printed "65000, 14" in both lines; the program is 13 bytes, 65000 to 65012, as the loader's FOR B = 65000 TO 65012 and the text's "Our machine code took 13" say (14 saved one extra byte).

[^v08-8]: (unverified) The AERCO disk interface and its MOVE syntax are not covered by the ROM or the library.

[^v08-9]: Library note: the statement-number variable is SUBPPC ($5C47), alongside PPC ($5C45); the interpreter's pointer into the Basic line is CH_ADD ($5C5D); OSPPC (OSPCC, $5C70) is the statement number for CONTINUE and is not set by USR; see docs/ts2068_system_variables.md.

[^v08-10]: Library note: the fetch does take 4 clock cycles, but M1 goes high again at the end of cycle 2, when the refresh starts, as the figure on p. 94 shows (general Z80 timing from the Zilog manual; not covered by the library).

[^v08-11]: Library note: a RET Z that is not taken takes 5 clock cycles (an M1 cycle lengthened by one), not a plain 4-cycle M1; taken, it takes 11; see docs/z80_combined_reference.md (RET Z 11/5).

[^c05-6]: Corrected. The original said the displacement is "merely added to the low register of the program counter and any carry ignored and not put in the high byte"; on the Z80, JR adds the sign-extended displacement to the full 16-bit program counter, so a jump can cross a 256-byte page boundary (in this program the target 65007 is on the same page as 65013, so the result is the same here).

[^v08-12]: Library note: besides the M1 and memory-read cycles, JR takes 5 more clock cycles to add the displacement, 12 in all (4 + 3 + 5); see docs/z80_combined_reference.md (JR 12).

[^c05-7]: Corrected. The original printed "kiloHz region"; the 6502 in the Apple II, Atari and Commodore 64 runs at about 1 to 1.8 MHz.
