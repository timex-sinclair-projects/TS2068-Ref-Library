<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 47–66. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 4: System Variables.*
*[← previous](04-chapter-03-screen-printing.md) · [book README](README.md) · [next →](06-chapter-05-beep-and-sound.md)*

---

<!-- p. 47 (pdf 55) -->

# Chapter 4: System Variables

Addresses 23552-24297 are used to store all the things your computer has to keep track of. We already met a few of them in the last chapter. They can be PEEKed at anytime--inside a program and/or in command mode. The complete list of these variables, 23756-24297 are reserved for additional variables, is listed on page 262-265 of your Owner's Manual. I asked you to make a copy of them as we will discuss them in detail now.

We will select our System Variables by subject matter rather than doing a top to bottom discussion. For this it is best to have a "hands on" perspective so turn on your computer for a while. If you have a disk drive interface, kindly disconnect it as one of the commands we are going give a little further on messes up if the disk drive is present.

## CHARacterS 23606-23607

Try, `PRINT PEEK 23606 + 256*PEEK 23607`. You get 15360 for the start of the character pixel table. But that is not the address I gave you in Chapter 2. It was 15616. Now, kindly read the note that goes along with CHARS. Then subtract 15360 from 15616 and you do indeed get 256. Why this offset? Since "space", the first printable character, and all subsequent characters have to have their CODE numbers multiplied by 8 to get them spaced the 8 bytes apart to designate the 8 pixel bytes, what is saved in CHARS is the amount to be added to the 8 times multiplication of the Character Code. For "space" it's 32x8 which is 256 added to 15360.

The important part for you to remember is that if you would like to design a different character font all you have to do is tell the computer to subtract 256 from the start of your character pixel table address and store it in CHARS and you have a new character set. The interesting thing is that doesn't necessarily have to be the alphabet and punctuation--it could be electrical symbols as I have seen done.

## RAMtop 23730-23731

First a word about PEEKing and POKEing. One never harms anything by PEEKing numbers even when you have the wrong numbers--you just get a stupid answer. POKEing the wrong number with the wrong thing can get you into a crash but nothing more--just turn the computer off and back on. You don't physically damage anything. Machine code is a lot of PEEKing and POKEing but it's <!-- p. 48 (pdf 56) --> done a little differently. However, this is a subject of a later chapter.

Enter the following command: `PRINT PEEK 23730 + 256*PEEK 23731`. You should get 65367 on the screen. By now you no doubt have figured out that the numbers in back of the titles are the address at which the particular system variable is stored. However, if you look at your memory map (back on page 252) you find RAMtop was not given a number but that it is exactly 1 address short of the UDG area. It came to the screen in decimal.

Yep, your computer gives you numbers in decimal--not Hexadecimal. It's just another reason why hexadecimal has limited usefulness since if you want to use it you now have to convert the decimal to hex, or write a program to do it for you.

Why didn't you get the full value of RAM--65535? Because by now you have figured out that the UDG graphic pixels are stored at the very top of RAM. But we just turned the computer on and we haven't designed anything as yet. Well, the computer reserves this area for UDG anyway and in the meantime it stores the pixels for CAPS A to U there until you redefine them. The full value of RAMtop is called Physical RAMtop stored at 23732-23733. We already talked about what happens if your computer develops a bad byte.

Why lower RAMtop? It's done to protect overwriting what is above it with anything else which could be disaster for M/C. Anything else the computer does fills up memory from the bottom up but it still has to know when it runs out of useable space, i.e., space not reserved above Ramtop.

Now enter the commands: `CLEAR 64000: PRINT PEEK 23730 + 256*PEEK 23731`. You got 64000 right? It should be pointed out that now 64000 is the last byte that Basic can use. The first byte of reserved space is 64001. We now can write our machine code above RAMtop and be assured that our Basic program will never overwrite it. It should be pointed out again that anything above RAMtop must be POKEd there and, furthermore, is NOT saved with the Basic program. It needs a special save that goes:

```basic
SAVE "name" CODE 64001,1535    or MOVE "name,bin",64001,1535
```

if you have a disk drive.[^v06-1] Note that I have saved both the machine code and the UDG in one save. How convenient, now I can erase all the lines that defined my UDG and the loader program for the machine code as well, just saving the RANDOMIZE USER statement for the M/C call. I do, however, have to add a LOAD or CAT line in my Basic program to reload the code.

Now, suppose I were doing a musical program to play a few ditties using the SOUND command. These programs are chuck full of numbers as you will find out in Chapter 5. Writing all these numbers in DATA lines takes not only 1 byte per number symbol <!-- p. 49 (pdf 57) --> (123 takes 3 bytes), but each number is "slugged" and so takes another 6 bytes. All these numbers are less than 256 which means they could be stored one to a byte as code above RAMtop and the program made to PEEK them as needed. I happen to know a few "composers" who have run out of memory. Now, since we are on the subject, how about putting the CODE on a different tape or disk. Then we could load tape #1 for one set of tunes and Tape #2 for the second--or, if you are ambitious, each movement of your Grand Symphony on a different load. It doesn't have to be music however. It could be other data as well. These are just a few ideas on "file storage"...they get out of hand fast enough the way it is.

## Setting RAMtop Without CLEAR

There is one thing wrong with using CLEAR. It also CLEARS the Variable file. RUN does the same. Since you generally load the entire Basic program and then start running it, the first line or so contains the CLEAR Followed by the LOAD of the CODE. The CLEAR just cleared your variable file. There may sometimes be reasons why you don't want the variable file cleared. One of the best is to continue a program that is only half run. Just POKE 23730 and 23731[^c03-4] with where you want RAMtop set and load your code.

We already mentioned that it was low bit of address into 23730 and high bit of address into 23731. What is the low bit of an address and the high bit of the address? Simply take the address and divide by 256. You get a number with a fraction. The integer number without the fraction is the "high" byte. Take the high byte number multiply by 256 and subtract from the address to get the "low" byte. I can't stress this enough so once again it's "LOW BYTE FIRST".

We have spend considerable time discussing POKEing RAMtop, but the technique will apply to all other double register variables as well. How do we know how many bytes a variable uses? Refer to the first column of the System Variables Table. The number is the number of bytes. "N" refers to no lasting effect. "X" means to take care so you don't crash. The computer can get lost very easily.

## Storage of a Basic Line

```text
PROGram 23635-23636       VARiableS 23627-23628
Edit LINE 23641-23642     WORKSPace 23649-23650
```

It's about time to find out how the computer stores a Basic line. Since your computer is still on, enter the following little program:[^c03-5]

```basic
 5 FOR  X = 26710 TO 26810
10 PRINT X;" "; PEEK X;" "; TAB 11; CHR$ PEEK X
15 NEXT X
```

<!-- p. 50 (pdf 58) -->

and RUN the program. Leave the first screen on the TV and DON'T SCROLL. Now turn to page 255 of your User's Manual and refer to the bottom of the page--BASIC PROGRAM LINE LAYOUT. As we explain a screen of program printout scroll the screen as needed.

Okay, so we didn't get a perfect printout of the program as there are a lot of question marks. Let's see what some of the question marks mean.

First a 0 and a 5 for the line number. Note that line numbers are NOT SLUGGED. The next 2 bytes 27 and 0 are the line length stored LSB/MSB fashion. (LSB = Least significant byte, MSB = most significant byte--low and high byte). We can't tell at this point if its right as the end of the line is on the next screen but we do know it will end with a "13", the enter code. The line length is MINUS the two bytes for line number and the two bytes for line length. Thus, when added to the address of the last byte of the line length, where the computer is when it reads the length of the line, will give the address of the enter byte at the end of the line. You can see how the computer searches the Basic program for a certain line number--it looks at the line number and if it's not what it wants adds the length of that line to get the address of the start of the next line -1.

Let's continue. Ah, something we recognize, FOR x = 26710. Since 26710 is a number, it is followed by the slug token (14) and then the 5 bytes of the slug itself. In this case, it's an integer (a number without a decimal point or a fraction ) so only uses the 3rd and 4th bytes of slug number in LSB/MSB fashion. It's a coincidence that the two numbers of the slug correspond to the codes for the letters "V" and "h" so they are printed. On to "TO 26810" with another slug ("h" and "INT" are coincidences again) and finally the 13 ENTER code. That ends the first line of our program.

At address 26741 we start line 10. The two bytes for the line number and the two for line length and then PRINT x;" "; (the 32 stands for the space) PEEK x;" "; TAB 11, slugged as 14, 0, 0, 11, 0, 0 and then ; CHR\$ PEEK x and 13 (enter). End of line 10.

At address 26773 we start line 15--two bytes for line number, two for line length, and the line itself NEXT x ENTER. That finishes our little Basic program. Please leave the program on the screen as we will continue with it. Consulting our memory map again (page 252) we see that immediately after the PROGram comes VARiableS. And since we have run this program, we have a value there--x. BUT, our x happens to be in a FOR statement so it is not a simple value. Kindly turn to page 257 of the User's Manual.

In translating the FOR/NEXT variable we see the three ones--meaning that bits 7, 6 and 5 are on. On the TV screen we see 248 SAVE (SAVE just happens to be the token for 248). To see if this <!-- p. 51 (pdf 59) --> number is really a FOR/NEXT x we take 248 subtract off 128 for Bit 7 being on, another subtraction of 64 for Bit 6 being on, and a third subtraction of 32 for Bit 5 being on leaving us with only 24. Reading under the layout on page 257 we see "letter -60H"--in other words take the lower case letter code, subtract off 96D and add 128 + 64 + 32 to get the code. Since we are working back, we have to add 96 to 24 and get 120--the code for "x".

The next 5 numbers are the slugged PRESENT VALUE of x. Since this program was running while printing itself out, everytime we looped through it, the PRESENT VALUE got updated. Since we know that it was holding the address we were looking at, the 159/104 (LSB/MSB) should correspond to 26783...as that is what it was when we printed address 26784, it was updated to 160/104 as we moved on to the next line...but the MSB was still 104.[^c03-6] Continuing with our translation of the FOR/NEXT variable, the next 5 bytes contain the limiting value (the value to stop at--the number after the TO) of x which is 26810. Address 26791 starts the STEP value, which we didn't specify, so it's defaulted to 1. 26796 and 26797 contain the looping line number--our program line 5. 26798 is the subline number within the line...it's a 2 not a 1 as it's the number after "TO" that we are after.[^v06-2]

That is the end of the VARS Table, so address 26799 contains an end marker 128. Consulting our memory map again, we should now be in the Edit Line. If you did what I did to RUN the program you entered RUN in command mode. 26800 has my RUN and 26801 has the ENTER. Address 26802 contains another 128 end marker to mark the end of the Edit Line.

Consulting our memory map again, we see that 26803 should start the workspace area collapsed to nothing, followed by the floating point calculator stack. It contains the integer of 181/104 which corresponds to 26805--again the value of x as it was printing the line. The floating point stack has another value of 55 which was used at some point in the program. I just extended the program to include these last few bytes just to show you they were there.

There you have your complete program all laid out in numbers for you. If it didn't make complete sense to you the first time through go and rerun the program and reread the explanation again.

What happens if we add more lines to the program? We have to remember one thing. While the computer was printing out itself, the Edit Line was still processing its contents of RUN-ENTER. When it finished the RUN, you get the message at the bottom of the screen saying what statement the program finished on together with the OKEY. The Edit line is now collapsed back down to no space at all. The message is only in the bottom screen. As we start to enter a new line the first thing it does is a CLS-Lower to clear the lower half of the screen and start printing what <!-- p. 52 (pdf 60) --> you entered there while saving the codes in the Edit Line space again expanding it as needed. Since the computer doesn't know how long the line will be that you are entering, it has to expand E Line a space at a time. Each time you press a new key it overwrites the cursor with the new key symbol, overwrites the end marker with a new cursor, adds a new end marker (Remember that a token is still stored as one byte.) and increments the values carried in WORKSPace, STKBOT and STKEND. Then it calls the PRINT TO TV routine to print the new symbol or token. If a token, a special extra routine to spell the token must be used. Once it has the code for the symbol, it now has to look up the pixels in the Character table and print these to the screen--repeating as often as needed to spell a token. If it happens to be a line number, just look up the pixels in the Character Table and print them--but keep the cursor in the K mode. If you sent it a token, it's time to change the cursor so check to see if CAPS LOCK is on and if so Print an Inverse C otherwise print an Inverse L cursor. It, of course, also has to check to see if the code was printable. If it turns out to be ENTER, a new sequence starts. All this happens almost simultaneously which gives you some idea of how fast your computer really is.

ENTERING a line the computer checks for "syntax". That's a fancy word meaning "check for errors"...things like the same number of right and left parentheses, an even number of quotation marks, TAB number no bigger than 31, and the two AT arguments in range, for example.[^v06-3] You don't really appreciate all this error checking until you start programming on another computer that doesn't do it. It can be quite frustrating to have it stop all the time as it finds another "simple" error. What computers don't check syntax until they run a program? Try Atari, Vic, Commodore, Texas Instruments, Tandy, Apple, IBM and its clones. But back to the 2068. If it finds an error, in goes the "?" cursor (somewhere close to the error) and the whole routine of changing the Edit line takes place. If no error is found, the numbers in the line are slugged. It then checks to see if the statement starts with a number and if so inserts the line length after the line number and inserts the line into the program either as a new line or a replacement line. If the line length is zero, it has to delete the old line. In the case of inserting a new line a position hunt for the right insertion spot must be carried out. When the correct spot if found, space for the new line must made by moving everything above it up the correct number of spaces--that includes all the higher program lines, the Variable File and Edit Line. After the line is inserted the page containing that line is LISTed to the screen. If the line has no line number it is executed immediately. After execution or insertion, the edit line is erased the space recovered.

See how easy Basic is? You really didn't have to worry about all of this and perhaps never even thought about it until now. This, however, gives you some inkling of what all you might have to consider when you write your own machine code routines--it takes a lot of planning and it all just doesn't happen like a magic <!-- p. 53 (pdf 61) --> show.

Note that the line number was originally entered one digit at a time. The computer will even let you enter a 5 digit number until it tries to enter the line. It then gets converted to the two bytes in the MSB/LSB fashion--it's the only time your computer does it--all the rest of the time it's LSB/MSB.[^v06-4]

There is a way to force line numbers to higher than 9999 but they print in letters and punctuation and are still limited to codes less than 16384.

Try: `POKE 26710, 55` followed by LIST on the program you have in the computer at the present time. Interesting line number isn't it? Now try bringing the cursor down with shifted 6 to line 10. Jumps to line 15 doesn't it. Press shift 6 again--back to line 5 --we can't get the cursor to line 10.

Now try: `POKE 26710,66` and follow with LIST. Nothing--an invisible program. Well, not quite. Try running the program. No dice, right? You messed up your line number sequence for the FOR/NEXT loop. Do a NEW. We were finished with the program anyway.

PROG, VARS and E LINE are "Edit" variables--they change as you edit (change) your program. There are a few more:

E PPC 23625-23626
:   (Edit--Present Program Counter) When you bring a program line down to the bottom of the screen, the line number is stored here.

K CUR 23643-23644
:   (Keyword CURsor) The address of the K, L, C, E or G cursor which is always in the Edit line.

LIST SP 23615-23616
:   (LIST Stack Pointer) is the address of the Vertical Cursor "<". The one that occurs between the line number and the first token.[^v06-5]

X PTR 23647-23648
:   (IX PoinTeR) This is a little ahead of the game. There is a register in the Z80 chip called IX that is used to find an error. It really stores the address behind the error cursor "?" which normally is where the error should occur.[^v06-6]

You will note that the above 4 system variables just keep track of where the various cursors are. There are a few more associated with errors and error reporting.

ERR C 23736-23737
:   (ERRor, Current) The line number an error occurred in which of course gets printed to the bottom of the screen with the error report. If no error then the line number the program ended on or was stopped on with a BREAK.[^v06-7]

ERR S 23738
:   (ERRor Statement) The statement in the line in which

<!-- p. 54 (pdf 62) -->

the error occurred which also is in the error report.[^v06-8]

ERR NR 23610
:   (ERRor NumbeR) Each error has a number--this number is always one less than that number. 255, one less than zero, is equivalent to "0--OKAY".

Since our computer has an ON ERR command, we have:

ERR LN 23734-23735
:   (ERRor LiNe) The line number to GOTO if we have used an ON ERR GOTO statement. I have seen this command abused to hide a lot of programming errors!

ERR T 23739
:   (ERRor Type) The error code for the ON ERR report.

And finally, several screen positions for the edit or LIST (which normally is used in "Editing" programs.)

S POSNL 23690-23691
:   (Screen POSitioN, Lower) which is the AT arguments for the lower screen. Column first, then line.

DF CCL 23686-23687[^v06-9]
:   (Display File Current Character, Lower) The address of the last character in the lower screen display --which may or may not be the current position. This has to be known and updated as we add more characters to a line so that it doesn't go off the screen.

S TOP 23660-23661
:   (Screen TOP) The top program line listed on the screen when LISTing a program.

DF SZ 23659[^c03-7]
:   (Display File Size) The number of lines in the bottom "Edit Line" + 1 for the blank line...used to scroll the bottom screen when more edit space is needed.

## Scroll

While we are on Scroll let's add:

SCR CT 23692
:   (SCRoll CounT) The "Edit" Scroll works by looking at DF SZ and scrolling that number of lines, counted from the bottom of the screen by the number held in SCR CT less 1. Therefore, when an extra line is needed, which is done by checking DF CCL, DF SZ is used to determine how many lines scroll and the scroll is done only 1 line up. The top blank line of the bottom screen blanks the bottom line of the top screen.[^v06-10]

Obviously, POKEing SCR CT with the number we desire, not necessarily a full screen, and then CALLing SCROLL is something we can do in machine code but not in Basic. In fact, it's possible to print INPUT to the top screen rather than the bottom. How do you think word processors work?

But you are not completely at a loss. Try this little decimal code loader program:[^c03-8]

<!-- p. 55 (pdf 63) -->

```basic
10 CLEAR 63999
15 FOR x = 64000 TO 65000
20 INPUT y
25 IF Y >= 255 THEN STOP
30 POKE x,y
35 PRINT AT 21,0;x;"  "; PEEK x
40 RANDOMIZE USR 2361
45 NEXT x
```

I use this program to enter machine code. Right now we are not interested in entering code so just RUN the program by putting in any number you wish (below 255). When you have seen enough enter a number bigger than 255. Everything should make sense in that program except line 40 RANDOMIZE USR 2361. Knowing what you now know about memory, this is a CALL to ROM. You can use ROM routines in Basic if you have everything set up...that's a big if as most of the time things can't be set up correctly from Basic. If you don't believe me, try adding: `37 POKE 23692, 3`. That should scroll the screen up two lines at a time. Wrong! We didn't call the full screen scroll routine, only the scroll loop for the top screen.

How do we know what routines are where in the ROM? By PEEKing ROM and translating it--if you don't want to translate roughly 20,000 bytes of machine code and maybe get some of it wrong, you buy a book (See page 29).[^v06-11] It's still machine code but sometimes it's great fun learning how code is written by reading someone else's interpretation of it. To tell the truth, you can spend a lifetime learning all the ins and outs of M/C.

For those of you with a copy of the "Timex 2068 Technical Manual" a listing of the major routines can be found in Appendix A (page 145). I'll warn you that some of the titles don't make much sense. For example, on page 146, the 2nd page, the 2nd column about 3/4ths the way down the page you will find PHLAF 004F.[^v06-12] PHLAF means POP HL, POP AF which doesn't tell you a thing about what the routine is really doing.

## System Variables for the Keyboard

K STATE 23552-9
:   (Keyboard States) It's 8 bytes long and is used by the keyboard routines to find out what key or keys are being pressed and as a counter to count down for the repeat delay and subsequent repeats of the same key.

LAST K 23560
:   (LAST KEY) Contrary to what you might think, the keyboard is scanned every 1/60th of a second as the computer is running by what is called a "maskable interrupt". Maskable means that it can be defeated. This is done by using the instruction DI--Disable interrupt. BUT, if you come back into Basic without doing an EI--Enable interrupt, you are in trouble as you have a dead keyboard. The only thing that works is the "off" switch and you know

<!-- p. 56 (pdf 64) -->

what that means. Anyway, the last key touched is stored in LAST K until you use it and clear it, remove your finger from the key, or touch another key.[^v06-13]

REPDEL 23561
:   (REPeat DELay) As it says, the time in 1/60ths of seconds that the computer waits for that slow human to remove his/her finger from the key before it assumes that the human wants to type another of that key. Originally set at 35 which is too slow for touch typist at 80+ words per minute or to fire those laser guns and move other things in arcade type games. Actually the 2068 goes into a countdown loop which wastes 1/60th of a second and does it as many times as REPDEL.[^v06-14]

REPPER 23562
:   (REPeatER) After waiting REPDEL/60 seconds for the first repeated key, it will only wait REPPER/60 seconds to continue with another repeat. Starts at 5. Don't go below 3 or you will be doing a lot of deletions as you get too many letters.

K DATA 23565
:   (Keyboard DATA) Stores the 2nd key of LAST K as when you press both CAPS SHIFT and SYMBOL SHIFT to get into Extended mode.[^v06-15] Note that LAST K will give you the right code for the combination of keys pressed, not just the one or the other key. CAPS SHIFT and A is going to be either 65 for a CAPITAL A if the mode was L or C, or 230 for NEW if the mode was K, or 126 for FREE if in the E mode, or 144 for UDG A if in G mode.[^v06-16]

RASP 23608
:   (RASPberry) The length of that horrible noise you sometimes get when you mess up--I suppose somebody will find a need to change the length of it someday for some good reason.

PIP 23609
:   (PIP) The length of the keyboard click. This is really additional time the keyboard update is delayed. POKEing it with large values can result in longer delays than REPDEL itself. If your keyboard isn't fast enough, leave this at zero as it is when the 2068 sets itself up.

ECHO E 23682-23683
:   (ECHO Edit) You have all been through the use INPUT prompts to make your programs "user friendly". The input prompt uses some of the Edit Line and immediately is followed by a blinking cursor asking for the input. Echo E marks the start of this position with an AT stored at these addresses with column first, line 2nd format.[^v06-17] The actual character codes go into the still, at this point, empty workspace area. With an enter, the workspace line gets converted to the proper variable.

## System Variables for the 2040 Printer

PPOSN 23679
:   (Printer POSitioN) TAB for the printer. Since it

<!-- p. 57 (pdf 65) -->

does one line at a time, it really can't use an AT.

PR CC 23680
:   (PRinter Current Character) The LSB of the last character address in the buffer. When the buffer is full, the computer stores the LSB here...the MSB is still held in one of the other CPU's registers.[^v06-18]

## System Variables for Input/Output (I/O)

## Ports, Streams and Channels

The CPU can't do much by itself. It has to interface with the outside world to various peripheral pieces of equipment. It does this through a port processing chip called the SCLD of which we will learn more about in Chapter 10. This chip has the capability of addressing 256 different ports.[^v06-19] Ports are two way--each can send and receive data or signals. Sometimes they do it intermittently--sending a string of data and then waiting until it gets a response back before repeating with a new cycle of more data and another wait for a new response. The confusing part of all this is that there are not 256 different lines for the 256 different ports--they use the data and address buses.

Take, for example, the three peripherals you must attach to do any computing at all--the keyboard, the TV screen and the sound/joystick are internal except for the fact that you need an extension for the TV out the back. A 4th port, the tape recorder ports, one for send and one for receive, also are jacks on the back of the 2068--in fact, two jacks to the same port. The monitor jack is just another variation of the TV jack with still a third "screen" port--the RBG monitor lines existing on the back outlet bus. Still another port, the "dock" or cartridge port exists as a bus under the front cover. All the rest of the ports have to come out the back bus in various combinations of lines.

The keyboard obviously can only send signals, the TV ports obviously only receive signals. The sound portion of the sound/joystick chip obviously only receives data but sends signals to the amplifier for the speaker. The cassette recorder receive (ear) and send (mic) ports get separated although they use the same port number...they are done that way so that you don't have to constantly replug from mic to ear and back on your recorder as one would eventually plug them in the wrong way. The 2040 printer port, which has to be plugged into the back is intermittent in nature and since it's a parallel device, sends 8 bits at a time requiring a minimum of 8 ports--one for each data line.[^v06-20] Other ports are used to control other things for the printer.

All these ports are permanently assigned as they are used in ROM routines making them impossible to change--unless you "burn in" a new ROM chip. As of 1984, Timex had assigned the ports listed in the table on the next page. MSN = Most Significant Nybble, LSN = Least Significant Nybble. There are no assignments below 70H.

<!-- p. 58 (pdf 66) -->

```text
      LSN (HEX)
     0_1_2_3_4_5_6_7_8_9_A_B_C_D_E_F   1. RD Keyboard/cassette
M 7        9       9                      WR Border/Beep/cassette
S 8  6 6 6 6       A 6 6 6 6           2. RD/WR Dock horiz. sel.
B 9  6 6 6 6         6 6 6 6           3. RD/WR Enhancement Port
  A  6 6 6 6         6 6 6 6           4. WR Sound chip address
H B  6 6 6 6         6 6 6 6           5. RD/WR Sound Chip Data
E C  6 6 6 6         6 6 6 6           6. TS 2040 Printer
X D  6 6 6 6         6 6 6 6           7. Bank Switching
  E  6 6 6 6         6 6 6 6         8 8. Micro-drive
  F  6 6 6 6 2 4 5 8 6 6 6 6 7 7 1 3  9. Modem
                                       A. RD/WR Centronics port
```

*Notes on the table above:* printer decoding;[^v06-21] Micro-drive, Modem and Centronics ports.[^v06-22]

The numbers in the table correspond to the devices listed to the right. Notice that we have added the Modem, Micro-drive and Bank Switching port.

The confusing part of all these port assignments is that the same port, for example, FE(1) can read the keyboard or the cassette and write to the border, sound chip (Beep) or cassette. Obviously all these devices are hooked together as signals can come in or go out multiple jacks all at the same time. Beep gets to the speaker amplifier as well as to the cassette mic jack. How does the computer know which one is which? It doesn't. But if it's a LOAD routine from the cassette, it will load whatever is coming in. We already talked about the keyboard being scanned every 1/60th of a second. This scan goes on "between bits" even when a load routine is being used. Thus, the 2068 can check for an INPUT from the keyboard while LOADing. It ignores all inputs except BREAK. If it reads BREAK, it aborts the LOAD, MERGE or SAVE routine it was doing.[^v06-23]

Also, should you hook up a new device, like a disk drive system for example, you could use the same port assignments already assigned. Your routine, however, would have to be able to distinguish which device is being read at the time.

You can send things out or get things in from ports using Basic by using OUT and IN. For example, `OUT 255, 1`, was supposed to turn your 2068 into Dual Screen Mode, and `OUT 255, 0` was supposed to turn it back into single screen mode (page 248--Owner's Manual), but these don't work because of the error in the "Change Video Mode" routine.[^v06-24]

To Summarize: The ports used are contained in the various routines in ROM, or the routines you or the hardware dealer writes to make other peripheral equipment work.

Channels and Streams. It would be impossible to remember all these assignments all the time. CHANNELS and STREAMS simplify life. They make it unnecessary to remember what device is connected to which port if working in Basic.

Upon setup, the 2068 sets up the following streams: (K = key<!-- p. 59 (pdf 67) -->board, S = screen, P = 2040 Printer and R = workspace.)

```text
253  K     This data is held in the System Variable STRMS 23568-
254  S     23605. Each stream is 2 bytes long--a number and a
255  R     channel designating letter.
  0  K     Streams 4-15 are available for further expansion.
  1  K
  2  S     Each stream is connected to a channel 5 bytes long.
  3  P     This data is in the Channel Variables (26660-26709)
           area. Only 26688-26709 are used at setup.
```

*Notes on the listing above:* stream entries;[^v06-25] the channel area.[^v06-26]

Upon setup there are only 4 channels designated by the letters K, S, R and P. All the Streams with the same letter use the same channel. Therefore, Streams # 253, 0 and 1 all use channel "K". Similarly, Streams 254 and 2 both use the "S" channel. Streams 253, 254 and 255 are called hidden streams as they are used internally by the 2068 and shouldn't be changed.

Streams 0 and 1 handle the command INPUT which has an input from the keyboard to get a character and an output to the lower screen to print it there. The address of the routine to CALL for the output is stored in the "K" channel bytes 1 and 2 as LSB/MSB. The input routine for the keyboard CALL address is in bytes 3 and 4 with byte 5 being the identifying "K".

Stream 2 (S) prints to the top screen only and handles the commands PRINT and LIST. It only has an output assignment with an error routine in the input address should you try to use it for that.

Stream 3 (P) handles LLIST and LPRINT and only has an output.

Switching Streams: Everything can be changed by specifying a different stream. Make sure your 2040 printer is attached and on. If not, turn the computer off and attached it.

Now try: `PRINT #3;"Hello"`

It went to the printer, not the TV, right? That's because you told it to PRINT using a stream designating a printer channel (P). Without that #3 after the PRINT, it would have used Stream #2 even if you didn't tell it to. This is called using a "default" value.

Try: `LPRINT #2;"Hello"`

A printer command got shunted to the TV because you selected Stream number 2 which points to an "S" channel.

We can open a new stream by doing: `OPEN #5, "P"`

If we follow with: `PRINT #5; "Hello"`, we get it to the printer simply because we designated stream 5 to point to a "P" channel.

<!-- p. 60 (pdf 68) -->

Now close the stream by: `CLOSE #5: PRINT #5; "Hello"`

We got an error because we just closed Stream 5. The first test showed us that we had indeed OPENed a new stream. This one shows us that we again CLOSEd (erased) it.

With streams everything need not always be what it seems. The following commands are identical:

```text
LPRINT = PRINT # 3        PRINT = LPRINT # 2
LLIST  = LIST # 3         LIST  = LLIST # 2
```

Don't try LIST and LLIST unless you have a test program entered to list.

You can permanently change a stream to whatever you want by redefining a preset stream with a different letter (channel). `OPEN #2, "P"` now makes Stream 2 a printer stream. All LIST and PRINT commands which default to Stream 2 would now act like LLIST and LPRINT. It's going to stay that way until you set it back with: `OPEN #2, "S"` or `CLOSE #2`. Streams 0 to 3 won't stay closed however, as the 2068 again "defaults" the stream back to their original settings.

You can even open your own stream using a different letter to point to as yet an unwritten channel having that letter designation. Designing a channel is a little beyond your ability at the present time.

The computer keeps track of the present stream number in STRMNM 23755 (STReaM NuMber).

The Channel Lookup Table can be changed from 26688 to another address by changing CHANS 23631-23632 (CHANnelS).

Even the Bank Channel Lookup Table can be changed by changing CURCBN 23743 (CURrent Channel Bank Number)...this is done when the computer is operating from a cartridge.[^v06-27]

## Operating System Variables and Flags

The 2068 has to use some System Variables to keep track of where it is:

PPC 23621-23622
:   (Present Program Counter) The line number being executed--not the address of the line number.

SUBPPC 23623
:   (SUB Present Program Counter) Since we can use ":" to put many statements in the same line, the computer has to keep track of which one it's doing at the present time.

NEWPPC 23618-23619
:   (NEW Present Program Counter) The line to be jumped to on a GOTO or a GOSUB.

<!-- p. 61 (pdf 69) -->

NSPPC 23620
:   (New Sub Present Program Counter) The subline to be jumped to on a `GOTO` or a `GOSUB`.

NXTLIN 23637-23638
:   (NeXT LINe) Not the number of the next line but the memory address of the start of the next line. The only way your computer knows where that line starts is to add the line length of its present line to its present position (MSB of Line Length). It won't know what that line number is until it comes to it at which time it will update PPC and SUBPPC. The computer has to know where this line starts in the case of a "false" IF statement which causes it to skip the remaining portion of its present line and jump to the start of the next line.

OLD PPC 23662-23663
:   (OLD Present Program Counter) Return line for a GOSUB or CONTINUE.[^v06-28]

OSPPC 23664
:   (Old Sub Present Program Counter) Return subline for a GOSUB or CONTINUE.[^v06-29]

CONTINUE is a type of error which will continue the program if you have not used an ON ERROR statement. Scroll does the same thing. But, the computer has to know where to continue or come back to after a scroll.

DATADD 23639-23640
:   (DATa ADDress) The address of the last byte used so far in a DATA statement. There is a special routine that hunts through your Basic program from the start for a DATA line as soon as it hits the first READ statement. Once it has found a DATA line it uses as much of it as it needs and stores the address of the last byte it has used here. At the next READ it continues with reading the rest of the data from that line. Should it hit an ENTER character, it hunts for the next DATA line and uses as much of that as it needs. Each time updating the address of the last byte used to DATADD. Of course, RESTORE either resets the address back to 0, the start of PROG if no argument was given, or the argument line.

There is a similar hunting routine for FN which also starts at the beginning of the Basic program looking for the DEF FN that goes with the arguments of the FN found. Once it has found the right definition, it reads the function and resets. This is the reason why DEF FN statements should occur early in a program so the routine doesn't have to search the entire program.

Data statements, on the other hand, are subject to change from one program run to another. The easiest way to effect these DATA line changes is to use high line numbers and MERGE the next set of data lines with the present program. Using identical line numbers erases the old DATA in favor of the new. Using the same RESTORE statement just before the first READ even presets the data search line so it doesn't have to look through the whole <!-- p. 62 (pdf 70) --> program.

## Variable Storage and Search

Kindly turn to page 256 of your User's Manual. One of the big problems in writing machine code is to interface with all the variables from the Basic part of the program. One technique used is to POKE the necessary variables into set data positions in the machine code area. However, it would be easier sometimes to search the VARS TABLE itself for the desired variable. Thus, we have to know how the 2068 stores variables.

All Sinclair based computers store variables in the same manner although the same number may not mean the same variable in the 2068 as it does in the 1000/1500/Z81 machines as they don't use ASCII coded letters and numbers as the 2068 does.

The type of variable, i.e., single character number, multiple character number, array number, string, string array or FOR can be determined by looking at the 3 high bits of the first character. A small "z" on the 2068 is code 122 which already uses Bits 5 and 6. How can they be used for something else? Every small letter uses Bits 5 and 6 so, once again, are not really needed. Unfortunately, using Bit 5 and 6 to designate the type of variable leads to your computer being unable to differentiate between an "A" and an "a"--Caps and small. Since Bit 6 is 64 and Bit 5 is 32, we have to subtract 96 (60H) from each first letter.

Going through the types of variables and their 3 high identifier bits, we get the following table:

```text
                     Bit 7  Bit 6  Bit 5
Single byte name       0      1      1
Multiple byte name     1      0      1
Number array           1      0      0
FOR                    1      1      1
String                 0      1      0
String array           1      1      0
unused sequence        0      0      1
```

*Notes on the table above:* unused sequences.[^v06-30]

We note that Bit 6 is used for all Single letter names. Bit 5 is for single numbers only.[^v06-31] Bit 7 is used for complex variables, i.e., long names, arrays and FOR.

The number variables are always followed by just the 5 bytes of the floating point number (without the 14 slug designator). In the case of long named variables and strings where an indefinite number of extra bytes must be used, the end byte of such a name has 128 added to it to indicate the last byte.[^v06-32] Should you ever PEEK the TOKEN SPELL TABLE (addresses 152-550) you will see the same sort of termination indicator used there.

<!-- p. 63 (pdf 71) -->

Since strings are different lengths, two bytes are needed to indicate their length. Arrays need to know the number of dimensions as well, so that info is also included before the actual array starts. It's these variable lengths that lets the 2068 skip over variables when searching through the table much like it could skip to the start of the next line when reading a Basic program. See page 257 of your User's Manual to see how arrays are arranged.

Hunting for variables: Whenever you use RUN or CLEAR you "dump" (clear out) the old variable table and start a new one at VARS 23627-23628. Unlike some computers, the 2068 must have all variables "initialized", i.e., set to some value...it does not assume a zero if it can't find it. If you set a variable or change it either directly or with a calculation, the first thing the computer does is to try to find if it has already been used by looking for it in the VARS. It's looking for a matching first byte. If a match is found, the address is put in DEST 23629-23630 (DESTination) and corresponding value changed accordingly. If the variable is not found, the DEST is the end of the VARS.[^v06-33] Room is made and the name and value inserted there. Dimensioning a variable or string array automatically kills the old array if any, recovering the space and putting the new dimensioned array at the end of the VARS. Your 2068 is one of only a few computers that allows redimensioning an array...it's the easiest way to clear an array and start over which can be very handy at times.

Double storage: Let A = 23456 in your Basic program has a slug of 6 bytes. When the program runs another 6 bytes are used in VARS for the same number. This seems like a waste of space. Pre-slugging the numbers at a time when the computer hasn't got much to do anyway as that slow human presses those keys can speed up the running of a program by 1/3rd. Checking for syntax at the same time also saves running time--and a lot of harassed nerves. Using the Z80 chip rather than a 6500 series or 8080 saves more time. Tokenizing commands also speeds things up although most computers do this anyway even if you have to type in the whole word. No wonder Sinclair programs run 4 to 5 times faster than Apple programs (Unless you are running CP/M, in which case you are using a Z80 CPU).

If you are really pressed for space there are several ways to save some. This very seldom seems to be a problem on the 2068 but was with a 16k RAM pack on a TS1000.

1. Enter all your most used numbers as double letter variables in direct command mode. But then NEVER use RUN. Start your program with a GOTO statement. Suppose that you have a subprogram you call all the time at line 9000. Do a `LET KZ = 9000` in command mode. Then when you call your routine you `GOSUB KZ`. This uses 7 bytes in VARS but only 2 in the program vs 10 if you used `GOSUB 9000`. Each additional time you used that GOSUB

   <!-- p. 64 (pdf 72) -->

   you will now be saving 8 bytes. But you don't get something for nothing as your program runs a bit slower since it has to look up all these numbers. Therefore, putting them first in the VARS table is important as you get a little speed back. You also lose something in program readability but letting k0 = 0, k1 = 1, k2 = 2...ka = 10...kf = 15, kg = 16, kh = 17 etc. isn't that hard to read and look at all those AT, TAB, INK, TO etc. times one uses small numbers. Each time after the first saves 5 bytes.

2. Use of `VAL "9000"` makes your program more readable and saves 3 bytes per use as the number is not slugged but VAL and the 2 " take 3 of the 6 slug bytes. It slows running time as the strings have to be stripped of quotes and slugged when used.

3. Use multistatement lines--each line saved is 4 bytes saved. (2 for the line number, two for the line length and 1 for enter less 1 for the ":")

4. Store numbers in string arrays, especially as codes if your numbers happen to be integers under 255.

5. Use advanced logic statements rather than page after page of individual IF statements. This includes the use of calculated GOTOs and GOSUBs--another thing your computer allows which others don't.

## Flags

THE CONCEPT: Rather than having to know an address or a number, sometimes the computer just has to know if one or another situation exists. Like, should it use the upper or lower screen, is it checking syntax or running a program, is OVER on or off, or is INVERSE on or off. All these are one or the other situations so the information can be stored in a single bit. Since the CPU can be asked about the status of any bit anywhere, we don't have to use a different byte for each of these on/off or one/another situations but can put as many as 8 in the same byte.

The System Variable Table contains 6 of these flag bytes.[^v06-34] To write effective machine code we need to know what is in these flags. You will note that all these addresses have an X in front of the note indicating "don't change unless you know what you are doing".[^v06-35]

Here is the complete list courtesy the TIMEX 2068 Technical Manual. (by Bit number)

<!-- p. 65 (pdf 73) -->

```text
          IF ON                    IF OFF
23611 FLAGS
     7 Need Interrupt         Check syntax
     6 Number                 String
     5 Keyhit                 No keyhit
     4 Token/slug             Regular character
     3 L mode at cursor       K mode at cursor
     2 L mode at character    K mode at character
     1 To printer             To screen
     0 Suppress space         Don't suppress space

23612 TV FLAGS
     7-6 not used
     5 Clear screen when key pressed
     4 Auto list
     3 Echo input from keyboard
     2 not used
     1 Output line for edit or number for string
     0 Use lower screen       Use upper screen

23658 FLAGS 2
     7-6 not used
     5 Delete key repeat
     4 Retype possible after syntax error
     3 Caps lock on
     2 Inside string when doing keyboard LIST CHAR
     1 Printer buffer not empty
     0 Automatic listing on screen

23665 FLAG X
     7 Line                   String line
     6 Need number
     5 Need input
     4-3-2 not used
     1 Variable not           Variable found
     0 Flexible length needed

23697 Print FLAG
     7 Paper complement of ink permanent
     6 Paper complement of ink temporary
     5 Ink complement of paper permanent
     4 Ink complement of paper temporary
     3 Invert (INVerse) permanent
     2 Invert (INVerse) temporary
     1 OVER (XOR) permanent
     0 OVER (XOR) temporary

23617 MODE
     1 G mode
     0 E mode                 K or L mode
```

*Notes on the table above:* FLAGS bit 7;[^v06-36] FLAGS bit 4;[^v06-37] FLAG X bit 7.[^v06-38]

<!-- p. 66 (pdf 74) -->

[^v06-1]: (unverified) MOVE "name,bin" is disk-interface BASIC; in the stock ROMs MOVE is only a keyword stub, so the syntax depends on the disk system's own ROM, which the library does not cover.

[^c03-4]: Corrected. The original printed "POKE 23730 and 23730"; RAMtop is the two-byte variable at 23730-23731, as the heading and the next paragraph state.

[^c03-5]: Corrected. The original printed line 10 as `10 PRINT X;" "; PEEK X; TAB 11; CHR$ PEEK X`, without the second `;" "`; the author's walk-through on page 50 includes it, and only with it does line 10 take the 32 bytes that put line 15 at 26773 (the printed form takes 28 and would put line 15 at 26769).

[^c03-6]: Corrected. The original printed "166/104" for 26783 and "167/104" for 26784; 166 + 104 × 256 = 26790 and 167 + 104 × 256 = 26791, while with VARS starting at 26780 the value bytes are at 26783-26784, whose own addresses are 159/104 and 160/104 (the later 181/104 = 26805 follows the same rule).

[^v06-2]: Library note: the 2 is SUBPPC + 1, the number of the statement after the FOR (FOR is statement 1), which is where NEXT jumps back to; it has nothing to do with TO. FOR stores the looping line LSB first and then `LD D,(IY+SUBPPC) / INC D` as the statement byte; see disassemblies/ts2068_home_rom_U16_stock.txt (ROM after $1CA9).

[^v06-3]: Library note: syntax checking tests form only (brackets, quotes, separators, the kind of argument each keyword takes); in syntax mode (FLAGS bit 7 = 0) expressions are parsed but not evaluated, so a TAB above 31 or an AT outside the screen is accepted on ENTER; AT out of range gives an error when the line runs and TAB is taken modulo 32; see docs/ts2068_system_variables.md (FLAGS bit 7, INTPT).

[^v06-4]: Library note: this holds for the line number at the head of each program line; wherever else the ROM keeps a line number (PPC, NEWPPC, E PPC, OLD PPC, the looping line of a FOR variable) it is stored LSB first. (The mantissa of a full floating-point number is also stored most significant byte first.) See docs/ts2068_system_variables.md.

[^v06-5]: Library note: LIST SP holds the machine-stack pointer saved when an automatic listing starts (`LD (LISTSP),SP` at ROM $14E1), so the ROM can abandon the listing with `LD SP,(LISTSP)` when the screen is full (ROM $0790 routine); the position of the ">" current-line cursor comes from E PPC; see docs/ts2068_system_variables.md (LISTSP).

[^v06-6]: Library note: the meaning (where the "?" goes) is right, but the name has nothing to do with the IX register, which the ROM never loads from X PTR; X PTR also saves CH ADD during READ and INPUT (`LD HL,(CHADD) / LD (XPTR),HL` in the RST $08 error entry); see disassemblies/2068_DEFS.ASM (XPTR).

[^v06-7]: Library note: ERR C is written only when an ON ERR is active (ERRLN bit 7 set): after the HALT at ROM $0E8D the ROM copies PPC to ERR C, SUBPPC to ERR S and the report code to ERR T on that path only; the line number printed in the report comes from PPC, not ERR C; see docs/ts2068_system_variables.md (ERRC).

[^v06-8]: Library note: like ERR C, ERR S is set (from SUBPPC) only on the ON ERR path after ROM $0E8D; the statement number printed in the report does not come from it.

[^v06-9]: Corrected against the ROM. The original printed "DF CCL 23684-23685"; DF CCL is at 23686-23687 ($5C86): the lower-screen path of STTVCU stores it with `LD ($5C86),HL` (22 86 5C at ROM $060F), while 23684-23685 ($5C84) is DF CC, written by the upper-screen path at ROM $0603; see docs/ts2068_system_variables.md. Both hold the display-file address of the next print position, not of the last character printed.

[^c03-7]: Corrected. The original printed "DF SZ 23659-23660"; DF SZ is a single byte at 23659, and 23660-23661 is S TOP, listed just above.

[^v06-10]: Library note: SCR CT does not set how many lines are scrolled; it is a countdown, decremented at every scroll (`DEC (IY+$52)` at ROM $07C3), and when it reaches zero the ROM stops with "scroll?" and reloads it, so POKE 23692,255 (or any value above 1) postpones the prompt; see docs/ts2068_system_variables.md (SCRCT).

[^c03-8]: Corrected. The original printed line 40 (and the prose that follows) as `RANDOMIZE USER 2361`, and line 35 as `PEEK y`; the BASIC function is USR (as in `RANDOMIZE USR 63200` on page 44), and `PEEK y` reads a ROM byte at the entered value (0-254), whereas `PEEK x` echoes the byte just POKEd at x, which is what an entry program displays.

[^v06-11]: Library note: the stock ROMs total 24,576 bytes (16K HOME ROM plus 8K EXROM); see docs/ts2068_memory_map.md.

[^v06-12]: (unverified) The library does not reproduce the Technical Manual's Appendix A, so its page numbers cannot be checked; the label itself matches the ROM, where PHLAF at $004F (`POP HL / POP AF / EI`) is the tail of the maskable-interrupt routine.

[^v06-13]: Library note: LAST K keeps its code until another key (or a repeat of the same key) overwrites it; releasing the key does not clear it, and reading it does not clear it either: the ROM marks a new key by setting FLAGS bit 5 (KEYHIT, ROM $032E) and marks it used by resetting that bit; see docs/ts2068_system_variables.md (FLAGS).

[^v06-14]: Library note: there is no busy-wait loop; the keyboard routine loads REPDEL into a per-key counter in K STATE (ROM after $0317), the 1/60 s interrupt decrements it once per scan (ROM $0336 onward) and the key repeats when it reaches zero, the counter then being reloaded from REPPER; the program keeps running meanwhile.

[^v06-15]: Library note: K DATA has nothing to do with CAPS SHIFT plus SYMBOL SHIFT; it holds the colour number that follows an INK/PAPER-type control code typed from the keyboard, so the editor can return it as the second byte on the next read (ROM $0C6B stores it, `LD A,(KDATA)` returns it); see disassemblies/2068_DEFS.ASM (KDATA).

[^v06-16]: Corrected against the ROM. The original printed "or 227 for READ if in the E mode" and ended the paragraph "CAPS and A can't ever give you FREE."; in E mode any shift, CAPS or SYMBOL, selects the shifted E-mode table (ROM $037F: `INC B / JR Z` takes the unshifted table only when no shift is held), and the byte for A in that table is $7E = 126, the FREE token (ROM $0268); 227 (READ, ROM $024E) is E mode with no shift; see docs/ts2068_tokens_and_keyboard.md.

[^v06-17]: Library note: the column/line order is right, but ECHO E holds the lower-screen position of the end of the input buffer, updated as each character is echoed (STTVCU at ROM $0607 stores it together with S POSNL), not the start of the input area; see docs/ts2068_system_variables.md (ECHOE).

[^v06-18]: Library note: PR CC holds the address of the next free position in the printer buffer at 23296 ($5B00); the ROM stores the whole address (`LD (PRCC),HL` at ROM $0616), so the high byte, always 91 ($5B), is in 23681 rather than in a CPU register; see docs/ts2068_system_variables.md (PRCC).

[^v06-19]: (unverified) Which ports the SCLD itself decodes is a hardware detail the ROMs cannot settle; the stock ROMs use only ports F4H, F5H, F6H, FBH, FEH and FFH (see docs/ts2068_memory_map.md, I/O Port Map).

[^v06-20]: Library note: the 2040 is not a parallel device addressed through 8 ports; the ROM drives it through the single port FBH (251) with the ZX Printer protocol, reading the encoder and status bits and sending the dots one at a time on the stylus bit (`OUT ($FB),A` / `IN A,($FB)`, ROM $0A32-$0A7A); see docs/ts2068_memory_map.md (I/O Port Map).

[^v06-21]: (unverified) That the 2040 also answers at x0-x3 and x8-xB through partial address decoding is a property of the printer hardware; the stock ROM addresses it only at FBH.

[^v06-22]: (unverified) The Micro-drive (F7H), Modem and Centronics (7xH/8xH) assignments are for third-party or never-shipped peripherals that the stock ROMs never address.

[^v06-23]: Library note: interrupts, and with them the keyboard scan, are off during LOAD, SAVE and VERIFY (`DI` in EXROM R_TAPE at $00FC and in the save routine); the tape routine itself reads the SPACE/BREAK row from port FEH at every edge test (`LD A,$7F / IN A,($FE) / RRA / RET NC` at EXROM $0193) and aborts if it is pressed; see disassemblies/ts2068_exrom_U20_stock.txt.

[^v06-24]: Library note: BASIC OUT is a raw port write (`CALL $1F0F / OUT (C),A`) and never calls a ROM video-mode routine; OUT 255,1 does switch the hardware, but nothing has prepared a second display file at 24576 ($6000), which holds the machine stack and the dispatcher copy, and VIDMOD is not updated, so the picture is garbage. The ROM's own defect is separate: dispatcher service $08 (CHNG_VID) is mis-targeted in the stock EXROM, so the second display file must be opened by calling CHNG_VID at EXROM $0E8E; see docs/ts2068_video_and_cartridges.md and docs/ts2068_dispatcher.md.

[^v06-25]: Library note: each 2-byte STRMS entry is not a number and a letter but a 16-bit offset (LSB first), plus 1, of the stream's 5-byte channel entry in the channel table; 0 means the stream is closed; the setup values at ROM $11C1 are the words 1, 6, 11, 1, 1, 6, 16; see docs/ts2068_system_variables.md (STRMS).

[^v06-26]: Library note: the channel table starts at 26688 ($6840, set into CHANS by NEW at ROM $0D9F); 26688-26708 hold the four 5-byte channels and the 128 terminator, 26709 is the byte DATADD points to, and PROG starts at 26710; 26660 ($6824) lies inside the dispatcher code copied to $6200-$682F (ROM $0E18), so it is not a channel area; see docs/ts2068_memory_map.md.

[^v06-27]: Library note: CURCBN (CRCBN in the library) holds the bank number in which the current channel's routines live; 0 and 1 mean the HOME/DOCK routines are called directly, and 2 and up route the I/O through an expansion bank (`LD A,(CRCBN) / CP $02` at ROM $11F2); there is no separate bank channel lookup table, and running from a cartridge is not what sets it; see disassemblies/2068_DEFS.ASM (CRCBN).

[^v06-28]: Library note: OLD PPC is the line to CONTINUE from; GOSUB keeps its return line and statement on the machine stack (GO_SUB pushes PPC and SUBPPC + 1), not in OLD PPC; see disassemblies/2068_DEFS.ASM (OLDPPC).

[^v06-29]: Library note: OSPPC is used by CONTINUE only; GOSUB's return statement goes on the machine stack (see the note on OLD PPC); see disassemblies/2068_DEFS.ASM (OSPCC).

[^v06-30]: Library note: 0 0 0 is unused as well; no variable's first byte has the three high bits 000 or 001 (the VARS end marker 128 has 100 with a zero letter field).

[^v06-31]: Library note: number arrays (100) have single-letter names but bit 6 reset, so bit 6 does not mark single-letter names; bit 5 is set for every numeric variable that is not an array (single-letter, long-named and FOR); bit 7 marks arrays, long names and FOR variables.

[^v06-32]: Library note: this is true only of long variable names (the last letter has 128 added); a string variable's name is a single letter and its end is given by the 2-byte length that follows, as the next paragraph says.

[^v06-33]: Library note: when the variable is not found, FLAGX bit 1 is set and DEST is left pointing at the variable's name in the BASIC line (the pointer returned by the search, ROM $1B93-$1BA9); the new variable is then built at the end of VARS; see docs/ts2068_system_variables.md (FLAGX).

[^v06-34]: Library note: these are the six listed below; the 2068 also has ARSFLG at 23750 ($5CC6), a flag byte for AROS cartridges; see disassemblies/2068_DEFS.ASM (ARSFLG).

[^v06-35]: (unverified) The Owner's Manual's system-variable table and its notation are not in the library.

[^v06-36]: Library note: FLAGS bit 7 has nothing to do with interrupts; it is INTPT: set means interpret (run) the line, reset means syntax-check only; the ROM sets it before running a line (`SET 7,(IY+$01)`, ROM after $0E55); see docs/ts2068_system_variables.md (FLAGS) and docs/technical-manual/03-system-software-guide.md.

[^v06-37]: (unverified) The library does not settle bit 4: the ROM sets it in NEW, docs/ts2068_system_variables.md calls it "Token mode on (TS 2068 only)" and disassemblies/2068_DEFS.ASM calls it an unknown flag used all over the place.

[^v06-38]: Library note: FLAG X bit 7 set means INPUT LINE is in progress, reset means ordinary INPUT; see docs/ts2068_system_variables.md (FLAGX, LINPLN).
