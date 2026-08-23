; z80dasm 1.2.0
; command line: z80dasm -a -l -g 0x0000 -t -o fdd3000.asm 3000_2068.ROM

	org 00000h

l0000h:
	di			;0000	f3		.
l0001h:
	jp l057dh		;0001	c3 7d 05	. } .
l0004h:
	rst 38h			;0004	ff		.
l0005h:
	rst 38h			;0005	ff		.
l0006h:
	rst 38h			;0006	ff		.
l0007h:
	rst 38h			;0007	ff		.
l0008h:
	jr l0039h		;0008	18 2f		. /
l000ah:
	rst 38h			;000a	ff		.
l000bh:
	rst 38h			;000b	ff		.
	rst 38h			;000c	ff		.
	rst 38h			;000d	ff		.
l000eh:
	rst 38h			;000e	ff		.
	rst 38h			;000f	ff		.
	jp l0305h		;0010	c3 05 03	. . .
sub_0013h:
	res 5,(iy+001h)		;0013	fd cb 01 ae	. . . .
	set 3,(iy+001h)		;0017	fd cb 01 de	. . . .
	rst 10h			;001b	d7		.
	or b			;001c	b0		.
	ld (bc),a		;001d	02		.
	xor a			;001e	af		.
	bit 5,(iy+001h)		;001f	fd cb 01 6e	. . . n
	ret z			;0023	c8		.
	ld a,(05c08h)		;0024	3a 08 5c	: . \
	cp 061h			;0027	fe 61		. a
	ret c			;0029	d8		.
	and 0dfh		;002a	e6 df		. .
	ret			;002c	c9		.
sub_002dh:
	ld a,00dh		;002d	3e 0d		> .
	rst 10h			;002f	d7		.
	djnz l0032h		;0030	10 00		. .
l0032h:
	ret			;0032	c9		.
	rst 38h			;0033	ff		.
	rst 38h			;0034	ff		.
	rst 38h			;0035	ff		.
	rst 38h			;0036	ff		.
	rst 38h			;0037	ff		.
	ret			;0038	c9		.
l0039h:
	push hl			;0039	e5		.
	push af			;003a	f5		.
	push iy			;003b	fd e5		. .
	pop hl			;003d	e1		.
l003eh:
	ld a,h			;003e	7c		|
	or l			;003f	b5		.
l0040h:
	inc hl			;0040	23		#
	inc bc			;0041	03		.
	pop af			;0042	f1		.
	pop hl			;0043	e1		.
	ret			;0044	c9		.
	pop af			;0045	f1		.
	ld hl,0213ah		;0046	21 3a 21	! : !
	bit 2,(hl)		;0049	cb 56		. V
	jp nz,0022ah		;004b	c2 2a 02	. * .
	bit 4,(hl)		;004e	cb 66		. f
	jp nz,l064ch		;0050	c2 4c 06	. L .
	bit 5,(hl)		;0053	cb 6e		. n
	jp nz,l024eh		;0055	c2 4e 02	. N .
	bit 0,(hl)		;0058	cb 46		. F
	res 0,(hl)		;005a	cb 86		. .
	pop hl			;005c	e1		.
	ret nz			;005d	c0		.
	ld hl,(05c5dh)		;005e	2a 5d 5c	* ] \
	ld (0213fh),hl		;0061	22 3f 21	" ? !
l0064h:
	dec hl			;0064	2b		+
	ld a,(hl)		;0065	7e		~
	cp 0a5h			;0066	fe a5		. .
	jr nc,l0070h		;0068	30 06		0 .
	cp 080h			;006a	fe 80		. .
	jr z,l008bh		;006c	28 1d		( .
	jr l0064h		;006e	18 f4		. .
l0070h:
	ld (05c5dh),hl		;0070	22 5d 5c	" ] \
	ld de,l0264h		;0073	11 64 02	. d .
	ld a,(hl)		;0076	7e		~
	ld b,a			;0077	47		G
	ex de,hl		;0078	eb		.
	ld a,(hl)		;0079	7e		~
l007ah:
	cp b			;007a	b8		.
	jr z,l0099h		;007b	28 1c		( .
l007dh:
	cp 0feh			;007d	fe fe		. .
	inc hl			;007f	23		#
	ld a,(hl)		;0080	7e		~
	jr nz,l007dh		;0081	20 fa		  .
	inc hl			;0083	23		#
	inc hl			;0084	23		#
	inc hl			;0085	23		#
	ld a,(hl)		;0086	7e		~
	cp 0ffh			;0087	fe ff		. .
	jr nz,l007ah		;0089	20 ef		  .
l008bh:
	ld hl,(0213bh)		;008b	2a 3b 21	* ; !
	jp (hl)			;008e	e9		.
	ld hl,l000bh		;008f	21 0b 00	! . .
	push hl			;0092	e5		.
	ld hl,(0213fh)		;0093	2a 3f 21	* ? !
	jp l0603h		;0096	c3 03 06	. . .
l0099h:
	inc de			;0099	13		.
	ld (05c5dh),de		;009a	ed 53 5d 5c	. S ] \
	ld a,(de)		;009e	1a		.
	cp 020h			;009f	fe 20		.  
	jr z,l0099h		;00a1	28 f6		( .
	cp 02ah			;00a3	fe 2a		. *
	jr nz,l008bh		;00a5	20 e4		  .
	inc hl			;00a7	23		#
	push hl			;00a8	e5		.
	rst 10h			;00a9	d7		.
	jr nz,l00ach		;00aa	20 00		  .
l00ach:
	pop hl			;00ac	e1		.
l00adh:
	ld de,l00dah		;00ad	11 da 00	. . .
	ld a,(hl)		;00b0	7e		~
	cp 0feh			;00b1	fe fe		. .
l00b3h:
	jr z,$+28		;00b3	28 1a		( .
	add a,e			;00b5	83		.
	ld e,a			;00b6	5f		_
	jr nc,l00bah		;00b7	30 01		0 .
	inc d			;00b9	14		.
l00bah:
	push hl			;00ba	e5		.
	ld hl,l00c9h		;00bb	21 c9 00	! . .
	push hl			;00be	e5		.
	ex de,hl		;00bf	eb		.
l00c0h:
	ld e,(hl)		;00c0	5e		^
	inc hl			;00c1	23		#
l00c2h:
	ld d,(hl)		;00c2	56		V
	push de			;00c3	d5		.
	ld hl,(05c5dh)		;00c4	2a 5d 5c	* ] \
	ld a,(hl)		;00c7	7e		~
	ret			;00c8	c9		.
l00c9h:
	pop hl			;00c9	e1		.
	inc hl			;00ca	23		#
	jr l00adh		;00cb	18 e0		. .
	call sub_0326h		;00cd	cd 26 03	. & .
	inc hl			;00d0	23		#
	ld e,(hl)		;00d1	5e		^
	inc hl			;00d2	23		#
	ld d,(hl)		;00d3	56		V
	ex de,hl		;00d4	eb		.
	ld de,l06ceh		;00d5	11 ce 06	. . .
	push de			;00d8	d5		.
	jp (hl)			;00d9	e9		.
l00dah:
	defb 0fdh,000h,00eh ;illegal sequence	;00da	fd 00 0e	. . .
	ld bc,l0129h		;00dd	01 29 01	. ) .
	ld e,b			;00e0	58		X
	ld bc,l0182h		;00e1	01 82 01	. . .
	cp c			;00e4	b9		.
	ld bc,l01c5h		;00e5	01 c5 01	. . .
	ret nc			;00e8	d0		.
	ld bc,l0202h		;00e9	01 02 02	. . .
	add hl,de		;00ec	19		.
	ld (bc),a		;00ed	02		.
	ret p			;00ee	f0		.
	ld bc,l01f7h		;00ef	01 f7 01	. . .
	ld d,d			;00f2	52		R
	add hl,bc		;00f3	09		.
	ld a,a			;00f4	7f		.
	dec bc			;00f5	0b		.
	ld h,a			;00f6	67		g
	ex af,af'		;00f7	08		.
	sbc a,(hl)		;00f8	9e		.
	rlca			;00f9	07		.
l00fah:
	jp l043eh		;00fa	c3 3e 04	. > .
l00fdh:
	call sub_0222h		;00fd	cd 22 02	. " .
l0100h:
	jr z,l00fah		;0100	28 f8		( .
	bit 7,(iy+001h)		;0102	fd cb 01 7e	. . . ~
	jp z,03ecdh		;0106	ca cd 3e	. . >
	ld (bc),a		;0109	02		.
	ld (02134h),a		;010a	32 34 21	2 4 !
	ret			;010d	c9		.
l010eh:
	call sub_0222h		;010e	cd 22 02	. " .
	jr nz,l00fah		;0111	20 e7		  .
	ld hl,(05c5dh)		;0113	2a 5d 5c	* ] \
	ld a,(hl)		;0116	7e		~
	cp 024h			;0117	fe 24		. $
	jr z,$+9		;0119	28 07		( .
	cp 022h			;011b	fe 22		. "
	jr z,$+5		;011d	28 03		( .
	dec hl			;011f	2b		+
	ld a,(de)		;0120	1a		.
	call p,05d22h		;0121	f4 22 5d	. " ]
	ld e,h			;0124	5c		\
	rst 10h			;0125	d7		.
	jr nz,l0128h		;0126	20 00		  .
l0128h:
	ret			;0128	c9		.
l0129h:
	call sub_025eh		;0129	cd 5e 02	. ^ .
	jr z,l00fah		;012c	28 cc		( .
	cp 05bh			;012e	fe 5b		. [
	jr c,l0134h		;0130	38 02		8 .
	sub 020h		;0132	d6 20		.  
l0134h:
	ld hl,l0000h		;0134	21 00 00	! . .
	add hl,sp		;0137	39		9
	inc hl			;0138	23		#
	inc hl			;0139	23		#
	ld e,(hl)		;013a	5e		^
	inc hl			;013b	23		#
	ld d,(hl)		;013c	56		V
	inc de			;013d	13		.
	ld b,a			;013e	47		G
l013fh:
	ld a,(de)		;013f	1a		.
	and a			;0140	a7		.
	jr z,l00fah		;0141	28 b7		( .
	cp b			;0143	b8		.
	jr z,l0149h		;0144	28 03		( .
	inc de			;0146	13		.
	jr l013fh		;0147	18 f6		. .
l0149h:
	ld (02136h),a		;0149	32 36 21	2 6 !
l014ch:
	inc de			;014c	13		.
	ld a,(de)		;014d	1a		.
	and a			;014e	a7		.
	jr nz,l014ch		;014f	20 fb		  .
	ld (hl),d		;0151	72		r
	dec hl			;0152	2b		+
	ld (hl),e		;0153	73		s
	rst 10h			;0154	d7		.
	jr nz,l0157h		;0155	20 00		  .
l0157h:
	ret			;0157	c9		.
	call sub_025eh		;0158	cd 5e 02	. ^ .
	jr z,l017bh		;015b	28 1e		( .
	call sub_0219h		;015d	cd 19 02	. . .
	call sub_0222h		;0160	cd 22 02	. " .
	jp z,l043eh		;0163	ca 3e 04	. > .
	bit 7,(iy+001h)		;0166	fd cb 01 7e	. . . ~
	ret z			;016a	c8		.
	call sub_0246h		;016b	cd 46 02	. F .
	ld (0214bh),bc		;016e	ed 43 4b 21	. C K !
	ld a,(0213ah)		;0172	3a 3a 21	: : !
	set 3,a			;0175	cb df		. .
l0177h:
	ld (0213ah),a		;0177	32 3a 21	2 : !
	ret			;017a	c9		.
l017bh:
	ld a,(0213ah)		;017b	3a 3a 21	: : !
	res 3,a			;017e	cb 9f		. .
	jr l0177h		;0180	18 f5		. .
l0182h:
	call sub_0219h		;0182	cd 19 02	. . .
	call sub_0222h		;0185	cd 22 02	. " .
	jp nz,l043eh		;0188	c2 3e 04	. > .
sub_018bh:
	ld hl,(05c5dh)		;018b	2a 5d 5c	* ] \
	ld a,(hl)		;018e	7e		~
	call sub_025eh		;018f	cd 5e 02	. ^ .
	jr z,l01b2h		;0192	28 1e		( .
	call sub_0219h		;0194	cd 19 02	. . .
	cp 0ach			;0197	fe ac		. .
	jp nz,l043eh		;0199	c2 3e 04	. > .
	rst 10h			;019c	d7		.
	jr nz,l019fh		;019d	20 00		  .
l019fh:
	call sub_0222h		;019f	cd 22 02	. " .
	jp z,l043eh		;01a2	ca 3e 04	. > .
	bit 7,(iy+001h)		;01a5	fd cb 01 7e	. . . ~
	ret z			;01a9	c8		.
	call sub_0246h		;01aa	cd 46 02	. F .
	ld (0214bh),bc		;01ad	ed 43 4b 21	. C K !
	ret			;01b1	c9		.
l01b2h:
	ld hl,l0000h		;01b2	21 00 00	! . .
	ld (0214bh),hl		;01b5	22 4b 21	" K !
	ret			;01b8	c9		.
	call sub_025eh		;01b9	cd 5e 02	. ^ .
	jp nz,l00fdh		;01bc	c2 fd 00	. . .
	ld a,080h		;01bf	3e 80		> .
	ld (02134h),a		;01c1	32 34 21	2 4 !
	ret			;01c4	c9		.
l01c5h:
	call sub_025eh		;01c5	cd 5e 02	. ^ .
	ld a,080h		;01c8	3e 80		> .
	ld (02134h),a		;01ca	32 34 21	2 4 !
	jp nz,l010eh		;01cd	c2 0e 01	. . .
l01d0h:
	ld a,(hl)		;01d0	7e		~
	and 0dfh		;01d1	e6 df		. .
	cp 04eh			;01d3	fe 4e		. N
l01d5h:
	jr z,l01e7h		;01d5	28 10		( .
	cp 00dh			;01d7	fe 0d		. .
	jr z,l01e2h		;01d9	28 07		( .
	cp 01ah			;01db	fe 1a		. .
	jr z,l01e2h		;01dd	28 03		( .
	jp l043eh		;01df	c3 3e 04	. > .
l01e2h:
	xor a			;01e2	af		.
	ld (02134h),a		;01e3	32 34 21	2 4 !
	ret			;01e6	c9		.
l01e7h:
	ld a,001h		;01e7	3e 01		> .
	ld (02134h),a		;01e9	32 34 21	2 4 !
	rst 10h			;01ec	d7		.
	jr nz,l01efh		;01ed	20 00		  .
l01efh:
	ret			;01ef	c9		.
l01f0h:
	ld a,(hl)		;01f0	7e		~
	and 0dfh		;01f1	e6 df		. .
	cp 044h			;01f3	fe 44		. D
	jr l01d5h		;01f5	18 de		. .
l01f7h:
	ld a,(02134h)		;01f7	3a 34 21	: 4 !
	ld (02139h),a		;01fa	32 39 21	2 9 !
	and a			;01fd	a7		.
	jr nz,l01f0h		;01fe	20 f0		  .
l0200h:
	jr l01e2h		;0200	18 e0		. .
l0202h:
	xor a			;0202	af		.
	ld (02134h),a		;0203	32 34 21	2 4 !
	ld a,(hl)		;0206	7e		~
	call sub_025eh		;0207	cd 5e 02	. ^ .
	ret z			;020a	c8		.
	cp 0cch			;020b	fe cc		. .
	jp nz,l043eh		;020d	c2 3e 04	. > .
	ld (02134h),a		;0210	32 34 21	2 4 !
	rst 10h			;0213	d7		.
	ld (0c300h),hl		;0214	22 00 c3	" . .
	ld c,003h		;0217	0e 03		. .
sub_0219h:
	cp 03bh			;0219	fe 3b		. ;
	jp nz,l043eh		;021b	c2 3e 04	. > .
	rst 10h			;021e	d7		.
	jr nz,l0221h		;021f	20 00		  .
l0221h:
	ret			;0221	c9		.
sub_0222h:
	ld hl,0213ah		;0222	21 3a 21	! : !
	set 2,(hl)		;0225	cb d6		. .
	rst 10h			;0227	d7		.
	ld d,h			;0228	54		T
	jr z,$-51		;0229	28 cb		( .
	sub (hl)		;022b	96		.
	res 0,(hl)		;022c	cb 86		. .
	pop hl			;022e	e1		.
	pop de			;022f	d1		.
	ld hl,0022ah		;0230	21 2a 02	! * .
	and a			;0233	a7		.
	sbc hl,de		;0234	ed 52		. R
	jp nz,l0438h		;0236	c2 38 04	. 8 .
	bit 6,(iy+003h)		;0239	fd cb 03 76	. . . v
	ret			;023d	c9		.
sub_023eh:
	ld hl,0213ah		;023e	21 3a 21	! : !
	set 5,(hl)		;0241	cb ee		. .
	rst 10h			;0243	d7		.
	ld e,01fh		;0244	1e 1f		. .
sub_0246h:
	ld hl,0213ah		;0246	21 3a 21	! : !
	set 5,(hl)		;0249	cb ee		. .
	rst 10h			;024b	d7		.
	inc hl			;024c	23		#
	rra			;024d	1f		.
l024eh:
	res 5,(hl)		;024e	cb ae		. .
	res 0,(hl)		;0250	cb 86		. .
	pop hl			;0252	e1		.
	pop de			;0253	d1		.
	ld hl,01ea0h		;0254	21 a0 1e	! . .
	and a			;0257	a7		.
	sbc hl,de		;0258	ed 52		. R
	ret nz			;025a	c0		.
	jp l0438h		;025b	c3 38 04	. 8 .
sub_025eh:
	cp 00dh			;025e	fe 0d		. .
	ret z			;0260	c8		.
	cp 03ah			;0261	fe 3a		. :
	ret			;0263	c9		.
l0264h:
	rst 8			;0264	cf		.
	inc c			;0265	0c		.
	cp 00ah			;0266	fe 0a		. .
	dec d			;0268	15		.
	rlca			;0269	07		.
	rst 28h			;026a	ef		.
	ld a,(de)		;026b	1a		.
	cp 006h			;026c	fe 06		. .
	ex af,af'		;026e	08		.
	inc c			;026f	0c		.
	ret m			;0270	f8		.
l0271h:
	jr l0271h		;0271	18 fe		. .
	ld b,0c9h		;0273	06 c9		. .
	add hl,bc		;0275	09		.
	out (000h),a		;0276	d3 00		. .
	ld (de),a		;0278	12		.
	ld (bc),a		;0279	02		.
	ld (de),a		;027a	12		.
	inc b			;027b	04		.
	ld c,c			;027c	49		I
	ld c,a			;027d	4f		O
	ld b,c			;027e	41		A
	ld d,d			;027f	52		R
	nop			;0280	00		.
	ld b,0feh		;0281	06 fe		. .
	ld a,(bc)		;0283	0a		.
	adc a,008h		;0284	ce 08		. .
	call nc,0fe0ah		;0286	d4 0a fe	. . .
	ld a,(bc)		;0289	0a		.
	cp (hl)			;028a	be		.
	ex af,af'		;028b	08		.
	push af			;028c	f5		.
	inc b			;028d	04		.
	inc hl			;028e	23		#
l028fh:
	nop			;028f	00		.
	nop			;0290	00		.
	ex af,af'		;0291	08		.
	cp 00ch			;0292	fe 0c		. .
	ld b,h			;0294	44		D
	rlca			;0295	07		.
	xor 004h		;0296	ee 04		. .
	inc hl			;0298	23		#
	nop			;0299	00		.
	nop			;029a	00		.
	ld (de),a		;029b	12		.
	ld e,0feh		;029c	1e fe		. .
	nop			;029e	00		.
	nop			;029f	00		.
	nop			;02a0	00		.
	ret p			;02a1	f0		.
	inc e			;02a2	1c		.
	cp 000h			;02a3	fe 00		. .
	ld (hl),c		;02a5	71		q
	ex af,af'		;02a6	08		.
	push hl			;02a7	e5		.
	ld b,023h		;02a8	06 23		. #
	nop			;02aa	00		.
	nop			;02ab	00		.
	cp 00ch			;02ac	fe 0c		. .
	ld c,b			;02ae	48		H
	ex af,af'		;02af	08		.
	push de			;02b0	d5		.
	ld (bc),a		;02b1	02		.
	cp 006h			;02b2	fe 06		. .
	halt			;02b4	76		v
	inc c			;02b5	0c		.
	call pe,01402h		;02b6	ec 02 14	. . .
	cp 00ah			;02b9	fe 0a		. .
	add hl,sp		;02bb	39		9
	ex af,af'		;02bc	08		.
	defb 0edh ;next byte illegal after ed	;02bd	ed		.
	inc c			;02be	0c		.
	ld d,0feh		;02bf	16 fe		. .
	ld a,(bc)		;02c1	0a		.
	add hl,hl		;02c2	29		)
	ex af,af'		;02c3	08		.
	call m,sub_0cfeh	;02c4	fc fe 0c	. . .
	ld b,e			;02c7	43		C
	ld a,(bc)		;02c8	0a		.
	ret nc			;02c9	d0		.
	ld (bc),a		;02ca	02		.
	djnz l02e3h		;02cb	10 16		. .
	cp 00ah			;02cd	fe 0a		. .
	ld l,l			;02cf	6d		m
	ld c,0d2h		;02d0	0e d2		. .
	ld (bc),a		;02d2	02		.
	ld c,0feh		;02d3	0e fe		. .
	ld a,(bc)		;02d5	0a		.
	and (hl)		;02d6	a6		.
	ex af,af'		;02d7	08		.
	pop af			;02d8	f1		.
	ld (bc),a		;02d9	02		.
	inc b			;02da	04		.
	xor h			;02db	ac		.
	nop			;02dc	00		.
	ld (bc),a		;02dd	02		.
	cp 008h			;02de	fe 08		. .
	ld c,(hl)		;02e0	4e		N
	add hl,bc		;02e1	09		.
	pop de			;02e2	d1		.
l02e3h:
	ld (bc),a		;02e3	02		.
	ld b,0ach		;02e4	06 ac		. .
	nop			;02e6	00		.
	ld (bc),a		;02e7	02		.
	cp 00ah			;02e8	fe 0a		. .
	ld d,009h		;02ea	16 09		. .
	jp (hl)			;02ec	e9		.
	ld (bc),a		;02ed	02		.
	cp 006h			;02ee	fe 06		. .
	xor a			;02f0	af		.
	ex af,af'		;02f1	08		.
	xor e			;02f2	ab		.
	ld (bc),a		;02f3	02		.
	inc b			;02f4	04		.
	ld d,b			;02f5	50		P
	ld d,l			;02f6	55		U
	ld d,(hl)		;02f7	56		V
	ld c,c			;02f8	49		I
	nop			;02f9	00		.
	cp 004h			;02fa	fe 04		. .
	adc a,c			;02fc	89		.
	ld c,0f3h		;02fd	0e f3		. .
	inc c			;02ff	0c		.
	cp 008h			;0300	fe 08		. .
	ld d,e			;0302	53		S
	ex af,af'		;0303	08		.
	rst 38h			;0304	ff		.
l0305h:
	ld (0213fh),hl		;0305	22 3f 21	" ? !
	ld (02141h),de		;0308	ed 53 41 21	. S A !
	pop hl			;030c	e1		.
	ld e,(hl)		;030d	5e		^
	inc hl			;030e	23		#
	ld d,(hl)		;030f	56		V
	inc hl			;0310	23		#
	push hl			;0311	e5		.
	ld hl,0213ah		;0312	21 3a 21	! : !
	set 0,(hl)		;0315	cb c6		. .
	ld hl,l000ah		;0317	21 0a 00	! . .
	push hl			;031a	e5		.
	push de			;031b	d5		.
	ld hl,(0213fh)		;031c	2a 3f 21	* ? !
	ld de,(02341h)		;031f	ed 5b 41 23	. [ A #
	jp l0603h		;0323	c3 03 06	. . .
sub_0326h:
	inc hl			;0326	23		#
	ld (0213fh),hl		;0327	22 3f 21	" ? !
	ld a,(hl)		;032a	7e		~
	or a			;032b	b7		.
	jr z,l0334h		;032c	28 06		( .
	ld b,a			;032e	47		G
sub_032fh:
	pop hl			;032f	e1		.
l0330h:
	inc sp			;0330	33		3
	djnz l0330h		;0331	10 fd		. .
	push hl			;0333	e5		.
l0334h:
	ld hl,(05c5dh)		;0334	2a 5d 5c	* ] \
	ld a,(hl)		;0337	7e		~
	call sub_025eh		;0338	cd 5e 02	. ^ .
	jp nz,l043eh		;033b	c2 3e 04	. > .
	ld hl,(0213fh)		;033e	2a 3f 21	* ? !
	bit 7,(iy+001h)		;0341	fd cb 01 7e	. . . ~
	ret nz			;0345	c0		.
	ld hl,01b4ah		;0346	21 4a 1b	! J .
	ex (sp),hl		;0349	e3		.
	jp l0603h		;034a	c3 03 06	. . .
l034dh:
	ld (02103h),bc		;034d	ed 43 03 21	. C . !
	ld (02105h),de		;0351	ed 53 05 21	. S . !
	ld (02107h),hl		;0355	22 07 21	" . !
	push af			;0358	f5		.
	pop hl			;0359	e1		.
	ld (02101h),hl		;035a	22 01 21	" . !
	ld (02109h),ix		;035d	dd 22 09 21	. " . !
	ld (0210bh),iy		;0361	fd 22 0b 21	. " . !
l0365h:
	ld a,0c0h		;0365	3e c0		> .
	ld (0212fh),a		;0367	32 2f 21	2 / !
	ld a,00dh		;036a	3e 0d		> .
	ld (02130h),a		;036c	32 30 21	2 0 !
	ld hl,02100h		;036f	21 00 21	! . !
	call sub_0454h		;0372	cd 54 04	. T .
	ret z			;0375	c8		.
	rst 10h			;0376	d7		.
	add hl,bc		;0377	09		.
	jr nz,$+58		;0378	20 38		  8
	call p,040c3h		;037a	f4 c3 40	. . @
	inc b			;037d	04		.
l037eh:
	ld (02130h),a		;037e	32 30 21	2 0 !
	ld a,0d0h		;0381	3e d0		> .
	ld (0212fh),a		;0383	32 2f 21	2 / !
	ld hl,02000h		;0386	21 00 20	! .  
	call sub_0454h		;0389	cd 54 04	. T .
	ret z			;038c	c8		.
	rst 10h			;038d	d7		.
	add hl,bc		;038e	09		.
	jr nz,l03c9h		;038f	20 38		  8
	call p,040c3h		;0391	f4 c3 40	. . @
	ld b,0cdh		;0394	06 cd		. .
	sub l			;0396	95		.
	inc b			;0397	04		.
	jr z,l03a2h		;0398	28 08		( .
	rst 10h			;039a	d7		.
	add hl,bc		;039b	09		.
	jr nz,l03d6h		;039c	20 38		  8
	or 0c3h			;039e	f6 c3		. .
	ld a,004h		;03a0	3e 04		> .
l03a2h:
	ld a,(0212fh)		;03a2	3a 2f 21	: / !
	cp 0c0h			;03a5	fe c0		. .
	jr z,l03abh		;03a7	28 02		( .
	and a			;03a9	a7		.
	ret			;03aa	c9		.
l03abh:
	ld hl,(02101h)		;03ab	2a 01 21	* . !
	push hl			;03ae	e5		.
	pop af			;03af	f1		.
	ld bc,(02103h)		;03b0	ed 4b 03 21	. K . !
	ld de,(02105h)		;03b4	ed 5b 05 21	. [ . !
	ld hl,(02107h)		;03b8	2a 07 21	* . !
	ld ix,(02109h)		;03bb	dd 2a 09 21	. * . !
	scf			;03bf	37		7
	ret			;03c0	c9		.
sub_03c1h:
	push hl			;03c1	e5		.
	ld a,002h		;03c2	3e 02		> .
	rst 10h			;03c4	d7		.
	jr nc,$+20		;03c5	30 12		0 .
	ld a,0ffh		;03c7	3e ff		> .
l03c9h:
	ld (05c8ch),a		;03c9	32 8c 5c	2 . \
	call sub_0013h		;03cc	cd 13 00	. . .
	cp 053h			;03cf	fe 53		. S
	jr nz,l03dah		;03d1	20 07		  .
l03d3h:
	call sub_0013h		;03d3	cd 13 00	. . .
l03d6h:
	cp 051h			;03d6	fe 51		. Q
	jr nz,l03d3h		;03d8	20 f9		  .
l03dah:
	call sub_002dh		;03da	cd 2d 00	. - .
	pop hl			;03dd	e1		.
	push hl			;03de	e5		.
	ld a,h			;03df	7c		|
	rra			;03e0	1f		.
	ld b,000h		;03e1	06 00		. .
	jr c,l03e7h		;03e3	38 02		8 .
	ld b,021h		;03e5	06 21		. !
l03e7h:
	pop hl			;03e7	e1		.
	inc b			;03e8	04		.
	ld a,b			;03e9	78		x
	cp 021h			;03ea	fe 21		. !
	ret z			;03ec	c8		.
	ld a,(hl)		;03ed	7e		~
	or a			;03ee	b7		.
	ret z			;03ef	c8		.
	inc hl			;03f0	23		#
	push hl			;03f1	e5		.
	rst 10h			;03f2	d7		.
	djnz l03f5h		;03f3	10 00		. .
l03f5h:
	jr l03e7h		;03f5	18 f0		. .
sub_03f7h:
	ld (02102h),a		;03f7	32 02 21	2 . !
	and a			;03fa	a7		.
	ret z			;03fb	c8		.
	cp 081h			;03fc	fe 81		. .
	ld de,l0415h		;03fe	11 15 04	. . .
	jr z,l0409h		;0401	28 06		( .
	cp 04bh			;0403	fe 4b		. K
	ld de,00428h		;0405	11 28 04	. ( .
	ret nz			;0408	c0		.
l0409h:
	push hl			;0409	e5		.
	ld hl,0210dh		;040a	21 0d 21	! . !
	ex de,hl		;040d	eb		.
	ld bc,00020h		;040e	01 20 00	.   .
	ldir			;0411	ed b0		. .
	pop hl			;0413	e1		.
	ret			;0414	c9		.
l0415h:
	ld d,e			;0415	53		S
	ld (hl),l		;0416	75		u
	ld (hl),b		;0417	70		p
	ld h,l			;0418	65		e
	ld (hl),d		;0419	72		r
	ld (hl),e		;041a	73		s
	ld h,l			;041b	65		e
	ld h,h			;041c	64		d
	ld h,l			;041d	65		e
	jr nz,$+42		;041e	20 28		  (
	ld e,c			;0420	59		Y
	cpl			;0421	2f		/
	ld c,(hl)		;0422	4e		N
	add hl,hl		;0423	29		)
	jr nz,$+65		;0424	20 3f		  ?
	ld (05700h),hl		;0426	22 00 57	" . W
	ld (hl),d		;0429	72		r
	ld l,a			;042a	6f		o
	ld l,(hl)		;042b	6e		n
	ld h,a			;042c	67		g
	jr nz,l0493h		;042d	20 64		  d
	ld h,c			;042f	61		a
	ld (hl),h		;0430	74		t
	ld h,c			;0431	61		a
	jr nz,$+118		;0432	20 74		  t
	ld a,c			;0434	79		y
	ld (hl),b		;0435	70		p
	ld h,l			;0436	65		e
	nop			;0437	00		.
l0438h:
	ex de,hl		;0438	eb		.
	rst 10h			;0439	d7		.
	ld a,e			;043a	7b		{
	nop			;043b	00		.
	ld a,(de)		;043c	1a		.
	ld (bc),a		;043d	02		.
l043eh:
	ld a,00bh		;043e	3e 0b		> .
l0440h:
	ld sp,(05c3dh)		;0440	ed 7b 3d 5c	. { = \
	ld (iy+002h),a		;0444	fd 77 02	. w .
	ld hl,(05c5dh)		;0447	2a 5d 5c	* ] \
	ld (05c5fh),hl		;044a	22 5f 5c	" _ \
	ld hl,01354h		;044d	21 54 13	! T .
	push hl			;0450	e5		.
	jp l0603h		;0451	c3 03 06	. . .
sub_0454h:
	push de			;0454	d5		.
	push bc			;0455	c5		.
	push hl			;0456	e5		.
	ld a,00ah		;0457	3e 0a		> .
	ld (02132h),a		;0459	32 32 21	2 2 !
l045ch:
	ld hl,0212fh		;045c	21 2f 21	! / !
	ld b,003h		;045f	06 03		. .
	ld c,000h		;0461	0e 00		. .
	call sub_04efh		;0463	cd ef 04	. . .
	ld a,(02130h)		;0466	3a 30 21	: 0 !
	ld b,a			;0469	47		G
	pop hl			;046a	e1		.
	push hl			;046b	e5		.
	call sub_04edh		;046c	cd ed 04	. . .
	ld a,c			;046f	79		y
	neg			;0470	ed 44		. D
	call sub_04e9h		;0472	cd e9 04	. . .
	ld hl,02131h		;0475	21 31 21	! 1 !
	call sub_0540h		;0478	cd 40 05	. @ .
	ld a,(02131h)		;047b	3a 31 21	: 1 !
	cp 0b0h			;047e	fe b0		. .
	jr nz,l0487h		;0480	20 05		  .
	xor a			;0482	af		.
l0483h:
	pop hl			;0483	e1		.
	pop bc			;0484	c1		.
	pop de			;0485	d1		.
	ret			;0486	c9		.
l0487h:
	ld a,(02132h)		;0487	3a 32 21	: 2 !
	dec a			;048a	3d		=
	ld (02132h),a		;048b	32 32 21	2 2 !
	jr nz,l045ch		;048e	20 cc		  .
l0490h:
	ld a,003h		;0490	3e 03		> .
	and a			;0492	a7		.
l0493h:
	jr l0483h		;0493	18 ee		. .
l0495h:
	push de			;0495	d5		.
	push bc			;0496	c5		.
	push hl			;0497	e5		.
	ld a,00ah		;0498	3e 0a		> .
	ld (02132h),a		;049a	32 32 21	2 2 !
l049dh:
	ld hl,0212fh		;049d	21 2f 21	! / !
	ld b,003h		;04a0	06 03		. .
	ld c,000h		;04a2	0e 00		. .
	call sub_0542h		;04a4	cd 42 05	. B .
	ld a,(0212fh)		;04a7	3a 2f 21	: / !
	cp 0c0h			;04aa	fe c0		. .
	jr z,l04b4h		;04ac	28 06		( .
	cp 0d0h			;04ae	fe d0		. .
	jr z,l04b9h		;04b0	28 07		( .
	jr l049dh		;04b2	18 e9		. .
l04b4h:
	ld hl,02100h		;04b4	21 00 21	! . !
	jr l04bch		;04b7	18 03		. .
l04b9h:
	ld hl,02000h		;04b9	21 00 20	! .  
l04bch:
	ld a,(02130h)		;04bc	3a 30 21	: 0 !
	ld b,a			;04bf	47		G
	call sub_0542h		;04c0	cd 42 05	. B .
	ld hl,02131h		;04c3	21 31 21	! 1 !
	call sub_0540h		;04c6	cd 40 05	. @ .
	ld a,c			;04c9	79		y
	and a			;04ca	a7		.
	jr z,l04e2h		;04cb	28 15		( .
	ld a,(02132h)		;04cd	3a 32 21	: 2 !
	dec a			;04d0	3d		=
	ld (02132h),a		;04d1	32 32 21	2 2 !
	jr z,l04ddh		;04d4	28 07		( .
	ld a,0e0h		;04d6	3e e0		> .
	call sub_04e9h		;04d8	cd e9 04	. . .
	jr l049dh		;04db	18 c0		. .
l04ddh:
	ld a,004h		;04dd	3e 04		> .
	and a			;04df	a7		.
	jr l0483h		;04e0	18 a1		. .
l04e2h:
	ld a,0b0h		;04e2	3e b0		> .
	call sub_04e9h		;04e4	cd e9 04	. . .
	jr l0483h		;04e7	18 9a		. .
sub_04e9h:
	ld b,001h		;04e9	06 01		. .
	jr l04eeh		;04eb	18 01		. .
sub_04edh:
	ld a,(hl)		;04ed	7e		~
l04eeh:
	ld d,a			;04ee	57		W
sub_04efh:
	add a,c			;04ef	81		.
	ld c,a			;04f0	4f		O
	push bc			;04f1	c5		.
	ld a,d			;04f2	7a		z
	and 00fh		;04f3	e6 0f		. .
	out (0efh),a		;04f5	d3 ef		. .
	ld e,a			;04f7	5f		_
	ld a,d			;04f8	7a		z
	and 0f0h		;04f9	e6 f0		. .
	rrca			;04fb	0f		.
	rrca			;04fc	0f		.
	rrca			;04fd	0f		.
	rrca			;04fe	0f		.
	ld d,a			;04ff	57		W
	ld bc,l00c0h		;0500	01 c0 00	. . .
	in a,(0efh)		;0503	db ef		. .
	and c			;0505	a1		.
	cp 040h			;0506	fe 40		. @
	jr z,l050eh		;0508	28 04		( .
	ld (de),a		;050a	12		.
	rst 30h			;050b	f7		.
	jr l0531h		;050c	18 23		. #
l050eh:
	ld a,e			;050e	7b		{
	or 080h			;050f	f6 80		. .
	out (0efh),a		;0511	d3 ef		. .
	ld b,000h		;0513	06 00		. .
l0515h:
	in a,(0efh)		;0515	db ef		. .
	and c			;0517	a1		.
	cp 0c0h			;0518	fe c0		. .
	jr z,l0520h		;051a	28 04		( .
	djnz l0515h		;051c	10 f7		. .
	jr l0531h		;051e	18 11		. .
l0520h:
	ld a,d			;0520	7a		z
	or 082h			;0521	f6 82		. .
	out (0efh),a		;0523	d3 ef		. .
	ld a,d			;0525	7a		z
	out (0efh),a		;0526	d3 ef		. .
	ld b,000h		;0528	06 00		. .
l052ah:
	in a,(0efh)		;052a	db ef		. .
	and c			;052c	a1		.
	jr z,l053ah		;052d	28 0b		( .
	djnz l052ah		;052f	10 f9		. .
l0531h:
	ld a,000h		;0531	3e 00		> .
	out (0efh),a		;0533	d3 ef		. .
	pop bc			;0535	c1		.
	pop hl			;0536	e1		.
	jp l0490h		;0537	c3 90 04	. . .
l053ah:
	pop bc			;053a	c1		.
	inc hl			;053b	23		#
	djnz sub_04edh		;053c	10 af		. .
	xor a			;053e	af		.
	ret			;053f	c9		.
sub_0540h:
	ld b,001h		;0540	06 01		. .
sub_0542h:
	push bc			;0542	c5		.
	ld a,040h		;0543	3e 40		> @
	out (0efh),a		;0545	d3 ef		. .
	ld bc,l00c2h		;0547	01 c2 00	. . .
l054ah:
	in a,(0efh)		;054a	db ef		. .
	ld e,a			;054c	5f		_
	and c			;054d	a1		.
	cp 080h			;054e	fe 80		. .
	jr z,l0556h		;0550	28 04		( .
	djnz l054ah		;0552	10 f6		. .
	jr l0531h		;0554	18 db		. .
l0556h:
	ld a,0c0h		;0556	3e c0		> .
	out (0efh),a		;0558	d3 ef		. .
	ld b,000h		;055a	06 00		. .
l055ch:
	in a,(0efh)		;055c	db ef		. .
	ld d,a			;055e	57		W
	and c			;055f	a1		.
	jr z,l0566h		;0560	28 04		( .
	djnz l055ch		;0562	10 f8		. .
	jr l0531h		;0564	18 cb		. .
l0566h:
	out (0efh),a		;0566	d3 ef		. .
	ld a,e			;0568	7b		{
	and 00fh		;0569	e6 0f		. .
	ld e,a			;056b	5f		_
	ld a,d			;056c	7a		z
	and 00fh		;056d	e6 0f		. .
	rlca			;056f	07		.
	rlca			;0570	07		.
	rlca			;0571	07		.
	rlca			;0572	07		.
	or e			;0573	b3		.
	ld (hl),a		;0574	77		w
	pop bc			;0575	c1		.
	add a,c			;0576	81		.
	ld c,a			;0577	4f		O
	inc hl			;0578	23		#
	djnz sub_0542h		;0579	10 c7		. .
	xor a			;057b	af		.
	ret			;057c	c9		.
l057dh:
	ld a,007h		;057d	3e 07		> .
	out (0feh),a		;057f	d3 fe		. .
	xor a			;0581	af		.
	out (0ffh),a		;0582	d3 ff		. .
	out (0f4h),a		;0584	d3 f4		. .
	ld de,02001h		;0586	11 01 20	. .  
	ld hl,02000h		;0589	21 00 20	! .  
	ld (hl),a		;058c	77		w
	ld bc,0e002h		;058d	01 02 e0	. . .
	ldir			;0590	ed b0		. .
	ld a,03fh		;0592	3e 3f		> ?
	ld i,a			;0594	ed 47		. G
	ld hl,l028fh		;0596	21 8f 02	! . .
	ld (0213bh),hl		;0599	22 3b 21	" ; !
	ld hl,l06d2h		;059c	21 d2 06	! . .
	ld (0213dh),hl		;059f	22 3d 21	" = !
	jp l0eb0h		;05a2	c3 b0 0e	. . .
l05a5h:
	ld hl,l0f10h		;05a5	21 10 0f	! . .
	push hl			;05a8	e5		.
	jp l0008h		;05a9	c3 08 00	. . .
l05ach:
	rst 28h			;05ac	ef		.
	ld hl,(05322h)		;05ad	2a 22 53	* " S
	ld d,h			;05b0	54		T
	ld b,c			;05b1	41		A
	ld d,d			;05b2	52		R
	ld d,h			;05b3	54		T
	ld (0ffffh),hl		;05b4	22 ff ff	" . .
	rst 38h			;05b7	ff		.
	rst 38h			;05b8	ff		.
	rst 38h			;05b9	ff		.
	rst 38h			;05ba	ff		.
	rst 38h			;05bb	ff		.
	rst 38h			;05bc	ff		.
	rst 38h			;05bd	ff		.
	rst 38h			;05be	ff		.
	rst 38h			;05bf	ff		.
	rst 38h			;05c0	ff		.
	rst 38h			;05c1	ff		.
	rst 38h			;05c2	ff		.
	rst 38h			;05c3	ff		.
	rst 38h			;05c4	ff		.
	rst 38h			;05c5	ff		.
	rst 38h			;05c6	ff		.
	rst 38h			;05c7	ff		.
	rst 38h			;05c8	ff		.
	rst 38h			;05c9	ff		.
	rst 38h			;05ca	ff		.
	rst 38h			;05cb	ff		.
	rst 38h			;05cc	ff		.
	rst 38h			;05cd	ff		.
	rst 38h			;05ce	ff		.
	rst 38h			;05cf	ff		.
	rst 38h			;05d0	ff		.
	rst 38h			;05d1	ff		.
	rst 38h			;05d2	ff		.
	rst 38h			;05d3	ff		.
	rst 38h			;05d4	ff		.
	rst 38h			;05d5	ff		.
	rst 38h			;05d6	ff		.
	rst 38h			;05d7	ff		.
	rst 38h			;05d8	ff		.
	rst 38h			;05d9	ff		.
	rst 38h			;05da	ff		.
	rst 38h			;05db	ff		.
	rst 38h			;05dc	ff		.
	rst 38h			;05dd	ff		.
	rst 38h			;05de	ff		.
	rst 38h			;05df	ff		.
	rst 38h			;05e0	ff		.
	rst 38h			;05e1	ff		.
	rst 38h			;05e2	ff		.
	rst 38h			;05e3	ff		.
	rst 38h			;05e4	ff		.
	rst 38h			;05e5	ff		.
	rst 38h			;05e6	ff		.
	rst 38h			;05e7	ff		.
	rst 38h			;05e8	ff		.
	rst 38h			;05e9	ff		.
	rst 38h			;05ea	ff		.
	rst 38h			;05eb	ff		.
	rst 38h			;05ec	ff		.
	rst 38h			;05ed	ff		.
	rst 38h			;05ee	ff		.
	rst 38h			;05ef	ff		.
	rst 38h			;05f0	ff		.
	rst 38h			;05f1	ff		.
	rst 38h			;05f2	ff		.
	rst 38h			;05f3	ff		.
	rst 38h			;05f4	ff		.
	rst 38h			;05f5	ff		.
	rst 38h			;05f6	ff		.
	rst 38h			;05f7	ff		.
	rst 38h			;05f8	ff		.
	rst 38h			;05f9	ff		.
	rst 38h			;05fa	ff		.
	rst 38h			;05fb	ff		.
	rst 38h			;05fc	ff		.
	rst 38h			;05fd	ff		.
	rst 38h			;05fe	ff		.
	rst 38h			;05ff	ff		.
	rst 38h			;0600	ff		.
	rst 38h			;0601	ff		.
	rst 38h			;0602	ff		.
l0603h:
	ei			;0603	fb		.
l0604h:
	ret			;0604	c9		.
	jp l037eh		;0605	c3 7e 03	. ~ .
	jp l034dh		;0608	c3 4d 03	. M .
	jp 00395h		;060b	c3 95 03	. . .
	jp sub_0454h		;060e	c3 54 04	. T .
	jp l0495h		;0611	c3 95 04	. . .
	jp 00f7fh		;0614	c3 7f 0f	. . .
	jp l0daah		;0617	c3 aa 0d	. . .
	jp l0b2bh		;061a	c3 2b 0b	. + .
	jp l0305h		;061d	c3 05 03	. . .
	jp l0a3ch		;0620	c3 3c 0a	. < .
	jp l0cach		;0623	c3 ac 0c	. . .
	jp l067eh		;0626	c3 7e 06	. ~ .
sub_0629h:
	ld a,(02136h)		;0629	3a 36 21	: 6 !
	bit 7,a			;062c	cb 7f		. .
	jp nz,0492ah		;062e	c2 2a 49	. * I
	ld hl,0cbfdh		;0631	21 fd cb	! . .
	ld bc,0c87eh		;0634	01 7e c8	. ~ .
	push hl			;0637	e5		.
	inc hl			;0638	23		#
	ld c,(hl)		;0639	4e		N
	inc hl			;063a	23		#
	ld b,(hl)		;063b	46		F
	inc bc			;063c	03		.
	inc bc			;063d	03		.
	inc bc			;063e	03		.
	pop hl			;063f	e1		.
	rst 10h			;0640	d7		.
	ld d,b			;0641	50		P
	rla			;0642	17		.
	ret			;0643	c9		.
sub_0644h:
	ld hl,0213ah		;0644	21 3a 21	! : !
	set 4,(hl)		;0647	cb e6		. .
	rst 10h			;0649	d7		.
	ld (hl),b		;064a	70		p
	inc l			;064b	2c		,
l064ch:
	res 4,(hl)		;064c	cb a6		. .
	res 0,(hl)		;064e	cb 86		. .
	pop hl			;0650	e1		.
	ex (sp),hl		;0651	e3		.
	push af			;0652	f5		.
	ld de,l064ch		;0653	11 4c 06	. L .
	ex de,hl		;0656	eb		.
	and a			;0657	a7		.
	sbc hl,de		;0658	ed 52		. R
	jp nz,l0438h		;065a	c2 38 04	. 8 .
	pop af			;065d	f1		.
	pop hl			;065e	e1		.
	ret			;065f	c9		.
sub_0660h:
	rst 10h			;0660	d7		.
	xor a			;0661	af		.
	cpl			;0662	2f		/
sub_0663h:
	ld hl,02000h		;0663	21 00 20	! .  
sub_0666h:
	push hl			;0666	e5		.
	and a			;0667	a7		.
l0668h:
	ld hl,l0040h		;0668	21 40 00	! @ .
	sbc hl,bc		;066b	ed 42		. B
	pop hl			;066d	e1		.
	ld a,(07808h)		;066e	3a 08 78	: . x
	or c			;0671	b1		.
	jr z,l0678h		;0672	28 04		( .
	ex de,hl		;0674	eb		.
	ldir			;0675	ed b0		. .
	ex de,hl		;0677	eb		.
l0678h:
	ld (hl),000h		;0678	36 00		6 .
	inc hl			;067a	23		#
	inc a			;067b	3c		<
	ld b,a			;067c	47		G
	ret			;067d	c9		.
l067eh:
	call 00395h		;067e	cd 95 03	. . .
	jr nc,l067eh		;0681	30 fb		0 .
	ld a,(02100h)		;0683	3a 00 21	: . !
	cp 080h			;0686	fe 80		. .
	ret z			;0688	c8		.
	cp 083h			;0689	fe 83		. .
	jr z,l06a7h		;068b	28 1a		( .
	cp 082h			;068d	fe 82		. .
	jr z,$+11		;068f	28 09		( .
	cp 081h			;0691	fe 81		. .
	jr nz,l067eh		;0693	20 e9		  .
	call sub_06c7h		;0695	cd c7 06	. . .
	ld a,(de)		;0698	1a		.
	jr nz,l0668h		;0699	20 cd		  .
	rst 0			;069b	c7		.
	ld b,03eh		;069c	06 3e		. >
	cp a			;069e	bf		.
	in a,(0feh)		;069f	db fe		. .
	bit 0,a			;06a1	cb 47		. G
	jr nz,$-6		;06a3	20 f8		  .
	jr l06bah		;06a5	18 13		. .
l06a7h:
	call sub_06c7h		;06a7	cd c7 06	. . .
l06aah:
	rst 10h			;06aa	d7		.
	or b			;06ab	b0		.
	ld (bc),a		;06ac	02		.
	inc de			;06ad	13		.
	ld a,d			;06ae	7a		z
	or e			;06af	b3		.
	jr nz,l06aah		;06b0	20 f8		  .
l06b2h:
	call sub_0013h		;06b2	cd 13 00	. . .
	jr z,l06b2h		;06b5	28 fb		( .
	rst 10h			;06b7	d7		.
	djnz l06bah		;06b8	10 00		. .
l06bah:
	ld a,091h		;06ba	3e 91		> .
	ld (02100h),a		;06bc	32 00 21	2 . !
	ld a,(05c08h)		;06bf	3a 08 5c	: . \
	call l034dh		;06c2	cd 4d 03	. M .
	jr l067eh		;06c5	18 b7		. .
sub_06c7h:
	ld hl,02000h		;06c7	21 00 20	! .  
	call sub_03c1h		;06ca	cd c1 03	. . .
	ret			;06cd	c9		.
l06ceh:
	ld hl,(0213dh)		;06ce	2a 3d 21	* = !
	jp (hl)			;06d1	e9		.
l06d2h:
	call l067eh		;06d2	cd 7e 06	. ~ .
l06d5h:
	ld a,002h		;06d5	3e 02		> .
	rst 10h			;06d7	d7		.
	jr nc,l06ech		;06d8	30 12		0 .
	bit 7,(iy+00ch)		;06da	fd cb 0c 7e	. . . ~
	jr z,l06e3h		;06de	28 03		( .
	call sub_002dh		;06e0	cd 2d 00	. - .
l06e3h:
	ld a,(02102h)		;06e3	3a 02 21	: . !
	ld b,a			;06e6	47		G
	ld a,(05cb1h)		;06e7	3a b1 5c	: . \
	cp 002h			;06ea	fe 02		. .
l06ech:
	ld a,b			;06ec	78		x
	jr nz,l0707h		;06ed	20 18		  .
	or a			;06ef	b7		.
	jr z,l070ah		;06f0	28 18		( .
	call sub_002dh		;06f2	cd 2d 00	. - .
	call sub_002dh		;06f5	cd 2d 00	. - .
	ld hl,0210dh		;06f8	21 0d 21	! . !
	call sub_03c1h		;06fb	cd c1 03	. . .
	call sub_002dh		;06fe	cd 2d 00	. - .
	call sub_002dh		;0701	cd 2d 00	. - .
	jp l043eh		;0704	c3 3e 04	. > .
l0707h:
	ld (05cb0h),a		;0707	32 b0 5c	2 . \
l070ah:
	ld (iy+002h),0ffh	;070a	fd 36 02 ff	. 6 . .
	ld hl,01ab9h		;070e	21 b9 1a	! . .
	push hl			;0711	e5		.
	jp l0603h		;0712	c3 03 06	. . .
	ld a,(02134h)		;0715	3a 34 21	: 4 !
	or a			;0718	b7		.
	ld a,00bh		;0719	3e 0b		> .
	jr z,l0725h		;071b	28 08		( .
	call sub_0660h		;071d	cd 60 06	. ` .
	rst 8			;0720	cf		.
	ld a,(hl)		;0721	7e		~
	inc bc			;0722	03		.
	ld a,00ch		;0723	3e 0c		> .
l0725h:
	ld (02100h),a		;0725	32 00 21	2 . !
	jp l034dh		;0728	c3 4d 03	. M .
sub_072bh:
	ld a,013h		;072b	3e 13		> .
	ld (02100h),a		;072d	32 00 21	2 . !
	ld a,(02134h)		;0730	3a 34 21	: 4 !
	ld (0212eh),a		;0733	32 2e 21	2 . !
	call l034dh		;0736	cd 4d 03	. M .
l0739h:
	call 00395h		;0739	cd 95 03	. . .
	jr nc,l0739h		;073c	30 fb		0 .
	ret			;073e	c9		.
l073fh:
	ld hl,l06ceh		;073f	21 ce 06	! . .
	ex (sp),hl		;0742	e3		.
	ret			;0743	c9		.
	call sub_072bh		;0744	cd 2b 07	. + .
	jr nz,l073fh		;0747	20 f6		  .
	ld a,(02004h)		;0749	3a 04 20	: .  
	or a			;074c	b7		.
	jr z,l0771h		;074d	28 22		( "
	ld hl,(0214bh)		;074f	2a 4b 21	* K !
	ld a,h			;0752	7c		|
	or l			;0753	b5		.
	jr nz,l073fh		;0754	20 e9		  .
	call sub_077bh		;0756	cd 7b 07	. { .
	jr nc,l073fh		;0759	30 e4		0 .
	ld (0214bh),bc		;075b	ed 43 4b 21	. C K !
	ld a,c			;075f	79		y
l0760h:
	call l037eh		;0760	cd 7e 03	. ~ .
	ld c,000h		;0763	0e 00		. .
	ld a,(02134h)		;0765	3a 34 21	: 4 !
	ld b,a			;0768	47		G
	ld de,(0234bh)		;0769	ed 5b 4b 23	. [ K #
	ld a,00fh		;076d	3e 0f		> .
	jr l0725h		;076f	18 b4		. .
l0771h:
	ld a,(0200ch)		;0771	3a 0c 20	: .  
	push af			;0774	f5		.
	call sub_077bh		;0775	cd 7b 07	. { .
	pop af			;0778	f1		.
	jr l0760h		;0779	18 e5		. .
sub_077bh:
	ld hl,02000h		;077b	21 00 20	! .  
	ld b,000h		;077e	06 00		. .
l0780h:
	ld (hl),020h		;0780	36 20		6  
	inc hl			;0782	23		#
	djnz l0780h		;0783	10 fb		. .
	rst 10h			;0785	d7		.
	xor a			;0786	af		.
	cpl			;0787	2f		/
	ld a,b			;0788	78		x
	or c			;0789	b1		.
	jr nz,l078dh		;078a	20 01		  .
	ret			;078c	c9		.
l078dh:
	ld a,b			;078d	78		x
	or a			;078e	b7		.
	jr z,l0794h		;078f	28 03		( .
	ld bc,l0100h		;0791	01 00 01	. . .
l0794h:
	push bc			;0794	c5		.
	ld hl,02000h		;0795	21 00 20	! .  
	ex de,hl		;0798	eb		.
	ldir			;0799	ed b0		. .
	pop bc			;079b	c1		.
	scf			;079c	37		7
	ret			;079d	c9		.
	call sub_0644h		;079e	cd 44 06	. D .
	ld a,(hl)		;07a1	7e		~
	jr nc,l07b6h		;07a2	30 12		0 .
	cp 061h			;07a4	fe 61		. a
	jr c,l07aah		;07a6	38 02		8 .
	sub 020h		;07a8	d6 20		.  
l07aah:
	or 080h			;07aa	f6 80		. .
	ld b,a			;07ac	47		G
	inc hl			;07ad	23		#
	ld a,(hl)		;07ae	7e		~
	cp 024h			;07af	fe 24		. $
	jp nz,l043eh		;07b1	c2 3e 04	. > .
	dec hl			;07b4	2b		+
	ld a,b			;07b5	78		x
l07b6h:
	ld (02136h),a		;07b6	32 36 21	2 6 !
	ld (02149h),hl		;07b9	22 49 21	" I !
	bit 7,(hl)		;07bc	cb 7e		. ~
	jr z,l07c8h		;07be	28 08		( .
	inc hl			;07c0	23		#
	inc hl			;07c1	23		#
	inc hl			;07c2	23		#
	ld a,(hl)		;07c3	7e		~
	dec a			;07c4	3d		=
	jp nz,l043eh		;07c5	c2 3e 04	. > .
l07c8h:
	ld a,c			;07c8	79		y
	and 060h		;07c9	e6 60		. `
	cp 040h			;07cb	fe 40		. @
	jp nz,l043eh		;07cd	c2 3e 04	. > .
	call sub_018bh		;07d0	cd 8b 01	. . .
	ld b,010h		;07d3	06 10		. .
	call sub_032fh		;07d5	cd 2f 03	. / .
	ld hl,l06d5h		;07d8	21 d5 06	! . .
	push hl			;07db	e5		.
	call sub_072bh		;07dc	cd 2b 07	. + .
	ret nz			;07df	c0		.
	ld a,(02004h)		;07e0	3a 04 20	: .  
	or a			;07e3	b7		.
	ld (0ed26h),hl		;07e4	22 26 ed	" & .
	ld e,e			;07e7	5b		[
	ld c,e			;07e8	4b		K
	ld hl,l000eh		;07e9	21 0e 00	! . .
l07ech:
	call sub_0d7fh		;07ec	cd 7f 0d	. . .
	push bc			;07ef	c5		.
	call sub_0629h		;07f0	cd 29 06	. ) .
	pop bc			;07f3	c1		.
	call sub_0816h		;07f4	cd 16 08	. . .
	ld a,(02136h)		;07f7	3a 36 21	: 6 !
	and 07fh		;07fa	e6 7f		. .
	ld (hl),a		;07fc	77		w
	inc hl			;07fd	23		#
	ld (hl),c		;07fe	71		q
	inc hl			;07ff	23		#
	ld (hl),b		;0800	70		p
	inc hl			;0801	23		#
	ld de,02300h		;0802	11 00 23	. . #
	ex de,hl		;0805	eb		.
	ld a,b			;0806	78		x
	or c			;0807	b1		.
	ret z			;0808	c8		.
	ldir			;0809	ed b0		. .
	ret			;080b	c9		.
	ld de,l0000h		;080c	11 00 00	. . .
	ld a,(02155h)		;080f	3a 55 21	: U !
	dec a			;0812	3d		=
	ld c,a			;0813	4f		O
	jr l07ech		;0814	18 d6		. .
sub_0816h:
	push bc			;0816	c5		.
	ld a,c			;0817	79		y
	add a,003h		;0818	c6 03		. .
	ld c,a			;081a	4f		O
	jr nc,l081eh		;081b	30 01		0 .
	inc b			;081d	04		.
l081eh:
	ld hl,(05c59h)		;081e	2a 59 5c	* Y \
	dec hl			;0821	2b		+
	push hl			;0822	e5		.
	rst 10h			;0823	d7		.
	cp e			;0824	bb		.
	ld (de),a		;0825	12		.
	pop hl			;0826	e1		.
	pop bc			;0827	c1		.
	ret			;0828	c9		.
	ld a,00ah		;0829	3e 0a		> .
	call l0725h		;082b	cd 25 07	. % .
	ld a,(02139h)		;082e	3a 39 21	: 9 !
	or a			;0831	b7		.
	ret z			;0832	c8		.
	call sub_0e4bh		;0833	cd 4b 0e	. K .
	jp nz,l06d5h		;0836	c2 d5 06	. . .
	call sub_0660h		;0839	cd 60 06	. ` .
	call l037eh		;083c	cd 7e 03	. ~ .
	ld a,007h		;083f	3e 07		> .
	jr l084ah		;0841	18 07		. .
	ld a,009h		;0843	3e 09		> .
	jp l0725h		;0845	c3 25 07	. % .
	ld a,016h		;0848	3e 16		> .
l084ah:
	ld (02100h),a		;084a	32 00 21	2 . !
	ld a,(02134h)		;084d	3a 34 21	: 4 !
	jp l034dh		;0850	c3 4d 03	. M .
	ld a,(02134h)		;0853	3a 34 21	: 4 !
	and a			;0856	a7		.
	ld a,01fh		;0857	3e 1f		> .
	jp z,l0725h		;0859	ca 25 07	. % .
	call sub_0660h		;085c	cd 60 06	. ` .
	call l037eh		;085f	cd 7e 03	. ~ .
	ld a,020h		;0862	3e 20		>  
	jp l0725h		;0864	c3 25 07	. % .
	cp 023h			;0867	fe 23		. #
	jr z,l0882h		;0869	28 17		( .
	call sub_025eh		;086b	cd 5e 02	. ^ .
	jp nz,l043eh		;086e	c2 3e 04	. > .
	ld a,003h		;0871	3e 03		> .
l0873h:
	ld (02100h),a		;0873	32 00 21	2 . !
	ld b,00eh		;0876	06 0e		. .
	call sub_032fh		;0878	cd 2f 03	. / .
	ld hl,l06ceh		;087b	21 ce 06	! . .
	push hl			;087e	e5		.
	jp l0365h		;087f	c3 65 03	. e .
l0882h:
	rst 10h			;0882	d7		.
	jr nz,l0885h		;0883	20 00		  .
l0885h:
	call sub_025eh		;0885	cd 5e 02	. ^ .
	jr nz,l088eh		;0888	20 04		  .
	ld a,00eh		;088a	3e 0e		> .
	jr l0873h		;088c	18 e5		. .
l088eh:
	call sub_0222h		;088e	cd 22 02	. " .
	jp z,l0440h		;0891	ca 40 04	. @ .
	bit 7,(iy+001h)		;0894	fd cb 01 7e	. . . ~
	jr z,l0873h		;0898	28 d9		( .
	call sub_023eh		;089a	cd 3e 02	. > .
	ld (02104h),a		;089d	32 04 21	2 . !
	ld a,00dh		;08a0	3e 0d		> .
	jr l0873h		;08a2	18 cf		. .
	call sub_0660h		;08a4	cd 60 06	. ` .
	call l037eh		;08a7	cd 7e 03	. ~ .
	ld a,004h		;08aa	3e 04		> .
	jp l084ah		;08ac	c3 4a 08	. J .
	call sub_0660h		;08af	cd 60 06	. ` .
	call l037eh		;08b2	cd 7e 03	. ~ .
	ld a,002h		;08b5	3e 02		> .
	ld (02100h),a		;08b7	32 00 21	2 . !
	xor a			;08ba	af		.
	jp l034dh		;08bb	c3 4d 03	. M .
	ld a,(02134h)		;08be	3a 34 21	: 4 !
	cp 082h			;08c1	fe 82		. .
	jr nc,l08cah		;08c3	30 05		0 .
	ld a,001h		;08c5	3e 01		> .
	jp l084ah		;08c7	c3 4a 08	. J .
l08cah:
	ld a,01dh		;08ca	3e 1d		> .
	ld a,(de)		;08cc	1a		.
	ld sp,hl		;08cd	f9		.
	ld a,(02136h)		;08ce	3a 36 21	: 6 !
	ld d,000h		;08d1	16 00		. .
	cp 049h			;08d3	fe 49		. I
	jr nz,l08dbh		;08d5	20 04		  .
	set 0,d			;08d7	cb c2		. .
	jr l08f2h		;08d9	18 17		. .
l08dbh:
	cp 04fh			;08db	fe 4f		. O
	jr nz,l08e3h		;08dd	20 04		  .
	set 1,d			;08df	cb ca		. .
	jr l08f2h		;08e1	18 0f		. .
l08e3h:
	cp 052h			;08e3	fe 52		. R
	jr nz,l08edh		;08e5	20 06		  .
	set 0,d			;08e7	cb c2		. .
	set 1,d			;08e9	cb ca		. .
	jr l08f2h		;08eb	18 05		. .
l08edh:
	cp 041h			;08ed	fe 41		. A
	jp nz,l043eh		;08ef	c2 3e 04	. > .
l08f2h:
	ld a,d			;08f2	7a		z
	ld (02136h),a		;08f3	32 36 21	2 6 !
	rst 10h			;08f6	d7		.
	xor a			;08f7	af		.
	cpl			;08f8	2f		/
	call sub_0663h		;08f9	cd 63 06	. c .
	call l037eh		;08fc	cd 7e 03	. ~ .
	ld e,001h		;08ff	1e 01		. .
	ld a,(0213ah)		;0901	3a 3a 21	: : !
	bit 3,a			;0904	cb 5f		. _
	jr z,l090dh		;0906	28 05		( .
	dec e			;0908	1d		.
	ld ix,(0214bh)		;0909	dd 2a 4b 21	. * K !
l090dh:
	ld a,(02136h)		;090d	3a 36 21	: 6 !
	ld d,a			;0910	57		W
	ld a,000h		;0911	3e 00		> .
	jp l084ah		;0913	c3 4a 08	. J .
	ld hl,01720h		;0916	21 20 17	!   .
	ld (05c82h),hl		;0919	22 82 5c	" . \
	ld hl,050e0h		;091c	21 e0 50	! . P
	ld (05c86h),hl		;091f	22 86 5c	" . \
	ld hl,01721h		;0922	21 21 17	! ! .
	ld (05c8ah),hl		;0925	22 8a 5c	" . \
	ld a,006h		;0928	3e 06		> .
l092ah:
	ld (02100h),a		;092a	32 00 21	2 . !
	rst 10h			;092d	d7		.
	xor a			;092e	af		.
	cpl			;092f	2f		/
	ld hl,02080h		;0930	21 80 20	! .  
	push bc			;0933	c5		.
	push hl			;0934	e5		.
	call sub_0666h		;0935	cd 66 06	. f .
	call sub_0660h		;0938	cd 60 06	. ` .
	ex de,hl		;093b	eb		.
	pop hl			;093c	e1		.
	pop bc			;093d	c1		.
	add a,c			;093e	81		.
	inc a			;093f	3c		<
	ldir			;0940	ed b0		. .
	ex de,hl		;0942	eb		.
	ld (hl),002h		;0943	36 02		6 .
	call l037eh		;0945	cd 7e 03	. ~ .
	ld a,(02102h)		;0948	3a 02 21	: . !
	jp l034dh		;094b	c3 4d 03	. M .
	ld a,005h		;094e	3e 05		> .
	jr l092ah		;0950	18 d8		. .
	call sub_0222h		;0952	cd 22 02	. " .
	jr nz,l0970h		;0955	20 19		  .
	ld hl,(05c5dh)		;0957	2a 5d 5c	* ] \
	ld a,(hl)		;095a	7e		~
	ld (02133h),a		;095b	32 33 21	2 3 !
	cp 0cah			;095e	fe ca		. .
	jr z,l0973h		;0960	28 11		( .
	cp 0afh			;0962	fe af		. .
	jr z,l097fh		;0964	28 19		( .
	cp 0aah			;0966	fe aa		. .
	jr z,l099bh		;0968	28 31		( 1
	cp 0e4h			;096a	fe e4		. .
	jr z,$+54		;096c	28 34		( 4
	jr l09c0h		;096e	18 50		. P
l0970h:
	jp l043eh		;0970	c3 3e 04	. > .
l0973h:
	rst 10h			;0973	d7		.
	jr nz,l0976h		;0974	20 00		  .
l0976h:
	call sub_0222h		;0976	cd 22 02	. " .
	jr z,l0970h		;0979	28 f5		( .
	ld a,002h		;097b	3e 02		> .
	jr l09c0h		;097d	18 41		. A
l097fh:
	rst 10h			;097f	d7		.
	jr nz,l0982h		;0980	20 00		  .
l0982h:
	call sub_0222h		;0982	cd 22 02	. " .
	jr z,l0970h		;0985	28 e9		( .
	ld hl,(05c5dh)		;0987	2a 5d 5c	* ] \
	ld a,(hl)		;098a	7e		~
	cp 02ch			;098b	fe 2c		. ,
	jr nz,l0970h		;098d	20 e1		  .
	rst 10h			;098f	d7		.
	jr nz,l0992h		;0990	20 00		  .
l0992h:
	call sub_0222h		;0992	cd 22 02	. " .
	jr z,l0970h		;0995	28 d9		( .
	ld a,003h		;0997	3e 03		> .
	jr l09c0h		;0999	18 25		. %
l099bh:
	rst 10h			;099b	d7		.
	jr nz,l099eh		;099c	20 00		  .
l099eh:
	ld a,004h		;099e	3e 04		> .
	ld a,(de)		;09a0	1a		.
	ld e,0d7h		;09a1	1e d7		. .
	jr nz,l09a5h		;09a3	20 00		  .
l09a5h:
	call sub_0644h		;09a5	cd 44 06	. D .
	jr c,l0970h		;09a8	38 c6		8 .
	ld a,c			;09aa	79		y
	and 060h		;09ab	e6 60		. `
	jr z,l09b3h		;09ad	28 04		( .
	cp 040h			;09af	fe 40		. @
	jr nz,l0970h		;09b1	20 bd		  .
l09b3h:
	ld (02145h),hl		;09b3	22 45 21	" E !
	ld hl,(05c5dh)		;09b6	2a 5d 5c	* ] \
	inc hl			;09b9	23		#
	inc hl			;09ba	23		#
	ld (05c5dh),hl		;09bb	22 5d 5c	" ] \
	ld a,005h		;09be	3e 05		> .
l09c0h:
	ld (02133h),a		;09c0	32 33 21	2 3 !
	ld hl,(05c5dh)		;09c3	2a 5d 5c	* ] \
	jp l01d0h		;09c6	c3 d0 01	. . .
	ld hl,l06d5h		;09c9	21 d5 06	! . .
	ex (sp),hl		;09cc	e3		.
	ld a,(02133h)		;09cd	3a 33 21	: 3 !
	cp 005h			;09d0	fe 05		. .
	jp z,l0a22h		;09d2	ca 22 0a	. " .
	cp 004h			;09d5	fe 04		. .
	jp z,l0a18h		;09d7	ca 18 0a	. . .
	cp 003h			;09da	fe 03		. .
	jp z,l0a03h		;09dc	ca 03 0a	. . .
	cp 002h			;09df	fe 02		. .
	jp z,l09fdh		;09e1	ca fd 09	. . .
	ld hl,l0200h		;09e4	21 00 02	! . .
	push hl			;09e7	e5		.
l09e8h:
	call sub_0660h		;09e8	cd 60 06	. ` .
	ex af,af'		;09eb	08		.
	ld hl,(05c53h)		;09ec	2a 53 5c	* S \
	ex de,hl		;09ef	eb		.
	ld hl,(05c59h)		;09f0	2a 59 5c	* Y \
	scf			;09f3	37		7
	sbc hl,de		;09f4	ed 52		. R
	ld b,h			;09f6	44		D
	ld c,l			;09f7	4d		M
	pop hl			;09f8	e1		.
	ld a,000h		;09f9	3e 00		> .
	jr l0a3ch		;09fb	18 3f		. ?
l09fdh:
	call sub_0246h		;09fd	cd 46 02	. F .
	push bc			;0a00	c5		.
	jr l09e8h		;0a01	18 e5		. .
l0a03h:
	call sub_0246h		;0a03	cd 46 02	. F .
	push bc			;0a06	c5		.
	call sub_0246h		;0a07	cd 46 02	. F .
	push bc			;0a0a	c5		.
l0a0bh:
	call sub_0660h		;0a0b	cd 60 06	. ` .
	ex af,af'		;0a0e	08		.
	pop de			;0a0f	d1		.
	pop bc			;0a10	c1		.
	ld hl,l0000h		;0a11	21 00 00	! . .
	ld a,003h		;0a14	3e 03		> .
	jr l0a3ch		;0a16	18 24		. $
l0a18h:
	ld hl,01b00h		;0a18	21 00 1b	! . .
	push hl			;0a1b	e5		.
	ld hl,04000h		;0a1c	21 00 40	! . @
	push hl			;0a1f	e5		.
	jr l0a0bh		;0a20	18 e9		. .
l0a22h:
	call sub_0660h		;0a22	cd 60 06	. ` .
	ex af,af'		;0a25	08		.
	ld hl,(02145h)		;0a26	2a 45 21	* E !
	bit 6,(hl)		;0a29	cb 76		. v
	ld a,001h		;0a2b	3e 01		> .
	jr z,l0a31h		;0a2d	28 02		( .
	ld a,002h		;0a2f	3e 02		> .
l0a31h:
	inc hl			;0a31	23		#
	ld c,(hl)		;0a32	4e		N
	inc hl			;0a33	23		#
	ld b,(hl)		;0a34	46		F
	dec hl			;0a35	2b		+
	inc bc			;0a36	03		.
	inc bc			;0a37	03		.
	ex de,hl		;0a38	eb		.
	ld hl,l0000h		;0a39	21 00 00	! . .
l0a3ch:
	push hl			;0a3c	e5		.
	push de			;0a3d	d5		.
	push bc			;0a3e	c5		.
	push af			;0a3f	f5		.
	ld (02147h),de		;0a40	ed 53 47 21	. S G !
	ld (02145h),bc		;0a44	ed 43 45 21	. C E !
	ld a,012h		;0a48	3e 12		> .
	ld (02100h),a		;0a4a	32 00 21	2 . !
	call l034dh		;0a4d	cd 4d 03	. M .
	call sub_0e4bh		;0a50	cd 4b 0e	. K .
	jr nz,l0aa2h		;0a53	20 4d		  M
	ld a,(02104h)		;0a55	3a 04 21	: . !
	ld (0212eh),a		;0a58	32 2e 21	2 . !
	ex af,af'		;0a5b	08		.
	call l037eh		;0a5c	cd 7e 03	. ~ .
	ld a,002h		;0a5f	3e 02		> .
	ld (02100h),a		;0a61	32 00 21	2 . !
	ld a,001h		;0a64	3e 01		> .
	call sub_0b25h		;0a66	cd 25 0b	. % .
	jr z,l0ab0h		;0a69	28 45		( E
	cp 023h			;0a6b	fe 23		. #
	jr z,l0ab0h		;0a6d	28 41		( A
	cp 020h			;0a6f	fe 20		.  
	jr z,l0ab0h		;0a71	28 3d		( =
	cp 023h			;0a73	fe 23		. #
	jr nz,l0aa2h		;0a75	20 2b		  +
	ld a,(02134h)		;0a77	3a 34 21	: 4 !
	and a			;0a7a	a7		.
	jr nz,l0aa8h		;0a7b	20 2b		  +
	ld hl,0210dh		;0a7d	21 0d 21	! . !
	push hl			;0a80	e5		.
	call sub_03c1h		;0a81	cd c1 03	. . .
	ld a,081h		;0a84	3e 81		> .
	ld (02102h),a		;0a86	32 02 21	2 . !
	call sub_03f7h		;0a89	cd f7 03	. . .
	pop hl			;0a8c	e1		.
	call sub_03c1h		;0a8d	cd c1 03	. . .
l0a90h:
	call sub_0013h		;0a90	cd 13 00	. . .
	cp 059h			;0a93	fe 59		. Y
	jr z,l0aa5h		;0a95	28 0e		( .
	cp 04eh			;0a97	fe 4e		. N
	jr nz,l0a90h		;0a99	20 f5		  .
	rst 10h			;0a9b	d7		.
	djnz l0a9eh		;0a9c	10 00		. .
l0a9eh:
	xor a			;0a9e	af		.
	ld (02102h),a		;0a9f	32 02 21	2 . !
l0aa2h:
	jp l0b0dh		;0aa2	c3 0d 0b	. . .
l0aa5h:
	rst 10h			;0aa5	d7		.
	djnz l0aa8h		;0aa6	10 00		. .
l0aa8h:
	call sub_0b16h		;0aa8	cd 16 0b	. . .
	call z,sub_0b1dh	;0aab	cc 1d 0b	. . .
	jr nz,l0aa2h		;0aae	20 f2		  .
l0ab0h:
	call sub_0b16h		;0ab0	cd 16 0b	. . .
	jr nz,l0aa2h		;0ab3	20 ed		  .
	pop af			;0ab5	f1		.
	pop bc			;0ab6	c1		.
	pop de			;0ab7	d1		.
	pop hl			;0ab8	e1		.
	push hl			;0ab9	e5		.
	push de			;0aba	d5		.
	push bc			;0abb	c5		.
	push af			;0abc	f5		.
	ld (02000h),a		;0abd	32 00 20	2 .  
	cp 000h			;0ac0	fe 00		. .
	jr nz,l0ad8h		;0ac2	20 14		  .
	ld (02001h),hl		;0ac4	22 01 20	" .  
	ld hl,(05c4bh)		;0ac7	2a 4b 5c	* K \
	and a			;0aca	a7		.
	sbc hl,de		;0acb	ed 52		. R
	ld (02005h),hl		;0acd	22 05 20	" .  
	ld (02003h),bc		;0ad0	ed 43 03 20	. C .  
	ld a,007h		;0ad4	3e 07		> .
	jr l0ae2h		;0ad6	18 0a		. .
l0ad8h:
	ld (02001h),bc		;0ad8	ed 43 01 20	. C .  
	ld (02003h),de		;0adc	ed 53 03 20	. S .  
	ld a,005h		;0ae0	3e 05		> .
l0ae2h:
	ld (0212dh),a		;0ae2	32 2d 21	2 - !
	call l037eh		;0ae5	cd 7e 03	. ~ .
	ld a,(0212eh)		;0ae8	3a 2e 21	: . !
	ld b,a			;0aeb	47		G
	ld c,000h		;0aec	0e 00		. .
	ld d,c			;0aee	51		Q
	ld a,(0212dh)		;0aef	3a 2d 21	: - !
	ld e,a			;0af2	5f		_
	ld a,00fh		;0af3	3e 0f		> .
	ld (02100h),a		;0af5	32 00 21	2 . !
	call sub_0b25h		;0af8	cd 25 0b	. % .
	jr nz,l0b03h		;0afb	20 06		  .
	call l0b2bh		;0afd	cd 2b 0b	. + .
	jr nz,l0b03h		;0b00	20 01		  .
	xor a			;0b02	af		.
l0b03h:
	push af			;0b03	f5		.
	call sub_0b1dh		;0b04	cd 1d 0b	. . .
	jr z,l0b0ch		;0b07	28 03		( .
	pop hl			;0b09	e1		.
	jr l0b0dh		;0b0a	18 01		. .
l0b0ch:
	pop af			;0b0c	f1		.
l0b0dh:
	or a			;0b0d	b7		.
	call sub_03f7h		;0b0e	cd f7 03	. . .
	pop af			;0b11	f1		.
	pop bc			;0b12	c1		.
	pop de			;0b13	d1		.
	pop hl			;0b14	e1		.
	ret			;0b15	c9		.
sub_0b16h:
	ld de,l0200h+1		;0b16	11 01 02	. . .
sub_0b19h:
	ld a,000h		;0b19	3e 00		> .
	jr l0b1fh		;0b1b	18 02		. .
sub_0b1dh:
	ld a,001h		;0b1d	3e 01		> .
l0b1fh:
	ld (02100h),a		;0b1f	32 00 21	2 . !
	ld a,(0212eh)		;0b22	3a 2e 21	: . !
sub_0b25h:
	call l034dh		;0b25	cd 4d 03	. M .
	jp sub_0e4bh		;0b28	c3 4b 0e	. K .
l0b2bh:
	push bc			;0b2b	c5		.
	push de			;0b2c	d5		.
	push hl			;0b2d	e5		.
l0b2eh:
	ld hl,(02145h)		;0b2e	2a 45 21	* E !
	ld bc,l0100h		;0b31	01 00 01	. . .
	or a			;0b34	b7		.
	sbc hl,bc		;0b35	ed 42		. B
	jr nc,l0b45h		;0b37	30 0c		0 .
	ld hl,(02145h)		;0b39	2a 45 21	* E !
	ld a,h			;0b3c	7c		|
	or l			;0b3d	b5		.
	jr z,l0b79h		;0b3e	28 39		( 9
	ld c,l			;0b40	4d		M
	ld b,h			;0b41	44		D
	ld hl,l0000h		;0b42	21 00 00	! . .
l0b45h:
	ld (02145h),hl		;0b45	22 45 21	" E !
	ld de,02000h		;0b48	11 00 20	. .  
	ld hl,(02147h)		;0b4b	2a 47 21	* G !
	push bc			;0b4e	c5		.
	ldir			;0b4f	ed b0		. .
	ld (02147h),hl		;0b51	22 47 21	" G !
	pop bc			;0b54	c1		.
	ld a,c			;0b55	79		y
	push bc			;0b56	c5		.
	call l037eh		;0b57	cd 7e 03	. ~ .
	pop de			;0b5a	d1		.
	jr nz,l0b76h		;0b5b	20 19		  .
	ld a,(0212eh)		;0b5d	3a 2e 21	: . !
	ld b,a			;0b60	47		G
	ld c,000h		;0b61	0e 00		. .
	ld a,00fh		;0b63	3e 0f		> .
	ld (02100h),a		;0b65	32 00 21	2 . !
	call l034dh		;0b68	cd 4d 03	. M .
	jr nz,l0b76h		;0b6b	20 09		  .
	call sub_0e4bh		;0b6d	cd 4b 0e	. K .
	jr c,l0b76h		;0b70	38 04		8 .
	jr nz,l0b7ah		;0b72	20 06		  .
	jr l0b2eh		;0b74	18 b8		. .
l0b76h:
	scf			;0b76	37		7
	jr l0b7bh		;0b77	18 02		. .
l0b79h:
	xor a			;0b79	af		.
l0b7ah:
	or a			;0b7a	b7		.
l0b7bh:
	pop hl			;0b7b	e1		.
	pop de			;0b7c	d1		.
	pop bc			;0b7d	c1		.
	ret			;0b7e	c9		.
	call sub_0222h		;0b7f	cd 22 02	. " .
	jr nz,l0b9bh		;0b82	20 17		  .
	ld hl,(05c5dh)		;0b84	2a 5d 5c	* ] \
	ld a,(hl)		;0b87	7e		~
	ld (02133h),a		;0b88	32 33 21	2 3 !
	call sub_025eh		;0b8b	cd 5e 02	. ^ .
	ret z			;0b8e	c8		.
	cp 0afh			;0b8f	fe af		. .
	jr z,l0b9eh		;0b91	28 0b		( .
	cp 0aah			;0b93	fe aa		. .
	jr z,l0bc7h		;0b95	28 30		( 0
	cp 0e4h			;0b97	fe e4		. .
	jr z,l0bceh		;0b99	28 33		( 3
l0b9bh:
	jp l043eh		;0b9b	c3 3e 04	. > .
l0b9eh:
	rst 10h			;0b9e	d7		.
	jr nz,l0ba1h		;0b9f	20 00		  .
l0ba1h:
	call sub_025eh		;0ba1	cd 5e 02	. ^ .
	jr z,l0bb7h		;0ba4	28 11		( .
	call sub_0222h		;0ba6	cd 22 02	. " .
	jr z,l0b9bh		;0ba9	28 f0		( .
	ld hl,(05c5dh)		;0bab	2a 5d 5c	* ] \
	ld a,(hl)		;0bae	7e		~
	cp 02ch			;0baf	fe 2c		. ,
	jr z,l0bbbh		;0bb1	28 08		( .
	ld a,002h		;0bb3	3e 02		> .
	jr l0c04h		;0bb5	18 4d		. M
l0bb7h:
	ld a,015h		;0bb7	3e 15		> .
	jr l0c04h		;0bb9	18 49		. I
l0bbbh:
	rst 10h			;0bbb	d7		.
	jr nz,l0bbeh		;0bbc	20 00		  .
l0bbeh:
	call sub_0222h		;0bbe	cd 22 02	. " .
	jr z,l0b9bh		;0bc1	28 d8		( .
	ld a,016h		;0bc3	3e 16		> .
	jr l0c04h		;0bc5	18 3d		. =
l0bc7h:
	rst 10h			;0bc7	d7		.
	jr nz,l0bcah		;0bc8	20 00		  .
l0bcah:
	ld a,003h		;0bca	3e 03		> .
	jr l0c04h		;0bcc	18 36		. 6
l0bceh:
	rst 10h			;0bce	d7		.
	jr nz,l0bd1h		;0bcf	20 00		  .
l0bd1h:
	call sub_0644h		;0bd1	cd 44 06	. D .
	ld (0214eh),hl		;0bd4	22 4e 21	" N !
	ld a,000h		;0bd7	3e 00		> .
	jr c,l0bddh		;0bd9	38 02		8 .
	ld a,080h		;0bdb	3e 80		> .
l0bddh:
	ld (02139h),a		;0bdd	32 39 21	2 9 !
	ld a,c			;0be0	79		y
	set 7,a			;0be1	cb ff		. .
	ld (02136h),a		;0be3	32 36 21	2 6 !
	and 060h		;0be6	e6 60		. `
	jr z,l0bf5h		;0be8	28 0b		( .
	cp 040h			;0bea	fe 40		. @
	jr z,l0bf1h		;0bec	28 03		( .
	pop af			;0bee	f1		.
	jr l0b9bh		;0bef	18 aa		. .
l0bf1h:
	ld a,002h		;0bf1	3e 02		> .
	jr l0bf7h		;0bf3	18 02		. .
l0bf5h:
	ld a,001h		;0bf5	3e 01		> .
l0bf7h:
	ld (02134h),a		;0bf7	32 34 21	2 4 !
	ld hl,(05c5dh)		;0bfa	2a 5d 5c	* ] \
	inc hl			;0bfd	23		#
	inc hl			;0bfe	23		#
	ld (05c5dh),hl		;0bff	22 5d 5c	" ] \
	ld a,004h		;0c02	3e 04		> .
l0c04h:
	ld (02133h),a		;0c04	32 33 21	2 3 !
	ret			;0c07	c9		.
	ld hl,l06d5h		;0c08	21 d5 06	! . .
	ex (sp),hl		;0c0b	e3		.
	ld a,(02133h)		;0c0c	3a 33 21	: 3 !
	cp 004h			;0c0f	fe 04		. .
	jr z,$+90		;0c11	28 58		( X
	cp 003h			;0c13	fe 03		. .
	jr z,l0c5dh		;0c15	28 46		( F
	cp 016h			;0c17	fe 16		. .
	jr z,l0c4dh		;0c19	28 32		( 2
	cp 015h			;0c1b	fe 15		. .
	jr z,l0c3fh		;0c1d	28 20		(  
	cp 002h			;0c1f	fe 02		. .
	jr z,$+8		;0c21	28 06		( .
sub_0c23h:
	ld a,000h		;0c23	3e 00		> .
	jr l0c37h		;0c25	18 10		. .
	call sub_0246h		;0c27	cd 46 02	. F .
	ld (02150h),bc		;0c2a	ed 43 50 21	. C P !
	ld bc,l0000h		;0c2e	01 00 00	. . .
	ld (0214eh),bc		;0c31	ed 43 4e 21	. C N !
l0c35h:
	ld a,003h		;0c35	3e 03		> .
l0c37h:
	ld (0214dh),a		;0c37	32 4d 21	2 M !
	call sub_0660h		;0c3a	cd 60 06	. ` .
	jr l0cach		;0c3d	18 6d		. m
l0c3fh:
	ld hl,0ffffh		;0c3f	21 ff ff	! . .
	ld (0214eh),hl		;0c42	22 4e 21	" N !
	ld hl,l0000h		;0c45	21 00 00	! . .
	ld (02150h),hl		;0c48	22 50 21	" P !
	jr l0c35h		;0c4b	18 e8		. .
l0c4dh:
	call sub_0246h		;0c4d	cd 46 02	. F .
	ld (0214eh),bc		;0c50	ed 43 4e 21	. C N !
	call sub_0246h		;0c54	cd 46 02	. F .
	ld (02150h),bc		;0c57	ed 43 50 21	. C P !
	jr l0c35h		;0c5b	18 d8		. .
l0c5dh:
	ld hl,01b00h		;0c5d	21 00 1b	! . .
	ld (0214eh),hl		;0c60	22 4e 21	" N !
	ld hl,04000h		;0c63	21 00 40	! . @
	ld (02150h),hl		;0c66	22 50 21	" P !
	rra			;0c69	1f		.
	jp z,0343ah		;0c6a	ca 3a 34	. : 4
	ld hl,04d32h		;0c6d	21 32 4d	! 2 M
	ld hl,060cdh		;0c70	21 cd 60	! . `
	ld b,018h		;0c73	06 18		. .
	ld (hl),03eh		;0c75	36 3e		6 >
	add a,b			;0c77	80		.
	ld (02138h),a		;0c78	32 38 21	2 8 !
	ld hl,l06d5h		;0c7b	21 d5 06	! . .
	ex (sp),hl		;0c7e	e3		.
	call sub_0c23h		;0c7f	cd 23 0c	. # .
	ld a,(02102h)		;0c82	3a 02 21	: . !
	or a			;0c85	b7		.
	ret nz			;0c86	c0		.
	ld de,06830h		;0c87	11 30 68	. 0 h
	ld hl,l0c9ah		;0c8a	21 9a 0c	! . .
	ld bc,00012h		;0c8d	01 12 00	. . .
	ldir			;0c90	ed b0		. .
	ld de,(0214bh)		;0c92	ed 5b 4b 21	. [ K !
	rst 10h			;0c96	d7		.
	jr nc,$+106		;0c97	30 68		0 h
	ret			;0c99	c9		.
l0c9ah:
	ld hl,00713h		;0c9a	21 13 07	! . .
	push hl			;0c9d	e5		.
	ld hl,0fefeh		;0c9e	21 fe fe	! . .
	push hl			;0ca1	e5		.
	ld hl,l0000h		;0ca2	21 00 00	! . .
	push hl			;0ca5	e5		.
	push hl			;0ca6	e5		.
	ex de,hl		;0ca7	eb		.
	call 065d0h		;0ca8	cd d0 65	. . e
	ret			;0cab	c9		.
l0cach:
	ld ix,0214dh		;0cac	dd 21 4d 21	. ! M !
	ld a,012h		;0cb0	3e 12		> .
	ld (02100h),a		;0cb2	32 00 21	2 . !
	call sub_0b25h		;0cb5	cd 25 0b	. % .
	jp nz,l0d7ch		;0cb8	c2 7c 0d	. | .
	ld a,(02104h)		;0cbb	3a 04 21	: . !
	ld (0212eh),a		;0cbe	32 2e 21	2 . !
	ld a,b			;0cc1	78		x
	call l037eh		;0cc2	cd 7e 03	. ~ .
	ld de,l0100h+1		;0cc5	11 01 01	. . .
	call sub_0b19h		;0cc8	cd 19 0b	. . .
	jp nz,l0d7ch		;0ccb	c2 7c 0d	. | .
	ld de,l0001h		;0cce	11 01 00	. . .
	call sub_0d7fh		;0cd1	cd 7f 0d	. . .
	jp nz,l0d6fh		;0cd4	c2 6f 0d	. o .
	ld a,(hl)		;0cd7	7e		~
	cp (ix+000h)		;0cd8	dd be 00	. . .
	jr nz,l0ce5h		;0cdb	20 08		  .
	cp 000h			;0cdd	fe 00		. .
	jr z,l0ceah		;0cdf	28 09		( .
	cp 004h			;0ce1	fe 04		. .
	jr c,l0cefh		;0ce3	38 0a		8 .
l0ce5h:
	ld a,04bh		;0ce5	3e 4b		> K
	jp l0d6fh		;0ce7	c3 6f 0d	. o .
l0ceah:
	ld de,l0006h		;0cea	11 06 00	. . .
	jr l0cf2h		;0ced	18 03		. .
l0cefh:
	ld de,l0004h		;0cef	11 04 00	. . .
l0cf2h:
	ld a,e			;0cf2	7b		{
	ld (0212dh),a		;0cf3	32 2d 21	2 - !
	call sub_0d7fh		;0cf6	cd 7f 0d	. . .
	jr nz,l0d6fh		;0cf9	20 74		  t
	ld a,(ix+000h)		;0cfb	dd 7e 00	. ~ .
sub_0cfeh:
	cp 000h			;0cfe	fe 00		. .
	jr z,l0d0ch		;0d00	28 0a		( .
	cp 003h			;0d02	fe 03		. .
	jr z,l0d44h		;0d04	28 3e		( >
	jr c,l0d26h		;0d06	38 1e		8 .
	ld a,04bh		;0d08	3e 4b		> K
	jr l0d6fh		;0d0a	18 63		. c
l0d0ch:
	push ix			;0d0c	dd e5		. .
	pop de			;0d0e	d1		.
	inc de			;0d0f	13		.
	ld bc,l0006h		;0d10	01 06 00	. . .
	ldir			;0d13	ed b0		. .
	call sub_0dech		;0d15	cd ec 0d	. . .
	or a			;0d18	b7		.
	jr nz,l0d6fh		;0d19	20 54		  T
	ld l,(ix+003h)		;0d1b	dd 6e 03	. n .
	ld h,(ix+006h)		;0d1e	dd 66 06	. f .
	ld (02145h),hl		;0d21	22 45 21	" E !
	jr l0d6ch		;0d24	18 46		. F
l0d26h:
	ld hl,(0214eh)		;0d26	2a 4e 21	* N !
	ld a,(02139h)		;0d29	3a 39 21	: 9 !
	or a			;0d2c	b7		.
	call nz,00632h		;0d2d	c4 32 06	. 2 .
	ld hl,(02000h)		;0d30	2a 00 20	* .  
	ld (02145h),hl		;0d33	22 45 21	" E !
	ld c,l			;0d36	4d		M
	ld b,h			;0d37	44		D
	dec bc			;0d38	0b		.
	dec bc			;0d39	0b		.
	call sub_0816h		;0d3a	cd 16 08	. . .
	ld a,(02136h)		;0d3d	3a 36 21	: 6 !
	ld (hl),a		;0d40	77		w
	inc hl			;0d41	23		#
	jr l0d69h		;0d42	18 25		. %
l0d44h:
	ld e,(ix+001h)		;0d44	dd 5e 01	. ^ .
	ld d,(ix+002h)		;0d47	dd 56 02	. V .
	ld hl,(02000h)		;0d4a	2a 00 20	* .  
	ld (02145h),hl		;0d4d	22 45 21	" E !
	ld a,e			;0d50	7b		{
	or d			;0d51	b2		.
	jr z,l0d5ch		;0d52	28 08		( .
	sbc hl,de		;0d54	ed 52		. R
	jr c,l0d5ch		;0d56	38 04		8 .
	ld (02145h),de		;0d58	ed 53 45 21	. S E !
l0d5ch:
	ld l,(ix+003h)		;0d5c	dd 6e 03	. n .
	ld h,(ix+004h)		;0d5f	dd 66 04	. f .
	ld a,l			;0d62	7d		}
	or h			;0d63	b4		.
	jr nz,l0d69h		;0d64	20 03		  .
	ld hl,(02002h)		;0d66	2a 02 20	* .  
l0d69h:
	ld (02147h),hl		;0d69	22 47 21	" G !
l0d6ch:
	call l0daah		;0d6c	cd aa 0d	. . .
l0d6fh:
	push af			;0d6f	f5		.
	call sub_0b1dh		;0d70	cd 1d 0b	. . .
	jr nz,l0d7bh		;0d73	20 06		  .
	pop af			;0d75	f1		.
	ld (02102h),a		;0d76	32 02 21	2 . !
	jr l0d7ch		;0d79	18 01		. .
l0d7bh:
	pop hl			;0d7b	e1		.
l0d7ch:
	jp sub_03f7h		;0d7c	c3 f7 03	. . .
sub_0d7fh:
	push de			;0d7f	d5		.
	ld a,(0212eh)		;0d80	3a 2e 21	: . !
	ld b,a			;0d83	47		G
	ld a,010h		;0d84	3e 10		> .
	ld (02100h),a		;0d86	32 00 21	2 . !
	call l034dh		;0d89	cd 4d 03	. M .
	jr nz,l0da7h		;0d8c	20 19		  .
l0d8eh:
	call 00395h		;0d8e	cd 95 03	. . .
	jr nc,l0d8eh		;0d91	30 fb		0 .
	ld a,(02100h)		;0d93	3a 00 21	: . !
	cp 080h			;0d96	fe 80		. .
	jr nz,l0da7h		;0d98	20 0d		  .
	ld a,(02102h)		;0d9a	3a 02 21	: . !
	ld bc,(02105h)		;0d9d	ed 4b 05 21	. K . !
	ld hl,02000h		;0da1	21 00 20	! .  
	or a			;0da4	b7		.
	pop de			;0da5	d1		.
	ret			;0da6	c9		.
l0da7h:
	scf			;0da7	37		7
	pop de			;0da8	d1		.
	ret			;0da9	c9		.
l0daah:
	push bc			;0daa	c5		.
	push de			;0dab	d5		.
	push hl			;0dac	e5		.
l0dadh:
	dec hl			;0dad	2b		+
	ld b,l			;0dae	45		E
	ld hl,00011h		;0daf	21 11 00	! . .
	ld bc,0edb7h		;0db2	01 b7 ed	. . .
	ld d,d			;0db5	52		R
	jr nc,l0dc3h		;0db6	30 0b		0 .
	ld hl,(02145h)		;0db8	2a 45 21	* E !
	ld a,l			;0dbb	7d		}
	or h			;0dbc	b4		.
	jr z,l0de3h		;0dbd	28 24		( $
	ex de,hl		;0dbf	eb		.
	ld hl,l0200h		;0dc0	21 00 02	! . .
l0dc3h:
	ld (02145h),hl		;0dc3	22 45 21	" E !
	call sub_0d7fh		;0dc6	cd 7f 0d	. . .
	jr c,l0de8h		;0dc9	38 1d		8 .
	jr z,l0dd1h		;0dcb	28 04		( .
	cp 048h			;0dcd	fe 48		. H
	jr nz,l0de7h		;0dcf	20 16		  .
l0dd1h:
	push af			;0dd1	f5		.
	ld a,b			;0dd2	78		x
	or c			;0dd3	b1		.
	jr z,l0de6h		;0dd4	28 10		( .
	ld de,(02147h)		;0dd6	ed 5b 47 21	. [ G !
	ldir			;0dda	ed b0		. .
	ld (02147h),de		;0ddc	ed 53 47 21	. S G !
	pop af			;0de0	f1		.
	jr l0dadh		;0de1	18 ca		. .
l0de3h:
	xor a			;0de3	af		.
	jr l0de8h		;0de4	18 02		. .
l0de6h:
	pop af			;0de6	f1		.
l0de7h:
	or a			;0de7	b7		.
l0de8h:
	pop hl			;0de8	e1		.
	pop de			;0de9	d1		.
	pop bc			;0dea	c1		.
	ret			;0deb	c9		.
sub_0dech:
	ld a,(02138h)		;0dec	3a 38 21	: 8 !
	or a			;0def	b7		.
	jr nz,$+69		;0df0	20 43		  C
	push ix			;0df2	dd e5		. .
	ld de,(05c53h)		;0df4	ed 5b 53 5c	. [ S \
	ld hl,(05c59h)		;0df8	2a 59 5c	* Y \
	dec hl			;0dfb	2b		+
	ld c,(ix+003h)		;0dfc	dd 4e 03	. N .
	ld b,(ix+004h)		;0dff	dd 46 04	. F .
	push bc			;0e02	c5		.
	rst 10h			;0e03	d7		.
	ld c,l			;0e04	4d		M
	rla			;0e05	17		.
	pop bc			;0e06	c1		.
	rst 10h			;0e07	d7		.
	cp e			;0e08	bb		.
	ld (de),a		;0e09	12		.
	inc hl			;0e0a	23		#
	ld c,(ix+005h)		;0e0b	dd 4e 05	. N .
	ld b,(ix+006h)		;0e0e	dd 46 06	. F .
	add hl,bc		;0e11	09		.
	ld (05c4bh),hl		;0e12	22 4b 5c	" K \
	ld l,(ix+001h)		;0e15	dd 6e 01	. n .
	ld h,(ix+002h)		;0e18	dd 66 02	. f .
	ld (05c42h),hl		;0e1b	22 42 5c	" B \
	ld a,h			;0e1e	7c		|
	or l			;0e1f	b5		.
	ld a,000h		;0e20	3e 00		> .
	jr nz,l0e25h		;0e22	20 01		  .
	dec a			;0e24	3d		=
l0e25h:
	ld (05c44h),a		;0e25	32 44 5c	2 D \
	ld hl,(05c53h)		;0e28	2a 53 5c	* S \
	ld (02147h),hl		;0e2b	22 47 21	" G !
	pop hl			;0e2e	e1		.
l0e2fh:
	xor a			;0e2f	af		.
	ret			;0e30	c9		.
	ld a,0ffh		;0e31	3e ff		> .
	pop hl			;0e33	e1		.
	set 3,l			;0e34	cb dd		. .
	ld c,(hl)		;0e36	4e		N
	inc bc			;0e37	03		.
	ld b,(ix+004h)		;0e38	dd 46 04	. F .
	inc bc			;0e3b	03		.
	rst 10h			;0e3c	d7		.
	jr nc,l0e3fh		;0e3d	30 00		0 .
l0e3fh:
	ex de,hl		;0e3f	eb		.
	ld (02147h),hl		;0e40	22 47 21	" G !
	ld (0214bh),hl		;0e43	22 4b 21	" K !
	xor a			;0e46	af		.
	ld (02138h),a		;0e47	32 38 21	2 8 !
	ret			;0e4a	c9		.
sub_0e4bh:
	call l0495h		;0e4b	cd 95 04	. . .
	jr z,l0e58h		;0e4e	28 08		( .
	rst 10h			;0e50	d7		.
	add hl,bc		;0e51	09		.
	jr nz,$-44		;0e52	20 d2		  .
	ld b,b			;0e54	40		@
l0e55h:
	inc b			;0e55	04		.
	jr sub_0e4bh		;0e56	18 f3		. .
l0e58h:
	ld a,(0212fh)		;0e58	3a 2f 21	: / !
	cp 0c0h			;0e5b	fe c0		. .
	jr nz,l0e6bh		;0e5d	20 0c		  .
	ld a,(02100h)		;0e5f	3a 00 21	: . !
	cp 080h			;0e62	fe 80		. .
	jr nz,l0e6bh		;0e64	20 05		  .
	ld a,(02102h)		;0e66	3a 02 21	: . !
	or a			;0e69	b7		.
	ret			;0e6a	c9		.
l0e6bh:
	scf			;0e6b	37		7
	ret			;0e6c	c9		.
	ld a,(02139h)		;0e6d	3a 39 21	: 9 !
	or a			;0e70	b7		.
	jr z,l0e7eh		;0e71	28 0b		( .
	ld a,(02134h)		;0e73	3a 34 21	: 4 !
	ld (02102h),a		;0e76	32 02 21	2 . !
	ld a,011h		;0e79	3e 11		> .
	jp l092ah		;0e7b	c3 2a 09	. * .
l0e7eh:
	call sub_0660h		;0e7e	cd 60 06	. ` .
	call l037eh		;0e81	cd 7e 03	. ~ .
	ld a,015h		;0e84	3e 15		> .
	jp l0725h		;0e86	c3 25 07	. % .
	ld a,(02136h)		;0e89	3a 36 21	: 6 !
	ld b,001h		;0e8c	06 01		. .
	cp 050h			;0e8e	fe 50		. P
	jr z,l0ea0h		;0e90	28 0e		( .
	ld b,000h		;0e92	06 00		. .
	cp 055h			;0e94	fe 55		. U
	jr z,l0ea0h		;0e96	28 08		( .
	ld b,002h		;0e98	06 02		. .
	cp 056h			;0e9a	fe 56		. V
	jr z,l0ea0h		;0e9c	28 02		( .
	ld b,003h		;0e9e	06 03		. .
l0ea0h:
	push bc			;0ea0	c5		.
	call sub_0660h		;0ea1	cd 60 06	. ` .
	call l037eh		;0ea4	cd 7e 03	. ~ .
	ld a,014h		;0ea7	3e 14		> .
	ld (02100h),a		;0ea9	32 00 21	2 . !
	pop af			;0eac	f1		.
	jp l034dh		;0ead	c3 4d 03	. M .
l0eb0h:
	ld sp,06200h		;0eb0	31 00 62	1 . b
	ld b,0ffh		;0eb3	06 ff		. .
l0eb5h:
	ld a,0c0h		;0eb5	3e c0		> .
	ld (0212fh),a		;0eb7	32 2f 21	2 / !
	ld a,00dh		;0eba	3e 0d		> .
	ld (02130h),a		;0ebc	32 30 21	2 0 !
	ld hl,02100h		;0ebf	21 00 21	! . !
	ld (hl),017h		;0ec2	36 17		6 .
	call sub_0454h		;0ec4	cd 54 04	. T .
	jr z,l0ed2h		;0ec7	28 09		( .
	djnz l0eb5h		;0ec9	10 ea		. .
l0ecbh:
	ld hl,l0001h		;0ecb	21 01 00	! . .
	push hl			;0ece	e5		.
	jp l0604h		;0ecf	c3 04 06	. . .
l0ed2h:
	call 00395h		;0ed2	cd 95 03	. . .
	or a			;0ed5	b7		.
	jr nz,l0ecbh		;0ed6	20 f3		  .
	ld (02000h),hl		;0ed8	22 00 20	" .  
	ld hl,l0f5fh		;0edb	21 5f 0f	! _ .
	ld de,06880h		;0ede	11 80 68	. . h
	ld bc,0005fh		;0ee1	01 5f 00	. _ .
	ldir			;0ee4	ed b0		. .
	ld a,001h		;0ee6	3e 01		> .
	ld (0213ah),a		;0ee8	32 3a 21	2 : !
	ld hl,06880h		;0eeb	21 80 68	! . h
	push hl			;0eee	e5		.
	ld de,(02000h)		;0eef	ed 5b 00 20	. [ .  
	jp l0604h		;0ef3	c3 04 06	. . .
l0ef6h:
	ld de,0658ch		;0ef6	11 8c 65	. . e
	ld hl,l05a5h		;0ef9	21 a5 05	! . .
	ld bc,l0007h		;0efc	01 07 00	. . .
	ldir			;0eff	ed b0		. .
	ld a,001h		;0f01	3e 01		> .
	ld (0213ah),a		;0f03	32 3a 21	2 : !
	ld hl,06815h		;0f06	21 15 68	! . h
	push hl			;0f09	e5		.
	ld hl,00ae7h		;0f0a	21 e7 0a	! . .
	jp l0604h		;0f0d	c3 04 06	. . .
l0f10h:
	ld hl,0658ch		;0f10	21 8c 65	! . e
	ld (hl),0ddh		;0f13	36 dd		6 .
	inc hl			;0f15	23		#
	ld (hl),0e9h		;0f16	36 e9		6 .
	ld a,007h		;0f18	3e 07		> .
	ld (02100h),a		;0f1a	32 00 21	2 . !
	ld hl,005afh		;0f1d	21 af 05	! . .
	ld de,02000h		;0f20	11 00 20	. .  
	ld bc,l0005h		;0f23	01 05 00	. . .
	ldir			;0f26	ed b0		. .
	ld a,006h		;0f28	3e 06		> .
	call l037eh		;0f2a	cd 7e 03	. ~ .
	call l034dh		;0f2d	cd 4d 03	. M .
	call 00395h		;0f30	cd 95 03	. . .
	cp 021h			;0f33	fe 21		. !
	jr nz,l0f51h		;0f35	20 1a		  .
	ld hl,(05c59h)		;0f37	2a 59 5c	* Y \
	ld bc,l0008h+1		;0f3a	01 09 00	. . .
	call l0305h		;0f3d	cd 05 03	. . .
	cp e			;0f40	bb		.
	ld (de),a		;0f41	12		.
	inc hl			;0f42	23		#
	ex de,hl		;0f43	eb		.
	ld hl,l05ach		;0f44	21 ac 05	! . .
	ld bc,l0008h+1		;0f47	01 09 00	. . .
	ldir			;0f4a	ed b0		. .
	ld de,l0e55h		;0f4c	11 55 0e	. U .
	jr l0f54h		;0f4f	18 03		. .
l0f51h:
	ld de,l0e2fh		;0f51	11 2f 0e	. / .
l0f54h:
	ld sp,06200h		;0f54	31 00 62	1 . b
	ld hl,l003eh		;0f57	21 3e 00	! > .
	push hl			;0f5a	e5		.
	push de			;0f5b	d5		.
	jp l0603h		;0f5c	c3 03 06	. . .
l0f5fh:
	ld hl,068d8h		;0f5f	21 d8 68	! . h
	ld a,d			;0f62	7a		z
	rrd			;0f63	ed 67		. g
	add a,031h		;0f65	c6 31		. 1
	ld (hl),a		;0f67	77		w
	inc hl			;0f68	23		#
	inc hl			;0f69	23		#
	ld a,d			;0f6a	7a		z
	and 00fh		;0f6b	e6 0f		. .
	add a,0b1h		;0f6d	c6 b1		. .
	ld (hl),a		;0f6f	77		w
	ld hl,00d55h		;0f70	21 55 0d	! U .
	ld de,068dfh		;0f73	11 df 68	. . h
	ld bc,l00b3h		;0f76	01 b3 00	. . .
	ldir			;0f79	ed b0		. .
	ld hl,068dch		;0f7b	21 dc 68	! . h
	ld bc,l0001h+2		;0f7e	01 03 00	. . .
	ldir			;0f81	ed b0		. .
	ld hl,l0000h		;0f83	21 00 00	! . .
	ld b,000h		;0f86	06 00		. .
	jp 068dfh		;0f88	c3 df 68	. . h
	ld de,068b9h		;0f8b	11 b9 68	. . h
	call l073fh		;0f8e	cd 3f 07	. ? .
	ld hl,l0ef6h		;0f91	21 f6 0e	! . .
	push hl			;0f94	e5		.
	jp l0008h		;0f95	c3 08 00	. . .
	add a,b			;0f98	80		.
	dec c			;0f99	0d		.
	dec c			;0f9a	0d		.
	ld a,a			;0f9b	7f		.
	jr nz,l0fcfh		;0f9c	20 31		  1
	add hl,sp		;0f9e	39		9
	jr c,l0fd6h		;0f9f	38 35		8 5
	jr nz,l0ff7h		;0fa1	20 54		  T
	ld c,l			;0fa3	4d		M
	ld e,b			;0fa4	58		X
	jr nz,l0ff7h		;0fa5	20 50		  P
	ld l,a			;0fa7	6f		o
	ld (hl),d		;0fa8	72		r
	ld (hl),h		;0fa9	74		t
	ld (hl),l		;0faa	75		u
	ld h,a			;0fab	67		g
	ld h,c			;0fac	61		a
	ld l,h			;0fad	6c		l
	jr nz,l0fddh		;0fae	20 2d		  -
	jr nz,$+86		;0fb0	20 54		  T
	ld c,a			;0fb2	4f		O
	ld d,e			;0fb3	53		S
	jr nz,$+88		;0fb4	20 56		  V
	jr nz,l0fd8h		;0fb6	20 20		   
	ld l,020h		;0fb8	2e 20		.  
	adc a,l			;0fba	8d		.
	jp 068ach		;0fbb	c3 ac 68	. . h
	rst 38h			;0fbe	ff		.
	rst 38h			;0fbf	ff		.
	rst 38h			;0fc0	ff		.
	rst 38h			;0fc1	ff		.
	rst 38h			;0fc2	ff		.
	rst 38h			;0fc3	ff		.
	rst 38h			;0fc4	ff		.
	rst 38h			;0fc5	ff		.
	rst 38h			;0fc6	ff		.
	rst 38h			;0fc7	ff		.
	rst 38h			;0fc8	ff		.
	rst 38h			;0fc9	ff		.
	rst 38h			;0fca	ff		.
	rst 38h			;0fcb	ff		.
	rst 38h			;0fcc	ff		.
	rst 38h			;0fcd	ff		.
	rst 38h			;0fce	ff		.
l0fcfh:
	rst 38h			;0fcf	ff		.
	rst 38h			;0fd0	ff		.
	rst 38h			;0fd1	ff		.
	rst 38h			;0fd2	ff		.
	rst 38h			;0fd3	ff		.
	rst 38h			;0fd4	ff		.
	rst 38h			;0fd5	ff		.
l0fd6h:
	rst 38h			;0fd6	ff		.
	rst 38h			;0fd7	ff		.
l0fd8h:
	rst 38h			;0fd8	ff		.
	rst 38h			;0fd9	ff		.
	rst 38h			;0fda	ff		.
	rst 38h			;0fdb	ff		.
	rst 38h			;0fdc	ff		.
l0fddh:
	rst 38h			;0fdd	ff		.
	rst 38h			;0fde	ff		.
	rst 38h			;0fdf	ff		.
	rst 38h			;0fe0	ff		.
	rst 38h			;0fe1	ff		.
	rst 38h			;0fe2	ff		.
	rst 38h			;0fe3	ff		.
	rst 38h			;0fe4	ff		.
	rst 38h			;0fe5	ff		.
	rst 38h			;0fe6	ff		.
	rst 38h			;0fe7	ff		.
	rst 38h			;0fe8	ff		.
	rst 38h			;0fe9	ff		.
	rst 38h			;0fea	ff		.
	rst 38h			;0feb	ff		.
	rst 38h			;0fec	ff		.
	rst 38h			;0fed	ff		.
	rst 38h			;0fee	ff		.
	rst 38h			;0fef	ff		.
	rst 38h			;0ff0	ff		.
	rst 38h			;0ff1	ff		.
	rst 38h			;0ff2	ff		.
	rst 38h			;0ff3	ff		.
	rst 38h			;0ff4	ff		.
	rst 38h			;0ff5	ff		.
	rst 38h			;0ff6	ff		.
l0ff7h:
	rst 38h			;0ff7	ff		.
	rst 38h			;0ff8	ff		.
	rst 38h			;0ff9	ff		.
	rst 38h			;0ffa	ff		.
	rst 38h			;0ffb	ff		.
	rst 38h			;0ffc	ff		.
	rst 38h			;0ffd	ff		.
	rst 38h			;0ffe	ff		.
	rst 38h			;0fff	ff		.
