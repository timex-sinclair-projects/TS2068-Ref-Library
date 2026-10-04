<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 127–146. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 8: The Floating Point Calculator.*
*[← previous](08-chapter-07-assembly-language.md) · [book README](README.md) · [next →](10-chapter-09-peripherals.md)*

---

<!-- p. 127 (unnumbered; pdf 137) -->

# Chapter 8: The Floating Point Calculator

A full explanation of what actually goes on in the floating point calculator is quite complex. A full description of all the possible modes and how they are implemented and the full workings of each instruction could be a book in itself.

The floating point calculator always uses the SLUG notation for numbers. We talked about slugs in Chapter 1 so a review at this time would be in order.

## A Note About Precision

The slug is always 5 bytes long. The first byte is always the EXPONENT followed by 4 bytes of the 32 most significant binary bits of the number (padded out with zeros if necessary).[^v10-1] The 4 byte binary numbers are called the mantissa, a word mathematics majors will remember from their study of logarithms. In logs, the mantissa was a decimal. The 2068 uses a binary mantissa of 4 bytes that is not a fraction. We can't mix the mantissa with the exponent as in logarithms.

Some books on floating point are going to call the use of a single binary byte numbers single precision, double byte operations double precision, three byte long numbers as triple precision and four byte numbers as quad precision. In this sense of the word "precision", our 2068 already uses quad precision. This type of notation has nothing to do with the number of decimal digits one can get from such numbers.

Decimal precision is the ability to give numbers in decimal notation to so many places accurately. The decimal 0.100000000 is accurate to the 9th decimal. If your computer represents that same decimal as 0.09999999957 it also is accurate to 9 places. IF we force rounding of the fraction beyond the 9th place, we get the same exact number. The 2068 rounds the fraction exceeding its precision to maintain the maximum amount it is capable of. This is the true definition of precision.

Some computers define single precision numbers as so many places. IBM calls its single precision as 6 numbers long, its double precision as 16 numbers long. The 2068 has no double standard as everything is 9 place precision. It takes a little over 3 bytes to signify each unit of 10 in binary. Visualize that 7 is 111 binary--3 bits, with 100 as 01100100--8 bits, and 1000 as 11 11101000--10 bits. 10 bits binary divided by 3 decimal bits = 3.33 bits binary per decimal place. 32 binary bits <!-- p. 128 (pdf 138) --> would then give us 32/3.33 which is 9 but not 10 bit decimal accuracy. The student will note that this is the area where the computer shifts over and starts printing numbers in scientific notation. With this information one can also calculate about how many binary bits are necessary for 16 place accuracy 16x3.33 = 53.28 bits. Rounding up to full bytes (56 bits) requires a 7 byte mantissa.

Many beginning students in assembly language realize this limitation of their computers and immediately want to jump into routines that can do calculations and manipulations on numbers with more accuracy. They think that the process is very simple or that maybe somebody has written a routine that can already do this for them. As far as I know, nobody has done this for either the ZX81/TS1000 or the 2068. The present floating point routines occupy from 12377 to 15496 in ROM as they are. Writing a double precision floating point calculator is really quite simple. All you have to do is add a few more bytes to the mantissa of the numbers and if you really want to handle big and tiny number use two bytes for the exponent. Then you have to understand all the various functions of the floating point calculator (not only add, subtract, multiply and divide but all trigonometric functions, draw, circle, log, exp, square root etc.) and write a new routine for those. Some of these use something called Chebyshev polynomials to generate the numbers--there are no trig tables or log tables in the ROM. And one more thing, translate your numbers from binary back to decimal when you are done and print them. You still may want to use scientific notation as well so it gets complex.

As I say, "Let's learn to walk before we fly" and just learn how to do some simple routines with the floating point calculator from machine code and save the rewriting for a later time.

## The Technique

The f.p. calculator has its own stack, similar to the machine stack we are already familiar with. Only this stack is 5 bytes wide so it can handle full numbers and it builds from the low addresses up. It does not hang like the machine stack. This stack is located at the very top of the Basic program with its bottom starting address held by the system variable STK BOT (23651-23652) and its top by STK END (23653-23654).[^v10-2] They are the same address when the stack is empty. There is no pointer to these positions like we had for the machine stack with the STACK POINTER. We have to provide our own and generally use HL.

In addition, the f.p. calculator has its own memory store where it can temporarily store up to 6 numbers. This storage is also in the system variables called MEMORY BOT (23698). Notice that it is 30 bytes long--just long enough to hold 6 five byte long numbers.

Operations of the f.p. calculator consists of loading the stack <!-- p. 129 (pdf 139) --> with the correct slugs in the right order and then using RST 40 to tell it what to do with the numbers. The f.p. calculator use a notation common to FORTH in that it operates on the top number or the top two numbers on the stack only and moves down as these numbers are replaced by the partial answers. Another name for this type of operation is called REVERSE POLISH--give the computer the two numbers, then tell it what to do with them. Hewlette-Packard had a few hand held calculators that used this type of notation.

Machine code numbers following a RST 40 instruction are NOT interpreted using the normal set of mnemonics but with the set given below. Note that this set is specific for the 2068 and cannot be translated directly back to the TS1000 which has a similar but slightly different list. The use of instruction 56 (38H) END F.P. tells the computer that the calculation is done and go back to regular mnemonics. At this point your answer is on the top of the f.p. calculator stack. The following is the list of f.p. calculator commands. The symbol # means number.

```text
DEC HEX OPERATION    DESCRIPTION

00  00  Jump-true    JR if preceding operation true. Dis = 0
                     byte
01  01  Exchange     Exchange the top two #'s on the stack.
02  02  Delete       Delete top # on stack.
03  03  Subtract     Subtract top # from 2nd. Leave answer in 2nd
                     #. Delete top #.
04  04  Multiply     Multiply 2nd # by top #. Leave answer in 2nd
                     #. Delete top #.
05  05  Divide       Divide top # into 2nd #. Leave answer in 2nd
                     #. Delete top #.
06  06  TO THE       Raise 2nd # to power of top #. Delete top #.
                     Leave answer in 2nd #. Corrupts B & M0-M3.
07  07  OR(x or y)   Leave x if y = 0, else leave a 1.
08  08  AND(x or y)  Leave x if y <> 0, else leave a 0.
09  09  X <= Y       Leave 1 if true, else 0 for false. B=code.
10  0A  X >= Y       Leave 1 if true, else 0 for false. B=code.
11  0B  X <> Y       Leave 1 if true, else 0 for false. B=code.
12  0C  X > Y        Leave 1 if true, else 0 for false. B=code.
13  0D  X < Y        Leave 1 if true, else 0 for false. B=code.
14  0E  X = Y        Leave 1 if true, else 0 for false. B=code.
15  0F  ADD          Add top # to 2nd #. Leave answer in  2nd  #.
                     Delete top #.
16  10  X$ AND Y     Gives X$ if Y <> 0 else gives "". B=code.
17  11  X$ <= Y      Leave 1 if true, else 0 for false. B=code.
18  12  X$ >= Y      Leave 1 if true, else 0 for false. B=code.
19  13  X$ <> Y      Leave 1 if true, else 0 for false. B=code.
20  14  X$ > Y       Leave 1 if true, else 0 for false. B=code.
21  15  X$ < Y       Leave 1 if true, else 0 for false. B=code.
22  16  X$ = Y$      Leave 1 if true, else 0 for false. B=code.
23  17  X$ + Y$      Concatenate string. Add Y$ to end of X$.
24  18  VAL$         Replace top of stack with VAL$. B=code
```

*Notes on the listing above:* AND (08)[^v10-3]; X$ AND Y (16).[^v10-4]

<!-- p. 130 (pdf 140) -->

```text
DEC HEX OPERATION    DESCRIPTION

25  19  USR$           Replace top of stack with USR of string
                       item.
26  1A  READ-IN        Read INKEY$ from channel specified.
27  1B  NEG            Negate top value of stack.
28  1C  CODE           Replace top of stack with CODE of string.
29  1D  VAL(b=code)    Replace top of stack with VAL of string.
30  1E  LEN            Replace top of stack with LEN of string.
31  1F  SIN            Replace top of stack with SINe. B,M0-M2
                       bad.
32  20  COS            Replace top of stack with COSin. B,M0-M2
                       bad
33  21  TAN            Replace top of stack with TANgent B,M0-M2
                       bd
34  22  ASN            Replace top of stack with ASN of value (in
                       radians). B,M0-M2 corrupted.
35  23  ACS            Replace top of stack with ACN of value (in
                       radians). B,M0-M2 corrupted.
36  24  ATN            Replace top of stack with ATN of value (in
                       radians). B,M0-M2 corrupted.
37  25  LN             Replace top of stack with LN. B, M0-M2 bad
38  26  EXP            Replace top of stack with EXP. B,M0-M3 bad
39  27  INT            Replace top of stack with INT. M0 corrupted
40  28  SQR            Replace top of stack with SQR. B,M0-m3 bad
41  29  SGN            Replace top of stack with Sign of value.
42  2A  ABS            Replace top of stack with ABS value.
43  2B  PEEK           Replace top of stack with PEEKed value.
44  2C  IN             Replace top of stack with IN (port) value.
45  2D  USR            Replace top of stack with USR value (INT).
46  2E  STR$           Replace top of stack with STR$. M0-M5 bad
47  2F  CHR$           Replace top of stack with CHR$ of value.
48  30  NOT            Leave 1 (true) if zero, else 0 for false.
49  31  Duplicate      Make duplicate of stack top on stack top.
50  32  X mod Y        Relace 2 top values with INT(X/Y) on top and
                       remainder below. Y is on top to start. M0
                       bad
51  33  Jump           Unconditional jump relative. Dis=byte 0.
52  34  STK DATA       Stack number which follows.
53  35  DJNZ           as in assembly (B register).
54  36  X < 0          Leave 1 if true, else 0 for false.
55  37  X > 0          Leave 1 if true, else 0 for false.
56  38  END f.p.       RETURN to normal machine code.
57  39  GET OPER       Convert a function operand to a value M0
                       bad
58  3A  TRUNCATE       Replace top of stack with truncation (to
                       0).
59  3B  SINGLE CAL.    Perform single calculation (code in B)
60  3C  E convert      Convert a number of #Em to top of stack
61  3D  Restack        Restack a number.
    86,88,8C series    Series generator for trig fct. etc. B,M0-M2
    A0-A4 Stk          A0 = STK 0, A1 = STK 1, A2 = STK 1/2, A3 =
                       STK PI/2, A4 = STK 10.
```

*Notes on the listing above:* GET OPER (57)[^v10-5]; the M0-M5 and B side-effects.[^v10-6]

<!-- p. 131 (pdf 141) -->

```text
    C0-C5 STK MEM      Stack from top of stack to memory 0 to 5 re-
                       spectively.
    E0-E5 GET MEM      Put on top of stack MEM 0 to 5.
```

Some of these routines need a bit more explanation.

Routine handling instructions. You will notice the inclusions that really don't do any calculations but merely aid the programmer in writing a routine. These are:

| Jump if true--true is 1 from stack not the zero flag.
|  (Jump & jump if T calculate dis from dis byte)
| Delete (top number only)
| STK to MEM (C0 series) does not clear number from stack.
| GET from MEM (E0 series) doesn't clear memory.
| Duplicate top number again
| DJNZ needs number in B register
| Exchange top number with 2nd number.
| END F.P.

Also notice the ability to stack often used constants, 0, 1, 1/2, PI/2 and 10 with the A0-A4 series.[^v10-7] If other constants are needed they can be added at the right time with STK DATA followed by your 5 byte number.[^v10-8]

The STK series (86,88,8C) is used by the floating point calculator to calculate LN, EXP and the trigonometric functions by use of the Chebyshev polynomials. For an explanation of their use see Logan, "The Complete Timex TS1000/Sinclair ZX81 ROM Disassembly" Appendix.

RESTACK # can only be used under the following conditions. HL must be pointing at the sign of the number which is held low/high in the next 2 bytes of memory.[^v10-9]

Logic functions. You will notice the inclusion of all the logical operations. Thus a 1 or a 0 are always left on the top of the stack to do with what you want.

The rest of the functions are the calculating kind and should be quite obvious as to what they are doing.

X mod Y is little understood but really means divide X by Y but stop at the integer value, don't go into decimals. Leave the remainder. Thus using it and not having a zero remainder immediately tells one X is not divisible by Y. The integer is on the top of the stack with the remainder beneath it.

A word of caution about using RST 40. It uses ALL, and I do mean all the registers including all the primes.[^v10-10] Anything that you have to save must be pushed before you do a RST 40 or it's lost.

## Loading and Unloading the Stack

<!-- p. 132 (pdf 142) -->

Getting numbers to and from the stack can best be done using the routines already available in the ROM. There are quite a few because of all the different ways of handling numbers.

### Integers

```text
INTEGERS:
     To Load:         12518 STACK A (single byte unsigned)
                      12521 STACK BC (double byte unsigned)

     To get back:     12640 F.P. to BC
                      12691 F.P. to A
```

Your integer number starts in A or BC and comes back in A or BC. If the number is too big you get an error message.[^v10-11]

## Already Slugged Numbers

```text
ALREADY SLUGGED NUMBERS:

     Always uses the format AEDCB
     To load:        11892  PUT AEDCB to stack
     To get back:    12207  Stack fetch to AEDCB
```

You of course have to put the number into AEDCB format and it's still in AEDCB when it comes back. To save it to memory or get it from memory write the following subroutines.

```z80
MEM to AEDCB: LD HL, last byte of # before calling.
              LD B, (HL)
              DEC HL
              LD C, (HL)
              DEC HL
              LD D, (HL)
              DEC HL
              LD E, (HL)
              DEC HL
              LD A, (HL)
              RET

AEDCB to MEM: LD HL, exponent byte address before calling.
              LD (HL), A
              INC HL
              LD (HL), E
              INC HL
              LD (HL), D
              INC HL
              LD (HL), C
              INC HL
              LD (HL), B
              RET
```

Note that they are written in opposite form, one forward, one reverse. Thus, should you get a number from memory and load it into the stack all you have to do is PUSH HL to save the address so you just POP HL and call the return back to memory, thus storing your answer where the number originally was.

<!-- p. 133 (pdf 143) -->

## Decimal Numbers

The problem with decimal numbers, numbers with decimal points in them, is that they have to be slugged first. You have two alternatives: either slug them yourself, or have the 2068 do that for you.

Having the 2068 do it for you requires the use of the routine at 12406 Decimal to F.P. Since this routine uses RST 24 and RST 32 we have to set CHAR ADDR (23645-23646) to the address of the first number of our number.[^v10-12] This number must be in ASCII code but may be in regular or scientific (E) format. Make sure the byte after the end of the number is a non-integer ASCII code like a space. Our number ends up right on the top of the stack.

Binary numbers from ASCII code can use the same routine with a call to 12377 after A is loaded with the token for BIN (196). This routine runs right into the decimal to floating point routine.

Getting slugs back into decimal is easy if you want them to the screen. It's not so easy if you just want to store them as the routine uses RST 16, PRINT A CHAR. It is called at 12705. Remember to do "PRINT ," before calling the routine.[^v10-13] This routine also uses MEM STK locations so any numbers you had stored in these locations are overwritten.

### Putting It All Together--A F.P. Example

Now that we understand something about the operation of the f.p. calculator, let's do an expression. How about:

```text
          X = (-B + (B^2 -4*A*C)^(1/2))/(2A)
```

If you remember your algebra, it's one of the solutions to a quadratic equation of the form:

```text
                A*X^2 + B*X + C = 0
```

Let's use:

```text
                2X^2 + 3X -65 = 0
```

Then, A = 2, B = 3 and C = -65

We have to calculate the expression B^2 - 4\*A\*C first so let's put B on the stack first, followed by C and then A on top.

```z80
          62,3           LD A, 3    B = 3
          205,230,48     CALL STACK A (12518)
          62,65          LD A, 65   C = 65
          205,230,48     CALL STACK A
          62,2           LD A, 2    A = 2
          205,230,48     CALL STACK A
          239            RST 40     Do f.p. calc.
```

<!-- p. 134 (pdf 144) -->

```z80
          49             Duplicate  A to top of stack
          15             Add        2A
          196            STK MEM 4  Save 2A
          49             Duplicate  2A to top of stack
          15             Add        4A
          1              Exchange   C to top
          27             Negate     C= - 65
          4              Multiply   4AC
          1              Exchange   B on top
          197            STK MEM 5  Save B
          49             Duplicate  B to top of stack
          4              Multiply   BxB
          1              Exchange   4AC on top
          3              SUB        BxB -4AC
          40             SQR *      (BxB -4AC)^(1/2)
          229            GET MEM 5  B on top
          27             NEG        -B
          15             ADD        -B +(BxB -4AC)^(1/2)
          228            GET MEM 4  2A on top
          5              Divide     (-B +(BxB -4AC)^(1/2))/(2A)
          56             END f.p. calc
          205,161,49     CALL Print f.p. (12705)
          201            RET
```

\* Will get invalid argument if you try to take the SQR of a negative number.

Notice how we generated a 2A by duplicate and add and, since we need it later we saved it to the stack. 4A was gotten by another duplicate and add. B squared was gotten by duplicate and multiply. Also notice how both the subtrahend (the number to be subtracted) and the divisor (the number that we are going to divide by) have to be on the top of the stack with the other number directly below it.

A few more precautions. Notice how STACK A only stacks an unsigned number. Doing LD A, 191 does not stack a -65. The same applies to STACK BC.

Also, saving numbers to STK MEM doesn't always guarantee that they will be there when you want them as something else you may be doing may require a STK MEM location. It is better to use them from the top down, i.e., high locations first.[^v10-14]

Troubleshooting floating point routines. It is best to go through your routine and check what is on the top of the stack, or if what is on the stack is correct. If you are using a DATA statement to enter your code, it is quite simple to add the 56 for END F.P. and follow that with 205,161,49,201 Print f.p. and RET and move it along as you check out the routine step by step. Especially check GET MEM to make sure it's still the same number you did with STK MEM.

We are still handicapped with not being able to enter fractional <!-- p. 135 (pdf 145) --> numbers directly as this point, but read on.

## Digging Deeper

A lot more is happening than really meets the eye when we use the floating point calculator. The routines are not the relatively simple ones for add, subtract multiply and divide of the preceding chapter. The complexity results because of the use of an exponent byte and the normalization of numbers.

## Normalizing Numbers

You ask what is normalization? It's another mathematical term meaning putting in a standardized form. Normalization is one of the things the 2068 does when it slugs a number. Since you may wish to use numbers in a form ready for the f.p. calculator let's look at the process.

The process consists of 3 parts:

1. Writing the binary form for a number using the 32 most significant bits. For conversion of fractions to binary see Chapter 1.

2. Shifting the decimal point of the binary number full left by adjusting the exponent.

3. Adjusting the first bit of the mantissa for the sign of the number.

For an example, lets use: 65535:

STEP 1. Binary notation.

```text
                1111 1111  1111 1111.  0000 0000  0000 0000
```

We could use:

```text
                0000 0000  0000 0000  1111 1111  1111 1111.
```

but the instructions say, "32 MOST significant bits" so the 2nd version is out.

STEP 2. Shift decimal.

Notice where the decimal point is. At this point our exponent is still 128. We have to move it 16 places left. That means add. 128 + 16 = 144. Our number now is:

```text
          144  .1111 1111  1111 1111  0000 0000  0000 0000
```

STEP 3. Put In Sign.

If our number were negative we would be done. It's posi<!-- p. 136 (pdf 146) -->tive. Zero the first byte of the mantissa. The final form is:

```text
          144  .0111 1111  1111 1111  0000 0000  0000 0000
```

Our 5 bytes become:

65535 = 144,127,255,0,0. Also note: - 65535 = 144,255,255,0,0.

Kindly note that the same 32 bits of numbers can represent a whole set of 256 different numbers depending upon what the exponent is. For our number some of these are:

```text
EXP NUMBER           EXP NUMBER               EXP NUMBER
144 65535.00000      138 1023.984375          145 131,070
143 32767.50000      137 511.9921875          146 262,140
142 16383.75000      136 255.99609375         147 524,280
141  8191.87500      135 127.998046875        148 1,048,560
140  4095.93750      134 63.9990234375        149 2,097,120
139  2047.96875      133 31.99951171875       150 4,194,240
```

[^c07-3]

Note that we have given the EXACT values of the numbers to as many decimal places as it took. As we point out in Chapter 1, the computer couldn't give you 31.99951171875 exactly.[^c07-4] It's accuracy goes awry about the 9th decimal number.

## Floating Point Additions of Exponentiated Numbers

Trying to follow through the ROM routines for just Add, Subtract, Multiply or Divide can be a bit harrowing since the routines take the slugged numbers and put them in registers. This makes their manipulation easier and faster but it also limits the length of the mantissa that can be handled. Imagine if you will, having to have to handle two numbers as in multiply or divide. That takes 10 registers! Once you remove the sign of the number, you need another byte to hold that so you really need 12 registers for the two numbers. Then, you can't just put one number into say BCDEHL and the other into B'C'D'E'H'L' as there would be no way to add L to L' or subtract L' from L. The numbers are split up as H'B'C'BC and L'D'E'DE. A routine to shift the first number left one bit then would read something like:

```z80
          RL C
          RL B
          EXX
          RL C
          RL B
          EXX
```

Just keeping track of which set of registers is in use and being worked on is an effort. This makes understanding what is going on difficult. What follows is a simplification of the process--just explaining the reasoning without getting into the actual <!-- p. 137 (pdf 147) --> HOW it's done.

Limited Precision. Because of the use of registers for manipulation of the numbers, a person desiring to write a higher precision routine literally must start over with a new way of doing things and use HL and DE to point at storage bytes. There are no more registers to handle any longer mantissas. By working "in place", a routine could be written for as long a mantissa as desired.

Let's see what really goes on when we try to add two numbers given in the SLUG form, i.e., with an exponent to keep track of the binary decimal point. Suppose we want to add:

```text
65,535.000000   144   0111 1111  1111 1111  0000 0000  0000 0000
 1,023.984375   138   0111 1111  1111 1111  0000 0000  0000 0000
```

Our slugs would look as given for both numbers.

The first thing we have to do is get the correct mantissas and store the signs in a register. Well, 2 registers, one for each number. So our slugs become:

```text
          144    1111 1111   1111 1111   0000 0000   0000 0000
          138    1111 1111   1111 1111   0000 0000   0000 0000
```

We can't add the mantissas yet as the exponents are different. We have to get the smaller (lower exponent number) to the same exponent by rotating right the mantissa the correct number of bits. In our case it's 6.

```text
          144      1111 1111  1111 1111  0000 0000  0000 0000
          144      0000 0011  1111 1111  1111 1100  0000 0000

Adding:   144 (1)  0000 0011  1111 1110  1111 1100  0000 0000
```

We got an overflow which means that that first (1) is really in the carry flag at this point. We have to shift our whole mantissa right one bit to accommodate it and at the same time up our exponent:

```text
          145  1000 0001  1111 1111  0111 1110  0000 0000
```

And finally put the sign back:

```text
          145  0000 0001  1111 1111  0111 1110  0000 0000
```

We leave it to the student to verify that this number is really 66558.984375.[^c07-5]

## Floating Point Subtraction of Exponented Numbers

Let's use the same two numbers. In algebra we learned that to <!-- p. 138 (pdf 148) --> subtract we change the sign and add the two numbers. In machine code that means we NEGate the number. Negate you will recall is CPL (complement) and INC. Let's start with the shifted number 1023.984375 already corrected.

```text
          144  0000 0011  1111 1111. 1111 1100  0000 0000
CPL            1111 1100  0000 0000. 0000 0011  1111 1111
INC            1111 1100  0000 0000. 0000 0100  0000 0000
```

Adding the two numbers:

```text
          144      1111 1111  1111 1111  0000 0000  0000 0000
          144      1111 1100  0000 0000  0000 0100  0000 0000
                ---------------------------------------------
          144 (1)  1111 1011  1111 1111  0000 0100  0000 0000
```

Notice how the INC of the number after the CPL was done at the end of the low bit. Now, let's look at our final number. Since we were adding a negative number we EXPECT an overflow so we don't adjust the final number but merely forget about the bit in the carry flag (See above for add). If we did not get a carry we would have to adjust everything LEFT a bit and adjust the exponent downward.

Let's see, the first two bytes are 65535-1024 = 64511. The 3rd byte adds 0.015625, the 4th nothing. 64511.015625 = 65535 - 1023.984375.[^c07-6]

## Multiplying Two Slugged Numbers

We again start by adjusting the sign bit of the mantissas for both numbers. Since we are only interested in the 32 most significant bits of the mantissa we don't care if we rotate the low part of our number off the low end but we do care if we lose bits off the high side. We will thus start by multiplying from left to right. One number called the multiplicand (MPC) will start out unchanged and will be added to the answer if the left most remaining digit of the multiplier (MX) is a 1. After that the MPC will be rotated right one bit for the next add. If no carry we will skip adding to the answer accumulator. We have to allow for an accumulator adjust routine just in case we overflow our answer mantissa on the high (left) side.

For our numbers let's choose:

```text
MX multiplier      1100 1100  1100 1100  0000 0000  0000 0000
MPX multiplicand   1111 1111  1111 1111  0000 0000  0000 0000
```

Instead of giving you the shifted left multiplier each time we will just indicate it by MX=1 or MX=0. Just count off the bits from the left as you go through the following routine.

```text
Starting answer    0000 0000  0000 0000  0000 0000  0000 0000
Starting MPC       1111 1111  1111 1111  0000 0000  0000 0000
                   ----------------------------------------------
```

<!-- p. 139 (pdf 149) -->

```text
1st MX=1  ANS =     1111 1111  1111 1111  0000 0000  0000 0000
Shift right MPC     0111 1111  1111 1111  1000 0000  0000 0000
                    ----------------------------------------------
2nd MX=1  ANS =   c 0111 1111  1111 1110  1000 0000  0000 0000
Adjust answer       1011 1111  1111 1111  0100 0000  0000 0000
```

The answer adjust is a SR and an INC in the 1 bit Also we have to INC the EXP. This requires a double shift right of the MPC, one for the shifted answer and a regular shift.

```text
Double SR MPC       0001 1111  1111 1111  1110 0000  0000 0000
3rd MX=0 SR MPC     0000 1111  1111 1111  1111 0000  0000 0000
4th MX=0 SR MPC     0000 0111  1111 1111  1111 1000  0000 0000
5th MX=1 OLD ANS    1011 1111  1111 1111  0100 0000  0000 0000
                    ----------------------------------------------
         NEW ANS    1100 0111  1111 1111  0011 1000  0000 0000
         SR MPC     0000 0011  1111 1111  1111 1100  0000 0000
6th MX=1 NEW ANS    1100 1011  1111 1111  0011 0100  0000 0000
                    ----------------------------------------------
         SR MPC     0000 0001  1111 1111  1111 1110  0000 0000
7th MX=0 SR MPC     0000 0000  1111 1111  1111 1111  0000 0000
8th MX=0 SR MPC     0000 0000  0111 1111  1111 1111  1000 0000
9th MX=1 OLD ANS    1100 1011  1111 1111  0011 0100  0000 0000
                    ----------------------------------------------
         NEW ANS    1100 1100  0111 1111  0011 0011  1000 0000
         SR MPC     0000 0000  0011 1111  1111 1111  1100 0000
                    ----------------------------------------------
10th MX=1 N. ANS    1100 1100  1011 1111  0011 0011  0100 0000
         SR MPC     0000 0000  0001 1111  1111 1111  1110 0000
11th MX=0 SR MPC    0000 0000  0000 1111  1111 1111  1111 0000
12th MX=0 SR MPC    0000 0000  0000 0111  1111 1111  1111 1000
13th MX=1 O. ANS    1100 1100  1011 1111  0011 0011  0100 0000
                    ----------------------------------------------
          N. ANS    1100 1100  1100 0111  0011 0011  0011 1000
          SR MPC    0000 0000  0000 0011  1111 1111  1111 1100
                    ----------------------------------------------
14th MX=1 N. ANS    1100 1100  1100 1011  0011 0011  0011 0100
```

[^c08-1]

The routine goes on with more SR MPC and in another 3, we start losing the least significant digits off the bottom end. However, if we examine our MX we have just passed the last 1 and so there will be no more additions to the answer. It is complete. All that remains is for us to calculate the exponent of the number.

You noticed that we didn't start by designating the exponent. In multiplication, it makes no difference what they are until we come to the answer adjustment routine. We start out the answer with the same EXP as the MPC. But how do we know where to INCrement the answer accumulator when we do an answer adjust? Well, if 1 has an EXP of 129 we just adjust the EXP - 128 place from the left in the mantissa. Okay, our multiplicand has to have the starting EXP of 128 + 16 = 144 as we incremented the 16th place. That's good old 65535 again. We also incremented this exponent, so at this point it's 145[^c08-2] to take care of the shift. The final exponent of the answer now has to be adjusted for the EXP of the Multiplier (MX). This adjustment is simply + (EXP MX - 129).

Of course we still have to adjust our number by adjusting the first bit of the mantissa for the sign of the number following the usual algebraic notations.

## Dividing Slugged Numbers

<!-- p. 140 (pdf 150) -->

The routine again starts by adjusting the first bit of the mantissa for the signs. It does not use negated numbers and adding to do subtractions. This time the number being divided will be rotated left while the divisor remains stationary and is subtracted from it. If subtraction results in an overflow, indicating a negative number, the divisor is added back. The answer is rotated left and incremented if subtraction was possible. No increment takes place if subtraction was not possible. Since rotation left of the remainder may result in an overflow, a test of the highest bit is first made to make sure it can be done.

For our example, let's do 65535/25 = 2621.4.

```text
65535 =   1111 1111  1111 1111  0000 0000  0000 0000
SUB 25    1100 1000  0000 0000  0000 0000  0000 0000
          ----------------------------------------------
REM       0011 0111  1111 1111  0000 0000  0000 0000
```

INC ANS and RL= 1(0). The (0) indicates the next place which may or may not be INCremented before the next rotation.

```text
RL REM    0110 1111  1111 1110  0000 0000  0000 0000
SUB       1100 1        not possible
ANS =     10(0)
RL REM    1101 1111  1111 1100  0000 0000  0000 0000
SUB       1100 1
REM       0001 0111  1111 1100  0000 0000  0000 0000
ANS       101(0)
          ----------------------------------------------
RL REM    0010 1111  1111 1000  0000 0000  0000 0000
SUB       1100 1        not possible
ANS       1010(0)
RL REM    0101 1111  1111 0000  0000 0000  0000 0000
SUB       1100 1        not possible
ANS       1010 0(0)
RL REM    1011 1111  1110 0000  0000 0000  0000 0000
SUB       1100 1        not possible
ANS       1010 00(0)
```

At this point the test of the high bit will indicate that RL REM is not possible. We must instead RR the Divisor. We also increment the EXP of the answer.

```text
   REM    1011 1111  1110 0000  0000 0000  0000 0000
RR & SUB  0110 01
          ----------------------------------------------
REM       0101 1011  1110 0000  0000 0000  0000 0000
ANS       1010 001(0)
RL REM    1011 0111  1100 0000  0000 0000  0000 0000
SUB       0110 01
          ----------------------------------------------
REM       0101 0011  1100 0000  0000 0000  0000 0000
ANS       1010 0011  (0)
RL REM    1010 0111  1000 0000  0000 0000  0000 0000
SUB       0110 01
          ----------------------------------------------
REM       0100 0011  1000 0000  0000 0000  0000 0000
ANS       1010 0011  1(0)
RL REM    1000 0111  0000 0000  0000 0000  0000 0000
SUB       0110 01
          ----------------------------------------------
REM       0010 0011  0000 0000  0000 0000  0000 0000
ANS       1010 0011  11(0)
RL REM    0100 0110  0000 0000. 0000 0000  0000 0000
```

<!-- p. 141 (pdf 151) -->

```text
SUB       0110 01      not possible
ANS       1010 0011  110(0)
RL REM    1000 1100  0000 0000
SUB       0110 01
          --------------------
REM       0010 1000  0000 0000   X
ANS       1010 0011  1101 (0)
RL REM    0101 0000  0000 0000
SUB       0110 01      not possible
ANS       1010 0011  1101 0(0)
RL REM    1010 0000  0000 0000
SUB       0110 01
          --------------------
REM       0011 1100  0000 0000   X
ANS       1010 0011  1101 01(0)
RL REM    0111 1000  0000 0000
SUB       0110 01
          --------------------
REM       0001 0100  0000 0000   X
ANS       1010 0011  1101 011(0)
RL REM    0010 1000  0000 0000
SUB       0110 01      not possible
ANS       1010 0011  1101 0110 (0)
RL REM    0101 0000  0000 0000
SUB       0110 01      not possible
ANS       1010 0011  1101 0110 0(0)
RL REm    1010 0000  0000 0000
SUB       0110 01
          --------------------
REM       0011 1100  0000 0000   X
```

*Notice that the remainders keep alternating between 101 and 1111 at the lines we have marked with an X. Our number will never come out even. We however can write the remaining digits of our answer as alter-sequences of 0110.*

```text
FINAL ANSWER  1010 0011  1101 0110  0110 0110  0110 0110
```

Calculating our answer exponent. We started with 144 for our number 65535 which we assign to the answer. In the course of the operations, it got incremented to 145. We now subtract off the EXP of the divisor and add the zero point. 25 would have an EXP of 133. Thus, 145 - 133 + 128 = 140 or 12 spaces right. Our number without exponent is:

```text
          1010 0011 1101. 0110 0110 0110 0110 0110
```

Consulting our table in Chapter 1 we get:

```text
           1   .25
           4   .125
           8   .015 625
          16   .007 812 5
          32   .000 976 562 5
         512   .000 488 281 25
        2048   .000 061 035 156 25
               .000 030 517 578 125
               .000 003 814 697 265 625
        ----   .000 001 907 348 632 812 5
               ---------------------------
        2621   .399 999 618 530 273 437 5

Rounding:      2621.400000
```

<!-- p. 142 (pdf 152) -->

You can see from this that our answer is accurate to 10 significant numbers as advertised.[^v10-15]

## Print a F.P. Number/Decimal to F.P.

We did the translation above by hand. How does the computer take a floating point binary number and convert it to decimal or take a decimal number and make it a floating point binary number?

The routine for decimal to floating point works something like:

> Stack a zero.\
> Check for Digit, if it is, stack it.\
> Exchange top two numbers.\
> Stack 10 and multiply--effectively multiplying everything previously on stack by 10.\
> Add the new number to the 10X previous number.\
> Loop back and get the next number.\
> If you get a non-decimal, check for "." and "E" else go to end routine.\
> If "." store the exponent and number at this point. Start a new number by stacking a 1--there may be several zeros following the decimal point and this will keep track of them. Get the next code and proceed as above.\
> If "E" start a 3rd number. The next symbol will be the sign so save that. Then proceed as above with digits. At end add to EXP of integer if sign was "+" or subtract if "-". Go to end routine.\
> END Routine. Adjust fractional number to EXP 129 and subtract the 1. Get the integer number and add the two with the exponents as calculated.[^v10-16]

The PRINT F.P. NUMBER routine located at 12705 is 425 bytes long[^v10-17] and is quite complex as it has to handle a lot of different numbers. It converts a floating point binary number to decimal and ends by printing it to the screen all in one. It works something like this (simplified).

> Check sign of number--jump to positive or negative routine.\
> Duplicate number.\
> Take integer and save it.\
> Subtract integer from fraction and save fraction.\
> Handle the integer as follows.
>
> > RL digits and move into A with `ADC A, A` effectively doubling the previous number already in A.\
> > Do a `DAA` if necessary and load A into (HL).
>
> The routine is as follows:
>
> > Shift all Binary digits left.

<!-- p. 143 (pdf 153) -->

```z80
Loop LD A, (HL)
     ADC A, A
     DAA
     LD (HL), A
     DEC HL
     DEC C
     JR NZ, Loop
```

Let's follow a typical number through this routine and see how the decimal numbers get generated. Why not pick good old 65535. It's 16 consecutive 1's if you remember. It will require 16 rotations of the number each one of which will cause a carry. We have already cleared MEM to hold our number and HL is pointing at what would normally be the exponent byte. Watch the numbers that appear in the memory locations. This is the one and only time the 2068 uses BCD notation. The DAA operation is omitted if it accomplishes no change.

```text
               MEM 1     #/#
 1st ADC   0000 0001   0/1
 2nd ADC   0000 0011   0/3
 3rd ADC   0000 0111   0/7
 4th ADC   0000 1111   0/15
     DAA   0001 0101   1/5
 5th ADC   0010 1011   2/11
     DAA   0011 0001   3/1
 6th ADC   0110 0011   6/3
 7th ADC   1100 0111  12/7          MEM 2     #/#
     DAA   0010 0111  c2/7  ADC   0000 0001   0/1
 8th ADC   0100 1111   4/15 ADC   0000 0010   0/2
     DAA   0101 0101   5/5
 9th ADC   1010 1011  10/11
     DAA   0001 0001  c1/1  ADC   0000 0101   0/5
10th ADC   0010 0011   2/3  ADC   0000 1010   0/10
                            DAA   0001 0000   1/0
11th ADC   0100 0111   4/7  ADC   0010 0000   2/0
12th ADC   1000 1111   8/15 ADC   0100 0000   4/0
     DAA   1001 0101   9/5
13th ADC  10010 1011  18/11
     DAA   1001 0001  c9/1  ADC   1000 0001   8/1
14th ADC  10010 0011  18/3
     DAA   1000 0011  c8/3  ADC  10000 0011  16/3         MEM 3
                            DAA   0110 0011  c6/3  ADC 0000 0001 0/1
15th ADC  10000 0111  16/7
     DAA   0110 0111  c6/7  ADC   1100 0111  12/7
                            DAA   0010 0111  c2/7  ADC 0000 0011 0/3
16th ADC   1100 1111  12/15
     DAA   0011 0101  c3/5  ADC   0100 1111   4/15
                            DAA   0101 0101   5/5  ADC 0000 0110 0/6
```

The final registers have the numbers, 3/5 5/5 0/6 in them reading nybblewise. If we rearrange the bytes reading right to left we get 065535.

<!-- p. 144 (pdf 154) -->

## Converting Binary Fractions To Decimal Fractions

We now can get back from STK MEM any fraction and work on that. The fractional conversion uses a different scheme of multiplying the fraction by 10. The integer part of the number then turns out to be the next digit of the fraction. The multiplying of the number of course starts with the least significant byte of the mantissa. Any overflow is carried over to the next byte and added after this byte is multiplied by 10 with any overflow again being carried over to the next most significant byte. The final carryover is the digit we wish to print. This is all done by an ingenious routine called CA = 10\*A + C.

An example is .1111 1111 0000 0000 0000 0000 0000 0000. From our table in Chapter 1, we know the answer should be .99609375. Starting with the least significant bytes we note that there will never be a carryover from lower bytes so that our process becomes simplified...all we have to do is multiply the number by 10 until we have zero remainder.

```text
Start          .1111 1111
x10    1001    .1111 0110   Integer 1001 = 9. Drop integer & repeat.
x10    1001    .1001 1100   Integer 1001 = 9.
x10    0110    .0001 1000   Integer 0110 = 6.
x10    0000    .1111 0000   Integer 0000 = 0.
x10    1001    .0110 0000   Integer 1001 = 9.
x10    0011    .1100 0000   Integer 0011 = 3.
x10    0111    .1000 0000   Integer 0111 = 7.
x10    0101    .0000 0000   Integer 0101 = 5.
```

[^c08-3]

Our number is complete.

## Rounding And Using Scientific Notation

The routine is far from done as it probably has decoded too many digits and so must proceed with rounding procedures. The use of scientific notation also still has to be decided upon. This means changing the position of the decimal point in the number to the 2nd printed figure. It is a little beyond the scope of this book to handle these subjects here. We also leave it to the student on how to get from BCD numbers (one number per nybble) to ASCII codes a single digit to a byte. The routine for doing this is really inserted between digitizing the integer part of the number and digitizing the fractional part if you're trying to translate the ROM.

## Graphics--PLOT and DRAW

Plot is the basis for all draw routines. One tells the computer to Plot a point and then draw a line, or an arc, to the next point. Draw takes the two end coordinates and calculates the next point to be plotted. Plot takes these positions and converts them to the correct screen bit to be turned on. It is in<!-- p. 145 (pdf 155) -->teresting to see how the coordinates X and Y are converted into a screen position. The following routine, given by Timex, uses the FULL screen including the bottom 2 lines not normally available in Basic.

For setup Y is held in B, X in C. The scheme for the bytes is as follows:

```text
                 Y                                  X
  7   6   5   4   3   2   1   0       7   6   5   4   3   2   1   0
 Screen  Line #     Scan row            Column      #    Bit   #
 block   in block   in line              0-31             0-7
 0,1,2    0-7        0-7
```

Bits 2-0 of Y become Bits 2-0 of H. Bits 7 and 6 of Y must be moved down to 3 and 4 of H. Bit 7 of H must be 0 with Bit 6 = 1. Bits 5-3 of Y become Bits 7-5 of L while Bits 7-3 of X become Bits 4-0 of L. Bits 2-0 of X are the pixel position to be turned on reading left to right and must be converted to right to left Bit number notation.[^c08-4]

```z80
PLOT X,Y  PUSH BC   Save coordinates for further calculations
          LD A, 191     Test B
          SUB B
          JR C, Error   Y too big
          LD B, A       B now inverted, TOP = 0
          AND 192       Save only screen block
          RRA           Rotate down to positions 3 and 4
          RRA
          RRA
          LD H, A       Save block
          LD A, B       Reload B
          AND 7         Save only scan row
          OR H          ADD in screen block
          OR 64         Add in D File start
          LD H, A       Save in H
          LD A, C       Get X
          RLCA          Rotate around partly
          RLCA
          RLCA
          AND 199       Save only bits 7,6,2,1,0
          LD L, A       Save partly shifted data
          LD A, B       Get line # from Y
          AND 56        only save line #
          OR L          Add in L
          RLCA          Finish rotation
          RLCA
          LD L, A       L done
          LD A, C       Work on pixel #
          AND 7         Save only pixel #
          LD B, A       Save in B, # = 0-7
          INC B         # now 1-8
          LD A, 1
    Loop  RRCA
          DJNZ Loop
```

[^c08-5]

<!-- p. 146 (pdf 156) -->

```z80
          OR (HL)       Add in screen byte
          LD (HL), A    Print to screen

             Handle attribute here

          POP BC
          RET
   Error  RST 8
          10       INTEGER out of range
```

### DRAW

Drawing a straight line must only increment X and/or Y by one or the line will not be continuous. Partial increments of X or Y must be rounded and either the whole position or an increment addition to the present increment must be made. The MEM STK keeps these numbers between successive plots.[^v10-18]

For example: PLOT 0,0: DRAW 200,50. Calculates the slope of the line to be (50-0)/(200-0) =.25. It's going to take 200 PLOTS to do it for the 200 positions of X to be navigated. Y is going to move up only .25 of a pixel for each X plotted. In Basic it would be:

```basic
Let Slope = (Y1 - Y0)/(X1 - X0)
FOR X = 1 TO 200
LET Y = INT (Slope*X)
PLOT X,Y
NEXT X
```

Imagine how difficult plotting an arc or an ellipse must be.

[^v10-1]: Library note: the ROM also holds whole numbers from -65535 to 65535 in a "small integer" form whose first byte is 0, not an exponent: 0, sign byte (0 or 255), low byte, high byte, 0; STACK A and STACK BC (used in the example below) stack numbers this way, and RESTACK (61) converts them to full floating form; see docs/ts2068_dispatcher.md (ROM $30E9, $3656).

[^v10-2]: Library note: the calculator stack does not sit directly on the BASIC program; it follows the variables area and the workspace (WORKSP), running from STK BOT up to STK END; see docs/ts2068_memory_map.md.

[^v10-3]: Corrected against the ROM. The original printed "else leave a 1"; FP_AND at $393F (EB CD 04 39 EB D0 A7 18 DE) returns leaving X when Y is non-zero, otherwise clears the carry (AND A) and STBOOL at $3926 stores the integer 0, so X AND Y gives 0 when Y = 0 (the label "AND(x or y)" means X AND Y); see disassemblies/ts2068_home_rom_U16_stock.txt.

[^v10-4]: Corrected against the ROM. The original printed "Gives X$ if Y = 0"; the string AND at $3948 (EB CD 04 39 EB D0 D5 1B AF 12 1B 12) returns keeping X$ when Y is non-zero and sets the string length to 0 when Y is zero, so X$ AND Y gives X$ if Y <> 0, else ""; see disassemblies/ts2068_home_rom_U16_stock.txt.

[^v10-5]: Library note: operation 57 ($39) is get-argt, which reduces a trigonometric argument (multiplies by 1/(2 PI), removes the whole part and folds the result into the range -1 to +1) for the SIN, COS and TAN series; it does not convert a general function operand, but it does overwrite MEM 0 as stated; see disassemblies/ts2068_home_rom_U16_stock.txt (ROM $3B9E).

[^v10-6]: Library note: these side-effects agree with the ROM where they were traced (INT, X mod Y and operation 57 overwrite MEM 0; the series generator behind SIN, COS, TAN, ASN, ACS, ATN, LN and EXP uses B and MEM 0-2); the lists for TO THE, EXP, SQR and STR$ were not traced; see disassemblies/ts2068_home_rom_U16_stock.txt (series at ROM $3808).

[^v10-7]: Corrected against the ROM. The original printed "A0-A5"; the constant table at $3684-$3695 holds exactly five compressed constants (0, 1, 1/2, PI/2, 10) for operations A0-A4, as the table above says, and the jump table starts at $3696; see docs/ts2068_rom_entry_points.md.

[^v10-8]: Library note: STK DATA ($34) does not take a plain 5-byte slug but a compressed literal: a first byte holding the number of mantissa bytes minus 1 in bits 7-6 and the exponent minus 80 in bits 5-0 (if bits 5-0 are 0, the exponent minus 80 is in the next byte), then 1 to 4 mantissa bytes, the rest filled with zeros; following 52 with 144,127,255,0,0 would decode as a different number and put the op-code stream out of step, whereas 65535 is 52,64,64,127,255 ($34,$40,$40,$7F,$FF); see docs/ts2068_rom_entry_points.md (ROM $3785).

[^v10-9]: Library note: used as calculator operation 61, RESTACK needs no setup, since the calculator points HL at the first byte of the top value itself; it returns at once if that byte is non-zero (already floating) and otherwise converts the small-integer form (0, sign, low, high, 0) to full floating-point form; see disassemblies/ts2068_home_rom_U16_stock.txt (ROM $3656).

[^v10-10]: Library note: the calculator uses AF, BC, DE, HL and the alternate registers but never IX, and it relies on IY holding 23610 ($5C3A); STACK BC even reloads IY with 23610 (ROM $30E9); see disassemblies/ts2068_home_rom_U16_stock.txt.

[^v10-11]: Library note: neither routine raises an error; F.P. to BC (ROM $3160) returns with the carry flag set if the value is over 65535 and F.P. to A ($3193) with carry set if it is over 255, so test carry after the call; the value comes back rounded and without its sign, with the zero flag reset if it was negative; see disassemblies/ts2068_home_rom_U16_stock.txt.

[^v10-12]: Library note: setting CHAR ADDR alone is not enough; the routine at 12406 ($3076) expects the first character already in A (its first instruction is CP "."), so load A, e.g. with RST 24, after setting CH ADD and before the CALL; it also overwrites MEM 0; see disassemblies/ts2068_home_rom_U16_stock.txt.

[^v10-13]: (unverified) The routine at 12705 prints through RST 16 to whatever channel is current; the ROM cannot show what "PRINT ," is meant to set up beyond leaving a screen channel selected, so make sure the channel you want is open before the call.

[^v10-14]: Library note: no memory is safe across all routines: printing a number (12705) overwrites MEM 3-5, INT, X mod Y and the decimal-to-F.P. routine overwrite MEM 0, and SIN, LN, EXP and the other series functions overwrite MEM 0-2, so check what the routines you call use; see disassemblies/ts2068_home_rom_U16_stock.txt.

[^c07-3]: Corrected. The original printed "137 512.9921875" and "145 131.070"; 65535/65536 × 2^9 = 511.9921875 (half of 1023.984375 above it), and the exponent-145 value is 131,070, written with a comma like the other entries.

[^c07-4]: Corrected. The original printed "31.995117900"; the value meant is the exponent-133 entry in the table above, 31.99951171875.

[^c07-5]: Corrected. The original printed "66558.983475"; the mantissa 1000 0001 1111 1111 0111 1110 0000 0000 at exponent 145 is 2181004800 / 2^15 = 66558.984375 (= 65535 + 1023.984375).

[^c07-6]: Corrected. The original printed "65411.015625"; 65535 - 1023.984375 = 64511.015625, and the sentence itself gives the first two bytes as 64511.

[^c08-1]: Corrected. The original printed the 5th-step NEW ANS as `1100 0111  1111 1111  1011 1000  0000 0000` (third byte B8h instead of 38h, since `0100 0000 + 1111 1000` carries out of the byte) and the 7 answer lines that follow from it with the same `1011` fifth nybble, ending in CCCBB334h; all 8 lines are recomputed here and the final answer CCCB3334h equals FFFFh × CCCCh, the operands set up on p. 138.

[^c08-2]: Corrected. The original printed "149"; the multiplicand's exponent of 144 is incremented once, giving 145, as the division example on p. 141 also says.

[^v10-15]: Library note: a 32-bit mantissa carries about 9.6 decimal digits (32 x log10 2 = 9.63), in line with the 9-place precision given on p. 128; the example agrees to 10 figures only after rounding.

[^v10-16]: Library note: the 2068 ROM handles the fraction and the exponent differently: it puts 1 in MEM 0 and, for each digit after the point, divides MEM 0 by 10 and adds digit x MEM 0 to the running value; an E exponent is applied by multiplying by 10^m (ROM $310D), not by adding to the binary exponent byte; see disassemblies/ts2068_home_rom_U16_stock.txt (ROM $3093-$30A7).

[^v10-17]: Corrected against the ROM. The original printed "422 bytes"; the routine runs from 12705 ($31A1) to its closing JP $1788 at $3347-$3349 (C3 88 17), 425 bytes, with CA = 10*A + C following at $334A.

[^c08-3]: Corrected. The original printed the fifth "x10" remainder as `.0011 0000`; 240 × 10 = 2400 = 9 × 256 + 96, so the remainder is `.0110 0000`, the only value that yields the next printed line (integer 3, remainder `.1100 0000`).

[^c08-4]: Corrected. The original printed "Bits 5-0 of L" and "Bits 1-3 of X"; L bits 7-5 hold Y bits 5-3, so the five X bits 7-3 fill L bits 4-0, and the pixel position is X bits 2-0, as the listing's `AND 199`/`AND 56`/`RLCA` and `AND 7` show.

[^c08-5]: Corrected. The original printed `LD A, 192` and `DJNZ, Loop`; with 192, Y = 0 gives screen block 3 (H = 58h, the attribute file), whereas 191 maps Y = 0-191 onto the display file with top = 0 (checked for every X, Y against the 2068 screen layout), and the Z80 mnemonic is `DJNZ Loop` without the comma.

[^v10-18]: Library note: a straight-line DRAW does not keep its state in the calculator memories; the line is stepped out with integer registers by DRAWLN ($2813) from the last PLOT position in XCOORD/YCOORD; only DRAW with a third (angle) argument, which draws an arc, works through the calculator memories (MEM 0-5); see disassemblies/ts2068_home_rom_U16_stock.txt (DRAW, DRAWLN).
