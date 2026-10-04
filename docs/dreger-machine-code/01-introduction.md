<!--
  DERIVED FILE — secondary source. The library docs and the stock ROMs take precedence.

  Source: Dr. Lloyd Dreger, "Introduction to 2068 Machine Code" (1986, S.M.U.G.),
  printed pages 1–2. Transcribed from the scan at
  https://archive.org/details/introduction-to-2068-machine-code/ and checked against the
  stock ROM images in this repository (2026-10). See README.md for conventions and rights.

  Footnotes: "Corrected." = transcription-era fix of a printing error; "Corrected against
  the ROM." = a value the stock ROM contradicts, fixed in the text; "Library note:" =
  Dreger's explanation is contradicted by the ROM (his wording is kept); "(unverified)" =
  neither the ROM nor the library can settle it; "Not corrected." = an error the page
  cannot settle. Page markers give the printed page (and scan page) of every passage.
-->

*Dreger, Introduction to 2068 Machine Code — Introduction: Let's Start at the Very Beginning.*
*[← previous](00-front-matter.md) · [book README](README.md) · [next →](02-chapter-01-numbers-and-counting.md)*

---

<!-- p. 1 (unnumbered; pdf 9) -->

# Introduction: Let's Start at the Very Beginning

I am assuming that my readers know the BASIC language of the T/S 2068. When you start to learn to walk you don't run the four minute mile the first day or even the first year. First you crawl, then you stand and take your first steps, finally walking (Beginning Basic) and then running (Advanced Basic).

Machine code is the equivalent of flying. When you try to fly, the first thing a sane person would do is to study aerodynamics. Then, getting your courage up, you climb a small bluff, put on your wings, get a running start over the precipice and, hopefully, soar down to the bottom of the bluff without crashing. Less sane types would just jump off the bluff.

This manual is a self study course in machine code aerodynamics as applied to T/S 2068 wings. This is what you should (or have to) know before you ever start writing machine code programs. We will start with some simple examples (easy low bluffs) but we won't get into advanced code as that is the topic for the next manual. Portions of this book have been pretested on my present m/c class. Their helpful suggestions were greatly appreciated.

## A Misconception

M/C is a new language. Just like flying uses different rules, different coordination and different muscles than walking, so is machine code different from Basic. It is not an extension of Basic nor is it an emulation of Basic commands--that is the function of the ROM in your computer. When one writes a M/C program one plans and thinks altogether differently than one does in Basic.

## Why Learn Machine Code?

There are only three good reasons for using machine code:

1. Basic is too slow.
2. Basic can't do it or is too cumbersome.
3. Basic is too long.

You may wish to add another:

4. Because it's there.

Which means that you're just curious as to what somebody else's code is doing. And you know what curiosity does...

## But to Get Started

Some of this is going to be very basic and elementary--if it is, just skip that section and go on to one you don't know. I have tried to cover all the bases and leave nothing to chance.

<!-- p. 2 (pdf 10) -->
