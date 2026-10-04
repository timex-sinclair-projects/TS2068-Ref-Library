<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 23–34. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 2: Memory Mapping.*
*[← previous](02-chapter-01-numbers-and-counting.md) · [book README](README.md) · [next →](04-chapter-03-screen-printing.md)*

---

<!-- p. 23 (pdf 31) -->

# Chapter 2: Memory Mapping

## Types of Memory

It's about time to find out where things are stored in our computer. Your 2068 has 64k of RAM (Random Excess Memory). This is the maximum amount of memory it can address at any one time.[^v04-1] If you recall from the last chapter, the largest number your computer can handle in two byte word form was 65535 (adding zero makes 65536 bytes). That little k after the 64 means kilo or 1000 (from the metric system of measurement). Well, 64,000 isn't 65536. In computerese it is. The "k" is really 1024 bytes long--which happens to be the closest power of 2 (2^10) to 1000. 1024 x 64 is 65536.

RAM can be written to or read from. That means it can be changed as you desire. It would soon fade, much like a TV tube picture does, if it wasn't constantly refreshed to keep it holding its memory. Naturally when you turn the computer off all RAM memory is erased.

Bank Switching: One of the special features of the 2068 is its ability to switch to a different "bank" of memory and use that instead. In fact, it can be programed to switch to anyone of 256 different 64k banks if you want to add that much more memory to the back of the 2068. This would give you a whopping 16,777,216 bytes of memory.[^v04-2] Banks are further subdivided into eight 8k CHUNKS. These chunks are labeled 0 to 7 like the bits.[^c02-2]

What does a 64k RAM look like physically? Generally manufacturers make memories 64k long and only 1 bit wide. This means you have to use 8 of these chips side by side in parallel to get your 8 bit byte wide memory. Your computer uses an 8 bit wide data bus (8 lines side by side) to get data to and from memory. It also uses a 16 bit address bus (16 lines) to tell each memory chip what address it wants read or written to. Thus each memory chip will have all 16 address lines attached to it but only one data line from the data bus. Now since we have to read and write to RAM each chip further has to have a READ line and a WRITE line running to it. And of course we need a refresh line, a power line and a ground line. Generally the address lines are made to run from chip to chip underneath them. The whole assembly would look something like the diagram on the next page.

The appropriate signal goes down the address lines, another signal goes down either the read or write line telling the chip to

<!-- p. 24 (pdf 32) -->

*[Diagram: eight memory chips side by side. Each chip has one line running up to a separate line of the "Data Bus" at the top; a set of horizontal lines labelled "Address Bus" runs underneath all eight chips, each chip tapping every line; below these are horizontal lines labelled "Rd", "Wr" and "Power", also connected to every chip.]*

send (read) or change (write) the memory address given. In the case of write, the data lines contain the material to be entered into memory. This kind of processing is called parallel processing as all 8 bits are handled at once. It is obviously at least 8 times faster than the one-after-the-other handling of bits that your tape recorder uses (serial processing).

In fact, the tape recorder is even slower as what it really does is record 2 tones--one means zero, the other 1. They are an octave apart in frequency. It's the switching of tones that further limits the transmission speed of the tape recorder and lowers it down to only 1200 baud (bits/second).[^v04-3] The T/S 1000 and the T/S 1500 are even worse at 300 baud. Those of you who have dot matrix printers or disk drives will have ribbon cables for a "centronics" parallel type port sending 8 bits in parallel to the device at 8X the baud rate. In addition, the signal is electrical and not sound so can be a lot faster. No wonder disk drives load and save programs so much faster.

Okay, if RAM is erasable every time we turn the computer off, where are the permanent instructions kept? They are kept in a different type of memory unit called ROM (Read Only Memory). Your computer has two ROM chips. One is 16k by 8 bits and the other is 8k by 8 bits. As the name says, we can't write or change this memory, only read what is there. It is permanent, errors and all and, of course, doesn't erase when the computer is turned off. Because it can't be changed we can say that ROM is "etched in stone" more or less.

Before discussing ROM further, there is a 3rd type of memory unit you may have heard about called EPROM (erasable programable ROM). It is essentially a ROM (permanent) until you erase it with ultraviolet light and then "burn" in a new program. The burning process is done by using a higher voltage electrical current to set the memory. Your computer can't do this as it takes a special device. New units are electrically erasable.. sometimes called EEPROMs.

## The ROM Memory Banks

Each bank of memory is given a number which corresponds to its port number.[^v04-4] The "home" or main RAM is bank #255. The first 16k <!-- p. 25 (pdf 33) --> of the home RAM is "shadowed" by the 16k main ROM. This means that the ROM instructions are for all practical purposes sitting in the lower 2 chunks of the home RAM--only it still can't be changed.[^v04-5]

Only when you are using your tape recorder to SAVE, LOAD, or VERIFY a program or change VIDEO MODE do you use the 8k EXTENDED ROM which is located in Bank #254.[^v04-6] There is about 2k of free space in the extended ROM.

Now, the cartridge slot, under the door at the right of your keyboard, uses Bank #0 known in computerese as the "dock" bank. It is only these 3 banks that can be called by the 2068 as it comes from the factory...all the rest take special programming.

## Extended ROM

The lowest 4k of the extended ROM contain the cassette routines and the CHANGE VIDEO routine. You can't use the change video routine as it is as it contains a fatal error.[^v04-7] In fact all the big errors in your computer occur in the extended ROM. The rest of the extended ROM contains the Function Dispatcher and Bank Switching routines which are programs to assist the computer in transferring data between banks and call different banks. Unfortunately, some sections are so full of errors that they are useless. If you have the "TIMEX 2068 TECHNICAL MANUAL" the errors are listed and can be corrected--or you can read further as a program to correct the errors is given later on in this book. The reason you can correct this routine is that it is not used from extended ROM but is written to 25088 of the home RAM which is then rewritable. Don't use the Function Dispatcher and Bank Switching routines without making these corrections. Unfortunately, these routines have to be switched to Chunk 7 of home RAM[^v04-8] when using dual screen modes and there are other mistakes which reintroduce more errors each time the shift is made.[^v04-9] These also must be corrected out each time.

Since the Function Dispatcher and Bank Switching routines actually get transferred to home RAM, there is only 4k that is added to the 64k of home RAM to give you 68k--which is where the 68 comes from in the name of the computer.

## The Cartridge Bank

When you turn your computer on it takes a few seconds to set itself up before you get the copyright notice. In that time it checks to see if you have put in a cartridge by checking for setup data at the start of chunk 4 (32768) to see if a LROS (Language ROM Orientated Software)--written in machine code, or an AROS (Application ROM Orientated Software)--written in Basic, is present.[^v04-10][^v04-11] AROS cartridges can only use the top 32768 bytes of their ROM as they need the routines, display file, etc. of lower memory to run the Basic. With LROS you can use everything but chunk 3.[^v04-12] However, many LROS cartridges also reserve chunk 2 <!-- p. 26 (pdf 34) --> which contains the display (TV) file.

**Don't pull a Bill!**

It can be very expensive. Your manual says always to turn off the computer before you plug or unplug anything and they mean it. If you look at the spacing of the contacts, it doesn't take much misalignment to contact the wrong connections. There are voltages on some of those lines and 5 volts is enough to blow an IC (integrated circuit) without difficulty. Poor Bill, one of our S.M.U.G. members, blew his whole computer when he tried plugging in his AERCO Printer Interface without first turning off the computer.

The same holds for plugging and unplugging cartridges into the slot...only more so. If you are lucky enough to get the cartridge in place without blowing anything, the computer won't know it's there until you reinitialize it. It only checks for the cartridge upon turnon. It then knows it's there and uses the ARSBuffer to store its data and call the next program line. You can restart the computer without turning it off by doing the command, `RANDOMIZE USR 0`.[^c02-9] The computer starts reading instructions at the beginning of bank 255.

## The Memory Map of Home RAM

We have discussed everything else except the home RAM bank or the "working" bank. This one is going to get quite complex so it is time to open your Operators Manual to page 254. (See how much information is stored in those appendices!) There you have 2 maps of the home RAM. The left one is for the single screen (normal) mode, the right for the Dual screen modes.

Now, make some additions to the left map. On the left of the line separating Home ROM from Display File 1 put 16384-4000H (That's the decimal-hexadecimal notation for the start of the Display File.) Draw a line 3/4 up the display file and write above that line ATTRIBUTES. To the left of the line you drew put 22528-5800H. To the left of the next 4 hex numbers add the decimal equivalents in ascending order 23296, 23552, 24576, 25088. Opposite the line below ARSBUF write 26688-6840H. Opposite the line below CHANS write 26688-6840H.[^v04-13] Opposite the line below PROG write 26710-6856H. Cross out that 6840H as that's wrong. In the space between STKEND and RAMTOP write SPARE. In the space above that write YOUR CODE. Opposite UDG write 65368-FF58H. At P-RAMT write good old 65535-FFFF.

On the right map write 31488 opposite 7B00H. Opposite F7C0H write 63424. Opposite F9C0H write 63936. On the bottom of the page write RAM RESIDENT CODE = FUNCTION DISPATCHER & BANK SWITCHING.

Now you have a useable Memory Map. Making a copy of it and keeping it between plastic is a good idea although not quite as use<!-- p. 27 (pdf 35) -->ful as the other pages I told you to copy earlier.

## Chunks 0 and 1

Since every 2000H is 8192 bytes or 8k or 1 chunk, you can see that the 2 lowest chunks of Home RAM are used by the operating code instructions to run Basic programs. We will be learning exactly what is in there a little later in the book. At the present time there is only one thing I want to add--the CHARacter Table is at 15616-3D00H. This is the table of pixels that the computer uses to write the TV screen. Each character has 8 bytes worth of pixels starting with character 32 (space) and ending with character 127 (copyright). There are no pixel bytes for the graphic symbols as the computer generates them from the graphic codes for these characters themselves which, incidentally, takes less space than the pixel bytes themselves. It was quite a shock for me not to find any as I started writing my first machine code program for the 2068.

## Chunk 2--The Display File

Is really the TV file. You learned in Basic that the "normal" TV mode prints 32 characters per line (0-31) and has 22 lines (0-21). But you have to add the lines on the bottom of the screen (2 more) so you really have 24 lines.

From your Basic UDG (remember User Defined Graphics) you learned that a character is made up of 64 pixels arranged in an 8 across by 8 down matrix. They were stored in 8 across lines. This is called pixel mapping and allows us to design our own characters be they letters, symbols or pictures. In the T/S 1000 we used character mapping--the display file only contained one byte per character. That wouldn't have been so bad as long as we could have told the computer to switch to a different character pixel table but we couldn't even do that. Additionally, the Z80 CPU (Central Processing Unit) had to stop every 1/60th of a second to refresh the screen. To do this it looked at the display file, then found the pixels in the character table and sent them to the TV. No wonder things were SLOW. We could tell it to forget about the screen and just calculate by using FAST. In the 2068, the pixels are already arranged for another chip to send to the TV screen so there is no need for slow or fast.

Now, 32 characters per line times 24 lines times 8 pixel bytes per character is a total of 6144 bytes just to print the TV screen. On top of this we have to add one attribute byte per character or 32x24 = 768 attribute bytes. That's a grand total of 6912 bytes. Contrast this to the 768 bytes of screen plus 32 end of line bytes for 800 bytes for the T/S 1000.[^v04-14] At least they fixed one thing on the 2068--the Display File is in a fixed location, not floating above the Basic program. It also had the nasty habit of collapsing if less than 3.5k of free memory remained-- remember? The T/S1000 was never made to handle more than 32k of memory in its original design...others have found <!-- p. 28 (pdf 36) --> ways around this limitation.

### The 64 Characters Per Line Screen

Going to the dual screen mode you have to use the right map and get two display files. But I'll warn you it isn't what you expect. Yes, each character has 8 pixels but DISPLAY FILE 1 holds all the EVEN characters and DISPLAY FILE 2 all the ODD characters as defined by TAB. Therefore, every other character is in DISPLAY FILE 1 and every other in DISPLAY FILE 2. In addition to the errors in the Change TV Mode routine which doesn't allow it to work, we have another surprise for you. Your computer only supports DISPLAY FILE 1. You have to write machine code routines to make CLS, TAB, AT, LIST, PRINT and COPY work from screen to screen.

### The 80 Characters Per Line Screen

This is even worse. You have to squeeze 16 more characters into a line. In 64 column mode you had 64x8 or 512 pixels across the screen. Dividing by 80 gives you 6.4 pixels per character. Well, fractions of a pixel don't work so we have to round down to 6 and then redesign the characters to 5 pixels wide, reserving the 6th pixel as a space between characters. Let's see, 80x6 is only 480 pixels per line. 32 are left over. Divide these 32 by 8 gives 4 bytes worth. To center we need 2 empty bytes in front of each line and 2 empty in back. We have to start with DISPLAY FILE 1 position 1 (position 0 being the first). Now, 6 bits of character 1 go into position 1 of Display File 1 together with the first two bits of character 2. Display File 2 position 1 gets the last 4 bits of character 2 and the first 4 bits of character 3. Back to Display File 1 position 2 for the last 2 bits of character 3 and all of character 4. Start Display file 2 position 2 with character 5.... It's going to be some time before you write a program that can do that. One only has 8 ink-paper colors available in dual screen mode as the attribute file isn't used. The whole screen has to be the same two colors.

## The Hi-Res Graphics Screen

Display File 1 holds all the pixels for a 32X24 normal screen but Display File 2 has an attribute for each pixel byte. This still limits you in doing beautiful art. You have only one ink and one paper color per 8 pixels and they are not in a square but a line. Again, it doesn't work without machine code.

I guess all these things were to be additions to the 2068 for future expansion...there still is about 2k of empty space in extended ROM. Some of the techniques are discussed in the "TIMEX 2068 TECHNICAL MANUAL". A beautiful plan but no followup. So we have to do it ourselves. We are, slowly but surely, as that is what users groups are all about.

<!-- p. 29 (pdf 37) -->

## The Printer Buffer

The printer buffer is only used for the T/S 2040 printer. It is only 256 bytes long which is just long enough to send 32x8 bytes of pixels--just long enough for one line. If you have ever stopped your printer in midline you will see that that is the way it works--one pixel line across the paper at a time. Dot Matrix Printers generally use their own buffers which makes this space available for other uses--like the printer driver routine itself as OLIGER does. Like AERCO, HUNTER, and WOODS, just to mention a few more, he is a 3rd party (not TIMEX related) supplier of hardware and programs. Much of what we have comes from these dedicated geniuses.

## The System Variables

If you were wondering where I was getting all those numbers from that I have been spouting about in this chapter, it's from this table located on pages 262-265 of your Operator's Manual and which I asked you to make copies of.

It is this table of 746 bytes (23756-24297 are reserved for additional variables) that helps the computer keep track of almost everything it needs to know.[^v04-15] It can be PEEKed at anytime--inside programs and/or in command mode. Unfortunately, it's written in computerese and takes a little knowledge and interpretation to figure out just what some of those abbreviations mean. Then you are still at a loss unless you have a copy of the "TIMEX 2068 TECHNICAL MANUAL" or "The Timex/Sinclair 2068 ROM Manuscript" to help you out. The "Technical Manual" was available from Timex--Products Service Center, Box K, 7004 Murry St., Little Rock, AK 72203 for $25--the same place you used to send your computer to for repairs. HOWEVER, since then they have changed the repair outlet to: T/S Users Group of Cincinnati. Call (513) 271-5575, Jack Roberts before sending. The Manuals are available in limited supply from them. If they run out, there will be a slight delay for another printing.

"The Complete Disassembly of the 2068 ROM" is available through S.M.U.G. (Sinclair Milwaukee Users Group), Box 101, Butler, WI 53007. Price is $16.95 + $2.50 S&H. Wisconsin residents kindly add 5% sales tax.

We discuss the System Variables in full detail in Chapter 3 as it's quite an extensive discussion. Let's move on to the rest of the memory map.

## Machine Stack (24576-25087)

I should say from 25087 to 24576 as the stack works from the top down. 512 bytes long, it is this section of memory that the CPU uses to store numbers, always in pairs, for further use. It also uses this stack to store data that it will need when it is going to transfer them to another bank of memory where it will need <!-- p. 30 (pdf 38) --> them when working on routines there.

A simple example: In Basic, whenever you are in a routine and want to call a SUBROUTINE you do a `GOSUB`. Since the variables you have been using are stored in the variables table, you don't have to save any numbers for future use as they are all stored there and updated as needed. All that has to be remembered is the return address...that address to come back to when the return statement is encountered in the subroutine...this is done in Basic by updating the OLD PROG LINE and SUB OLD PROG LINE.[^v04-16]

In machine code it is more primitive. A machine code routine may CALL (equivalent to a GOSUB) another routine. If one has numbers in the various registers that one has to save to continue with the routine after the RETURN from the CALL, then a convenient way of saving the numbers is to PUSH them onto the stack before making the CALL. They are always PUSHed onto the stack in pairs like: AF, BC, DE and HL (or IX and IY). If you don't need the values anymore to continue after the CALL you don't have to PUSH them. Finally, when you make your CALL, the CPU itself PUSHes one more set of values onto the stack--the address of the next statement, i.e., the RETURN address to come back to when it sees the RETURN statement. The CPU will POP the bottom two numbers off the stack at this point and use that as a RETURN to where it came. Of course you may use the stack to store numbers while in a subroutine BUT make sure you POP them off before the CPU gets that RETURN statement or you RETURN to whatever address that set of unPOPed numbers would make.

You have just met your first assembly instructions PUSH, POP, CALL and RETURN. As I remind my students so often, MAKE SURE YOUR PUSHES EQUAL YOUR POPS. POPing too many values is just as bad as not POPing enough.

The stack works from the TOP DOWN. A special register called the stack pointer is set with the starting address 25088.[^v04-17] As a PUSH or CALL is encountered the first value goes into 25087 and the next value into 25086 as the SP (stack pointer) is DECREMENTED (decreased by 1) twice from 25088 to 25086. As the POP or RETURN is received, it reads out the value at the stack pointer and the one above it to the appropriate registers, and INCREMENTS (increases by 1) the value of the stack pointer twice. NOTE: The values are still in those addresses and will only be overwritten by the next PUSH or CALL statement. This important fact can sometimes be useful in programming.

## Ram Resident Code (25088-26688)

Better known as the Function Dispatcher and the Bank Switching routines. It is a disgrace to TIMEX as it is full of errors. Chapter 10 discusses the Function Dispatcher and Bank Switching routines in full detail after it shows you how to correct it. Let it suffice at this point just to mention that it is this set of routines that allows the 2068 to switch from one bank of mem<!-- p. 31 (pdf 39) -->ory to another and call routines in other banks. It is also used to run all Cartridge programs.

## ARSBUF (26688-?) AROS Line Buffer

No space is normally reserved for the AROS LINE BUFFER.[^v04-18] When a Cartridge is inserted under the front door of the computer and the computer senses that an AROS type cartridge is present, it moves up CHANS to provide room for a buffer. When running an AROS cartridge with Basic in it, the computer finds the next line to be executed in AROS ROM and copies it down to this buffer. It then switches back to the home ROM and executes the line. If the line has a READ statement in it, the computer goes back to the DOCK bank (0) and finds the appropriate DATA line and copies that to the ARSBUF as well. Since there is no program located in the PROGram part of the home RAM when running a cartridge, the computer further starts the VARiable table at 32553.[^v04-19] It does NOT float upwards so care must be taken not to write too long an AROS Basic line or an AROS Data line as you may start over writing the VARS table.

## CHANS (26688-26708) Channels Table

Without a cartridge, the CHANNELS TABLE resides here.[^v04-20] With a cartridge, it is moved up depending upon the length of the AROS line being copied.[^v04-21] It is this table that is consulted by the STREAMS to find out how to route data--to the screen or the printer.

## PROGram (26710-?)

The start of the Basic Program. It extends upward as far as necessary to accommodate the full length of the program. This value can always be found by PEEKing PROG 23635-23636.

## VARS (??) Variable Table

It always immediately follows the PROGRAM and initially starts without anything in it. As the program is run, each new variable is added at the end. The table expands upwards so room must be left for this expansion. UNLIKE most other computers, your 2068 (as well as all other SINCLAIR computers) save the VARS with the program when SAVING (tape) or MOVING (disk) a program. This allows starting a program in midstream with a `GOTO` statement. One can also write variables directly to this table by entering them in the COMMAND mode. Many programs which are cramped for space do this with constants and "set" strings. Doing a `CLEAR` or a `RUN` always starts by clearing out the variable table before running the program which would be disaster for a program with set constants in the VARS table.

How variables are stored in this table (their codes) is discussed in Chapter 4. The start of the VARS table can always be found by PEEKing VARS 23627-23628.

<!-- p. 32 (pdf 40) -->

## E Line (??) Edit Line

When you are typing in a program line it appears on the bottom of the screen and is written to this space, the space expanding as you type in more of the line. When you finally hit ENTER, the line is checked for syntax errors, the numbers are slugged and if okay and there is a line number, is inserted in the proper line number sequence of the program. If no line number, the line is immediately executed.

Should you LIST your program and use EDIT to bring a line down to the bottom screen for changes (Editing), it again goes to this area as well. Any changes you make are executed and upon ENTER the above sequence again takes place only this time the old line is replaced by the new line which may be shorter or longer than the old line. If you changed the line number, the new line may replace another line with that number or become a new line addition to the program.

After ENTERing or executing a line, E LINE is erased and the space it occupied recovered. E LINE can always be found by PEEKing 23641 and 23642 in the usual manner.

## WORKSP (??) Workspace

The workspace floats above E-LINE and is used by the computer to ENTER the data you are typing in from an INPUT (Rather than putting it in E-LINE and processing it as a line). When the Workspace is active, E-LINE has collapsed down to nothing.[^v04-22] Workspace collapses to nothing when not in use as well. Workspace can be found by PEEKing 23649-23650.

## STKBOT-STKEND (??)

These two areas are used by the computer to do floating point calculations. They also collapse to zero space when not in use. Since the floating point calculator uses Forth notation by pushing numbers onto a stack (this time a 5 byte wide stack and right side up), STKBOT keeps track of the start of the stack and STKEND being the top working end of the stack. Although calculations can only occur between the two top numbers on the stack, the stack can be preloaded with as many numbers as necessary with calculations then taking place in a group rather than push a number, do a calculation, push another number etc. More is said about this in Chapter 8 where we actually go through a calculation using the stack. Again, these areas float on top of the E-LINE. Their location can be found at anytime by PEEKing STKBOT 23651-23652 or STKEND 23653-23654.

## Free Memory

STKEND is the end of the computer used space--above this resides any extra memory that is still left over...remember that the <!-- p. 33 (pdf 41) --> computer uses more memory as the program is RUN as it is building a variable table as it goes along. The available free memory can drop very rapidly if you start DIMensioning variables. E-LINE, WORKSP and the F. P. stack require some space but can usually get by with about 2-400 bytes.

The amount of Free Memory at the moment, is always given by FREE. It is calculated as the space between STKEND and RAMTOP.

## Ramtop

Ramtop is the upper limit of memory available to a Basic Program as you set it. Should your Basic program expand to the point where it needs more memory than that to continue functioning, like adding another variable to the variable table, you will get an OUT OF MEMORY error code. Upon setup, RAMTOP is set at 65367 leaving 168 spaces above it for USER DEFINED GRAPHICS (UDG). Anything above Ramtop is NEVER saved with a Basic program. It, however, can be saved as code.

Ramtop can be set anywhere you like. You can thus reserve space for your machine code program and always be assured that it is never overwritten by the Basic program by lowering Ramtop. This can be done in two ways. The simplest is just to do a `CLEAR` followed by the address you want Ramtop set to. Your computer puts a marker at this point so this address is not available for your code but the one immediately above is.[^v04-23] The trouble with `CLEAR` is that it also clears the variable table which you may not want done. The way around this is to POKE 23730 and 23731 with the low and high values of the address respectively. PEEKing these addresses obviously tells one where Ramtop is set.

Saving things above Ramtop must be done with another save as it is not saved with a Basic program. Both your code and the UDG can be saved at the same time using: `SAVE "name" CODE starting address, length`. "name" is any name up to 10 characters in length and is usually the same name as the Basic program. Starting address is one above your Ramtop setting and the length is calculated from there to the end of memory at 65535.

## UDG (65368-65535) User Defined Graphics

Your own designed symbols as you learned in Basic. You are allowed 21 of them using Graphics A to U. If you don't use them they still contain CAPS A to U. But, with the start of the UDG table designated by PEEKing 23675 and 23676, one is really not limited to 21 UDG figures--just 21 at a time. And, no limit to what appears on the screen at any one time. This is because you could design a 2nd set and put them just below the 1st set. When you want your program to print to the screen from the 2nd set all you have to do is POKE 23675 and 23676 with the starting address of your 2nd set. If you want the 1st set back a little lower in the screen just POKE the same two addresses with the address of the 1st set (65368). One can alternate between as <!-- p. 34 (pdf 42) --> many sets as one wants just by making sure the program is looking at the right set when told to print to the screen. Why does this work? Because your computer has a PIXEL mapped Display File. Once the right pixels are in the display file they automatically go from there to the screen. AND from the screen to the printer with `COPY`.

## Sprites

Sometimes a single character space is not big enough for your graphic and you will want to use several together to form a bigger graphic which you will move around the screen as a unit. These type graphics are called sprites. There is a routine in the "2068 Technical Manual" which gives some of the techniques to handle sprites in machine code. Moving sprites by Basic is slow and jerky as you have to move them a character space at a time.

## P Ramtop (65535)

Physical Ramtop is 65535 with a perfect memory. If you have a bad memory cell in your computer it can be less. The first thing that your computer does upon startup is check all HOME RAM by writing a 2 to each cell and reading it back. If it finds other than a 2, it sets P Ramtop just below the bad cell and reduces your memory accordingly. P Ramtop's location can be checked by PEEKing 23732 and 23733.

## Dual Screen Mode

What we have discussed above is the complete Home RAM from bottom to top. The right hand diagram on page 254 is how the Home RAM shifts with the addition of Display File 2 above the system variables. The RAM Resident code and the machine stack are shifted to high memory above the UDG. This isn't quite enough space so the machine code variables and CHANS as well as PROG are moved up a bit for the rest of the space.

[^v04-1]: Library note: 64K is the Z80's address space, not the amount of RAM; in the home bank 16K (chunks 0-1) is the HOME ROM and 48K ($4000-$FFFF) is RAM, which is all the power-on test fills and checks; see docs/technical-manual/02-hardware-guide.md (HOME ROM $0D42).

[^v04-2]: (unverified) 256 x 65,536 = 16,777,216 is correct arithmetic, but how many expansion banks can actually be fitted depends on bus-expansion hardware that was never produced; the ROM itself only names bank 255 (home), 254 (EXROM) and 0 (dock), with expansion banks numbered from 1 (EXROM GET_NUMBER).

[^c02-2]: Corrected. The original printed "0 to 8"; eight chunks numbered from 0 run 0-7, as do the bits of a byte, and the book itself calls the highest chunk of home memory "Chunk 7" (p. 25).

[^v04-3]: Library note: the rate is not a fixed 1200 baud; the EXROM tape writer uses Spectrum timing (half-cycle loop counts $3E for a 0 and $3E + $42 for a 1), so at 3.528 MHz a 0 bit runs at about 2060 bits/second and a 1 bit at about 1030, roughly 1400-1500 on average for mixed data; see docs/exrom_revision_analysis.md (EXROM $00BA-$00C4).

[^v04-4]: (unverified) Nothing in the ROM ties a bank number to an I/O port: GET_NUMBER simply uses 255 for home, 254 for the EXROM and 0 for the dock, which only happen to match ports $FF (DECR) and $FE (ULA); bank selection itself goes through the HSR at port $F4 (EXROM GET_NUMBER).

[^v04-5]: Library note: there is no RAM behind the HOME ROM; chunks 0-1 of the home bank are the 16K ROM itself and internal RAM is the 48K at $4000-$FFFF; see docs/technical-manual/02-hardware-guide.md (HOME ROM $0D42).

[^v04-6]: Library note: the EXROM is also used at every start-up (the Function Dispatcher/Bank Switching code is copied from EXROM $1000 to $6200, and the cartridge check BLDSCT runs there), and by MERGE and the bank services; see docs/ts2068_dispatcher.md (HOME ROM $0DED, EXROM BLDSCT).

[^v04-7]: Library note: the change video routine works when called directly at EXROM $0E8E, as the SYNTAX loader on p. 44 does; its defects are that the dispatcher table enters it at $0EA3 (skipping its register saves), the free-memory test ignores overflow, RAMTOP is not lowered, mode 128 leaves VIDMOD 0, and closing the second display file is unreliable; see docs/technical-manual/06-known-bugs.md and docs/ts2068_errata_and_notes.md (EXROM $0E8E, $0E27).

[^v04-8]: Corrected against the ROM. The original printed "Chunk 7 of home ROM"; the open-display-file routine copies the dispatcher to $F7C0-$FFFF, which is home RAM (EXROM $0DDD: LD DE,$F7C0 / LD HL,$6000 / LD BC,$0840 / LDIR).

[^v04-9]: (unverified) The relocation fix-up table at EXROM $1D00, walked by OPDFIL/CLDFIL, is flagged in the library as possibly incomplete, but no specific stock-ROM fix-table error is documented; see docs/ts2068_errata_and_notes.md ('Addressing the Disassembly Author's Concerns').

[^v04-10]: Library note: only the AROS header (8 bytes) is read from dock $8000 (chunk 4); the LROS header (4 bytes) is read from dock $0001 (chunk 0); see docs/ts2068_video_and_cartridges.md (EXROM BLDSCT, $0A07 and $0A23).

[^v04-11]: Library note: an AROS can hold BASIC (language type 1) or machine code (type 2), and the ROM handles both; see docs/technical-manual/05-advanced-concepts.md, 'Machine Code AROS'.

[^v04-12]: Library note: chunk 3 must not be marked in use in the chunk-specification byte when control passes to the cartridge, because the bank-switching code lives there; once running, an LROS may switch chunk 3 to the dock itself; see docs/technical-manual/06-known-bugs.md (Chunk 3).

[^c02-9]: Corrected. The original printed "RANDOMIZE USER 0"; the 2068 keyword is USR.

[^v04-13]: Corrected against the ROM. The original printed "26660-6824H"; at start-up the ROM sets CHANS to $6840 = 26688 (HOME ROM $0D9F: LD HL,$6840 / LD (CHANS),HL), as the book itself gives on p. 31; with no cartridge ARSBUF is empty, so this is the same line as ARSBUF. The instruction to cross out 6840H refers to the Operator's Manual map and is left as printed.

[^v04-14]: (unverified) The TS1000/ZX81 display file is outside the library; a fully expanded one is usually given as 793 bytes (24 lines x 33 bytes plus a leading NEWLINE), not 800.

[^v04-15]: Corrected against the ROM. The original printed "1046 bytes"; the span the sentence describes, from the first system variable at 23552 ($5C00) to the end of the reserved area at 24297 ($5EE9), is 746 bytes, and the SYSCON table follows at 24298 ($5EEA); the whole area to the end of chunk 2 (23552-24575) is 1024 bytes; see docs/ts2068_memory_map.md and docs/ts2068_system_variables.md.

[^v04-16]: Library note: GO SUB does not use OLDPPC/OSPPC (those are the CONTINUE pointers); it pushes the current line number (PPC) and next statement number onto the GO SUB stack on the machine stack; see disassemblies/ts2068_home_rom_U16_stock.txt (HOME ROM GO_SUB).

[^v04-17]: Library note: 25088 ($6200) is MSTBOT, the address just above the stack; NEW stores a $3E marker at 25087 and loads SP with 25086 ($61FE), with ERR SP at 25084; see docs/ts2068_memory_map.md (HOME ROM $0D88).

[^v04-18]: Library note: when an AROS is present the ROM inserts a fixed 208-byte buffer at 26688 and then the cartridge's machine-code reserve n (from its header) at the same place, so ARSBUF ends up at 26688 + n to 26688 + n + 207; see docs/technical-manual/05-advanced-concepts.md (HOME ROM AROS, $18CB).

[^v04-19]: Library note: nothing in the ROM uses 32553; VARS stays just above the moved CHANS, at 26918 plus the cartridge's machine-code reserve ($6926 + n), and it moves like any other pointer when lines are copied into ARSBUF; see docs/technical-manual/05-advanced-concepts.md (HOME ROM AROS, REMGSZ).

[^v04-20]: Corrected against the ROM. The original printed "26688-26709" in the heading; the default channel data is 21 bytes (4 x 5 + the $80 terminator) copied from ROM $11AA to 26688-26708 ($6840-$6854); 26709 ($6855) is the byte DATADD points at, and PROG starts at 26710 (HOME ROM $0D9F; EXROM NORMSVAR).

[^v04-21]: Library note: CHANS is moved up once, by the fixed 208-byte ($D0) AROS buffer plus the machine-code reserve given in the cartridge header (SYSCON+6); it does not vary with the length of the line being copied; see docs/technical-manual/05-advanced-concepts.md (HOME ROM AROS, $18CB).

[^v04-22]: (unverified) Not traced in the ROM; E LINE always keeps at least its $0D/$80 terminators (EXROM NORMSVAR), so it never shrinks to zero bytes.

[^v04-23]: Library note: on the 2068 CLEAR does not put a marker at RAMTOP; it stores the new RAMTOP and puts its $3E marker at MSTBOT-1 (25087) because the machine stack is fixed in chunk 3; RAMTOP is still the last byte BASIC may use, so code starts one above it; see disassemblies/ts2068_home_rom_U16_stock.txt (HOME ROM CLEAR, $1F84).
