; z80dasm 1.2.0
; command line: z80dasm -a -l -g 0x0000 -o gus-exrom.asm gus-exrom.rom

	org 00000h

l0000h:
	di			;0000
l0001h:
	jr l0049h		;0001
l0003h:
	jp l1cbch		;0003
l0006h:
	rst 38h			;0006
l0007h:
	rst 38h			;0007
l0008h:
	ld hl,(05c5dh)		;0008
l000bh:
	ld (05c5fh),hl		;000b
	pop hl			;000e
	ld l,(hl)		;000f
l0010h:
	ld (iy+000h),l		;0010
	ld sp,(05c3dh)		;0013
l0017h:
	ld hl,l1354h		;0017
	push hl			;001a
	ld h,0ffh		;001b
	ld l,000h		;001d
	push hl			;001f
l0020h:
	push af			;0020
	ld a,(05cc2h)		;0021
	and a			;0024
	ei			;0025
	jr z,l002ch		;0026
	pop af			;0028
l0029h:
	call 0fd32h		;0029
l002ch:
	pop af			;002c
	call 06572h		;002d
l0030h:
	rst 38h			;0030
	rst 38h			;0031
	rst 38h			;0032
	ld bc,0ad05h		;0033
	rlca			;0036
	inc sp			;0037
l0038h:
	push af			;0038
	di			;0039
	ld a,(05cc2h)		;003a
	and a			;003d
	nop			;003e
	jr z,l0045h		;003f
	pop af			;0041
	jp 0fa6eh		;0042
l0045h:
	pop af			;0045
	jp 062aeh		;0046
l0049h:
	ld a,003h		;0049
	out (0f4h),a		;004b
	jr l005ah		;004d
l004fh:
	xor a			;004f
	out (0f4h),a		;0050
	out (0ffh),a		;0052
	ld de,0ffffh		;0054
	jp l0d31h		;0057
l005ah:
	jp l1caeh		;005a
	ld de,06000h		;005d
	ld bc,l000bh		;0060
	defb 0edh ;next byte illegal after ed	;0063
	nop			;0064
	ret			;0065
	jr l0003h		;0066
sub_0068h:
	jp l1879h		;0068
l006bh:
	push hl			;006b
	ld hl,01f80h		;006c
	bit 7,a			;006f
	jr z,l0076h		;0071
	ld hl,00c98h		;0073
l0076h:
	ex af,af'		;0076
	inc de			;0077
	dec ix			;0078
	di			;007a
	ld a,002h		;007b
	ld b,a			;007d
l007eh:
	djnz l007eh		;007e
	out (0feh),a		;0080
	xor 00fh		;0082
	ld b,0a4h		;0084
	dec l			;0086
	jr nz,l007eh		;0087
	dec b			;0089
	dec h			;008a
	jp p,l007eh		;008b
	ld b,02fh		;008e
l0090h:
	djnz l0090h		;0090
	out (0feh),a		;0092
	ld a,00dh		;0094
	ld b,037h		;0096
l0098h:
	djnz l0098h		;0098
	out (0feh),a		;009a
	ld bc,l3b0eh		;009c
	ex af,af'		;009f
	ld l,a			;00a0
	jp l00adh		;00a1
l00a4h:
	ld a,d			;00a4
	or e			;00a5
	jr z,l00b4h		;00a6
	ld l,(ix+000h)		;00a8
l00abh:
	ld a,h			;00ab
	xor l			;00ac
l00adh:
	ld h,a			;00ad
	ld a,001h		;00ae
	scf			;00b0
	jp l00cbh		;00b1
l00b4h:
	ld l,h			;00b4
	jr l00abh		;00b5
l00b7h:
	ld a,c			;00b7
	bit 7,b			;00b8
l00bah:
	djnz l00bah		;00ba
	jr nc,l00c2h		;00bc
	ld b,042h		;00be
l00c0h:
	djnz l00c0h		;00c0
l00c2h:
	out (0feh),a		;00c2
	ld b,03eh		;00c4
	jr nz,l00b7h		;00c6
	dec b			;00c8
	xor a			;00c9
	inc a			;00ca
l00cbh:
	rl l			;00cb
	jp nz,l00bah		;00cd
	dec de			;00d0
	inc ix			;00d1
	ld b,031h		;00d3
	ld a,07fh		;00d5
	in a,(0feh)		;00d7
	rra			;00d9
	ret nc			;00da
	ld a,d			;00db
	inc a			;00dc
	jp nz,l00a4h		;00dd
	ld b,03bh		;00e0
l00e2h:
	djnz l00e2h		;00e2
	ret			;00e4
l00e5h:
	push af			;00e5
	ld a,(05c48h)		;00e6
	and 038h		;00e9
	rrca			;00eb
	rrca			;00ec
	rrca			;00ed
	out (0feh),a		;00ee
	ld a,07fh		;00f0
	in a,(0feh)		;00f2
	rra			;00f4
	ei			;00f5
	jr c,l00fah		;00f6
l00f8h:
	rst 8			;00f8
	inc c			;00f9
l00fah:
	pop af			;00fa
	ret			;00fb
sub_00fch:
	jp l196dh		;00fc
l00ffh:
	di			;00ff
	ld a,00fh		;0100
	out (0feh),a		;0102
	ld hl,l00e5h		;0104
	push hl			;0107
	in a,(0feh)		;0108
	rra			;010a
	and 020h		;010b
	or 002h			;010d
	ld c,a			;010f
	cp a			;0110
l0111h:
	ret nz			;0111
l0112h:
	call sub_018dh		;0112
	jr nc,l0111h		;0115
	ld hl,l0414h+1		;0117
l011ah:
	djnz l011ah		;011a
	dec hl			;011c
	ld a,h			;011d
	or l			;011e
	jr nz,l011ah		;011f
	call sub_0189h		;0121
	jr nc,l0111h		;0124
l0126h:
	ld b,09ch		;0126
	call sub_0189h		;0128
	jr nc,l0111h		;012b
	ld a,0c6h		;012d
	cp b			;012f
	jr nc,l0112h		;0130
	inc h			;0132
	jr nz,l0126h		;0133
l0135h:
	ld b,0c9h		;0135
	call sub_018dh		;0137
	jr nc,l0111h		;013a
	ld a,b			;013c
	cp 0d4h			;013d
	jr nc,l0135h		;013f
	call sub_018dh		;0141
	ret nc			;0144
	ld a,c			;0145
	xor 003h		;0146
	ld c,a			;0148
	ld h,000h		;0149
	ld b,0b0h		;014b
	jr l016eh		;014d
l014fh:
	ex af,af'		;014f
	jr nz,l0159h		;0150
	jr nc,l0163h		;0152
	ld (ix+000h),l		;0154
	jr l0168h		;0157
l0159h:
	rl c			;0159
	xor l			;015b
	ret nz			;015c
	ld a,c			;015d
	rra			;015e
	ld c,a			;015f
	inc de			;0160
	jr l016ah		;0161
l0163h:
	ld a,(ix+000h)		;0163
	xor l			;0166
	ret nz			;0167
l0168h:
	inc ix			;0168
l016ah:
	dec de			;016a
	ex af,af'		;016b
	ld b,0b2h		;016c
l016eh:
	ld l,001h		;016e
l0170h:
	call sub_0189h		;0170
	ret nc			;0173
	ld a,0cbh		;0174
	cp b			;0176
	rl l			;0177
	ld b,0b0h		;0179
	jp nc,l0170h		;017b
	ld a,h			;017e
	xor l			;017f
	ld h,a			;0180
	ld a,d			;0181
	or e			;0182
	jr nz,l014fh		;0183
	ld a,h			;0185
	cp 001h			;0186
	ret			;0188
sub_0189h:
	call sub_018dh		;0189
	ret nc			;018c
sub_018dh:
	ld a,016h		;018d
l018fh:
	dec a			;018f
	jr nz,l018fh		;0190
	and a			;0192
l0193h:
	inc b			;0193
	ret z			;0194
	ld a,07fh		;0195
	in a,(0feh)		;0197
	rra			;0199
	ret nc			;019a
	xor c			;019b
	and 020h		;019c
	jr z,l0193h		;019e
	ld a,c			;01a0
	cpl			;01a1
	ld c,a			;01a2
	and 007h		;01a3
	or 008h			;01a5
	out (0feh),a		;01a7
	scf			;01a9
	ret			;01aa
	jp l0210h		;01ab
l01aeh:
	ld bc,019e1h		;01ae
	sub c			;01b1
	ld (05c74h),a		;01b2
	exx			;01b5
	ld hl,l254fh		;01b6
	jp l08ddh		;01b9
l01bch:
	call sub_221fh		;01bc
	xor a			;01bf
	jp l03f6h		;01c0
sub_01c3h:
	call sub_02b9h		;01c3
	jp l04f1h		;01c6
l01c9h:
	jp l03ddh		;01c9
	bit 7,(iy+001h)		;01cc
	jr z,l0238h		;01d0
	jp l1a73h		;01d2
l01d5h:
	ld a,(05c74h)		;01d5
	and a			;01d8
	jr z,l01ddh		;01d9
	ld c,022h		;01db
l01ddh:
	call sub_01e2h		;01dd
	jr l01f4h		;01e0
sub_01e2h:
	push ix			;01e2
	exx			;01e4
	ld hl,l0030h		;01e5
	jr l01c9h		;01e8
l01eah:
	exx			;01ea
	ld hl,l24c7h		;01eb
	jp l08ddh		;01ee
	nop			;01f1
	nop			;01f2
	nop			;01f3
l01f4h:
	push de			;01f4
	pop ix			;01f5
	ld b,00bh		;01f7
	ld a,020h		;01f9
l01fbh:
	ld (de),a		;01fb
	inc de			;01fc
	djnz l01fbh		;01fd
	ld (ix+001h),0ffh	;01ff
	call sub_0208h		;0203
	jr l021ah		;0206
sub_0208h:
	push ix			;0208
	exx			;020a
	ld hl,l2fafh		;020b
	jr l01c9h		;020e
l0210h:
	ld hl,l01eah		;0210
	push hl			;0213
	ld a,(05c74h)		;0214
	jp l01aeh		;0217
l021ah:
	ld hl,0fff6h		;021a
	dec bc			;021d
	add hl,bc		;021e
	inc bc			;021f
	jr nc,l0231h		;0220
	ld a,(05c74h)		;0222
	and a			;0225
	jr nz,$+4		;0226
l0228h:
	rst 8			;0228
	ld c,078h		;0229
	or c			;022b
	jr z,l0238h		;022c
	ld bc,l0008h+2		;022e
l0231h:
	push ix			;0231
	pop hl			;0233
	inc hl			;0234
	ex de,hl		;0235
	ldir			;0236
l0238h:
	call sub_023dh		;0238
	jr l024fh		;023b
sub_023dh:
	push ix			;023d
	exx			;023f
	ld hl,l0017h+1		;0240
	jr l01c9h		;0243
	exx			;0245
	ld hl,l0008h		;0246
	jp l08ddh		;0249
	nop			;024c
	nop			;024d
	nop			;024e
l024fh:
	cp 0e4h			;024f
	jp nz,l02f2h		;0251
	ld a,(05c74h)		;0254
	cp 003h			;0257
	jp z,l08d9h		;0259
	jr l0280h		;025c
sub_025eh:
	call sub_03c1h		;025e
	inc de			;0261
	ld a,d			;0262
	or e			;0263
	ld a,001h		;0264
	ret z			;0266
	ld a,000h		;0267
	ret			;0269
sub_026ah:
	nop			;026a
	nop			;026b
	nop			;026c
	xor a			;026d
	ret			;026e
sub_026fh:
	cp 080h			;026f
	jp nz,l2194h		;0271
	call sub_02b9h		;0274
	call l04f1h		;0277
	jp l045fh		;027a
	nop			;027d
	nop			;027e
	nop			;027f
l0280h:
	call sub_02d7h		;0280
	call sub_02e0h		;0283
	set 7,c			;0286
	jr nc,$+13		;0288
	ld hl,l0000h		;028a
	ld a,(05c74h)		;028d
	dec a			;0290
	jr z,l02a9h		;0291
	rst 8			;0293
	ld bc,0d9c2h		;0294
	ex af,af'		;0297
	bit 7,(iy+001h)		;0298
	jr z,l02b6h		;029c
	inc hl			;029e
	ld a,(hl)		;029f
	ld (ix+00bh),a		;02a0
	inc hl			;02a3
	ld a,(hl)		;02a4
	ld (ix+00ch),a		;02a5
	inc hl			;02a8
l02a9h:
	ld (ix+00eh),c		;02a9
	ld a,001h		;02ac
	bit 6,c			;02ae
l02b0h:
	jr z,l02b3h		;02b0
	inc a			;02b2
l02b3h:
	ld (ix+000h),a		;02b3
l02b6h:
	ex de,hl		;02b6
	jr l02cbh		;02b7
sub_02b9h:
	call sub_2298h		;02b9
	jp c,l192fh		;02bc
	and a			;02bf
	jp z,l192fh		;02c0
	dec a			;02c3
	ret z			;02c4
	scf			;02c5
	ret			;02c6
	nop			;02c7
	nop			;02c8
	nop			;02c9
	nop			;02ca
l02cbh:
	call sub_02d7h		;02cb
	cp 029h			;02ce
	jr nz,$-59		;02d0
	call sub_02d7h		;02d2
	jr l02e9h		;02d5
sub_02d7h:
	push ix			;02d7
	exx			;02d9
	ld hl,l0020h		;02da
	jp l03ddh		;02dd
sub_02e0h:
	push ix			;02e0
	exx			;02e2
	ld hl,l2c70h		;02e3
	jp l03ddh		;02e6
l02e9h:
	bit 7,(iy+001h)		;02e9
	ret z			;02ed
	ex de,hl		;02ee
	jp l04c9h		;02ef
l02f2h:
	cp 0aah			;02f2
	jr nz,l032eh		;02f4
	ld a,(05c74h)		;02f6
	cp 003h			;02f9
	jp z,l08d9h		;02fb
	call sub_02d7h		;02fe
	jr l0315h		;0301
sub_0303h:
	push ix			;0303
	exx			;0305
	ld hl,l0017h+1		;0306
	jp l03ddh		;0309
sub_030ch:
	push ix			;030c
	exx			;030e
	ld hl,l0010h		;030f
	jp l03ddh		;0312
l0315h:
	bit 7,(iy+001h)		;0315
	ret z			;0319
	ld (ix+00bh),000h	;031a
	ld (ix+00ch),01bh	;031e
	ld hl,04000h		;0322
	ld (ix+00dh),l		;0325
	ld (ix+00eh),h		;0328
	jp l0440h		;032b
l032eh:
	cp 0afh			;032e
	jp nz,l0447h		;0330
	ld a,(05c74h)		;0333
	cp 003h			;0336
	jp z,l08d9h		;0338
	push ix			;033b
	exx			;033d
	ld hl,l0020h		;033e
	push hl			;0341
	ld l,000h		;0342
	ld h,0ffh		;0344
	push hl			;0346
	ld hl,l0000h		;0347
	push hl			;034a
	push hl			;034b
	exx			;034c
	call sub_0f99h		;034d
	exx			;0350
	ld hl,l21e7h		;0351
	push hl			;0354
	ld l,000h		;0355
	ld h,0ffh		;0357
	push hl			;0359
	ld hl,l0000h		;035a
	push hl			;035d
	push hl			;035e
	exx			;035f
	call sub_0f99h		;0360
	pop ix			;0363
	jr nz,l0387h		;0365
	ld a,(05c74h)		;0367
	and a			;036a
	jp z,l08d9h		;036b
	call sub_0373h		;036e
	jr l0385h		;0371
sub_0373h:
	push ix			;0373
	exx			;0375
	ld hl,01c51h		;0376
	jp l03ddh		;0379
sub_037ch:
	push ix			;037c
	exx			;037e
	ld hl,l1f23h		;037f
	jp l03ddh		;0382
l0385h:
	jr l03bch		;0385
l0387h:
	push ix			;0387
	push ix			;0389
	call sub_0392h		;038b
	pop ix			;038e
	jr l039ch		;0390
sub_0392h:
	exx			;0392
	ld hl,l2558h		;0393
	jp l08ddh		;0396
	nop			;0399
	nop			;039a
	nop			;039b
l039ch:
	exx			;039c
	ld hl,l0017h+1		;039d
	push hl			;03a0
	ld l,000h		;03a1
	ld h,0ffh		;03a3
	push hl			;03a5
	ld hl,l0000h		;03a6
	push hl			;03a9
	push hl			;03aa
	exx			;03ab
	call sub_0f99h		;03ac
	pop ix			;03af
	cp 02ch			;03b1
	jr z,l03d5h		;03b3
	ld a,(05c74h)		;03b5
	and a			;03b8
	jp z,l08d9h		;03b9
l03bch:
	call sub_0373h		;03bc
	jr l03d3h		;03bf
sub_03c1h:
	push ix			;03c1
	exx			;03c3
	ld hl,l02b0h		;03c4
	jp l03ddh		;03c7
sub_03cah:
	push ix			;03ca
	exx			;03cc
	ld hl,01be5h		;03cd
	jp l03ddh		;03d0
l03d3h:
	jr l03ffh		;03d3
l03d5h:
	call sub_02d7h		;03d5
	call sub_03cah		;03d8
	jr l03ffh		;03db
l03ddh:
	push hl			;03dd
	ld hl,0ff00h		;03de
	push hl			;03e1
	ld h,000h		;03e2
	push hl			;03e4
	push hl			;03e5
	exx			;03e6
	call sub_0f99h		;03e7
	pop ix			;03ea
	ret			;03ec
l03edh:
	push ix			;03ed
	exx			;03ef
	ld hl,l073fh		;03f0
	jp l03ddh		;03f3
l03f6h:
	ld a,0ffh		;03f6
	ld (05dcfh),a		;03f8
	jp l1c49h		;03fb
	nop			;03fe
l03ffh:
	bit 7,(iy+001h)		;03ff
	ret z			;0403
	push ix			;0404
	call sub_040dh		;0406
	pop ix			;0409
	jr l041bh		;040b
sub_040dh:
	exx			;040d
	ld hl,l3cdch		;040e
	jp l08ddh		;0411
l0414h:
	ld a,009h		;0414
l0416h:
	scf			;0416
	ret			;0417
	nop			;0418
	nop			;0419
	nop			;041a
l041bh:
	ld (ix+00bh),c		;041b
	ld (ix+00ch),b		;041e
	call sub_037ch		;0421
	jr l0438h		;0424
sub_0426h:
	push ix			;0426
	exx			;0428
	ld hl,l1230h		;0429
	jp l03ddh		;042c
sub_042fh:
	push ix			;042f
	exx			;0431
	ld hl,l2fafh		;0432
	jp l03ddh		;0435
l0438h:
	ld (ix+00dh),c		;0438
	ld (ix+00eh),b		;043b
	ld h,b			;043e
	ld l,c			;043f
l0440h:
	ld (ix+000h),003h	;0440
	jp l04c9h		;0444
l0447h:
	cp 0cah			;0447
	jr z,l0456h		;0449
	bit 7,(iy+001h)		;044b
	ret z			;044f
	ld (ix+00eh),080h	;0450
	jr l04a9h		;0454
l0456h:
	ld a,(05c74h)		;0456
	and a			;0459
	jp nz,l08d9h		;045a
	jr l0481h		;045d
l045fh:
	push af			;045f
	jr l0465h		;0460
l0462h:
	call sub_05fah		;0462
l0465h:
	call sub_068eh		;0465
	jr c,l046dh		;0468
	jp l06f2h		;046a
l046dh:
	pop af			;046d
	and a			;046e
	ret			;046f
	nop			;0470
l0471h:
	call sub_03c1h		;0471
	inc de			;0474
	ld a,d			;0475
	or e			;0476
	jr nz,l0471h		;0477
l0479h:
	call sub_0546h		;0479
	jr z,l0479h		;047c
	jp l1c40h		;047e
l0481h:
	call sub_02d7h		;0481
	call sub_03cah		;0484
	bit 7,(iy+001h)		;0487
	ret z			;048b
	push ix			;048c
	exx			;048e
	ld hl,l1f23h		;048f
	push hl			;0492
	ld l,000h		;0493
	ld h,0ffh		;0495
	push hl			;0497
	ld hl,l0000h		;0498
	push hl			;049b
	push hl			;049c
	exx			;049d
	call sub_0f99h		;049e
	pop ix			;04a1
	ld (ix+00dh),c		;04a3
	ld (ix+00eh),b		;04a6
l04a9h:
	ld (ix+000h),000h	;04a9
	ld hl,(05c59h)		;04ad
	ld de,(05c53h)		;04b0
	scf			;04b4
	sbc hl,de		;04b5
	ld (ix+00bh),l		;04b7
	ld (ix+00ch),h		;04ba
	ld hl,(05c4bh)		;04bd
	sbc hl,de		;04c0
	ld (ix+00fh),l		;04c2
	ld (ix+010h),h		;04c5
	ex de,hl		;04c8
l04c9h:
	ld a,(05c74h)		;04c9
	and a			;04cc
	jp z,l0851h		;04cd
	push hl			;04d0
	ld bc,l0010h+1		;04d1
	add ix,bc		;04d4
l04d6h:
	push ix			;04d6
	ld de,l0010h+1		;04d8
	xor a			;04db
	scf			;04dc
	call sub_00fch		;04dd
	pop ix			;04e0
	jr nc,l04d6h		;04e2
	ld a,0feh		;04e4
	jr l04fah		;04e6
sub_04e8h:
	push hl			;04e8
	ld hl,l0000h		;04e9
	ld (05dd1h),hl		;04ec
	pop hl			;04ef
	ret			;04f0
l04f1h:
	push af			;04f1
	ld a,0feh		;04f2
	call sub_0426h		;04f4
	pop af			;04f7
	ret			;04f8
	nop			;04f9
l04fah:
	call sub_0426h		;04fa
	ld (iy+052h),003h	;04fd
	ld c,080h		;0501
	ld a,(ix+000h)		;0503
	cp (ix-011h)		;0506
	jr nz,l050dh		;0509
	ld c,0f6h		;050b
l050dh:
	cp 004h			;050d
	jr nc,l04d6h		;050f
	ld de,l3ca8h		;0511
	push bc			;0514
	push ix			;0515
	exx			;0517
	ld hl,l073fh		;0518
	push hl			;051b
	ld l,000h		;051c
	ld h,0ffh		;051e
	push hl			;0520
	ld hl,l0000h		;0521
	push hl			;0524
	push hl			;0525
	exx			;0526
	call sub_0f99h		;0527
	pop ix			;052a
	pop bc			;052c
	push ix			;052d
	pop de			;052f
	ld hl,0fff0h		;0530
	add hl,de		;0533
	ld b,00ah		;0534
	ld a,(hl)		;0536
	inc a			;0537
	jr nz,l053dh		;0538
	ld a,c			;053a
	add a,b			;053b
	ld c,a			;053c
l053dh:
	inc de			;053d
	ld a,(de)		;053e
	cp (hl)			;053f
	inc hl			;0540
	jr nz,l0544h		;0541
	inc c			;0543
l0544h:
	jr l0558h		;0544
sub_0546h:
	res 5,(iy+001h)		;0546
	set 3,(iy+001h)		;054a
	call sub_03c1h		;054e
	xor a			;0551
	bit 5,(iy+001h)		;0552
	jr l0566h		;0556
l0558h:
	call sub_030ch		;0558
	djnz l053dh		;055b
	bit 7,c			;055d
	jp nz,l04d6h		;055f
	ld a,00dh		;0562
	jr l0578h		;0564
l0566h:
	ret z			;0566
	ld a,(05c08h)		;0567
	and 07fh		;056a
	cp 061h			;056c
	ret c			;056e
	cp 07bh			;056f
	ret nc			;0571
	and 0dfh		;0572
	ret			;0574
	nop			;0575
	nop			;0576
	nop			;0577
l0578h:
	call sub_030ch		;0578
	pop hl			;057b
	ld a,(ix+000h)		;057c
	cp 003h			;057f
	jr z,l058fh		;0581
	ld a,(05c74h)		;0583
	dec a			;0586
	jp z,l05cch		;0587
	cp 002h			;058a
	jp z,l06e5h		;058c
l058fh:
	push hl			;058f
	ld l,(ix-006h)		;0590
	ld h,(ix-005h)		;0593
	ld e,(ix+00bh)		;0596
	ld d,(ix+00ch)		;0599
	ld a,h			;059c
	or l			;059d
	jr z,l05adh		;059e
	sbc hl,de		;05a0
	jr c,l05cah		;05a2
	jr z,l05adh		;05a4
	ld a,(ix+000h)		;05a6
	cp 003h			;05a9
	jr nz,l05cah		;05ab
l05adh:
	pop hl			;05ad
	ld a,h			;05ae
	or l			;05af
	jr nz,l05b8h		;05b0
	ld l,(ix+00dh)		;05b2
	ld h,(ix+00eh)		;05b5
l05b8h:
	push hl			;05b8
	pop ix			;05b9
	ld a,(05c74h)		;05bb
	cp 002h			;05be
	scf			;05c0
	jr nz,l05c4h		;05c1
	and a			;05c3
l05c4h:
	ld a,0ffh		;05c4
l05c6h:
	call sub_00fch		;05c6
	ret c			;05c9
l05cah:
	rst 8			;05ca
	ld a,(de)		;05cb
l05cch:
	ld e,(ix+00bh)		;05cc
	ld d,(ix+00ch)		;05cf
	push hl			;05d2
	ld a,h			;05d3
	or l			;05d4
	jr nz,l05ddh		;05d5
	inc de			;05d7
	inc de			;05d8
	inc de			;05d9
	ex de,hl		;05da
	jr l05e9h		;05db
l05ddh:
	ld l,(ix-006h)		;05dd
	ld h,(ix-005h)		;05e0
	ex de,hl		;05e3
	scf			;05e4
	sbc hl,de		;05e5
	jr c,l0606h		;05e7
l05e9h:
	ld de,l0003h+2		;05e9
	add hl,de		;05ec
	ld b,h			;05ed
	ld c,l			;05ee
	jr l0603h		;05ef
sub_05f1h:
	push ix			;05f1
	exx			;05f3
	ld hl,01fbbh		;05f4
	jp l03ddh		;05f7
sub_05fah:
	ld (iy+052h),0ffh	;05fa
	jp sub_030ch		;05fe
	nop			;0601
	nop			;0602
l0603h:
	call sub_05f1h		;0603
l0606h:
	pop hl			;0606
	ld a,(ix+000h)		;0607
	and a			;060a
	jr z,l0673h		;060b
	ld a,h			;060d
	or l			;060e
	jr z,l0638h		;060f
	dec hl			;0611
	ld b,(hl)		;0612
	dec hl			;0613
	ld c,(hl)		;0614
	dec hl			;0615
	inc bc			;0616
	inc bc			;0617
	inc bc			;0618
l0619h:
	ld (05c5fh),ix		;0619
	push ix			;061d
	exx			;061f
	ld hl,l1750h		;0620
	push hl			;0623
	ld l,000h		;0624
	ld h,0ffh		;0626
	push hl			;0628
	ld hl,l0000h		;0629
	push hl			;062c
	push hl			;062d
	exx			;062e
	call sub_0f99h		;062f
	pop ix			;0632
	ld ix,(05c5fh)		;0634
l0638h:
	ld hl,(05c59h)		;0638
	dec hl			;063b
	ld c,(ix+00bh)		;063c
	ld b,(ix+00ch)		;063f
	push bc			;0642
	inc bc			;0643
	inc bc			;0644
	inc bc			;0645
	ld a,(ix-003h)		;0646
	push af			;0649
	jr l065eh		;064a
sub_064ch:
	push ix			;064c
	exx			;064e
	ld hl,012bbh		;064f
	jp l03ddh		;0652
sub_0655h:
	call sub_069fh		;0655
	jp nc,l06aah		;0658
	in a,(00fh)		;065b
	ret			;065d
l065eh:
	call sub_064ch		;065e
	inc hl			;0661
	pop af			;0662
	ld (hl),a		;0663
	pop de			;0664
	inc hl			;0665
	ld (hl),e		;0666
	inc hl			;0667
	ld (hl),d		;0668
	inc hl			;0669
	push hl			;066a
	pop ix			;066b
	scf			;066d
	ld a,0ffh		;066e
	jp l05c6h		;0670
l0673h:
	ex de,hl		;0673
	ld hl,(05c59h)		;0674
	dec hl			;0677
	ld (05c5fh),ix		;0678
	ld c,(ix+00bh)		;067c
	ld b,(ix+00ch)		;067f
	push bc			;0682
	jr l0697h		;0683
sub_0685h:
	push ix			;0685
	exx			;0687
	ld hl,0174dh		;0688
	jp l03ddh		;068b
sub_068eh:
	call sub_2298h		;068e
	and a			;0691
	ret z			;0692
	cp 080h			;0693
	ccf			;0695
	ret			;0696
l0697h:
	call sub_0685h		;0697
	pop bc			;069a
	push hl			;069b
	push bc			;069c
	jr l06b1h		;069d
sub_069fh:
	call sub_0856h		;069f
	rra			;06a2
	ret c			;06a3
	ld a,0feh		;06a4
	in a,(0feh)		;06a6
	rra			;06a8
	ret			;06a9
l06aah:
	pop bc			;06aa
	jp l1a61h		;06ab
	nop			;06ae
	nop			;06af
	nop			;06b0
l06b1h:
	call sub_064ch		;06b1
	ld ix,(05c5fh)		;06b4
	inc hl			;06b8
	ld c,(ix+00fh)		;06b9
	ld b,(ix+010h)		;06bc
	add hl,bc		;06bf
	ld (05c4bh),hl		;06c0
	ld h,(ix+00eh)		;06c3
	ld a,h			;06c6
	and 0c0h		;06c7
	jr nz,l06d5h		;06c9
	ld l,(ix+00dh)		;06cb
	ld (05c42h),hl		;06ce
	ld (iy+00ah),000h	;06d1
l06d5h:
	pop de			;06d5
	pop ix			;06d6
	scf			;06d8
	ld a,0ffh		;06d9
	ld hl,(05c53h)		;06db
	dec hl			;06de
	ld (05c57h),hl		;06df
	jp l05c6h		;06e2
l06e5h:
	ld c,(ix+00bh)		;06e5
	ld b,(ix+00ch)		;06e8
	push bc			;06eb
	inc bc			;06ec
	call sub_01e2h		;06ed
	jr l0704h		;06f0
l06f2h:
	jp z,l046dh		;06f2
	cp 003h			;06f5
	jp z,l21fah		;06f7
	jp l0462h		;06fa
l06fdh:
	ld hl,00a30h		;06fd
	jp l16dfh		;0700
	nop			;0703
l0704h:
	ld (hl),080h		;0704
	ex de,hl		;0706
	pop de			;0707
	push hl			;0708
	push hl			;0709
	pop ix			;070a
	scf			;070c
	ld a,0ffh		;070d
	call l05c6h		;070f
	pop hl			;0712
	ld de,(05c53h)		;0713
l0717h:
	ld a,(hl)		;0717
	and 0c0h		;0718
	jr nz,l0749h		;071a
l071ch:
	ld a,(de)		;071c
	inc de			;071d
	cp (hl)			;071e
	inc hl			;071f
	jr nz,l0724h		;0720
	ld a,(de)		;0722
	cp (hl)			;0723
l0724h:
	dec de			;0724
	dec hl			;0725
	jr nc,l0744h		;0726
	push hl			;0728
	ex de,hl		;0729
	push ix			;072a
	exx			;072c
	ld hl,l1720h		;072d
	push hl			;0730
	ld l,000h		;0731
	ld h,0ffh		;0733
	push hl			;0735
	ld hl,l0000h		;0736
	push hl			;0739
	push hl			;073a
	exx			;073b
	call sub_0f99h		;073c
l073fh:
	pop ix			;073f
	pop hl			;0741
	jr l071ch		;0742
l0744h:
	call sub_0799h		;0744
	jr l0717h		;0747
l0749h:
	ld a,(hl)		;0749
	ld c,a			;074a
	cp 080h			;074b
	ret z			;074d
	push hl			;074e
	ld hl,(05c4bh)		;074f
l0752h:
	ld a,(hl)		;0752
	cp 080h			;0753
	jr z,l0790h		;0755
	cp c			;0757
	jr z,l0776h		;0758
l075ah:
	push bc			;075a
	push ix			;075b
	exx			;075d
	ld hl,l1720h		;075e
	push hl			;0761
	ld l,000h		;0762
	ld h,0ffh		;0764
	push hl			;0766
	ld hl,l0000h		;0767
	push hl			;076a
	push hl			;076b
	exx			;076c
	call sub_0f99h		;076d
	pop ix			;0770
	pop bc			;0772
	ex de,hl		;0773
	jr l0752h		;0774
l0776h:
	and 0e0h		;0776
	cp 0a0h			;0778
	jr nz,l078eh		;077a
	pop de			;077c
	push de			;077d
	push hl			;077e
l077fh:
	inc hl			;077f
	inc de			;0780
	ld a,(de)		;0781
	cp (hl)			;0782
	jr nz,l078bh		;0783
	rla			;0785
	jr nc,l077fh		;0786
	pop hl			;0788
	jr l078eh		;0789
l078bh:
	pop hl			;078b
	jr l075ah		;078c
l078eh:
	ld a,0ffh		;078e
l0790h:
	pop de			;0790
	ex de,hl		;0791
	inc a			;0792
	scf			;0793
	call sub_0799h		;0794
	jr l0749h		;0797
sub_0799h:
	jr nz,l07cfh		;0799
	ex af,af'		;079b
	ld (05c5fh),hl		;079c
	ex de,hl		;079f
	push ix			;07a0
	exx			;07a2
	ld hl,l1720h		;07a3
	push hl			;07a6
	ld l,000h		;07a7
	ld h,0ffh		;07a9
	push hl			;07ab
	ld hl,l0000h		;07ac
	push hl			;07af
	push hl			;07b0
	exx			;07b1
	call sub_0f99h		;07b2
	exx			;07b5
	ld hl,l1750h		;07b6
	push hl			;07b9
	ld l,000h		;07ba
	ld h,0ffh		;07bc
	push hl			;07be
	ld hl,l0000h		;07bf
	push hl			;07c2
	push hl			;07c3
	exx			;07c4
	call sub_0f99h		;07c5
	pop ix			;07c8
	ex de,hl		;07ca
	ld hl,(05c5fh)		;07cb
	ex af,af'		;07ce
l07cfh:
	ex af,af'		;07cf
	push de			;07d0
	push ix			;07d1
	exx			;07d3
	ld hl,l1720h		;07d4
	push hl			;07d7
	ld l,000h		;07d8
	ld h,0ffh		;07da
	push hl			;07dc
	ld hl,l0000h		;07dd
	push hl			;07e0
	push hl			;07e1
	exx			;07e2
	call sub_0f99h		;07e3
	pop ix			;07e6
	ld (05c5fh),hl		;07e8
	ld hl,(05c53h)		;07eb
	ex (sp),hl		;07ee
	push bc			;07ef
	ex af,af'		;07f0
	jr c,l080eh		;07f1
	dec hl			;07f3
	jr l0808h		;07f4
sub_07f6h:
	push bc			;07f6
	ld b,006h		;07f7
l07f9h:
	push bc			;07f9
	ld b,000h		;07fa
l07fch:
	ld a,07fh		;07fc
	djnz l07fch		;07fe
	pop bc			;0800
	djnz l07f9h		;0801
	pop bc			;0803
	in a,(0feh)		;0804
	ret			;0806
	nop			;0807
l0808h:
	call sub_064ch		;0808
	inc hl			;080b
	jr l0825h		;080c
l080eh:
	jr l0822h		;080e
l0810h:
	call sub_05fah		;0810
l0813h:
	pop af			;0813
	ret			;0814
l0815h:
	ld a,002h		;0815
	call sub_1924h		;0817
	and a			;081a
	ei			;081b
	ret			;081c
sub_081dh:
	ld a,002h		;081d
	jp l1862h		;081f
l0822h:
	call sub_064ch		;0822
l0825h:
	inc hl			;0825
	pop bc			;0826
	pop de			;0827
	ld (05c53h),de		;0828
	ld de,(05c5fh)		;082c
	push bc			;0830
	push de			;0831
	ex de,hl		;0832
	ldir			;0833
	pop hl			;0835
	pop bc			;0836
	push de			;0837
	push ix			;0838
	exx			;083a
	ld hl,l1750h		;083b
	push hl			;083e
	ld l,000h		;083f
	ld h,0ffh		;0841
	push hl			;0843
	ld hl,l0000h		;0844
	push hl			;0847
	push hl			;0848
	exx			;0849
	call sub_0f99h		;084a
	pop ix			;084d
	pop de			;084f
	ret			;0850
l0851h:
	push hl			;0851
	ld a,0fdh		;0852
	jr l0868h		;0854
sub_0856h:
	push bc			;0856
	ld b,00ah		;0857
l0859h:
	call sub_07f6h		;0859
	djnz l0859h		;085c
	pop bc			;085e
	ret			;085f
	nop			;0860
	nop			;0861
	nop			;0862
	nop			;0863
	nop			;0864
	nop			;0865
	nop			;0866
	nop			;0867
l0868h:
	call sub_0426h		;0868
	xor a			;086b
	ld de,l3c89h		;086c
	push ix			;086f
	exx			;0871
	ld hl,l073fh		;0872
	push hl			;0875
	ld l,000h		;0876
	ld h,0ffh		;0878
	push hl			;087a
	ld hl,l0000h		;087b
	push hl			;087e
	push hl			;087f
	exx			;0880
	call sub_0f99h		;0881
	pop ix			;0884
	set 5,(iy+002h)		;0886
	call sub_08aah		;088a
	push ix			;088d
	ld de,l0010h+1		;088f
	xor a			;0892
	call sub_0068h		;0893
	pop ix			;0896
	ld b,032h		;0898
l089ah:
	halt			;089a
	djnz l089ah		;089b
	ld e,(ix+00bh)		;089d
	ld d,(ix+00ch)		;08a0
	ld a,0ffh		;08a3
	pop ix			;08a5
	jp sub_0068h		;08a7
sub_08aah:
	push af			;08aa
	push bc			;08ab
	push de			;08ac
	ld bc,09c40h		;08ad
l08b0h:
	dec bc			;08b0
	ld a,c			;08b1
	or b			;08b2
	jr nz,l08b0h		;08b3
l08b5h:
	xor a			;08b5
	in a,(0feh)		;08b6
	and 01fh		;08b8
	cp 01fh			;08ba
	jr z,l08b5h		;08bc
	push ix			;08be
	exx			;08c0
	ld hl,008a9h		;08c1
	push hl			;08c4
	ld l,000h		;08c5
	ld h,0ffh		;08c7
	push hl			;08c9
	ld hl,l0000h		;08ca
	push hl			;08cd
	push hl			;08ce
	exx			;08cf
	call sub_0f99h		;08d0
	pop ix			;08d3
	pop de			;08d5
	pop bc			;08d6
	pop af			;08d7
	ret			;08d8
l08d9h:
	exx			;08d9
	ld hl,01bedh		;08da
l08ddh:
	push hl			;08dd
	ld l,000h		;08de
	ld h,0ffh		;08e0
	push hl			;08e2
	exx			;08e3
l08e4h:
	call sub_0f8ah		;08e4
l08e7h:
	jp l01bch		;08e7
l08eah:
	ld (05cbch),hl		;08ea
	call sub_09f4h		;08ed
	ld hl,(05cbch)		;08f0
	ld de,l0008h		;08f3
	add hl,de		;08f6
	ld a,(hl)		;08f7
	cp 001h			;08f8
	jr nz,l090fh		;08fa
	push hl			;08fc
	call sub_096ch		;08fd
	pop hl			;0900
	inc hl			;0901
	ld e,(hl)		;0902
	inc hl			;0903
	ld d,(hl)		;0904
	push de			;0905
	ld b,000h		;0906
	inc hl			;0908
	ld c,(hl)		;0909
	push bc			;090a
	ei			;090b
	call 06572h		;090c
l090fh:
	ld hl,(05cbch)		;090f
	inc hl			;0912
	ld a,(hl)		;0913
	cp 002h			;0914
	jr z,l091eh		;0916
l0918h:
	call sub_096ch		;0918
	jp l099ah		;091b
l091eh:
	dec hl			;091e
	ld a,(hl)		;091f
	cp 001h			;0920
	jr z,l0956h		;0922
	cp 002h			;0924
	jr nz,l096ah		;0926
	ld de,l0006h		;0928
	add hl,de		;092b
	ld c,(hl)		;092c
	inc hl			;092d
	ld b,(hl)		;092e
	ld hl,06840h		;092f
	add hl,bc		;0932
	ex de,hl		;0933
	ld hl,06840h		;0934
	ldir			;0937
	call sub_0973h		;0939
	ld hl,(05cbch)		;093c
	ld de,l0003h+2		;093f
	add hl,de		;0942
	ld a,(hl)		;0943
	cp 000h			;0944
	jr z,l099ah		;0946
	dec hl			;0948
	ld c,(hl)		;0949
	dec hl			;094a
	ld d,(hl)		;094b
	dec hl			;094c
	ld e,(hl)		;094d
	push de			;094e
	ld b,000h		;094f
	push bc			;0951
	ei			;0952
	call 06572h		;0953
l0956h:
	call sub_096ch		;0956
	ld a,080h		;0959
	ld (05cc6h),a		;095b
	ld hl,018c6h		;095e
	push hl			;0961
	ld b,0ffh		;0962
	ld c,000h		;0964
	push bc			;0966
	call 06572h		;0967
l096ah:
	rst 8			;096a
	dec de			;096b
sub_096ch:
	ld hl,06840h		;096c
	ld de,00015h		;096f
	add hl,de		;0972
sub_0973h:
	ld (05c57h),hl		;0973
	inc hl			;0976
	ld (05c53h),hl		;0977
	ld (05c4bh),hl		;097a
	ld (hl),080h		;097d
	inc hl			;097f
	ld (05c59h),hl		;0980
	ld (hl),00dh		;0983
	inc hl			;0985
	ld (hl),080h		;0986
	inc hl			;0988
	ld (05c61h),hl		;0989
	ld (05c63h),hl		;098c
	ld (05c65h),hl		;098f
	xor a			;0992
	ld (05cc6h),a		;0993
	ld (05cc2h),a		;0996
	ret			;0999
l099ah:
	ld d,0ffh		;099a
	ld e,080h		;099c
	ld hl,l0e2fh		;099e
	push hl			;09a1
	push de			;09a2
	ld hl,(05cbch)		;09a3
	ld de,l000bh+1		;09a6
	add hl,de		;09a9
	ld b,000h		;09aa
l09ach:
	ld a,(hl)		;09ac
	cp 080h			;09ad
	jr z,l09e3h		;09af
	cp 000h			;09b1
	jr z,l09ddh		;09b3
	inc hl			;09b5
	ld b,(hl)		;09b6
	ld de,00014h		;09b7
	add hl,de		;09ba
	ld a,(hl)		;09bb
	rrca			;09bc
	jr c,l09c4h		;09bd
	inc hl			;09bf
	inc hl			;09c0
	inc hl			;09c1
	jr l09ach		;09c2
l09c4h:
	inc hl			;09c4
	ld a,(hl)		;09c5
	pop de			;09c6
	cp e			;09c7
	jr c,l09cfh		;09c8
	push de			;09ca
	inc hl			;09cb
	inc hl			;09cc
	jr l09ach		;09cd
l09cfh:
	pop de			;09cf
	ld de,l0003h+2		;09d0
	sbc hl,de		;09d3
	push hl			;09d5
	ld c,a			;09d6
	push bc			;09d7
	inc de			;09d8
	inc de			;09d9
	add hl,de		;09da
	jr l09ach		;09db
l09ddh:
	ld de,l0017h+1		;09dd
	add hl,de		;09e0
	jr l09ach		;09e1
l09e3h:
	pop bc			;09e3
	ld a,b			;09e4
	cp 0ffh			;09e5
	jr z,l09edh		;09e7
	ld c,058h		;09e9
	jr l09efh		;09eb
l09edh:
	ld c,000h		;09ed
l09efh:
	push bc			;09ef
	ei			;09f0
	call 06572h		;09f1
sub_09f4h:
	ld hl,(05cbch)		;09f4
	xor a			;09f7
	ld (05cbeh),a		;09f8
	ld (06315h),a		;09fb
	ld de,l0008h		;09fe
	add hl,de		;0a01
	ld e,0ffh		;0a02
	ld d,000h		;0a04
	push de			;0a06
	ld de,l0001h		;0a07
	push de			;0a0a
	push hl			;0a0b
	ld de,l0003h+1		;0a0c
	push de			;0a0f
	ld de,l0001h		;0a10
	push de			;0a13
	call 06722h		;0a14
	ld a,(hl)		;0a17
	cp 001h			;0a18
	jr z,l0a3eh		;0a1a
	ld (hl),000h		;0a1c
	ld e,0ffh		;0a1e
	ld d,000h		;0a20
	push de			;0a22
	ld de,08000h		;0a23
	push de			;0a26
	ld hl,(05cbch)		;0a27
	push hl			;0a2a
	ld de,l0008h		;0a2b
	push de			;0a2e
	ld de,l0001h		;0a2f
	push de			;0a32
	call 06722h		;0a33
	inc hl			;0a36
	ld a,(hl)		;0a37
	cp 002h			;0a38
	jr z,l0a3eh		;0a3a
	ld (hl),000h		;0a3c
l0a3eh:
	ld hl,(05cbch)		;0a3e
	ld de,l000bh+2		;0a41
	add hl,de		;0a44
	ld d,0c0h		;0a45
	ld e,000h		;0a47
	call 0635ch		;0a49
l0a4ch:
	call sub_0bd1h		;0a4c
	jp nc,l0ad4h		;0a4f
	ld b,a			;0a52
	set 7,b			;0a53
	ld (hl),b		;0a55
	res 7,b			;0a56
	inc hl			;0a58
	ld c,0feh		;0a59
	push bc			;0a5b
	ld de,l08e7h		;0a5c
	push de			;0a5f
	ld de,l0000h		;0a60
	push de			;0a63
	ld de,l0001h		;0a64
	push de			;0a67
	push de			;0a68
	call 06722h		;0a69
	ld e,0ffh		;0a6c
	ld d,a			;0a6e
	push de			;0a6f
	ld de,l0000h		;0a70
	push de			;0a73
	push hl			;0a74
	ld de,00016h		;0a75
	push de			;0a78
	ld de,l0001h		;0a79
	push de			;0a7c
	call 06722h		;0a7d
	ld d,(hl)		;0a80
	ld a,(l08e7h)		;0a81
	cp d			;0a84
	jp nz,l0ac2h		;0a85
	ld c,0feh		;0a88
	push bc			;0a8a
	ld de,l0a4ch		;0a8b
	push de			;0a8e
	ld de,l0000h		;0a8f
	push de			;0a92
	ld de,l0001h		;0a93
	push de			;0a96
	push de			;0a97
	call 06722h		;0a98
	ld e,0ffh		;0a9b
	ld d,a			;0a9d
	push de			;0a9e
	ld de,l0000h		;0a9f
	push de			;0aa2
	push hl			;0aa3
	ld de,00016h		;0aa4
	push de			;0aa7
	ld de,l0001h		;0aa8
	push de			;0aab
	call 06722h		;0aac
	ld d,(hl)		;0aaf
	ld a,(l08e7h)		;0ab0
	cp d			;0ab3
	jp nz,l0ac2h		;0ab4
	dec hl			;0ab7
	dec hl			;0ab8
	call sub_0adbh		;0ab9
	ld de,00015h		;0abc
	add hl,de		;0abf
	jr l0acah		;0ac0
l0ac2h:
	ld a,d			;0ac2
	and 0dfh		;0ac3
	ld (hl),a		;0ac5
	dec hl			;0ac6
	call sub_0c1fh		;0ac7
l0acah:
	ld d,0c0h		;0aca
	ld e,001h		;0acc
	call 0635ch		;0ace
	jp l0a4ch		;0ad1
l0ad4h:
	call sub_2082h		;0ad4
	call sub_0cfbh		;0ad7
	ret			;0ada
sub_0adbh:
	ld (hl),002h		;0adb
	push bc			;0add
	ld de,l0038h		;0ade
	push de			;0ae1
	push de			;0ae2
	ld de,l0010h		;0ae3
	push de			;0ae6
	ld de,l0001h		;0ae7
	push de			;0aea
	call 06722h		;0aeb
	inc hl			;0aee
	inc hl			;0aef
	ld a,(hl)		;0af0
	set 0,a			;0af1
	ld (hl),a		;0af3
	ld de,l0000h		;0af4
	ld a,001h		;0af7
l0af9h:
	ex af,af'		;0af9
	push hl			;0afa
	ex de,hl		;0afb
	ld de,l2000h		;0afc
	add hl,de		;0aff
	ex de,hl		;0b00
	pop hl			;0b01
	ld b,0feh		;0b02
	ld a,(05cbeh)		;0b04
	ld c,a			;0b07
	push bc			;0b08
	ld bc,l08e7h		;0b09
	push bc			;0b0c
	push de			;0b0d
	ld bc,l0001h		;0b0e
	push bc			;0b11
	push bc			;0b12
	call 06722h		;0b13
	ld a,(05cbeh)		;0b16
	ld b,a			;0b19
	ld c,000h		;0b1a
	push bc			;0b1c
	push de			;0b1d
	inc hl			;0b1e
	push hl			;0b1f
	ld bc,l0001h		;0b20
	push bc			;0b23
	push bc			;0b24
	call 06722h		;0b25
	ld b,(hl)		;0b28
	dec hl			;0b29
	ld a,(l08e7h)		;0b2a
	cp b			;0b2d
	jr nz,l0b95h		;0b2e
	ld b,0feh		;0b30
	ld a,(05cbeh)		;0b32
	ld c,a			;0b35
	push bc			;0b36
	ld bc,l0a4ch		;0b37
	push bc			;0b3a
	push de			;0b3b
	ld bc,l0001h		;0b3c
	push bc			;0b3f
	push bc			;0b40
	call 06722h		;0b41
	ld a,(05cbeh)		;0b44
	ld b,a			;0b47
	ld c,000h		;0b48
	push bc			;0b4a
	push de			;0b4b
	inc hl			;0b4c
	push hl			;0b4d
	ld bc,l0001h		;0b4e
	push bc			;0b51
	push bc			;0b52
	call 06722h		;0b53
	ld b,(hl)		;0b56
	dec hl			;0b57
	ld a,(l0a4ch)		;0b58
	cp b			;0b5b
	jr nz,l0b95h		;0b5c
	ex af,af'		;0b5e
	ld b,(hl)		;0b5f
	cp 001h			;0b60
	jr nz,l0b68h		;0b62
	set 1,b			;0b64
	jr l0b92h		;0b66
l0b68h:
	cp 002h			;0b68
	jr nz,l0b70h		;0b6a
	set 2,b			;0b6c
	jr l0b92h		;0b6e
l0b70h:
	cp 003h			;0b70
	jr nz,l0b78h		;0b72
	set 3,b			;0b74
	jr l0b92h		;0b76
l0b78h:
	cp 004h			;0b78
	jr nz,l0b80h		;0b7a
	set 4,b			;0b7c
	jr l0b92h		;0b7e
l0b80h:
	cp 005h			;0b80
	jr nz,l0b88h		;0b82
	set 5,b			;0b84
	jr l0b92h		;0b86
l0b88h:
	cp 006h			;0b88
	jr nz,l0b90h		;0b8a
	set 6,b			;0b8c
	jr l0b92h		;0b8e
l0b90h:
	set 7,b			;0b90
l0b92h:
	ld (hl),b		;0b92
	jr l0bcah		;0b93
l0b95h:
	ex af,af'		;0b95
	ld b,(hl)		;0b96
	cp 001h			;0b97
	jr nz,l0b9fh		;0b99
	res 1,b			;0b9b
	jr l0bc9h		;0b9d
l0b9fh:
	cp 002h			;0b9f
	jr nz,l0ba7h		;0ba1
	res 2,b			;0ba3
	jr l0bc9h		;0ba5
l0ba7h:
	cp 003h			;0ba7
	jr nz,l0bafh		;0ba9
	res 3,b			;0bab
	jr l0bc9h		;0bad
l0bafh:
	cp 004h			;0baf
	jr nz,l0bb7h		;0bb1
	res 4,b			;0bb3
	jr l0bc9h		;0bb5
l0bb7h:
	cp 005h			;0bb7
	jr nz,l0bbfh		;0bb9
	res 5,b			;0bbb
	jr l0bc9h		;0bbd
l0bbfh:
	cp 006h			;0bbf
	jr nz,l0bc7h		;0bc1
	res 6,b			;0bc3
	jr l0bc9h		;0bc5
l0bc7h:
	res 7,b			;0bc7
l0bc9h:
	ld (hl),b		;0bc9
l0bcah:
	inc a			;0bca
	cp 008h			;0bcb
	jp nz,l0af9h		;0bcd
	ret			;0bd0
sub_0bd1h:
	ld a,(05cbeh)		;0bd1
	inc a			;0bd4
	ld (05cbeh),a		;0bd5
	ld (06315h),a		;0bd8
	ld d,0a0h		;0bdb
	ld e,a			;0bdd
	call 0635ch		;0bde
	ld d,080h		;0be1
	ld e,a			;0be3
	call 0635ch		;0be4
	ld d,040h		;0be7
	ld e,000h		;0be9
	call 0635ch		;0beb
	push af			;0bee
	ld a,(0a000h)		;0bef
	ex af,af'		;0bf2
	ld a,004h		;0bf3
	ld (0a000h),a		;0bf5
	ld d,0a0h		;0bf8
	ld e,0c0h		;0bfa
	call 063adh		;0bfc
	bit 2,e			;0bff
	jr nz,l0c0ah		;0c01
	ex af,af'		;0c03
	ld (0a000h),a		;0c04
	pop af			;0c07
	scf			;0c08
	ret			;0c09
l0c0ah:
	ex af,af'		;0c0a
	ld (0a000h),a		;0c0b
	pop af			;0c0e
	dec a			;0c0f
	ld (05cbeh),a		;0c10
	ld (06315h),a		;0c13
	ld d,0c0h		;0c16
	ld e,004h		;0c18
	call 0635ch		;0c1a
	and a			;0c1d
	ret			;0c1e
sub_0c1fh:
	dec hl			;0c1f
	ld (hl),001h		;0c20
	ld de,00015h		;0c22
	add hl,de		;0c25
	ld a,(hl)		;0c26
	rra			;0c27
	jr c,l0c2fh		;0c28
	ld de,l0003h+1		;0c2a
	add hl,de		;0c2d
	ret			;0c2e
l0c2fh:
	ld c,008h		;0c2f
	ld a,(05cbeh)		;0c31
	dec hl			;0c34
	dec hl			;0c35
	dec hl			;0c36
	ld d,(hl)		;0c37
	dec hl			;0c38
	ld e,(hl)		;0c39
	ld h,d			;0c3a
	ld l,e			;0c3b
	ld b,a			;0c3c
	push hl			;0c3d
	push bc			;0c3e
	ld bc,l0000h		;0c3f
	push bc			;0c42
	push bc			;0c43
	call 065d0h		;0c44
	ld de,l0008h		;0c47
	add hl,de		;0c4a
	ret			;0c4b
	xor a			;0c4c
	ld (05cbeh),a		;0c4d
	ld (06315h),a		;0c50
	ld d,0c0h		;0c53
	ld e,000h		;0c55
	call 0635ch		;0c57
	ld hl,(05cbch)		;0c5a
	ld de,l000bh+1		;0c5d
l0c60h:
	add hl,de		;0c60
	call sub_0bd1h		;0c61
	jp nc,l0cf5h		;0c64
	ld a,(hl)		;0c67
	push hl			;0c68
	cp 080h			;0c69
	jr nz,l0c72h		;0c6b
	ld de,l0017h+1		;0c6d
	add hl,de		;0c70
	ld (hl),a		;0c71
l0c72h:
	call sub_0bd1h		;0c72
	ld hl,05fe9h		;0c75
	ld e,0ffh		;0c78
	ld d,a			;0c7a
	push de			;0c7b
	ld de,l0000h		;0c7c
	push de			;0c7f
	push hl			;0c80
	ld de,00016h		;0c81
	push de			;0c84
	ld de,l0001h		;0c85
	push de			;0c88
	call 06722h		;0c89
	ex af,af'		;0c8c
	ld a,(hl)		;0c8d
	cpl			;0c8e
	dec hl			;0c8f
	ld (hl),a		;0c90
	ex af,af'		;0c91
	ld d,0ffh		;0c92
	ld e,a			;0c94
	push de			;0c95
	push hl			;0c96
	ld de,l0001h+1		;0c97
	push de			;0c9a
	ld de,l0001h		;0c9b
	push de			;0c9e
	push de			;0c9f
	call 06722h		;0ca0
	ld e,0ffh		;0ca3
	ld d,a			;0ca5
	push de			;0ca6
	ld de,l0001h+1		;0ca7
	push de			;0caa
	inc hl			;0cab
	push hl			;0cac
	ld de,l0001h		;0cad
	push de			;0cb0
	push de			;0cb1
	call 06722h		;0cb2
	ld a,(hl)		;0cb5
	dec hl			;0cb6
	ld b,(hl)		;0cb7
	cp b			;0cb8
	jr nz,l0ccah		;0cb9
	pop hl			;0cbb
	ld a,(hl)		;0cbc
	cp 002h			;0cbd
	jr nz,l0cc5h		;0cbf
	inc hl			;0cc1
	inc hl			;0cc2
	jr l0ce8h		;0cc3
l0cc5h:
	call sub_0adbh		;0cc5
	jr l0ce8h		;0cc8
l0ccah:
	ld c,(hl)		;0cca
	pop hl			;0ccb
	inc hl			;0ccc
	inc hl			;0ccd
	ld a,(hl)		;0cce
	cp c			;0ccf
	jr z,l0ce8h		;0cd0
	push hl			;0cd2
	ex de,hl		;0cd3
	ld hl,05fe9h		;0cd4
	ld bc,00016h		;0cd7
	ldir			;0cda
	pop hl			;0cdc
	dec hl			;0cdd
	ld a,(05cbeh)		;0cde
	set 7,a			;0ce1
	ld (hl),a		;0ce3
	call sub_0c1fh		;0ce4
	inc hl			;0ce7
l0ce8h:
	ld d,0c0h		;0ce8
	ld e,001h		;0cea
	call 0635ch		;0cec
	ld de,00016h		;0cef
	jp l0c60h		;0cf2
l0cf5h:
	ld (hl),080h		;0cf5
	call sub_0cfbh		;0cf7
	ret			;0cfa
sub_0cfbh:
	xor a			;0cfb
	ld (05cbeh),a		;0cfc
l0cffh:
	ld hl,(05cbch)		;0cff
	ld de,l000bh+1		;0d02
	add hl,de		;0d05
l0d06h:
	ld a,(hl)		;0d06
	cp 080h			;0d07
	jr z,l0d84h		;0d09
	inc hl			;0d0b
	ld a,(hl)		;0d0c
	bit 7,a			;0d0d
	jr nz,l0d17h		;0d0f
	ld de,l0017h		;0d11
	add hl,de		;0d14
	jr l0d06h		;0d15
l0d17h:
	ld (05fe9h),hl		;0d17
	dec hl			;0d1a
	ld a,(hl)		;0d1b
	cp 002h			;0d1c
	jr nz,l0d28h		;0d1e
	ld de,l0017h		;0d20
	add hl,de		;0d23
	ld a,0ffh		;0d24
	jr l0d2dh		;0d26
l0d28h:
	ld de,l0017h		;0d28
	add hl,de		;0d2b
	ld a,(hl)		;0d2c
l0d2dh:
	ld (05febh),a		;0d2d
l0d30h:
	inc hl			;0d30
l0d31h:
	ld a,(hl)		;0d31
	cp 080h			;0d32
	jr z,l0d64h		;0d34
	inc hl			;0d36
	ld a,(hl)		;0d37
	bit 7,a			;0d38
	jr nz,l0d42h		;0d3a
	ld de,l0017h		;0d3c
	add hl,de		;0d3f
	jr l0d30h		;0d40
l0d42h:
	dec hl			;0d42
	ld a,(hl)		;0d43
	cp 002h			;0d44
	jr nz,l0d4eh		;0d46
	ld de,l0017h		;0d48
	add hl,de		;0d4b
	jr l0d30h		;0d4c
l0d4eh:
	ex de,hl		;0d4e
	ld bc,l0017h		;0d4f
	add hl,bc		;0d52
	ld a,(05febh)		;0d53
	ld b,a			;0d56
	ld a,(hl)		;0d57
	cp b			;0d58
	jr nc,l0d30h		;0d59
	ld (05febh),a		;0d5b
	ld (05fe9h),de		;0d5e
	jr l0d30h		;0d62
l0d64h:
	ld a,(05cbeh)		;0d64
	inc a			;0d67
	ld (05cbeh),a		;0d68
	ld hl,(05fe9h)		;0d6b
	ld (hl),a		;0d6e
	ld e,0ffh		;0d6f
	ld d,a			;0d71
	push de			;0d72
	ld e,(hl)		;0d73
	ld d,000h		;0d74
	push de			;0d76
	ld e,000h		;0d77
	push de			;0d79
	ld e,001h		;0d7a
	push de			;0d7c
	push de			;0d7d
	call 06722h		;0d7e
	jp l0cffh		;0d81
l0d84h:
	xor a			;0d84
	ld (05cbeh),a		;0d85
	ld (06315h),a		;0d88
	ld d,0c0h		;0d8b
	ld e,000h		;0d8d
	call 0635ch		;0d8f
	ld hl,(05cbch)		;0d92
	ld de,l000bh+2		;0d95
	add hl,de		;0d98
	ld d,0a0h		;0d99
l0d9bh:
	call sub_0bd1h		;0d9b
	ret nc			;0d9e
	ld e,(hl)		;0d9f
	call 0635ch		;0da0
	ld d,0c0h		;0da3
	ld e,001h		;0da5
	call 0635ch		;0da7
	ld de,l0017h+1		;0daa
	add hl,de		;0dad
	jr l0d9bh		;0dae
sub_0db0h:
	push bc			;0db0
	push de			;0db1
	push hl			;0db2
	push af			;0db3
	ld hl,(05cb4h)		;0db4
	ld de,(05c7bh)		;0db7
	and a			;0dbb
	sbc hl,de		;0dbc
	ld b,h			;0dbe
	ld c,l			;0dbf
	inc bc			;0dc0
	ld hl,(05c7bh)		;0dc1
	push hl			;0dc4
	ld de,00840h		;0dc5
	and a			;0dc8
	sbc hl,de		;0dc9
	ex de,hl		;0dcb
	pop hl			;0dcc
	ld (05c7bh),de		;0dcd
	ldir			;0dd1
	ld hl,l0000h		;0dd3
	add hl,sp		;0dd6
	ld bc,097c0h		;0dd7
	add hl,bc		;0dda
	di			;0ddb
	ld sp,hl		;0ddc
	ld de,0f7c0h		;0ddd
	ld hl,06000h		;0de0
	ld bc,00840h		;0de3
	ldir			;0de6
	ld hl,l1d00h		;0de8
	ld bc,097c0h		;0deb
l0deeh:
	ld e,(hl)		;0dee
	inc hl			;0def
	ld d,(hl)		;0df0
	inc hl			;0df1
	ld a,e			;0df2
	or d			;0df3
	jr z,l0e05h		;0df4
	ex de,hl		;0df6
	add hl,bc		;0df7
	push de			;0df8
	ld e,(hl)		;0df9
	inc hl			;0dfa
	ld d,(hl)		;0dfb
	ex de,hl		;0dfc
	add hl,bc		;0dfd
	ex de,hl		;0dfe
	ld (hl),d		;0dff
	dec hl			;0e00
	ld (hl),e		;0e01
	pop hl			;0e02
	jr l0deeh		;0e03
l0e05h:
	pop af			;0e05
	ld (05cc2h),a		;0e06
	push af			;0e09
	ei			;0e0a
	ld hl,06000h		;0e0b
l0e0eh:
	xor a			;0e0e
	ld (hl),a		;0e0f
	inc hl			;0e10
	ld a,h			;0e11
	cp 07bh			;0e12
	jr nz,l0e0eh		;0e14
	pop af			;0e16
	push af			;0e17
	and 07fh		;0e18
	ld b,a			;0e1a
	in a,(0ffh)		;0e1b
	and 080h		;0e1d
	or b			;0e1f
	out (0ffh),a		;0e20
	pop hl			;0e22
	pop de			;0e23
	pop bc			;0e24
	pop af			;0e25
	ret			;0e26
sub_0e27h:
	push af			;0e27
	push bc			;0e28
	push de			;0e29
	push hl			;0e2a
	in a,(0ffh)		;0e2b
	and 080h		;0e2d
l0e2fh:
	out (0ffh),a		;0e2f
	ld hl,l0000h		;0e31
	add hl,sp		;0e34
	ld de,097c0h		;0e35
	and a			;0e38
	sbc hl,de		;0e39
	di			;0e3b
	ld sp,hl		;0e3c
	ld hl,0ffffh		;0e3d
	ld de,0683fh		;0e40
	ld bc,00840h		;0e43
	lddr			;0e46
	ld hl,l1d00h		;0e48
	ld bc,097c0h		;0e4b
l0e4eh:
	ld e,(hl)		;0e4e
	inc hl			;0e4f
	ld d,(hl)		;0e50
	inc hl			;0e51
	ld a,e			;0e52
	or d			;0e53
	jr z,l0e66h		;0e54
	push hl			;0e56
	ex de,hl		;0e57
	ld e,(hl)		;0e58
	inc hl			;0e59
	ld d,(hl)		;0e5a
	ex de,hl		;0e5b
	and a			;0e5c
	sbc hl,bc		;0e5d
	ex de,hl		;0e5f
	ld (hl),d		;0e60
	dec hl			;0e61
	ld (hl),e		;0e62
	pop hl			;0e63
	jr l0e4eh		;0e64
l0e66h:
	xor a			;0e66
	ld (05cc2h),a		;0e67
	ei			;0e6a
	ld hl,0f7bfh		;0e6b
	ld de,0ffffh		;0e6e
	push hl			;0e71
	ld bc,(05c7bh)		;0e72
	and a			;0e76
	sbc hl,bc		;0e77
	ld b,h			;0e79
	ld c,l			;0e7a
	inc bc			;0e7b
	pop hl			;0e7c
	lddr			;0e7d
	ld de,00840h		;0e7f
	ld hl,(05c7bh)		;0e82
	add hl,de		;0e85
	ld (05c7bh),hl		;0e86
	pop hl			;0e89
	pop de			;0e8a
	pop bc			;0e8b
	pop af			;0e8c
	ret			;0e8d
	push bc			;0e8e
	push de			;0e8f
	push hl			;0e90
	push af			;0e91
	ld b,a			;0e92
	ld a,(05cc2h)		;0e93
	and a			;0e96
	jr nz,l0eedh		;0e97
	or b			;0e99
	jp z,l0f3dh		;0e9a
	ld hl,l12c0h		;0e9d
	ld b,h			;0ea0
	ld c,l			;0ea1
	ld de,00840h		;0ea2
	add hl,de		;0ea5
	ld de,(05c65h)		;0ea6
	add hl,de		;0eaa
	ld de,(05cb2h)		;0eab
	and a			;0eaf
	sbc hl,de		;0eb0
	jp nc,l0f3ah		;0eb2
	ld hl,0683fh		;0eb5
	ld de,l12cah		;0eb8
	push de			;0ebb
	ld de,0ff00h		;0ebc
	push de			;0ebf
	ld de,l0000h		;0ec0
	push de			;0ec3
	push de			;0ec4
	call 065d0h		;0ec5
	ld hl,(05c65h)		;0ec8
	ex de,hl		;0ecb
	lddr			;0ecc
	pop af			;0ece
	push af			;0ecf
	call sub_0db0h		;0ed0
	ld bc,097c0h		;0ed3
	ld hl,(05c3dh)		;0ed6
	add hl,bc		;0ed9
	ld (05c3dh),hl		;0eda
	ld hl,(05c3fh)		;0edd
	add hl,bc		;0ee0
	ld (05c3fh),hl		;0ee1
	ld hl,(05cc0h)		;0ee4
	add hl,bc		;0ee7
	ld (05cc0h),hl		;0ee8
	jr l0f3dh		;0eeb
l0eedh:
	ld a,b			;0eed
	and a			;0eee
	jr z,l0f01h		;0eef
	and 07fh		;0ef1
	ld b,a			;0ef3
	in a,(0ffh)		;0ef4
	and 080h		;0ef6
	or b			;0ef8
	out (0ffh),a		;0ef9
	ld a,b			;0efb
	ld (05cc2h),a		;0efc
	jr l0f3dh		;0eff
l0f01h:
	call sub_0e27h		;0f01
	ld bc,097c0h		;0f04
	ld hl,(05c3dh)		;0f07
	and a			;0f0a
	sbc hl,bc		;0f0b
	ld (05c3dh),hl		;0f0d
	ld hl,(05c3fh)		;0f10
	and a			;0f13
	sbc hl,bc		;0f14
	ld (05c3fh),hl		;0f16
	ld hl,(05cc0h)		;0f19
	and a			;0f1c
	sbc hl,bc		;0f1d
	ld (05cc0h),hl		;0f1f
	ld bc,l12c0h		;0f22
	ld hl,06840h		;0f25
	ld de,l1750h		;0f28
	push de			;0f2b
	ld de,0ff00h		;0f2c
	push de			;0f2f
	ld de,l0000h		;0f30
	push de			;0f33
	push de			;0f34
	call 065d0h		;0f35
	jr l0f3dh		;0f38
l0f3ah:
	scf			;0f3a
	jr l0f3eh		;0f3b
l0f3dh:
	and a			;0f3d
l0f3eh:
	pop af			;0f3e
	pop hl			;0f3f
	pop de			;0f40
	pop bc			;0f41
	ret			;0f42
	ld bc,(05c5dh)		;0f43
	call sub_2569h		;0f47
	ld hl,(05c5dh)		;0f4a
	and a			;0f4d
	sbc hl,bc		;0f4e
	dec hl			;0f50
	ld a,l			;0f51
	ld hl,(05c65h)		;0f52
	ld (hl),a		;0f55
	inc hl			;0f56
	pop bc			;0f57
	ld (hl),b		;0f58
	inc hl			;0f59
	ld (hl),c		;0f5a
	inc hl			;0f5b
	ld (05c65h),hl		;0f5c
	ld hl,(05c5dh)		;0f5f
	dec hl			;0f62
	bit 0,a			;0f63
	jr z,l0f73h		;0f65
l0f67h:
	dec a			;0f67
	ld b,(hl)		;0f68
	dec hl			;0f69
	dec a			;0f6a
	jp m,l0f7dh		;0f6b
	ld c,(hl)		;0f6e
	dec hl			;0f6f
	push bc			;0f70
	jr l0f67h		;0f71
l0f73h:
	ld b,020h		;0f73
	and a			;0f75
	ret z			;0f76
	ld c,(hl)		;0f77
	dec hl			;0f78
	dec a			;0f79
	push bc			;0f7a
	jr l0f67h		;0f7b
l0f7dh:
	ld hl,(05c65h)		;0f7d
	dec hl			;0f80
	ld a,(hl)		;0f81
	dec hl			;0f82
	ld (05c65h),hl		;0f83
	ld h,(hl)		;0f86
	ld l,a			;0f87
	push hl			;0f88
	ret			;0f89
sub_0f8ah:
	push af			;0f8a
	ld a,(05cc2h)		;0f8b
	and a			;0f8e
	jr z,l0f95h		;0f8f
	pop af			;0f91
	jp 0fd32h		;0f92
l0f95h:
	pop af			;0f95
	jp 06572h		;0f96
sub_0f99h:
	push af			;0f99
	ld a,(05cc2h)		;0f9a
	and a			;0f9d
	jr z,l0fa4h		;0f9e
	pop af			;0fa0
	jp 0fd90h		;0fa1
l0fa4h:
	pop af			;0fa4
	jp 065d0h		;0fa5
	nop			;0fa8
	nop			;0fa9
	nop			;0faa
	nop			;0fab
	nop			;0fac
	nop			;0fad
	nop			;0fae
	nop			;0faf
	nop			;0fb0
	nop			;0fb1
	nop			;0fb2
	nop			;0fb3
	nop			;0fb4
	nop			;0fb5
	nop			;0fb6
	nop			;0fb7
	nop			;0fb8
	nop			;0fb9
	nop			;0fba
	nop			;0fbb
	nop			;0fbc
	nop			;0fbd
	nop			;0fbe
	nop			;0fbf
	nop			;0fc0
	nop			;0fc1
	nop			;0fc2
	nop			;0fc3
	nop			;0fc4
	nop			;0fc5
	nop			;0fc6
	nop			;0fc7
	nop			;0fc8
	nop			;0fc9
	nop			;0fca
	nop			;0fcb
	nop			;0fcc
	nop			;0fcd
	nop			;0fce
	nop			;0fcf
	nop			;0fd0
	nop			;0fd1
	nop			;0fd2
	nop			;0fd3
	nop			;0fd4
	nop			;0fd5
	nop			;0fd6
	nop			;0fd7
	nop			;0fd8
	nop			;0fd9
	nop			;0fda
	nop			;0fdb
	nop			;0fdc
	nop			;0fdd
	nop			;0fde
	nop			;0fdf
	nop			;0fe0
	nop			;0fe1
	nop			;0fe2
	nop			;0fe3
	nop			;0fe4
	nop			;0fe5
	nop			;0fe6
	nop			;0fe7
	nop			;0fe8
	nop			;0fe9
	nop			;0fea
	nop			;0feb
	nop			;0fec
	nop			;0fed
	nop			;0fee
	nop			;0fef
	nop			;0ff0
	nop			;0ff1
	nop			;0ff2
	nop			;0ff3
	nop			;0ff4
	nop			;0ff5
	nop			;0ff6
	nop			;0ff7
	nop			;0ff8
	nop			;0ff9
	nop			;0ffa
	nop			;0ffb
	nop			;0ffc
	nop			;0ffd
	nop			;0ffe
	nop			;0fff
	ld ix,l0000h		;1000
	add ix,sp		;1004
	push bc			;1006
	push af			;1007
	push bc			;1008
	push de			;1009
	push hl			;100a
	ld e,(ix+002h)		;100b
	ld d,(ix+003h)		;100e
	xor a			;1011
	sla e			;1012
	rl d			;1014
	rla			;1016
	ld hl,l000bh+2		;1017
	sla l			;101a
	rl h			;101c
	and a			;101e
	sbc hl,de		;101f
	jr nc,l1038h		;1021
	ld hl,l0017h+1		;1023
	sla l			;1026
	rl h			;1028
	and a			;102a
	sbc hl,de		;102b
	jr c,l103eh		;102d
	ld b,0ffh		;102f
	call 06405h		;1031
	ld b,0ffh		;1034
	jr l1042h		;1036
l1038h:
	ld b,0feh		;1038
	ld c,0feh		;103a
	jr l1042h		;103c
l103eh:
	ld b,0ffh		;103e
	ld c,000h		;1040
l1042h:
	push af			;1042
	push bc			;1043
	ld hl,l1fffh		;1044
	scf			;1047
	sbc hl,de		;1048
	ld b,0feh		;104a
	call 06316h		;104c
	ex de,hl		;104f
	pop bc			;1050
	pop af			;1051
	and a			;1052
	jr z,l1074h		;1053
	ld (ix-002h),c		;1055
	ld (ix-001h),b		;1058
	ld l,(ix+000h)		;105b
	ld h,(ix+001h)		;105e
	ld (ix+003h),h		;1061
	ld (ix+002h),l		;1064
	ld (ix+001h),d		;1067
	ld (ix+000h),e		;106a
	pop hl			;106d
	pop de			;106e
	pop bc			;106f
	pop af			;1070
	call 06572h		;1071
l1074h:
	ld l,(ix+000h)		;1074
	ld h,(ix+001h)		;1077
	push hl			;107a
	ld l,(ix+004h)		;107b
	ld h,(ix+005h)		;107e
	ld (ix-002h),l		;1081
	ld (ix-001h),h		;1084
	ld l,(ix+006h)		;1087
	ld h,(ix+007h)		;108a
	ld (ix+000h),l		;108d
	ld (ix+001h),h		;1090
	ld (ix+002h),c		;1093
	ld (ix+003h),b		;1096
	ld (ix+004h),e		;1099
	ld (ix+005h),d		;109c
	pop hl			;109f
	ld (ix+006h),l		;10a0
	ld (ix+007h),h		;10a3
	pop hl			;10a6
	pop de			;10a7
	pop bc			;10a8
	pop af			;10a9
	call 065d0h		;10aa
	ret			;10ad
	push af			;10ae
	push hl			;10af
	push ix			;10b0
	ld hl,l0000h		;10b2
	add hl,sp		;10b5
	push de			;10b6
	ld a,(06315h)		;10b7
	ld e,a			;10ba
	ld d,000h		;10bb
	inc de			;10bd
	inc de			;10be
	and a			;10bf
	sbc hl,de		;10c0
	ex de,hl		;10c2
	ld ix,l0000h		;10c3
	add ix,de		;10c7
	pop de			;10c9
	ld sp,ix		;10ca
	call 0651eh		;10cc
	push bc			;10cf
	ld b,0ffh		;10d0
	call 06405h		;10d2
	ld b,0ffh		;10d5
	ld a,c			;10d7
	and 0f8h		;10d8
	ld c,a			;10da
	call 06499h		;10db
	pop bc			;10de
	ld hl,(05c78h)		;10df
	inc hl			;10e2
	ld (05c78h),hl		;10e3
	ld a,h			;10e6
	or l			;10e7
	jr nz,l10edh		;10e8
	inc (iy+040h)		;10ea
l10edh:
	push bc			;10ed
	push de			;10ee
	call sub_02e0h+1	;10ef
	pop de			;10f2
	pop bc			;10f3
	ld ix,l0000h		;10f4
	add ix,sp		;10f8
	call 0654ah		;10fa
	inc ix			;10fd
	ld sp,ix		;10ff
	pop ix			;1101
	pop hl			;1103
	pop af			;1104
	ei			;1105
	ret			;1106
	push af			;1107
	push hl			;1108
	ld hl,(05d37h)		;1109
	ld a,h			;110c
	or l			;110d
	jr z,l1111h		;110e
	jp (hl)			;1110
l1111h:
	pop hl			;1111
	pop af			;1112
	retn			;1113
	rst 38h			;1115
	push af			;1116
	push bc			;1117
	push de			;1118
	call 0645eh		;1119
	push af			;111c
	ld d,b			;111d
	ld b,a			;111e
	call 06405h		;111f
	push bc			;1122
	call 0644dh		;1123
	cpl			;1126
	ld b,d			;1127
	ld c,a			;1128
	call 06499h		;1129
	ld e,(hl)		;112c
	inc hl			;112d
	ld d,(hl)		;112e
	dec hl			;112f
	ex de,hl		;1130
	pop bc			;1131
	pop af			;1132
	ld b,a			;1133
	call 06499h		;1134
	pop de			;1137
	pop bc			;1138
	pop af			;1139
	ret			;113a
	push af			;113b
	push bc			;113c
	call 0645eh		;113d
	push af			;1140
	ld d,b			;1141
	ld b,a			;1142
	call 06405h		;1143
	push bc			;1146
	call 0644dh		;1147
	cpl			;114a
	ld b,d			;114b
	ld c,a			;114c
	call 06499h		;114d
	ld (hl),e		;1150
	inc hl			;1151
	ld (hl),d		;1152
	dec hl			;1153
	pop bc			;1154
	pop af			;1155
	call 06499h		;1156
	pop bc			;1159
	pop af			;115a
	ret			;115b
	push af			;115c
	push bc			;115d
	push hl			;115e
	ld h,d			;115f
	ld l,000h		;1160
	ld a,(0c000h)		;1162
	push af			;1165
	ld a,(hl)		;1166
	push af			;1167
	ld a,007h		;1168
	out (0f5h),a		;116a
	in a,(0f6h)		;116c
	ld b,a			;116e
	ld a,00eh		;116f
	out (0f5h),a		;1171
	in a,(0f6h)		;1173
	ld c,a			;1175
	ld a,007h		;1176
	out (0f5h),a		;1178
	ld a,040h		;117a
	out (0f6h),a		;117c
	ld a,00eh		;117e
	out (0f5h),a		;1180
	xor a			;1182
	out (0f6h),a		;1183
	ld a,002h		;1185
	ld (0c000h),a		;1187
	ld a,e			;118a
	ld (hl),a		;118b
	sra a			;118c
	sra a			;118e
	sra a			;1190
	sra a			;1192
	ld (hl),a		;1194
	ld a,007h		;1195
	out (0f5h),a		;1197
	ld a,b			;1199
	out (0f6h),a		;119a
	ld a,00eh		;119c
	out (0f5h),a		;119e
	ld a,c			;11a0
	out (0f6h),a		;11a1
	pop af			;11a3
	ld (hl),a		;11a4
	pop af			;11a5
	ld (0c000h),a		;11a6
	pop hl			;11a9
	pop bc			;11aa
	pop af			;11ab
	ret			;11ac
	push af			;11ad
	push bc			;11ae
	push hl			;11af
	ld h,d			;11b0
	ld l,000h		;11b1
	ld a,(0c000h)		;11b3
	push af			;11b6
	ld a,(hl)		;11b7
	push af			;11b8
	ld a,007h		;11b9
	out (0f5h),a		;11bb
	in a,(0f6h)		;11bd
	ld b,a			;11bf
	ld a,00eh		;11c0
	out (0f5h),a		;11c2
	in a,(0f6h)		;11c4
	ld c,a			;11c6
	push bc			;11c7
	ld a,007h		;11c8
	out (0f5h),a		;11ca
	ld a,040h		;11cc
	out (0f6h),a		;11ce
	ld a,00eh		;11d0
	out (0f5h),a		;11d2
	xor a			;11d4
	out (0f6h),a		;11d5
	ld a,002h		;11d7
	ld (0c000h),a		;11d9
	ld a,(hl)		;11dc
	and 00fh		;11dd
	ld c,a			;11df
	ld h,e			;11e0
	ld a,(hl)		;11e1
	sla a			;11e2
	sla a			;11e4
	sla a			;11e6
	sla a			;11e8
	or c			;11ea
	ld e,a			;11eb
	pop bc			;11ec
	ld a,007h		;11ed
	out (0f5h),a		;11ef
	ld a,b			;11f1
	out (0f6h),a		;11f2
	ld a,00eh		;11f4
	out (0f5h),a		;11f6
	ld a,c			;11f8
	out (0f6h),a		;11f9
	pop af			;11fb
	ld (hl),a		;11fc
	pop af			;11fd
	ld (0c000h),a		;11fe
	pop hl			;1201
	pop bc			;1202
	pop af			;1203
	ret			;1204
	push af			;1205
	push de			;1206
	ld a,b			;1207
	cp 0feh			;1208
	jr z,l123ah		;120a
	cp 0ffh			;120c
	jr z,l122dh		;120e
	and a			;1210
	jr z,l1232h		;1211
	ld d,080h		;1213
	ld e,b			;1215
	call 0635ch		;1216
	ld d,040h		;1219
	ld e,080h		;121b
	call 063adh		;121d
	ld a,e			;1220
	cpl			;1221
	ld c,a			;1222
	ld d,0a0h		;1223
	ld e,0c0h		;1225
	call 063adh		;1227
	ld b,e			;122a
	jr l124ah		;122b
l122dh:
	ld bc,l0000h		;122d
l1230h:
	jr l124ah		;1230
l1232h:
	in a,(0f4h)		;1232
	cpl			;1234
	ld b,a			;1235
	ld c,000h		;1236
	jr l124ah		;1238
l123ah:
	in a,(0ffh)		;123a
	and 080h		;123c
	cpl			;123e
	rlca			;123f
	ld b,a			;1240
	in a,(0f4h)		;1241
	cpl			;1243
	and 001h		;1244
	or b			;1246
	ld b,a			;1247
	ld c,000h		;1248
l124ah:
	pop de			;124a
	pop af			;124b
	ret			;124c
	push bc			;124d
	ld a,h			;124e
	ld b,005h		;124f
l1251h:
	srl a			;1251
	djnz l1251h		;1253
	inc a			;1255
	ld b,a			;1256
	xor a			;1257
	scf			;1258
l1259h:
	rla			;1259
	djnz l1259h		;125a
	pop bc			;125c
	ret			;125d
	push bc			;125e
	push de			;125f
	call 0644dh		;1260
	ld c,a			;1263
	ld a,(06315h)		;1264
	and a			;1267
	jr z,l1274h		;1268
	ld b,a			;126a
l126bh:
	ld e,b			;126b
	call 06405h		;126c
	and c			;126f
	jr z,l1295h		;1270
	djnz l126bh		;1272
l1274h:
	in a,(0f4h)		;1274
	cpl			;1276
	and c			;1277
	jr z,l1292h		;1278
	dec c			;127a
	jr nz,l128eh		;127b
	in a,(0ffh)		;127d
	and 080h		;127f
	ld d,a			;1281
	in a,(0f4h)		;1282
	and 001h		;1284
	rrca			;1286
	and d			;1287
	jr z,l128eh		;1288
	ld a,0feh		;128a
	jr l1296h		;128c
l128eh:
	ld a,0ffh		;128e
	jr l1296h		;1290
l1292h:
	xor a			;1292
	jr l1296h		;1293
l1295h:
	ld a,b			;1295
l1296h:
	pop de			;1296
	pop bc			;1297
	ret			;1298
	push af			;1299
	push bc			;129a
	push de			;129b
	push hl			;129c
	ld h,b			;129d
	ld a,(06315h)		;129e
	and a			;12a1
	jr z,l12b5h		;12a2
	ld d,080h		;12a4
	ld e,000h		;12a6
	call 0635ch		;12a8
	ld d,0a0h		;12ab
	push af			;12ad
	ld a,c			;12ae
	cpl			;12af
	ld e,a			;12b0
	pop af			;12b1
	call 0635ch		;12b2
l12b5h:
	ld a,b			;12b5
	and a			;12b6
	jr nz,l12cah		;12b7
	ld a,c			;12b9
	cp 0ffh			;12ba
	jr z,l12c4h		;12bc
	in a,(0ffh)		;12be
l12c0h:
	res 7,a			;12c0
	out (0ffh),a		;12c2
l12c4h:
	ld a,c			;12c4
	cpl			;12c5
	out (0f4h),a		;12c6
	jr l1319h		;12c8
l12cah:
	ld a,b			;12ca
	cp 0feh			;12cb
	jr nz,l12ech		;12cd
	in a,(0ffh)		;12cf
	rla			;12d1
	rr c			;12d2
	ccf			;12d4
	rra			;12d5
	out (0ffh),a		;12d6
	bit 7,a			;12d8
	jr nz,l12e4h		;12da
	in a,(0f4h)		;12dc
	and 0fch		;12de
	out (0f4h),a		;12e0
	jr l1319h		;12e2
l12e4h:
	in a,(0f4h)		;12e4
	or 003h			;12e6
	out (0f4h),a		;12e8
	jr l1319h		;12ea
l12ech:
	in a,(0f4h)		;12ec
	cpl			;12ee
	ld e,a			;12ef
	ld a,c			;12f0
	cpl			;12f1
	or e			;12f2
	cpl			;12f3
	out (0f4h),a		;12f4
	bit 0,c			;12f6
	jr nz,l1306h		;12f8
	in a,(0ffh)		;12fa
	res 7,a			;12fc
	out (0ffh),a		;12fe
	in a,(0f4h)		;1300
	and 0fch		;1302
	out (0f4h),a		;1304
l1306h:
	ld a,b			;1306
	cp 0ffh			;1307
	jr z,l1319h		;1309
	ld d,080h		;130b
	ld e,b			;130d
	call 0635ch		;130e
	ld d,040h		;1311
	ld a,c			;1313
	cpl			;1314
	ld e,a			;1315
	call 0635ch		;1316
l1319h:
	pop hl			;1319
	pop de			;131a
	pop bc			;131b
	pop af			;131c
	ret			;131d
	push af			;131e
	push bc			;131f
	push de			;1320
	in a,(0ffh)		;1321
	nop			;1323
	nop			;1324
	ld (ix+000h),a		;1325
	inc ix			;1328
	in a,(0f4h)		;132a
	ld (ix+000h),a		;132c
	inc ix			;132f
	ld a,(06315h)		;1331
	and a			;1334
	jr z,l1344h		;1335
	ld b,a			;1337
l1338h:
	ld e,b			;1338
	call 06405h		;1339
	ld (ix+000h),c		;133c
	inc ix			;133f
	ld b,e			;1341
	djnz l1338h		;1342
l1344h:
	dec ix			;1344
	pop de			;1346
	pop bc			;1347
	pop af			;1348
	ret			;1349
	push af			;134a
	push bc			;134b
	push de			;134c
	ld a,(ix+000h)		;134d
	out (0ffh),a		;1350
	inc ix			;1352
l1354h:
	ld a,(ix+000h)		;1354
	out (0f4h),a		;1357
	inc ix			;1359
	ld a,(06315h)		;135b
	and a			;135e
	jr z,l136ch		;135f
	ld b,a			;1361
l1362h:
	ld c,(ix+000h)		;1362
	call 06499h		;1365
	inc ix			;1368
	djnz l1362h		;136a
l136ch:
	dec ix			;136c
	pop de			;136e
	pop bc			;136f
	pop af			;1370
	ret			;1371
	ld ix,l0000h		;1372
	add ix,sp		;1376
	ld (ix+000h),c		;1378
	ld (ix+001h),b		;137b
	ld c,(ix+002h)		;137e
	ld b,(ix+003h)		;1381
	call 06499h		;1384
	pop bc			;1387
	pop ix			;1388
	pop ix			;138a
	jp (ix)			;138c
	rst 38h			;138e
	rst 38h			;138f
	rst 38h			;1390
	rst 38h			;1391
	rst 38h			;1392
	rst 38h			;1393
	rst 38h			;1394
	rst 38h			;1395
	rst 38h			;1396
	rst 38h			;1397
	rst 38h			;1398
	rst 38h			;1399
	rst 38h			;139a
	rst 38h			;139b
	rst 38h			;139c
	rst 38h			;139d
	rst 38h			;139e
	rst 38h			;139f
	rst 38h			;13a0
	rst 38h			;13a1
	rst 38h			;13a2
	rst 38h			;13a3
	rst 38h			;13a4
	rst 38h			;13a5
	rst 38h			;13a6
	rst 38h			;13a7
	rst 38h			;13a8
	rst 38h			;13a9
	rst 38h			;13aa
	rst 38h			;13ab
	rst 38h			;13ac
	rst 38h			;13ad
	rst 38h			;13ae
	rst 38h			;13af
	rst 38h			;13b0
	rst 38h			;13b1
	rst 38h			;13b2
	rst 38h			;13b3
	rst 38h			;13b4
	rst 38h			;13b5
	rst 38h			;13b6
	rst 38h			;13b7
	rst 38h			;13b8
	rst 38h			;13b9
	rst 38h			;13ba
	rst 38h			;13bb
	rst 38h			;13bc
	rst 38h			;13bd
	rst 38h			;13be
	rst 38h			;13bf
	rst 38h			;13c0
	rst 38h			;13c1
	rst 38h			;13c2
	rst 38h			;13c3
	rst 38h			;13c4
	rst 38h			;13c5
	rst 38h			;13c6
	rst 38h			;13c7
	rst 38h			;13c8
	rst 38h			;13c9
	rst 38h			;13ca
	rst 38h			;13cb
	rst 38h			;13cc
	rst 38h			;13cd
	rst 38h			;13ce
	rst 38h			;13cf
	ex (sp),hl		;13d0
	ld ix,(065ceh)		;13d1
	dec ix			;13d5
	ld (ix+000h),h		;13d7
	dec ix			;13da
	ld (ix+000h),l		;13dc
	pop hl			;13df
	ex (sp),hl		;13e0
	dec ix			;13e1
	ld (ix+000h),h		;13e3
	dec ix			;13e6
	ld (ix+000h),l		;13e8
	ld (065ceh),ix		;13eb
	push de			;13ef
	push bc			;13f0
	push af			;13f1
	ld hl,l0000h		;13f2
	add hl,sp		;13f5
	ld d,h			;13f6
	ld e,l			;13f7
	ld a,(06315h)		;13f8
	ld c,a			;13fb
	ld b,000h		;13fc
	inc bc			;13fe
	inc bc			;13ff
	and a			;1400
	sbc hl,bc		;1401
	ld sp,hl		;1403
	ld ix,l0000h		;1404
	add ix,de		;1408
	ex de,hl		;140a
	ld c,(ix+008h)		;140b
	ld b,(ix+009h)		;140e
	ld a,00eh		;1411
	add a,c			;1413
	ld c,a			;1414
	jr nc,l1418h		;1415
	inc b			;1417
l1418h:
	ldir			;1418
	push de			;141a
	pop ix			;141b
	call 0651eh		;141d
	ld ix,l0000h		;1420
	add ix,sp		;1424
	ld c,(ix+00ah)		;1426
	ld b,(ix+00bh)		;1429
	call 06499h		;142c
	pop af			;142f
	pop bc			;1430
	pop de			;1431
	pop hl			;1432
	pop ix			;1433
	pop ix			;1435
	pop ix			;1437
	call 0658ch		;1439
	push af			;143c
	push bc			;143d
	push de			;143e
	push hl			;143f
	ld ix,(065ceh)		;1440
	ld c,(ix+000h)		;1444
	inc ix			;1447
	ld b,(ix+000h)		;1449
	inc ix			;144c
	ld (065ceh),ix		;144e
	ld ix,l0000h		;1452
	add ix,sp		;1456
	ld a,008h		;1458
	add a,c			;145a
	ld c,a			;145b
	jr nc,l145fh		;145c
	inc b			;145e
l145fh:
	add ix,bc		;145f
	push ix			;1461
	pop hl			;1463
	dec hl			;1464
	call 0654ah		;1465
	push ix			;1468
	pop de			;146a
	lddr			;146b
	ex de,hl		;146d
	inc hl			;146e
	ld sp,hl		;146f
	ld ix,(065ceh)		;1470
	ld c,(ix+000h)		;1474
	inc ix			;1477
	ld b,(ix+000h)		;1479
	inc ix			;147c
	ld (065ceh),ix		;147e
	push bc			;1482
	pop ix			;1483
	pop hl			;1485
	pop de			;1486
	pop bc			;1487
	pop af			;1488
	push ix			;1489
	ret			;148b
	push hl			;148c
	push de			;148d
	push bc			;148e
	ld c,b			;148f
	ld b,(ix+009h)		;1490
	call 06499h		;1493
	ld b,d			;1496
	ld c,e			;1497
	ld e,(ix+000h)		;1498
	ld d,(ix+001h)		;149b
	ld l,(ix+006h)		;149e
	ld h,(ix+007h)		;14a1
	rlca			;14a4
	rrca			;14a5
	jr c,l14adh		;14a6
	ldir			;14a8
	add hl,bc		;14aa
	jr l14b2h		;14ab
l14adh:
	lddr			;14ad
	and a			;14af
	sbc hl,bc		;14b0
l14b2h:
	ld (ix+006h),l		;14b2
	ld (ix+007h),h		;14b5
	pop bc			;14b8
	pop hl			;14b9
	push hl			;14ba
	push bc			;14bb
	ld b,(ix+008h)		;14bc
	call 06499h		;14bf
	ld b,h			;14c2
	ld c,l			;14c3
	ld e,(ix+004h)		;14c4
	ld d,(ix+005h)		;14c7
	ld l,(ix+000h)		;14ca
	ld h,(ix+001h)		;14cd
	rlca			;14d0
	rrca			;14d1
	jr c,l14d9h		;14d2
	ldir			;14d4
	add hl,bc		;14d6
	jr l14deh		;14d7
l14d9h:
	lddr			;14d9
	and a			;14db
	sbc hl,bc		;14dc
l14deh:
	ld (ix+004h),l		;14de
	ld (ix+005h),h		;14e1
	pop bc			;14e4
	pop de			;14e5
	pop hl			;14e6
	ret			;14e7
	ld d,h			;14e8
	ld e,l			;14e9
	ld c,(ix+002h)		;14ea
	ld b,(ix+003h)		;14ed
	ld a,(ix+000h)		;14f0
	rlca			;14f3
	rrca			;14f4
	jr c,l14fah		;14f5
	add hl,bc		;14f7
	jr l14fch		;14f8
l14fah:
	sbc hl,bc		;14fa
l14fch:
	call 0644dh		;14fc
	cpl			;14ff
	ld b,a			;1500
	ex de,hl		;1501
	call 0644dh		;1502
	cpl			;1505
	ld c,a			;1506
	xor b			;1507
	jr z,l1520h		;1508
	ld a,c			;150a
	and b			;150b
	ld b,a			;150c
	ld c,000h		;150d
	scf			;150f
l1510h:
	ld a,b			;1510
	rl c			;1511
	and c			;1513
	jr nz,l1510h		;1514
l1516h:
	ld a,b			;1516
	rl c			;1517
	and c			;1519
	jr z,l1520h		;151a
	xor b			;151c
	ld b,a			;151d
	jr l1516h		;151e
l1520h:
	ld a,b			;1520
	ret			;1521
	push af			;1522
	push bc			;1523
	push de			;1524
	push hl			;1525
	ld hl,l0000h		;1526
	add hl,sp		;1529
	ld de,l0008h+2		;152a
	add hl,de		;152d
	ex de,hl		;152e
	ld a,(06315h)		;152f
	ld c,a			;1532
	ld b,000h		;1533
	ld hl,l0000h		;1535
	add hl,sp		;1538
	and a			;1539
	sbc hl,bc		;153a
	dec hl			;153c
	dec hl			;153d
	push hl			;153e
	pop ix			;153f
	ld sp,ix		;1541
	call 0651eh		;1543
	push de			;1546
	pop ix			;1547
	ld l,(ix+006h)		;1549
	ld h,(ix+007h)		;154c
	call 066e8h		;154f
	push af			;1552
	ld l,(ix+004h)		;1553
	ld h,(ix+005h)		;1556
	call 066e8h		;1559
	ld c,a			;155c
	pop af			;155d
	ld b,a			;155e
	ld a,(ix+009h)		;155f
	ld d,(ix+008h)		;1562
	cp d			;1565
	jr nz,l156dh		;1566
	ld a,b			;1568
	and c			;1569
	ld b,a			;156a
	jr l1578h		;156b
l156dh:
	ld a,b			;156d
	or c			;156e
	cp 0ffh			;156f
	jr nz,l15a0h		;1571
	ld e,b			;1573
	ld b,d			;1574
	call 06499h		;1575
l1578h:
	ld b,(ix+009h)		;1578
	ld c,e			;157b
	call 06499h		;157c
	ld l,(ix+006h)		;157f
	ld h,(ix+007h)		;1582
	ld e,(ix+004h)		;1585
	ld d,(ix+005h)		;1588
	ld c,(ix+002h)		;158b
	ld b,(ix+003h)		;158e
	ld a,(ix+000h)		;1591
	rlca			;1594
	rrca			;1595
	jr c,l159ch		;1596
	ldir			;1598
	jr l15eeh		;159a
l159ch:
	lddr			;159c
	jr l15eeh		;159e
l15a0h:
	ld hl,05cc0h		;15a0
	push bc			;15a3
	ld b,0ffh		;15a4
	call 06316h		;15a6
	pop bc			;15a9
	ld de,00200h		;15aa
	and a			;15ad
	sbc hl,de		;15ae
	ld de,l0020h		;15b0
	add hl,de		;15b3
	ex de,hl		;15b4
	ld hl,l0000h		;15b5
	add hl,sp		;15b8
	inc de			;15b9
	and a			;15ba
	sbc hl,de		;15bb
	jr nc,l15c3h		;15bd
	ld a,001h		;15bf
	jr l15eeh		;15c1
l15c3h:
	dec de			;15c3
	ex de,hl		;15c4
	ld sp,hl		;15c5
	inc de			;15c6
	ld a,(ix+000h)		;15c7
	ld (ix+000h),l		;15ca
	ld (ix+001h),h		;15cd
	ld l,(ix+002h)		;15d0
	ld h,(ix+003h)		;15d3
l15d6h:
	and a			;15d6
	sbc hl,de		;15d7
	jr c,l15e0h		;15d9
	call 0668ch		;15db
	jr l15d6h		;15de
l15e0h:
	add hl,de		;15e0
	ex de,hl		;15e1
	call 0668ch		;15e2
	ex de,hl		;15e5
	ld l,(ix+000h)		;15e6
	ld h,(ix+001h)		;15e9
	add hl,de		;15ec
	ld sp,hl		;15ed
l15eeh:
	xor a			;15ee
	ld ix,l0000h		;15ef
	add ix,sp		;15f3
	call 0654ah		;15f5
	inc ix			;15f8
	ld sp,ix		;15fa
	pop hl			;15fc
	pop de			;15fd
	pop bc			;15fe
	pop af			;15ff
	pop ix			;1600
	ex (sp),ix		;1602
	pop ix			;1604
	ex (sp),ix		;1606
	pop ix			;1608
	ex (sp),ix		;160a
	pop ix			;160c
	ex (sp),ix		;160e
	pop ix			;1610
	ex (sp),ix		;1612
	ret			;1614
	pop ix			;1615
	push af			;1617
	in a,(0ffh)		;1618
	set 7,a			;161a
	out (0ffh),a		;161c
	ld a,003h		;161e
	out (0f4h),a		;1620
	pop af			;1622
	jp (hl)			;1623
	nop			;1624
	nop			;1625
	nop			;1626
	nop			;1627
	nop			;1628
	nop			;1629
	nop			;162a
	nop			;162b
	nop			;162c
	nop			;162d
	nop			;162e
	nop			;162f
	jp l1781h		;1630
	jp l17c3h		;1633
	jp l17cdh		;1636
	jp l1668h		;1639
	jp l180fh		;163c
sub_163fh:
	push af			;163f
	call sub_229dh		;1640
	jr c,l164ah		;1643
	xor d			;1645
	ld d,a			;1646
	pop af			;1647
	and a			;1648
	ret			;1649
l164ah:
	pop af			;164a
	scf			;164b
	ret			;164c
sub_164dh:
	push af			;164d
	ld a,042h		;164e
	ld d,a			;1650
	call sub_229dh		;1651
	jr c,l1665h		;1654
	pop af			;1656
	ld (05dd9h),a		;1657
	call sub_163fh		;165a
	ld a,(05dcfh)		;165d
	call sub_163fh		;1660
	and a			;1663
	ret			;1664
l1665h:
	pop af			;1665
	scf			;1666
	ret			;1667
l1668h:
	push af			;1668
	ld a,005h		;1669
	call sub_164dh		;166b
	jp c,l1c20h		;166e
	pop af			;1671
	push hl			;1672
	call sub_163fh		;1673
	cp 080h			;1676
	jr nc,l1680h		;1678
	ld a,001h		;167a
	ld l,000h		;167c
	jr l1684h		;167e
l1680h:
	ld a,002h		;1680
	ld l,008h		;1682
l1684h:
	call sub_163fh		;1684
	ld a,(05c3ch)		;1687
	and 010h		;168a
	bit 4,(iy+001h)		;168c
	jr z,l1694h		;1690
	or 001h			;1692
l1694h:
	bit 1,(iy+030h)		;1694
	jr z,l169ch		;1698
	or 002h			;169a
l169ch:
	call sub_163fh		;169c
	ld a,(05c8dh)		;169f
	call sub_163fh		;16a2
	ld h,000h		;16a5
	ld a,l			;16a7
	ld (05dcdh),hl		;16a8
	call sub_163fh		;16ab
	ld a,h			;16ae
	call sub_163fh		;16af
	ld a,d			;16b2
	call sub_229dh		;16b3
	jp c,l1c20h		;16b6
	ld a,l			;16b9
	and a			;16ba
	jr z,l16c5h		;16bb
	ld hl,(05dd7h)		;16bd
	call sub_223eh		;16c0
	jr l16c8h		;16c3
l16c5h:
	call sub_1828h		;16c5
l16c8h:
	jp c,l1bf2h		;16c8
	and a			;16cb
	jp nz,l1bf2h		;16cc
	pop hl			;16cf
	ld a,(05dd9h)		;16d0
	cp 005h			;16d3
	jr nz,l16d8h		;16d5
	pop af			;16d7
l16d8h:
	xor a			;16d8
	ld (05dcdh),hl		;16d9
	ld hl,00a35h		;16dc
l16dfh:
	push hl			;16df
	ld l,000h		;16e0
	ld h,0ffh		;16e2
	push hl			;16e4
	ld hl,(05dcdh)		;16e5
	jp l08e4h		;16e8
l16ebh:
	rlca			;16eb
	ld d,043h		;16ec
	ld d,d			;16ee
	dec h			;16ef
	inc (hl)		;16f0
	ld h,c			;16f1
	ld (hl),b		;16f2
sub_16f3h:
	ld a,042h		;16f3
	ld d,a			;16f5
	call sub_229dh		;16f6
	ld a,000h		;16f9
	ret c			;16fb
	ld a,(05c74h)		;16fc
	cp 0d8h			;16ff
	jr nz,l1707h		;1701
	sub 0d4h		;1703
	jr l1715h		;1705
l1707h:
	cp 0dbh			;1707
	jr nz,l170fh		;1709
	sub 0d6h		;170b
	jr l1715h		;170d
l170fh:
	cp 0deh			;170f
	jr nz,l1715h		;1711
	sub 0d8h		;1713
l1715h:
	call sub_163fh		;1715
	ld a,(05dcfh)		;1718
	call sub_163fh		;171b
	in a,(0ffh)		;171e
l1720h:
	and 03fh		;1720
	ld b,a			;1722
	and 007h		;1723
	push af			;1725
	ld c,0ffh		;1726
	jr z,l173ah		;1728
	ld a,b			;172a
	rrca			;172b
	rrca			;172c
	rrca			;172d
	and 007h		;172e
	ld hl,l16ebh		;1730
	push de			;1733
	ld e,a			;1734
	ld d,000h		;1735
	add hl,de		;1737
	pop de			;1738
	ld c,(hl)		;1739
l173ah:
	ld a,c			;173a
	call sub_163fh		;173b
	pop af			;173e
	push af			;173f
	cp 006h			;1740
	jr nz,l1746h		;1742
	ld a,003h		;1744
l1746h:
	call sub_163fh		;1746
	ld hl,l1820h		;1749
	cp 003h			;174c
	jr nz,l1752h		;174e
l1750h:
	ld l,040h		;1750
l1752h:
	ld a,l			;1752
	call sub_163fh		;1753
	ld a,h			;1756
	call sub_163fh		;1757
	ld hl,04000h		;175a
	ld (05dd3h),hl		;175d
	pop af			;1760
	ld hl,01b00h		;1761
	jr z,l1769h		;1764
	ld hl,l3b00h		;1766
l1769h:
	ld (05dcdh),hl		;1769
	ld a,l			;176c
	call sub_163fh		;176d
	ld a,h			;1770
	call sub_163fh		;1771
	ld a,d			;1774
	call sub_163fh		;1775
	ld d,000h		;1778
	ld hl,04000h		;177a
	call sub_223eh		;177d
	ret			;1780
l1781h:
	ld a,(05ddbh)		;1781
	and 001h		;1784
	jr z,l1794h		;1786
	call sub_16f3h		;1788
	jp c,l1c21h		;178b
	and a			;178e
	jp nz,l1bf3h		;178f
	jr l17b3h		;1792
l1794h:
	di			;1794
	ld b,0b0h		;1795
	ld hl,04000h		;1797
l179ah:
	push hl			;179a
	push bc			;179b
	call sub_17dch		;179c
	pop bc			;179f
	pop hl			;17a0
	inc h			;17a1
	ld a,h			;17a2
	and 007h		;17a3
	jr nz,l17b1h		;17a5
	ld a,l			;17a7
	add a,020h		;17a8
	ld l,a			;17aa
	ccf			;17ab
	sbc a,a			;17ac
	and 0f8h		;17ad
	add a,h			;17af
	ld h,a			;17b0
l17b1h:
	djnz l179ah		;17b1
l17b3h:
	ld (05dcdh),hl		;17b3
	jp l06fdh		;17b6
	nop			;17b9
sub_17bah:
	push ix			;17ba
	exx			;17bc
	ld hl,00a30h		;17bd
	jp l03ddh		;17c0
l17c3h:
	call sub_17dch		;17c3
	exx			;17c6
	ld hl,l0619h		;17c7
	jp l08ddh		;17ca
l17cdh:
	di			;17cd
	ld hl,05b00h		;17ce
	ld b,008h		;17d1
l17d3h:
	push bc			;17d3
	call sub_17dch		;17d4
	pop bc			;17d7
	djnz l17d3h		;17d8
	jr l17b3h		;17da
sub_17dch:
	ld a,b			;17dc
	cp 003h			;17dd
	sbc a,a			;17df
	and 002h		;17e0
	out (0fbh),a		;17e2
	ld d,a			;17e4
l17e5h:
	call sub_2009h		;17e5
	jr c,l17efh		;17e8
	call sub_17bah		;17ea
	rst 8			;17ed
	inc c			;17ee
l17efh:
	in a,(0fbh)		;17ef
	add a,a			;17f1
	ret m			;17f2
	jr nc,l17e5h		;17f3
	ld c,020h		;17f5
l17f7h:
	ld e,(hl)		;17f7
	inc hl			;17f8
	ld b,008h		;17f9
l17fbh:
	rl d			;17fb
	rl e			;17fd
	rr d			;17ff
l1801h:
	in a,(0fbh)		;1801
	rra			;1803
	jr nc,l1801h		;1804
	ld a,d			;1806
	out (0fbh),a		;1807
	djnz l17fbh		;1809
	dec c			;180b
	jr nz,l17f7h		;180c
	ret			;180e
l180fh:
	push af			;180f
	push hl			;1810
	sub 090h		;1811
	ld l,a			;1813
	ld h,000h		;1814
	push bc			;1816
	ld bc,(05c7bh)		;1817
	add hl,hl		;181b
	add hl,hl		;181c
	add hl,hl		;181d
	add hl,bc		;181e
	pop bc			;181f
l1820h:
	ld (05dd7h),hl		;1820
	pop hl			;1823
	pop af			;1824
	jp l1668h		;1825
sub_1828h:
	ld c,00eh		;1828
	call sub_2298h		;182a
	and a			;182d
	jp z,l0414h		;182e
	dec a			;1831
	jp nz,l0416h		;1832
	call sub_1a54h		;1835
	jp c,l0414h		;1838
	ret			;183b
	rst 38h			;183c
	rst 38h			;183d
	rst 38h			;183e
	rst 38h			;183f
	jr l1856h		;1840
	jr l1862h		;1842
	jr l1852h		;1844
	jr l186dh		;1846
	jr l186ah		;1848
	jr l184fh		;184a
	jp sub_1a54h		;184c
l184fh:
	jp l2279h		;184f
l1852h:
	ld bc,00015h		;1852
	ret			;1855
l1856h:
	push af			;1856
	ld a,(05ddbh)		;1857
	and 00fh		;185a
	ld b,000h		;185c
	ld c,a			;185e
	pop af			;185f
	ret			;1860
sub_1861h:
	xor a			;1861
l1862h:
	push af			;1862
	and 00fh		;1863
	ld (05ddbh),a		;1865
	pop af			;1868
	ret			;1869
l186ah:
	jp sub_2298h		;186a
l186dh:
	jp sub_229dh		;186d
	and a			;1870
	ret			;1871
l1872h:
	pop af			;1872
	ld hl,l00e5h		;1873
	jp l006bh		;1876
l1879h:
	push af			;1879
	ld a,(05ddbh)		;187a
	and 002h		;187d
	jr z,l1872h		;187f
	pop af			;1881
	ld hl,l00e5h		;1882
	push hl			;1885
	push af			;1886
	di			;1887
	ld l,a			;1888
	and a			;1889
	jr nz,l1890h		;188a
	ld c,001h		;188c
	jr l189ah		;188e
l1890h:
	cp 0ffh			;1890
	jr nz,l1898h		;1892
	ld c,003h		;1894
	jr l18d8h		;1896
l1898h:
	ld c,009h		;1898
l189ah:
	call sub_229dh		;189a
	jp c,l192fh		;189d
	push de			;18a0
	ld a,(05c74h)		;18a1
	call sub_1963h		;18a4
	ld a,(05dcfh)		;18a7
	call sub_1963h		;18aa
	ld de,(05dd1h)		;18ad
	call sub_1959h		;18b1
	push ix			;18b4
	pop de			;18b6
	call sub_1959h		;18b7
	pop de			;18ba
	call sub_1947h		;18bb
	call sub_229dh		;18be
	jr c,l192fh		;18c1
	inc c			;18c3
	call sub_2298h		;18c4
	jp c,l1c1fh		;18c7
	and a			;18ca
	jp z,l1c1fh		;18cb
	dec a			;18ce
	jr nz,l192fh		;18cf
	inc c			;18d1
	call sub_1a54h		;18d2
	jp c,l1c1fh		;18d5
l18d8h:
	pop af			;18d8
	ld h,a			;18d9
	call sub_229dh		;18da
	jr c,l1930h		;18dd
	ld (05dcdh),de		;18df
	ld de,(05dd1h)		;18e3
	call sub_1936h		;18e7
	ld a,h			;18ea
	and a			;18eb
	call nz,sub_04e8h	;18ec
	ld de,(05dcdh)		;18ef
l18f3h:
	ld a,(ix+000h)		;18f3
	call sub_229dh		;18f6
	jr c,l1930h		;18f9
	xor h			;18fb
	ld h,a			;18fc
	inc ix			;18fd
	dec de			;18ff
	ld a,d			;1900
	or e			;1901
	jr nz,l18f3h		;1902
	ld a,h			;1904
	call sub_229dh		;1905
	jr c,l1930h		;1908
	inc c			;190a
	call sub_1a54h		;190b
	jp c,l1c20h		;190e
	call sub_2298h		;1911
	jp c,l1c20h		;1914
	and a			;1917
	jp z,l1c20h		;1918
	dec a			;191b
	call nz,sub_026fh	;191c
	ei			;191f
	jr nz,l1930h		;1920
	scf			;1922
	ret			;1923
sub_1924h:
	inc c			;1924
	ld a,h			;1925
	call sub_229dh		;1926
	jr c,l192fh		;1929
	dec c			;192b
	ret			;192c
l192dh:
	pop hl			;192d
l192eh:
	pop hl			;192e
l192fh:
	pop hl			;192f
l1930h:
	pop hl			;1930
	and a			;1931
	ret z			;1932
	jp l1bf3h		;1933
sub_1936h:
	ld a,e			;1936
	call sub_229dh		;1937
	jr c,l192fh		;193a
	call sub_1956h		;193c
	ld a,d			;193f
	call sub_229dh		;1940
	jr c,l192fh		;1943
	jr sub_1956h		;1945
sub_1947h:
	ld a,e			;1947
	call sub_229dh		;1948
	jr c,l192eh		;194b
	call sub_1956h		;194d
	ld a,d			;1950
sub_1951h:
	call sub_229dh		;1951
	jr c,l192eh		;1954
sub_1956h:
	xor l			;1956
	ld l,a			;1957
	ret			;1958
sub_1959h:
	ld a,e			;1959
	call sub_229dh		;195a
	jr c,l192dh		;195d
	call sub_1956h		;195f
	ld a,d			;1962
sub_1963h:
	call sub_229dh		;1963
	jr c,l192dh		;1966
	jr sub_1956h		;1968
l196ah:
	jp l1930h		;196a
l196dh:
	push af			;196d
	ld a,(05ddbh)		;196e
	and 002h		;1971
	jp z,l1a4dh		;1973
	pop af			;1976
	ld hl,l00e5h		;1977
	push hl			;197a
	di			;197b
	push de			;197c
	push af			;197d
	pop hl			;197e
	res 6,l			;197f
	push hl			;1981
	ld l,a			;1982
	and a			;1983
	jr nz,l198ah		;1984
	ld c,005h		;1986
	jr l1994h		;1988
l198ah:
	cp 0ffh			;198a
	jr nz,l1992h		;198c
	ld c,007h		;198e
	jr l1994h		;1990
l1992h:
	ld c,00ah		;1992
l1994h:
	pop af			;1994
	ex af,af'		;1995
	ld a,l			;1996
	ld h,a			;1997
	call sub_229dh		;1998
	jp c,l192fh		;199b
	ld a,(05c74h)		;199e
	call sub_1951h		;19a1
	ld a,(05dcfh)		;19a4
	call sub_1951h		;19a7
	ld de,(05dd1h)		;19aa
	call sub_1947h		;19ae
	inc h			;19b1
	call z,sub_04e8h	;19b2
	dec h			;19b5
	push ix			;19b6
	pop de			;19b8
	call sub_1947h		;19b9
	pop de			;19bc
	call sub_1936h		;19bd
	ld a,l			;19c0
	call sub_229dh		;19c1
	jr c,l196ah		;19c4
	inc c			;19c6
	call sub_2298h		;19c7
	jp c,l1c20h		;19ca
	and a			;19cd
	jp z,l1c20h		;19ce
	dec a			;19d1
	jr nz,l1a35h		;19d2
	call sub_1a54h		;19d4
	jp c,l1c20h		;19d7
	call sub_1924h		;19da
l19ddh:
	call sub_2298h		;19dd
	jr c,l196ah		;19e0
	ld l,a			;19e2
	ex af,af'		;19e3
	jr nz,l1a20h		;19e4
	jr nc,l1a2dh		;19e6
	ld (ix+000h),l		;19e8
	ex af,af'		;19eb
l19ech:
	ld a,h			;19ec
	xor l			;19ed
	ld h,a			;19ee
	inc ix			;19ef
	dec de			;19f1
	ld a,d			;19f2
	or e			;19f3
	jr nz,l19ddh		;19f4
	call sub_2298h		;19f6
	jp c,l196ah		;19f9
	xor h			;19fc
	and a			;19fd
	jp nz,l0815h		;19fe
	inc a			;1a01
	call sub_1924h		;1a02
	call sub_1a54h		;1a05
	jp c,l1c20h		;1a08
	call sub_2298h		;1a0b
	jp c,l1c20h		;1a0e
	and a			;1a11
	jp z,l1c20h		;1a12
	dec a			;1a15
	call nz,sub_026fh	;1a16
	scf			;1a19
	ei			;1a1a
	jr nz,l1a1eh		;1a1b
	ret			;1a1d
l1a1eh:
	ccf			;1a1e
	ret			;1a1f
l1a20h:
	rl b			;1a20
	xor l			;1a22
	ret nz			;1a23
	bit 0,b			;1a24
	jr z,l1a2ah		;1a26
	cp a			;1a28
	scf			;1a29
l1a2ah:
	ex af,af'		;1a2a
	jr l19ddh		;1a2b
l1a2dh:
	ex af,af'		;1a2d
	ld a,(ix+000h)		;1a2e
	xor l			;1a31
	jr z,l19ech		;1a32
	ret			;1a34
l1a35h:
	pop hl			;1a35
	jp l1c3eh		;1a36
l1a39h:
	pop hl			;1a39
l1a3ah:
	push af			;1a3a
	ld a,(05ddbh)		;1a3b
	and 00fh		;1a3e
	ld (05ddbh),a		;1a40
	pop af			;1a43
	pop de			;1a44
l1a45h:
	pop de			;1a45
	pop hl			;1a46
	ld bc,l0010h+1		;1a47
	jp l01d5h		;1a4a
l1a4dh:
	pop af			;1a4d
	inc d			;1a4e
	ex af,af'		;1a4f
	dec d			;1a50
	jp l00ffh		;1a51
sub_1a54h:
	push af			;1a54
	push bc			;1a55
	ld b,0e2h		;1a56
l1a58h:
	call sub_0655h		;1a58
	bit 6,a			;1a5b
	jr nz,l1a6eh		;1a5d
	djnz l1a58h		;1a5f
l1a61h:
	ld a,040h		;1a61
	nop			;1a63
	nop			;1a64
	nop			;1a65
	nop			;1a66
	nop			;1a67
	pop bc			;1a68
	pop af			;1a69
	ld a,002h		;1a6a
	scf			;1a6c
	ret			;1a6d
l1a6eh:
	pop bc			;1a6e
	pop af			;1a6f
	scf			;1a70
	ccf			;1a71
	ret			;1a72
l1a73h:
	push hl			;1a73
	push de			;1a74
	ld hl,(05c78h)		;1a75
l1a78h:
	inc hl			;1a78
	ld a,h			;1a79
	or l			;1a7a
	jr z,l1a78h		;1a7b
	ld (05dd1h),hl		;1a7d
	ld hl,(05c65h)		;1a80
	dec hl			;1a83
	ld b,(hl)		;1a84
	dec hl			;1a85
	ld c,(hl)		;1a86
	dec hl			;1a87
	ld d,(hl)		;1a88
	dec hl			;1a89
	ld e,(hl)		;1a8a
	ld a,b			;1a8b
	and a			;1a8c
	jr nz,l1a45h		;1a8d
	ld a,c			;1a8f
	cp 020h			;1a90
	jp nc,l1c2fh		;1a92
	ld a,(05c74h)		;1a95
	and a			;1a98
	jr z,l1aa0h		;1a99
	cp 002h			;1a9b
	jp nc,l1a45h		;1a9d
l1aa0h:
	ld a,c			;1aa0
	cp 020h			;1aa1
	jr nc,l1a45h		;1aa3
	and a			;1aa5
	jr z,l1a45h		;1aa6
	cp 005h			;1aa8
	jr c,l1a45h		;1aaa
	push de			;1aac
	push de			;1aad
	pop hl			;1aae
	ld (05dd3h),hl		;1aaf
	ld (05dd5h),bc		;1ab2
	ld b,05fh		;1ab6
	ld a,b			;1ab8
	and (hl)		;1ab9
	inc hl			;1aba
	cp 054h			;1abb
	jr z,l1adbh		;1abd
	cp 04eh			;1abf
	jp nz,l1a3ah		;1ac1
	ld a,b			;1ac4
	and (hl)		;1ac5
	inc hl			;1ac6
	cp 045h			;1ac7
	jp nz,l1a3ah		;1ac9
	ld a,b			;1acc
	and (hl)		;1acd
	inc hl			;1ace
	cp 054h			;1acf
	jp nz,l1a3ah		;1ad1
	ld a,(05ddbh)		;1ad4
	or 0c0h			;1ad7
	jr l1af2h		;1ad9
l1adbh:
	ld a,b			;1adb
	and (hl)		;1adc
	inc hl			;1add
	cp 050h			;1ade
	jp nz,l1a3ah		;1ae0
	ld a,b			;1ae3
	and (hl)		;1ae4
	inc hl			;1ae5
	cp 049h			;1ae6
	jp nz,l1a3ah		;1ae8
	ld a,(05ddbh)		;1aeb
	set 7,a			;1aee
	res 6,a			;1af0
l1af2h:
	ld (05ddbh),a		;1af2
	ld a,03ah		;1af5
	cp (hl)			;1af7
	jp nz,l1a3ah		;1af8
	ld a,c			;1afb
	cp 006h			;1afc
	jp c,l1a3ah		;1afe
	ld a,(05c74h)		;1b01
	and a			;1b04
	jp nz,l210eh		;1b05
	push hl			;1b08
	xor a			;1b09
	ld h,a			;1b0a
	ld l,a			;1b0b
	ld (05dd7h),hl		;1b0c
	ld (05dd9h),hl		;1b0f
	call sub_0303h		;1b12
	cp 0afh			;1b15
	jr z,l1b2ah		;1b17
	call sub_1b6bh		;1b19
	jr z,l1b48h		;1b1c
l1b1eh:
	jp l1a39h		;1b1e
sub_1b21h:
	call sub_02d7h		;1b21
	call sub_03cah		;1b24
	jp sub_037ch		;1b27
l1b2ah:
	call sub_1b21h		;1b2a
	ld (05dd7h),bc		;1b2d
	call sub_0303h		;1b31
	cp 02ch			;1b34
	jp nz,l1c27h		;1b36
	call sub_1b21h		;1b39
	ld (05dd9h),bc		;1b3c
	call sub_0303h		;1b40
	call sub_1b6bh		;1b43
	jr nz,l1b1eh		;1b46
l1b48h:
	bit 7,(iy+001h)		;1b48
	jp z,l1b71h		;1b4c
	pop hl			;1b4f
	ld bc,(05dd5h)		;1b50
	inc hl			;1b54
	ld b,05fh		;1b55
	ld a,b			;1b57
	and (hl)		;1b58
	cp 054h			;1b59
	jp z,l208eh		;1b5b
	cp 053h			;1b5e
	jp z,l20c3h		;1b60
	cp 050h			;1b63
	jp z,l2111h		;1b65
	jp l210eh		;1b68
sub_1b6bh:
	cp 00dh			;1b6b
	ret z			;1b6d
	cp 03ah			;1b6e
	ret			;1b70
l1b71h:
	pop hl			;1b71
l1b72h:
	pop de			;1b72
	jp l1c23h		;1b73
	call sub_229dh		;1b76
	jp c,l1c20h		;1b79
	jr l1b83h		;1b7c
sub_1b7eh:
	call sub_229dh		;1b7e
	jr c,l1b86h		;1b81
l1b83h:
	xor d			;1b83
	ld d,a			;1b84
	ret			;1b85
l1b86h:
	pop hl			;1b86
l1b87h:
	pop hl			;1b87
l1b88h:
	pop hl			;1b88
	pop hl			;1b89
	jp l1c3eh		;1b8a
l1b8dh:
	push af			;1b8d
	ld a,(05ddbh)		;1b8e
	res 7,a			;1b91
	res 6,a			;1b93
	ld (05ddbh),a		;1b95
	pop af			;1b98
	call sub_042fh		;1b99
	ld a,c			;1b9c
	or a			;1b9d
	jr z,l1b88h		;1b9e
	ld (05dcdh),bc		;1ba0
	ld b,c			;1ba4
	ld c,00dh		;1ba5
	ld a,042h		;1ba7
	ld d,a			;1ba9
	call sub_229dh		;1baa
	jr c,l1b87h		;1bad
	ld a,(05c74h)		;1baf
	call sub_1b7eh		;1bb2
	ld a,(05dcfh)		;1bb5
	call sub_1b7eh		;1bb8
	ld hl,(05dd7h)		;1bbb
	ld a,l			;1bbe
	call sub_1b7eh		;1bbf
	ld a,h			;1bc2
	call sub_1b7eh		;1bc3
	ld hl,(05dd9h)		;1bc6
	ld a,l			;1bc9
	call sub_1b7eh		;1bca
	ld a,h			;1bcd
	call sub_1b7eh		;1bce
	ld a,b			;1bd1
	call sub_1b7eh		;1bd2
	ld a,(05dceh)		;1bd5
	call sub_1b7eh		;1bd8
	call sub_1b7eh		;1bdb
	ld d,000h		;1bde
	pop hl			;1be0
	ld hl,(05dd3h)		;1be1
	call sub_223eh		;1be4
	jp c,l1bf1h		;1be7
	and a			;1bea
	jp z,l1c23h		;1beb
	push af			;1bee
	xor a			;1bef
	pop af			;1bf0
l1bf1h:
	pop de			;1bf1
l1bf2h:
	pop hl			;1bf2
l1bf3h:
	ei			;1bf3
	dec a			;1bf4
	jp z,l1c3eh		;1bf5
	dec a			;1bf8
	jp z,l1c39h		;1bf9
	dec a			;1bfc
	jp z,l1c3ch		;1bfd
	dec a			;1c00
	jp z,l1c35h		;1c01
	dec a			;1c04
	jr z,l1c16h		;1c05
	dec a			;1c07
	jr z,l1c18h		;1c08
	dec a			;1c0a
	jr z,l1c1ch		;1c0b
	dec a			;1c0d
	jr z,l1c1ah		;1c0e
	dec a			;1c10
	jr z,l1c21h		;1c11
	jp l00f8h		;1c13
l1c16h:
	rst 8			;1c16
	dec b			;1c17
l1c18h:
	rst 8			;1c18
	rlca			;1c19
l1c1ah:
	rst 8			;1c1a
	ex af,af'		;1c1b
l1c1ch:
	rst 8			;1c1c
	add hl,bc		;1c1d
	pop hl			;1c1e
l1c1fh:
	pop hl			;1c1f
l1c20h:
	pop hl			;1c20
l1c21h:
	rst 8			;1c21
	ld (de),a		;1c22
l1c23h:
	pop de			;1c23
	pop hl			;1c24
	xor a			;1c25
	ret			;1c26
l1c27h:
	pop hl			;1c27
	pop hl			;1c28
	pop hl			;1c29
	pop de			;1c2a
	pop hl			;1c2b
	jp l1c35h		;1c2c
l1c2fh:
	bit 7,(iy+001h)		;1c2f
	jr z,l1c23h		;1c33
l1c35h:
	ei			;1c35
	jp l08d9h		;1c36
l1c39h:
	jp l0228h		;1c39
l1c3ch:
	rst 8			;1c3c
	add hl,de		;1c3d
l1c3eh:
	rst 8			;1c3e
	ld a,(de)		;1c3f
l1c40h:
	call sub_1a54h		;1c40
	jp c,l1b87h		;1c43
	jp sub_229dh		;1c46
l1c49h:
	ld hl,l1c5dh		;1c49
	ld de,05b00h		;1c4c
	ld bc,l0029h		;1c4f
	ldir			;1c52
	call 05b00h		;1c54
	ld hl,05eeah		;1c57
	jp l1c86h		;1c5a
l1c5dh:
	xor a			;1c5d
	call 05b05h		;1c5e
	ret			;1c61
	ld de,05b0bh		;1c62
	jp l03edh		;1c65
	add a,b			;1c68
	dec c			;1c69
	dec c			;1c6a
	ld a,a			;1c6b
	jr nz,l1ca0h		;1c6c
	jr nc,$+52		;1c6e
	inc (hl)		;1c70
	jr nz,l1cc7h		;1c71
	ld l,c			;1c73
	ld l,l			;1c74
	ld h,l			;1c75
	ld a,b			;1c76
	jr nz,$+82		;1c77
	ld l,c			;1c79
	ld h,e			;1c7a
	ld l,a			;1c7b
	jr nz,l1cc7h		;1c7c
	ld l,(hl)		;1c7e
	ld (hl),h		;1c7f
	ld h,l			;1c80
	ld (hl),d		;1c81
	ld h,(hl)		;1c82
	ld h,c			;1c83
	ld h,e			;1c84
	push hl			;1c85
l1c86h:
	ld hl,05eeah		;1c86
	ld (05cbch),hl		;1c89
	xor a			;1c8c
	ld (05cbeh),a		;1c8d
	ld (06315h),a		;1c90
	ld a,0fdh		;1c93
	in a,(0feh)		;1c95
	bit 2,a			;1c97
	jp nz,l08eah		;1c99
	xor a			;1c9c
	ld (hl),a		;1c9d
	inc hl			;1c9e
	ld (hl),a		;1c9f
l1ca0h:
	ld de,l0007h		;1ca0
	add hl,de		;1ca3
	ld (hl),a		;1ca4
	ld (05cc6h),a		;1ca5
	call l0a3eh		;1ca8
	jp l0918h		;1cab
l1caeh:
	ld hl,l004fh		;1cae
	ld de,06000h		;1cb1
	ld bc,l000bh		;1cb4
	ldir			;1cb7
	jp 06000h		;1cb9
l1cbch:
	push af			;1cbc
	ld a,(05cc2h)		;1cbd
	and a			;1cc0
	jr nz,l1cc7h		;1cc1
	pop af			;1cc3
	jp 06307h		;1cc4
l1cc7h:
	pop af			;1cc7
	jp 0fac7h		;1cc8
	nop			;1ccb
	nop			;1ccc
	nop			;1ccd
	nop			;1cce
	nop			;1ccf
	nop			;1cd0
	nop			;1cd1
	nop			;1cd2
	nop			;1cd3
	nop			;1cd4
	nop			;1cd5
	nop			;1cd6
	nop			;1cd7
	nop			;1cd8
	nop			;1cd9
	nop			;1cda
	nop			;1cdb
	nop			;1cdc
	nop			;1cdd
	nop			;1cde
	nop			;1cdf
	nop			;1ce0
	nop			;1ce1
	nop			;1ce2
	nop			;1ce3
	nop			;1ce4
	nop			;1ce5
	nop			;1ce6
	nop			;1ce7
	nop			;1ce8
	nop			;1ce9
	nop			;1cea
	nop			;1ceb
	nop			;1cec
	nop			;1ced
	nop			;1cee
	nop			;1cef
	nop			;1cf0
	nop			;1cf1
	nop			;1cf2
	nop			;1cf3
	nop			;1cf4
	nop			;1cf5
	nop			;1cf6
	nop			;1cf7
	nop			;1cf8
	nop			;1cf9
	nop			;1cfa
	nop			;1cfb
	nop			;1cfc
	nop			;1cfd
	nop			;1cfe
	nop			;1cff
l1d00h:
	ld (04d62h),a		;1d00
	ld h,d			;1d03
	ld (hl),d		;1d04
	ld h,d			;1d05
	xor e			;1d06
	ld h,d			;1d07
	cp b			;1d08
	ld h,d			;1d09
	call 0d362h		;1d0a
	ld h,d			;1d0d
	call c,0fb62h		;1d0e
	ld h,d			;1d11
	ld a,(de)		;1d12
	ld h,e			;1d13
	jr nz,$+101		;1d14
	inc h			;1d16
	ld h,e			;1d17
	ld hl,(l3563h)		;1d18
	ld h,e			;1d1b
	ld a,063h		;1d1c
	ld b,h			;1d1e
	ld h,e			;1d1f
	ld c,b			;1d20
	ld h,e			;1d21
	ld c,(hl)		;1d22
	ld h,e			;1d23
	ld d,a			;1d24
	ld h,e			;1d25
	rla			;1d26
	ld h,h			;1d27
	ld e,064h		;1d28
	jr z,l1d90h		;1d2a
	ld h,c			;1d2c
	ld h,h			;1d2d
	ld h,l			;1d2e
	ld h,h			;1d2f
	ld l,l			;1d30
	ld h,h			;1d31
	sbc a,a			;1d32
	ld h,h			;1d33
	xor h			;1d34
	ld h,h			;1d35
	or e			;1d36
	ld h,h			;1d37
	ld c,065h		;1d38
	ld d,065h		;1d3a
	ld (l3a65h),a		;1d3c
	ld h,l			;1d3f
	ld e,h			;1d40
	ld h,l			;1d41
	ld h,(hl)		;1d42
	ld h,l			;1d43
	adc a,065h		;1d44
	add a,l			;1d46
	ld h,l			;1d47
	out (065h),a		;1d48
	defb 0edh ;next byte illegal after ed	;1d4a
	ld h,l			;1d4b
	ld sp,hl		;1d4c
	ld h,l			;1d4d
	ld e,066h		;1d4e
	dec l			;1d50
	ld h,(hl)		;1d51
	ld a,(04266h)		;1d52
	ld h,(hl)		;1d55
	ld d,b			;1d56
	ld h,(hl)		;1d57
	ld h,(hl)		;1d58
	ld h,(hl)		;1d59
	ld (hl),d		;1d5a
	ld h,(hl)		;1d5b
	add a,b			;1d5c
	ld h,(hl)		;1d5d
	sub h			;1d5e
	ld h,(hl)		;1d5f
	ret nz			;1d60
	ld h,(hl)		;1d61
	ld h,(iy+003h)		;1d62
	ld h,a			;1d65
	jr nc,l1dcfh		;1d66
	ld c,a			;1d68
	ld h,a			;1d69
	ld d,b			;1d6a
	ld h,a			;1d6b
	ld e,d			;1d6c
	ld h,a			;1d6d
	halt			;1d6e
	ld h,a			;1d6f
	ld a,l			;1d70
	ld h,a			;1d71
	and a			;1d72
	ld h,a			;1d73
	call c,0e367h		;1d74
	ld h,a			;1d77
	or 067h			;1d78
	nop			;1d7a
	nop			;1d7b
	nop			;1d7c
	nop			;1d7d
	nop			;1d7e
	nop			;1d7f
	nop			;1d80
	nop			;1d81
	nop			;1d82
	nop			;1d83
	nop			;1d84
	nop			;1d85
	nop			;1d86
	nop			;1d87
	nop			;1d88
	nop			;1d89
	nop			;1d8a
	nop			;1d8b
	nop			;1d8c
	nop			;1d8d
	nop			;1d8e
	nop			;1d8f
l1d90h:
	nop			;1d90
	nop			;1d91
	nop			;1d92
	nop			;1d93
	nop			;1d94
	nop			;1d95
	nop			;1d96
	nop			;1d97
	nop			;1d98
	nop			;1d99
	nop			;1d9a
	nop			;1d9b
	nop			;1d9c
	nop			;1d9d
	nop			;1d9e
	nop			;1d9f
	nop			;1da0
	nop			;1da1
	nop			;1da2
	nop			;1da3
	nop			;1da4
	nop			;1da5
	nop			;1da6
	nop			;1da7
	nop			;1da8
	nop			;1da9
	nop			;1daa
	nop			;1dab
	nop			;1dac
	nop			;1dad
	nop			;1dae
	nop			;1daf
	nop			;1db0
	nop			;1db1
	nop			;1db2
	nop			;1db3
	nop			;1db4
	nop			;1db5
	nop			;1db6
	nop			;1db7
	nop			;1db8
	nop			;1db9
	nop			;1dba
	nop			;1dbb
	nop			;1dbc
	nop			;1dbd
	nop			;1dbe
	nop			;1dbf
	nop			;1dc0
	nop			;1dc1
	nop			;1dc2
	nop			;1dc3
	nop			;1dc4
	nop			;1dc5
	nop			;1dc6
	nop			;1dc7
	nop			;1dc8
	nop			;1dc9
	nop			;1dca
	nop			;1dcb
	nop			;1dcc
	nop			;1dcd
	nop			;1dce
l1dcfh:
	nop			;1dcf
	nop			;1dd0
	nop			;1dd1
	nop			;1dd2
	nop			;1dd3
	nop			;1dd4
	nop			;1dd5
	nop			;1dd6
	nop			;1dd7
	nop			;1dd8
	nop			;1dd9
	nop			;1dda
	nop			;1ddb
	nop			;1ddc
	nop			;1ddd
	nop			;1dde
	nop			;1ddf
	nop			;1de0
	nop			;1de1
	nop			;1de2
	nop			;1de3
	nop			;1de4
	nop			;1de5
	nop			;1de6
	nop			;1de7
	nop			;1de8
	nop			;1de9
	nop			;1dea
	nop			;1deb
	nop			;1dec
	nop			;1ded
	nop			;1dee
	nop			;1def
	nop			;1df0
	nop			;1df1
	nop			;1df2
	nop			;1df3
	nop			;1df4
	nop			;1df5
	nop			;1df6
	nop			;1df7
	nop			;1df8
	nop			;1df9
	nop			;1dfa
	nop			;1dfb
	nop			;1dfc
	nop			;1dfd
	nop			;1dfe
	nop			;1dff
	nop			;1e00
	nop			;1e01
	nop			;1e02
	nop			;1e03
	nop			;1e04
	nop			;1e05
	nop			;1e06
	nop			;1e07
	nop			;1e08
	nop			;1e09
	nop			;1e0a
	nop			;1e0b
	nop			;1e0c
	nop			;1e0d
	nop			;1e0e
	nop			;1e0f
	nop			;1e10
	nop			;1e11
	nop			;1e12
	nop			;1e13
	nop			;1e14
	nop			;1e15
	nop			;1e16
	nop			;1e17
	nop			;1e18
	nop			;1e19
	nop			;1e1a
	nop			;1e1b
	nop			;1e1c
	nop			;1e1d
	nop			;1e1e
	nop			;1e1f
	nop			;1e20
	nop			;1e21
	nop			;1e22
	nop			;1e23
	nop			;1e24
	nop			;1e25
	nop			;1e26
	nop			;1e27
	nop			;1e28
	nop			;1e29
	nop			;1e2a
	nop			;1e2b
	nop			;1e2c
	nop			;1e2d
	nop			;1e2e
	nop			;1e2f
	nop			;1e30
	nop			;1e31
	nop			;1e32
	nop			;1e33
	nop			;1e34
	nop			;1e35
	nop			;1e36
	nop			;1e37
	nop			;1e38
	nop			;1e39
	nop			;1e3a
	nop			;1e3b
	nop			;1e3c
	nop			;1e3d
	nop			;1e3e
	nop			;1e3f
	nop			;1e40
	nop			;1e41
	nop			;1e42
	nop			;1e43
	nop			;1e44
	nop			;1e45
	nop			;1e46
	nop			;1e47
	nop			;1e48
	nop			;1e49
	nop			;1e4a
	nop			;1e4b
	nop			;1e4c
	nop			;1e4d
	nop			;1e4e
	nop			;1e4f
	nop			;1e50
	nop			;1e51
	nop			;1e52
	nop			;1e53
	nop			;1e54
	nop			;1e55
	nop			;1e56
	nop			;1e57
	nop			;1e58
	nop			;1e59
	nop			;1e5a
	nop			;1e5b
	nop			;1e5c
	nop			;1e5d
	nop			;1e5e
	nop			;1e5f
	nop			;1e60
	nop			;1e61
	nop			;1e62
	nop			;1e63
	nop			;1e64
	nop			;1e65
	nop			;1e66
	nop			;1e67
	nop			;1e68
	nop			;1e69
	nop			;1e6a
	nop			;1e6b
	nop			;1e6c
	nop			;1e6d
	nop			;1e6e
	nop			;1e6f
	nop			;1e70
	nop			;1e71
	nop			;1e72
	nop			;1e73
	nop			;1e74
	nop			;1e75
	nop			;1e76
	nop			;1e77
	nop			;1e78
	nop			;1e79
	nop			;1e7a
	nop			;1e7b
	nop			;1e7c
	nop			;1e7d
	nop			;1e7e
	nop			;1e7f
	nop			;1e80
	nop			;1e81
	nop			;1e82
	nop			;1e83
	nop			;1e84
	nop			;1e85
	nop			;1e86
	nop			;1e87
	nop			;1e88
	nop			;1e89
	nop			;1e8a
	nop			;1e8b
	nop			;1e8c
	nop			;1e8d
	nop			;1e8e
	nop			;1e8f
	nop			;1e90
	nop			;1e91
	nop			;1e92
	nop			;1e93
	nop			;1e94
	nop			;1e95
	nop			;1e96
	nop			;1e97
	nop			;1e98
	nop			;1e99
	nop			;1e9a
	nop			;1e9b
	nop			;1e9c
	nop			;1e9d
	nop			;1e9e
	nop			;1e9f
	nop			;1ea0
	nop			;1ea1
	nop			;1ea2
	nop			;1ea3
	nop			;1ea4
	nop			;1ea5
	nop			;1ea6
	nop			;1ea7
	nop			;1ea8
	nop			;1ea9
	nop			;1eaa
	nop			;1eab
	nop			;1eac
	nop			;1ead
	nop			;1eae
	nop			;1eaf
	nop			;1eb0
	nop			;1eb1
	nop			;1eb2
	nop			;1eb3
	nop			;1eb4
	nop			;1eb5
	nop			;1eb6
	nop			;1eb7
	nop			;1eb8
	nop			;1eb9
	nop			;1eba
	nop			;1ebb
	nop			;1ebc
	nop			;1ebd
	nop			;1ebe
	nop			;1ebf
	nop			;1ec0
	nop			;1ec1
	nop			;1ec2
	nop			;1ec3
	nop			;1ec4
	nop			;1ec5
	nop			;1ec6
	nop			;1ec7
	nop			;1ec8
	nop			;1ec9
	nop			;1eca
	nop			;1ecb
	nop			;1ecc
	nop			;1ecd
	nop			;1ece
l1ecfh:
	nop			;1ecf
	nop			;1ed0
	nop			;1ed1
	nop			;1ed2
	nop			;1ed3
	nop			;1ed4
	nop			;1ed5
	nop			;1ed6
	nop			;1ed7
	nop			;1ed8
	nop			;1ed9
	nop			;1eda
	nop			;1edb
	sub l			;1edc
	rla			;1edd
	inc de			;1ede
	jr z,l1f05h		;1edf
	ld h,039h		;1ee1
	add hl,bc		;1ee3
	and (hl)		;1ee4
	ex af,af'		;1ee5
	ccf			;1ee6
	rlca			;1ee7
	ld h,(hl)		;1ee8
	dec b			;1ee9
	ld d,h			;1eea
	dec b			;1eeb
	ld a,(0b005h)		;1eec
	ld (bc),a		;1eef
	djnz l1ef2h		;1ef0
l1ef2h:
	defb 0edh ;next byte illegal after ed	;1ef2
	ld de,011cfh		;1ef3
	ld l,h			;1ef6
	inc a			;1ef7
	ld h,l			;1ef8
	inc a			;1ef9
	ld e,(hl)		;1efa
	inc a			;1efb
	ld c,(hl)		;1efc
	inc a			;1efd
	defb 0fdh,03bh,0f5h ;illegal sequence	;1efe
	dec sp			;1f01
	ret nc			;1f02
	dec sp			;1f03
	push bc			;1f04
l1f05h:
	dec sp			;1f05
	sbc a,(hl)		;1f06
	dec sp			;1f07
	ld l,03bh		;1f08
	rst 18h			;1f0a
	ld a,(l3acah)		;1f0b
	cp e			;1f0e
l1f0fh:
	ld a,(l3656h)		;1f0f
	out (035h),a		;1f12
	ld l,(hl)		;1f14
	dec (hl)		;1f15
	adc a,c			;1f16
	inc (hl)		;1f17
	ld l,b			;1f18
	inc (hl)		;1f19
	out (033h),a		;1f1a
	adc a,033h		;1f1c
	and c			;1f1e
	ld sp,l3193h		;1f1f
l1f22h:
	ld h,b			;1f22
l1f23h:
	ld sp,l30f9h		;1f23
	jp (hl)			;1f26
	jr nc,l1f0fh		;1f27
	jr nc,l1f84h		;1f29
	jr nc,$-62		;1f2b
	cpl			;1f2d
	xor a			;1f2e
	cpl			;1f2f
	cp l			;1f30
	ld l,074h		;1f31
	ld l,070h		;1f33
	ld l,070h		;1f35
	inc l			;1f37
	jp p,0e529h		;1f38
	add hl,hl		;1f3b
	or (hl)			;1f3c
	add hl,hl		;1f3d
	rst 10h			;1f3e
	jr z,l1ecfh		;1f3f
	jr z,l1f97h		;1f41
	jr z,$+18		;1f43
	jr z,l1f22h		;1f45
	ld h,079h		;1f47
	ld h,060h		;1f49
	ld h,03eh		;1f4b
	ld h,035h		;1f4d
	ld h,003h		;1f4f
	ld h,01dh		;1f51
	inc h			;1f53
	sbc a,023h		;1f54
	add a,b			;1f56
	inc hl			;1f57
	ld l,e			;1f58
	ld (0222bh),hl		;1f59
	ld a,(hl)		;1f5c
	ld hl,l2159h		;1f5d
	ld d,l			;1f60
	ld hl,l201dh		;1f61
	add hl,bc		;1f64
	jr nz,$-19		;1f65
	rra			;1f67
	call nc,0bb1fh		;1f68
	rra			;1f6b
	sbc a,c			;1f6c
	rra			;1f6d
	add hl,sp		;1f6e
	rra			;1f6f
	ld (hl),01fh		;1f70
	inc hl			;1f72
	rra			;1f73
	ld e,01fh		;1f74
	pop af			;1f76
	ld e,0e4h		;1f77
	ld e,0d4h		;1f79
	ld e,0cah		;1f7b
	ld e,082h		;1f7d
	ld e,097h		;1f7f
	dec e			;1f81
	ld d,l			;1f82
	dec e			;1f83
l1f84h:
	ld e,c			;1f84
	inc e			;1f85
	ld a,b			;1f86
	inc e			;1f87
	ret c			;1f88
	ld a,(de)		;1f89
	daa			;1f8a
	ld a,(de)		;1f8b
	adc a,b			;1f8c
	rla			;1f8d
	ld d,b			;1f8e
	rla			;1f8f
	jr nz,l1fa9h		;1f90
	ret p			;1f92
	ld d,0d6h		;1f93
	ld d,00dh		;1f95
l1f97h:
	ld d,0d0h		;1f97
	dec h			;1f99
	call z,0d425h		;1f9a
	dec h			;1f9d
	ret z			;1f9e
	dec h			;1f9f
	ld h,l			;1fa0
	inc d			;1fa1
	ld hl,(0be14h)		;1fa2
	inc de			;1fa5
	sbc a,a			;1fa6
	inc de			;1fa7
	ld d,h			;1fa8
l1fa9h:
	inc de			;1fa9
	cp e			;1faa
	ld (de),a		;1fab
	jr nc,l1fc0h		;1fac
	pop hl			;1fae
	ld de,l0d31h		;1faf
	dec e			;1fb2
	dec c			;1fb3
	dec c			;1fb4
	dec c			;1fb5
	ld c,d			;1fb6
	ld a,(bc)		;1fb7
	inc hl			;1fb8
	ld a,(bc)		;1fb9
	jp pe,0a908h		;1fba
	ex af,af'		;1fbd
	adc a,b			;1fbe
	ex af,af'		;1fbf
l1fc0h:
	djnz $+9		;1fc0
	or d			;1fc2
	dec b			;1fc3
	nop			;1fc4
	dec b			;1fc5
	ld (bc),a		;1fc6
	ld a,(bc)		;1fc7
	ld (hl),004h		;1fc8
	di			;1fca
	inc bc			;1fcb
	pop hl			;1fcc
	ld (bc),a		;1fcd
	rst 38h			;1fce
	rst 38h			;1fcf
	rst 38h			;1fd0
	rst 38h			;1fd1
	rst 38h			;1fd2
	rst 38h			;1fd3
	rst 38h			;1fd4
	rst 38h			;1fd5
	rst 38h			;1fd6
	rst 38h			;1fd7
	ld (0d067h),hl		;1fd8
	ld h,l			;1fdb
	ld (hl),d		;1fdc
	ld h,l			;1fdd
	sbc a,c			;1fde
	ld h,h			;1fdf
	ld e,(hl)		;1fe0
	ld h,h			;1fe1
	dec b			;1fe2
	ld h,h			;1fe3
	rst 38h			;1fe4
	rst 38h			;1fe5
	rst 38h			;1fe6
	rst 38h			;1fe7
	rst 38h			;1fe8
	rst 38h			;1fe9
	rst 38h			;1fea
	rst 38h			;1feb
	push hl			;1fec
	nop			;1fed
	adc a,(hl)		;1fee
	ld c,051h		;1fef
	ex af,af'		;1ff1
	push hl			;1ff2
	ld b,0cch		;1ff3
	dec b			;1ff5
	xor e			;1ff6
	ld bc,sub_018dh		;1ff7
	adc a,c			;1ffa
	ld bc,sub_00fch		;1ffb
	ld l,b			;1ffe
l1fffh:
	nop			;1fff
l2000h:
	jp l203fh		;2000
l2003h:
	jp l2003h		;2003
l2006h:
	jp l2006h		;2006
sub_2009h:
	ld a,07fh		;2009
	in a,(0feh)		;200b
	rra			;200d
	ret c			;200e
	bit 6,(iy+07dh)		;200f
	jr z,l2017h		;2013
	scf			;2015
	ret			;2016
l2017h:
	ld a,0feh		;2017
	in a,(0feh)		;2019
	rra			;201b
	ret c			;201c
l201dh:
	ret			;201d
	ld a,020h		;201e
	out (00fh),a		;2020
	xor a			;2022
	out (00fh),a		;2023
	pop af			;2025
	ret			;2026
l2027h:
	jp l2027h		;2027
l202ah:
	jp l202ah		;202a
l202dh:
	jp l202dh		;202d
l2030h:
	jp l2030h		;2030
l2033h:
	jp l2033h		;2033
l2036h:
	jp l2036h		;2036
l2039h:
	jp l2039h		;2039
l203ch:
	jp l203ch		;203c
l203fh:
	di			;203f
	ld a,l			;2040
	srl l			;2041
	srl l			;2043
	cpl			;2045
	and 003h		;2046
	ld c,a			;2048
	ld b,000h		;2049
	ld ix,l205bh		;204b
	add ix,bc		;204f
	ld a,(05c48h)		;2051
	and 038h		;2054
	rrca			;2056
	rrca			;2057
	rrca			;2058
	or 008h			;2059
l205bh:
	nop			;205b
	nop			;205c
	nop			;205d
	inc b			;205e
	inc c			;205f
l2060h:
	dec c			;2060
	jr nz,l2060h		;2061
	ld c,03fh		;2063
	dec b			;2065
	jp nz,l2060h		;2066
	xor 010h		;2069
	out (0feh),a		;206b
	ld b,h			;206d
	ld c,a			;206e
	bit 4,a			;206f
	jr nz,l207ch		;2071
	ld a,d			;2073
	or e			;2074
	jr z,l2080h		;2075
	ld a,c			;2077
	ld c,l			;2078
	dec de			;2079
	jp (ix)			;207a
l207ch:
	ld c,l			;207c
	inc c			;207d
	jp (ix)			;207e
l2080h:
	ei			;2080
	ret			;2081
sub_2082h:
	dec hl			;2082
	ld (hl),080h		;2083
	push ix			;2085
	exx			;2087
	ld hl,00a35h		;2088
	jp l03ddh		;208b
l208eh:
	inc hl			;208e
	ld a,b			;208f
	and (hl)		;2090
	cp 041h			;2091
	jp nz,l2155h		;2093
	inc hl			;2096
	ld a,b			;2097
	and (hl)		;2098
	cp 050h			;2099
	jr nz,l210eh		;209b
	inc hl			;209d
	ld a,b			;209e
	and (hl)		;209f
	cp 045h			;20a0
	jr nz,l210eh		;20a2
	ld a,(05ddbh)		;20a4
	bit 7,a			;20a7
	res 7,a			;20a9
	ld (05ddbh),a		;20ab
	jr z,l210eh		;20ae
	bit 6,a			;20b0
	res 6,a			;20b2
	ld (05ddbh),a		;20b4
	jr nz,l210eh		;20b7
	ld a,008h		;20b9
	cp c			;20bb
	jr nz,l210eh		;20bc
	call sub_1861h		;20be
	jr l2108h		;20c1
l20c3h:
	inc hl			;20c3
	ld a,b			;20c4
	and (hl)		;20c5
	cp 044h			;20c6
	jr nz,l210eh		;20c8
	inc hl			;20ca
	ld a,b			;20cb
	and (hl)		;20cc
	cp 043h			;20cd
	jr nz,l210eh		;20cf
	inc hl			;20d1
	ld a,b			;20d2
	and (hl)		;20d3
	cp 041h			;20d4
	jr nz,l210eh		;20d6
	inc hl			;20d8
	ld a,b			;20d9
	and (hl)		;20da
	cp 052h			;20db
	jr nz,l210eh		;20dd
	inc hl			;20df
	ld a,b			;20e0
	and (hl)		;20e1
	cp 044h			;20e2
	jr nz,l210eh		;20e4
	ld a,(05ddbh)		;20e6
	bit 7,a			;20e9
	res 7,a			;20eb
	ld (05ddbh),a		;20ed
	jr z,l210eh		;20f0
	bit 6,a			;20f2
	res 6,a			;20f4
	ld (05ddbh),a		;20f6
	jr nz,l210eh		;20f9
	ld a,00ah		;20fb
	cp c			;20fd
	jr nz,l210eh		;20fe
	ld a,(05ddbh)		;2100
	or 002h			;2103
l2105h:
	call l1862h		;2105
l2108h:
	call sub_042fh		;2108
	jp l1b72h		;210b
l210eh:
	jp l1b8dh		;210e
l2111h:
	inc hl			;2111
	ld a,b			;2112
	and (hl)		;2113
	cp 049h			;2114
	jr nz,l210eh		;2116
	inc hl			;2118
	ld a,b			;2119
	and (hl)		;211a
	cp 043h			;211b
	jr nz,l210eh		;211d
	inc hl			;211f
	ld a,b			;2120
	and (hl)		;2121
	cp 04fh			;2122
	jr nz,l210eh		;2124
	inc hl			;2126
	ld a,b			;2127
	and (hl)		;2128
	cp 050h			;2129
	jr nz,l210eh		;212b
	inc hl			;212d
	ld a,b			;212e
	and (hl)		;212f
	cp 054h			;2130
	jr nz,l210eh		;2132
	ld a,(05ddbh)		;2134
	bit 7,a			;2137
	res 7,a			;2139
	ld (05ddbh),a		;213b
	jr z,l210eh		;213e
	bit 6,a			;2140
	res 6,a			;2142
	ld (05ddbh),a		;2144
	jr nz,l210eh		;2147
	ld a,00ah		;2149
	cp c			;214b
	jr nz,l210eh		;214c
	ld a,(05ddbh)		;214e
	set 0,a			;2151
	jr l2105h		;2153
l2155h:
	cp 053h			;2155
	jr nz,l210eh		;2157
l2159h:
	inc hl			;2159
	ld a,(hl)		;215a
	cp 032h			;215b
	jr nz,l210eh		;215d
	inc hl			;215f
	ld a,(hl)		;2160
	cp 030h			;2161
	jr nz,l210eh		;2163
	inc hl			;2165
	ld a,(hl)		;2166
	cp 034h			;2167
	jr nz,l210eh		;2169
	inc hl			;216b
	ld a,(hl)		;216c
	cp 030h			;216d
	jr nz,l210eh		;216f
	ld a,(05ddbh)		;2171
	bit 7,a			;2174
	res 7,a			;2176
	ld (05ddbh),a		;2178
	jr z,l210eh		;217b
	bit 6,a			;217d
	res 6,a			;217f
	ld (05ddbh),a		;2181
	jr nz,l210eh		;2184
	ld a,00ah		;2186
	cp c			;2188
	jp nz,l210eh		;2189
	ld a,(05ddbh)		;218c
	res 0,a			;218f
	jp l2105h		;2191
l2194h:
	cp 081h			;2194
	jr nz,l21a4h		;2196
	call sub_02b9h		;2198
	call l04f1h		;219b
	call l045fh		;219e
	jp l21c1h		;21a1
l21a4h:
	cp 082h			;21a4
	jr nz,l21bah		;21a6
	call sub_02b9h		;21a8
	push af			;21ab
	call sub_21b1h		;21ac
	pop af			;21af
	ret			;21b0
sub_21b1h:
	call l04f1h		;21b1
	call sub_2298h		;21b4
	jp sub_05fah		;21b7
l21bah:
	cp 083h			;21ba
	jr nz,l21c7h		;21bc
	call sub_02b9h		;21be
l21c1h:
	push af			;21c1
	call l0471h		;21c2
	pop af			;21c5
	ret			;21c6
l21c7h:
	cp 084h			;21c7
	jr nz,l21dfh		;21c9
	call sub_02b9h		;21cb
	push af			;21ce
	push hl			;21cf
	call sub_025eh		;21d0
	ld l,a			;21d3
	call sub_026ah		;21d4
	add a,a			;21d7
	or l			;21d8
	call sub_229dh		;21d9
	pop hl			;21dc
	pop af			;21dd
	ret			;21de
l21dfh:
	cp 085h			;21df
	jr nz,l21fdh		;21e1
	call sub_01c3h		;21e3
	push af			;21e6
l21e7h:
	call l045fh		;21e7
	jp c,l0813h		;21ea
	call l0471h		;21ed
	and 05fh		;21f0
	cp 04eh			;21f2
	jp nz,l22a1h		;21f4
	jp l0810h		;21f7
l21fah:
	pop af			;21fa
	scf			;21fb
	ret			;21fc
l21fdh:
	cp 086h			;21fd
	jr nz,l2213h		;21ff
	call sub_02b9h		;2201
	push af			;2204
	call sub_220ah		;2205
	pop af			;2208
	ret			;2209
sub_220ah:
	push ix			;220a
	exx			;220c
	ld hl,008a6h		;220d
	jp l03ddh		;2210
l2213h:
	cp 086h			;2213
	ret nz			;2215
	call sub_02b9h		;2216
	push af			;2219
	call l203fh		;221a
	pop af			;221d
	ret			;221e
sub_221fh:
	call sub_081dh		;221f
	call sub_096ch		;2222
	xor a			;2225
	ld (05cbeh),a		;2226
	ld (06315h),a		;2229
	ret			;222c
	rrca			;222d
	ld a,080h		;222e
	ld (05ef6h),a		;2230
	ret			;2233
	rrca			;2234
	xor a			;2235
	out (00fh),a		;2236
	ret			;2238
	ld a,001h		;2239
	jp l192fh		;223b
sub_223eh:
	call sub_2298h		;223e
	jr c,l2294h		;2241
	and a			;2243
	jr z,l2294h		;2244
	dec a			;2246
	call sub_1a54h		;2247
	jr c,l2294h		;224a
	ret nz			;224c
	ld a,044h		;224d
	ld d,a			;224f
	call sub_229dh		;2250
	jr c,l2294h		;2253
	ld a,(05dcdh)		;2255
	call sub_1b7eh		;2258
	ld a,(05dceh)		;225b
	call sub_1b7eh		;225e
l2261h:
	ld a,(hl)		;2261
	call sub_1b7eh		;2262
	inc hl			;2265
	push hl			;2266
	ld hl,(05dcdh)		;2267
	dec hl			;226a
	ld (05dcdh),hl		;226b
	ld a,h			;226e
	or l			;226f
	pop hl			;2270
	jr nz,l2261h		;2271
	ld a,d			;2273
	call sub_229dh		;2274
	jr c,l2294h		;2277
l2279h:
	call sub_1a54h		;2279
	jp c,l2294h		;227c
	ld c,00eh		;227f
	call sub_2298h		;2281
	jr c,l2294h		;2284
	and a			;2286
	jp z,l2294h		;2287
	dec a			;228a
	ret z			;228b
	call sub_026fh		;228c
	and a			;228f
	jr nz,l2296h		;2290
	and a			;2292
	ret			;2293
l2294h:
	ld a,009h		;2294
l2296h:
	scf			;2296
	ret			;2297
sub_2298h:
	in a,(00eh)		;2298
	and a			;229a
	ret			;229b
	ret			;229c
sub_229dh:
	out (00eh),a		;229d
	and a			;229f
	ret			;22a0
l22a1h:
	call sub_1a54h		;22a1
	jr c,l22a9h		;22a4
	jp l21e7h		;22a6
l22a9h:
	pop af			;22a9
	ld a,009h		;22aa
	scf			;22ac
	ret			;22ad
	rst 38h			;22ae
	rst 38h			;22af
	rst 38h			;22b0
	rst 38h			;22b1
	rst 38h			;22b2
	rst 38h			;22b3
	rst 38h			;22b4
	rst 38h			;22b5
	rst 38h			;22b6
	rst 38h			;22b7
	rst 38h			;22b8
	rst 38h			;22b9
	rst 38h			;22ba
	rst 38h			;22bb
	rst 38h			;22bc
	rst 38h			;22bd
	rst 38h			;22be
	rst 38h			;22bf
	rst 38h			;22c0
	rst 38h			;22c1
	rst 38h			;22c2
	rst 38h			;22c3
	rst 38h			;22c4
	rst 38h			;22c5
	rst 38h			;22c6
	rst 38h			;22c7
	rst 38h			;22c8
	rst 38h			;22c9
	rst 38h			;22ca
	rst 38h			;22cb
	rst 38h			;22cc
	rst 38h			;22cd
	rst 38h			;22ce
	rst 38h			;22cf
	rst 38h			;22d0
	rst 38h			;22d1
	rst 38h			;22d2
	rst 38h			;22d3
	rst 38h			;22d4
	rst 38h			;22d5
	rst 38h			;22d6
	rst 38h			;22d7
	rst 38h			;22d8
	rst 38h			;22d9
	rst 38h			;22da
	rst 38h			;22db
	rst 38h			;22dc
	rst 38h			;22dd
	rst 38h			;22de
	rst 38h			;22df
	rst 38h			;22e0
	rst 38h			;22e1
	rst 38h			;22e2
	rst 38h			;22e3
	rst 38h			;22e4
	rst 38h			;22e5
	rst 38h			;22e6
	rst 38h			;22e7
	rst 38h			;22e8
	rst 38h			;22e9
	rst 38h			;22ea
	rst 38h			;22eb
	rst 38h			;22ec
	rst 38h			;22ed
	rst 38h			;22ee
	rst 38h			;22ef
	rst 38h			;22f0
	rst 38h			;22f1
	rst 38h			;22f2
	rst 38h			;22f3
	rst 38h			;22f4
	rst 38h			;22f5
	rst 38h			;22f6
	rst 38h			;22f7
	rst 38h			;22f8
	rst 38h			;22f9
	rst 38h			;22fa
	rst 38h			;22fb
	rst 38h			;22fc
	rst 38h			;22fd
	rst 38h			;22fe
	rst 38h			;22ff
	rst 38h			;2300
	rst 38h			;2301
	rst 38h			;2302
	rst 38h			;2303
	rst 38h			;2304
	rst 38h			;2305
	rst 38h			;2306
	rst 38h			;2307
	rst 38h			;2308
	rst 38h			;2309
	rst 38h			;230a
	rst 38h			;230b
	rst 38h			;230c
	rst 38h			;230d
	rst 38h			;230e
	rst 38h			;230f
	rst 38h			;2310
	rst 38h			;2311
	rst 38h			;2312
	rst 38h			;2313
	rst 38h			;2314
	rst 38h			;2315
	rst 38h			;2316
	rst 38h			;2317
	rst 38h			;2318
	rst 38h			;2319
	rst 38h			;231a
	rst 38h			;231b
	rst 38h			;231c
	rst 38h			;231d
	rst 38h			;231e
	rst 38h			;231f
	rst 38h			;2320
	rst 38h			;2321
	rst 38h			;2322
	rst 38h			;2323
	rst 38h			;2324
	rst 38h			;2325
	rst 38h			;2326
	rst 38h			;2327
	rst 38h			;2328
	rst 38h			;2329
	rst 38h			;232a
	rst 38h			;232b
	rst 38h			;232c
	rst 38h			;232d
	rst 38h			;232e
	rst 38h			;232f
	rst 38h			;2330
	rst 38h			;2331
	rst 38h			;2332
	rst 38h			;2333
	rst 38h			;2334
	rst 38h			;2335
	rst 38h			;2336
	rst 38h			;2337
	rst 38h			;2338
	rst 38h			;2339
	rst 38h			;233a
	rst 38h			;233b
	rst 38h			;233c
	rst 38h			;233d
	rst 38h			;233e
	rst 38h			;233f
	rst 38h			;2340
	rst 38h			;2341
	rst 38h			;2342
	rst 38h			;2343
	rst 38h			;2344
	rst 38h			;2345
	rst 38h			;2346
	rst 38h			;2347
	rst 38h			;2348
	rst 38h			;2349
	rst 38h			;234a
	rst 38h			;234b
	rst 38h			;234c
	rst 38h			;234d
	rst 38h			;234e
	rst 38h			;234f
	rst 38h			;2350
	rst 38h			;2351
	rst 38h			;2352
	rst 38h			;2353
	rst 38h			;2354
	rst 38h			;2355
	rst 38h			;2356
	rst 38h			;2357
	rst 38h			;2358
	rst 38h			;2359
	rst 38h			;235a
	rst 38h			;235b
	rst 38h			;235c
	rst 38h			;235d
	rst 38h			;235e
	rst 38h			;235f
	rst 38h			;2360
	rst 38h			;2361
	rst 38h			;2362
	rst 38h			;2363
	rst 38h			;2364
	rst 38h			;2365
	rst 38h			;2366
	rst 38h			;2367
	rst 38h			;2368
	rst 38h			;2369
	rst 38h			;236a
	rst 38h			;236b
	rst 38h			;236c
	rst 38h			;236d
	rst 38h			;236e
	rst 38h			;236f
	rst 38h			;2370
	rst 38h			;2371
	rst 38h			;2372
	rst 38h			;2373
	rst 38h			;2374
	rst 38h			;2375
	rst 38h			;2376
	rst 38h			;2377
	rst 38h			;2378
	rst 38h			;2379
	rst 38h			;237a
	rst 38h			;237b
	rst 38h			;237c
	rst 38h			;237d
	rst 38h			;237e
	rst 38h			;237f
	rst 38h			;2380
	rst 38h			;2381
	rst 38h			;2382
	rst 38h			;2383
	rst 38h			;2384
	rst 38h			;2385
	rst 38h			;2386
	rst 38h			;2387
	rst 38h			;2388
	rst 38h			;2389
	rst 38h			;238a
	rst 38h			;238b
	rst 38h			;238c
	rst 38h			;238d
	rst 38h			;238e
	rst 38h			;238f
	rst 38h			;2390
	rst 38h			;2391
	rst 38h			;2392
	rst 38h			;2393
	rst 38h			;2394
	rst 38h			;2395
	rst 38h			;2396
	rst 38h			;2397
	rst 38h			;2398
	rst 38h			;2399
	rst 38h			;239a
	rst 38h			;239b
	rst 38h			;239c
	rst 38h			;239d
	rst 38h			;239e
	rst 38h			;239f
	rst 38h			;23a0
	rst 38h			;23a1
	rst 38h			;23a2
	rst 38h			;23a3
	rst 38h			;23a4
	rst 38h			;23a5
	rst 38h			;23a6
	rst 38h			;23a7
	rst 38h			;23a8
	rst 38h			;23a9
	rst 38h			;23aa
	rst 38h			;23ab
	rst 38h			;23ac
	rst 38h			;23ad
	rst 38h			;23ae
	rst 38h			;23af
	rst 38h			;23b0
	rst 38h			;23b1
	rst 38h			;23b2
	rst 38h			;23b3
	rst 38h			;23b4
	rst 38h			;23b5
	rst 38h			;23b6
	rst 38h			;23b7
	rst 38h			;23b8
	rst 38h			;23b9
	rst 38h			;23ba
	rst 38h			;23bb
	rst 38h			;23bc
	rst 38h			;23bd
	rst 38h			;23be
	rst 38h			;23bf
	rst 38h			;23c0
	rst 38h			;23c1
	rst 38h			;23c2
	rst 38h			;23c3
	rst 38h			;23c4
	rst 38h			;23c5
	rst 38h			;23c6
	rst 38h			;23c7
	rst 38h			;23c8
	rst 38h			;23c9
	rst 38h			;23ca
	rst 38h			;23cb
	rst 38h			;23cc
	rst 38h			;23cd
	rst 38h			;23ce
	rst 38h			;23cf
	rst 38h			;23d0
	rst 38h			;23d1
	rst 38h			;23d2
	rst 38h			;23d3
	rst 38h			;23d4
	rst 38h			;23d5
	rst 38h			;23d6
	rst 38h			;23d7
	rst 38h			;23d8
	rst 38h			;23d9
	rst 38h			;23da
	rst 38h			;23db
	rst 38h			;23dc
	rst 38h			;23dd
	rst 38h			;23de
	rst 38h			;23df
	rst 38h			;23e0
	rst 38h			;23e1
	rst 38h			;23e2
	rst 38h			;23e3
	rst 38h			;23e4
	rst 38h			;23e5
	rst 38h			;23e6
	rst 38h			;23e7
	rst 38h			;23e8
	rst 38h			;23e9
	rst 38h			;23ea
	rst 38h			;23eb
	rst 38h			;23ec
	rst 38h			;23ed
	rst 38h			;23ee
	rst 38h			;23ef
	rst 38h			;23f0
	rst 38h			;23f1
	rst 38h			;23f2
	rst 38h			;23f3
	rst 38h			;23f4
	rst 38h			;23f5
	rst 38h			;23f6
	rst 38h			;23f7
	rst 38h			;23f8
	rst 38h			;23f9
	rst 38h			;23fa
	rst 38h			;23fb
	rst 38h			;23fc
	rst 38h			;23fd
	rst 38h			;23fe
	rst 38h			;23ff
	rst 38h			;2400
	rst 38h			;2401
	rst 38h			;2402
	rst 38h			;2403
	rst 38h			;2404
	rst 38h			;2405
	rst 38h			;2406
	rst 38h			;2407
	rst 38h			;2408
	rst 38h			;2409
	rst 38h			;240a
	rst 38h			;240b
	rst 38h			;240c
	rst 38h			;240d
	rst 38h			;240e
	rst 38h			;240f
	rst 38h			;2410
	rst 38h			;2411
	rst 38h			;2412
	rst 38h			;2413
	rst 38h			;2414
	rst 38h			;2415
	rst 38h			;2416
	rst 38h			;2417
	rst 38h			;2418
	rst 38h			;2419
	rst 38h			;241a
	rst 38h			;241b
	rst 38h			;241c
	rst 38h			;241d
	rst 38h			;241e
	rst 38h			;241f
	rst 38h			;2420
	rst 38h			;2421
	rst 38h			;2422
	rst 38h			;2423
	rst 38h			;2424
	rst 38h			;2425
	rst 38h			;2426
	rst 38h			;2427
	rst 38h			;2428
	rst 38h			;2429
	rst 38h			;242a
	rst 38h			;242b
	rst 38h			;242c
	rst 38h			;242d
	rst 38h			;242e
	rst 38h			;242f
	rst 38h			;2430
	rst 38h			;2431
	rst 38h			;2432
	rst 38h			;2433
	rst 38h			;2434
	rst 38h			;2435
	rst 38h			;2436
	rst 38h			;2437
	rst 38h			;2438
	rst 38h			;2439
	rst 38h			;243a
	rst 38h			;243b
	rst 38h			;243c
	rst 38h			;243d
	rst 38h			;243e
	rst 38h			;243f
	rst 38h			;2440
	rst 38h			;2441
	rst 38h			;2442
	rst 38h			;2443
	rst 38h			;2444
	rst 38h			;2445
	rst 38h			;2446
	rst 38h			;2447
	rst 38h			;2448
	rst 38h			;2449
	rst 38h			;244a
	rst 38h			;244b
	rst 38h			;244c
	rst 38h			;244d
	rst 38h			;244e
	rst 38h			;244f
	rst 38h			;2450
	rst 38h			;2451
	rst 38h			;2452
	rst 38h			;2453
	rst 38h			;2454
	rst 38h			;2455
	rst 38h			;2456
	rst 38h			;2457
	rst 38h			;2458
	rst 38h			;2459
	rst 38h			;245a
	rst 38h			;245b
	rst 38h			;245c
	rst 38h			;245d
	rst 38h			;245e
	rst 38h			;245f
	rst 38h			;2460
	rst 38h			;2461
	rst 38h			;2462
	rst 38h			;2463
	rst 38h			;2464
	rst 38h			;2465
	rst 38h			;2466
	rst 38h			;2467
	rst 38h			;2468
	rst 38h			;2469
	rst 38h			;246a
	rst 38h			;246b
	rst 38h			;246c
	rst 38h			;246d
	rst 38h			;246e
	rst 38h			;246f
	rst 38h			;2470
	rst 38h			;2471
	rst 38h			;2472
	rst 38h			;2473
	rst 38h			;2474
	rst 38h			;2475
	rst 38h			;2476
	rst 38h			;2477
	rst 38h			;2478
	rst 38h			;2479
	rst 38h			;247a
	rst 38h			;247b
	rst 38h			;247c
	rst 38h			;247d
	rst 38h			;247e
	rst 38h			;247f
	rst 38h			;2480
	rst 38h			;2481
	rst 38h			;2482
	rst 38h			;2483
	rst 38h			;2484
	rst 38h			;2485
	rst 38h			;2486
	rst 38h			;2487
	rst 38h			;2488
	rst 38h			;2489
	rst 38h			;248a
	rst 38h			;248b
	rst 38h			;248c
	rst 38h			;248d
	rst 38h			;248e
	rst 38h			;248f
	rst 38h			;2490
	rst 38h			;2491
	rst 38h			;2492
	rst 38h			;2493
	rst 38h			;2494
	rst 38h			;2495
	rst 38h			;2496
	rst 38h			;2497
	rst 38h			;2498
	rst 38h			;2499
	rst 38h			;249a
	rst 38h			;249b
	rst 38h			;249c
	rst 38h			;249d
	rst 38h			;249e
	rst 38h			;249f
	rst 38h			;24a0
	rst 38h			;24a1
	rst 38h			;24a2
	rst 38h			;24a3
	rst 38h			;24a4
	rst 38h			;24a5
	rst 38h			;24a6
	rst 38h			;24a7
	rst 38h			;24a8
	rst 38h			;24a9
	rst 38h			;24aa
	rst 38h			;24ab
	rst 38h			;24ac
	rst 38h			;24ad
	rst 38h			;24ae
	rst 38h			;24af
	rst 38h			;24b0
	rst 38h			;24b1
	rst 38h			;24b2
	rst 38h			;24b3
	rst 38h			;24b4
	rst 38h			;24b5
	rst 38h			;24b6
	rst 38h			;24b7
	rst 38h			;24b8
	rst 38h			;24b9
	rst 38h			;24ba
	rst 38h			;24bb
	rst 38h			;24bc
	rst 38h			;24bd
	rst 38h			;24be
	rst 38h			;24bf
	rst 38h			;24c0
	rst 38h			;24c1
	rst 38h			;24c2
	rst 38h			;24c3
	rst 38h			;24c4
	rst 38h			;24c5
	rst 38h			;24c6
l24c7h:
	rst 38h			;24c7
	rst 38h			;24c8
	rst 38h			;24c9
	rst 38h			;24ca
	rst 38h			;24cb
	rst 38h			;24cc
	rst 38h			;24cd
	rst 38h			;24ce
	rst 38h			;24cf
	rst 38h			;24d0
	rst 38h			;24d1
	rst 38h			;24d2
	rst 38h			;24d3
	rst 38h			;24d4
	rst 38h			;24d5
	rst 38h			;24d6
	rst 38h			;24d7
	rst 38h			;24d8
	rst 38h			;24d9
	rst 38h			;24da
	rst 38h			;24db
	rst 38h			;24dc
	rst 38h			;24dd
	rst 38h			;24de
	rst 38h			;24df
	rst 38h			;24e0
	rst 38h			;24e1
	rst 38h			;24e2
	rst 38h			;24e3
	rst 38h			;24e4
	rst 38h			;24e5
	rst 38h			;24e6
	rst 38h			;24e7
	rst 38h			;24e8
	rst 38h			;24e9
	rst 38h			;24ea
	rst 38h			;24eb
	rst 38h			;24ec
	rst 38h			;24ed
	rst 38h			;24ee
	rst 38h			;24ef
	rst 38h			;24f0
	rst 38h			;24f1
	rst 38h			;24f2
	rst 38h			;24f3
	rst 38h			;24f4
	rst 38h			;24f5
	rst 38h			;24f6
	rst 38h			;24f7
	rst 38h			;24f8
	rst 38h			;24f9
	rst 38h			;24fa
	rst 38h			;24fb
	rst 38h			;24fc
	rst 38h			;24fd
	rst 38h			;24fe
	rst 38h			;24ff
	rst 38h			;2500
	rst 38h			;2501
	rst 38h			;2502
	rst 38h			;2503
	rst 38h			;2504
	rst 38h			;2505
	rst 38h			;2506
	rst 38h			;2507
	rst 38h			;2508
	rst 38h			;2509
	rst 38h			;250a
	rst 38h			;250b
	rst 38h			;250c
	rst 38h			;250d
	rst 38h			;250e
	rst 38h			;250f
	rst 38h			;2510
	rst 38h			;2511
	rst 38h			;2512
	rst 38h			;2513
	rst 38h			;2514
	rst 38h			;2515
	rst 38h			;2516
	rst 38h			;2517
	rst 38h			;2518
	rst 38h			;2519
	rst 38h			;251a
	rst 38h			;251b
	rst 38h			;251c
	rst 38h			;251d
	rst 38h			;251e
	rst 38h			;251f
	rst 38h			;2520
	rst 38h			;2521
	rst 38h			;2522
	rst 38h			;2523
	rst 38h			;2524
	rst 38h			;2525
	rst 38h			;2526
	rst 38h			;2527
	rst 38h			;2528
	rst 38h			;2529
	rst 38h			;252a
	rst 38h			;252b
	rst 38h			;252c
	rst 38h			;252d
	rst 38h			;252e
	rst 38h			;252f
	rst 38h			;2530
	rst 38h			;2531
	rst 38h			;2532
	rst 38h			;2533
	rst 38h			;2534
	rst 38h			;2535
	rst 38h			;2536
	rst 38h			;2537
	rst 38h			;2538
	rst 38h			;2539
	rst 38h			;253a
	rst 38h			;253b
	rst 38h			;253c
	rst 38h			;253d
	rst 38h			;253e
	rst 38h			;253f
	rst 38h			;2540
	rst 38h			;2541
	rst 38h			;2542
	rst 38h			;2543
	rst 38h			;2544
	rst 38h			;2545
	rst 38h			;2546
	rst 38h			;2547
	rst 38h			;2548
	rst 38h			;2549
	rst 38h			;254a
	rst 38h			;254b
	rst 38h			;254c
	rst 38h			;254d
	rst 38h			;254e
l254fh:
	rst 38h			;254f
	rst 38h			;2550
	rst 38h			;2551
	rst 38h			;2552
	rst 38h			;2553
	rst 38h			;2554
	rst 38h			;2555
	rst 38h			;2556
	rst 38h			;2557
l2558h:
	rst 38h			;2558
	rst 38h			;2559
	rst 38h			;255a
	rst 38h			;255b
	rst 38h			;255c
	rst 38h			;255d
	rst 38h			;255e
	rst 38h			;255f
	rst 38h			;2560
	rst 38h			;2561
	rst 38h			;2562
	rst 38h			;2563
	rst 38h			;2564
	rst 38h			;2565
	rst 38h			;2566
	rst 38h			;2567
	rst 38h			;2568
sub_2569h:
	rst 38h			;2569
	rst 38h			;256a
	rst 38h			;256b
	rst 38h			;256c
	rst 38h			;256d
	rst 38h			;256e
	rst 38h			;256f
	rst 38h			;2570
	rst 38h			;2571
	rst 38h			;2572
	rst 38h			;2573
	rst 38h			;2574
	rst 38h			;2575
	rst 38h			;2576
	rst 38h			;2577
	rst 38h			;2578
	rst 38h			;2579
	rst 38h			;257a
	rst 38h			;257b
	rst 38h			;257c
	rst 38h			;257d
	rst 38h			;257e
	rst 38h			;257f
	rst 38h			;2580
	rst 38h			;2581
	rst 38h			;2582
	rst 38h			;2583
	rst 38h			;2584
	rst 38h			;2585
	rst 38h			;2586
	rst 38h			;2587
	rst 38h			;2588
	rst 38h			;2589
	rst 38h			;258a
	rst 38h			;258b
	rst 38h			;258c
	rst 38h			;258d
	rst 38h			;258e
	rst 38h			;258f
	rst 38h			;2590
	rst 38h			;2591
	rst 38h			;2592
	rst 38h			;2593
	rst 38h			;2594
	rst 38h			;2595
	rst 38h			;2596
	rst 38h			;2597
	rst 38h			;2598
	rst 38h			;2599
	rst 38h			;259a
	rst 38h			;259b
	rst 38h			;259c
	rst 38h			;259d
	rst 38h			;259e
	rst 38h			;259f
	rst 38h			;25a0
	rst 38h			;25a1
	rst 38h			;25a2
	rst 38h			;25a3
	rst 38h			;25a4
	rst 38h			;25a5
	rst 38h			;25a6
	rst 38h			;25a7
	rst 38h			;25a8
	rst 38h			;25a9
	rst 38h			;25aa
	rst 38h			;25ab
	rst 38h			;25ac
	rst 38h			;25ad
	rst 38h			;25ae
	rst 38h			;25af
	rst 38h			;25b0
	rst 38h			;25b1
	rst 38h			;25b2
	rst 38h			;25b3
	rst 38h			;25b4
	rst 38h			;25b5
	rst 38h			;25b6
	rst 38h			;25b7
	rst 38h			;25b8
	rst 38h			;25b9
	rst 38h			;25ba
	rst 38h			;25bb
	rst 38h			;25bc
	rst 38h			;25bd
	rst 38h			;25be
	rst 38h			;25bf
	rst 38h			;25c0
	rst 38h			;25c1
	rst 38h			;25c2
	rst 38h			;25c3
	rst 38h			;25c4
	rst 38h			;25c5
	rst 38h			;25c6
	rst 38h			;25c7
	rst 38h			;25c8
	rst 38h			;25c9
	rst 38h			;25ca
	rst 38h			;25cb
	rst 38h			;25cc
	rst 38h			;25cd
	rst 38h			;25ce
	rst 38h			;25cf
	rst 38h			;25d0
	rst 38h			;25d1
	rst 38h			;25d2
	rst 38h			;25d3
	rst 38h			;25d4
	rst 38h			;25d5
	rst 38h			;25d6
	rst 38h			;25d7
	rst 38h			;25d8
	rst 38h			;25d9
	rst 38h			;25da
	rst 38h			;25db
	rst 38h			;25dc
	rst 38h			;25dd
	rst 38h			;25de
	rst 38h			;25df
	rst 38h			;25e0
	rst 38h			;25e1
	rst 38h			;25e2
	rst 38h			;25e3
	rst 38h			;25e4
	rst 38h			;25e5
	rst 38h			;25e6
	rst 38h			;25e7
	rst 38h			;25e8
	rst 38h			;25e9
	rst 38h			;25ea
	rst 38h			;25eb
	rst 38h			;25ec
	rst 38h			;25ed
	rst 38h			;25ee
	rst 38h			;25ef
	rst 38h			;25f0
	rst 38h			;25f1
	rst 38h			;25f2
	rst 38h			;25f3
	rst 38h			;25f4
	rst 38h			;25f5
	rst 38h			;25f6
	rst 38h			;25f7
	rst 38h			;25f8
	rst 38h			;25f9
	rst 38h			;25fa
	rst 38h			;25fb
	rst 38h			;25fc
	rst 38h			;25fd
	rst 38h			;25fe
	rst 38h			;25ff
	rst 38h			;2600
	rst 38h			;2601
	rst 38h			;2602
	rst 38h			;2603
	rst 38h			;2604
	rst 38h			;2605
	rst 38h			;2606
	rst 38h			;2607
	rst 38h			;2608
	rst 38h			;2609
	rst 38h			;260a
	rst 38h			;260b
	rst 38h			;260c
	rst 38h			;260d
	rst 38h			;260e
	rst 38h			;260f
	rst 38h			;2610
	rst 38h			;2611
	rst 38h			;2612
	rst 38h			;2613
	rst 38h			;2614
	rst 38h			;2615
	rst 38h			;2616
	rst 38h			;2617
	rst 38h			;2618
	rst 38h			;2619
	rst 38h			;261a
	rst 38h			;261b
	rst 38h			;261c
	rst 38h			;261d
	rst 38h			;261e
	rst 38h			;261f
	rst 38h			;2620
	rst 38h			;2621
	rst 38h			;2622
	rst 38h			;2623
	rst 38h			;2624
	rst 38h			;2625
	rst 38h			;2626
	rst 38h			;2627
	rst 38h			;2628
	rst 38h			;2629
	rst 38h			;262a
	rst 38h			;262b
	rst 38h			;262c
	rst 38h			;262d
	rst 38h			;262e
	rst 38h			;262f
	rst 38h			;2630
	rst 38h			;2631
	rst 38h			;2632
	rst 38h			;2633
	rst 38h			;2634
	rst 38h			;2635
	rst 38h			;2636
	rst 38h			;2637
	rst 38h			;2638
	rst 38h			;2639
	rst 38h			;263a
	rst 38h			;263b
	rst 38h			;263c
	rst 38h			;263d
	rst 38h			;263e
	rst 38h			;263f
	rst 38h			;2640
	rst 38h			;2641
	rst 38h			;2642
	rst 38h			;2643
	rst 38h			;2644
	rst 38h			;2645
	rst 38h			;2646
	rst 38h			;2647
	rst 38h			;2648
	rst 38h			;2649
	rst 38h			;264a
	rst 38h			;264b
	rst 38h			;264c
	rst 38h			;264d
	rst 38h			;264e
	rst 38h			;264f
	rst 38h			;2650
	rst 38h			;2651
	rst 38h			;2652
	rst 38h			;2653
	rst 38h			;2654
	rst 38h			;2655
	rst 38h			;2656
	rst 38h			;2657
	rst 38h			;2658
	rst 38h			;2659
	rst 38h			;265a
	rst 38h			;265b
	rst 38h			;265c
	rst 38h			;265d
	rst 38h			;265e
	rst 38h			;265f
	rst 38h			;2660
	rst 38h			;2661
	rst 38h			;2662
	rst 38h			;2663
	rst 38h			;2664
	rst 38h			;2665
	rst 38h			;2666
	rst 38h			;2667
	rst 38h			;2668
	rst 38h			;2669
	rst 38h			;266a
	rst 38h			;266b
	rst 38h			;266c
	rst 38h			;266d
	rst 38h			;266e
	rst 38h			;266f
	rst 38h			;2670
	rst 38h			;2671
	rst 38h			;2672
	rst 38h			;2673
	rst 38h			;2674
	rst 38h			;2675
	rst 38h			;2676
	rst 38h			;2677
	rst 38h			;2678
	rst 38h			;2679
	rst 38h			;267a
	rst 38h			;267b
	rst 38h			;267c
	rst 38h			;267d
	rst 38h			;267e
	rst 38h			;267f
	rst 38h			;2680
	rst 38h			;2681
	rst 38h			;2682
	rst 38h			;2683
	rst 38h			;2684
	rst 38h			;2685
	rst 38h			;2686
	rst 38h			;2687
	rst 38h			;2688
	rst 38h			;2689
	rst 38h			;268a
	rst 38h			;268b
	rst 38h			;268c
	rst 38h			;268d
	rst 38h			;268e
	rst 38h			;268f
	rst 38h			;2690
	rst 38h			;2691
	rst 38h			;2692
	rst 38h			;2693
	rst 38h			;2694
	rst 38h			;2695
	rst 38h			;2696
	rst 38h			;2697
	rst 38h			;2698
	rst 38h			;2699
	rst 38h			;269a
	rst 38h			;269b
	rst 38h			;269c
	rst 38h			;269d
	rst 38h			;269e
	rst 38h			;269f
	rst 38h			;26a0
	rst 38h			;26a1
	rst 38h			;26a2
	rst 38h			;26a3
	rst 38h			;26a4
	rst 38h			;26a5
	rst 38h			;26a6
	rst 38h			;26a7
	rst 38h			;26a8
	rst 38h			;26a9
	rst 38h			;26aa
	rst 38h			;26ab
	rst 38h			;26ac
	rst 38h			;26ad
	rst 38h			;26ae
	rst 38h			;26af
	rst 38h			;26b0
	rst 38h			;26b1
	rst 38h			;26b2
	rst 38h			;26b3
	rst 38h			;26b4
	rst 38h			;26b5
	rst 38h			;26b6
	rst 38h			;26b7
	rst 38h			;26b8
	rst 38h			;26b9
	rst 38h			;26ba
	rst 38h			;26bb
	rst 38h			;26bc
	rst 38h			;26bd
	rst 38h			;26be
	rst 38h			;26bf
	rst 38h			;26c0
	rst 38h			;26c1
	rst 38h			;26c2
	rst 38h			;26c3
	rst 38h			;26c4
	rst 38h			;26c5
	rst 38h			;26c6
	rst 38h			;26c7
	rst 38h			;26c8
	rst 38h			;26c9
	rst 38h			;26ca
	rst 38h			;26cb
	rst 38h			;26cc
	rst 38h			;26cd
	rst 38h			;26ce
	rst 38h			;26cf
	rst 38h			;26d0
	rst 38h			;26d1
	rst 38h			;26d2
	rst 38h			;26d3
	rst 38h			;26d4
	rst 38h			;26d5
	rst 38h			;26d6
	rst 38h			;26d7
	rst 38h			;26d8
	rst 38h			;26d9
	rst 38h			;26da
	rst 38h			;26db
	rst 38h			;26dc
	rst 38h			;26dd
	rst 38h			;26de
	rst 38h			;26df
	rst 38h			;26e0
	rst 38h			;26e1
	rst 38h			;26e2
	rst 38h			;26e3
	rst 38h			;26e4
	rst 38h			;26e5
	rst 38h			;26e6
	rst 38h			;26e7
	rst 38h			;26e8
	rst 38h			;26e9
	rst 38h			;26ea
	rst 38h			;26eb
	rst 38h			;26ec
	rst 38h			;26ed
	rst 38h			;26ee
	rst 38h			;26ef
	rst 38h			;26f0
	rst 38h			;26f1
	rst 38h			;26f2
	rst 38h			;26f3
	rst 38h			;26f4
	rst 38h			;26f5
	rst 38h			;26f6
	rst 38h			;26f7
	rst 38h			;26f8
	rst 38h			;26f9
	rst 38h			;26fa
	rst 38h			;26fb
	rst 38h			;26fc
	rst 38h			;26fd
	rst 38h			;26fe
	rst 38h			;26ff
	rst 38h			;2700
	rst 38h			;2701
	rst 38h			;2702
	rst 38h			;2703
	rst 38h			;2704
	rst 38h			;2705
	rst 38h			;2706
	rst 38h			;2707
	rst 38h			;2708
	rst 38h			;2709
	rst 38h			;270a
	rst 38h			;270b
	rst 38h			;270c
	rst 38h			;270d
	rst 38h			;270e
	rst 38h			;270f
	rst 38h			;2710
	rst 38h			;2711
	rst 38h			;2712
	rst 38h			;2713
	rst 38h			;2714
	rst 38h			;2715
	rst 38h			;2716
	rst 38h			;2717
	rst 38h			;2718
	rst 38h			;2719
	rst 38h			;271a
	rst 38h			;271b
	rst 38h			;271c
	rst 38h			;271d
	rst 38h			;271e
	rst 38h			;271f
	rst 38h			;2720
	rst 38h			;2721
	rst 38h			;2722
	rst 38h			;2723
	rst 38h			;2724
	rst 38h			;2725
	rst 38h			;2726
	rst 38h			;2727
	rst 38h			;2728
	rst 38h			;2729
	rst 38h			;272a
	rst 38h			;272b
	rst 38h			;272c
	rst 38h			;272d
	rst 38h			;272e
	rst 38h			;272f
	rst 38h			;2730
	rst 38h			;2731
	rst 38h			;2732
	rst 38h			;2733
	rst 38h			;2734
	rst 38h			;2735
	rst 38h			;2736
	rst 38h			;2737
	rst 38h			;2738
	rst 38h			;2739
	rst 38h			;273a
	rst 38h			;273b
	rst 38h			;273c
	rst 38h			;273d
	rst 38h			;273e
	rst 38h			;273f
	rst 38h			;2740
	rst 38h			;2741
	rst 38h			;2742
	rst 38h			;2743
	rst 38h			;2744
	rst 38h			;2745
	rst 38h			;2746
	rst 38h			;2747
	rst 38h			;2748
	rst 38h			;2749
	rst 38h			;274a
	rst 38h			;274b
	rst 38h			;274c
	rst 38h			;274d
	rst 38h			;274e
	rst 38h			;274f
	rst 38h			;2750
	rst 38h			;2751
	rst 38h			;2752
	rst 38h			;2753
	rst 38h			;2754
	rst 38h			;2755
	rst 38h			;2756
	rst 38h			;2757
	rst 38h			;2758
	rst 38h			;2759
	rst 38h			;275a
	rst 38h			;275b
	rst 38h			;275c
	rst 38h			;275d
	rst 38h			;275e
	rst 38h			;275f
	rst 38h			;2760
	rst 38h			;2761
	rst 38h			;2762
	rst 38h			;2763
	rst 38h			;2764
	rst 38h			;2765
	rst 38h			;2766
	rst 38h			;2767
	rst 38h			;2768
	rst 38h			;2769
	rst 38h			;276a
	rst 38h			;276b
	rst 38h			;276c
	rst 38h			;276d
	rst 38h			;276e
	rst 38h			;276f
	rst 38h			;2770
	rst 38h			;2771
	rst 38h			;2772
	rst 38h			;2773
	rst 38h			;2774
	rst 38h			;2775
	rst 38h			;2776
	rst 38h			;2777
	rst 38h			;2778
	rst 38h			;2779
	rst 38h			;277a
	rst 38h			;277b
	rst 38h			;277c
	rst 38h			;277d
	rst 38h			;277e
	rst 38h			;277f
	rst 38h			;2780
	rst 38h			;2781
	rst 38h			;2782
	rst 38h			;2783
	rst 38h			;2784
	rst 38h			;2785
	rst 38h			;2786
	rst 38h			;2787
	rst 38h			;2788
	rst 38h			;2789
	rst 38h			;278a
	rst 38h			;278b
	rst 38h			;278c
	rst 38h			;278d
	rst 38h			;278e
	rst 38h			;278f
	rst 38h			;2790
	rst 38h			;2791
	rst 38h			;2792
	rst 38h			;2793
	rst 38h			;2794
	rst 38h			;2795
	rst 38h			;2796
	rst 38h			;2797
	rst 38h			;2798
	rst 38h			;2799
	rst 38h			;279a
	rst 38h			;279b
	rst 38h			;279c
	rst 38h			;279d
	rst 38h			;279e
	rst 38h			;279f
	rst 38h			;27a0
	rst 38h			;27a1
	rst 38h			;27a2
	rst 38h			;27a3
	rst 38h			;27a4
	rst 38h			;27a5
	rst 38h			;27a6
	rst 38h			;27a7
	rst 38h			;27a8
	rst 38h			;27a9
	rst 38h			;27aa
	rst 38h			;27ab
	rst 38h			;27ac
	rst 38h			;27ad
	rst 38h			;27ae
	rst 38h			;27af
	rst 38h			;27b0
	rst 38h			;27b1
	rst 38h			;27b2
	rst 38h			;27b3
	rst 38h			;27b4
	rst 38h			;27b5
	rst 38h			;27b6
	rst 38h			;27b7
	rst 38h			;27b8
	rst 38h			;27b9
	rst 38h			;27ba
	rst 38h			;27bb
	rst 38h			;27bc
	rst 38h			;27bd
	rst 38h			;27be
	rst 38h			;27bf
	rst 38h			;27c0
	rst 38h			;27c1
	rst 38h			;27c2
	rst 38h			;27c3
	rst 38h			;27c4
	rst 38h			;27c5
	rst 38h			;27c6
	rst 38h			;27c7
	rst 38h			;27c8
	rst 38h			;27c9
	rst 38h			;27ca
	rst 38h			;27cb
	rst 38h			;27cc
	rst 38h			;27cd
	rst 38h			;27ce
	rst 38h			;27cf
	rst 38h			;27d0
	rst 38h			;27d1
	rst 38h			;27d2
	rst 38h			;27d3
	rst 38h			;27d4
	rst 38h			;27d5
	rst 38h			;27d6
	rst 38h			;27d7
	rst 38h			;27d8
	rst 38h			;27d9
	rst 38h			;27da
	rst 38h			;27db
	rst 38h			;27dc
	rst 38h			;27dd
	rst 38h			;27de
	rst 38h			;27df
	rst 38h			;27e0
	rst 38h			;27e1
	rst 38h			;27e2
	rst 38h			;27e3
	rst 38h			;27e4
	rst 38h			;27e5
	rst 38h			;27e6
	rst 38h			;27e7
	rst 38h			;27e8
	rst 38h			;27e9
	rst 38h			;27ea
	rst 38h			;27eb
	rst 38h			;27ec
	rst 38h			;27ed
	rst 38h			;27ee
	rst 38h			;27ef
	rst 38h			;27f0
	rst 38h			;27f1
	rst 38h			;27f2
	rst 38h			;27f3
	rst 38h			;27f4
	rst 38h			;27f5
	rst 38h			;27f6
	rst 38h			;27f7
	rst 38h			;27f8
	rst 38h			;27f9
	rst 38h			;27fa
	rst 38h			;27fb
	rst 38h			;27fc
	rst 38h			;27fd
	rst 38h			;27fe
	rst 38h			;27ff
	rst 38h			;2800
	rst 38h			;2801
	rst 38h			;2802
	rst 38h			;2803
	rst 38h			;2804
	rst 38h			;2805
	rst 38h			;2806
	rst 38h			;2807
	rst 38h			;2808
	rst 38h			;2809
	rst 38h			;280a
	rst 38h			;280b
	rst 38h			;280c
	rst 38h			;280d
	rst 38h			;280e
	rst 38h			;280f
	rst 38h			;2810
	rst 38h			;2811
	rst 38h			;2812
	rst 38h			;2813
	rst 38h			;2814
	rst 38h			;2815
	rst 38h			;2816
	rst 38h			;2817
	rst 38h			;2818
	rst 38h			;2819
	rst 38h			;281a
	rst 38h			;281b
	rst 38h			;281c
	rst 38h			;281d
	rst 38h			;281e
	rst 38h			;281f
	rst 38h			;2820
	rst 38h			;2821
	rst 38h			;2822
	rst 38h			;2823
	rst 38h			;2824
	rst 38h			;2825
	rst 38h			;2826
	rst 38h			;2827
	rst 38h			;2828
	rst 38h			;2829
	rst 38h			;282a
	rst 38h			;282b
	rst 38h			;282c
	rst 38h			;282d
	rst 38h			;282e
	rst 38h			;282f
	rst 38h			;2830
	rst 38h			;2831
	rst 38h			;2832
	rst 38h			;2833
	rst 38h			;2834
	rst 38h			;2835
	rst 38h			;2836
	rst 38h			;2837
	rst 38h			;2838
	rst 38h			;2839
	rst 38h			;283a
	rst 38h			;283b
	rst 38h			;283c
	rst 38h			;283d
	rst 38h			;283e
	rst 38h			;283f
	rst 38h			;2840
	rst 38h			;2841
	rst 38h			;2842
	rst 38h			;2843
	rst 38h			;2844
	rst 38h			;2845
	rst 38h			;2846
	rst 38h			;2847
	rst 38h			;2848
	rst 38h			;2849
	rst 38h			;284a
	rst 38h			;284b
	rst 38h			;284c
	rst 38h			;284d
	rst 38h			;284e
	rst 38h			;284f
	rst 38h			;2850
	rst 38h			;2851
	rst 38h			;2852
	rst 38h			;2853
	rst 38h			;2854
	rst 38h			;2855
	rst 38h			;2856
	rst 38h			;2857
	rst 38h			;2858
	rst 38h			;2859
	rst 38h			;285a
	rst 38h			;285b
	rst 38h			;285c
	rst 38h			;285d
	rst 38h			;285e
	rst 38h			;285f
	rst 38h			;2860
	rst 38h			;2861
	rst 38h			;2862
	rst 38h			;2863
	rst 38h			;2864
	rst 38h			;2865
	rst 38h			;2866
	rst 38h			;2867
	rst 38h			;2868
	rst 38h			;2869
	rst 38h			;286a
	rst 38h			;286b
	rst 38h			;286c
	rst 38h			;286d
	rst 38h			;286e
	rst 38h			;286f
	rst 38h			;2870
	rst 38h			;2871
	rst 38h			;2872
	rst 38h			;2873
	rst 38h			;2874
	rst 38h			;2875
	rst 38h			;2876
	rst 38h			;2877
	rst 38h			;2878
	rst 38h			;2879
	rst 38h			;287a
	rst 38h			;287b
	rst 38h			;287c
	rst 38h			;287d
	rst 38h			;287e
	rst 38h			;287f
	rst 38h			;2880
	rst 38h			;2881
	rst 38h			;2882
	rst 38h			;2883
	rst 38h			;2884
	rst 38h			;2885
	rst 38h			;2886
	rst 38h			;2887
	rst 38h			;2888
	rst 38h			;2889
	rst 38h			;288a
	rst 38h			;288b
	rst 38h			;288c
	rst 38h			;288d
	rst 38h			;288e
	rst 38h			;288f
	rst 38h			;2890
	rst 38h			;2891
	rst 38h			;2892
	rst 38h			;2893
	rst 38h			;2894
	rst 38h			;2895
	rst 38h			;2896
	rst 38h			;2897
	rst 38h			;2898
	rst 38h			;2899
	rst 38h			;289a
	rst 38h			;289b
	rst 38h			;289c
	rst 38h			;289d
	rst 38h			;289e
	rst 38h			;289f
	rst 38h			;28a0
	rst 38h			;28a1
	rst 38h			;28a2
	rst 38h			;28a3
	rst 38h			;28a4
	rst 38h			;28a5
	rst 38h			;28a6
	rst 38h			;28a7
	rst 38h			;28a8
	rst 38h			;28a9
	rst 38h			;28aa
	rst 38h			;28ab
	rst 38h			;28ac
	rst 38h			;28ad
	rst 38h			;28ae
	rst 38h			;28af
	rst 38h			;28b0
	rst 38h			;28b1
	rst 38h			;28b2
	rst 38h			;28b3
	rst 38h			;28b4
	rst 38h			;28b5
	rst 38h			;28b6
	rst 38h			;28b7
	rst 38h			;28b8
	rst 38h			;28b9
	rst 38h			;28ba
	rst 38h			;28bb
	rst 38h			;28bc
	rst 38h			;28bd
	rst 38h			;28be
	rst 38h			;28bf
	rst 38h			;28c0
	rst 38h			;28c1
	rst 38h			;28c2
	rst 38h			;28c3
	rst 38h			;28c4
	rst 38h			;28c5
	rst 38h			;28c6
	rst 38h			;28c7
	rst 38h			;28c8
	rst 38h			;28c9
	rst 38h			;28ca
	rst 38h			;28cb
	rst 38h			;28cc
	rst 38h			;28cd
	rst 38h			;28ce
	rst 38h			;28cf
	rst 38h			;28d0
	rst 38h			;28d1
	rst 38h			;28d2
	rst 38h			;28d3
	rst 38h			;28d4
	rst 38h			;28d5
	rst 38h			;28d6
	rst 38h			;28d7
	rst 38h			;28d8
	rst 38h			;28d9
	rst 38h			;28da
	rst 38h			;28db
	rst 38h			;28dc
	rst 38h			;28dd
	rst 38h			;28de
	rst 38h			;28df
	rst 38h			;28e0
	rst 38h			;28e1
	rst 38h			;28e2
	rst 38h			;28e3
	rst 38h			;28e4
	rst 38h			;28e5
	rst 38h			;28e6
	rst 38h			;28e7
	rst 38h			;28e8
	rst 38h			;28e9
	rst 38h			;28ea
	rst 38h			;28eb
	rst 38h			;28ec
	rst 38h			;28ed
	rst 38h			;28ee
	rst 38h			;28ef
	rst 38h			;28f0
	rst 38h			;28f1
	rst 38h			;28f2
	rst 38h			;28f3
	rst 38h			;28f4
	rst 38h			;28f5
	rst 38h			;28f6
	rst 38h			;28f7
	rst 38h			;28f8
	rst 38h			;28f9
	rst 38h			;28fa
	rst 38h			;28fb
	rst 38h			;28fc
	rst 38h			;28fd
	rst 38h			;28fe
	rst 38h			;28ff
	rst 38h			;2900
	rst 38h			;2901
	rst 38h			;2902
	rst 38h			;2903
	rst 38h			;2904
	rst 38h			;2905
	rst 38h			;2906
	rst 38h			;2907
	rst 38h			;2908
	rst 38h			;2909
	rst 38h			;290a
	rst 38h			;290b
	rst 38h			;290c
	rst 38h			;290d
	rst 38h			;290e
	rst 38h			;290f
	rst 38h			;2910
	rst 38h			;2911
	rst 38h			;2912
	rst 38h			;2913
	rst 38h			;2914
	rst 38h			;2915
	rst 38h			;2916
	rst 38h			;2917
	rst 38h			;2918
	rst 38h			;2919
	rst 38h			;291a
	rst 38h			;291b
	rst 38h			;291c
	rst 38h			;291d
	rst 38h			;291e
	rst 38h			;291f
	rst 38h			;2920
	rst 38h			;2921
	rst 38h			;2922
	rst 38h			;2923
	rst 38h			;2924
	rst 38h			;2925
	rst 38h			;2926
	rst 38h			;2927
	rst 38h			;2928
	rst 38h			;2929
	rst 38h			;292a
	rst 38h			;292b
	rst 38h			;292c
	rst 38h			;292d
	rst 38h			;292e
	rst 38h			;292f
	rst 38h			;2930
	rst 38h			;2931
	rst 38h			;2932
	rst 38h			;2933
	rst 38h			;2934
	rst 38h			;2935
	rst 38h			;2936
	rst 38h			;2937
	rst 38h			;2938
	rst 38h			;2939
	rst 38h			;293a
	rst 38h			;293b
	rst 38h			;293c
	rst 38h			;293d
	rst 38h			;293e
	rst 38h			;293f
	rst 38h			;2940
	rst 38h			;2941
	rst 38h			;2942
	rst 38h			;2943
	rst 38h			;2944
	rst 38h			;2945
	rst 38h			;2946
	rst 38h			;2947
	rst 38h			;2948
	rst 38h			;2949
	rst 38h			;294a
	rst 38h			;294b
	rst 38h			;294c
	rst 38h			;294d
	rst 38h			;294e
	rst 38h			;294f
	rst 38h			;2950
	rst 38h			;2951
	rst 38h			;2952
	rst 38h			;2953
	rst 38h			;2954
	rst 38h			;2955
	rst 38h			;2956
	rst 38h			;2957
	rst 38h			;2958
	rst 38h			;2959
	rst 38h			;295a
	rst 38h			;295b
	rst 38h			;295c
	rst 38h			;295d
	rst 38h			;295e
	rst 38h			;295f
	rst 38h			;2960
	rst 38h			;2961
	rst 38h			;2962
	rst 38h			;2963
	rst 38h			;2964
	rst 38h			;2965
	rst 38h			;2966
	rst 38h			;2967
	rst 38h			;2968
	rst 38h			;2969
	rst 38h			;296a
	rst 38h			;296b
	rst 38h			;296c
	rst 38h			;296d
	rst 38h			;296e
	rst 38h			;296f
	rst 38h			;2970
	rst 38h			;2971
	rst 38h			;2972
	rst 38h			;2973
	rst 38h			;2974
	rst 38h			;2975
	rst 38h			;2976
	rst 38h			;2977
	rst 38h			;2978
	rst 38h			;2979
	rst 38h			;297a
	rst 38h			;297b
	rst 38h			;297c
	rst 38h			;297d
	rst 38h			;297e
	rst 38h			;297f
	rst 38h			;2980
	rst 38h			;2981
	rst 38h			;2982
	rst 38h			;2983
	rst 38h			;2984
	rst 38h			;2985
	rst 38h			;2986
	rst 38h			;2987
	rst 38h			;2988
	rst 38h			;2989
	rst 38h			;298a
	rst 38h			;298b
	rst 38h			;298c
	rst 38h			;298d
	rst 38h			;298e
	rst 38h			;298f
	rst 38h			;2990
	rst 38h			;2991
	rst 38h			;2992
	rst 38h			;2993
	rst 38h			;2994
	rst 38h			;2995
	rst 38h			;2996
	rst 38h			;2997
	rst 38h			;2998
	rst 38h			;2999
	rst 38h			;299a
	rst 38h			;299b
	rst 38h			;299c
	rst 38h			;299d
	rst 38h			;299e
	rst 38h			;299f
	rst 38h			;29a0
	rst 38h			;29a1
	rst 38h			;29a2
	rst 38h			;29a3
	rst 38h			;29a4
	rst 38h			;29a5
	rst 38h			;29a6
	rst 38h			;29a7
	rst 38h			;29a8
	rst 38h			;29a9
	rst 38h			;29aa
	rst 38h			;29ab
	rst 38h			;29ac
	rst 38h			;29ad
	rst 38h			;29ae
	rst 38h			;29af
	rst 38h			;29b0
	rst 38h			;29b1
	rst 38h			;29b2
	rst 38h			;29b3
	rst 38h			;29b4
	rst 38h			;29b5
	rst 38h			;29b6
	rst 38h			;29b7
	rst 38h			;29b8
	rst 38h			;29b9
	rst 38h			;29ba
	rst 38h			;29bb
	rst 38h			;29bc
	rst 38h			;29bd
	rst 38h			;29be
	rst 38h			;29bf
	rst 38h			;29c0
	rst 38h			;29c1
	rst 38h			;29c2
	rst 38h			;29c3
	rst 38h			;29c4
	rst 38h			;29c5
	rst 38h			;29c6
	rst 38h			;29c7
	rst 38h			;29c8
	rst 38h			;29c9
	rst 38h			;29ca
	rst 38h			;29cb
	rst 38h			;29cc
	rst 38h			;29cd
	rst 38h			;29ce
	rst 38h			;29cf
	rst 38h			;29d0
	rst 38h			;29d1
	rst 38h			;29d2
	rst 38h			;29d3
	rst 38h			;29d4
	rst 38h			;29d5
	rst 38h			;29d6
	rst 38h			;29d7
	rst 38h			;29d8
	rst 38h			;29d9
	rst 38h			;29da
	rst 38h			;29db
	rst 38h			;29dc
	rst 38h			;29dd
	rst 38h			;29de
	rst 38h			;29df
	rst 38h			;29e0
	rst 38h			;29e1
	rst 38h			;29e2
	rst 38h			;29e3
	rst 38h			;29e4
	rst 38h			;29e5
	rst 38h			;29e6
	rst 38h			;29e7
	rst 38h			;29e8
	rst 38h			;29e9
	rst 38h			;29ea
	rst 38h			;29eb
	rst 38h			;29ec
	rst 38h			;29ed
	rst 38h			;29ee
	rst 38h			;29ef
	rst 38h			;29f0
	rst 38h			;29f1
	rst 38h			;29f2
	rst 38h			;29f3
	rst 38h			;29f4
	rst 38h			;29f5
	rst 38h			;29f6
	rst 38h			;29f7
	rst 38h			;29f8
	rst 38h			;29f9
	rst 38h			;29fa
	rst 38h			;29fb
	rst 38h			;29fc
	rst 38h			;29fd
	rst 38h			;29fe
	rst 38h			;29ff
	rst 38h			;2a00
	rst 38h			;2a01
	rst 38h			;2a02
	rst 38h			;2a03
	rst 38h			;2a04
	rst 38h			;2a05
	rst 38h			;2a06
	rst 38h			;2a07
	rst 38h			;2a08
	rst 38h			;2a09
	rst 38h			;2a0a
	rst 38h			;2a0b
	rst 38h			;2a0c
	rst 38h			;2a0d
	rst 38h			;2a0e
	rst 38h			;2a0f
	rst 38h			;2a10
	rst 38h			;2a11
	rst 38h			;2a12
	rst 38h			;2a13
	rst 38h			;2a14
	rst 38h			;2a15
	rst 38h			;2a16
	rst 38h			;2a17
	rst 38h			;2a18
	rst 38h			;2a19
	rst 38h			;2a1a
	rst 38h			;2a1b
	rst 38h			;2a1c
	rst 38h			;2a1d
	rst 38h			;2a1e
	rst 38h			;2a1f
	rst 38h			;2a20
	rst 38h			;2a21
	rst 38h			;2a22
	rst 38h			;2a23
	rst 38h			;2a24
	rst 38h			;2a25
	rst 38h			;2a26
	rst 38h			;2a27
	rst 38h			;2a28
	rst 38h			;2a29
	rst 38h			;2a2a
	rst 38h			;2a2b
	rst 38h			;2a2c
	rst 38h			;2a2d
	rst 38h			;2a2e
	rst 38h			;2a2f
	rst 38h			;2a30
	rst 38h			;2a31
	rst 38h			;2a32
	rst 38h			;2a33
	rst 38h			;2a34
	rst 38h			;2a35
	rst 38h			;2a36
	rst 38h			;2a37
	rst 38h			;2a38
	rst 38h			;2a39
	rst 38h			;2a3a
	rst 38h			;2a3b
	rst 38h			;2a3c
	rst 38h			;2a3d
	rst 38h			;2a3e
	rst 38h			;2a3f
	rst 38h			;2a40
	rst 38h			;2a41
	rst 38h			;2a42
	rst 38h			;2a43
	rst 38h			;2a44
	rst 38h			;2a45
	rst 38h			;2a46
	rst 38h			;2a47
	rst 38h			;2a48
	rst 38h			;2a49
	rst 38h			;2a4a
	rst 38h			;2a4b
	rst 38h			;2a4c
	rst 38h			;2a4d
	rst 38h			;2a4e
	rst 38h			;2a4f
	rst 38h			;2a50
	rst 38h			;2a51
	rst 38h			;2a52
	rst 38h			;2a53
	rst 38h			;2a54
	rst 38h			;2a55
	rst 38h			;2a56
	rst 38h			;2a57
	rst 38h			;2a58
	rst 38h			;2a59
	rst 38h			;2a5a
	rst 38h			;2a5b
	rst 38h			;2a5c
	rst 38h			;2a5d
	rst 38h			;2a5e
	rst 38h			;2a5f
	rst 38h			;2a60
	rst 38h			;2a61
	rst 38h			;2a62
	rst 38h			;2a63
	rst 38h			;2a64
	rst 38h			;2a65
	rst 38h			;2a66
	rst 38h			;2a67
	rst 38h			;2a68
	rst 38h			;2a69
	rst 38h			;2a6a
	rst 38h			;2a6b
	rst 38h			;2a6c
	rst 38h			;2a6d
	rst 38h			;2a6e
	rst 38h			;2a6f
	rst 38h			;2a70
	rst 38h			;2a71
	rst 38h			;2a72
	rst 38h			;2a73
	rst 38h			;2a74
	rst 38h			;2a75
	rst 38h			;2a76
	rst 38h			;2a77
	rst 38h			;2a78
	rst 38h			;2a79
	rst 38h			;2a7a
	rst 38h			;2a7b
	rst 38h			;2a7c
	rst 38h			;2a7d
	rst 38h			;2a7e
	rst 38h			;2a7f
	rst 38h			;2a80
	rst 38h			;2a81
	rst 38h			;2a82
	rst 38h			;2a83
	rst 38h			;2a84
	rst 38h			;2a85
	rst 38h			;2a86
	rst 38h			;2a87
	rst 38h			;2a88
	rst 38h			;2a89
	rst 38h			;2a8a
	rst 38h			;2a8b
	rst 38h			;2a8c
	rst 38h			;2a8d
	rst 38h			;2a8e
	rst 38h			;2a8f
	rst 38h			;2a90
	rst 38h			;2a91
	rst 38h			;2a92
	rst 38h			;2a93
	rst 38h			;2a94
	rst 38h			;2a95
	rst 38h			;2a96
	rst 38h			;2a97
	rst 38h			;2a98
	rst 38h			;2a99
	rst 38h			;2a9a
	rst 38h			;2a9b
	rst 38h			;2a9c
	rst 38h			;2a9d
	rst 38h			;2a9e
	rst 38h			;2a9f
	rst 38h			;2aa0
	rst 38h			;2aa1
	rst 38h			;2aa2
	rst 38h			;2aa3
	rst 38h			;2aa4
	rst 38h			;2aa5
	rst 38h			;2aa6
	rst 38h			;2aa7
	rst 38h			;2aa8
	rst 38h			;2aa9
	rst 38h			;2aaa
	rst 38h			;2aab
	rst 38h			;2aac
	rst 38h			;2aad
	rst 38h			;2aae
	rst 38h			;2aaf
	rst 38h			;2ab0
	rst 38h			;2ab1
	rst 38h			;2ab2
	rst 38h			;2ab3
	rst 38h			;2ab4
	rst 38h			;2ab5
	rst 38h			;2ab6
	rst 38h			;2ab7
	rst 38h			;2ab8
	rst 38h			;2ab9
	rst 38h			;2aba
	rst 38h			;2abb
	rst 38h			;2abc
	rst 38h			;2abd
	rst 38h			;2abe
	rst 38h			;2abf
	rst 38h			;2ac0
	rst 38h			;2ac1
	rst 38h			;2ac2
	rst 38h			;2ac3
	rst 38h			;2ac4
	rst 38h			;2ac5
	rst 38h			;2ac6
	rst 38h			;2ac7
	rst 38h			;2ac8
	rst 38h			;2ac9
	rst 38h			;2aca
	rst 38h			;2acb
	rst 38h			;2acc
	rst 38h			;2acd
	rst 38h			;2ace
	rst 38h			;2acf
	rst 38h			;2ad0
	rst 38h			;2ad1
	rst 38h			;2ad2
	rst 38h			;2ad3
	rst 38h			;2ad4
	rst 38h			;2ad5
	rst 38h			;2ad6
	rst 38h			;2ad7
	rst 38h			;2ad8
	rst 38h			;2ad9
	rst 38h			;2ada
	rst 38h			;2adb
	rst 38h			;2adc
	rst 38h			;2add
	rst 38h			;2ade
	rst 38h			;2adf
	rst 38h			;2ae0
	rst 38h			;2ae1
	rst 38h			;2ae2
	rst 38h			;2ae3
	rst 38h			;2ae4
	rst 38h			;2ae5
	rst 38h			;2ae6
	rst 38h			;2ae7
	rst 38h			;2ae8
	rst 38h			;2ae9
	rst 38h			;2aea
	rst 38h			;2aeb
	rst 38h			;2aec
	rst 38h			;2aed
	rst 38h			;2aee
	rst 38h			;2aef
	rst 38h			;2af0
	rst 38h			;2af1
	rst 38h			;2af2
	rst 38h			;2af3
	rst 38h			;2af4
	rst 38h			;2af5
	rst 38h			;2af6
	rst 38h			;2af7
	rst 38h			;2af8
	rst 38h			;2af9
	rst 38h			;2afa
	rst 38h			;2afb
	rst 38h			;2afc
	rst 38h			;2afd
	rst 38h			;2afe
	rst 38h			;2aff
	rst 38h			;2b00
	rst 38h			;2b01
	rst 38h			;2b02
	rst 38h			;2b03
	rst 38h			;2b04
	rst 38h			;2b05
	rst 38h			;2b06
	rst 38h			;2b07
	rst 38h			;2b08
	rst 38h			;2b09
	rst 38h			;2b0a
	rst 38h			;2b0b
	rst 38h			;2b0c
	rst 38h			;2b0d
	rst 38h			;2b0e
	rst 38h			;2b0f
	rst 38h			;2b10
	rst 38h			;2b11
	rst 38h			;2b12
	rst 38h			;2b13
	rst 38h			;2b14
	rst 38h			;2b15
	rst 38h			;2b16
	rst 38h			;2b17
	rst 38h			;2b18
	rst 38h			;2b19
	rst 38h			;2b1a
	rst 38h			;2b1b
	rst 38h			;2b1c
	rst 38h			;2b1d
	rst 38h			;2b1e
	rst 38h			;2b1f
	rst 38h			;2b20
	rst 38h			;2b21
	rst 38h			;2b22
	rst 38h			;2b23
	rst 38h			;2b24
	rst 38h			;2b25
	rst 38h			;2b26
	rst 38h			;2b27
	rst 38h			;2b28
	rst 38h			;2b29
	rst 38h			;2b2a
	rst 38h			;2b2b
	rst 38h			;2b2c
	rst 38h			;2b2d
	rst 38h			;2b2e
	rst 38h			;2b2f
	rst 38h			;2b30
	rst 38h			;2b31
	rst 38h			;2b32
	rst 38h			;2b33
	rst 38h			;2b34
	rst 38h			;2b35
	rst 38h			;2b36
	rst 38h			;2b37
	rst 38h			;2b38
	rst 38h			;2b39
	rst 38h			;2b3a
	rst 38h			;2b3b
	rst 38h			;2b3c
	rst 38h			;2b3d
	rst 38h			;2b3e
	rst 38h			;2b3f
	rst 38h			;2b40
	rst 38h			;2b41
	rst 38h			;2b42
	rst 38h			;2b43
	rst 38h			;2b44
	rst 38h			;2b45
	rst 38h			;2b46
	rst 38h			;2b47
	rst 38h			;2b48
	rst 38h			;2b49
	rst 38h			;2b4a
	rst 38h			;2b4b
	rst 38h			;2b4c
	rst 38h			;2b4d
	rst 38h			;2b4e
	rst 38h			;2b4f
	rst 38h			;2b50
	rst 38h			;2b51
	rst 38h			;2b52
	rst 38h			;2b53
	rst 38h			;2b54
	rst 38h			;2b55
	rst 38h			;2b56
	rst 38h			;2b57
	rst 38h			;2b58
	rst 38h			;2b59
	rst 38h			;2b5a
	rst 38h			;2b5b
	rst 38h			;2b5c
	rst 38h			;2b5d
	rst 38h			;2b5e
	rst 38h			;2b5f
	rst 38h			;2b60
	rst 38h			;2b61
	rst 38h			;2b62
	rst 38h			;2b63
	rst 38h			;2b64
	rst 38h			;2b65
	rst 38h			;2b66
	rst 38h			;2b67
	rst 38h			;2b68
	rst 38h			;2b69
	rst 38h			;2b6a
	rst 38h			;2b6b
	rst 38h			;2b6c
	rst 38h			;2b6d
	rst 38h			;2b6e
	rst 38h			;2b6f
	rst 38h			;2b70
	rst 38h			;2b71
	rst 38h			;2b72
	rst 38h			;2b73
	rst 38h			;2b74
	rst 38h			;2b75
	rst 38h			;2b76
	rst 38h			;2b77
	rst 38h			;2b78
	rst 38h			;2b79
	rst 38h			;2b7a
	rst 38h			;2b7b
	rst 38h			;2b7c
	rst 38h			;2b7d
	rst 38h			;2b7e
	rst 38h			;2b7f
	rst 38h			;2b80
	rst 38h			;2b81
	rst 38h			;2b82
	rst 38h			;2b83
	rst 38h			;2b84
	rst 38h			;2b85
	rst 38h			;2b86
	rst 38h			;2b87
	rst 38h			;2b88
	rst 38h			;2b89
	rst 38h			;2b8a
	rst 38h			;2b8b
	rst 38h			;2b8c
	rst 38h			;2b8d
	rst 38h			;2b8e
	rst 38h			;2b8f
	rst 38h			;2b90
	rst 38h			;2b91
	rst 38h			;2b92
	rst 38h			;2b93
	rst 38h			;2b94
	rst 38h			;2b95
	rst 38h			;2b96
	rst 38h			;2b97
	rst 38h			;2b98
	rst 38h			;2b99
	rst 38h			;2b9a
	rst 38h			;2b9b
	rst 38h			;2b9c
	rst 38h			;2b9d
	rst 38h			;2b9e
	rst 38h			;2b9f
	rst 38h			;2ba0
	rst 38h			;2ba1
	rst 38h			;2ba2
	rst 38h			;2ba3
	rst 38h			;2ba4
	rst 38h			;2ba5
	rst 38h			;2ba6
	rst 38h			;2ba7
	rst 38h			;2ba8
	rst 38h			;2ba9
	rst 38h			;2baa
	rst 38h			;2bab
	rst 38h			;2bac
	rst 38h			;2bad
	rst 38h			;2bae
	rst 38h			;2baf
	rst 38h			;2bb0
	rst 38h			;2bb1
	rst 38h			;2bb2
	rst 38h			;2bb3
	rst 38h			;2bb4
	rst 38h			;2bb5
	rst 38h			;2bb6
	rst 38h			;2bb7
	rst 38h			;2bb8
	rst 38h			;2bb9
	rst 38h			;2bba
	rst 38h			;2bbb
	rst 38h			;2bbc
	rst 38h			;2bbd
	rst 38h			;2bbe
	rst 38h			;2bbf
	rst 38h			;2bc0
	rst 38h			;2bc1
	rst 38h			;2bc2
	rst 38h			;2bc3
	rst 38h			;2bc4
	rst 38h			;2bc5
	rst 38h			;2bc6
	rst 38h			;2bc7
	rst 38h			;2bc8
	rst 38h			;2bc9
	rst 38h			;2bca
	rst 38h			;2bcb
	rst 38h			;2bcc
	rst 38h			;2bcd
	rst 38h			;2bce
	rst 38h			;2bcf
	rst 38h			;2bd0
	rst 38h			;2bd1
	rst 38h			;2bd2
	rst 38h			;2bd3
	rst 38h			;2bd4
	rst 38h			;2bd5
	rst 38h			;2bd6
	rst 38h			;2bd7
	rst 38h			;2bd8
	rst 38h			;2bd9
	rst 38h			;2bda
	rst 38h			;2bdb
	rst 38h			;2bdc
	rst 38h			;2bdd
	rst 38h			;2bde
	rst 38h			;2bdf
	rst 38h			;2be0
	rst 38h			;2be1
	rst 38h			;2be2
	rst 38h			;2be3
	rst 38h			;2be4
	rst 38h			;2be5
	rst 38h			;2be6
	rst 38h			;2be7
	rst 38h			;2be8
	rst 38h			;2be9
	rst 38h			;2bea
	rst 38h			;2beb
	rst 38h			;2bec
	rst 38h			;2bed
	rst 38h			;2bee
	rst 38h			;2bef
	rst 38h			;2bf0
	rst 38h			;2bf1
	rst 38h			;2bf2
	rst 38h			;2bf3
	rst 38h			;2bf4
	rst 38h			;2bf5
	rst 38h			;2bf6
	rst 38h			;2bf7
	rst 38h			;2bf8
	rst 38h			;2bf9
	rst 38h			;2bfa
	rst 38h			;2bfb
	rst 38h			;2bfc
	rst 38h			;2bfd
	rst 38h			;2bfe
	rst 38h			;2bff
	rst 38h			;2c00
	rst 38h			;2c01
	rst 38h			;2c02
	rst 38h			;2c03
	rst 38h			;2c04
	rst 38h			;2c05
	rst 38h			;2c06
	rst 38h			;2c07
	rst 38h			;2c08
	rst 38h			;2c09
	rst 38h			;2c0a
	rst 38h			;2c0b
	rst 38h			;2c0c
	rst 38h			;2c0d
	rst 38h			;2c0e
	rst 38h			;2c0f
	rst 38h			;2c10
	rst 38h			;2c11
	rst 38h			;2c12
	rst 38h			;2c13
	rst 38h			;2c14
	rst 38h			;2c15
	rst 38h			;2c16
	rst 38h			;2c17
	rst 38h			;2c18
	rst 38h			;2c19
	rst 38h			;2c1a
	rst 38h			;2c1b
	rst 38h			;2c1c
	rst 38h			;2c1d
	rst 38h			;2c1e
	rst 38h			;2c1f
	rst 38h			;2c20
	rst 38h			;2c21
	rst 38h			;2c22
	rst 38h			;2c23
	rst 38h			;2c24
	rst 38h			;2c25
	rst 38h			;2c26
	rst 38h			;2c27
	rst 38h			;2c28
	rst 38h			;2c29
	rst 38h			;2c2a
	rst 38h			;2c2b
	rst 38h			;2c2c
	rst 38h			;2c2d
	rst 38h			;2c2e
	rst 38h			;2c2f
	rst 38h			;2c30
	rst 38h			;2c31
	rst 38h			;2c32
	rst 38h			;2c33
	rst 38h			;2c34
	rst 38h			;2c35
	rst 38h			;2c36
	rst 38h			;2c37
	rst 38h			;2c38
	rst 38h			;2c39
	rst 38h			;2c3a
	rst 38h			;2c3b
	rst 38h			;2c3c
	rst 38h			;2c3d
	rst 38h			;2c3e
	rst 38h			;2c3f
	rst 38h			;2c40
	rst 38h			;2c41
	rst 38h			;2c42
	rst 38h			;2c43
	rst 38h			;2c44
	rst 38h			;2c45
	rst 38h			;2c46
	rst 38h			;2c47
	rst 38h			;2c48
	rst 38h			;2c49
	rst 38h			;2c4a
	rst 38h			;2c4b
	rst 38h			;2c4c
	rst 38h			;2c4d
	rst 38h			;2c4e
	rst 38h			;2c4f
	rst 38h			;2c50
	rst 38h			;2c51
	rst 38h			;2c52
	rst 38h			;2c53
	rst 38h			;2c54
	rst 38h			;2c55
	rst 38h			;2c56
	rst 38h			;2c57
	rst 38h			;2c58
	rst 38h			;2c59
	rst 38h			;2c5a
	rst 38h			;2c5b
	rst 38h			;2c5c
	rst 38h			;2c5d
	rst 38h			;2c5e
	rst 38h			;2c5f
	rst 38h			;2c60
	rst 38h			;2c61
	rst 38h			;2c62
	rst 38h			;2c63
	rst 38h			;2c64
	rst 38h			;2c65
	rst 38h			;2c66
	rst 38h			;2c67
	rst 38h			;2c68
	rst 38h			;2c69
	rst 38h			;2c6a
	rst 38h			;2c6b
	rst 38h			;2c6c
	rst 38h			;2c6d
	rst 38h			;2c6e
	rst 38h			;2c6f
l2c70h:
	rst 38h			;2c70
	rst 38h			;2c71
	rst 38h			;2c72
	rst 38h			;2c73
	rst 38h			;2c74
	rst 38h			;2c75
	rst 38h			;2c76
	rst 38h			;2c77
	rst 38h			;2c78
	rst 38h			;2c79
	rst 38h			;2c7a
	rst 38h			;2c7b
	rst 38h			;2c7c
	rst 38h			;2c7d
	rst 38h			;2c7e
	rst 38h			;2c7f
	rst 38h			;2c80
	rst 38h			;2c81
	rst 38h			;2c82
	rst 38h			;2c83
	rst 38h			;2c84
	rst 38h			;2c85
	rst 38h			;2c86
	rst 38h			;2c87
	rst 38h			;2c88
	rst 38h			;2c89
	rst 38h			;2c8a
	rst 38h			;2c8b
	rst 38h			;2c8c
	rst 38h			;2c8d
	rst 38h			;2c8e
	rst 38h			;2c8f
	rst 38h			;2c90
	rst 38h			;2c91
	rst 38h			;2c92
	rst 38h			;2c93
	rst 38h			;2c94
	rst 38h			;2c95
	rst 38h			;2c96
	rst 38h			;2c97
	rst 38h			;2c98
	rst 38h			;2c99
	rst 38h			;2c9a
	rst 38h			;2c9b
	rst 38h			;2c9c
	rst 38h			;2c9d
	rst 38h			;2c9e
	rst 38h			;2c9f
	rst 38h			;2ca0
	rst 38h			;2ca1
	rst 38h			;2ca2
	rst 38h			;2ca3
	rst 38h			;2ca4
	rst 38h			;2ca5
	rst 38h			;2ca6
	rst 38h			;2ca7
	rst 38h			;2ca8
	rst 38h			;2ca9
	rst 38h			;2caa
	rst 38h			;2cab
	rst 38h			;2cac
	rst 38h			;2cad
	rst 38h			;2cae
	rst 38h			;2caf
	rst 38h			;2cb0
	rst 38h			;2cb1
	rst 38h			;2cb2
	rst 38h			;2cb3
	rst 38h			;2cb4
	rst 38h			;2cb5
	rst 38h			;2cb6
	rst 38h			;2cb7
	rst 38h			;2cb8
	rst 38h			;2cb9
	rst 38h			;2cba
	rst 38h			;2cbb
	rst 38h			;2cbc
	rst 38h			;2cbd
	rst 38h			;2cbe
	rst 38h			;2cbf
	rst 38h			;2cc0
	rst 38h			;2cc1
	rst 38h			;2cc2
	rst 38h			;2cc3
	rst 38h			;2cc4
	rst 38h			;2cc5
	rst 38h			;2cc6
	rst 38h			;2cc7
	rst 38h			;2cc8
	rst 38h			;2cc9
	rst 38h			;2cca
	rst 38h			;2ccb
	rst 38h			;2ccc
	rst 38h			;2ccd
	rst 38h			;2cce
	rst 38h			;2ccf
	rst 38h			;2cd0
	rst 38h			;2cd1
	rst 38h			;2cd2
	rst 38h			;2cd3
	rst 38h			;2cd4
	rst 38h			;2cd5
	rst 38h			;2cd6
	rst 38h			;2cd7
	rst 38h			;2cd8
	rst 38h			;2cd9
	rst 38h			;2cda
	rst 38h			;2cdb
	rst 38h			;2cdc
	rst 38h			;2cdd
	rst 38h			;2cde
	rst 38h			;2cdf
	rst 38h			;2ce0
	rst 38h			;2ce1
	rst 38h			;2ce2
	rst 38h			;2ce3
	rst 38h			;2ce4
	rst 38h			;2ce5
	rst 38h			;2ce6
	rst 38h			;2ce7
	rst 38h			;2ce8
	rst 38h			;2ce9
	rst 38h			;2cea
	rst 38h			;2ceb
	rst 38h			;2cec
	rst 38h			;2ced
	rst 38h			;2cee
	rst 38h			;2cef
	rst 38h			;2cf0
	rst 38h			;2cf1
	rst 38h			;2cf2
	rst 38h			;2cf3
	rst 38h			;2cf4
	rst 38h			;2cf5
	rst 38h			;2cf6
	rst 38h			;2cf7
	rst 38h			;2cf8
	rst 38h			;2cf9
	rst 38h			;2cfa
	rst 38h			;2cfb
	rst 38h			;2cfc
	rst 38h			;2cfd
	rst 38h			;2cfe
	rst 38h			;2cff
	rst 38h			;2d00
	rst 38h			;2d01
	rst 38h			;2d02
	rst 38h			;2d03
	rst 38h			;2d04
	rst 38h			;2d05
	rst 38h			;2d06
	rst 38h			;2d07
	rst 38h			;2d08
	rst 38h			;2d09
	rst 38h			;2d0a
	rst 38h			;2d0b
	rst 38h			;2d0c
	rst 38h			;2d0d
	rst 38h			;2d0e
	rst 38h			;2d0f
	rst 38h			;2d10
	rst 38h			;2d11
	rst 38h			;2d12
	rst 38h			;2d13
	rst 38h			;2d14
	rst 38h			;2d15
	rst 38h			;2d16
	rst 38h			;2d17
	rst 38h			;2d18
	rst 38h			;2d19
	rst 38h			;2d1a
	rst 38h			;2d1b
	rst 38h			;2d1c
	rst 38h			;2d1d
	rst 38h			;2d1e
	rst 38h			;2d1f
	rst 38h			;2d20
	rst 38h			;2d21
	rst 38h			;2d22
	rst 38h			;2d23
	rst 38h			;2d24
	rst 38h			;2d25
	rst 38h			;2d26
	rst 38h			;2d27
	rst 38h			;2d28
	rst 38h			;2d29
	rst 38h			;2d2a
	rst 38h			;2d2b
	rst 38h			;2d2c
	rst 38h			;2d2d
	rst 38h			;2d2e
	rst 38h			;2d2f
	rst 38h			;2d30
	rst 38h			;2d31
	rst 38h			;2d32
	rst 38h			;2d33
	rst 38h			;2d34
	rst 38h			;2d35
	rst 38h			;2d36
	rst 38h			;2d37
	rst 38h			;2d38
	rst 38h			;2d39
	rst 38h			;2d3a
	rst 38h			;2d3b
	rst 38h			;2d3c
	rst 38h			;2d3d
	rst 38h			;2d3e
	rst 38h			;2d3f
	rst 38h			;2d40
	rst 38h			;2d41
	rst 38h			;2d42
	rst 38h			;2d43
	rst 38h			;2d44
	rst 38h			;2d45
	rst 38h			;2d46
	rst 38h			;2d47
	rst 38h			;2d48
	rst 38h			;2d49
	rst 38h			;2d4a
	rst 38h			;2d4b
	rst 38h			;2d4c
	rst 38h			;2d4d
	rst 38h			;2d4e
	rst 38h			;2d4f
	rst 38h			;2d50
	rst 38h			;2d51
	rst 38h			;2d52
	rst 38h			;2d53
	rst 38h			;2d54
	rst 38h			;2d55
	rst 38h			;2d56
	rst 38h			;2d57
	rst 38h			;2d58
	rst 38h			;2d59
	rst 38h			;2d5a
	rst 38h			;2d5b
	rst 38h			;2d5c
	rst 38h			;2d5d
	rst 38h			;2d5e
	rst 38h			;2d5f
	rst 38h			;2d60
	rst 38h			;2d61
	rst 38h			;2d62
	rst 38h			;2d63
	rst 38h			;2d64
	rst 38h			;2d65
	rst 38h			;2d66
	rst 38h			;2d67
	rst 38h			;2d68
	rst 38h			;2d69
	rst 38h			;2d6a
	rst 38h			;2d6b
	rst 38h			;2d6c
	rst 38h			;2d6d
	rst 38h			;2d6e
	rst 38h			;2d6f
	rst 38h			;2d70
	rst 38h			;2d71
	rst 38h			;2d72
	rst 38h			;2d73
	rst 38h			;2d74
	rst 38h			;2d75
	rst 38h			;2d76
	rst 38h			;2d77
	rst 38h			;2d78
	rst 38h			;2d79
	rst 38h			;2d7a
	rst 38h			;2d7b
	rst 38h			;2d7c
	rst 38h			;2d7d
	rst 38h			;2d7e
	rst 38h			;2d7f
	rst 38h			;2d80
	rst 38h			;2d81
	rst 38h			;2d82
	rst 38h			;2d83
	rst 38h			;2d84
	rst 38h			;2d85
	rst 38h			;2d86
	rst 38h			;2d87
	rst 38h			;2d88
	rst 38h			;2d89
	rst 38h			;2d8a
	rst 38h			;2d8b
	rst 38h			;2d8c
	rst 38h			;2d8d
	rst 38h			;2d8e
	rst 38h			;2d8f
	rst 38h			;2d90
	rst 38h			;2d91
	rst 38h			;2d92
	rst 38h			;2d93
	rst 38h			;2d94
	rst 38h			;2d95
	rst 38h			;2d96
	rst 38h			;2d97
	rst 38h			;2d98
	rst 38h			;2d99
	rst 38h			;2d9a
	rst 38h			;2d9b
	rst 38h			;2d9c
	rst 38h			;2d9d
	rst 38h			;2d9e
	rst 38h			;2d9f
	rst 38h			;2da0
	rst 38h			;2da1
	rst 38h			;2da2
	rst 38h			;2da3
	rst 38h			;2da4
	rst 38h			;2da5
	rst 38h			;2da6
	rst 38h			;2da7
	rst 38h			;2da8
	rst 38h			;2da9
	rst 38h			;2daa
	rst 38h			;2dab
	rst 38h			;2dac
	rst 38h			;2dad
	rst 38h			;2dae
	rst 38h			;2daf
	rst 38h			;2db0
	rst 38h			;2db1
	rst 38h			;2db2
	rst 38h			;2db3
	rst 38h			;2db4
	rst 38h			;2db5
	rst 38h			;2db6
	rst 38h			;2db7
	rst 38h			;2db8
	rst 38h			;2db9
	rst 38h			;2dba
	rst 38h			;2dbb
	rst 38h			;2dbc
	rst 38h			;2dbd
	rst 38h			;2dbe
	rst 38h			;2dbf
	rst 38h			;2dc0
	rst 38h			;2dc1
	rst 38h			;2dc2
	rst 38h			;2dc3
	rst 38h			;2dc4
	rst 38h			;2dc5
	rst 38h			;2dc6
	rst 38h			;2dc7
	rst 38h			;2dc8
	rst 38h			;2dc9
	rst 38h			;2dca
	rst 38h			;2dcb
	rst 38h			;2dcc
	rst 38h			;2dcd
	rst 38h			;2dce
	rst 38h			;2dcf
	rst 38h			;2dd0
	rst 38h			;2dd1
	rst 38h			;2dd2
	rst 38h			;2dd3
	rst 38h			;2dd4
	rst 38h			;2dd5
	rst 38h			;2dd6
	rst 38h			;2dd7
	rst 38h			;2dd8
	rst 38h			;2dd9
	rst 38h			;2dda
	rst 38h			;2ddb
	rst 38h			;2ddc
	rst 38h			;2ddd
	rst 38h			;2dde
	rst 38h			;2ddf
	rst 38h			;2de0
	rst 38h			;2de1
	rst 38h			;2de2
	rst 38h			;2de3
	rst 38h			;2de4
	rst 38h			;2de5
	rst 38h			;2de6
	rst 38h			;2de7
	rst 38h			;2de8
	rst 38h			;2de9
	rst 38h			;2dea
	rst 38h			;2deb
	rst 38h			;2dec
	rst 38h			;2ded
	rst 38h			;2dee
	rst 38h			;2def
	rst 38h			;2df0
	rst 38h			;2df1
	rst 38h			;2df2
	rst 38h			;2df3
	rst 38h			;2df4
	rst 38h			;2df5
	rst 38h			;2df6
	rst 38h			;2df7
	rst 38h			;2df8
	rst 38h			;2df9
	rst 38h			;2dfa
	rst 38h			;2dfb
	rst 38h			;2dfc
	rst 38h			;2dfd
	rst 38h			;2dfe
	rst 38h			;2dff
	rst 38h			;2e00
	rst 38h			;2e01
	rst 38h			;2e02
	rst 38h			;2e03
	rst 38h			;2e04
	rst 38h			;2e05
	rst 38h			;2e06
	rst 38h			;2e07
	rst 38h			;2e08
	rst 38h			;2e09
	rst 38h			;2e0a
	rst 38h			;2e0b
	rst 38h			;2e0c
	rst 38h			;2e0d
	rst 38h			;2e0e
	rst 38h			;2e0f
	rst 38h			;2e10
	rst 38h			;2e11
	rst 38h			;2e12
	rst 38h			;2e13
	rst 38h			;2e14
	rst 38h			;2e15
	rst 38h			;2e16
	rst 38h			;2e17
	rst 38h			;2e18
	rst 38h			;2e19
	rst 38h			;2e1a
	rst 38h			;2e1b
	rst 38h			;2e1c
	rst 38h			;2e1d
	rst 38h			;2e1e
	rst 38h			;2e1f
	rst 38h			;2e20
	rst 38h			;2e21
	rst 38h			;2e22
	rst 38h			;2e23
	rst 38h			;2e24
	rst 38h			;2e25
	rst 38h			;2e26
	rst 38h			;2e27
	rst 38h			;2e28
	rst 38h			;2e29
	rst 38h			;2e2a
	rst 38h			;2e2b
	rst 38h			;2e2c
	rst 38h			;2e2d
	rst 38h			;2e2e
	rst 38h			;2e2f
	rst 38h			;2e30
	rst 38h			;2e31
	rst 38h			;2e32
	rst 38h			;2e33
	rst 38h			;2e34
	rst 38h			;2e35
	rst 38h			;2e36
	rst 38h			;2e37
	rst 38h			;2e38
	rst 38h			;2e39
	rst 38h			;2e3a
	rst 38h			;2e3b
	rst 38h			;2e3c
	rst 38h			;2e3d
	rst 38h			;2e3e
	rst 38h			;2e3f
	rst 38h			;2e40
	rst 38h			;2e41
	rst 38h			;2e42
	rst 38h			;2e43
	rst 38h			;2e44
	rst 38h			;2e45
	rst 38h			;2e46
	rst 38h			;2e47
	rst 38h			;2e48
	rst 38h			;2e49
	rst 38h			;2e4a
	rst 38h			;2e4b
	rst 38h			;2e4c
	rst 38h			;2e4d
	rst 38h			;2e4e
	rst 38h			;2e4f
	rst 38h			;2e50
	rst 38h			;2e51
	rst 38h			;2e52
	rst 38h			;2e53
	rst 38h			;2e54
	rst 38h			;2e55
	rst 38h			;2e56
	rst 38h			;2e57
	rst 38h			;2e58
	rst 38h			;2e59
	rst 38h			;2e5a
	rst 38h			;2e5b
	rst 38h			;2e5c
	rst 38h			;2e5d
	rst 38h			;2e5e
	rst 38h			;2e5f
	rst 38h			;2e60
	rst 38h			;2e61
	rst 38h			;2e62
	rst 38h			;2e63
	rst 38h			;2e64
	rst 38h			;2e65
	rst 38h			;2e66
	rst 38h			;2e67
	rst 38h			;2e68
	rst 38h			;2e69
	rst 38h			;2e6a
	rst 38h			;2e6b
	rst 38h			;2e6c
	rst 38h			;2e6d
	rst 38h			;2e6e
	rst 38h			;2e6f
	rst 38h			;2e70
	rst 38h			;2e71
	rst 38h			;2e72
	rst 38h			;2e73
	rst 38h			;2e74
	rst 38h			;2e75
	rst 38h			;2e76
	rst 38h			;2e77
	rst 38h			;2e78
	rst 38h			;2e79
	rst 38h			;2e7a
	rst 38h			;2e7b
	rst 38h			;2e7c
	rst 38h			;2e7d
	rst 38h			;2e7e
	rst 38h			;2e7f
	rst 38h			;2e80
	rst 38h			;2e81
	rst 38h			;2e82
	rst 38h			;2e83
	rst 38h			;2e84
	rst 38h			;2e85
	rst 38h			;2e86
	rst 38h			;2e87
	rst 38h			;2e88
	rst 38h			;2e89
	rst 38h			;2e8a
	rst 38h			;2e8b
	rst 38h			;2e8c
	rst 38h			;2e8d
	rst 38h			;2e8e
	rst 38h			;2e8f
	rst 38h			;2e90
	rst 38h			;2e91
	rst 38h			;2e92
	rst 38h			;2e93
	rst 38h			;2e94
	rst 38h			;2e95
	rst 38h			;2e96
	rst 38h			;2e97
	rst 38h			;2e98
	rst 38h			;2e99
	rst 38h			;2e9a
	rst 38h			;2e9b
	rst 38h			;2e9c
	rst 38h			;2e9d
	rst 38h			;2e9e
	rst 38h			;2e9f
	rst 38h			;2ea0
	rst 38h			;2ea1
	rst 38h			;2ea2
	rst 38h			;2ea3
	rst 38h			;2ea4
	rst 38h			;2ea5
	rst 38h			;2ea6
	rst 38h			;2ea7
	rst 38h			;2ea8
	rst 38h			;2ea9
	rst 38h			;2eaa
	rst 38h			;2eab
	rst 38h			;2eac
	rst 38h			;2ead
	rst 38h			;2eae
	rst 38h			;2eaf
	rst 38h			;2eb0
	rst 38h			;2eb1
	rst 38h			;2eb2
	rst 38h			;2eb3
	rst 38h			;2eb4
	rst 38h			;2eb5
	rst 38h			;2eb6
	rst 38h			;2eb7
	rst 38h			;2eb8
	rst 38h			;2eb9
	rst 38h			;2eba
	rst 38h			;2ebb
	rst 38h			;2ebc
	rst 38h			;2ebd
	rst 38h			;2ebe
	rst 38h			;2ebf
	rst 38h			;2ec0
	rst 38h			;2ec1
	rst 38h			;2ec2
	rst 38h			;2ec3
	rst 38h			;2ec4
	rst 38h			;2ec5
	rst 38h			;2ec6
	rst 38h			;2ec7
	rst 38h			;2ec8
	rst 38h			;2ec9
	rst 38h			;2eca
	rst 38h			;2ecb
	rst 38h			;2ecc
	rst 38h			;2ecd
	rst 38h			;2ece
	rst 38h			;2ecf
	rst 38h			;2ed0
	rst 38h			;2ed1
	rst 38h			;2ed2
	rst 38h			;2ed3
	rst 38h			;2ed4
	rst 38h			;2ed5
	rst 38h			;2ed6
	rst 38h			;2ed7
	rst 38h			;2ed8
	rst 38h			;2ed9
	rst 38h			;2eda
	rst 38h			;2edb
	rst 38h			;2edc
	rst 38h			;2edd
	rst 38h			;2ede
	rst 38h			;2edf
	rst 38h			;2ee0
	rst 38h			;2ee1
	rst 38h			;2ee2
	rst 38h			;2ee3
	rst 38h			;2ee4
	rst 38h			;2ee5
	rst 38h			;2ee6
	rst 38h			;2ee7
	rst 38h			;2ee8
	rst 38h			;2ee9
	rst 38h			;2eea
	rst 38h			;2eeb
	rst 38h			;2eec
	rst 38h			;2eed
	rst 38h			;2eee
	rst 38h			;2eef
	rst 38h			;2ef0
	rst 38h			;2ef1
	rst 38h			;2ef2
	rst 38h			;2ef3
	rst 38h			;2ef4
	rst 38h			;2ef5
	rst 38h			;2ef6
	rst 38h			;2ef7
	rst 38h			;2ef8
	rst 38h			;2ef9
	rst 38h			;2efa
	rst 38h			;2efb
	rst 38h			;2efc
	rst 38h			;2efd
	rst 38h			;2efe
	rst 38h			;2eff
	rst 38h			;2f00
	rst 38h			;2f01
	rst 38h			;2f02
	rst 38h			;2f03
	rst 38h			;2f04
	rst 38h			;2f05
	rst 38h			;2f06
	rst 38h			;2f07
	rst 38h			;2f08
	rst 38h			;2f09
	rst 38h			;2f0a
	rst 38h			;2f0b
	rst 38h			;2f0c
	rst 38h			;2f0d
	rst 38h			;2f0e
	rst 38h			;2f0f
	rst 38h			;2f10
	rst 38h			;2f11
	rst 38h			;2f12
	rst 38h			;2f13
	rst 38h			;2f14
	rst 38h			;2f15
	rst 38h			;2f16
	rst 38h			;2f17
	rst 38h			;2f18
	rst 38h			;2f19
	rst 38h			;2f1a
	rst 38h			;2f1b
	rst 38h			;2f1c
	rst 38h			;2f1d
	rst 38h			;2f1e
	rst 38h			;2f1f
	rst 38h			;2f20
	rst 38h			;2f21
	rst 38h			;2f22
	rst 38h			;2f23
	rst 38h			;2f24
	rst 38h			;2f25
	rst 38h			;2f26
	rst 38h			;2f27
	rst 38h			;2f28
	rst 38h			;2f29
	rst 38h			;2f2a
	rst 38h			;2f2b
	rst 38h			;2f2c
	rst 38h			;2f2d
	rst 38h			;2f2e
	rst 38h			;2f2f
	rst 38h			;2f30
	rst 38h			;2f31
	rst 38h			;2f32
	rst 38h			;2f33
	rst 38h			;2f34
	rst 38h			;2f35
	rst 38h			;2f36
	rst 38h			;2f37
	rst 38h			;2f38
	rst 38h			;2f39
	rst 38h			;2f3a
	rst 38h			;2f3b
	rst 38h			;2f3c
	rst 38h			;2f3d
	rst 38h			;2f3e
	rst 38h			;2f3f
	rst 38h			;2f40
	rst 38h			;2f41
	rst 38h			;2f42
	rst 38h			;2f43
	rst 38h			;2f44
	rst 38h			;2f45
	rst 38h			;2f46
	rst 38h			;2f47
	rst 38h			;2f48
	rst 38h			;2f49
	rst 38h			;2f4a
	rst 38h			;2f4b
	rst 38h			;2f4c
	rst 38h			;2f4d
	rst 38h			;2f4e
	rst 38h			;2f4f
	rst 38h			;2f50
	rst 38h			;2f51
	rst 38h			;2f52
	rst 38h			;2f53
	rst 38h			;2f54
	rst 38h			;2f55
	rst 38h			;2f56
	rst 38h			;2f57
	rst 38h			;2f58
	rst 38h			;2f59
	rst 38h			;2f5a
	rst 38h			;2f5b
	rst 38h			;2f5c
	rst 38h			;2f5d
	rst 38h			;2f5e
	rst 38h			;2f5f
	rst 38h			;2f60
	rst 38h			;2f61
	rst 38h			;2f62
	rst 38h			;2f63
	rst 38h			;2f64
	rst 38h			;2f65
	rst 38h			;2f66
	rst 38h			;2f67
	rst 38h			;2f68
	rst 38h			;2f69
	rst 38h			;2f6a
	rst 38h			;2f6b
	rst 38h			;2f6c
	rst 38h			;2f6d
	rst 38h			;2f6e
	rst 38h			;2f6f
	rst 38h			;2f70
	rst 38h			;2f71
	rst 38h			;2f72
	rst 38h			;2f73
	rst 38h			;2f74
	rst 38h			;2f75
	rst 38h			;2f76
	rst 38h			;2f77
	rst 38h			;2f78
	rst 38h			;2f79
	rst 38h			;2f7a
	rst 38h			;2f7b
	rst 38h			;2f7c
	rst 38h			;2f7d
	rst 38h			;2f7e
	rst 38h			;2f7f
	rst 38h			;2f80
	rst 38h			;2f81
	rst 38h			;2f82
	rst 38h			;2f83
	rst 38h			;2f84
	rst 38h			;2f85
	rst 38h			;2f86
	rst 38h			;2f87
	rst 38h			;2f88
	rst 38h			;2f89
	rst 38h			;2f8a
	rst 38h			;2f8b
	rst 38h			;2f8c
	rst 38h			;2f8d
	rst 38h			;2f8e
	rst 38h			;2f8f
	rst 38h			;2f90
	rst 38h			;2f91
	rst 38h			;2f92
	rst 38h			;2f93
	rst 38h			;2f94
	rst 38h			;2f95
	rst 38h			;2f96
	rst 38h			;2f97
	rst 38h			;2f98
	rst 38h			;2f99
	rst 38h			;2f9a
	rst 38h			;2f9b
	rst 38h			;2f9c
	rst 38h			;2f9d
	rst 38h			;2f9e
	rst 38h			;2f9f
	rst 38h			;2fa0
	rst 38h			;2fa1
	rst 38h			;2fa2
	rst 38h			;2fa3
	rst 38h			;2fa4
	rst 38h			;2fa5
	rst 38h			;2fa6
	rst 38h			;2fa7
	rst 38h			;2fa8
	rst 38h			;2fa9
	rst 38h			;2faa
	rst 38h			;2fab
	rst 38h			;2fac
	rst 38h			;2fad
	rst 38h			;2fae
l2fafh:
	rst 38h			;2faf
	rst 38h			;2fb0
	rst 38h			;2fb1
	rst 38h			;2fb2
	rst 38h			;2fb3
	rst 38h			;2fb4
	rst 38h			;2fb5
	rst 38h			;2fb6
	rst 38h			;2fb7
	rst 38h			;2fb8
	rst 38h			;2fb9
	rst 38h			;2fba
	rst 38h			;2fbb
	rst 38h			;2fbc
	rst 38h			;2fbd
	rst 38h			;2fbe
	rst 38h			;2fbf
	rst 38h			;2fc0
	rst 38h			;2fc1
	rst 38h			;2fc2
	rst 38h			;2fc3
	rst 38h			;2fc4
	rst 38h			;2fc5
	rst 38h			;2fc6
	rst 38h			;2fc7
	rst 38h			;2fc8
	rst 38h			;2fc9
	rst 38h			;2fca
	rst 38h			;2fcb
	rst 38h			;2fcc
	rst 38h			;2fcd
	rst 38h			;2fce
	rst 38h			;2fcf
	rst 38h			;2fd0
	rst 38h			;2fd1
	rst 38h			;2fd2
	rst 38h			;2fd3
	rst 38h			;2fd4
	rst 38h			;2fd5
	rst 38h			;2fd6
	rst 38h			;2fd7
	rst 38h			;2fd8
	rst 38h			;2fd9
	rst 38h			;2fda
	rst 38h			;2fdb
	rst 38h			;2fdc
	rst 38h			;2fdd
	rst 38h			;2fde
	rst 38h			;2fdf
	rst 38h			;2fe0
	rst 38h			;2fe1
	rst 38h			;2fe2
	rst 38h			;2fe3
	rst 38h			;2fe4
	rst 38h			;2fe5
	rst 38h			;2fe6
	rst 38h			;2fe7
	rst 38h			;2fe8
	rst 38h			;2fe9
	rst 38h			;2fea
	rst 38h			;2feb
	rst 38h			;2fec
	rst 38h			;2fed
	rst 38h			;2fee
	rst 38h			;2fef
	rst 38h			;2ff0
	rst 38h			;2ff1
	rst 38h			;2ff2
	rst 38h			;2ff3
	rst 38h			;2ff4
	rst 38h			;2ff5
	rst 38h			;2ff6
	rst 38h			;2ff7
	rst 38h			;2ff8
	rst 38h			;2ff9
	rst 38h			;2ffa
	rst 38h			;2ffb
	rst 38h			;2ffc
	rst 38h			;2ffd
	rst 38h			;2ffe
	rst 38h			;2fff
	rst 38h			;3000
	rst 38h			;3001
	rst 38h			;3002
	rst 38h			;3003
	rst 38h			;3004
	rst 38h			;3005
	rst 38h			;3006
	rst 38h			;3007
	rst 38h			;3008
	rst 38h			;3009
	rst 38h			;300a
	rst 38h			;300b
	rst 38h			;300c
	rst 38h			;300d
	rst 38h			;300e
	rst 38h			;300f
	rst 38h			;3010
	rst 38h			;3011
	rst 38h			;3012
	rst 38h			;3013
	rst 38h			;3014
	rst 38h			;3015
	rst 38h			;3016
	rst 38h			;3017
	rst 38h			;3018
	rst 38h			;3019
	rst 38h			;301a
	rst 38h			;301b
	rst 38h			;301c
	rst 38h			;301d
	rst 38h			;301e
	rst 38h			;301f
	rst 38h			;3020
	rst 38h			;3021
	rst 38h			;3022
	rst 38h			;3023
	rst 38h			;3024
	rst 38h			;3025
	rst 38h			;3026
	rst 38h			;3027
	rst 38h			;3028
	rst 38h			;3029
	rst 38h			;302a
	rst 38h			;302b
	rst 38h			;302c
	rst 38h			;302d
	rst 38h			;302e
	rst 38h			;302f
	rst 38h			;3030
	rst 38h			;3031
	rst 38h			;3032
	rst 38h			;3033
	rst 38h			;3034
	rst 38h			;3035
	rst 38h			;3036
	rst 38h			;3037
	rst 38h			;3038
	rst 38h			;3039
	rst 38h			;303a
	rst 38h			;303b
	rst 38h			;303c
	rst 38h			;303d
	rst 38h			;303e
	rst 38h			;303f
	rst 38h			;3040
	rst 38h			;3041
	rst 38h			;3042
	rst 38h			;3043
	rst 38h			;3044
	rst 38h			;3045
	rst 38h			;3046
	rst 38h			;3047
	rst 38h			;3048
	rst 38h			;3049
	rst 38h			;304a
	rst 38h			;304b
	rst 38h			;304c
	rst 38h			;304d
	rst 38h			;304e
	rst 38h			;304f
	rst 38h			;3050
	rst 38h			;3051
	rst 38h			;3052
	rst 38h			;3053
	rst 38h			;3054
	rst 38h			;3055
	rst 38h			;3056
	rst 38h			;3057
	rst 38h			;3058
	rst 38h			;3059
	rst 38h			;305a
	rst 38h			;305b
	rst 38h			;305c
	rst 38h			;305d
	rst 38h			;305e
	rst 38h			;305f
	rst 38h			;3060
	rst 38h			;3061
	rst 38h			;3062
	rst 38h			;3063
	rst 38h			;3064
	rst 38h			;3065
	rst 38h			;3066
	rst 38h			;3067
	rst 38h			;3068
	rst 38h			;3069
	rst 38h			;306a
	rst 38h			;306b
	rst 38h			;306c
	rst 38h			;306d
	rst 38h			;306e
	rst 38h			;306f
	rst 38h			;3070
	rst 38h			;3071
	rst 38h			;3072
	rst 38h			;3073
	rst 38h			;3074
	rst 38h			;3075
	rst 38h			;3076
	rst 38h			;3077
	rst 38h			;3078
	rst 38h			;3079
	rst 38h			;307a
	rst 38h			;307b
	rst 38h			;307c
	rst 38h			;307d
	rst 38h			;307e
	rst 38h			;307f
	rst 38h			;3080
	rst 38h			;3081
	rst 38h			;3082
	rst 38h			;3083
	rst 38h			;3084
	rst 38h			;3085
	rst 38h			;3086
	rst 38h			;3087
	rst 38h			;3088
	rst 38h			;3089
	rst 38h			;308a
	rst 38h			;308b
	rst 38h			;308c
	rst 38h			;308d
	rst 38h			;308e
	rst 38h			;308f
	rst 38h			;3090
	rst 38h			;3091
	rst 38h			;3092
	rst 38h			;3093
	rst 38h			;3094
	rst 38h			;3095
	rst 38h			;3096
	rst 38h			;3097
	rst 38h			;3098
	rst 38h			;3099
	rst 38h			;309a
	rst 38h			;309b
	rst 38h			;309c
	rst 38h			;309d
	rst 38h			;309e
	rst 38h			;309f
	rst 38h			;30a0
	rst 38h			;30a1
	rst 38h			;30a2
	rst 38h			;30a3
	rst 38h			;30a4
	rst 38h			;30a5
	rst 38h			;30a6
	rst 38h			;30a7
	rst 38h			;30a8
	rst 38h			;30a9
	rst 38h			;30aa
	rst 38h			;30ab
	rst 38h			;30ac
	rst 38h			;30ad
	rst 38h			;30ae
	rst 38h			;30af
	rst 38h			;30b0
	rst 38h			;30b1
	rst 38h			;30b2
	rst 38h			;30b3
	rst 38h			;30b4
	rst 38h			;30b5
	rst 38h			;30b6
	rst 38h			;30b7
	rst 38h			;30b8
	rst 38h			;30b9
	rst 38h			;30ba
	rst 38h			;30bb
	rst 38h			;30bc
	rst 38h			;30bd
	rst 38h			;30be
	rst 38h			;30bf
	rst 38h			;30c0
	rst 38h			;30c1
	rst 38h			;30c2
	rst 38h			;30c3
	rst 38h			;30c4
	rst 38h			;30c5
	rst 38h			;30c6
	rst 38h			;30c7
	rst 38h			;30c8
	rst 38h			;30c9
	rst 38h			;30ca
	rst 38h			;30cb
	rst 38h			;30cc
	rst 38h			;30cd
	rst 38h			;30ce
	rst 38h			;30cf
	rst 38h			;30d0
	rst 38h			;30d1
	rst 38h			;30d2
	rst 38h			;30d3
	rst 38h			;30d4
	rst 38h			;30d5
	rst 38h			;30d6
	rst 38h			;30d7
	rst 38h			;30d8
	rst 38h			;30d9
	rst 38h			;30da
	rst 38h			;30db
	rst 38h			;30dc
	rst 38h			;30dd
	rst 38h			;30de
	rst 38h			;30df
	rst 38h			;30e0
	rst 38h			;30e1
	rst 38h			;30e2
	rst 38h			;30e3
	rst 38h			;30e4
	rst 38h			;30e5
	rst 38h			;30e6
	rst 38h			;30e7
	rst 38h			;30e8
	rst 38h			;30e9
	rst 38h			;30ea
	rst 38h			;30eb
	rst 38h			;30ec
	rst 38h			;30ed
	rst 38h			;30ee
	rst 38h			;30ef
	rst 38h			;30f0
	rst 38h			;30f1
	rst 38h			;30f2
	rst 38h			;30f3
	rst 38h			;30f4
	rst 38h			;30f5
	rst 38h			;30f6
	rst 38h			;30f7
	rst 38h			;30f8
l30f9h:
	rst 38h			;30f9
	rst 38h			;30fa
	rst 38h			;30fb
	rst 38h			;30fc
	rst 38h			;30fd
	rst 38h			;30fe
	rst 38h			;30ff
	rst 38h			;3100
	rst 38h			;3101
	rst 38h			;3102
	rst 38h			;3103
	rst 38h			;3104
	rst 38h			;3105
	rst 38h			;3106
	rst 38h			;3107
	rst 38h			;3108
	rst 38h			;3109
	rst 38h			;310a
	rst 38h			;310b
	rst 38h			;310c
	rst 38h			;310d
	rst 38h			;310e
	rst 38h			;310f
	rst 38h			;3110
	rst 38h			;3111
	rst 38h			;3112
	rst 38h			;3113
	rst 38h			;3114
	rst 38h			;3115
	rst 38h			;3116
	rst 38h			;3117
	rst 38h			;3118
	rst 38h			;3119
	rst 38h			;311a
	rst 38h			;311b
	rst 38h			;311c
	rst 38h			;311d
	rst 38h			;311e
	rst 38h			;311f
	rst 38h			;3120
	rst 38h			;3121
	rst 38h			;3122
	rst 38h			;3123
	rst 38h			;3124
	rst 38h			;3125
	rst 38h			;3126
	rst 38h			;3127
	rst 38h			;3128
	rst 38h			;3129
	rst 38h			;312a
	rst 38h			;312b
	rst 38h			;312c
	rst 38h			;312d
	rst 38h			;312e
	rst 38h			;312f
	rst 38h			;3130
	rst 38h			;3131
	rst 38h			;3132
	rst 38h			;3133
	rst 38h			;3134
	rst 38h			;3135
	rst 38h			;3136
	rst 38h			;3137
	rst 38h			;3138
	rst 38h			;3139
	rst 38h			;313a
	rst 38h			;313b
	rst 38h			;313c
	rst 38h			;313d
	rst 38h			;313e
	rst 38h			;313f
	rst 38h			;3140
	rst 38h			;3141
	rst 38h			;3142
	rst 38h			;3143
	rst 38h			;3144
	rst 38h			;3145
	rst 38h			;3146
	rst 38h			;3147
	rst 38h			;3148
	rst 38h			;3149
	rst 38h			;314a
	rst 38h			;314b
	rst 38h			;314c
	rst 38h			;314d
	rst 38h			;314e
	rst 38h			;314f
	rst 38h			;3150
	rst 38h			;3151
	rst 38h			;3152
	rst 38h			;3153
	rst 38h			;3154
	rst 38h			;3155
	rst 38h			;3156
	rst 38h			;3157
	rst 38h			;3158
	rst 38h			;3159
	rst 38h			;315a
	rst 38h			;315b
	rst 38h			;315c
	rst 38h			;315d
	rst 38h			;315e
	rst 38h			;315f
	rst 38h			;3160
	rst 38h			;3161
	rst 38h			;3162
	rst 38h			;3163
	rst 38h			;3164
	rst 38h			;3165
	rst 38h			;3166
	rst 38h			;3167
	rst 38h			;3168
	rst 38h			;3169
	rst 38h			;316a
	rst 38h			;316b
	rst 38h			;316c
	rst 38h			;316d
	rst 38h			;316e
	rst 38h			;316f
	rst 38h			;3170
	rst 38h			;3171
	rst 38h			;3172
	rst 38h			;3173
	rst 38h			;3174
	rst 38h			;3175
	rst 38h			;3176
	rst 38h			;3177
	rst 38h			;3178
	rst 38h			;3179
	rst 38h			;317a
	rst 38h			;317b
	rst 38h			;317c
	rst 38h			;317d
	rst 38h			;317e
	rst 38h			;317f
	rst 38h			;3180
	rst 38h			;3181
	rst 38h			;3182
	rst 38h			;3183
	rst 38h			;3184
	rst 38h			;3185
	rst 38h			;3186
	rst 38h			;3187
	rst 38h			;3188
	rst 38h			;3189
	rst 38h			;318a
	rst 38h			;318b
	rst 38h			;318c
	rst 38h			;318d
	rst 38h			;318e
	rst 38h			;318f
	rst 38h			;3190
	rst 38h			;3191
	rst 38h			;3192
l3193h:
	rst 38h			;3193
	rst 38h			;3194
	rst 38h			;3195
	rst 38h			;3196
	rst 38h			;3197
	rst 38h			;3198
	rst 38h			;3199
	rst 38h			;319a
	rst 38h			;319b
	rst 38h			;319c
	rst 38h			;319d
	rst 38h			;319e
	rst 38h			;319f
	rst 38h			;31a0
	rst 38h			;31a1
	rst 38h			;31a2
	rst 38h			;31a3
	rst 38h			;31a4
	rst 38h			;31a5
	rst 38h			;31a6
	rst 38h			;31a7
	rst 38h			;31a8
	rst 38h			;31a9
	rst 38h			;31aa
	rst 38h			;31ab
	rst 38h			;31ac
	rst 38h			;31ad
	rst 38h			;31ae
	rst 38h			;31af
	rst 38h			;31b0
	rst 38h			;31b1
	rst 38h			;31b2
	rst 38h			;31b3
	rst 38h			;31b4
	rst 38h			;31b5
	rst 38h			;31b6
	rst 38h			;31b7
	rst 38h			;31b8
	rst 38h			;31b9
	rst 38h			;31ba
	rst 38h			;31bb
	rst 38h			;31bc
	rst 38h			;31bd
	rst 38h			;31be
	rst 38h			;31bf
	rst 38h			;31c0
	rst 38h			;31c1
	rst 38h			;31c2
	rst 38h			;31c3
	rst 38h			;31c4
	rst 38h			;31c5
	rst 38h			;31c6
	rst 38h			;31c7
	rst 38h			;31c8
	rst 38h			;31c9
	rst 38h			;31ca
	rst 38h			;31cb
	rst 38h			;31cc
	rst 38h			;31cd
	rst 38h			;31ce
	rst 38h			;31cf
	rst 38h			;31d0
	rst 38h			;31d1
	rst 38h			;31d2
	rst 38h			;31d3
	rst 38h			;31d4
	rst 38h			;31d5
	rst 38h			;31d6
	rst 38h			;31d7
	rst 38h			;31d8
	rst 38h			;31d9
	rst 38h			;31da
	rst 38h			;31db
	rst 38h			;31dc
	rst 38h			;31dd
	rst 38h			;31de
	rst 38h			;31df
	rst 38h			;31e0
	rst 38h			;31e1
	rst 38h			;31e2
	rst 38h			;31e3
	rst 38h			;31e4
	rst 38h			;31e5
	rst 38h			;31e6
	rst 38h			;31e7
	rst 38h			;31e8
	rst 38h			;31e9
	rst 38h			;31ea
	rst 38h			;31eb
	rst 38h			;31ec
	rst 38h			;31ed
	rst 38h			;31ee
	rst 38h			;31ef
	rst 38h			;31f0
	rst 38h			;31f1
	rst 38h			;31f2
	rst 38h			;31f3
	rst 38h			;31f4
	rst 38h			;31f5
	rst 38h			;31f6
	rst 38h			;31f7
	rst 38h			;31f8
	rst 38h			;31f9
	rst 38h			;31fa
	rst 38h			;31fb
	rst 38h			;31fc
	rst 38h			;31fd
	rst 38h			;31fe
	rst 38h			;31ff
	rst 38h			;3200
	rst 38h			;3201
	rst 38h			;3202
	rst 38h			;3203
	rst 38h			;3204
	rst 38h			;3205
	rst 38h			;3206
	rst 38h			;3207
	rst 38h			;3208
	rst 38h			;3209
	rst 38h			;320a
	rst 38h			;320b
	rst 38h			;320c
	rst 38h			;320d
	rst 38h			;320e
	rst 38h			;320f
	rst 38h			;3210
	rst 38h			;3211
	rst 38h			;3212
	rst 38h			;3213
	rst 38h			;3214
	rst 38h			;3215
	rst 38h			;3216
	rst 38h			;3217
	rst 38h			;3218
	rst 38h			;3219
	rst 38h			;321a
	rst 38h			;321b
	rst 38h			;321c
	rst 38h			;321d
	rst 38h			;321e
	rst 38h			;321f
	rst 38h			;3220
	rst 38h			;3221
	rst 38h			;3222
	rst 38h			;3223
	rst 38h			;3224
	rst 38h			;3225
	rst 38h			;3226
	rst 38h			;3227
	rst 38h			;3228
	rst 38h			;3229
	rst 38h			;322a
	rst 38h			;322b
	rst 38h			;322c
	rst 38h			;322d
	rst 38h			;322e
	rst 38h			;322f
	rst 38h			;3230
	rst 38h			;3231
	rst 38h			;3232
	rst 38h			;3233
	rst 38h			;3234
	rst 38h			;3235
	rst 38h			;3236
	rst 38h			;3237
	rst 38h			;3238
	rst 38h			;3239
	rst 38h			;323a
	rst 38h			;323b
	rst 38h			;323c
	rst 38h			;323d
	rst 38h			;323e
	rst 38h			;323f
	rst 38h			;3240
	rst 38h			;3241
	rst 38h			;3242
	rst 38h			;3243
	rst 38h			;3244
	rst 38h			;3245
	rst 38h			;3246
	rst 38h			;3247
	rst 38h			;3248
	rst 38h			;3249
	rst 38h			;324a
	rst 38h			;324b
	rst 38h			;324c
	rst 38h			;324d
	rst 38h			;324e
	rst 38h			;324f
	rst 38h			;3250
	rst 38h			;3251
	rst 38h			;3252
	rst 38h			;3253
	rst 38h			;3254
	rst 38h			;3255
	rst 38h			;3256
	rst 38h			;3257
	rst 38h			;3258
	rst 38h			;3259
	rst 38h			;325a
	rst 38h			;325b
	rst 38h			;325c
	rst 38h			;325d
	rst 38h			;325e
	rst 38h			;325f
	rst 38h			;3260
	rst 38h			;3261
	rst 38h			;3262
	rst 38h			;3263
	rst 38h			;3264
	rst 38h			;3265
	rst 38h			;3266
	rst 38h			;3267
	rst 38h			;3268
	rst 38h			;3269
	rst 38h			;326a
	rst 38h			;326b
	rst 38h			;326c
	rst 38h			;326d
	rst 38h			;326e
	rst 38h			;326f
	rst 38h			;3270
	rst 38h			;3271
	rst 38h			;3272
	rst 38h			;3273
	rst 38h			;3274
	rst 38h			;3275
	rst 38h			;3276
	rst 38h			;3277
	rst 38h			;3278
	rst 38h			;3279
	rst 38h			;327a
	rst 38h			;327b
	rst 38h			;327c
	rst 38h			;327d
	rst 38h			;327e
	rst 38h			;327f
	rst 38h			;3280
	rst 38h			;3281
	rst 38h			;3282
	rst 38h			;3283
	rst 38h			;3284
	rst 38h			;3285
	rst 38h			;3286
	rst 38h			;3287
	rst 38h			;3288
	rst 38h			;3289
	rst 38h			;328a
	rst 38h			;328b
	rst 38h			;328c
	rst 38h			;328d
	rst 38h			;328e
	rst 38h			;328f
	rst 38h			;3290
	rst 38h			;3291
	rst 38h			;3292
	rst 38h			;3293
	rst 38h			;3294
	rst 38h			;3295
	rst 38h			;3296
	rst 38h			;3297
	rst 38h			;3298
	rst 38h			;3299
	rst 38h			;329a
	rst 38h			;329b
	rst 38h			;329c
	rst 38h			;329d
	rst 38h			;329e
	rst 38h			;329f
	rst 38h			;32a0
	rst 38h			;32a1
	rst 38h			;32a2
	rst 38h			;32a3
	rst 38h			;32a4
	rst 38h			;32a5
	rst 38h			;32a6
	rst 38h			;32a7
	rst 38h			;32a8
	rst 38h			;32a9
	rst 38h			;32aa
	rst 38h			;32ab
	rst 38h			;32ac
	rst 38h			;32ad
	rst 38h			;32ae
	rst 38h			;32af
	rst 38h			;32b0
	rst 38h			;32b1
	rst 38h			;32b2
	rst 38h			;32b3
	rst 38h			;32b4
	rst 38h			;32b5
	rst 38h			;32b6
	rst 38h			;32b7
	rst 38h			;32b8
	rst 38h			;32b9
	rst 38h			;32ba
	rst 38h			;32bb
	rst 38h			;32bc
	rst 38h			;32bd
	rst 38h			;32be
	rst 38h			;32bf
	rst 38h			;32c0
	rst 38h			;32c1
	rst 38h			;32c2
	rst 38h			;32c3
	rst 38h			;32c4
	rst 38h			;32c5
	rst 38h			;32c6
	rst 38h			;32c7
	rst 38h			;32c8
	rst 38h			;32c9
	rst 38h			;32ca
	rst 38h			;32cb
	rst 38h			;32cc
	rst 38h			;32cd
	rst 38h			;32ce
	rst 38h			;32cf
	rst 38h			;32d0
	rst 38h			;32d1
	rst 38h			;32d2
	rst 38h			;32d3
	rst 38h			;32d4
	rst 38h			;32d5
	rst 38h			;32d6
	rst 38h			;32d7
	rst 38h			;32d8
	rst 38h			;32d9
	rst 38h			;32da
	rst 38h			;32db
	rst 38h			;32dc
	rst 38h			;32dd
	rst 38h			;32de
	rst 38h			;32df
	rst 38h			;32e0
	rst 38h			;32e1
	rst 38h			;32e2
	rst 38h			;32e3
	rst 38h			;32e4
	rst 38h			;32e5
	rst 38h			;32e6
	rst 38h			;32e7
	rst 38h			;32e8
	rst 38h			;32e9
	rst 38h			;32ea
	rst 38h			;32eb
	rst 38h			;32ec
	rst 38h			;32ed
	rst 38h			;32ee
	rst 38h			;32ef
	rst 38h			;32f0
	rst 38h			;32f1
	rst 38h			;32f2
	rst 38h			;32f3
	rst 38h			;32f4
	rst 38h			;32f5
	rst 38h			;32f6
	rst 38h			;32f7
	rst 38h			;32f8
	rst 38h			;32f9
	rst 38h			;32fa
	rst 38h			;32fb
	rst 38h			;32fc
	rst 38h			;32fd
	rst 38h			;32fe
	rst 38h			;32ff
	rst 38h			;3300
	rst 38h			;3301
	rst 38h			;3302
	rst 38h			;3303
	rst 38h			;3304
	rst 38h			;3305
	rst 38h			;3306
	rst 38h			;3307
	rst 38h			;3308
	rst 38h			;3309
	rst 38h			;330a
	rst 38h			;330b
	rst 38h			;330c
	rst 38h			;330d
	rst 38h			;330e
	rst 38h			;330f
	rst 38h			;3310
	rst 38h			;3311
	rst 38h			;3312
	rst 38h			;3313
	rst 38h			;3314
	rst 38h			;3315
	rst 38h			;3316
	rst 38h			;3317
	rst 38h			;3318
	rst 38h			;3319
	rst 38h			;331a
	rst 38h			;331b
	rst 38h			;331c
	rst 38h			;331d
	rst 38h			;331e
	rst 38h			;331f
	rst 38h			;3320
	rst 38h			;3321
	rst 38h			;3322
	rst 38h			;3323
	rst 38h			;3324
	rst 38h			;3325
	rst 38h			;3326
	rst 38h			;3327
	rst 38h			;3328
	rst 38h			;3329
	rst 38h			;332a
	rst 38h			;332b
	rst 38h			;332c
	rst 38h			;332d
	rst 38h			;332e
	rst 38h			;332f
	rst 38h			;3330
	rst 38h			;3331
	rst 38h			;3332
	rst 38h			;3333
	rst 38h			;3334
	rst 38h			;3335
	rst 38h			;3336
	rst 38h			;3337
	rst 38h			;3338
	rst 38h			;3339
	rst 38h			;333a
	rst 38h			;333b
	rst 38h			;333c
	rst 38h			;333d
	rst 38h			;333e
	rst 38h			;333f
	rst 38h			;3340
	rst 38h			;3341
	rst 38h			;3342
	rst 38h			;3343
	rst 38h			;3344
	rst 38h			;3345
	rst 38h			;3346
	rst 38h			;3347
	rst 38h			;3348
	rst 38h			;3349
	rst 38h			;334a
	rst 38h			;334b
	rst 38h			;334c
	rst 38h			;334d
	rst 38h			;334e
	rst 38h			;334f
	rst 38h			;3350
	rst 38h			;3351
	rst 38h			;3352
	rst 38h			;3353
	rst 38h			;3354
	rst 38h			;3355
	rst 38h			;3356
	rst 38h			;3357
	rst 38h			;3358
	rst 38h			;3359
	rst 38h			;335a
	rst 38h			;335b
	rst 38h			;335c
	rst 38h			;335d
	rst 38h			;335e
	rst 38h			;335f
	rst 38h			;3360
	rst 38h			;3361
	rst 38h			;3362
	rst 38h			;3363
	rst 38h			;3364
	rst 38h			;3365
	rst 38h			;3366
	rst 38h			;3367
	rst 38h			;3368
	rst 38h			;3369
	rst 38h			;336a
	rst 38h			;336b
	rst 38h			;336c
	rst 38h			;336d
	rst 38h			;336e
	rst 38h			;336f
	rst 38h			;3370
	rst 38h			;3371
	rst 38h			;3372
	rst 38h			;3373
	rst 38h			;3374
	rst 38h			;3375
	rst 38h			;3376
	rst 38h			;3377
	rst 38h			;3378
	rst 38h			;3379
	rst 38h			;337a
	rst 38h			;337b
	rst 38h			;337c
	rst 38h			;337d
	rst 38h			;337e
	rst 38h			;337f
	rst 38h			;3380
	rst 38h			;3381
	rst 38h			;3382
	rst 38h			;3383
	rst 38h			;3384
	rst 38h			;3385
	rst 38h			;3386
	rst 38h			;3387
	rst 38h			;3388
	rst 38h			;3389
	rst 38h			;338a
	rst 38h			;338b
	rst 38h			;338c
	rst 38h			;338d
	rst 38h			;338e
	rst 38h			;338f
	rst 38h			;3390
	rst 38h			;3391
	rst 38h			;3392
	rst 38h			;3393
	rst 38h			;3394
	rst 38h			;3395
	rst 38h			;3396
	rst 38h			;3397
	rst 38h			;3398
	rst 38h			;3399
	rst 38h			;339a
	rst 38h			;339b
	rst 38h			;339c
	rst 38h			;339d
	rst 38h			;339e
	rst 38h			;339f
	rst 38h			;33a0
	rst 38h			;33a1
	rst 38h			;33a2
	rst 38h			;33a3
	rst 38h			;33a4
	rst 38h			;33a5
	rst 38h			;33a6
	rst 38h			;33a7
	rst 38h			;33a8
	rst 38h			;33a9
	rst 38h			;33aa
	rst 38h			;33ab
	rst 38h			;33ac
	rst 38h			;33ad
	rst 38h			;33ae
	rst 38h			;33af
	rst 38h			;33b0
	rst 38h			;33b1
	rst 38h			;33b2
	rst 38h			;33b3
	rst 38h			;33b4
	rst 38h			;33b5
	rst 38h			;33b6
	rst 38h			;33b7
	rst 38h			;33b8
	rst 38h			;33b9
	rst 38h			;33ba
	rst 38h			;33bb
	rst 38h			;33bc
	rst 38h			;33bd
	rst 38h			;33be
	rst 38h			;33bf
	rst 38h			;33c0
	rst 38h			;33c1
	rst 38h			;33c2
	rst 38h			;33c3
	rst 38h			;33c4
	rst 38h			;33c5
	rst 38h			;33c6
	rst 38h			;33c7
	rst 38h			;33c8
	rst 38h			;33c9
	rst 38h			;33ca
	rst 38h			;33cb
	rst 38h			;33cc
	rst 38h			;33cd
	rst 38h			;33ce
	rst 38h			;33cf
	rst 38h			;33d0
	rst 38h			;33d1
	rst 38h			;33d2
	rst 38h			;33d3
	rst 38h			;33d4
	rst 38h			;33d5
	rst 38h			;33d6
	rst 38h			;33d7
	rst 38h			;33d8
	rst 38h			;33d9
	rst 38h			;33da
	rst 38h			;33db
	rst 38h			;33dc
	rst 38h			;33dd
	rst 38h			;33de
	rst 38h			;33df
	rst 38h			;33e0
	rst 38h			;33e1
	rst 38h			;33e2
	rst 38h			;33e3
	rst 38h			;33e4
	rst 38h			;33e5
	rst 38h			;33e6
	rst 38h			;33e7
	rst 38h			;33e8
	rst 38h			;33e9
	rst 38h			;33ea
	rst 38h			;33eb
	rst 38h			;33ec
	rst 38h			;33ed
	rst 38h			;33ee
	rst 38h			;33ef
	rst 38h			;33f0
	rst 38h			;33f1
	rst 38h			;33f2
	rst 38h			;33f3
	rst 38h			;33f4
	rst 38h			;33f5
	rst 38h			;33f6
	rst 38h			;33f7
	rst 38h			;33f8
	rst 38h			;33f9
	rst 38h			;33fa
	rst 38h			;33fb
	rst 38h			;33fc
	rst 38h			;33fd
	rst 38h			;33fe
	rst 38h			;33ff
	rst 38h			;3400
	rst 38h			;3401
	rst 38h			;3402
	rst 38h			;3403
	rst 38h			;3404
	rst 38h			;3405
	rst 38h			;3406
	rst 38h			;3407
	rst 38h			;3408
	rst 38h			;3409
	rst 38h			;340a
	rst 38h			;340b
	rst 38h			;340c
	rst 38h			;340d
	rst 38h			;340e
	rst 38h			;340f
	rst 38h			;3410
	rst 38h			;3411
	rst 38h			;3412
	rst 38h			;3413
	rst 38h			;3414
	rst 38h			;3415
	rst 38h			;3416
	rst 38h			;3417
	rst 38h			;3418
	rst 38h			;3419
	rst 38h			;341a
	rst 38h			;341b
	rst 38h			;341c
	rst 38h			;341d
	rst 38h			;341e
	rst 38h			;341f
	rst 38h			;3420
	rst 38h			;3421
	rst 38h			;3422
	rst 38h			;3423
	rst 38h			;3424
	rst 38h			;3425
	rst 38h			;3426
	rst 38h			;3427
	rst 38h			;3428
	rst 38h			;3429
	rst 38h			;342a
	rst 38h			;342b
	rst 38h			;342c
	rst 38h			;342d
	rst 38h			;342e
	rst 38h			;342f
	rst 38h			;3430
	rst 38h			;3431
	rst 38h			;3432
	rst 38h			;3433
	rst 38h			;3434
	rst 38h			;3435
	rst 38h			;3436
	rst 38h			;3437
	rst 38h			;3438
	rst 38h			;3439
	rst 38h			;343a
	rst 38h			;343b
	rst 38h			;343c
	rst 38h			;343d
	rst 38h			;343e
	rst 38h			;343f
	rst 38h			;3440
	rst 38h			;3441
	rst 38h			;3442
	rst 38h			;3443
	rst 38h			;3444
	rst 38h			;3445
	rst 38h			;3446
	rst 38h			;3447
	rst 38h			;3448
	rst 38h			;3449
	rst 38h			;344a
	rst 38h			;344b
	rst 38h			;344c
	rst 38h			;344d
	rst 38h			;344e
	rst 38h			;344f
	rst 38h			;3450
	rst 38h			;3451
	rst 38h			;3452
	rst 38h			;3453
	rst 38h			;3454
	rst 38h			;3455
	rst 38h			;3456
	rst 38h			;3457
	rst 38h			;3458
	rst 38h			;3459
	rst 38h			;345a
	rst 38h			;345b
	rst 38h			;345c
	rst 38h			;345d
	rst 38h			;345e
	rst 38h			;345f
	rst 38h			;3460
	rst 38h			;3461
	rst 38h			;3462
	rst 38h			;3463
	rst 38h			;3464
	rst 38h			;3465
	rst 38h			;3466
	rst 38h			;3467
	rst 38h			;3468
	rst 38h			;3469
	rst 38h			;346a
	rst 38h			;346b
	rst 38h			;346c
	rst 38h			;346d
	rst 38h			;346e
	rst 38h			;346f
	rst 38h			;3470
	rst 38h			;3471
	rst 38h			;3472
	rst 38h			;3473
	rst 38h			;3474
	rst 38h			;3475
	rst 38h			;3476
	rst 38h			;3477
	rst 38h			;3478
	rst 38h			;3479
	rst 38h			;347a
	rst 38h			;347b
	rst 38h			;347c
	rst 38h			;347d
	rst 38h			;347e
	rst 38h			;347f
	rst 38h			;3480
	rst 38h			;3481
	rst 38h			;3482
	rst 38h			;3483
	rst 38h			;3484
	rst 38h			;3485
	rst 38h			;3486
	rst 38h			;3487
	rst 38h			;3488
	rst 38h			;3489
	rst 38h			;348a
	rst 38h			;348b
	rst 38h			;348c
	rst 38h			;348d
	rst 38h			;348e
	rst 38h			;348f
	rst 38h			;3490
	rst 38h			;3491
	rst 38h			;3492
	rst 38h			;3493
	rst 38h			;3494
	rst 38h			;3495
	rst 38h			;3496
	rst 38h			;3497
	rst 38h			;3498
	rst 38h			;3499
	rst 38h			;349a
	rst 38h			;349b
	rst 38h			;349c
	rst 38h			;349d
	rst 38h			;349e
	rst 38h			;349f
	rst 38h			;34a0
	rst 38h			;34a1
	rst 38h			;34a2
	rst 38h			;34a3
	rst 38h			;34a4
	rst 38h			;34a5
	rst 38h			;34a6
	rst 38h			;34a7
	rst 38h			;34a8
	rst 38h			;34a9
	rst 38h			;34aa
	rst 38h			;34ab
	rst 38h			;34ac
	rst 38h			;34ad
	rst 38h			;34ae
	rst 38h			;34af
	rst 38h			;34b0
	rst 38h			;34b1
	rst 38h			;34b2
	rst 38h			;34b3
	rst 38h			;34b4
	rst 38h			;34b5
	rst 38h			;34b6
	rst 38h			;34b7
	rst 38h			;34b8
	rst 38h			;34b9
	rst 38h			;34ba
	rst 38h			;34bb
	rst 38h			;34bc
	rst 38h			;34bd
	rst 38h			;34be
	rst 38h			;34bf
	rst 38h			;34c0
	rst 38h			;34c1
	rst 38h			;34c2
	rst 38h			;34c3
	rst 38h			;34c4
	rst 38h			;34c5
	rst 38h			;34c6
	rst 38h			;34c7
	rst 38h			;34c8
	rst 38h			;34c9
	rst 38h			;34ca
	rst 38h			;34cb
	rst 38h			;34cc
	rst 38h			;34cd
	rst 38h			;34ce
	rst 38h			;34cf
	rst 38h			;34d0
	rst 38h			;34d1
	rst 38h			;34d2
	rst 38h			;34d3
	rst 38h			;34d4
	rst 38h			;34d5
	rst 38h			;34d6
	rst 38h			;34d7
	rst 38h			;34d8
	rst 38h			;34d9
	rst 38h			;34da
	rst 38h			;34db
	rst 38h			;34dc
	rst 38h			;34dd
	rst 38h			;34de
	rst 38h			;34df
	rst 38h			;34e0
	rst 38h			;34e1
	rst 38h			;34e2
	rst 38h			;34e3
	rst 38h			;34e4
	rst 38h			;34e5
	rst 38h			;34e6
	rst 38h			;34e7
	rst 38h			;34e8
	rst 38h			;34e9
	rst 38h			;34ea
	rst 38h			;34eb
	rst 38h			;34ec
	rst 38h			;34ed
	rst 38h			;34ee
	rst 38h			;34ef
	rst 38h			;34f0
	rst 38h			;34f1
	rst 38h			;34f2
	rst 38h			;34f3
	rst 38h			;34f4
	rst 38h			;34f5
	rst 38h			;34f6
	rst 38h			;34f7
	rst 38h			;34f8
	rst 38h			;34f9
	rst 38h			;34fa
	rst 38h			;34fb
	rst 38h			;34fc
	rst 38h			;34fd
	rst 38h			;34fe
	rst 38h			;34ff
	rst 38h			;3500
	rst 38h			;3501
	rst 38h			;3502
	rst 38h			;3503
	rst 38h			;3504
	rst 38h			;3505
	rst 38h			;3506
	rst 38h			;3507
	rst 38h			;3508
	rst 38h			;3509
	rst 38h			;350a
	rst 38h			;350b
	rst 38h			;350c
	rst 38h			;350d
	rst 38h			;350e
	rst 38h			;350f
	rst 38h			;3510
	rst 38h			;3511
	rst 38h			;3512
	rst 38h			;3513
	rst 38h			;3514
	rst 38h			;3515
	rst 38h			;3516
	rst 38h			;3517
	rst 38h			;3518
	rst 38h			;3519
	rst 38h			;351a
	rst 38h			;351b
	rst 38h			;351c
	rst 38h			;351d
	rst 38h			;351e
	rst 38h			;351f
	rst 38h			;3520
	rst 38h			;3521
	rst 38h			;3522
	rst 38h			;3523
	rst 38h			;3524
	rst 38h			;3525
	rst 38h			;3526
	rst 38h			;3527
	rst 38h			;3528
	rst 38h			;3529
	rst 38h			;352a
	rst 38h			;352b
	rst 38h			;352c
	rst 38h			;352d
	rst 38h			;352e
	rst 38h			;352f
	rst 38h			;3530
	rst 38h			;3531
	rst 38h			;3532
	rst 38h			;3533
	rst 38h			;3534
	rst 38h			;3535
	rst 38h			;3536
	rst 38h			;3537
	rst 38h			;3538
	rst 38h			;3539
	rst 38h			;353a
	rst 38h			;353b
	rst 38h			;353c
	rst 38h			;353d
	rst 38h			;353e
	rst 38h			;353f
	rst 38h			;3540
	rst 38h			;3541
	rst 38h			;3542
	rst 38h			;3543
	rst 38h			;3544
	rst 38h			;3545
	rst 38h			;3546
	rst 38h			;3547
	rst 38h			;3548
	rst 38h			;3549
	rst 38h			;354a
	rst 38h			;354b
	rst 38h			;354c
	rst 38h			;354d
	rst 38h			;354e
	rst 38h			;354f
	rst 38h			;3550
	rst 38h			;3551
	rst 38h			;3552
	rst 38h			;3553
	rst 38h			;3554
	rst 38h			;3555
	rst 38h			;3556
	rst 38h			;3557
	rst 38h			;3558
	rst 38h			;3559
	rst 38h			;355a
	rst 38h			;355b
	rst 38h			;355c
	rst 38h			;355d
	rst 38h			;355e
	rst 38h			;355f
	rst 38h			;3560
	rst 38h			;3561
	rst 38h			;3562
l3563h:
	rst 38h			;3563
	rst 38h			;3564
	rst 38h			;3565
	rst 38h			;3566
	rst 38h			;3567
	rst 38h			;3568
	rst 38h			;3569
	rst 38h			;356a
	rst 38h			;356b
	rst 38h			;356c
	rst 38h			;356d
	rst 38h			;356e
	rst 38h			;356f
	rst 38h			;3570
	rst 38h			;3571
	rst 38h			;3572
	rst 38h			;3573
	rst 38h			;3574
	rst 38h			;3575
	rst 38h			;3576
	rst 38h			;3577
	rst 38h			;3578
	rst 38h			;3579
	rst 38h			;357a
	rst 38h			;357b
	rst 38h			;357c
	rst 38h			;357d
	rst 38h			;357e
	rst 38h			;357f
	rst 38h			;3580
	rst 38h			;3581
	rst 38h			;3582
	rst 38h			;3583
	rst 38h			;3584
	rst 38h			;3585
	rst 38h			;3586
	rst 38h			;3587
	rst 38h			;3588
	rst 38h			;3589
	rst 38h			;358a
	rst 38h			;358b
	rst 38h			;358c
	rst 38h			;358d
	rst 38h			;358e
	rst 38h			;358f
	rst 38h			;3590
	rst 38h			;3591
	rst 38h			;3592
	rst 38h			;3593
	rst 38h			;3594
	rst 38h			;3595
	rst 38h			;3596
	rst 38h			;3597
	rst 38h			;3598
	rst 38h			;3599
	rst 38h			;359a
	rst 38h			;359b
	rst 38h			;359c
	rst 38h			;359d
	rst 38h			;359e
	rst 38h			;359f
	rst 38h			;35a0
	rst 38h			;35a1
	rst 38h			;35a2
	rst 38h			;35a3
	rst 38h			;35a4
	rst 38h			;35a5
	rst 38h			;35a6
	rst 38h			;35a7
	rst 38h			;35a8
	rst 38h			;35a9
	rst 38h			;35aa
	rst 38h			;35ab
	rst 38h			;35ac
	rst 38h			;35ad
	rst 38h			;35ae
	rst 38h			;35af
	rst 38h			;35b0
	rst 38h			;35b1
	rst 38h			;35b2
	rst 38h			;35b3
	rst 38h			;35b4
	rst 38h			;35b5
	rst 38h			;35b6
	rst 38h			;35b7
	rst 38h			;35b8
	rst 38h			;35b9
	rst 38h			;35ba
	rst 38h			;35bb
	rst 38h			;35bc
	rst 38h			;35bd
	rst 38h			;35be
	rst 38h			;35bf
	rst 38h			;35c0
	rst 38h			;35c1
	rst 38h			;35c2
	rst 38h			;35c3
	rst 38h			;35c4
	rst 38h			;35c5
	rst 38h			;35c6
	rst 38h			;35c7
	rst 38h			;35c8
	rst 38h			;35c9
	rst 38h			;35ca
	rst 38h			;35cb
	rst 38h			;35cc
	rst 38h			;35cd
	rst 38h			;35ce
	rst 38h			;35cf
	rst 38h			;35d0
	rst 38h			;35d1
	rst 38h			;35d2
	rst 38h			;35d3
	rst 38h			;35d4
	rst 38h			;35d5
	rst 38h			;35d6
	rst 38h			;35d7
	rst 38h			;35d8
	rst 38h			;35d9
	rst 38h			;35da
	rst 38h			;35db
	rst 38h			;35dc
	rst 38h			;35dd
	rst 38h			;35de
	rst 38h			;35df
	rst 38h			;35e0
	rst 38h			;35e1
	rst 38h			;35e2
	rst 38h			;35e3
	rst 38h			;35e4
	rst 38h			;35e5
	rst 38h			;35e6
	rst 38h			;35e7
	rst 38h			;35e8
	rst 38h			;35e9
	rst 38h			;35ea
	rst 38h			;35eb
	rst 38h			;35ec
	rst 38h			;35ed
	rst 38h			;35ee
	rst 38h			;35ef
	rst 38h			;35f0
	rst 38h			;35f1
	rst 38h			;35f2
	rst 38h			;35f3
	rst 38h			;35f4
	rst 38h			;35f5
	rst 38h			;35f6
	rst 38h			;35f7
	rst 38h			;35f8
	rst 38h			;35f9
	rst 38h			;35fa
	rst 38h			;35fb
	rst 38h			;35fc
	rst 38h			;35fd
	rst 38h			;35fe
	rst 38h			;35ff
	rst 38h			;3600
	rst 38h			;3601
	rst 38h			;3602
	rst 38h			;3603
	rst 38h			;3604
	rst 38h			;3605
	rst 38h			;3606
	rst 38h			;3607
	rst 38h			;3608
	rst 38h			;3609
	rst 38h			;360a
	rst 38h			;360b
	rst 38h			;360c
	rst 38h			;360d
	rst 38h			;360e
	rst 38h			;360f
	rst 38h			;3610
	rst 38h			;3611
	rst 38h			;3612
	rst 38h			;3613
	rst 38h			;3614
	rst 38h			;3615
	rst 38h			;3616
	rst 38h			;3617
	rst 38h			;3618
	rst 38h			;3619
	rst 38h			;361a
	rst 38h			;361b
	rst 38h			;361c
	rst 38h			;361d
	rst 38h			;361e
	rst 38h			;361f
	rst 38h			;3620
	rst 38h			;3621
	rst 38h			;3622
	rst 38h			;3623
	rst 38h			;3624
	rst 38h			;3625
	rst 38h			;3626
	rst 38h			;3627
	rst 38h			;3628
	rst 38h			;3629
	rst 38h			;362a
	rst 38h			;362b
	rst 38h			;362c
	rst 38h			;362d
	rst 38h			;362e
	rst 38h			;362f
	rst 38h			;3630
	rst 38h			;3631
	rst 38h			;3632
	rst 38h			;3633
	rst 38h			;3634
	rst 38h			;3635
	rst 38h			;3636
	rst 38h			;3637
	rst 38h			;3638
	rst 38h			;3639
	rst 38h			;363a
	rst 38h			;363b
	rst 38h			;363c
	rst 38h			;363d
	rst 38h			;363e
	rst 38h			;363f
	rst 38h			;3640
	rst 38h			;3641
	rst 38h			;3642
	rst 38h			;3643
	rst 38h			;3644
	rst 38h			;3645
	rst 38h			;3646
	rst 38h			;3647
	rst 38h			;3648
	rst 38h			;3649
	rst 38h			;364a
	rst 38h			;364b
	rst 38h			;364c
	rst 38h			;364d
	rst 38h			;364e
	rst 38h			;364f
	rst 38h			;3650
	rst 38h			;3651
	rst 38h			;3652
	rst 38h			;3653
	rst 38h			;3654
	rst 38h			;3655
l3656h:
	rst 38h			;3656
	rst 38h			;3657
	rst 38h			;3658
	rst 38h			;3659
	rst 38h			;365a
	rst 38h			;365b
	rst 38h			;365c
	rst 38h			;365d
	rst 38h			;365e
	rst 38h			;365f
	rst 38h			;3660
	rst 38h			;3661
	rst 38h			;3662
	rst 38h			;3663
	rst 38h			;3664
	rst 38h			;3665
	rst 38h			;3666
	rst 38h			;3667
	rst 38h			;3668
	rst 38h			;3669
	rst 38h			;366a
	rst 38h			;366b
	rst 38h			;366c
	rst 38h			;366d
	rst 38h			;366e
	rst 38h			;366f
	rst 38h			;3670
	rst 38h			;3671
	rst 38h			;3672
	rst 38h			;3673
	rst 38h			;3674
	rst 38h			;3675
	rst 38h			;3676
	rst 38h			;3677
	rst 38h			;3678
	rst 38h			;3679
	rst 38h			;367a
	rst 38h			;367b
	rst 38h			;367c
	rst 38h			;367d
	rst 38h			;367e
	rst 38h			;367f
	rst 38h			;3680
	rst 38h			;3681
	rst 38h			;3682
	rst 38h			;3683
	rst 38h			;3684
	rst 38h			;3685
	rst 38h			;3686
	rst 38h			;3687
	rst 38h			;3688
	rst 38h			;3689
	rst 38h			;368a
	rst 38h			;368b
	rst 38h			;368c
	rst 38h			;368d
	rst 38h			;368e
	rst 38h			;368f
	rst 38h			;3690
	rst 38h			;3691
	rst 38h			;3692
	rst 38h			;3693
	rst 38h			;3694
	rst 38h			;3695
	rst 38h			;3696
	rst 38h			;3697
	rst 38h			;3698
	rst 38h			;3699
	rst 38h			;369a
	rst 38h			;369b
	rst 38h			;369c
	rst 38h			;369d
	rst 38h			;369e
	rst 38h			;369f
	rst 38h			;36a0
	rst 38h			;36a1
	rst 38h			;36a2
	rst 38h			;36a3
	rst 38h			;36a4
	rst 38h			;36a5
	rst 38h			;36a6
	rst 38h			;36a7
	rst 38h			;36a8
	rst 38h			;36a9
	rst 38h			;36aa
	rst 38h			;36ab
	rst 38h			;36ac
	rst 38h			;36ad
	rst 38h			;36ae
	rst 38h			;36af
	rst 38h			;36b0
	rst 38h			;36b1
	rst 38h			;36b2
	rst 38h			;36b3
	rst 38h			;36b4
	rst 38h			;36b5
	rst 38h			;36b6
	rst 38h			;36b7
	rst 38h			;36b8
	rst 38h			;36b9
	rst 38h			;36ba
	rst 38h			;36bb
	rst 38h			;36bc
	rst 38h			;36bd
	rst 38h			;36be
	rst 38h			;36bf
	rst 38h			;36c0
	rst 38h			;36c1
	rst 38h			;36c2
	rst 38h			;36c3
	rst 38h			;36c4
	rst 38h			;36c5
	rst 38h			;36c6
	rst 38h			;36c7
	rst 38h			;36c8
	rst 38h			;36c9
	rst 38h			;36ca
	rst 38h			;36cb
	rst 38h			;36cc
	rst 38h			;36cd
	rst 38h			;36ce
	rst 38h			;36cf
	rst 38h			;36d0
	rst 38h			;36d1
	rst 38h			;36d2
	rst 38h			;36d3
	rst 38h			;36d4
	rst 38h			;36d5
	rst 38h			;36d6
	rst 38h			;36d7
	rst 38h			;36d8
	rst 38h			;36d9
	rst 38h			;36da
	rst 38h			;36db
	rst 38h			;36dc
	rst 38h			;36dd
	rst 38h			;36de
	rst 38h			;36df
	rst 38h			;36e0
	rst 38h			;36e1
	rst 38h			;36e2
	rst 38h			;36e3
	rst 38h			;36e4
	rst 38h			;36e5
	rst 38h			;36e6
	rst 38h			;36e7
	rst 38h			;36e8
	rst 38h			;36e9
	rst 38h			;36ea
	rst 38h			;36eb
	rst 38h			;36ec
	rst 38h			;36ed
	rst 38h			;36ee
	rst 38h			;36ef
	rst 38h			;36f0
	rst 38h			;36f1
	rst 38h			;36f2
	rst 38h			;36f3
	rst 38h			;36f4
	rst 38h			;36f5
	rst 38h			;36f6
	rst 38h			;36f7
	rst 38h			;36f8
	rst 38h			;36f9
	rst 38h			;36fa
	rst 38h			;36fb
	rst 38h			;36fc
	rst 38h			;36fd
	rst 38h			;36fe
	rst 38h			;36ff
	rst 38h			;3700
	rst 38h			;3701
	rst 38h			;3702
	rst 38h			;3703
	rst 38h			;3704
	rst 38h			;3705
	rst 38h			;3706
	rst 38h			;3707
	rst 38h			;3708
	rst 38h			;3709
	rst 38h			;370a
	rst 38h			;370b
	rst 38h			;370c
	rst 38h			;370d
	rst 38h			;370e
	rst 38h			;370f
	rst 38h			;3710
	rst 38h			;3711
	rst 38h			;3712
	rst 38h			;3713
	rst 38h			;3714
	rst 38h			;3715
	rst 38h			;3716
	rst 38h			;3717
	rst 38h			;3718
	rst 38h			;3719
	rst 38h			;371a
	rst 38h			;371b
	rst 38h			;371c
	rst 38h			;371d
	rst 38h			;371e
	rst 38h			;371f
	rst 38h			;3720
	rst 38h			;3721
	rst 38h			;3722
	rst 38h			;3723
	rst 38h			;3724
	rst 38h			;3725
	rst 38h			;3726
	rst 38h			;3727
	rst 38h			;3728
	rst 38h			;3729
	rst 38h			;372a
	rst 38h			;372b
	rst 38h			;372c
	rst 38h			;372d
	rst 38h			;372e
	rst 38h			;372f
	rst 38h			;3730
	rst 38h			;3731
	rst 38h			;3732
	rst 38h			;3733
	rst 38h			;3734
	rst 38h			;3735
	rst 38h			;3736
	rst 38h			;3737
	rst 38h			;3738
	rst 38h			;3739
	rst 38h			;373a
	rst 38h			;373b
	rst 38h			;373c
	rst 38h			;373d
	rst 38h			;373e
	rst 38h			;373f
	rst 38h			;3740
	rst 38h			;3741
	rst 38h			;3742
	rst 38h			;3743
	rst 38h			;3744
	rst 38h			;3745
	rst 38h			;3746
	rst 38h			;3747
	rst 38h			;3748
	rst 38h			;3749
	rst 38h			;374a
	rst 38h			;374b
	rst 38h			;374c
	rst 38h			;374d
	rst 38h			;374e
	rst 38h			;374f
	rst 38h			;3750
	rst 38h			;3751
	rst 38h			;3752
	rst 38h			;3753
	rst 38h			;3754
	rst 38h			;3755
	rst 38h			;3756
	rst 38h			;3757
	rst 38h			;3758
	rst 38h			;3759
	rst 38h			;375a
	rst 38h			;375b
	rst 38h			;375c
	rst 38h			;375d
	rst 38h			;375e
	rst 38h			;375f
	rst 38h			;3760
	rst 38h			;3761
	rst 38h			;3762
	rst 38h			;3763
	rst 38h			;3764
	rst 38h			;3765
	rst 38h			;3766
	rst 38h			;3767
	rst 38h			;3768
	rst 38h			;3769
	rst 38h			;376a
	rst 38h			;376b
	rst 38h			;376c
	rst 38h			;376d
	rst 38h			;376e
	rst 38h			;376f
	rst 38h			;3770
	rst 38h			;3771
	rst 38h			;3772
	rst 38h			;3773
	rst 38h			;3774
	rst 38h			;3775
	rst 38h			;3776
	rst 38h			;3777
	rst 38h			;3778
	rst 38h			;3779
	rst 38h			;377a
	rst 38h			;377b
	rst 38h			;377c
	rst 38h			;377d
	rst 38h			;377e
	rst 38h			;377f
	rst 38h			;3780
	rst 38h			;3781
	rst 38h			;3782
	rst 38h			;3783
	rst 38h			;3784
	rst 38h			;3785
	rst 38h			;3786
	rst 38h			;3787
	rst 38h			;3788
	rst 38h			;3789
	rst 38h			;378a
	rst 38h			;378b
	rst 38h			;378c
	rst 38h			;378d
	rst 38h			;378e
	rst 38h			;378f
	rst 38h			;3790
	rst 38h			;3791
	rst 38h			;3792
	rst 38h			;3793
	rst 38h			;3794
	rst 38h			;3795
	rst 38h			;3796
	rst 38h			;3797
	rst 38h			;3798
	rst 38h			;3799
	rst 38h			;379a
	rst 38h			;379b
	rst 38h			;379c
	rst 38h			;379d
	rst 38h			;379e
	rst 38h			;379f
	rst 38h			;37a0
	rst 38h			;37a1
	rst 38h			;37a2
	rst 38h			;37a3
	rst 38h			;37a4
	rst 38h			;37a5
	rst 38h			;37a6
	rst 38h			;37a7
	rst 38h			;37a8
	rst 38h			;37a9
	rst 38h			;37aa
	rst 38h			;37ab
	rst 38h			;37ac
	rst 38h			;37ad
	rst 38h			;37ae
	rst 38h			;37af
	rst 38h			;37b0
	rst 38h			;37b1
	rst 38h			;37b2
	rst 38h			;37b3
	rst 38h			;37b4
	rst 38h			;37b5
	rst 38h			;37b6
	rst 38h			;37b7
	rst 38h			;37b8
	rst 38h			;37b9
	rst 38h			;37ba
	rst 38h			;37bb
	rst 38h			;37bc
	rst 38h			;37bd
	rst 38h			;37be
	rst 38h			;37bf
	rst 38h			;37c0
	rst 38h			;37c1
	rst 38h			;37c2
	rst 38h			;37c3
	rst 38h			;37c4
	rst 38h			;37c5
	rst 38h			;37c6
	rst 38h			;37c7
	rst 38h			;37c8
	rst 38h			;37c9
	rst 38h			;37ca
	rst 38h			;37cb
	rst 38h			;37cc
	rst 38h			;37cd
	rst 38h			;37ce
	rst 38h			;37cf
	rst 38h			;37d0
	rst 38h			;37d1
	rst 38h			;37d2
	rst 38h			;37d3
	rst 38h			;37d4
	rst 38h			;37d5
	rst 38h			;37d6
	rst 38h			;37d7
	rst 38h			;37d8
	rst 38h			;37d9
	rst 38h			;37da
	rst 38h			;37db
	rst 38h			;37dc
	rst 38h			;37dd
	rst 38h			;37de
	rst 38h			;37df
	rst 38h			;37e0
	rst 38h			;37e1
	rst 38h			;37e2
	rst 38h			;37e3
	rst 38h			;37e4
	rst 38h			;37e5
	rst 38h			;37e6
	rst 38h			;37e7
	rst 38h			;37e8
	rst 38h			;37e9
	rst 38h			;37ea
	rst 38h			;37eb
	rst 38h			;37ec
	rst 38h			;37ed
	rst 38h			;37ee
	rst 38h			;37ef
	rst 38h			;37f0
	rst 38h			;37f1
	rst 38h			;37f2
	rst 38h			;37f3
	rst 38h			;37f4
	rst 38h			;37f5
	rst 38h			;37f6
	rst 38h			;37f7
	rst 38h			;37f8
	rst 38h			;37f9
	rst 38h			;37fa
	rst 38h			;37fb
	rst 38h			;37fc
	rst 38h			;37fd
	rst 38h			;37fe
	rst 38h			;37ff
	rst 38h			;3800
	rst 38h			;3801
	rst 38h			;3802
	rst 38h			;3803
	rst 38h			;3804
	rst 38h			;3805
	rst 38h			;3806
	rst 38h			;3807
	rst 38h			;3808
	rst 38h			;3809
	rst 38h			;380a
	rst 38h			;380b
	rst 38h			;380c
	rst 38h			;380d
	rst 38h			;380e
	rst 38h			;380f
	rst 38h			;3810
	rst 38h			;3811
	rst 38h			;3812
	rst 38h			;3813
	rst 38h			;3814
	rst 38h			;3815
	rst 38h			;3816
	rst 38h			;3817
	rst 38h			;3818
	rst 38h			;3819
	rst 38h			;381a
	rst 38h			;381b
	rst 38h			;381c
	rst 38h			;381d
	rst 38h			;381e
	rst 38h			;381f
	rst 38h			;3820
	rst 38h			;3821
	rst 38h			;3822
	rst 38h			;3823
	rst 38h			;3824
	rst 38h			;3825
	rst 38h			;3826
	rst 38h			;3827
	rst 38h			;3828
	rst 38h			;3829
	rst 38h			;382a
	rst 38h			;382b
	rst 38h			;382c
	rst 38h			;382d
	rst 38h			;382e
	rst 38h			;382f
	rst 38h			;3830
	rst 38h			;3831
	rst 38h			;3832
	rst 38h			;3833
	rst 38h			;3834
	rst 38h			;3835
	rst 38h			;3836
	rst 38h			;3837
	rst 38h			;3838
	rst 38h			;3839
	rst 38h			;383a
	rst 38h			;383b
	rst 38h			;383c
	rst 38h			;383d
	rst 38h			;383e
	rst 38h			;383f
	rst 38h			;3840
	rst 38h			;3841
	rst 38h			;3842
	rst 38h			;3843
	rst 38h			;3844
	rst 38h			;3845
	rst 38h			;3846
	rst 38h			;3847
	rst 38h			;3848
	rst 38h			;3849
	rst 38h			;384a
	rst 38h			;384b
	rst 38h			;384c
	rst 38h			;384d
	rst 38h			;384e
	rst 38h			;384f
	rst 38h			;3850
	rst 38h			;3851
	rst 38h			;3852
	rst 38h			;3853
	rst 38h			;3854
	rst 38h			;3855
	rst 38h			;3856
	rst 38h			;3857
	rst 38h			;3858
	rst 38h			;3859
	rst 38h			;385a
	rst 38h			;385b
	rst 38h			;385c
	rst 38h			;385d
	rst 38h			;385e
	rst 38h			;385f
	rst 38h			;3860
	rst 38h			;3861
	rst 38h			;3862
	rst 38h			;3863
	rst 38h			;3864
	rst 38h			;3865
	rst 38h			;3866
	rst 38h			;3867
	rst 38h			;3868
	rst 38h			;3869
	rst 38h			;386a
	rst 38h			;386b
	rst 38h			;386c
	rst 38h			;386d
	rst 38h			;386e
	rst 38h			;386f
	rst 38h			;3870
	rst 38h			;3871
	rst 38h			;3872
	rst 38h			;3873
	rst 38h			;3874
	rst 38h			;3875
	rst 38h			;3876
	rst 38h			;3877
	rst 38h			;3878
	rst 38h			;3879
	rst 38h			;387a
	rst 38h			;387b
	rst 38h			;387c
	rst 38h			;387d
	rst 38h			;387e
	rst 38h			;387f
	rst 38h			;3880
	rst 38h			;3881
	rst 38h			;3882
	rst 38h			;3883
	rst 38h			;3884
	rst 38h			;3885
	rst 38h			;3886
	rst 38h			;3887
	rst 38h			;3888
	rst 38h			;3889
	rst 38h			;388a
	rst 38h			;388b
	rst 38h			;388c
	rst 38h			;388d
	rst 38h			;388e
	rst 38h			;388f
	rst 38h			;3890
	rst 38h			;3891
	rst 38h			;3892
	rst 38h			;3893
	rst 38h			;3894
	rst 38h			;3895
	rst 38h			;3896
	rst 38h			;3897
	rst 38h			;3898
	rst 38h			;3899
	rst 38h			;389a
	rst 38h			;389b
	rst 38h			;389c
	rst 38h			;389d
	rst 38h			;389e
	rst 38h			;389f
	rst 38h			;38a0
	rst 38h			;38a1
	rst 38h			;38a2
	rst 38h			;38a3
	rst 38h			;38a4
	rst 38h			;38a5
	rst 38h			;38a6
	rst 38h			;38a7
	rst 38h			;38a8
	rst 38h			;38a9
	rst 38h			;38aa
	rst 38h			;38ab
	rst 38h			;38ac
	rst 38h			;38ad
	rst 38h			;38ae
	rst 38h			;38af
	rst 38h			;38b0
	rst 38h			;38b1
	rst 38h			;38b2
	rst 38h			;38b3
	rst 38h			;38b4
	rst 38h			;38b5
	rst 38h			;38b6
	rst 38h			;38b7
	rst 38h			;38b8
	rst 38h			;38b9
	rst 38h			;38ba
	rst 38h			;38bb
	rst 38h			;38bc
	rst 38h			;38bd
	rst 38h			;38be
	rst 38h			;38bf
	rst 38h			;38c0
	rst 38h			;38c1
	rst 38h			;38c2
	rst 38h			;38c3
	rst 38h			;38c4
	rst 38h			;38c5
	rst 38h			;38c6
	rst 38h			;38c7
	rst 38h			;38c8
	rst 38h			;38c9
	rst 38h			;38ca
	rst 38h			;38cb
	rst 38h			;38cc
	rst 38h			;38cd
	rst 38h			;38ce
	rst 38h			;38cf
	rst 38h			;38d0
	rst 38h			;38d1
	rst 38h			;38d2
	rst 38h			;38d3
	rst 38h			;38d4
	rst 38h			;38d5
	rst 38h			;38d6
	rst 38h			;38d7
	rst 38h			;38d8
	rst 38h			;38d9
	rst 38h			;38da
	rst 38h			;38db
	rst 38h			;38dc
	rst 38h			;38dd
	rst 38h			;38de
	rst 38h			;38df
	rst 38h			;38e0
	rst 38h			;38e1
	rst 38h			;38e2
	rst 38h			;38e3
	rst 38h			;38e4
	rst 38h			;38e5
	rst 38h			;38e6
	rst 38h			;38e7
	rst 38h			;38e8
	rst 38h			;38e9
	rst 38h			;38ea
	rst 38h			;38eb
	rst 38h			;38ec
	rst 38h			;38ed
	rst 38h			;38ee
	rst 38h			;38ef
	rst 38h			;38f0
	rst 38h			;38f1
	rst 38h			;38f2
	rst 38h			;38f3
	rst 38h			;38f4
	rst 38h			;38f5
	rst 38h			;38f6
	rst 38h			;38f7
	rst 38h			;38f8
	rst 38h			;38f9
	rst 38h			;38fa
	rst 38h			;38fb
	rst 38h			;38fc
	rst 38h			;38fd
	rst 38h			;38fe
	rst 38h			;38ff
	rst 38h			;3900
	rst 38h			;3901
	rst 38h			;3902
	rst 38h			;3903
	rst 38h			;3904
	rst 38h			;3905
	rst 38h			;3906
	rst 38h			;3907
	rst 38h			;3908
	rst 38h			;3909
	rst 38h			;390a
	rst 38h			;390b
	rst 38h			;390c
	rst 38h			;390d
	rst 38h			;390e
	rst 38h			;390f
	rst 38h			;3910
	rst 38h			;3911
	rst 38h			;3912
	rst 38h			;3913
	rst 38h			;3914
	rst 38h			;3915
	rst 38h			;3916
	rst 38h			;3917
	rst 38h			;3918
	rst 38h			;3919
	rst 38h			;391a
	rst 38h			;391b
	rst 38h			;391c
	rst 38h			;391d
	rst 38h			;391e
	rst 38h			;391f
	rst 38h			;3920
	rst 38h			;3921
	rst 38h			;3922
	rst 38h			;3923
	rst 38h			;3924
	rst 38h			;3925
	rst 38h			;3926
	rst 38h			;3927
	rst 38h			;3928
	rst 38h			;3929
	rst 38h			;392a
	rst 38h			;392b
	rst 38h			;392c
	rst 38h			;392d
	rst 38h			;392e
	rst 38h			;392f
	rst 38h			;3930
	rst 38h			;3931
	rst 38h			;3932
	rst 38h			;3933
	rst 38h			;3934
	rst 38h			;3935
	rst 38h			;3936
	rst 38h			;3937
	rst 38h			;3938
	rst 38h			;3939
	rst 38h			;393a
	rst 38h			;393b
	rst 38h			;393c
	rst 38h			;393d
	rst 38h			;393e
	rst 38h			;393f
	rst 38h			;3940
	rst 38h			;3941
	rst 38h			;3942
	rst 38h			;3943
	rst 38h			;3944
	rst 38h			;3945
	rst 38h			;3946
	rst 38h			;3947
	rst 38h			;3948
	rst 38h			;3949
	rst 38h			;394a
	rst 38h			;394b
	rst 38h			;394c
	rst 38h			;394d
	rst 38h			;394e
	rst 38h			;394f
	rst 38h			;3950
	rst 38h			;3951
	rst 38h			;3952
	rst 38h			;3953
	rst 38h			;3954
	rst 38h			;3955
	rst 38h			;3956
	rst 38h			;3957
	rst 38h			;3958
	rst 38h			;3959
	rst 38h			;395a
	rst 38h			;395b
	rst 38h			;395c
	rst 38h			;395d
	rst 38h			;395e
	rst 38h			;395f
	rst 38h			;3960
	rst 38h			;3961
	rst 38h			;3962
	rst 38h			;3963
	rst 38h			;3964
	rst 38h			;3965
	rst 38h			;3966
	rst 38h			;3967
	rst 38h			;3968
	rst 38h			;3969
	rst 38h			;396a
	rst 38h			;396b
	rst 38h			;396c
	rst 38h			;396d
	rst 38h			;396e
	rst 38h			;396f
	rst 38h			;3970
	rst 38h			;3971
	rst 38h			;3972
	rst 38h			;3973
	rst 38h			;3974
	rst 38h			;3975
	rst 38h			;3976
	rst 38h			;3977
	rst 38h			;3978
	rst 38h			;3979
	rst 38h			;397a
	rst 38h			;397b
	rst 38h			;397c
	rst 38h			;397d
	rst 38h			;397e
	rst 38h			;397f
	rst 38h			;3980
	rst 38h			;3981
	rst 38h			;3982
	rst 38h			;3983
	rst 38h			;3984
	rst 38h			;3985
	rst 38h			;3986
	rst 38h			;3987
	rst 38h			;3988
	rst 38h			;3989
	rst 38h			;398a
	rst 38h			;398b
	rst 38h			;398c
	rst 38h			;398d
	rst 38h			;398e
	rst 38h			;398f
	rst 38h			;3990
	rst 38h			;3991
	rst 38h			;3992
	rst 38h			;3993
	rst 38h			;3994
	rst 38h			;3995
	rst 38h			;3996
	rst 38h			;3997
	rst 38h			;3998
	rst 38h			;3999
	rst 38h			;399a
	rst 38h			;399b
	rst 38h			;399c
	rst 38h			;399d
	rst 38h			;399e
	rst 38h			;399f
	rst 38h			;39a0
	rst 38h			;39a1
	rst 38h			;39a2
	rst 38h			;39a3
	rst 38h			;39a4
	rst 38h			;39a5
	rst 38h			;39a6
	rst 38h			;39a7
	rst 38h			;39a8
	rst 38h			;39a9
	rst 38h			;39aa
	rst 38h			;39ab
	rst 38h			;39ac
	rst 38h			;39ad
	rst 38h			;39ae
	rst 38h			;39af
	rst 38h			;39b0
	rst 38h			;39b1
	rst 38h			;39b2
	rst 38h			;39b3
	rst 38h			;39b4
	rst 38h			;39b5
	rst 38h			;39b6
	rst 38h			;39b7
	rst 38h			;39b8
	rst 38h			;39b9
	rst 38h			;39ba
	rst 38h			;39bb
	rst 38h			;39bc
	rst 38h			;39bd
	rst 38h			;39be
	rst 38h			;39bf
	rst 38h			;39c0
	rst 38h			;39c1
	rst 38h			;39c2
	rst 38h			;39c3
	rst 38h			;39c4
	rst 38h			;39c5
	rst 38h			;39c6
	rst 38h			;39c7
	rst 38h			;39c8
	rst 38h			;39c9
	rst 38h			;39ca
	rst 38h			;39cb
	rst 38h			;39cc
	rst 38h			;39cd
	rst 38h			;39ce
	rst 38h			;39cf
	rst 38h			;39d0
	rst 38h			;39d1
	rst 38h			;39d2
	rst 38h			;39d3
	rst 38h			;39d4
	rst 38h			;39d5
	rst 38h			;39d6
	rst 38h			;39d7
	rst 38h			;39d8
	rst 38h			;39d9
	rst 38h			;39da
	rst 38h			;39db
	rst 38h			;39dc
	rst 38h			;39dd
	rst 38h			;39de
	rst 38h			;39df
	rst 38h			;39e0
	rst 38h			;39e1
	rst 38h			;39e2
	rst 38h			;39e3
	rst 38h			;39e4
	rst 38h			;39e5
	rst 38h			;39e6
	rst 38h			;39e7
	rst 38h			;39e8
	rst 38h			;39e9
	rst 38h			;39ea
	rst 38h			;39eb
	rst 38h			;39ec
	rst 38h			;39ed
	rst 38h			;39ee
	rst 38h			;39ef
	rst 38h			;39f0
	rst 38h			;39f1
	rst 38h			;39f2
	rst 38h			;39f3
	rst 38h			;39f4
	rst 38h			;39f5
	rst 38h			;39f6
	rst 38h			;39f7
	rst 38h			;39f8
	rst 38h			;39f9
	rst 38h			;39fa
	rst 38h			;39fb
	rst 38h			;39fc
	rst 38h			;39fd
	rst 38h			;39fe
	rst 38h			;39ff
	rst 38h			;3a00
	rst 38h			;3a01
	rst 38h			;3a02
	rst 38h			;3a03
	rst 38h			;3a04
	rst 38h			;3a05
	rst 38h			;3a06
	rst 38h			;3a07
	rst 38h			;3a08
	rst 38h			;3a09
	rst 38h			;3a0a
	rst 38h			;3a0b
	rst 38h			;3a0c
	rst 38h			;3a0d
	rst 38h			;3a0e
	rst 38h			;3a0f
	rst 38h			;3a10
	rst 38h			;3a11
	rst 38h			;3a12
	rst 38h			;3a13
	rst 38h			;3a14
	rst 38h			;3a15
	rst 38h			;3a16
	rst 38h			;3a17
	rst 38h			;3a18
	rst 38h			;3a19
	rst 38h			;3a1a
	rst 38h			;3a1b
	rst 38h			;3a1c
	rst 38h			;3a1d
	rst 38h			;3a1e
	rst 38h			;3a1f
	rst 38h			;3a20
	rst 38h			;3a21
	rst 38h			;3a22
	rst 38h			;3a23
	rst 38h			;3a24
	rst 38h			;3a25
	rst 38h			;3a26
	rst 38h			;3a27
	rst 38h			;3a28
	rst 38h			;3a29
	rst 38h			;3a2a
	rst 38h			;3a2b
	rst 38h			;3a2c
	rst 38h			;3a2d
	rst 38h			;3a2e
	rst 38h			;3a2f
	rst 38h			;3a30
	rst 38h			;3a31
	rst 38h			;3a32
	rst 38h			;3a33
	rst 38h			;3a34
	rst 38h			;3a35
	rst 38h			;3a36
	rst 38h			;3a37
	rst 38h			;3a38
	rst 38h			;3a39
	rst 38h			;3a3a
	rst 38h			;3a3b
	rst 38h			;3a3c
	rst 38h			;3a3d
	rst 38h			;3a3e
	rst 38h			;3a3f
	rst 38h			;3a40
	rst 38h			;3a41
	rst 38h			;3a42
	rst 38h			;3a43
	rst 38h			;3a44
	rst 38h			;3a45
	rst 38h			;3a46
	rst 38h			;3a47
	rst 38h			;3a48
	rst 38h			;3a49
	rst 38h			;3a4a
	rst 38h			;3a4b
	rst 38h			;3a4c
	rst 38h			;3a4d
	rst 38h			;3a4e
	rst 38h			;3a4f
	rst 38h			;3a50
	rst 38h			;3a51
	rst 38h			;3a52
	rst 38h			;3a53
	rst 38h			;3a54
	rst 38h			;3a55
	rst 38h			;3a56
	rst 38h			;3a57
	rst 38h			;3a58
	rst 38h			;3a59
	rst 38h			;3a5a
	rst 38h			;3a5b
	rst 38h			;3a5c
	rst 38h			;3a5d
	rst 38h			;3a5e
	rst 38h			;3a5f
	rst 38h			;3a60
	rst 38h			;3a61
	rst 38h			;3a62
	rst 38h			;3a63
	rst 38h			;3a64
l3a65h:
	rst 38h			;3a65
	rst 38h			;3a66
	rst 38h			;3a67
	rst 38h			;3a68
	rst 38h			;3a69
	rst 38h			;3a6a
	rst 38h			;3a6b
	rst 38h			;3a6c
	rst 38h			;3a6d
	rst 38h			;3a6e
	rst 38h			;3a6f
	rst 38h			;3a70
	rst 38h			;3a71
	rst 38h			;3a72
	rst 38h			;3a73
	rst 38h			;3a74
	rst 38h			;3a75
	rst 38h			;3a76
	rst 38h			;3a77
	rst 38h			;3a78
	rst 38h			;3a79
	rst 38h			;3a7a
	rst 38h			;3a7b
	rst 38h			;3a7c
	rst 38h			;3a7d
	rst 38h			;3a7e
	rst 38h			;3a7f
	rst 38h			;3a80
	rst 38h			;3a81
	rst 38h			;3a82
	rst 38h			;3a83
	rst 38h			;3a84
	rst 38h			;3a85
	rst 38h			;3a86
	rst 38h			;3a87
	rst 38h			;3a88
	rst 38h			;3a89
	rst 38h			;3a8a
	rst 38h			;3a8b
	rst 38h			;3a8c
	rst 38h			;3a8d
	rst 38h			;3a8e
	rst 38h			;3a8f
	rst 38h			;3a90
	rst 38h			;3a91
	rst 38h			;3a92
	rst 38h			;3a93
	rst 38h			;3a94
	rst 38h			;3a95
	rst 38h			;3a96
	rst 38h			;3a97
	rst 38h			;3a98
	rst 38h			;3a99
	rst 38h			;3a9a
	rst 38h			;3a9b
	rst 38h			;3a9c
	rst 38h			;3a9d
	rst 38h			;3a9e
	rst 38h			;3a9f
	rst 38h			;3aa0
	rst 38h			;3aa1
	rst 38h			;3aa2
	rst 38h			;3aa3
	rst 38h			;3aa4
	rst 38h			;3aa5
	rst 38h			;3aa6
	rst 38h			;3aa7
	rst 38h			;3aa8
	rst 38h			;3aa9
	rst 38h			;3aaa
	rst 38h			;3aab
	rst 38h			;3aac
	rst 38h			;3aad
	rst 38h			;3aae
	rst 38h			;3aaf
	rst 38h			;3ab0
	rst 38h			;3ab1
	rst 38h			;3ab2
	rst 38h			;3ab3
	rst 38h			;3ab4
	rst 38h			;3ab5
	rst 38h			;3ab6
	rst 38h			;3ab7
	rst 38h			;3ab8
	rst 38h			;3ab9
	rst 38h			;3aba
	rst 38h			;3abb
	rst 38h			;3abc
	rst 38h			;3abd
	rst 38h			;3abe
	rst 38h			;3abf
	rst 38h			;3ac0
	rst 38h			;3ac1
	rst 38h			;3ac2
	rst 38h			;3ac3
	rst 38h			;3ac4
	rst 38h			;3ac5
	rst 38h			;3ac6
	rst 38h			;3ac7
	rst 38h			;3ac8
	rst 38h			;3ac9
l3acah:
	rst 38h			;3aca
	rst 38h			;3acb
	rst 38h			;3acc
	rst 38h			;3acd
	rst 38h			;3ace
	rst 38h			;3acf
	rst 38h			;3ad0
	rst 38h			;3ad1
	rst 38h			;3ad2
	rst 38h			;3ad3
	rst 38h			;3ad4
	rst 38h			;3ad5
	rst 38h			;3ad6
	rst 38h			;3ad7
	rst 38h			;3ad8
	rst 38h			;3ad9
	rst 38h			;3ada
	rst 38h			;3adb
	rst 38h			;3adc
	rst 38h			;3add
	rst 38h			;3ade
	rst 38h			;3adf
	rst 38h			;3ae0
	rst 38h			;3ae1
	rst 38h			;3ae2
	rst 38h			;3ae3
	rst 38h			;3ae4
	rst 38h			;3ae5
	rst 38h			;3ae6
	rst 38h			;3ae7
	rst 38h			;3ae8
	rst 38h			;3ae9
	rst 38h			;3aea
	rst 38h			;3aeb
	rst 38h			;3aec
	rst 38h			;3aed
	rst 38h			;3aee
	rst 38h			;3aef
	rst 38h			;3af0
	rst 38h			;3af1
	rst 38h			;3af2
	rst 38h			;3af3
	rst 38h			;3af4
	rst 38h			;3af5
	rst 38h			;3af6
	rst 38h			;3af7
	rst 38h			;3af8
	rst 38h			;3af9
	rst 38h			;3afa
	rst 38h			;3afb
	rst 38h			;3afc
	rst 38h			;3afd
	rst 38h			;3afe
	rst 38h			;3aff
l3b00h:
	rst 38h			;3b00
	rst 38h			;3b01
	rst 38h			;3b02
	rst 38h			;3b03
	rst 38h			;3b04
	rst 38h			;3b05
	rst 38h			;3b06
	rst 38h			;3b07
	rst 38h			;3b08
	rst 38h			;3b09
	rst 38h			;3b0a
	rst 38h			;3b0b
	rst 38h			;3b0c
	rst 38h			;3b0d
l3b0eh:
	rst 38h			;3b0e
	rst 38h			;3b0f
	rst 38h			;3b10
	rst 38h			;3b11
	rst 38h			;3b12
	rst 38h			;3b13
	rst 38h			;3b14
	rst 38h			;3b15
	rst 38h			;3b16
	rst 38h			;3b17
	rst 38h			;3b18
	rst 38h			;3b19
	rst 38h			;3b1a
	rst 38h			;3b1b
	rst 38h			;3b1c
	rst 38h			;3b1d
	rst 38h			;3b1e
	rst 38h			;3b1f
	rst 38h			;3b20
	rst 38h			;3b21
	rst 38h			;3b22
	rst 38h			;3b23
	rst 38h			;3b24
	rst 38h			;3b25
	rst 38h			;3b26
	rst 38h			;3b27
	rst 38h			;3b28
	rst 38h			;3b29
	rst 38h			;3b2a
	rst 38h			;3b2b
	rst 38h			;3b2c
	rst 38h			;3b2d
	rst 38h			;3b2e
	rst 38h			;3b2f
	rst 38h			;3b30
	rst 38h			;3b31
	rst 38h			;3b32
	rst 38h			;3b33
	rst 38h			;3b34
	rst 38h			;3b35
	rst 38h			;3b36
	rst 38h			;3b37
	rst 38h			;3b38
	rst 38h			;3b39
	rst 38h			;3b3a
	rst 38h			;3b3b
	rst 38h			;3b3c
	rst 38h			;3b3d
	rst 38h			;3b3e
	rst 38h			;3b3f
	rst 38h			;3b40
	rst 38h			;3b41
	rst 38h			;3b42
	rst 38h			;3b43
	rst 38h			;3b44
	rst 38h			;3b45
	rst 38h			;3b46
	rst 38h			;3b47
	rst 38h			;3b48
	rst 38h			;3b49
	rst 38h			;3b4a
	rst 38h			;3b4b
	rst 38h			;3b4c
	rst 38h			;3b4d
	rst 38h			;3b4e
	rst 38h			;3b4f
	rst 38h			;3b50
	rst 38h			;3b51
	rst 38h			;3b52
	rst 38h			;3b53
	rst 38h			;3b54
	rst 38h			;3b55
	rst 38h			;3b56
	rst 38h			;3b57
	rst 38h			;3b58
	rst 38h			;3b59
	rst 38h			;3b5a
	rst 38h			;3b5b
	rst 38h			;3b5c
	rst 38h			;3b5d
	rst 38h			;3b5e
	rst 38h			;3b5f
	rst 38h			;3b60
	rst 38h			;3b61
	rst 38h			;3b62
	rst 38h			;3b63
	rst 38h			;3b64
	rst 38h			;3b65
	rst 38h			;3b66
	rst 38h			;3b67
	rst 38h			;3b68
	rst 38h			;3b69
	rst 38h			;3b6a
	rst 38h			;3b6b
	rst 38h			;3b6c
	rst 38h			;3b6d
	rst 38h			;3b6e
	rst 38h			;3b6f
	rst 38h			;3b70
	rst 38h			;3b71
	rst 38h			;3b72
	rst 38h			;3b73
	rst 38h			;3b74
	rst 38h			;3b75
	rst 38h			;3b76
	rst 38h			;3b77
	rst 38h			;3b78
	rst 38h			;3b79
	rst 38h			;3b7a
	rst 38h			;3b7b
	rst 38h			;3b7c
	rst 38h			;3b7d
	rst 38h			;3b7e
	rst 38h			;3b7f
	rst 38h			;3b80
	rst 38h			;3b81
	rst 38h			;3b82
	rst 38h			;3b83
	rst 38h			;3b84
	rst 38h			;3b85
	rst 38h			;3b86
	rst 38h			;3b87
	rst 38h			;3b88
	rst 38h			;3b89
	rst 38h			;3b8a
	rst 38h			;3b8b
	rst 38h			;3b8c
	rst 38h			;3b8d
	rst 38h			;3b8e
	rst 38h			;3b8f
	rst 38h			;3b90
	rst 38h			;3b91
	rst 38h			;3b92
	rst 38h			;3b93
	rst 38h			;3b94
	rst 38h			;3b95
	rst 38h			;3b96
	rst 38h			;3b97
	rst 38h			;3b98
	rst 38h			;3b99
	rst 38h			;3b9a
	rst 38h			;3b9b
	rst 38h			;3b9c
	rst 38h			;3b9d
	rst 38h			;3b9e
	rst 38h			;3b9f
	rst 38h			;3ba0
	rst 38h			;3ba1
	rst 38h			;3ba2
	rst 38h			;3ba3
	rst 38h			;3ba4
	rst 38h			;3ba5
	rst 38h			;3ba6
	rst 38h			;3ba7
	rst 38h			;3ba8
	rst 38h			;3ba9
	rst 38h			;3baa
	rst 38h			;3bab
	rst 38h			;3bac
	rst 38h			;3bad
	rst 38h			;3bae
	rst 38h			;3baf
	rst 38h			;3bb0
	rst 38h			;3bb1
	rst 38h			;3bb2
	rst 38h			;3bb3
	rst 38h			;3bb4
	rst 38h			;3bb5
	rst 38h			;3bb6
	rst 38h			;3bb7
	rst 38h			;3bb8
	rst 38h			;3bb9
	rst 38h			;3bba
	rst 38h			;3bbb
	rst 38h			;3bbc
	rst 38h			;3bbd
	rst 38h			;3bbe
	rst 38h			;3bbf
	rst 38h			;3bc0
	rst 38h			;3bc1
	rst 38h			;3bc2
	rst 38h			;3bc3
	rst 38h			;3bc4
	rst 38h			;3bc5
	rst 38h			;3bc6
	rst 38h			;3bc7
	rst 38h			;3bc8
	rst 38h			;3bc9
	rst 38h			;3bca
	rst 38h			;3bcb
	rst 38h			;3bcc
	rst 38h			;3bcd
	rst 38h			;3bce
	rst 38h			;3bcf
	rst 38h			;3bd0
	rst 38h			;3bd1
	rst 38h			;3bd2
	rst 38h			;3bd3
	rst 38h			;3bd4
	rst 38h			;3bd5
	rst 38h			;3bd6
	rst 38h			;3bd7
	rst 38h			;3bd8
	rst 38h			;3bd9
	rst 38h			;3bda
	rst 38h			;3bdb
	rst 38h			;3bdc
	rst 38h			;3bdd
	rst 38h			;3bde
	rst 38h			;3bdf
	rst 38h			;3be0
	rst 38h			;3be1
	rst 38h			;3be2
	rst 38h			;3be3
	rst 38h			;3be4
	rst 38h			;3be5
	rst 38h			;3be6
	rst 38h			;3be7
	rst 38h			;3be8
	rst 38h			;3be9
	rst 38h			;3bea
	rst 38h			;3beb
	rst 38h			;3bec
	rst 38h			;3bed
	rst 38h			;3bee
	rst 38h			;3bef
	rst 38h			;3bf0
	rst 38h			;3bf1
	rst 38h			;3bf2
	rst 38h			;3bf3
	rst 38h			;3bf4
	rst 38h			;3bf5
	rst 38h			;3bf6
	rst 38h			;3bf7
	rst 38h			;3bf8
	rst 38h			;3bf9
	rst 38h			;3bfa
	rst 38h			;3bfb
	rst 38h			;3bfc
	rst 38h			;3bfd
	rst 38h			;3bfe
	rst 38h			;3bff
	rst 38h			;3c00
	rst 38h			;3c01
	rst 38h			;3c02
	rst 38h			;3c03
	rst 38h			;3c04
	rst 38h			;3c05
	rst 38h			;3c06
	rst 38h			;3c07
	rst 38h			;3c08
	rst 38h			;3c09
	rst 38h			;3c0a
	rst 38h			;3c0b
	rst 38h			;3c0c
	rst 38h			;3c0d
	rst 38h			;3c0e
	rst 38h			;3c0f
	rst 38h			;3c10
	rst 38h			;3c11
	rst 38h			;3c12
	rst 38h			;3c13
	rst 38h			;3c14
	rst 38h			;3c15
	rst 38h			;3c16
	rst 38h			;3c17
	rst 38h			;3c18
	rst 38h			;3c19
	rst 38h			;3c1a
	rst 38h			;3c1b
	rst 38h			;3c1c
	rst 38h			;3c1d
	rst 38h			;3c1e
	rst 38h			;3c1f
	rst 38h			;3c20
	rst 38h			;3c21
	rst 38h			;3c22
	rst 38h			;3c23
	rst 38h			;3c24
	rst 38h			;3c25
	rst 38h			;3c26
	rst 38h			;3c27
	rst 38h			;3c28
	rst 38h			;3c29
	rst 38h			;3c2a
	rst 38h			;3c2b
	rst 38h			;3c2c
	rst 38h			;3c2d
	rst 38h			;3c2e
	rst 38h			;3c2f
	rst 38h			;3c30
	rst 38h			;3c31
	rst 38h			;3c32
	rst 38h			;3c33
	rst 38h			;3c34
	rst 38h			;3c35
	rst 38h			;3c36
	rst 38h			;3c37
	rst 38h			;3c38
	rst 38h			;3c39
	rst 38h			;3c3a
	rst 38h			;3c3b
	rst 38h			;3c3c
	rst 38h			;3c3d
	rst 38h			;3c3e
	rst 38h			;3c3f
	rst 38h			;3c40
	rst 38h			;3c41
	rst 38h			;3c42
	rst 38h			;3c43
	rst 38h			;3c44
	rst 38h			;3c45
	rst 38h			;3c46
	rst 38h			;3c47
	rst 38h			;3c48
	rst 38h			;3c49
	rst 38h			;3c4a
	rst 38h			;3c4b
	rst 38h			;3c4c
	rst 38h			;3c4d
	rst 38h			;3c4e
	rst 38h			;3c4f
	rst 38h			;3c50
	rst 38h			;3c51
	rst 38h			;3c52
	rst 38h			;3c53
	rst 38h			;3c54
	rst 38h			;3c55
	rst 38h			;3c56
	rst 38h			;3c57
	rst 38h			;3c58
	rst 38h			;3c59
	rst 38h			;3c5a
	rst 38h			;3c5b
	rst 38h			;3c5c
	rst 38h			;3c5d
	rst 38h			;3c5e
	rst 38h			;3c5f
	rst 38h			;3c60
	rst 38h			;3c61
	rst 38h			;3c62
	rst 38h			;3c63
	rst 38h			;3c64
	rst 38h			;3c65
	rst 38h			;3c66
	rst 38h			;3c67
	rst 38h			;3c68
	rst 38h			;3c69
	rst 38h			;3c6a
	rst 38h			;3c6b
	rst 38h			;3c6c
	rst 38h			;3c6d
	rst 38h			;3c6e
	rst 38h			;3c6f
	rst 38h			;3c70
	rst 38h			;3c71
	rst 38h			;3c72
	rst 38h			;3c73
	rst 38h			;3c74
	rst 38h			;3c75
	rst 38h			;3c76
	rst 38h			;3c77
	rst 38h			;3c78
	rst 38h			;3c79
	rst 38h			;3c7a
	rst 38h			;3c7b
	rst 38h			;3c7c
	rst 38h			;3c7d
	rst 38h			;3c7e
	rst 38h			;3c7f
	rst 38h			;3c80
	rst 38h			;3c81
	rst 38h			;3c82
	rst 38h			;3c83
	rst 38h			;3c84
	rst 38h			;3c85
	rst 38h			;3c86
	rst 38h			;3c87
	rst 38h			;3c88
l3c89h:
	rst 38h			;3c89
	rst 38h			;3c8a
	rst 38h			;3c8b
	rst 38h			;3c8c
	rst 38h			;3c8d
	rst 38h			;3c8e
	rst 38h			;3c8f
	rst 38h			;3c90
	rst 38h			;3c91
	rst 38h			;3c92
	rst 38h			;3c93
	rst 38h			;3c94
	rst 38h			;3c95
	rst 38h			;3c96
	rst 38h			;3c97
	rst 38h			;3c98
	rst 38h			;3c99
	rst 38h			;3c9a
	rst 38h			;3c9b
	rst 38h			;3c9c
	rst 38h			;3c9d
	rst 38h			;3c9e
	rst 38h			;3c9f
	rst 38h			;3ca0
	rst 38h			;3ca1
	rst 38h			;3ca2
	rst 38h			;3ca3
	rst 38h			;3ca4
	rst 38h			;3ca5
	rst 38h			;3ca6
	rst 38h			;3ca7
l3ca8h:
	rst 38h			;3ca8
	rst 38h			;3ca9
	rst 38h			;3caa
	rst 38h			;3cab
	rst 38h			;3cac
	rst 38h			;3cad
	rst 38h			;3cae
	rst 38h			;3caf
	rst 38h			;3cb0
	rst 38h			;3cb1
	rst 38h			;3cb2
	rst 38h			;3cb3
	rst 38h			;3cb4
	rst 38h			;3cb5
	rst 38h			;3cb6
	rst 38h			;3cb7
	rst 38h			;3cb8
	rst 38h			;3cb9
	rst 38h			;3cba
	rst 38h			;3cbb
	rst 38h			;3cbc
	rst 38h			;3cbd
	rst 38h			;3cbe
	rst 38h			;3cbf
	rst 38h			;3cc0
	rst 38h			;3cc1
	rst 38h			;3cc2
	rst 38h			;3cc3
	rst 38h			;3cc4
	rst 38h			;3cc5
	rst 38h			;3cc6
	rst 38h			;3cc7
	rst 38h			;3cc8
	rst 38h			;3cc9
	rst 38h			;3cca
	rst 38h			;3ccb
	rst 38h			;3ccc
	rst 38h			;3ccd
	rst 38h			;3cce
	rst 38h			;3ccf
	rst 38h			;3cd0
	rst 38h			;3cd1
	rst 38h			;3cd2
	rst 38h			;3cd3
	rst 38h			;3cd4
	rst 38h			;3cd5
	rst 38h			;3cd6
	rst 38h			;3cd7
	rst 38h			;3cd8
	rst 38h			;3cd9
	rst 38h			;3cda
	rst 38h			;3cdb
l3cdch:
	rst 38h			;3cdc
	rst 38h			;3cdd
	rst 38h			;3cde
	rst 38h			;3cdf
	rst 38h			;3ce0
	rst 38h			;3ce1
	rst 38h			;3ce2
	rst 38h			;3ce3
	rst 38h			;3ce4
	rst 38h			;3ce5
	rst 38h			;3ce6
	rst 38h			;3ce7
	rst 38h			;3ce8
	rst 38h			;3ce9
	rst 38h			;3cea
	rst 38h			;3ceb
	rst 38h			;3cec
	rst 38h			;3ced
	rst 38h			;3cee
	rst 38h			;3cef
	rst 38h			;3cf0
	rst 38h			;3cf1
	rst 38h			;3cf2
	rst 38h			;3cf3
	rst 38h			;3cf4
	rst 38h			;3cf5
	rst 38h			;3cf6
	rst 38h			;3cf7
	rst 38h			;3cf8
	rst 38h			;3cf9
	rst 38h			;3cfa
	rst 38h			;3cfb
	rst 38h			;3cfc
	rst 38h			;3cfd
	rst 38h			;3cfe
	rst 38h			;3cff
	rst 38h			;3d00
	rst 38h			;3d01
	rst 38h			;3d02
	rst 38h			;3d03
	rst 38h			;3d04
	rst 38h			;3d05
	rst 38h			;3d06
	rst 38h			;3d07
	rst 38h			;3d08
	rst 38h			;3d09
	rst 38h			;3d0a
	rst 38h			;3d0b
	rst 38h			;3d0c
	rst 38h			;3d0d
	rst 38h			;3d0e
	rst 38h			;3d0f
	rst 38h			;3d10
	rst 38h			;3d11
	rst 38h			;3d12
	rst 38h			;3d13
	rst 38h			;3d14
	rst 38h			;3d15
	rst 38h			;3d16
	rst 38h			;3d17
	rst 38h			;3d18
	rst 38h			;3d19
	rst 38h			;3d1a
	rst 38h			;3d1b
	rst 38h			;3d1c
	rst 38h			;3d1d
	rst 38h			;3d1e
	rst 38h			;3d1f
	rst 38h			;3d20
	rst 38h			;3d21
	rst 38h			;3d22
	rst 38h			;3d23
	rst 38h			;3d24
	rst 38h			;3d25
	rst 38h			;3d26
	rst 38h			;3d27
	rst 38h			;3d28
	rst 38h			;3d29
	rst 38h			;3d2a
	rst 38h			;3d2b
	rst 38h			;3d2c
	rst 38h			;3d2d
	rst 38h			;3d2e
	rst 38h			;3d2f
	rst 38h			;3d30
	rst 38h			;3d31
	rst 38h			;3d32
	rst 38h			;3d33
	rst 38h			;3d34
	rst 38h			;3d35
	rst 38h			;3d36
	rst 38h			;3d37
	rst 38h			;3d38
	rst 38h			;3d39
	rst 38h			;3d3a
	rst 38h			;3d3b
	rst 38h			;3d3c
	rst 38h			;3d3d
	rst 38h			;3d3e
	rst 38h			;3d3f
	rst 38h			;3d40
	rst 38h			;3d41
	rst 38h			;3d42
	rst 38h			;3d43
	rst 38h			;3d44
	rst 38h			;3d45
	rst 38h			;3d46
	rst 38h			;3d47
	rst 38h			;3d48
	rst 38h			;3d49
	rst 38h			;3d4a
	rst 38h			;3d4b
	rst 38h			;3d4c
	rst 38h			;3d4d
	rst 38h			;3d4e
	rst 38h			;3d4f
	rst 38h			;3d50
	rst 38h			;3d51
	rst 38h			;3d52
	rst 38h			;3d53
	rst 38h			;3d54
	rst 38h			;3d55
	rst 38h			;3d56
	rst 38h			;3d57
	rst 38h			;3d58
	rst 38h			;3d59
	rst 38h			;3d5a
	rst 38h			;3d5b
	rst 38h			;3d5c
	rst 38h			;3d5d
	rst 38h			;3d5e
	rst 38h			;3d5f
	rst 38h			;3d60
	rst 38h			;3d61
	rst 38h			;3d62
	rst 38h			;3d63
	rst 38h			;3d64
	rst 38h			;3d65
	rst 38h			;3d66
	rst 38h			;3d67
	rst 38h			;3d68
	rst 38h			;3d69
	rst 38h			;3d6a
	rst 38h			;3d6b
	rst 38h			;3d6c
	rst 38h			;3d6d
	rst 38h			;3d6e
	rst 38h			;3d6f
	rst 38h			;3d70
	rst 38h			;3d71
	rst 38h			;3d72
	rst 38h			;3d73
	rst 38h			;3d74
	rst 38h			;3d75
	rst 38h			;3d76
	rst 38h			;3d77
	rst 38h			;3d78
	rst 38h			;3d79
	rst 38h			;3d7a
	rst 38h			;3d7b
	rst 38h			;3d7c
	rst 38h			;3d7d
	rst 38h			;3d7e
	rst 38h			;3d7f
	rst 38h			;3d80
	rst 38h			;3d81
	rst 38h			;3d82
	rst 38h			;3d83
	rst 38h			;3d84
	rst 38h			;3d85
	rst 38h			;3d86
	rst 38h			;3d87
	rst 38h			;3d88
	rst 38h			;3d89
	rst 38h			;3d8a
	rst 38h			;3d8b
	rst 38h			;3d8c
	rst 38h			;3d8d
	rst 38h			;3d8e
	rst 38h			;3d8f
	rst 38h			;3d90
	rst 38h			;3d91
	rst 38h			;3d92
	rst 38h			;3d93
	rst 38h			;3d94
	rst 38h			;3d95
	rst 38h			;3d96
	rst 38h			;3d97
	rst 38h			;3d98
	rst 38h			;3d99
	rst 38h			;3d9a
	rst 38h			;3d9b
	rst 38h			;3d9c
	rst 38h			;3d9d
	rst 38h			;3d9e
	rst 38h			;3d9f
	rst 38h			;3da0
	rst 38h			;3da1
	rst 38h			;3da2
	rst 38h			;3da3
	rst 38h			;3da4
	rst 38h			;3da5
	rst 38h			;3da6
	rst 38h			;3da7
	rst 38h			;3da8
	rst 38h			;3da9
	rst 38h			;3daa
	rst 38h			;3dab
	rst 38h			;3dac
	rst 38h			;3dad
	rst 38h			;3dae
	rst 38h			;3daf
	rst 38h			;3db0
	rst 38h			;3db1
	rst 38h			;3db2
	rst 38h			;3db3
	rst 38h			;3db4
	rst 38h			;3db5
	rst 38h			;3db6
	rst 38h			;3db7
	rst 38h			;3db8
	rst 38h			;3db9
	rst 38h			;3dba
	rst 38h			;3dbb
	rst 38h			;3dbc
	rst 38h			;3dbd
	rst 38h			;3dbe
	rst 38h			;3dbf
	rst 38h			;3dc0
	rst 38h			;3dc1
	rst 38h			;3dc2
	rst 38h			;3dc3
	rst 38h			;3dc4
	rst 38h			;3dc5
	rst 38h			;3dc6
	rst 38h			;3dc7
	rst 38h			;3dc8
	rst 38h			;3dc9
	rst 38h			;3dca
	rst 38h			;3dcb
	rst 38h			;3dcc
	rst 38h			;3dcd
	rst 38h			;3dce
	rst 38h			;3dcf
	rst 38h			;3dd0
	rst 38h			;3dd1
	rst 38h			;3dd2
	rst 38h			;3dd3
	rst 38h			;3dd4
	rst 38h			;3dd5
	rst 38h			;3dd6
	rst 38h			;3dd7
	rst 38h			;3dd8
	rst 38h			;3dd9
	rst 38h			;3dda
	rst 38h			;3ddb
	rst 38h			;3ddc
	rst 38h			;3ddd
	rst 38h			;3dde
	rst 38h			;3ddf
	rst 38h			;3de0
	rst 38h			;3de1
	rst 38h			;3de2
	rst 38h			;3de3
	rst 38h			;3de4
	rst 38h			;3de5
	rst 38h			;3de6
	rst 38h			;3de7
	rst 38h			;3de8
	rst 38h			;3de9
	rst 38h			;3dea
	rst 38h			;3deb
	rst 38h			;3dec
	rst 38h			;3ded
	rst 38h			;3dee
	rst 38h			;3def
	rst 38h			;3df0
	rst 38h			;3df1
	rst 38h			;3df2
	rst 38h			;3df3
	rst 38h			;3df4
	rst 38h			;3df5
	rst 38h			;3df6
	rst 38h			;3df7
	rst 38h			;3df8
	rst 38h			;3df9
	rst 38h			;3dfa
	rst 38h			;3dfb
	rst 38h			;3dfc
	rst 38h			;3dfd
	rst 38h			;3dfe
	rst 38h			;3dff
	rst 38h			;3e00
	rst 38h			;3e01
	rst 38h			;3e02
	rst 38h			;3e03
	rst 38h			;3e04
	rst 38h			;3e05
	rst 38h			;3e06
	rst 38h			;3e07
	rst 38h			;3e08
	rst 38h			;3e09
	rst 38h			;3e0a
	rst 38h			;3e0b
	rst 38h			;3e0c
	rst 38h			;3e0d
	rst 38h			;3e0e
	rst 38h			;3e0f
	rst 38h			;3e10
	rst 38h			;3e11
	rst 38h			;3e12
	rst 38h			;3e13
	rst 38h			;3e14
	rst 38h			;3e15
	rst 38h			;3e16
	rst 38h			;3e17
	rst 38h			;3e18
	rst 38h			;3e19
	rst 38h			;3e1a
	rst 38h			;3e1b
	rst 38h			;3e1c
	rst 38h			;3e1d
	rst 38h			;3e1e
	rst 38h			;3e1f
	rst 38h			;3e20
	rst 38h			;3e21
	rst 38h			;3e22
	rst 38h			;3e23
	rst 38h			;3e24
	rst 38h			;3e25
	rst 38h			;3e26
	rst 38h			;3e27
	rst 38h			;3e28
	rst 38h			;3e29
	rst 38h			;3e2a
	rst 38h			;3e2b
	rst 38h			;3e2c
	rst 38h			;3e2d
	rst 38h			;3e2e
	rst 38h			;3e2f
	rst 38h			;3e30
	rst 38h			;3e31
	rst 38h			;3e32
	rst 38h			;3e33
	rst 38h			;3e34
	rst 38h			;3e35
	rst 38h			;3e36
	rst 38h			;3e37
	rst 38h			;3e38
	rst 38h			;3e39
	rst 38h			;3e3a
	rst 38h			;3e3b
	rst 38h			;3e3c
	rst 38h			;3e3d
	rst 38h			;3e3e
	rst 38h			;3e3f
	rst 38h			;3e40
	rst 38h			;3e41
	rst 38h			;3e42
	rst 38h			;3e43
	rst 38h			;3e44
	rst 38h			;3e45
	rst 38h			;3e46
	rst 38h			;3e47
	rst 38h			;3e48
	rst 38h			;3e49
	rst 38h			;3e4a
	rst 38h			;3e4b
	rst 38h			;3e4c
	rst 38h			;3e4d
	rst 38h			;3e4e
	rst 38h			;3e4f
	rst 38h			;3e50
	rst 38h			;3e51
	rst 38h			;3e52
	rst 38h			;3e53
	rst 38h			;3e54
	rst 38h			;3e55
	rst 38h			;3e56
	rst 38h			;3e57
	rst 38h			;3e58
	rst 38h			;3e59
	rst 38h			;3e5a
	rst 38h			;3e5b
	rst 38h			;3e5c
	rst 38h			;3e5d
	rst 38h			;3e5e
	rst 38h			;3e5f
	rst 38h			;3e60
	rst 38h			;3e61
	rst 38h			;3e62
	rst 38h			;3e63
	rst 38h			;3e64
	rst 38h			;3e65
	rst 38h			;3e66
	rst 38h			;3e67
	rst 38h			;3e68
	rst 38h			;3e69
	rst 38h			;3e6a
	rst 38h			;3e6b
	rst 38h			;3e6c
	rst 38h			;3e6d
	rst 38h			;3e6e
	rst 38h			;3e6f
	rst 38h			;3e70
	rst 38h			;3e71
	rst 38h			;3e72
	rst 38h			;3e73
	rst 38h			;3e74
	rst 38h			;3e75
	rst 38h			;3e76
	rst 38h			;3e77
	rst 38h			;3e78
	rst 38h			;3e79
	rst 38h			;3e7a
	rst 38h			;3e7b
	rst 38h			;3e7c
	rst 38h			;3e7d
	rst 38h			;3e7e
	rst 38h			;3e7f
	rst 38h			;3e80
	rst 38h			;3e81
	rst 38h			;3e82
	rst 38h			;3e83
	rst 38h			;3e84
	rst 38h			;3e85
	rst 38h			;3e86
	rst 38h			;3e87
	rst 38h			;3e88
	rst 38h			;3e89
	rst 38h			;3e8a
	rst 38h			;3e8b
	rst 38h			;3e8c
	rst 38h			;3e8d
	rst 38h			;3e8e
	rst 38h			;3e8f
	rst 38h			;3e90
	rst 38h			;3e91
	rst 38h			;3e92
	rst 38h			;3e93
	rst 38h			;3e94
	rst 38h			;3e95
	rst 38h			;3e96
	rst 38h			;3e97
	rst 38h			;3e98
	rst 38h			;3e99
	rst 38h			;3e9a
	rst 38h			;3e9b
	rst 38h			;3e9c
	rst 38h			;3e9d
	rst 38h			;3e9e
	rst 38h			;3e9f
	rst 38h			;3ea0
	rst 38h			;3ea1
	rst 38h			;3ea2
	rst 38h			;3ea3
	rst 38h			;3ea4
	rst 38h			;3ea5
	rst 38h			;3ea6
	rst 38h			;3ea7
	rst 38h			;3ea8
	rst 38h			;3ea9
	rst 38h			;3eaa
	rst 38h			;3eab
	rst 38h			;3eac
	rst 38h			;3ead
	rst 38h			;3eae
	rst 38h			;3eaf
	rst 38h			;3eb0
	rst 38h			;3eb1
	rst 38h			;3eb2
	rst 38h			;3eb3
	rst 38h			;3eb4
	rst 38h			;3eb5
	rst 38h			;3eb6
	rst 38h			;3eb7
	rst 38h			;3eb8
	rst 38h			;3eb9
	rst 38h			;3eba
	rst 38h			;3ebb
	rst 38h			;3ebc
	rst 38h			;3ebd
	rst 38h			;3ebe
	rst 38h			;3ebf
	rst 38h			;3ec0
	rst 38h			;3ec1
	rst 38h			;3ec2
	rst 38h			;3ec3
	rst 38h			;3ec4
	rst 38h			;3ec5
	rst 38h			;3ec6
	rst 38h			;3ec7
	rst 38h			;3ec8
	rst 38h			;3ec9
	rst 38h			;3eca
	rst 38h			;3ecb
	rst 38h			;3ecc
	rst 38h			;3ecd
	rst 38h			;3ece
	rst 38h			;3ecf
	rst 38h			;3ed0
	rst 38h			;3ed1
	rst 38h			;3ed2
	rst 38h			;3ed3
	rst 38h			;3ed4
	rst 38h			;3ed5
	rst 38h			;3ed6
	rst 38h			;3ed7
	rst 38h			;3ed8
	rst 38h			;3ed9
	rst 38h			;3eda
	rst 38h			;3edb
	rst 38h			;3edc
	rst 38h			;3edd
	rst 38h			;3ede
	rst 38h			;3edf
	rst 38h			;3ee0
	rst 38h			;3ee1
	rst 38h			;3ee2
	rst 38h			;3ee3
	rst 38h			;3ee4
	rst 38h			;3ee5
	rst 38h			;3ee6
	rst 38h			;3ee7
	rst 38h			;3ee8
	rst 38h			;3ee9
	rst 38h			;3eea
	rst 38h			;3eeb
	rst 38h			;3eec
	rst 38h			;3eed
	rst 38h			;3eee
	rst 38h			;3eef
	rst 38h			;3ef0
	rst 38h			;3ef1
	rst 38h			;3ef2
	rst 38h			;3ef3
	rst 38h			;3ef4
	rst 38h			;3ef5
	rst 38h			;3ef6
	rst 38h			;3ef7
	rst 38h			;3ef8
	rst 38h			;3ef9
	rst 38h			;3efa
	rst 38h			;3efb
	rst 38h			;3efc
	rst 38h			;3efd
	rst 38h			;3efe
	rst 38h			;3eff
	rst 38h			;3f00
	rst 38h			;3f01
	rst 38h			;3f02
	rst 38h			;3f03
	rst 38h			;3f04
	rst 38h			;3f05
	rst 38h			;3f06
	rst 38h			;3f07
	rst 38h			;3f08
	rst 38h			;3f09
	rst 38h			;3f0a
	rst 38h			;3f0b
	rst 38h			;3f0c
	rst 38h			;3f0d
	rst 38h			;3f0e
	rst 38h			;3f0f
	rst 38h			;3f10
	rst 38h			;3f11
	rst 38h			;3f12
	rst 38h			;3f13
	rst 38h			;3f14
	rst 38h			;3f15
	rst 38h			;3f16
	rst 38h			;3f17
	rst 38h			;3f18
	rst 38h			;3f19
	rst 38h			;3f1a
	rst 38h			;3f1b
	rst 38h			;3f1c
	rst 38h			;3f1d
	rst 38h			;3f1e
	rst 38h			;3f1f
	rst 38h			;3f20
	rst 38h			;3f21
	rst 38h			;3f22
	rst 38h			;3f23
	rst 38h			;3f24
	rst 38h			;3f25
	rst 38h			;3f26
	rst 38h			;3f27
	rst 38h			;3f28
	rst 38h			;3f29
	rst 38h			;3f2a
	rst 38h			;3f2b
	rst 38h			;3f2c
	rst 38h			;3f2d
	rst 38h			;3f2e
	rst 38h			;3f2f
	rst 38h			;3f30
	rst 38h			;3f31
	rst 38h			;3f32
	rst 38h			;3f33
	rst 38h			;3f34
	rst 38h			;3f35
	rst 38h			;3f36
	rst 38h			;3f37
	rst 38h			;3f38
	rst 38h			;3f39
	rst 38h			;3f3a
	rst 38h			;3f3b
	rst 38h			;3f3c
	rst 38h			;3f3d
	rst 38h			;3f3e
	rst 38h			;3f3f
	rst 38h			;3f40
	rst 38h			;3f41
	rst 38h			;3f42
	rst 38h			;3f43
	rst 38h			;3f44
	rst 38h			;3f45
	rst 38h			;3f46
	rst 38h			;3f47
	rst 38h			;3f48
	rst 38h			;3f49
	rst 38h			;3f4a
	rst 38h			;3f4b
	rst 38h			;3f4c
	rst 38h			;3f4d
	rst 38h			;3f4e
	rst 38h			;3f4f
	rst 38h			;3f50
	rst 38h			;3f51
	rst 38h			;3f52
	rst 38h			;3f53
	rst 38h			;3f54
	rst 38h			;3f55
	rst 38h			;3f56
	rst 38h			;3f57
	rst 38h			;3f58
	rst 38h			;3f59
	rst 38h			;3f5a
	rst 38h			;3f5b
	rst 38h			;3f5c
	rst 38h			;3f5d
	rst 38h			;3f5e
	rst 38h			;3f5f
	rst 38h			;3f60
	rst 38h			;3f61
	rst 38h			;3f62
	rst 38h			;3f63
	rst 38h			;3f64
	rst 38h			;3f65
	rst 38h			;3f66
	rst 38h			;3f67
	rst 38h			;3f68
	rst 38h			;3f69
	rst 38h			;3f6a
	rst 38h			;3f6b
	rst 38h			;3f6c
	rst 38h			;3f6d
	rst 38h			;3f6e
	rst 38h			;3f6f
	rst 38h			;3f70
	rst 38h			;3f71
	rst 38h			;3f72
	rst 38h			;3f73
	rst 38h			;3f74
	rst 38h			;3f75
	rst 38h			;3f76
	rst 38h			;3f77
	rst 38h			;3f78
	rst 38h			;3f79
	rst 38h			;3f7a
	rst 38h			;3f7b
	rst 38h			;3f7c
	rst 38h			;3f7d
	rst 38h			;3f7e
	rst 38h			;3f7f
	rst 38h			;3f80
	rst 38h			;3f81
	rst 38h			;3f82
	rst 38h			;3f83
	rst 38h			;3f84
	rst 38h			;3f85
	rst 38h			;3f86
	rst 38h			;3f87
	rst 38h			;3f88
	rst 38h			;3f89
	rst 38h			;3f8a
	rst 38h			;3f8b
	rst 38h			;3f8c
	rst 38h			;3f8d
	rst 38h			;3f8e
	rst 38h			;3f8f
	rst 38h			;3f90
	rst 38h			;3f91
	rst 38h			;3f92
	rst 38h			;3f93
	rst 38h			;3f94
	rst 38h			;3f95
	rst 38h			;3f96
	rst 38h			;3f97
	rst 38h			;3f98
	rst 38h			;3f99
	rst 38h			;3f9a
	rst 38h			;3f9b
	rst 38h			;3f9c
	rst 38h			;3f9d
	rst 38h			;3f9e
	rst 38h			;3f9f
	rst 38h			;3fa0
	rst 38h			;3fa1
	rst 38h			;3fa2
	rst 38h			;3fa3
	rst 38h			;3fa4
	rst 38h			;3fa5
	rst 38h			;3fa6
	rst 38h			;3fa7
	rst 38h			;3fa8
	rst 38h			;3fa9
	rst 38h			;3faa
	rst 38h			;3fab
	rst 38h			;3fac
	rst 38h			;3fad
	rst 38h			;3fae
	rst 38h			;3faf
	rst 38h			;3fb0
	rst 38h			;3fb1
	rst 38h			;3fb2
	rst 38h			;3fb3
	rst 38h			;3fb4
	rst 38h			;3fb5
	rst 38h			;3fb6
	rst 38h			;3fb7
	rst 38h			;3fb8
	rst 38h			;3fb9
	rst 38h			;3fba
	rst 38h			;3fbb
	rst 38h			;3fbc
	rst 38h			;3fbd
	rst 38h			;3fbe
	rst 38h			;3fbf
	rst 38h			;3fc0
	rst 38h			;3fc1
	rst 38h			;3fc2
	rst 38h			;3fc3
	rst 38h			;3fc4
	rst 38h			;3fc5
	rst 38h			;3fc6
	rst 38h			;3fc7
	rst 38h			;3fc8
	rst 38h			;3fc9
	rst 38h			;3fca
	rst 38h			;3fcb
	rst 38h			;3fcc
	rst 38h			;3fcd
	rst 38h			;3fce
	rst 38h			;3fcf
	rst 38h			;3fd0
	rst 38h			;3fd1
	rst 38h			;3fd2
	rst 38h			;3fd3
	rst 38h			;3fd4
	rst 38h			;3fd5
	rst 38h			;3fd6
	rst 38h			;3fd7
	rst 38h			;3fd8
	rst 38h			;3fd9
	rst 38h			;3fda
	rst 38h			;3fdb
	rst 38h			;3fdc
	rst 38h			;3fdd
	rst 38h			;3fde
	rst 38h			;3fdf
	rst 38h			;3fe0
	rst 38h			;3fe1
	rst 38h			;3fe2
	rst 38h			;3fe3
	rst 38h			;3fe4
	rst 38h			;3fe5
	rst 38h			;3fe6
	rst 38h			;3fe7
	rst 38h			;3fe8
	rst 38h			;3fe9
	rst 38h			;3fea
	rst 38h			;3feb
	rst 38h			;3fec
	rst 38h			;3fed
	rst 38h			;3fee
	rst 38h			;3fef
	rst 38h			;3ff0
	rst 38h			;3ff1
	rst 38h			;3ff2
	rst 38h			;3ff3
	rst 38h			;3ff4
	rst 38h			;3ff5
	rst 38h			;3ff6
	rst 38h			;3ff7
	rst 38h			;3ff8
	rst 38h			;3ff9
	rst 38h			;3ffa
	rst 38h			;3ffb
	rst 38h			;3ffc
	rst 38h			;3ffd
	rst 38h			;3ffe
	rst 38h			;3fff
