<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 67–84. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Chapter 5: Beep and Sound.*
*[← previous](05-chapter-04-system-variables.md) · [book README](README.md) · [next →](07-chapter-06-the-cpu.md)*

---

<!-- p. 67 (pdf 75) -->

# Chapter 5: Beep and Sound

## The Beep Command

The simple Beep circuit is contained mostly in the SCLD chip which is why the Spectrum also has BEEP. The Spectrum does not have the more sophisticated AY-3 8912 Sound chip which Timex added in an attempt at music. The tiny speaker under your 2068 doesn't do it justice. But since Beep also comes out the MIC socket[^v07-1] a line can be run to a more suitable amplifier-speaker system. It not only improves quality but also volume control.

The BEEP command is port addressed to port 254. If a write to this port sets Bit 4, the internal speaker is activated. If Bit 3 is set, the signal goes to the MIC port for recording or amplification. Take care, port 254 Bits 0-1-2 contain the active Border color. These bits have to be kept to a valid color number (0 is a black border) as an OUT (254) command is given.

The easiest noise to create is the keyboard click which is activated by setting PIP (23609) to the length of the click desired (in 1/60th of a second mode--not like BEEP from Basic which uses seconds).[^v07-2]

The Basic command of BEEP has two arguments. The first is duration in seconds, the 2nd is the note where middle C is zero and each note on the piano, moving up and using all the half steps is a number higher. Notes below middle C are counted step or half step minus from middle C. Every 12 notes is an octave. Thus, 12 is one octave above middle C, -12 is one octave below middle C.

Translating this command to machine code is extremely difficult. The routine in ROM makes extensive use of the floating point calculator to calculate the proper frequency of impulses to send to the speaker. By comparison, duration is relatively easy. Another precaution, if you don't prevent maskable interrupts with a DI, which incidentally also prevents updating of the screen, your notes are going to "warble" or have a vibrato to them.[^v07-3] If you want pure notes stick to calling the ROM routine.

You have no control over the exact pitch of the note you create nor the loudness of the note, nor the tremolo, or anything else --just rough pitch and duration.

Fully exploring the BEEP command can take a lifetime of study as the command has been used to make the computer talk. Such appli<!-- p. 68 (pdf 76) -->cations are beyond the scope of this book.

## A Simple Experiment From Basic

Enter and run the following program:

```basic
 5 FOR x = 1 TO 500
10 OUT 254, 7: OUT 254, 23
15 NEXT x
20 OUT 254, 7: OUT 254, 23: GOTO 20
```

You will have to STOP the program with a CAPS SHIFTED BREAK.

You got two sounds right? What we just did is toggle Port 254 by turning the speaker switch on and off many times with the statements: `OUT 254, 7: OUT 254, 23`. We told you we would have to keep a valid border color so we chose white (7). The first OUT keeps the border color but turns off everything else. Now if we subtract 7 from the value we sent in the 2nd OUT, 23, we get 16 --exactly what we need to turn on BIT 4 which tells the computer to turn on the speaker.

Now we cycled the on/off to get the frequency. In lines 5 to 15 we did it with a FOR-NEXT loop. In line 20 with a GOTO. Since the first tone was lower than the second, we can say that our computer executes a FOR-NEXT slower than a GOTO loop...for this program. GOTOs execute slower as the program gets longer and longer. The FOR-NEXT loop cycled about 95 times a second with the GOTO at about 140 times a second.

Now add Line 1 `BORDER 5: BEEP 2.5, -18: BEEP 2.5, -15` and run the program again. Compare the first pair of sounds with those of the second pair. The BEEP sounds will be cleaner purer tones. The loop sounds will have a definite "warble" or "vibrato" to them, due as we pointed out above to the interrupts to reread the display file and check for a keyboard input.[^v07-4] Also, did you see the border change from green to white?[^v07-5] You may want to play with the pitch of the BEEP upping or lowering them a tone or two to see if you get a better match of the two sets of sounds. Your computer may be running at a slightly different frequency than mine.

Middle C, designated by a 0 in BEEP, has a frequency of 260/second.[^v07-6] One octave below that (at -12) would be "C below middle C" with a frequency of half middle C or 130/second. 3 steps below that at -15 is A at about 110/second. 3 notes below that at -18 is F# at about 92. What we have just done is very crudely timed our FOR-NEXT and GOTO loops.

If you don't believe me that the length of the program changes the speed of the GOTO loop, RUN the program again to attune your ear to the last frequency. Now delete all but line 20 and RUN the program again. You can already detect a pitch change.

<!-- p. 69 (pdf 77) -->

## Simulated Sounds From Machine Code

If you read from the beginning of the book to here you should know how to load the following machine code into your computer and run it. I have given you a decimal and a hex loader program earlier. Note that I haven't given you any addresses. Since the program is short it is written address independent and can be put anywhere. You choose the address. I don't expect the novice students to understand this program at the present time but they should recognize what part of the program gets POKEd above RAMtop and what is assembly mnemonics.

```z80
62,5                     LD A, 5 Border Cyan
14,254                   LD C, 254 Set Port
38,0                     LD H, 0  Set wait/frequency
22,255                   LD D, 255  Set loop count
68             Again     LD B, H
203,231                  SET 4, A  On
237,121                  OUT (C), A
16,254         1st wait  DJNZ, 1st wait
68                       LD B, H
203,167                  RES 4, A OFF
237,121                  OUT (C), A
16,254         2nd wait  DJNZ, 2ND Wait
203,231                  SET 4, A  ON
237,121                  OUT (C), A
16,254         3rd wait  DJNZ, 3rd wait
203,167                  RES 4, A  OFF
237,121                  OUT(C), A
16,254         4th wait  DJNZ, 4th wait
36                       INC  H
21                       DEC D
32,226                   JR NZ, AGAIN
201                      RET
```

Running the above program will give you a sliding scale downwards. The frequency of the tone is set by the wait loops and although there is one cycle at the start of a very long wait (the 1st time through B = 0, so DEC B sets it to 255 and you have to wait the entire DEC back to 0) the next wait is the shortest as B = 1. Only one cycle at each frequency is used.[^v07-7]

Obviously to do sustained tone one replaces INC H with a nop. To set the tone, experiment with LD H, n with different values. The higher the value the lower the sound.

To increase the length of the note, use DE as a counter instead of just D. This will require the resetting of A at the start of each loop as you will need to use the A register to check to see if DE is zero.

## Load, Save and Baud Rates

Since we have mentioned saving the border color when using BEEP <!-- p. 70 (pdf 78) --> you of course have noticed how the border blinks red and green while it's waiting for a Lead-In signal from your cassette player while LOADing a program. Once it has found it, the border shifts to a red-green montage of stripes.[^v07-8] While actually loading the few bytes of header it barely blinks on yellow and blue bands as it does while loading the program. If you haven't figured it out by now, Port 254 which contains the border color in Bits 0 to 2 also uses Bit 6 to read, and Bit 3 to write to, the cassette.[^v07-9] Sinclair, unlike other computers, uses these facts to give its users a visual verification that the program is loading or saving properly. The Baud Rate (bits per second sent or received) is too high (1200 baud) on the 2068 to give you discrete bands of bytes as on the ZX-81 or the TS-1000 (300 baud).[^v07-10] Remember the screen refresh rate changes the way things are seen on the screen edges.

What is actually sent to your tape recorder is two different pulses of sound. A pulse at a frequency of 1020 Hz (Hertz = cycles/second) for a 1 and a pulse one octave higher at 2040 Hz for a 0.[^v07-11] At a switch rate of 1200 baud, that's only 1 cycle for a 1 and 2 cycles for a 0.[^v07-12] Since both these are 2 to 3 octaves above middle C (260 Hz), you are asked to turn the treble on the recorder all the way up. Should you ever play a computer tape through the recorder speaker you get that high pitched screech. Not only is it high but it's loud to give a strong signal. Turn the volume down or the dog runs for cover--at least mine does.

What really slows down SAVE, LOAD and VERIFY to a cassette are these pulses of sound. Internally, and to disk drives, a single electrical pulse, not a series of pulses at a set frequency, serves as a bit on or off. Hence the baud rates of the disk drives and internal transfers to memory can occur much faster.

The other thing that slows down cassette data transfer is that 1 bit must be sent at a time serially, one after the other. Disk drives and Dot Matrix Printers use a Centronics "parallel" port of 8 data lines sending a whole byte at a time down 8 different lines. Generally on board RAM stores a set amount of data before processing it--this is called storing it in a buffer. A printer that prints one line left to right and the next right to left has to have all the pixels for a line stored before starting to print a line. A disk drive for a 5.25 inch diameter disk operating at 300 rpm is equivalent to a tape running at 65 inches/sec (outside track) compared to 3 inches/sec for a recorder,[^v07-13] so can record or read (still serially, one bit after the other on the disk surface) faster than a tape recorder especially when it just has to send a pulse down 1 line 1/8th of the time. The pulses can really be 8 times longer than if they had to go down a single line.

Disk drive baud rates are limited by the way they operate. Normally a drive spins a disk at 300 or 360 rpm. That's 5 or 6 turns per second. It has to read or write a track in that amount of time. Since it has to read the data that fast, it also has to

<!-- Duplicate scan: pdf 79 and pdf 80 are second scans of printed pp. 69-70 (pdf 77-78); text identical, not transcribed again. -->

<!-- p. 71 (pdf 81) -->

handle the data that fast. The baud rate will now depend upon how many bits are written on a track. This depends upon how fast the read/write head can respond to signals. Generally a single density disk uses a bit time of 8 microseconds--that's 8 millionths of a second or 125,000 bits per second. Double density packing puts twice as many bits on a track and thus has to operate at a phenomenal 250,000 bits per second and a read/write time of only 4 microseconds.

Both dual and Quad density disks use dual packing of bits in a track. Quad density is achieved by having 80 tracks/side rather than 40.

There is no way to send 250,000 bits/sec down a single data line using a clock cycle of 3.528 mega cycles. It requires a send loop of only 14.11 T states.[^c04-1] Using 8 data lines, as we do in parallel interface port, we can up that time to 113 T states. Even more T states are used in the interface and the disk because they generally have their own clock operating at 8 megacycles or higher. It should be pointed out that the read/write rate is NOT the effective rate as disks have a lot of overhead bytes to read and write as well. Our effective baud rate thus is less than 250,000 bits/second which would be a phenomenal 31250 bytes/second.

Modems are devices that allow one computer to talk to another over a phone line. That should be quite fast. But, a phone line is only a single data line--a series port if you please. A pure bit rate, i.e., without multiplexing onto a carrier wave, of 300 baud is already a high pitched sound which is generally about the limit that an ordinary phone line can handle without garbling. Mainframe computers talking to each other use multiplexing on special data phone lines to achieve higher baud rates. 1200 baud is about as fast as most personal computer modems can handle.

## Sound Command

The sound chip has 14 internal registers assignable to 3 different channels of sound with or without noise added.[^v07-14] They are listed in the table on the next page. Despite having 14 registers to control sound, we still can only write 3 part harmony. With only one envelope for timbre we are stuck with a maximum of two sounds, that of the envelope and that without the envelope--hardly enough to write a symphony. About the best we can expect is to write for one instrument. With this limited ability of the envelope and the small speaker, it's still going to sound like computer sound--not organ, grand piano, mandolin or even banjo. The sound chip does much better with sound effects than with music.

<!-- p. 72 (pdf 82) -->

## The Sound Chip Registers

```text
                      SOUND CHIP REGISTERS
                                      BIT
REG CHAN CONTROL        7   6   5   4   3   2   1   0
 0   A   Tone control  Fine Tune----------------------
 1   A
                                       Coarse tune----
 2   B   Tone control  Fine Tune----------------------
 3   B
                                       Coarse tune----
 4   C   Tone control  Fine Tune----------------------
 5   C
                                       Coarse tune----
 6 Noise Period                    Coarse tune only---
 7 Enable
                      joystick N O I S E     T O N E
                               C    B   A   C   B   A
 8   A   Loudness             ENV   -----0-15----------
 9   B   loudness             ENV   -----0-15----------
10   C   loudness             ENV   -----0-15----------
11 Envelope period     Fine tune-----------------------
12                     Coarse tune---------------------
13 Envelope shape                     CONT ATT ALT HOLD
14 Joystick In Register
15 In register not used
```

We have to give a few definitions and define a few terms before we can use the above table effectively.

Registers 0 to 5: The sound chip receives the clock signal of 1.764 megahertz but divides it by 16[^v07-15] to give an effective frequency of 110,250 Hz for generating tones. We are used to thinking of the pitch (tone) of a note as a frequency, f, (middle C, C4 is 261.626 Hz). To get the period, p, of the note we have to take the reciprocal, i.e., p = 1/f. To get the tone period required by registers 0 to 5, we multiply p by the frequency of the sound chip, 110,250. (This is the step by step way of saying: tone period = 110,250/f.) These numbers can range from 14[^v07-16] to NO MORE THAN 4095[^c04-2]--no bigger than we can hold in 12 bits, 4 in the high or coarse tune, and 8 in the fine tune. We, of course, have two bytes for each of our 3 sound channels. These values are already figured out for you for all the notes in your User's Manual (page 187ff). However, they are not exact due to rounding errors. The table starting on the next page is more accurate.

Register 6: Noise period is limited to values from 0 to 31 which creates a high pitched frequency used with RANDOMISE to create "white" noise. Higher values of noise produce lower sounds. Your User's Manual lists 3 short programs for some sounds, which is just a start. You're on your own with experimentation as far as creating that special effect for your super game.

Register 7: Nothing happens until you tell the sound chip what registers you want to use and that includes the joysticks. As your User's Manual says "subtract from 63 and use that number". This register is an ACTIVE when LOW type...a "0" must be in the bit indicated to activate the register. Mixing of noise with a tone is allowed but not recommended if you want to play music.

<!-- p. 73 (pdf 83) -->

## Register Values For Notes of the Musical Scale[^c04-3]

```text
     IDEAL               ACTUAL           IDEAL               ACTUAL
NOTE FREQ        C    F  FREQ        NOTE FREQ        C    F  FREQ
A0      27.500  15  169     27.501   C5     523.251   0  211    522.512
A#0     29.135  14  200     29.136   C#5    554.365   0  199    554.020
B0      30.868  13  244     30.865   D5     587.330   0  188    586.436
C1      32.703  13   43     32.705   D#5    622.254   0  177    622.881
C#1     34.648  12  110     34.648   E5     659.255   0  167    660.180
D1      36.708  11  187     36.713   F5     698.456   0  158    697.785
D#1     38.891  11   19     38.889   F#5    739.989   0  149    739.933
E1      41.203  10  116     41.200   G5     783.991   0  141    781.915
F1      43.654   9  222     43.646   G#5    830.609   0  133    828.947
F#1     46.249   9   80     46.246   A5     880.000   0  125    882.000
G1      48.999   8  202     49.000   A#5    932.328   0  118    934.322
G#1     51.913   8   76     51.907   B5     987.767   0  112    984.375
A1      55.000   7  213     54.988   C6    1046.502   0  105   1050.000
A#1     58.270   7  100     58.272   C#6   1108.731   0   99   1113.636
B1      61.735   6  250     61.730   D6    1174.659   0   94   1172.872
C2      65.406   6  150     65.391   D#6   1244.508   0   89   1238.764
C#2     69.296   6   55     69.296   E6    1318.510   0   84   1312.500
D2      73.416   5  222     73.402   F6    1396.913   0   79   1395.570
D#2     77.782   5  137     77.805   F#6   1479.978   0   74   1489.865
E2      82.407   5   58     82.399   G6    1567.982   0   70   1575.000
F2      87.307   4  239     87.292   G#6   1661.219   0   66   1670.455
F#2     92.499   4  168     92.492   A6    1760.000   0   63   1750.000
G2      97.999   4  101     98.000   A#6   1864.655   0   59   1868.644
G#2    103.826   4   38    103.814   B6    1975.533   0   56   1968.750
A2     110.000   3  234    110.030   C7    2093.005   0   53   2080.189
A#2    116.541   3  178    116.543   C#7   2217.461   0   50   2205.000
B2     123.471   3  125    123.460   D7    2349.318   0   47   2345.745
C3     130.813   3   75    130.783   D#7   2489.016   0   44   2505.682
C#3    138.591   3   28    138.505   E7    2637.021   0   42   2625.000
D3     146.832   2  239    146.804   F7    2793.826   0   39   2826.923
D#3    155.563   2  197    155.501   F#7   2959.956   0   37   2979.730
E3     164.814   2  157    164.798   G7    3135.964   0   35   3150.000
F3     174.614   2  119    174.723   G#7   3322.438   0   33   3340.909
F#3    184.997   2   84    184.983   A7    3520.000   0   31   3556.452
G3     195.998   2   51    195.826   A#7   3729.310   0   30   3675.000
G#3    207.652   2   19    207.627   B7    3951.067   0   28   3937.500
A3     220.000   1  245    220.060   C8    4186.009   0   26   4240.385
A#3    233.082   1  217    233.087   C#8   4434.922   0   25   4410.000
B3     246.942   1  190    247.197   D8    4698.637   0   23   4793.478
C4     261.626   1  165    261.876   D#8   4978.032   0   22   5011.364
C#4    277.183   1  142    277.010   E8    5274.041   0   21   5250.000
D4     293.665   1  119    294.000   F8    5587.652   0   20   5512.500
D#4    311.127   1   98    311.441   F#8   5919.911   0   19   5802.632
E4     329.628   1   78    330.090   G8    6271.927   0   18   6125.000
F4     349.228   1   60    348.892   G#8   6644.876   0   17   6485.294
F#4    369.994   1   42    369.966   A8    7040.000   0   16   6890.625
G4     391.995   1   25    392.349   A#8   7458.621   0   15   7350.000
G#4    415.305   1    9    416.038   B8    7902.133   0   14   7875.000
A4     440.000   0  251    439.243   C9    8372.018   0   13   8480.769
A#4    466.164   0  237    465.190   All notes of the scale can  not
B4     493.883   0  223    494.395   be played beyond this point.
```

<!-- p. 74 (pdf 84) -->

## Additional Register Values For Notes of the Musical Scale[^c04-4]

```text
     IDEAL               ACTUAL
NOTE FREQ        C    F  FREQ
D9    9397.274   0   12   9187.500   Unless you are a dog you
D#9   9956.062   0   11  10022.727   can't hear notes higher
F9   11175.304   0   10  11025.000   than  F10.
G9   12543.854   0    9  12250.000
A9   14080.000   0    8  13781.250
B9   15804.266   0    7  15750.000
D10  18794.548   0    6  18375.000
F10  22350.608   0    5  22050.000
```

Be sure to turn the sound registers off by writing 63 to register 7 when you are done.

Registers 8-9-10: Loudness for channels A, B, and C respectively if you use numbers from 0 (very soft) to 15 (loud). Adding 16, turning on Bit 4, turns this maximum loudness over to the shape of the envelope which will then control its variation. Not using the envelope gives you a note of steady loudness.

Registers 11-12: Envelope Period (E.P.). The length of the envelope is based on the frequency of 6890.625 (110,250/16) and can be calculated as we did above for the tone (pitch) as long as we remember that it has to be per second--not per minute.

The use of these registers can best be explained by an example. If you strike a note on a piano and hold down the key, the sound will last for 10 to 15 seconds before it has faded away to silence. Generally a pianist doesn't wait for the sound to fade that far before hitting other notes. To keep the melody note going without having to keep a finger on the note, the pianist uses the SUSTAIN pedal which lifts the dampers on all the strings thus giving rise to harmonics. Releasing the sustain pedal drops the dampers and kills all sounds instantly (unless the key is still being pressed).

We thus have to contend with two types of timing. That which we described above is called phrasing. The second type, tempo, can be handled with PAUSE. Phrasing for a piano is a long slowly decreasing volume sound. But phrasing can also be used for a crescendo as well as a decrescendo, or it can be used as a combination of the two as well. Wind instruments can increase or decrease the loudness of a note over a period of as much as a minute or as they say, "as long as the lungs hold out". The longest "hold" on the 2068 is 9.51 seconds (65535/6890.625).

PAUSE is used to control tempo timing. Even if an envelope is used for a channel, new notes can be written to it. The envelope continues its function unabated with the new note(s). If we recall, PAUSE 1 waits 1/60th of a second. PAUSE 60 waits for 1 second. PAUSE 3600 waits for 1 minute. Since tempo is expressed in beats/minute, taking 3600/TEMPO gives the PAUSE value needed.

<!-- p. 75 (pdf 85) -->

Below are some of the commonly used tempos:

```text
               Beats/min
PRESTO          168-208
ALLEGRO         120-168
MODERATO        108-120
ANDANTE          76-108
ADAGIO           66-76
LARGHETTO        60-66
LARGO            40-60
```

Sometimes notes are played on the "off beat" or even faster including dotted notes at 1.5 times normal length. Adjusting of pause with: PAUSE = DUR\*TEMPO where DUR is the duration of the note in terms of the beat note, i.e., 1/2, 1.5 or some other fraction or multiple is the easiest way to make this adjustment.

Register 13: Envelope shape is just 4 bits on or off and is NOT what was hoped for. You do not have control over the length of the attack, the length of the hold, or the length of the decay, nor can you do anything too much about vibrato or tremolo.

The diagrams on page 193 of your User's Manual also are a bit confusing. Looking at the very bottom of the diagram gives us a clue as to what is happening. We see the letters EP (Envelope Period) marked out. Each of the diagrams printed above it uses this same length envelope period. All the way across is 10 envelope periods, not 1.

About all we can do with the shape of the envelope is designate which shape it should be--attack or decay, whether it should be a one shot deal or just be a series of one type or another.

The 4 bits of the register are:[^v07-17]

```text
BIT VALUE COMMAND
 0    1   Hold
 1    2   Alternate
 2    4   Attack
 3    8   Continue
```

Bit 2 is the easiest. When on it means start with an attack--increase the volume from low to high. When off, decay is the mode selected by default.

Bit 1 is next easiest--Alternate. Depending upon Bit 2, alternate attack and decay--Crescendo if both on (Value of 6). Decrescendo if both on and Bit 0 is on as well (Value of 7).[^v07-18]

Bit 0--Hold off makes the envelope one shot except that when Bit 1 (Alternate) is on, the volume ends by jumping to what the value would have been at the end of the alternate period.[^v07-19]

<!-- p. 76 (pdf 86) -->

Bit 3--Continue repeats the whole process. With Bit 1 on with alternations of attack and decay.

All Bits off is a decay only and then off at the end of the envelope period.

Under NO CONDITIONS can we get an attack, then hold, then decay in one envelope period.

## An Example

Most books and your User's Manual are a bit sketchy of exactly how to convert a piece of sheet music to sound on the 2068 so we will go through an actual example, first in Basic and then we will talk about converting it to machine code.

The music I have chosen is given on the next page. It is something you should recognize should you enter and run the program (another case of modern music plagiarizing the classics). We will just do the first 8 measures. By coincidence, it's 3 part harmony which we can handle. In cases where we have more parts we would have to simplify the music by dropping a part. In lots of cases the bass plays an octave so the obvious simplification is to drop the high note of the bass octave. We get some effect of this note anyhow from harmonics the computer generates.

We note that the lowest note we want to play is in measure 8, a low Ab (the small b behind the A is the closest I can manage to a flat symbol). Ab is also equal to G#. This note is not written in the music with a flat sign in front of it because the key signature, at the start of each staff, says to use 4 flats. Thus, all B's, E's, A's and D's are flatted unless written otherwise (these changes are called accidentals as in measures 3, 4, 5, 6, and 7. We also note that the key signature says both staffs of music are written in the BASS CLEF (Those backward C's) rather than normal notation which starts in Measure 8.

The high note occurs in Measure 3, Bb. Therefore, we will be going from a low Ab1 (G#1) through C2, C3, and C4 (middle C), up to Bb4 (A#4) just short of C5. This is a range of 39 notes. Since each note will take 2 bytes, the easiest way to do this in Basic is with a numeric array.

```basic
10 DIM n(78)
15 FOR x = 1 TO 78
20 READ a
25 LET n(x) = a
30 NEXT x
35 DATA 8,76,7,213,7,100,6,250,6,150,6,55,5,222,5,137,5,58,
4,239,4,168,4,101,4,38,3,234,3,178,3,125,3,75,3,28,2,239,2,
197,2,157,2,119,2,84,2,51,2,19,1,245,1,217,1,190,1,165,1,14
2,1,119,1,98,1,78,1,60,1,42,1,25,1,9,0,251,0,237
```

The data, of course, is just taken from the note table given

<!-- p. 77 (unnumbered; pdf 87) -->

*[Sheet music: a photocopied page of printed piano music (page number "10" printed at the start of the first system, the page scanned sideways), headed "Adagio cantabile", two staves per system in a key signature of four flats, with printed fingering numbers and dynamics (pp, mf, p, cresc., poco animato). Handwritten annotations add measure numbers (about 1 to 20) along the systems, "Ab" beside the page number, and the letters "B E A D" (the four flatted notes) beside the first staff.]*

<!-- p. 78 (pdf 88) -->

earlier starting at G#1.

We can now call our notes by numbers (n) and use n\*2 and n\*2-1 for the fine register and the coarse register respectively of whatever tone channel we specify. While we are about it we may just as well assign our 3 channels. Channel A will handle the melody, Channel B the accompaniment and Channel C the bass.

```text
39--------Bb4
    37    Ab4
36--------G4
    34    F4
32--------Eb4
    30    Db4
  29----  C4
    27    Bb3
25--------Ab3
    24    G3
22--------F3
    20    Eb3
18--------Db3
    17    C3
15--------Bb2
    13    Ab2
12--------G2
    10    F2
   8----  Eb2
     6    Db2
   5----  C2
     3    Bb1
   1----  Ab1
```

We set up the table at the right by counting up and down from middle C (note 29). The longer lines in this table indicate the staff lines of Treble clef (upper) and the Bass clef. Only 3 lines of the Treble clef are shown as we won't be needing the rest. A note, of course, can be ON the line or BETWEEN the lines. After we do our normal scale, we add the flats to change it to the key we are using--each A, B, D, and E flatted. We finally end by adding the octave we are in. Starting at the bottom, we then add the numbers, skipping those that will only be used for accidentals as we pointed out. Using this it is quite easy to assign the correct numbers to the notes. For example, the first 3 notes of the first measure which will all be played together would be 29, 25 and 13 for Channels A, B, and C respectively.

## Tempo and Note Length

We now go on to note length. We see that the key signature assigns a 2/4 meter--2 quarter notes per measure. We also look above the top clef and see "Adagio Cantabile". Adagio is the tempo, Cantabile means, in a singing manner"--a subject we will handle in our discussion of the sound envelope. Going back to page 75, we see that Adagio means 66-76 beats/minute. However, we note that the accompaniment is written in 1/8th notes and this beat continues throughout the piece. Well, 1/8th notes are half as long as 1/4th notes so we can play two for every 1/4th note. Since our tempo was 66-76 quarter notes per minute, we can also say it's 132-152 8th notes per minute. Converting to 1/60th of a second using the value of 144 gives us, 3600/144 = 25, a nice integer value.

We also assign note lengths of 1/8th = 1, 1/16th = .5, 1/4th = 2 and triplet 1/8th = .67. We abbreviate these notes as E, S, Q, and TE respectively. Our PAUSE will be DUR\*TEM. DUR will have the letter values above with TEM being 25.

How do we keep a quarter note in the A and C channel and write eighth notes to the B channel? We just don't change the notes until we want to. If we are going to read notes from DATA lines, this presents a problem with the read statement...unless we put dummy values in the DATA statement. Zero is a good dummy value. However, we have then several SOUND statements to use. If you <!-- p. 79 (pdf 89) --> are typing this into your computer please use the same line numbers. We will fill in the missing lines later.

```basic
60 IF b AND NOT a AND NOT c THEN SOUND 2,n(b*2);3,n(2*b-1)
65 IF NOT a AND b AND c THEN SOUND 2,n(b*2);3,n(b*2-1);4,n(
c*2);5,n(c*2-1)
70 IF a AND b AND NOT c THEN SOUND 0,n(a*2);1,n(a*2-1);2,n(
b*2);3,n(b*2-1)
75 IF a AND NOT b AND NOT c THEN SOUND 0,n(a*2);1,n(a*2-1)
80 IF a AND b AND c THEN SOUND 0,n(a*2);1,n(a*2-1);2,n(b*2)
;3,n(b*2-1);4,n(c*2);5,n(c*2-1)
85 PAUSE DUR*TEM
```

We enclose these statements in a FOR/NEXT loop:

```basic
50 FOR x = 1 TO 67
55 READ DUR,a,b,c
90 NEXT x
```

We also have to add:

```basic
5 LET Q = 2: LET E = 1: LET S = .5: LET TE = .67: LET TEM = 25.
```

We of course can write music without the use of the envelope. In fact, we will do that and add the envelope later. We have to decide on the volume of each channel. Of course, we will be using pure tones. We want the melody to be a little louder than the bass and the beat so how about:

```basic
45 SOUND 7,56;8,12;9,9;10,10
```

The enable register, 7, is set with pure sound for all 3 channels. Channel A has loudness 12 for the melody. Channel B, 9 for the harmony with Channel C a 10, slightly louder for the bass. We have to be careful with these values as too large a value can overdrive the tiny speaker. If that should happen, just do a BEEP to toggle it loose. If it persists, lower the loudness values 1 each.

Of course we should turn our program off when we are done and maybe get ready to replay it with:

```basic
95 SOUND 7,63;8,0;9,0;10,0: RESTORE 100
```

Our DATA lines will look like this. Every measure has its own DATA line so finding errors is simplified. Check your DATA lines. They should have a letter(s) and 3 number sequences.[^c05-1]

```basic
110 DATA E,29,25,13,E,0,20,0,E,0,25,0,E,0,20,0,
     E,27,24,18,E,0,20,0,E,0,24,0,E,0,20,0
120 DATA E,32,25,17,E,0,20,0,E,0,25,0,E,0,20,0,
     E,0,27,12,E,0,20,0,E,30,27,0,E,0,20,0
130 DATA E,29,25,13,E,0,20,0,E,32,27,12,E,0,20,0,
```

<!-- p. 80 (pdf 90) -->

```basic
     E,37,29,1,E,0,25,0,E,39,31,22,E,0,25,0
140 DATA E,32,24,20,E,0,27,0,E,0,24,0,E,0,27,0,
     E,0,24,8,E,0,27,0,E,33,24,0,E,0,27,0
150 DATA E,34,24,6,E,0,27,0,E,0,24,0,E,0,27,0,
     E,27,24,18,E,0,24,0,E,0,20,0,S,29,20,0,S,30,0,0
160 DATA E,32,25,17,E,0,20,0,E,0,25,0,E,0,20,0,
     E,26,20,10,E,0,17,0,E,0,20,0,E,0,17,0
170 DATA E,30,22,9,E,0,18,0,E,0,22,0,E,0,18,0,
     E,29,18,8,E,27,18,0,E,25,18,9,E,24,18,0
180 DATA E,27,22,1,E,0,24,0,E,0,22,13,E,0,24,0,TE,25,17,1,
     TE,0,20,0,TE,0,25,0,TE,0,29,0,TE,0,32,0,TE,0,37,0
```

Okay, RUN the program. Not bad for a first try. But, let's admit it, a bit computerish. Since we are not using an envelope the sounds came on and stayed on at the same volume for the full length of the note. We did accomplish one thing, the melody notes were long while the accompaniment notes were short. This sound some people have labeled "organ" or sustained music--the note plays at the set volume until we release the key. But even here, there is no, what is called, "voicing" to the notes.

## Using the Envelope

This is where technique ends and art begins. It's going to take a lot of experimentation to get it just right. But you might as well be warned that you are very limited in what you can achieve. I'm sure that another whole book could be written on the subject of sound effects and music.

Enabling the envelope is done per channel by adding 16 to the loudness registers (8, 9 and 10) for the sounds you want controlled by the envelope period and shape. Also be forewarned that strange things happen if you put two different channels under the envelope at the same time--they have a tendency to block each other if the notes are too close together. Obviously the same envelope must be used for all channels under its control.

A few guidelines. Start by working with the coarse (12) register first. Plunking sounds like guitars and banjos use relatively short (low numbers) periods with register 13 at 2. The sound decays logarithmically right from the start as a plucked string does.

Piano and snare drums use medium periods which can be chopped by rewriting register 13 when a new note is written to the channel. Unfortunately, all notes controlled by the envelope start over. In our music above, putting Channels B and C under the envelope control replays the channel C note again. Putting Channel A under envelope control would be disaster as the melody notes would replay at every 1/8th note interval.

Bowed strings and wind instruments are primarily fast attack with hold and continue on (short period with hold). Such sounds can be gotten with register 13 at 13.[^c05-2][^v07-20]

<!-- p. 81 (pdf 91) -->

## Vibrato

Vibrato is caused by the slow variation of the pitch of the sound by a few cycles per second as the note is being played. This can easily be done by a violinist by vibrating his string fingers on the fret board. The changing pressure of the finger on the string results in a small shortening and lengthening of the string to give a small change in pitch to a sustained note. On the 2068 this means we have to rewrite the fine tune register with first a higher note, then the note, then a lower note and then back to the note. For the A register it would be:

```basic
SOUND 0, n(a*2)+1
PAUSE 1
SOUND 0, n(a*2)
PAUSE 1
SOUND 0, n(a*2)-1
PAUSE 1
SOUND 0, n(a*2)
PAUSE 1
```

We have to repeat this sequence until we have sustained the note as long as we like. We can also add registers 2 and 4 for channels B and C to these SOUND statements if we want everything in vibrato.

### Tremolo

Tremolo is obtained by changing the volume of the note through a slightly changing cycle similar to what we did above with vibrato. We could add this to the sound commands in the above program by changing registers 8, 9 and 10 for Channels A, B and C respectively. Change these also only by 1.

With both vibrato and tremolo we have to rework the PAUSE statement into a FOR/NEXT loop with the same number of pause counts. Our original program used a `PAUSE = DUR*TEM` where TEM was 25. Since this value is not divisible by 4, let's use 24 which is and gives us a loop of 6. Further difficulties can be encountered with many fractional values of DUR. This can be solved by using:

```basic
FOR y = 1 TO (DUR*TEM)/4
PROGRAM
NEXT y
```

Why does it work? Simply that the second argument of FOR, that expression, is rounded to an INTEGER.[^v07-21]

We have another problem however. Our data read in a zero for a value whenever we didn't want to rewrite the note. We somehow have to maintain the value of the fine tune as we sustain a note. We leave it up to the student as to how this can be a<!-- p. 82 (pdf 92) -->chieved. HINT: It's not in the DATA statement.

## Enhancing Your Program

We have just done a pure sound program. The big advantage of using a SOUND command is that once set up it keeps working while the computer can do something else. In our program we just made it wait with a PAUSE statement which was timed to the right interval for the note length. Doing something else while a note is playing takes exquisite timing on the part of the programmer as you have to get back and send the next SOUND command at approximately the right interval of time. Theoretically, our program ran a bit slower than the PAUSE statement allowed as we did not account for the time it took to execute the FOR/NEXT loop and the IF/THEN statements. These things may have to be adjusted for in fast music. But since all tempos have a range, sticking close to the mid or upper portion of that range insures a good tempo.

## Machine Code Sound

Writing this simple program for only 8 measures of music took a lot of memory. If you don't believe me do a PRINT FREE and subtract that number from 38652. The reason is all the numbers, each of which takes an additional 6 bytes for its slug. However, note one thing. All the numbers in all our DATA lines were from 0 to 255--just a nice size to fit into individual bytes. Setting up two files, a note tuning file and a note sequence file and POKEing the data into these files and then calling it by PEEKs will save a great deal of memory.

You are now half way to a full code program. To write a SOUND command you send the register number OUT Port 245 (F5H) and then send the value you want written to that register OUT Port 246 (F6H). As long as PORT 245 contains the right register, another OUT 246 will send the same register a new value.

That is the easy part. The hard part is timing everything which has to be done with counting loops. A typical one is:

```z80
     LD BC, COUNT
TIME DEC BC          6
     LD A, B         4
     OR C            4
     JRNZ, TIME     12
```

Note the numbers to right of the instructions. This is how many T states or clock cycles it takes to complete each instruction. Once through the loop takes 26 clock cycles. At 3.528 million cycles per second, it can do this loop 135,692 times a second (if no timeout is taken to handle interrupts). Loading BC with its maximum value of 65535 only holds things up for less than half a second. In our program we used a TEMpo value of 25. (25/60th seconds) and this could just barely be achieved with a value of 56538 in BC for the duration of our 1/8th notes. Even a <!-- p. 83 (pdf 93) --> quarter note hold would require more than a simple timing loop.

Well, not quite. One can pad the timing loop with harmless extra instructions like LD A, A (4), nop (4)[^c05-3] or a meaningless CALL (17) to an address that has nothing but a RET (10) in it. The numbers in () are of course the number of T states chewed up. Note that the CALL and RET consume 27 thus effectively doubling the time of the count loop (27 + 26). Any address already containing a RET will do for a call address. One still has to have a program to read the values of notes and write the registers but with these hints, the advanced student should be able to write a program. The beginning student must read on for another two chapters before attempting it.

## Joysticks

Sound register 14 sends or receives from whatever is connected to the joystick ports which need not necessarily be a joystick. To enable register 14, Bit 6 of register 7 must be reset (0) for an IN, set (1) for an OUT. During all the discussion of SOUND that 63 value to register 7 reset the joystick at the same time so we had the joystick on to receive a signal all this while... we want an IN as we can only read joysticks.

Reading the joystick in machine code can be done with:[^c05-4]

```z80
LD A, 7
OUT (245), A   Set register 7 to read
XOR A          Set A to zero
OUT (246), A   Send zero to register 7
LD A, 14
OUT (245), A
LD A, 1 = Left, 2= Right  3= Both
IN A, (246)
```

*Notes on the listing above:* writing 0 to register 7 also switches on every tone and noise channel.[^v07-22]

Register A will now contain the results of register 14 (in low active format, i.e., 0 if contact closed). The bits are:

```text
    7       6  5  4     3     2    1    0
 button     not used  right left down up
```

Generally RLA is used to CLEAR the carry flag to check for a button press while RRA is used for reading the various directions again with a clear of the carry flag.[^v07-23] Note that some joysticks will allow diagonal directions to be read by resetting 2 bits. Others will not.

We apologize to the beginning student for this bit of assembly language without explanations. You won't recognize some of these commands. Read on and once you know the commands come back and reread sections of the book with more understanding. It's one of the problems in writing a book and trying to do things logically.

<!-- p. 84 (pdf 94) -->

Sound register 15 exists and can be set to read or write as described above for register 14 using Bit 7 of the enable register. Unfortunately, nothing is attached to it. Any ideas hardware hackers?

[^v07-1]: (unverified) The ROM's BEEP routine PARP (ROM $03F3) holds port 254 bit 3, the tape-out bit, set and toggles only bit 4, so whether the tone reaches the MIC socket is a question of the SCLD's single "Spkr/Tape out" pin and the board wiring; docs/technical-manual/02-hardware-guide.md lists that one pin for both but the library does not settle what appears at the jack.

[^v07-2]: Library note: PIP is not timed in 1/60ths of a second; the editor loads E with PIP, D with 0 and HL with $00C8 and calls PARP, so the click is PIP+1 cycles of about 1,836 T-states, roughly half a millisecond each (power-on value 0); see docs/technical-manual/04-system-io-guide.md §4.4 and docs/ts2068_system_variables.md (ROM $0A94, PARP $03F3).

[^v07-3]: Library note: DI does not stop the display, which the SCLD generates in hardware; it stops the 60 Hz IM 1 interrupt routine, which only advances FRAMES and scans the keyboard (the ROM's own PARP routine starts with DI for this reason); see docs/technical-manual/02-hardware-guide.md (ROM INTRPT $0038, PARP $03F3).

[^v07-4]: Library note: the interrupt does not reread the display file; it advances FRAMES and scans the keyboard (ROM INTRPT $0038). The SCLD reads the display in hardware, and separately slows code running in the display RAM by holding the CPU clock while it fetches screen data; see docs/technical-manual/02-hardware-guide.md §2.1.8.2.

[^v07-5]: Library note: BORDER 5 is cyan, not green (green is 4), as the listing on p. 69 says ("Border Cyan"); see docs/technical-manual/02-hardware-guide.md §2.1.13.2.

[^v07-6]: Library note: the ROM's base frequency for BEEP note 0 is 261.6256 Hz (TONC table, ROM $04AC: 89 02 D0 12 86 = 261.6256 Hz); the 130, 110 and 92 figures that follow are right to the precision given; see disassemblies/ts2068_home_rom_U16_stock.txt (TONC).

[^v07-7]: Library note: each pass actually outputs two cycles. Only the 1st and 2nd waits load B from H; the 3rd and 4th find B already 0 (left by the previous DJNZ) and always run the full 256 loops, so each step is one cycle with H-length half-periods followed by one cycle with fixed 256-loop half-periods; see docs/z80_combined_reference.md (DJNZ).

[^v07-8]: Library note: the leader border alternates red (2) and cyan (5), not green: the EXROM edge routine R_EDGE outputs the complemented seed (seeded $22/$02) AND 7, and SAVE uses the same pair (A = $02, then XOR $0F); see disassemblies/ts2068_exrom_U20_stock.txt (EXROM R_EDGE $018D, W_TAPE $0068).

[^v07-9]: Corrected against the ROM. The original printed "also uses Bit 6 to read or write to the cassette"; bit 6 of port 254 is the tape input (EAR) on a read, while the tape output (MIC) is bit 3 on a write, as p. 67 says (EXROM R_EDGE $018D sets it with OR $08); docs/technical-manual/02-hardware-guide.md §2.1.13.2.

[^v07-10]: Library note: the 2068 has no fixed tape rate; every bit is one cycle, 1,710 T-states for a 0 and 3,420 for a 1, so the rate is about 2,060 bits/s for zeros, 1,030 for ones and roughly 1,375 for an even mix; see docs/technical-manual/04-system-io-guide.md §4.2 (EXROM W_TAPE $0068).

[^v07-11]: Library note: these are the Technical Manual's figures (the Spectrum's at 3.5 MHz); at the 2068's 3.528 MHz the ROM's 1,710 and 3,420 T-state cycles give about 2,063 Hz for a 0 and 1,032 Hz for a 1; see docs/technical-manual/04-system-io-guide.md §4.2 (EXROM W_TAPE $0068).

[^v07-12]: Library note: every bit is a single cycle; a 0 is one short cycle, half as long as the one long cycle of a 1, not two cycles; see docs/technical-manual/04-system-io-guide.md §4.2 (EXROM W_TAPE $0068).

[^v07-13]: (unverified) Tape speed is outside the ROM and the library; the standard compact-cassette speed is 1 7/8 inches/sec, which only strengthens the comparison.

[^c04-1]: Corrected. The original printed "13.14 T states" and "105 T states"; at the stated clock of 3.528 MHz, one bit every 1/250,000 second is 3,528,000/250,000 = 14.11 T states, and 8 lines give 8 × 14.11 = 113 (the printed figures match a 3.285 MHz clock, the digits of 3.528 transposed).

[^v07-14]: Library note: the AY-3-8912 has 16 registers, 0 to 15, as the table below shows; 0 to 13 control sound and 14 and 15 are the I/O-port registers; see docs/technical-manual/02-hardware-guide.md §2.1.6.1 (ROM SOUND checks the register number with CP $11).

[^v07-15]: Corrected against the ROM. The original printed "receives the clock signal of 3.528 megahertz but divides it by 32"; the sound chip is clocked at 1.764 MHz (the SCLD's φC output, 14.112 MHz / 8, half the CPU clock) and its tone generators divide by 16, which gives the same 110,250 Hz; docs/technical-manual/02-hardware-guide.md §2.1.6 and the SCLD pin list.

[^v07-16]: Library note: 14 is only where the note table stops (B8); the chip accepts any 12-bit tone period from 1 upward (the lower bound is from the AY data sheet, which the library does not include).

[^c04-2]: Corrected. The original printed "4025"; the largest value that fits in 12 bits is 2^12 - 1 = 4095, as the same sentence says.

[^c04-3]: Corrected. The original printed A0 actual 27.506, A1 actual 54.998, A#2 ideal 116.614, F#6 ideal 1497.978 and G7 actual 2150.000; recomputed by script from ideal = 440 × 2^(n/12) and actual = 110,250/(C × 256 + F), these are 27.501, 54.988, 116.541, 1479.978 and 3150.000, and all C and F values agree with the rounding of 110,250/ideal. (Several ideal frequencies above C7 differ from the formula by 0.001 in the last place; that is the author's rounding and is left as printed.)

[^c04-4]: Corrected. The original printed A9 actual "13781.000"; 110,250/8 = 13781.250. (D10 ideal 18794.548 against 18794.545 computed is the same last-place drift seen in the higher octaves of the table above and is left as printed.)

[^v07-17]: (unverified) The library has no AY-3-8912 data sheet (docs/technical-manual/02-hardware-guide.md §2.1.6 refers to an external one); this bit order, Continue, Attack, Alternate, Hold from bit 3 down, matches the General Instrument data sheet.

[^v07-18]: (unverified) The library cannot settle envelope shapes. Per the GI data sheet, with Continue (bit 3) off the Alternate and Hold bits are ignored, so values 4 to 7 all give one rising ramp and then silence; 7 is not a decrescendo, and alternating ramps need bit 3 (value 14, or 10 to start with a fall).

[^v07-19]: (unverified) Not in the library. Per the GI data sheet it is Continue = 0, not Hold = 0, that makes the envelope one-shot; Hold = 1 (with Continue on) freezes the level after the first period, at its end value or, with Alternate, at the inverted value. The statements below that all bits off gives one decay then silence, and that no shape gives attack-hold-decay, agree with the data sheet.

[^c05-1]: Corrected. The original printed line 50 as `FOR x = 1 TO 68` and the first printed line of DATA lines 130, 140, 150, 160 and 170 without a trailing comma; the DATA holds 67 groups of four items, every DATA line sums to the same 8 eighth-notes so no group is missing, and without the commas items such as `0E` would run together on a TS2068.

[^c05-2]: Corrected. The original printed "channel 13 at 13"; the 2068 sound chip has only three channels (A, B, C), and 13 is the envelope shape register discussed in the preceding paragraphs.

[^v07-20]: (unverified) Not in the library; per the GI data sheet shape 13 (Continue + Attack + Hold) is one rising ramp held at maximum, which agrees with the text.

[^v07-21]: Library note: FOR does not round its limit; it stores the limit as a 5-byte floating-point number (copied with the step by LDIR) and NEXT compares against it unrounded, so starting at 1 with step 1 the loop runs the whole-number part of the limit (4.6 gives 4 passes, not 5); see disassemblies/ts2068_home_rom_U16_stock.txt (ROM FOR $1C78).

[^c05-3]: Corrected. The original printed "nop (2)"; the Z80 NOP instruction takes 4 T states.

[^c05-4]: Corrected. The original printed `LD A, 64` before the `OUT (245), A` that selects the register to read, and `IN (246), A`; to read register 14, as the text then says, 14 must be written to the register-select port (64 is not a sound register number), and the Z80 input instruction is `IN A, (246)`.

[^v07-22]: Library note: writing 0 to register 7 does clear bit 6 for input, but it also enables all three tone and all three noise channels, so any channel with a non-zero volume starts sounding; writing 63 (bit 6 still 0) gives the same joystick read without that side effect; see docs/technical-manual/04-system-io-guide.md §4.3 and docs/technical-manual/02-hardware-guide.md §2.1.6.1.

[^v07-23]: Library note: RLA does not clear the carry flag; it rotates bit 7 (the button) into carry, so carry is 0 when the button is pressed (the data is active low), and RRA likewise shifts the direction bits out through carry one at a time; see docs/z80_combined_reference.md (RLA, RRA).
