; z80dasm 1.2.0
; command line: z80dasm -a -l -g 0x0000 -o gus-home.asm gus-home.rom

	org 00000h

l0000h:
	di			;0000
l0001h:
	xor a			;0001
l0002h:
	ld de,0ffffh		;0002
l0005h:
	jp l0d31h		;0005
l0008h:
	ld hl,(05c5dh)		;0008
	ld (05c5fh),hl		;000b
l000eh:
	jr l0053h		;000e
l0010h:
	jp l11edh		;0010
	rst 38h			;0013
l0014h:
	rst 38h			;0014
l0015h:
	rst 38h			;0015
l0016h:
	rst 38h			;0016
	rst 38h			;0017
l0018h:
	ld hl,(05c5dh)		;0018
	ld a,(hl)		;001b
l001ch:
	call sub_007dh		;001c
	ret nc			;001f
l0020h:
	call sub_0074h		;0020
	jr l001ch		;0023
	rst 38h			;0025
	rst 38h			;0026
	rst 38h			;0027
	jp l371ah		;0028
	rst 38h			;002b
	rst 38h			;002c
	rst 38h			;002d
	rst 38h			;002e
	rst 38h			;002f
l0030h:
	push bc			;0030
	ld hl,(05c61h)		;0031
	push hl			;0034
	jp l132dh		;0035
	push af			;0038
	push hl			;0039
	ld hl,(05c78h)		;003a
	inc hl			;003d
	ld (05c78h),hl		;003e
	ld a,h			;0041
	or l			;0042
	jr nz,l0048h		;0043
	inc (iy+040h)		;0045
l0048h:
	push bc			;0048
	push de			;0049
	call sub_02e1h		;004a
	pop de			;004d
	pop bc			;004e
	pop hl			;004f
l0050h:
	pop af			;0050
	ei			;0051
l0052h:
	ret			;0052
l0053h:
	pop hl			;0053
	ld l,(hl)		;0054
l0055h:
	ld (iy+000h),l		;0055
	ld sp,(05c3dh)		;0058
	jp l1354h		;005c
	rst 38h			;005f
	rst 38h			;0060
	rst 38h			;0061
	rst 38h			;0062
	rst 38h			;0063
	rst 38h			;0064
	dec d			;0065
	push af			;0066
	push hl			;0067
	ld hl,(05cb0h)		;0068
	ld a,h			;006b
	or l			;006c
	jr nz,l0070h		;006d
	jp (hl)			;006f
l0070h:
	pop hl			;0070
	pop af			;0071
	retn			;0072
sub_0074h:
	ld hl,(05c5dh)		;0074
sub_0077h:
	inc hl			;0077
sub_0078h:
	ld (05c5dh),hl		;0078
	ld a,(hl)		;007b
	ret			;007c
sub_007dh:
	cp 021h			;007d
	ret nc			;007f
	cp 00dh			;0080
	ret z			;0082
	cp 00ch			;0083
	ret z			;0085
	cp 010h			;0086
	ret c			;0088
	cp 018h			;0089
	ccf			;008b
	ret c			;008c
	inc hl			;008d
	cp 016h			;008e
	jr c,l0093h		;0090
	inc hl			;0092
l0093h:
	scf			;0093
	ld (05c5dh),hl		;0094
	ret			;0097
l0098h:
	cp a			;0098
	ld d,d			;0099
	ld c,(hl)		;009a
	call nz,04e49h		;009b
	ld c,e			;009e
	ld b,l			;009f
	ld e,c			;00a0
	and h			;00a1
	ld d,b			;00a2
	ret			;00a3
	ld b,(hl)		;00a4
	adc a,050h		;00a5
	ld c,a			;00a7
l00a8h:
	ld c,c			;00a8
	ld c,(hl)		;00a9
	call nc,04353h		;00aa
	ld d,d			;00ad
	ld b,l			;00ae
	ld b,l			;00af
	ld c,(hl)		;00b0
	and h			;00b1
	ld b,c			;00b2
	ld d,h			;00b3
	ld d,h			;00b4
	jp nc,0d441h		;00b5
	ld d,h			;00b8
	ld b,c			;00b9
	jp nz,04156h		;00ba
	ld c,h			;00bd
	and h			;00be
	ld b,e			;00bf
	ld c,a			;00c0
	ld b,h			;00c1
	push bc			;00c2
	ld d,(hl)		;00c3
	ld b,c			;00c4
	call z,0454ch		;00c5
l00c8h:
	adc a,053h		;00c8
	ld c,c			;00ca
	adc a,043h		;00cb
	ld c,a			;00cd
l00ceh:
	out (054h),a		;00ce
l00d0h:
	ld b,c			;00d0
	adc a,041h		;00d1
	ld d,e			;00d3
	adc a,041h		;00d4
	ld b,e			;00d6
	out (041h),a		;00d7
	ld d,h			;00d9
	adc a,04ch		;00da
	adc a,045h		;00dc
	ld e,b			;00de
	ret nc			;00df
	ld c,c			;00e0
	ld c,(hl)		;00e1
	call nc,05153h		;00e2
	jp nc,04753h		;00e5
	adc a,041h		;00e8
	ld b,d			;00ea
	out (050h),a		;00eb
	ld b,l			;00ed
	ld b,l			;00ee
	bit 1,c			;00ef
	adc a,055h		;00f1
	ld d,e			;00f3
	jp nc,05453h		;00f4
	ld d,d			;00f7
	and h			;00f8
	ld b,e			;00f9
	ld c,b			;00fa
	ld d,d			;00fb
	and h			;00fc
	ld c,(hl)		;00fd
	ld c,a			;00fe
l00ffh:
	call nc,04942h		;00ff
l0102h:
	adc a,04fh		;0102
	jp nc,04e41h		;0104
	call nz,0bd3ch		;0107
	ld a,0bdh		;010a
	inc a			;010c
	cp (hl)			;010d
	ld c,h			;010e
	ld c,c			;010f
	ld c,(hl)		;0110
	push bc			;0111
	ld d,h			;0112
	ld c,b			;0113
	ld b,l			;0114
	adc a,054h		;0115
	rst 8			;0117
	ld d,e			;0118
	ld d,h			;0119
	ld b,l			;011a
	ret nc			;011b
	ld b,h			;011c
	ld b,l			;011d
	ld b,(hl)		;011e
l011fh:
	jr nz,l0167h		;011f
	adc a,043h		;0121
	ld b,c			;0123
	call nc,04f46h		;0124
	ld d,d			;0127
	ld c,l			;0128
	ld b,c			;0129
	call nc,04f4dh		;012a
	ld d,(hl)		;012d
	push bc			;012e
	ld b,l			;012f
	ld d,d			;0130
	ld b,c			;0131
	ld d,e			;0132
	push bc			;0133
	ld c,a			;0134
	ld d,b			;0135
	ld b,l			;0136
	ld c,(hl)		;0137
	jr nz,$-91		;0138
	ld b,e			;013a
	ld c,h			;013b
	ld c,a			;013c
	ld d,e			;013d
	ld b,l			;013e
	jr nz,$-91		;013f
	ld c,l			;0141
	ld b,l			;0142
	ld d,d			;0143
	ld b,a			;0144
	push bc			;0145
	ld d,(hl)		;0146
	ld b,l			;0147
	ld d,d			;0148
	ld c,c			;0149
	ld b,(hl)		;014a
	exx			;014b
	ld b,d			;014c
	ld b,l			;014d
	ld b,l			;014e
	ret nc			;014f
	ld b,e			;0150
	ld c,c			;0151
	ld d,d			;0152
	ld b,e			;0153
	ld c,h			;0154
	push bc			;0155
	ld c,c			;0156
	ld c,(hl)		;0157
	bit 2,b			;0158
	ld b,c			;015a
	ld d,b			;015b
	ld b,l			;015c
	jp nc,04c46h		;015d
	ld b,c			;0160
	ld d,e			;0161
	ret z			;0162
	ld b,d			;0163
	ld d,d			;0164
	ld c,c			;0165
	ld b,a			;0166
l0167h:
	ld c,b			;0167
	call nc,04e49h		;0168
	ld d,(hl)		;016b
	ld b,l			;016c
	ld d,d			;016d
	ld d,e			;016e
	push bc			;016f
	ld c,a			;0170
	ld d,(hl)		;0171
	ld b,l			;0172
	jp nc,0554fh		;0173
	call nc,0504ch		;0176
	ld d,d			;0179
	ld c,c			;017a
	ld c,(hl)		;017b
	call nc,04c4ch		;017c
	ld c,c			;017f
	ld d,e			;0180
	call nc,05453h		;0181
	ld c,a			;0184
	ret nc			;0185
	ld d,d			;0186
	ld b,l			;0187
	ld b,c			;0188
	call nz,04144h		;0189
	ld d,h			;018c
	pop bc			;018d
	ld d,d			;018e
	ld b,l			;018f
	ld d,e			;0190
	ld d,h			;0191
	ld c,a			;0192
	ld d,d			;0193
	push bc			;0194
	ld c,(hl)		;0195
	ld b,l			;0196
	rst 10h			;0197
	ld b,d			;0198
	ld c,a			;0199
	ld d,d			;019a
	ld b,h			;019b
	ld b,l			;019c
	jp nc,04f43h		;019d
	ld c,(hl)		;01a0
	ld d,h			;01a1
	ld c,c			;01a2
	ld c,(hl)		;01a3
	ld d,l			;01a4
	push bc			;01a5
	ld b,h			;01a6
	ld c,c			;01a7
	call 04552h		;01a8
l01abh:
	call 04f46h		;01ab
	jp nc,04f47h		;01ae
	jr nz,l0207h		;01b1
	rst 8			;01b3
	ld b,a			;01b4
	ld c,a			;01b5
	jr nz,l020bh		;01b6
	ld d,l			;01b8
	jp nz,04e49h		;01b9
	ld d,b			;01bc
	ld d,l			;01bd
	call nc,04f4ch		;01be
	ld b,c			;01c1
	call nz,0494ch		;01c2
	ld d,e			;01c5
	call nc,0454ch		;01c6
	call nc,04150h		;01c9
l01cch:
	ld d,l			;01cc
	ld d,e			;01cd
	push bc			;01ce
	ld c,(hl)		;01cf
	ld b,l			;01d0
	ld e,b			;01d1
	call nc,04f50h		;01d2
	ld c,e			;01d5
	push bc			;01d6
	ld d,b			;01d7
	ld d,d			;01d8
	ld c,c			;01d9
	ld c,(hl)		;01da
	call nc,04c50h		;01db
	ld c,a			;01de
	call nc,05552h		;01df
	adc a,053h		;01e2
	ld b,c			;01e4
	ld d,(hl)		;01e5
	push bc			;01e6
	ld d,d			;01e7
	ld b,c			;01e8
	ld c,(hl)		;01e9
	ld b,h			;01ea
	ld c,a			;01eb
	ld c,l			;01ec
	ld c,c			;01ed
	ld e,d			;01ee
	push bc			;01ef
	ld c,c			;01f0
	add a,043h		;01f1
	ld c,h			;01f3
	out (044h),a		;01f4
	ld d,d			;01f6
	ld b,c			;01f7
	rst 10h			;01f8
	ld b,e			;01f9
	ld c,h			;01fa
	ld b,l			;01fb
	ld b,c			;01fc
	jp nc,04552h		;01fd
l0200h:
	ld d,h			;0200
	ld d,l			;0201
	ld d,d			;0202
	adc a,043h		;0203
l0205h:
	ld c,a			;0205
	ld d,b			;0206
l0207h:
	exx			;0207
	ld b,h			;0208
	ld b,l			;0209
	ld c,h			;020a
l020bh:
	ld b,l			;020b
	ld d,h			;020c
l020dh:
	push bc			;020d
	ld c,a			;020e
l020fh:
	ld c,(hl)		;020f
	jr nz,l0257h		;0210
	ld d,d			;0212
	jp nc,05453h		;0213
	ld c,c			;0216
	ld b,e			;0217
	bit 2,e			;0218
	ld c,a			;021a
	ld d,l			;021b
	ld c,(hl)		;021c
	call nz,05246h		;021d
	ld b,l			;0220
	push bc			;0221
	ld d,d			;0222
	ld b,l			;0223
	ld d,e			;0224
	ld b,l			;0225
	call nc,04842h		;0226
	ld e,c			;0229
	ld (hl),035h		;022a
	ld d,h			;022c
	ld b,a			;022d
	ld d,(hl)		;022e
	ld c,(hl)		;022f
	ld c,d			;0230
	ld d,l			;0231
	scf			;0232
	inc (hl)		;0233
	ld d,d			;0234
	ld b,(hl)		;0235
	ld b,e			;0236
	ld c,l			;0237
	ld c,e			;0238
	ld c,c			;0239
	jr c,l026fh		;023a
	ld b,l			;023c
l023dh:
	ld b,h			;023d
	ld e,b			;023e
	ld c,04ch		;023f
	ld c,a			;0241
	add hl,sp		;0242
	ld (05357h),a		;0243
	ld e,d			;0246
	jr nz,l0256h		;0247
	ld d,b			;0249
	jr nc,l027dh		;024a
	ld d,c			;024c
	ld b,c			;024d
	ex (sp),hl		;024e
	call nz,0e4e0h		;024f
l0252h:
	or h			;0252
	cp h			;0253
	cp l			;0254
	cp e			;0255
l0256h:
	xor a			;0256
l0257h:
	or b			;0257
	or c			;0258
	ret nz			;0259
	and a			;025a
	and (hl)		;025b
	cp (hl)			;025c
	xor l			;025d
	or d			;025e
	cp d			;025f
	push hl			;0260
	and l			;0261
	jp nz,0b3e1h		;0262
	cp c			;0265
	pop bc			;0266
	cp b			;0267
	ld a,(hl)		;0268
	call c,05cdah		;0269
	or a			;026c
	ld a,e			;026d
	ld a,l			;026e
l026fh:
	ret c			;026f
	cp a			;0270
	xor (hl)		;0271
	xor d			;0272
	xor e			;0273
	defb 0ddh,0deh,0dfh ;illegal sequence	;0274
	ld a,a			;0277
	or l			;0278
	sub 07ch		;0279
	push de			;027b
	ld e,l			;027c
l027dh:
	in a,(0b6h)		;027d
	exx			;027f
	ld e,e			;0280
	rst 10h			;0281
	inc c			;0282
	rlca			;0283
	ld b,004h		;0284
	dec b			;0286
	ex af,af'		;0287
	ld a,(bc)		;0288
	dec bc			;0289
	add hl,bc		;028a
	rrca			;028b
	jp po,l3f2ah		;028c
	call 0ccc8h		;028f
	bit 3,(hl)		;0292
	xor h			;0294
	dec l			;0295
	dec hl			;0296
	dec a			;0297
	ld l,02ch		;0298
	dec sp			;029a
	ld (l3cc7h),hl		;029b
	jp 0c53eh		;029e
	cpl			;02a1
	ret			;02a2
	ld h,b			;02a3
	add a,03ah		;02a4
	ret nc			;02a6
	adc a,0a8h		;02a7
	jp z,0d4d3h		;02a9
	pop de			;02ac
	jp nc,0cfa9h		;02ad
sub_02b0h:
	ld l,02fh		;02b0
	ld de,0ffffh		;02b2
	ld bc,0fefeh		;02b5
l02b8h:
	in a,(c)		;02b8
	cpl			;02ba
	and 01fh		;02bb
	jr z,l02cdh		;02bd
	ld h,a			;02bf
l02c0h:
	ld a,l			;02c0
l02c1h:
	inc d			;02c1
l02c2h:
	ret nz			;02c2
l02c3h:
	sub 008h		;02c3
	srl h			;02c5
	jr nc,l02c3h		;02c7
	ld d,e			;02c9
	ld e,a			;02ca
	jr nz,l02c1h		;02cb
l02cdh:
	dec l			;02cd
	rlc b			;02ce
	jr c,l02b8h		;02d0
	ld a,d			;02d2
	inc a			;02d3
	ret z			;02d4
	cp 028h			;02d5
	ret z			;02d7
	cp 019h			;02d8
	ret z			;02da
	ld a,e			;02db
	ld e,d			;02dc
	ld d,a			;02dd
	cp 018h			;02de
	ret			;02e0
sub_02e1h:
	call sub_02b0h		;02e1
	ret nz			;02e4
	ld hl,05c00h		;02e5
l02e8h:
	bit 7,(hl)		;02e8
	jr nz,l02f3h		;02ea
	inc hl			;02ec
	dec (hl)		;02ed
	dec hl			;02ee
	jr nz,l02f3h		;02ef
	ld (hl),0ffh		;02f1
l02f3h:
	ld a,l			;02f3
	ld hl,05c04h		;02f4
	cp l			;02f7
	jr nz,l02e8h		;02f8
	call sub_035ch		;02fa
	ret nc			;02fd
	res 5,(iy+030h)		;02fe
	ld hl,05c00h		;0302
	cp (hl)			;0305
	jr z,l0336h		;0306
	ex de,hl		;0308
	ld hl,05c04h		;0309
	cp (hl)			;030c
	jr z,l0336h		;030d
	bit 7,(hl)		;030f
	jr nz,l0317h		;0311
	ex de,hl		;0313
	bit 7,(hl)		;0314
	ret z			;0316
l0317h:
	ld e,a			;0317
	ld (hl),a		;0318
	inc hl			;0319
	ld (hl),005h		;031a
	inc hl			;031c
	ld a,(05c09h)		;031d
	ld (hl),a		;0320
	inc hl			;0321
	ld c,(iy+007h)		;0322
	ld d,(iy+001h)		;0325
	push hl			;0328
	call sub_0371h		;0329
	pop hl			;032c
	ld (hl),a		;032d
l032eh:
	ld (05c08h),a		;032e
	set 5,(iy+001h)		;0331
	ret			;0335
l0336h:
	inc hl			;0336
	ld (hl),005h		;0337
	inc hl			;0339
	ld a,(05c08h)		;033a
	cp 0ceh			;033d
	ret nc			;033f
	dec (hl)		;0340
	ret nz			;0341
	ld a,(05c0ah)		;0342
	ld (hl),a		;0345
	inc hl			;0346
	ld a,(hl)		;0347
	cp 00ch			;0348
	jr nz,l032eh		;034a
	set 5,(iy+030h)		;034c
	push af			;0350
	ld bc,04e20h		;0351
l0354h:
	dec bc			;0354
	ld a,c			;0355
	or b			;0356
	jr nz,l0354h		;0357
	pop af			;0359
	jr l032eh		;035a
sub_035ch:
	ld b,d			;035c
	ld d,000h		;035d
	ld a,e			;035f
	cp 027h			;0360
	ret nc			;0362
	cp 018h			;0363
	jr nz,l036ah		;0365
	bit 7,b			;0367
	ret nz			;0369
l036ah:
	ld hl,00227h		;036a
	add hl,de		;036d
	ld a,(hl)		;036e
	scf			;036f
	ret			;0370
sub_0371h:
	ld a,e			;0371
	cp 03ah			;0372
	jr c,l03a5h		;0374
	dec c			;0376
	jp m,l038dh		;0377
	jr z,l037fh		;037a
	add a,04fh		;037c
	ret			;037e
l037fh:
	ld hl,l020dh		;037f
	inc b			;0382
	jr z,l0388h		;0383
	ld hl,00227h		;0385
l0388h:
	ld d,000h		;0388
	add hl,de		;038a
	ld a,(hl)		;038b
	ret			;038c
l038dh:
	ld hl,0024bh		;038d
	bit 0,b			;0390
	jr z,l0388h		;0392
	bit 3,d			;0394
	jr z,l03a2h		;0396
	bit 3,(iy+030h)		;0398
	ret nz			;039c
	inc b			;039d
	ret nz			;039e
	add a,020h		;039f
l03a1h:
	ret			;03a1
l03a2h:
	add a,0a5h		;03a2
	ret			;03a4
l03a5h:
	cp 030h			;03a5
	ret c			;03a7
	dec c			;03a8
	jp m,l03dbh		;03a9
	jr nz,l03c7h		;03ac
	ld hl,00276h		;03ae
	bit 5,b			;03b1
	jr z,l0388h		;03b3
	cp 038h			;03b5
	jr nc,l03c0h		;03b7
	sub 020h		;03b9
	inc b			;03bb
	ret z			;03bc
	add a,008h		;03bd
	ret			;03bf
l03c0h:
	sub 036h		;03c0
	inc b			;03c2
	ret z			;03c3
	add a,0feh		;03c4
	ret			;03c6
l03c7h:
	ld hl,l0252h		;03c7
	cp 039h			;03ca
	jr z,l0388h		;03cc
	cp 030h			;03ce
	jr z,l0388h		;03d0
	and 007h		;03d2
	add a,080h		;03d4
	inc b			;03d6
	ret z			;03d7
	xor 00fh		;03d8
	ret			;03da
l03dbh:
	inc b			;03db
	ret z			;03dc
	bit 5,b			;03dd
	ld hl,l0252h		;03df
	jr nz,l0388h		;03e2
	sub 010h		;03e4
	cp 022h			;03e6
	jr z,l03f0h		;03e8
	cp 020h			;03ea
	ret nz			;03ec
	ld a,05fh		;03ed
	ret			;03ef
l03f0h:
	ld a,040h		;03f0
	ret			;03f2
l03f3h:
	ld (05dcdh),hl		;03f3
	ld hl,l1ffeh+2		;03f6
	jp l03fch		;03f9
l03fch:
	push hl			;03fc
	ld hl,0fefch		;03fd
	push hl			;0400
	ld hl,l0000h		;0401
	push hl			;0404
	push hl			;0405
	ld hl,(05dcdh)		;0406
	call sub_040dh		;0409
	ret			;040c
sub_040dh:
	push af			;040d
	ld a,(05cc2h)		;040e
	and a			;0411
	jr z,l0418h		;0412
	pop af			;0414
	jp 0fd90h		;0415
l0418h:
	pop af			;0418
	jp 065d0h		;0419
	nop			;041c
	nop			;041d
	djnz l03f3h		;041e
	cp 044h			;0420
	ld c,a			;0422
	bit 4,a			;0423
	jr nz,l0430h		;0425
	ld a,d			;0427
	or e			;0428
	jr z,l0434h		;0429
	ld a,c			;042b
	ld c,l			;042c
	dec de			;042d
	jp (ix)			;042e
l0430h:
	ld c,l			;0430
l0431h:
	inc c			;0431
	jp (ix)			;0432
l0434h:
	ei			;0434
	ret			;0435
	rst 28h			;0436
	ld sp,0c027h		;0437
	inc bc			;043a
	inc (hl)		;043b
	call pe,0986ch		;043c
	rra			;043f
	push af			;0440
	inc b			;0441
	and c			;0442
	rrca			;0443
	jr c,$+35		;0444
	sub d			;0446
	ld e,h			;0447
	ld a,(hl)		;0448
	and a			;0449
	jr nz,l04aah		;044a
	inc hl			;044c
	ld c,(hl)		;044d
	inc hl			;044e
	ld b,(hl)		;044f
	ld a,b			;0450
	rla			;0451
	sbc a,a			;0452
	cp c			;0453
	jr nz,l04aah		;0454
	inc hl			;0456
	cp (hl)			;0457
	jr nz,l04aah		;0458
	ld a,b			;045a
	add a,03ch		;045b
	jp p,l0463h		;045d
	jp po,l04aah		;0460
l0463h:
	ld b,0fah		;0463
l0465h:
	inc b			;0465
	sub 00ch		;0466
	jr nc,l0465h		;0468
	add a,00ch		;046a
	push bc			;046c
	ld hl,l04ach		;046d
	call sub_37c5h		;0470
	call sub_3773h		;0473
	rst 28h			;0476
	inc b			;0477
	jr c,$-13		;0478
	add a,(hl)		;047a
	ld (hl),a		;047b
	rst 28h			;047c
	ret nz			;047d
	ld (bc),a		;047e
	ld sp,0cd38h		;047f
	ld e,01fh		;0482
	cp 00bh			;0484
	jr nc,l04aah		;0486
	rst 28h			;0488
	ret po			;0489
	inc b			;048a
	ret po			;048b
	inc (hl)		;048c
	add a,b			;048d
	ld b,e			;048e
	ld d,l			;048f
	sbc a,a			;0490
	add a,b			;0491
	ld bc,l3405h		;0492
	dec (hl)		;0495
	ld (hl),c		;0496
	inc bc			;0497
	jr c,$-49		;0498
	inc hl			;049a
	rra			;049b
	push bc			;049c
	call sub_1f23h		;049d
	pop hl			;04a0
	ld d,b			;04a1
	ld e,c			;04a2
	ld a,d			;04a3
l04a4h:
	or e			;04a4
	ret z			;04a5
	dec de			;04a6
	jp l03f3h		;04a7
l04aah:
	rst 8			;04aa
	ld a,(bc)		;04ab
l04ach:
	adc a,c			;04ac
	ld (bc),a		;04ad
	ret nc			;04ae
	ld (de),a		;04af
	add a,(hl)		;04b0
	adc a,c			;04b1
	ld a,(bc)		;04b2
	sub a			;04b3
	ld h,b			;04b4
	ld (hl),l		;04b5
	adc a,c			;04b6
	ld (de),a		;04b7
	push de			;04b8
	rla			;04b9
	rra			;04ba
	adc a,c			;04bb
	dec de			;04bc
	sub b			;04bd
	ld b,c			;04be
	ld (bc),a		;04bf
l04c0h:
	adc a,c			;04c0
	inc h			;04c1
	ret nc			;04c2
	ld d,e			;04c3
	jp z,l2e89h		;04c4
	sbc a,l			;04c7
	ld (hl),0b1h		;04c8
	adc a,c			;04ca
	jr c,$+1		;04cb
	ld c,c			;04cd
	ld a,089h		;04ce
	ld b,e			;04d0
	rst 38h			;04d1
	ld l,d			;04d2
	ld (hl),e		;04d3
	adc a,c			;04d4
	ld c,a			;04d5
	and a			;04d6
	nop			;04d7
	ld d,h			;04d8
	adc a,c			;04d9
	ld e,h			;04da
	nop			;04db
	nop			;04dc
	nop			;04dd
	adc a,c			;04de
	ld l,c			;04df
	inc d			;04e0
l04e1h:
	or 024h			;04e1
l04e3h:
	adc a,c			;04e3
l04e4h:
	halt			;04e4
l04e5h:
	pop af			;04e5
	djnz $+7		;04e6
l04e8h:
	ld de,05c92h		;04e8
	ld (05dd7h),de		;04eb
	jp l0a1dh		;04ef
l04f2h:
	ld hl,l1639h		;04f2
l04f5h:
	jp l0a50h		;04f5
l04f8h:
	ld hl,01636h		;04f8
	jr l04f5h		;04fb
	ret			;04fd
	ret			;04fe
	ret			;04ff
l0500h:
	call sub_0a09h		;0500
	cp 020h			;0503
	jp nc,l05f0h		;0505
	cp 00ch			;0508
	jr nz,l0513h		;050a
	bit 4,(iy+001h)		;050c
	jp z,l05f0h		;0510
l0513h:
	cp 006h			;0513
	jr c,l0580h		;0515
	cp 018h			;0517
	jr nc,l0580h		;0519
	ld hl,l0522h		;051b
	ld e,a			;051e
	ld d,000h		;051f
	add hl,de		;0521
l0522h:
	ld e,(hl)		;0522
l0523h:
	add hl,de		;0523
	push hl			;0524
	jp l061ah		;0525
	ld c,(hl)		;0528
	ld d,a			;0529
	djnz $+43		;052a
	ld d,h			;052c
	ld d,e			;052d
	ld d,d			;052e
	scf			;052f
	ld d,b			;0530
	ld c,a			;0531
	ld e,a			;0532
	ld e,(hl)		;0533
	ld e,l			;0534
	ld e,h			;0535
	ld e,e			;0536
	ld e,d			;0537
	ld d,h			;0538
	ld d,e			;0539
	inc c			;053a
	ld a,022h		;053b
	cp c			;053d
	jr nz,l0551h		;053e
	bit 1,(iy+001h)		;0540
	jr nz,l054fh		;0544
	inc b			;0546
	ld c,002h		;0547
	ld a,019h		;0549
	cp b			;054b
	jr nz,l0551h		;054c
	dec b			;054e
l054fh:
	ld c,021h		;054f
l0551h:
	jp l0914h		;0551
	ld a,(05c91h)		;0554
	push af			;0557
	ld (iy+057h),001h	;0558
	ld a,020h		;055c
	call l05f0h		;055e
	pop af			;0561
	ld (05c91h),a		;0562
	ret			;0565
	bit 1,(iy+001h)		;0566
	jp nz,l0a23h		;056a
	ld c,021h		;056d
	call sub_0790h		;056f
	dec b			;0572
	jp l0914h		;0573
	call l061ah		;0576
	ld a,c			;0579
	dec a			;057a
	dec a			;057b
	and 010h		;057c
	jr l05dah		;057e
l0580h:
	ld a,03fh		;0580
	jr l05f0h		;0582
l0584h:
	ld de,l059eh		;0584
	ld (05c0fh),a		;0587
	jr l0597h		;058a
	ld de,l0584h		;058c
	jr l0594h		;058f
	ld de,l059eh		;0591
l0594h:
	ld (05c0eh),a		;0594
l0597h:
	ld hl,(05c51h)		;0597
	ld (hl),e		;059a
	inc hl			;059b
	ld (hl),d		;059c
	ret			;059d
l059eh:
	ld de,l0500h		;059e
	call l0597h		;05a1
	ld hl,(05c0eh)		;05a4
	ld d,a			;05a7
	ld a,l			;05a8
	cp 016h			;05a9
	jp c,l23bbh		;05ab
	jr nz,l05d9h		;05ae
	ld b,h			;05b0
	ld c,d			;05b1
	ld a,01fh		;05b2
	sub c			;05b4
	jr c,l05c3h		;05b5
	add a,002h		;05b7
	ld c,a			;05b9
	bit 1,(iy+001h)		;05ba
	jr nz,l05d6h		;05be
	ld a,016h		;05c0
	sub b			;05c2
l05c3h:
	jp c,l1f29h		;05c3
	inc a			;05c6
	ld b,a			;05c7
	inc b			;05c8
	bit 0,(iy+002h)		;05c9
	jp nz,sub_0790h		;05cd
	cp (iy+031h)		;05d0
	jp c,l07c1h		;05d3
l05d6h:
	jp l0914h		;05d6
l05d9h:
	ld a,h			;05d9
l05dah:
	call l061ah		;05da
	add a,c			;05dd
	dec a			;05de
	and 01fh		;05df
	ret z			;05e1
	ld d,a			;05e2
	set 0,(iy+001h)		;05e3
l05e7h:
	ld a,020h		;05e7
	call sub_0776h		;05e9
	dec d			;05ec
	jr nz,l05e7h		;05ed
	ret			;05ef
l05f0h:
	call sub_063bh		;05f0
l05f3h:
	bit 1,(iy+001h)		;05f3
	jr nz,l0613h		;05f7
	bit 0,(iy+002h)		;05f9
	jr nz,l0607h		;05fd
	ld (05c88h),bc		;05ff
	ld (05c84h),hl		;0603
	ret			;0606
l0607h:
	ld (05c8ah),bc		;0607
	ld (05c82h),bc		;060b
	ld (05c86h),hl		;060f
	ret			;0612
l0613h:
	ld (iy+045h),c		;0613
	ld (05c80h),hl		;0616
	ret			;0619
l061ah:
	bit 1,(iy+001h)		;061a
l061eh:
	jr nz,l0634h		;061e
	ld bc,(05c88h)		;0620
	ld hl,(05c84h)		;0624
	bit 0,(iy+002h)		;0627
	ret z			;062b
	ld bc,(05c8ah)		;062c
l0630h:
	ld hl,(05c86h)		;0630
	ret			;0633
l0634h:
	ld c,(iy+045h)		;0634
	ld hl,(05c80h)		;0637
	ret			;063a
sub_063bh:
	cp 00ch			;063b
	jr nz,l0643h		;063d
	ld a,07ah		;063f
	jr l0694h		;0641
l0643h:
	cp 07ch			;0643
	jr z,l0694h		;0645
	cp 07eh			;0647
	jr z,l0694h		;0649
	cp 07bh			;064b
	jr c,l0659h		;064d
	cp 080h			;064f
	jr nc,l0659h		;0651
	bit 4,(iy+001h)		;0653
	jr z,l0694h		;0657
l0659h:
	cp 080h			;0659
	jr c,l069ah		;065b
	cp 090h			;065d
	jr nc,l0687h		;065f
	ld b,a			;0661
	call sub_066dh		;0662
	call l061ah		;0665
	ld de,05c92h		;0668
	jr l06b4h		;066b
sub_066dh:
	ld hl,05c92h		;066d
	call sub_0673h		;0670
sub_0673h:
	rr b			;0673
	sbc a,a			;0675
	and 00fh		;0676
	ld c,a			;0678
	rr b			;0679
	sbc a,a			;067b
	and 0f0h		;067c
	or c			;067e
	ld c,004h		;067f
l0681h:
	ld (hl),a		;0681
	inc hl			;0682
	dec c			;0683
	jr nz,l0681h		;0684
	ret			;0686
l0687h:
	sub 0a5h		;0687
	jr nc,l0694h		;0689
	add a,015h		;068b
	push bc			;068d
	ld bc,(05c7bh)		;068e
	jr l069fh		;0692
l0694h:
	call sub_0745h		;0694
	jp l061ah		;0697
l069ah:
	push bc			;069a
	ld bc,(05c36h)		;069b
l069fh:
	ex de,hl		;069f
	ld hl,05c3bh		;06a0
	res 0,(hl)		;06a3
	cp 020h			;06a5
	jr nz,l06abh		;06a7
	set 0,(hl)		;06a9
l06abh:
	ld h,000h		;06ab
	ld l,a			;06ad
	add hl,hl		;06ae
	add hl,hl		;06af
	add hl,hl		;06b0
	add hl,bc		;06b1
	pop bc			;06b2
	ex de,hl		;06b3
l06b4h:
	ld a,c			;06b4
	dec a			;06b5
	ld a,021h		;06b6
	jr nz,l06c8h		;06b8
	dec b			;06ba
	ld c,a			;06bb
	bit 1,(iy+001h)		;06bc
	jr z,l06c8h		;06c0
	push de			;06c2
	call l0a23h		;06c3
	pop de			;06c6
	ld a,c			;06c7
l06c8h:
	cp c			;06c8
	push de			;06c9
	call z,sub_0790h	;06ca
	pop de			;06cd
	push bc			;06ce
	push hl			;06cf
	ld a,(05c91h)		;06d0
	ld b,0ffh		;06d3
	rra			;06d5
	jr c,l06d9h		;06d6
	inc b			;06d8
l06d9h:
	rra			;06d9
	rra			;06da
	sbc a,a			;06db
	ld c,a			;06dc
	ld a,008h		;06dd
	and a			;06df
	bit 1,(iy+001h)		;06e0
	jr z,l06ebh		;06e4
	set 1,(iy+030h)		;06e6
	scf			;06ea
l06ebh:
	ex de,hl		;06eb
l06ech:
	ex af,af'		;06ec
	ld a,(de)		;06ed
	and b			;06ee
	xor (hl)		;06ef
	xor c			;06f0
	ld (de),a		;06f1
	ex af,af'		;06f2
	jr c,l0708h		;06f3
	inc d			;06f5
l06f6h:
	inc hl			;06f6
	dec a			;06f7
	jr nz,l06ech		;06f8
	ex de,hl		;06fa
	dec h			;06fb
	bit 1,(iy+001h)		;06fc
	call z,sub_0710h	;0700
	pop hl			;0703
	pop bc			;0704
	dec c			;0705
	inc hl			;0706
	ret			;0707
l0708h:
	ex af,af'		;0708
	ld a,020h		;0709
	add a,e			;070b
	ld e,a			;070c
	ex af,af'		;070d
	jr l06f6h		;070e
sub_0710h:
	ld a,h			;0710
	rrca			;0711
	rrca			;0712
	rrca			;0713
	and 003h		;0714
	or 058h			;0716
	ld h,a			;0718
	ld de,(05c8fh)		;0719
	ld a,(hl)		;071d
	xor e			;071e
	and d			;071f
l0720h:
	xor e			;0720
	bit 6,(iy+057h)		;0721
	jr z,l072fh		;0725
	and 0c7h		;0727
	bit 2,a			;0729
	jr nz,l072fh		;072b
	xor 038h		;072d
l072fh:
	bit 4,(iy+057h)		;072f
	jr z,l073dh		;0733
	and 0f8h		;0735
	bit 5,a			;0737
	jr nz,l073dh		;0739
	xor 007h		;073b
l073dh:
	ld (hl),a		;073d
	ret			;073e
sub_073fh:
	push hl			;073f
	ld h,000h		;0740
	ex (sp),hl		;0742
	jr l074fh		;0743
sub_0745h:
	ld de,l0098h		;0745
	cp 05bh			;0748
	jr c,l074eh		;074a
	sub 01fh		;074c
l074eh:
	push af			;074e
l074fh:
	call sub_077ch		;074f
	jr c,l075dh		;0752
	ld a,020h		;0754
	bit 0,(iy+001h)		;0756
	call z,sub_0776h	;075a
l075dh:
	ld a,(de)		;075d
	and 07fh		;075e
	call sub_0776h		;0760
	ld a,(de)		;0763
	inc de			;0764
	add a,a			;0765
	jr nc,l075dh		;0766
	pop de			;0768
	cp 048h			;0769
	jr z,l0770h		;076b
	cp 082h			;076d
	ret c			;076f
l0770h:
	ld a,d			;0770
	cp 003h			;0771
	ret c			;0773
	ld a,020h		;0774
sub_0776h:
	push de			;0776
	exx			;0777
	rst 10h			;0778
	exx			;0779
	pop de			;077a
	ret			;077b
sub_077ch:
	push af			;077c
	ex de,hl		;077d
	inc a			;077e
l077fh:
	bit 7,(hl)		;077f
	inc hl			;0781
	jr z,l077fh		;0782
	dec a			;0784
	jr nz,l077fh		;0785
	ex de,hl		;0787
	pop af			;0788
	cp 020h			;0789
	ret c			;078b
	ld a,(de)		;078c
	sub 041h		;078d
	ret			;078f
sub_0790h:
	bit 1,(iy+001h)		;0790
	ret nz			;0794
	ld de,l0914h		;0795
	push de			;0798
	ld a,b			;0799
	bit 0,(iy+002h)		;079a
	jp nz,l083dh		;079e
	cp (iy+031h)		;07a1
	jr c,l07c1h		;07a4
	ret nz			;07a6
	bit 4,(iy+002h)		;07a7
	jr z,l07c3h		;07ab
	ld e,(iy+02dh)		;07ad
	dec e			;07b0
	jr z,l080dh		;07b1
	ld a,000h		;07b3
	call sub_1230h		;07b5
	ld sp,(05c3fh)		;07b8
	res 4,(iy+002h)		;07bc
	ret			;07c0
l07c1h:
	rst 8			;07c1
	inc b			;07c2
l07c3h:
	dec (iy+052h)		;07c3
	jr nz,l080dh		;07c6
	ld a,018h		;07c8
	sub b			;07ca
	ld (05c8ch),a		;07cb
	ld hl,(05c8fh)		;07ce
	push hl			;07d1
	ld a,(05c91h)		;07d2
	push af			;07d5
	ld a,0fdh		;07d6
	call sub_1230h		;07d8
	xor a			;07db
	ld de,l0833h		;07dc
	call sub_073fh		;07df
	set 5,(iy+002h)		;07e2
	ld hl,05c3bh		;07e6
	set 3,(hl)		;07e9
	res 5,(hl)		;07eb
	exx			;07ed
	call sub_11cfh		;07ee
	exx			;07f1
	cp 020h			;07f2
	jr z,l083bh		;07f4
	cp 0e2h			;07f6
	jr z,l083bh		;07f8
	or 020h			;07fa
	cp 06eh			;07fc
	jr z,l083bh		;07fe
	ld a,0feh		;0800
	call sub_1230h		;0802
	pop af			;0805
	ld (05c91h),a		;0806
	pop hl			;0809
	ld (05c8fh),hl		;080a
l080dh:
	call sub_0939h		;080d
	ld b,(iy+031h)		;0810
	inc b			;0813
	ld c,021h		;0814
	push bc			;0816
	call sub_09d6h		;0817
	ld a,h			;081a
	rrca			;081b
	rrca			;081c
	rrca			;081d
	and 003h		;081e
	or 058h			;0820
	ld h,a			;0822
	ld de,05ae0h		;0823
	ld a,(de)		;0826
	ld c,(hl)		;0827
	ld b,020h		;0828
	ex de,hl		;082a
l082bh:
	ld (de),a		;082b
	ld (hl),c		;082c
	inc de			;082d
	inc hl			;082e
	djnz l082bh		;082f
	pop bc			;0831
	ret			;0832
l0833h:
	add a,b			;0833
	ld (hl),e		;0834
	ld h,e			;0835
	ld (hl),d		;0836
	ld l,a			;0837
	ld l,h			;0838
	ld l,h			;0839
	cp a			;083a
l083bh:
	rst 8			;083b
	inc c			;083c
l083dh:
	cp 002h			;083d
	jr c,l07c1h		;083f
	add a,(iy+031h)		;0841
	sub 019h		;0844
	ret nc			;0846
	neg			;0847
	push bc			;0849
	ld b,a			;084a
	ld hl,(05c8fh)		;084b
	push hl			;084e
	ld hl,(05c91h)		;084f
	push hl			;0852
	call sub_0888h		;0853
	ld a,b			;0856
l0857h:
	push af			;0857
	ld hl,05c6bh		;0858
	ld b,(hl)		;085b
	ld a,b			;085c
	inc a			;085d
	ld (hl),a		;085e
	ld hl,05c89h		;085f
	cp (hl)			;0862
	jr c,l0868h		;0863
	inc (hl)		;0865
	ld b,018h		;0866
l0868h:
	call sub_093bh		;0868
	pop af			;086b
	dec a			;086c
	jr nz,l0857h		;086d
	pop hl			;086f
	ld (iy+057h),l		;0870
	pop hl			;0873
	ld (05c8fh),hl		;0874
	ld bc,(05c88h)		;0877
	res 0,(iy+002h)		;087b
	call l0914h		;087f
	set 0,(iy+002h)		;0882
	pop bc			;0886
	ret			;0887
sub_0888h:
	xor a			;0888
	ld hl,(05c8dh)		;0889
	bit 0,(iy+002h)		;088c
	jr z,l0896h		;0890
	ld h,a			;0892
	ld l,(iy+00eh)		;0893
l0896h:
	ld (05c8fh),hl		;0896
	ld hl,05c91h		;0899
	jr nz,l08a0h		;089c
	ld a,(hl)		;089e
	rrca			;089f
l08a0h:
	xor (hl)		;08a0
	and 055h		;08a1
	xor (hl)		;08a3
	ld (hl),a		;08a4
	ret			;08a5
sub_08a6h:
	call sub_08eah		;08a6
sub_08a9h:
	ld hl,05c3ch		;08a9
	res 5,(hl)		;08ac
	set 0,(hl)		;08ae
	call sub_0888h		;08b0
	ld b,(iy+031h)		;08b3
	call sub_097fh		;08b6
	ld hl,05ac0h		;08b9
	ld a,(05c8dh)		;08bc
	dec b			;08bf
	jr l08c9h		;08c0
l08c2h:
	ld c,020h		;08c2
l08c4h:
	dec hl			;08c4
	ld (hl),a		;08c5
	dec c			;08c6
	jr nz,l08c4h		;08c7
l08c9h:
	djnz l08c2h		;08c9
	ld (iy+031h),002h	;08cb
sub_08cfh:
	ld a,0fdh		;08cf
	call sub_1230h		;08d1
	ld hl,(05c51h)		;08d4
	ld de,l0500h		;08d7
	and a			;08da
l08dbh:
	ld (hl),e		;08db
	inc hl			;08dc
	ld (hl),d		;08dd
	inc hl			;08de
	ld de,l0c0eh		;08df
	ccf			;08e2
	jr c,l08dbh		;08e3
	ld bc,l1721h		;08e5
	jr l0914h		;08e8
sub_08eah:
	ld hl,l0000h		;08ea
	ld (05c7dh),hl		;08ed
	res 0,(iy+030h)		;08f0
	call sub_08cfh		;08f4
	ld a,0feh		;08f7
	call sub_1230h		;08f9
	call sub_0888h		;08fc
	ld b,018h		;08ff
	call sub_097fh		;0901
	ld hl,(05c51h)		;0904
	ld de,l0500h		;0907
	ld (hl),e		;090a
	inc hl			;090b
	ld (hl),d		;090c
	ld (iy+052h),001h	;090d
	ld bc,01821h		;0911
l0914h:
	ld hl,05b00h		;0914
	bit 1,(iy+001h)		;0917
	jr nz,l092fh		;091b
	ld a,b			;091d
	bit 0,(iy+002h)		;091e
	jr z,l0929h		;0922
	add a,(iy+031h)		;0924
	sub 018h		;0927
l0929h:
	push bc			;0929
	ld b,a			;092a
	call sub_09d6h		;092b
	pop bc			;092e
l092fh:
	ld a,021h		;092f
	sub c			;0931
	ld e,a			;0932
	ld d,000h		;0933
	add hl,de		;0935
	jp l05f3h		;0936
sub_0939h:
	ld b,017h		;0939
sub_093bh:
	call sub_09d6h		;093b
	ld c,008h		;093e
l0940h:
	push bc			;0940
	push hl			;0941
	ld a,b			;0942
	and 007h		;0943
	ld a,b			;0945
	jr nz,l0954h		;0946
l0948h:
	ex de,hl		;0948
	ld hl,0f8e0h		;0949
	add hl,de		;094c
	ex de,hl		;094d
	ld bc,l0020h		;094e
	dec a			;0951
	ldir			;0952
l0954h:
	ex de,hl		;0954
	ld hl,0ffe0h		;0955
	add hl,de		;0958
	ex de,hl		;0959
	ld b,a			;095a
	and 007h		;095b
	rrca			;095d
	rrca			;095e
	rrca			;095f
	ld c,a			;0960
	ld a,b			;0961
	ld b,000h		;0962
	ldir			;0964
	ld b,007h		;0966
	add hl,bc		;0968
	and 0f8h		;0969
	jr nz,l0948h		;096b
	pop hl			;096d
	inc h			;096e
	pop bc			;096f
	dec c			;0970
	jr nz,l0940h		;0971
	call sub_09c3h		;0973
	ld hl,0ffe0h		;0976
	add hl,de		;0979
	ex de,hl		;097a
	ldir			;097b
	ld b,001h		;097d
sub_097fh:
	push bc			;097f
	call sub_09d6h		;0980
	ld c,008h		;0983
l0985h:
	push bc			;0985
	push hl			;0986
	ld a,b			;0987
l0988h:
	and 007h		;0988
	rrca			;098a
	rrca			;098b
	rrca			;098c
	ld c,a			;098d
	ld a,b			;098e
	ld b,000h		;098f
	dec c			;0991
	ld d,h			;0992
	ld e,l			;0993
	ld (hl),000h		;0994
	inc de			;0996
	ldir			;0997
	ld de,00701h		;0999
	add hl,de		;099c
	dec a			;099d
	and 0f8h		;099e
	ld b,a			;09a0
	jr nz,l0988h		;09a1
	pop hl			;09a3
	inc h			;09a4
	pop bc			;09a5
	dec c			;09a6
	jr nz,l0985h		;09a7
	call sub_09c3h		;09a9
	ld h,d			;09ac
	ld l,e			;09ad
	inc de			;09ae
	ld a,(05c8dh)		;09af
	bit 0,(iy+002h)		;09b2
	jr z,l09bbh		;09b6
	ld a,(05c48h)		;09b8
l09bbh:
	ld (hl),a		;09bb
	dec bc			;09bc
	ldir			;09bd
	pop bc			;09bf
	ld c,021h		;09c0
	ret			;09c2
sub_09c3h:
	ld a,h			;09c3
	rrca			;09c4
	rrca			;09c5
	rrca			;09c6
	dec a			;09c7
	or 050h			;09c8
	ld h,a			;09ca
	ex de,hl		;09cb
	ld h,c			;09cc
	ld l,b			;09cd
	add hl,hl		;09ce
	add hl,hl		;09cf
	add hl,hl		;09d0
	add hl,hl		;09d1
	add hl,hl		;09d2
	ld b,h			;09d3
	ld c,l			;09d4
	ret			;09d5
sub_09d6h:
	ld a,018h		;09d6
	sub b			;09d8
	ld d,a			;09d9
	rrca			;09da
l09dbh:
	rrca			;09db
	rrca			;09dc
	and 0e0h		;09dd
	ld l,a			;09df
	ld a,d			;09e0
	and 018h		;09e1
	or 040h			;09e3
	ld h,a			;09e5
	ret			;09e6
	push af			;09e7
	push bc			;09e8
	push de			;09e9
	ld bc,09c40h		;09ea
l09edh:
	dec bc			;09ed
	ld a,c			;09ee
	or b			;09ef
	jr nz,l09edh		;09f0
l09f2h:
	xor a			;09f2
	in a,(0feh)		;09f3
	and 01fh		;09f5
	cp 01fh			;09f7
	jr z,l09f2h		;09f9
	call sub_08a9h		;09fb
	pop de			;09fe
	pop bc			;09ff
	pop af			;0a00
	ret			;0a01
	exx			;0a02
	ld hl,l1630h		;0a03
	jp l3ce3h		;0a06
sub_0a09h:
	ld c,a			;0a09
	ld a,(05ddbh)		;0a0a
	rrca			;0a0d
	ld a,c			;0a0e
	jp nc,l061ah		;0a0f
	bit 1,(iy+001h)		;0a12
	jp z,l061eh		;0a16
	cp 080h			;0a19
	jr nc,l0a68h		;0a1b
l0a1dh:
	ld (05dcdh),hl		;0a1d
	jp l04f2h		;0a20
l0a23h:
	jp l3cf8h		;0a23
l0a26h:
	ld (05dcdh),hl		;0a26
	ld hl,0163ch		;0a29
	jp l0a50h		;0a2c
	nop			;0a2f
	ld a,004h		;0a30
	out (0fbh),a		;0a32
	ei			;0a34
sub_0a35h:
	ld hl,05b00h		;0a35
	ld (iy+046h),l		;0a38
	xor a			;0a3b
	ld b,a			;0a3c
l0a3dh:
	ld (hl),a		;0a3d
	inc hl			;0a3e
	djnz l0a3dh		;0a3f
	res 1,(iy+030h)		;0a41
	ld c,021h		;0a45
	jp l0914h		;0a47
	ld (05dcdh),hl		;0a4a
	ld hl,l1633h		;0a4d
l0a50h:
	push hl			;0a50
	ld hl,0fefch		;0a51
	push hl			;0a54
	push af			;0a55
	ld a,(05cc2h)		;0a56
	and a			;0a59
	ld hl,(05dcdh)		;0a5a
	jp nz,l0a64h		;0a5d
	pop af			;0a60
	call 06572h		;0a61
l0a64h:
	pop af			;0a64
	call 0fd32h		;0a65
l0a68h:
	cp 0a5h			;0a68
	jp c,l0a73h		;0a6a
	sub 0a5h		;0a6d
	call sub_0745h		;0a6f
	ret			;0a72
l0a73h:
	cp 090h			;0a73
	jp nc,l0a26h		;0a75
	ld b,a			;0a78
	push af			;0a79
	call sub_066dh		;0a7a
	pop af			;0a7d
	jp l04e8h		;0a7e
	nop			;0a81
sub_0a82h:
	ld hl,(05c3dh)		;0a82
	push hl			;0a85
l0a86h:
	ld hl,l0be5h		;0a86
	push hl			;0a89
	ld (05c3dh),sp		;0a8a
l0a8eh:
	call sub_11cfh		;0a8e
	push af			;0a91
	ld d,000h		;0a92
	ld e,(iy-001h)		;0a94
	ld hl,l00c8h		;0a97
	call l03f3h		;0a9a
	pop af			;0a9d
	ld hl,l0a8eh		;0a9e
	push hl			;0aa1
	cp 00ch			;0aa2
	jr nz,l0ab2h		;0aa4
	bit 5,(iy+030h)		;0aa6
	jr nz,l0ab2h		;0aaa
	bit 3,(iy+001h)		;0aac
	jr z,l0ae7h		;0ab0
l0ab2h:
	cp 018h			;0ab2
	jr nc,l0ae7h		;0ab4
	cp 007h			;0ab6
	jr c,l0ae7h		;0ab8
	cp 010h			;0aba
	jr c,l0af8h		;0abc
	ld bc,l0002h		;0abe
	ld d,a			;0ac1
	cp 016h			;0ac2
	jr c,l0ad2h		;0ac4
	inc bc			;0ac6
	bit 7,(iy+037h)		;0ac7
	jp z,l0b84h		;0acb
	call sub_11cfh		;0ace
	ld e,a			;0ad1
l0ad2h:
	call sub_11cfh		;0ad2
	push de			;0ad5
	ld hl,(05c5bh)		;0ad6
	res 0,(iy+007h)		;0ad9
	call sub_12bbh		;0add
	pop bc			;0ae0
	inc hl			;0ae1
	ld (hl),b		;0ae2
	inc hl			;0ae3
	ld (hl),c		;0ae4
	jr l0af1h		;0ae5
l0ae7h:
	res 0,(iy+007h)		;0ae7
	ld hl,(05c5bh)		;0aeb
	call sub_12b8h		;0aee
l0af1h:
	ld (de),a		;0af1
	inc de			;0af2
	ld (05c5bh),de		;0af3
	ret			;0af7
l0af8h:
	ld e,a			;0af8
	ld d,000h		;0af9
	ld hl,l0affh		;0afb
	add hl,de		;0afe
l0affh:
	ld e,(hl)		;0aff
	add hl,de		;0b00
	push hl			;0b01
	ld hl,(05c5bh)		;0b02
	ret			;0b05
	add hl,bc		;0b06
	ld h,(hl)		;0b07
	ld l,d			;0b08
	ld d,b			;0b09
	or l			;0b0a
	ld (hl),b		;0b0b
	ld a,(hl)		;0b0c
	rst 8			;0b0d
	call nc,0492ah		;0b0e
	ld e,h			;0b11
	bit 5,(iy+037h)		;0b12
	jp nz,l0bfdh		;0b16
	call sub_16d6h		;0b19
	call sub_1324h		;0b1c
	ld a,d			;0b1f
	or e			;0b20
	jp z,l0bfdh		;0b21
	push hl			;0b24
	inc hl			;0b25
	ld c,(hl)		;0b26
	inc hl			;0b27
	ld b,(hl)		;0b28
	ld hl,l0008h+2		;0b29
	add hl,bc		;0b2c
	ld b,h			;0b2d
	ld c,l			;0b2e
	call sub_1fbbh		;0b2f
	call l0bfdh		;0b32
	ld hl,(05c51h)		;0b35
	ex (sp),hl		;0b38
	push hl			;0b39
	ld a,0ffh		;0b3a
	call sub_1230h		;0b3c
	pop hl			;0b3f
	dec hl			;0b40
	dec (iy+00fh)		;0b41
	call sub_15ach		;0b44
	inc (iy+00fh)		;0b47
	ld hl,(05c59h)		;0b4a
	inc hl			;0b4d
	inc hl			;0b4e
	inc hl			;0b4f
	inc hl			;0b50
	ld (05c5bh),hl		;0b51
	pop hl			;0b54
	call sub_1248h		;0b55
	ret			;0b58
	bit 5,(iy+037h)		;0b59
	jr nz,l0b67h		;0b5d
	ld hl,05c49h		;0b5f
	call sub_165bh		;0b62
	jr l0bd4h		;0b65
l0b67h:
	ld (iy+000h),010h	;0b67
	jr l0b8ah		;0b6b
	call sub_0b97h		;0b6d
	jr l0b77h		;0b70
	ld a,(hl)		;0b72
	cp 00dh			;0b73
	ret z			;0b75
	inc hl			;0b76
l0b77h:
	ld (05c5bh),hl		;0b77
	ret			;0b7a
	call sub_0b97h		;0b7b
	ld bc,l0001h		;0b7e
	jp l1750h		;0b81
l0b84h:
	call sub_11cfh		;0b84
	call sub_11cfh		;0b87
l0b8ah:
	pop hl			;0b8a
	pop hl			;0b8b
l0b8ch:
	pop hl			;0b8c
	ld (05c3dh),hl		;0b8d
	bit 7,(iy+000h)		;0b90
	ret nz			;0b94
	ld sp,hl		;0b95
	ret			;0b96
sub_0b97h:
	scf			;0b97
	call sub_0cfbh		;0b98
	sbc hl,de		;0b9b
	add hl,de		;0b9d
	inc hl			;0b9e
	pop bc			;0b9f
	ret c			;0ba0
	push bc			;0ba1
	ld b,h			;0ba2
	ld c,l			;0ba3
l0ba4h:
	ld h,d			;0ba4
	ld l,e			;0ba5
	inc hl			;0ba6
	ld a,(de)		;0ba7
	and 0f0h		;0ba8
	cp 010h			;0baa
	jr nz,l0bb7h		;0bac
	inc hl			;0bae
	ld a,(de)		;0baf
	sub 017h		;0bb0
	adc a,000h		;0bb2
	jr nz,l0bb7h		;0bb4
	inc hl			;0bb6
l0bb7h:
	and a			;0bb7
	sbc hl,bc		;0bb8
	add hl,bc		;0bba
	ex de,hl		;0bbb
	jr c,l0ba4h		;0bbc
	ret			;0bbe
	bit 5,(iy+037h)		;0bbf
	ret nz			;0bc3
	ld hl,(05c49h)		;0bc4
	call sub_16d6h		;0bc7
	ex de,hl		;0bca
	call sub_1324h		;0bcb
	ld hl,05c4ah		;0bce
	call sub_1668h		;0bd1
l0bd4h:
	call sub_14e1h		;0bd4
	ld a,000h		;0bd7
	jp sub_1230h		;0bd9
	bit 7,(iy+037h)		;0bdc
	jr z,l0b8ah		;0be0
	jp l0ae7h		;0be2
l0be5h:
	bit 4,(iy+030h)		;0be5
	jr z,l0b8ch		;0be9
	ld (iy+000h),0ffh	;0beb
	ld d,000h		;0bef
	ld e,(iy-002h)		;0bf1
	ld hl,l1a8fh+1		;0bf4
	call l03f3h		;0bf7
	jp l0a86h		;0bfa
l0bfdh:
	push hl			;0bfd
	call sub_0cf6h		;0bfe
	dec hl			;0c01
	call sub_174dh		;0c02
	ld (05c5bh),hl		;0c05
	ld (iy+007h),000h	;0c08
	pop hl			;0c0c
	ret			;0c0d
l0c0eh:
	bit 3,(iy+002h)		;0c0e
	call nz,sub_0c83h	;0c12
	and a			;0c15
	bit 5,(iy+001h)		;0c16
	ret z			;0c1a
	ld a,(05c08h)		;0c1b
	res 5,(iy+001h)		;0c1e
	push af			;0c22
	bit 5,(iy+002h)		;0c23
	call nz,sub_08a9h	;0c27
	pop af			;0c2a
	cp 020h			;0c2b
	jr nc,l0c81h		;0c2d
	cp 010h			;0c2f
	jr nc,l0c60h		;0c31
	cp 006h			;0c33
	jr nc,l0c41h		;0c35
	ld b,a			;0c37
	and 001h		;0c38
	ld c,a			;0c3a
	ld a,b			;0c3b
	rra			;0c3c
	add a,012h		;0c3d
	jr l0c6bh		;0c3f
l0c41h:
	jr nz,l0c4ch		;0c41
	ld hl,05c6ah		;0c43
	ld a,008h		;0c46
	xor (hl)		;0c48
	ld (hl),a		;0c49
	jr l0c5ah		;0c4a
l0c4ch:
	cp 00eh			;0c4c
	ret c			;0c4e
	sub 00dh		;0c4f
	ld hl,05c41h		;0c51
	cp (hl)			;0c54
	ld (hl),a		;0c55
	jr nz,l0c5ah		;0c56
	ld (hl),000h		;0c58
l0c5ah:
	set 3,(iy+002h)		;0c5a
	cp a			;0c5e
	ret			;0c5f
l0c60h:
	ld b,a			;0c60
	and 007h		;0c61
	ld c,a			;0c63
	ld a,010h		;0c64
	bit 3,b			;0c66
	jr nz,l0c6bh		;0c68
	inc a			;0c6a
l0c6bh:
	ld (iy-02dh),c		;0c6b
	ld de,l0c73h		;0c6e
	jr l0c79h		;0c71
l0c73h:
	ld a,(05c0dh)		;0c73
	ld de,l0c0eh		;0c76
l0c79h:
	ld hl,(05c4fh)		;0c79
	inc hl			;0c7c
	inc hl			;0c7d
	ld (hl),e		;0c7e
	inc hl			;0c7f
	ld (hl),d		;0c80
l0c81h:
	scf			;0c81
	ret			;0c82
sub_0c83h:
	call sub_0888h		;0c83
	res 3,(iy+002h)		;0c86
	res 5,(iy+002h)		;0c8a
	ld hl,(05c8ah)		;0c8e
	push hl			;0c91
	ld hl,(05c3dh)		;0c92
	push hl			;0c95
	ld hl,l0ccdh		;0c96
	push hl			;0c99
	ld (05c3dh),sp		;0c9a
	ld hl,(05c82h)		;0c9e
	push hl			;0ca1
	scf			;0ca2
	call sub_0cfbh		;0ca3
	ex de,hl		;0ca6
	call sub_15c9h		;0ca7
	ex de,hl		;0caa
	call sub_162dh		;0cab
	ld hl,(05c8ah)		;0cae
	ex (sp),hl		;0cb1
	ex de,hl		;0cb2
	call sub_0888h		;0cb3
l0cb6h:
	ld a,(05c8bh)		;0cb6
	sub d			;0cb9
	jr c,l0ce2h		;0cba
	jr nz,l0cc4h		;0cbc
	ld a,e			;0cbe
	sub (iy+050h)		;0cbf
	jr nc,l0ce2h		;0cc2
l0cc4h:
	ld a,020h		;0cc4
	push de			;0cc6
	call l0500h		;0cc7
	pop de			;0cca
	jr l0cb6h		;0ccb
l0ccdh:
	ld d,000h		;0ccd
	ld e,(iy-002h)		;0ccf
	ld hl,l1a8fh+1		;0cd2
	call l03f3h		;0cd5
	ld (iy+000h),0ffh	;0cd8
	ld de,(05c8ah)		;0cdc
	jr l0ce4h		;0ce0
l0ce2h:
	pop de			;0ce2
	pop hl			;0ce3
l0ce4h:
	pop hl			;0ce4
	ld (05c3dh),hl		;0ce5
	pop bc			;0ce8
	push de			;0ce9
	call l0914h		;0cea
	pop hl			;0ced
	ld (05c82h),hl		;0cee
	ld (iy+026h),000h	;0cf1
	ret			;0cf5
sub_0cf6h:
	ld hl,(05c61h)		;0cf6
	dec hl			;0cf9
	and a			;0cfa
sub_0cfbh:
	ld de,(05c59h)		;0cfb
	bit 5,(iy+037h)		;0cff
	ret z			;0d03
	ld de,(05c61h)		;0d04
	ret c			;0d08
	ld hl,(05c63h)		;0d09
	ret			;0d0c
l0d0dh:
	ld a,(hl)		;0d0d
	cp 00eh			;0d0e
	ld bc,l0005h+1		;0d10
	call z,l1750h		;0d13
	ld a,(hl)		;0d16
	inc hl			;0d17
	cp 00dh			;0d18
	jr nz,l0d0dh		;0d1a
	ret			;0d1c
	di			;0d1d
	ld a,0ffh		;0d1e
	ld de,(05cb2h)		;0d20
	exx			;0d24
	ld bc,(05cb4h)		;0d25
	ld de,(05c38h)		;0d29
	ld hl,(05c7bh)		;0d2d
	exx			;0d30
l0d31h:
	ld b,a			;0d31
	ld a,007h		;0d32
	out (0feh),a		;0d34
	ld a,03fh		;0d36
	ld i,a			;0d38
	nop			;0d3a
	nop			;0d3b
	nop			;0d3c
	nop			;0d3d
	nop			;0d3e
	nop			;0d3f
	ld h,d			;0d40
	ld l,e			;0d41
l0d42h:
	ld (hl),002h		;0d42
	dec hl			;0d44
	cp h			;0d45
	jr nz,l0d42h		;0d46
l0d48h:
	and a			;0d48
	sbc hl,de		;0d49
	add hl,de		;0d4b
	inc hl			;0d4c
	jr nc,l0d55h		;0d4d
	dec (hl)		;0d4f
	jr z,l0d55h		;0d50
	dec (hl)		;0d52
	jr z,l0d48h		;0d53
l0d55h:
	dec hl			;0d55
	exx			;0d56
	ld (05cb4h),bc		;0d57
	ld (05c38h),de		;0d5b
	ld (05c7bh),hl		;0d5f
	exx			;0d62
	inc b			;0d63
	jr z,l0d7fh		;0d64
	ld (05cb4h),hl		;0d66
	ld de,l3eafh		;0d69
	ld bc,l00a8h		;0d6c
	ex de,hl		;0d6f
	lddr			;0d70
	ex de,hl		;0d72
	inc hl			;0d73
	ld (05c7bh),hl		;0d74
	dec hl			;0d77
	ld bc,00040h		;0d78
	ld (05c38h),bc		;0d7b
l0d7fh:
	ld (05cb2h),hl		;0d7f
	ld hl,l3c00h		;0d82
	ld (05c36h),hl		;0d85
	ld hl,06200h		;0d88
	ld (05cc0h),hl		;0d8b
	dec hl			;0d8e
	ld (hl),03eh		;0d8f
	dec hl			;0d91
	ld sp,hl		;0d92
	dec hl			;0d93
	dec hl			;0d94
	ld (05c3dh),hl		;0d95
	im 1			;0d98
	nop			;0d9a
	ld iy,05c3ah		;0d9b
	ld hl,06840h		;0d9f
	ld (05c4fh),hl		;0da2
	ld de,l11aah		;0da5
	ld bc,l0015h		;0da8
	ex de,hl		;0dab
	ldir			;0dac
	ex de,hl		;0dae
	ld a,038h		;0daf
	ld (05c8dh),a		;0db1
	ld (05c8fh),a		;0db4
	ld (05c48h),a		;0db7
	ld hl,l0523h		;0dba
	ld (05c09h),hl		;0dbd
	dec (iy-03ah)		;0dc0
	dec (iy-036h)		;0dc3
	ld hl,l11c1h		;0dc6
	ld de,05c10h		;0dc9
	ld bc,l000eh		;0dcc
	ldir			;0dcf
	xor a			;0dd1
	out (0ffh),a		;0dd2
	set 1,(iy+001h)		;0dd4
	call sub_0a35h		;0dd8
	ld (iy+031h),002h	;0ddb
	call sub_08a6h		;0ddf
	xor a			;0de2
	set 4,(iy+001h)		;0de3
	ld de,l1117h		;0de7
	call sub_073fh		;0dea
	set 5,(iy+002h)		;0ded
	ld hl,l0e0bh		;0df1
	ld de,06000h		;0df4
	ld bc,l001ch+1		;0df7
	ldir			;0dfa
	call 06000h		;0dfc
	ld hl,065ceh		;0dff
	ld (065ceh),hl		;0e02
	ld hl,008e7h		;0e05
	call 06815h		;0e08
l0e0bh:
	ld a,003h		;0e0b
	out (0f4h),a		;0e0d
	in a,(0ffh)		;0e0f
	set 7,a			;0e11
	out (0ffh),a		;0e13
	ld hl,l1000h		;0e15
	ld de,06200h		;0e18
	ld bc,l0630h		;0e1b
	ldir			;0e1e
	res 7,a			;0e20
	out (0ffh),a		;0e22
	xor a			;0e24
	out (0f4h),a		;0e25
	ret			;0e27
l0e28h:
	ld (iy+031h),002h	;0e28
	call sub_14e1h		;0e2c
l0e2fh:
	call sub_133fh		;0e2f
l0e32h:
	ld a,000h		;0e32
	call sub_1230h		;0e34
	call sub_0a82h		;0e37
	call sub_1a27h		;0e3a
	bit 7,(iy+000h)		;0e3d
	jr nz,l0e55h		;0e41
	bit 4,(iy+030h)		;0e43
	jr z,l0e8dh		;0e47
	ld hl,(05c59h)		;0e49
	call l0d0dh		;0e4c
	ld (iy+000h),0ffh	;0e4f
	jr l0e32h		;0e53
l0e55h:
	ld hl,(05c59h)		;0e55
	ld (05c5dh),hl		;0e58
	call sub_1768h		;0e5b
	ld a,b			;0e5e
	or c			;0e5f
	jp nz,l1158h		;0e60
	rst 18h			;0e63
	cp 00dh			;0e64
	jr z,l0e28h		;0e66
	bit 0,(iy+030h)		;0e68
	call nz,sub_08eah	;0e6c
	call sub_08a9h		;0e6f
	ld a,019h		;0e72
	sub (iy+04fh)		;0e74
	ld (05c8ch),a		;0e77
	set 7,(iy+001h)		;0e7a
	ld (iy+000h),0ffh	;0e7e
	ld (iy+00ah),001h	;0e82
	ld (iy+07ch),000h	;0e86
	call sub_1ad8h		;0e8a
l0e8dh:
	halt			;0e8d
	ld a,(iy+000h)		;0e8e
	cp 0ffh			;0e91
	jr z,l0ec8h		;0e93
	bit 7,(iy+07dh)		;0e95
	jr z,l0ec8h		;0e99
	set 6,(iy+07dh)		;0e9b
	inc a			;0e9f
	ld (05cbbh),a		;0ea0
	ld (iy+000h),0ffh	;0ea3
	ld hl,(05c45h)		;0ea7
	ld (05cb8h),hl		;0eaa
	ld a,(05c47h)		;0ead
	ld (05cbah),a		;0eb0
	ld hl,(05cb6h)		;0eb3
	res 7,h			;0eb6
	res 6,h			;0eb8
	ld (05c42h),hl		;0eba
	ld (iy+00ah),001h	;0ebd
	ld hl,l0e8dh		;0ec1
	push hl			;0ec4
	jp l1ab9h		;0ec5
l0ec8h:
	ld a,007h		;0ec8
	out (0f5h),a		;0eca
	ld a,0ffh		;0ecc
	out (0f6h),a		;0ece
	res 3,(iy+002h)		;0ed0
	res 5,(iy+001h)		;0ed4
	bit 1,(iy+030h)		;0ed8
	call nz,l0a23h		;0edc
	ld a,(05c3ah)		;0edf
	inc a			;0ee2
l0ee3h:
	push af			;0ee3
	ld hl,l0000h		;0ee4
	ld (iy+037h),h		;0ee7
	ld (iy+026h),h		;0eea
	ld (05c0bh),hl		;0eed
	ld hl,l0001h		;0ef0
	ld (05c16h),hl		;0ef3
	call sub_133fh		;0ef6
	res 5,(iy+037h)		;0ef9
	call sub_08a9h		;0efd
	set 5,(iy+002h)		;0f00
l0f04h:
	pop af			;0f04
	ld b,a			;0f05
	cp 00ah			;0f06
	jr c,l0f0ch		;0f08
	add a,007h		;0f0a
l0f0ch:
	call sub_11eah		;0f0c
	ld a,020h		;0f0f
	rst 10h			;0f11
	ld a,b			;0f12
	ld de,l0f65h		;0f13
	call sub_073fh		;0f16
	xor a			;0f19
	ld de,l1115h		;0f1a
	call sub_073fh		;0f1d
	ld bc,(05c45h)		;0f20
	call sub_1788h		;0f24
	ld a,03ah		;0f27
	rst 10h			;0f29
	ld c,(iy+00dh)		;0f2a
	ld b,000h		;0f2d
	call sub_1788h		;0f2f
	call l0bfdh		;0f32
	ld a,(05c3ah)		;0f35
	inc a			;0f38
	jr z,l0f56h		;0f39
	cp 009h			;0f3b
	jr z,l0f43h		;0f3d
	cp 015h			;0f3f
	jr nz,l0f46h		;0f41
l0f43h:
	inc (iy+00dh)		;0f43
l0f46h:
	ld bc,l0002h+1		;0f46
	ld de,05c70h		;0f49
	ld hl,05c44h		;0f4c
	bit 7,(hl)		;0f4f
	jr z,l0f54h		;0f51
	add hl,bc		;0f53
l0f54h:
	lddr			;0f54
l0f56h:
	ld (iy+00ah),0ffh	;0f56
	res 3,(iy+001h)		;0f5a
	res 3,(iy+002h)		;0f5e
	jp l0e32h		;0f62
l0f65h:
	add a,b			;0f65
	ld c,a			;0f66
	bit 1,(hl)		;0f67
	ld b,l			;0f69
	ld e,b			;0f6a
	ld d,h			;0f6b
	jr nz,$+121		;0f6c
	ld l,c			;0f6e
	ld (hl),h		;0f6f
	ld l,b			;0f70
	ld l,a			;0f71
	ld (hl),l		;0f72
	ld (hl),h		;0f73
	jr nz,l0fbch		;0f74
	ld c,a			;0f76
	jp nc,06156h		;0f77
	ld (hl),d		;0f7a
	ld l,c			;0f7b
	ld h,c			;0f7c
	ld h,d			;0f7d
	ld l,h			;0f7e
	ld h,l			;0f7f
	jr nz,l0ff0h		;0f80
	ld l,a			;0f82
	ld (hl),h		;0f83
	jr nz,l0fech		;0f84
	ld l,a			;0f86
	ld (hl),l		;0f87
	ld l,(hl)		;0f88
	call po,07553h		;0f89
	ld h,d			;0f8c
	ld (hl),e		;0f8d
	ld h,e			;0f8e
	ld (hl),d		;0f8f
	ld l,c			;0f90
	ld (hl),b		;0f91
	ld (hl),h		;0f92
	jr nz,l100ch		;0f93
	ld (hl),d		;0f95
	ld l,a			;0f96
	ld l,(hl)		;0f97
	rst 20h			;0f98
	ld c,a			;0f99
	ld (hl),l		;0f9a
	ld (hl),h		;0f9b
	jr nz,$+113		;0f9c
	ld h,(hl)		;0f9e
	jr nz,l100eh		;0f9f
	ld h,l			;0fa1
l0fa2h:
	ld l,l			;0fa2
	ld l,a			;0fa3
	ld (hl),d		;0fa4
	ld sp,hl		;0fa5
	ld c,a			;0fa6
	ld (hl),l		;0fa7
	ld (hl),h		;0fa8
	jr nz,l101ah		;0fa9
	ld h,(hl)		;0fab
	jr nz,l1021h		;0fac
	ld h,e			;0fae
	ld (hl),d		;0faf
	ld h,l			;0fb0
	ld h,l			;0fb1
	xor 04eh		;0fb2
	ld (hl),l		;0fb4
	ld l,l			;0fb5
	ld h,d			;0fb6
	ld h,l			;0fb7
	ld (hl),d		;0fb8
	jr nz,l102fh		;0fb9
	ld l,a			;0fbb
l0fbch:
	ld l,a			;0fbc
	jr nz,l1021h		;0fbd
	ld l,c			;0fbf
	rst 20h			;0fc0
	ld d,d			;0fc1
	ld b,l			;0fc2
	ld d,h			;0fc3
	ld d,l			;0fc4
	ld d,d			;0fc5
	ld c,(hl)		;0fc6
	jr nz,l1040h		;0fc7
	ld l,c			;0fc9
	ld (hl),h		;0fca
	ld l,b			;0fcb
	ld l,a			;0fcc
	ld (hl),l		;0fcd
	ld (hl),h		;0fce
	jr nz,l1018h		;0fcf
	ld c,a			;0fd1
	ld d,e			;0fd2
	ld d,l			;0fd3
	jp nz,06e45h		;0fd4
	ld h,h			;0fd7
	jr nz,l1049h		;0fd8
	ld h,(hl)		;0fda
	jr nz,l1043h		;0fdb
	ld l,c			;0fdd
	ld l,h			;0fde
	push hl			;0fdf
l0fe0h:
	ld d,e			;0fe0
	ld d,h			;0fe1
	ld c,a			;0fe2
	ld d,b			;0fe3
	jr nz,l1059h		;0fe4
	ld (hl),h		;0fe6
	ld h,c			;0fe7
	ld (hl),h		;0fe8
	ld h,l			;0fe9
	ld l,l			;0fea
	ld h,l			;0feb
l0fech:
	ld l,(hl)		;0fec
	call p,06e49h		;0fed
l0ff0h:
	halt			;0ff0
	ld h,c			;0ff1
	ld l,h			;0ff2
	ld l,c			;0ff3
	ld h,h			;0ff4
	jr nz,l1058h		;0ff5
	ld (hl),d		;0ff7
	ld h,a			;0ff8
	ld (hl),l		;0ff9
	ld l,l			;0ffa
	ld h,l			;0ffb
	ld l,(hl)		;0ffc
	call p,06e49h		;0ffd
l1000h:
	ld (hl),h		;1000
	ld h,l			;1001
	ld h,a			;1002
	ld h,l			;1003
	ld (hl),d		;1004
	jr nz,l1076h		;1005
	ld (hl),l		;1007
	ld (hl),h		;1008
	jr nz,l107ah		;1009
	ld h,(hl)		;100b
l100ch:
	jr nz,$+116		;100c
l100eh:
	ld h,c			;100e
	ld l,(hl)		;100f
	ld h,a			;1010
	push hl			;1011
	ld c,(hl)		;1012
	ld l,a			;1013
	ld l,(hl)		;1014
	ld (hl),e		;1015
	ld h,l			;1016
	ld l,(hl)		;1017
l1018h:
	ld (hl),e		;1018
	ld h,l			;1019
l101ah:
	jr nz,l1085h		;101a
	ld l,(hl)		;101c
	jr nz,l1061h		;101d
	ld b,c			;101f
	ld d,e			;1020
l1021h:
	ld c,c			;1021
	jp 05242h		;1022
	ld b,l			;1025
	ld b,c			;1026
	ld c,e			;1027
	jr nz,l1057h		;1028
	jr nz,l106fh		;102a
	ld c,a			;102c
	ld c,(hl)		;102d
	ld d,h			;102e
l102fh:
	jr nz,l10a3h		;102f
	ld h,l			;1031
	ld (hl),b		;1032
	ld h,l			;1033
	ld h,c			;1034
	ld (hl),h		;1035
	di			;1036
	ld c,a			;1037
	ld (hl),l		;1038
	ld (hl),h		;1039
	jr nz,l10abh		;103a
	ld h,(hl)		;103c
	jr nz,l1083h		;103d
	ld b,c			;103f
l1040h:
	ld d,h			;1040
	pop bc			;1041
	ld c,c			;1042
l1043h:
	ld l,(hl)		;1043
	halt			;1044
	ld h,c			;1045
	ld l,h			;1046
	ld l,c			;1047
	ld h,h			;1048
l1049h:
	jr nz,$+104		;1049
	ld l,c			;104b
	ld l,h			;104c
	ld h,l			;104d
	jr nz,l10beh		;104e
	ld h,c			;1050
	ld l,l			;1051
	push hl			;1052
	ld c,(hl)		;1053
	ld l,a			;1054
	jr nz,$+116		;1055
l1057h:
	ld l,a			;1057
l1058h:
	ld l,a			;1058
l1059h:
	ld l,l			;1059
l105ah:
	jr nz,l10c2h		;105a
	ld l,a			;105c
	ld (hl),d		;105d
	jr nz,l10cch		;105e
	ld l,c			;1060
l1061h:
	ld l,(hl)		;1061
	push hl			;1062
	ld d,e			;1063
	ld d,h			;1064
	ld c,a			;1065
	ld d,b			;1066
	jr nz,l10d2h		;1067
	ld l,(hl)		;1069
	jr nz,l10b5h		;106a
	ld c,(hl)		;106c
	ld d,b			;106d
	ld d,l			;106e
l106fh:
	call nc,04f46h		;106f
	ld d,d			;1072
	jr nz,l10ech		;1073
	ld l,c			;1075
l1076h:
	ld (hl),h		;1076
	ld l,b			;1077
	ld l,a			;1078
	ld (hl),l		;1079
l107ah:
	ld (hl),h		;107a
	jr nz,l10cbh		;107b
	ld b,l			;107d
	ld e,b			;107e
	call nc,06e49h		;107f
	halt			;1082
l1083h:
	ld h,c			;1083
	ld l,h			;1084
l1085h:
	ld l,c			;1085
	ld h,h			;1086
	jr nz,l10d2h		;1087
	cpl			;1089
	ld c,a			;108a
	jr nz,l10f1h		;108b
	ld h,l			;108d
	halt			;108e
	ld l,c			;108f
	ld h,e			;1090
	push hl			;1091
	ld c,c			;1092
	ld l,(hl)		;1093
	halt			;1094
	ld h,c			;1095
	ld l,h			;1096
	ld l,c			;1097
	ld h,h			;1098
	jr nz,l10feh		;1099
	ld l,a			;109b
	ld l,h			;109c
	ld l,a			;109d
	jp p,05242h		;109e
	ld b,l			;10a1
	ld b,c			;10a2
l10a3h:
	ld c,e			;10a3
	jr nz,l110fh		;10a4
	ld l,(hl)		;10a6
	ld (hl),h		;10a7
	ld l,a			;10a8
	jr nz,l111bh		;10a9
l10abh:
	ld (hl),d		;10ab
	ld l,a			;10ac
	ld h,a			;10ad
	ld (hl),d		;10ae
	ld h,c			;10af
	sbc hl,de		;10b0
	ld b,c			;10b2
	ld c,l			;10b3
	ld d,h			;10b4
l10b5h:
	ld c,a			;10b5
	ld d,b			;10b6
	jr nz,l1127h		;10b7
	ld l,a			;10b9
	jr nz,l1123h		;10ba
	ld l,a			;10bc
	ld l,a			;10bd
l10beh:
	call po,07453h		;10be
	ld h,c			;10c1
l10c2h:
	ld (hl),h		;10c2
	ld h,l			;10c3
	ld l,l			;10c4
	ld h,l			;10c5
	ld l,(hl)		;10c6
	ld (hl),h		;10c7
	jr nz,l1136h		;10c8
	ld l,a			;10ca
l10cbh:
	ld (hl),e		;10cb
l10cch:
	call p,06e49h		;10cc
	halt			;10cf
	ld h,c			;10d0
	ld l,h			;10d1
l10d2h:
	ld l,c			;10d2
	ld h,h			;10d3
	jr nz,l1149h		;10d4
	ld (hl),h		;10d6
	ld (hl),d		;10d7
	ld h,l			;10d8
	ld h,c			;10d9
	im 0			;10da
	ld c,(hl)		;10dc
	jr nz,$+121		;10dd
	ld l,c			;10df
	ld (hl),h		;10e0
	ld l,b			;10e1
	ld l,a			;10e2
	ld (hl),l		;10e3
	ld (hl),h		;10e4
	jr nz,l112bh		;10e5
	ld b,l			;10e7
	add a,050h		;10e8
	ld h,c			;10ea
	ld (hl),d		;10eb
l10ech:
	ld h,c			;10ec
	ld l,l			;10ed
	ld h,l			;10ee
	ld (hl),h		;10ef
	ld h,l			;10f0
l10f1h:
	ld (hl),d		;10f1
	jr nz,$+103		;10f2
	ld (hl),d		;10f4
	ld (hl),d		;10f5
	ld l,a			;10f6
	jp p,06154h		;10f7
	ld (hl),b		;10fa
	ld h,l			;10fb
	jr nz,l116ah		;10fc
l10feh:
	ld l,a			;10fe
	ld h,c			;10ff
	ld h,h			;1100
	ld l,c			;1101
	ld l,(hl)		;1102
	ld h,a			;1103
	jr nz,l116bh		;1104
	ld (hl),d		;1106
	ld (hl),d		;1107
	ld l,a			;1108
	jp p,0694dh		;1109
	ld (hl),e		;110c
	ld (hl),e		;110d
	ld l,c			;110e
l110fh:
	ld l,(hl)		;110f
	ld h,a			;1110
	jr nz,l115fh		;1111
	ld d,d			;1113
	ld c,a			;1114
l1115h:
	out (02ch),a		;1115
l1117h:
	and b			;1117
	ld a,a			;1118
	jr nz,$+51		;1119
l111bh:
	add hl,sp		;111b
	jr c,l1150h		;111c
	jr nz,$+85		;111e
	ld l,c			;1120
	ld l,(hl)		;1121
	ld h,e			;1122
l1123h:
	ld l,h			;1123
	ld h,c			;1124
	ld l,c			;1125
	ld (hl),d		;1126
l1127h:
	jr nz,l117bh		;1127
	ld h,l			;1129
	ld (hl),e		;112a
l112bh:
	ld h,l			;112b
	ld h,c			;112c
	ld (hl),d		;112d
	ld h,e			;112e
	ld l,b			;112f
	jr nz,l117eh		;1130
	ld (hl),h		;1132
	ld h,h			;1133
	dec c			;1134
	dec c			;1135
l1136h:
	ld a,a			;1136
	jr nz,l116ah		;1137
	add hl,sp		;1139
	jr c,$+53		;113a
	jr nz,l1192h		;113c
	ld l,c			;113e
	ld l,l			;113f
	ld h,l			;1140
	ld a,b			;1141
	jr nz,$+69		;1142
	ld l,a			;1144
	ld l,l			;1145
	ld (hl),b		;1146
	ld (hl),l		;1147
	ld (hl),h		;1148
l1149h:
	ld h,l			;1149
	ld (hl),d		;114a
	jr nz,l1190h		;114b
	ld l,a			;114d
	ld (hl),d		;114e
	ret p			;114f
l1150h:
	ld a,010h		;1150
	ld bc,l0000h		;1152
	jp l0ee3h		;1155
l1158h:
	ld (05c49h),bc		;1158
	ld hl,(05c5dh)		;115c
l115fh:
	ex de,hl		;115f
	ld hl,l1150h		;1160
	push hl			;1163
	ld hl,(05c61h)		;1164
	scf			;1167
	sbc hl,de		;1168
l116ah:
	push hl			;116a
l116bh:
	ld h,b			;116b
	ld l,c			;116c
	call sub_16d6h		;116d
	jr nz,l1178h		;1170
	call sub_1720h		;1172
	call l1750h		;1175
l1178h:
	pop bc			;1178
	ld a,c			;1179
	dec a			;117a
l117bh:
	or b			;117b
	jr z,l11a6h		;117c
l117eh:
	push bc			;117e
	inc bc			;117f
	inc bc			;1180
	inc bc			;1181
	inc bc			;1182
	dec hl			;1183
	ld de,(05c53h)		;1184
	push de			;1188
	call sub_12bbh		;1189
	pop hl			;118c
	ld (05c53h),hl		;118d
l1190h:
	pop bc			;1190
	push bc			;1191
l1192h:
	inc de			;1192
	ld hl,(05c61h)		;1193
	dec hl			;1196
	dec hl			;1197
	lddr			;1198
	ld hl,(05c49h)		;119a
	ex de,hl		;119d
	pop bc			;119e
	ld (hl),b		;119f
	dec hl			;11a0
	ld (hl),c		;11a1
	dec hl			;11a2
	ld (hl),e		;11a3
	dec hl			;11a4
	ld (hl),d		;11a5
l11a6h:
	pop af			;11a6
	jp l0e28h		;11a7
l11aah:
	nop			;11aa
	dec b			;11ab
	ld c,00ch		;11ac
	ld c,e			;11ae
	nop			;11af
	dec b			;11b0
	cp a			;11b1
	ld de,0e753h		;11b2
	ld a,(bc)		;11b5
	cp a			;11b6
	ld de,l0052h		;11b7
	dec b			;11ba
	cp a			;11bb
	ld de,08050h		;11bc
	rst 8			;11bf
	ld (de),a		;11c0
l11c1h:
	ld bc,00600h		;11c1
	nop			;11c4
	dec bc			;11c5
	nop			;11c6
	ld bc,l00ffh+1		;11c7
	nop			;11ca
	ld b,000h		;11cb
	djnz sub_11cfh		;11cd
sub_11cfh:
	bit 5,(iy+002h)		;11cf
	jr nz,l11d9h		;11d3
	set 3,(iy+002h)		;11d5
l11d9h:
	call sub_11e1h		;11d9
	ret c			;11dc
	jr z,l11d9h		;11dd
	rst 8			;11df
	rlca			;11e0
sub_11e1h:
	exx			;11e1
	push hl			;11e2
	ld hl,(05c51h)		;11e3
	inc hl			;11e6
	inc hl			;11e7
	jr l11f2h		;11e8
sub_11eah:
	ld e,030h		;11ea
	add a,e			;11ec
l11edh:
	exx			;11ed
	push hl			;11ee
	ld hl,(05c51h)		;11ef
l11f2h:
	ex af,af'		;11f2
	ld a,(05cbfh)		;11f3
	cp 002h			;11f6
	jr nc,l1205h		;11f8
	ex af,af'		;11fa
	ld e,(hl)		;11fb
	inc hl			;11fc
	ld d,(hl)		;11fd
	ex de,hl		;11fe
	call sub_1264h		;11ff
	pop hl			;1202
	exx			;1203
	ret			;1204
l1205h:
	ex af,af'		;1205
	ld hl,(05c51h)		;1206
	ld b,(hl)		;1209
	ld c,088h		;120a
	ld a,(05cc6h)		;120c
	bit 0,a			;120f
	jr nz,l1215h		;1211
	inc hl			;1213
	inc hl			;1214
l1215h:
	ld a,(05ccbh)		;1215
	ld e,a			;1218
	ld d,000h		;1219
	push de			;121b
	ld de,l0005h+2		;121c
	add hl,de		;121f
	push hl			;1220
	push bc			;1221
	ld bc,l0002h		;1222
	push bc			;1225
	ld bc,l0000h		;1226
	push bc			;1229
	call 065d0h		;122a
	pop hl			;122d
	exx			;122e
	ret			;122f
sub_1230h:
	add a,a			;1230
	add a,016h		;1231
	ld l,a			;1233
	ld h,05ch		;1234
	ld e,(hl)		;1236
	inc hl			;1237
	ld d,(hl)		;1238
	ld a,d			;1239
	or e			;123a
	jr nz,l123fh		;123b
l123dh:
	rst 8			;123d
	rla			;123e
l123fh:
	cp 080h			;123f
	jr nc,l1265h		;1241
	dec de			;1243
	ld hl,(05c4fh)		;1244
	add hl,de		;1247
sub_1248h:
	ld (05c51h),hl		;1248
	ld a,000h		;124b
	ld (05cbfh),a		;124d
	res 4,(iy+030h)		;1250
	inc hl			;1254
	inc hl			;1255
	inc hl			;1256
	inc hl			;1257
	ld c,(hl)		;1258
	ld hl,l1293h		;1259
	call sub_136bh		;125c
	ret nc			;125f
	ld d,000h		;1260
	ld e,(hl)		;1262
	add hl,de		;1263
sub_1264h:
	jp (hl)			;1264
l1265h:
	ld hl,(05cbch)		;1265
	sub 080h		;1268
	ld d,a			;126a
	add hl,de		;126b
	ld (05c51h),hl		;126c
	ld a,(hl)		;126f
	ld (05cbfh),a		;1270
	res 4,(iy+030h)		;1273
	inc hl			;1277
	inc hl			;1278
	inc hl			;1279
	inc hl			;127a
	inc hl			;127b
	inc hl			;127c
	ld a,(05cbfh)		;127d
	ld b,a			;1280
	ld c,088h		;1281
	ld d,(hl)		;1283
	inc hl			;1284
	ld e,(hl)		;1285
	ld h,d			;1286
	ld l,e			;1287
	push hl			;1288
	push bc			;1289
	ld bc,l0000h		;128a
	push bc			;128d
	push bc			;128e
	call 065d0h		;128f
	ret			;1292
l1293h:
	ld c,e			;1293
	ld b,053h		;1294
	ld (de),a		;1296
	ld d,b			;1297
	dec de			;1298
	nop			;1299
	set 0,(iy+002h)		;129a
	res 5,(iy+001h)		;129e
	set 4,(iy+030h)		;12a2
	jr l12ach		;12a6
	res 0,(iy+002h)		;12a8
l12ach:
	res 1,(iy+001h)		;12ac
	jp sub_0888h		;12b0
	set 1,(iy+001h)		;12b3
	ret			;12b7
sub_12b8h:
	ld bc,l0001h		;12b8
sub_12bbh:
	push hl			;12bb
	call sub_1fbbh		;12bc
	pop hl			;12bf
	call sub_12cah		;12c0
	ld hl,(05c65h)		;12c3
	ex de,hl		;12c6
	lddr			;12c7
	ret			;12c9
sub_12cah:
	push af			;12ca
	push hl			;12cb
	ld hl,05cc4h		;12cc
	ld e,(hl)		;12cf
	inc hl			;12d0
	ld d,(hl)		;12d1
	ex (sp),hl		;12d2
	and a			;12d3
	sbc hl,de		;12d4
	add hl,de		;12d6
	ex (sp),hl		;12d7
	jr nc,l12e0h		;12d8
	ex de,hl		;12da
	add hl,bc		;12db
	ex de,hl		;12dc
	ld (hl),d		;12dd
	dec hl			;12de
	ld (hl),e		;12df
l12e0h:
	ld hl,05c4bh		;12e0
	ld a,00eh		;12e3
l12e5h:
	cp 009h			;12e5
	jr z,l12edh		;12e7
	cp 008h			;12e9
	jr nz,l12fah		;12eb
l12edh:
	push hl			;12ed
	ld hl,05cc6h		;12ee
	ld l,(hl)		;12f1
	bit 7,l			;12f2
	pop hl			;12f4
	jr z,l12fah		;12f5
	inc hl			;12f7
	jr l130eh		;12f8
l12fah:
	ld e,(hl)		;12fa
	inc hl			;12fb
	ld d,(hl)		;12fc
	ex (sp),hl		;12fd
	and a			;12fe
	sbc hl,de		;12ff
	add hl,de		;1301
	ex (sp),hl		;1302
	jr nc,l130eh		;1303
	push de			;1305
	ex de,hl		;1306
	add hl,bc		;1307
	ex de,hl		;1308
	ld (hl),d		;1309
	dec hl			;130a
	ld (hl),e		;130b
	inc hl			;130c
	pop de			;130d
l130eh:
	inc hl			;130e
	dec a			;130f
	jr nz,l12e5h		;1310
	ex de,hl		;1312
	pop de			;1313
	pop af			;1314
	and a			;1315
	sbc hl,de		;1316
	ld b,h			;1318
	ld c,l			;1319
	inc bc			;131a
	add hl,de		;131b
	ex de,hl		;131c
	ret			;131d
l131eh:
	nop			;131e
	nop			;131f
l1320h:
	ex de,hl		;1320
	ld de,l131eh		;1321
sub_1324h:
	ld a,(hl)		;1324
	and 0c0h		;1325
	jr nz,l1320h		;1327
	ld d,(hl)		;1329
	inc hl			;132a
	ld e,(hl)		;132b
	ret			;132c
l132dh:
	ld hl,(05c63h)		;132d
	dec hl			;1330
	call sub_12bbh		;1331
	inc hl			;1334
	inc hl			;1335
	pop bc			;1336
	ld (05c61h),bc		;1337
	pop bc			;133b
	ex de,hl		;133c
	inc hl			;133d
	ret			;133e
sub_133fh:
	ld hl,(05c59h)		;133f
	ld (hl),00dh		;1342
	ld (05c5bh),hl		;1344
	inc hl			;1347
	ld (hl),080h		;1348
	inc hl			;134a
	ld (05c61h),hl		;134b
sub_134eh:
	ld hl,(05c61h)		;134e
	ld (05c63h),hl		;1351
l1354h:
	ld hl,(05c63h)		;1354
	ld (05c65h),hl		;1357
	push hl			;135a
	ld hl,05c92h		;135b
	ld (05c68h),hl		;135e
	pop hl			;1361
	ret			;1362
	ld de,(05c59h)		;1363
	jp sub_174dh		;1367
l136ah:
	inc hl			;136a
sub_136bh:
	ld a,(hl)		;136b
	and a			;136c
	ret z			;136d
	cp c			;136e
	inc hl			;136f
	jr nz,l136ah		;1370
	scf			;1372
	ret			;1373
sub_1374h:
	ld hl,(05cbch)		;1374
	ld de,0000ch		;1377
	add hl,de		;137a
l137bh:
	ld a,(hl)		;137b
	cp 080h			;137c
	jr z,l139ah		;137e
	inc hl			;1380
	inc hl			;1381
	cp 001h			;1382
	jr nz,l138ah		;1384
	ld a,(hl)		;1386
	cp c			;1387
	jr z,l139ch		;1388
l138ah:
	push hl			;138a
	ex de,hl		;138b
	ld de,l0018h		;138c
	add hl,de		;138f
	ex de,hl		;1390
	pop hl			;1391
	push de			;1392
	ld de,l0016h		;1393
	add hl,de		;1396
	pop de			;1397
	jr l137bh		;1398
l139ah:
	and a			;139a
	ret			;139b
l139ch:
	dec hl			;139c
	scf			;139d
	ret			;139e
	call sub_140fh		;139f
	ld a,b			;13a2
	or c			;13a3
	ret z			;13a4
	call sub_13beh		;13a5
sub_13a8h:
	ld bc,l0000h		;13a8
	ld de,0a3e2h		;13ab
	ex de,hl		;13ae
	add hl,de		;13af
	jr c,l13b9h		;13b0
	ld bc,sub_11cfh		;13b2
	add hl,bc		;13b5
	ld c,(hl)		;13b6
	inc hl			;13b7
	ld b,(hl)		;13b8
l13b9h:
	ex de,hl		;13b9
	ld (hl),c		;13ba
	inc hl			;13bb
	ld (hl),b		;13bc
	ret			;13bd
sub_13beh:
	push hl			;13be
	ld a,b			;13bf
	cp 080h			;13c0
	jr nc,l13d8h		;13c2
	ld hl,(05c4fh)		;13c4
	add hl,bc		;13c7
	inc hl			;13c8
	inc hl			;13c9
	inc hl			;13ca
	ld c,(hl)		;13cb
	ex de,hl		;13cc
	ld hl,l1407h		;13cd
	call sub_136bh		;13d0
	ld c,(hl)		;13d3
	ld b,000h		;13d4
	add hl,bc		;13d6
	jp (hl)			;13d7
l13d8h:
	sub 080h		;13d8
	ld b,a			;13da
	ld hl,(05cbch)		;13db
	add hl,bc		;13de
	ld a,(hl)		;13df
	cp 000h			;13e0
	ret z			;13e2
	cp 080h			;13e3
	ret z			;13e5
	inc hl			;13e6
	ld b,(hl)		;13e7
	inc hl			;13e8
	inc hl			;13e9
	inc hl			;13ea
	inc hl			;13eb
	ld e,(hl)		;13ec
	inc hl			;13ed
	ld d,(hl)		;13ee
	ld h,d			;13ef
	ld l,e			;13f0
	ld a,(05ccbh)		;13f1
	ld e,a			;13f4
	ld d,000h		;13f5
	push de			;13f7
	push hl			;13f8
	push bc			;13f9
	ld bc,l0002h		;13fa
	push bc			;13fd
	ld bc,l0000h		;13fe
	push bc			;1401
	call 065d0h		;1402
	pop hl			;1405
	ret			;1406
l1407h:
	ld c,e			;1407
	dec b			;1408
	ld d,e			;1409
	inc bc			;140a
	ld d,b			;140b
	ld bc,0c9e1h		;140c
sub_140fh:
	call sub_1f1eh		;140f
	ld (05ccbh),a		;1412
	cp 010h			;1415
	jr c,l141bh		;1417
l1419h:
	rst 8			;1419
	rla			;141a
l141bh:
	add a,003h		;141b
	rlca			;141d
	ld hl,05c10h		;141e
	ld c,a			;1421
	ld b,000h		;1422
	add hl,bc		;1424
	ld c,(hl)		;1425
	inc hl			;1426
	ld b,(hl)		;1427
	dec hl			;1428
	ret			;1429
	cp 02ch			;142a
	jr z,l1433h		;142c
	call 01b44h		;142e
	jr l143eh		;1431
l1433h:
	call sub_2889h		;1433
	jr nz,l143eh		;1436
	call sub_2569h		;1438
	call 01b44h		;143b
l143eh:
	rst 28h			;143e
	ld bc,0cd38h		;143f
	rrca			;1442
	inc d			;1443
	ld a,b			;1444
	or c			;1445
	jr z,l145eh		;1446
	ex de,hl		;1448
	ld hl,(05c4fh)		;1449
	add hl,bc		;144c
	inc hl			;144d
	inc hl			;144e
	inc hl			;144f
	ld a,(hl)		;1450
	ex de,hl		;1451
	cp 04bh			;1452
	jr z,l145eh		;1454
	cp 053h			;1456
	jr z,l145eh		;1458
	cp 050h			;145a
	jr nz,l1419h		;145c
l145eh:
	call sub_1465h		;145e
	ld (hl),e		;1461
	inc hl			;1462
	ld (hl),d		;1463
	ret			;1464
sub_1465h:
	push hl			;1465
	call sub_2fafh		;1466
	dec bc			;1469
	ld a,b			;146a
	or c			;146b
	jr z,$+6		;146c
l146eh:
	rst 8			;146e
	ld (de),a		;146f
l1470h:
	rst 8			;1470
	ld c,003h		;1471
	push bc			;1473
	ld a,(de)		;1474
	and 0dfh		;1475
	ld c,a			;1477
	ld hl,l14c7h		;1478
	call sub_136bh		;147b
	jr nc,l1486h		;147e
	ld c,(hl)		;1480
	ld b,000h		;1481
	add hl,bc		;1483
	pop bc			;1484
	jp (hl)			;1485
l1486h:
	jr l146eh		;1486
	call sub_1374h		;1488
	jr nc,l146eh		;148b
	pop bc			;148d
	dec bc			;148e
	ld a,b			;148f
	or c			;1490
	jr nz,l146eh		;1491
	push de			;1493
	ex de,hl		;1494
	call sub_25b9h		;1495
	ex de,hl		;1498
	ld b,(hl)		;1499
	ld c,088h		;149a
	inc hl			;149c
	inc hl			;149d
	ld e,(hl)		;149e
	inc hl			;149f
	ld d,(hl)		;14a0
	ld h,d			;14a1
	ld l,e			;14a2
	ld a,(05ccbh)		;14a3
	ld e,a			;14a6
	ld d,000h		;14a7
	push de			;14a9
	push hl			;14aa
	push bc			;14ab
l14ach:
	ld hl,(05c65h)		;14ac
	ld c,(hl)		;14af
	dec hl			;14b0
	ld (05c65h),hl		;14b1
	ld b,000h		;14b4
	inc bc			;14b6
	inc bc			;14b7
	push bc			;14b8
	ld bc,l0000h		;14b9
	push bc			;14bc
	call 065d0h		;14bd
	pop de			;14c0
	ld a,d			;14c1
	add a,080h		;14c2
	ld d,a			;14c4
	pop hl			;14c5
	ret			;14c6
l14c7h:
	ld c,e			;14c7
	ld b,053h		;14c8
	ex af,af'		;14ca
	ld d,b			;14cb
	ld a,(bc)		;14cc
	nop			;14cd
	ld e,001h		;14ce
	jr l14d8h		;14d0
	ld e,006h		;14d2
	jr l14d8h		;14d4
	ld e,010h		;14d6
l14d8h:
	dec bc			;14d8
	ld a,b			;14d9
	or c			;14da
	jp nz,l1470h		;14db
	ld d,a			;14de
	pop hl			;14df
	ret			;14e0
sub_14e1h:
	ld (05c3fh),sp		;14e1
	ld (iy+002h),010h	;14e5
	call sub_08eah		;14e9
	set 0,(iy+002h)		;14ec
	ld b,(iy+031h)		;14f0
	call sub_097fh		;14f3
	res 0,(iy+002h)		;14f6
	set 0,(iy+030h)		;14fa
	ld hl,(05c49h)		;14fe
	ld de,(05c6ch)		;1501
	and a			;1505
	sbc hl,de		;1506
	add hl,de		;1508
	jr c,l152dh		;1509
	push de			;150b
	call sub_16d6h		;150c
	ld de,l02c0h		;150f
	ex de,hl		;1512
	sbc hl,de		;1513
	ex (sp),hl		;1515
	call sub_16d6h		;1516
	pop bc			;1519
l151ah:
	push bc			;151a
	call sub_1720h		;151b
	pop bc			;151e
	add hl,bc		;151f
	jr c,l1530h		;1520
	ex de,hl		;1522
	ld d,(hl)		;1523
	inc hl			;1524
	ld e,(hl)		;1525
	dec hl			;1526
	ld (05c6ch),de		;1527
	jr l151ah		;152b
l152dh:
	ld (05c6ch),hl		;152d
l1530h:
	ld hl,(05c6ch)		;1530
	call sub_16d6h		;1533
	jr z,l1539h		;1536
	ex de,hl		;1538
l1539h:
	call sub_157fh		;1539
	res 4,(iy+002h)		;153c
	ret			;1540
	ld a,003h		;1541
	jr l1547h		;1543
	ld a,002h		;1545
l1547h:
	ld (iy+002h),000h	;1547
	call sub_2889h		;154b
	call nz,sub_1230h	;154e
	rst 18h			;1551
	call sub_220fh		;1552
	jr c,l156bh		;1555
	rst 18h			;1557
	cp 03bh			;1558
	jr z,l1560h		;155a
	cp 02ch			;155c
	jr nz,l1566h		;155e
l1560h:
	rst 20h			;1560
	call sub_1be5h		;1561
	jr l156eh		;1564
l1566h:
	call sub_1c51h		;1566
	jr l156eh		;1569
l156bh:
	call sub_1c49h		;156b
l156eh:
	call 01b44h		;156e
	call sub_1f23h		;1571
	ld a,b			;1574
	and 03fh		;1575
	ld h,a			;1577
	ld l,c			;1578
	ld (05c49h),hl		;1579
	call sub_16d6h		;157c
sub_157fh:
	ld e,001h		;157f
l1581h:
	call sub_15a1h		;1581
	rst 10h			;1584
	bit 4,(iy+002h)		;1585
	jr z,l1581h		;1589
	ld a,(05c6bh)		;158b
	sub (iy+04fh)		;158e
	jr nz,l1581h		;1591
	xor e			;1593
	ret z			;1594
	push hl			;1595
	push de			;1596
	ld hl,05c6ch		;1597
	call sub_165bh		;159a
	pop de			;159d
	pop hl			;159e
	jr l1581h		;159f
sub_15a1h:
	ld bc,(05c49h)		;15a1
	call sub_16e8h		;15a5
	ld d,03eh		;15a8
	jr z,l15b1h		;15aa
sub_15ach:
	ld de,l0000h		;15ac
	rl e			;15af
l15b1h:
	ld (iy+02dh),e		;15b1
	ld a,(hl)		;15b4
	cp 040h			;15b5
	pop bc			;15b7
	ret nc			;15b8
	push bc			;15b9
	call sub_1795h		;15ba
	inc hl			;15bd
	inc hl			;15be
	inc hl			;15bf
	res 0,(iy+001h)		;15c0
	ld a,d			;15c4
	and a			;15c5
	jr z,l15cdh		;15c6
	rst 10h			;15c8
sub_15c9h:
	set 0,(iy+001h)		;15c9
l15cdh:
	push de			;15cd
	ex de,hl		;15ce
	res 2,(iy+030h)		;15cf
	ld hl,05c3bh		;15d3
	res 2,(hl)		;15d6
	bit 5,(iy+037h)		;15d8
	jr z,l15e0h		;15dc
	set 2,(hl)		;15de
l15e0h:
	ld hl,(05c5fh)		;15e0
	and a			;15e3
	sbc hl,de		;15e4
	jr nz,l15edh		;15e6
	ld a,03fh		;15e8
	call sub_160dh		;15ea
l15edh:
	call sub_162dh		;15ed
	ex de,hl		;15f0
	ld a,(hl)		;15f1
	call sub_1602h		;15f2
	inc hl			;15f5
	cp 00dh			;15f6
	jr z,l1600h		;15f8
	ex de,hl		;15fa
	call sub_1683h		;15fb
	jr l15e0h		;15fe
l1600h:
	pop de			;1600
	ret			;1601
sub_1602h:
	cp 00eh			;1602
	ret nz			;1604
	inc hl			;1605
	inc hl			;1606
	inc hl			;1607
	inc hl			;1608
	inc hl			;1609
	inc hl			;160a
	ld a,(hl)		;160b
	ret			;160c
sub_160dh:
	exx			;160d
	ld hl,(05c8fh)		;160e
	push hl			;1611
	res 7,h			;1612
	set 7,l			;1614
	ld (05c8fh),hl		;1616
	ld hl,05c91h		;1619
	ld d,(hl)		;161c
	push de			;161d
	ld (hl),000h		;161e
	call l0500h		;1620
	pop hl			;1623
	ld (iy+057h),h		;1624
	pop hl			;1627
	ld (05c8fh),hl		;1628
	exx			;162b
	ret			;162c
sub_162dh:
	ld hl,(05c5bh)		;162d
l1630h:
	and a			;1630
	sbc hl,de		;1631
l1633h:
	ret nz			;1633
	ld a,(05c41h)		;1634
	rlc a			;1637
l1639h:
	jr z,l163fh		;1639
	add a,043h		;163b
	jr l1655h		;163d
l163fh:
	ld hl,05c3bh		;163f
	res 3,(hl)		;1642
	ld a,04bh		;1644
	bit 2,(hl)		;1646
	jr z,l1655h		;1648
	set 3,(hl)		;164a
	inc a			;164c
	bit 3,(iy+030h)		;164d
	jr z,l1655h		;1651
	ld a,043h		;1653
l1655h:
	push de			;1655
	call sub_160dh		;1656
	pop de			;1659
	ret			;165a
sub_165bh:
	ld e,(hl)		;165b
	inc hl			;165c
	ld d,(hl)		;165d
	push hl			;165e
	ex de,hl		;165f
	inc hl			;1660
	call sub_16d6h		;1661
	call sub_1324h		;1664
	pop hl			;1667
sub_1668h:
	bit 5,(iy+037h)		;1668
	ret nz			;166c
	ld (hl),d		;166d
	dec hl			;166e
	ld (hl),e		;166f
	ret			;1670
l1671h:
	ld a,e			;1671
	and a			;1672
	ret m			;1673
	jr sub_1683h		;1674
sub_1676h:
	xor a			;1676
l1677h:
	add hl,bc		;1677
	inc a			;1678
	jr c,l1677h		;1679
	sbc hl,bc		;167b
	dec a			;167d
	jr z,l1671h		;167e
	jp sub_11eah		;1680
sub_1683h:
	res 4,(iy+001h)		;1683
	bit 2,(iy+001h)		;1687
	jr z,l1691h		;168b
	set 4,(iy+001h)		;168d
l1691h:
	call sub_30d9h		;1691
	jr nc,l16d4h		;1694
	cp 00ch			;1696
	jr z,l16d0h		;1698
	cp 021h			;169a
	jr c,l16d4h		;169c
	res 2,(iy+001h)		;169e
	cp 07bh			;16a2
	jr nz,l16ach		;16a4
	bit 4,(iy+001h)		;16a6
	jr z,l16d4h		;16aa
l16ach:
	cp 0cbh			;16ac
	jr z,l16d4h		;16ae
	cp 03ah			;16b0
	jr nz,l16c2h		;16b2
	bit 5,(iy+037h)		;16b4
	jr nz,l16d0h		;16b8
	bit 2,(iy+030h)		;16ba
	jr z,l16d4h		;16be
	jr l16d0h		;16c0
l16c2h:
	cp 022h			;16c2
	jr nz,l16d0h		;16c4
	push af			;16c6
	ld a,(05c6ah)		;16c7
	xor 004h		;16ca
	ld (05c6ah),a		;16cc
	pop af			;16cf
l16d0h:
	set 2,(iy+001h)		;16d0
l16d4h:
	rst 10h			;16d4
	ret			;16d5
sub_16d6h:
	push hl			;16d6
	ld hl,(05c53h)		;16d7
	ld d,h			;16da
	ld e,l			;16db
l16dch:
	pop bc			;16dc
	call sub_16e8h		;16dd
	ret nc			;16e0
	push bc			;16e1
	call sub_1720h		;16e2
	ex de,hl		;16e5
	jr l16dch		;16e6
sub_16e8h:
	ld a,(hl)		;16e8
	cp b			;16e9
	ret nz			;16ea
	inc hl			;16eb
	ld a,(hl)		;16ec
	dec hl			;16ed
	cp c			;16ee
	ret			;16ef
	inc hl			;16f0
	inc hl			;16f1
	inc hl			;16f2
sub_16f3h:
	ld (05c5dh),hl		;16f3
	ld c,000h		;16f6
l16f8h:
	dec d			;16f8
	ret z			;16f9
	rst 20h			;16fa
	cp e			;16fb
	jr nz,l1702h		;16fc
	and a			;16fe
	ret			;16ff
l1700h:
	inc hl			;1700
	ld a,(hl)		;1701
l1702h:
	call sub_1602h		;1702
	ld (05c5dh),hl		;1705
	cp 022h			;1708
	jr nz,l170dh		;170a
	dec c			;170c
l170dh:
	cp 03ah			;170d
	jr z,l1715h		;170f
	cp 0cbh			;1711
	jr nz,l1719h		;1713
l1715h:
	bit 0,c			;1715
	jr z,l16f8h		;1717
l1719h:
	cp 00dh			;1719
	jr nz,l1700h		;171b
	dec d			;171d
	scf			;171e
	ret			;171f
sub_1720h:
	push hl			;1720
l1721h:
	ld a,(hl)		;1721
	cp 040h			;1722
	jr c,l173dh		;1724
	bit 5,a			;1726
	jr z,l173eh		;1728
	add a,a			;172a
	jp m,l172fh		;172b
	ccf			;172e
l172fh:
	ld bc,l0005h		;172f
	jr nc,l1736h		;1732
	ld c,012h		;1734
l1736h:
	rla			;1736
	inc hl			;1737
	ld a,(hl)		;1738
	jr nc,l1736h		;1739
	jr l1743h		;173b
l173dh:
	inc hl			;173d
l173eh:
	inc hl			;173e
	ld c,(hl)		;173f
	inc hl			;1740
	ld b,(hl)		;1741
	inc hl			;1742
l1743h:
	add hl,bc		;1743
	pop de			;1744
sub_1745h:
	and a			;1745
	sbc hl,de		;1746
	ld b,h			;1748
	ld c,l			;1749
	add hl,de		;174a
	ex de,hl		;174b
	ret			;174c
sub_174dh:
	call sub_1745h		;174d
l1750h:
	push bc			;1750
	ld a,b			;1751
	cpl			;1752
	ld b,a			;1753
	ld a,c			;1754
	cpl			;1755
	ld c,a			;1756
	inc bc			;1757
	push bc			;1758
	call sub_12cah		;1759
	ex (sp),hl		;175c
	add hl,bc		;175d
	ld c,l			;175e
	ld b,h			;175f
	pop de			;1760
	pop hl			;1761
	add hl,de		;1762
	push de			;1763
	ldir			;1764
	pop hl			;1766
	ret			;1767
sub_1768h:
	ld hl,(05c59h)		;1768
	dec hl			;176b
	ld (05c5dh),hl		;176c
	rst 20h			;176f
	ld hl,05c92h		;1770
	ld (05c65h),hl		;1773
	call sub_30f9h		;1776
	call sub_3160h		;1779
	jr c,l1782h		;177c
	ld hl,0d8f0h		;177e
	add hl,bc		;1781
l1782h:
	jp c,l1bedh		;1782
	jp l1354h		;1785
sub_1788h:
	push de			;1788
	push hl			;1789
	xor a			;178a
	bit 7,b			;178b
	jr nz,l17afh		;178d
	ld h,b			;178f
	ld l,c			;1790
	ld e,0ffh		;1791
	jr l179dh		;1793
sub_1795h:
	push de			;1795
	ld d,(hl)		;1796
	inc hl			;1797
	ld e,(hl)		;1798
	push hl			;1799
	ex de,hl		;179a
	ld e,020h		;179b
l179dh:
	ld bc,0fc18h		;179d
	call sub_1676h		;17a0
	ld bc,0ff9ch		;17a3
	call sub_1676h		;17a6
	ld c,0f6h		;17a9
	call sub_1676h		;17ab
	ld a,l			;17ae
l17afh:
	call sub_11eah		;17af
	pop hl			;17b2
	pop de			;17b3
	ret			;17b4
sub_17b5h:
	push bc			;17b5
	ld bc,0ff00h		;17b6
	call 06499h		;17b9
	pop bc			;17bc
	call sub_12bbh		;17bd
	ld hl,(05cbch)		;17c0
	ld de,l0002h+2		;17c3
	add hl,de		;17c6
	ld a,(hl)		;17c7
	ld b,000h		;17c8
	ld c,a			;17ca
	call 06499h		;17cb
	ret			;17ce
sub_17cfh:
	ld hl,(05cbch)		;17cf
	inc hl			;17d2
	inc hl			;17d3
	ld e,(hl)		;17d4
	inc hl			;17d5
	ld d,(hl)		;17d6
	ex de,hl		;17d7
l17d8h:
	ld a,(hl)		;17d8
	cp b			;17d9
	jr nz,l17e0h		;17da
	inc hl			;17dc
	ld a,(hl)		;17dd
	dec hl			;17de
	cp c			;17df
l17e0h:
	ret nc			;17e0
	inc hl			;17e1
	inc hl			;17e2
	ld e,(hl)		;17e3
	inc hl			;17e4
	ld d,(hl)		;17e5
	inc hl			;17e6
	add hl,de		;17e7
	jr l17d8h		;17e8
l17eah:
	push hl			;17ea
	ld hl,(05cbch)		;17eb
	ld de,l0002h+2		;17ee
	add hl,de		;17f1
	ld a,(hl)		;17f2
	ld c,a			;17f3
	ld b,000h		;17f4
	call 06499h		;17f6
	pop bc			;17f9
	call sub_17cfh		;17fa
	jr l1818h		;17fd
l17ffh:
	call sub_2889h		;17ff
	ret z			;1802
	ld hl,(05cbch)		;1803
	ld de,l0002h+2		;1806
	add hl,de		;1809
	ld a,(hl)		;180a
	ld c,a			;180b
	ld b,000h		;180c
	call 06499h		;180e
	ld hl,(05c55h)		;1811
	ld (iy+00ah),000h	;1814
l1818h:
	ld a,(hl)		;1818
	and 0c0h		;1819
	jr z,l1824h		;181b
	ld bc,0ff00h		;181d
	call 06499h		;1820
	ret			;1823
l1824h:
	ld d,(hl)		;1824
	inc hl			;1825
	ld e,(hl)		;1826
	ld (05c45h),de		;1827
	inc hl			;182b
	ld e,(hl)		;182c
	inc hl			;182d
	ld d,(hl)		;182e
	inc hl			;182f
	push hl			;1830
	add hl,de		;1831
	ld (05c55h),hl		;1832
	push de			;1835
	ld hl,(05c4fh)		;1836
	dec hl			;1839
	ld de,(05cc4h)		;183a
	and a			;183e
	sbc hl,de		;183f
	ld de,l00d0h		;1841
	ex de,hl		;1844
	and a			;1845
	sbc hl,de		;1846
	jr nc,l186eh		;1848
	ld a,l			;184a
	cpl			;184b
	ld c,a			;184c
	ld a,h			;184d
	cpl			;184e
	ld b,a			;184f
	inc bc			;1850
	inc bc			;1851
	ld hl,(05cc4h)		;1852
l1855h:
	push bc			;1855
	ld bc,0ff00h		;1856
	call 06499h		;1859
	pop bc			;185c
	call l1750h		;185d
	ld hl,(05cbch)		;1860
	ld de,l0002h+2		;1863
	add hl,de		;1866
	ld a,(hl)		;1867
	ld b,000h		;1868
	ld c,a			;186a
	call 06499h		;186b
l186eh:
	pop hl			;186e
	push hl			;186f
	ld de,l00ceh+1		;1870
	dec hl			;1873
	and a			;1874
	sbc hl,de		;1875
	jr c,l1883h		;1877
	ld c,l			;1879
	ld b,h			;187a
	inc bc			;187b
	ld hl,(05c4fh)		;187c
	dec hl			;187f
	call sub_17b5h		;1880
l1883h:
	pop bc			;1883
	pop de			;1884
	ld hl,l00ffh		;1885
	push hl			;1888
	push de			;1889
	ld hl,(05cc4h)		;188a
	ld (hl),00dh		;188d
	ld (05c5dh),hl		;188f
	inc hl			;1892
	push hl			;1893
	push bc			;1894
	ld bc,l0001h		;1895
	push bc			;1898
	call 06722h		;1899
	ld a,(iy+00ah)		;189c
	ld (iy+00ah),0ffh	;189f
	cp 001h			;18a3
	adc a,000h		;18a5
	dec a			;18a7
	push af			;18a8
	ld (05c47h),a		;18a9
	ld (iy+000h),0ffh	;18ac
	ld bc,0ff00h		;18b0
	call 06499h		;18b3
	pop af			;18b6
	jp z,l1a44h		;18b7
	inc a			;18ba
	ld d,a			;18bb
	ld e,000h		;18bc
	call sub_16f3h		;18be
	jp z,l1b4ah		;18c1
	rst 8			;18c4
	ld d,021h		;18c5
	add a,05ch		;18c7
	ld (hl),080h		;18c9
	ld bc,l00d0h		;18cb
	ld hl,06840h		;18ce
	dec hl			;18d1
	call sub_12bbh		;18d2
	ld hl,06840h		;18d5
	ld (05cc4h),hl		;18d8
	ld hl,(05cbch)		;18db
	ld de,l0005h+1		;18de
	add hl,de		;18e1
	ld c,(hl)		;18e2
	inc hl			;18e3
	ld b,(hl)		;18e4
	ld hl,06840h		;18e5
	dec hl			;18e8
	call sub_12bbh		;18e9
	ld hl,(05cbch)		;18ec
	ld de,l0002h+2		;18ef
	add hl,de		;18f2
	ld a,(hl)		;18f3
	ld b,000h		;18f4
	ld c,a			;18f6
	call 06499h		;18f7
	ld hl,(05cbch)		;18fa
	inc hl			;18fd
	inc hl			;18fe
	ld e,(hl)		;18ff
	inc hl			;1900
	ld d,(hl)		;1901
	ex de,hl		;1902
	ld d,(hl)		;1903
	inc hl			;1904
	ld e,(hl)		;1905
	ld bc,0ff00h		;1906
	call 06499h		;1909
	ld hl,(05cbch)		;190c
	ld bc,l0005h		;190f
	add hl,bc		;1912
	ld a,(hl)		;1913
l1914h:
	cp 000h			;1914
	jr z,l1941h		;1916
	ld (05c42h),de		;1918
	call sub_08a6h		;191c
	ld hl,(05cbch)		;191f
	inc hl			;1922
	inc hl			;1923
	ld e,(hl)		;1924
	inc hl			;1925
	ld d,(hl)		;1926
	ex de,hl		;1927
	dec hl			;1928
	ld (05c57h),hl		;1929
	ld (iy+000h),0ffh	;192c
	set 7,(iy+001h)		;1930
	ld (iy+00ah),000h	;1934
	ld hl,l0e8dh		;1938
	push hl			;193b
	ld hl,l1ab9h		;193c
	ei			;193f
	jp (hl)			;1940
l1941h:
	ei			;1941
	jp l0e2fh		;1942
l1945h:
	or l			;1945
	ret nc			;1946
	ret nz			;1947
	call nz,0b3c8h		;1948
	cp b			;194b
	sub a			;194c
	sub l			;194d
	sub (hl)		;194e
	sbc a,c			;194f
	sbc a,h			;1950
	sbc a,h			;1951
	sbc a,h			;1952
	sbc a,h			;1953
	sbc a,h			;1954
	sbc a,h			;1955
	sbc a,h			;1956
	add a,e			;1957
	add a,l			;1958
	ld (07270h),a		;1959
	ld (hl),h		;195c
	ld c,h			;195d
	sbc a,b			;195e
	ld e,d			;195f
	ld b,e			;1960
	ld b,l			;1961
	cpl			;1962
	dec de			;1963
	inc hl			;1964
	dec sp			;1965
	ld a,e			;1966
	ld c,b			;1967
	inc de			;1968
	ld e,l			;1969
	cpl			;196a
	ld b,a			;196b
	ld sp,l3e55h		;196c
	ld (hl),c		;196f
	ld b,(hl)		;1970
	ld de,0604dh		;1971
	ld c,b			;1974
	add hl,de		;1975
	ld h,c			;1976
l1977h:
	and h			;1977
	and (hl)		;1978
	xor b			;1979
	xor d			;197a
	ld bc,l023dh		;197b
	ld b,000h		;197e
	pop af			;1980
	ld e,006h		;1981
	rlc l			;1983
	ld e,e			;1985
	inc e			;1986
	ld b,000h		;1987
	sbc a,c			;1989
	rra			;198a
	nop			;198b
	ld e,c			;198c
	inc e			;198d
	nop			;198e
	call nc,0041fh		;198f
	dec a			;1992
	ld b,0cch		;1993
	ld b,005h		;1995
	ld a,b			;1997
	inc e			;1998
	inc b			;1999
	nop			;199a
	ld d,l			;199b
	dec e			;199c
	dec b			;199d
	ld e,c			;199e
	ld hl,02b05h		;199f
	ld (0c005h),hl		;19a2
	cpl			;19a5
	dec b			;19a6
	nop			;19a7
	dec de			;19a8
	nop			;19a9
	dec e			;19aa
	dec c			;19ab
	inc bc			;19ac
	dec hl			;19ad
	rra			;19ae
	dec b			;19af
	ld b,l			;19b0
	dec d			;19b1
	ex af,af'		;19b2
	nop			;19b3
	ld a,(bc)		;19b4
	rra			;19b5
	inc bc			;19b6
	call nc,l001ch+2	;19b7
	call po,0031eh		;19ba
	ld (hl),01fh		;19bd
	nop			;19bf
	and (hl)		;19c0
	ex af,af'		;19c1
	add hl,bc		;19c2
	nop			;19c3
	dec (hl)		;19c4
	ld h,006h		;19c5
	nop			;19c7
	ex de,hl		;19c8
	rra			;19c9
	dec b			;19ca
	sub a			;19cb
	dec e			;19cc
	dec b			;19cd
	add a,d			;19ce
	ld e,003h		;19cf
	sbc a,l			;19d1
	ld e,009h		;19d2
	dec b			;19d4
	in a,(026h)		;19d5
	nop			;19d7
	ld (bc),a		;19d8
	ld a,(bc)		;19d9
	dec b			;19da
	ld d,l			;19db
	ld hl,04105h		;19dc
	dec d			;19df
	dec bc			;19e0
	dec bc			;19e1
	dec bc			;19e2
	dec bc			;19e3
	ex af,af'		;19e4
	nop			;19e5
	ld (hl),004h		;19e6
	add hl,bc		;19e8
	dec b			;19e9
	ld a,c			;19ea
	ld h,007h		;19eb
	rlca			;19ed
	rlca			;19ee
	rlca			;19ef
	rlca			;19f0
	rlca			;19f1
	ex af,af'		;19f2
	nop			;19f3
	inc b			;19f4
	rra			;19f5
	ld b,000h		;19f6
	ld a,024h		;19f8
	dec b			;19fa
	dec e			;19fb
	jr nz,l1a04h		;19fc
	inc l			;19fe
	ld a,(bc)		;19ff
	dec b			;1a00
	ld hl,(l0613h+1)	;1a01
l1a04h:
	nop			;1a04
	sbc a,a			;1a05
	inc de			;1a06
	ld a,(bc)		;1a07
	inc l			;1a08
	dec b			;1a09
	call z,l0a23h+2		;1a0a
	inc l			;1a0d
	dec b			;1a0e
	ret nc			;1a0f
	dec h			;1a10
	ld a,(bc)		;1a11
	inc l			;1a12
	dec b			;1a13
	call nc,l0a23h+2	;1a14
	inc l			;1a17
	dec b			;1a18
	ret z			;1a19
	dec h			;1a1a
	dec b			;1a1b
	pop de			;1a1c
	jr nz,l1a24h		;1a1d
	add a,b			;1a1f
	jr nz,sub_1a27h		;1a20
	ld d,h			;1a22
	inc h			;1a23
l1a24h:
	dec b			;1a24
	jr z,l1a48h		;1a25
sub_1a27h:
	res 7,(iy+001h)		;1a27
	call sub_1768h		;1a2b
	ld a,b			;1a2e
	or c			;1a2f
	jr z,l1a3ah		;1a30
	ld a,(05cc6h)		;1a32
	bit 7,a			;1a35
	jp nz,l1bedh		;1a37
l1a3ah:
	xor a			;1a3a
	ld (05c47h),a		;1a3b
	dec a			;1a3e
	ld (05c3ah),a		;1a3f
	jr l1a45h		;1a42
l1a44h:
	rst 20h			;1a44
l1a45h:
	call sub_134eh		;1a45
l1a48h:
	inc (iy+00dh)		;1a48
	jp m,l1bedh		;1a4b
	rst 18h			;1a4e
	ld b,000h		;1a4f
	cp 00dh			;1a51
	jp z,l1b09h		;1a53
	cp 03ah			;1a56
	jr z,l1a44h		;1a58
	ld hl,l1ab9h		;1a5a
	push hl			;1a5d
	ld c,a			;1a5e
	rst 20h			;1a5f
	ld a,c			;1a60
	cp 00ch			;1a61
	jr z,l1a7fh		;1a63
	cp 07bh			;1a65
	jr c,l1a71h		;1a67
	cp 080h			;1a69
	jr nc,l1a71h		;1a6b
	bit 0,a			;1a6d
	jr nz,l1a7fh		;1a6f
l1a71h:
	sub 0ceh		;1a71
	jp c,l1bedh		;1a73
	ld c,a			;1a76
	ld hl,l1945h		;1a77
l1a7ah:
	add hl,bc		;1a7a
	ld c,(hl)		;1a7b
	add hl,bc		;1a7c
	jr l1a98h		;1a7d
l1a7fh:
	cp 00ch			;1a7f
	jr nz,l1a87h		;1a81
	ld a,000h		;1a83
	jr l1a8fh		;1a85
l1a87h:
	sub 07ah		;1a87
	cp 005h			;1a89
	jr nz,l1a8fh		;1a8b
	ld a,002h		;1a8d
l1a8fh:
	ld hl,l1977h		;1a8f
	ld c,a			;1a92
	jr l1a7ah		;1a93
l1a95h:
	ld hl,(05c74h)		;1a95
l1a98h:
	ld a,(hl)		;1a98
	inc hl			;1a99
	ld (05c74h),hl		;1a9a
	ld bc,l1a95h		;1a9d
	push bc			;1aa0
	ld c,a			;1aa1
	cp 020h			;1aa2
	jr nc,l1ab2h		;1aa4
	ld hl,l1b64h		;1aa6
	ld b,000h		;1aa9
	add hl,bc		;1aab
	ld c,(hl)		;1aac
	add hl,bc		;1aad
	push hl			;1aae
	rst 18h			;1aaf
	dec b			;1ab0
	ret			;1ab1
l1ab2h:
	rst 18h			;1ab2
	cp c			;1ab3
	jp nz,l1bedh		;1ab4
	rst 20h			;1ab7
	ret			;1ab8
l1ab9h:
	call sub_2009h		;1ab9
	jr c,l1ac0h		;1abc
	rst 8			;1abe
	inc d			;1abf
l1ac0h:
	bit 7,(iy+00ah)		;1ac0
	jp nz,l1b4ah		;1ac4
	ld hl,(05c42h)		;1ac7
	bit 7,h			;1aca
	jr nz,sub_1ad8h		;1acc
	ld a,(05cc6h)		;1ace
	bit 7,a			;1ad1
	jp nz,l17eah		;1ad3
	jr l1aech		;1ad6
sub_1ad8h:
	ld hl,0fffeh		;1ad8
	ld (05c45h),hl		;1adb
	ld hl,(05c61h)		;1ade
	dec hl			;1ae1
	ld de,(05c59h)		;1ae2
	dec de			;1ae6
	ld a,(05c44h)		;1ae7
	jr l1b27h		;1aea
l1aech:
	call sub_16d6h		;1aec
	ld a,(05c44h)		;1aef
	jr z,l1b15h		;1af2
	and a			;1af4
	jr nz,l1b42h		;1af5
	ld b,a			;1af7
	ld a,(hl)		;1af8
	and 0c0h		;1af9
	ld a,b			;1afb
	jr z,l1b15h		;1afc
	rst 8			;1afe
	rst 38h			;1aff
	pop bc			;1b00
	ld a,(05cc6h)		;1b01
	bit 7,a			;1b04
	jp nz,l17ffh		;1b06
l1b09h:
	call sub_2889h		;1b09
	ret z			;1b0c
	ld hl,(05c55h)		;1b0d
	ld a,0c0h		;1b10
	and (hl)		;1b12
	ret nz			;1b13
	xor a			;1b14
l1b15h:
	cp 001h			;1b15
	adc a,000h		;1b17
	ld d,(hl)		;1b19
	inc hl			;1b1a
	ld e,(hl)		;1b1b
	ld (05c45h),de		;1b1c
	inc hl			;1b20
	ld e,(hl)		;1b21
	inc hl			;1b22
	ld d,(hl)		;1b23
	ex de,hl		;1b24
	add hl,de		;1b25
	inc hl			;1b26
l1b27h:
	ld (05c55h),hl		;1b27
	ex de,hl		;1b2a
	ld (05c5dh),hl		;1b2b
	ld d,a			;1b2e
	ld e,000h		;1b2f
	ld (iy+00ah),0ffh	;1b31
	dec d			;1b35
	ld (iy+00dh),d		;1b36
	jp z,l1a44h		;1b39
	inc d			;1b3c
	call sub_16f3h		;1b3d
	jr z,l1b4ah		;1b40
l1b42h:
	rst 8			;1b42
	ld d,0cdh		;1b43
	adc a,c			;1b45
	jr z,$-62		;1b46
	pop bc			;1b48
	pop bc			;1b49
l1b4ah:
	rst 18h			;1b4a
	cp 00dh			;1b4b
	jr nz,l1b5ch		;1b4d
	ld hl,(05c55h)		;1b4f
	ld a,(05cc6h)		;1b52
	bit 7,a			;1b55
	jp nz,l17ffh		;1b57
	jr l1b09h		;1b5a
l1b5ch:
	cp 03ah			;1b5c
	jp z,l1a44h		;1b5e
	jp l1bedh		;1b61
l1b64h:
	rrca			;1b64
	dec e			;1b65
	ld c,e			;1b66
	add hl,bc		;1b67
	ld h,a			;1b68
	dec bc			;1b69
	ld a,e			;1b6a
	adc a,(hl)		;1b6b
	ld (hl),c		;1b6c
	cp h			;1b6d
	add a,c			;1b6e
	rst 10h			;1b6f
	call sub_1c49h		;1b70
	cp a			;1b73
	pop bc			;1b74
	call z,01b44h		;1b75
	ex de,hl		;1b78
	ld hl,(05c74h)		;1b79
	ld c,(hl)		;1b7c
	inc hl			;1b7d
	ld b,(hl)		;1b7e
	ex de,hl		;1b7f
	push bc			;1b80
	ret			;1b81
sub_1b82h:
	call sub_2c70h		;1b82
l1b85h:
	ld (iy+037h),000h	;1b85
	jr nc,$+10		;1b89
	set 1,(iy+037h)		;1b8b
	jr nz,l1ba9h		;1b8f
l1b91h:
	rst 8			;1b91
	ld bc,054cch		;1b92
	dec l			;1b95
	bit 6,(iy+001h)		;1b96
	jr nz,l1ba9h		;1b9a
	xor a			;1b9c
	call sub_2889h		;1b9d
	call nz,sub_2fafh	;1ba0
	ld hl,05c71h		;1ba3
	or (hl)			;1ba6
	ld (hl),a		;1ba7
	ex de,hl		;1ba8
l1ba9h:
	ld (05c72h),bc		;1ba9
	ld (05c4dh),hl		;1bad
	ret			;1bb0
	pop bc			;1bb1
	call sub_1bb9h		;1bb2
	call 01b44h		;1bb5
	ret			;1bb8
sub_1bb9h:
	ld a,(05c3bh)		;1bb9
sub_1bbch:
	push af			;1bbc
	call sub_2854h		;1bbd
	pop af			;1bc0
	ld d,(iy+001h)		;1bc1
	xor d			;1bc4
	and 040h		;1bc5
	jr nz,l1bedh		;1bc7
	bit 7,d			;1bc9
	jp nz,l2ebdh		;1bcb
	ret			;1bce
	call sub_2c70h		;1bcf
	push af			;1bd2
	ld a,c			;1bd3
	or 09fh			;1bd4
	inc a			;1bd6
	jr nz,l1bedh		;1bd7
	pop af			;1bd9
	jr l1b85h		;1bda
sub_1bdch:
	rst 20h			;1bdc
l1bddh:
	call sub_1be5h		;1bdd
	cp 02ch			;1be0
	jr nz,l1bedh		;1be2
	rst 20h			;1be4
sub_1be5h:
	call sub_2854h		;1be5
	bit 6,(iy+001h)		;1be8
	ret nz			;1bec
l1bedh:
	rst 8			;1bed
	dec bc			;1bee
sub_1befh:
	call sub_2854h		;1bef
	bit 6,(iy+001h)		;1bf2
	ret z			;1bf6
	jr l1bedh		;1bf7
	bit 7,(iy+001h)		;1bf9
	res 0,(iy+002h)		;1bfd
	call nz,sub_0888h	;1c01
	pop af			;1c04
	ld a,(05c74h)		;1c05
	ld hl,(05c74h)		;1c08
	ld de,l1914h		;1c0b
	and a			;1c0e
	sbc hl,de		;1c0f
	ld a,l			;1c11
	call sub_23a6h		;1c12
	call 01b44h		;1c15
	ld hl,(05c8fh)		;1c18
	ld (05c8dh),hl		;1c1b
	ld hl,05c91h		;1c1e
	ld a,(hl)		;1c21
l1c22h:
	rlca			;1c22
	xor (hl)		;1c23
	and 0aah		;1c24
	xor (hl)		;1c26
	ld (hl),a		;1c27
	ret			;1c28
	call sub_2889h		;1c29
	jr z,l1c41h		;1c2c
	res 0,(iy+002h)		;1c2e
	call sub_0888h		;1c32
	ld hl,05c90h		;1c35
	ld a,(hl)		;1c38
	or 0f8h			;1c39
	ld (hl),a		;1c3b
	res 6,(iy+057h)		;1c3c
	rst 18h			;1c40
l1c41h:
	call sub_238ch		;1c41
	jr l1bddh		;1c44
	jp l24d2h		;1c46
sub_1c49h:
	cp 00dh			;1c49
	jr z,sub_1c51h		;1c4b
	cp 03ah			;1c4d
	jr nz,sub_1be5h		;1c4f
sub_1c51h:
	call sub_2889h		;1c51
	ret z			;1c54
	rst 28h			;1c55
	and b			;1c56
	jr c,l1c22h		;1c57
	rst 8			;1c59
	ex af,af'		;1c5a
	pop bc			;1c5b
	call sub_2889h		;1c5c
	jr z,l1c75h		;1c5f
	rst 28h			;1c61
	ld (bc),a		;1c62
	jr c,$-19		;1c63
	call sub_3904h		;1c65
	jr nc,l1c75h		;1c68
	ld a,(05cc6h)		;1c6a
	bit 7,a			;1c6d
	jp nz,l17ffh		;1c6f
	jp l1b09h		;1c72
l1c75h:
	jp l1a45h		;1c75
	cp 0cdh			;1c78
	jr nz,l1c85h		;1c7a
	rst 20h			;1c7c
	call sub_1be5h		;1c7d
	call 01b44h		;1c80
	jr $+8			;1c83
l1c85h:
	call 01b44h		;1c85
	rst 28h			;1c88
	and c			;1c89
	jr c,$-15		;1c8a
	ret nz			;1c8c
	ld (bc),a		;1c8d
	ld bc,001e0h		;1c8e
	jr c,$-49		;1c91
	cp l			;1c93
	ld l,022h		;1c94
	ld l,b			;1c96
	ld e,h			;1c97
	dec hl			;1c98
	ld a,(hl)		;1c99
	set 7,(hl)		;1c9a
	ld bc,l0005h+1		;1c9c
	add hl,bc		;1c9f
	rlca			;1ca0
	jr c,l1ca9h		;1ca1
	ld c,00dh		;1ca3
	call sub_12bbh		;1ca5
	inc hl			;1ca8
l1ca9h:
	push hl			;1ca9
	rst 28h			;1caa
	ld (bc),a		;1cab
	ld (bc),a		;1cac
	jr c,$-29		;1cad
	ex de,hl		;1caf
	ld c,00ah		;1cb0
	ldir			;1cb2
	ld hl,(05c45h)		;1cb4
	ex de,hl		;1cb7
	ld (hl),e		;1cb8
	inc hl			;1cb9
	ld (hl),d		;1cba
	ld d,(iy+00dh)		;1cbb
	inc d			;1cbe
	inc hl			;1cbf
	ld (hl),d		;1cc0
	call sub_1d84h		;1cc1
	ret nc			;1cc4
	ld hl,(05c45h)		;1cc5
	ld (05c42h),hl		;1cc8
	ld a,(05c47h)		;1ccb
	neg			;1cce
	ld d,a			;1cd0
	ld hl,(05cbch)		;1cd1
	inc hl			;1cd4
	ld a,(hl)		;1cd5
	cp 002h			;1cd6
	jr nz,l1cf2h		;1cd8
	inc hl			;1cda
	inc hl			;1cdb
	inc hl			;1cdc
	ld a,(hl)		;1cdd
	and 00fh		;1cde
	ld c,a			;1ce0
	ld b,000h		;1ce1
	call 06499h		;1ce3
	ld bc,(05c45h)		;1ce6
	call sub_17cfh		;1cea
	ld h,b			;1ced
	ld l,c			;1cee
	dec hl			;1cef
	jr l1cf5h		;1cf0
l1cf2h:
	ld hl,(05c5dh)		;1cf2
l1cf5h:
	ld e,0f3h		;1cf5
l1cf7h:
	ld bc,(05c55h)		;1cf7
	call 01d28h		;1cfb
	ld (05c55h),bc		;1cfe
	ld b,(iy+038h)		;1d02
	jr c,l1d26h		;1d05
	rst 20h			;1d07
	or 020h			;1d08
	cp b			;1d0a
	jr z,l1d10h		;1d0b
	rst 20h			;1d0d
	jr l1cf7h		;1d0e
l1d10h:
	rst 20h			;1d10
	ld a,001h		;1d11
	sub d			;1d13
	ld (05c44h),a		;1d14
	ld hl,05cc6h		;1d17
	ld l,(hl)		;1d1a
	bit 7,l			;1d1b
	jr z,l1d25h		;1d1d
	ld bc,0ff00h		;1d1f
	call 06499h		;1d22
l1d25h:
	ret			;1d25
l1d26h:
	rst 8			;1d26
	ld de,0fe7eh		;1d27
	ld a,(l2027h+1)		;1d2a
l1d2dh:
	inc hl			;1d2d
	ld a,(hl)		;1d2e
	and 0c0h		;1d2f
	scf			;1d31
	ret nz			;1d32
	ld a,e			;1d33
	cp 0e4h			;1d34
	jr nz,l1d3bh		;1d36
	ld (05cc7h),hl		;1d38
l1d3bh:
	ld b,(hl)		;1d3b
l1d3ch:
	inc hl			;1d3c
	ld c,(hl)		;1d3d
	ld (05c42h),bc		;1d3e
	inc hl			;1d42
	ld c,(hl)		;1d43
	inc hl			;1d44
	ld b,(hl)		;1d45
	push hl			;1d46
	add hl,bc		;1d47
	ld b,h			;1d48
	ld c,l			;1d49
	pop hl			;1d4a
	ld d,000h		;1d4b
	push bc			;1d4d
	call sub_16f3h		;1d4e
	pop bc			;1d51
	ret nc			;1d52
	jr l1d2dh		;1d53
	bit 1,(iy+037h)		;1d55
	jp nz,l1b91h		;1d59
	ld hl,(05c4dh)		;1d5c
	bit 7,(hl)		;1d5f
	jr z,l1d82h		;1d61
	inc hl			;1d63
	ld (05c68h),hl		;1d64
	rst 28h			;1d67
	ret po			;1d68
	jp po,0c00fh		;1d69
	ld (bc),a		;1d6c
	jr c,l1d3ch		;1d6d
	add a,h			;1d6f
	dec e			;1d70
	ret c			;1d71
	ld hl,(05c68h)		;1d72
	ld de,l000eh+1		;1d75
	add hl,de		;1d78
	ld e,(hl)		;1d79
	inc hl			;1d7a
	ld d,(hl)		;1d7b
	inc hl			;1d7c
	ld h,(hl)		;1d7d
	ex de,hl		;1d7e
	jp l1efdh		;1d7f
l1d82h:
	rst 8			;1d82
	nop			;1d83
sub_1d84h:
	rst 28h			;1d84
	pop hl			;1d85
	ret po			;1d86
	jp po,00036h		;1d87
	ld (bc),a		;1d8a
	ld bc,03703h		;1d8b
	nop			;1d8e
	inc b			;1d8f
	jr c,$-87		;1d90
	ret			;1d92
	jr c,l1dcch		;1d93
	ret			;1d95
l1d96h:
	rst 20h			;1d96
	call sub_1b82h		;1d97
	call sub_2889h		;1d9a
	jp z,l1e78h		;1d9d
	rst 18h			;1da0
	ld (05c5fh),hl		;1da1
	ld hl,05cc6h		;1da4
	ld l,(hl)		;1da7
	bit 7,l			;1da8
	jp z,l1e52h		;1daa
	ld hl,(05cbch)		;1dad
	ld de,l0002h+2		;1db0
	add hl,de		;1db3
	ld a,(hl)		;1db4
	and 00fh		;1db5
	ld b,000h		;1db7
	ld c,a			;1db9
	call 06499h		;1dba
	ld hl,(05c57h)		;1dbd
	ld a,(hl)		;1dc0
	cp 02ch			;1dc1
	jr z,l1dd8h		;1dc3
	ld e,0e4h		;1dc5
	call 01d28h		;1dc7
	jr nc,l1dd5h		;1dca
l1dcch:
	ld bc,0ff00h		;1dcc
	call 06499h		;1dcf
	jp l1e62h		;1dd2
l1dd5h:
	ld (05c57h),hl		;1dd5
l1dd8h:
	ld hl,(05cc7h)		;1dd8
	inc hl			;1ddb
	inc hl			;1ddc
	ld c,(hl)		;1ddd
	inc hl			;1dde
	ld b,(hl)		;1ddf
	ld (05cc9h),bc		;1de0
	ld bc,0ff00h		;1de4
	call 06499h		;1de7
	ld bc,(05cc9h)		;1dea
	ld hl,(05c4fh)		;1dee
	push hl			;1df1
	dec hl			;1df2
	call sub_12bbh		;1df3
	pop de			;1df6
	ld hl,l00ffh		;1df7
	push hl			;1dfa
	ld hl,(05cc7h)		;1dfb
	inc hl			;1dfe
	inc hl			;1dff
	inc hl			;1e00
	inc hl			;1e01
	push hl			;1e02
	push de			;1e03
	ld bc,(05cc9h)		;1e04
	push bc			;1e08
	ld bc,l0001h		;1e09
	push bc			;1e0c
	call 06722h		;1e0d
	ld hl,(05cc7h)		;1e10
	ld de,(05cc9h)		;1e13
	add hl,de		;1e17
	ld de,l0002h+2		;1e18
	add hl,de		;1e1b
	ld bc,(05c57h)		;1e1c
	and a			;1e20
	sbc hl,bc		;1e21
	ld b,h			;1e23
	ld c,l			;1e24
	ld hl,(05c4fh)		;1e25
	and a			;1e28
	sbc hl,bc		;1e29
	push hl			;1e2b
	inc hl			;1e2c
	ld (05c5dh),hl		;1e2d
	call sub_1bb9h		;1e30
	pop de			;1e33
	ld hl,(05c5dh)		;1e34
	and a			;1e37
	sbc hl,de		;1e38
	ld de,(05c57h)		;1e3a
	add hl,de		;1e3e
	ld (05c57h),hl		;1e3f
	ld hl,(05c4fh)		;1e42
	ld bc,(05cc9h)		;1e45
	and a			;1e49
	sbc hl,bc		;1e4a
	call l1750h		;1e4c
	jp l1e6eh		;1e4f
l1e52h:
	ld hl,(05c57h)		;1e52
	ld a,(hl)		;1e55
	cp 02ch			;1e56
	jp z,l1e64h		;1e58
	ld e,0e4h		;1e5b
	call 01d28h		;1e5d
	jr nc,l1e64h		;1e60
l1e62h:
	rst 8			;1e62
	dec c			;1e63
l1e64h:
	call sub_0077h		;1e64
	call sub_1bb9h		;1e67
	rst 18h			;1e6a
	ld (05c57h),hl		;1e6b
l1e6eh:
	ld hl,(05c5fh)		;1e6e
	ld (iy+026h),000h	;1e71
	call sub_0078h		;1e75
l1e78h:
	rst 18h			;1e78
	cp 02ch			;1e79
	jp z,l1d96h		;1e7b
	call 01b44h		;1e7e
	ret			;1e81
	call sub_2889h		;1e82
	jr nz,l1e92h		;1e85
l1e87h:
	call sub_2854h		;1e87
	cp 02ch			;1e8a
	call nz,01b44h		;1e8c
	rst 20h			;1e8f
	jr l1e87h		;1e90
l1e92h:
	ld a,0e4h		;1e92
l1e94h:
	ld b,a			;1e94
	cpdr			;1e95
	ld de,l0200h		;1e97
	jp sub_16f3h		;1e9a
	call sub_1f23h		;1e9d
	ld hl,(05cbch)		;1ea0
	inc hl			;1ea3
	ld a,(hl)		;1ea4
	cp 002h			;1ea5
	jr nz,l1ecah		;1ea7
	inc hl			;1ea9
	inc hl			;1eaa
	inc hl			;1eab
	ld a,(hl)		;1eac
	and 00fh		;1ead
	push bc			;1eaf
	ld c,a			;1eb0
	ld b,000h		;1eb1
	call 06499h		;1eb3
	pop bc			;1eb6
	call sub_17cfh		;1eb7
	ld bc,0ff00h		;1eba
	call 06499h		;1ebd
	jr l1ec5h		;1ec0
	call sub_16d6h		;1ec2
l1ec5h:
	dec hl			;1ec5
	ld (05c57h),hl		;1ec6
	ret			;1ec9
l1ecah:
	ld h,b			;1eca
	ld l,c			;1ecb
	call sub_16d6h		;1ecc
	dec hl			;1ecf
	ld (05c57h),hl		;1ed0
	ret			;1ed3
	call sub_1f23h		;1ed4
	ld a,b			;1ed7
	or c			;1ed8
	jr nz,l1edfh		;1ed9
	ld bc,(05c78h)		;1edb
l1edfh:
	ld (05c76h),bc		;1edf
	ret			;1ee3
	ld hl,(05c6eh)		;1ee4
	inc h			;1ee7
	jp z,l1b42h		;1ee8
	dec h			;1eeb
	ld d,(iy+036h)		;1eec
	jr l1efdh		;1eef
sub_1ef1h:
	call sub_1f23h		;1ef1
	ld h,b			;1ef4
	ld l,c			;1ef5
	ld d,000h		;1ef6
	ld a,h			;1ef8
	cp 0f0h			;1ef9
	jr nc,l1f29h		;1efb
l1efdh:
	ld (05c42h),hl		;1efd
	ld (iy+00ah),d		;1f00
	ret			;1f03
	call sub_1f0fh		;1f04
	out (c),a		;1f07
	ret			;1f09
	call sub_1f0fh		;1f0a
	ld (bc),a		;1f0d
	ret			;1f0e
sub_1f0fh:
	call 03193h		;1f0f
	jr c,l1f29h		;1f12
	jr z,l1f18h		;1f14
	neg			;1f16
l1f18h:
	push af			;1f18
	call sub_1f23h		;1f19
	pop af			;1f1c
	ret			;1f1d
sub_1f1eh:
	call 03193h		;1f1e
	jr l1f26h		;1f21
sub_1f23h:
	call sub_3160h		;1f23
l1f26h:
	jr c,l1f29h		;1f26
	ret z			;1f28
l1f29h:
	rst 8			;1f29
	ld a,(bc)		;1f2a
	call sub_1ef1h		;1f2b
	ld bc,l0000h		;1f2e
	call l1ecah		;1f31
	jr l1f39h		;1f34
	call sub_1f23h		;1f36
l1f39h:
	ld a,b			;1f39
	or c			;1f3a
	jr nz,l1f41h		;1f3b
	ld bc,(05cb2h)		;1f3d
l1f41h:
	push bc			;1f41
	ld de,(05c4bh)		;1f42
	ld hl,(05c59h)		;1f46
	dec hl			;1f49
	call sub_174dh		;1f4a
	call sub_08a6h		;1f4d
	ld hl,05cc6h		;1f50
	ld l,(hl)		;1f53
	bit 7,l			;1f54
	jr z,l1f67h		;1f56
	ld hl,(05cbch)		;1f58
	inc hl			;1f5b
	inc hl			;1f5c
	ld e,(hl)		;1f5d
	inc hl			;1f5e
	ld d,(hl)		;1f5f
	ex de,hl		;1f60
	dec hl			;1f61
	ld (05c57h),hl		;1f62
	jr l1f6eh		;1f65
l1f67h:
	ld hl,(05c53h)		;1f67
	dec hl			;1f6a
	ld (05c57h),hl		;1f6b
l1f6eh:
	ld hl,(05c65h)		;1f6e
	ld de,00032h		;1f71
	add hl,de		;1f74
	pop de			;1f75
	sbc hl,de		;1f76
	jr nc,l1f82h		;1f78
	ld hl,(05cb4h)		;1f7a
	and a			;1f7d
	sbc hl,de		;1f7e
	jr nc,l1f84h		;1f80
l1f82h:
	rst 8			;1f82
	dec d			;1f83
l1f84h:
	ex de,hl		;1f84
	ld (05cb2h),hl		;1f85
	pop de			;1f88
	pop bc			;1f89
	ld hl,(05cc0h)		;1f8a
	dec hl			;1f8d
	ld (hl),03eh		;1f8e
	dec hl			;1f90
	ld sp,hl		;1f91
	push bc			;1f92
	ld (05c3dh),sp		;1f93
	ex de,hl		;1f97
	jp (hl)			;1f98
	pop de			;1f99
	ld h,(iy+00dh)		;1f9a
	inc h			;1f9d
	ex (sp),hl		;1f9e
	inc sp			;1f9f
	ld bc,(05c45h)		;1fa0
	push bc			;1fa4
	push hl			;1fa5
	ld (05c3dh),sp		;1fa6
	push de			;1faa
	call sub_1ef1h		;1fab
	ld hl,(05cc0h)		;1fae
	dec h			;1fb1
	ld de,l0010h		;1fb2
	add hl,de		;1fb5
	sbc hl,sp		;1fb6
	ret c			;1fb8
	jr l1fcfh		;1fb9
sub_1fbbh:
	ld hl,(05c65h)		;1fbb
	add hl,bc		;1fbe
	jr c,l1fcfh		;1fbf
	ex de,hl		;1fc1
	ld hl,l0050h		;1fc2
	add hl,de		;1fc5
	jr c,l1fcfh		;1fc6
	ld de,(05cb2h)		;1fc8
	sbc hl,de		;1fcc
	ret c			;1fce
l1fcfh:
	ld l,003h		;1fcf
	jp l0055h		;1fd1
	pop bc			;1fd4
	pop hl			;1fd5
	pop de			;1fd6
	ld a,d			;1fd7
	cp 03eh			;1fd8
	jr z,l1fe7h		;1fda
	dec sp			;1fdc
	ex (sp),hl		;1fdd
	ex de,hl		;1fde
	ld (05c3dh),sp		;1fdf
	push bc			;1fe3
	jp l1efdh		;1fe4
l1fe7h:
	push de			;1fe7
	push hl			;1fe8
	rst 8			;1fe9
	ld b,0fdh		;1fea
	rlc c			;1fec
	xor (hl)		;1fee
	call sub_1f23h		;1fef
l1ff2h:
	halt			;1ff2
	dec bc			;1ff3
	ld a,b			;1ff4
	or c			;1ff5
	jr z,l2004h		;1ff6
	ld a,b			;1ff8
	and c			;1ff9
	inc a			;1ffa
	jr nz,l1ffeh		;1ffb
	inc bc			;1ffd
l1ffeh:
	bit 5,(iy+001h)		;1ffe
	jr z,l1ff2h		;2002
l2004h:
	res 5,(iy+001h)		;2004
	ret			;2008
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
	ret			;201c
	call sub_2889h		;201d
	jr z,l2027h		;2020
	ld a,0ceh		;2022
	jp l1e94h		;2024
l2027h:
	set 6,(iy+001h)		;2027
	call sub_304bh		;202b
	jr nc,l2046h		;202e
	rst 20h			;2030
	cp 024h			;2031
	jr nz,l203ah		;2033
	res 6,(iy+001h)		;2035
	rst 20h			;2039
l203ah:
	cp 028h			;203a
	jr nz,l207ah		;203c
	rst 20h			;203e
	cp 029h			;203f
	jr z,l2063h		;2041
l2043h:
	call sub_304bh		;2043
l2046h:
	jp nc,l1bedh		;2046
	ex de,hl		;2049
	rst 20h			;204a
	cp 024h			;204b
	jr nz,l2051h		;204d
	ex de,hl		;204f
	rst 20h			;2050
l2051h:
	ex de,hl		;2051
	ld bc,l0005h+1		;2052
	call sub_12bbh		;2055
	inc hl			;2058
	inc hl			;2059
	ld (hl),00eh		;205a
	cp 02ch			;205c
	jr nz,l2063h		;205e
	rst 20h			;2060
	jr l2043h		;2061
l2063h:
	cp 029h			;2063
	jr nz,l207ah		;2065
	rst 20h			;2067
	cp 03dh			;2068
	jr nz,l207ah		;206a
	rst 20h			;206c
	ld a,(05c3bh)		;206d
	push af			;2070
	call sub_2854h		;2071
	pop af			;2074
	xor (iy+001h)		;2075
l2078h:
	and 040h		;2078
l207ah:
	jp nz,l1bedh		;207a
	call 01b44h		;207d
	rst 18h			;2080
	cp 07fh			;2081
	jr z,l20aeh		;2083
	cp 0ech			;2085
	jr z,l20bch		;2087
	cp 0e8h			;2089
	jp nz,l1bedh		;208b
	rst 20h			;208e
	call 01b44h		;208f
	bit 7,(iy+07dh)		;2092
	ret z			;2096
	ld hl,(05cb8h)		;2097
	ld (05c42h),hl		;209a
	ld a,(05cbah)		;209d
	ld (05c44h),a		;20a0
	res 6,(iy+07dh)		;20a3
l20a7h:
	pop hl			;20a7
	ld de,l0005h+2		;20a8
	add hl,de		;20ab
	push hl			;20ac
	ret			;20ad
l20aeh:
	rst 20h			;20ae
	call 01b44h		;20af
	res 7,(iy+07dh)		;20b2
	res 6,(iy+07dh)		;20b6
	jr l20a7h		;20ba
l20bch:
	rst 20h			;20bc
	call sub_1be5h		;20bd
	call 01b44h		;20c0
	call sub_3160h		;20c3
	ld a,b			;20c6
	and 03fh		;20c7
	or 080h			;20c9
	ld b,a			;20cb
	ld (05cb6h),bc		;20cc
	ret			;20d0
	rst 18h			;20d1
	cp 02ch			;20d2
	jr nz,l20e0h		;20d4
	call sub_2889h		;20d6
	jr z,l20e7h		;20d9
	rst 28h			;20db
	and c			;20dc
	jr c,$+26		;20dd
	rlca			;20df
l20e0h:
	call sub_1be5h		;20e0
	cp 02ch			;20e3
	jr nz,l211ch		;20e5
l20e7h:
	rst 20h			;20e7
	cp 00dh			;20e8
	jr z,l20f5h		;20ea
	cp 03ah			;20ec
	jr z,l20f5h		;20ee
	call sub_1be5h		;20f0
	jr l20feh		;20f3
l20f5h:
	ld bc,l270fh		;20f5
	call sub_2889h		;20f8
	call nz,sub_30e9h	;20fb
l20feh:
	call 01b44h		;20fe
	call sub_211eh		;2101
	inc hl			;2104
	call sub_16d6h		;2105
	push hl			;2108
	call sub_211eh		;2109
	call sub_16d6h		;210c
	ex de,hl		;210f
	pop hl			;2110
	push hl			;2111
	scf			;2112
	sbc hl,de		;2113
	jr c,l211ch		;2115
	pop hl			;2117
	call sub_174dh		;2118
	ret			;211b
l211ch:
	rst 8			;211c
	dec bc			;211d
sub_211eh:
	call sub_3160h		;211e
	ld a,b			;2121
	and 03fh		;2122
	ld h,a			;2124
	ld l,c			;2125
	ret			;2126
l2127h:
	rst 20h			;2127
	call l1bddh		;2128
	call sub_2889h		;212b
	jr z,l2146h		;212e
	call 03193h		;2130
	push af			;2133
	call 03193h		;2134
	cp 011h			;2137
	jp nc,l1bedh		;2139
	dec a			;213c
	inc a			;213d
	jp m,l1bedh		;213e
	out (0f5h),a		;2141
	pop af			;2143
	out (0f6h),a		;2144
l2146h:
	rst 18h			;2146
	cp 03bh			;2147
	jr z,l2127h		;2149
	call 01b44h		;214b
	ret			;214e
sub_214fh:
	call sub_2889h		;214f
	pop hl			;2152
	ret z			;2153
	jp (hl)			;2154
	ld a,003h		;2155
	jr l2163h		;2157
	ld a,(05cc6h)		;2159
	res 0,a			;215c
	ld (05cc6h),a		;215e
	ld a,002h		;2161
l2163h:
	call sub_2889h		;2163
	call nz,sub_1230h	;2166
	call sub_2889h		;2169
	call nz,sub_2179h	;216c
	call sub_0888h		;216f
	call sub_217eh		;2172
	call 01b44h		;2175
	ret			;2178
sub_2179h:
	set 4,(iy+001h)		;2179
	ret			;217d
sub_217eh:
	rst 18h			;217e
	call sub_21e4h		;217f
	jr z,l2191h		;2182
l2184h:
	call sub_21edh		;2184
	jr z,l2184h		;2187
	call sub_219bh		;2189
	call sub_21edh		;218c
	jr z,l2184h		;218f
l2191h:
	cp 029h			;2191
	ret z			;2193
sub_2194h:
	call sub_214fh		;2194
	ld a,00dh		;2197
	rst 10h			;2199
	ret			;219a
sub_219bh:
	rst 18h			;219b
	cp 0ach			;219c
	jr nz,l21adh		;219e
	call sub_1bdch		;21a0
	call sub_214fh		;21a3
	call sub_2660h		;21a6
	ld a,016h		;21a9
	jr l21bdh		;21ab
l21adh:
	cp 0adh			;21ad
	jr nz,l21c3h		;21af
	rst 20h			;21b1
	call sub_1be5h		;21b2
	call sub_214fh		;21b5
	call sub_1f23h		;21b8
	ld a,017h		;21bb
l21bdh:
	rst 10h			;21bd
	ld a,c			;21be
	rst 10h			;21bf
	ld a,b			;21c0
	rst 10h			;21c1
	ret			;21c2
l21c3h:
	call sub_239ch		;21c3
	ret nc			;21c6
	call sub_220fh		;21c7
	ret nc			;21ca
	call sub_2854h		;21cb
	call sub_214fh		;21ce
	bit 6,(iy+001h)		;21d1
	call z,sub_2fafh	;21d5
	jp nz,l31a1h		;21d8
l21dbh:
	ld a,b			;21db
	or c			;21dc
	dec bc			;21dd
	ret z			;21de
	ld a,(de)		;21df
	inc de			;21e0
	rst 10h			;21e1
	jr l21dbh		;21e2
sub_21e4h:
	cp 029h			;21e4
	ret z			;21e6
	cp 00dh			;21e7
	ret z			;21e9
	cp 03ah			;21ea
	ret			;21ec
sub_21edh:
	rst 18h			;21ed
	cp 03bh			;21ee
	jr z,l2206h		;21f0
	cp 02ch			;21f2
	jr nz,l2200h		;21f4
	call sub_2889h		;21f6
	jr z,l2206h		;21f9
	ld a,006h		;21fb
	rst 10h			;21fd
	jr l2206h		;21fe
l2200h:
	cp 027h			;2200
	ret nz			;2202
	call sub_2194h		;2203
l2206h:
	rst 20h			;2206
	call sub_21e4h		;2207
	jr nz,l220dh		;220a
	pop bc			;220c
l220dh:
	cp a			;220d
	ret			;220e
sub_220fh:
	cp 023h			;220f
	scf			;2211
	ret nz			;2212
	rst 20h			;2213
	call sub_1be5h		;2214
	and a			;2217
	call sub_214fh		;2218
	call sub_1f1eh		;221b
	ld (05ccbh),a		;221e
	cp 010h			;2221
	jp nc,l123dh		;2223
	call sub_1230h		;2226
	and a			;2229
	ret			;222a
	ld a,(05cc6h)		;222b
	set 0,a			;222e
	ld (05cc6h),a		;2230
	call sub_2889h		;2233
	jr z,l2240h		;2236
	ld a,001h		;2238
	call sub_1230h		;223a
	call sub_08a9h		;223d
l2240h:
	ld (iy+002h),001h	;2240
	call sub_226bh		;2244
	call 01b44h		;2247
	ld bc,(05c88h)		;224a
	ld a,(05c6bh)		;224e
	cp b			;2251
	jr c,l2257h		;2252
	ld c,021h		;2254
	ld b,a			;2256
l2257h:
	ld (05c88h),bc		;2257
	ld a,019h		;225b
	sub b			;225d
	ld (05c8ch),a		;225e
	res 0,(iy+002h)		;2261
	call l0914h		;2265
	jp sub_08a9h		;2268
sub_226bh:
	call sub_21edh		;226b
	jr z,sub_226bh		;226e
	cp 028h			;2270
	jr nz,l2282h		;2272
	rst 20h			;2274
	call sub_217eh		;2275
	rst 18h			;2278
	cp 029h			;2279
	jp nz,l1bedh		;227b
	rst 20h			;227e
	jp l235ch		;227f
l2282h:
	cp 0cah			;2282
	jr nz,l2297h		;2284
	rst 20h			;2286
	call sub_1b82h		;2287
	set 7,(iy+037h)		;228a
	bit 6,(iy+001h)		;228e
	jp nz,l1bedh		;2292
	jr l22a4h		;2295
l2297h:
	call sub_304bh		;2297
	jp nc,l2359h		;229a
	call sub_1b82h		;229d
	res 7,(iy+037h)		;22a0
l22a4h:
	call sub_2889h		;22a4
	jp z,l235ch		;22a7
	call sub_134eh		;22aa
	ld hl,05c71h		;22ad
	res 6,(hl)		;22b0
	set 5,(hl)		;22b2
	ld bc,l0001h		;22b4
	bit 7,(hl)		;22b7
	jr nz,l22c6h		;22b9
	ld a,(05c3bh)		;22bb
	and 040h		;22be
	jr nz,l22c4h		;22c0
	ld c,003h		;22c2
l22c4h:
	or (hl)			;22c4
	ld (hl),a		;22c5
l22c6h:
	rst 30h			;22c6
	ld (hl),00dh		;22c7
	ld a,c			;22c9
	rrca			;22ca
	rrca			;22cb
	jr nc,l22d3h		;22cc
	ld a,022h		;22ce
	ld (de),a		;22d0
	dec hl			;22d1
	ld (hl),a		;22d2
l22d3h:
	ld (05c5bh),hl		;22d3
	bit 7,(iy+037h)		;22d6
	jr nz,l2308h		;22da
	ld hl,(05c5dh)		;22dc
	push hl			;22df
	ld hl,(05c3dh)		;22e0
	push hl			;22e3
l22e4h:
	ld hl,l22e4h		;22e4
	push hl			;22e7
	bit 4,(iy+030h)		;22e8
	jr z,l22f2h		;22ec
	ld (05c3dh),sp		;22ee
l22f2h:
	ld hl,(05c61h)		;22f2
	call l0d0dh		;22f5
	ld (iy+000h),0ffh	;22f8
	call sub_0a82h		;22fc
	res 7,(iy+001h)		;22ff
	call sub_2363h		;2303
	jr l230bh		;2306
l2308h:
	call sub_0a82h		;2308
l230bh:
	ld (iy+022h),000h	;230b
	call 02380h		;230f
	jr nz,l231eh		;2312
	call sub_0c83h		;2314
	ld bc,(05c82h)		;2317
	call l0914h		;231b
l231eh:
	ld hl,05c71h		;231e
	res 5,(hl)		;2321
	bit 7,(hl)		;2323
	res 7,(hl)		;2325
	jr nz,l2345h		;2327
	pop hl			;2329
	pop hl			;232a
	ld (05c3dh),hl		;232b
	pop hl			;232e
	ld (05c5fh),hl		;232f
	set 7,(iy+001h)		;2332
	call sub_2363h		;2336
	ld hl,(05c5fh)		;2339
	ld (iy+026h),000h	;233c
	ld (05c5dh),hl		;2340
	jr l235ch		;2343
l2345h:
	ld hl,(05c63h)		;2345
	ld de,(05c61h)		;2348
	scf			;234c
	sbc hl,de		;234d
	ld b,h			;234f
	ld c,l			;2350
	call sub_2e70h		;2351
	call l2ebdh		;2354
	jr l235ch		;2357
l2359h:
	call sub_219bh		;2359
l235ch:
	call sub_21edh		;235c
	jp z,sub_226bh		;235f
	ret			;2362
sub_2363h:
	ld hl,(05c61h)		;2363
	ld (05c5dh),hl		;2366
	rst 18h			;2369
	cp 0e2h			;236a
	jr z,l237ah		;236c
	ld a,(05c71h)		;236e
	call sub_1bbch		;2371
	rst 18h			;2374
	cp 00dh			;2375
	ret z			;2377
	rst 8			;2378
	dec bc			;2379
l237ah:
	call sub_2889h		;237a
	ret z			;237d
	rst 8			;237e
	djnz $+44		;237f
	ld d,c			;2381
	ld e,h			;2382
	inc hl			;2383
	inc hl			;2384
	inc hl			;2385
	inc hl			;2386
	ld a,(hl)		;2387
	cp 04bh			;2388
	ret			;238a
l238bh:
	rst 20h			;238b
sub_238ch:
	call sub_239ch		;238c
	ret c			;238f
	rst 18h			;2390
	cp 02ch			;2391
	jr z,l238bh		;2393
	cp 03bh			;2395
	jr z,l238bh		;2397
	jp l1bedh		;2399
sub_239ch:
	cp 0d9h			;239c
	ret c			;239e
	cp 0dfh			;239f
	ccf			;23a1
	ret c			;23a2
	push af			;23a3
	rst 20h			;23a4
	pop af			;23a5
sub_23a6h:
	sub 0c9h		;23a6
	push af			;23a8
	call sub_1be5h		;23a9
	pop af			;23ac
	and a			;23ad
	call sub_214fh		;23ae
	push af			;23b1
	call sub_1f1eh		;23b2
	ld d,a			;23b5
	pop af			;23b6
	rst 10h			;23b7
	ld a,d			;23b8
	rst 10h			;23b9
	ret			;23ba
l23bbh:
	sub 011h		;23bb
	adc a,000h		;23bd
	jr z,l23deh		;23bf
	sub 002h		;23c1
	adc a,000h		;23c3
	jr z,l241dh		;23c5
	cp 001h			;23c7
	ld a,d			;23c9
	ld b,001h		;23ca
	jr nz,l23d2h		;23cc
	rlca			;23ce
	rlca			;23cf
	ld b,004h		;23d0
l23d2h:
	ld c,a			;23d2
	ld a,d			;23d3
	cp 002h			;23d4
	jr nc,l23eeh		;23d6
	ld a,c			;23d8
	ld hl,05c91h		;23d9
	jr l2416h		;23dc
l23deh:
	ld a,d			;23de
	ld b,007h		;23df
	jr c,l23e8h		;23e1
	rlca			;23e3
	rlca			;23e4
	rlca			;23e5
	ld b,038h		;23e6
l23e8h:
	ld c,a			;23e8
	ld a,d			;23e9
	cp 00ah			;23ea
	jr c,l23f0h		;23ec
l23eeh:
	rst 8			;23ee
	inc de			;23ef
l23f0h:
	ld hl,05c8fh		;23f0
	cp 008h			;23f3
	jr c,l2402h		;23f5
	ld a,(hl)		;23f7
	jr z,l2401h		;23f8
	or b			;23fa
	cpl			;23fb
	and 024h		;23fc
	jr z,l2401h		;23fe
	ld a,b			;2400
l2401h:
	ld c,a			;2401
l2402h:
	ld a,c			;2402
	call l2416h		;2403
	ld a,007h		;2406
	cp d			;2408
	sbc a,a			;2409
	call l2416h		;240a
	rlca			;240d
	rlca			;240e
	and 050h		;240f
	ld b,a			;2411
	ld a,008h		;2412
	cp d			;2414
	sbc a,a			;2415
l2416h:
	xor (hl)		;2416
	and b			;2417
	xor (hl)		;2418
	ld (hl),a		;2419
	inc hl			;241a
	ld a,b			;241b
	ret			;241c
l241dh:
	sbc a,a			;241d
	ld a,d			;241e
	rrca			;241f
	ld b,080h		;2420
	jr nz,l2427h		;2422
	rrca			;2424
	ld b,040h		;2425
l2427h:
	ld c,a			;2427
	ld a,d			;2428
	cp 008h			;2429
	jr z,l2431h		;242b
	cp 002h			;242d
	jr nc,l23eeh		;242f
l2431h:
	ld a,c			;2431
	ld hl,05c8fh		;2432
	call l2416h		;2435
	ld a,c			;2438
	rrca			;2439
	rrca			;243a
	rrca			;243b
	jr l2416h		;243c
	call sub_1f1eh		;243e
	cp 008h			;2441
	jr nc,l23eeh		;2443
	out (0feh),a		;2445
	rlca			;2447
	rlca			;2448
	rlca			;2449
	bit 5,a			;244a
	jr nz,l2450h		;244c
	xor 007h		;244e
l2450h:
	ld (05c48h),a		;2450
	ret			;2453
	rst 18h			;2454
	cp 02ah			;2455
	jr nz,l247fh		;2457
	call l0020h		;2459
	call 01b44h		;245c
	ret			;245f
	ld a,010h		;2460
	ld hl,05c16h		;2462
l2465h:
	call sub_13a8h		;2465
	inc hl			;2468
	inc hl			;2469
	dec a			;246a
	jr nz,l2465h		;246b
	ld hl,009f4h		;246d
	push hl			;2470
	ld b,0feh		;2471
l2473h:
	ld c,088h		;2473
	push bc			;2475
	ld bc,l0000h		;2476
	push bc			;2479
	push bc			;247a
	call 065d0h		;247b
	ret			;247e
l247fh:
	cp 023h			;247f
	jr z,l2498h		;2481
	call 01b44h		;2483
	ret			;2486
	ld hl,l0c4ch		;2487
	push hl			;248a
	ld bc,0fefeh		;248b
	push bc			;248e
	ld bc,l0000h		;248f
	push bc			;2492
	push bc			;2493
	call 065d0h		;2494
	ret			;2497
l2498h:
	rst 20h			;2498
	call sub_1be5h		;2499
	call 01b44h		;249c
	call sub_1f1eh		;249f
	cp 011h			;24a2
	jr nc,l24b7h		;24a4
	and a			;24a6
	jp m,l24b7h		;24a7
	add a,a			;24aa
	add a,016h		;24ab
	ld l,a			;24ad
	ld h,05ch		;24ae
	ld e,(hl)		;24b0
	inc hl			;24b1
	ld d,(hl)		;24b2
	ld a,d			;24b3
	or e			;24b4
	jr nz,l24b9h		;24b5
l24b7h:
	rst 8			;24b7
	rla			;24b8
l24b9h:
	ld a,d			;24b9
	cp 080h			;24ba
	ret c			;24bc
	jp l2567h		;24bd
	sub 080h		;24c0
	ld d,a			;24c2
	ld de,(sub_17cfh)	;24c3
	call 01b44h		;24c7
	ret			;24ca
	ld bc,l0014h		;24cb
	ret			;24ce
	push hl			;24cf
	jr l2473h		;24d0
l24d2h:
	rst 18h			;24d2
	cp 02ah			;24d3
	jp nz,l2547h		;24d5
	rst 20h			;24d8
	call sub_1befh		;24d9
	cp 02ch			;24dc
	jp nz,l1bedh		;24de
	call sub_2889h		;24e1
	jr nz,l24ech		;24e4
	call sub_2569h		;24e6
	call 01b44h		;24e9
l24ech:
	jr l2567h		;24ec
	call sub_2fafh		;24ee
	dec bc			;24f1
	ld a,b			;24f2
	or c			;24f3
	jr nz,l2567h		;24f4
	ld a,(de)		;24f6
	and 0dfh		;24f7
	ld c,a			;24f9
	call sub_1374h		;24fa
	jp nc,l2567h		;24fd
	push hl			;2500
	ld de,l0014h		;2501
	add hl,de		;2504
	ld a,(hl)		;2505
	bit 1,a			;2506
	jp z,l2567h		;2508
	pop hl			;250b
	ex de,hl		;250c
	call sub_25b9h		;250d
	ex de,hl		;2510
	ld a,(05c74h)		;2511
	and a			;2514
	cp 000h			;2515
	jr c,l253fh		;2517
	jr z,l2543h		;2519
	add a,0d4h		;251b
	ld c,a			;251d
l251eh:
	push bc			;251e
	ld d,(hl)		;251f
	ld e,088h		;2520
	ld bc,0000ch		;2522
	add hl,bc		;2525
	ld c,(hl)		;2526
	inc hl			;2527
	ld b,(hl)		;2528
	push bc			;2529
	push de			;252a
	ld hl,(05c65h)		;252b
	dec hl			;252e
	ld c,(hl)		;252f
	inc c			;2530
	ld (05c65h),hl		;2531
	ld b,000h		;2534
	push bc			;2536
	ld bc,l0000h		;2537
	push bc			;253a
	call 065d0h		;253b
	ret			;253e
l253fh:
	ld c,0f8h		;253f
	jr l251eh		;2541
l2543h:
	ld c,0efh		;2543
	jr l251eh		;2545
l2547h:
	pop af			;2547
	exx			;2548
	ld hl,l01abh		;2549
l254ch:
	jp l3ce3h		;254c
	call sub_1befh		;254f
	exx			;2552
	ld hl,l01cch		;2553
	jr l254ch		;2556
	call sub_1be5h		;2558
	exx			;255b
	ld hl,l1855h		;255c
	jr l254ch		;255f
	ret			;2561
	call 0fd90h		;2562
	jr $-7			;2565
l2567h:
	rst 8			;2567
	ld (de),a		;2568
sub_2569h:
	ld a,(05cc6h)		;2569
	res 1,a			;256c
	ld (05cc6h),a		;256e
	push bc			;2571
	rst 18h			;2572
l2573h:
	cp 022h			;2573
	jr z,l2582h		;2575
	cp 03ah			;2577
	jr z,l2582h		;2579
	cp 00dh			;257b
	jr z,l2582h		;257d
	rst 20h			;257f
	jr l2573h		;2580
l2582h:
	cp 03ah			;2582
	jr nz,l258dh		;2584
	ld a,(05cc6h)		;2586
	bit 1,a			;2589
	jr nz,l25b6h		;258b
l258dh:
	push hl			;258d
	ld b,005h		;258e
l2590h:
	dec hl			;2590
	ld a,(hl)		;2591
	cp 00eh			;2592
	jr z,l25b5h		;2594
	djnz l2590h		;2596
	pop hl			;2598
	rst 18h			;2599
	cp 022h			;259a
	jr nz,l25b3h		;259c
	ld a,(05cc6h)		;259e
	bit 1,a			;25a1
	jr nz,l25ach		;25a3
	set 1,a			;25a5
	ld (05cc6h),a		;25a7
	jr l25b6h		;25aa
l25ach:
	res 1,a			;25ac
	ld (05cc6h),a		;25ae
	jr l25b6h		;25b1
l25b3h:
	pop bc			;25b3
	ret			;25b4
l25b5h:
	pop hl			;25b5
l25b6h:
	rst 20h			;25b6
	jr l2573h		;25b7
sub_25b9h:
	ld bc,0fefeh		;25b9
	call 06499h		;25bc
	call l0f43h		;25bf
	ld bc,0ff00h		;25c2
	call 06499h		;25c5
	ld b,0cfh		;25c8
	jr l25d6h		;25ca
	ld b,0d0h		;25cc
	jr l25d6h		;25ce
	ld b,0d1h		;25d0
	jr l25d6h		;25d2
	ld b,0d2h		;25d4
l25d6h:
	call sub_2889h		;25d6
	jr nz,l25e1h		;25d9
	call sub_2569h		;25db
	call 01b44h		;25de
l25e1h:
	jp l2567h		;25e1
	ld bc,0000ch		;25e4
	add hl,bc		;25e7
	ld c,(hl)		;25e8
	inc hl			;25e9
	ld b,(hl)		;25ea
	push bc			;25eb
	push de			;25ec
	ld hl,(05c65h)		;25ed
	dec hl			;25f0
	ld c,(hl)		;25f1
	inc c			;25f2
	ld (05c65h),hl		;25f3
	ld b,000h		;25f6
	push bc			;25f8
	ld bc,l0000h		;25f9
	push bc			;25fc
	call 065d0h		;25fd
	ret			;2600
	rst 8			;2601
	ld (de),a		;2602
sub_2603h:
	ld a,0afh		;2603
	sub b			;2605
	jp c,l2852h		;2606
	ld b,a			;2609
	and a			;260a
	rra			;260b
	scf			;260c
	rra			;260d
	and a			;260e
	rra			;260f
	xor b			;2610
	and 0f8h		;2611
	xor b			;2613
	ld h,a			;2614
	ld a,c			;2615
	rlca			;2616
	rlca			;2617
	rlca			;2618
	xor b			;2619
	and 0c7h		;261a
	xor b			;261c
	rlca			;261d
	rlca			;261e
	ld l,a			;261f
	ld a,c			;2620
	and 007h		;2621
	ret			;2623
sub_2624h:
	call sub_2660h		;2624
	call sub_2603h		;2627
	ld b,a			;262a
	inc b			;262b
	ld a,(hl)		;262c
l262dh:
	rlca			;262d
	djnz l262dh		;262e
	and 001h		;2630
	jp l30e6h		;2632
l2635h:
	call sub_2660h		;2635
	call sub_263eh		;2638
	jp sub_0888h		;263b
sub_263eh:
	ld (05c7dh),bc		;263e
	call sub_2603h		;2642
	ld b,a			;2645
	inc b			;2646
	ld a,0feh		;2647
l2649h:
	rrca			;2649
	djnz l2649h		;264a
	ld b,a			;264c
	ld a,(hl)		;264d
	ld c,(iy+057h)		;264e
	bit 0,c			;2651
	jr nz,l2656h		;2653
	and b			;2655
l2656h:
	bit 2,c			;2656
	jr nz,l265ch		;2658
	xor b			;265a
	cpl			;265b
l265ch:
	ld (hl),a		;265c
	jp sub_0710h		;265d
sub_2660h:
	call sub_266dh		;2660
	ld b,a			;2663
	push bc			;2664
	call sub_266dh		;2665
	ld e,c			;2668
	pop bc			;2669
	ld d,c			;266a
l266bh:
	ld c,a			;266b
	ret			;266c
sub_266dh:
	call 03193h		;266d
	jp c,l2852h		;2670
	ld c,001h		;2673
	ret z			;2675
	ld c,0ffh		;2676
	ret			;2678
	rst 18h			;2679
	cp 02ch			;267a
	jp nz,l1bedh		;267c
	rst 20h			;267f
	call sub_1be5h		;2680
	call 01b44h		;2683
	rst 28h			;2686
	ld hl,(l383dh)		;2687
	ld a,(hl)		;268a
	cp 081h			;268b
	jr nc,l2694h		;268d
	rst 28h			;268f
	ld (bc),a		;2690
	jr c,l26abh		;2691
	and c			;2693
l2694h:
	rst 28h			;2694
	and e			;2695
	jr c,l26ceh		;2696
	add a,e			;2698
	rst 28h			;2699
	push bc			;269a
	ld (bc),a		;269b
	jr c,l266bh		;269c
	sub 027h		;269e
	push bc			;26a0
	rst 28h			;26a1
	ld sp,l04e1h		;26a2
	jr c,l2725h		;26a5
	cp 080h			;26a7
	jr nc,l26b3h		;26a9
l26abh:
	rst 28h			;26ab
	ld (bc),a		;26ac
	ld (bc),a		;26ad
	jr c,$-61		;26ae
	jp l2635h		;26b0
l26b3h:
	rst 28h			;26b3
	jp nz,0c001h		;26b4
	ld (bc),a		;26b7
	inc bc			;26b8
	ld bc,l0fe0h		;26b9
	ret nz			;26bc
l26bdh:
	ld bc,0e031h		;26bd
	ld bc,0e031h		;26c0
	and b			;26c3
	pop bc			;26c4
l26c5h:
	ld (bc),a		;26c5
	jr c,l26c5h		;26c6
	inc (hl)		;26c8
	ld h,d			;26c9
	call sub_1f1eh		;26ca
	ld l,a			;26cd
l26ceh:
	push hl			;26ce
	call sub_1f1eh		;26cf
	pop hl			;26d2
	ld h,a			;26d3
	ld (05c7dh),hl		;26d4
	pop bc			;26d7
	jp l2779h		;26d8
l26dbh:
	rst 18h			;26db
	cp 02ch			;26dc
	jr z,l26e6h		;26de
	call 01b44h		;26e0
	jp 027d0h		;26e3
l26e6h:
	rst 20h			;26e6
	call sub_1be5h		;26e7
	call 01b44h		;26ea
	rst 28h			;26ed
	push bc			;26ee
	and d			;26ef
	inc b			;26f0
	rra			;26f1
	ld sp,l3030h		;26f2
	nop			;26f5
	ld b,002h		;26f6
	jr c,l26bdh		;26f8
	ret nc			;26fa
l26fbh:
	daa			;26fb
	ret nz			;26fc
	ld (bc),a		;26fd
	pop bc			;26fe
	ld (bc),a		;26ff
	ld sp,0e12ah		;2700
	ld bc,l2ae1h		;2703
	rrca			;2706
	ret po			;2707
	dec b			;2708
	ld hl,(001e0h)		;2709
	dec a			;270c
	jr c,l278dh		;270d
l270fh:
	cp 081h			;270f
	jr nc,l271ah		;2711
	rst 28h			;2713
	ld (bc),a		;2714
	ld (bc),a		;2715
	jr c,l26dbh		;2716
	ret nc			;2718
	daa			;2719
l271ah:
	call sub_27d6h		;271a
	push bc			;271d
	rst 28h			;271e
	ld (bc),a		;271f
	pop hl			;2720
	ld bc,0c105h		;2721
	ld (bc),a		;2724
l2725h:
	ld bc,0e131h		;2725
	inc b			;2728
	jp nz,l0102h		;2729
	ld sp,l04e1h		;272c
	jp po,0e0e5h		;272f
	inc bc			;2732
	and d			;2733
	inc b			;2734
	ld sp,0c51fh		;2735
	ld (bc),a		;2738
	jr nz,l26fbh		;2739
	ld (bc),a		;273b
	jp nz,0c102h		;273c
	push hl			;273f
	inc b			;2740
	ret po			;2741
	jp po,l0f04h		;2742
	pop hl			;2745
	ld bc,l02c1h		;2746
	ret po			;2749
	inc b			;274a
	jp po,l04e5h		;274b
	inc bc			;274e
	jp nz,0e12ah		;274f
	ld hl,(l020fh)		;2752
	jr c,$+28		;2755
	cp 081h			;2757
	pop bc			;2759
	jp c,027d0h		;275a
	push bc			;275d
	rst 28h			;275e
	ld bc,l3a38h		;275f
	ld a,l			;2762
	ld e,h			;2763
	call l30e6h		;2764
	rst 28h			;2767
	ret nz			;2768
	rrca			;2769
	ld bc,l3a38h		;276a
	ld a,(hl)		;276d
	ld e,h			;276e
	call l30e6h		;276f
	rst 28h			;2772
	push bc			;2773
	rrca			;2774
	ret po			;2775
	push hl			;2776
	jr c,$-61		;2777
l2779h:
	dec b			;2779
	jr z,l27b8h		;277a
	jr l2792h		;277c
l277eh:
	rst 28h			;277e
	pop hl			;277f
l2780h:
	ld sp,l04e3h		;2780
	jp po,l04e4h		;2783
	inc bc			;2786
	pop bc			;2787
	ld (bc),a		;2788
	call po,0e204h		;2789
	ex (sp),hl		;278c
l278dh:
	inc b			;278d
	rrca			;278e
	jp nz,l3802h		;278f
l2792h:
	push bc			;2792
	rst 28h			;2793
	ret nz			;2794
	ld (bc),a		;2795
	pop hl			;2796
	rrca			;2797
	ld sp,l3a38h		;2798
	ld a,l			;279b
	ld e,h			;279c
	call l30e6h		;279d
	rst 28h			;27a0
	inc bc			;27a1
	ret po			;27a2
	jp po,0c00fh		;27a3
	ld bc,l38e0h		;27a6
	ld a,(05c7eh)		;27a9
	call l30e6h		;27ac
	rst 28h			;27af
	inc bc			;27b0
l27b1h:
	jr c,l2780h		;27b1
	djnz l27ddh		;27b3
	pop bc			;27b5
	djnz l277eh		;27b6
l27b8h:
	rst 28h			;27b8
	ld (bc),a		;27b9
	ld (bc),a		;27ba
	ld bc,l3a38h		;27bb
	ld a,l			;27be
	ld e,h			;27bf
	call l30e6h		;27c0
	rst 28h			;27c3
	inc bc			;27c4
	ld bc,l3a38h		;27c5
	ld a,(hl)		;27c8
	ld e,h			;27c9
	call l30e6h		;27ca
	rst 28h			;27cd
	inc bc			;27ce
	jr c,$-49		;27cf
	djnz $+42		;27d1
	jp sub_0888h		;27d3
sub_27d6h:
	rst 28h			;27d6
	ld sp,l3428h		;27d7
	ld (l00ffh+1),a		;27da
l27ddh:
	dec b			;27dd
	push hl			;27de
	ld bc,02a05h		;27df
	jr c,l27b1h		;27e2
	sub e			;27e4
	ld sp,00638h		;27e5
	and 0fch		;27e8
	add a,004h		;27ea
	jr nc,l27f0h		;27ec
	ld a,0fch		;27ee
l27f0h:
	push af			;27f0
	call l30e6h		;27f1
	rst 28h			;27f4
	push hl			;27f5
	ld bc,03105h		;27f6
	rra			;27f9
	call nz,sub_3102h	;27fa
	and d			;27fd
	inc b			;27fe
	rra			;27ff
	pop bc			;2800
	ld bc,l02c0h		;2801
	ld sp,03104h		;2804
	rrca			;2807
	and c			;2808
	inc bc			;2809
	dec de			;280a
	jp l3802h		;280b
	pop bc			;280e
	ret			;280f
	call sub_2660h		;2810
	ld a,c			;2813
	cp b			;2814
	jr nc,l281dh		;2815
	ld l,c			;2817
	push de			;2818
	xor a			;2819
	ld e,a			;281a
	jr l2824h		;281b
l281dh:
	or c			;281d
	ret z			;281e
	ld l,b			;281f
	ld b,c			;2820
	push de			;2821
	ld d,000h		;2822
l2824h:
	ld h,b			;2824
	ld a,b			;2825
	rra			;2826
l2827h:
	add a,l			;2827
	jr c,l282dh		;2828
	cp h			;282a
	jr c,l2834h		;282b
l282dh:
	sub h			;282d
	ld c,a			;282e
	exx			;282f
	pop bc			;2830
	push bc			;2831
	jr l2838h		;2832
l2834h:
	ld c,a			;2834
	push de			;2835
	exx			;2836
	pop bc			;2837
l2838h:
	ld hl,(05c7dh)		;2838
	ld a,b			;283b
	add a,h			;283c
	ld b,a			;283d
	ld a,c			;283e
	inc a			;283f
	add a,l			;2840
	jr c,l2850h		;2841
	jr z,l2852h		;2843
l2845h:
	dec a			;2845
	ld c,a			;2846
	call sub_263eh		;2847
	exx			;284a
	ld a,c			;284b
	djnz l2827h		;284c
	pop de			;284e
	ret			;284f
l2850h:
	jr z,l2845h		;2850
l2852h:
	rst 8			;2852
	ld a,(bc)		;2853
sub_2854h:
	rst 18h			;2854
	ld b,000h		;2855
	push bc			;2857
l2858h:
	ld c,a			;2858
	ld hl,l294ch		;2859
	call sub_136bh		;285c
	ld a,c			;285f
	jp nc,l2a42h		;2860
	ld b,000h		;2863
	ld c,(hl)		;2865
	add hl,bc		;2866
	jp (hl)			;2867
l2868h:
	call sub_0074h		;2868
	inc bc			;286b
	cp 00dh			;286c
	jp z,l1bedh		;286e
	cp 022h			;2871
	jr nz,l2868h		;2873
	call sub_0074h		;2875
	cp 022h			;2878
	ret			;287a
sub_287bh:
	rst 20h			;287b
	cp 028h			;287c
	jr nz,l2886h		;287e
	call sub_1bdch		;2880
	rst 18h			;2883
	cp 029h			;2884
l2886h:
	jp nz,l1bedh		;2886
sub_2889h:
	bit 7,(iy+001h)		;2889
	ret			;288d
sub_288eh:
	call sub_2660h		;288e
	ld hl,(05c36h)		;2891
	ld de,l00ffh+1		;2894
	add hl,de		;2897
	ld a,c			;2898
	rrca			;2899
	rrca			;289a
	rrca			;289b
	and 0e0h		;289c
	xor b			;289e
	ld e,a			;289f
	ld a,c			;28a0
	and 018h		;28a1
	xor 040h		;28a3
	ld d,a			;28a5
	ld b,060h		;28a6
l28a8h:
	push bc			;28a8
	push de			;28a9
	push hl			;28aa
	ld a,(de)		;28ab
	xor (hl)		;28ac
	jr z,l28b3h		;28ad
	inc a			;28af
	jr nz,l28cch		;28b0
	dec a			;28b2
l28b3h:
	ld c,a			;28b3
	ld b,007h		;28b4
l28b6h:
	inc d			;28b6
	inc hl			;28b7
	ld a,(de)		;28b8
l28b9h:
	xor (hl)		;28b9
	xor c			;28ba
	jr nz,l28cch		;28bb
	djnz l28b6h		;28bd
	pop bc			;28bf
l28c0h:
	pop bc			;28c0
	pop bc			;28c1
	ld a,080h		;28c2
	sub b			;28c4
	ld bc,l0001h		;28c5
	rst 30h			;28c8
	ld (de),a		;28c9
	jr l28d6h		;28ca
l28cch:
	pop hl			;28cc
	ld de,l0008h		;28cd
	add hl,de		;28d0
	pop de			;28d1
	pop bc			;28d2
	djnz l28a8h		;28d3
	ld c,b			;28d5
l28d6h:
	ret			;28d6
sub_28d7h:
	call sub_2660h		;28d7
	ld a,c			;28da
	rrca			;28db
	rrca			;28dc
	rrca			;28dd
	ld c,a			;28de
	and 0e0h		;28df
	xor b			;28e1
	ld l,a			;28e2
	ld a,c			;28e3
	and 003h		;28e4
	xor 058h		;28e6
	ld h,a			;28e8
	ld a,(hl)		;28e9
	jp l30e6h		;28ea
	call sub_2889h		;28ed
	jr z,$+5		;28f0
	rst 28h			;28f2
	and e			;28f3
	jr c,l28b9h		;28f4
	add a,c			;28f6
	ld hl,(07bcdh)		;28f7
	jr z,l28c0h		;28fa
	ld (bc),a		;28fc
	add hl,hl		;28fd
	rst 20h			;28fe
	jp l2a81h		;28ff
	call sub_2660h		;2902
	ld a,b			;2905
	call sub_292bh		;2906
	ld a,c			;2909
	call sub_292bh		;290a
	ld d,c			;290d
	ld a,00eh		;290e
	out (0f5h),a		;2910
	ld c,0f6h		;2912
	in a,(c)		;2914
	cpl			;2916
	ld b,d			;2917
	djnz l2926h		;2918
	and 00fh		;291a
	cp 00fh			;291c
	jr c,l2922h		;291e
	and 000h		;2920
l2922h:
	call l30e6h		;2922
	ret			;2925
l2926h:
	rlca			;2926
	and 001h		;2927
	jr l2922h		;2929
sub_292bh:
	sub 002h		;292b
	adc a,000h		;292d
	jr nz,l2932h		;292f
	ret			;2931
l2932h:
	rst 8			;2932
	add hl,bc		;2933
	call sub_2889h		;2934
	jr z,l2948h		;2937
	ld hl,(05cb2h)		;2939
	ld de,(05c65h)		;293c
	and a			;2940
	sbc hl,de		;2941
	ld c,l			;2943
	ld b,h			;2944
	call sub_30e9h		;2945
l2948h:
	rst 20h			;2948
	jp l2a81h		;2949
l294ch:
	ld (l2824h),hl		;294c
	ld d,a			;294f
	ld l,0fah		;2950
	dec hl			;2952
	ld a,(de)		;2953
	ld a,h			;2954
	ld d,07eh		;2955
	ld (de),a		;2957
	xor b			;2958
	ld e,d			;2959
	and l			;295a
	ld e,e			;295b
	and a			;295c
	adc a,b			;295d
	and (hl)		;295e
	sub e			;295f
	call nz,0aaeah		;2960
	jp 0cbabh		;2963
	xor c			;2966
	jp nc,l17ffh+1		;2967
	ret			;296a
	jr $-115		;296b
	rst 20h			;296d
	jp l2858h		;296e
	rst 18h			;2971
	inc hl			;2972
	push hl			;2973
	ld bc,l0000h		;2974
	call l2868h		;2977
	jr nz,l2997h		;297a
l297ch:
	call l2868h		;297c
	jr z,l297ch		;297f
	call sub_2889h		;2981
	jr z,l2997h		;2984
	rst 30h			;2986
	pop hl			;2987
	push de			;2988
l2989h:
	ld a,(hl)		;2989
	inc hl			;298a
	ld (de),a		;298b
	inc de			;298c
	cp 022h			;298d
	jr nz,l2989h		;298f
	ld a,(hl)		;2991
	inc hl			;2992
	cp 022h			;2993
	jr z,l2989h		;2995
l2997h:
	dec bc			;2997
	pop de			;2998
l2999h:
	ld hl,05c3bh		;2999
	res 6,(hl)		;299c
	bit 7,(hl)		;299e
	call nz,sub_2e70h	;29a0
	jp l2ad0h		;29a3
	rst 20h			;29a6
	call sub_2854h		;29a7
	cp 029h			;29aa
	jp nz,l1bedh		;29ac
	rst 20h			;29af
	jp l2ad0h		;29b0
	jp 02b7bh		;29b3
	call sub_2889h		;29b6
	jr z,l29e3h		;29b9
	ld bc,(05c76h)		;29bb
	call sub_30e9h		;29bf
	rst 28h			;29c2
	and c			;29c3
	rrca			;29c4
	inc (hl)		;29c5
	scf			;29c6
	ld d,004h		;29c7
	inc (hl)		;29c9
	add a,b			;29ca
	ld b,c			;29cb
	nop			;29cc
	nop			;29cd
	add a,b			;29ce
	ld (0a102h),a		;29cf
	inc bc			;29d2
	ld sp,0cd38h		;29d3
	ld h,b			;29d6
	ld sp,043edh		;29d7
	halt			;29da
	ld e,h			;29db
	ld a,(hl)		;29dc
	and a			;29dd
	jr z,l29e3h		;29de
	sub 010h		;29e0
	ld (hl),a		;29e2
l29e3h:
	jr l29eeh		;29e3
	call sub_2889h		;29e5
	jr z,l29eeh		;29e8
	rst 28h			;29ea
	and e			;29eb
	jr c,$+54		;29ec
l29eeh:
	rst 20h			;29ee
	jp l2a81h		;29ef
	ld bc,l105ah		;29f2
	rst 20h			;29f5
	cp 023h			;29f6
	jp z,l2acbh		;29f8
	ld hl,05c3bh		;29fb
	res 6,(hl)		;29fe
	bit 7,(hl)		;2a00
	jr z,l2a23h		;2a02
	call sub_02b0h		;2a04
	ld c,000h		;2a07
	jr nz,l2a1eh		;2a09
	call sub_035ch		;2a0b
	jr nc,l2a1eh		;2a0e
	dec d			;2a10
	ld e,a			;2a11
	call sub_0371h		;2a12
	push af			;2a15
	ld bc,l0001h		;2a16
	rst 30h			;2a19
	pop af			;2a1a
	ld (de),a		;2a1b
	ld c,001h		;2a1c
l2a1eh:
	ld b,000h		;2a1e
	call sub_2e70h		;2a20
l2a23h:
	jp l2ad0h		;2a23
	call sub_287bh		;2a26
	call nz,sub_288eh	;2a29
	rst 20h			;2a2c
	jp l2999h		;2a2d
	call sub_287bh		;2a30
	call nz,sub_28d7h	;2a33
	rst 20h			;2a36
	jr l2a81h		;2a37
	call sub_287bh		;2a39
	call nz,sub_2624h	;2a3c
	rst 20h			;2a3f
	jr l2a81h		;2a40
l2a42h:
	call sub_3046h		;2a42
	jr nc,l2a9dh		;2a45
	cp 041h			;2a47
	jr nc,l2a87h		;2a49
	call sub_2889h		;2a4b
	jr nz,l2a73h		;2a4e
	call sub_3059h		;2a50
	rst 18h			;2a53
	ld bc,l0005h+1		;2a54
	call sub_12bbh		;2a57
	inc hl			;2a5a
	ld (hl),00eh		;2a5b
	inc hl			;2a5d
	ex de,hl		;2a5e
	ld hl,(05c65h)		;2a5f
	ld c,005h		;2a62
	and a			;2a64
	sbc hl,bc		;2a65
	ld (05c65h),hl		;2a67
	ldir			;2a6a
	ex de,hl		;2a6c
	dec hl			;2a6d
	call sub_0077h		;2a6e
	jr l2a81h		;2a71
l2a73h:
	rst 18h			;2a73
l2a74h:
	inc hl			;2a74
	ld a,(hl)		;2a75
	cp 00eh			;2a76
	jr nz,l2a74h		;2a78
	inc hl			;2a7a
	call sub_3773h		;2a7b
	ld (05c5dh),hl		;2a7e
l2a81h:
	set 6,(iy+001h)		;2a81
	jr l2a9bh		;2a85
l2a87h:
	call sub_2c70h		;2a87
	jp c,l1b91h		;2a8a
	call z,sub_2d54h	;2a8d
	ld a,(05c3bh)		;2a90
	cp 0c0h			;2a93
	jr c,l2a9bh		;2a95
	inc hl			;2a97
	call sub_3773h		;2a98
l2a9bh:
	jr l2ad0h		;2a9b
l2a9dh:
	ld bc,l09dbh		;2a9d
	cp 02dh			;2aa0
	jr z,l2acbh		;2aa2
	ld bc,l1018h		;2aa4
	cp 0aeh			;2aa7
	jr z,l2acbh		;2aa9
l2aabh:
	sub 0afh		;2aab
	jp c,l1bedh		;2aad
	ld bc,004f0h		;2ab0
	cp 014h			;2ab3
	jr z,l2acbh		;2ab5
	jp nc,l1bedh		;2ab7
	ld b,010h		;2aba
	add a,0dch		;2abc
	ld c,a			;2abe
	cp 0dfh			;2abf
	jr nc,l2ac5h		;2ac1
	res 6,c			;2ac3
l2ac5h:
	cp 0eeh			;2ac5
	jr c,l2acbh		;2ac7
	res 7,c			;2ac9
l2acbh:
	push bc			;2acb
	rst 20h			;2acc
	jp l2858h		;2acd
l2ad0h:
	rst 18h			;2ad0
l2ad1h:
	cp 028h			;2ad1
	jr nz,l2ae1h		;2ad3
	bit 6,(iy+001h)		;2ad5
	jr nz,l2af2h		;2ad9
	call sub_2e10h		;2adb
	rst 20h			;2ade
	jr l2ad1h		;2adf
l2ae1h:
	ld b,000h		;2ae1
	ld c,a			;2ae3
	ld hl,l2b53h		;2ae4
	call sub_136bh		;2ae7
	jr nc,l2af2h		;2aea
	ld c,(hl)		;2aec
	ld hl,l2aabh		;2aed
	add hl,bc		;2af0
	ld b,(hl)		;2af1
l2af2h:
	pop de			;2af2
	ld a,d			;2af3
	cp b			;2af4
	jr c,l2b31h		;2af5
	and a			;2af7
	jp z,l0018h		;2af8
	push bc			;2afb
	ld hl,05c3bh		;2afc
	ld a,e			;2aff
	cp 0edh			;2b00
	jr nz,l2b0ah		;2b02
	bit 6,(hl)		;2b04
	jr nz,l2b0ah		;2b06
	ld e,099h		;2b08
l2b0ah:
	push de			;2b0a
	call sub_2889h		;2b0b
	jr z,l2b19h		;2b0e
	ld a,e			;2b10
	and 03fh		;2b11
	ld b,a			;2b13
	rst 28h			;2b14
	dec sp			;2b15
	jr c,$+26		;2b16
	add hl,bc		;2b18
l2b19h:
	ld a,e			;2b19
	xor (iy+001h)		;2b1a
	and 040h		;2b1d
l2b1fh:
	jp nz,l1bedh		;2b1f
	pop de			;2b22
	ld hl,05c3bh		;2b23
	set 6,(hl)		;2b26
	bit 7,e			;2b28
	jr nz,l2b2eh		;2b2a
	res 6,(hl)		;2b2c
l2b2eh:
	pop bc			;2b2e
	jr l2af2h		;2b2f
l2b31h:
	push de			;2b31
	ld a,c			;2b32
	bit 6,(iy+001h)		;2b33
	jr nz,l2b4eh		;2b37
	and 03fh		;2b39
	add a,008h		;2b3b
	ld c,a			;2b3d
	cp 010h			;2b3e
	jr nz,l2b46h		;2b40
	set 6,c			;2b42
	jr l2b4eh		;2b44
l2b46h:
	jr c,l2b1fh		;2b46
	cp 017h			;2b48
	jr z,l2b4eh		;2b4a
	set 7,c			;2b4c
l2b4eh:
	push bc			;2b4e
	rst 20h			;2b4f
	jp l2858h		;2b50
l2b53h:
	dec hl			;2b53
	rst 8			;2b54
	dec l			;2b55
	jp 0c42ah		;2b56
	cpl			;2b59
	push bc			;2b5a
	ld e,(hl)		;2b5b
	add a,03dh		;2b5c
	adc a,03eh		;2b5e
	call z,0cd3ch		;2b60
	rst 0			;2b63
	ret			;2b64
	ret z			;2b65
	jp z,0cbc9h		;2b66
	push bc			;2b69
	rst 0			;2b6a
	add a,0c8h		;2b6b
	nop			;2b6d
	ld b,008h		;2b6e
	ex af,af'		;2b70
	ld a,(bc)		;2b71
	ld (bc),a		;2b72
	inc bc			;2b73
	dec b			;2b74
	dec b			;2b75
	dec b			;2b76
	dec b			;2b77
	dec b			;2b78
	dec b			;2b79
	ld b,0cdh		;2b7a
	adc a,c			;2b7c
	jr z,l2b9fh		;2b7d
	dec (hl)		;2b7f
	rst 20h			;2b80
	call sub_304bh		;2b81
	jp nc,l1bedh		;2b84
	rst 20h			;2b87
	cp 024h			;2b88
	push af			;2b8a
	jr nz,l2b8eh		;2b8b
	rst 20h			;2b8d
l2b8eh:
	cp 028h			;2b8e
	jr nz,l2ba4h		;2b90
	rst 20h			;2b92
	cp 029h			;2b93
	jr z,l2ba7h		;2b95
l2b97h:
	call sub_2854h		;2b97
	rst 18h			;2b9a
	cp 02ch			;2b9b
	jr nz,l2ba2h		;2b9d
l2b9fh:
	rst 20h			;2b9f
	jr l2b97h		;2ba0
l2ba2h:
	cp 029h			;2ba2
l2ba4h:
	jp nz,l1bedh		;2ba4
l2ba7h:
	rst 20h			;2ba7
	ld hl,05c3bh		;2ba8
	res 6,(hl)		;2bab
	pop af			;2bad
	jr z,l2bb2h		;2bae
	set 6,(hl)		;2bb0
l2bb2h:
	jp l2ad0h		;2bb2
	rst 20h			;2bb5
	and 0dfh		;2bb6
l2bb8h:
	ld b,a			;2bb8
	rst 20h			;2bb9
	sub 024h		;2bba
	ld c,a			;2bbc
	jr nz,l2bc0h		;2bbd
	rst 20h			;2bbf
l2bc0h:
	rst 20h			;2bc0
	push hl			;2bc1
	ld hl,(05c53h)		;2bc2
	dec hl			;2bc5
l2bc6h:
	ld de,l00ceh		;2bc6
	push bc			;2bc9
	call 01d28h		;2bca
	pop bc			;2bcd
	jr nc,$+4		;2bce
	rst 8			;2bd0
	jr l2bb8h		;2bd1
	call sub_2c69h		;2bd3
	and 0dfh		;2bd6
	cp b			;2bd8
	jr nz,l2be3h		;2bd9
	call sub_2c69h		;2bdb
	sub 024h		;2bde
	cp c			;2be0
	jr z,l2befh		;2be1
l2be3h:
	pop hl			;2be3
	dec hl			;2be4
	ld de,l0200h		;2be5
	push bc			;2be8
	call sub_16f3h		;2be9
	pop bc			;2bec
	jr l2bc6h		;2bed
l2befh:
	and a			;2bef
	call z,sub_2c69h	;2bf0
	pop de			;2bf3
	pop de			;2bf4
	ld (05c5dh),de		;2bf5
	call sub_2c69h		;2bf9
	push hl			;2bfc
	cp 029h			;2bfd
	jr z,l2c43h		;2bff
l2c01h:
	inc hl			;2c01
	ld a,(hl)		;2c02
	cp 00eh			;2c03
	ld d,040h		;2c05
	jr z,l2c10h		;2c07
	dec hl			;2c09
	call sub_2c69h		;2c0a
	inc hl			;2c0d
	ld d,000h		;2c0e
l2c10h:
	inc hl			;2c10
	push hl			;2c11
	push de			;2c12
	call sub_2854h		;2c13
	pop af			;2c16
	xor (iy+001h)		;2c17
	and 040h		;2c1a
	jr nz,l2c49h		;2c1c
	pop hl			;2c1e
	ex de,hl		;2c1f
	ld hl,(05c65h)		;2c20
	ld bc,l0005h		;2c23
	sbc hl,bc		;2c26
	ld (05c65h),hl		;2c28
	ldir			;2c2b
	ex de,hl		;2c2d
	dec hl			;2c2e
	call sub_2c69h		;2c2f
	cp 029h			;2c32
	jr z,l2c43h		;2c34
	push hl			;2c36
	rst 18h			;2c37
	cp 02ch			;2c38
	jr nz,l2c49h		;2c3a
	rst 20h			;2c3c
	pop hl			;2c3d
	call sub_2c69h		;2c3e
	jr l2c01h		;2c41
l2c43h:
	push hl			;2c43
	rst 18h			;2c44
	cp 029h			;2c45
	jr z,l2c4bh		;2c47
l2c49h:
	rst 8			;2c49
	add hl,de		;2c4a
l2c4bh:
	pop de			;2c4b
	ex de,hl		;2c4c
	ld (05c5dh),hl		;2c4d
	ld hl,(05c0bh)		;2c50
	ex (sp),hl		;2c53
	ld (05c0bh),hl		;2c54
	push de			;2c57
	rst 20h			;2c58
	rst 20h			;2c59
	call sub_2854h		;2c5a
	pop hl			;2c5d
	ld (05c5dh),hl		;2c5e
	pop hl			;2c61
	ld (05c0bh),hl		;2c62
	rst 20h			;2c65
	jp l2ad0h		;2c66
sub_2c69h:
	inc hl			;2c69
	ld a,(hl)		;2c6a
	cp 021h			;2c6b
	jr c,sub_2c69h		;2c6d
	ret			;2c6f
sub_2c70h:
	set 6,(iy+001h)		;2c70
	rst 18h			;2c74
	call sub_304bh		;2c75
	jp nc,l1bedh		;2c78
	push hl			;2c7b
	and 01fh		;2c7c
	ld c,a			;2c7e
	rst 20h			;2c7f
	push hl			;2c80
	cp 028h			;2c81
	jr z,l2cadh		;2c83
	set 6,c			;2c85
	cp 024h			;2c87
	jr z,l2c9ch		;2c89
	set 5,c			;2c8b
	call sub_3046h		;2c8d
	jr nc,l2ca1h		;2c90
l2c92h:
	call sub_3046h		;2c92
	jr nc,l2cadh		;2c95
	res 6,c			;2c97
	rst 20h			;2c99
	jr l2c92h		;2c9a
l2c9ch:
	rst 20h			;2c9c
	res 6,(iy+001h)		;2c9d
l2ca1h:
	ld a,(05c0ch)		;2ca1
	and a			;2ca4
	jr z,l2cadh		;2ca5
	call sub_2889h		;2ca7
	jp nz,l2d0fh		;2caa
l2cadh:
	ld b,c			;2cad
	call sub_2889h		;2cae
	jr nz,l2cbbh		;2cb1
	ld a,c			;2cb3
	and 0e0h		;2cb4
	set 7,a			;2cb6
	ld c,a			;2cb8
	jr l2cf2h		;2cb9
l2cbbh:
	ld hl,(05c4bh)		;2cbb
l2cbeh:
	ld a,(hl)		;2cbe
	and 07fh		;2cbf
	jr z,l2cf0h		;2cc1
	cp c			;2cc3
	jr nz,l2ce8h		;2cc4
	rla			;2cc6
	add a,a			;2cc7
	jp p,l2cfdh		;2cc8
	jr c,l2cfdh		;2ccb
	pop de			;2ccd
	push de			;2cce
	push hl			;2ccf
l2cd0h:
	inc hl			;2cd0
l2cd1h:
	ld a,(de)		;2cd1
	inc de			;2cd2
	cp 020h			;2cd3
	jr z,l2cd1h		;2cd5
	or 020h			;2cd7
	cp (hl)			;2cd9
	jr z,l2cd0h		;2cda
	or 080h			;2cdc
	cp (hl)			;2cde
	jr nz,l2ce7h		;2cdf
	ld a,(de)		;2ce1
	call sub_3046h		;2ce2
	jr nc,l2cfch		;2ce5
l2ce7h:
	pop hl			;2ce7
l2ce8h:
	push bc			;2ce8
	call sub_1720h		;2ce9
	ex de,hl		;2cec
	pop bc			;2ced
	jr l2cbeh		;2cee
l2cf0h:
	set 7,b			;2cf0
l2cf2h:
	pop de			;2cf2
	rst 18h			;2cf3
	cp 028h			;2cf4
	jr z,l2d01h		;2cf6
	set 5,b			;2cf8
	jr l2d09h		;2cfa
l2cfch:
	pop de			;2cfc
l2cfdh:
	pop de			;2cfd
	pop de			;2cfe
	push hl			;2cff
	rst 18h			;2d00
l2d01h:
	call sub_3046h		;2d01
	jr nc,l2d09h		;2d04
	rst 20h			;2d06
	jr l2d01h		;2d07
l2d09h:
	pop hl			;2d09
	rl b			;2d0a
	bit 6,b			;2d0c
	ret			;2d0e
l2d0fh:
	ld hl,(05c0bh)		;2d0f
	ld a,(hl)		;2d12
	cp 029h			;2d13
	jp z,l2cadh		;2d15
l2d18h:
	ld a,(hl)		;2d18
	or 060h			;2d19
	ld b,a			;2d1b
	inc hl			;2d1c
	ld a,(hl)		;2d1d
	cp 00eh			;2d1e
	jr z,l2d29h		;2d20
	dec hl			;2d22
	call sub_2c69h		;2d23
	inc hl			;2d26
	res 5,b			;2d27
l2d29h:
	ld a,b			;2d29
	cp c			;2d2a
	jr z,l2d3fh		;2d2b
	inc hl			;2d2d
	inc hl			;2d2e
	inc hl			;2d2f
	inc hl			;2d30
	inc hl			;2d31
	call sub_2c69h		;2d32
	cp 029h			;2d35
	jp z,l2cadh		;2d37
	call sub_2c69h		;2d3a
	jr l2d18h		;2d3d
l2d3fh:
	bit 5,c			;2d3f
	jr nz,l2d4fh		;2d41
	inc hl			;2d43
	ld de,(05c65h)		;2d44
	call sub_377fh		;2d48
	ex de,hl		;2d4b
	ld (05c65h),hl		;2d4c
l2d4fh:
	pop de			;2d4f
	pop de			;2d50
	xor a			;2d51
	inc a			;2d52
	ret			;2d53
sub_2d54h:
	xor a			;2d54
	ld b,a			;2d55
	bit 7,c			;2d56
	jr nz,l2da5h		;2d58
	bit 7,(hl)		;2d5a
	jr nz,l2d6ch		;2d5c
	inc a			;2d5e
l2d5fh:
	inc hl			;2d5f
	ld c,(hl)		;2d60
	inc hl			;2d61
	ld b,(hl)		;2d62
	inc hl			;2d63
	ex de,hl		;2d64
	call sub_2e70h		;2d65
	rst 18h			;2d68
	jp l2e07h		;2d69
l2d6ch:
	inc hl			;2d6c
	inc hl			;2d6d
	inc hl			;2d6e
	ld b,(hl)		;2d6f
	bit 6,c			;2d70
	jr z,l2d7eh		;2d72
	dec b			;2d74
	jr z,l2d5fh		;2d75
	ex de,hl		;2d77
	rst 18h			;2d78
	cp 028h			;2d79
	jr nz,l2ddeh		;2d7b
	ex de,hl		;2d7d
l2d7eh:
	ex de,hl		;2d7e
	jr l2da5h		;2d7f
l2d81h:
	push hl			;2d81
	rst 18h			;2d82
	pop hl			;2d83
	cp 02ch			;2d84
	jr z,l2da8h		;2d86
	bit 7,c			;2d88
	jr z,l2ddeh		;2d8a
	bit 6,c			;2d8c
	jr nz,l2d96h		;2d8e
	cp 029h			;2d90
	jr nz,l2dd0h		;2d92
	rst 20h			;2d94
	ret			;2d95
l2d96h:
	cp 029h			;2d96
	jr z,l2e06h		;2d98
	cp 0cch			;2d9a
	jr nz,l2dd0h		;2d9c
l2d9eh:
	rst 18h			;2d9e
	dec hl			;2d9f
	ld (05c5dh),hl		;2da0
	jr l2e03h		;2da3
l2da5h:
	ld hl,l0000h		;2da5
l2da8h:
	push hl			;2da8
	rst 20h			;2da9
	pop hl			;2daa
	ld a,c			;2dab
	cp 0c0h			;2dac
	jr nz,l2db9h		;2dae
	rst 18h			;2db0
	cp 029h			;2db1
	jr z,l2e06h		;2db3
	cp 0cch			;2db5
	jr z,l2d9eh		;2db7
l2db9h:
	push bc			;2db9
	push hl			;2dba
	call sub_2each		;2dbb
	ex (sp),hl		;2dbe
	ex de,hl		;2dbf
	call sub_2e8ah		;2dc0
	jr c,l2ddeh		;2dc3
	dec bc			;2dc5
	call sub_2eb2h		;2dc6
	add hl,bc		;2dc9
	pop de			;2dca
	pop bc			;2dcb
	djnz l2d81h		;2dcc
	bit 7,c			;2dce
l2dd0h:
	jr nz,l2e38h		;2dd0
	push hl			;2dd2
	bit 6,c			;2dd3
	jr nz,l2deah		;2dd5
	ld b,d			;2dd7
	ld c,e			;2dd8
	rst 18h			;2dd9
	cp 029h			;2dda
	jr z,l2de0h		;2ddc
l2ddeh:
	rst 8			;2dde
	ld (bc),a		;2ddf
l2de0h:
	rst 20h			;2de0
	pop hl			;2de1
	ld de,l0005h		;2de2
	call sub_2eb2h		;2de5
	add hl,bc		;2de8
	ret			;2de9
l2deah:
	call sub_2each		;2dea
	ex (sp),hl		;2ded
	call sub_2eb2h		;2dee
	pop bc			;2df1
	add hl,bc		;2df2
	inc hl			;2df3
	ld b,d			;2df4
	ld c,e			;2df5
	ex de,hl		;2df6
	call sub_2e6fh		;2df7
	rst 18h			;2dfa
	cp 029h			;2dfb
	jr z,l2e06h		;2dfd
	cp 02ch			;2dff
	jr nz,l2ddeh		;2e01
l2e03h:
	call sub_2e10h		;2e03
l2e06h:
	rst 20h			;2e06
l2e07h:
	cp 028h			;2e07
	jr z,l2e03h		;2e09
	res 6,(iy+001h)		;2e0b
	ret			;2e0f
sub_2e10h:
	call sub_2889h		;2e10
	call nz,sub_2fafh	;2e13
	rst 20h			;2e16
	cp 029h			;2e17
	jr z,l2e6bh		;2e19
	push de			;2e1b
	xor a			;2e1c
	push af			;2e1d
	push bc			;2e1e
	ld de,l0001h		;2e1f
	rst 18h			;2e22
	pop hl			;2e23
	cp 0cch			;2e24
	jr z,l2e3fh		;2e26
	pop af			;2e28
	call sub_2e8bh		;2e29
	push af			;2e2c
	ld d,b			;2e2d
	ld e,c			;2e2e
	push hl			;2e2f
	rst 18h			;2e30
	pop hl			;2e31
	cp 0cch			;2e32
	jr z,l2e3fh		;2e34
	cp 029h			;2e36
l2e38h:
	jp nz,l1bedh		;2e38
	ld h,d			;2e3b
	ld l,e			;2e3c
	jr l2e52h		;2e3d
l2e3fh:
	push hl			;2e3f
	rst 20h			;2e40
	pop hl			;2e41
	cp 029h			;2e42
	jr z,l2e52h		;2e44
	pop af			;2e46
	call sub_2e8bh		;2e47
	push af			;2e4a
	rst 18h			;2e4b
	ld h,b			;2e4c
	ld l,c			;2e4d
	cp 029h			;2e4e
	jr nz,l2e38h		;2e50
l2e52h:
	pop af			;2e52
	ex (sp),hl		;2e53
	add hl,de		;2e54
	dec hl			;2e55
	ex (sp),hl		;2e56
	and a			;2e57
	sbc hl,de		;2e58
	ld bc,l0000h		;2e5a
	jr c,l2e66h		;2e5d
	inc hl			;2e5f
	and a			;2e60
	jp m,l2ddeh		;2e61
	ld b,h			;2e64
	ld c,l			;2e65
l2e66h:
	pop de			;2e66
	res 6,(iy+001h)		;2e67
l2e6bh:
	call sub_2889h		;2e6b
	ret z			;2e6e
sub_2e6fh:
	xor a			;2e6f
sub_2e70h:
	res 6,(iy+001h)		;2e70
sub_2e74h:
	push bc			;2e74
	call sub_3768h		;2e75
	pop bc			;2e78
	ld hl,(05c65h)		;2e79
	ld (hl),a		;2e7c
	inc hl			;2e7d
	ld (hl),e		;2e7e
	inc hl			;2e7f
	ld (hl),d		;2e80
	inc hl			;2e81
	ld (hl),c		;2e82
	inc hl			;2e83
	ld (hl),b		;2e84
	inc hl			;2e85
	ld (05c65h),hl		;2e86
l2e89h:
	ret			;2e89
sub_2e8ah:
	xor a			;2e8a
sub_2e8bh:
	push de			;2e8b
	push hl			;2e8c
	push af			;2e8d
	call sub_1be5h		;2e8e
	pop af			;2e91
	call sub_2889h		;2e92
	jr z,l2ea9h		;2e95
	push af			;2e97
	call sub_1f23h		;2e98
	pop de			;2e9b
	ld a,b			;2e9c
	or c			;2e9d
	scf			;2e9e
	jr z,l2ea6h		;2e9f
	pop hl			;2ea1
	push hl			;2ea2
	and a			;2ea3
	sbc hl,bc		;2ea4
l2ea6h:
	ld a,d			;2ea6
	sbc a,000h		;2ea7
l2ea9h:
	pop hl			;2ea9
	pop de			;2eaa
	ret			;2eab
sub_2each:
	ex de,hl		;2eac
	inc hl			;2ead
	ld e,(hl)		;2eae
	inc hl			;2eaf
	ld d,(hl)		;2eb0
	ret			;2eb1
sub_2eb2h:
	call sub_2889h		;2eb2
	ret z			;2eb5
	call sub_3468h		;2eb6
	jp c,l1fcfh		;2eb9
	ret			;2ebc
l2ebdh:
	ld hl,(05c4dh)		;2ebd
	bit 1,(iy+037h)		;2ec0
	jr z,l2f24h		;2ec4
	ld bc,l0005h		;2ec6
l2ec9h:
	inc bc			;2ec9
l2ecah:
	inc hl			;2eca
	ld a,(hl)		;2ecb
	cp 020h			;2ecc
	jr z,l2ecah		;2ece
	jr nc,l2eddh		;2ed0
	cp 010h			;2ed2
	jr c,l2ee7h		;2ed4
	cp 016h			;2ed6
	jr nc,l2ee7h		;2ed8
	inc hl			;2eda
	jr l2ecah		;2edb
l2eddh:
	call sub_3046h		;2edd
	jr c,l2ec9h		;2ee0
	cp 024h			;2ee2
	jp z,l2f7eh		;2ee4
l2ee7h:
	ld a,c			;2ee7
	ld hl,(05c59h)		;2ee8
	dec hl			;2eeb
	call sub_12bbh		;2eec
	inc hl			;2eef
	inc hl			;2ef0
	ex de,hl		;2ef1
	push de			;2ef2
	ld hl,(05c4dh)		;2ef3
	dec de			;2ef6
	sub 006h		;2ef7
	ld b,a			;2ef9
	jr z,l2f0dh		;2efa
l2efch:
	inc hl			;2efc
l2efdh:
	ld a,(hl)		;2efd
	cp 021h			;2efe
	jr c,l2efch		;2f00
	or 020h			;2f02
	inc de			;2f04
	ld (de),a		;2f05
	djnz l2efch		;2f06
	or 080h			;2f08
	ld (de),a		;2f0a
	ld a,0c0h		;2f0b
l2f0dh:
	ld hl,(05c4dh)		;2f0d
	xor (hl)		;2f10
	or 020h			;2f11
	pop hl			;2f13
	call sub_2fa8h		;2f14
l2f17h:
	push hl			;2f17
	rst 28h			;2f18
	ld (bc),a		;2f19
	jr c,l2efdh		;2f1a
	ld bc,l0005h		;2f1c
	and a			;2f1f
	sbc hl,bc		;2f20
	jr l2f64h		;2f22
l2f24h:
	bit 6,(iy+001h)		;2f24
	jr z,l2f30h		;2f28
	ld de,l0005h+1		;2f2a
	add hl,de		;2f2d
	jr l2f17h		;2f2e
l2f30h:
	ld hl,(05c4dh)		;2f30
	ld bc,(05c72h)		;2f33
	bit 0,(iy+037h)		;2f37
	jr nz,l2f6dh		;2f3b
	ld a,b			;2f3d
	or c			;2f3e
	ret z			;2f3f
	push hl			;2f40
	rst 30h			;2f41
	push de			;2f42
	push bc			;2f43
	ld d,h			;2f44
	ld e,l			;2f45
	inc hl			;2f46
	ld (hl),020h		;2f47
	lddr			;2f49
	push hl			;2f4b
	call sub_2fafh		;2f4c
	pop hl			;2f4f
	ex (sp),hl		;2f50
	and a			;2f51
	sbc hl,bc		;2f52
	add hl,bc		;2f54
	jr nc,l2f59h		;2f55
	ld b,h			;2f57
	ld c,l			;2f58
l2f59h:
	ex (sp),hl		;2f59
	ex de,hl		;2f5a
	ld a,b			;2f5b
	or c			;2f5c
	jr z,l2f61h		;2f5d
	ldir			;2f5f
l2f61h:
	pop bc			;2f61
	pop de			;2f62
	pop hl			;2f63
l2f64h:
	ex de,hl		;2f64
	ld a,b			;2f65
	or c			;2f66
	ret z			;2f67
	push de			;2f68
	ldir			;2f69
	pop hl			;2f6b
	ret			;2f6c
l2f6dh:
	dec hl			;2f6d
	dec hl			;2f6e
	dec hl			;2f6f
	ld a,(hl)		;2f70
	push hl			;2f71
	push bc			;2f72
	call sub_2f84h		;2f73
	pop bc			;2f76
	pop hl			;2f77
	inc bc			;2f78
	inc bc			;2f79
	inc bc			;2f7a
	jp l1750h		;2f7b
l2f7eh:
	ld a,0dfh		;2f7e
	ld hl,(05c4dh)		;2f80
	and (hl)		;2f83
sub_2f84h:
	push af			;2f84
	call sub_2fafh		;2f85
	ex de,hl		;2f88
	add hl,bc		;2f89
	push bc			;2f8a
	dec hl			;2f8b
	ld (05c4dh),hl		;2f8c
	inc bc			;2f8f
	inc bc			;2f90
	inc bc			;2f91
	ld hl,(05c59h)		;2f92
	dec hl			;2f95
	call sub_12bbh		;2f96
	ld hl,(05c4dh)		;2f99
	pop bc			;2f9c
	push bc			;2f9d
	inc bc			;2f9e
	lddr			;2f9f
	ex de,hl		;2fa1
	inc hl			;2fa2
	pop bc			;2fa3
	ld (hl),b		;2fa4
	dec hl			;2fa5
	ld (hl),c		;2fa6
	pop af			;2fa7
sub_2fa8h:
	dec hl			;2fa8
	ld (hl),a		;2fa9
	ld hl,(05c59h)		;2faa
	dec hl			;2fad
	ret			;2fae
sub_2fafh:
	ld hl,(05c65h)		;2faf
	dec hl			;2fb2
	ld b,(hl)		;2fb3
	dec hl			;2fb4
	ld c,(hl)		;2fb5
	dec hl			;2fb6
	ld d,(hl)		;2fb7
	dec hl			;2fb8
	ld e,(hl)		;2fb9
	dec hl			;2fba
	ld a,(hl)		;2fbb
	ld (05c65h),hl		;2fbc
	ret			;2fbf
	call sub_2c70h		;2fc0
l2fc3h:
	jp nz,l1bedh		;2fc3
	call sub_2889h		;2fc6
	jr nz,l2fd3h		;2fc9
	res 6,c			;2fcb
	call sub_2d54h		;2fcd
	call 01b44h		;2fd0
l2fd3h:
	jr c,l2fddh		;2fd3
	push bc			;2fd5
	call sub_1720h		;2fd6
	call l1750h		;2fd9
	pop bc			;2fdc
l2fddh:
	set 7,c			;2fdd
	ld b,000h		;2fdf
	push bc			;2fe1
	ld hl,l0001h		;2fe2
	bit 6,c			;2fe5
	jr nz,l2febh		;2fe7
	ld l,005h		;2fe9
l2febh:
	ex de,hl		;2feb
l2fech:
	rst 20h			;2fec
	ld h,0ffh		;2fed
	call sub_2e8ah		;2fef
	jp c,l2ddeh		;2ff2
	pop hl			;2ff5
	push bc			;2ff6
	inc h			;2ff7
	push hl			;2ff8
	ld h,b			;2ff9
	ld l,c			;2ffa
	call sub_2eb2h		;2ffb
	ex de,hl		;2ffe
	rst 18h			;2fff
	cp 02ch			;3000
	jr z,l2fech		;3002
	cp 029h			;3004
	jr nz,l2fc3h		;3006
	rst 20h			;3008
	pop bc			;3009
	ld a,c			;300a
	ld l,b			;300b
	ld h,000h		;300c
	inc hl			;300e
	inc hl			;300f
	add hl,hl		;3010
	add hl,de		;3011
	jp c,l1fcfh		;3012
	push de			;3015
	push bc			;3016
	push hl			;3017
	ld b,h			;3018
	ld c,l			;3019
	ld hl,(05c59h)		;301a
	dec hl			;301d
	call sub_12bbh		;301e
	inc hl			;3021
	ld (hl),a		;3022
	pop bc			;3023
	dec bc			;3024
	dec bc			;3025
	dec bc			;3026
	inc hl			;3027
	ld (hl),c		;3028
	inc hl			;3029
	ld (hl),b		;302a
	pop bc			;302b
	ld a,b			;302c
	inc hl			;302d
	ld (hl),a		;302e
	ld h,d			;302f
l3030h:
	ld l,e			;3030
l3031h:
	dec de			;3031
	ld (hl),000h		;3032
	bit 6,c			;3034
	jr z,l303ah		;3036
	ld (hl),020h		;3038
l303ah:
	pop bc			;303a
	lddr			;303b
l303dh:
	pop bc			;303d
	ld (hl),b		;303e
	dec hl			;303f
	ld (hl),c		;3040
	dec hl			;3041
	dec a			;3042
	jr nz,l303dh		;3043
	ret			;3045
sub_3046h:
	call sub_30d9h		;3046
	ccf			;3049
	ret c			;304a
sub_304bh:
	cp 041h			;304b
	ccf			;304d
	ret nc			;304e
	cp 05bh			;304f
	ret c			;3051
	cp 061h			;3052
	ccf			;3054
	ret nc			;3055
	cp 07bh			;3056
	ret			;3058
sub_3059h:
	cp 0c4h			;3059
	jr nz,l3076h		;305b
	ld de,l0000h		;305d
l3060h:
	rst 20h			;3060
	sub 031h		;3061
	adc a,000h		;3063
	jr nz,l3071h		;3065
	ex de,hl		;3067
	ccf			;3068
	adc hl,hl		;3069
	jp c,l356ch		;306b
	ex de,hl		;306e
	jr l3060h		;306f
l3071h:
	ld b,d			;3071
	ld c,e			;3072
	jp sub_30e9h		;3073
l3076h:
	cp 02eh			;3076
l3078h:
	jr z,l3089h		;3078
	call sub_30f9h		;307a
	cp 02eh			;307d
	jr nz,l30a9h		;307f
	rst 20h			;3081
	call sub_30d9h		;3082
	jr c,l30a9h		;3085
	jr $+12			;3087
l3089h:
	rst 20h			;3089
	call sub_30d9h		;308a
l308dh:
	jp c,l1bedh		;308d
	rst 28h			;3090
	and b			;3091
	jr c,$-15		;3092
	and c			;3094
	ret nz			;3095
	ld (bc),a		;3096
	jr c,l3078h		;3097
	call sub_30e0h		;3099
	jr c,l30a9h		;309c
	rst 28h			;309e
l309fh:
	ret po			;309f
	and h			;30a0
	dec b			;30a1
	ret nz			;30a2
	inc b			;30a3
	rrca			;30a4
	jr c,$-23		;30a5
	jr $-15			;30a7
l30a9h:
	cp 045h			;30a9
	jr z,l30b0h		;30ab
	cp 065h			;30ad
	ret nz			;30af
l30b0h:
	ld b,0ffh		;30b0
	rst 20h			;30b2
	cp 02bh			;30b3
	jr z,l30bch		;30b5
	cp 02dh			;30b7
	jr nz,l30bdh		;30b9
	inc b			;30bb
l30bch:
	rst 20h			;30bc
l30bdh:
	call sub_30d9h		;30bd
	jr c,l308dh		;30c0
	push bc			;30c2
	call sub_30f9h		;30c3
	call 03193h		;30c6
	pop bc			;30c9
	jp c,l356ch		;30ca
	and a			;30cd
	jp m,l356ch		;30ce
	inc b			;30d1
	jr z,l30d6h		;30d2
	neg			;30d4
l30d6h:
	jp l310dh		;30d6
sub_30d9h:
	cp 030h			;30d9
	ret c			;30db
	cp 03ah			;30dc
	ccf			;30de
	ret			;30df
sub_30e0h:
	call sub_30d9h		;30e0
	ret c			;30e3
	sub 030h		;30e4
l30e6h:
	ld c,a			;30e6
	ld b,000h		;30e7
sub_30e9h:
	ld iy,05c3ah		;30e9
	xor a			;30ed
	ld e,a			;30ee
l30efh:
	ld d,c			;30ef
	ld c,b			;30f0
	ld b,a			;30f1
	call sub_2e74h		;30f2
	rst 28h			;30f5
	jr c,l309fh		;30f6
	ret			;30f8
sub_30f9h:
	push af			;30f9
	rst 28h			;30fa
	and b			;30fb
	jr c,l30efh		;30fc
l30feh:
	call sub_30e0h		;30fe
	ret c			;3101
sub_3102h:
	rst 28h			;3102
	ld bc,l04a4h		;3103
l3106h:
	rrca			;3106
	jr c,l30d6h		;3107
	ld (hl),h		;3109
	nop			;310a
	jr l30feh		;310b
l310dh:
	rlca			;310d
	rrca			;310e
l310fh:
	jr nc,l3113h		;310f
	cpl			;3111
	inc a			;3112
l3113h:
	push af			;3113
	ld hl,05c92h		;3114
	call sub_3926h		;3117
	rst 28h			;311a
	and h			;311b
	jr c,l310fh		;311c
l311eh:
	srl a			;311e
l3120h:
	jr nc,l312fh		;3120
	push af			;3122
	rst 28h			;3123
	pop bc			;3124
	ret po			;3125
	nop			;3126
	inc b			;3127
	inc b			;3128
l3129h:
	inc sp			;3129
	ld (bc),a		;312a
	dec b			;312b
	pop hl			;312c
	jr c,l3120h		;312d
l312fh:
	jr z,l3139h		;312f
l3131h:
	push af			;3131
	rst 28h			;3132
	ld sp,l3804h		;3133
	pop af			;3136
	jr l311eh		;3137
l3139h:
	rst 28h			;3139
	ld (bc),a		;313a
	jr c,l3106h		;313b
sub_313dh:
	inc hl			;313d
	ld c,(hl)		;313e
	inc hl			;313f
	ld a,(hl)		;3140
	xor c			;3141
	sub c			;3142
	ld e,a			;3143
	inc hl			;3144
	ld a,(hl)		;3145
	adc a,c			;3146
	xor c			;3147
	ld d,a			;3148
	ret			;3149
	ld c,000h		;314a
sub_314ch:
	push hl			;314c
	ld (hl),000h		;314d
	inc hl			;314f
	ld (hl),c		;3150
	inc hl			;3151
	ld a,e			;3152
	xor c			;3153
l3154h:
	sub c			;3154
	ld (hl),a		;3155
	inc hl			;3156
	ld a,d			;3157
	adc a,c			;3158
	xor c			;3159
	ld (hl),a		;315a
l315bh:
	inc hl			;315b
	ld (hl),000h		;315c
	pop hl			;315e
	ret			;315f
sub_3160h:
	rst 28h			;3160
l3161h:
	jr c,$+128		;3161
	and a			;3163
	jr z,$+7		;3164
	rst 28h			;3166
	and d			;3167
	rrca			;3168
	daa			;3169
	jr c,l315bh		;316a
	ld (bc),a		;316c
	jr c,l3154h		;316d
	push de			;316f
	ex de,hl		;3170
	ld b,(hl)		;3171
	call sub_313dh		;3172
	xor a			;3175
	sub b			;3176
	bit 7,c			;3177
	ld b,d			;3179
	ld c,e			;317a
	ld a,e			;317b
	pop de			;317c
	pop hl			;317d
	ret			;317e
sub_317fh:
	ld d,a			;317f
	rla			;3180
	sbc a,a			;3181
	ld e,a			;3182
	ld c,a			;3183
	xor a			;3184
	ld b,a			;3185
l3186h:
	call sub_2e74h		;3186
	rst 28h			;3189
	inc (hl)		;318a
	rst 28h			;318b
	ld a,(de)		;318c
	jr nz,l3129h		;318d
	add a,l			;318f
	inc b			;3190
	daa			;3191
	jr c,l3161h		;3192
	ld h,b			;3194
	ld sp,0f5d8h		;3195
	dec b			;3198
	inc b			;3199
	jr z,l319fh		;319a
	pop af			;319c
	scf			;319d
	ret			;319e
l319fh:
	pop af			;319f
	ret			;31a0
l31a1h:
	rst 28h			;31a1
	ld sp,00036h		;31a2
	dec bc			;31a5
	ld sp,00037h		;31a6
	dec c			;31a9
	ld (bc),a		;31aa
	jr c,$+64		;31ab
	jr nc,l3186h		;31ad
	ret			;31af
	ld hl,(l3e38h)		;31b0
	dec l			;31b3
	rst 10h			;31b4
	rst 28h			;31b5
	and b			;31b6
	jp 0c5c4h		;31b7
	ld (bc),a		;31ba
	jr c,$-37		;31bb
	push hl			;31bd
	exx			;31be
l31bfh:
	rst 28h			;31bf
	ld sp,0c227h		;31c0
	inc bc			;31c3
	jp po,0c201h		;31c4
	ld (bc),a		;31c7
	jr c,$+128		;31c8
	and a			;31ca
	jr nz,l3215h		;31cb
l31cdh:
	call sub_313dh		;31cd
	ld b,010h		;31d0
	ld a,d			;31d2
	and a			;31d3
	jr nz,l31dch		;31d4
	or e			;31d6
	jr z,l31e2h		;31d7
	ld d,e			;31d9
	ld b,008h		;31da
l31dch:
	push de			;31dc
	exx			;31dd
	pop de			;31de
	exx			;31df
	jr l323ah		;31e0
l31e2h:
	rst 28h			;31e2
	ld (bc),a		;31e3
	jp po,07e38h		;31e4
	sub 07eh		;31e7
	call sub_317fh		;31e9
	ld d,a			;31ec
	ld a,(05cach)		;31ed
	sub d			;31f0
	ld (05cach),a		;31f1
	ld a,d			;31f4
	call l310dh		;31f5
	rst 28h			;31f8
	ld sp,0c127h		;31f9
	inc bc			;31fc
	pop hl			;31fd
	jr c,l31cdh		;31fe
	sub e			;3200
	ld sp,l32e4h+1		;3201
	and c			;3204
	ld e,h			;3205
	dec a			;3206
	rla			;3207
	sbc a,a			;3208
	inc a			;3209
	ld hl,05cabh		;320a
	ld (hl),a		;320d
	inc hl			;320e
	add a,(hl)		;320f
	ld (hl),a		;3210
	pop hl			;3211
	jp 0328eh		;3212
l3215h:
	sub 080h		;3215
	cp 01ch			;3217
	jr c,l322eh		;3219
	call sub_317fh		;321b
	sub 007h		;321e
	ld b,a			;3220
	ld hl,05cach		;3221
	add a,(hl)		;3224
	ld (hl),a		;3225
	ld a,b			;3226
	neg			;3227
	call l310dh		;3229
	jr l31bfh		;322c
l322eh:
	ex de,hl		;322e
	call sub_3379h		;322f
	exx			;3232
	set 7,d			;3233
	ld a,l			;3235
	exx			;3236
	sub 080h		;3237
	ld b,a			;3239
l323ah:
	sla e			;323a
	rl d			;323c
	exx			;323e
	rl e			;323f
	rl d			;3241
	exx			;3243
	ld hl,05caah		;3244
	ld c,005h		;3247
l3249h:
	ld a,(hl)		;3249
	adc a,a			;324a
	daa			;324b
	ld (hl),a		;324c
	dec hl			;324d
	dec c			;324e
	jr nz,l3249h		;324f
	djnz l323ah		;3251
	xor a			;3253
	ld hl,05ca6h		;3254
	ld de,05ca1h		;3257
	ld b,009h		;325a
	rld			;325c
	ld c,0ffh		;325e
l3260h:
	rld			;3260
	jr nz,l3268h		;3262
	dec c			;3264
	inc c			;3265
	jr nz,l3272h		;3266
l3268h:
	ld (de),a		;3268
	inc de			;3269
	inc (iy+071h)		;326a
	inc (iy+072h)		;326d
	ld c,000h		;3270
l3272h:
	bit 0,b			;3272
	jr z,l3277h		;3274
	inc hl			;3276
l3277h:
	djnz l3260h		;3277
	ld a,(05cabh)		;3279
	sub 009h		;327c
	jr c,l328ah		;327e
	dec (iy+071h)		;3280
	ld a,004h		;3283
	cp (iy+06fh)		;3285
	jr l32cbh		;3288
l328ah:
	rst 28h			;328a
	ld (bc),a		;328b
	jp po,0eb38h		;328c
	call sub_3379h		;328f
	exx			;3292
	ld a,080h		;3293
	sub l			;3295
	ld l,000h		;3296
	set 7,d			;3298
	exx			;329a
	call sub_339ch		;329b
l329eh:
	ld a,(iy+071h)		;329e
	cp 008h			;32a1
	jr c,l32abh		;32a3
	exx			;32a5
	rl d			;32a6
	exx			;32a8
	jr l32cbh		;32a9
l32abh:
	ld bc,l0200h		;32ab
l32aeh:
	ld a,e			;32ae
	call sub_334ah		;32af
	ld e,a			;32b2
	ld a,d			;32b3
	call sub_334ah		;32b4
	ld d,a			;32b7
	push bc			;32b8
	exx			;32b9
	pop bc			;32ba
	djnz l32aeh		;32bb
	ld hl,05ca1h		;32bd
	ld a,c			;32c0
	ld c,(iy+071h)		;32c1
	add hl,bc		;32c4
	ld (hl),a		;32c5
	inc (iy+071h)		;32c6
	jr l329eh		;32c9
l32cbh:
	push af			;32cb
l32cch:
	ld hl,05ca1h		;32cc
	ld c,(iy+071h)		;32cf
	ld b,000h		;32d2
	add hl,bc		;32d4
	ld b,c			;32d5
	pop af			;32d6
l32d7h:
	dec hl			;32d7
	ld a,(hl)		;32d8
	adc a,000h		;32d9
	ld (hl),a		;32db
	and a			;32dc
	jr z,l32e4h		;32dd
	cp 00ah			;32df
	ccf			;32e1
	jr nc,l32ech		;32e2
l32e4h:
	djnz l32d7h		;32e4
	ld (hl),001h		;32e6
	inc b			;32e8
	inc (iy+072h)		;32e9
l32ech:
	ld (iy+071h),b		;32ec
	rst 28h			;32ef
	ld (bc),a		;32f0
	jr c,l32cch		;32f1
	pop hl			;32f3
	exx			;32f4
	ld bc,(05cabh)		;32f5
	ld hl,05ca1h		;32f9
	ld a,b			;32fc
	cp 009h			;32fd
	jr c,l3305h		;32ff
	cp 0fch			;3301
	jr c,l332bh		;3303
l3305h:
	and a			;3305
	call z,sub_11eah	;3306
sub_3309h:
	xor a			;3309
	sub b			;330a
	jp m,l3311h		;330b
	ld b,a			;330e
	jr l331dh		;330f
l3311h:
	ld a,c			;3311
	and a			;3312
	jr z,l3318h		;3313
	ld a,(hl)		;3315
	inc hl			;3316
	dec c			;3317
l3318h:
	call sub_11eah		;3318
	djnz l3311h		;331b
l331dh:
	ld a,c			;331d
	and a			;331e
	ret z			;331f
	inc b			;3320
	ld a,02eh		;3321
l3323h:
	rst 10h			;3323
	ld a,030h		;3324
	djnz l3323h		;3326
	ld b,c			;3328
	jr l3311h		;3329
l332bh:
	ld d,b			;332b
	dec d			;332c
	ld b,001h		;332d
	call sub_3309h		;332f
	ld a,045h		;3332
	rst 10h			;3334
	ld c,d			;3335
	ld a,c			;3336
	and a			;3337
	jp p,l3342h		;3338
	neg			;333b
	ld c,a			;333d
	ld a,02dh		;333e
	jr l3344h		;3340
l3342h:
	ld a,02bh		;3342
l3344h:
	rst 10h			;3344
	ld b,000h		;3345
	jp sub_1788h		;3347
sub_334ah:
	push de			;334a
	ld l,a			;334b
	ld h,000h		;334c
	ld e,l			;334e
	ld d,h			;334f
	add hl,hl		;3350
	add hl,hl		;3351
	add hl,de		;3352
	add hl,hl		;3353
	ld e,c			;3354
	add hl,de		;3355
	ld c,h			;3356
	ld a,l			;3357
	pop de			;3358
	ret			;3359
sub_335ah:
	ld a,(hl)		;335a
	ld (hl),000h		;335b
	and a			;335d
	ret z			;335e
	inc hl			;335f
	bit 7,(hl)		;3360
	set 7,(hl)		;3362
	dec hl			;3364
	ret z			;3365
	push bc			;3366
	ld bc,l0005h		;3367
	add hl,bc		;336a
	ld b,c			;336b
	ld c,a			;336c
	scf			;336d
l336eh:
	dec hl			;336e
	ld a,(hl)		;336f
	cpl			;3370
	adc a,000h		;3371
	ld (hl),a		;3373
	djnz l336eh		;3374
	ld a,c			;3376
	pop bc			;3377
	ret			;3378
sub_3379h:
	push hl			;3379
	push af			;337a
	ld c,(hl)		;337b
	inc hl			;337c
	ld b,(hl)		;337d
	ld (hl),a		;337e
	inc hl			;337f
	ld a,c			;3380
	ld c,(hl)		;3381
	push bc			;3382
	inc hl			;3383
	ld c,(hl)		;3384
	inc hl			;3385
	ld b,(hl)		;3386
	ex de,hl		;3387
	ld d,a			;3388
	ld e,(hl)		;3389
	push de			;338a
	inc hl			;338b
	ld d,(hl)		;338c
	inc hl			;338d
	ld e,(hl)		;338e
	push de			;338f
	exx			;3390
	pop de			;3391
	pop hl			;3392
	pop bc			;3393
	exx			;3394
	inc hl			;3395
	ld d,(hl)		;3396
	inc hl			;3397
	ld e,(hl)		;3398
	pop af			;3399
	pop hl			;339a
	ret			;339b
sub_339ch:
	and a			;339c
	ret z			;339d
	cp 021h			;339e
	jr nc,l33b8h		;33a0
	push bc			;33a2
	ld b,a			;33a3
l33a4h:
	exx			;33a4
	sra l			;33a5
	rr d			;33a7
	rr e			;33a9
	exx			;33ab
	rr d			;33ac
	rr e			;33ae
	djnz l33a4h		;33b0
	pop bc			;33b2
	ret nc			;33b3
	call sub_33c3h		;33b4
	ret nz			;33b7
l33b8h:
	exx			;33b8
	xor a			;33b9
sub_33bah:
	ld l,000h		;33ba
	ld d,a			;33bc
	ld e,l			;33bd
	exx			;33be
	ld de,l0000h		;33bf
	ret			;33c2
sub_33c3h:
	inc e			;33c3
	ret nz			;33c4
	inc d			;33c5
	ret nz			;33c6
	exx			;33c7
	inc e			;33c8
	jr nz,l33cch		;33c9
	inc d			;33cb
l33cch:
	exx			;33cc
	ret			;33cd
sub_33ceh:
	ex de,hl		;33ce
	call sub_382dh		;33cf
	ex de,hl		;33d2
	ld a,(de)		;33d3
	or (hl)			;33d4
	jr nz,l33fdh		;33d5
	push de			;33d7
	inc hl			;33d8
	push hl			;33d9
	inc hl			;33da
	ld e,(hl)		;33db
	inc hl			;33dc
	ld d,(hl)		;33dd
	inc hl			;33de
	inc hl			;33df
	inc hl			;33e0
	ld a,(hl)		;33e1
	inc hl			;33e2
	ld c,(hl)		;33e3
	inc hl			;33e4
	ld b,(hl)		;33e5
	pop hl			;33e6
	ex de,hl		;33e7
	add hl,bc		;33e8
	ex de,hl		;33e9
	adc a,(hl)		;33ea
	rrca			;33eb
	adc a,000h		;33ec
	jr nz,l33fbh		;33ee
	sbc a,a			;33f0
	ld (hl),a		;33f1
	inc hl			;33f2
	ld (hl),e		;33f3
	inc hl			;33f4
	ld (hl),d		;33f5
	dec hl			;33f6
	dec hl			;33f7
	dec hl			;33f8
	pop de			;33f9
	ret			;33fa
l33fbh:
	dec hl			;33fb
	pop de			;33fc
l33fdh:
	call sub_3652h		;33fd
	exx			;3400
	push hl			;3401
	exx			;3402
	push de			;3403
	push hl			;3404
l3405h:
	call sub_335ah		;3405
	ld b,a			;3408
	ex de,hl		;3409
	call sub_335ah		;340a
	ld c,a			;340d
	cp b			;340e
	jr nc,l3414h		;340f
	ld a,b			;3411
	ld b,c			;3412
	ex de,hl		;3413
l3414h:
	push af			;3414
	sub b			;3415
	call sub_3379h		;3416
	call sub_339ch		;3419
	pop af			;341c
	pop hl			;341d
	ld (hl),a		;341e
	push hl			;341f
	ld l,b			;3420
	ld h,c			;3421
	add hl,de		;3422
	exx			;3423
	ex de,hl		;3424
	adc hl,bc		;3425
	ex de,hl		;3427
l3428h:
	ld a,h			;3428
	adc a,l			;3429
	ld l,a			;342a
	rra			;342b
	xor l			;342c
	exx			;342d
	ex de,hl		;342e
	pop hl			;342f
	rra			;3430
l3431h:
	jr nc,l343bh		;3431
	ld a,001h		;3433
	call sub_339ch		;3435
l3438h:
	inc (hl)		;3438
	jr z,l345eh		;3439
l343bh:
	exx			;343b
	ld a,l			;343c
	and 080h		;343d
	exx			;343f
	inc hl			;3440
	ld (hl),a		;3441
	dec hl			;3442
	jr z,l3464h		;3443
	ld a,e			;3445
	neg			;3446
	ccf			;3448
	ld e,a			;3449
	ld a,d			;344a
	cpl			;344b
	adc a,000h		;344c
	ld d,a			;344e
	exx			;344f
	ld a,e			;3450
	cpl			;3451
	adc a,000h		;3452
	ld e,a			;3454
	ld a,d			;3455
	cpl			;3456
	adc a,000h		;3457
	jr nc,l3462h		;3459
	rra			;345b
	exx			;345c
	inc (hl)		;345d
l345eh:
	jp z,l356ch		;345e
	exx			;3461
l3462h:
	ld d,a			;3462
	exx			;3463
l3464h:
	xor a			;3464
	jp l3514h		;3465
sub_3468h:
	push bc			;3468
	ld b,010h		;3469
	ld a,h			;346b
	ld c,l			;346c
	ld hl,l0000h		;346d
l3470h:
	add hl,hl		;3470
	jr c,l347dh		;3471
	rl c			;3473
	rla			;3475
	jr nc,l347bh		;3476
	add hl,de		;3478
	jr c,l347dh		;3479
l347bh:
	djnz l3470h		;347b
l347dh:
	pop bc			;347d
	ret			;347e
sub_347fh:
	call sub_3904h		;347f
	ret c			;3482
	inc hl			;3483
	xor (hl)		;3484
	set 7,(hl)		;3485
	dec hl			;3487
	ret			;3488
	ld a,(de)		;3489
	or (hl)			;348a
	jr nz,l34afh		;348b
	push de			;348d
	push hl			;348e
	push de			;348f
	call sub_313dh		;3490
	ex de,hl		;3493
	ex (sp),hl		;3494
	ld b,c			;3495
	call sub_313dh		;3496
	ld a,b			;3499
	xor c			;349a
	ld c,a			;349b
	pop hl			;349c
	call sub_3468h		;349d
	ex de,hl		;34a0
	pop hl			;34a1
	jr c,l34aeh		;34a2
	ld a,d			;34a4
	or e			;34a5
	jr nz,l34a9h		;34a6
	ld c,a			;34a8
l34a9h:
	call sub_314ch		;34a9
	pop de			;34ac
	ret			;34ad
l34aeh:
	pop de			;34ae
l34afh:
	call sub_3652h		;34af
	xor a			;34b2
	call sub_347fh		;34b3
	ret c			;34b6
	exx			;34b7
	push hl			;34b8
	exx			;34b9
	push de			;34ba
	ex de,hl		;34bb
	call sub_347fh		;34bc
	ex de,hl		;34bf
	jr c,l351ch		;34c0
	push hl			;34c2
	call sub_3379h		;34c3
	ld a,b			;34c6
	and a			;34c7
	sbc hl,hl		;34c8
	exx			;34ca
	push hl			;34cb
	sbc hl,hl		;34cc
	exx			;34ce
	ld b,021h		;34cf
	jr l34e4h		;34d1
l34d3h:
	jr nc,l34dah		;34d3
	add hl,de		;34d5
	exx			;34d6
	adc hl,de		;34d7
	exx			;34d9
l34dah:
	exx			;34da
	rr h			;34db
	rr l			;34dd
	exx			;34df
	rr h			;34e0
	rr l			;34e2
l34e4h:
	exx			;34e4
	rr b			;34e5
	rr c			;34e7
	exx			;34e9
	rr c			;34ea
	rra			;34ec
	djnz l34d3h		;34ed
	ex de,hl		;34ef
	exx			;34f0
	ex de,hl		;34f1
	exx			;34f2
	pop bc			;34f3
	pop hl			;34f4
	ld a,b			;34f5
	add a,c			;34f6
	jr nz,l34fah		;34f7
	and a			;34f9
l34fah:
	dec a			;34fa
	ccf			;34fb
l34fch:
	rla			;34fc
	ccf			;34fd
	rra			;34fe
	jp p,l3505h		;34ff
	jr nc,l356ch		;3502
	and a			;3504
l3505h:
	inc a			;3505
	jr nz,l3510h		;3506
	jr c,l3510h		;3508
	exx			;350a
	bit 7,d			;350b
	exx			;350d
	jr nz,l356ch		;350e
l3510h:
	ld (hl),a		;3510
	exx			;3511
	ld a,b			;3512
	exx			;3513
l3514h:
	jr nc,l352bh		;3514
	ld a,(hl)		;3516
	and a			;3517
l3518h:
	ld a,080h		;3518
	jr z,l351dh		;351a
l351ch:
	xor a			;351c
l351dh:
	exx			;351d
	and d			;351e
	call sub_33bah		;351f
	rlca			;3522
	ld (hl),a		;3523
	jr c,l3554h		;3524
	inc hl			;3526
	ld (hl),a		;3527
	dec hl			;3528
	jr l3554h		;3529
l352bh:
	ld b,020h		;352b
l352dh:
	exx			;352d
	bit 7,d			;352e
	exx			;3530
	jr nz,l3545h		;3531
	rlca			;3533
	rl e			;3534
	rl d			;3536
	exx			;3538
	rl e			;3539
	rl d			;353b
	exx			;353d
	dec (hl)		;353e
	jr z,l3518h		;353f
	djnz l352dh		;3541
	jr l351ch		;3543
l3545h:
	rla			;3545
	jr nc,l3554h		;3546
	call sub_33c3h		;3548
	jr nz,l3554h		;354b
	exx			;354d
	ld d,080h		;354e
	exx			;3550
	inc (hl)		;3551
	jr z,l356ch		;3552
l3554h:
	push hl			;3554
	inc hl			;3555
	exx			;3556
	push de			;3557
	exx			;3558
	pop bc			;3559
	ld a,b			;355a
	rla			;355b
	rl (hl)			;355c
	rra			;355e
	ld (hl),a		;355f
	inc hl			;3560
	ld (hl),c		;3561
	inc hl			;3562
	ld (hl),d		;3563
	inc hl			;3564
	ld (hl),e		;3565
	pop hl			;3566
	pop de			;3567
	exx			;3568
	pop hl			;3569
	exx			;356a
	ret			;356b
l356ch:
	rst 8			;356c
	dec b			;356d
	call sub_3652h		;356e
	ex de,hl		;3571
	xor a			;3572
	call sub_347fh		;3573
	jr c,l356ch		;3576
	ex de,hl		;3578
	call sub_347fh		;3579
	ret c			;357c
	exx			;357d
	push hl			;357e
	exx			;357f
	push de			;3580
	push hl			;3581
	call sub_3379h		;3582
	exx			;3585
	push hl			;3586
	ld h,b			;3587
	ld l,c			;3588
	exx			;3589
	ld h,c			;358a
	ld l,b			;358b
	xor a			;358c
	ld b,0dfh		;358d
	jr l35a1h		;358f
l3591h:
	rla			;3591
	rl c			;3592
	exx			;3594
	rl c			;3595
	rl b			;3597
	exx			;3599
l359ah:
	add hl,hl		;359a
	exx			;359b
	adc hl,hl		;359c
	exx			;359e
	jr c,l35b1h		;359f
l35a1h:
	sbc hl,de		;35a1
	exx			;35a3
	sbc hl,de		;35a4
	exx			;35a6
	jr nc,l35b8h		;35a7
	add hl,de		;35a9
	exx			;35aa
	adc hl,de		;35ab
	exx			;35ad
	and a			;35ae
	jr l35b9h		;35af
l35b1h:
	and a			;35b1
	sbc hl,de		;35b2
	exx			;35b4
	sbc hl,de		;35b5
	exx			;35b7
l35b8h:
	scf			;35b8
l35b9h:
	inc b			;35b9
	jp m,l3591h		;35ba
	push af			;35bd
	jr z,l359ah		;35be
	ld e,a			;35c0
	ld d,c			;35c1
	exx			;35c2
	ld e,c			;35c3
	ld d,b			;35c4
	pop af			;35c5
	rr b			;35c6
	pop af			;35c8
	rr b			;35c9
	exx			;35cb
	pop bc			;35cc
	pop hl			;35cd
	ld a,b			;35ce
	sub c			;35cf
	jp l34fch		;35d0
	ld a,(hl)		;35d3
	and a			;35d4
	ret z			;35d5
	cp 081h			;35d6
	jr nc,l35e0h		;35d8
	ld (hl),000h		;35da
	ld a,020h		;35dc
	jr l3631h		;35de
l35e0h:
	cp 091h			;35e0
	jr nz,l35feh		;35e2
	inc hl			;35e4
	inc hl			;35e5
	inc hl			;35e6
	ld a,080h		;35e7
	and (hl)		;35e9
	dec hl			;35ea
	or (hl)			;35eb
	dec hl			;35ec
	jr nz,l35f2h		;35ed
	ld a,080h		;35ef
	xor (hl)		;35f1
l35f2h:
	dec hl			;35f2
	jr nz,l362bh		;35f3
	ld (hl),a		;35f5
	inc hl			;35f6
	ld (hl),0ffh		;35f7
	dec hl			;35f9
	ld a,018h		;35fa
	jr l3631h		;35fc
l35feh:
	jr nc,l362ch		;35fe
	push de			;3600
	cpl			;3601
	add a,091h		;3602
	inc hl			;3604
	ld d,(hl)		;3605
	inc hl			;3606
	ld e,(hl)		;3607
	dec hl			;3608
	dec hl			;3609
	ld c,000h		;360a
	bit 7,d			;360c
	jr z,l3611h		;360e
	dec c			;3610
l3611h:
	set 7,d			;3611
	ld b,008h		;3613
	sub b			;3615
	add a,b			;3616
	jr c,l361dh		;3617
	ld e,d			;3619
	ld d,000h		;361a
	sub b			;361c
l361dh:
	jr z,l3626h		;361d
	ld b,a			;361f
l3620h:
	srl d			;3620
	rr e			;3622
	djnz l3620h		;3624
l3626h:
	call sub_314ch		;3626
	pop de			;3629
	ret			;362a
l362bh:
	ld a,(hl)		;362b
l362ch:
	sub 0a0h		;362c
	ret p			;362e
	neg			;362f
l3631h:
	push de			;3631
	ex de,hl		;3632
	dec hl			;3633
	ld b,a			;3634
	srl b			;3635
	srl b			;3637
	srl b			;3639
	jr z,l3642h		;363b
l363dh:
	ld (hl),000h		;363d
	dec hl			;363f
	djnz l363dh		;3640
l3642h:
	and 007h		;3642
	jr z,l364fh		;3644
	ld b,a			;3646
	ld a,0ffh		;3647
l3649h:
	sla a			;3649
	djnz l3649h		;364b
	and (hl)		;364d
	ld (hl),a		;364e
l364fh:
	ex de,hl		;364f
	pop de			;3650
	ret			;3651
sub_3652h:
	call sub_3655h		;3652
sub_3655h:
	ex de,hl		;3655
l3656h:
	ld a,(hl)		;3656
	and a			;3657
	ret nz			;3658
	push de			;3659
	call sub_313dh		;365a
	xor a			;365d
	inc hl			;365e
	ld (hl),a		;365f
	dec hl			;3660
	ld (hl),a		;3661
	ld b,091h		;3662
	ld a,d			;3664
	and a			;3665
	jr nz,l3670h		;3666
	or e			;3668
	ld b,d			;3669
	jr z,l367ch		;366a
	ld d,e			;366c
	ld e,b			;366d
	ld b,089h		;366e
l3670h:
	ex de,hl		;3670
l3671h:
	dec b			;3671
	add hl,hl		;3672
	jr nc,l3671h		;3673
	rrc c			;3675
	rr h			;3677
	rr l			;3679
	ex de,hl		;367b
l367ch:
	dec hl			;367c
	ld (hl),e		;367d
	dec hl			;367e
	ld (hl),d		;367f
	dec hl			;3680
	ld (hl),b		;3681
	pop de			;3682
	ret			;3683
l3684h:
	nop			;3684
	or b			;3685
	nop			;3686
	ld b,b			;3687
	or b			;3688
	nop			;3689
	ld bc,l0030h		;368a
	pop af			;368d
	ld c,c			;368e
	rrca			;368f
	jp c,040a2h		;3690
	or b			;3693
	nop			;3694
	ld a,(bc)		;3695
l3696h:
	xor d			;3696
	ld a,(l37fbh)		;3697
	ld h,b			;369a
	scf			;369b
	adc a,033h		;369c
	adc a,c			;369e
	inc (hl)		;369f
	ld l,(hl)		;36a0
	dec (hl)		;36a1
	ld l,h			;36a2
	inc a			;36a3
	ld (hl),039h		;36a4
	ccf			;36a6
	add hl,sp		;36a7
	ld d,(hl)		;36a8
	add hl,sp		;36a9
	ld d,(hl)		;36aa
	add hl,sp		;36ab
	ld d,(hl)		;36ac
	add hl,sp		;36ad
	ld d,(hl)		;36ae
	add hl,sp		;36af
	ld d,(hl)		;36b0
	add hl,sp		;36b1
	ld d,(hl)		;36b2
	add hl,sp		;36b3
	out (033h),a		;36b4
	ld c,b			;36b6
	add hl,sp		;36b7
	ld d,(hl)		;36b8
	add hl,sp		;36b9
	ld d,(hl)		;36ba
	add hl,sp		;36bb
	ld d,(hl)		;36bc
	add hl,sp		;36bd
	ld d,(hl)		;36be
	add hl,sp		;36bf
	ld d,(hl)		;36c0
	add hl,sp		;36c1
	ld d,(hl)		;36c2
	add hl,sp		;36c3
	or a			;36c4
	add hl,sp		;36c5
	ld sp,hl		;36c6
	add hl,sp		;36c7
	rst 10h			;36c8
	jr c,l372bh		;36c9
	ld a,(sub_382dh)	;36cb
	add a,h			;36ce
	ld a,(l39f9h)		;36cf
	adc a,a			;36d2
	ld a,(l3bd0h)		;36d3
	push bc			;36d6
	dec sp			;36d7
	push af			;36d8
	dec sp			;36d9
	ld c,(hl)		;36da
	inc a			;36db
	ld e,(hl)		;36dc
	inc a			;36dd
	defb 0fdh,03bh,02eh ;illegal sequence	;36de
	dec sp			;36e1
	rst 18h			;36e2
	ld a,(l3acah)		;36e3
	ld h,l			;36e6
	inc a			;36e7
	ld d,c			;36e8
	jr c,$+43		;36e9
	jr c,$+109		;36eb
	jr c,l3753h		;36ed
l36efh:
	jr c,$+116		;36ef
	jr c,l372dh		;36f1
	ld a,(l39e4h)		;36f3
	inc e			;36f6
	add hl,sp		;36f7
	ld a,a			;36f8
	scf			;36f9
	cp e			;36fa
	ld a,(l3aa1h)		;36fb
	add a,l			;36fe
	scf			;36ff
	sub l			;3700
	ld a,(l3921h)		;3701
	inc d			;3704
	add hl,sp		;3705
	or (hl)			;3706
	ld a,(l3b9eh)		;3707
	out (035h),a		;370a
	ld h,c			;370c
	scf			;370d
	dec c			;370e
	ld sp,l3656h		;370f
	ex af,af'		;3712
	jr c,l36efh		;3713
	scf			;3715
	call pe,0ce37h		;3716
	scf			;3719
l371ah:
	call sub_39dah		;371a
sub_371dh:
	ld a,b			;371d
	ld (05c67h),a		;371e
sub_3721h:
	exx			;3721
	ex (sp),hl		;3722
	exx			;3723
l3724h:
	ld (05c65h),de		;3724
	exx			;3728
	ld a,(hl)		;3729
	inc hl			;372a
l372bh:
	push hl			;372b
	and a			;372c
l372dh:
	jp p,l373fh		;372d
	ld d,a			;3730
	and 060h		;3731
	rrca			;3733
	rrca			;3734
	rrca			;3735
	rrca			;3736
	add a,07ch		;3737
	ld l,a			;3739
	ld a,d			;373a
	and 01fh		;373b
	jr l374dh		;373d
l373fh:
	cp 018h			;373f
	jr nc,l374bh		;3741
	exx			;3743
	ld bc,0fffbh		;3744
	ld d,h			;3747
	ld e,l			;3748
	add hl,bc		;3749
	exx			;374a
l374bh:
	rlca			;374b
	ld l,a			;374c
l374dh:
	ld de,l3696h		;374d
	ld h,000h		;3750
	add hl,de		;3752
l3753h:
	ld e,(hl)		;3753
	inc hl			;3754
	ld d,(hl)		;3755
	ld hl,l3724h		;3756
	ex (sp),hl		;3759
	push de			;375a
	exx			;375b
	ld bc,(05c66h)		;375c
	ret			;3760
	pop af			;3761
	ld a,(05c67h)		;3762
	exx			;3765
	jr l372bh		;3766
sub_3768h:
	push de			;3768
	push hl			;3769
	ld bc,l0005h		;376a
	call sub_1fbbh		;376d
	pop hl			;3770
	pop de			;3771
	ret			;3772
sub_3773h:
	ld de,(05c65h)		;3773
	call sub_377fh		;3777
	ld (05c65h),de		;377a
	ret			;377e
sub_377fh:
	call sub_3768h		;377f
	ldir			;3782
	ret			;3784
	ld h,d			;3785
	ld l,e			;3786
sub_3787h:
	call sub_3768h		;3787
	exx			;378a
	push hl			;378b
	exx			;378c
	ex (sp),hl		;378d
	push bc			;378e
	ld a,(hl)		;378f
	and 0c0h		;3790
	rlca			;3792
	rlca			;3793
	ld c,a			;3794
	inc c			;3795
	ld a,(hl)		;3796
	and 03fh		;3797
	jr nz,l379dh		;3799
	inc hl			;379b
	ld a,(hl)		;379c
l379dh:
	add a,050h		;379d
	ld (de),a		;379f
	ld a,005h		;37a0
	sub c			;37a2
	inc hl			;37a3
	inc de			;37a4
	ld b,000h		;37a5
	ldir			;37a7
	pop bc			;37a9
	ex (sp),hl		;37aa
	exx			;37ab
	pop hl			;37ac
	exx			;37ad
	ld b,a			;37ae
	xor a			;37af
l37b0h:
	dec b			;37b0
	ret z			;37b1
	ld (de),a		;37b2
	inc de			;37b3
	jr l37b0h		;37b4
sub_37b6h:
	and a			;37b6
l37b7h:
	ret z			;37b7
	push af			;37b8
	push de			;37b9
	ld de,l0000h		;37ba
	call sub_3787h		;37bd
	pop de			;37c0
	pop af			;37c1
	dec a			;37c2
	jr l37b7h		;37c3
sub_37c5h:
	ld c,a			;37c5
	rlca			;37c6
	rlca			;37c7
	add a,c			;37c8
	ld c,a			;37c9
	ld b,000h		;37ca
	add hl,bc		;37cc
	ret			;37cd
	push de			;37ce
	ld hl,(05c68h)		;37cf
	call sub_37c5h		;37d2
	call sub_377fh		;37d5
	pop hl			;37d8
	ret			;37d9
	ld h,d			;37da
	ld l,e			;37db
	exx			;37dc
	push hl			;37dd
	ld hl,l3684h		;37de
	exx			;37e1
	call sub_37b6h		;37e2
	call sub_3787h		;37e5
	exx			;37e8
	pop hl			;37e9
	exx			;37ea
	ret			;37eb
	push hl			;37ec
	ex de,hl		;37ed
	ld hl,(05c68h)		;37ee
	call sub_37c5h		;37f1
	ex de,hl		;37f4
	call sub_377fh		;37f5
	ex de,hl		;37f8
	pop hl			;37f9
	ret			;37fa
l37fbh:
	ld b,005h		;37fb
l37fdh:
	ld a,(de)		;37fd
	ld c,(hl)		;37fe
	ex de,hl		;37ff
	ld (de),a		;3800
	ld (hl),c		;3801
l3802h:
	inc hl			;3802
	inc de			;3803
l3804h:
	djnz l37fdh		;3804
	ex de,hl		;3806
	ret			;3807
	ld b,a			;3808
	call sub_371dh		;3809
	ld sp,0c00fh		;380c
l380fh:
	ld (bc),a		;380f
	and b			;3810
	jp nz,0e031h		;3811
	inc b			;3814
	jp po,l03c0h+1		;3815
	jr c,$-49		;3818
	add a,l			;381a
	scf			;381b
	call sub_3721h		;381c
	rrca			;381f
	ld bc,l02c2h		;3820
	dec (hl)		;3823
	xor 0e1h		;3824
	inc bc			;3826
	jr c,$-53		;3827
	ld b,0ffh		;3829
	jr l3833h		;382b
sub_382dh:
	call sub_3904h		;382d
	ret c			;3830
	ld b,000h		;3831
l3833h:
	ld a,(hl)		;3833
	and a			;3834
	jr z,l3842h		;3835
	inc hl			;3837
	ld a,b			;3838
	and 080h		;3839
	or (hl)			;383b
	rla			;383c
l383dh:
	ccf			;383d
	rra			;383e
	ld (hl),a		;383f
	dec hl			;3840
	ret			;3841
l3842h:
	push de			;3842
	push hl			;3843
	call sub_313dh		;3844
	pop hl			;3847
	ld a,b			;3848
	or c			;3849
	cpl			;384a
	ld c,a			;384b
	call sub_314ch		;384c
	pop de			;384f
	ret			;3850
	call sub_3904h		;3851
	ret c			;3854
	push de			;3855
	ld de,l0001h		;3856
	inc hl			;3859
	rl (hl)			;385a
	dec hl			;385c
	sbc a,a			;385d
	ld c,a			;385e
	call sub_314ch		;385f
	pop de			;3862
	ret			;3863
	call sub_1f23h		;3864
	in a,(c)		;3867
	jr l386fh		;3869
	call sub_1f23h		;386b
	ld a,(bc)		;386e
l386fh:
	jp l30e6h		;386f
	call sub_1f23h		;3872
	call sub_388eh		;3875
	ld hl,l3882h		;3878
	push hl			;387b
	ld hl,sub_30e9h		;387c
	push hl			;387f
	push bc			;3880
	ret			;3881
l3882h:
	pop af			;3882
	inc a			;3883
	ret z			;3884
	push bc			;3885
	ld bc,0ff00h		;3886
	call 06499h		;3889
	pop bc			;388c
	ret			;388d
sub_388eh:
	ld hl,(05cbch)		;388e
	inc hl			;3891
	ld a,(hl)		;3892
	cp 002h			;3893
	jr nz,l38c5h		;3895
	inc hl			;3897
	inc hl			;3898
	inc hl			;3899
	ld a,b			;389a
	bit 7,a			;389b
	jr z,l38c5h		;389d
	and 006h		;389f
	jr z,l38beh		;38a1
	sub 004h		;38a3
	jp m,l38b7h		;38a5
	jr z,l38b0h		;38a8
	ld a,(hl)		;38aa
	jp m,l38c5h		;38ab
	jr l38cbh		;38ae
l38b0h:
	ld a,(hl)		;38b0
	bit 6,a			;38b1
	jr z,l38cbh		;38b3
	jr l38c5h		;38b5
l38b7h:
	ld a,(hl)		;38b7
	bit 5,a			;38b8
	jr z,l38cbh		;38ba
	jr l38c5h		;38bc
l38beh:
	ld a,(hl)		;38be
	bit 4,a			;38bf
	jr z,l38cbh		;38c1
	jr l38c5h		;38c3
l38c5h:
	pop hl			;38c5
	ld a,0ffh		;38c6
	push af			;38c8
	push hl			;38c9
	ret			;38ca
l38cbh:
	pop hl			;38cb
	push af			;38cc
	push hl			;38cd
	push bc			;38ce
	ld c,a			;38cf
	ld b,000h		;38d0
	call 06499h		;38d2
	pop bc			;38d5
	ret			;38d6
	call sub_2fafh		;38d7
	dec bc			;38da
	ld a,b			;38db
	or c			;38dc
	jr nz,l3902h		;38dd
	ld a,(de)		;38df
l38e0h:
	call sub_304bh		;38e0
	jr c,l38eeh		;38e3
	sub 090h		;38e5
	jr c,l3902h		;38e7
	cp 015h			;38e9
	jr nc,l3902h		;38eb
	inc a			;38ed
l38eeh:
	dec a			;38ee
	add a,a			;38ef
	add a,a			;38f0
	add a,a			;38f1
	cp 0a8h			;38f2
	jr nc,l3902h		;38f4
	ld bc,(05c7bh)		;38f6
	add a,c			;38fa
	ld c,a			;38fb
	jr nc,l38ffh		;38fc
	inc b			;38fe
l38ffh:
	jp sub_30e9h		;38ff
l3902h:
	rst 8			;3902
	add hl,bc		;3903
sub_3904h:
	push hl			;3904
	push bc			;3905
	ld b,a			;3906
	ld a,(hl)		;3907
	inc hl			;3908
	or (hl)			;3909
	inc hl			;390a
	or (hl)			;390b
	inc hl			;390c
	or (hl)			;390d
	ld a,b			;390e
	pop bc			;390f
	pop hl			;3910
	ret nz			;3911
	scf			;3912
	ret			;3913
sub_3914h:
	call sub_3904h		;3914
	ret c			;3917
	ld a,0ffh		;3918
	jr l3922h		;391a
sub_391ch:
	call sub_3904h		;391c
	jr sub_3926h		;391f
l3921h:
	xor a			;3921
l3922h:
	inc hl			;3922
	xor (hl)		;3923
	dec hl			;3924
	rlca			;3925
sub_3926h:
	push hl			;3926
	ld a,000h		;3927
	ld (hl),a		;3929
	inc hl			;392a
	ld (hl),a		;392b
	inc hl			;392c
	rla			;392d
	ld (hl),a		;392e
	rra			;392f
	inc hl			;3930
	ld (hl),a		;3931
	inc hl			;3932
	ld (hl),a		;3933
	pop hl			;3934
	ret			;3935
	ex de,hl		;3936
	call sub_3904h		;3937
	ex de,hl		;393a
	ret c			;393b
	scf			;393c
	jr sub_3926h		;393d
	ex de,hl		;393f
	call sub_3904h		;3940
	ex de,hl		;3943
	ret nc			;3944
	and a			;3945
	jr sub_3926h		;3946
	ex de,hl		;3948
	call sub_3904h		;3949
	ex de,hl		;394c
	ret nc			;394d
	push de			;394e
	dec de			;394f
	xor a			;3950
	ld (de),a		;3951
	dec de			;3952
	ld (de),a		;3953
	pop de			;3954
	ret			;3955
	ld a,b			;3956
	sub 008h		;3957
	bit 2,a			;3959
	jr nz,l395eh		;395b
	dec a			;395d
l395eh:
	rrca			;395e
	jr nc,l3969h		;395f
	push af			;3961
	push hl			;3962
	call l37fbh		;3963
	pop de			;3966
	ex de,hl		;3967
	pop af			;3968
l3969h:
	bit 2,a			;3969
	jr nz,l3974h		;396b
	rrca			;396d
	push af			;396e
	call sub_33ceh		;396f
	jr $+53			;3972
l3974h:
	rrca			;3974
	push af			;3975
	call sub_2fafh		;3976
	push de			;3979
	push bc			;397a
	call sub_2fafh		;397b
	pop hl			;397e
l397fh:
	ld a,h			;397f
	or l			;3980
	ex (sp),hl		;3981
	ld a,b			;3982
	jr nz,l3990h		;3983
	or c			;3985
l3986h:
	pop bc			;3986
	jr z,l398dh		;3987
	pop af			;3989
	ccf			;398a
	jr l39a3h		;398b
l398dh:
	pop af			;398d
	jr l39a3h		;398e
l3990h:
	or c			;3990
	jr z,l39a0h		;3991
	ld a,(de)		;3993
	sub (hl)		;3994
	jr c,l39a0h		;3995
	jr nz,l3986h		;3997
l3999h:
	dec bc			;3999
	inc de			;399a
	inc hl			;399b
	ex (sp),hl		;399c
	dec hl			;399d
	jr l397fh		;399e
l39a0h:
	pop bc			;39a0
	pop af			;39a1
	and a			;39a2
l39a3h:
	push af			;39a3
	rst 28h			;39a4
	and b			;39a5
	jr c,l3999h		;39a6
	push af			;39a8
	call c,sub_391ch	;39a9
	pop af			;39ac
	push af			;39ad
	call nc,sub_3914h	;39ae
	pop af			;39b1
	rrca			;39b2
	call nc,sub_391ch	;39b3
	ret			;39b6
	call sub_2fafh		;39b7
	push de			;39ba
	push bc			;39bb
	call sub_2fafh		;39bc
	pop hl			;39bf
	push hl			;39c0
	push de			;39c1
	push bc			;39c2
	add hl,bc		;39c3
	ld b,h			;39c4
	ld c,l			;39c5
	rst 30h			;39c6
	call sub_2e70h		;39c7
	pop bc			;39ca
	pop hl			;39cb
	ld a,b			;39cc
	or c			;39cd
	jr z,l39d2h		;39ce
	ldir			;39d0
l39d2h:
	pop bc			;39d2
	pop hl			;39d3
	ld a,b			;39d4
	or c			;39d5
	jr z,sub_39dah		;39d6
	ldir			;39d8
sub_39dah:
	ld hl,(05c65h)		;39da
	ld de,0fffbh		;39dd
	push hl			;39e0
	add hl,de		;39e1
	pop de			;39e2
	ret			;39e3
l39e4h:
	call 03193h		;39e4
	jr c,l39f7h		;39e7
	jr nz,l39f7h		;39e9
	push af			;39eb
	ld bc,l0001h		;39ec
	rst 30h			;39ef
	pop af			;39f0
	ld (de),a		;39f1
	call sub_2e70h		;39f2
	ex de,hl		;39f5
	ret			;39f6
l39f7h:
	rst 8			;39f7
	ld a,(bc)		;39f8
l39f9h:
	ld hl,(05c5dh)		;39f9
	push hl			;39fc
	ld a,b			;39fd
	add a,0e3h		;39fe
	sbc a,a			;3a00
	push af			;3a01
	call sub_2fafh		;3a02
	push de			;3a05
	inc bc			;3a06
	rst 30h			;3a07
	pop hl			;3a08
	ld (05c5dh),de		;3a09
	push de			;3a0d
	ldir			;3a0e
	ex de,hl		;3a10
	dec hl			;3a11
	ld (hl),00dh		;3a12
	res 7,(iy+001h)		;3a14
	call sub_2854h		;3a18
	rst 18h			;3a1b
	cp 00dh			;3a1c
	jr nz,l3a27h		;3a1e
	pop hl			;3a20
	pop af			;3a21
	xor (iy+001h)		;3a22
	and 040h		;3a25
l3a27h:
	jp nz,l1bedh		;3a27
	ld (05c5dh),hl		;3a2a
	set 7,(iy+001h)		;3a2d
	call sub_2854h		;3a31
	pop hl			;3a34
	ld (05c5dh),hl		;3a35
l3a38h:
	jr sub_39dah		;3a38
	ld bc,l0001h		;3a3a
	rst 30h			;3a3d
	ld (05c5bh),hl		;3a3e
	push hl			;3a41
	ld hl,(05c51h)		;3a42
	push hl			;3a45
	ld a,0ffh		;3a46
	call sub_1230h		;3a48
	call l31a1h		;3a4b
	pop hl			;3a4e
	call sub_1248h		;3a4f
	pop de			;3a52
	ld hl,(05c5bh)		;3a53
	and a			;3a56
	sbc hl,de		;3a57
	ld b,h			;3a59
	ld c,l			;3a5a
	call sub_2e70h		;3a5b
	ex de,hl		;3a5e
	ret			;3a5f
	call sub_1f1eh		;3a60
	cp 010h			;3a63
	jp nc,l1f29h		;3a65
	ld hl,(05c51h)		;3a68
	push hl			;3a6b
	call sub_1230h		;3a6c
	call sub_11e1h		;3a6f
	ld bc,l0000h		;3a72
	jr nc,l3a7ah		;3a75
	inc c			;3a77
	rst 30h			;3a78
	ld (de),a		;3a79
l3a7ah:
	call sub_2e70h		;3a7a
	pop hl			;3a7d
	call sub_1248h		;3a7e
	jp sub_39dah		;3a81
	call sub_2fafh		;3a84
	ld a,b			;3a87
	or c			;3a88
	jr z,l3a8ch		;3a89
	ld a,(de)		;3a8b
l3a8ch:
	jp l30e6h		;3a8c
l3a8fh:
	call sub_2fafh		;3a8f
	jp sub_30e9h		;3a92
	exx			;3a95
	push hl			;3a96
	ld hl,05c67h		;3a97
	dec (hl)		;3a9a
	pop hl			;3a9b
	jr nz,l3aa2h		;3a9c
	inc hl			;3a9e
	exx			;3a9f
	ret			;3aa0
l3aa1h:
	exx			;3aa1
l3aa2h:
	ld e,(hl)		;3aa2
	ld a,e			;3aa3
	rla			;3aa4
	sbc a,a			;3aa5
	ld d,a			;3aa6
	add hl,de		;3aa7
l3aa8h:
	exx			;3aa8
	ret			;3aa9
	inc de			;3aaa
	inc de			;3aab
	ld a,(de)		;3aac
	dec de			;3aad
	dec de			;3aae
	and a			;3aaf
	jr nz,l3aa1h		;3ab0
	exx			;3ab2
	inc hl			;3ab3
	exx			;3ab4
	ret			;3ab5
	pop af			;3ab6
	exx			;3ab7
	ex (sp),hl		;3ab8
	exx			;3ab9
	ret			;3aba
	rst 28h			;3abb
	ret nz			;3abc
	ld (bc),a		;3abd
	ld sp,005e0h		;3abe
	daa			;3ac1
	ret po			;3ac2
	ld bc,l04c0h		;3ac3
	inc bc			;3ac6
	ret po			;3ac7
	jr c,$-53		;3ac8
l3acah:
	rst 28h			;3aca
	ld sp,00036h		;3acb
	inc b			;3ace
	ld a,(0c938h)		;3acf
	ld sp,0c03ah		;3ad2
	inc bc			;3ad5
	ret po			;3ad6
	ld bc,l0030h		;3ad7
	inc bc			;3ada
	and c			;3adb
	inc bc			;3adc
	jr c,l3aa8h		;3add
	rst 28h			;3adf
	dec a			;3ae0
	inc (hl)		;3ae1
l3ae2h:
	pop af			;3ae2
	jr c,l3a8fh		;3ae3
	dec sp			;3ae5
	add hl,hl		;3ae6
	inc b			;3ae7
	ld sp,0c327h		;3ae8
	inc bc			;3aeb
	ld sp,0a10fh		;3aec
	inc bc			;3aef
	adc a,b			;3af0
	inc de			;3af1
	ld (hl),058h		;3af2
	ld h,l			;3af4
	ld h,(hl)		;3af5
	sbc a,l			;3af6
l3af7h:
	ld a,b			;3af7
	ld h,l			;3af8
	ld b,b			;3af9
	and d			;3afa
	ld h,b			;3afb
	ld (0e7c9h),a		;3afc
	ld hl,0aff7h		;3aff
	inc h			;3b02
	ex de,hl		;3b03
	cpl			;3b04
l3b05h:
	or b			;3b05
	or b			;3b06
	inc d			;3b07
	xor 07eh		;3b08
	cp e			;3b0a
	sub h			;3b0b
	ld e,b			;3b0c
	pop af			;3b0d
	ld a,(0f87eh)		;3b0e
	rst 8			;3b11
	ex (sp),hl		;3b12
	jr c,l3ae2h		;3b13
	sub e			;3b15
	ld sp,l0720h		;3b16
	jr c,l3b1eh		;3b19
	add a,(hl)		;3b1b
	jr nc,l3b27h		;3b1c
l3b1eh:
	rst 8			;3b1e
	dec b			;3b1f
	jr c,l3b29h		;3b20
	sub (hl)		;3b22
	jr nc,l3b29h		;3b23
	neg			;3b25
l3b27h:
	ld (hl),a		;3b27
	ret			;3b28
l3b29h:
	rst 28h			;3b29
	ld (bc),a		;3b2a
	and b			;3b2b
	jr c,l3af7h		;3b2c
	rst 28h			;3b2e
	dec a			;3b2f
	ld sp,00037h		;3b30
	inc b			;3b33
	jr c,l3b05h		;3b34
	add hl,bc		;3b36
	and b			;3b37
	ld (bc),a		;3b38
	jr c,l3bb9h		;3b39
	ld (hl),080h		;3b3b
	call l30e6h		;3b3d
	rst 28h			;3b40
	inc (hl)		;3b41
	jr c,l3b44h		;3b42
l3b44h:
	inc bc			;3b44
	ld bc,l3431h		;3b45
	ret p			;3b48
	ld c,h			;3b49
	call z,0cdcch		;3b4a
	inc bc			;3b4d
	scf			;3b4e
	nop			;3b4f
	ex af,af'		;3b50
	ld bc,l03a1h		;3b51
	ld bc,l3438h		;3b54
	rst 28h			;3b57
	ld bc,0f034h		;3b58
	ld sp,01772h		;3b5b
	ret m			;3b5e
	inc b			;3b5f
	ld bc,l03a2h		;3b60
	and d			;3b63
	inc bc			;3b64
	ld sp,03234h		;3b65
	jr nz,$+6		;3b68
	and d			;3b6a
	inc bc			;3b6b
	adc a,h			;3b6c
	ld de,l14ach		;3b6d
	add hl,bc		;3b70
	ld d,(hl)		;3b71
	jp c,059a5h		;3b72
	jr nc,$-57		;3b75
	ld e,h			;3b77
	sub b			;3b78
	xor d			;3b79
	sbc a,(hl)		;3b7a
	ld (hl),b		;3b7b
	ld l,a			;3b7c
	ld h,c			;3b7d
	and c			;3b7e
	set 3,d			;3b7f
	sub (hl)		;3b81
	and h			;3b82
	ld sp,0b49fh		;3b83
	rst 20h			;3b86
	and b			;3b87
	cp 05ch			;3b88
	call m,01beah		;3b8a
	ld b,e			;3b8d
l3b8eh:
	jp z,0ed36h		;3b8e
	and a			;3b91
	sbc a,h			;3b92
	ld a,(hl)		;3b93
	ld e,(hl)		;3b94
	ret p			;3b95
	ld l,(hl)		;3b96
	inc hl			;3b97
	add a,b			;3b98
	sub e			;3b99
	inc b			;3b9a
	rrca			;3b9b
	jr c,$-53		;3b9c
l3b9eh:
	rst 28h			;3b9e
	dec a			;3b9f
	inc (hl)		;3ba0
	xor 022h		;3ba1
	ld sp,hl		;3ba3
	add a,e			;3ba4
	ld l,(hl)		;3ba5
	inc b			;3ba6
	ld sp,l0fa2h		;3ba7
	daa			;3baa
	inc bc			;3bab
	ld sp,l310fh		;3bac
	rrca			;3baf
	ld sp,0a12ah		;3bb0
	inc bc			;3bb3
	ld sp,0c037h		;3bb4
	nop			;3bb7
	inc b			;3bb8
l3bb9h:
	ld (bc),a		;3bb9
	jr c,$-53		;3bba
	and c			;3bbc
	inc bc			;3bbd
	ld bc,00036h		;3bbe
	ld (bc),a		;3bc1
	dec de			;3bc2
	jr c,l3b8eh		;3bc3
	rst 28h			;3bc5
l3bc6h:
	add hl,sp		;3bc6
	ld hl,(l03a1h)		;3bc7
	ret po			;3bca
	nop			;3bcb
	ld b,01bh		;3bcc
	inc sp			;3bce
	inc bc			;3bcf
l3bd0h:
	rst 28h			;3bd0
l3bd1h:
	add hl,sp		;3bd1
l3bd2h:
	ld sp,l0431h		;3bd2
	ld sp,0a10fh		;3bd5
	inc bc			;3bd8
	add a,(hl)		;3bd9
	inc d			;3bda
	and 05ch		;3bdb
	rra			;3bdd
	dec bc			;3bde
	and e			;3bdf
	adc a,a			;3be0
	jr c,l3bd1h		;3be1
	jp (hl)			;3be3
	dec d			;3be4
	ld h,e			;3be5
	cp e			;3be6
	inc hl			;3be7
	xor 092h		;3be8
	dec c			;3bea
	call 0f1edh		;3beb
	inc hl			;3bee
	ld e,l			;3bef
	dec de			;3bf0
	jp pe,l3804h		;3bf1
	ret			;3bf4
	rst 28h			;3bf5
	ld sp,l011fh		;3bf6
	jr nz,l3c00h		;3bf9
	jr c,l3bc6h		;3bfb
	call l3656h		;3bfd
l3c00h:
	ld a,(hl)		;3c00
	cp 081h			;3c01
	jr c,l3c13h		;3c03
	rst 28h			;3c05
	and c			;3c06
	dec de			;3c07
	ld bc,03105h		;3c08
	ld (hl),0a3h		;3c0b
	ld bc,00600h		;3c0d
	dec de			;3c10
	inc sp			;3c11
	inc bc			;3c12
l3c13h:
	rst 28h			;3c13
	and b			;3c14
	ld bc,l3131h		;3c15
	inc b			;3c18
	ld sp,0a10fh		;3c19
	inc bc			;3c1c
	adc a,h			;3c1d
	djnz l3bd2h		;3c1e
	inc de			;3c20
	ld c,055h		;3c21
	call po,0588dh		;3c23
	add hl,sp		;3c26
	cp h			;3c27
	ld e,e			;3c28
	sbc a,b			;3c29
	sbc a,(iy+000h)		;3c2a
	ld (hl),075h		;3c2d
	and b			;3c2f
	in a,(0e8h)		;3c30
	or h			;3c32
	ld h,e			;3c33
	ld b,d			;3c34
	call nz,0b5e6h		;3c35
	add hl,bc		;3c38
l3c39h:
	ld (hl),0beh		;3c39
	jp (hl)			;3c3b
	ld (hl),073h		;3c3c
	dec de			;3c3e
	ld e,l			;3c3f
	call pe,0ded8h		;3c40
	ld h,e			;3c43
	cp (hl)			;3c44
	ret p			;3c45
	ld h,c			;3c46
	and c			;3c47
	or e			;3c48
	inc c			;3c49
	inc b			;3c4a
	rrca			;3c4b
	jr c,$-53		;3c4c
	rst 28h			;3c4e
	ld sp,l0431h		;3c4f
l3c52h:
	and c			;3c52
	inc bc			;3c53
	dec de			;3c54
	jr z,$-93		;3c55
	rrca			;3c57
	dec b			;3c58
	inc h			;3c59
	ld sp,l380fh		;3c5a
	ret			;3c5d
	rst 28h			;3c5e
	ld (l03a2h+1),hl	;3c5f
	dec de			;3c62
	jr c,$-53		;3c63
	rst 28h			;3c65
	ld sp,l0030h		;3c66
	ld e,0a2h		;3c69
	jr c,$-15		;3c6b
	ld bc,l3031h		;3c6d
	nop			;3c70
	rlca			;3c71
	dec h			;3c72
	inc b			;3c73
	jr c,l3c39h		;3c74
	rst 18h			;3c76
	ld a,(sub_3102h)	;3c77
	jr nc,l3c7ch		;3c7a
l3c7ch:
	add hl,bc		;3c7c
	and b			;3c7d
	ld bc,00037h		;3c7e
	ld b,0a1h		;3c81
	ld bc,l0205h		;3c83
	and c			;3c86
	jr c,l3c52h		;3c87
	add a,b			;3c89
	ld d,e			;3c8a
	ld (hl),h		;3c8b
	ld h,c			;3c8c
	ld (hl),d		;3c8d
	ld (hl),h		;3c8e
	jr nz,l3d05h		;3c8f
	ld h,c			;3c91
	ld (hl),b		;3c92
	ld h,l			;3c93
	inc l			;3c94
	jr nz,l3d0bh		;3c95
	ld l,b			;3c97
	ld h,l			;3c98
	ld l,(hl)		;3c99
	jr nz,$+114		;3c9a
	ld (hl),d		;3c9c
	ld h,l			;3c9d
	ld (hl),e		;3c9e
	ld (hl),e		;3c9f
	jr nz,l3d03h		;3ca0
	ld l,(hl)		;3ca2
	ld a,c			;3ca3
	jr nz,l3d11h		;3ca4
	ld h,l			;3ca6
	ld a,c			;3ca7
	xor (hl)		;3ca8
	dec c			;3ca9
	ld d,b			;3caa
	ld (hl),d		;3cab
	ld l,a			;3cac
	ld h,a			;3cad
	ld (hl),d		;3cae
	ld h,c			;3caf
	ld l,l			;3cb0
	ld a,(00da0h)		;3cb1
	ld c,(hl)		;3cb4
	ld (hl),l		;3cb5
	ld l,l			;3cb6
	ld h,d			;3cb7
	ld h,l			;3cb8
	ld (hl),d		;3cb9
	jr nz,l3d1dh		;3cba
	ld (hl),d		;3cbc
	ld (hl),d		;3cbd
	ld h,c			;3cbe
	ld a,c			;3cbf
	ld a,(00da0h)		;3cc0
	ld b,e			;3cc3
	ld l,b			;3cc4
	ld h,c			;3cc5
	ld (hl),d		;3cc6
l3cc7h:
	ld h,c			;3cc7
	ld h,e			;3cc8
	ld (hl),h		;3cc9
	ld h,l			;3cca
	ld (hl),d		;3ccb
	jr nz,l3d2fh		;3ccc
	ld (hl),d		;3cce
	ld (hl),d		;3ccf
	ld h,c			;3cd0
	ld a,c			;3cd1
	ld a,(00da0h)		;3cd2
	ld b,d			;3cd5
	ld a,c			;3cd6
	ld (hl),h		;3cd7
	ld h,l			;3cd8
	ld (hl),e		;3cd9
	ld a,(0cda0h)		;3cda
	inc hl			;3cdd
	rra			;3cde
	exx			;3cdf
	ld hl,l1855h		;3ce0
l3ce3h:
	push hl			;3ce3
	ld hl,0fefch		;3ce4
	push hl			;3ce7
	push af			;3ce8
	ld a,(05cc2h)		;3ce9
	and a			;3cec
	exx			;3ced
	jr nz,l3cf4h		;3cee
	pop af			;3cf0
	call 06572h		;3cf1
l3cf4h:
	pop af			;3cf4
	call 0fd32h		;3cf5
l3cf8h:
	ld (05dcdh),hl		;3cf8
	jp l04f8h		;3cfb
	nop			;3cfe
	nop			;3cff
	nop			;3d00
	nop			;3d01
	nop			;3d02
l3d03h:
	nop			;3d03
	nop			;3d04
l3d05h:
	nop			;3d05
	nop			;3d06
	nop			;3d07
	nop			;3d08
	djnz l3d1bh		;3d09
l3d0bh:
	djnz l3d1dh		;3d0b
	nop			;3d0d
	djnz l3d10h		;3d0e
l3d10h:
	nop			;3d10
l3d11h:
	inc h			;3d11
	inc h			;3d12
	nop			;3d13
	nop			;3d14
	nop			;3d15
	nop			;3d16
	nop			;3d17
	nop			;3d18
	inc h			;3d19
	ld a,(hl)		;3d1a
l3d1bh:
	inc h			;3d1b
	inc h			;3d1c
l3d1dh:
	ld a,(hl)		;3d1d
	inc h			;3d1e
	nop			;3d1f
	nop			;3d20
	ex af,af'		;3d21
	ld a,028h		;3d22
	ld a,00ah		;3d24
	ld a,008h		;3d26
	nop			;3d28
	ld h,d			;3d29
	ld h,h			;3d2a
	ex af,af'		;3d2b
	djnz l3d54h		;3d2c
	ld b,(hl)		;3d2e
l3d2fh:
	nop			;3d2f
	nop			;3d30
	djnz l3d5bh		;3d31
	djnz l3d5fh		;3d33
	ld b,h			;3d35
	ld a,(l0000h)		;3d36
	ex af,af'		;3d39
	djnz l3d3ch		;3d3a
l3d3ch:
	nop			;3d3c
	nop			;3d3d
	nop			;3d3e
	nop			;3d3f
	nop			;3d40
	inc b			;3d41
	ex af,af'		;3d42
	ex af,af'		;3d43
	ex af,af'		;3d44
	ex af,af'		;3d45
	inc b			;3d46
	nop			;3d47
	nop			;3d48
	jr nz,l3d5bh		;3d49
	djnz $+18		;3d4b
	djnz l3d6fh		;3d4d
	nop			;3d4f
	nop			;3d50
	nop			;3d51
	inc d			;3d52
	ex af,af'		;3d53
l3d54h:
	ld a,008h		;3d54
	inc d			;3d56
	nop			;3d57
	nop			;3d58
	nop			;3d59
	ex af,af'		;3d5a
l3d5bh:
	ex af,af'		;3d5b
	ld a,008h		;3d5c
	ex af,af'		;3d5e
l3d5fh:
	nop			;3d5f
	nop			;3d60
	nop			;3d61
	nop			;3d62
	nop			;3d63
	nop			;3d64
	ex af,af'		;3d65
	ex af,af'		;3d66
	djnz l3d69h		;3d67
l3d69h:
	nop			;3d69
	nop			;3d6a
	nop			;3d6b
	ld a,000h		;3d6c
	nop			;3d6e
l3d6fh:
	nop			;3d6f
	nop			;3d70
	nop			;3d71
	nop			;3d72
	nop			;3d73
	nop			;3d74
	jr $+26			;3d75
	nop			;3d77
	nop			;3d78
	nop			;3d79
	ld (bc),a		;3d7a
	inc b			;3d7b
	ex af,af'		;3d7c
	djnz l3d9fh		;3d7d
	nop			;3d7f
	nop			;3d80
	inc a			;3d81
	ld b,(hl)		;3d82
	ld c,d			;3d83
	ld d,d			;3d84
	ld h,d			;3d85
	inc a			;3d86
	nop			;3d87
	nop			;3d88
	jr l3db3h		;3d89
	ex af,af'		;3d8b
	ex af,af'		;3d8c
	ex af,af'		;3d8d
	ld a,000h		;3d8e
	nop			;3d90
	inc a			;3d91
	ld b,d			;3d92
	ld (bc),a		;3d93
	inc a			;3d94
	ld b,b			;3d95
	ld a,(hl)		;3d96
	nop			;3d97
	nop			;3d98
	inc a			;3d99
	ld b,d			;3d9a
	inc c			;3d9b
	ld (bc),a		;3d9c
	ld b,d			;3d9d
	inc a			;3d9e
l3d9fh:
	nop			;3d9f
	nop			;3da0
	ex af,af'		;3da1
	jr l3dcch		;3da2
	ld c,b			;3da4
	ld a,(hl)		;3da5
	ex af,af'		;3da6
	nop			;3da7
	nop			;3da8
	ld a,(hl)		;3da9
	ld b,b			;3daa
	ld a,h			;3dab
	ld (bc),a		;3dac
	ld b,d			;3dad
	inc a			;3dae
	nop			;3daf
	nop			;3db0
	inc a			;3db1
	ld b,b			;3db2
l3db3h:
	ld a,h			;3db3
	ld b,d			;3db4
	ld b,d			;3db5
	inc a			;3db6
	nop			;3db7
	nop			;3db8
	ld a,(hl)		;3db9
	ld (bc),a		;3dba
	inc b			;3dbb
	ex af,af'		;3dbc
	djnz l3dcfh		;3dbd
	nop			;3dbf
	nop			;3dc0
	inc a			;3dc1
	ld b,d			;3dc2
	inc a			;3dc3
	ld b,d			;3dc4
	ld b,d			;3dc5
	inc a			;3dc6
	nop			;3dc7
	nop			;3dc8
	inc a			;3dc9
	ld b,d			;3dca
	ld b,d			;3dcb
l3dcch:
	ld a,002h		;3dcc
	inc a			;3dce
l3dcfh:
	nop			;3dcf
	nop			;3dd0
	nop			;3dd1
	nop			;3dd2
	djnz l3dd5h		;3dd3
l3dd5h:
	nop			;3dd5
	djnz l3dd8h		;3dd6
l3dd8h:
	nop			;3dd8
	nop			;3dd9
	djnz l3ddch		;3dda
l3ddch:
	nop			;3ddc
	djnz l3defh		;3ddd
	jr nz,l3de1h		;3ddf
l3de1h:
	nop			;3de1
	inc b			;3de2
	ex af,af'		;3de3
	djnz $+10		;3de4
	inc b			;3de6
	nop			;3de7
	nop			;3de8
	nop			;3de9
	nop			;3dea
	ld a,000h		;3deb
	ld a,000h		;3ded
l3defh:
	nop			;3def
	nop			;3df0
	nop			;3df1
	djnz l3dfch		;3df2
	inc b			;3df4
	ex af,af'		;3df5
	djnz l3df8h		;3df6
l3df8h:
	nop			;3df8
	inc a			;3df9
	ld b,d			;3dfa
	inc b			;3dfb
l3dfch:
	ex af,af'		;3dfc
	nop			;3dfd
	ex af,af'		;3dfe
	nop			;3dff
	nop			;3e00
	inc a			;3e01
	ld c,d			;3e02
	ld d,(hl)		;3e03
	ld e,(hl)		;3e04
	ld b,b			;3e05
	inc a			;3e06
	nop			;3e07
	nop			;3e08
	inc a			;3e09
	ld b,d			;3e0a
	ld b,d			;3e0b
	ld a,(hl)		;3e0c
	ld b,d			;3e0d
	ld b,d			;3e0e
	nop			;3e0f
	nop			;3e10
	ld a,h			;3e11
	ld b,d			;3e12
	ld a,h			;3e13
	ld b,d			;3e14
	ld b,d			;3e15
	ld a,h			;3e16
	nop			;3e17
	nop			;3e18
	inc a			;3e19
	ld b,d			;3e1a
	ld b,b			;3e1b
	ld b,b			;3e1c
	ld b,d			;3e1d
	inc a			;3e1e
	nop			;3e1f
	nop			;3e20
	ld a,b			;3e21
	ld b,h			;3e22
	ld b,d			;3e23
	ld b,d			;3e24
	ld b,h			;3e25
	ld a,b			;3e26
	nop			;3e27
	nop			;3e28
	ld a,(hl)		;3e29
	ld b,b			;3e2a
	ld a,h			;3e2b
	ld b,b			;3e2c
	ld b,b			;3e2d
	ld a,(hl)		;3e2e
	nop			;3e2f
	nop			;3e30
	ld a,(hl)		;3e31
	ld b,b			;3e32
	ld a,h			;3e33
	ld b,b			;3e34
	ld b,b			;3e35
	ld b,b			;3e36
	nop			;3e37
l3e38h:
	nop			;3e38
	inc a			;3e39
	ld b,d			;3e3a
	ld b,b			;3e3b
	ld c,(hl)		;3e3c
	ld b,d			;3e3d
	inc a			;3e3e
	nop			;3e3f
	nop			;3e40
	ld b,d			;3e41
	ld b,d			;3e42
	ld a,(hl)		;3e43
	ld b,d			;3e44
	ld b,d			;3e45
	ld b,d			;3e46
	nop			;3e47
	nop			;3e48
	ld a,008h		;3e49
	ex af,af'		;3e4b
	ex af,af'		;3e4c
	ex af,af'		;3e4d
	ld a,000h		;3e4e
	nop			;3e50
	ld (bc),a		;3e51
	ld (bc),a		;3e52
	ld (bc),a		;3e53
	ld b,d			;3e54
l3e55h:
	ld b,d			;3e55
	inc a			;3e56
	nop			;3e57
	nop			;3e58
	ld b,h			;3e59
	ld c,b			;3e5a
	ld (hl),b		;3e5b
	ld c,b			;3e5c
	ld b,h			;3e5d
	ld b,d			;3e5e
	nop			;3e5f
	nop			;3e60
	ld b,b			;3e61
	ld b,b			;3e62
	ld b,b			;3e63
	ld b,b			;3e64
	ld b,b			;3e65
	ld a,(hl)		;3e66
	nop			;3e67
	nop			;3e68
	ld b,d			;3e69
	ld h,(hl)		;3e6a
	ld e,d			;3e6b
	ld b,d			;3e6c
	ld b,d			;3e6d
	ld b,d			;3e6e
	nop			;3e6f
	nop			;3e70
	ld b,d			;3e71
	ld h,d			;3e72
	ld d,d			;3e73
	ld c,d			;3e74
	ld b,(hl)		;3e75
	ld b,d			;3e76
	nop			;3e77
	nop			;3e78
	inc a			;3e79
	ld b,d			;3e7a
	ld b,d			;3e7b
	ld b,d			;3e7c
	ld b,d			;3e7d
	inc a			;3e7e
	nop			;3e7f
	nop			;3e80
	ld a,h			;3e81
	ld b,d			;3e82
	ld b,d			;3e83
	ld a,h			;3e84
	ld b,b			;3e85
	ld b,b			;3e86
	nop			;3e87
	nop			;3e88
	inc a			;3e89
	ld b,d			;3e8a
	ld b,d			;3e8b
	ld d,d			;3e8c
	ld c,d			;3e8d
	inc a			;3e8e
	nop			;3e8f
	nop			;3e90
	ld a,h			;3e91
	ld b,d			;3e92
	ld b,d			;3e93
	ld a,h			;3e94
	ld b,h			;3e95
	ld b,d			;3e96
	nop			;3e97
	nop			;3e98
	inc a			;3e99
	ld b,b			;3e9a
	inc a			;3e9b
	ld (bc),a		;3e9c
	ld b,d			;3e9d
	inc a			;3e9e
	nop			;3e9f
	nop			;3ea0
	cp 010h			;3ea1
	djnz l3eb5h		;3ea3
	djnz $+18		;3ea5
	nop			;3ea7
	nop			;3ea8
	ld b,d			;3ea9
	ld b,d			;3eaa
	ld b,d			;3eab
	ld b,d			;3eac
	ld b,d			;3ead
	inc a			;3eae
l3eafh:
	nop			;3eaf
	nop			;3eb0
	ld b,d			;3eb1
	ld b,d			;3eb2
	ld b,d			;3eb3
	ld b,d			;3eb4
l3eb5h:
	inc h			;3eb5
	jr l3eb8h		;3eb6
l3eb8h:
	nop			;3eb8
	ld b,d			;3eb9
	ld b,d			;3eba
	ld b,d			;3ebb
	ld b,d			;3ebc
	ld e,d			;3ebd
	inc h			;3ebe
	nop			;3ebf
	nop			;3ec0
	ld b,d			;3ec1
	inc h			;3ec2
	jr l3eddh		;3ec3
	inc h			;3ec5
	ld b,d			;3ec6
	nop			;3ec7
	nop			;3ec8
	add a,d			;3ec9
	ld b,h			;3eca
	jr z,l3eddh		;3ecb
	djnz $+18		;3ecd
	nop			;3ecf
	nop			;3ed0
	ld a,(hl)		;3ed1
	inc b			;3ed2
	ex af,af'		;3ed3
	djnz l3ef6h		;3ed4
	ld a,(hl)		;3ed6
	nop			;3ed7
	nop			;3ed8
	ld c,008h		;3ed9
	ex af,af'		;3edb
	ex af,af'		;3edc
l3eddh:
	ex af,af'		;3edd
	ld c,000h		;3ede
	nop			;3ee0
	nop			;3ee1
	ld b,b			;3ee2
	jr nz,$+18		;3ee3
	ex af,af'		;3ee5
	inc b			;3ee6
	nop			;3ee7
	nop			;3ee8
	ld (hl),b		;3ee9
	djnz l3efch		;3eea
	djnz l3efeh		;3eec
	ld (hl),b		;3eee
	nop			;3eef
	nop			;3ef0
	djnz $+58		;3ef1
	ld d,h			;3ef3
	djnz $+18		;3ef4
l3ef6h:
	djnz l3ef8h		;3ef6
l3ef8h:
	nop			;3ef8
	nop			;3ef9
	nop			;3efa
	nop			;3efb
l3efch:
	nop			;3efc
	nop			;3efd
l3efeh:
	nop			;3efe
	rst 38h			;3eff
	nop			;3f00
	inc e			;3f01
	ld (l2078h),hl		;3f02
	jr nz,l3f85h		;3f05
	nop			;3f07
	nop			;3f08
	nop			;3f09
	jr c,l3f10h		;3f0a
	inc a			;3f0c
	ld b,h			;3f0d
	inc a			;3f0e
	nop			;3f0f
l3f10h:
	nop			;3f10
	jr nz,$+34		;3f11
	inc a			;3f13
	ld (03c22h),hl		;3f14
	nop			;3f17
	nop			;3f18
	nop			;3f19
	inc e			;3f1a
	jr nz,l3f3dh		;3f1b
	jr nz,l3f3bh		;3f1d
	nop			;3f1f
	nop			;3f20
	inc b			;3f21
	inc b			;3f22
	inc a			;3f23
	ld b,h			;3f24
	ld b,h			;3f25
	inc a			;3f26
	nop			;3f27
	nop			;3f28
	nop			;3f29
l3f2ah:
	jr c,l3f70h		;3f2a
	ld a,b			;3f2c
	ld b,b			;3f2d
	inc a			;3f2e
	nop			;3f2f
	nop			;3f30
	inc c			;3f31
	djnz $+26		;3f32
	djnz l3f46h		;3f34
	djnz l3f38h		;3f36
l3f38h:
	nop			;3f38
	nop			;3f39
	inc a			;3f3a
l3f3bh:
	ld b,h			;3f3b
	ld b,h			;3f3c
l3f3dh:
	inc a			;3f3d
	inc b			;3f3e
	jr c,l3f41h		;3f3f
l3f41h:
	ld b,b			;3f41
	ld b,b			;3f42
	ld a,b			;3f43
	ld b,h			;3f44
	ld b,h			;3f45
l3f46h:
	ld b,h			;3f46
	nop			;3f47
	nop			;3f48
	djnz l3f4bh		;3f49
l3f4bh:
	jr nc,l3f5dh		;3f4b
	djnz l3f87h		;3f4d
	nop			;3f4f
	nop			;3f50
	inc b			;3f51
	nop			;3f52
	inc b			;3f53
	inc b			;3f54
	inc b			;3f55
	inc h			;3f56
	jr l3f59h		;3f57
l3f59h:
	jr nz,l3f83h		;3f59
	jr nc,l3f8dh		;3f5b
l3f5dh:
	jr z,l3f83h		;3f5d
	nop			;3f5f
	nop			;3f60
	djnz l3f73h		;3f61
	djnz l3f75h		;3f63
	djnz l3f73h		;3f65
	nop			;3f67
	nop			;3f68
	nop			;3f69
	ld l,h			;3f6a
	sub d			;3f6b
	sub d			;3f6c
	sub d			;3f6d
	sub d			;3f6e
	nop			;3f6f
l3f70h:
	nop			;3f70
	nop			;3f71
	ld a,b			;3f72
l3f73h:
	ld b,h			;3f73
	ld b,h			;3f74
l3f75h:
	ld b,h			;3f75
	ld b,h			;3f76
	nop			;3f77
	nop			;3f78
	nop			;3f79
	jr c,l3fc0h		;3f7a
	ld b,h			;3f7c
	ld b,h			;3f7d
	jr c,l3f80h		;3f7e
l3f80h:
	nop			;3f80
	nop			;3f81
	ld a,b			;3f82
l3f83h:
	ld b,h			;3f83
	ld b,h			;3f84
l3f85h:
	ld a,b			;3f85
	ld b,b			;3f86
l3f87h:
	ld b,b			;3f87
	nop			;3f88
	nop			;3f89
	inc a			;3f8a
	ld b,h			;3f8b
	ld b,h			;3f8c
l3f8dh:
	inc a			;3f8d
	inc b			;3f8e
	ld b,000h		;3f8f
	nop			;3f91
	inc e			;3f92
	jr nz,$+34		;3f93
	jr nz,$+34		;3f95
	nop			;3f97
	nop			;3f98
	nop			;3f99
	jr c,$+66		;3f9a
	jr c,$+6		;3f9c
	ld a,b			;3f9e
	nop			;3f9f
	nop			;3fa0
	djnz l3fdbh		;3fa1
	djnz $+18		;3fa3
	djnz l3fb3h		;3fa5
	nop			;3fa7
	nop			;3fa8
	nop			;3fa9
	ld b,h			;3faa
	ld b,h			;3fab
	ld b,h			;3fac
	ld b,h			;3fad
	jr c,l3fb0h		;3fae
l3fb0h:
	nop			;3fb0
	nop			;3fb1
	ld b,h			;3fb2
l3fb3h:
	ld b,h			;3fb3
	jr z,l3fdeh		;3fb4
	djnz l3fb8h		;3fb6
l3fb8h:
	nop			;3fb8
	nop			;3fb9
	sub d			;3fba
	sub d			;3fbb
	sub d			;3fbc
	sub d			;3fbd
	ld l,h			;3fbe
	nop			;3fbf
l3fc0h:
	nop			;3fc0
	nop			;3fc1
	ld b,h			;3fc2
	jr z,$+18		;3fc3
	jr z,$+70		;3fc5
	nop			;3fc7
	nop			;3fc8
	nop			;3fc9
	ld b,h			;3fca
	ld b,h			;3fcb
	ld b,h			;3fcc
	inc a			;3fcd
	inc b			;3fce
	jr c,l3fd1h		;3fcf
l3fd1h:
	nop			;3fd1
	ld a,h			;3fd2
	ex af,af'		;3fd3
	djnz l3ff6h		;3fd4
	ld a,h			;3fd6
	nop			;3fd7
	nop			;3fd8
	ld c,008h		;3fd9
l3fdbh:
	jr nc,l3fe5h		;3fdb
	ex af,af'		;3fdd
l3fdeh:
	ld c,000h		;3fde
	nop			;3fe0
	ex af,af'		;3fe1
	ex af,af'		;3fe2
	ex af,af'		;3fe3
	ex af,af'		;3fe4
l3fe5h:
	ex af,af'		;3fe5
	ex af,af'		;3fe6
	nop			;3fe7
	nop			;3fe8
	ld (hl),b		;3fe9
	djnz l3ff8h		;3fea
	djnz l3ffeh		;3fec
	ld (hl),b		;3fee
	nop			;3fef
	nop			;3ff0
	inc d			;3ff1
	jr z,l3ff4h		;3ff2
l3ff4h:
	nop			;3ff4
	nop			;3ff5
l3ff6h:
	nop			;3ff6
	nop			;3ff7
l3ff8h:
	inc a			;3ff8
	ld b,d			;3ff9
	sbc a,c			;3ffa
	and c			;3ffb
	and c			;3ffc
	sbc a,c			;3ffd
l3ffeh:
	ld b,d			;3ffe
	inc a			;3fff
