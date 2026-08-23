; eToolkit EPROM - BASIC Listing
; by Thomas B. Woods
; Extracted from AROS cartridge ROM: eToolkit.ROM (24,576 bytes)
; TS2068 Sinclair BASIC, tokenized format
;
; AROS Header: type=$01, lang=$02, start=$800A, chunks=$8F, autostart=$01
; BASIC program: ROM offset $000A-$4CCA (19,649 bytes, 285 lines)
;
; Notation:
;   [UDG-X]     = User Defined Graphic character X (A-U)
;   [gfxN]      = Block graphics character N (0-F)
;   {INK n}     = Embedded INK control code in string
;   {PAPER n}   = Embedded PAPER control code in string
;   {BRIGHT n}  = Embedded BRIGHT control code in string
;   {INVERSE n} = Embedded INVERSE control code in string
;   {AT r,c}    = Embedded AT control code in string
;   Tokens appearing inside quoted strings (e.g. "STOP ") are
;   keyword tokens stored as single bytes, shown with trailing space.
;
; Program structure:
;   Lines 1-2:      Initialization and HOME bank variable save
;   Line 10:        Main menu
;   Lines 100-190:  1. Block Line Renumberer
;   Lines 200-292:  2. Hex/Dec Loader
;   Lines 300-460:  3. BASIC Disassembler (Z80)
;   Lines 500-596:  4. Tri-Base Arithmetic (Dec/Hex/Bin)
;   Lines 600-608:  5. UDG Generator
;   Lines 700-720:  6. Header Reader (tape)
;   Lines 800-850:  7. Configure Print Driver
;   Lines 900-910:  8. Return to HOME Bank
;   Line 1000:      Byte display subroutine
;   Lines 9995-9999: System routines (save/restore HOME vars)
;
; Machine code routines called via USR:
;   USR 55216 ($D7B0) - HOME ROM/EXROM routine (line 1)
;   USR 55228 ($D7BC) - HOME ROM/EXROM routine (line 201)
;   USR 55239 ($D7C7) - HOME ROM/EXROM routine (line 501)
;   USR 25092 ($6204) - Dispatch (param via RANDOMIZE seed)
;   USR 25110 ($6216) - Hex string conversion
;   USR 25120 ($6220) - Find BASIC line address
;   USR 25151 ($623F) - Block renumber execution
;   USR 25158 ($6246) - Hex/Dec mode cleanup
;   USR 25159 ($6247) - Binary string conversion
;   USR 25185 ($6261) - Output mode cleanup
;
; Header Reader MC (POKEd at runtime into 25110-25153):
;   Lines 702-706 contain DATA for a tape header reader routine
;   that is POKEd into addresses 25110-25153 when function 6 is selected.
;

   1 CLS :POKE (PEEK 23740+256*PEEK 23741+1),2:RANDOMIZE USR 55216
   2 IF (PEEK 24601=175 AND PEEK 24602=211) OR (PEEK 24601+PEEK 24602=0) THEN GO SUB 9997
  10 CLS :POKE (PEEK 23740+256*PEEK 23741+1),2:PRINT TAB 6;INVERSE 1;" * TOOLKIT EPROM * "'''INVERSE 0;"Select Function-"''TAB 4;"1.  Block Line Renumberer."''TAB 4;"2.  Hex/Dec Loader."''TAB 4;"3.  Disassembler."''TAB 4;"4.  Tri-Base Arithmetic."''TAB 4;"5.  UDG Generator."''TAB 4;"6.  Header Reader."''TAB 4;"7.  Configure Print Driver."''TAB 4;"8.  Return to HOME Bank.":INPUT "Function Nr: ";q:GO TO 100*q+(100 AND q>3)
 100 REM Block Line Renumberer.
 101 IF PEEK 24601+PEEK 24602=0 THEN GO SUB 9997
 110 CLS :PRINT TAB 2;INVERSE 1;" * Block Line Renumberer * "'':RANDOMIZE 56891:LET q=USR 25092
 120 PRINT "Old starting line number: ";:INPUT q:IF q=0 THEN GO TO 10
 130 POKE 25110,q-256*INT (q/256):POKE 25111,INT (q/256):LPRINT ''"Old starting line number: ";q:PRINT q
 135 LET q=USR 25120
 140 POKE 25112,q-256*INT (q/256):POKE 25113,INT (q/256):LPRINT "Address: ";q,"Length: ";PEEK (q+2)+256*PEEK (q+3)+4
 142 LPRINT "Relative address: ";q-PEEK 23635-256*PEEK 23636''
 144 PRINT "Address: ";q,"Length: ";PEEK (q+2)+256*PEEK (q+3)+4
 146 PRINT "Relative address: ";q-PEEK 23635-256*PEEK 23636''
 148 PRINT "New starting line number: ";:INPUT q:IF q=0 THEN GO TO 10
 150 POKE 25114,q-256*INT (q/256):POKE 25115,INT (q/256):LPRINT "New starting line number: ";q'':PRINT q''"Step: ";:INPUT q:IF q=0 THEN GO TO 10
 160 POKE 25118,q-256*INT (q/256):POKE 25119,INT (q/256):LPRINT "Step: ";q'':PRINT q''"Old stopping line number: ";:INPUT q:IF q=0 THEN GO TO 10
 170 POKE 25116,q-256*INT (q/256):POKE 25117,INT (q/256):LPRINT "Old stopping line number: ";q:PRINT q:INPUT "Inputs OK (y/n)? ";q$:IF q$<>"Y" AND q$<>"y" THEN CLS :GO TO 120
 180 LET q=USR 25151
 185 LPRINT '''"     Renumbering complete."''''':PRINT AT 15,5;"Renumbering complete.":IF PEEK (PEEK 23631+256*PEEK 23632+16)=5 THEN INPUT "Copy (y/n)? ";q$:IF q$="Y" OR q$="y" THEN COPY 
 190 GO TO 900
 200 IF PEEK 24601+PEEK 24602=0 THEN GO SUB 9997:REM             Hex/Dec Loader.
 201 CLS ::PRINT TAB 5;INVERSE 1;" * Hex/Dec Loader * "'':POKE 23658,8:DIM h$(4):LET h$="0000":LET A=10:LET B=11:LET C=12:LET D=13:LET E=14:LET F=15:POKE (PEEK 23740+256*PEEK 23741+1),2:RANDOMIZE USR 55228
 210 INPUT "Hex or Decimal Codes (H/D)? ";b$:IF b$="A" OR b$="Q" OR b$="STOP" OR b$="STOP " THEN GO TO 290
 211 IF b$="" OR (b$(1)<>"H" AND b$(1)<>"D") THEN GO TO 210
 212 LET b$=("Hex. " AND b$(1)="H")+("Dec. " AND b$(1)="D")
 220 INPUT "Address? ";i$:IF i$="A" OR i$="Q" OR i$="STOP" OR i$="STOP " THEN GO TO 290
 221 IF i$="" OR (i$(1)<>"H" AND i$(1)<>"D" AND i$(1)<>"R") THEN GO TO 220
 222 IF i$(1)="R" THEN LET i=PEEK 23635+256*PEEK 23636:GO TO 226
 223 IF i$(1)="H" THEN LET h$(6-LEN i$ TO )=i$(2 TO ):LET i=4096*VAL h$(1)+256*VAL h$(2)+16*VAL h$(3)+VAL h$(4):LET i$=i$(2 TO ):GO TO 228
 224 LET i=VAL i$(2 TO )
 225 IF i>65535 THEN PRINT '"Address exceeds maximum."''':LPRINT ''"Address exceeds maximum."''':GO TO 220
 226 RANDOMIZE i:IF i=0 THEN POKE 23670,0:POKE 23671,0
 227 LET h$=h$:RANDOMIZE USR 25110
 228 LET x=PEEK i:LET h=x:LET x$=CHR$ (INT (h/16)+48+7*(INT (h/16)>9)):LET h=h-16*INT (h/16):LET x$=x$+CHR$ (h+48+7*(h>9))
 229 FOR j=0 TO 5-LEN STR$ i:LPRINT " ";:NEXT j:LPRINT i;" ";h$;"  ";(" " AND LEN STR$ x<3);(" " AND LEN STR$ x=1);x;" ";x$;"  ";:PRINT TAB 5-LEN STR$ i;i;TAB 6;h$;TAB 15-LEN STR$ x;x;TAB 16;x$;"  ";
 230 INPUT (b$);"Code? ";x$:IF x$="Q" OR x$="STOP" OR x$="STOP " THEN GO TO 290
 231 IF x$="A" THEN PRINT '':LPRINT '':GO TO 220
 232 IF x$="" THEN LPRINT :GO TO 260
 233 IF b$(1)="H" THEN GO TO 237
 234 IF x$="H" THEN LET b$="Hex. ":GO TO 230
 235 LET x=VAL x$:IF x>255 THEN GO TO 230
 236 LET h=x:LET x$=CHR$ (INT (h/16)+48+7*(INT (h/16)>9)):LET h=h-16*INT (h/16):LET x$=x$+CHR$ (h+48+7*(h>9)):GO TO 240
 237 IF x$="D" THEN LET b$="Dec. ":GO TO 230
 238 IF LEN x$<>2 THEN GO TO 230
 239 LET x=16*VAL x$(1)+VAL x$(2)
 240 POKE i,x
 250 LPRINT (" " AND LEN STR$ x<3);(" " AND LEN STR$ x=1);x;" ";x$':PRINT (" " AND LEN STR$ x<3);(" " AND LEN STR$ x=1);x;" ";x$'
 260 LET i=i+1:GO TO 225
 290 LPRINT ''':IF PEEK (PEEK 23631+256*PEEK 23632+16)=5 THEN INPUT "Copy (Y/N)? ";i$:IF i$="Y" THEN COPY 
 291 INPUT "More (Y/N)? ";i$:IF i$="Y" THEN PRINT ''':GO TO 210
 292 LET h$=h$:RANDOMIZE USR 25158:GO TO 10
 300 IF PEEK 24601+PEEK 24602=0 THEN GO SUB 9997:REM             BASIC Disassembler.
 301 CLS :PRINT TAB 3;INVERSE 1;" * BASIC Disassembler * ":POKE 23658,8:DIM d$(8,4):POKE (PEEK 23740+256*PEEK 23741+1),2:RESTORE 301:FOR j=1 TO 8:READ d$(j):NEXT j:DATA "B","C","D","E","H","L","(HL)","A"
 302 INPUT "Address? ";k$:IF k$="" THEN GO TO 302
 303 IF k$="Q" OR k$="STOP" OR k$="STOP " THEN GO TO 10
 304 IF k$(1)<>"D" THEN GO TO 308
 305 IF LEN k$>6 OR k$="D" THEN GO TO 302
 306 GO TO 385
 307 LET a=VAL (k$(2 TO )):GO TO 311
 308 IF k$(1)<>"H" OR LEN k$<>5 THEN GO TO 302
 309 GO TO 389
 310 GO SUB 384
 311 LET c=0:CLS 
 312 LET b$="":LET c$="":GO SUB 363:GO SUB 366:IF c$(LEN c$-1 TO )="ED" THEN GO TO 333
 313 IF c$(LEN c$-1 TO )="CB" THEN GO TO 335
 314 IF c$(LEN c$-1 TO )="DD" THEN GO TO 340
 315 IF c$(LEN c$-1 TO )="FD" THEN GO TO 341
 316 IF c$<"39" THEN IF c$(2)="0" OR c$(2)="8" THEN IF c$>"0F" THEN GO TO 394
 317 GO SUB 374
 318 LET n$="":GO SUB 371:IF LEN n$=0 THEN GO TO 323
 319 IF LEN n$=1 THEN GO TO 322
 320 GO SUB 366:GO SUB 366:LET b$=c$(LEN c$-1 TO )+c$(LEN c$-3 TO LEN c$-2)
 321 LET n=CODE n$(1)-48-(7 AND n$(1)>"@"):LET i$=i$( TO n-1)+b$+(i$(n+1+(LEN n$=2) TO ) AND i$(LEN i$)<>"#"):GO TO 325
 322 GO SUB 366:LET b$=c$(LEN c$-1 TO ):GO TO 321
 323 IF i$="" THEN LET i$="Not def.":GO TO 325
 324 IF i$(1)="*" THEN LET i$="Not def."
 325 PRINT TAB 0;a$;TAB 6;c$;TAB 15;i$:LPRINT a$;"  ";c$;:FOR j=1 TO 9-LEN c$:LPRINT " ";:NEXT j:LPRINT i$
 326 LET c=c+1:IF c=22 THEN GO TO 355
 327 IF i$="RST 28h" THEN GO TO 330
 328 IF i$="RST 08h" THEN LET c$="":GO SUB 363:GO SUB 366:LET i=16*VAL c$(1)+CODE c$(2)-47-(7 AND c$(2)>"@"):LET i$=" ERR "+CHR$ (i+48+(7 AND i>9)):GO TO 325
 329 GO TO 312
 330 LET c$="":GO SUB 363:GO SUB 366:LET i$="DEFB "+c$:PRINT TAB 0;a$;TAB 6;c$;TAB 15;i$:LPRINT a$;"  ";c$;:FOR j=1 TO 9-LEN c$:LPRINT " ";:NEXT j:LPRINT i$:IF c$="38" THEN GO TO 326
 331 LET c=c+1:IF c=22 THEN GO TO 355
 332 GO TO 330
 333 GO SUB 366:LET b=b-64:IF b<0 OR (b>59 AND b<96) OR b>123 THEN LET i$="":GO TO 323
 334 RESTORE 420+INT (b/10):GO SUB 376:GO TO 318
 335 GO SUB 366:GO SUB 336:GO TO 318
 336 IF b<64 THEN RESTORE 450:LET v=INT (b/8)-8*INT (b/64):FOR j=0 TO v:READ i$:NEXT j:GO TO 338
 337 LET i$=("BIT " AND b<128)+("RES " AND b>127 AND b<192)+("SET " AND b>191)+STR$ INT ((b-64*INT (b/64))/8)+","
 338 IF i$="" THEN LET i$="****":RETURN 
 339 LET v=b-8*INT (b/8):GO SUB 383:RETURN 
 340 LET x$="IX":GO TO 342
 341 LET x$="IY"
 342 GO SUB 366
 343 IF c$(LEN c$-1 TO )="CB" THEN GO TO 353
 344 LET y=b:GO SUB 374:LET k=1
 345 IF k>LEN i$-1 OR y=235 THEN LET i$="":GO TO 323
 346 IF i$(k TO k+1)="HL" THEN GO TO 348
 347 LET k=k+1:GO TO 345
 348 IF y<=43 OR y=57 OR y>=225 THEN GO TO 351
 349 GO SUB 366:LET u$="":IF k<>LEN i$-1 THEN LET u$=i$(k+2 TO )
 350 LET i$=i$(1 TO k-1)+x$+"+"+c$(LEN c$-1 TO )+u$:GO TO 318
 351 LET u$="":IF k<>LEN i$-1 THEN LET u$=i$(k+2 TO ):IF y=41 THEN LET u$(2 TO )=x$
 352 LET i$=i$(1 TO k-1)+x$+u$:GO TO 318
 353 GO SUB 366:GO SUB 366:LET b=PEEK (a-1):IF (b+2)/8<>INT ((b+2)/8) THEN LET i$="":GO TO 323
 354 GO SUB 336:LET i$=i$( TO LEN i$-3)+x$+"+"+c$(5 TO 6)+i$(LEN i$):GO TO 324
 355 INPUT "More? (Y/N/C/Q) ";q$:IF q$="Q" THEN GO TO 10
 356 IF q$="N" THEN GO TO 302
 357 IF q$="Y" THEN GO TO 360
 358 IF PEEK (PEEK 23631+256*PEEK 23632+16)<>5 OR q$<>"C" THEN GO TO 355
 359 COPY :GO TO 355
 360 IF i$="RST 28h" THEN GO TO 362
 361 IF i$<>"DEFB "+c$ OR c$="38" THEN GO TO 311
 362 CLS :LET c=0:GO TO 330
 363 LET a$="":LET r=a:LET k=3
 364 LET i=INT (r/(16^k)):LET a$=a$+CHR$ (i+48+(7 AND i>9)):LET r=r-(16^k)*i:IF k=0 THEN RETURN 
 365 LET k=k-1:GO TO 364
 366 IF a>65535 THEN GO TO 368
 367 LET b=PEEK a:LET i=INT (b/16):LET c$=c$+CHR$ (i+48+(7 AND i>9))+CHR$ (b-16*i+48+(7 AND (b-16*i)>9)):LET a=a+1:RETURN 
 368 PRINT AT 21,6;"Address exceeds maximum.":LPRINT ''"Address exceeds maximum."'':BEEP 3,10:PAUSE 300:PRINT AT 21,6;"                        ":IF c=0 THEN GO TO 302
 369 IF PEEK (PEEK 23631+256*PEEK 23632+16)=5 THEN INPUT "Copy (Y/N)? ";q$:IF q$="Y" THEN COPY 
 370 GO TO 302
 371 LET n$="":FOR j=1 TO LEN i$:IF i$(j)<>"#" THEN GO TO 373
 372 LET n$=n$+CHR$ (j+48+(7 AND j>9))
 373 NEXT j:RETURN 
 374 IF b>=64 THEN GO TO 377
 375 RESTORE 400+INT (b/10)
 376 FOR j=0 TO b-10*INT (b/10):READ i$:NEXT j:RETURN 
 377 IF b<=191 THEN GO TO 379
 378 RESTORE 410+INT ((b-192)/10):FOR j=0 TO b-10*INT ((b-192)/10)-192:READ i$:NEXT j:RETURN 
 379 LET b=b-64:IF b=54 THEN LET i$="HALT":RETURN 
 380 IF b<64 THEN LET v=INT (b/8):LET i$="LD ":GO SUB 383:LET i$=i$+",":GO TO 382
 381 LET b=b-64:RESTORE 440:LET v=INT (b/8):FOR j=0 TO v:READ i$:NEXT j
 382 LET v=b-8*v:GO SUB 383:RETURN 
 383 LET e$=d$(1+v):LET i$=i$+e$(1 TO 1+(3 AND 1+v=7)):RETURN 
 384 LET a=0:LET a$=k$(2 TO ):FOR j=1 TO 4:LET a=a+(16^(4-j))*(CODE a$(j)-48-(7 AND a$(j)>"@")):NEXT j:RETURN 
 385 LET k=2
 386 IF k$(k)<"0" OR k$(k)>"9" THEN GO TO 302
 387 IF k=LEN k$ THEN GO TO 307
 388 LET k=k+1:GO TO 386
 389 LET k=2
 390 IF (k$(k)>="0" AND k$(k)<="9") OR (k$(k)>="A" AND k$(k)<="F") THEN GO TO 392
 391 GO TO 302
 392 IF k=LEN k$ THEN GO TO 310
 393 LET k=k+1:GO TO 390
 394 RESTORE 460:FOR j=0 TO INT (b/8)-2:READ i$:NEXT j:GO SUB 366:LET q=a:LET q$=a$:LET a=a+b-(256 AND b>127):GO SUB 363:LET i$=i$+a$:LET a=q:LET a$=q$:GO TO 325
 400 DATA "NOP","LD BC,##","LD (BC),A","INC BC","INC B","DEC B","LD B,#","RLCA","EX AF,AF'","ADD HL,BC"
 401 DATA "LD A,(BC)","DEC BC","INC C","DEC C","LD C,#","RRCA","","LD DE,##","LD (DE),A","INC DE"
 402 DATA "INC D","DEC D","LD D,#","RLA","","ADD HL,DE","LD A,(DE)","DEC DE","INC E","DEC E"
 403 DATA "LD E,#","RRA","","LD HL,##","LD (##),HL","INC HL","INC H","DEC H","LD H,#","DAA"
 404 DATA "","ADD HL,HL","LD HL,(##)","DEC HL","INC L","DEC L","LD L,#","CPL","","LD SP,##"
 405 DATA "LD (##),A","INC SP","INC (HL)","DEC (HL)","LD (HL),#","SCF","","ADD HL,SP","LD A,(##)","DEC SP"
 406 DATA "INC A","DEC A","LD A,#","CCF"
 410 DATA "RET NZ","POP BC","JP NZ,##","JP ##","CALL NZ,##","PUSH BC","ADD A,#","RST 00h","RET Z","RET"
 411 DATA "JP Z,##","","CALL Z,##","CALL ##","ADC A,#","RST 08h","RET NC","POP DE","JP NC,##","OUT (#),A"
 412 DATA "CALL NC,##","PUSH DE","SUB #","RST 10h","RET C","EXX","JP C,##","IN A,(#)","CALL C,##",""
 413 DATA "SBC A,#","RST 18h","RET PO","POP HL","JP PO,##","EX (SP),HL","CALL PO,##","PUSH HL","AND #","RST 20h"
 414 DATA "RET PE","JP (HL)","JP PE,##","EX DE,HL","CALL PE,##","","XOR #","RST 28h","RET P","POP AF"
 415 DATA "JP P,##","DI","CALL P,##","PUSH AF","OR #","RST 30h","RET M","LD SP,HL","JP M,##","EI"
 416 DATA "CALL M,##","","CP #","RST 38h"
 420 DATA "IN B,(C)","OUT (C),B","SBC HL,BC","LD (##),BC","NEG","RETN","IM 0","LD I,A","IN C,(C)","OUT (C),C"
 421 DATA "ADC HL,BC","LD BC,(##)","","RETI","","LD R,A","IN D,(C)","OUT (C),D","SBC HL,DE","LD (##),DE"
 422 DATA "","","IM 1","LD A,I","IN E,(C)","OUT (C),E","ADC HL,DE","LD DE,(##)","",""
 423 DATA "IM 2","LD A,R","IN H,(C)","OUT (C),H","SBC HL,HL","","","","","RRD"
 424 DATA "IN L,(C)","OUT (C),L","ADC HL,HL","","","","","RLD","",""
 425 DATA "SBC HL,SP","LD (##),SP","","","","","IN A,(C)","OUT (C),A","ADC HL,SP","LD SP,(##)"
 429 DATA "","","","","","","LDI","CPI","INI","OUTI"
 430 DATA "","","","","LDD","CPD","IND","OUTD"
 431 DATA "","","LDIR","CPIR","INIR","OTIR","","","",""
 432 DATA "LDDR","CPDR","INDR","OTDR"
 440 DATA "ADD A,","ADC A,","SUB ","SBC A,","AND ","XOR ","OR ","CP "
 450 DATA "RLC ","RRC ","RL ","RR ","SLA ","SRA ","","SRL "
 460 DATA "DJNZ ","JR ","JR NZ,","JR Z,","JR NC,","JR C,"
 500 IF PEEK 24601+PEEK 24602=0 THEN GO SUB 9997:REM             Tri-Base Arithmetic.
 501 CLS :PRINT TAB 3;INVERSE 1;" * Tri-Base Arithmetic * ":POKE 23658,8:DIM h$(5):DIM m$(17):LET A=10:LET B=11:LET C=12:LET D=13:LET E=14:LET F=15:POKE (PEEK 23740+256*PEEK 23741+1),2:RANDOMIZE USR 55239
 520 LET f$=""
 521 LET l=1
 522 INPUT "Input: ";i$
 523 IF (i$(1)>"/" AND i$(1)<":") OR (i$(1)="-" AND i$<>"-") OR i$(1)="D" THEN GO TO 541
 524 IF i$(1)="H" THEN LET n=0:FOR i=2 TO LEN i$:LET n=16*n+VAL i$(i):NEXT i:GO TO 581
 525 IF i$(1)="B" THEN LET n=0:FOR i=2 TO LEN i$:LET n=2*n+VAL i$(i):NEXT i:GO TO 581
 526 IF i$="V" OR i$="CLS" THEN CLS 
 527 IF PEEK (PEEK 23631+256*PEEK 23632+16)=5 THEN IF i$="Z" OR i$="COPY" THEN COPY 
 528 LET l=0:IF i$="A" OR i$="Q" OR i$="STOP" OR i$="STOP " THEN GO TO 595
 529 IF i$="+" OR i$="-" OR i$="*" OR i$="/" OR i$="AND" OR i$="OR" OR i$="XOR" THEN GO TO 544
 530 LET l=2
 531 IF i$="+/-" THEN GO TO 556
 532 IF i$="STO" THEN GO TO 570
 533 IF i$="RCL" THEN GO TO 571
 534 LET l=3
 535 IF i$="=" THEN GO TO 545
 536 IF i$="C" THEN GO TO 557
 537 IF i$="SL" OR i$="SR" THEN GO TO 558
 538 IF LEN i$<3 THEN GO TO 522
 539 IF i$(1 TO 2)="RL" OR i$(1 TO 2)="RR" THEN GO TO 560
 540 GO TO 521
 541 LET n=VAL i$(1+(1 AND i$(1)="D") TO ):GO TO 581
 544 LPRINT i$:PRINT i$:GO SUB 546:LET f$=i$:LET l$=m$:GO TO 522
 545 GO SUB 546:LET n=x:GO TO 580
 546 IF f$="" THEN LET x=n
 547 IF f$="+" THEN LET x=x+n
 548 IF f$="-" THEN LET x=x-n
 549 IF f$="*" THEN LET x=x*n
 550 IF f$="/" THEN LET x=INT (x/n)
 551 IF f$<>"AND" AND f$<>"OR" AND f$<>"XOR" THEN RETURN 
 552 LET n=0:FOR i=2 TO 17:IF f$="AND" THEN LET n=2*n+(VAL m$(i) AND VAL l$(i))
 553 IF f$="OR" THEN LET n=2*n+(VAL m$(i) OR VAL l$(i))
 554 IF f$="XOR" THEN LET n=2*n+((VAL m$(i) OR VAL l$(i)) AND NOT (VAL m$(i) AND VAL l$(i)))
 555 NEXT i:LET x=n:RETURN 
 556 LET n=-n:GO TO 580
 557 LET i$="1's Compl":LET n=-n-1:GO TO 580
 558 LET n=(2*n AND i$(2)="L")+(INT (n/2) AND i$(2)="R"):GO TO 580
 560 LET m=VAL i$(3 TO ):IF m>16 OR m<1 THEN GO TO 522
 561 LET z=1:FOR i=2 TO 17-m:LET m$(i)="0":NEXT i:LET n=0:FOR i=2 TO 17:LET n=2*n+VAL m$(i):NEXT i:IF i$(2)="R" THEN GO TO 565
 562 IF n<2^(m-1) THEN LET z=0
 563 LET n=2*n+z:IF n>2^m THEN LET n=n-2^m
 564 GO TO 580
 565 IF n/2=INT (n/2) THEN LET z=0
 566 LET n=INT (n/2)+z*2^(m-1):GO TO 580
 570 LPRINT "STO":PRINT "STO":LET s=n:GO TO 521
 571 LET n=s
 580 LPRINT i$:PRINT i$
 581 IF n<65536 AND n>-65537 THEN GO TO 583
 582 LPRINT "OVERFLOW!":LPRINT :PRINT "OVERFLOW!":PRINT :GO TO 520
 583 IF n<0 THEN GO TO 585
 584 LET z=n:LET h$(1)=" ":GO SUB 586:LET m$(1)=" ":GO TO 588
 585 LET z=65536+n:LET h$(1)="F":GO SUB 586:LET m$(1)="C":GO TO 588
 586 RANDOMIZE z:IF z=0 THEN POKE 23670,0:POKE 23671,0
 587 LET h$=h$:RANDOMIZE USR 25110:RETURN 
 588 RANDOMIZE z:IF z=0 THEN POKE 23670,0:POKE 23671,0
 589 LET m$=m$:RANDOMIZE USR 25159
 590 IF l=1 THEN LPRINT :PRINT 
 591 FOR i=1 TO 6-LEN STR$ n:LPRINT " ";:NEXT i:LPRINT n;"  ";h$;"  ";m$:PRINT TAB 6-LEN STR$ n;n;TAB 8;h$;TAB 15;m$:IF l=0 THEN GO TO 522
 592 IF l=2 THEN GO TO 521
 593 GO TO 520
 595 LET h$=h$:RANDOMIZE USR 25185:LET m$=m$:RANDOMIZE USR 25185:IF PEEK (PEEK 23631+256*PEEK 23632+16)=5 THEN INPUT "Copy (Y/N)? ";a$:IF a$="Y" OR a$="y" THEN COPY 
 596 GO TO 10
 600 IF PEEK 24601+PEEK 24602=0 THEN GO SUB 9997:REM            UDG Generator.
 601 CLS :PRINT TAB 11;INVERSE 1;" * UDG Generator * ";INVERSE 0;AT 14,0;" Key  No Shift Cap Shft Sym Shft";AT 14,0;OVER 1;"_____ ________ ________ ________";OVER 0''" A-U   Define  Replace  Replace Arrow Move Cur Mv & Ink Mv & Pap  1    ------  All Ink  All Pap 2,3,9  ------    Ink     Paper    4    ------   Toggle   Toggle   0    ------    Exit     Exit  ":RANDOMIZE 57012:RANDOMIZE USR 25092  
 602 INPUT "Restore original graphics (y/n)? ";a$:IF a$="Y" OR a$="y" THEN RANDOMIZE 57299:RANDOMIZE USR 25092:GO TO 602
 603 IF PEEK (PEEK 23631+256*PEEK 23632+16)=5 THEN INPUT "Copy (y/n)? ";a$:IF a$="Y" OR a$="y" THEN COPY 
 604 INPUT "Save UDG's (y/n)? ";a$:IF a$<>"Y" AND a$<>"y" THEN GO TO 10
 605 INPUT "Name for SAVE? ";a$:IF a$="" OR LEN a$>10 THEN GO TO 605
 606 SAVE a$CODE PEEK 23675+256*PEEK 23676,65536-PEEK 23675-256*PEEK 23676:CLS :PRINT AT 10,7;FLASH 1;" REWIND to VERIFY ":BEEP .5,12:VERIFY ""CODE :BEEP .5,12:PRINT AT 10,7;"                  ";AT 12,8+LEN a$;"is OK."
 607 INPUT "More (y/n)? ";a$:IF a$="Y" OR a$="y" THEN GO TO 601
 608 GO TO 10
 700 IF PEEK 24601+PEEK 24602=0 THEN GO SUB 9997:REM            Header reader.
 701 CLS :PRINT TAB 6;INVERSE 1;" * Header Reader * ":POKE (PEEK 23740+256*PEEK 23741+1),2:RESTORE 702:FOR a=25110 TO 25153:READ c:POKE a,c:NEXT a
 702 DATA 175,55,221,33,66,98,17,17,0,243
 703 DATA 245,219,255,203,255,211,255,219,244,50
 704 DATA 65,98,62,1,211,244,241,205,252,0
 705 DATA 58,65,98,211,244,219,255,203,191,211
 706 DATA 255,251,201,0
 707 FOR i=0 TO 6:POKE USR "a"+i,0:NEXT i:POKE USR "a"+7,126
 708 POKE 25154,4:CLS :PRINT AT 10,8;"Start the tape-":RANDOMIZE USR 25110:CLS :LET type=PEEK 25154:IF type>3 THEN PRINT AT 10,9;FLASH 1;" Not a Header ":GO TO 719
 709 LET a$="":FOR i=0 TO 9:LET a$=a$+CHR$ PEEK (25155+i):NEXT i:LET len=PEEK 25165+256*PEEK 25166:LET start=PEEK 25167+256*PEEK 25168:LET pa=PEEK 25169+256*PEEK 25170:LET var=len-pa:LPRINT "Name: ";a$'':PRINT "Name: [UDG-A][UDG-A][UDG-A][UDG-A][UDG-A][UDG-A][UDG-A][UDG-A][UDG-A][UDG-A]";OVER 1;AT 0,6;a$'':IF type THEN GO TO 712
 710 LPRINT "Program type: BASIC."''"Program area: ";pa;" bytes."''"Variables area: ";var;" bytes."'':PRINT "Program type: BASIC."''"Program area: ";pa;" bytes."''"Variables area: ";var;" bytes."'':IF start>9999 THEN LPRINT "No auto-start."'''':PRINT "No auto-start.":GO TO 718
 711 LPRINT "Auto-start at Line ";start;"."'''':PRINT "Auto-start at Line ";start;".":GO TO 718
 712 LET t$="Code Block.":IF start=16384 AND len=6912 THEN LET t$="Screen."
 713 IF type=1 THEN LET t$="Numeric Array.":LET n$=CHR$ (PEEK 25168-64)+" or "+CHR$ (PEEK 25168-32)
 714 IF type=2 THEN LET t$="Character Array.":LET n$=CHR$ (PEEK 25168-128)+"$ or "+CHR$ (PEEK 25168-96)+"$"
 715 LPRINT "Type: ";t$'':PRINT "Type: ";t$'':IF type=1 OR type=2 THEN LPRINT "Array Variable Name: ";n$'':PRINT "Array Variable Name: ";n$'' 
 716 IF type=3 THEN LPRINT "Starting Address: ";start'':PRINT "Starting Address: ";start''
 717 LPRINT "Length: ";len;" bytes."'''':PRINT "Length: ";len;" bytes."
 718 IF PEEK (PEEK 23631+256*PEEK 23632+16)=5 THEN INPUT "Copy (y/n)? ";r$:IF r$="Y" OR r$="y" THEN COPY 
 719 INPUT "Read another header (y/n)? ";r$:IF r$="Y" OR r$="y" THEN GO TO 708
 720 GO TO 10
 800 IF PEEK 24601+PEEK 24602=0 THEN GO SUB 9997:REM  Configure Print Driver.
 801 CLS :PRINT TAB 1;INVERSE 1;" * Configure Print Driver * "''':PRINT TAB 4;"1.  Aerco."''TAB 4;"2.  Tasman (B)."''TAB 4;"3.  Tasman (C)."''TAB 4;"4.  T/S 2040."''TAB 4;"5.  A & J."''TAB 4;"6.  Byte-Back Parallel."''TAB 4;"7.  Other."
 810 INPUT "Select a Number: ";q:IF q<1 OR q>7 THEN GO TO 810
 820 LET q=q-1:IF q=3 THEN LET q=PEEK 23631+256*PEEK 23632+15:POKE q,0:POKE (q+1),5:GO TO 10
 825 RANDOMIZE 56352:RANDOMIZE USR 25092
 826 IF q=6 THEN INPUT "Enter the starting address of   your driver software:";q:RANDOMIZE q:POKE 23321,PEEK 23670:POKE 23322,PEEK 23671:LET q=6
 830 PRINT AT 20,0;"Do you want an automatic LINE   FEED with CARRIAGE RETURN? (y/n)":INPUT q$:IF q$="Y" OR q$="y" THEN LET q=q+128
 840 LET q$="                                ":POKE 23326,q:PRINT AT 20,0;q$'q$;AT 18,0;"Now input initial print mode:"'q$;TAB 4;"1.  NORMAL."'TAB 4;"2.  UP-ARROW.":INPUT AT 0,4;"3.  RAW ASCII.",q:IF q<1 OR q>3 THEN GO TO 840
 850 LET q=q-1:POKE 23327,q:GO TO 10
 900 REM Return to HOME Bank.
 905 RANDOMIZE 56224:RANDOMIZE USR 25092:REM restore home vars
 910 POKE 24601,0:POKE 24602,0:POKE (PEEK 23740+256*PEEK 23741+1),0:POKE 23750,0:STOP 
1000 CLS :PRINT "Byte   Contents";OVER 1;AT 0,0;"____   ________"'':FOR i=1 TO 17:PRINT TAB 3-LEN STR$ i;i;TAB 12-LEN STR$ PEEK (25131+i);PEEK (25153+i):NEXT i:GO TO 718
9995 STOP 
9996 STOP 
9997 RANDOMIZE 56250:RANDOMIZE USR 25092:RETURN :REM save home vars
9998 CLEAR :POKE 23750,0:OUT 244,240:POKE 23635,10:POKE 23636,128:POKE 23627,PEEK 32776:POKE 23628,PEEK 32777:RANDOMIZE (1+PEEK 32776+256*PEEK 32777):POKE 23641,PEEK 23670:POKE 23642,PEEK 23671:LIST :STOP 
9999 CLEAR :POKE 32776,PEEK 23627:POKE 32777,PEEK 23628:POKE PEEK 23627+256*PEEK 23628,128:POKE 1+PEEK 23627+256*PEEK 23628,13:POKE 2+PEEK 23627+256*PEEK 23628,128
