<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 147–168. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 9: Peripherals.*
*[← previous](09-chapter-08-floating-point-calculator.md) · [book README](README.md) · [next →](11-chapter-10-io-and-bank-switching.md)*

---

<!-- p. 147 (pdf 157) -->

# Chapter 9: Peripherals

## Dot Matrix Printers

To operate a dot matrix printer you not only need the printer but an interface and a firmware program called the Print Driver Program. The interface has to be compatible to the 2068, i.e., match the circuit board lines that come out the back side of the computer. These are different on the 2068 than the Spectrum and the "Silver Avenger". The other end has to plug into your printer. Since Timex never got around to supplying us with a standard dot matrix printer much less an interface, 3rd party venders have stepped in to fill the void. The two favorite interfaces are the AERCO and the TASMAN. Both are parallel interfaces. One could use a serial interface but that slows things down tremendously.

Printers are pretty well standardized. Generally any Printer Driver Program can be modified to run any printer although driver programs may not work with a different interface. Timing for some printers has had to be modified inside the printer driver program to get them to run. Modifications to operate a particular dot matrix printer are done in Basic and POKEd into the code portion of the program which then can be saved and used "as is" each time it is needed without the Basic.

One thing that the printer driver program does is change the channel address jumped to by the `LPRINT` and `LLIST` commands to call the dot matrix driver routine instead of the 2040 printer routine. Once modified `LPRINT` and `LLIST` automatically go to the dot matrix printer.

Since the `COPY` command does not use a channel, using copy still sends the signals to the 2040 printer. To COPY to a Dot Matrix Printer requires the use of a `RANDOMIZE USR` call to that portion of your driver program that handles it. (We can't change the COPY routine as it is in unchangeable ROM unless we go through some hardware changes.) Since COPY will be sending pixel lines rather than ASCII code to the printer, the printer must be converted to accepting this type of signal by sending it some escape code commands.

### Escape Codes

When we first turn on our printer, its internal ROM sets itself up with certain values for the margins, font, line spacing and the like. These preset values are default values. In other <!-- p. 148 (pdf 158) --> words, the ones it will use if you don't send it any commands to change them. They are generally called escape codes because the majority of them all start with the character #27. In fact, all the codes below 32 are considered command controls for the printer. ASCII codes start at 32 and run to 127 only. All the ESCape codes are given in one of the appendixes in the back of your printer manual. #27 is labeled ESCape. You will notice that certain of the numbers below 32 have other names as well. Of particular note is #13 better known as carriage return.[^c08-6] Like machine code instructions, the printer ROM knows when it receives a certain code exactly how many following bytes go with that code and will interpret the next numbers it receives as fulfilling those requirements. Since we can't just press a key that will put code #27 inside a string we are forced to do it with `CHR$ 27`. Some numbers which follow an ESC (27) are codes for symbols or letters and can be sent as a quote letter, symbol or number instead of `CHR$`. We can also use an `OUT` statement to send codes to the printer if we know what port number the interface and the printer are using. The AERCO and TASMAN interfaces use port 127.[^v11-1] Several `OUT` statements, one after the other can also be used to change the configuration of a printer. I have to give you a word of caution here. Some printers are extremely slow in accepting ESCape codes. When they are busy processing a code they send a busy code back saying don't send any more numbers yet. This must be detected by the Printer Driver Program and obeyed or the next numbers will go unheeded. Since you are not using the Printer Driver Program when sending `OUT` statements directly, you either have to detect these signals with an `IN (port), A` and `IF A <> 0 THEN GOTO` (the same line like when using `INKEY$`), or wait a sufficiently long time to assure that the printer is free before sending the next code number (such as a `PAUSE`).

### Dot Matrix Pixels

We learned in Basic that a character or graphic is made up of 8 bytes of 8 pixels each. Actually, in the case of capital letters, there is a blank pixel all the way around the letter.[^v11-3] Pixel lines 1 and 8 are blank and so are the 1st and last pixels in the middle 6 bytes. So in reality, we only use a 6x6 matrix to draw the letter. Most lower case letters follow the same format except for j, q, p, g, and y which go below the line with what are called descenders and as such use byte 8 for that purpose. Dot matrix printers use various formats, one of the common ones being a 9x9. This difference in the number of pixels that form a character is no problem in printing the letters as the printer has its own pixel tables for characters--plural as most have several standard fonts already in their ROM. Since we just send the ASCII letter codes, not the pixels, the printer just looks up the right pixel codes like your computer does and uses that matrix. The printer also prints in a different manner by doing all the leftmost pixels of a character at a time, then the 2nd leftmost etc.--the pixels are vertical not horizontal.

The problem comes with COPY where the pixels are sent. The line <!-- p. 149 (pdf 159) --> spacing has to be changed as well as the mat. Only the top dot is used to print the pixel line sent. The paper moves up only a fraction of a character line to print the next row of pixels, etc. The printer just reads the whole row of pixels one at a time.

### Designing Your Own Dot Matrix Characters

Before jumping off and designing your own characters consult the appendixes in your printer manual as you might just find what you are looking for in characters 160 to 255. How you get your printer to print them will depend upon your Print Driver Program. Using `CHR$ 180` with some will get you the word TAN which may mean that you may have to resort to the "OUT (port), code" mode of operation discussed above.

Most printers allow for the designing of your own font or character. Of course, it must be designed within the limits of the printer character space. Once designed, the printer must be configured to accept the new font characters and the pixel bytes loaded.

Generally you will only be redesigning a few characters so the first thing you want to do is download (that's the term for getting the entire pixel table the printer uses into its RAM where it can be changed.) The entire set is downloaded and then just the ones you want changed are changed. You have to give up the printing of a standard ASCII character for each new character you want. Without downloading a standard set, your printer is going to print blanks for every character you haven't entered. In this way you can mix your own characters with a standard set.

Designing your own character set is similar but different than designing characters for the screen as you did with UDG characters. First, you can't use those characters directly unless you copy the screen in its entirety--this of course leaves you with a format only 32 characters wide which probably is not what you want on a full sized piece of paper. Since printers vary in how they will use the pixel data you have to consult your Printer's Manual for the required design. Generally, they are going to use pixels in vertical columns rather than in horizontal rows. In addition, your printer may not allow the same print dot to be on in two consecutive columns. There are additional instructions for descenders as well. (Generally a downshift of the entire character by two dot lines.)

Once having your vertical pixel bytes designed and counted you have to send them to the printer as an ESC code. Be sure you have the correct number of bytes required. You have to also include the number of the character you want to change. Typical is:

```text
          ESC/42/1/#/d/t1/t2/t3/t4/t5/t6/t7/t8/t9
```

ESC/42/1 sets up the printer to receive the new pixel data. The <!-- p. 150 (pdf 160) --> \# is the ASCII code for the symbol you are going to replace with yours. d is the descender on or off (shift down two dot rows or not) byte. t1-t9 are the vertical data bytes. You have to repeat the whole sequence for each character you are going to want to change.[^v11-2]

Finally, you have to enable the now changed set with: ESC/\$/1. You turn it off with: ESC/\$/0, and go back to the default set.

### DIP Switches

Because different Printer Driver Programs operate differently, it may be necessary to reset some of the DIP switches on your printer when you move from one driver program to another. Most printers have 2 sets of these switches, one is usually on the backside of the printer while the second set is inside and not readily available. If your printer isn't behaving correctly, check the setting of these switches. Of particular note is the switch that controls printing whenever a CR (Carriage return) is sent or when the printer's buffer is full. Since most word processors have their own on-board printer driver routines, it's vital for these programs as you can't very readily change the code that easily and must work with the driver given in the program.

### Word Processors

TASWORD II by Tasman Software, 17 Hartley Crescent, Leeds LS6 2LL\
M-SCRIPT by Micro-Systems Inc. Distributed by Zebra Systems, NY

Many 2068 owners use their machines for word processors, a situation that wasn't very feasible with the T/S1000 because of its poor keyboard. A better keyboard on the 2068 would make word processing even easier as punctuation isn't easy with the "as received" keyboard--that symbol shift has got to go. The following paragraphs are not a tutorial on how to use word processors but just compare features on the two most popular.

Once you get used to a word processor you will never use a typewriter again. It is the only way to produce perfect copy every-time--if you proofread carefully enough. At least you have the option of correcting your spelling, composition and grammar before you print the copy.

Tasword uses a 32 column screen but shoves 2 characters into each normal character space to achieve a 64 character line. It has its own 4 bit wide pixel character table to do this. (After all, it is an adaptation from the Spectrum which only has one screen mode.) As a result, the characters on the screen are a bit hard to read. The pixels are wide and not reduced in width as they are in the M-Script screen which is a true 64 character screen using both Display Files. M-Script is easier to read and results in less eye strain. The new modified FAT M-Script, a modification you can do yourself, is even better.

<!-- p. 151 (pdf 161) -->

In addition, M-Script has a command called "window" which allows you to use lines up to 132 characters across as would be needed with a 15 inch wide dot matrix printer. Only 64 characters are displayed on the screen at a time but as you type in more of a line the screen scrolls left giving you the last 64 characters entered on that line at all times. When you reach the end of the line, it jumps back all the way to the start of the next line and gives you the beginnings of previous lines already entered. In addition it has a keyboard buffer which allows you to keep right on typing while it is taking time to switch lines and do all its other work and then processing the keyboard entries. This is very evident if you are doing line scrolls with cap shifted 6 and enter a whole string of them.

Both programs allow for a whole passel of editing functions such as deleting, inserting, moving blocks, duplicating blocks, searching for strings, merging files and the like. One difference is in the way they handle margins. On Tasword, the left margin and the right margin can be indented giving a shorter line length and spacing it on the screen accordingly. When it goes to the printer it will remain centered. In M-Script there is no left margin set for the screen. Using "window" will shorten your lines but they are all left justified and right unjustified. You don't see the actual composition on the screen that you get on the printer. M-Script has the advantage of using printer commands right in the text to allow for italicizing a word in a line or underlining one. Using center on Tasword centers it within the Text of the screen, in M-Script it doesn't but will on the printer. Tasword is limited to 64 characters to the printer line, M-Script can be any width.

Both use a word entry process known as wrap around. If there is not enough room on the end of the line for the whole word, it is deleted from that line and put on the next line...automatically. One doesn't have to use a carriage return as with a typewriter until the end of a paragraph. Tasword just jumps to the end of a line while M-Script places a "\\" at the end of the line and then jumps to the next line. The "\\" is not printed, but it makes a difference in how each program uses its file space. Neither program has a glossary to check word spelling or hyphenation. You have to go back and hyphenate words yourself or put up with long gaps between words on a line. Any guesses as to the longest one syllable word in the English language? Try through.

Both use a file to store the characters that will be sent to the printer but they do it differently. In Tasword, each line consumes 64 bytes of file whether it's a blank line or not. In other words, each line is padded with spaces. This limits Tasword to exactly 300 lines of text including all empty lines. M-Script, on the other hand, starts with a slightly smaller file but doesn't pad lines. A blank line, as used between paragraphs, is just represented by the "\\" and uses one byte of file. Par<!-- p. 152 (pdf 162) -->tial lines just consume what is written on them plus the "\\" character. Thus M-Script can have as many lines as it takes to completely fill its file. Despite a smaller file, M-Script can hold a longer document than Tasword.

Dot matrix printers generally have several type fonts available such as pica, elite and italics at the very minimum. These can be done in normal, condensed and expanded mode, with or without underline, and in either Bold (that is what double strike and emphasized is all about) or normal strength printing. Extra features are superscripts, subscripts and special characters. You can have a real brawl using all of these and they work from your word processor as well.

Tasword uses the graphics character set to put them into a program. Generally the same number in inverse turns off what you turned on. Only one problem with this is that you are limited to 8 on-off sets. Tasword, as is, does not have any means of printing multipage documents so the first thing that has to be done is take two graphic codes and redefine them for page length and page skip--the number of lines to skip after printing the first page before starting to print the 2nd page so you get over the "fold" in the paper and can leave some margin on the bottom and top of each page. Although the 16 graphics can be changed you are limited to no more than 16 codes.

M-Script has a lot more commands given right into the print format including page numbering, page length and page skip, right and/or left justification. Instead of graphics, M-Script has a "define print statement" that can be used to define up to 10 different print codes at once and then call them up by number as you need them. Nothing prevents you from redefining them half way through a document thus giving one an unlimited number of commands available. Underline, **BOLD** and Tab are already included. One can also include REM statements to remind the operator of anything needed or defined. The use of headers (as is used for printing this book) allows one to automatically number pages--and skip numbering as on the first page of each chapter. A different header for even and odd pages keeps the page numbers on the outside margins. Use of a header spacing automatically gives one the empty lines between the header and the text. Footers may also be used. Forcing of new pages is also allowed.

### Word Processor Limitations

Because word processors do so much and have redefined most of the characters on the keyboard to handle other functions, some cannot handle the simple graphics or special characters. They are generally limited to the ASCII set of 96 codes from 32 to 127. If you want to use any of the other characters your printer has (160-255) you have to download them into the ASCII set as already mentioned. Of course, doing this loses you the normal ASCII character that would be printed with that code.

<!-- p. 153 (pdf 163) -->

Please note: In the whole discussion of Printer Driver Programs and Word Processors we have not done a single listing of code. These programs are copyrighted and the property of the writers. Listing their code would be an infringement of that copyright. You may look at it on your own but I can't publish it. Most of it is going to be beyond the ability of the novice machine code student.

## The Keyboard

The keyboard is the most versatile means for your computer to obtain information. It is possible to query the entire keyboard or just a section of it to see if a key has been or is being depressed.

```text
SEC 3   1     2     3     4     5     6     7     8     9     0       SEC 4
         \     \     \     \     \     \     \     \     \     \
SEC 2     Q     W     E     R     T     Y     U     I     O     P     SEC 5
           \     \     \     \     \     \     \     \     \     \
SEC 1       A     S     D     F     G     H     J     K     L   ENTER SEC 6
           /     /     /     /     /     /     /     /     /     |
SEC 0 CAPS    Z     X     C     V     B     N     M     SYM  BREAK  SEC 7
      SHIFT   |     |     |     |     |     |     |   SHIFT  SPACE
        |     |     |     |     +BIT 4+     |     |     |      |
        |     |     |     +-----BIT 3-------+     |     |      |
        |     |     +-----------BIT 2-------------+     |      |
        |     +-----------------BIT 1-------------------+      |
        +-----------------------BIT 0--------------------------+
```

*[Diagram: the 2068 keyboard drawn as four rows of keys. Each half-row of five keys is a "section" (SEC 0-7); lines link each key to its data bit, BIT 0 (outermost keys) through BIT 4 (innermost keys), as redrawn above.]*

The keyboard is sectioned off into 8 sections of a half line each as in the above diagram. It's these sections that can be queried individually. When depressing a key two contacts are closed, one for the half line and a second for the keyboard bit. Both are returned in the format of active bit LOW. Thus no key will return an FFh, a section 0 key FEh, a section 1 key FDh, etc. to Section 7 at 7Fh (127).[^v11-4]

Since the keyboard is accessed through port FEh (254), and the port number is always put on the 8 low address lines, the section byte of the keyboard then is put on the 8 high address lines with the keyboard bits going onto the 5 low data lines. Setting B to 0, and C to 254 and then doing an `IN A, (C)` will get you the section number in B and the Bit number in A.[^c08-7] Thus, the computer has all the information which, together with mode (K, L, C, E, or G) that it needs to calculate the correct code (ASCII token, graphic or UDG) for whatever key is being pressed.

<!-- p. 154 (pdf 164) -->

The Sinclair line of computers (ZX81, TS1000, TS1500 and TS2068) work a bit differently than other micros in that they don't wait for an interrupt from the keyboard but use the automatic 1/60th of a second maskable interrupt to check the keyboard. The 2068 has the additional feature of being able to sense that a key is still being held down and will count for a certain fraction of a second before it starts repeating that key code as another key press. It also waits a different length of time after the first repeat to do a second repeat of the same key.

### Keyboard Routines

#### A Completely Dead Keyboard

Since the keyboard is scanned every 1/60th of a second with a maskable interrupt (INT) routine, disabling this maskable interrupt with the instruction DI kills the keyboard. Doing a RST 56 is equivalent to calling the interrupt routine and will scan the keyboard even with DI being on, AND since there is an EI statement in the end of that routine will enable them from then on. If you don't do a RST 56, make sure you do an EI before coming back to Basic or you are in trouble.

A temporary stop of your program can be achieved with HALT. With the next interrupt (if DI not on, within 1/60th of a second) the program continues. Without INTerrupts enabled you have stopped without a way to restart.

You can also disable the keyboard by setting Bit 6 of Port 255.[^v11-5] This is done by:

```z80
IN A, (255)
SET 6, A
OUT (255),A
```

Reset with `RES 6, A` instead of `SET 6, A`.

#### Caps Lock

Caps lock can be set with setting Bit 3 of FLAGS 2 (23658). It can be done directly if in normal video mode even from Basic. But in any other video mode it must be done with:[^v11-6]

```z80
LD A, (23658)
OR 8
LD (23658), A
```

To unlock, use `AND 247` rather than `OR 8`.

#### Reading The Whole Keyboard

If every 1/60th of a second isn't fast enough for your fast action game, you can force a keyboard read by RST 56. This checks <!-- p. 155 (pdf 165) --> to see if a key is being depressed and if not just returns. If a key is depressed, it goes through the whole keyboard read routine in ROM, sets Keyhit (Bit 5 of FLAGS, 23611)[^c08-8] and puts the code in LAST K (23560). The code will depend upon what MODE the computer is in at the time (K, L, C, E or G). Mode can be set by altering Bits 0 and 1 of MODE (23617).[^v11-7] If you are just interested in the CAPS mode value of keys (no tokens, UDG or lower case), this code can be found at 23556.[^v11-8] This method is not the fastest available. It also has the problem of giving you the last key pressed without bothering to reset. To do it properly, one should RESET KEYHIT and then call RST 56, then check for a hit and recycle until you get one if you like.

Of course one can call the keyboard routines directly with `CALL 737`. The keyboard routines are quite complex and consist of the following routines.

```text
688   Keyboard scan
737   Update keyboard
822   Repeat key
860   K Base
881   Character Code
```

The 2068 Technical Manual gives a full flow diagram of these routines. It is beyond the scope of this book to discuss them here.

Calling 737, Update keyboard, will call all the other routines needed and our answer will be in LAST K. We, however, have to have a way of determining if a new key has been pressed by resetting the flag KEYHIT. If a key is being pressed, Keyhit will be set and the ASCII code or Token code will be in Last K. Be sure to Push any registers you have to save before making the keyboard call as the routine uses all the registers.[^v11-9] If you Push registers make sure you Pop them after the call.

```z80
      RES 5, (IY + 1) Flags-Keyhit
Again CALL 737
      BIT 5, (IY + 1)
      JR Z, Again   Loop waits for hit
      LD A, (23560)  Last K
```

[^c08-9]

#### Testing Last K

You may be interested in a whole keyboard or just a few keys. The easiest way to test for just a few keys is to test for a direct match. From the above, Last K is already in A so:

```z80
CP #
JR Z, that # routine
CP #2
JR Z, #2 routine
etc.
```

<!-- p. 156 (pdf 166) -->

Of course, calling the Basic routines to decode the keyboard is no faster than Basic. But just remember that the keyboard is checked every 1/60th second to see if a key is being pressed and then does the routine to read it. That would be equivalent to just checking it once in the first program above without cycling to wait for a press of a key.

### Fast Action--Just Activating Part Of The Keyboard

If you are just interested in a few keys from the keyboard, you can do a direct decode using the scheme we talked about earlier--sections and bits. This is what one would use for a keyboard acting as a joystick. The keyboard is read through Port 254. We must remember that our input will be in ACTIVE HIGH format.[^v11-10]

```z80
LD BC,  C=254, B = Section #          0   254(FE)
IN A, (C)                             1   253(FD)
CPL     Convert to active high        2   251(FB)
BIT X, A    X = Bit #                 3   247(F7)
JR NZ, Bit X routine                  4   239(EF)
BIT Y, A    Y = Bit #2                5   223(DF)
JR NZ, Bit Y routine                  6   191(BF)
                                      7   127(7F)
```

[^c08-10]

You can examine several sections of the keyboard in the same call merely by putting two bits low in B (Notice how the section numbers given above are really that Bit # low). But be warned, the answer in A also comes back mixed and you have to have some way of decoding them. For example, turning on section 2 and 5 by putting 219 into B, will let you read QWERT and YUIOP only. But Q and P are both going to reset Bit 0, W and O are both going to reset Bit 1 etc. Doing the CPL turns the Bits from 0's into 1's (it isn't necessary but makes it easier thinking about it). If you have to somehow differentiate between "W" and "O" this method won't do it.

This method of scanning the keyboard doesn't wait until the key is debounced so generally you can repeat it for each of the keys that you wish to check. An obvious application is to make four keys into a keyboard type joystick. The big trouble with most fast action games is that they don't ask for keyboard inputs often enough to move that gun to the right spot or shoot bullets often or fast enough. Remember the screen is wider than it is high.

### Break?

Sometimes one just wants to see if the BREAK key (Break and Caps shift) has been pressed. Just make sure the carry flag is set and then `CALL 8201` (2009H). The carry flag will be cleared if Break was pressed.[^v11-11]

### Input

<!-- p. 157 (pdf 167) -->

Reading in a sequence of keys in a routine (like a name) one after the other can be done by storing the LAST K's in a space and going back to get the next until a certain key like ENTER is pressed. However, your computer is so fast compared to your fingers that you must put in a wait loop so you have time to get your fingers off the keys or you get a whole string of the same letter.

### Redefining The Keyboard

We can only redefine part of the keyboard from Basic--the UDG's. These require the graphics mode and are limited to 21 in number. Hardly enough for a total redefine of the entire keyboard. What some people would like to do is convert their entire keyboard from "QWERTY" to another like say "DVORAK". A diagram of the Dvorak keyboard is given below.

```text
+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
|  7  |  5  |  3  |  1  |  9  |  0  |  2  |  4  |  6  |  8  |
+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+--+
   |  Z  |  V  |  S  |  P  |  Y  |  F  |  G  |  C  |  R  |  L  |
   +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+--------+
     |  A  |  O  |  E  |  U  |  I  |  D  |  H  |  T  |  N  | ENTER    |
+----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
| CAPS |  W  |  Q  |  J  |  K  |  X  |  B  |  M  |  SYM  |BREAK| CAPS  |
| SHIFT|     |     |     |     |     |     |     | SHIFT |     | SHIFT |
+------+-----+-----+-----+-----+-----+-----+-----+-------+-----+-------+
```

*[Diagram: the Dvorak layout as mapped onto the 2068 keyboard, drawn as four rows of boxed keys; redrawn above.]*

We had to make some compromises with this layout because the 2068 keyboard doesn't have enough keys. S is supposed to be where the ENTER key is, W where the symbol shift key is with Z at the right CAPS SHIFT. We only have 26 letter keys so all the punctuation is still in the symbol shift mode. W is put where the ":" should be, S where the "." should be, V where the "," should be and Z where the "?" should be.

The way the 2068 assigns codes to keys is through what are called "lookup tables". There is a different table for each mode K, L, C, E and E-Symbol shifted. Each key has a number offset that is added to the table base to give the desired address in the table. That address contains the code sent to Last K. These tables are in ROM and can't be changed.[^v11-12]

However, certain programs have their own lookup tables. One such is M-Script. Since these tables are in RAM we can change them. For M-Script the two tables for CAPS and lower case letters are at 42647 and 42583 respectively.[^v11-13] Load M-Script as usual and when <!-- p. 158 (pdf 168) --> the screen comes up asking for color changes, etc. just do a BREAK and enter and run the following program. Use `GOTO 600` to get it into the code area.

```basic
600 RESTORE 600
605 FOR X = 42583 TO 42622
610 READ Y: POKE X, Y: NEXT X
615 FOR X = 42647 TO 42685
620 READ Y: POKE X, Y: NEXT X
625 DATA 119,113,106,107,97,111,101,117,105,122,118,
  115,112,55,53,51,49,57,56,54,52,50,48,108,114,99,1
  03,102,13,110,116,104,100,32,0,109,98,120
630 DATA 87,81,74,75,65,79,69,85,73,90,86,83,80,89,1
  29,130,131,132,133,8,137,136,135,76,82,86,71,70,13
  ,78,84,72,68,128,0,77,78,88
635 STOP
```

[^c08-11]

Once having run the program, `GOTO 9000` and save on a new tape. As long as you stay in Basic, your keyboard is normal. Once you are in the program it's changed, and that includes all letter commands for M-Script. If this is your first time with "Dvorak" I suggest you tape a copy of the keyboard to the upper portion of the computer. The only key that stays the same is A. Have fun.

## Graphic Pixel Generation

We told you earlier that the graphic symbols were not included in the pixel character table but that they were done dynamically from the graphic symbol codes themselves. If you have ever bothered to look at these graphic symbols they are composed of four quadrants. Let's label them as:

```text
+----+----+
| #2 | #1 |
+----+----+
| #8 | #4 |
+----+----+
```

Let's look at the graphic numbers by subtracting 128 from each and seeing what is left. For this, use Appendix B page 242 of the User's Manual.

```text
128 = 0   Space, all empty
129 = 1   #1 space on
130 = 2   #2 space on
131 = 3   #1 and #2 spaces on
132 = 4   #4 space on
133 = 5   #4 and #1 spaces on
134 = 6   #4 and #2 spaces on
135 = 7   #4, #2 and #1 spaces on
136 = 8   #8 space on
137 = 9   #8 and #1 spaces on
138 = 10  #8 and #2 spaces on
139 = 11  #8, #2 and #1 spaces on, etc.
```

<!-- p. 159 (pdf 169) -->

The routine goes as follows.[^v11-14] Assume CHAR CODE in A to start.

```z80
        LD B, A
        LD D, 2   Count
Next 4  RR B      Rotate 1st bit to carry
        SBC A, A  If Bit = 1, A = 255, else A = 0
        AND 15    Save low nybble
        LD C, A   Save in C
        RR B      Next bit to carry
        SBC A, A  As above 255 or 0
        AND 240   Save high nybble
        OR C      Add in low mybble
        LD C, 4   count
Again   LD (HL), A  To Display file
        INC H
        DEC C
        JR NZ, Again  4 times
        DEC D
        JR NZ, Next 4  do lower quadrants.
        RET
```

This takes 26 bytes.[^c09-1] 16 graphic characters times 8 bytes each would take 128 bytes.

## Microdrives

The microdrive, originally developed in England for the Spectrum and since adopted for the 2068, is nothing but a fast, miniaturized, expensive tape recorder. It uses microtapes of a continuous nature which have an inherent failure problem.

The problem with any continuous tape is, and always has been, that there is too much tension at the "crossover point"--a necessary evil of the system. The excessive tension pulls on the tape and in a short time stretches the outside edges causing them to ripple thus aggravating the problem. The fast speed required for the high baud rate only adds to the problem. In addition, the tape has to rub over itself causing abrasion of the metallic oxide surface and the plastic tape. For the uninitiated, a grinding belt consists of a metallic oxide glued to a cloth belt. Fine iron and chrome oxides on a belt are called polishing belts. They still abrade away material but more slowly.

How bad is this problem? In case you haven't heard, many programs that have been "protected" to prevent copies from being made have been returned to the manufacturer because of malfunction in as little as several months time. So many, in fact, that some manufacturers have refused to support the Spectrum and the QL with any more new products. I don't know what it is, but the British have an aversion to disk drives that borders on being <!-- p. 160 (pdf 170) --> paranoiac, doing everything and anything to avoid them. The Ferranti chip on the microdrive also has a tendency to malfunction permanently.

Having discussed the major drawback of the microdrive, let's look at the advantages. We get a fast baud rate. The fast baud rate is achieved by doing away with recording sounds for bits as was discussed earlier and just recording pips as is done on disk drives. This achieves closer packing of bits and bytes. A speeded up tape also helps. Loading times for a 32k program including a search for the program are down in the seconds range rather than minutes as with a normal tape recorder. The QL and the 2068 microdrive cannot be interchanged.

Economics: You pay $150 for the microdrive interface and a drive. Each tape costs $4.50 vs. $1.50 for a normal tape. An AERCO disk drive and interface is going to cost you $300 but will use disks at $1.00 each. Each disk will handle 32 programs or 395k vs. 85k for each microdrive tape. In addition you will have an additional 64k of memory and an RBG interface ready to accept the cable to your RBG monitor when you get one. Jerry at AERCO is busy with the CP/M DOS system which will allow you to run all those programs on your 2068 as well. Your $300 for the disk drive isn't all just for the interface and the drive. For $50 extra you can get 256k extra memory right on your interface.

## Modems

Communications with another computer over the phone lines may be the wave of the future but not yet--unless AT&T kills it. In addition to the cost of long distance phone lines, AT&T has threatened to hit Modem Users with a special service fee.

What one really does with a modem is use it much like a dot matrix printer--a printer to another computer. With the printer you sent it print commands to tell it how you wanted something printed and then send it what you wanted printed. A Printer Driver Firmware Program did it for you. Modems work the same way with an interface and a Modem Driver Program in the computer telling it first how to send it and then what to send over a phone line.

Because phone lines are voice channels, it is necessary for the computer to use tones when talking to each other. Because of this, the transmission rate is, of necessity, low--only 300 baud (bits/sec). You are back to the good old TS1000 LOAD/SAVE rates. A 16k program takes over 7 minutes to transmit. Some modems have various baud rates that can be selected. Other things that must be the same for both computers are the word (really byte) size (5, 6, 7 or 8 bits), parity (even, odd or none), and the number of stop bits used (1 or 2).

<!-- p. 161 (pdf 171) -->

We have to explain a few terms here.

**PARITY:** When transmitting data an extra bit is used to make the parity even or odd. The computer counts the number of 1's in a byte and then sets the parity bit to make it even or odd depending upon what is required. In this way the receiving computer can tell if a byte got garbled in transmission. This used to be the standard of transmission between a computer and a printer or other peripheral in olden days when tube noise was a problem.

**WORD SIZE:** Because baud rates are so low, one wants to use the lowest possible byte length. This, however, depends upon what you are sending. If it's a message all in ASCII code, 7 bits are enough. If it's code or a 2068 program, all 8 bits are necessary. If it's digitized data numbers, only 4 or 5 bytes are needed.

**STOP BITS:** A blank bit or two at the end of each byte is needed to keep my computer in "sync" with yours which may be operating at a slightly different frequency than mine. This empty space allows both computers to wait until the start of the next byte.

What this all amounts to is that a normal 8 bit byte grows to 9 with the addition of the parity bit and then to 10 with the extra Stop bit. Our transmission rate is now down to 30 bytes per second. If word length is only 4 bits it can be as high as 50 bytes/sec, or 66% faster.

### Connecting Up

You just can't plug your modem interface into the back of your computer, connect it to the modem, connect the modem to the phone line, dial a number and expect things to work. You have to know ahead of time what settings to use for a particular service. If you don't know, you have to make a manual phone call and find out. You may wish to talk to the host operator anyway.

Modems attach to phone lines in two ways, direct wiring and acoustically (that the one with the cradle for the receiver). You have to hang up the phone on the wirein type as it's the same type of screech as the tape recorders. Also stray noises are picked up by the mouthpiece and may garble your data.

**DUPLEXING.** Once hooked together there are various routines that can be used to communicate, person to person, with the operator at the other end of the phone line through the keyboard. Computers use what is called duplexing. This, in reality, sends back to the sending computer the byte that was just received for a match. In HALF duplexing, only what the other computer sends back to you is displayed on your screen. In FULL duplex, both what you typed and what the other computer sent back are displayed one symbol after the other.

**USE OF A BUFFER.** Typing in messages is slower than using pretyp-

<!-- p. 162 (pdf 172) -->

ed messages and programs. Like word processors, most of the computer's memory is not used so can store what is sent for processing at a later time. The buffer is generally made as big as possible to handle as long a program as desired (within limits). Later processing may mean sending it to a printer or making a tape out of it. It is called "downloading".

That's okay when receiving material. When you are sending, you must first "upload" what you want to send from a tape into your buffer, then tell your computer to send it. Note that I haven't said to disk when saving a buffer. The reason is that many modem driver programs were written before disk drives and haven't been converted as yet. Adding disk drive saving of programs will require a "patch" to the modem driver program. Generally this is at the expense of some buffer space. Writing such a patch is beyond the ability of a beginning machine code programmer.

A 2068 computer talking to another 2068 computer and exchanging programs is fine. A 2068 talking to an IBM or Apple or any other computer is not so fine unless the program being transmitted to you is either a Spectrum or a 2068 program or code for that program. Converting even a Basic program from another computer to your 2068 is not an easy task. Be advised that although you have to type out all commands for those computers they have strange abbreviations and may "tokenize" them in storage. Each line would have to be edited to get it into 2068 format. Getting a printout and then reentering is the easiest.

### Bulletin Boards

Some modems allow autodialing and autoanswering. Unfortunately, with autoanswering the computer doesn't know if it's another computer calling or a human who wants to talk to you, not your computer. Using the computer to answer with a blast of its carrier tone can cause one to lose many friends quite rapidly. However, since the computer doesn't answer until the 3rd ring picking up the phone before that will avoid this. What you do when you are not there ready to answer the phone is a problem the firmware writers don't tackle. Auto dialing is only possible with touch tone phones and requires a storage area with the number and other pertinent data for making a connection. MTERM provides for up to 10 such phone numbers.

Some modems have selectable baud rates...300 bits/sec is too slow for mainframes to talk to each other. Rates as high as 9000 baud can be used. To use these higher rates one uses what is called multiplexing the signal onto a carrier signal. This uses special phone lines requiring special installation which must be rented from the phone company. This is obviously not for the average person.

## Disk Drives

<!-- p. 163 (pdf 173) -->

There are disk drives and there are disk drives. Most of the time a disk recorded with one system will not read on another. There are many variations that disk recording has gone through during the years and I'm sure more are still to come. What used to take a 12 inch disk to record can now be recorded on a 3.5 inch disk. Since home or personal computer arrived on the scene relatively recently, most of them are coupled with at most 8 inch disks drives with 5.25 and 3.5 inch drives being more common. Which disk drive you chose will depend upon what most of the programs you want to use are written on.

Because Timex never got around to providing a disk drive for the 2068, 3rd party vendors stepped in and filled the gap. At this writing, there are 3 different vendors. In alphabetical order they are: AERCO, RAMEX and ZEBRA. Belatedly, the Portuguese "Silver Avenger" is arriving on the scene with its 2068/Spectrum ROMs and a Spectrum back bus and supposedly a 3 inch disk. Yep, not 3.5 but 3 inch--again nonstandard. Since the interface for this drive will be attaching to a Spectrum back bus, it's not going to fit the 2068.

### Use of Single Sided Disks

Although the 8 inch floppy preceded it, the 5.25 inch floppy is what most 2068 users will purchase so we will concentrate on that disk. In reality it is a thin piece of plastic coated on both sides with an iron oxide-chromium oxide magnetizable material and then packaged in a permanent paper dust jacket. Because of the close packing of the data and the fragile nature of the very thin magnetic coating, never touch the disk with your fingers through the windows on both sides of the disk. Inspection of the disk through these windows will show you that over half of the disk surface is empty and only a band 0.833 inches wide is actually used. In manufacture all disks are made single or dual density double sided. In inspecting disks a few from a lot are tested and if flaws are detected the whole lot is labeled as single sided. The 2nd side may be perfectly good, but only one side is guaranteed good.

The 2nd side may be used at your risk. A mere formatting of the disk will not indicate that it is good or bad. You only find out when you MOVE a program into a track and then reload it into the computer which is a bit too late. There is no verify for disks. One should always make two copies of a disk. Since the side guaranteed is the side with the label and since the catalogue track limits how many programs may be stored on a disk (32 with AERCO), you may only be using side 1. Two copies should be sufficient. Once you get to side 2 (less than 200k remaining), you are playing Russian roulette with a 2 chambered gun. If you don't like 50-50 odds, make more copies, 3 to 4. At least one of them should hit tracks that are perfectly good.

### Care of Floppies

<!-- p. 164 (pdf 174) -->

Never write on a label already on a disk with a ball point pen. Use only the slightest pressure with a felt tipped pen, or better still, write out another label and paste it over the old one. As long as we are on the subject of disk care, never turn off power to the disk drive with a disk still in the system. Never turn on the power to the disk drives with the cardboard inserts still in place--it has a tendency to ruin heads. Never store disks near or on top of a TV or monitor as the degaussing of the picture tube that takes place when you turn them off creates a strong magnetic field capable of messing up disks. Large speakers can do the same. Never put disks on top of the drive itself as motors starting and stopping spell disaster. Always store your spare set some place different than your working set. Always use the jackets for the disks...there is nothing that messes them up faster than spilled coffee or soda. AND don't smoke when operating the drives.

### Disc Density

Depending upon the drive there are 35, 40 or 80 tracks per side of a disk. Unlike a phonograph record where a track is really a continuous spiral, these tracks are perfect circles with the end of a track running right back into the beginning of the same track. With this sort of system one needs to use some sort of track marker to mark the beginning/end of the track. Tracks are also divided into sectors, 10 sectors/track being common. We all know that you cannot use a new disk directly but first must do what is called "formatting" a disk. Formatting puts a magnetic marker at the start/end of each track. To do this, the drive uses the hard sector hole to mark the start of each track around the disk. This hole is also used to strobe the disk to see if the drive is rotating and if a disk is present. The signal indicates the start of sector 1 and the end of sector 10. Nine more sector start/end signals are written on each track and the disk stepped through all tracks. In single density format each sector will have 256 bytes (2048 bits). In dual density, each sector will contain 512 bytes (4096 bits). Quad density is achieved not with another doubling of the density of the bits in a sector but by doubling the number of tracks on a disk--usually 80 per side.

### The 5.25 Inch Floppy

Tracks are packed radially at 48/inch (single or dual density) or 96/inch for quad density. In either case we end up with a band 0.833 inches wide. With a 1 1/8 inch hole and evenly spacing the empty part of the disk on each side of the bands gives us an inside diameter of 2.3 inches (circumference 7.22 inches) and an outside track diameter of 4.0 (12.57 circumference). At 48 tracks per inch radially, each track has to be something less than 0.021 inches wide (the track separation distance) as there must be some space between tracks to prevent cross talk from one track to another. In quad density, the tracks have to be half <!-- p. 165 (pdf 175) --> that wide.

Using the outside track (12.57 inches around) with a dual density track of 10 sectors of 512 bytes gives us 512x10x8 bits per track. Not counting space used by the sector end markers this works out to a 0.00031 inches per bit or, to put it another way, 3258 bits/inch. For comparison, a cassette tape recorder at 3 inches/sec and a baud rate of 1200 gives a bit width of 0.0025 or 400 bits/inch--an order of magnitude wider. Using the smaller inside track makes things even tighter.

At 5120 bytes per track and 40 tracks per side, that's 204,800 bytes per side at dual density.[^c09-2] This is unformatted capacity. Depending upon the format, 18 to 33 percent of the capacity of the disk are chewed up with overhead housekeeping data--one of which is a full track devoted to the directory. Additionally each track has to have a few bytes devoted to track number and what sector to go to next. With most systems handling double sided disks and up to 4 drives, double density-double sided systems of 4 drives could have a whopping 1.64 megabytes of storage. Quad density systems a whopping 3.28 megabytes.

With that much space available, disk drives are somewhat wasteful of space. Some drives insist upon using a minimum of 1 track per program. Since a track has an effective storage of 5120 bytes, a tiny program of Basic, calling a wee program of machine code (separate save = another track) and a screen (another save of 2 tracks as over 5120 bytes) can chew up 4 tracks and be almost empty.

A big advantage of the disk drive is that it can read a track as many times as it needs to. In a tape recorder it goes by only once. Asking a disk to load a program into the computer first has the disk consult the directory for a name match which then gives it a track number. The head placement worm gear grinds out the correct number of turns to the track position while the computer waits a second for this to take place. The head is put into the read mode and starts looking for the track start signal. If it can't find it, it will stop and increment the head half a step up and then half a step down in an attempt to find the track. If not found, the appropriate error-DISK NOT READABLE will appear on the screen. If the signal is found, it waits another revolution of the disk before reading the other operating data. Again another rotation before it starts sending the actual program bytes--including a parity byte at the end of the track. NOTE: Some disk drives will get this done in 2 rotations rather than 3. The computer is also calculating parity of the incoming bytes and compares its calculated value with the last byte--if they don't agree another load is tried immediately.

### DOS--Disk Operating System

Disk drives just don't plug into the back of your 2068 computer through an interface and run. First of all, the ROM doesn't sup<!-- p. 166 (pdf 176) -->port the commands CAT, FORMAT, ERASE and MOVE--where have you read that term before? These commands have to be handled by the DOS--Disk Operating System. Also more instructions have to be written for turning on drive motors, finding the right track or an empty track if MOVE (the disk equivalent of SAVE) is used, and a dozen other things that a disk controller needs to function. If you are fortunate enough to have an AERCO system with CP/M not only are you using 5.25 inch disks but also 8 inch which needs a different set of operatives to work. In fact the Aerco system will read single, double and quad density disks in 3 different formats. This takes a full 8k operating system. Other systems get by with 4k but may be limited to reading and writing disk that are of only their same format.

This system has to be loaded somewhere and may take the top 4-8k of your memory--unless you have an Aerco system in which case it's in Chunk 1 of Bank 0. If you don't remember where that is, it's called the DOCK bank. Being there, it doesn't use any RAM. That extra 64k gets put to use as soon as you turn on your computer and have your disk drive interface attached. Although on the back of the computer and not under the front cover, it is wired to act like it's under the front cover. Thus, as soon as you turn your computer on, it senses a cartridge present and calls the EPROM on the interface to make all the corrections to the Bank Switching routines which at this time have already been moved to Chunk 3 of RAM and then sets itself up in Chunk 1 of the DOCK Bank. It then checks to see if the disk you are using has a BOOT program on it and automatically loads and runs that. The Boot program is short and its only function is to load another program.

Okay, you want to use your dot matrix printer as well so you have piggybacked your printer interface to the back of your disk interface. Having a Boot program ask you if you need a Printer Driver Program and if the answer is "Y" automatically loading the version of it you need is really nice. You also are assured of not putting it someplace where it might overwrite some of the DOS program. The Aerco system uses bytes 23856-23863 in the unused reserved System Variables Table.

There is one disadvantage to this setup in that when running a program Chunk 1 of Home ROM must be used thus disabling Chunk 1 of the Dock Bank. When you want the DOS again you may have to first enable the DOCK Bank with `OUT 244, 1`--you will find out what that means in the next chapter.[^v11-15] That is a small price to pay for a full use of Home RAM and Disk drives.

What all happens when you MOVE (save) a program? If you want a blow by blow description, Aerco has copies of its entire DOS disassembly available for $20. The MOVE command is similar to the SAVE command except your name MUST be followed by a 3 symbol extension.[^v11-16] The word must is emphasized as it MUST be used. No LINE token, just a comma and the line number. The MOVE command automatically gets the Drives going. The first thing it checks <!-- p. 167 (pdf 177) --> is to see if you have specified a drive in your name--it has to be a, b, c, or d followed by a ":". If not, it uses the last drive you told it to use. The 2nd thing it checks is to see if a disk is turning. The 3rd thing it checks is to see if the disk is write protected and if it is, asks if it can overwrite. The 4th thing it checks is to see if the name and extension you gave it match what is already on the disk--after all, you may be reloading a program. If this is the case it will check the program length and see if it has enough room in the same number of tracks or it is the last loaded program. In either of these cases it will overwrite the old program. If a new program, it will next check to see if there are enough empty tracks to hold the program. If enough memory remains, it puts the name padded with blanks if necessary into the directory together with track number, moves the head to that track and writes in the program. All this in the course of a few seconds. This description is of necessity brief and only gives some of the highlights of what all is going on-the whole disassembly goes on for some 50 odd pages and makes for some great bedtime reading. You say you don't read code at bedtime? Well, that's your problem.

In the case of ERASE, the program is erased out of the directory and as such, the tracks becomes available for the next program MOVEd onto the disk that can fit the size.

Because we have to use extensions, the same name with a different extension is considered a different program. With 4 different extensions, .bas, .bin, .scr, and .dat, everything can go under the same name.

DOS code is very involved and not a project for the novice machine code programmer.

<!-- p. 168 (pdf 178) -->

[^c08-6]: Corrected. The original printed "#13 better known as linefeed"; code 13 is carriage return (linefeed is code 10).

[^v11-1]: (unverified) The AERCO and TASMAN interfaces are third-party hardware; their port numbers are not in the ROM or the TS2068 Reference Library, so check the interface documentation before using port 127.

[^v11-3]: Library note: checked against the ROM character set at $3D00, 24 of the 26 capitals have the blank border; T (00 FE 10 ...) and Y (00 82 44 ...) use the leftmost pixel column. The lower-case letters using byte 8 are exactly g, j, p, q and y.

[^v11-2]: (unverified) These escape sequences are printer-specific and not covered by the ROM or the library; check your printer manual for the exact download and select codes.

[^v11-4]: Library note: only the five key bits (bits 4-0, 0 = pressed) come back from the read; FEh, FDh ... 7Fh are the half-row selector values the program puts on the high address lines (in B), one bit low per section, not values that are returned; see docs/ts2068_memory_map.md (Keyboard Half-Row Addressing).

[^c08-7]: Corrected. The original printed `IN (C), A`; the Z80 mnemonic is `IN A, (C)`. Library note: with B = 0 all eight half-rows are selected at once, so A returns the AND of all of them (bit n is 0 if any key in column n is down) and B is left unchanged; this tells you whether a key is pressed but not in which section, and the ROM finds the key by reading each half-row in turn with B = FEh, FDh ... 7Fh (`RLC B` in K_SCAN at $02B0); see disassemblies/ts2068_home_rom_U16_stock.txt.

[^v11-5]: Library note: bit 6 of port 255 (DECR) inhibits the 60 Hz maskable interrupt (0 enables it), so the keyboard stops being scanned, but the FRAMES clock and anything else driven by the interrupt stop too; reading port 255 back first, as below, is what the ROM itself does (HOME ROM $0E0F, DB FF); see docs/ts2068_memory_map.md (DECR).

[^v11-6]: (unverified) Nothing in the ROM ties access to FLAGS2 (23658) to the video mode, so the library cannot confirm that the direct POKE from BASIC fails in the other modes.

[^c08-8]: Corrected. The original printed "Bit 3 of FLAGS"; the listing that follows tests and resets bit 5 of (IY + 1), which is FLAGS at 23611.

[^v11-7]: Library note: MODE (23617) holds only 0, 1 (E mode) or 2 (G mode); with MODE = 0, K or L is chosen by bit 3 of FLAGS (23611) and C by bit 3 of FLAGS2 (23658, CAPS lock), so MODE alone cannot select K, L or C; see docs/ts2068_system_variables.md and CHCODE (ROM $0371) in disassemblies/ts2068_home_rom_U16_stock.txt.

[^v11-8]: Library note: 23556 ($5C04, KS_A2) is one of two key-state blocks; the ROM may record the key in the other block at 23552 ($5C00, KS_A1) instead, and 255 means no key; see docs/ts2068_system_variables.md (UPD_K at ROM $02E1).

[^v11-9]: Library note: the update routine changes only AF, BC, DE and HL (the interrupt handler at $0038 saves exactly those four around its CALL $02E1); IX, IY and the alternate registers are untouched, and IY must hold 23610; see docs/ts2068_rom_entry_points.md.

[^c08-9]: Corrected. The original printed `JR NZ, Again` and the comment "Lask K"; `BIT 5, (IY + 1)` gives Z while no key has been hit, so waiting for a hit needs `JR Z, Again`, and 23560 is LAST K.

[^v11-10]: Library note: the raw read from port 254 is active LOW (0 = pressed); it is the CPL in the listing that makes it active high; see docs/ts2068_memory_map.md.

[^c08-10]: Corrected. The original printed `191(7F)`, `IN (C), A` and `JR Z` on both bit tests; 191 is BFh (7Fh is section 7's 127), the Z80 mnemonic is `IN A, (C)`, and after `CPL` a pressed key's bit is 1, so `BIT` gives NZ on a press and the jumps must be `JR NZ`.

[^v11-11]: Library note: the routine at 8201 ($2009) sets the flags itself, so the carry need not be set first; it returns carry clear when CAPS SHIFT and SPACE are both down, except that while an ON ERR trap is being handled (bit 6 of 23735, the high byte of ERRLN, set) it returns carry set after testing only SPACE; see docs/ts2068_system_variables.md (ERRLN) and disassemblies/ts2068_home_rom_U16_stock.txt.

[^v11-12]: Library note: the ROM does not keep one table per mode: it has a main table (LCKEYS), E-mode unshifted and shifted tables (EKEYS, SEKEYS), a symbol-shift table (KKEYS) and two for the digit keys (NUMFNTBL, SSKEYS); K-mode keywords and L/C-mode letters are computed from the main code (adding $A5 for a keyword, $20 for lower case) rather than looked up; see docs/ts2068_memory_map.md ($0227-$02AF) and CHCODE (ROM $0371).

[^v11-13]: (unverified) M-Script is third-party software; these table addresses depend on its version and cannot be checked against the ROM or the library.

[^c08-11]: Not corrected. Lines 605 and 615 READ 79 values (40 + 39) but the DATA lines hold only 76 (38 + 38), so the program stops with "Out of DATA"; line 625 appears to lack a lower-case "y" (121) after "p", but line 630 also has doubtful entries (86 where "C" belongs, 78 where "B" belongs) and its digit-row values cannot be checked, so the missing and wrong values cannot be settled from the page.

[^v11-14]: Library note: this is an adaptation that writes straight to the display file (`INC H`); the ROM's own routine at $066D (MKBLKGR) builds the 8-byte pattern in MEMBOT (23698) with `INC HL`, running a four-line half-routine ($0673) twice, and the normal character printer then copies it to the screen; see disassemblies/ts2068_home_rom_U16_stock.txt.

[^c09-1]: Corrected. The original printed "28 bytes"; assembling the listing gives 1+2+2+1+2+1+2+1+2+1+2+1+1+1+2+1+2+1 = 26 bytes.

[^c09-2]: Corrected. The original printed "5125 bytes per track" and "205,800 bytes per side"; 10 sectors × 512 bytes = 5120 (the figure used in the next paragraph), × 40 tracks = 204,800, which is what the later 1.64 and 3.28 megabyte totals assume.

[^v11-15]: Library note: the chunk and the OUT value disagree: bit n of port 244 (HSR) maps chunk n, so `OUT 244, 1` maps DOCK chunk 0 ($0000-$1FFF), while DOCK chunk 1 ($2000-$3FFF) needs `OUT 244, 2` (with bit 7 of port 255 = 0); where the AERCO DOS actually sits is not in the library; see docs/ts2068_memory_map.md (HSR).

[^v11-16]: (unverified) The AERCO DOS (MOVE syntax, drive letters, the 32-program catalogue, its use of 23856-23863) is third-party firmware and is not covered by the ROM or the library.
