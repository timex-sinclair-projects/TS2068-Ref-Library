<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 99–126. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 7: Machine Code--Assembly Language.*
*[← previous](07-chapter-06-the-cpu.md) · [book README](README.md) · [next →](09-chapter-08-floating-point-calculator.md)*

---

<!-- p. 99 (pdf 109) -->

# Chapter 7: Machine Code--Assembly Language

Think of assembly as a bunch of routines put together much as one does subroutines in Basic. In your study of assembly you will be making a collection of these routines which will be used again and again. If you don't have a notebook listing these routines, preferably in corrected, debugged form, you will have to reinvent them every time you need them. This is as good a time as any to start. This should be a different notebook than the one you use to work out routines in. Looseleaf notebooks are excellent for this purpose as they allow you to rearrange things and insert better routines for older ones as you perfect them.

We write our programs in the mnemonics of assembly language which then have to be converted to the number sequences of machine code which is what is entered into computer memory. The experienced writer will already be using an assembler program such as "Hot Z" to do all the machine coding for them. For the novice, I strongly recommend doing a few programs by hand. In this way we don't have to worry about all the ins and outs of using a complex program like Hot Z. It's a good program but can be frustrating the first few times that you try to write a program with it. We will work with just pencil and paper. I do recommend a pencil with a good eraser. The beginner makes a lot of mistakes. The terms ASSEMBLY LANGUAGE and MACHINE CODE are sometimes used interchangably by authors when in reality each has its own meaning.

Machine code, the number sequences, can be written in Hexadecimal (Hex) or in decimal. One has to be specific about which is being used as 10h is different from 10d. Sometimes people write the numbers of assembly language in decimal with the machine code in Hex. Addresses also can be written in Hex or decimal. Reading Hex addresses is a real pain. One can choose to write in any convention one desires. But be consistent. If everything on the assembly side is in decimal, keep it that way throughout. Don't go mixing the hex with the decimal. We are going to use decimal throughout--address, machine code and assembly numbers.

## Other Conventions Used

We have already met some of these but here they all are again:

1. Read the word "with" everytime you see a comma. `LD A, B` is Load register A with register B.

2. () are read as "the contents of the address". `LD A, (HL)` is

<!-- p. 100 (pdf 110) -->

   Load A with the contents of the address in HL.

3. N and NN denote single byte and double byte (word) size numbers.

4. d and dis is a signed single byte displacement number, 0 to 127 being positive or forward and 255 to 128 negative or backwards.

5. Prefixes CB(203), ED(237), DD(221), FD(253). Referring to the table in Appendix B of the User's Manual we have 3 columns of mnemonics.[^v09-1] The first column is used when none of the above prefixes is used. To get to the second column one must use the prefix CB followed by the instruction number. ED gets you to the 3rd column.

   There are two more prefixes not listed in the table. FD and DD. These prefixes change otherwise HL instructions to IY and IX respectively. For example, Instruction 35 normally is `INC HL`. With a FD(253) prefix it reads `INC IY`. With a DD(221) prefix it reads `INC IX`.

6. Conditional commands use the abbreviations C for carry, NC for no carry, Z for zero, NZ for non zero, M for minus, P for positive, PE for parity even and PO for parity odd.

## The Flag Register

The F register is the flag register and holds 6 flags. It could hold 8 but we only need 6. We can never directly change the value of the flag register by LOADing in a different value.[^v09-2] We can change some flags by doing certain operations.

CARRY (Bit 0)
:   All ADD, SUB, ADC, SBC, and CP instructions will change the carry flag if the results goes through zero (overflow or underflow) being set if reset and reset if set.[^v09-3] All AND, OR and XOR instructions will RESET the carry flag. Rotation instructions will rotate the end bits into and out of the carry flag resetting or setting it accordingly. CCF (Complement Carry Flag) will always change the carry flag to its opposite setting. SCF (Set Carry Flag) will always set the carry flag to 1. There is no reset carry flag but AND A does it nicely for us.

ZERO (Bit 6)
:   is set if the results of an operation like ADD, SUB, ADC, SBC, INC, DEC, CP, AND, OR and XOR is exactly zero when using the A register. SBC and ADC change the zero flag when using HL. INC and DEC of a double register will not set the zero flag when the value reaches zero. Rotation and Bit testing also affect the zero flag.[^v09-4] AND A will CLEAR the carry flag as mentioned above but also clears the zero flag.[^v09-5] XOR will clear A and thus SET the zero flag. No load instructions affect the zero flag except LD A, I and LD A, R.

<!-- p. 101 (pdf 111) -->

SIGN (Bit 7)
:   shows if a result is negative or positive with respect to 2's complement arithmetic. In other words, a copy of Bit 7 of a single register or Bit 15 of a double register. Thus all ADD, INC, SUB, DEC, SBC, CP, AND, OR, and XOR with single register and ADC and SBC with double registers change the sign flag. Rotation will also affect the sign flag.[^v09-6] Only LD A, R and LD A, I change the sign flag. Block searching instruction use the sign flag. There is no way to deliberately set or reset the sign flag except using the scheme above--setting or resetting Bit 7 of a register.[^v09-7]

OVERFLOW/PARITY (Bit 2)
:   is a dual purpose flag. The overflow part tests whether the result of an operation in 2's complemented arithmetic is correct or not--not as in carry above where insufficient space or in sign above where it would indicate a negative number (bit 7 being on).

    Consider adding 20 to 113, the results, 133 would be correct using unsigned numbers but incorrect using 2's complemented signed numbers as it would indicate a negative number with bit 7 being on, -123.[^c06-1]

    Parity counts the number of 1 bits and SETS the Parity flag if the number is even. All AND, OR and XOR are tested for Parity.

    All ADD, ADC, SUB, SBC, and CP are tested for OVERFLOW.[^v09-8]

    Block instruction use the parity/overflow flag. There are no instructions for explicitly handling the overflow/parity flag.

HALF CARRY (Bit 4) and NEGATIVE (Bit 1)
:   cannot be tested for and are only used by the DAA operation internally.

Bits 3 and 5 are not used.

## The Z80 Assembly Instruction Set

## Load Instructions

Some texts on assembly go through the full set of different ways to load a register like immediate, direct, indirect, implied and extended. The reason for this is that mnemonics of the 6500 and 8080 CPU's were of the nature: LD A, Immediate. What the writer is trying to do is show the relationship between that mnemonic and the Z80 equivalent, `LD A, n`.

The Z80 mnemonics are much more direct. We don't have to know what type of load we are using to use it, we just do it. This is <!-- p. 102 (pdf 112) --> why I consider the mnemonics for the 6500 and 8080 CPU's as written in computerese instead of English. They are just gosh awful as you are required to know all this extraneous junk. The future bodes ill also as the 68000 processor use the same obtuse set of mnemonics. Originally they wanted no mnemonic longer than 3 letters but with all the extra commands needed for a 16 bit processor what was already a strained restriction really gets bent so that "any resemblance to what the mnemonic says and what really happens is purely accidental."

The Load commands can be used to transfer one register value to another as in: `LD A, C` (Load A with C) or its reverse: `LD C, A`. What should be remembered is that after A is loaded with the value in C, both A and C contain the same number. The number is not erased from a register until it is overwritten with another number. Once in a while one encounters nonsense instructions like `LD A, A` which really does nothing except waste time.

One can also load a register directly with a number. `LD A, n` means load A with the number n. In the code, this number n must immediately follow the instruction number. `LD A, 6` codes to 62,6.

Loading to and from memory is achieved with: `LD (nn), A` and `LD A, (nn)` respectively. These two instruction are equivalent to `POKE nn, A` and `LET A = PEEK nn`. In both these cases, nn again must follow the code number in LSB/MSB format.

We can also load the contents of A to and from memory by using a register pair as a pointer. `LD (HL), A` and `LD A, (HL)` load A to and from the address held in HL. Similar instructions exist for the BC and DE pairs using A. All registers can be loaded to or from memory using HL as a pointer, but only A with BC or DE.

IX and IY can also be used to load A to and from memory but require an offset. These mnemonics are written `LD (IY+d), A` and `LD A, (IY+d)` for load to and read from memory position IY+d respectively. The 2068 sets IY to the value 23610, an address in the middle of the Systems Variables. Then, with the offset, d, set at 10, the value of address 23620 will be read or rewritten. With a negative number like 245, the address 23600 will be of concern.[^c06-2] One can move 127 spaces either side of the address in IX or IY.[^v09-9] BUT, a word of caution: IY must be reset to the value of 23610 before coming back to Basic. Further care must be taken when using IY and then calling ROM routines as these routines and the subroutines they may call may need IY set back to 23610 to check a system variable. IX, on the other hand, is used by the Bank Switching, Function dispatcher and the floating point calculator routines.[^v09-10] It, however, is usually reset before use.

In the code, remember that all IY and IX instructions must be preceded by the Prefix FD or DD. This is followed by the instruction number which is ALWAYS followed by the displacement (if dealing with memory locations) in the 3rd position and any <!-- p. 103 (pdf 113) --> other codes following that. Also note that you can use double prefixes like FD,CB and FD,ED.[^v09-11]

We can also load a double register with a number as in `LD BC, nn`. In the code, NN must follow the instruction number in LSB/MSB format. Do not confuse the above instruction with `LD BC, (nn)` as this instruction loads C with the contents of address nn and loads B with the contents of address nn+1. `LD (nn), BC` puts C in address nn and B in address nn+1.

If you look at the double register instructions allowed, you will note that there is no `LD BC, HL` or any other load one double register with another. You have to do it one at a time.

### Code for Load of a Single Register

```text
                                                (IY*)
  with   A   B   C   D   E   H   L (HL)  N   (IX*) nn   (BC) (DE)
LD  A  127 120 121 122 123 124 125 126 62n  126d 58nn  10   26
    B   71  64  65  66  67  68  69  70  6n   70d
    C   79  72  73  74  75  76  77  78 14n   78d
    D   87  80  81  82  83  84  85  86 22n   86d
    E   95  88  89  90  91  92  93  94 30n   94d
    H  103  96  97  98  99 100 101 102 38n  102d
    L  111 104 105 106 107 108 109 110 46n  110d
  (HL) 119 112 113 114 115 116 117 --- 54n
(IX*)/ 119d112d113d114d115d116d117d    54dn
  (IY*)
   nn  50nn   *prefix all IX with 221    n and nn = reminder
  (BC)  2             all IY with 253      next byte(s) must be
  (DE) 18     d = displacement is 3rd byte      number(s).
```

[^c06-3]

### Code for Load of Double Registers

```text
  with         nn      (nn)       BC          DE     HL,IX*,IY*      SP
LD (nn)        --          -- 237,67,nn 237,83,nn 34,nn or   237,115,nn
                                                  237,99,nn
LD  BC        1nn  237,75,nn   --          --        --
    DE       17nn  237,91,nn   --          --        --
IY*,HL,IX*   33nn   42nn or    --          --        --
                   237,107,nn
    SP       49nn  237,123,nn  --          --        249
```

[^c06-4] [^v09-12]

### Special Load Instructions

```text
LD A, I  237,87      LD I, A  237,71
LD A, R  237,95      LD R, A  237,79
```

Kindly note above that some double register instructions can be coded two different ways--with or without using a prefix. The STACK POINTER is considered a double register. The novice assembly code writer will not use the special load instructions as they deal with changing the interrupt and refresh registers...a topic much too complicated to be discussed here. We only list these here for completeness. `LD A, I` and `LD A, R` are also the only two LD instructions that change any flags.[^v09-13]

<!-- p. 104 (pdf 114) -->

## Block Move Instructions

```text
LDI  237,160    LDD  237,168    LDIR 237,176    LDDR 237,184
```

These four instructions move one or more consecutive bytes from one memory location sequence to another. We could write the following program to transfer a string of consecutive bytes from one spot to another.

```z80
      LD DE, destination address
      LD HL, source address
      LD BC, number of bytes to transfer
again LD A, (HL)
      LD (DE), A
      INC DE
      INC HL
      DEC BC
      LD A, B
      OR C
      JRNZ, again
```

OR, we could use the instruction LDIR to take the place of the whole "again" loop. LDIR (LOAD, INCrement and REPEAT) has to be set up in the DE, HL and BC registers as noted above and does all the instructions in the "again" loop WITHOUT the use of the A register.

LDI is the same as LDIR but only moves one byte. It still decrements the BC counter, but does not repeat.[^c06-5] It has limited usefulness.

The above routine works with transfers of bytes that don't overlap addresses. When we just want to move things up a few spaces to make room, we have to start at the back of the string of bytes and move forward with a DEC of HL and DE so that we don't erase what we havn't yet moved. LDDR (LOAD, DECrement and REPEAT) is the same as LDIR in the setup of DE, HL and BC but uses DEC HL and DEC DE instead of the INCrements. Of course, LDD is the one shot equivalent of LDI.

## Jumps, Jump Relatives, Calls and Returns

JR (Jump Relative) and JP (Jump) are the assembly equivalents of the Basic GOTO statement. They can be absolute (without conditions) or conditional (based on the condition of a flag in the F register. Thus, conditional jumps are the equivalent of IF-THEN GOTO. We thus read, `JP Z, nn` as: If Zero (flag set) then Jump to address "nn". Again, JP instructions have to be followed by 2 address bytes in LSB/MSB format.

There are 3 absolute jumps that use an address contained in a register to jump to:

<!-- p. 105 (pdf 115) -->

```z80
JP (HL)     JP (IX)     JP (IY)
```

Don't be confused with these statements. The jump is to the address of HL, NOT the address contained by the memory address HL is pointing to.

JR's are limited to a jump that can be written in one byte, i.e., +/-128, and is relative to where we are now--an offset or displacement if you please.[^v09-14] It uses 2's complemented numbers, i.e., 128-255 are negative or backward jumps as used in loops or Next statements, 0-127 are forward jumps.

Students have a great deal of difficulty calculating these displacement values and even though we did it in the last chapter we are going to give you another example. A typical counting loop (sometimes used to do nothing else but waste time like waiting for that slow human to get the finger off the key) consists of:

```z80
1,y,x                LD BC, value ( x = high byte, y = low byte)
11         Again     DEC BC
120                  LD A, B
177                  OR C
32,____              JR NZ, Again.
(0),(1)
```

We have to fill in the missing value to get us back to "Again". As your CPU reads the full instruction `JR NZ, dis`, the Program Counter has advanced to the first address of the next instruction whatever that may be. Instead of the code of the instruction which would normally be written there, I have written a (0) to indicate where a displacement of "0" would get us. Similarily, the position of the next byte is written as a (1) to show where a 1 would get us.

Well, if those bytes are 0 and 1, then the displacement byte has the value of 255 which is -1. The "32" has the position of 254 (-2), the 177 the position of 253, etc. All we have to do is keep counting backwards until we get to that 11 at 251 and write that number in the blank. For forward, we have to remember the (0) position by starting to count with it rather than a "1". Or as they say "THROUGH ZERO".

DJNZ is a very special JR instruction which reads: DEC B and Jump Relative if NOT ZERO. It's always register B that gets DECremented and it's always IF NOT ZERO. It's never the double register BC.

Because it is easier to detect zero (the zero flag goes up) all loops in machine code COUNT DOWN rather than up.

CALL and RETurn are the assembly equivalents of GOSUB and RETURN respectively. All CALLs have to have an "nn" type address, there is no `CALL (HL)` or any other double register address. Like JP <!-- p. 106 (pdf 116) --> and JR, CALL and RET can be conditional which then makes them equivalent of IF-THEN GOSUB or IF-THEN RETURN. There are always two considerations to be made when using a CALL:

1. Do we have to save any values to continue the routine we are in when we get back from the subroutine? We have to save these values unless we know beyond any shadow of a doubt that the subroutine and the other subroutines it might call don't use the register that holds the value we must save.

2. Do we need any values we have already put on the stack in the subroutine?

The first consideration is quite obvious. However the ROM routines sometimes get so convoluted and involved that the beginning student may have some difficulty following them through to all their different ramifications.

The second is not quite so obvious. The reason for the second is that when we do a CALL the first thing the CPU does is PUSH the present address of the next statement onto the machine stack to use as a RETurn address, thus effectively burying any values you may need. This PUSHed value must be retained at all cost or when the computer reads that RETurn statement it's going to POP off the next values from the stack and go to that address--and get hopelessly lost.

This brings up another consideration. Before you tell the CPU to RETurn from a subroutine you had better have POPed off all values you PUSHed when doing the routine or the CPU also will use the numbers of the forgotten PUSH as an address with the same disastrous results. ALWAYS MAKE SURE THE PUSHES EQUAL THE POPS.

### Code for Jumps, Calls and Returns

```text
      ABS    Z      NZ     C      NC     M      P      PO     PE
JP    195nn  202nn  194nn  218nn  210nn  250nn  242nn  226nn  234nn
JR     24d    40d    32d    56d    48d
DJNZ   16d
CALL  205nn  204nn  196nn  220nn  212nn  252nn  244nn  228nn  236nn
RET   201    200    192    216    208    248    240    224    232
```

[^c06-6]

```text
JP(HL)  233     JP(IX) 221,233     JP(IY) 253,233
```

Note that you can't use the sign or parity flags for conditional jump relatives.[^c06-7]

## Converting Spectrum Programs to the 2068

Now that we know what the GOTO and GOSUB statements are, we can <!-- p. 107 (pdf 117) --> relocate a program to a different area. Or, if we have a "Spectrum ROM to 2068 ROM" conversion table we can convert Spectrum programs to the 2068. These tables have been published. They are also contained in expanded form in the "2068 ROM DISASSEMBLY MANUSCRIPT" already discussed.

You really have no need for a Spectrum emulator or Spectrum ROM anymore. Who, in their right mind, would want to convert from a computer that has sound, joysticks, bank switching and 4 screen mode capabilities to one without these? Just because the program you want isn't written for the 2068 but the Spectrum doesn't mean you convert your computer to a limited Spectrum. Instead you convert the Spectrum to the 2068. You already know enough code to do it.

In just a Spectrum to 2068 conversion, we don't have to worry about the Basic part of the program except for USR CALLs to the ROM. These and the machine code have to be changed. We can't read code so a disassembler like "HOT Z", which does assembly and disassembly, can help a lot. It's best to get a hard copy so you can really look at it rather than change it from the screen. What we are looking for are all calls to ROM (below 16384). The two bytes in back of these calls are the address in the Spectrum Rom and must be changed to the same spot in the 2068 ROM. Check the JP's as well to make sure they don't jump to ROM and then check for `JP (HL)`, `JP (IX)` and `JP (IY)` for the same type of jump to the ROM. Generally JP's are not to ROM. That's it.[^v09-15] Save your new code to a new tape or disk before running as you might just crash the first time through because you missed something or got it wrong. After it runs successfully where it is you may consider changing its location.

## Moving Code to a Different Location

FIRST we have to disassemble the machine code back to mnemonics. We can use the same copy we made above if we can still read it. Anyway we need a hard copy of the mnemonics. In cases like this a disassembler that does a printout saves a lot of time.

SECOND, decide where you want to move it to and calculate your offset, that is, how much your addresses are going to change. If you aren't cramped for space, it's easier if this number is divisible by 256 which means that you just have to change the high byte of an address by a certain amount.

THIRD, mark your printout of the disassembly for all `LD R, (address)`, and `LD (address), R` statements (R is a single or double register) that are pointing to addresses within the code program.[^v09-16] You will be happy to find out that the Spectrum and the 2068 use exactly the same addresses for the screen and the system variables except the 2068 has a longer table with extra values added to the end.

<!-- p. 108 (pdf 118) -->

FOURTH, check only the `JP`, `JP(HL)`, `JP(IX)` and `JP(IY)` and `CALL` statements for internal jumps and calls and change these with the offset calculated above. You can ignore calls to ROM if it already is a 2068 program. Otherwise, they must be changed as discussed above.

Changing `JP(HL)/(IY)/(IX)` is a bit of a problem as you have to go back up through the program and see how they calculate the value in those registers. Somewhere they do an offset add or offset load and the change is made there.

FIFTH, don't forget to change your RAND USR statement in Basic.

SIXTH, all POKEs to and PEEKs from the code areas must be changed in the Basic portion of the program to correspond to the new addresses.

SEVENTH, write yourself an LDIR program as given on page 104 to move your code to the new address. Make sure you place your move code in a spot where it won't get overwritten by your new code.

## Saving Registers--EX, EXX, PUSH and POP, DI and EI

Seven registers sometimes are not enough so we have to store a value somewhere while we are using a register for something else. This is especially true with the A register, but sometimes addresses held in register pairs must be saved as well. Where you save the values depends upon how soon you will need it back and how often the value will be needed.

First let's discuss A. Since this register is necessary for all math and logic one wants to get values in and out fast. The easiest is just LD the value to another unused register such as B, C, D, E, H, or L if one is available and not going to be used.

If all the registers are in use or will be used, we can do `EX AF, AF'` and save our value in A' (sorry but F is also saved in F' whether we like it or not). Doing another `EX AF, AF'` gets our value back to A and also saves in AF' another value of A.

The other 3 register pairs have to be saved as one and cannot be saved separately. EXX (217) exchanges HL with HL', DE with DE', and BC with BC'. That's H with H', L with L' etc. We can't exchange BC, DE or HL with their primes by itself.

Note Well: since HL is the only double register pair we can add to or sub- tract from, there is one more exchange, `EX HL, DE` which just swaps the present pairs of values--HL to DE, DE to HL.[^v09-17] There is no `EX BC, HL` or `EX BC, DE`.

Other EX mnemonics are `EX (SP), HL` and of course the extended IY <!-- p. 109 (pdf 119) --> and IX registers. The use of `EX (SP), HL` exchanges HL with the last two bytes pushed on the stack--a rapid way to change pointers or counters. `PUSH BC; EX (SP), HL; POP BC` is a fast way to exchange HL and BC without aid of a 5th register.

A word of caution about using prime registers. Don't have values stored there and then Call a floating point routine as they will be gone. I learned code on the Z81 (T/S1000) machine where the prime registers are used to refresh the screen so use of the primes generally created a crash. The 2068 is quite a bit more tolerant but don't say I didn't warn you.[^v09-18]

One way out of this dilemma is to prevent maskable interrupts by using DI (Disable interrupts) 243. The use of this instruction does two things while in effect. It prevents reading the keyboard and it doesn't allow for updating of the screen. You can change the whole Display File but it won't appear on the screen until you again Enable Interrupts with EI (251).[^v09-19] You never, never, never want to come out of machine code without being sure you have the interrupts enabled. The result is not a crash, but its equivalent--the keyboard is dead and so is the entry of any more commands--you might as well pull the plug.

Rather than go on at this point with listing more ways of storing values of registers let's stop for a minute and look at an interesting use of the EX AF, AF' instruction--a visual use.

This time around I'm going to give you the assembly mnemonics and let you code the program and enter it starting at 65000.[^v09-20]

```z80
        DI
        LD DE, 22528 (first attr)
        LD BC, 767   counter
        LD A, (DE)   read first attr
        EX AF, AF'   save attr
  Loop  INC DE       move to next position
        LD A, (DE)   read present attr
        EX AF, AF'   save present attr/get last attr
        LD (DE), A   put in file
        DEC BC       counter update
        LD A, B      test counter for zero
        OR C
        JR NZ, Loop
        EX AF, AF'   get last attr
        LD (attr 1), A  put in posn 1
        EI
        RET
```

The Basic that goes along with this program is:[^c06-8]

```basic
 5 BORDER 5: GOSUB 100: CLS
10 FOR X = 22528 to 23295
15 LET Y = (INT (RND*158)): REM Random INK, PAPER,
BRIGHT and a few flash--but not all.
```

<!-- p. 110 (pdf 120) -->

```basic
 20 POKE X, Y
 25 NEXT X
 30 PAUSE 0: REM Stop for a look at your random paper
 screen--notice that we have put attrbutes all the way
 down into the 2 bottom lines. Hit a key to continue.
 35 FOR X = 1 TO 768: REM can be what you want, but
 768 is once around.
 40 RANDOMize USR 65000
 45 PAUSE 30: REM a delay or it goes too fast
 50 NEXT X
 55 STOP
100 FOR X = 65000 TO 65023
105 READ Y
110 POKE X, Y
115 NEXT X
120 RETURN
125 DATA 243,17,0,88,1,255,2,26,8,19,26,8,18,11,120,
    177,32,247,8,50,0,88,251,201
```

Did you get 24 bytes of code and end at address 65023? Do your numbers agree with the numbers in the DATA line of the Basic program? Did you get your JR NZ displacement right? What number did you use for ATTR 1? If you got it all right, good for you. You know how to assemble code.

Did you run the program? A nice display and all done in attributes only. Did you notice that as soon as the program had to print the program complete message the bottom 2 lines reverted to border color.

Notes on the assembly program: The A register is very busy. Read all the notes written for the various lines of assembly. Note how the AF' register when loaded back contains the value we want to "print" for the next attribute.

The big question is why did we do the loop only 767 times instead of 768? The reason is that we don't handle the first attribute first but only get its value to put it into attribute 2. When the value of the last attribute becomes available we use that to finish the screen by putting it in the Attr 1 space.

What the program actually does is scrolls the attributes one position throughout the entire table. We use the RANDOMIZE USER 65000 inside a Basic loop together with a pause to slow things down. The loop as written will scroll one byte through all 768 positions and ends up with what we started with.

### Going Further

What we have now is the basic core of our program. We can now easily build other things into it. Let's start by adding PAUSE to the assembly code. PAUSE is equivalent to a wait loop as we have already discussed in Chapter 5 page 82. We make the com<!-- p. 111 (pdf 121) -->puter waste time by doing nothing but count down to zero. Typical is:

```z80
     LD BC, 20000
Wait DEC BC             6
     LD A, B            4
     OR C               4
     JR NZ, Wait       12
```

The higher the value in BC the longer the wait. Where do we put this loop? How about right after EI? Just before the return. Now we can take PAUSE out of our Basic program. Playing around with different values in BC will give you an indication of just how fast the 2068 can count.

How about also doing the FOR-NEXT loop that surrounds the RANDOMIZE USR statement? How do we do it? We need another counter. Let's use BC again. This presents a minor problem. We have to save the value of BC while we are using the other. Put the following 2 lines at the start of the program:

```z80
      LD BC, 768   loop counter
Times PUSH BC      Save counter
```

We insert the following just before the RETurn statement:

```z80
      POP BC       Get loop counter
      DEC BC       Update counter
      LD A, B      Test for zero
      OR C
      JR NZ, Times
```

Now we can also take the loop from around the RANDOMIZE USR line and just leave that. We leave it up to the student to code in these extra changes and add them to the correct positions in the DATA line. Make sure you extend the FOR-NEXT loop in the Loader routine to READ and POKE the extra bytes. Notice that we now have used BC as counters in 3 different situations.

Want to go further? Just to check that it's the attributes, put some printing on the screen and then call the scroll attributes routine. The letters stay in position although the use of flash for some of the attributes causes them to change colors. Delete all printing and run the program again. Now, try a screen copy to the printer. Surprised? Nothing to print.

Okay, I told you the program would be visual. Don't you think it rates at least a "jump off a high cliff with a beautiful soar and maybe a spiral or two down to the bottom"? If you don't know what I'm talking about, read page 1.

## Timing

We forgot to explain the numbers after our timing loop. They are <!-- p. 112 (pdf 122) --> the number of clock cycles, at 3,528,000/sec that it takes to execute the instruction. They are also called T states. Mostec has worked out exactly how long the computer takes to execute any instruction.[^v09-21] Because of the way the CPU works this is always a full number of cycles. To determine exactly how long a wait loop takes, we add up all the T states for each instruction. These are listed in Appendix A. Notice that the JR instruction has two times given. One is for when it has to make a jump (always the longer) and the other is when it ignores the instruction--it still takes time to read it, even if it doesn't act on it. For the wait loop above this comes to a total of 26 T states each time through the loop. For our loop, that's an elapsed time of 26/3,528,000 seconds. Or to put it a different way, it will loop through the loop 135,692.3 times a second. With a value of 20,000 in BC, this loop only waits for 0.147 seconds. Since PAUSE 1 is 0.0166 seconds, our loop is equivalent to PAUSE 8.8 (not counting setup time for the computer to look up and interpret PAUSE).

## More Ways to Save Registers

We got a bit ahead of our story in that last program but a very safe way to save a register pair is to PUSH it on to the machine stack. We can't push a single register, it always must be a pair. As mentioned earlier we have a problem of logistics to consider using this method. The first arises with multiple pushes to the stack. We bury our value as they are POPed off in reverse order --what was PUSHed last is POPed first. If we PUSH BC and then PUSH DE and now want to POP BC we must first POP DE. If we use POP BC without first using POP DE we get the value that was in DE into BC. The computer doesn't keep track of which pair was pushed or popped when--that is up to the programmer.

We discussed the machine stack back in Chapter 2 when we were talking about where things were stored. If you recall, the stack builds from the top down. Thus when a value is PUSHed to the stack, it's always 2 bytes long. The stack pointer which keeps track of where the end of the stack should be, is always automatically decremented twice. When something is POPed, the values aren't really erased but only the pointer is incremented twice. Therefore, doing 2 DEC SP is equivalent to a rePUSH of a value once on the stack back on the stack in the same position.[^v09-22] Similarly, doing a double INC SP POPs a value to nowhere.

The second problem is with CALLs. The CPU pushes the RETurn address onto the stack, then jumps to the routine. When it gets the RETurn instruction, it POPs the next values off the stack and returns to that address. You had better have POPed everything you PUSHed since you did the CALL. The return address also gets in the way of using other saved value from a previous routine as well.

Numbers used in numerous routines and that may get buried on the machine stack are best stored in a memory location--similar to <!-- p. 113 (pdf 123) --> what the computer does with its System Variables. Many programs start with a series of addresses used for this purposes. One of the problems of a disassembler is that it never knows when it is disassembling instructions and when it's disassembling data. The result is that sometimes you get some really weird code that doesn't make sense. Most disassemblers have a routine that let's you read data directly as ASCII symbols. That doesn't help much when it comes to a series of numbers. It is up to you to decide when code doesn't make sense if it's ASCII or numeric data. Numeric data can be 1 to 5 bytes long (floating point numbers are 5 byte). Programs that use this method of storing numeric data generally are full of `LD (address), register` and `LD register, (address)` mnemonics.

### Code for PUSH, POP, Exchange and DI/EI

```text
    PUSH POP   EX AF, AF'  8     EX (SP), IX 221,227  DI 243
 AF  245 241   EXX         217   EX (SP), IY 253,227  EI 251
 BC  197 193   EX DE, HL 235     EX DE, IX   221,235
 DE  213 209   EX (SP), HL 227   EX DE, IX   253,235
 HL  229 225
```

[^c06-9]

## Simple Arithmetic and Logic

### INC and DEC

Only these two instructions can be used on all single registers and register pairs. We have already met them--good old INC and DEC (Add 1 to a value or subtract one from a value). Double registers work by only INC and DEC the low byte using the high byte to store overflow or borrow from. Decrementing a single register that is at zero puts it at 255 without affecting the carry flag. Incrementing 255 puts it to zero with the zero flag set. All flags except carry are affected by INC and DEC,[^c06-10] however, DEC and INC of double registers DO NOT automatically set the zero flag or the carry flag. This is why we can do a JR immediately after a DEC of a single register but must test a double register for zero with `LD A, B` and `OR C`. If A is zero after these two operations, the zero flag is set. Of course similar instructions can be used to check zero of other register pairs. The Parity flag goes EVEN when a double register is at zero.[^v09-23] Unfortunately this flag can't be used in conditional Jump Relatives.

### ADD, ADC, SUB and SBC

All other math and logic operations can only be done with the A, HL, IX and IY registers. The double registers are limited. Your User's Manual uses two variations of mnemonics:

```z80
ADD A, C and SBC A, C represent the first kind.
SUB B and OR B represent the second kind.
```

<!-- p. 114 (pdf 124) -->

The first set we have no trouble with, ADD to A the value of C is quite explicit. We know what is happening and we know that the answer ends up in A. With SUB B we know we should be subtracting B, or is it subtract something from B? Well, it's always happening to register A. So it's `SUB A, B`., OR to A the value in B. The answer is always in A.

ADD means add directly and don't worry about the carry flag. ADC means add and if the carry flag is set add that too. Similarly, with SUB and SBC except that SBC subtracts the value of the carry flag. There is no SUB instruction with double registers, only SBC.

The reason for ADC and SBC is that zero is counted as a number as the register rolls over zero (like the mileage counter on your car rolling through 100,000). For example, 255 + 1000 should give us 1255. 1000 is 3 in the high byte and 232 in the low byte. Adding 255 and 232 gives us 231 with an overflow. The carry flag is on at this point. Now, if we add the high bytes using ADD we get 0 + 3 = 3 in the high byte which is wrong--it should be 4. But by doing an ADC instead we get 3 + 0 + carry for a 4. 1024 + 231 is 1255. We do have to take the precaution of setting carry to zero before using the ADC or SBC instructions or we will get a wrong answer...that means everytime we add or subtract double registers. How do we reset the carry flag? By doing AND A. CCF is complement, not clear, the carry flag.

The same thing applies to double registers with the answers always ending up in HL, IX or IY. We do not have SUB just SBC with double registers.

We will save all the instructions used for multiply and divide for the next section. A simple multiply by 2 can be achieved with `ADD A, A`. Doing it twice is equivalent to multiplying by 4. Three times is times 8, etc. Similarly `ADD HL, HL` can be used for the HL double register multiplications of powers of 2.

## Logic

`CP r` and `CP n`. CP (Compare), compares the contents of the register (r) or the number (n) to the contents of the A register by doing a MENTAL subtraction. Neither A nor the register change. The answer is stored nowhere. Only the flags are set or reset depending upon what the results would have been. Thus if A = R, the zero flag would be set. If A < R the carry flag would have been set and if A > R the carry flag would be reset. By testing the flags we can tell if A was greater than, equal to, or less than the r (or n). Here is where all the conditional jumps, jump relatives, calls and returns can really come into play. Doing a compare and then a conditional branch we have just executed the equivalent of a Basic IF-THEN statement.

```text
CPI  237,161    CPIR  237,177.  CPD  237,169    CPDR  237,185
```

[^c06-11]

<!-- p. 115 (pdf 125) -->

These look similar to LDI, LDIR, LDD and LDDR and they are. In reality it's `CP (HL)` followed by INC (if I) or `DEC HL` (if D), `DEC BC`, and Repeat (if R). However, 2 conditions STOP the repeat: when A = (HL) or when BC reaches 0. One can look through a string of data, or the variable table looking for a matching byte to A. Obviously A must be set up with the value we are looking for. HL must be set at the starting address (in the case of INC, at the start, in the case of DEC at the end), and BC must have the length of the list. If a match is found, HL will contain the address of the matching byte.[^v09-24] If no match is found, BC = 0.[^v09-25]

### AND, OR and XOR

The first two of these ARE NOT THE SAME AS their Basic equivalents.[^v09-26] These are the Boolean operations. They do a bit by bit comparison of the binary number in the A register with the binary number in a register or a number and leave the answer in A. It is best to write out the binary number in A with the other number (or the register number) below it when working these out.

AND. If the number has this bit set, don't change the bit in A, else reset it to zero. Or to put it another way, save only those bits of A whose bits I have "on" in the number--a MASK if you please. AND 255 thus would not change A. AND 0 sets A to zero as it saves nothing. AND A does nothing but turn on the zero flag.[^v09-27] A few examples:

```text
A = 159   10011111   A = 255   11111111   A = 231   11100111
AND 14    00001110   AND 24    00011000   AND 24    00011000
results   --------             --------             --------
          00001110             00011000             00000000
```

OR. Try to add the number bit to A but don't do a carry, else leave it alone. Thus if a bit in A is already on, it stays on and nothing happens. If the bit in A is off, it is turned on only if the number has it on. Thus OR 255 sets A to 255. OR 0 doesn't change A.

```text
A = 159   10011111   A = 1     00000001   A = 200   11001000
OR 13     00001101   OR 31     00011111   OR 244    11110100
results   --------             --------             --------
          10011111             00011111             11111100
```

XOR Exclusive OR). Flip those bits of A I tell you to, else leave them alone. `XOR A` makes A = 0 and sets the zero flag. `XOR 255` flips every bit in A and proves to be very useful for flipping all the bits in a pixel byte when doing inverse printing to the screen...every bit that was off is on and every bit that was on is off.

```text
A = 159   10011111   A = 0     00000000   A = 255   11111111
XOR 200   11001000   XOR 255   11111111   XOR 85    01010101
results   --------             --------             --------
          01010111             11111111             10101010
```

[^c06-12]

To repeat, ALL LOGIC AFFECT FLAGS if necessary. The answer is <!-- p. 116 (pdf 126) --> always in A.

## Other Simple Math Operations

The discussion of these had to be delayed until the logic operators were discussed.

CPL (Complement). First, don't confuse CPL (47) with `CP L` (compare L) (189). CPL is actually `XOR 255`, flipping all the bits in the A register. If it is followed by `INC A`, we have done what is called a 2's complement of a number, which in layman's language means change the sign of the number. For example, we know that -1 is 255. Thus by doing an `XOR 255` (or a CPL) we get 0. Then `INC A` gives us 1. We thus have converted -1 to +1. One can only complement to the A register.

NEG (negate). Means change the sign of a number, It is equivalent to `XOR 255` and `INC A` all wrapped up in one instruction.[^v09-28] It is also equivalent to a 2's complement. As in Algebra where minus a minus number is a positive number, so it is with the computer.

One last comment. A single byte number and its complement add up to 255. A single byte number and its 2's complement add up to 256. CPL only work on A, not HL. If you need to complement a double byte number you have to move it into A a byte at a time, do a CPL, and move it back. Then only INC the low byte.[^v09-29] Double byte numbers and their complements always add up to 65535. A double byte number and its 2's complement add up to 65536.

For the student. What is the 2's complement of zero? Well, XOR 255 makes it 255 and INC A brings it back to "0". Okay, what is the 2's complement of 128? XOR 255 changes it to 127 and INC brings it right back to 128. Since 128 has bit 7 set it should be a negative number. But since its 2's complement is also 128, we have to say that it is undefined.[^v09-30]

## Checking Bits. BIT, SET and RESET

(All these instructions require a 203 (CB) prefix.)

Since we are playing around with the bits inside a byte, let's discuss the BIT checking operations of the Z80. We can ask the computer to give us the status of any bit we want to, either in a register or in the memory address pointed to by the HL register pair as in `BIT n, (HL)`. n designates the Bit number 0 to 7. If the bit is 1 the zero flag is turned off, if "0" the zero flag is on. If we preface with the IX or IY preface we can also use the addresses in these registers with a displacement to ask about a memory bit pointed to by (IX+d) and (IY+d).

We can also change a BIT anywhere. `SET n, r` or `SET n, (HL)` will turn on that particular bit (n) wherever it is. RESET, working exactly the same way, of course, turns off that Bit.[^v09-31]

<!-- p. 117 (pdf 127) -->

### Codes for Math, Logic and Bit Operations

```text
      A   B   C   D   E   H   L (HL)  n    (IX*)/(IY*)
ADD  135 128 129 130 131 132 133 134 198n    134d
ADC  143 136 137 138 139 140 141 142 206n    142d
SUB  151 144 145 146 147 148 149 150 214n    150d
SBC  159 152 153 154 155 156 157 158 222n    158d
AND  167 160 161 162 163 164 165 166 230n    166d
XOR  175 168 169 170 171 172 173 174 238n    174d
OR   183 176 177 178 179 180 181 182 246n    182d
CP   191 184 185 186 187 188 189 190 254n    190d
INC   60   4  12  20  28  36  44  52          52d
DEC   61   5  13  21  29  37  45  53          53d
CPL   47
NEG 237,68
```

```text
          BC      DE      HL      SP     IX*/IY*     CPD  237,169
ADD HL     9      25      41      57                 CPDR 237,185
ADC HL 237,74  237,90  237,106 237,122                CPI 237,161
SBC HL 237,66  237,82  237,98  237,114               CPIR 237,177
ADD IY*    9      25      --      57
ADD IX*    9      25      --      57
INC        3      19      35      51       35
DEC       11      27      43      59       43
```

*Notes on the listing above:* ADD IX/IY.[^v09-32]

PREFACE WITH 203 (CB)

```text
       A   B   C   D   E   H   L  (HL)  (IX+d)*/(IY+d)*
BIT 0  71  64  65  66  67  68  69  70        d70
    1  79  72  73  74  75  76  77  78        d78
    2  87  80  81  82  83  84  85  86        d86
    3  95  88  89  90  91  92  93  94        d94
    4 103  96  97  98  99 100 101 102        d102
    5 111 104 105 106 107 108 109 110        d110
    6 119 112 113 114 115 116 117 118        d118
    7 127 120 121 122 123 124 125 126        d126

       A   B   C   D   E   H   L  (HL)  (IX+d)*/(IY+d)*
RES 0 135 128 129 130 131 132 133 134        d134
    1 143 136 137 138 139 140 141 142        d142
    2 151 144 145 146 147 148 149 150        d150
    3 159 152 153 154 155 156 157 158        d158
    4 167 160 161 162 163 164 165 166        d166
    5 175 168 169 170 171 172 173 174        d174
    6 183 176 177 178 179 180 181 182        d182
    7 191 184 185 186 187 188 189 190        d190

       A   B   C   D   E   H   L  (HL)  (IX+d)*/(IY+d)*
SET 0 199 192 193 194 195 196 197 198        d198
    1 207 200 201 202 203 204 205 206        d206
    2 215 208 209 210 211 212 213 214        d214
    3 223 216 217 218 219 220 221 222        d222
    4 231 224 225 226 227 228 229 230        d230
    5 239 232 233 234 235 236 237 238        d238
    6 247 240 241 242 243 244 245 246        d246
    7 255 248 249 250 251 252 253 254        d254
```

[^c06-13]

<!-- p. 118 (pdf 128) -->

## Multiply and Divide--Rotate and Shift

Suppose we have the number 32 (only Bit 5 on) and want to multiply it by 2. The obvious answer 64 requires that Bit 6 be turned on and bit 5 turned off. Similarly, if we wanted to divide 32 by 2, the answer 16 requires that Bit 5 again be turned off and Bit 4 be turned on. In both cases, an operation that shifted or rotated everything one bit to the left or one bit to the right would be nice. That is exactly what the rotate and shift instructions do. However, we have one further consideration. What do we do with the bit that is pushed off the byte either right or left? This will depend upon what we want to do with that bit. Hence several different rotates and shifts.

The easiest way to describe what is happening is to draw you a picture of the various commands.

RLC (rotate left circular)
:   *[Diagram: register box with bits 7...0; bit 7 goes out to the carry box C and also loops around into bit 0.]*

RRC (rotate right circular)
:   *[Diagram: carry box C beside a register box marked 7 ... 0, with arrows showing the bit leaving the right-hand end going to C and wrapping round to the left-hand end.]*

RL (rotate left)
:   *[Diagram: C box and register 7...0 joined in a loop; bit 7 goes into C and the old C goes into bit 0.]*

RR (rotate right)
:   *[Diagram: C box and register 7...0 joined in a loop; bit 0 goes into C and the old C goes into bit 7.]*

SLA (shift left arithmetic)
:   *[Diagram: C <- [7 ... 0] <- 0; bit 7 goes into C and a 0 enters bit 0.]*

SRA (shift right arithmetic)
:   *[Diagram: [7 ... 0] -> C; bit 0 goes into C and bit 7 is fed back into itself (sign kept).]*

SRL (shift right logic)[^c06-14]
:   *[Diagram: 0 -> [7 ... 0] -> C; a 0 enters bit 7 and bit 0 goes into C.]*

RLD (rotate left digit) (by nybble)
:   *[Diagram: the A register and the byte at (HL), each drawn as two nybble boxes, with arrows showing nybbles rotating leftward between the right-hand nybble of A and the two nybbles of (HL).]*

RRD (rotate right digit) (by nybble)
:   *[Diagram: the A register and the byte at (HL), each drawn as two nybble boxes, with arrows showing nybbles rotating rightward between the right-hand nybble of A and the two nybbles of (HL).]*

DAA (decimal adjust accumulator) (shift out 10 if necessary)
:   *[Diagram: C box beside the A register drawn as two nybbles, with arrows from the low nybble to the high nybble and from the high nybble out to C.]*

The last 3 instructions are used for handling Binary Coded Decimal packed number. That is, each decimal number occupies a 4 bit nybble. The DAA instruction works something like this:

```text
         26       0010  0110
       + 35       0011  0101
                  ----  ----
Binary add        0101  1011  -- This nybble is 11
    DAA shift 10  ____10____
corrected answer  0110  0001   Correct answer 61
```

### Multiplying

By a power of 2. For a single byte number is quite easy.

```z80
LD L, number
LD H, 0
```

<!-- p. 119 (pdf 129) -->

```z80
          AND A    clear carry
          RL L  X2
          RL H  overflow to H
          RL L  X4
          RL H  overflow to H + X2 of H
```

Notice how if the L register overflows the bit goes to the carry which then gets loaded into the H register on the RL H instruction. The next time around anything already in H automatically gets rotated Left effectively multiplying it by 2 as Bit 0 again gets any input from the carry flag. In these instances, the carry flag is acting as the 9th bit of a register.

Division by powers of 2 of course would start with the number in H and use alternating RR H and RR L's. Any number in L is of course a fraction.

Multiplying and dividing double byte numbers of 2 can be handled in the same manner as long as we don't get any overflow of the registers either way, or, in the case of division, we are not interested in the fraction. If overflow should occur we have to make sure the carry flag is reset before continuing. If we must save the overflow, we have to use a third register to handle it.

RR and RL ruin the number in the register. If we use a counter and do things exactly 8 times, as will become necessary when we do not necessarily want to multiply by a power of 2, we can use RLC and RRC and rotate the number back into the register for use in the next operation. This would require our answer to be kept in other registers.

## Multiplication and Division by Any Number

To multiply or divide by any number we have to do things differently. For example 47 x 7 = 329. Our answer is going to require two registers. Let's use HL for that.

```text
          47 is 00101111 binary
           7 is 00000111 binary
```

B will be our counter, set to 8. DE will hold our 47. A is our multiplier of 7.

```z80
          LD B, 8   counter
          LD HL, 0  clear our answer
          LD DE, 47 load our multiplicand
Next dig. AND A     clear carry flag
          RRC A     next digit of multiplier to carry
          JR NC, update
          ADD HL, DE
update    AND A
          RL E
          RL D
          DJNZ, next digit (binary)
```

*Notes on the listing above:* the multiplier in A.[^v09-33]

<!-- p. 120 (pdf 130) -->

With our example, the first time we are going to add DE to HL so:

```text
              HL =   00101111
the 2nd time add     01011110
                     --------
so HL becomes        10001101
the 3rd time add     10111100
                   ----------
so HL becomes      1 01001001  this is 329.
```

The 4th, 5th, 6th, 7th and 8th times through[^v09-34] we are rotating zeros into the carry so nothing more is being added to HL.

## Division--Successive Subtractions Giving Integer Value Only

This method of division is not very efficient but is simple and easy to understand. It stops when it has computed the full number leaving HL with the remainder. It has to go through the loop as many times as the integer value of the answer:

```z80
         LD BC, 0 clear answer
         LD HL, dividend (number to be divided)
         LD DE, divisor
   Loop  AND A  clear carry flag
         SBC HL, DE  try to subtract
         JR C, rem
         INC BC
         JR loop
    rem  ADD HL, DE
         RET
```

A more complex but efficient division.

```z80
         LD HL, dividend (number to be divided)
         LD D, divisor
         LD E, 0
         LD IX, 0      clear answer
         LD A, L       shift dividend to A and L
         LD L, H
         LD H, 0       clear remainder register
         LD B, 16      set counter
   Loop  ADD HL, HL  shift L until you can subtract
         RL A
         JR NC, Shift
         INC L
  Shift  ADD IX, IX
         INC IX        assume can subtract
         OR A          clear carry
         SBC HL, DE  do subtract
         JR NC, Next Could subtract so loop
         ADD HL, DE  got negative # so add back and
         DEC IX        adjust answer down
   Next  DJNZ Loop   do 16 times
```

[^c07-1]

These are relatively short numbers. The routine is quite simple. But this last gives you some idea of what must be done with <!-- p. 121 (pdf 131) --> longer binary numbers. We leave it up to the student to devise more advanced routines.

## Floating Point

The above discussion was done using integer numbers, but the routines can be used for decimal numbers (to an extent). We have assumed that the decimal point was always at the end of a byte, but it doesn't have to be. We can put it anywhere in our binary number as long as we keep track of where it is. This is really the function of the exponent byte of a Floating point number.

Suppose that we put our answer in memory and now are back in Basic. Reading out our 2 byte answer would be done with:

```basic
     PRINT PEEK X +256*PEEK (X+1)
```

If we had deliberately shifted our binary decimal point one place left, i.e., between Bit 0 and Bit 1 of our low byte, our readback statement would change to:

```basic
     PRINT (PEEK X)/2 +128*PEEK (X+1)
```

Everything gets divided by 2. For every position left we move our decimal point it's another power of 2 to divide by. Thus 4 binary positions left is:

```basic
     PRINT (PEEK X)/16 +(256/16)*PEEK (X+1)
```

A whole byte of binary decimal left is:

```basic
     PRINT (PEEK X)/256 + PEEK (X+1)
```

This is a simple way to get a fraction in our divide routines above.

Well, how about shifts right? Multiply instead of divide. For 1 place right it is:

```basic
     PRINT 2*PEEK X +512*PEEK (X+1)
```

Please note that in all of this we are talking about the placement of the decimal point, the marker between the integer and the fraction, in a binary string of numbers. Review binary numbers as we discussed them in Chapter 1 if you are not entirely clear on this point. Since our computer is going to take these fractions and print them in decimal, one should take with a grain of salt the accuracy of all those decimal positions.

Another word of caution: Don't divide by zero. A routine to trap out a zero divisor must be included in the above routines if you don't know what your divisor is going to be.

<!-- p. 122 (pdf 132) -->

### Codes for Shift, Rotate and BCD Arithmetic

All have 203 (CB) prefixes except where noted

```text
     A  B  C  D  E  H  L  (HL)  (IY*)/(IX*)   Alternate method
RLC  7  0  1  2  3  4  5   6        6d        without prefix
RRC 15  8  9 10 11 12 13  14       14d
RL  23 16 17 18 19 20 21  22       22d        RLC A  7
RR  31 24 25 26 27 28 29  30       30d        RRC A 15
SLA 39 32 33 34 35 36 37  38       38d        RL A  23
SRA 47 40 41 42 43 44 45  46       46d        RR A  31
SRL 63 56 57 58 59 60 61  62       62d

RLD 237,111
RRD 237,103
DAA 39 (no prefix)
```

[^c07-2] [^v09-35]

## IN/OUT

As we pointed out earlier, every peripheral on the computer including anything we add must be addressed through ports. This includes the keyboard, sound chip, joysticks, 2040 printer, dot matrix printer, modem, disk drives, cassette recorder, screen or monitor, extra memory, cartridge programs, microdrives and whatever else you may wish to add.[^v09-36]

The 2068 can use as many as 256 (0 to 255) different ports. Every time we use an IN or an OUT we must specify the port. Only IN A, (n) and OUT (n), A need the port number immediately after the instruction number (direct addressing). All the rest of the IN/OUT's require that the port be held in register C.

The port number is put on the 8 low address lines, should there be a value in B, this is put on the eight top address lines. Thus the 2068 can really address 65536 different ports. Almost always B is "0" as 256 ports are more than adequate to handle everything we may ever need.[^v09-37]

Obviously one has to know what is attached to what port before writing any code for it. In the first part of this book we gave you all the necessary port assignments for the normal equipment you may attach. Attaching 3rd party equipment requires the firmware program written to interface that piece of equipment to the 2068. Disassembling programs of this nature is going to reveal a lot of confusing instructions which seem to have no purpose (to the novice). They do serve a purpose however in that sending things out and getting things in have to be timed and what you are really looking at are pseudo timing loops.

```text
INI   237,162   IND   237,170   INIR 237,178   INDR 237,186
OUTI  237,163   OUTD  237,171.  OTIR 237,179   OTDR 237,187
```

<!-- p. 123 (pdf 133) -->

Again we have a set of series transfer of bytes out the same port or in the same port. These are really IN (HL),(C) and OUT (C), (HL) instructions. The setup is as:

```z80
          LD HL, address to be loaded in or out of.
          LD C,  port
          LD B,  count
```

Because of 1 register count, one INIR will only work for 256 bytes before it has to be repeated.

### Codes for IN/OUT Commands

Preface with 237 (ED)

```text
             A    B   C   D   E   H   L  (HL)
IN r, (C)   120  64  72  80  88  96 104 112
OUT (C), r  121  65  73  81  89  97 105 113

IN A, (n)    219,n   (no preface)
OUT (n), A   211,n   (no preface)
```

There is an error in your User's Manual:

```text
     Change  237,112 to IN (HL), (C)
     Change  237,113 to OUT (HL), (C)
```

*Notes on the listing above:* 237,112 and 237,113.[^v09-38]

## Restarts (RST)

We have 8 of them which are really CALLs to the addresses 0, 8, 16, 24, 32, 40, 48, and 56. For the 2068, these are special routines which can be very useful.

RST 0 (PLUGIN). This is the first instruction that your computer uses. Hence it is equivalent to restarting the whole computer setup without turning the computer off and then back on. It is equivalent to RANDOMIZE USER 0 which we have already talked about.

RST 8 (Error). Your computer uses this restart to print errors at the bottom of the screen. Using RST 8 (207) must be followed by a DATA byte indicating the desired error. This number is always one less than the error number. Thus 255 will give Error 0 which is OK. A "0" will give error 1, NEXT without FOR, etc. Error A is 10, B is 11, G is 16, H is 17 etc.[^v09-39]

RST 16 (Print A Character). Prints the ASCII symbol for the code carried in register A to the present screen position.[^v09-40] Be sure to initialize the screen after doing a CLS with a "PRINT ," before going into code and calling your routine.[^v09-41] It can be used to give print commands such as AT (22)[^v09-42] followed by line and column numbers, TAB (23) followed by a column number, INK (16) and <!-- p. 124 (pdf 134) --> PAPER (17), need a color number while FLASH (18), BRIGHT (19), INVERSE (20), and OVER (21) need the usual 1 for on and 0 for off. PRINT comma (6) works like TAB 16 or TAB 0 while ENTER (13) is the equivalent to NEWLINE, the print apostrophe.[^v09-43] Don't use the cursor controls as they only operate in LIST mode which is hardly where one would be while running code.[^v09-44]

RST 16 can be used in a loop as follows: We use a number like 24 which isn't used for anything, to end the loop so we don't even have to use a counter.

```z80
         LD DE, Data base
    Loop LD A, (DE)
         CP 24
         RET Z
         RST 16
         INC DE
         JR Loop
```

Data base of course is the address of where you have put what you want to print. This routine will work with all graphics and TOKEN prints as well.[^v09-45]

RST 24 (Get Character).\
RST 32 (Next Character). These two restarts are not too useful as they work on the line being edited or the line being executed and depend upon having the address in 23645 CHAR ADDR.

RST 40 (Do Floating Point Calculation). This is a topic we will cover in the next chapter. It needs a whole chapter to itself.

RST 48 (Make BC spaces). Is used to insert a new line into a program or insert a variable into the variable table. Both these require everything above them in memory to be moved up to make space. It is also used to insert a character into a line that you are editing (i.e., either inside the line or at the end as you are entering it--in these cases BC = 1.[^v09-46]

RST 56 (Maskable interrupt routine). In reality it is update screen and scan keyboard for a new input.[^v09-47] It can't be called with DI in effect and will do an EI before returning.[^v09-48] If you want to use this to read the keyboard, you will find your answer in LAST K. If you have not used DI, the maskable interrupt will automatically do it for you every 1/60th of a second anyway.

### Codes for Restarts

```text
RST 0    199  Plug in
RST 8    207  Error
RST 16   215  Print a Character
RST 24   223  Get a character
RST 32   231  Next character
RST 40   239  Do Floating Point calculation
```

<!-- p. 125 (pdf 135) -->

```text
RST 48   247  Make BC spaces
RST 56   255  Maskable interrupt. Update screen, Scan Keyboard.
```

## Miscellaneous Instructions

nop (0) no operation. A nice instruction in case you goof and have to change your program and all of a sudden have too many bytes--just fill in with zeros. Also can be used to pad timing loops to waste more time. Since CLEAR sets all memory locations to zero, memory is actually full of these instructions until something else is POKEd there.[^v09-49]

HALT (118) This stops the CPU until it receives an interrupt from a peripheral device. This is used to synchronize the CPU with the peripheral. Don't use it unless you understand interrupts or you have just stopped your computer with no way to start it again--unless you turn it off and back on.[^v09-50]

IM0/1/2 Interrupt modes 0, 1 and 2. IM0 is the default mode compatible with 8080 processors. The interrupting device must give the CPU an instruction code during the interrupt acknowledge time.

IM1 causes restart to address 56 (38h). Generally the 2068 is set to this mode.

IM2 causes restart to the address given by the interrupting device (low byte) with the I register giving the high byte.[^v09-51]

### Codes for Miscellaneous Instructions

```text
IM0  237,70     nop  0
IM1  237,86     halt 118
IM2  237,94
```

## Extra Instructions

WARNING: Although these codes exist, they are not checked out by the manufacturer and may cause your particular CPU to lock up and malfunction. They must be checked out before being used.[^v09-52]

### The Missing CB Instructions 48-55

These do the following operations SL and INC. The easiest abbreviation is SLL. It is the missing operation in the shift and rotate instructions.

```text
SLL A      203,55
SLL B      203,48
SLL C      203,49
SLL D      203,50
```

<!-- p. 126 (pdf 136) -->

```text
SLL E      203,51
SLL H      203,52
SLL L      203,53
SLL (HL)   203,54
```

The other extra instructions deal with the IY and IX registers needing DD(221) or FD(253) prefixes to convert to IX and IY respectively instructions normally dealing with H (which converts to the high register of IX of IY) and L (which converts to the low register of IX and IY).

### Codes for Extra IX and IY Instructions

Prefix 221(DD) for IX, 253(FD) for IY

```text
                                               (IY-IY)   (IY-IY)
      with      A   B   C   D   E     n     L(IX-IX)  H(IX-IX)
LD H(IX/IY)   103  96  97  98  99    38       101       ---
LD L(IX/IY)   111 104 105 106 107    46       ---       108

     H(IX/IY) L(IX/IY)  Additional NEG  Additional RET N
LD A    124      125       237,76          237,85
LD B     68       69       237,84          237,93
LD C     76       77       237,92          237,101
LD D     84       85       237,100         237,109
LD E     92       93       237,108         237,117
ADD     132      133       237,116         237,125
ADC     140      141       237,124
SUB     148      149
SBC     156      157       Unused ED instructions are nop.
CP      188      189
AND     164      165
OR      180      181
XOR     172      173
INC      36       44
DEC      37       45
```

[^v09-1]: (unverified) The TS2068 User's Manual is not part of the library, so the layout of its Appendix B cannot be checked here; docs/z80_combined_reference.md gives the full opcode tables, including the CB, ED, DD and FD pages.

[^v09-2]: Library note: no LD instruction loads F, but POP AF loads F straight from the stack, so any flag pattern can be set with, for example, PUSH BC / POP AF (F takes the value that was in C); see docs/z80_combined_reference.md (POP AF).

[^v09-3]: Library note: the carry flag is not toggled. ADD and ADC set C when the result carries out of bit 7 (bit 15 for 16-bit adds) and reset it otherwise; SUB, SBC and CP set C when a borrow occurs and reset it otherwise, whatever its previous state; see docs/z80_combined_reference.md (ADD, ADC, SUB, SBC, CP).

[^v09-4]: Library note: true of BIT and of the CB-prefixed rotates and shifts (RLC r, RL r, SLA r and so on), but the one-byte accumulator rotates RLCA, RRCA, RLA and RRA (7, 15, 23, 31) leave S, Z and P/V unchanged; see docs/z80_combined_reference.md (RLCA, RRCA, RLA, RRA).

[^v09-5]: Library note: AND A sets the zero flag from A: Z is set if A is 0 and reset otherwise, which is why AND A (or OR A) is the usual "is A zero?" test; it also clears carry, sets H and sets P/V to parity, leaving A unchanged; see docs/z80_combined_reference.md (AND r).

[^v09-6]: Library note: as with the zero flag, only the CB-prefixed rotates and shifts (and RLD/RRD) affect S; RLCA, RRCA, RLA and RRA do not; see docs/z80_combined_reference.md (RLCA, RRCA, RLA, RRA).

[^v09-7]: Library note: PUSH rr / POP AF sets the sign flag (and every other flag) to any chosen value, since POP AF loads F from the stack; see docs/z80_combined_reference.md (POP AF).

[^c06-1]: Corrected. The original printed "-125"; 133 - 256 = -123 in 2's complement.

[^v09-8]: Library note: true of the 8-bit forms and of 16-bit ADC HL and SBC HL; 16-bit ADD HL, ADD IX and ADD IY leave P/V (and S and Z) unchanged and affect only C, H and N; see docs/z80_combined_reference.md (ADD HL,rr).

[^c06-2]: Not corrected. With IY = 23610 a displacement byte of 245 (= -11) addresses 23599, not 23600; either the displacement should be 246 (mirroring the +10 example) or the address 23599, and the page does not show which the author meant.

[^v09-9]: Library note: the displacement is a signed byte, so the reach is 128 bytes below to 127 bytes above the address in IX or IY, as convention 4 above implies; see docs/z80_combined_reference.md (Addressing Mode Summary).

[^v09-10]: Library note: in the stock ROMs IX is used by the EXROM bank-switching code, the function dispatcher and the EXROM tape routines, and in the HOME ROM only by the BEEP timing loop (PARP); the HOME ROM floating-point calculator does not use IX, though it does use the alternate registers (EXX); see disassemblies/ts2068_home_rom_U16_stock.txt and ts2068_exrom_U20_stock.txt.

[^v09-11]: Library note: FD,CB (and DD,CB) is a real double prefix, followed by the displacement and then the opcode; there is no FD,ED or DD,ED form: the FD or DD is ignored and the ED instruction runs unchanged (FD ED 44h, 253,237,68, is simply NEG); see docs/z80_combined_reference.md (Opcode Prefix System).

[^c06-3]: Corrected. The original printed 94 for `LD H, C` and 55nn for `LD A, (nn)`; the Z80 codes are 97 (64 + 8×4 + 1; 94 is `LD E, (HL)`) and 58nn (3Ah; 55 is SCF).

[^c06-4]: Corrected. The original printed "237,106,nn" as the alternative code for `LD HL, (nn)`; it is ED 6Bh = 237,107, and 237,106 is `ADC HL, HL`, as the book's own table on page 117 shows.

[^v09-12]: Corrected against the Z80 opcode table. The listing as transcribed printed the LD (nn) row as "-- -- 237 67,nn 237,83,nn 34,nn or 237,115,nn" and the LD BC row as "1nn 237,75,nn -- -- 237,99,nn", which put 237,99,nn (the prefixed LD (nn), HL) on the LD BC row as if it were an LD BC, HL and made 237,115,nn (LD (nn), SP) read as the second code for LD (nn), HL; the cells are re-laid like the HL row below (LD (nn), BC = ED 43h = 237,67; LD (nn), HL = 34 or ED 63h = 237,99; LD (nn), SP = ED 73h = 237,115); see docs/z80_combined_reference.md.

[^v09-13]: Library note: true of the single LD instructions; the block moves LDI, LDD, LDIR and LDDR also change flags (H and N reset, P/V set while BC is not zero); see docs/z80_combined_reference.md (LDI, LDD, LDIR, LDDR).

[^c06-5]: Corrected. The original printed "Thus it can do without the BC counter."; LDI (and LDD) still decrement BC each time and set the parity/overflow flag while BC is not zero.

[^v09-14]: Library note: the range is -128 to +127, counted from the address of the instruction that follows the two-byte JR; see docs/z80_combined_reference.md (JR).

[^c06-6]: Corrected. The original printed 234nn for `CALL PE`; the code is ECh = 236, and 234 is `JP PE`, as shown on the line above.

[^c06-7]: Corrected. The original printed "for conditional jumps"; the table above shows JP, CALL and RET all take the M, P, PO and PE (sign and parity) conditions, and only JR (and DJNZ) are limited to Z, NZ, C and NC.

[^v09-15]: Library note: re-pointing ROM calls is necessary but not sufficient. RST calls need no change; the Spectrum tape routines (SA-BYTES $04C2, LD-BYTES $0556) have no HOME ROM equivalent on the 2068 and must be reached through the EXROM dispatcher (services $05 LOAD, $06 MERGE, $07 SAVE); ROM addresses held in LD rr,nn instructions, pushed return addresses and data tables need changing too; and code that assumes the Spectrum's RAM layout (channel area, PROG, machine stack, all relocated on the 2068) or its 50 Hz timing will misbehave; see docs/ts2068_vs_spectrum48_comparison.md (Compatibility Rules for Porting Spectrum Code to TS 2068) and docs/ts2068_dispatcher.md.

[^v09-16]: Library note: also mark every LD rr,nn (including LD IX,nn and LD IY,nn) whose nn points into the code, the conditional JP and CALL instructions, and any addresses held in data tables or pushed as return addresses; all of these must move with the code; see docs/z80_combined_reference.md (LD rr,nn).

[^v09-17]: Library note: the Zilog mnemonic is EX DE, HL (235, as in the table on page 113); and HL is not the only pair that can be added to, since ADD IX, rr and ADD IY, rr also exist (page 117); see docs/z80_combined_reference.md (EX DE,HL).

[^v09-18]: (unverified) ZX81 behaviour is outside the library. On the 2068 the 60 Hz interrupt routine at $0038 uses no alternate registers, but the HOME ROM floating-point calculator does (EXX), so the warning about calling it stands; see docs/ts2068_rom_entry_points.md (ROM $0038).

[^v09-19]: Library note: DI stops the 60 Hz interrupt, so the keyboard is not scanned and the FRAMES clock stops, but it does not hold back the screen: the display hardware reads the display file continuously and the interrupt routine contains no display code, so changes to the display file appear at once; see docs/ts2068_rom_entry_points.md (ROM $0038 MASK-INT).

[^v09-20]: Library note: at power-up the ROM sets UDG to 65368 and RAMTOP to 65367, so 65000 lies below RAMTOP and is not protected from BASIC (NEW clears it); CLEAR 64999 first keeps the code safe; see docs/ts2068_system_variables.md (RAMTOP; ROM $0D66).

[^c06-8]: Corrected. The original printed 23298; the attribute file is 768 bytes, 22528 to 23295 (22528 + 767, matching the 767 counter in the machine code), so 23298 POKEs three bytes past it.

[^v09-21]: Library note: the Z80 was designed by Zilog; Mostek (so spelled) was a second-source maker that published the same timings.

[^v09-22]: Library note: only while interrupts are disabled. Each 60 Hz interrupt pushes the return address, AF, HL, BC and DE below SP, overwriting the "popped" bytes, so DEC SP / DEC SP after an interrupt recovers garbage; see docs/ts2068_rom_entry_points.md (ROM $0038).

[^c06-9]: Not corrected. The fourth line repeats "EX DE, IX" with the 253 (IY) prefix, and neither `EX DE, IX` nor `EX DE, IY` is a real Z80 instruction (a DD or FD prefix has no effect on 235, which simply performs `EX DE, HL`), so there is no correct entry to restore.

[^c06-10]: Corrected. The original printed "All flags are affected by INC and DEC" and said that decrementing a register at zero gives 255 "with the carry flag set"; 8-bit INC and DEC affect every flag except carry, which they leave unchanged.

[^v09-23]: Library note: 16-bit INC and DEC affect no flags at all, P/V included. P/V reports BC only after the block instructions LDI, LDD, CPI and CPD, where it is reset (PO) when BC reaches zero and can be tested with JP PO; see docs/z80_combined_reference.md (Block instructions — P/V flag as loop indicator).

[^c06-11]: Corrected. The original printed 237,167 for CPI; the code is ED A1h = 237,161, as the table on page 117 gives it.

[^v09-24]: Library note: HL is stepped after every compare, including the matching one, so on a match HL points one byte past it after CPIR (one byte before it after CPDR); DEC HL (or INC HL) gives the address of the match; see docs/z80_combined_reference.md (CPI, CPD).

[^v09-25]: Library note: BC is also 0 when the match is the last byte searched; test the zero flag instead (Z set = match found, NZ = no match); see docs/z80_combined_reference.md (CPI).

[^v09-26]: (unverified) The library does not document BASIC's AND and OR; in Spectrum-family BASIC they are logical operators on whole numbers, not bit-by-bit ones, which is consistent with the warning.

[^v09-27]: Library note: AND A leaves A unchanged and sets the flags from it: Z is set only if A is 0, carry is cleared, H is set and P/V shows parity; see docs/z80_combined_reference.md (AND r).

[^c06-12]: Corrected. The original printed "XOR 84"; the binary operand 01010101 and the result 10101010 are both for 85 (84 is 01010100).

[^v09-28]: Library note: CPL and XOR 255, and NEG and CPL / INC A, give the same result in A but different flags: CPL sets only H and N, whereas XOR 255 sets S, Z and parity and clears carry; NEG sets carry when A was not zero and P/V when A was 128; see docs/z80_combined_reference.md (CPL, XOR, NEG).

[^v09-29]: Library note: incrementing only the low byte loses the carry into the high byte whenever the complemented low byte is 255 (original low byte 0): 256 (0100h) complements to FEFFh and INC L gives FE00h, but -256 is FF00h. Increment the whole pair (INC HL), or form the negative directly with LD HL, 0 / AND A / SBC HL, DE; see docs/z80_combined_reference.md (INC rr).

[^v09-30]: Library note: 128 is not undefined: as a signed byte it is -128, the one value whose negation (+128) cannot be held in a byte, so NEG leaves it at 128 and sets the overflow flag; see docs/z80_combined_reference.md (NEG).

[^v09-31]: Library note: the mnemonic is RES, as in the code table on page 117.

[^v09-32]: Library note: the ADD IY* and ADD IX* rows omit ADD IY, IY and ADD IX, IX (prefix, then 41), which exist; the -- under HL means only that there is no ADD IX, HL or ADD IY, HL; see docs/z80_combined_reference.md (ADD IX,IX DD 29).

[^c06-13]: Corrected. The original printed 70 for `BIT 0, A`; the code is CB 47h = 71, and 70 is `BIT 0, (HL)`, as shown under (HL) in the same row.

[^c06-14]: Corrected. The original printed "shift left logic"; SRL is shift right logical, as the diagram itself shows (a 0 enters bit 7 and bit 0 goes into C).

[^v09-33]: Library note: the listing assumes A already holds the multiplier: add `LD A, 7` before the loop. `RRC A` is the two-byte CB form; the one-byte RRCA (15) does the same job here. With A loaded, the routine gives the correct 16-bit product for every pair of 8-bit numbers.

[^v09-34]: Corrected against the listing. The original printed "The 4th, 5th, 6th and 7th times"; B is set to 8, so DJNZ runs the loop eight times, and passes 4 to 8 add nothing for the multiplier 7.

[^c07-1]: Corrected. The original printed `DJNZ, Loo`, `OR A, A`, a lower-case `next` target, and no `LD E, 0`; the label is `Loop` (truncated), `OR A` is the Z80 form, the target is the `Next` label, and the `LD E, 0` line is added here because `SBC HL, DE` compares the remainder in H against D and needs E = 0 (the routine then gives correct quotients for divisors up to 128).

[^c07-2]: Corrected. The original printed 63d for SRL (IX+d)/(IY+d); the indexed form ends with the same byte as the (HL) column, so SRL (IX+d) = DD CB d 3E, final byte 62.

[^v09-35]: Library note: the alternate codes are the one-byte RLCA, RRCA, RLA and RRA. They give the same result in A and are faster (4 T-states against 8), but they are not flag-equivalent: they leave S, Z and P/V unchanged, so a JR Z or JR NZ after RLCA tests an old zero flag; see docs/z80_combined_reference.md (RLCA, RRCA, RLA, RRA).

[^v09-36]: (unverified) Only the stock TS2068 ports are documented in the library (docs/ts2068_memory_map.md, which includes $FB for the ZX-protocol printer); the ports used by third-party printers, modems, disk drives and microdrive interfaces cannot be checked here.

[^v09-37]: Library note: on the 2068 the high byte often matters: the keyboard port 254 ($FE) uses it to select the half-row (the ROM scans with LD BC,$FEFE / IN A,(C) at $02B5 and tests BREAK with LD A,$7F / IN A,($FE) at $2009), and for INI, OUTI, INIR and OTIR B is the byte counter and so also appears on the top address lines; see docs/ts2068_memory_map.md (Keyboard Half-Row Addressing).

[^v09-38]: Library note: there are no IN (HL), (C) or OUT (C), (HL) instructions. 237,112 (ED 70h) is the undocumented IN (C), sometimes written IN F, (C): it reads port BC, sets the flags and discards the byte, storing nothing at (HL); 237,113 (ED 71h) is the undocumented OUT (C), 0, which sends 0 to port BC. To move a byte between (HL) and a port use INI or OUTI. What the User's Manual printed cannot be checked here; see docs/z80_combined_reference.md (IN (C) / OUT (C),0).

[^v09-39]: Library note: these are the report numbers; by the rule above the byte after RST 8 is one less, so report A (Invalid argument) needs 9, B 10, G (No room for line) 15 and H (STOP in INPUT) 16; see disassemblies/ts2068_home_rom_U16_stock.txt (ERRMSGS).

[^v09-40]: Library note: RST 16 jumps to $11ED, which sends A to the current channel: the upper screen only when stream 2 is selected, otherwise the lower screen or the printer; see docs/ts2068_rom_entry_points.md (ROM $0010).

[^v09-41]: (unverified) Whether a preceding PRINT leaves the upper-screen channel selected at USR time cannot be settled from the ROM listing; the reliable method is to select stream 2 in the code with LD A, 2 / CALL $1230 (or dispatcher service $29 SELECT); see docs/ts2068_rom_entry_points.md (ROM $1230).

[^v09-42]: Corrected against the ROM. The original printed "AT (27)"; AT is control code 22 ($16): the print routine treats only codes 6 to 23 as controls (ROM $0513: CP $06 / CP $18) and its CONTRO jump table sends $16 to the AT handler at $058C, while 27 simply prints a "?"; see disassemblies/ts2068_home_rom_U16_stock.txt (CONTRO).

[^v09-43]: Library note: TAB (23), like AT, takes two following bytes: the column and a second byte (send 0); with only one, the next character is swallowed as the second parameter (the CONTRO table sends both AT and TAB to $058C); see disassemblies/ts2068_home_rom_U16_stock.txt (CONTRO).

[^v09-44]: Library note: only codes 10 and 11 (cursor down and up) print a "?"; code 8 moves the print position back one place (P_LFT) and code 9 moves it right by printing a space with OVER 1 (P_RT); see disassemblies/ts2068_home_rom_U16_stock.txt (CONTRO).

[^v09-45]: Library note: RST 16 does print block graphics, UDGs and tokens, but 24 is still a legal parameter byte after AT, TAB, INK and the other controls (for example AT 5,24 or TAB 24), and the loop would stop there; choose a terminator that never occurs in the data, or use a counter.

[^v09-46]: Library note: RST 48 makes BC free bytes in one place only, at the top of the workspace just below the calculator stack ($0030 jumps to RESERVE at $132D); opening space inside the program, the variables or the edit line is done by the ROM's MAKE-ROOM (INSERT) routine at $12BB, with HL = position and BC = count ($12B8 enters it with BC = 1); see docs/ts2068_rom_entry_points.md ($0030 BC-SPACES, $12BB MAKE-ROOM).

[^v09-47]: Library note: the interrupt routine advances the FRAMES clock and scans the keyboard; it does no screen updating (the display hardware reads the display file directly), and the same applies to "Update screen" in the table below; see docs/ts2068_rom_entry_points.md ($0038 MASK-INT).

[^v09-48]: Library note: it can be called with interrupts disabled (nothing in it tests the interrupt state), but because it ends with EI / RET ($0051) interrupts are enabled again afterwards, so a routine that wanted DI must issue DI again; each call also adds 1 to FRAMES; see docs/ts2068_rom_entry_points.md ($0038 MASK-INT).

[^v09-49]: Library note: CLEAR does not zero memory; it clears the BASIC variables, screen and stacks (CLR_BC at ROM $1F39 has no fill loop). It is the power-on memory test (ROM $0D42) that leaves RAM set to 0, so unused memory is full of NOPs only until something else is written there; see disassemblies/ts2068_home_rom_U16_stock.txt (CLEAR, CLR_BC).

[^v09-50]: Library note: on the 2068 the 60 Hz frame interrupt arrives every 1/60 second, so with interrupts enabled HALT simply waits for the next frame (the ROM's PAUSE is built on it, $1FF2); it stops the machine for good only after DI; see disassemblies/ts2068_home_rom_U16_stock.txt (PAUSE).

[^v09-51]: Library note: IM 2 is indirect: I (high byte) and the byte on the data bus (low byte) form the address of a table entry, and the CPU calls the 16-bit address stored there. Nothing on the stock 2068 supplies that byte, so (unverified) the usual practice is a 257-byte table filled with one value; see docs/z80_combined_reference.md (IM 2).

[^v09-52]: Library note: these instructions are undocumented by Zilog but work on all real Z80 hardware, including the 2068's NMOS Z80A; lock-ups are not a known effect, though OUT (C), 0 sends $FF instead of 0 on CMOS Z80s; see docs/z80_combined_reference.md (Undocumented Instructions).
