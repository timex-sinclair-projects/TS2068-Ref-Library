<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 35–46. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 3: Screen Printing.*
*[← previous](03-chapter-02-memory-mapping.md) · [book README](README.md) · [next →](05-chapter-04-system-variables.md)*

---

<!-- p. 35 (pdf 43) -->

# Chapter 3: Screen Printing

## The Display File Map--Screen Map

From Basic UDG and Chapter 2 we found out that our Display File was pixel mapped, i.e., the bytes containing the print pixels were stored there, not the character codes. However, we did not discuss in what sequence these pixel bytes were stored. That sequence and the use of various print statements and commands associated with screen printing is the subject of this chapter.

We will assume a normal screen of 32 columns by 24 lines. We also know from Chapter 2 that the Display File starts as Chunk 2, address 16384. We have to have some sequence to these bytes so how about starting with Pixel 1 of Character 1 at 16384 followed by Pixel 1 of Character 2 in the next address and so forth for 32 spaces to finish the top row of pixels for the screen. (Note that in all of this we are calling Line 0-Column 0, Line 1-Column 1.) Logic would tell us at this point to continue with Pixel 2 of Character 1 and do all the "2" Pixels for the top row.

Not so. The 33 byte, address 16416, holds Pixel 1 of Character 1 of Line 2 followed in the next address by Pixel 1 of Character 2 of Line 2.[^c02-3] Okay, we're flexible. We do all the #1 pixels for all the screen positions before moving on to #2 pixels. Right!

Wrong! We do it for the top 8 lines only and then do all the #2 pixels for the top 8 lines as we did the #1 pixels. This is followed by the #3 pixels for the top 8 lines, the #4 pixels for the top 8 lines, etc. When we finally get done with the top 8 lines we do the same with the center 8 lines and finally, once more with the bottom 8 lines. Remember the screen has 24 lines, not the 22 we are used to thinking of. Part of our Display File will look something like this, address by address per character.[^c02-4]

```text
        1     2     3     4     5                 32
L 1 16384 16385 16386 16387 16388 --- --- --- 16415
I 2 16640 16641 16642 16643 16644 --- --- --- 16671
N 3 16896 16897 16898 16899 16900 --- --- --- 16927
E 4 17152 17153 17154 17155 17156 --- --- --- 17183
  5 17408 17409 17410 17411 17412 --- --- --- 17439
1 6 17664 17665 17666 17667 17668 --- --- --- 17695
  7 17920 17921 17922 17923 17924 --- --- --- 17951
  8 18176 18177 18178 18179 18180 --- --- --- 18207
L 1 16416 16417 16418
I 2 16672 16673 16674
```

<!-- p. 36 (pdf 44) -->

Please note that the "seam" between the top 8 and the 2nd 8 print lines occurs at 18431-2. 18432 starts the 2nd 8.

Why such a strange way of doing things? What is the logic? Is there some advantage to doing it this way? Let's see. At 32 characters per line by 8 lines we get a string of 256 #1 pixels before we start the #2 pixels. With this clue, the advanced student already knows the answer. The beginning student has to think back to Chapter 1 when we discussed holding an address in 2 byte long words. The dividing line was 256. Therefore, if we were holding our print address in the H and L registers (How nice to have registers with H = high and L = low.) of the CPU all we have to do to add 256 to our address is INCrement H. Even the beginning student can see that putting the write to HL and INC H inside a loop and doing it 8 times will get the whole character printed to the Display File.

That's nice and fast for the first character but how do we get to address of pixel #1 of character #2? We are way off base in left field from where we have to be. I suppose we could subtract off exactly 1791 to get the starting address for the next character. We are in great trouble if that character happens to be AT 8,0 which is one of the seams in the screen.

The computer doesn't know if it's going to print 1, 2 or a string of characters, so instead of storing the address of the next character, it really stores an AT value and recalculates the starting Display File address from that for each character.[^v05-1] Of course, it increments AT after it has calculated a needed address. Then, if you don't use a ";" at the end of a print statement, all it has to do to start a new line is increment the line number and set the column number back to zero to be ready for the next print statement.

Calculating the correct Display File address from AT must take into account the 8 line seams in the File. The top 8 lines are easy as all you have to do is multiply the line number by 32 and add the column number and 16384 to it. The second 8 needs 8 subtracted from the line number so that the same routine as we used for the first 8 lines can be used (multiply by 32, add column # plus 16384) but we also must add 2048. Similarly, the bottom 8 lines need 16 subtracted and an addition of 4096 rather than 2048 and the same routine can be used on the remaining portion of line numbers. It's beyond the power of the beginning student to see how this can be done in a minimum of bytes but advanced students should know how. HINT: Use SET for 2048, 4096, and 16384. From this it can be seen why AT begins at 0,0 and not 1,1...nothing has to be added for the start. The beginning student should start to realize at this point that thinking for machine code is somewhat different than Basic programing.

The top screen address of the next character is stored in DF CC 23684-23685 (Display File Current Character).

<!-- p. 37 (pdf 45) -->

## Plot

Now that we know how the screen pixels are stored, how does `PLOT` work? From Basic, we learned that 0,0 for `PLOT` is in the lower left hand corner of the screen. X, the horizontal coordinate, goes from 0 (left) to 255 (right) across the screen. Y, the vertical coordinate, from 0 (bottom) to 175 (top).[^c02-5] These coordinates are stored at COORDS 23677-23678. X in 23677, y in 23678.

How does the computer get the right pixel from these numbers?

Let's `PLOT` x = 142, y = 97 and see which pixel of what address must be turned on. Looking at x first, we realize that every 8 bits across is going to be another byte's worth. Dividing 142 by 8 gives us 17 full bytes with 6 left over. We are in the 18th byte.

But, we recall that the bit numbers are 7,6,5,4,3,2,1,0 and we want the 7th bit from the left (bit 1). A zero remainder would have meant bit 7 of the 18th byte.[^c02-6]

Y is the real problem as it counts from pixel byte # 8 of line 21 on up to pixel byte 1 of line 0. It is much easier counting from the top down by doing a 175 - y. This has the effect of moving 0,0 from the lower left to the upper left corner of the screen. It does not affect calculations on x. 175 - 97 = 78. Dividing by 8 gives us line 9, pixel byte 6. Writing that in binary:

```text
       128 64   32 16 8   4 2 1
   y =  0   1    0  0 1   1 1 0
       3rd 2nd  line in   bytes
       sec sec  section   down
```

Notice how the 64 bit really translate into the 2nd section of the screen and how the 128 bit would be section 3. Notice how the 32, 16 and 8 bits give us the line number in the section. Our number was line 9 = section 2, line 1 so we expect a 1. Lastly, the 4, 2 and 1 bits gives us the pixel byte to use.

Now, let's try writing our high byte of address. Referring back to Chapter 1, we note the following values of bits:[^c02-7]

```text
32768 16384 8192 4096 2048 1024 512 256
```

We remember that the display file starts at 16384. How convenient, all we have to do is turn on that bit. Our high byte looks like:

```text
0,1,0,0,0,0,0,0
```

Moving down a full section of 8 lines (32x8x8) or 2048 bytes worth. Real convenient to have another bit just equal that:

```text
0,1,0,0,1,0,0,0
```

<!-- p. 38 (pdf 46) -->

(If our example would have been in section 3, it would mean add 4096 rather than 2048 which just happens to be a nice number also.)

The extra line (we were in line 9) will be going to the low byte of our address so let's skip that for the present. The byte number of a character goes in the 3 low bits. (Remember those INC H's we were talking about earlier?) So our high byte address becomes:

```text
0,1,0,0,1,1,1,0
```

Translating back to decimal gives us 19968.

Going on to the low byte of our address and working with that remaining line, we must multiply by 32 which is equivalent to putting it into 3 high bits as is. (0,0,1). The 5 low bytes of the low address will be our full pixels from x = 17 (1,0,0,0,1). So our low byte address is:

```text
0,0,1,1,0,0,0,1
```

Which translates to 49. Adding both address bytes gives us 20017.[^c02-8]

There you have the whole rationale of a `PLOT` routine. The whole thing seems quite complex and involved with a lot of bit fiddling. Machine code is great for that sort of thing especially with the Z80 code. Those of you who know machine code should now be able to write a routine for `PLOT`. The routine is given in Chapter 10. The novice is not ready to take on a full fledged bit manipulation routine such as this quite yet.

If you think `PLOT` is bad, just think about what `DRAW` would involve, or if you're really serious, how about `CIRCLE` with the extra argument that turns it into an ellipse. For the mathematician, how about a 4 dimensioned space form unfolding into 3 different dimensions? Or? Let your imagination run. The point of all this is to get you to start thinking in different terms than you used in Basic. Machine code is really like learning a new language. Let's go on to something easier.

## The Attribute File

The attribute file is part of the Display File and immediately follows the screen map. It, for once, doesn't have any fancy way of storing but merely uses one byte per character starting with 0,0 at address 22528 and going across each row in order, row upon row for 768 bytes.

Each attribute byte contains the information about that character space's BRIGHT, FLASH, PAPER and INK. (All 8 bytes are the same.) In reality, when we are done printing the character to the screen file, we are only half done. We now have to find the correct attribute byte and change that also if necessary.

<!-- p. 39 (pdf 47) -->

The scheme for an attribute byte is given on page 252 of your User's Manual. Again it is done bit-wise. Bit 7 is used for FLASH, being 1 if on and zero if off. Bit 6 is for BRIGHT with the same notation. Bits 5, 4 and 3 are used for the PAPER color using the scheme listed in the table in the Manual. Bits 2, 1 and 0 do the same for INK. If we examine this table, we will note that the colors are formed "gun-wise". Your color TV or color monitor has 3 guns: red, green and blue. Turning on no guns gives us black. Turning on the "1" gun turns on the BLUE gun. Similarly, the "2" gun is RED and the "4" gun is GREEN. These are the primary colors. Mixing 2 colors gives the secondary colors. Red and green give yellow. Green and blue give cyan and red and blue give magenta. All 3 guns give WHITE.

Our computer only has 2 intensities of color--dull or regular and bright...because it has to handle everything in digital form. Your TV set is an analogue device which doesn't have to digitize everything so it can process a certain percentage of red, a certain percentage of blue and a certain percentage of green together with what is called luminescence (or brightness) --essentially black, to give you any hue you want. To completely digitize a TV picture, your TV would have to handle tens of millions of bytes per second...remember that the TV is refreshed every 1/60th of a second so it's 60 pictures a second. Some of the beautiful graphic display can be done with digitizing but the memory of these computers is in the multi-megabyte range.

The attribute value in present use is stored in 4 bytes in the system variables at: 23693 ATTR P(ermanent); 23694 MASK Permanent; 23695 ATTR T(emporary) and 23696 MASK Temporary.

What's the difference between Permanent and Temporary? When we do an `INK 0 : PAPER 7` without a `PRINT` statement we are doing a PERMANENT change to Ink and Paper. When we do INK, PAPER, FLASH or BRIGHT in a `PRINT` statement, we are doing a TEMPORARY change-it only lasts for the duration of the statement...UNLESS we do a ";" in which case it carries over to the next `PRINT` statement.[^v05-2]

What is a mask? The mask tells the computer what parts of the ATTRIBUTE to take from the TEMPORARY ATTRIBUTE and what to take from the PERMANENT ATTRIBUTE. The two masks always complement each other--what is "on" in one is "off" in the other.[^v05-3]

You can easily change the attributes by POKEing in a different value. But remember you have to have ALL the values. Knowing what we already know about binary numbers we start with the INK number--as is. Then we add to it the PAPER number MULTIPLIED by 8. To turn on BRIGHT we have to add 64, right? And, to turn on FLASH, add 128. If you try this remember that nothing is going to show on the screen until you tell the computer to print something. The attribute value is changed but it isn't used until you print something.

<!-- p. 40 (pdf 48) -->

In M/C thinking, the easiest way to get the right ATTR address is to go back to that AT, which gets updated each and every character and make the calculations from that.

## Over and Inverse

The missing operations not included in the attribute are OVER and INVERSE. The reason for this is that once the pixels are in the Display File the Over and Inverse is not needed--it is already accomplished. Over and Inverse are found in another type of variable called P FLAG 23697 (Print Flag). But first let's talk about a "flag".

No, it's not the "Stars and Stripes" waving somewhere, and no, it's not somebody doing semaphore signaling--but you're getting warm. It's more like pennants flying on a ship signaling something like, "Gale Winds", or, "Captain is on board". A "flag" is only 1 bit of a byte. When it's "on" it means one thing and when it's "off" it usually means the opposite. Therefore, a whole byte of flags means that up to 8 flags can be stored in that byte. The 8 flags of P FLAG are:

```text
7 Paper complement of Ink permanent
6 Paper complement of Ink temporary
5 Ink complement of Paper permanent
4 Ink complement of Paper temporary
3 INVERT permanent
2 INVERT temporary
1 OVER (XOR) permanent
0 OVER (XOR) temporary
```

If you remember from Basic, doing `INK 9` will give you a contrasting color to the PAPER. Doing it outside or inside a `PRINT` line again is the difference between permanent and temporary. Running the program sets the different flags in the P FLAG.

Your User's Manual says that the use of INVERSE prints the pixels in PAPER color and the Paper in INK color...not so. Yes, it looks like that but in reality it sends the Display File the complemented pixel byte--all the 1's are 0's and all the 0's are 1's. We will discuss how to do this type of inverting later when we talk about machine code logic.

When a character is sent to the same space already occupied by another character, the old character is simply replaced by the pixel bytes of the new...overwritten as we say. When OVER is "on" we ADD the pixels in the old byte to those of the new in all cases where one or the other is a "1". When both bytes have a "1" in the same position, a "0" is used. If you try to underline a string of lower case "y" you will see that the underline line is not continuous because of the descender, that part of the "y" below the line, goes into the bottom byte where the underline occurs.

<!-- p. 41 (pdf 49) -->

Notice that (XOR) in the OVER flag? This flag is sometimes also called the XOR flag telling the computer to do an XOR operation ...in the case of OVER it means XOR the byte in the Display File with the new pixel byte and send the results as a replacement. XOR means EXCLUSIVE OR which we will find out about later...it's an operation that can't be done from Basic.

### INVERSE vs. INVERSE and TRUE VIDEO

Why have Inverse Video and True Video as well as Inverse?

Enter and run the following program:

```basic
 5 LET a$ = "HELLO"
10 PRINT a$
15 INVERSE 1: PRINT a$;"HELLO"
20 PRINT "HELLO"
25 INVERSE 0: PRINT INVERSE 1;"HELLO THERE";
30 GOTO 10
```

Walking through the program, the first a\$ gets printed normally as we would expect. Line 15 prints a\$ in Inverse but it prints "HELLO" normally.[^v05-4] Line 20 with INVERSE still on in permanent mode prints "HELLO" inverted. Line 25 turns off the permanent Inverse but then the PRINT substatement turns it back on so "HELLO THERE" is inverted. We forgot to turn Inverse off as we cycle back but behold, a\$ still goes in normally.

The reason for TRUE and INVERSE Video is that it allows one to just invert a single character in a string. Edit line 15 by adding INVERSE VIDEO in front of the "H" and True Video in back of it. Run the program again. Notice that in line 15 where we originally got a\$ printed in inverse, this time the "H" which was in inverse video did not change to normal but stayed inverted. INVERSE VIDEO is thus absolute. That is, when INVERSE VIDEO is used it keeps it Inverse no matter what INVERSE says. You can't invert an Inverse Video.

## Screen\$

When you save a SCREEN\$ you save both the screen bytes and the attributes. When you load a screen back from tape directly into the Display File, you are loading at 1200 baud (bits/second)... that's 150 bytes/second. With a load taking 6912 bytes, it takes 46+ seconds to load.[^c03-1] If you start with the screen loaded with contrasting INK and PAPER and then overwrite with a SCREEN\$ load so that you can see the printing as it's loaded you first get a load of Permanent colors printed which then gets colored as you load the attributes. Nothing fancy at all to this routine but it can give one some interesting effects as it's being done.

Another favorite trick during loading is to get rid of all the loading messages--this is simply done by making INK and PAPER the same color and designing your screen to be blank where the <!-- p. 42 (pdf 50) --> message would be printed. No M/C involved in this--just knowing how your computer works.

## BORDCR 23624 Border Color

Address 23624 contains the Border color times 8. A contrasting ink color is automatically used. Be careful POKEing this address as it is also used for LOAD, SAVE and VERIFY--the tape routines. If you recall, the border does different things as a program is being loaded or saved. This is because the Sinclair designers found that they could give their users a visual indication that a program is loading or saving properly from or to cassette. Other personal computers don't bother. Also note that since the loads from or to disk are so fast there really is no need for a visual signal. The emphasis with disk loads is on speed and there isn't enough time to stop and give a signal to the screen much less have the viewer notice it.

## VIDMOD 23746 Video Mode

Of all the disappointments in the 2068, this is perhaps the greatest. We were supposed to be able to use 4 different types of screens and end up with only being able to use one. We cannot "get at" the rest of the modes without doing some machine code routines. Even after we set up the DUAL screen mode, we can't write to it without more code. I can't think of a better use for all the extra space in the Extended ROM than to support the additional modes for the screen and at least correct these omissions. At the same time that we are "burning in" a new Extended ROM we could make all the corrections to the Function Dispatcher and Bank Switching routines as well. In case you were wondering about the Spectrum, it only has one display mode. This was supposed to be an added feature of the 2068. The modes we were supposed to have are:

**MODE 0**--the one we do have is the normal 32 column by 24 line screen with the attributes working as described. It only uses Display File 1.

**MODE 6**--Is the first of 3 dual screen modes which use BOTH Display Files with 64 characters across the screen and 24 lines down.[^v05-5] As already mentioned every other character is stored in the same screen file. It doesn't use the attributes as the whole screen has to be the same INK and a contrasting PAPER color. No FLASH and BRIGHT are allowed. Call this the Office or monitor mode. By changing pixel widths of the characters it can be made to display an 80 column screen as we already mentioned.

**MODE 2**--is the high resolution color mode. It uses the single 24 line by 32 column screen but the 2nd Display File stores an attribute for each pixel byte of the screen. There are still some limitations to the use of colors.

**MODE 1**--Is the 2 page mode. It's 2 normal screens that can be

<!-- p. 43 (pdf 51) -->

called to the TV/Monitor alternately and could be used for such things as animation by quickly switching from one display to the other. Updates of the screen file not on display must be done in code as Basic wouldn't be fast enough. At present this mode is not supported from Basic so it's all code.

## Display File 2

If we look at our memory map (page 254 of the User's Manual if you haven't made a copy), we find that in normal operation, the space used by Display File 2 is used by the RAM Resident Code, alias the Function Dispatcher/Bank Switching routines, as well as the Machine Code Stack and the Machine Code Variables and part of the Basic Program. Note that on the left map the PROG starts at 26710, whereas in the right map the top of Display File 2 is at 31488.[^v05-6] Therefore, before we use the 2nd display file we have to make room for it. The Function Dispatcher/Bank Switching routines and the Machine Stack go to the top of memory as the User Defined Graphics are moved down a bit to provide room. Additionally, the Machine Code Vars, ARSBUFF, CHANS and PROG are moved up for the rest of the space needed. Cartridge programs can NEVER use Display File 2 modes as they need the Bank Switching routines along with the ARSBUF to stay in Chunk 3.[^v05-7]

At this point you should be familiar enough with entering some codes from other programs to realize that M/C does NOT use line numbers. It, however, has GOTO and GOSUB equivalents called JUMP and CALL which really say, "jump to this address". Since addresses are ABSOLUTE, anytime one moves M/C to a new address, one has to make certain to change all the JUMPs and CALLs. When your computer goes into Dual Screen mode where it needs the 2nd display file, it moves the Function Dispatcher/Bank Switching routines and the machine stack to upper RAM and then uses another routine to correct all the jumps and calls. Unfortunately, there are more errors in that routine so that it actually adds errors to the routines.[^v05-8]

If you want to see what a 64 column mode looks like you can do:

```basic
OUT 255, 62
```

You get a black screen with what looks like Chinese in the top third of the screen. What you are really looking at is the Function Dispatcher/Bank Switching routines printed to the screen as pixels. Although you opened up Display File 2 to the TV screen you did not switch out the code. At this point, if you started with a clear screen, Display File 1 is empty--notice how the Chinese is nicely separated.

Also notice the Edit line at the bottom of the screen now seems strangely staggered. Try entering a line of a program. The letters look compressed horizontally. As you enter the line note how the spacing in the top line of Chinese becomes filled with <!-- p. 44 (pdf 52) --> your program line. If you look carefully, on a well focused TV, you can actually make out the letters of the line between the Chinese.

Want to experiment further? Let's go to a full 2 screen mode and get rid of the Chinese. At the same time let's do it in Hex. Enter the following Hex Code loader program: (courtesy SYNTAX)[^c03-2]

```basic
 1 REM DON'T NEW AFTER THIS
 5 CLEAR 63199
10 READ A, B, C, D, E, F
15 DATA 10,11,12,13,14,15
20 READ Q$
25 LET P = 1
30 FOR X = 63200 TO 63237
35 LET X$ = Q$(P TO P+1)
40 LET V = VAL (X$(1))*16 + VAL(X$(2))
45 POKE X, V
50 LET P = P + 3
55 NEXT X
60 INPUT "VIDEO MODE"; V
65 POKE 63212, V
70 RANDOMIZE USR 63200
75 DATA "F3,3E,01,D3,F4,DB,FF,
CB,FF,D3,FF,3E,01,F5,FB,CD,8E,0E
,F3,DB,FF,CB,BF,D3,FF,AF,D3,F4,F
1,FE,80,20,03,32,C2,5C,FB,C9"
```

Check the numbers in the bottom DATA line to make sure they are correct, then RUN. When the "VIDEO MODE" prompt comes up enter a 62.

We got a nice black screen and no Chinese. We now have made room for Display File 2 and cleared it out. Hitting LIST shows us our program in Display File 1 only. If you want, do some direct command PRINT statements to see how it works.

At this point we have not used Display File 2. As the warning in the REM states: "DON'T USE NEW", we have to now Enter a New program by overwriting the old one...If you like, you may save the above program first.[^c03-3]

```basic
 1 REM For 1st 8 lines only
 5 OUT 255, 62: REM Ink/Paper Change
per p 248 User,s Manual
10 INPUT y$
15 FOR x = 1 TO LEN y$
20 LET A = CODE y$(x)
25 LET AF = 15360
30 FOR Y = 0 TO 7
35 LET F = PEEK (AF + A*8)
40 LET Z = X/2
45 IF Z = INT (x/2) THEN POKE 1
6383 +(Z+.5)+Y*256,F
```

<!-- p. 45 (pdf 53) -->

```basic
50 IF Z <> INT (x/2) THEN POKE 2
4575+Z+Y*256,F
55 LET AF = AF + 1
60 NEXT Y
65 NEXT x
```

Enter a 70 and a 75 to get rid of those lines.

To RUN this program do a GOTO 5, NOT a RUN. At the INPUT enter any message that you wish up to 16 screen lines long--it will be compressed down to 8-64 column lines when it prints to the top of the screen. Notice how slow Basic is...it seems to be drawing the characters in slow motion. Certainly not an acceptable speed and one reason for writing the program in M/C.

I hope you have your 2040 printer attached. If you do try a COPY. You got only every other character to the printer.

Okey, try CLS. Only screen 1 cleared. This is what I mean when I say only Display File 1 is supported. You can't write, COPY, CLS or anything else to Display File 2.

Well, at least we can clear the 2nd screen in a short program. Add to the bottom of your program:

```basic
70 STOP
75 FOR x = 24576 TO 30719
80 POKE x, 0
85 NEXT X
```

*Notes on the listing above:* line 75 now starts at 24576.[^v05-9]

And RUN the program by entering `GOTO 75`.

As you can see, it would take new routines for each of the normal functions of the screen including AT, TAB, etc. Some of these routines are given in the 2068 Technical Manual although at this time they won't mean much to you. The advanced student may wish to try some of them at this time.

Obviously, the other screen modes will need routines as well.

## Screen Outputs

You have the choice of 3 different screen outputs depending upon what sort of screen you use. TV is for standard TV operating on either channel 2 or 3. Monitor is for a monitor output, while RGB output can be taken off the back bus for an RBG monitor.[^v05-10] If you have an AERCO Disk Drive Interface you already own all the necessary hardware for a RBG monitor--all you need is the cable from the interface to the monitor. You can make this yourself but if you are like me, not a hardware hacker, you can send the specifications to AERCO and have them make a cable for you. The difference between a monitor and a RBG monitor is well worth the price.

<!-- p. 46 (pdf 54) -->

<!-- page intentionally blank in original -->

[^c02-3]: Corrected. The original printed "Character 1" twice; address 16417 is the next column on the same line, as row "L 1" of the table below shows (16416 16417 16418).

[^c02-4]: Corrected. The original printed row 4 as "17152 17152 17153 17154 17155" and row 8, column 32 as 18197; each entry is 16384 + 256 x (pixel row - 1) + (column - 1).

[^v05-1]: Library note: the ROM keeps both the AT position (S POSN) and the display-file address DF CC; the character printer writes the 8 bytes at DF CC and then just increments the address (INC HL) for the next column, recalculating it from line and column only after AT, TAB, a new line or a scroll; see docs/ts2068_system_variables.md (HOME ROM $06F6-$0707).

[^c02-5]: Corrected. The original printed 176; the vertical PLOT coordinate runs 0-175 (176 pixel rows), as the text assumes a few paragraphs later when it converts with "175 - y".

[^c02-6]: Corrected. The original printed "the 6th bit from the left (bit 2)" and "bit 0 of the 17th byte"; x counts from 0 and pixel bits run 7 (left) to 0 (right), so x MOD 8 = 6 is the 7th pixel from the left, bit 1 (7 - 6), and a zero remainder is the leftmost pixel, bit 7, of the 18th byte.

[^c02-7]: Corrected. The original printed 32728; the top bit of the high byte is worth 2^15 = 32768.

[^c02-8]: Corrected. The original printed x = 18 (1,0,0,1,0), low byte 0,0,1,1,0,0,1,0 = 50 and address 20018; 142 / 8 = 17 full bytes, so the byte offset counting from 0 is 17, and the low byte (0,0,1,1,0,0,0,1 = 49) and the total (19968 + 49 = 20017) that follow from it are corrected too.

[^v05-2]: Library note: the temporary colours do not carry over; each time channel 'S' is opened (at the start of every PRINT) the ROM copies ATTR P/MASK P into ATTR T/MASK T and the permanent PFLAG bits into the temporary ones, so a trailing ";" keeps only the print position, as the program on p. 41 shows; see docs/ts2068_system_variables.md (HOME ROM KANALS, DO_ATTS $0888).

[^v05-3]: Library note: the mask picks between the attribute already on the screen and the one being printed: each 1 bit in MASK T keeps that bit of the screen attribute (the INK 8 / PAPER 8 'transparent' setting) and each 0 bit takes it from ATTR T; MASK T is the temporary copy of MASK P and the two are not complements; see docs/ts2068_system_variables.md (HOME ROM ATTBYT $0710).

[^v05-4]: (unverified) Run-time behaviour not checked by emulation. As described it looks inconsistent: with INVERSE 1 set permanently, line 15 should print both a\$ and "HELLO" inverted. In the ROM INVERSE is a flag in PFLAG (bit 2, with bit 3 the permanent copy), not a toggle, which fits the closing remark that you can't invert an inverse video.

[^c03-1]: Corrected. The original printed "27+ seconds"; at the 150 bytes per second given in the same sentence, 6912 bytes take 6912/150 = 46.08 seconds. Library note: the 2068 tape rate is not a fixed 1200 baud but depends on the data (about 2060 bits/second for 0 bits, 1030 for 1 bits; EXROM $00BA-$00C4), so a 6912-byte SCREEN\$ takes roughly 35-50 seconds plus leader and header; see the note on p. 24.

[^v05-5]: Corrected against the ROM. The original printed "MODE 3"; 64-column mode is DECR bits D2-D0 = 110, mode value 6 (6, 14, 22 ... 62 with the colour pair in bits 5-3, as in the book's own `OUT 255, 62`), while 011 is an undefined combination; see docs/technical-manual/02-hardware-guide.md (DECR, port $FF).

[^v05-6]: Library note: Display File 2 occupies 24576-31487 ($6000-$7AFF); 31488 ($7B00) is the first byte above it, where the moved area begins; see docs/ts2068_memory_map.md (EXROM $0E0E clears up to $7AFF).

[^v05-7]: Library note: this applies to a BASIC AROS while its BASIC is running, because the support code calls the chunk-3 bank-switching code directly; LROS and machine-code cartridges can use the advanced modes; see docs/technical-manual/06-known-bugs.md (Advanced Video Modes).

[^v05-8]: (unverified) No specific stock-ROM error in the relocation fix-up table (EXROM $1D00) is documented in the library; its fix-table changes appear only alongside the community EXROM's own rewrites; see docs/exrom_revision_analysis.md.

[^c03-2]: Corrected. The original printed line 30 as `FOR X = 63200 TO 65237`; the DATA string in line 75 holds exactly 38 bytes (63200 to 63237), and with 65237 the loop would run off the end of `Q$` with a subscript error after the 38th byte. The bytes disassemble to a coherent routine: `DI; LD A,1; OUT (F4H),A; IN A,(FFH); SET 7,A; OUT (FFH),A; LD A,1; PUSH AF; EI; CALL 0E8EH; DI; IN A,(FFH); RES 7,A; OUT (FFH),A; XOR A; OUT (F4H),A; POP AF; CP 80H; JR NZ,+3; LD (5CC2H),A; EI; RET`, line 65's `POKE 63212, V` patches the operand of the second `LD A,1` (offset 12), and 5CC2H = 23746 is VIDMOD.

[^c03-3]: Corrected. The original printed line 45 ending `+Y+256,F`; each pixel row of a character cell is 256 bytes further on in the display file, so the offset is `Y*256`, as in the matching line 50 (`24575+Z+Y*256,F`).

[^v05-9]: Corrected against the ROM. The original printed `75 FOR x = 24575 TO 30719`; the Display File 2 pixel area is 24576-30719 ($6000-$77FF), and starting at 24575 also pokes 0 into $5FFF, the last byte of the SYSCON area; see docs/ts2068_memory_map.md. (The 24575 in line 50 is intentional: Z there is always n + 0.5, and POKE rounds the address.)

[^v05-10]: (unverified) Video output hardware (RF channel 2/3, composite, RGB on the rear connector) and the third-party AERCO cable are outside the ROM and the library.
