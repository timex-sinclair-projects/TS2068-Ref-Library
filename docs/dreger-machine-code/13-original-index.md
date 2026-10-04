<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  index pages 3–7. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Original index (1986 page numbers).*
*[← previous](12-appendixes.md) · [book README](README.md)*

---

<!-- p. Index 3-7 (pdf 3-7); Index 8 (pdf 8) is blank -->

# Index {.unnumbered}

Page numbers are those of the original printing.

```text
INTRODUCTION ........................................................ 1

CHAPTER 1  Numbers and Counting ..................................... 2
    The Digital Computer ............................................ 2
    The Eight Bit Byte .............................................. 2
    Binary Numbers .................................................. 3
    Converting Binary to Decimal and Decimal to Binary .............. 6
    Addition in Binary .............................................. 7
    Subtraction in Binary ........................................... 7
    Binary Multiplication ........................................... 8
    Binary Division ................................................. 8
    Hexadecimal Counting ............................................ 9
    Hexadecimal to Binary Conversion Table .......................... 11
    Negative Numbers ................................................ 11
    Negative Number Conversion Table ................................ 13
    Adding and Subtracting Negative Numbers ......................... 13
    Numbers That Aren't Really Numbers .............................. 14
        Character Codes ............................................. 14
        Pixels ...................................................... 14
        Instructions ................................................ 14
            Tokens .................................................. 14
            Machine Code ............................................ 14
    BCD Numbers ..................................................... 15
    The Slug ........................................................ 15
    Decoding The Slug ............................................... 15
    Binary Bit Conversion Table ..................................... 17
    Dollars and Cents ............................................... 18
    The Slug Exponent ............................................... 19
    Signed Floating Point Numbers ................................... 20
    Translating Slugs into Numbers .................................. 20
    Scientific Notation ............................................. 21
    Limits of Number Size ........................................... 21
    Double Precision Numbers ........................................ 21

CHAPTER 2  Memory Mapping ........................................... 23
    Types of Memory ................................................. 23
    The ROM Memory Banks ............................................ 24
    Extended ROM .................................................... 25
    The Cartridge Bank .............................................. 25
    The Memory Map of Home RAM ...................................... 26
    Chunks 0 and 1 .................................................. 27
    Chunk 2--The Display File ....................................... 27
        The 64 Characters Per Line Screen ........................... 28
        The 80 Characters Per Line Screen ........................... 28
    The Hi-Res Graphics Screen ...................................... 28
    The Printer Buffer .............................................. 29
    The System Variables ............................................ 29
    Machine Stack ................................................... 29
    Ram Resident Code ............................................... 30
    ARSBUF--AROS Line Buffer ........................................ 31
    CHANS--Channels Table ........................................... 31
    PROGram ......................................................... 31
    VARS--Variable Table ............................................ 31
    E Line--Edit Line ............................................... 32
    WORKSP--Work Space .............................................. 32
    STKBOT-STKEND ................................................... 32
    Free Memory ..................................................... 32
    Ramtop .......................................................... 33
    UDG--User Defined Graphics ...................................... 33
    Sprites ......................................................... 34
    P Ramtop ........................................................ 34
    Dual Screen ..................................................... 34

CHAPTER 3  Screen Printing .......................................... 35
    Screen Printing ................................................. 35
    Plot ............................................................ 37
    The Attribute File .............................................. 38
    Over and Inverse ................................................ 40
    Screen$ ......................................................... 41
    BORDCR--Border Color ............................................ 42
    VIDMOD--Video Mode .............................................. 42
        MODE 0 ...................................................... 42
        MODE 1 ...................................................... 42
        MODE 2 ...................................................... 42
        MODE 3 ...................................................... 42
    Display File 2 .................................................. 43
    Screen Outputs .................................................. 45

CHAPTER 4  System Variables ......................................... 47
    CHARacters ...................................................... 47
    RAMtop .......................................................... 47
    Setting Ramtop Without CLEAR .................................... 48
    Storage of a Basic Line ......................................... 49
    Scroll .......................................................... 54
    System Variables for the Keyboard ............................... 55
    System Variables for the 2040 Printer ........................... 56
    System Variables for Input/Output (I/O) ......................... 57
    Ports, Streams and Channels ..................................... 57
    Operating System Variables and Flags ............................ 60
    Variable Storage and Search ..................................... 62
    Flags ........................................................... 64

CHAPTER 5  Beep and Sound ........................................... 67
    The Beep Command ................................................ 67
    A Simple Experiment From Basic .................................. 68
    Simulated Sounds From Machine Code .............................. 69
    Load, Save and Baud Rates ....................................... 69
    Sound Command ................................................... 71
    The Sound Chip Registers ........................................ 72
    Register Values For Notes of the Musical Scale .................. 73
    Additional Register Values ...................................... 74
    An Example ...................................................... 76
    Tempo and Note Length ........................................... 78
    Using the Envelope .............................................. 80
    Vibrato ......................................................... 81
    Enhancing Your Program .......................................... 82
    Machine Code Sound .............................................. 82
    Joysticks ....................................................... 83

CHAPTER 6  The Central Processing Unit .............................. 85
    The CPU--Internal Organization .................................. 86
    Our First Machine Code Program .................................. 87
    For Hardware Hackers Only ....................................... 92
    Getting An Instruction (M1 Cycle) ............................... 93
    Memory Refresh .................................................. 93
    M1 Cycle ........................................................ 94
    Memory Read Cycle ............................................... 94
    Memory Write Cycle .............................................. 94
    I/O Timing Cycle ................................................ 95
    Comparing the Z80 with the 8080 and the 6502 CPU's .............. 96
    The Future ...................................................... 97

CHAPTER 7  Machine Code--Assembly Language .......................... 99
    Other Conventions Used .......................................... 99
    The Flag Register ............................................... 100
    Load Instructions ............................................... 101
    Block Move Instructions ......................................... 104
    Jumps, Jump Relatives, Calls and Returns ........................ 104
    Converting Spectrum Programs to the 2068 ........................ 106
    Moving Code to a Different Location ............................. 107
    Saving Registers--EX, EXX, PUSH and POP, DI & EI ................ 108
    Timing .......................................................... 111
    More Ways to Save Registers ..................................... 112
    Simple Arithmetic and Logic ..................................... 113
        INC and DEC ................................................. 113
        ADD, ADC, SUB and SBC ....................................... 113
    Logic ........................................................... 114
        AND, OR and XOR ............................................. 115
    Other Simple Math Operations .................................... 116
    Checking Bits. BIT, SET and RESET ............................... 116
    Multiply and Divide--Rotate and Shift ........................... 118
        Multiplying ................................................. 118
    Multiply and Division by any Number ............................. 119
    Division--Successive Subtractions Giving Integer ................ 120
    Floating Point .................................................. 121
    IN/OUT .......................................................... 122
    Restarts ........................................................ 123
    Miscellaneous Instructions ...................................... 125
    Extra Instructions .............................................. 125

CHAPTER 8  The Floating Point Calculator ............................ 127
    A Note About Precision .......................................... 127
    The Technique ................................................... 128
    Floating Point Operations ....................................... 129
    Loading and Unloading the Stack ................................. 131
    Already Slugged Numbers ......................................... 132
    Decimal Numbers ................................................. 132
    Digging Deeper .................................................. 134
    Normalizing Numbers ............................................. 135
    Floating Point Addition of Exponented Numbers ................... 136
    Floating Point Subtractions of Exponented Numbers ............... 137
    Multiplying Two Slugged Numbers ................................. 138
    Dividing Slugged Numbers ........................................ 139
    Print a F.P. Number/Decimal to F.P. ............................. 142
    Converting Binary Fractions to Decimal Fractions ................ 143
    Rounding and Using Scientific Notation .......................... 144
    Graphics--Plot and Draw ......................................... 144

CHAPTER 9  Peripherals .............................................. 147
    Dot Matrix Printers ............................................. 147
        Escape Codes ................................................ 147
        Dot Matrix Pixels ........................................... 148
        Designing Your Own Dot Matrix Characters .................... 149
        Dip Switches ................................................ 150
        Word Processors ............................................. 150
        Word Processor Limitations .................................. 152
    The Keyboard .................................................... 153
        Keyboard Routines ........................................... 154
            A Completely Dead Keyboard .............................. 154
            Caps Lock ............................................... 154
            Reading the Whole Keyboard .............................. 154
            Testing Last K .......................................... 155
        Fast Action--Just Reading Part of Board ..................... 156
        Break? ...................................................... 156
        Input ....................................................... 156
        Redefining the Keyboard ..................................... 157
    Graphic Pixel Generation ........................................ 158
    Microdrives ..................................................... 159
    Modems .......................................................... 160
        Connecting Up ............................................... 161
        Bulletin Boards ............................................. 162
    Disk Drives ..................................................... 162
        Use of Single Sided Disks ................................... 163
        Care of Floppies ............................................ 163
        Disk Density ................................................ 164
        The 5.25 Inch Floppy ........................................ 164
        DOS--Disk Operating System .................................. 165

CHAPTER 10  Advanced Concepts--I/O Porting & Bank Switching ......... 169
    The SCLD ........................................................ 170
    Bank Switching--An Overview ..................................... 171
    The Function Dispatcher ......................................... 172
        Corrections For ............................................. 172
    AROS and Bank Switching ......................................... 174
    Cartridge Initialization ........................................ 174
        Errors in AROS Routine ...................................... 174
        Cartridge Setup ............................................. 175
    Ram Resident Code Routines ...................................... 176
    Function Dispatcher Service Codes ............................... 178
    Horizontal Select Register ...................................... 187
        Enabling ExROM .............................................. 188
        Enabling a Bank of Extended Memory .......................... 189
        Enabling Chunks in the Dock Bank ............................ 190
        Enabling More Chunks of ExROM ............................... 190

APPENDIXES .......................................................... 191
    Appendix A   Timing Tables ...................................... 192
    Appendix B   A Machine Code Print & Input Routine ............... 193
    Appendix C   A Complete Code Table .............................. 202
    Appendix D   Machine Code for Encoding--Decimal ................. 208
                 Machine Code for Encoding--Hex ..................... 210
    Appendix E   Decimal/Hex Conversion Tables ...................... 212
    Appendix F   Bibliography/Copyrights ............................ 213
```

*Correction in the index above:* The Beep Command.[^idx-1]

[^idx-1]: Corrected. The original index printed page 64; the section begins on page 67, the first page of Chapter 5.
