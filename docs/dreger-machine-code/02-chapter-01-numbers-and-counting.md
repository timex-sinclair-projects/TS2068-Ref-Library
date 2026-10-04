<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 3–22. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 1: Numbers and Counting.*
*[← previous](01-introduction.md) · [book README](README.md) · [next →](03-chapter-02-memory-mapping.md)*

---

<!-- p. 3 (unnumbered; pdf 11) -->

# Chapter 1: Numbers and Counting

## The Digital Computer

The T/S 2068 is a digital computer. All it can do is handle numbers and that is ALL it can do--nothing more. But, it handles numbers very rapidly and very accurately doing exactly as it's told at about a million instructions per second.[^v03-1] Therein lies the problem. You are now embarking on writing instructions for a computer. In Basic there was enough error trapping to just stop a program and tell you you goofed. In machine code it crashes. 99 times out of 100 the first time you run your program it's going to crash irretrievably. So the first law of m/c programming is: ALWAYS SAVE YOUR PROGRAM BEFORE RUNNING IT...unless you don't mind the frustration of reentering your program a zillion or so times before you get it right.

The computer is "dumb" and has no brain of its own. It follows your instructions to the letter. Pardon me, to the number. If you tell it to do something wrong or something stupid it will do it as it doesn't know any better. There is no, "Well, you know what I mean". It's still the same old adage, "GARBAGE IN, GARBAGE OUT". The machine code programmer has to be meticulous and exacting or his/her program will never give the correct results. There is no margin for error. There is talk of making a thinking computer but these types of programs are complex and far far too advanced for you at this point--let's soar first, then try hang gliding and maybe a little flying like a turkey before we try to soar like an eagle or go supersonic like an SST.

## A Stumbling Block

I said that the computer can only handle numbers. That is true and later on I will show you that that is all it really does. This is the problem however. Everything is numbers and sometimes the numbers stand for numbers, sometimes they stand for instructions, sometimes they stand for symbols and sometimes they stand for pictures--it all depends upon where you are in the computer. We will find out what they mean at all these different times. But first let's look at how the computer stores a number.

## The Eight Bit Byte (pronounced bite)

Oh, oh! Two new words! If you are going to learn a new language you are going to have to learn the terminology so don't be afraid of new terms as they will be fully explained as they are introduced. You can't be a Chemist without knowing the symbols <!-- p. 4 (pdf 12) --> they use for elements and how they combine them to represent molecules, or Physics without terms such as momentum and inertia. So it is with programming.

The 2068 is an "electronic" digital computer--not a mechanical computer. In fact, it's nothing but a very huge collection of on-off switches called transistors packaged together very densely in LSIC (Large Scale Integrated Circuits) called chips which have from 2 to 64 leads coming out of them for connections to other things. They look like little black boxes. We are not going to investigate what exactly is inside these little black boxes as we leave that to the "Hardware Hackers". We are just interested in how to make them work properly. We aren't even interested in what signal to send down what wire as far as that goes.

## Binary Numbers

The memory section of the 2068 consists of 65536 sections each of which is 8 bits (switches) long. Each of these 65536 sections is called a byte. Where in this array of 65536 positions a particular byte is located is called its ADDRESS and is designated by a number from 0 to 65535. Zero is an absolutely good number as far as a computer is concerned. The bits inside a byte also are named by numbers. The lowest bit is called "Bit 0" (zero, not the letter "O"), with the next called "Bit 1", etc. to Bit 7 for the highest. Since we are used to reading numbers from left to right we would write the names of the bits as the following string:

```text
                7  6  5  4  3  2  1  0
```

By convention, we designate a zero as the "off" state of a switch and "1" as the "on" state. Then the number 0 would look like:

```text
                0  0  0  0  0  0  0  0
```

Hooray! It even looks like zero!

Flipping Bit 0 on to represent a 1 condition makes our string of bits:

```text
                0  0  0  0  0  0  0  1
```

And that looks like 1. So far so good.

But now we run into a snag since if we try to add another number to the right position for the number 2 we can't. There are only two positions for this switch, "on" and "off"--it's not a 10 position switch which is what we would need to write decimal numbers. Our only recourse is to start using the Bit 1 switch. Turning that on and turning off the Bit 0 switch gives us:

```text
                0  0  0  0  0  0  1  0
```

Which looks like 10 doesn't it?

<!-- p. 5 (pdf 13) -->

If we think about our digital (literally fingers) number system, which is a base 10 number system for obvious reasons, it starts using the 10's position on the 10th number (not counting 0). Now, since the computer starts using the 10's position on the 2nd number (again not counting 0), we say that the computer is using a base 2 number system--or binary (bi means 2 as in bicycle).

Well, how do we write 3? Simply as 2 + 1 or:

```text
               0  0  0  0  0  0  1  1
```

We are again, as they say, "full up" so the number 4 has to start using Bit 2--the third bit:

```text
               0  0  0  0  0  1  0  0

With 5 as:     0  0  0  0  0  1  0  1
and 6 as:      0  0  0  0  0  1  1  0
and 7 as:      0  0  0  0  0  1  1  1
```

At 8 we have to start using Bit 3 as:

```text
               0  0  0  0  1  0  0  0
```

But a shortcut. If we write down the values at which a switch is first used together with the switch or bit numbers we get an interesting sequence:

```text
     Bit #         7  6  5  4  3  2  1  0
     Value       128 64 32 16  8  4  2  1
```

Each bit is double that of the one to its right. Write this little table down somewhere so that you can refer back to it from time to time.

And, since we saw that to do a 3 we actually did 2 + 1, if we add all these values together we come up with 255 which is the highest value we can store in a byte. That's not a very big number. What do we do for bigger numbers?

We use another byte. But we don't just add the two together as that would only get us to 510. Let's put the 2nd byte in front of, or to the left of, the "low" byte. Like this:[^c01-1]

```text
     15    14   13   12   11   10   9   8   7  6  5  4 3 2 1 0
  32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1
```

If we continue our series of doubling, we get the numbers listed below the bit numbers as the first time that bit is used. Adding all these together gives us 65535 as the maximum for two bytes. Adding the number 0 gives us a total of 65536 storage spaces or bytes in memory. We call the upper byte of this 2 byte <!-- p. 6 (pdf 14) --> "word" the "high" byte.

We have already used this terminology in Basic when we did:

```basic
PRINT PEEK 23627 + 256*PEEK 23628.
```

Look at the value of Bit 8--256. To get it to read 1 we have to divide it by 256. To get Bit 9 to 2 we also have to divide by 256. Since the byte can only hold numbers up to 255 we have to multiply the high byte by 256 for the right answer. Omitting that 256* gives the wrong answer.

But shouldn't it be `PRINT 256*PEEK 23627 + PEEK 23628`?--high byte first? Nope! A quirk of m/c code is that it's always "low byte first, high byte last" for "word" size numbers.[^v03-2] We were actually asking our computer to give us the starting address of the VARS (variables) area storage.

We will be using double byte word storage quite often in m/c BUT we do not extend it to 3 or more bytes. When we need numbers bigger than 65535 or numbers with fractions, the computer goes to what is called floating point notation which handles numbers in quite a different manner.

## Converting Binary to Decimal Numbers and Decimal to Binary

Get that little table I told you to write down. You may wish to extend the table by adding the high byte numbers we added on page 5. Use a slash between the high and low byte. Let's convert:

```text
               0  1  0  0  1  1  1  1
```

back to decimal. We will write down the numbers corresponding to the 1 bits only and add these up. The left position is 0 so no 128. Next a 1 so we have 64. 2 more zeros so skip 32 and 16 but write down 8, 4, 2 and 1 for the last 4 1's. Adding them up we get 64 + 8 + 4 + 2 + 1 = 79.

Now try these: 1 0 1 0 1 0 1 0, 01100110, 10101, 1111.

Did I confuse you? Generally programmers don't space binary numbers nicely but run them all together as a string of 1's and 0's. They also drop all leading zeros. You should have gotten 170, 102, 21 and 15 for your answers.

Let's go the other way and convert a decimal number to binary. First, write down the number. We'll use 89. Refer to your table and try to subtract off 128. We can't, so write down a "0". Repeat with 64. It works so write down a "1" after the "0". Subtracting 64 leaves 25. Obviously 32 can't be subtracted so another 0. 16 can, so a 1 leaving 9. Another 1 for 8 leaves 1 so no 2 or 4 (00) and a 1 for the final 1 to finish off the number: 01011001.

<!-- p. 7 (pdf 15) -->

Okay! Try 180, 56 and 219. (The answers are on the bottom of the page to make it a little more difficult for you to cheat.)

## Adding and Subtracting in Binary

Adding and subtracting binary numbers is quite like it is in decimal notation if we remember that we can NEVER have numbers bigger than 1. So if we get a 2 in addition we write a zero and carry 1 to the next column. For example.

```text
               01111110    126
               00011111    _31
               --------    ---
               10011101    157
                ccxxxc
```

In the above example, the columns marked with a "c" resulted in an addition of 2 so we write a 0 and carry a 1. In the columns marked by an "x" we had a carry and an add to give us a 3 so we write a 1 and carry a 1 to the next column.

Now try these:

```text
 01010101     00111011     00111110     11000001
+10011111    +00111101    +01111100    +01000000
---------    ---------    ---------    ---------
```

The answers are on the bottom of the page again. But what about that last number? 193 + 64 = 257--that's bigger than 255 and our actual answer is 1. Only the 8 low bits count.[^c01-2] We have what is known as an "overflow". No, the computer won't crash if it happens but instead will turn on the CARRY FLAG to warn itself that a byte has gone past the zero mark. Thus, we sometimes call the carry flag the 9th bit of a byte. The computer automatically uses it when adding or subtracting word long numbers to get any carries from the low byte to the high byte.

SUBTRACTION: In subtraction, borrowing a 1 through a 0 results in a 1 remainder, not a 9 as we're used to. As an example:

```text
                ccc2
               10000011
              -00101010
              ---------
               01011001
```

The columns marked with a "c" have a remainder of 1 as the carry continues with a final carry of 2 over to the last column.

Now, try these subtractions. Careful, the last one is a zinger.

```text
 11001100     11100011     11111000     00011110
-00110011    -10011111    -10101010    -11100000
---------    ---------    ---------    ---------
```

| ANSWERS: 180 = 10110100, 56 = 00111000, 219 = 11011011
| ADDITION ANSWERS: 11110100, 01111000, 10111010, c00000001
| SUBTRACTIONS ANSWERS: 10011001, 01000100, 01001110, M00111110

<!-- p. 8 (pdf 16) -->

That last carry has an "M" before it indicating that it's a minus or negative number. And, you guessed it, another flag went up--the minus flag indicating that this time we had an "underflow".[^v03-3] The carry flag also goes on...unless it was on in which case that "1" was used and the carry flag is now "off"...but that can only happen when you use SBC (subtract with carry) instruction.[^v03-4] You will learn more about that later.

## Binary Multiplication

It's like regular multiplication by 1 and 0 with the add rules applying when you add. Since your computer can only add two numbers we will be adding our partial answers as we go along. We will assume we have as many bits as necessary for the answer and not concern ourselves with handling overflows at this point.

```text
      00010110     22              0000110101101111     3439
     x00001101    x13             x0000000011101111     x239
     ---------    ---             -----------------     ----
      00010110     66              0000110101101111    30951
    000101100_    22              0000110101101111_   10317
    ----------    --              -----------------
    0001101110    286             00010100001001101   6878__
                                                      ------
   00010110___                   0000110101101111__   821921
   -----------                   ------------------
   00100011110                   000101111000001001
                                0000110101101111___
                                -------------------
                                0001100100110000001
                              00001101011011110____
                              ---------------------
                              000100111011101100001
                             0000110101101111______
                             ----------------------
                             0001011101001100100001
                            0000110101101111_______
                            -----------------------
                            00011001000101010100001
```

Try these. No ringers this time.

```text
  00001111      00010001       111101101101101
 x00001111     x00010001      x0000000111101001
 ---------     ---------      -----------------
```

The answers are below.

## Binary Division

It's like regular division and subtraction combined with carries on the subtractions as we learned above.

| MULTIPLICATION ANS: 11100001, 100100001, 111010111100001100110101[^c01-3]

<!-- p. 9 (pdf 17) -->

```text
      ___10011                  ______1110111110
         -----                        ----------
 1101/11111111       and 110101/1100011001010110
      1101                       110101_
      ----                       -------
        10111                    1011100
         1101                     110101_
         ----                     -------
         10101                    1001110
          1101                     110101__
          ----                     --------
remainder 1000                      1100110
                                     110101_
                                     -------
                                     1100011
                                      110101_
                                      -------
                                      1011100
                                       110101_
                                       -------
                                       1001111
                                        110101_
                                        -------
                                         110101
                                         110101
                                         ------
                                              0
```

In the first case above we stopped when we hit the decimal point but there was no reason why we should do so. We could have kept right on going. We as yet have not discussed binary fractions so you have to go to a later section of this chapter to find out how a binary fraction is converted back to a decimal fraction.

Try these divisions.

1000001/1111, 11001100110/11001100, 11111111/101010.

You really won't be doing much adding, subtracting, multiplying, or dividing in binary in m/c but it lays the groundwork for floating point numbers which will be discussed later on.

## Hexadecimal Counting

And that is about all you can do with it is count. But, many programmers write in hexadecimal code and as such we have to discuss it. It has only 2 advantages:

1. All 8 bit bytes can be expressed with 2 and always 2 symbols.
2. Everyone does it. Well, almost everyone.

The second is the lamest excuse I have ever seen. It smacks of a "lemming" attitude.

I have never seen a scheme of doing simple arithmetic operations in hexadecimal. However, it has some historical, or is it hysterical, significance. It is the reason why the byte has 8 bits.

| DIVISION ANSWERS: 100 remainder 101, 1000 remainder 110, 110 remainder 11.[^c01-4]

<!-- p. 10 (pdf 18) -->

If you think about binary numbers, it takes 4 bits for the number 9, written as 1001B (the B in back of the number will be our way to designate a binary number). An H behind a number will signify a Hexadecimal number. Decimal numbers sometimes have a D suffix or none at all. Because all three systems are used we have to specify which we are using.

Historical: Back when computers had expensive memories (hand wired ferrite cores!) the byte was only 4 bits long. Just long enough to express a single decimal digit if you wish, with a little to spare--up to 15. Programmers didn't want to waste this extra space so the base 16 number system was devised. The 16 numbers used in this system are 0-9, A, B, C, D, E and F. You can see that a lot of imagination, intuition and ingenuity went into designing those symbols by BIG BLUE. It was in the era of IBM and Sperry Univac that I first saw the terminology used so I'll blame BIG BLUE as I first saw it in their publications. Even if IBM didn't do it, shame on them if they never bothered to fix it. IBM mania has led to other unnecessary complexities as well.

The 4 bit byte became known as the nybble (pronounced nibble). When computers grew, they put 2 nybbles into a byte making it 8 bits long. The future goes to the 16 and 32 bit computers with CPU's (Central Processing Units) already designed and in use so there is no chance of anyone ever deviating from the pattern.

In Hex, A = 10, B = 11, C = 12, D = 13, E = 14 and F = 15. The low 4 bits of a byte are expressed in the right symbol, the high 4 bits in the left symbol. If a nybble is zero, a leading or trailing 0 must be written. Thus F0 = 240 and 0F = 15.

To convert Hex to Decimal: Take the first symbol value and multiply by 16 and add the value of the 2nd symbol...if you have an IQ higher than 135 you can do it quite rapidly in your head.

To convert Decimal to Hex: Divide the decimal by 16, convert to the proper first symbol and then convert the remainder to the 2nd symbol.

For double byte numbers converted either way the important numbers to remember are 4096, 256, 16 and 1. I dare most of you to do that mentally.

For those of my readers who have normal IQ's the following table will help to convert from Hex to Decimal and Decimal to Hex.

To get from hex to decimal: Find the first symbol in the left column and read across to the column of the second symbol as found on the top. AA = 170. AB = 171. BA = 186.

To go from decimal to hex: Find the number in the table and read the first symbol on the left and the 2nd symbol on the top.[^c01-5]

<!-- p. 11 (pdf 19) -->

## Hexadecimal to Binary Conversion Table

```text
                           SECOND SYMBOL

      0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F

F 0   0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15

I 1  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31

R 2  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47

S 3  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63

T 4  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79

  5  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95

S 6  96  97  98  99 100 101 102 103 104 105 106 107 108 109 110 111

Y 7 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127

M 8 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143

B 9 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159

O A 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175

L B 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191

  C 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207

  D 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223

  E 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239

  F 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255
```

## Other Number Systems

There is still another base number system that has been used from time to time called OCTAL--base 8, but we won't be using that system.

## Negative Numbers

Up to this point we have been discussing positive or unsigned numbers. We now go to signed numbers.

Humans use the minus sign in front of a number to designate a negative number and sometimes a plus sign in front of positive numbers--but at least always a minus sign in front of negative numbers. Unfortunately, the computer doesn't recognize a minus <!-- p. 12 (pdf 20) --> sign unless it's given a number. In addition, the sign of a number should be stored with that number so it doesn't get lost. In signed numbers one of our precious 8 bits must be used as a sign designator. By convention, it's Bit 7. When zero, the number is positive, when 1, negative.

Let's see now. That limits positive numbers from 1 to 127 as 128 turns on bit 7. That leaves 128 spots for negative numbers.[^v03-5]

```text
But if  00000001B is 1, 10000001B should be -1. It isn't.
       _11111111B is -1. I have deliberately written it exactly
        --------
       100000000B        under the 1 and added them together.

Take another 2 numbers: 00110001   49
                        11001111  -49
                        --------  ---
Adding them:           100000000.
```

Notice that in both pairs the 0's have turned to 1's and the 1's to 0's...except for the low bit. If we took exact opposites and added we would always get 11111111B which is only 255. If -1 were 11111110, then 11111111B would be minus 0. I'm not enough of a mathematician to tell you the difference between a +0 and a -0. To avoid this, the number is complemented to 256 by merely flipping all the bits and adding 1. This is called twos complementing a number. In this way we only have one zero, not two. Simply flipping the bits is called complementing.

Since we will be working with single byte negative numbers the table on the next page will help convert a negative number to its 2's complement. The left column gives the tens with the units across the top. The table is dual conversion. Just use the right lines for decimal or Hex conversion. The table is also reproduced in the appendixes for your convenience.

Word long numbers use the same method by 2's complementing to 65536 with the first bit of the high byte indicating sign.

As an aside, the word complement comes from Plane Geometry where we had pairs of angles known as complementary angles which always added up to exactly 90 degrees.[^v03-6]

Now for the question of the month. How does the computer know when it's dealing with signed numbers or unsigned numbers?

The answer is, it depends upon the instruction. If the instruction requires a signed number one must be used. Signed numbers are used in JUMP RELATIVE statements where a negative number means jump backwards and a positive number means jump forward. The computer looks at Bit 7 and then makes appropriate operations based on the rest of the number.

<!-- p. 13 (pdf 21) -->

## Negative Number Conversion Table (Decimal and Hex)

```text
        _0___1___2___3___4___5___6___7___8___9.

  0      0  255 254 253 252 251 250 249 248 247
         00  FF  FE  FD  FC  FB  FA  F9  F8  F7

 10     246 245 244 243 242 241 240 239 238 237
         F6  F5  F4  F3  F2  F1  F0  EF  EE  ED

 20     236 235 234 233 232 231 230 229 228 227
         EC  EB  EA  E9  E8  E7  E6  E5  E4  E3

 30     226 225 224 223 222 221 220 219 218 217
         E2  E1  E0  DF  DE  DD  DC  DB  DA  D9

 40     216 215 214 213 212 211 210 209 208 207
         D8  D7  D6  D5  D4  D3  D2  D1  D0  CF

 50     206 205 204 203 202 201 200 199 198 197
         CE  CD  CC  CB  CA  C9  C8  C7  C6  C5

 60     196 195 194 193 192 191 190 189 188 187
         C4  C3  C2  C1  C0  BF  BE  BD  BC  BB

 70     186 185 184 183 182 181 180 179 178 177
         BA  B9  B8  B7  B6  B5  B4  B3  B2  B1

 80     176 175 174 173 172 171 170 169 168 167
         B0  AF  AE  AD  AC  AB  AA  A9  A8  A7

 90     166 165 164 163 162 161 160 159 158 157
         A6  A5  A4  A3  A2  A1  A0  9F  9E  9D

100     156 155 154 153 152 151 150 149 148 147
         9C  9B  9A  99  98  97  96  95  94  93

110     146 145 144 143 142 141 140 139 138 137
         92  91  90  8F  8E  8D  8C  8B  8A  89

120     136 135 134 133 132 131 130 129 128
         88  87  86  85  84  83  82  81  80
```

## Adding and Subtracting Negative Numbers

Notice in the above examples that -1 and +1 add up to zero as does -49 and +49--a very good reason for doing a 2's complement to negate a number. Now, if you recall your algebra--you do don't you? Anyway, when you subtract a negative number you change the sign and add. In m/c that means 2's complement and <!-- p. 14 (pdf 22) --> add. If you remember only that you will have no trouble subtracting negative numbers. Adding negative numbers just makes the results more negative--which means that if you run through the zero on the bottom side you have a number LESS than -128[^v03-7] and you have to go to word length numbers carrying the extra bit into the high byte and complement the high byte and 2's complement the low byte. This may be a bit confusing at this point but I have put it here to be reviewed when you are referred back to this chapter later in the book.

## Numbers That Aren't Really Numbers

Kindly open your Operators Manual to page 240. That's the book you got with your computer so I know you have a copy..somewhere. You are going to be sleeping with pages 239-245 and pages 262-265 so it would be a good idea to get copies made of these pages and put them inside plastic folders to save wear and tear on your Manual. You may also want to copy page 252 if you plan on doing a lot of screen work.[^v03-8]

### 1. Character Codes

In Basic you learned that, "`PRINT CHR$ 65`" will give you a capital A on the screen. On page 241, the number 65 has an "A" in the CODE column. 66 gives you a CAP B and 32 a space. All the numbers from 165-255 will give you the appropriate token spelled out. Therefore, all the numbers from 32 to 255 are printable. Those under 32 are not, giving the familiar "?".[^v03-9] In m/c we can even use these CONTROL characters in PRINT operations. Notice that the PRINT comma (6) is a different code than the comma (44). The PRINT comma is our TAB 16 or TAB 0 half line move.

### 2. Pixels

In Basic you learned how to design your own graphics by designating eight 8 bit numbers as a character, symbol or drawing. You now know enough about memory storage to figure out that the computer uses 8 bytes of binary to store the character. If you had a good Basic course you would even know where they are stored. You would also know where the display file is kept. For those of you not so fortunate, don't worry, just read the next chapter. Pixels are stored as numbers. Another example of a number that isn't a number.

### 3. Instructions

#### A. Tokens

Basic instructions like PRINT (CHR$ 245) are stored as single numbers as well. You were religiously instructed never to type in all the letters of PRINT but to hit the right token key. In this respect your 2068 saves a lot of space as it only uses one byte to store the word PRINT rather than 6 (extra space for the space after PRINT). It also lets your computer run faster as it only <!-- p. 15 (pdf 23) --> has to decode one number rather than a string. The first space after a line number or a ":" is always a token.[^v03-10]

#### B. Machine Code

The instructions we are to learn all about (assembly language) like: EX AF, AF' all have to be encoded to numbers. EX AF, AF' has the code number 8. The 8, not EX AF, AF' is what is stored. All machine code is nothing but a string of numbers--some of them instructions, some are real numbers, some are symbol or pixel numbers.

When we do a "`RANDOMIZE USR #`" or a "`PRINT USR #`" or a "`LET A = USR #`" or a "`LIST USR #`" (# = address) statement in Basic we are telling the computer to set its Program Counter, a special counter that keeps track of what address is holding the next instruction, to the address we give it and start doing the instructions from there on. There is NO BASIC INTERPRETER in the computer. It is just reading machine code that causes it to operate in a manner we call Basic language.

## BCD Numbers

BCD (Binary Coded Decimal) numbers are numbers that are not true binary numbers. Remember that we said the nybble (4 bits) was just big enough to hold one decimal digit? Therefore, in BCD the high nybble is a true binary number and the low nybble is a true binary number but the combination is not. An 8 bit byte holds 2 decimal numbers from 0 to 9 in each nybble, 00 to 99 in each byte. 12345678 in BCD is 12, 34, 56, 78 in separate bytes but looks like 0001 0010, 0011 0100, 0101 0110, 0111 1000 in binary bits spaced into nybbles. The 2068 only uses binary coded decimal numbers at one point in floating point calculations when converting a binary number back to decimal. This is only temporary as it always stores numbers one to the byte in ASCII coded format or true binary.

## The Slug

After writing a line and hitting ENTER, your computer edits the line before putting it in the program, a feature you don't really appreciate until you work on another computer and get all those syntax errors when trying to run a program. Another thing the computer does before entering a line is SLUG the number. If you want to know where I got this word check code 14.[^v03-11] When it detects a number it goes to the end of the number and puts in a 14 code, sends the digits it has found (together with any sign, decimal point and E) to the floating point calculator for encoding into a 5 byte long number which is then inserted after the slug indicator. The first byte of the number is the exponent of the number telling the computer how many binary places left or right of the first binary digit to put the decimal point (I suppose we shouldn't use the term "decimal point" when talking about binary numbers but it is used for the same purpose as in <!-- p. 16 (pdf 24) --> decimal--to differentiate the integer from the fraction.) The next 4 bytes are the 32 most significant binary digits of the number. The computer has done some of the calculations that it would normally have to do when running the program. Obviously this speeds up execution of the program.

However, we never see these 6 bytes printed to the screen when we LIST the program as the print routine detects the 14 SLUG code and skips it and the next 5 bytes. We will see how this works when we look at the storage of a typical Basic line a little later in the book. The Slug is another example of a number that is not a number.

## Decoding the Slug

Fractional Binary Numbers: Before we can decode the slug we have to discuss fractional binary numbers. For our example, let's assume the decimal point is at the left of the high bit. The bits then have the values:

```text
1/2 1/4 1/8  1/16  1/32   1/64    1/128    1/256     1/512
.5 .25  .125 .0625 .03125 .015625 .0078125 .00390625 .001953125
```

The decimal equivalents are given under the fractional ones. The fractions should look familiar--they are the same numbers we used for whole numbers only now they are in the denominators. To help us convert fractions and whole numbers to binary we will use the table on the next page.[^c01-6]

We have only listed the 48 binary digits either way from the decimal point. The table, of course, can be extended. We would have to that if we wanted to encode numbers like 6.023E+23 or 9.1085E-28.

You are also wondering why I extended the decimal numbers out to the very end when we all know that the 2068 is only accurate to 10 places.[^v03-12] The reason is that if we don't carry out subtractions or additions to the bitter end errors creep into the numbers. We use the abbreviations, 9 0's and 12 0's to condense the fractions in the bottom part of the table to reduce the length of numbers for printing on an 80 column printer.

Let's convert 0.10000000000 to binary. This looks like a simple number but watch what happens. Take an empty sheet of paper and write down 0.100000000 on the top. Go down the table writing zeros for each number we pass because it is bigger than our number. In our case, our binary number would start with .0001 as we go down to .0625. Subtracting leaves us a remainder of .0375. Again we look for a number equal to or just smaller than our remainder. We find it in the next number at .03125. Our binary becomes .00011 with a remainder of .00625. We skip two numbers to get to .00390625 so our binary is now .00011001 with a remainder of .00234375. On to .000110011 binary using .001953125 for a remainder of .000390625. A few more binary bits to .000110011001

<!-- p. 17 (pdf 25) -->

## Binary Bit Conversion Table

```text
                  1  .5
                  2  .25
                  4__.125
                  8  .062,5
                 16  .031,25
                 32__.015,625
                 64  .007,812,5
                128  .003,906,25
                256__.001,953,125
                512  .000,976,562,5
              1,024  .000,488,281,25
              2,048__.000,244,140,625
              4,096  .000,122,070,312,5
              8,192  .000,061,035,156,25
             16,384__.000,030,517,578,125
             32,768  .000,015,258,789,062,5
             65,536  .000,007,629,394,531,25
            131,072__.000,003,814,697,265,625
            262,144  .000,001,907,348,632,812,5
            524,288  .000,000,953,674,316,406,25
          1,048,576__.000,000,476,837,158,203,125
          2,097,152  .000,000,238,418,579,101,562,5
          4,194,304  .000,000,119,209,289,550,781,25
          8,388,608__.000,000,059,604,644,775,390,625
         16,777,216  .000,000,029,802,322,387,695,312,5
         33,554,432  .000,000,014,901,161,193,847,656,25
         67,108,864__.000,000,007,450,580,596,923,828,125
        134,217,728  .000,000,003,725,290,298,461,914,062,5
        268,435,456  .000,000,001,862,645,149,230,957,031,25
        536,870,912__._9_0's_,931,322,574,615,478,515,625
      1,073,741,824  . 9 0's ,465,661,287,307,739,257,812,5
      2,147,483,648  . 9 0's ,232,830,643,653,869,628,906,25
      4,294,967,296__._9_0's_,116,415,321,826,934,814,453,125
      8,589,934,592  . 9 0's ,058,207,660,913,467,407,226,562,5
     17,179,869,184  . 9 0's ,029,103,830,456,733,703,613,281,25
     34,359,738,368__._9_0's_,014,551,915,228,366,851,806,640,625
     68,719,476,736  . 9 0's ,007,275,957,614,183,425,903,320,312,5
    137,438,953,472  . 9 0's ,003,637,978,807,091,712,951,660,156,25
    274,877,906,944__._9_0's_,001,818,989,403,545,856,475,830,078,125
    549,755,813,888  . 12 0's,909,494,701,772,928,237,915,039,062,5
  1,099,511,627,776  . 12 0's,454,747,350,886,464,118,957,519,531,25
  2,199,023,255,552__._12_0's,227,373,675,443,232,059,478,759,765,625
  4,398,046,511,104  . 12 0's,113,686,837,721,616,029,739,379,882,812,5
  8,796,093,022,208  . 12 0's,056,843,418,860,808,014,869,689,941,406,25
 17,592,186,044,416__._12_0's,028,421,709,430,404,007,434,844,970,703,125
 35,184,372,088,832  . 12 0's,014,210,854,715,202,003,717,422,485,351,562,5
 70,368,744,177,664  . 12 0's,007,105,427,357,601,001,858,711,242,675,781,25
140,737,488,355,328  . 12 0's,003,552,713,678,800,500,929,355,621,337,890,625
```

<!-- p. 18 (pdf 26) -->

and a remainder of .000146484375. Counting the bits we have in our binary number we are up to 12. Looking at our remainder we only have 3 place accuracy (3 zeros). Fortunately, we see a pattern developing in our binary number which indicates that it has a repeating set of numbers and will NEVER come out even. That is, in fact, the case. Our binary number will look like:

```text
.000110011001100110011001100110011001 with a remainder of:
0.000,000,000,100,708,386...
```

Counting the zeros in our remainder,[^c01-7] we find that we have 9 place accuracy. Exactly as advertised, the 2068 only is capable of 9 place accuracy. Well, yes and no, sometimes it's less.

Try, `LET z = 1.00100100100100: PRINT z`. The answer was 1.001001.[^v03-13] That's only 7 digits long. You did get 9 digit accuracy as the number would be 1.00100100 but the trailing two zeros are never printed.[^v03-14] The 2068 never prints trailing zeros which is a nuisance when it comes to dealing with dollars and cents amounts.

Try, `LET w = 123456789: PRINT w`. You get 1.2345679E+8...8 digits long. Whoops, an error! Instead of getting 1.23456789E+8, our answer was truncated at 8 digits and rounded. The 2068 rounds whenever the truncated number is 5 or more.[^v03-15] Therefore, although the 2068 has 9 place accuracy, you don't always get 9 digit numbers.

The true mathematician could have told us that it would take approximately 3.32 binary digits for every decimal digit. Therefore, 32 bits of binary is only 9.63 decimal digits worth.

Going from binary number is easy with the use of the table. Start at the decimal point and write down the integer of the "1" bits only and then add them up. Then do the fractional part by again writing down the fractional equivalents of the "1" bits and add them up as well.

| Try these:
| Encode to binary: .444444444, 321.798 and 1,678.79.
| Decode to decimal: 101.10110110110110110110110110110110,
| 11100000000001011.000011110000111, and 111.0011100000000011111111
| Round the decimals to the 10 most significant figures.

## Dollars and Cents

We learned in Basic that to round a number to dollars and cents

| ANSWERS: .444444444 = .01110001 11000111 00011100 01101111,
| 321.798 = 10100000 1.1100110 00100100 11011101,
| 1678.79 = 11010001 110.11001 01000111 10101110,
| Binary to Decimal: 5.714285714, 114699.0588, 7.218810797[^c01-8]

<!-- p. 19 (pdf 27) -->

we do a:

```basic
        LET a = (INT((a +.005)*100)/100)
```

where "a" is the number we want to round to the nearest penny. However, try the following values of "a" and see what you get when you PRINT a: 0.005; 2.000 and 1.005. I got .01, 2 and 1 respectively. Well, the first two are right although the 2nd answer didn't print the ".00". The third answer is even wrong as it should be 1.01! Try 1.005001 and you get the right answer. It's only the value 1.005 that comes out wrong.[^v03-16]

If you want the 2068 to print even dollars with trailing ".00" you have to trick it into doing so. The following program will do it for you (except for 1.005). A is your variable.[^c01-9]

```basic
 5 LET a = (INT ((a +.005)*100))
10 LET a$ = STR$ a
15 PRINT a$( TO LEN a$-2);".";a$(LEN a$-1 TO )
20 LET a =a/100
```

*Notes on the listing above:* amounts under 10 cents.[^v03-17]

Line 20 is not necessary if you have no more calculations to do on your number. If you want your printout in neat columns, you have to do a calculated TAB based on LEN a$.

By now you have also noticed that the 2068 doesn't print numbers with commas every 3 spaces. In fact, entering numbers with commas in them will give you a syntax error. The 2068 doesn't have a PRINT USING function like many computers have. Of all the missing commands that would be beneficial I have yet to see someone do this one. However, once again, by putting the number into a string we can trick it into inserting the commas where we want them. We have that extra piece of information called the LEN of the string to help us out. We leave it to the student to modify the above program to print a "$" in front of numbers and add commas every 3rd digit.

A further caution about INT. It always rounds down. Thus 1.99 becomes 1; 0.999 becomes 0 and -1.999 becomes -2 as does -1.01.

## The Slug Exponent

In our example of fractions, we didn't have a full number ahead of it. From the examples I gave you we combined integers with fractions. The decimal point occurred anywhere in the binary byte. That is an impossible situation as EVERY BYTE MUST BE AN INTEGER. We get out of this situation by moving the decimal in front of the first significant bit--the first "1" and use an exponent byte to indicate how many places we moved it. That means that numbers smaller than .5 are going to have the zeros between the decimal and the first "1" chopped off as we move the decimal right. For full numbers the decimal will have to move left. In other words, we need positive and negative exponents. BUT, it's not the negative numbers we just learned about. This time Sin<!-- p. 20 (pdf 28) -->clair uses 80H (128D) as zero with numbers greater than 128 as positive and numbers under 128 negative (127 is -1).

If you remember, 0.100000000 in binary started as .0001100110... The first significant digit is the 4th binary number. Thus we chop off the 3 leading zeros and move the remaining digits left 3 bits. The exponent becomes 128 - 3 = 125.

What is the exponent for 31, 11111. binary? 128 + 5 = 133.[^v03-18] The 32 binary digits are padded out with zeros as .11111000 00000000 00000000 00000000. We show the position of the moved decimal point.

## Signed Floating Point Numbers

Since the first bit of the binary part of the number is always a 1, this position is superfluous. The 2068 takes full advantage of this fact and stores the SIGN of the number there...a "0" for positive and a "1" for negative. Our number 31 becomes .01111000 in its first byte. Our decimal .1 becomes .01001100 in its first byte.

Let's convert our .1 to slug form. We know the exponent is 125 and the binary part was .01001100 11001100 11001100 11001100 (we had to add 3 more digits on the end when we chopped off the 3 leading zeros.) Converting the bytes to decimal gives us the slug 14, 125, 76, 204, 204, 205.[^v03-19] Remember slugs start with a 14 which really isn't part of the number.

## Translating Slugs into Numbers

The 2068 uses two notations for slugs. We have just given you the floating point notation. Integers are stored as 14, 0, 0, low, high, 0.[^v03-20] Translation is direct.

Since you have probably PEEKed these numbers, they will be 5 decimal numbers after a 14. The first after the 14 is the exponent. Skip that for the time being and convert the next 4 bytes into binary. Now look at the leading bit. If it's a zero convert it to a "1", if a 1 leave it and write a minus sign in front of the bit. Now subtract 128 from the exponent and move the decimal that many places right if positive or add that many zeros in front of the first byte if negative. Now refer back to the table on page 16 and convert the binary to decimal.

Alternate translation: Sometimes the above method gets to be really horrendous as one even moves off the table. We can translate the binary part of every number as a whole number starting at bit 32 in the table. Once we have this number we now adjust the number for the SHIFTED exponent. Take the exponent and subtract off (128 + 32 = 160)--the extra 32 is because we started conversion at bit 32 assuming our exponent was 32. With our remainder go down the table that amount of numbers and if negative read the fraction (if your exponent was still positive, read the <!-- p. 21 (pdf 29) --> integer number). MULTIPLY by this number. If you have a good hand calculator you can probably do it on that without difficulty unless you have a really big or small number.

The student will have surmised from all this that the same binary number can represent 255 different numbers[^v03-21] just because there is a change in the exponent. The exponent of 126 turns our same binary number that gave us 0.1 into 0.2. An exponent of 127 would give us 0.4. 128 would give us 0.8. 129 would give us 1.6, etc.

## Scientific Notation

Remember when we did `LET w = 123456789 : PRINT w`, and got an answer of 1.2345679E+8?[^c02-1] We get this scientific notation every time a number is more than 8 digits long--not like your Manual says over 10^13![^v03-22] You will remember from Basic that the "E" means "times 10 to the power of". What it really says is move the decimal point over that many places--left if negative, right if positive.

In the 2068 ROM there is a check exponent routine that finds how far away from 128 the exponent is and, if greater than 32 either way, automatically goes into E notation.[^v03-23] It is very important to keep this in mind when dealing with dollars and cents, as in doing bookkeeping where rounding and truncating numbers is a "no-no". Once you get to about $100,000.00 there is a distinct possibility of messing up the number. It really doesn't take a very big business to have assets over that amount.

## Limits of Number Size

It is now obvious that 2^127 and 2^-128 are the largest and smallest numbers that our computer can ever handle as that is the point where the exponent hits 255 and 1 respectively.[^v03-24] These numbers are 1.7014118E+38 and 2.9387359E-39. Big but not huge. The 2068, like any other computer, can be made to handle much bigger numbers but not without writing your own m/c program to do so. We discuss the problems of doing this in the chapter on floating point.

## Double Precision Numbers

Some computers have less precision than 8 decimal numbers in their original setups but then add double precision numbers that allow accuracy without rounding out to 16 or more significant figures. The 2068 doesn't have this feature much to the irony of some owners. What obviously has to be done is that a double precision floating point calculator must be written using an 8 byte mantissa (in machine code of course as Basic is too slow). This is no simple task and not a project for even the most ardent of machine code novices. The routine to print a floating point number from our binary data is not simple to understand much less rewrite.

<!-- p. 22 (pdf 30) -->

[^v03-1]: Library note: the Z80A runs at 3.528 MHz and its fastest instructions take 4 T-states, so even an unbroken run of them gives only about 880,000 per second, and typical code manages a few hundred thousand; see CLAUDE.md (Key Facts) and docs/z80_combined_reference.md.

[^c01-1]: Corrected. The original printed 65 under bit 6; 2^6 = 64, as in the 8-bit table just above and as the doubling series requires.

[^v03-2]: Library note: true of Z80 word operands and of the system variables, but not quite "always": BASIC line numbers in the program area are stored high byte first; see docs/ts2068_tokens_and_keyboard.md (program line format).

[^c01-2]: Corrected. The original printed "Only the 8 low bytes count"; an 8-bit sum keeps its 8 low bits, the 9th going to the carry flag, as the next sentences explain.

[^v03-3]: Library note: the Z80 sign (minus) flag copies bit 7 of the 8-bit result, which for 00011110 - 11100000 = 00111110 is 0, so S stays off; only the carry (borrow) flag shows the true difference (-194) went below zero (SUB 224 with A=30 gives A=3EH, S=0, C=1); see docs/z80_combined_reference.md (flag table).

[^v03-4]: Library note: SBC subtracts the incoming carry as well (A = A - s - CY), so with carry already set the result goes one further below zero and the carry is set again by the new borrow; the incoming carry is never "used up" to clear it (SBC A,224 with A=30, C=1 gives A=3DH, C=1); see docs/z80_combined_reference.md (SBC).

[^c01-3]: Corrected. The original printed 100110010 and 1101000101000000110101 for the second and third answers; 00010001 x 00010001 = 17 x 17 = 289 = 100100001 and 111101101101101 x 0000000111101001 = 31597 x 489 = 15450933 = 111010111100001100110101.

[^c01-4]: Corrected. The original printed "101" and "1100011000" for the first and third answers; 1000001/1111 = 65/15 = 4 remainder 5 = 100 remainder 101, and 11111111/101010 = 255/42 = 6 remainder 3 = 110 remainder 11.

[^c01-5]: Corrected. The original printed 18 in row 1, column 3 of the table below; 13H = 1 x 16 + 3 = 19.

[^v03-5]: Corrected. The original printed "127 spots"; a two's complement byte runs from -1 (FFH) down to -128 (80H), 128 negative values, as the table on the next page shows.

[^v03-6]: Corrected. The original printed 180 degrees; complementary angles add up to 90 degrees (angles adding up to 180 are supplementary).

[^v03-7]: Corrected. The original printed -255; a signed byte holds -128 to +127, so a sum below -128 needs word length.

[^v03-8]: (unverified) The page numbers here and below (240, 239-245, 262-265, 252, 241) refer to the 2068 User Manual, which the library does not hold; the facts cited from them (CHR$ 65 = "A", 66 = "B", 32 = space) are standard.

[^v03-9]: Library note: only some codes under 32 print "?" (the ROM's LD A,"?" at 0580H); 6 (comma), 8 and 9 (left/right), 13 (ENTER) and 16-23 (INK, PAPER, FLASH, BRIGHT, INVERSE, OVER, AT, TAB) act on the print position or colours; see the SENDTV/CONTRO table in disassemblies/ts2068_home_rom_U16_stock.txt (ROM $0500).

[^v03-10]: Library note: in a stored line the line number is followed by a 2-byte length before the first keyword, and on the 2068 that keyword byte may be one of the low codes 0CH (DELETE) or 7BH-7FH (ON ERR, STICK, SOUND, FREE, RESET) rather than 165-255; see docs/ts2068_tokens_and_keyboard.md and CLAUDE.md.

[^v03-11]: (unverified) The Manual's wording for code 14 cannot be checked here, but the Timex ROM source comments call $0E the "number slug" and the dispatcher routine that strips them is DESLUG (service $25); see docs/ts2068_dispatcher.md.

[^c01-6]: Corrected. The original printed .000,000,014,901,161,193,947,656,25 for 33,554,432, ,806,640,125 at the end of the 34,359,738,368 row, and ,616,024,739,... for 4,398,046,511,104 (each row must equal 1/2^k exactly, i.e. 5^k with leading zeros); the 4,398,046,511,104 error had been halved into the five rows that follow it, and those rows (originally ending ,808,012,369,..., ,404,006,184,..., ,202,003,092,..., ,601,001,546,... and ,500,773,105,621,337,895,625) are recomputed here as well.

[^v03-12]: Library note: the 32-bit mantissa gives about 9.6 significant decimal digits (the library says ~9.5), consistent with the 9 places the book arrives at on p. 18, not 10; PRINT shows at most 8; see docs/ts2068_vs_spectrum48_comparison.md.

[^c01-7]: Not corrected. The printed remainder 0.000,000,000,100,708,386... matches no truncation of 0.1 in binary: the 36-bit fraction shown leaves 0.000,000,000,008,731,149... (which would contradict the 9-place conclusion), while a 32-bit fraction, the slug's mantissa length, leaves 0.000,000,000,139,698,386... (which fits the conclusion and the printed "386" ending but not the 36 digits printed), so which figure was intended cannot be settled from the page.

[^v03-13]: Corrected against the ROM. The original printed LET z = 1.00101001001001; run on the stock HOME ROM that value prints 1.00101 (slug 81 00 21 18 94), while 1.00100100100100 prints the 1.001001 given here and matches the "1.00100100" that follows.

[^v03-14]: Library note: PRINT always rounds to at most 8 significant digits (the CP $08 at ROM $32A1), so the number becomes 1.0010010 and the one trailing zero is dropped; trailing zeros are indeed never printed (2.000 prints 2); see disassemblies/ts2068_home_rom_U16_stock.txt (ROM $329E).

[^v03-15]: Corrected against the ROM. The original printed "greater than 5"; the number printer rounds up when the first dropped digit is 5 or more (LD A,$04 / CP (MEM4+3) at ROM $3283, bytes 3E 04 FD BE), so 12345678.5 prints 12345679; see disassemblies/ts2068_home_rom_U16_stock.txt.

[^c01-8]: Corrected. The original printed 01101011 as the last byte for .444444444, "1101001 110.11001 01010001 11100110" for 1678.79 (the integer part 1101001110 is only 846), and 5.71418299, 113699.059 and 7.21894318 as the decoded values; exact conversion gives the bytes shown and, to 10 significant figures, 5.714285714, 114699.0588 and 7.218810797.

[^v03-16]: Library note: 1.005 is not the only one; most x.xx5 values are stored slightly below their true value, and on the stock ROM about a quarter of all half-cent amounts round down with this formula (0.505 gives 0.5, 1.015 gives 1.01, 1.025 gives 1.02); see docs/ts2068_dispatcher.md (Floating Point Number Format).

[^c01-9]: Corrected. The original printed "(INT ((a +.005)*100)", with three opening parentheses and two closing, which the 2068 rejects as a syntax error; the missing ")" is restored at the end.

[^v03-17]: (unverified) Not run on a full BASIC interpreter, but for amounts under 10 cents STR$ a has one digit, so line 15 asks for a$( TO -1) and a$(0 TO ), which Sinclair BASIC should reject with an error; the listing also inherits the rounding failures noted above, so it works only for amounts of 10 cents or more.

[^v03-18]: Library note: this is how 31 looks in full floating point form (85 78 00 00 00); in a program line, and wherever a whole number from -65535 to 65535 is stored, the 2068 uses the integer form instead, so the literal 31 is slugged as 0, 0, 31, 0, 0; see docs/ts2068_dispatcher.md (Floating Point Number Format).

[^v03-19]: Corrected against the ROM. The original printed 14, 125, 76, 204, 204, 204; the stock HOME ROM's number reader rounds the last mantissa bit (the bits after the 32nd are 11...), storing 0.1 as 7D 4C CC CC CD, i.e. 14, 125, 76, 204, 204, 205; the truncated form also prints as 0.1.

[^v03-20]: Library note: this form covers 0 to 65535; on the calculator stack and in variables, -1 to -65535 use 0, 255, low, high, 0 with low/high in two's complement (-1 is 0, 255, 255, 255, 0); in program text a minus sign is a separate operator, so slugs there are never negative; see docs/ts2068_dispatcher.md (Floating Point Number Format, ROM $314C).

[^v03-21]: Corrected against the ROM. The original printed 256; exponent byte 0 marks the integer form (1 is stored 00 00 01 00 00), so only the 255 exponents 1-255 are floating point; see docs/ts2068_dispatcher.md (Floating Point Number Format).

[^c02-1]: Corrected. The original printed 12345678; the passage being recalled (p. 18) is LET w = 123456789, and only that nine-digit value prints as 1.2345679E+8.

[^v03-22]: (unverified) The Manual's wording cannot be checked here; the stock ROM does switch to E notation above 8 integer digits as the book says, and 1E13 itself prints as 1E+13.

[^v03-23]: Library note: the ROM decides on the decimal, not the binary, exponent: it switches to E notation when there would be 9 or more digits before the decimal point or 5 or more zeros after it (1E+8 and 1E-6 print in E form, 99999999 and .00001 do not), whatever the binary exponent; see disassemblies/ts2068_home_rom_U16_stock.txt (ROM $32FC, CP $09 / CP $FC).

[^v03-24]: Corrected against the ROM. The original printed "255 and 0"; exponent byte 0 is the integer-form flag, so the smallest number uses exponent byte 1 (0.5 x 2^-127 = 2^-128, raw 01 00 00 00 00 prints 2.9387359E-39), and strictly the largest is just under 2^127 (raw FF 7F FF FF FF prints 1.7014118E+38); see docs/ts2068_dispatcher.md.
