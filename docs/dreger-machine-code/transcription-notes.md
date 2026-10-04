# Chunk 01 notes: PDF pages 9-28

## 1. Pages covered and headings

PDF 9-28 = printed pp. 1-20 (Introduction plus Chapter 1 up to "Translating Slugs into Numbers", which stops mid-sentence at the end of p. 20).

- pdf 9: no page number printed (inferred p. 1). Marked `<!-- p. ? (pdf 9) -->`.
- pdf 10: printed "Page 2", otherwise blank. Only the page comment is emitted.
- pdf 11: no page number printed (inferred p. 3, the chapter opener). Marked `p. ?`.
- pdf 12-28: printed pp. 4-20.

Headings produced:
- `# Introduction: Let's Start at the Very Beginning`. The TOC calls it INTRODUCTION and the page title is "LET'S START AT THE VERY BEGINNING", so I combined the two. Under it: `##` A Misconception / Why Learn Machine Code? / But to Get Started.
- `# Chapter 1: Numbers and Counting`
- `##` The Digital Computer; A Stumbling Block (in-page only, not in the TOC); The Eight Bit Byte (pronounced bite); Binary Numbers; Converting Binary to Decimal Numbers and Decimal to Binary; Adding and Subtracting in Binary; Binary Multiplication; Binary Division; Hexadecimal Counting; Hexadecimal to Binary Conversion Table; Other Number Systems (in-page only); Negative Numbers; Negative Number Conversion Table (Decimal and Hex); Adding and Subtracting Negative Numbers; Numbers That Aren't Really Numbers; BCD Numbers; The Slug; Decoding the Slug; Binary Bit Conversion Table; Dollars and Cents; The Slug Exponent; Signed Floating Point Numbers; Translating Slugs into Numbers.
- `###` 1. Character Codes; 2. Pixels; 3. Instructions. `####` A. Tokens; B. Machine Code. The run-in labels "A. TOKENS." and "B. MACHINE CODE." were turned into these headings and removed from the paragraph text so they are not duplicated.
- The TOC item "Subtraction in Binary" appears on the page only as a run-in "SUBTRACTION:" at the start of a paragraph. I kept it as printed prose and did not make it a heading.
- "Hexadecimal to Binary Conversion Table" (TOC p. 11) is not printed on the page, which shows only "SECOND SYMBOL". I added the heading from the TOC. The table is actually hex to decimal; the TOC wording is kept.
- The Binary Bit Conversion Table (all of pdf 25) sits in the middle of a paragraph that starts on p. 16 and ends on p. 18. I kept page order, so the paragraph is split by the table block.

## 2. Verification

All checks were done with Python scripts in `scratchpad/c01/` (check.py, tables.py, blocks.py and ad hoc runs). There is no machine code in this chunk, so no assembler or reconcile run was needed.

- Hex/decimal table (p. 11): every cell checked against row*16+col. One mismatch: row 1, col 3 is printed as 18 (scan confirmed at zoom). Footnote c01-5.
- Negative number conversion table (p. 13): every decimal value checked against (256-n)&255, and every hex value against int(hex,16). All 128 entries correct.
- Binary Bit Conversion Table (p. 17): integers checked against 2^(k-1) and fractions against 5^k zero-padded to k digits (= 1/2^k). Mismatches:
  - row 26: "193,947" should be "193,847"
  - row 36: "640,125" should be "640,625"
  - row 43: "616,024" should be "616,029". This error carries through rows 44-48, which are exact halvings of the printed row above.
  - row 48: also has "895" for "890" relative to its own predecessor.

  All of these were confirmed on zoomed crops. Footnote c01-6.
- Binary arithmetic, pp. 6-9: 79; the answers 170/102/21/15; 89 = 01011001; 180/56/219; the addition example and the four addition answers; the subtraction example and the four subtraction answers (the last as M00111110). All correct.
- Long multiplication examples (22 x 13 = 286; 3439 x 239 = 821921): every partial product and running sum re-added. All correct.
- Multiplication answers: #1 correct; #2 and #3 wrong. Footnote c01-3.
- Long division examples (255/13 = 10011 r 1000; 50774/53 = 1110111110 r 0): each subtraction step simulated. All correct.
- Division answers: #2 correct; #1 and #3 do not match the problems as printed. The digit counts of the problems were confirmed at 3x zoom. Footnote c01-4.
- p. 16 fraction row (1/2 to 1/512): correct.
- p. 16 worked conversion of 0.1 (remainders .0375, .00625, .00234375, .000390625, .000146484375): correct.
- p. 18 repeating fraction: confirmed as 36 binary digits by pixel-width measurement. The printed remainder 1.00708386E-10 does not match the exact 8.73E-12. Footnote c01-7.
- p. 18 answers: 321.798 correct; .444444444 last byte, 1678.79 fraction and all three decode answers are wrong. Footnote c01-8.
- p. 20: 128-3 = 125; 128+5 = 133; 31 = .11111000...; sign-bit first bytes .01111000 and .01001100; slug bytes 76 and 204. All correct.
  - The slug for 0.1 is printed as 14,125,76,204,204,204. The real ROM rounds the last byte to 205 (7D 4C CC CC CD), but the text is explicitly describing truncation, so this is not footnoted. Flagged here in case the editor wants a note.
- p. 18 prose: 32 bits / 3.32 = 9.63 decimal digits; check 32*log10(2) = 9.633. Correct.
- p. 6: VARS sysvar at 23627/23628. Consistent with the 2068 system variable map.
- p. 14 codes (65 = A, 66 = B, 32 = space, PRINT comma 6, comma 44, PRINT token 245, EX AF,AF' = 8, slug code 14): consistent with the Spectrum/2068 character set.
  - The claim that tokens run from 165-255 was not verifiable here (the 2068 has extra keywords) and was left as printed.
- p. 19 BASIC: line 5 has unbalanced parentheses. Footnote c01-9. The rest was checked by reasoning (a=1 -> "100" -> "1.00").
- Unverifiable: none of the numeric content. All prose claims about the Operators Manual page numbers (240, 239-245, 262-265, 252, 241) were left as printed.

## 3. Ambiguous glyphs resolved

- p. 5 (pdf 13), 16-bit value row: "65" under bit 6 is clearly 6-5 at zoom, not 64. It is an original error (footnote c01-1).
- p. 9 (pdf 17), division dividend: read at 3x zoom as 1100011001010110 (16 digits). It is consistent with quotient 1110111110 x 110101.
- p. 9, division problems: "1000001/1111", "11001100110/11001100" and "11111111/101010" (8 ones) read at 3x zoom.
- p. 8 (pdf 16), fifth partial product row: read as "00001101011011110____" (multiplicand plus a 0 for the skipped bit 4, then 4 underscores). This is consistent with the following sum.
- p. 11 (pdf 19), row 1 col 3 "18": both digits zoom-confirmed as 1-8.
- p. 18 (pdf 26), decode problem 1: 101.10110110110110110110110110110110 (32 fraction digits). Reconstructed from two overlapping 3x crops.
- p. 9, "remalnder" in the DIVISION ANSWERS line: a dot-matrix glitch for "remainder".
- p. 7 ANSWERS: "180 = 10110100" (8 digits) confirmed at zoom.

## 4. Silent prose typo fixes (original -> fixed)

- p. 4: "densly" -> "densely"
- p. 4: "Horray!" -> "Hooray!"
- p. 6: "corrresponding" -> "corresponding"
- p. 6: "bigger then 65535" -> "bigger than 65535"
- p. 7: "Okey!" -> "Okay!"
- p. 7: "carrys" -> "carries"
- p. 9: "carrys" -> "carries"
- p. 9: "remalnder" -> "remainder"
- p. 3: "programing" -> "programming"
- p. 12: "tegether" -> "together" (inside the text block that mixes prose and numbers)
- p. 12: "appropiate" -> "appropriate"
- p. 18: "Fortnunately" -> "Fortunately"
- p. 18: "advertsied" -> "advertised"
- p. 19: "funtion" -> "function"
- p. 19: "re-pectively" -> "respectively"

The following were not changed (author voice): "nybble", "Chemist", "We would have to that if" (missing "do"), "Going from binary number is easy", "copy..somewhere", "IQ's", "CPU's", and "Kindly open your Operators Manual".

## 5. Footnoted technical errors in the original

- c01-1: p. 5, 16-bit place-value row "65" should be 64.
- c01-2: p. 7, "Only the 8 low bytes count" should be bits.
- c01-3: p. 8, multiplication answers #2 (289) and #3 (15450933) are wrong.
- c01-4: p. 9, division answers #1 and #3 are wrong.
- c01-5: p. 11 hex table, 18 should be 19 at row 1, col 3.
- c01-6: p. 17 Binary Bit Conversion Table, rows 26, 36 and 43-48.
- c01-7: p. 18, the remainder after 36 binary digits of 0.1 is 8.73E-12, not 1.007E-10.
- c01-8: p. 18, encode/decode answers (.444444444, 1678.79 and the three decode results).
- c01-9: p. 19, BASIC line 5 has unbalanced parentheses.

Footnote markers that refer to a table or code block are attached to the nearest prose sentence, since pandoc cannot carry a marker inside a fenced block:
- c01-5 is on the "To go from decimal to hex" paragraph just before the table.
- c01-6 is on "use the table on the next page".
- c01-9 is on "A is your variable."

## 6. Illegible spots, diagrams, and rendering conventions

- Nothing was illegible. There are no drawings in this chunk.
- Underlining (dot-matrix overstrike) in the arithmetic examples (pp. 7, 8, 9, 12) is rendered as a line of `-` directly beneath the underlined characters. The `_` characters themselves (shift placeholders such as "000101100_", "______1110111110") are printed underscores and are kept.
- In the Binary Bit Conversion Table every third row is underlined as a visual group marker. Only the underscores that appear in the gaps ("4__.125", "._9_0's_,") are reproduced; the underline under the digits is not marked.
- The negative-table header "_0___1___2___..." is likewise kept as printed.
- Answer lines and "Try these" lines are pandoc line blocks (`| `) to keep their line breaks.
- The hex table's vertical "FIRST SYMBOL" label is kept as the letters in column 1, as printed.

## 7. Widest code-block line

77 characters: the last row of the Binary Bit Conversion Table (p. 17, pdf 25), "140,737,488,355,328  . 12 0's,003,552,...,895,625". Other blocks are at most 67 characters (the hex table rows).
# Chunk 02 notes

## 1. Pages covered / headings
PDF 29-48 -> printed pp. 21-40 (offset: pdf = printed + 8). Printed p. 22 (pdf 30) is blank apart from the running head; only its page marker is emitted.

Headings produced:
- p.21 (end of Chapter 1): `## Scientific Notation`, `## Limits of Number Size`, `## Double Precision Numbers`
- `# Chapter 2: Memory Mapping`
  - `## Types of Memory`, `## The ROM Memory Banks`, `## Extended ROM`, `## The Cartridge Bank` (with in-page line "Don't pull a Bill!" rendered as a bold paragraph, not a heading -- it is not in the TOC), `## The Memory Map of Home RAM`, `## Chunks 0 and 1`, `## Chunk 2--The Display File`
    - `### The 64 Characters Per Line Screen`, `### The 80 Characters Per Line Screen` (TOC indents these under Chunk 2)
  - `## The Hi-Res Graphics Screen`, `## The Printer Buffer`, `## The System Variables`, `## Machine Stack (24576-25087)`, `## Ram Resident Code (25088-26688)`, `## ARSBUF (26688-?) AROS Line Buffer`, `## CHANS (26688-26709) Channels Table`, `## PROGram (26710-?)`, `## VARS (??) Variable Table`, `## E Line (??) Edit Line`, `## WORKSP (??) Workspace`, `## STKBOT-STKEND (??)`, `## Free Memory`, `## Ramtop`, `## UDG (65368-65535) User Defined Graphics`, `## Sprites`, `## P Ramtop (65535)`, `## Dual Screen Mode`
- `# Chapter 3: Screen Printing`
  - `## The Display File Map--Screen Map` (the TOC calls this section "Screen Printing", p. 35; I used the in-page heading wording), `## Plot`, `## The Attribute File`, `## Over and Inverse`
- Address ranges in the in-page headings were kept in the heading text as printed.

## 2. Verification
No machine-code listings or BASIC DATA loaders in this chunk. Checked programmatically (python):
- All decimal/hex pairs on p.26-27: 16384=4000H, 22528=5800H, 23296/23552/24576/25088 = 5B00/5C00/6000/6200H, 26688=6840H, 26660=6824H, 26710=6856H, 65368=FF58H, 65535=FFFFH, 15616=3D00H, 31488=7B00H, 63424=F7C0H, 63936=F9C0H, 2000H=8192 -- all correct.
- p.21: 2^127 = 1.7014118E+38, 2^-128 = 2.9387359E-39 (correct). 12345678 vs 1.2345679E+8 inconsistent -> footnote c02-1.
- p.23: 256 x 65536 = 16,777,216; 1024 x 64 = 65536 (correct).
- p.27-28: 6144, 768, 6912, 768+32=800, 64x8=512, 512/80=6.4, 80x6=480, 32/8=4 (all correct).
- p.29: stack 24576-25087 = 512 bytes (correct). System variables "1046 bytes (23756-24297 ...)": 23756-24297 is 542 bytes; the 1046 total could not be cross-checked from this chunk -- left as printed, unverified.
- p.33: 65535-65367 = 168 = 21 x 8 UDG bytes (correct).
- p.35 display-file table: each entry checked against 16384 + 256*(row-1) + (col-1); two errors in original -> footnote c02-4. "L 1"/"I 2" continuation rows (16416..., 16672...) correct.
- p.36: seam 16384+2048 = 18432 (correct); 18176-16385 = 1791 (correct).
- p.37-38 PLOT example: 142/8 = 17 r 6, 175-97 = 78, 78/8 = 9 r 6, 78 = 01001110b, high byte 01001110b x 256 = 19968, low byte 00110010b = 50, 19968+50 = 20018 (arithmetic correct). Conceptual errors footnoted (c02-5, c02-6, c02-8); bit value 32728 footnoted (c02-7).
- System-variable addresses (PROG 23635, VARS 23627, E LINE 23641, WORKSP 23649, STKBOT 23651, STKEND 23653, RAMTOP 23730, P-RAMT 23732, UDG 23675, DF CC 23684, COORDS 23677, ATTR P/MASK P/ATTR T/MASK T 23693-23696, P FLAG 23697) match the standard Spectrum/2068 system-variable layout. P FLAG bit assignments match the standard layout.
- Unverifiable: VARS start 32553 with an AROS cartridge (p.31); the CHANS address on p.26 (see below).

Inconsistency NOT footnoted (evidence ambiguous): p.26 tells the reader to write "26660-6824H" opposite the line below CHANS, while p.31 gives CHANS as 26688-26709 (and ARSBUF 26688). The hex/decimal pair itself is self-consistent. The p.26 instruction relates to lines on the Operator's Manual map (not reproduced), so I could not establish which is intended; transcribed as printed. The assembler/editor may want to review.

Also not footnoted: p.29 address "Little Rock, AK 72203" (Arkansas is AR) -- a postal address, not technical; left as printed.

## 3. Ambiguous glyphs resolved
All numeric passages were re-read at 300 dpi crops (c02/crop_*.png). Font distinguishes 0 (slashless round) vs O and 3 vs 8 clearly at that zoom; no unresolved cases.
- p.35 table row 4: "17152 17152" really does repeat (checked zoomed) -- original error, footnoted.
- p.35 table row 8 col 32: "18197" confirmed at zoom (not 18207) -- original error, footnoted.
- p.37: "32728" confirmed at zoom (not 32768) -- footnoted.
- p.21: "1.2345679E+8" and "12345678" confirmed at zoom.

## 4. Silent prose typo fixes
- p.21: "Rememer" -> "Remember"; "repectively" -> "respectively"; "ardent o-f" (o: / of split) -> "ardent of"
- p.25: "casette" -> "cassette"; "progamming" -> "programming"; "every- thing" -> "everything"
- p.26: "It then knows its there" -> "It then knows it's there"
- p.24: "centrononics" -> "centronics"
- p.27: "less space then" -> "less space than"
- p.28: "suprise" -> "surprise"
- p.29: "knnowledge" -> "knowledge"
- p.30: "appropiate" -> "appropriate"
- p.31: "appropiate" -> "appropriate"
- p.33: "momemnt" -> "moment"
- p.35: "Dislay" -> "Display"
- p.36: "its going to print" -> "it's going to print"; "each chracter" -> "each character"
- p.37: "does not effect calculations" -> "does not affect calculations"
- p.38: "Rememeber" -> "Remember"; "multipy" -> "multiply"; "different terms then you used" -> "than you used"
- p.39: "Similarily" -> "Similarly"; "what is \"om\" in one" -> "\"on\""; "masks always compliment" -> "complement"
- p.40: "decender" -> "descender"
Kept as period/author spellings (not fixed): programed, programable, programing, useable, Orientated, followup, turnon, analogue, "over writing", "Random Excess Memory" (author's joke), "The 33 byte", "change-it".

## 5. Footnoted technical errors (9)
- c02-1 (p.21): LET w = 12345678 vs printed result 1.2345679E+8.
- c02-2 (p.23): chunks "labeled 0 to 8" -> 0 to 7.
- c02-3 (p.35): "Pixel 1 of Character 1 of Line 2" repeated; second should be Character 2.
- c02-4 (p.35): table row 4 columns 2-5 off by one; row 8 col 32 18197 -> 18207.
- c02-5 (p.37): Y "from 0 (bottom) to 176 (top)" -> 175.
- c02-6 (p.37): remainder 6 means bit 1, not bit 2; zero remainder means bit 7.
- c02-7 (p.37): bit value 32728 -> 32768.
- c02-8 (p.38): x column should be 17 (0-based), low byte 49, address 20017 (not 18/50/20018).
- c02-9 (p.26): "RANDOMIZE USER 0" -> RANDOMIZE USR 0.

## 6. Illegible spots / diagrams
- No illegible text.
- p.24 (pdf 32): memory-chip/bus wiring drawing described as `*[Diagram: ...]*`.
- p.22 (pdf 30): blank page (running head only).
- p.35: vertical "LINE 1"/"LI..." label letters down the left of the table kept as printed inside the text block.

## 7. Widest code-block line
52 characters: header row of the display-file table, p.35 (pdf 43).
# Chunk 03 notes

## 1. Pages covered
PDF 49-68 = printed pp. 41-60 (printed = pdf - 8). Printed p. 46 (pdf 54) is blank in the original. I added only the page comment and `<!-- page intentionally blank in original -->`.

Headings produced:
- `### INVERSE vs. INVERSE and TRUE VIDEO` (in-page heading, not in the TOC; I treated it as a subsection of "Over and Inverse", which begins in the previous chunk)
- `## Screen$`, `## BORDCR 23624 Border Color`, `## VIDMOD 23746 Video Mode`, `## Display File 2`, `## Screen Outputs`
- MODE 0/3/2/1 are TOC sub-entries but are run-in paragraph leads in the text ("MODE 0--the one we do..."). I kept them as bold run-in leads (`**MODE 0**--...`), not headings, and kept the printed order (0, 3, 2, 1).
- `# Chapter 4: System Variables`
- `## CHARacterS 23606-23607`, `## RAMtop 23730-23731`, `## Setting RAMtop Without CLEAR`, `## Storage of a Basic Line`, `## Scroll`, `## System Variables for the Keyboard`, `## System Variables for the 2040 Printer`, `## System Variables for Input/Output (I/O)`, `## Ports, Streams and Channels` (the last two are back to back and empty between them, as printed; the TOC lists both on p. 57 at the same level), `## Operating System Variables and Flags`
- System-variable entries (E PPC, K CUR, ERR C, K STATE, REPDEL, PPOSN, PPC, etc.) are pandoc definition lists (`Term` / `:   text`), the same style chunk_06 uses for flag entries. Where an entry breaks across a page, the continuation after the page comment is an unindented plain paragraph, so the 4-space indent cannot turn it into a code block.

## 2. Verification
- **Hex loader (p. 44)**: the DATA string has 38 bytes. I disassembled it with a small opcode script: DI; LD A,1; OUT (F4H),A; IN A,(FFH); SET 7,A; OUT (FFH),A; LD A,1; PUSH AF; EI; CALL 0E8EH; DI; IN A,(FFH); RES 7,A; OUT (FFH),A; XOR A; OUT (F4H),A; POP AF; CP 80H; JR NZ,+3; LD (5CC2H),A; EI; RET. The routine is coherent. POKE 63212 = offset 12 = the operand of the second LD A, which is correct. 5CC2H = 23746 = VIDMOD, matching the text. The loop end 65237 does not match the 38 bytes (63200-63237), so it is footnoted.
- **BASIC line storage walk-through (pp. 49-51)**: checked with arithmetic. Line 5 length = 27, which matches the text, so line 10 starts at 26741 (matches). 26710 = 86/104 = "V"/"h" (matches). 26810 LSB = 186 = INT token (matches). Line 10 only reaches 26773 if it contains a second `;" "`, as the p. 50 prose says; the printed listing lacks it (footnoted). VARS: 26780 + 19-byte FOR variable = 26799 end marker, which matches 26791 STEP, 26796-7 line, 26798 statement, 26799 marker and 26800-26802. The 166/104 and 167/104 pairs do not equal 26783/26784 (they equal 26790/26791) (footnoted). 181/104 = 26805 is correct. 248 - 128 - 64 - 32 = 24, and 24 + 96 = 120 = "x", which is correct.
- **Other arithmetic**: 1200/8 = 150 is correct, but 6912/150 = 46.08, not "27+" (footnoted). 15616 - 15360 = 256 = 32 × 8 is correct. 65367 + 1 + 21 × 8 = 65536 is correct. 64001 + 1535 = 65536 is correct. 24576 + 6912 = 31488 (top of DF2) is correct. 24576 + 6144 - 1 = 30719 is correct. 55 × 256 + 5 = 14085 (< 16384, visible) and 66 × 256 + 5 = 16901 (> 16383, invisible) are both consistent with the text. STRMS 23568-23605 = 38 bytes = 19 streams × 2, which is correct.
- **System-variable addresses**: I checked them against the standard Spectrum/TS2068 sysvar map: BORDCR 23624, VIDMOD 23746, CHARS 23606, RAMTOP 23730, P-RAMT 23732, PROG 23635, VARS 23627, E LINE 23641, WORKSP 23649, E PPC 23625, K CUR 23643, LIST SP 23615, X PTR 23647, ERR NR 23610, S POSNL 23690, DF CCL 23684, S TOP 23660, SCR CT 23692, KSTATE 23552, LAST K 23560, REPDEL 23561, REPPER 23562, K DATA 23565, RASP 23608, PIP 23609, ECHO E 23682, PPOSN 23679, PR CC 23680, CHANS 23631, PPC 23621, SUBPPC 23623, NEWPPC 23618. All agree except DF SZ, which is printed as 2 bytes (footnoted). The 2068-only variables (ERR C 23736, ERR S 23738, ERR LN 23734, ERR T 23739, STRMNM 23755, CURCBN 23743) are consistent with each other, but I had no independent reference for them.
- **Token codes**: NEW = 230, READ = 227, UDG A = 144, SAVE = 248, INT = 186. All correct.
- **Unverifiable**: ROM address 2361 (scroll loop), 0E8EH, PHLAF 004F, page references to the manuals, and the port-assignment table (p. 58). For the port table I only sanity-checked FE = 1 (keyboard/border), F4 = 2, F5 = 4, F6 = 5 and FF = 3; these are consistent with the hex code above, which uses F4 and FF.

## 3. Ambiguous glyphs resolved
- p. 44, line 30 of the hex loader: "65237". I zoomed in and the second digit is clearly 5, not 3. Transcribed as printed; footnote c03-2.
- p. 44, line 45: "(x/2)" has a stray mark that looks like "/-". I read it as "/", because line 50 prints "(x/2)" cleanly. "+Y+256" is clearly a plus in the zoomed crop.
- p. 44: the case of x/X varies between lines (line 40 `X/2`, others `x`). Kept as printed; Sinclair BASIC variable names are case-insensitive.
- p. 49, line 10: `" ."` shows a small dot after the space inside the quotes. I treated it as a speck, because the p. 50 text says the string is a single space ("the 32 stands for the space"). Transcribed as `" "`.
- p. 55, line 35: the string has two spaces (`"  "`), confirmed by zoom.
- Hex loader DATA: 0 vs O, 8 vs B and 3 vs E were each checked in a zoomed crop. The disassembly confirms every byte forms valid, coherent code.
- The Sinclair-listing line wraps inside long BASIC lines ("POKE 1 / 6383", "POKE 2 / 4575", and the DATA string wrapping mid-byte "F / 1") are preserved exactly as printed.

## 4. Silent prose typo fixes
- p. 41: relacement -> replacement; permanant -> permanent; origionaly -> originally
- p. 42: personnal -> personal; Dislay -> Display
- p. 44: curtesy -> courtesy
- p. 47: inteface -> interface
- p. 48: alredy -> already
- p. 52: programing -> programming; Attari -> Atari
- p. 53: occured -> occurred (ERR C entry)
- p. 54: occured -> occurred (ERR S continuation)
- p. 52: "erased the the space" -> "erased the space" (duplicated word)
- p. 56: CAPITOL -> CAPITAL
- p. 58: "the the computer" -> "the computer"
- p. 59: epansion -> expansion; channal -> channel

Left as printed (grammar or period usage, not spelling): "going give", "We have spend", "if its right", "if found", "must made", "attached it", "Okey"/"OKEY", "useable", "chuck full", "RBG", "User,s" (inside a BASIC REM).


## 5. Footnoted technical errors in the original (8)
- c03-1 (p. 41): "27+ seconds"; 6912/150 = 46 s.
- c03-2 (p. 44): loader loop `TO 65237` should be `63237` (38 bytes). Includes the disassembly.
- c03-3 (p. 44): line 45 `+Y+256` should be `+Y*256` (cf. line 50).
- c03-4 (p. 49): "POKE 23730 and 23730" should be 23731.
- c03-5 (p. 49): line 10 listing lacks the second `;" "` that the p. 50 walk-through and the address arithmetic require.
- c03-6 (p. 51): 166/104 and 167/104 are 26790/26791, not 26783/26784.
- c03-7 (p. 54): DF SZ is the single byte 23659, not 23659-23660 (it would overlap S TOP).
- c03-8 (p. 55): `RANDOMIZE USER` should be `USR`; `PEEK y` is probably meant to be `PEEK x`.

Noted but not footnoted:
- p. 45: `FOR x = 24575 TO 30719` starts one byte below DF2 (24576). This is harmless and may be deliberate.
- p. 55: `IF Y >= 255` stops on 255, while the prose says "bigger than 255". This is minor.
- p. 59: "Only 26688-26709 are used" is 22 bytes; 4 channels × 5 + an end marker = 21. This is inconclusive.

## 6. Illegible spots / diagrams
No illegible spots and no non-text diagrams. The port-assignment table on p. 58 is a ```text block. The column positions follow the printed character grid (each LSN column is 2 characters wide), and the printed underlined header is rendered as `0_1_2_..._F`.

## 7. Widest code-block line
65 characters: the p. 58 port table, row "M 7 ... WR Border/Beep/cassette".
# Chunk 04 notes

## 1. Pages covered

PDF 69-88 -> printed pp. 61-78 (printed = pdf - 8 for pdf 69-78; pdf 79-80 are a DUPLICATE SCAN of printed pp. 69-70, so printed = pdf - 10 from pdf 81 on).

- pdf 69-73 (pp. 61-65): end of Ch. 4 "Operating System Variables and Flags" (no heading; chunk starts mid-list at NSPPC), then `## Variable Storage and Search`, `## Flags` (flag table p. 65).
- pdf 74 (p. 66): blank page (only running head). Marker only.
- pdf 75 (p. 67): `# Chapter 5: Beep and Sound`, `## The Beep Command`.
- `## A Simple Experiment From Basic` (p. 68), `## Simulated Sounds From Machine Code` (p. 69), `## Load, Save and Baud Rates` (p. 69), `## Sound Command` (p. 71), `## The Sound Chip Registers` (p. 72), `## Register Values For Notes of the Musical Scale` (p. 73), `## Additional Register Values For Notes of the Musical Scale` (p. 74; TOC calls it "Additional Register Values"), `## An Example` (p. 76), `## Tempo and Note Length` (p. 78).
- pdf 79-80: duplicate scans of pp. 69-70 (pixel-diffed against pdf 77-78: different scans, same content, visually re-checked line by line). Not transcribed twice; an HTML comment records the duplication. The assembler should NOT expect page markers for pdf 79/80.
- pdf 87: sheet-music page, no printed page number (would be p. 77); marked `<!-- p. ? (pdf 87) -->`.
- Chunk ends mid-sentence on p. 78 ("If you").

## 2. Verification

- **Machine-code listing p. 69** (decimal bytes + mnemonics): decoded every byte with an opcode-table script. All 39 bytes match the mnemonics (3E 05 LD A,5; 0E FE LD C,254; 26 00 LD H,0; 16 FF LD D,255; 44 LD B,H; CB E7 SET 4,A; ED 79 OUT (C),A; 10 FE DJNZ self; CB A7 RES 4,A; 24 INC H; 15 DEC D; 20 E2 JR NZ -> offset 8 = "Again", correct; C9 RET). No errors. (Observation, not footnoted: B is reloaded from H only before the 1st and 2nd waits; the 3rd/4th waits run with B=0, i.e. 256 iterations. That is how the code is written, and the prose partly describes it.)
- **Note table p. 73 (100 rows) and p. 74 (8 rows)**: every row checked by script: ideal = 440*2^(n/12), period = C*256+F, actual = 110250/period, and period == round(110250/ideal). All C/F values are correct. Seven printed values disagree with the arithmetic; each was re-checked on 300-dpi crops and is as printed. Five of these are in footnote c04-3 and one (A9) is in c04-4. The 7th, D10 ideal (.548 vs .545), is a rounding difference only and is mentioned inside c04-4.
- **BASIC DATA p. 76**: the 78 values were compared by script with the C,F columns of the note table from G#1 to A#4 (39 notes). They match exactly.
- Prose arithmetic checked: 23-7=16; 3.528 MHz/32 = 110,250; 110,250/16 = 6890.625; 65535/6890.625 = 9.51; 3600/144 = 25; 250,000/8 = 31,250; 8 microseconds = 125,000 bits/s; BEEP -12/-15/-18 = 130/110/92 Hz; 96 = 60H; the KZ/GOSUB byte counts (7, 2, 10, 8, 5, 3) all check. 13.14 T states was wrong (c04-1) and so was 4025 (c04-2).
- The variable-type bit table p. 62 matches the known Spectrum/2068 VARS encoding. System variable addresses (23609, 23611, 23612, 23617, 23620, 23627, 23629, 23637, 23639, 23658, 23662, 23664, 23665, 23697) match the standard Spectrum/2068 map.
- Unverifiable: the "TOKEN SPELL TABLE (addresses 152-550)", the User's Manual page references (187ff, 193, 256, 257), the 95/140 loops-per-second figures, and "65 inches/sec".

## 3. Ambiguous glyphs resolved

- p. 64 "letting kO = 0": read as `k0` (k-zero), since the series continues k1, k2 ... ka ... kf, kg, kh.
- p. 73 G7 actual "2150.000": zoomed, clearly a 2 (the font's 2 and 3 are distinct). Kept and footnoted.
- p. 73 A0 actual "27.506" and A1 "54.998": zoomed, as printed.
- p. 72 "4025": zoomed. It is 4025, not 4095.
- p. 71 "13.14": zoomed, as printed.
- p. 76 DATA line 3 ends "1,14" and line 4 begins "2,": that is the value 142 (C#4 fine) wrapped across lines. The line breaks are kept exactly as printed.
- p. 69 a stray dot before "522.512" (p. 73) and before "T O N E" (p. 72) are speckles, ignored.

## 4. Silent prose typo fixes

- p. 61: "come-/back" (line-end hyphen) -> "come back"
- p. 62: "indefi-/nate" -> "indefinite"
- p. 63: "lets .the" -> "lets the" (stray dot); "harrassed" -> "harassed"
- p. 64: "import- ant" -> "important"
- p. 67: heading "THE BEEP COMAND" -> "The Beep Command"; "calculatar" -> "calculator"; "them. if you want" -> "them. If you want"
- p. 68: "definate" -> "definite"
- p. 70: "havn't" -> "haven't"
- p. 71: "pheneminal" -> "phenomenal" (first occurrence; the second was already spelled correctly)
- p. 72: "(mid-/le C" -> "(middle C"
- p. 75: "tremelo" -> "tremolo"; "resister" -> "register"; "Aternate" -> "Alternate"
- p. 76: "BASE CLEF" -> "BASS CLEF"
- p. 78: "Adgio" -> "Adagio"

Kept as printed: "Z81" (p. 62), "AY-3 8912", "RANDOMISE", "lets", the missing opening quote in `Cantabile means, in a singing manner"`, and the unclosed parenthesis "(these changes are called accidentals as in measures 3, 4, 5, 6, and 7." (p. 76).

## 5. Footnoted technical errors

- [^c04-1] p. 71: 13.14 T states should be about 14.11 at 3.528 MHz (105 = 8 x 13.14).
- [^c04-2] p. 72: max tone period 4025 should be 4095 (12 bits).
- [^c04-3] p. 73 table: A0 actual 27.506 (27.501), A1 actual 54.998 (54.988), A#2 ideal 116.614 (116.541), F#6 ideal 1497.978 (1479.978), G7 actual 2150.000 (3150.000).
- [^c04-4] p. 74 table: A9 actual 13781.000 (13781.250).

Footnote markers could not go inside code blocks, so the table footnotes are attached to the table headings.

## 6. Illegible spots / diagrams

- No illegible text.
- pdf 87: photocopied piano sheet music, scanned sideways. Described in an italic bracket. It is probably Beethoven's "Pathétique" sonata, 2nd movement (Adagio cantabile, A-flat major, 4 flats), but the page does not name it, so the description does not either.
- p. 66 (pdf 74) is blank.

## 7. Widest code line

71 characters: the two-column note table on p. 73 (pdf 83), e.g. `A0      27.500  15  169     27.506   C5     523.251   0  211    522.512`. The note tables were re-spaced into regular columns (the printed spacing was not perfectly uniform); the column order and all values are as printed. The sound-chip register table (p. 72) and flag table (p. 65) were laid out on a character grid measured from the scan.
# Chunk 05 notes

## 1. Pages covered
PDF 89-108 -> printed pp. 79-98 (offset 10). pdf 108 (p. 98) is blank apart from the running head; it has only its page comment. pdf 94 (p. 84) holds one short paragraph.

Headings produced:
- (Chapter 5 continued, "An Example" / "Tempo and Note Length" material runs on from p. 78)
- `## Using the Envelope` (p. 80)
- `## Vibrato` (p. 81)
- `### Tremolo` (p. 81) -- not in the TOC; printed as a peer heading of VIBRATO, made ### under Vibrato
- `## Enhancing Your Program` (p. 82)
- `## Machine Code Sound` (p. 82)
- `## Joysticks` (p. 83)
- `# Chapter 6: The Central Processing Unit (CPU)` (p. 85) -- page prints "CHAPTER 6 / THE CENTRAL PROCESSING UNIT (CPU)"; TOC omits "(CPU)"; kept the page wording
- `## The CPU--Internal Organization` (p. 86)
- `## Our First Machine Code Program` (p. 88)
- `## For Hardware Hackers Only` (p. 92)
- `## Getting An Instruction (M1 Cycle)` (p. 93)
- `## Memory Refresh (Cycle 3 and 4 of M1)` (p. 93; TOC: "Memory Refresh")
- `## M1 Cycle`, `## Memory Read Cycle`, `## Memory Write Cycle` (p. 94) -- TOC entries at p. 94; on the page they are only diagram captions, so I gave each a ## heading plus the caption in bold above its diagram description
- `## I/O Timing Cycle` (p. 95)
- `## Comparing the Z80 with the 8080 and the 6502 CPU's` (p. 96, TOC wording)
- `### 6502 vs. Z80` (p. 96) -- not in the TOC
- `## The Future` (p. 97)
- Bold captions (not headings): REGISTERS OF THE CPU (p. 87), I/O TIMING CYCLE (p. 96)

## 2. Verification
- Machine-code program (pp. 88-89, 65000-65012): checked with a script (c05/verify.py) against a Z80 opcode table: 62=LD A,n; 33=LD HL,nn (0,88 -> 22528); 6=LD B,n; 119=LD (HL),A; 35=INC HL; 5=DEC B; 200=RET Z; 24=JR e. The addresses are contiguous, 13 bytes in all, ending at 65012. JR 250 from 65011 -> target 65007 (LOOP). All correct.
- The BASIC loader DATA (line 135) is byte-for-byte the same as the listing. The FOR range 65000-65012 is 13 bytes. Correct.
- Displacement walk-through on p. 91 (255/254/253 ... 250 at the 119): correct.
- Opcode numbers given in prose (#33, #6, #35, #5, #200, #24, 62): all correct.
- Arithmetic: loop T-states 6+4+4+12=26 correct; 3,528,000/26 = 135,692.3 correct; 65535 loops = 0.483 s ("less than half a second") correct; 25/60 s -> 56538.46 loops, printed 56538 correct; CALL+RET 17+10=27 correct; 22528/256 = 88.0 correct; RED paper 8x2=16 correct; LET A=32 = green paper correct; 32x2=64 attributes correct; 25 -> 24/4 = 6 correct; 16 address + 8 data + power + ground = 26 correct.
- BASIC byte count (p. 92, "105 bytes"): recomputed as 16+20+33+10+19+7 = 105, assuming no stored spaces and a 6-byte number slug. Correct. 105/13 = 8.1, "8 times shorter" correct.
- Music DATA (pp. 79-80): parsed every group as letter + 3 numbers. All lines parse. Durations (E=1, S=.5, TE=.67) sum to 8 eighth-notes per line (180: 8.02 from the triplets), which fits 2 measures of 2/4 per line. Total groups = 67 against `FOR x = 1 TO 68` -> footnote c05-1. Note numbers 31, 33, 26 and 9 are not in the p. 78 staff table, but that table skips accidentals on purpose, so this is not an error.
- The SOUND register usage (7 enable, 8/9/10 loudness, 12 coarse envelope, 13 shape, 0-5 tone, 14/15 I/O) agrees with the AY-3-8912 register map.
- Not cross-checkable: the joystick bit layout, the PRINT FREE base 38652, the Zilog/Mostek addresses (they look plausible), and the p. 93 PPC/SPPC/OSPPC description.
- The python `z80` package imports, but I used a hand opcode table for this short listing.

## 3. Ambiguous glyphs resolved
- p. 79 "5 LET Q = 2 ..." -- Q (not O): it matches the p. 78 abbreviations E, S, Q, TE.
- p. 79 line 5 ends "LET TEM = 25." with a trailing period, printed wrapped across two lines. I joined it into one line and kept the period as printed ("25." is still a valid number in Sinclair BASIC).
- The BASIC lines 65, 70 and 80 wrap mid-expression on the printout ("n(" / "c*2)"). I kept the printed wrapping inside the code block. The DATA continuation lines keep their indentation.
- p. 80 DATA 150: "S,29,20,0,S,30,0,0" -- confirmed S (16th), not 5, by zoom.
- p. 82 "JRNZ, TIME" and p. 101 "JR, Dis": kept the author's notation as printed.
- p. 83 joystick listing: "LD A, 64" read clearly at zoom (6 and 4 distinct).
- The dot-matrix asterisk (shown as a star) is transcribed `*` throughout.

## 4. Silent prose typo fixes
- p. 80: "Channal A" -> "Channel A"
- p. 80: "pluck- ed" (line-end hyphen) -> "plucked"
- p. 83: "necessarilly" -> "necessarily"
- p. 83: "another two chapter" -> "another two chapters"
- p. 86: "definately" -> "definitely"
- p. 87: "equia-lents" -> "equivalents"
- p. 88: "oeratiions" -> "operations"
- p. 89: "tht" -> "that"
- p. 90: "Taking out or handy calculater" -> "Taking out our handy calculator"
- p. 91: "other then A" -> "other than A"
- p. 91: "where we give it an addreses" -> "an address"
- p. 91: "Everytime" -> "Every time"
- p. 93: "maxhine" -> "machine"
- p. 93: "discription" -> "description"
- p. 93: "droping" -> "dropping"
- p. 97: "faster then the Apple II" -> "faster than"
- Not changed (proper nouns or period usage): "Mostec INC." (the company is Mostek) and "Carrolton" (the city is Carrollton) on p. 85, kept as printed; also "insures", "en mass", "TEMpo", "RANDOMIZE USER", "CPU's".

## 5. Footnoted technical errors in the original
- c05-1 (p. 79-80): 67 DATA groups vs FOR 1 TO 68; missing line-end commas in DATA 140-170.
- c05-2 (p. 80): "channel 13 at 13" should be register 13.
- c05-3 (p. 83): NOP is 4 T-states, not 2.
- c05-4 (p. 83): LD A,64 before OUT (245),A should presumably be LD A,14 to select register 14; IN (246),A has its operands reversed (IN A,(246)).
- c05-5 (p. 87): IX/IY offset range is -128..+127, not +/-127.
- c05-6 (p. 95): JR adds to the full 16-bit PC, not only the low byte.
- c05-7 (p. 96): the 6502 clock is ~1-1.8 MHz, not kHz.
- Noted but not footnoted (not wrong): SAVE/MOVE use length 14 for a 13-byte program (p. 92). This saves one extra harmless byte. Also, "Every measure has its own DATA line" while each line actually holds 2 measures of 2/4.

## 6. Illegible spots / diagrams described
- No illegible text.
- Diagrams described in italic brackets: p. 87 Registers of the CPU block diagram; p. 94 three timing diagrams (M1, memory read, memory write); p. 96 I/O timing cycle. The overline (active-low) bars on the signal names are given as "(overlined)" in the descriptions. A stray "MEMORY READ" label at the foot of p. 94 is mentioned inside the write-cycle description.

## 7. Widest code-block line
66 characters: the p. 89 listing line "65010   200                      RET Z          DONE-back to Basic" (the machine-code listing block spanning pp. 88-89).
# Chunk 06 notes

## 1. Pages covered
PDF 109-128 -> printed pp. 99-118 (offset 10, every page carries a printed number).

Headings produced:
- `# Chapter 7: Machine Code--Assembly Language` (p. 99)
- `## Other Conventions Used` (99)
- `## The Flag Register` (100)
- `## The Z80 Assembly Instruction Set` (101; in-page heading, not in TOC)
- `## Load Instructions` (101)
- `### Code for Load of a Single Register`, `### Code for Load of Double Registers`, `### Special Load Instructions` (103)
- `## Block Move Instructions` (104)
- `## Jumps, Jump Relatives, Calls and Returns` (104)
- `### Code for Jumps, Calls and Returns` (106)
- `## Converting Spectrum Programs to the 2068` (106)
- `## Moving Code to a Different Location` (107)
- `## Saving Registers--EX, EXX, PUSH and POP, DI and EI` (108)
- `### Going Further` (110; in-page, not in TOC)
- `## Timing` (111)
- `## More Ways to Save Registers` (112)
- `### Code for PUSH, POP, Exchange and DI/EI` (113)
- `## Simple Arithmetic and Logic` (113), `### INC and DEC` (113), `### ADD, ADC, SUB and SBC` (113)
- `## Logic` (114), `### AND, OR and XOR` (115)
- `## Other Simple Math Operations` (116)
- `## Checking Bits. BIT, SET and RESET` (116) -- the parenthetical "(All these instructions require a 203 (CB) prefix.)" was part of the printed heading line; moved to its own paragraph.
- `### Codes for Math, Logic and Bit Operations` (117)
- `## Multiply and Divide--Rotate and Shift` (118), `### Multiplying` (118)

TOC levels followed (INC and DEC / ADD... / AND, OR and XOR / Multiplying are indented in the TOC -> `###`).

The flag descriptions (CARRY, ZERO, SIGN, OVERFLOW/PARITY, HALF CARRY) are hanging-indent paragraphs in the original; rendered as pandoc definition lists. Same for the rotate/shift diagram list on p. 118.

## 2. Verification
Script: scratchpad/verify06.py (Z80 opcode formulas, decimal).
Checked every code in: single-register LD table (p103), double-register LD table, special loads, block moves (p104), jump/call/ret table (p106), PUSH/POP/EX/DI/EI table (p113), CPI/CPIR/CPD/CPDR (p114 and p117), the full math/logic table, 16-bit ADD/ADC/SBC/INC/DEC table, and all 8x9 BIT/RES/SET rows (p117). Also INC HL = 35, LD A,6 = 62,6, CP L = 189, CPL = 47, NEG = 237,68.
Discrepancies (all re-checked on 300-dpi zoomed crops; all are as printed -> footnoted):
LD H,C 94 (97); LD A,(nn) 55 (58); LD HL,(nn) alt 237,106 (237,107); CALL PE 234 (236); CPI 237,167 on p114 (237,161; p117 gives 161); BIT 0,A 70 (71).
24-byte attribute-scroll program (p109/110): hand-encoded from the mnemonics and compared with DATA line 125 -> exact match, including JR NZ displacement 247 and LD (22528),A = 50,0,88; 24 bytes ending at 65023 as stated.
Counting-loop displacement example (p105): 251 confirmed.
Logic examples (p115): all binary/decimal values checked; XOR 84 example inconsistent (binary is 85) -> footnote.
Arithmetic: 20+113=133 ok, signed -125 wrong (-123) -> footnote; IY 23610 + 245 -> 23599 not 23600 -> footnote; 1000 = 3/232, 255+232 = 231 carry, 1024+231 = 1255 ok; T-states 6+4+4+12 = 26, 3,528,000/26 = 135,692.3, 20000 loops = 0.147 s, PAUSE 8.8 (8.84 truncated) ok; DAA 26+35: 0101 1011 -> 0110 0001 ok.
Unverifiable: none of significance (prose only otherwise).

## 3. Ambiguous glyphs resolved
- p103: "55nn" (LD A,(nn)) and "94" (LD H,C) zoomed — clearly printed so, not misreads.
- p103: "237,106,nn" zoomed — clearly 106.
- p114: CPI "237,167" zoomed — clearly 167.
- p113 double-register table: the "34,nn or" under HL,IX*,IY* in the LD (nn) row continues on the next line as "237,99,nn" (LD (nn),HL alternate ED 63h, correct); layout kept as printed.
- Headings printed "MULTIFLY"/"MULTIFLYING"/"EXCHANCE": "F" is this printer's P glyph (cf. "Fage"); rendered Multiply/Multiplying; "EXCHANCE" -> "Exchange" (typo fix).

## 4. Silent prose typo fixes
- p99: preferrably -> preferably
- p100: instrutions -> instructions; reseting -> resetting; Compliment Carry Flag -> Complement Carry Flag
- p101: seting -> setting; 2's complimented (overflow para) -> complemented
- p102: resemblence -> resemblance; comimg -> coming; Futher -> Further
- p104: havn't -> haven't; asolute -> absolute
- p105: 2's complimented -> complemented; Similarily -> Similarly
- p106: begining -> beginning
- p108: we ae using -> we are using
- p111: Suprised -> Surprised
- p112: this is alway a full -> always; it alway must be -> always; poped -> popped; programer -> programmer; Similarily -> Similarly
- p113: varitions -> variations; heading EXCHANCE -> Exchange
- p114: milage -> mileage; Similarily -> Similarly
- p115: necessaary -> necessary
- p116: whereever -> wherever
- p118: commmands -> commands; Similarily -> Similarly
Left as printed (period/author usage or not clearly typos): "everytime", "interchangably", "Mostec" (company name, = Mostek), "let's" for "lets", "this purposes", "CPL only work", "JRNZ, again" (in listing), "attrbutes" (inside BASIC REM, code), "RANDOMIZE USER" (p110 prose), unbalanced "(based on the condition of a flag in the F register." (p104), "XOR Exclusive OR)." (p115).

## 5. Footnoted technical errors (14)
c06-1 -125 should be -123 (p101). c06-2 IY+245 = 23599 not 23600 (p102). c06-3 LD H,C 94->97 and LD A,(nn) 55->58 (p103). c06-4 LD HL,(nn) alt 237,106->237,107 (p103). c06-5 LDI still uses/decrements BC (p104). c06-6 CALL PE 234->236 (p106). c06-7 sign/parity conditions are usable for JP/CALL/RET, not JR (p106). c06-8 BASIC line 10 to 23298 overruns attribute file (ends 23295) (p109). c06-9 "EX DE, IX" 253,235 line; neither EX DE,IX/IY exists (p113). c06-10 INC/DEC do not affect carry (p113). c06-11 CPI 237,167->237,161 (p114). c06-12 XOR 84 example uses 85 (p115). c06-13 BIT 0,A 70->71 (p117). c06-14 SRL is shift right logical, printed "shift left logic" (p118).
Footnote markers for table errors (c06-3, -4, -6, -9, -11, -13, -12) sit in a standalone paragraph directly after the relevant code block, since a marker cannot go inside a fenced block.

## 6. Illegible spots / diagrams
No illegible text.
p118: rotate/shift diagrams (RLC, RRC, RL, RR, SLA, SRA, SRL, RLD, RRD, DAA) are hand-drawn box-and-arrow figures; each described in an italic `*[Diagram: ...]*` beside its printed label.
Representation choice: in the AND/OR/XOR examples (p115) and the DAA example (p118) the second operand is underlined in the original; rendered as a "--------" rule line beneath it inside the text block (the rule line is not in the original).
Page breaks inside the BASIC listing (p109/110): the code block is closed before the page comment and reopened after.

## 7. Widest code-block line
71 characters: header row of "Code for Load of Double Registers" table (p103, pdf 113).
# Chunk 07 notes

## 1. Pages covered
PDF 129-148 -> printed pp. 119-138 (pdf = printed + 10). pdf 137 (p. 127, chapter opening) has no printed page number -> `<!-- p. ? (pdf 137) -->`.

Headings produced:
- `## Multiplication and Division by Any Number` (p.119; TOC: "Multiply and Division by any Number")
- `## Division--Successive Subtractions Giving Integer Value Only` (p.120)
- `## Floating Point` (p.121)
- `### Codes for Shift, Rotate and BCD Arithmetic` (p.122; not in TOC)
- `## IN/OUT` (p.122)
- `### Codes for IN/OUT Commands` (p.123; not in TOC)
- `## Restarts (RST)` (p.123)
- `### Codes for Restarts` (p.124)
- `## Miscellaneous Instructions`, `### Codes for Miscellaneous Instructions`, `## Extra Instructions` (p.125)
- `### The Missing CB Instructions 48-55` (p.125; a lead-in line in the original, made a subheading)
- `### Codes for Extra IX and IY Instructions` (p.126)
- `# Chapter 8: The Floating Point Calculator` (p.127)
- `## A Note About Precision`, `## The Technique`, `## Loading and Unloading the Stack`, `### Integers`, `## Already Slugged Numbers`, `## Decimal Numbers`, `### Putting It All Together--A F.P. Example`, `## Digging Deeper`, `## Normalizing Numbers`, `## Floating Point Additions of Exponentiated Numbers` (text wording; TOC says "Addition of Exponented"), `## Floating Point Subtraction of Exponented Numbers`, `## Multiplying Two Slugged Numbers`.
- TOC lists "Floating Point Operations ... 129" but there is no such heading on p.129 in the text; none was invented. The assembler may want to insert `## Floating Point Operations` before the "Machine code numbers following a RST 40..." paragraph / opcode table on p.129.
- "INTEGERS:" and "ALREADY SLUGGED NUMBERS:" labels were kept inside their text blocks as well as being made headings.

## 2. Verification
Script: scratchpad/c07/verify.py (opcode-formula checks), plus inline checks.
- CB shift/rotate table (p.122), RLD/RRD/DAA, unprefixed RLCA/RRCA/RLA/RRA: all match Z80 opcodes except SRL indexed "63d" (footnoted c07-2).
- Block I/O codes INI..OTDR (p.122), IN r,(C)/OUT (C),r table, IN A,(n)/OUT (n),A (p.123): all correct.
- RST codes 199..255, IM0/1/2, HALT, NOP (pp.124-125): correct.
- SLL codes CB 30-37 (pp.125-126): correct.
- Undocumented IXH/IXL table, additional NEG and RETN codes (p.126): all correct.
- F.P. calculator table (pp.129-131): DEC == HEX checked for all 62 rows (00-3D): consistent. Operation names/descriptions not cross-checked against a 2068 ROM listing.
- Quadratic example (pp.133-134): bytes checked (LD A,n=62; CALL 12518 -> 205,230,48; CALL 12705 -> 205,161,49; STK MEM 4/5 = 196/197; GET MEM 4/5 = 228/229; SQR 40, NEG 27, Add 15, Duplicate 49, Multiply 4, Exchange 1, SUB 3, Divide 5, END 56, RST 40 = 239). Stack sequence simulated: result 5, which solves 2X^2+3X-65=0. "LD A,191 does not stack -65": 191 = 256-65, correct.
- Multiplication 47x7 (pp.119-120): binary additions verified (47+94=141, 141+188=329). Routine logic simulated mentally: OK.
- Complex division routine (p.120) simulated in Python (c07/div.py): works with D=divisor, E=0 (remainder in H). Footnoted label truncation/OR A,A (c07-1).
- BASIC PEEK expressions (p.121): arithmetic consistent.
- Precision arithmetic (p.127-128): 32/3.33 = 9.6, 16x3.33 = 53.28, 1000 = 11 11101000 (10 bits): correct.
- Normalization 65535 -> 144,127,255,0,0 and -65535 -> 144,255,255,0,0: correct.
- Exponent table (p.136): computed 65535/65536 x 2^(e-128); all match except exp 137 (footnote c07-3).
- Addition example (p.137): shift by 6 -> 03FFFC00, sum 1 03FEFC00, normalized 81FF7E00 at exp 145: all binary rows correct; stated decimal value wrong (c07-5).
- Subtraction example (p.138): CPL FC0003FF, INC FC000400, sum 1 FBFF0400: all correct; 64511 correct; final decimal wrong (c07-6).
- Unverifiable (no 2068 ROM disassembly to hand): ROM addresses 12518, 12521, 12640, 12691, 11892, 12207, 12406, 12377, 12705, the range 12377-15496; system variable addresses 23645, 23651-23654, 23698 (these match Spectrum-family values CH_ADD 5C5D, STKBOT 5C63, STKEND 5C65, MEMBOT 5C92); the 0.09999999957 example; Logan book title.

## 3. Ambiguous glyphs resolved
- "IMO/IM1/IM2" (p.125): font's 0 vs O; read as IM0 (zero), since the instruction is IM 0 and code 237,70 = ED 46.
- "M0-M2", "M0-M3" etc. in fp table: read as M-zero (memory 0).
- p.138 first row "0000 000Q": last glyph is a 0 with a stray underline mark; transcribed 0000 0000 (CPL of it gives 1111 1111, consistent).
- p.122 "OUTD 237,171." trailing period kept as printed (looks like a stray dot).
- p.129 "Hewlette-Packard": kept as printed (proper name spelling, not silently fixed).

## 4. Silent prose typo fixes
- p.121: "a fraction in the our divide routines" -> "in our divide routines"
- p.122: "perpheral" -> "peripheral"; "IN/ OUt's" -> "IN/OUT's"
- p.123: "for the the code" -> "for the code"
- p.124: "not to useful" -> "not too useful"
- p.125: "operation's SL and INC" -> "operations SL and INC"
- p.127: "explaination" -> "explanation"; "maximun" -> "maximum"
- p.128: "calcuclate" -> "calculate"; "You you have to do" -> "you have to do" (sentence "All you have to do"); "eponent" -> "exponent"; "funct-ions" rejoined
- p.131: "programer" -> "programmer"; "trigonometic" -> "trigonometric"
- p.133: "alter-\nnatives" (odd hard break) -> "alternatives"
- p.137: "accomodate" -> "accommodate"
- p.138: "tht" -> "that"; "let's chose" -> "let's choose"
- NOT fixed (inside code/table blocks, kept as printed): "Relace", "bd", "ACN", "B,M0-m3", "MPX multiplicand"; prose "f.p. calculator use", "Operations ... consists", "It's accuracy", "as this point", "lets use" left as author's grammar.

## 5. Footnoted technical errors
- c07-1 (p.120): `DJNZ, Loo` truncated label; `OR A, A`; routine needs E=0.
- c07-2 (p.122): SRL (IX+d)/(IY+d) printed 63d; should be 62d.
- c07-3 (p.136): exp 137 printed 512.9921875, should be 511.9921875; "131.070" should be 131,070.
- c07-4 (p.136): prose "31.995117900" vs table 31.99951171875 (missing 9).
- c07-5 (p.137): "66558.983475" should be 66558.984375.
- c07-6 (p.138): "65411.015625" should be 64511.015625.
Total: 6 footnotes.

## 6. Illegible spots / diagrams
- No illegible spots. No diagrams.
- Underlined addition operands (p.120 "01011110", "__10111100"; p.138 "___1111_1100__..."; "Starting MPC" row) are rendered as a separate dashed rule line beneath the operand inside the text block, instead of underlines/underscores.
- p.124 RST 24 / RST 32 were printed side by side with a shared description column; rendered as two lines (pandoc hard break) followed by the description.
- p.131 list of routine handling instructions rendered as a pandoc line block.
- p.138 multiplication example continues on the next chunk (stops after "Starting MPC").

## 7. Widest code-block line
67 characters: p.130 (pdf 140) fp table row "50  32  X mod Y        Relace 2 top values with INT(X/Y) on top and".
# Chunk 08 notes

## 1. Pages covered
PDF 149-168 -> printed pp. 139-158 (offset: printed = pdf - 10). p. 147 (pdf 157, chapter opener) has no printed number; it was inferred from the sequence.

Headings produced:
- `## Dividing Slugged Numbers` (p. 139)
- `## Print a F.P. Number/Decimal to F.P.` (p. 142)
- `## Converting Binary Fractions To Decimal Fractions` (p. 144)
- `## Rounding And Using Scientific Notation` (p. 144)
- `## Graphics--PLOT and DRAW` (p. 144)
- `### DRAW` (p. 146; not in the TOC, so made a subsection)
- `# Chapter 9: Peripherals` (p. 147)
  - `## Dot Matrix Printers`
    - `### Escape Codes`, `### Dot Matrix Pixels`, `### Designing Your Own Dot Matrix Characters`, `### DIP Switches`, `### Word Processors`, `### Word Processor Limitations`
  - `## The Keyboard` (p. 153)
    - `### Keyboard Routines`
      - `#### A Completely Dead Keyboard`, `#### Caps Lock`, `#### Reading The Whole Keyboard`, `#### Testing Last K`
    - `### Fast Action--Just Activating Part Of The Keyboard` (the TOC wording is "Fast Action--Just Reading Part of Board"; the in-page wording is kept)
    - `### Break?`, `### Input` (the heading sits at the foot of p. 156 and its text is on p. 157), `### Redefining The Keyboard`
  - `## Graphic Pixel Generation` (p. 158)

The chunk opens mid-section, partway through "Multiplying Two Slugged Numbers" from p. 138. That section's heading is in the previous chunk.

## 2. Verification
- **p. 139 multiplication table (FFFFh × CCCCh, set up on p. 138):** I checked every NEW ANS against OLD ANS + shifted MPC with Python, and checked each MPC shift (single or double SR). All shifts are correct. 5 of the 6 additions are consistent with the printed figures. The 5th-step addition is wrong in the original: it gives B8 where 38 is correct, and the error carries through every later line. I confirmed this against the true product FFFF×CCCC = CCCB3334h; the printed final answer is CCCBB334h. See footnote c08-1. I also checked the exponent prose: 144 + 1 = 145, but the book prints 149 (footnote c08-2).
- **pp. 140-141 division 65535/25:** I traced each RL/SUB step in hex by hand: 37FF, 6FFE, DFFC-C800=17FC, 2FF8, 5FF0, BFE0; RR divisor 6400; 5BE0, B7C0→53C0, A780→4380, 8700→2300, 4600 n/p, 8C00→2800, 5000 n/p, A000→3C00, 7800→1400, 2800 n/p, 5000 n/p, A000→3C00. All remainders match the print. The final mantissa A3D.666…h = 2621.4 is correct, and so are the exponents 145 - 133 + 128 = 140.
- **p. 141 fraction table:** Python, using exact fractions, confirmed each 2^-k value and the sum 0.3999996185302734375 against the printed `.399 999 618 530 273 437 5`. I also confirmed 2048+512+32+16+8+4+1 = 2621 = 1010 0011 1101b.
- **p. 143 BCD doubling (ADC/DAA) table for 65535:** I simulated the 16 rotations over MEM1/2/3 in Python. Every raw ADC value, DAA result and carry matches, and the final 06 55 35 is correct.
- **p. 144 ×10 fraction table (.11111111b = .99609375):** Python check. One original error: the remainder after the 5th ×10 is printed .0011 0000 but should be .0110 0000 (footnote c08-3). All other lines are correct.
- **p. 145-146 PLOT listing:** this is source only, with no bytes, so I could not assemble it against anything. I checked the logic by hand: the AND masks 192/7/64/199/56 are correct for the stated layout. The `LD A,192` is an off-by-one error and `DJNZ, Loop` has a stray comma (footnote c08-5). The prose about which bits go where contradicts the listing (footnote c08-4).
- **System variable addresses:** checked against the Spectrum/2068 layout. LAST K 23560 (5C08h), FLAGS 23611 (5C3Bh) = IY+1, MODE 23617 (5C41h) and FLAGS2 23658 (5C6Ah) are correct. 8201 = 2009h is correct. 219 = 1101 1011b has bits 2 and 5 low, which is correct for sections 2 and 5. The 254/253/251/247/239/223/127 section values are correct; 191 is labelled 7F where it should be BF (footnote c08-10).
- **p. 158 BASIC DATA loader:** I zoomed the DATA lines and re-read them twice. There are 38 + 38 values for 40 + 39 POKEs (footnote c08-11). The loader POKEs data with no assembly listing to pair it with, so the byte values themselves cannot be cross-checked. I decoded them as ASCII and they look like Dvorak-ordered letter tables.
- **Unverifiable:** the ROM routine addresses on p. 155 (688/737/822/860/881), the PRINT F.P. routine "at 12705 ... 422 bytes", 23556 as the CAPS key code, and Appendix B "page 242" of the User's Manual. These are all left as printed.

## 3. Ambiguous glyphs resolved
- p. 139: "149" in "at this point it's 149". I zoomed in and it is clearly 149 (footnoted).
- p. 140: in "RL REM 1010 0111", the last digit looked like "j/1" on the scan; I read it as 1, since the RL of 0101 0011 1100 requires it.
- p. 140: "RL REM 0100 0110 0000 0000. 0000" has a stray period printed after the 2nd group; I kept it as printed.
- p. 141: "RL REm" has a lower-case m in the original; I kept it.
- p. 150: "DIF SWITCHES". The dot-matrix P lost its stroke; the TOC has "Dip Switches", so I rendered it "DIP Switches".
- p. 160 (printed 150): "ÈSC/$/1" has a stray mark over the E; I rendered it ESC/$/1.
- p. 156: "earlier-" at the line end, then "sections" on a new line. I rendered it "earlier--sections" as the author's double dash, broken across the line.
- p. 158: the DATA lines wrap mid-number ("1 / 03", "1 / 29", "13 / ,78"). I kept the wrap exactly as printed inside the code block.
- Throughout: the dot-matrix P/F and 3/5 shapes were resolved from context and by zooming at 300 dpi.

## 4. Silent prose typo fixes
- p. 140: "higest" -> "highest"
- p. 142: "stact" -> "stack"
- p. 143: "ommited" -> "omitted"
- p. 147: "unchangable" -> "unchangeable"
- p. 148: "as as such" -> "and as such"; "char- acter" -> "character"; "chacharacters" -> "characters"
- p. 149: "havn't" -> "haven't"
- p. 150: "becuase of it's" -> "because of its"; "Leed LS6 2LL" -> "Leeds LS6 2LL"
- p. 151: "pro- gram" -> "program"; "Taswide" -> "Tasword"
- p. 152: "Dispite" -> "Despite"; "fuctions" -> "functions"
- p. 155: "code in in LAST K" -> "code in LAST K"; "Lask K" (in prose) -> "Last K". It is left as "Lask K" in the code-comment, and footnote 9 mentions it.
- p. 156: "keybaord" -> "keyboard"
- p. 157: "fsst" -> "fast"
- Kept as period spelling: "venders", "every-time", "nybblewise", and "Try through." (the author's joke answer).
- p. 141, the side note reading "as alter- sequences of 0110" is kept as "alter-sequences" because the intended word is unclear (alternate/alternating). I set this side note, which runs beside the table in the original, as an italic paragraph after the table.

## 5. Footnoted technical errors in the original (11)
1. c08-1 (p. 139): the 5th-step addition is B8 instead of 38, and the error carries through to the final answer CCCBB334 (it should be CCCB3334).
2. c08-2 (p. 139): the exponent is printed 149 and should be 145.
3. c08-3 (p. 144): the ×10 remainder is .0011 0000 and should be .0110 0000.
4. c08-4 (p. 145): the prose bit mapping says L bits 5-0 (should be 4-0) and pixel "Bits 1-3" (should be 2-0).
5. c08-5 (p. 145): `LD A, 192` should be 191; `DJNZ, Loop` has a stray comma.
6. c08-6 (p. 148): #13 is called linefeed; it is CR.
7. c08-7 (p. 153): `IN (C), A` should be `IN A, (C)`.
8. c08-8 (p. 155): Keyhit is called bit 3 of FLAGS; it is bit 5, as the book's own listing uses.
9. c08-9 (p. 155): `JR NZ, Again` makes the wait loop's logic inverted.
10. c08-10 (p. 156): 191 is labelled (7F) and should be (BF); `IN (C), A`; `JR Z` after CPL/BIT is inverted.
11. c08-11 (p. 158): there are 76 DATA values for 79 READs.

## 6. Illegible spots / diagrams described
- There were no illegible spots.
- p. 153: the keyboard section/bit diagram is redrawn as an ASCII ```text block, with an italic *[Diagram: ...]* caption.
- p. 157: the Dvorak keyboard box diagram is redrawn as an ASCII box ```text block, with an italic caption.
- p. 158: the 2×2 quadrant label box (#2 #1 / #8 #4) is redrawn as an ASCII box.
- Underlining in the binary arithmetic tables on pp. 139-141 (the operand row underlined before a sum) is shown as a dashed line under that row. The original underlines are dot-matrix underscores.
- Underlined headings on pp. 154-156 ("A_Completely_Dead_Keyboard." etc.) are converted to plain headings without the trailing periods.

## 7. Widest code-block line
75 characters: the "SEC 3 ... SEC 4" row of the keyboard diagram on p. 153. The widest numeric table line is about 68 characters (p. 139 table rows).
# Chunk 09 notes

## 1. Pages covered
PDF 169-188 -> printed pp. 159-178 (printed = pdf - 10). Printed p. 168 (pdf 178) is blank; only its page marker is emitted.

Headings produced:
- (chunk opens mid-section "Graphic Pixel Generation" of Chapter 9, p. 159; no heading emitted)
- `## Microdrives`, `## Modems`, `### Connecting Up`, `### Bulletin Boards`, `## Disk Drives`,
  `### Use of Single Sided Disks`, `### Care of Floppies`, `### Disc Density` (printed "DISC DENSITY"; TOC says "Disk Density" -- kept text spelling),
  `### The 5.25 Inch Floppy`, `### DOS--Disk Operating System`
- `# Chapter 10: Advanced Concepts--I/O Porting and Bank Switching`
- `## The SCLD`, `## Bank Switching--An Overview`, `## The Function Dispatcher`,
  `### RAM Resident Code (25088-26688)` (TOC calls this subsection "Corrections For"; in-page heading wording kept),
  `## AROS and Bank Switching`, `## Cartridge Initialization`, `### Errors in AROS Routine`, `### Cartridge Setup`
- TOC entries "Ram Resident Code Routines" (p.176) and "Function Dispatcher Service Codes" (p.178) have no in-page heading; none invented.
- Run-in labels kept as bold: PARITY:, WORD SIZE:, STOP BITS:, DUPLEXING., USE OF A BUFFER., LROS Display File.

## 2. Verification
- p.159 pixel routine (no bytes printed): hand-assembled byte count = 26, book says 28 -> footnote c09-1. 16 x 8 = 128 correct.
- p.172-173 correction program (address/bytes/mnemonic): script checked address continuity (all consistent, 65000-65100), 16-bit operands vs bytes, 8-bit immediates. Discrepancies: 65001 `21,30,FE` = 65072 vs DATA B at 65060 (c09-3); 65015 `01,1A,00` = 26 vs "LD BC, 25" (c09-4); 65050 `3E,FB` = 251 vs "LD A, 253" (c09-5). All three re-checked on zoomed crops -- printed exactly so. DATA B disassembles to coherent code (JR Z/CP FF/AND A/LD C,FF/IN A,(FF)/AND 80/IN A,(F4)/CPL/LD C,A; POP BC/POP DE/LD (HL),E/INC HL/LD (HL),D/DEC HL), and block sizes 9+26+6 = 41 match the data layout. Fix targets match the routine table (25408 in PUT WORD 633B; 25610/25648 in GET BANK STATUS 6405; 25753 = BANK ENABLE 6499; 25930 = RESTORE STATUS 654A).
- p.173 POKE table: DOWN 205,92,99 = CALL 635CH (WRITE BANK STATUS REG); UP 205,28,251 = CALL FB1CH; 205,232,102 = CALL 66E8H vs UP 205,168,254 = CALL FEA8H. Every UP address/target = DOWN + 38848 = 63936 - 25088. All consistent.
- p.176 routine table: every high address = low + 38848 (97C0H), all 17 rows OK.
- p.164-165 disk arithmetic: 2.3*pi = 7.22, 4.0*pi = 12.57, 1/48 = 0.021, 40/48 = 0.833, 40960/12.57 = 3258 bits/in, 1/3258 = 0.00031, 3/1200 = 0.0025 -> 400/in: all OK. "5125 bytes/track" and "205,800" wrong (c09-2); 1.64 MB and 3.28 MB OK with 204,800.
- p.161 modem: 8+1+1 = 10 bits -> 30 bytes/s at 300 baud; 4+1+1 = 6 -> 50 bytes/s, 66% faster: OK. 16k at 300 baud "over 7 minutes" OK (7.3 min at 8 bits).
- p.175: 56 = 38H, 102 = 66H, 23698 = 5C92H, 244 = F4H: OK. p.174: 00001111 active-low = chunks 4-7: OK.
- Unverifiable: prices, Aerco bytes 23856-23863, sys-var addresses 23740-23755, 31510/26710/32553, service code table descriptions, "8N+236 to 8N+246" T states.

## 3. Ambiguous glyphs
- pdf 169 (p.159) first listing line: small, slightly smudged register letter in "LD ?, A" -- read as B (the routine then rotates B; H makes no sense).
- pdf 182 65001 bytes: zoomed 3x, clearly "30" not "24".
- pdf 183 65050: zoomed, clearly "FB" and "253".
- ED,B0: "B0" (B-zero), standard LDIR.

## 4. Silent prose typo fixes
- p.159: "goes a follows" -> "goes as follows"; "Srectrum" -> "Spectrum"; "inherant" -> "inherent"; hyphenation rejoins (miniaturized, continuous, necessary, required, addition, uninitiated, slowly, programs, malfunction).
- p.160: "malfunct-ion" rejoined.
- p.162: "pos- sible" -> "possible"; "uplaod" -> "upload"; "havn't" -> "haven't".
- p.163: "personnel computer" -> "personal computer"; "venders" (x2) -> "vendors"; "Portugese" -> "Portuguese".
- p.164: "different then your" -> "different than your"; "singals" -> "signals".
- p.165: "appopiate" -> "appropriate".
- p.166: "discription" -> "description".
- p.170: "handes" -> "handles".
- p.171: "tht" -> "that".
- p.172: "Chpater" -> "Chapter"; "fuctions" -> "functions"; "tranfers" -> "transfers".
- p.169: "keybord" -> "keyboard".
- p.174: "addresss" -> "address"; "Them memory" -> "Then memory"; "ommissions" -> "omissions".
- p.177: "discription" -> "description"; "asterick" -> "asterisk".
- NOT changed: code comment "mybble" (p.159, in code block); "RBG" (p.160, x2, probably RGB -- technical term, left as printed); "wirein", "Disc Density", "what Bank hold", "the tracks becomes", "chose".
- p.177 numbered list: original numbers the last two items "6." and "6."; the Markdown list numbers them 6 and 7 (pandoc renumbers ordered lists anyway). Item 1's unclosed parenthesis kept as printed.

## 5. Footnoted technical errors
- c09-1 (p.159): routine is 26 bytes, not 28.
- c09-2 (p.165): 5125 -> 5120 bytes/track; 205,800 -> 204,800 bytes/side.
- c09-3 (p.172): `21,30,FE` should be `21,24,FE` (DATA B at 65060).
- c09-4 (p.173): `LD BC, 25`/"For 25 bytes" should be 26 (bytes 01,1A,00 are right).
- c09-5 (p.173): `3E,FB` vs `LD A, 253` inconsistent; which is intended not established.

## 6. Illegible / diagrams
None illegible. No diagrams. pdf 178 (p.168) blank page. The correction listing is split into two z80 blocks at the p.172/173 page break so the page marker is not inside a fence.

## 7. Widest code line
68 characters: correction listing line "65039  32,99,64 ... LD (25753), A  and RESTORE STATUS" (p.173). Mnemonic column in that listing normalised to a fixed column 35.
# Chunk 10 notes: PDF pages 189-208 (printed pages 179-198)

## 1. Pages covered and headings

- PDF 189-208 = printed pp. 179-198. Printed page = PDF page - 10 throughout.
- pp. 179-187 (top): the rest of the Chapter 10 "Function Dispatcher Service Codes" table (codes 32-145). No heading is emitted, because the section heading and the column header ("CODE SERVICE / SETUP and RETURN") are on p. 178 (pdf 188, chunk 9).
  - FORMAT DECISION FOR THE ASSEMBLER: I put the table in ```text blocks, one per page, with columns at code = col 0, service = col 5 and description = col 26. I kept the printed line breaks and end-of-line hyphenation. I collapsed the multiple spaces from print justification inside descriptions to single spaces. Chunk 9 should use the same layout for codes 00-31 so the table is consistent. Entry 106's long name runs into the description column, as it does in print.
  - The single prose paragraph on p. 184 ("The following routines all use the floating point calculator...") splits the table into separate blocks.
- Headings produced:
  - `## Horizontal Select Register` (TOC p. 187)
  - `### Bank Switching` (in-page heading, not in TOC)
  - `### Enabling the EXROM` (TOC "Enabling ExROM")
  - `### Port 254` (in-page heading, not in TOC)
  - `### Enabling a Bank of Extended Memory`
  - `### Enabling Chunks in the Dock Bank`
  - `### Enabling More Chunks of the EXROM`
  - `# Appendixes` (top level, like a chapter; TOC "APPENDIXES ... 191")
  - `## Appendix A: Timing Tables`
  - `## Appendix B: A Machine Code Print & Input Routine` (wording from the TOC). The in-page title "A PRINT ROUTINE THAT WORKS LIKE A BASIC PRINT STATEMENT" is `###`.
- The appendix list on p. 191 is a 2-column pipe table with an empty header row.
- The chunk ends at p. 198 (pdf 208) partway through the Appendix B listing, after 65093 RRCA. Appendix C (the complete code table, p. 202) is NOT in this chunk. It starts at pdf 212, so it belongs to chunk 11.

## 2. Verification

- **Appendix B machine-code listing (64724-65093, 5 pages):** I transcribed it into a pipe-delimited file and checked it with a Python script. The script uses a hand-built Z80 decoder covering every unprefixed opcode and CB-prefixed opcode that appears in the listing.
  - Checks:
    - (a) Address continuity: each address = previous address + byte count.
    - (b) Each byte sequence decodes to the printed mnemonic and operand. This covers 23695/23697 from 143,92 and 145,92, and every immediate value.
    - (c) Every JR displacement resolves to the address of the label it names.
  - Result: all decode and match except the original errors listed in section 5 (CP 6/8, 214 SUB vs ADD, 65942, 198,2 vs ADD 8, and two JR Z displacements that are off by one).
  - JR targets that could not be checked here:
    - `JR Z, OUT` at 64996 and 65006 both resolve to 65121, so OUT is presumably at 65121.
    - `JR C, GRAPHIC` at 65026 resolves to 65123.
    - Both targets are past p. 198, so chunk 11 should confirm OUT = 65121 and GRAPHIC = 65123.
  - Observations, not footnoted:
    - `JR NC, OUT` at 64727 and 64741 (INK/PAPER) both resolve to 64795 ("JR RET NEXT CHAR"), not to the later OUT label. Both are consistent, and the effect is to skip the bad colour byte, so I take this as intentional. The "OUT" comment is loose.
    - `JR NXT CHAR` at 64861 lands on 64988, which is itself `JR NXT CHAR` (a trampoline, since 65000 is out of range). This is valid.
- **Appendix B DATA (64000-64178):** decoded with a script into tokens and text. Result:
  `AT 1,13 PAPER 6 INK 4 FLASH 1 "Hello." FLASH 0 TAB 7 INK 2 PAPER 5 "I,m your frienndly" PAPER 6 INK 0 '' TAB 5 [139,131x19,135] TAB 5 [138] INVERSE 1 "TIMEX/SINCLAIR 2068" INVERSE 0 [133] TAB 5 [142,140x19,141] '' TAB 11 INK 1 BRIGHT 1 "Computer." '' TAB 5 [144]"What is your name?r" AT 12,14 OVER 1 "____ ____" OVER 0 OVER 0 END`
  I compared this against the BASIC line printed above it; the mismatches are footnoted. I also checked the byte count per line: line 64030 has 11 bytes, and every other line has 10 (the last line has 9).
- **Appendix A timing table:** compared all 85 entries with the Zilog Z80 CPU User Manual T-state values. One wrong value (LD HL,(nn) 13 → 16), plus the RRL mnemonic and the "7 T states" sentence (footnoted).
- **Prose checks:**
  - 7/11/13/14 = bit 3/2/1/0 low: correct.
  - 244 = F4H, 252 = FCH, 253 = FDH, 255 = FFH: correct.
- **Not verified:**
  - The service-code descriptions (no cross-check available in the book).
  - The OUT 253/252 bank-switch sequence. It is internally consistent with the command table.
  - The p. 188 port-255 bit list. Real TS2068 hardware docs give 64-column mode as bits 1+2 (value 6, binary 110), whereas the book says "Bit 2 Enable 64 column display (with Bit 0)". I did not footnote this because the book's own VIDMOD material (p. 42) was not checked against it. Worth a look by whoever assembles chunk 3/4.

## 3. Ambiguous glyphs resolved

- p. 179 entry 33: "Filè": the stray accent is a print artefact. Read as "File".
- p. 193 data 64080: "82n32" is clearly an "n" in print. Transcribed as printed and footnoted.
- p. 193 underlines: the final "13" on line 64110 shows no underline, although the matching 13 at the start of 64120 is underlined. Transcribed as seen.
- p. 194 64725 "254,6": checked at 300 dpi; definitely 6, not 8.
- p. 197 first address "65942": checked at 300 dpi; definitely 65942.
- p. 197 64957 "198,2": checked at 300 dpi; definitely 2.
- p. 198 65032 "40,143" and 65036 "40,139": checked at 300 dpi. Both confirmed, and the shared off-by-one supports the reading.
- p. 195 64825: "LD A, .(23697)": the stray dot is a print artefact and was dropped.
- Underlined print-control bytes in the DATA listing (pp. 193-194): rendered as a line of `-` characters under each underlined group, inside the ```text block. Underlining is not possible in code blocks.

## 4. Silent prose typo fixes

- p. 179, code 40: "NC of no input" → "NC if no input"
- p. 184, code 105: "Creats" → "Creates"
- p. 184 prose: "floatng point calulator" → "floating point calculator"
- p. 189 table: "in-itialize" kept (line break); "Initalization" → "Initialization"
- p. 190: "Hi nvbble" → "Hi nybble"
- p. 190: "implementatation" → "implementation"
- p. 190: "avaiable" → "available"
- p. 190: "sofware" → "software"
- p. 190: "Vol. 2, #3,Jan-Feb" → "Vol. 2, #3, Jan-Feb" (spacing)
- p. 191: "easy amd quick" → "easy and quick"
- p. 193 token table: "Start an new line" → "Start a new line"
- p. 194: "promp for a scroll" → "prompt for a scroll"
- Kept as printed:
  - "K PRIT" (p. 182, code 81). It is probably "K PRINT", but it is a routine name, so I did not change it.
  - "Nybble"/"nybble" (period spelling).
  - "AROs or LROS" (p. 190).
  - "Follow by" in the token table.
  - "UDG's".
  - "data base".

## 5. Footnoted technical errors (18)

- c10-1: p. 188 — ports "253 (BDATPT) and 252 (BCMDPT)": the names are swapped.
- c10-2: p. 190 — "OUT 244, 15 will turn on all top 32k": 15 enables chunks 0-3, the bottom 32k.
- c10-3: p. 192 — LD HL,(nn) 13 → 16 T states.
- c10-4: p. 192 — "RRL": no such instruction; presumably SRL.
- c10-5: p. 192 — undocumented IXH/IXL instructions are 4 T states longer, not 7.
- c10-6: p. 193 — 44 (comma) used for the apostrophe in "I'm".
- c10-7: p. 193 — line 64030 has an extra 110 ("frienndly"), making 11 bytes.
- c10-8: p. 193 — 173,5 where the BASIC line has TAB 7.
- c10-9: p. 193 — "82n32": typing slip for "82,32".
- c10-10: p. 193 — "Computer." has a full stop that is not in the BASIC line.
- c10-11: p. 194 — stray 114 ("r") after "name?".
- c10-12: p. 194 — AT 12,14 vs BASIC AT 13,14.
- c10-13: p. 194 — final 222,0 (OVER 0) where the BASIC line has BRIGHT 0 (220,0).
- c10-14: p. 194 — 64725 "254,6" vs "CP 8".
- c10-15: p. 196 — 64897 "214,8" (SUB) vs "ADD A, 8" (should be 198,8).
- c10-16: p. 197 — address "65942" should be 64942.
- c10-17: p. 197 — 64957 "198,2" vs "ADD A, 8".
- c10-18: p. 198 — JR Z displacements 143/139 are one short; they should be 144/140 to reach 64922.

Footnote references cannot go inside code blocks. For listings and tables I placed them in an italic line right after the block: `*[Editor's notes on this ...: [^c10-n] ...]*`. The assembler may restyle this. Pandoc renders the chunk without errors.

## 6. Illegible spots and diagrams

- No illegible spots.
- p. 193 BASIC line: the quoted graphics-character strings print as blanks in the original, and I kept them as runs of spaces. The NOTE's inline graphic (a small box drawing for Graphic A, the UDG) is rendered as "[box symbol]".
- Hand-drawn margin marks (binder-hole arcs) are ignored.

## 7. Widest code-block line

- 67 characters, in the p. 189 BCMDPT/BDATPT command table (`11  Initialization done-move to next.` line).
- The service-code table blocks are at most about 66 characters, and the assembly listings at most 60 (p. 198: `65066  56,1 ... OVER ON--B = 255`).
# Chunk 11 notes (PDF 209-224)

## 1. Pages covered / headings

PDF 209-224 = printed pp. 199-213, plus pdf 224, a blank back page with no printed number (marked `<!-- p. ? (pdf 224) -->`, no content). The offset is 10.

- pp. 199-201: end of the Appendix B listing (PRINT/GRAPHICS/CLS/INPUT routines, 65094-65312), one prose paragraph, and the class demo listing at 63000-63068. There is no heading because the chunk starts mid-appendix.
- `## Appendix C: A Complete Code Table` (pp. 202-207), with `### Double Prefix Codes` (p. 207).
- `## Appendix D: Machine Codes for Encoding`, with `### Machine Codes for Encoding--Decimal` (pp. 208-209) and `### Machine Code for Encoding--Hex` (pp. 210-211). The TOC lists these two as sub-entries of Appendix D, and the wording follows the page headings.
- `## Appendix E: Decimal/Hex Conversion Tables`, with `### Address Conversion` and `### Negative Number Conversion Table` (p. 212).
- `## Appendix F: Bibliography` (p. 213). The TOC calls it "Bibliography/Copyrights"; the page heading says "BIBLIOGRAPHY".
- Assumption: the assembler (or chunk 10) supplies `# Appendixes` and the Appendix A/B headings. I used `##` for appendices, to sit under that.
- Dropped as running or continuation heads:
  - the "APPENDIX C  CODE TABLE" line at the top of pp. 203-207
  - "APPENDIX D  MACHINE CDOES FOR ENCODING--DECIMAL" mid-page on p. 209 (note the original typo "CDOES")
  - "APPENDIX D  MACHINE CODES FOR ENCODING--HEX" at the top of p. 211
  - all page-number lines

## 2. Verification

- **Appendix B listing (pp. 199-201, 2 listings, 125 instructions):**
  - Every byte group was disassembled with the python `z80` package (`Z80Machine._disasm`). Every instruction length matched, and address continuity was checked programmatically with no gaps.
  - All absolute operands were checked: 23695, 23693, 23560, 23624, 20704 (33,224,80), 23264 (33,224,90, the last attribute line), 65000 (205,232,253), 65184 (205,160,254, = INPUT), 64000, 64186, 64179, 64219, 65280.
  - All JR/DJNZ targets resolve to the labelled lines: SKIP, RETURN, AGAIN, NEXT 4, LOOP, LOOP 2, WAIT, DEBOUNCE, DELETE, KEY, PR INP, ROW, LINE.
  - Not verifiable here: the targets of `JR NXT CHAR` (65114, which resolves to 65000) and `JR DO ATTR` (65150, which resolves to 65089). Those labels are on earlier pages.
  - One mismatch: 65110 `214,7` = SUB 7, but the mnemonic says `SUB A, 8`. Footnoted.
- **Appendix C (256 rows x 5 columns, plus 32 double-prefix rows):**
  - Every non-blank NORMAL/CB/ED/DD/FD cell was compared with the `z80` disassembler output after normalising notation (HIX = IXH, etc.). DEC/HEX pairs were checked arithmetically (all 256 correct). The DDCB/FDCB table was checked the same way.
  - Remaining mismatches are expected notation differences, not errors: RST n, the (prefix) rows, IN A,N vs IN A,(n), undocumented ED NEG/RETN duplicates, and ED 63/6B.
  - Genuine errors were footnoted (c11-2 to c11-11).
- **Appendix D, decimal and hex:**
  - A script parsed every LD r,r' row, the ALU rows (r, n and d columns), INC/DEC, the rotate/shift rows, and the BIT/RES/SET rows, and compared them with opcode formulas: 251 cell checks in all.
  - The remaining entries were checked by hand against the Z80 opcode map: LD with nn/(nn), ADC/SBC HL, INC/DEC rr, PUSH/POP, EX, block instructions, IN/OUT, JP/CALL/RET/JR, RST, the "unsupported" IX/IY-half tables, and RET N/NEG duplicates.
  - The character/token CODE column of Appendix C was checked against the TS2068 character set and keyword tokens; no discrepancies.
- **Appendix E:**
  - Address-conversion grid checked programmatically (60 cells).
  - Negative-number table: I read every cell from zoomed crops and compared it with a generated (256-n) mod 256 table and its hex form. All 129 entries are correct, and the published block is the generated one, which is identical to the scan.
- **Bibliography:** prices, addresses and ZIP codes were transcribed only; there is nothing to cross-check them against.

## 3. Ambiguous glyphs resolved

- This printer's P looks like F, and its 0 looks like O. I read them from context: POP, PRINT, MSCRIPT, digit 0 in "BIT 0", "RES 0", "IM0", "RST 0".
- "IMO" / "IM0" (ED 46, p. 203; also pp. 208 and 210): transcribed as `IM0`, with no space as printed. "IM 1" and "IM 2" on p. 203 do have a space.
- p. 210, `ED48nn` / `ED58nn` / `ED68nn` / `ED78nn`: zoomed in. The glyph is a rounded 8, not the flat-backed B used in "BC" on the same line, so these are original errors (footnote c11-22).
- p. 210, CALL row `F0nn E8nn E0nn`: zoomed in and confirmed as printed.
- p. 208, the rotate row "Rl r" (RL): the glyph after R looks like a lowercase l (or 1). Transcribed as `Rl`.
- p. 211, `IN A,(n) DBn`: the D is overstruck, but it reads DB.
- p. 213, "22090" in the Baker entry has an overstruck 0. Transcribed as 22090.
- p. 202: code 96 is printed as a backtick-like glyph (transcribed as a backtick), and 95 as an underscore-like glyph (`_`).
- p. 200: `LD HL; 20704` is printed with a semicolon-like mark. Kept as printed.
- p. 199: "LD BC, 768" has a speck by the comma. Treated as a comma.
- p. 209 BIT table margin: the vertical label (meant to spell "203 PREFIX") shows a blank where F should be and only a dot where I should be. Transcribed as a blank and `.`.
- p. 209 "DEC" row: the D is partly hidden by a hole-punch mark. It reads "DEC" and the values confirm it.

## 4. Silent prose typo fixes

None. The one prose paragraph (p. 201) has no typos that needed fixing. I kept "it's up to you do with it" as printed.

These were kept as printed and not "fixed":
- table column heads "AFTED ED" and "AFTED DD" (pp. 206-207, inside code blocks)
- in the bibliography: "Programing", "Osborn" (Osborne), "Berkley" (Berkeley), "Melbourn House" (Melbourne House), "Jeff." with a period. These are citation data.

## 5. Footnoted technical errors (30)

c11-1 p.199 SUB 7 vs SUB A,8 · c11-2 C 09 FD ADD IY,DE → BC · c11-3 C DD/FD 64,6C LD HIX,H → HIX,HIX / LIX,HIX · c11-4 C ED67/6F "RR D"/"RL D" → RRD/RLD · c11-5 C ED70/71 IN(HL),(C)/OUT(C),(HL) behaviour · c11-6 C 8D FD LIX → LIY · c11-7 C ED B2 IRIR → INIR · c11-8 C B6 FD "OR )IY+d)" · c11-9 C E6 AND A → AND N · c11-10 C DD/FD EB EX DE,IX/IY nonexistent · c11-11 C FDCB BE RES 6 → RES 7 · c11-12 D-dec LD HL,(nn) 237,106 → 107 · c11-13 D-dec duplicated ALU block, CCF 65 → 63 · c11-14 D-dec DEC B 4 → 5 · c11-15 D-dec EX DE,IX/IY · c11-16 D-dec OUT (C),L 195 → 105 · c11-17 D-dec INDR 237,178 → 186 · c11-18 D-dec RES table missing rows 3-4, rows 5-7 are SET codes, SET table absent · c11-19 D-dec LD L(IX),n 39 → 46 · c11-20 D-hex LD A,(nn)/(BC)/(DE) given in decimal · c11-21 D-hex DIR → LDIR · c11-22 D-hex ED48/58/68/78 → ED4B/5B/6B/7B, 42nn → 2Ann · c11-23 D-hex EX DE,IX/IY · c11-24 D-hex SLR → SRL · c11-25 D-hex CALL P/PE/PO F0/E8/E0 → F4/EC/E4 · c11-26 D-hex "OUT(C),A D3n" → OUT (n),A · c11-27 D-hex margin "ED PREFIX" → CB · c11-28 D-hex LD L(IX),n 27 → 2E · c11-29 E "1 2" → "2 2" · c11-30 E total 4096 → 4095.

Footnote markers cannot go inside code blocks, so each table is followed by a one-line `*Errata in the table above:*` list that carries the markers. The assembler or editor may want to restyle these lines.

Not footnoted, as they are notation or undocumented-opcode matters:
- ED 4E/66/6E/76/7E (undocumented IM/NOP codes) left blank
- ED 63/6B listed without \*
- "RET N" / "RET I" printed with a space (RETN/RETI)
- "IN A, N" for IN A,(n)
- p. 211 "H(IX,IY+d)" column heads, where there is really no displacement
- the hex page's empty IX,IY column for INC/DEC rr, and the missing F9 after "LD SP, HL/IX/IY"

## 6. Illegible spots / diagrams

No illegible spots and no diagrams. pdf 224 is blank except for hole-punch marks.

The left-margin letter columns of the scans are partly cut off at the page edge on pp. 208-211. The visible letters were transcribed. They spell "203 PREFIX", "CB PREFIX" or "ED PREFIX" vertically down the rows.

## 7. Widest code-block line

83 characters: Appendix C, p. 204, row `134 86  ...  ADD A,(IX+d)  ADD A,(IY+d)`. The other Appendix C pages are 80-83 characters wide. Appendix B and D blocks are 72 characters or less.

# Corrected-reprint pass (2026-10-04)

Footnotes: 122 total; 115 corrected in the text (c11-18 reconstructs missing RES/SET rows), 7 not corrected:

- [^c01-7]: Not corrected. The printed remainder 0.000,000,000,100,708,386... matches no truncation of 0.1 in binary: the 36-bit fraction shown leaves 0.000,000,000,008,731,149... (which would contradict the 9-place conclusion), while a 32-bit fraction, the slug's mantissa length, leaves 0.000,000,000,139,698,386... (which fits the conclusion and the printed "386" ending but not the 36 digits printed), so which figure was intended cannot be settled from the page.
- [^c06-2]: Not corrected. With IY = 23610 a displacement byte of 245 (= -11) addresses 23599, not 23600; either the displacement should be 246 (mirroring the +10 example) or the address 23599, and the page does not show which the author meant.
- [^c06-9]: Not corrected. The fourth line repeats "EX DE, IX" with the 253 (IY) prefix, and neither `EX DE, IX` nor `EX DE, IY` is a real Z80 instruction (a DD or FD prefix has no effect on 235, which simply performs `EX DE, HL`), so there is no correct entry to restore.
- [^c08-11]: Not corrected. Lines 605 and 615 READ 79 values (40 + 39) but the DATA lines hold only 76 (38 + 38), so the program stops with "Out of DATA"; line 625 appears to lack a lower-case "y" (121) after "p", but line 630 also has doubtful entries (86 where "C" belongs, 78 where "B" belongs) and its digit-row values cannot be checked, so the missing and wrong values cannot be settled from the page.
- [^c10-2]: Not corrected. "OUT 244, 15 will turn on all top 32k" is self-contradictory: by the book's own definitions (bit *n* of port 244 enables Chunk *n*; Chunk 0 is addresses 0-8k), 15 (bits 0-3) enables Chunks 0-3, the bottom 32k, while the top 32k (Chunks 4-7) would need OUT 244, 240. The sentence names both LROS (bottom) and AROS (top) cartridges, so the page does not settle whether the number or the word "top" is the slip.
- [^c10-10]: Not corrected. At 64135 the data has 46 (a full stop) after "Computer", but the Basic line has "Computer" with no full stop; either one could be the slip, and nothing on the page decides which.
- [^c10-12]: Not corrected. The data has 172,12,14 (AT 12,14) where the Basic line has AT 13,14; both rows are valid for the routine (which accepts lines 0-23), and nothing on the page shows which row the answer field was meant to occupy.

Footnotes whose original claim changed on review: c01-7, c01-8, c02-1, c05-1, c06-8, c07-4, c09-5 (settled from the TS2068 ROM: EI, byte 251), c10-8 (direction reversed), c10-10 (address 64135 not 64125).

Tooling: ts-archive scripts/reconcile.py fails with the current python z80 package (build_instr returns a tuple, so instr.size raises); checks ran through local wrappers.

# Library audit pass (2026-10-04)

All 736 checkable claims were checked against the stock ROM images (`TS2068_U16.BIN`, `TS2068_U20.BIN`), their disassemblies and the TS2068 Reference Library. 484 confirmed. 35 values corrected in the text ("Corrected against the ROM."), 163 library notes, 41 (unverified) notes. Footnote c10-2 (OUT 244,15) was converted from "Not corrected" to a ROM correction. The audit also found 57 errors in the library itself, corrected in the same session (see the library's git history).
