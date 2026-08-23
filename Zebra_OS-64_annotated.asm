	org 00000h

LROS_HEADER:

;================================================================
; Zebra OS-64 ROM for the Timex/Sinclair 2068
; (C) 1985 Zebra Systems Inc.
;
; Annotated disassembly
; Based on z80dasm output with labels, comments, and section
; markers derived from the original TS2068 HOME ROM disassembly
; and the Zebra OS-64 analysis document.
;================================================================

;================================================================
;*** ZEBRA MODIFICATION: LROS Cartridge Header ($0000-$0007) ***
; The original cold-start code (DI; XOR A; LD DE,$FFFF; JP $0D31)
; is replaced with a standard LROS cartridge header.
; $0000 = $00 (unused)
; $0001 = $01 (cartridge type = LROS)
; $0002-$0003 = $05,$00 (starting address = $0005)
; $0004 = $FC (chunk spec: chunks 0-1 from cartridge)
; $0005-$0007 = $C3,$9E,$0D (JP $0D9E -- LROS entry point)
;================================================================
	nop			;0000	00
LROS_BC:
	ld bc,LROS_CALL+1		;0001	01 05 00
LROS_CALL:
	call m,09ec3h		;0004	fc c3 9e
LROS_JP_LO:
	dec c			;0007	0d
ERROR:

;================================================================
; Module: BASIC
; Routine: ERROR ($0008) - RST $08
; Handles errors. Top of machine stack has the address of the
; error identifier byte.
;================================================================
	ld hl,(05c5dh)		;0008	2a 5d 5c  ; CH_ADD
	ld (05c5fh),hl		;000b	22 5f 5c  ; X_PTR
	jr GETERNR		;000e	18 43
WRCH:

;================================================================
; Module: BASIC
; Routine: WRCH ($0010) - RST $10
; Write a character to the current stream.
;================================================================
	jp l11edh		;0010	c3 ed 11

;*** ZEBRA MODIFICATION: RST $10 Alternate Entry ($0013-$0017) ***
; Installed in padding space after the WRCH jump.
; LD E,A / EX AF,AF' / JP $06FA
; Used by 64-column character print loop.
	ld e,a			;0013	5f
WRCH_ALT:
	ex af,af'		;0014	08
	jp 006fah		;0015	c3 fa 06
GETCURCH:

;================================================================
; Module: BASIC
; Routine: GETCURCH ($0018) - RST $18
; Get the current character pointed to by CH_ADD.
;================================================================
	ld hl,(05c5dh)		;0018	2a 5d 5c  ; CH_ADD
	ld a,(hl)		;001b	7e
GETCURCH_1:
	call TEST_CH		;001c	cd 7d 00
	ret nc			;001f	d0
NEXTCH_RST:

;================================================================
; Module: BASIC
; Routine: NEXTCH_RST ($0020) - RST $20
; Get the next character, skipping control codes.
;================================================================
	call NEXTCH		;0020	cd 74 00
	jr GETCURCH_1		;0023	18 f7
	nop			;0025	00
	nop			;0026	00
	nop			;0027	00

;================================================================
; Module: BASIC
; Routine: CALCCALL ($0028) - RST $28
; Jumps to the calculator interpreter.
;================================================================
	jp l371ah		;0028	c3 1a 37
NIBBLE_SWAP:

;*** ZEBRA MODIFICATION: Nibble Swap Utility ($002B-$002F) ***
; Installed in RST $28 padding space.
; RRCA x4, RET -- swaps high/low nibbles of A.
; Used by 64-col display code for 4-pixel-wide characters.
	rrca			;002b	0f
	rrca			;002c	0f
	rrca			;002d	0f
	rrca			;002e	0f
	ret			;002f	c9
ALLOCBC:

;================================================================
; Module: BASIC
; Routine: ALLOCBC ($0030) - RST $30
; Expand the workspace BC bytes.
;================================================================
	push bc			;0030	c5
	ld hl,(05c61h)		;0031	2a 61 5c  ; WORKSP
	push hl			;0034	e5
	jp GLPR		;0035	c3 2d 13

;================================================================
; Module: BASIC
; Routine: INTRPT ($0038) - Maskable Interrupt Handler (IM1)
; Keyboard interrogation routine. Increments FRAMES counter,
; then calls keyboard scan.
;================================================================
	push af			;0038	f5
	push hl			;0039	e5
	ld hl,(05c78h)		;003a	2a 78 5c  ; FRAMES
	inc hl			;003d	23
	ld (05c78h),hl		;003e	22 78 5c  ; FRAMES
	ld a,h			;0041	7c
	or l			;0042	b5
	jr nz,INTRPT_1		;0043	20 03
	inc (iy+040h)		;0045	fd 34 40  ; IY+$40 = FRAMES2
INTRPT_1:
	push bc			;0048	c5
	push de			;0049	d5
	call UPD_K		;004a	cd e1 02
	pop de			;004d	d1
	pop bc			;004e	c1
	pop hl			;004f	e1
PHLAF:
	pop af			;0050	f1
	ei			;0051	fb
PHLAF_RET:
	ret			;0052	c9
GETERNR:

;================================================================
; Module: BASIC
; Routine: GETERNR ($0053)
; Gets the error number by popping the return address from
; the stack then loading it into L.
;================================================================
	pop hl			;0053	e1
	ld l,(hl)		;0054	6e
LE3:

;================================================================
; Module: BASIC
; Routine: LE3 ($0055)
; Put the error number in L into ERR_NR, restore SP from ERRSP,
; and reset the calculator stack.
;================================================================
	ld (iy+000h),l		;0055	fd 75 00  ; IY+$00 = ERR_NR
	ld sp,(05c3dh)		;0058	ed 7b 3d 5c  ; ERRSP
	jp RESET		;005c	c3 54 13
	nop			;005f	00
	nop			;0060	00
	nop			;0061	00
	nop			;0062	00
	nop			;0063	00
	nop			;0064	00
	nop			;0065	00

;================================================================
; Module: BASIC
; Routine: NMI ($0066) - Non-Maskable Interrupt
;*** ZEBRA MODIFICATION: NMI Bug Fix ($006D) ***
; The infamous inverted-logic bug is FIXED here.
; Original: JR NZ,$0070 (jumps to user handler when USRNMI=0)
; Zebra:    JR Z,$0070  (correctly skips JP (HL) when HL=0)
;================================================================
	push af			;0066	f5
	push hl			;0067	e5
	ld hl,(0fff1h)		;0068	2a f1 ff  ; USRNMI
	ld a,h			;006b	7c
	or l			;006c	b5
	jr z,NMI_EXIT		;006d	28 01
	jp (hl)			;006f	e9
NMI_EXIT:
	pop hl			;0070	e1
	pop af			;0071	f1
	retn			;0072	ed 45
NEXTCH:

;================================================================
; Module: BASIC
; Routine: NEXTCH ($0074)
; Get the next character after bumping CH_ADD.
;================================================================
	ld hl,(05c5dh)		;0074	2a 5d 5c  ; CH_ADD
NC_HL:
	inc hl			;0077	23
TC_HL:
	ld (05c5dh),hl		;0078	22 5d 5c  ; CH_ADD
	ld a,(hl)		;007b	7e
	ret			;007c	c9
TEST_CH:

;================================================================
; Module: BASIC
; Routine: TEST_CH ($007D)
; Tests the character in A. Returns with various flag conditions
; based on character type (printable, control, CR, etc.)
;================================================================
	cp 021h			;007d	fe 21
	ret nc			;007f	d0
	cp 00dh			;0080	fe 0d
	ret z			;0082	c8
	cp 00ch			;0083	fe 0c
	ret z			;0085	c8
	cp 010h			;0086	fe 10
	ret c			;0088	d8
	cp 018h			;0089	fe 18
	ccf			;008b	3f
	ret c			;008c	d8
	inc hl			;008d	23
	cp 016h			;008e	fe 16
	jr c,TEST_CH_3		;0090	38 01
	inc hl			;0092	23
TEST_CH_3:
	scf			;0093	37
	ld (05c5dh),hl		;0094	22 5d 5c  ; CH_ADD
	ret			;0097	c9
TOKENS:

;================================================================
; Module: BASIC
; Routine: TOKENS ($0098)
; Token table - Sinclair-encoded BASIC keywords.
; Each entry ends with bit 7 set on the last character.
;================================================================
	cp a			;0098	bf
	ld d,d			;0099	52
	ld c,(hl)		;009a	4e
	call nz,04e49h		;009b	c4 49 4e
	ld c,e			;009e	4b
	ld b,l			;009f	45
	ld e,c			;00a0	59
	and h			;00a1	a4
	ld d,b			;00a2	50
	ret			;00a3	c9
	ld b,(hl)		;00a4	46
	adc a,050h		;00a5	ce 50
	ld c,a			;00a7	4f
	ld c,c			;00a8	49
	ld c,(hl)		;00a9	4e
	call nc,04353h		;00aa	d4 53 43
	ld d,d			;00ad	52
	ld b,l			;00ae	45
	ld b,l			;00af	45
	ld c,(hl)		;00b0	4e
	and h			;00b1	a4
	ld b,c			;00b2	41
	ld d,h			;00b3	54
	ld d,h			;00b4	54
	jp nc,0d441h		;00b5	d2 41 d4
	ld d,h			;00b8	54
	ld b,c			;00b9	41
	jp nz,04156h		;00ba	c2 56 41
	ld c,h			;00bd	4c
	and h			;00be	a4
	ld b,e			;00bf	43
	ld c,a			;00c0	4f
	ld b,h			;00c1	44
	push bc			;00c2	c5
	ld d,(hl)		;00c3	56
	ld b,c			;00c4	41
	call z,0454ch		;00c5	cc 4c 45
TOK_SIN:
	adc a,053h		;00c8	ce 53
	ld c,c			;00ca	49
	adc a,043h		;00cb	ce 43
	ld c,a			;00cd	4f
TOK_COS:
	out (054h),a		;00ce	d3 54
TOK_TAN:
	ld b,c			;00d0	41
	adc a,041h		;00d1	ce 41
	ld d,e			;00d3	53
	adc a,041h		;00d4	ce 41
	ld b,e			;00d6	43
	out (041h),a		;00d7	d3 41
	ld d,h			;00d9	54
	adc a,04ch		;00da	ce 4c
	adc a,045h		;00dc	ce 45
	ld e,b			;00de	58
	ret nc			;00df	d0
	ld c,c			;00e0	49
	ld c,(hl)		;00e1	4e
	call nc,05153h		;00e2	d4 53 51
	jp nc,04753h		;00e5	d2 53 47
	adc a,041h		;00e8	ce 41
	ld b,d			;00ea	42
	out (050h),a		;00eb	d3 50
	ld b,l			;00ed	45
	ld b,l			;00ee	45
	bit 1,c			;00ef	cb 49
	adc a,055h		;00f1	ce 55
	ld d,e			;00f3	53
	jp nc,05453h		;00f4	d2 53 54
	ld d,d			;00f7	52
	and h			;00f8	a4
	ld b,e			;00f9	43
	ld c,b			;00fa	48
	ld d,d			;00fb	52
TOK_CHR:
	and h			;00fc	a4
	ld c,(hl)		;00fd	4e
	ld c,a			;00fe	4f
TOK_NOT:
	call nc,04942h		;00ff	d4 42 49
TOK_BIN:
	adc a,04fh		;0102	ce 4f
	jp nc,04e41h		;0104	d2 41 4e
	call nz,0bd3ch		;0107	c4 3c bd
	ld a,0bdh		;010a	3e bd
	inc a			;010c	3c
	cp (hl)			;010d	be
	ld c,h			;010e	4c
	ld c,c			;010f	49
	ld c,(hl)		;0110	4e
	push bc			;0111	c5
	ld d,h			;0112	54
	ld c,b			;0113	48
	ld b,l			;0114	45
	adc a,054h		;0115	ce 54
	rst 8			;0117	cf
	ld d,e			;0118	53
	ld d,h			;0119	54
	ld b,l			;011a	45
	ret nc			;011b	d0
	ld b,h			;011c	44
	ld b,l			;011d	45
	ld b,(hl)		;011e	46
TOK_DEF_FN:
	jr nz,TOK_BRIGHT		;011f	20 46
	adc a,043h		;0121	ce 43
	ld b,c			;0123	41
	call nc,04f46h		;0124	d4 46 4f
	ld d,d			;0127	52
	ld c,l			;0128	4d
	ld b,c			;0129	41
	call nc,04f4dh		;012a	d4 4d 4f
	ld d,(hl)		;012d	56
	push bc			;012e	c5
	ld b,l			;012f	45
	ld d,d			;0130	52
	ld b,c			;0131	41
	ld d,e			;0132	53
	push bc			;0133	c5
	ld c,a			;0134	4f
	ld d,b			;0135	50
	ld b,l			;0136	45
	ld c,(hl)		;0137	4e
	jr nz,$-91		;0138	20 a3
	ld b,e			;013a	43
	ld c,h			;013b	4c
	ld c,a			;013c	4f
	ld d,e			;013d	53
	ld b,l			;013e	45
	jr nz,$-91		;013f	20 a3
	ld c,l			;0141	4d
	ld b,l			;0142	45
	ld d,d			;0143	52
	ld b,a			;0144	47
	push bc			;0145	c5
	ld d,(hl)		;0146	56
	ld b,l			;0147	45
	ld d,d			;0148	52
	ld c,c			;0149	49
	ld b,(hl)		;014a	46
	exx			;014b	d9
	ld b,d			;014c	42
	ld b,l			;014d	45
	ld b,l			;014e	45
	ret nc			;014f	d0
	ld b,e			;0150	43
	ld c,c			;0151	49
	ld d,d			;0152	52
	ld b,e			;0153	43
	ld c,h			;0154	4c
	push bc			;0155	c5
	ld c,c			;0156	49
	ld c,(hl)		;0157	4e
	bit 2,b			;0158	cb 50
	ld b,c			;015a	41
	ld d,b			;015b	50
	ld b,l			;015c	45
	jp nc,04c46h		;015d	d2 46 4c
	ld b,c			;0160	41
	ld d,e			;0161	53
	ret z			;0162	c8
	ld b,d			;0163	42
	ld d,d			;0164	52
	ld c,c			;0165	49
	ld b,a			;0166	47
TOK_BRIGHT:
	ld c,b			;0167	48
	call nc,04e49h		;0168	d4 49 4e
	ld d,(hl)		;016b	56
	ld b,l			;016c	45
	ld d,d			;016d	52
	ld d,e			;016e	53
	push bc			;016f	c5
	ld c,a			;0170	4f
	ld d,(hl)		;0171	56
	ld b,l			;0172	45
	jp nc,0554fh		;0173	d2 4f 55
	call nc,0504ch		;0176	d4 4c 50
	ld d,d			;0179	52
	ld c,c			;017a	49
	ld c,(hl)		;017b	4e
	call nc,04c4ch		;017c	d4 4c 4c
	ld c,c			;017f	49
	ld d,e			;0180	53
	call nc,05453h		;0181	d4 53 54
	ld c,a			;0184	4f
	ret nc			;0185	d0
	ld d,d			;0186	52
	ld b,l			;0187	45
	ld b,c			;0188	41
	call nz,04144h		;0189	c4 44 41
	ld d,h			;018c	54
	pop bc			;018d	c1
	ld d,d			;018e	52
	ld b,l			;018f	45
	ld d,e			;0190	53
	ld d,h			;0191	54
	ld c,a			;0192	4f
	ld d,d			;0193	52
	push bc			;0194	c5
	ld c,(hl)		;0195	4e
	ld b,l			;0196	45
	rst 10h			;0197	d7
	ld b,d			;0198	42
	ld c,a			;0199	4f
	ld d,d			;019a	52
	ld b,h			;019b	44
	ld b,l			;019c	45
	jp nc,04f43h		;019d	d2 43 4f
	ld c,(hl)		;01a0	4e
	ld d,h			;01a1	54
	ld c,c			;01a2	49
	ld c,(hl)		;01a3	4e
	ld d,l			;01a4	55
	push bc			;01a5	c5
	ld b,h			;01a6	44
	ld c,c			;01a7	49
	call 04552h		;01a8	cd 52 45
l01abh:
	call 04f46h		;01ab	cd 46 4f
	jp nc,04f47h		;01ae	d2 47 4f
	jr nz,TOK_DELETE		;01b1	20 54
	rst 8			;01b3	cf
	ld b,a			;01b4	47
	ld c,a			;01b5	4f
	jr nz,TOK_DELETE_2		;01b6	20 53
	ld d,l			;01b8	55
	jp nz,04e49h		;01b9	c2 49 4e
	ld d,b			;01bc	50
	ld d,l			;01bd	55
	call nc,04f4ch		;01be	d4 4c 4f
	ld b,c			;01c1	41
	call nz,0494ch		;01c2	c4 4c 49
	ld d,e			;01c5	53
	call nc,0454ch		;01c6	d4 4c 45
	call nc,04150h		;01c9	d4 50 41
	ld d,l			;01cc	55
	ld d,e			;01cd	53
	push bc			;01ce	c5
	ld c,(hl)		;01cf	4e
	ld b,l			;01d0	45
	ld e,b			;01d1	58
	call nc,04f50h		;01d2	d4 50 4f
	ld c,e			;01d5	4b
	push bc			;01d6	c5
	ld d,b			;01d7	50
	ld d,d			;01d8	52
	ld c,c			;01d9	49
	ld c,(hl)		;01da	4e
	call nc,04c50h		;01db	d4 50 4c
	ld c,a			;01de	4f
	call nc,05552h		;01df	d4 52 55
	adc a,053h		;01e2	ce 53
	ld b,c			;01e4	41
	ld d,(hl)		;01e5	56
	push bc			;01e6	c5
	ld d,d			;01e7	52
	ld b,c			;01e8	41
	ld c,(hl)		;01e9	4e
	ld b,h			;01ea	44
	ld c,a			;01eb	4f
	ld c,l			;01ec	4d
	ld c,c			;01ed	49
	ld e,d			;01ee	5a
	push bc			;01ef	c5
	ld c,c			;01f0	49
	add a,043h		;01f1	c6 43
	ld c,h			;01f3	4c
	out (044h),a		;01f4	d3 44
	ld d,d			;01f6	52
	ld b,c			;01f7	41
	rst 10h			;01f8	d7
	ld b,e			;01f9	43
	ld c,h			;01fa	4c
	ld b,l			;01fb	45
	ld b,c			;01fc	41
	jp nc,04552h		;01fd	d2 52 45
TOK_RETURN:
	ld d,h			;0200	54
	ld d,l			;0201	55
	ld d,d			;0202	52
	adc a,043h		;0203	ce 43
TOK_COPY:
	ld c,a			;0205	4f
	ld d,b			;0206	50
TOK_DELETE:
	exx			;0207	d9
	ld b,h			;0208	44
	ld b,l			;0209	45
	ld c,h			;020a	4c
TOK_DELETE_2:
	ld b,l			;020b	45
	ld d,h			;020c	54
EKEYS_BASE:
	push bc			;020d	c5
	ld c,a			;020e	4f
EKEYS_2:
	ld c,(hl)		;020f	4e
	jr nz,NUMFNTBL_1		;0210	20 45
	ld d,d			;0212	52
	jp nc,05453h		;0213	d2 53 54
	ld c,c			;0216	49
	ld b,e			;0217	43
	bit 2,e			;0218	cb 53
	ld c,a			;021a	4f
	ld d,l			;021b	55
	ld c,(hl)		;021c	4e
	call nz,05246h		;021d	c4 46 52
	ld b,l			;0220	45
	push bc			;0221	c5
	ld d,d			;0222	52
	ld b,l			;0223	45
	ld d,e			;0224	53
	ld b,l			;0225	45
	call nc,04842h		;0226	d4 42 48
	ld e,c			;0229	59
	ld (hl),035h		;022a	36 35
	ld d,h			;022c	54
	ld b,a			;022d	47
	ld d,(hl)		;022e	56
	ld c,(hl)		;022f	4e
	ld c,d			;0230	4a
	ld d,l			;0231	55
	scf			;0232	37
	inc (hl)		;0233	34
	ld d,d			;0234	52
	ld b,(hl)		;0235	46
	ld b,e			;0236	43
	ld c,l			;0237	4d
	ld c,e			;0238	4b
	ld c,c			;0239	49
	jr c,KKEYS		;023a	38 33
	ld b,l			;023c	45
l023dh:
	ld b,h			;023d	44
	ld e,b			;023e	58
	ld c,04ch		;023f	0e 4c
	ld c,a			;0241	4f
	add hl,sp		;0242	39
	ld (05357h),a		;0243	32 57 53
	ld e,d			;0246	5a
	jr nz,NUMFNTBL_0		;0247	20 0d
	ld d,b			;0249	50
	jr nc,KKEYS_2		;024a	30 31
	ld d,c			;024c	51
	ld b,c			;024d	41
	ex (sp),hl		;024e	e3
	call nz,0e4e0h		;024f	c4 e0 e4
SEKEYS:
	or h			;0252	b4
	cp h			;0253	bc
	cp l			;0254	bd
	cp e			;0255	bb
NUMFNTBL_0:
	xor a			;0256	af
NUMFNTBL_1:
	or b			;0257	b0
	or c			;0258	b1
	ret nz			;0259	c0
	and a			;025a	a7
	and (hl)		;025b	a6
	cp (hl)			;025c	be
	xor l			;025d	ad
	or d			;025e	b2
	cp d			;025f	ba
	push hl			;0260	e5
	and l			;0261	a5
	jp nz,0b3e1h		;0262	c2 e1 b3
	cp c			;0265	b9
	pop bc			;0266	c1
	cp b			;0267	b8
	ld a,(hl)		;0268	7e
	call c,05cdah		;0269	dc da 5c
	or a			;026c	b7
	ld a,e			;026d	7b
	ld a,l			;026e	7d
KKEYS:
	ret c			;026f	d8
	cp a			;0270	bf
	xor (hl)		;0271	ae
	xor d			;0272	aa
	xor e			;0273	ab
	defb 0ddh,0deh,0dfh ;illegal sequence	;0274	dd de df
	ld a,a			;0277	7f
	or l			;0278	b5
	sub 07ch		;0279	d6 7c
	push de			;027b	d5
	ld e,l			;027c	5d
KKEYS_2:
	in a,(0b6h)		;027d	db b6
	exx			;027f	d9
	ld e,e			;0280	5b
	rst 10h			;0281	d7
	inc c			;0282	0c
	rlca			;0283	07
	ld b,004h		;0284	06 04
	dec b			;0286	05
	ex af,af'		;0287	08
	ld a,(bc)		;0288	0a
	dec bc			;0289	0b
	add hl,bc		;028a	09
	rrca			;028b	0f
	jp po,Z64_SCREEN_NEXT		;028c	e2 2a 3f
	call 0ccc8h		;028f	cd c8 cc
	bit 3,(hl)		;0292	cb 5e
	xor h			;0294	ac
	dec l			;0295	2d
	dec hl			;0296	2b
	dec a			;0297	3d
	ld l,02ch		;0298	2e 2c
	dec sp			;029a	3b
	ld (l3cc7h),hl		;029b	22 c7 3c
	jp 0c53eh		;029e	c3 3e c5
	cpl			;02a1	2f
	ret			;02a2	c9
	ld h,b			;02a3	60
	add a,03ah		;02a4	c6 3a
	ret nc			;02a6	d0
	adc a,0a8h		;02a7	ce a8
	jp z,0d4d3h		;02a9	ca d3 d4
	pop de			;02ac	d1
	jp nc,0cfa9h		;02ad	d2 a9 cf
K_SCAN:

;================================================================
; Module: KBSCAN
; Routine: K_SCAN ($02B0)
; Scans the keyboard matrix.
; Returns: Z/NZ with D,E containing key information.
;================================================================
	ld l,02fh		;02b0	2e 2f
	ld de,0ffffh		;02b2	11 ff ff
	ld bc,0fefeh		;02b5	01 fe fe
K_SCAN_LP:
	in a,(c)		;02b8	ed 78
	cpl			;02ba	2f
	and 01fh		;02bb	e6 1f
	jr z,K_SCAN_5		;02bd	28 0e
	ld h,a			;02bf	67
K_SCAN_2:
	ld a,l			;02c0	7d
K_SCAN_3:
	inc d			;02c1	14
K_SCAN_RET:
	ret nz			;02c2	c0
K_SCAN_4:
	sub 008h		;02c3	d6 08
	srl h			;02c5	cb 3c
	jr nc,K_SCAN_4		;02c7	30 fa
	ld d,e			;02c9	53
	ld e,a			;02ca	5f
	jr nz,K_SCAN_3		;02cb	20 f4
K_SCAN_5:
	dec l			;02cd	2d
	rlc b			;02ce	cb 00
	jr c,K_SCAN_LP		;02d0	38 e6
	ld a,d			;02d2	7a
	inc a			;02d3	3c
	ret z			;02d4	c8
	cp 028h			;02d5	fe 28
	ret z			;02d7	c8
	cp 019h			;02d8	fe 19
	ret z			;02da	c8
	ld a,e			;02db	7b
	ld e,d			;02dc	5a
	ld d,a			;02dd	57
	cp 018h			;02de	fe 18
	ret			;02e0	c9
UPD_K:

;================================================================
; Module: KBSCAN
; Routine: UPD_K ($02E1)
; Update keyboard state, handle debounce and repeat.
;================================================================
	call K_SCAN		;02e1	cd b0 02
	ret nz			;02e4	c0
	ld hl,05c00h		;02e5	21 00 5c  ; KS_A1
UPD_K_1:
	bit 7,(hl)		;02e8	cb 7e
	jr nz,UPD_K_2		;02ea	20 07
	inc hl			;02ec	23
	dec (hl)		;02ed	35
	dec hl			;02ee	2b
	jr nz,UPD_K_2		;02ef	20 02
	ld (hl),0ffh		;02f1	36 ff
UPD_K_2:
	ld a,l			;02f3	7d
	ld hl,05c04h		;02f4	21 04 5c  ; KS_A2
	cp l			;02f7	bd
	jr nz,UPD_K_1		;02f8	20 ee
	call K_BASE		;02fa	cd 5c 03
	ret nc			;02fd	d0
	res 5,(iy+030h)		;02fe	fd cb 30 ae  ; IY+$30 = FLAGS2
	ld hl,05c00h		;0302	21 00 5c  ; KS_A1
	cp (hl)			;0305	be
	jr z,REPEAT_KEY		;0306	28 2e
	ex de,hl		;0308	eb
	ld hl,05c04h		;0309	21 04 5c  ; KS_A2
	cp (hl)			;030c	be
	jr z,REPEAT_KEY		;030d	28 27
	bit 7,(hl)		;030f	cb 7e
	jr nz,SAVE_KEY		;0311	20 04
	ex de,hl		;0313	eb
	bit 7,(hl)		;0314	cb 7e
	ret z			;0316	c8
SAVE_KEY:
	ld e,a			;0317	5f
	ld (hl),a		;0318	77
	inc hl			;0319	23
	ld (hl),005h		;031a	36 05
	inc hl			;031c	23
	ld a,(05c09h)		;031d	3a 09 5c  ; REPDEL
	ld (hl),a		;0320	77
	inc hl			;0321	23
	ld c,(iy+007h)		;0322	fd 4e 07  ; IY+$07 = MODE
	ld d,(iy+001h)		;0325	fd 56 01  ; IY+$01 = FLAGS
	push hl			;0328	e5
	call CHCODE		;0329	cd 71 03
	pop hl			;032c	e1
	ld (hl),a		;032d	77
STORE_LASTK:
	ld (05c08h),a		;032e	32 08 5c  ; LASTK
	set 5,(iy+001h)		;0331	fd cb 01 ee  ; IY+$01 = FLAGS
	ret			;0335	c9
REPEAT_KEY:
	inc hl			;0336	23
	ld (hl),005h		;0337	36 05
	inc hl			;0339	23
	ld a,(05c08h)		;033a	3a 08 5c  ; LASTK
	cp 0ceh			;033d	fe ce
	ret nc			;033f	d0
	dec (hl)		;0340	35
	ret nz			;0341	c0
	ld a,(05c0ah)		;0342	3a 0a 5c  ; REPPER
	ld (hl),a		;0345	77
	inc hl			;0346	23
	ld a,(hl)		;0347	7e
	cp 00ch			;0348	fe 0c
	jr nz,STORE_LASTK		;034a	20 e2
	set 5,(iy+030h)		;034c	fd cb 30 ee  ; IY+$30 = FLAGS2
	push af			;0350	f5
	ld bc,04e20h		;0351	01 20 4e
DEL_DELAY:
	dec bc			;0354	0b
	ld a,c			;0355	79
	or b			;0356	b0
	jr nz,DEL_DELAY		;0357	20 fb
	pop af			;0359	f1
	jr STORE_LASTK		;035a	18 d2
K_BASE:

;================================================================
; Module: KBSCAN
; Routine: K_BASE ($035C)
; Look up base key code from scan result.
;================================================================
	ld b,d			;035c	42
	ld d,000h		;035d	16 00
	ld a,e			;035f	7b
	cp 027h			;0360	fe 27
	ret nc			;0362	d0
	cp 018h			;0363	fe 18
	jr nz,K_BASE_1		;0365	20 03
	bit 7,b			;0367	cb 78
	ret nz			;0369	c0
K_BASE_1:
	ld hl,00227h		;036a	21 27 02
	add hl,de		;036d	19
	ld a,(hl)		;036e	7e
	scf			;036f	37
	ret			;0370	c9
CHCODE:

;================================================================
; Module: KBSCAN
; Routine: CHCODE ($0371)
; Convert key code based on current MODE and shift state.
;================================================================
	ld a,e			;0371	7b
	cp 03ah			;0372	fe 3a
	jr c,KEY_DIGIT		;0374	38 2f
	dec c			;0376	0d
	jp m,LED4		;0377	fa 8d 03
	jr z,EMODE_KEYS		;037a	28 03
	add a,04fh		;037c	c6 4f
	ret			;037e	c9
EMODE_KEYS:
	ld hl,EKEYS_BASE		;037f	21 0d 02
	inc b			;0382	04
	jr z,KEY_LOOKUP		;0383	28 03
	ld hl,00227h		;0385	21 27 02
KEY_LOOKUP:
	ld d,000h		;0388	16 00
	add hl,de		;038a	19
	ld a,(hl)		;038b	7e
	ret			;038c	c9
LED4:
	ld hl,0024bh		;038d	21 4b 02
	bit 0,b			;0390	cb 40
	jr z,KEY_LOOKUP		;0392	28 f4
	bit 3,d			;0394	cb 5a
	jr z,K_MODE_KEYWORD		;0396	28 0a
	bit 3,(iy+030h)		;0398	fd cb 30 5e  ; IY+$30 = FLAGS2
	ret nz			;039c	c0
	inc b			;039d	04
	ret nz			;039e	c0
	add a,020h		;039f	c6 20
LED4_RET:
	ret			;03a1	c9
K_MODE_KEYWORD:
	add a,0a5h		;03a2	c6 a5
	ret			;03a4	c9
KEY_DIGIT:
	cp 030h			;03a5	fe 30
	ret c			;03a7	d8
	dec c			;03a8	0d
	jp m,KEY_LK_MODE		;03a9	fa db 03
	jr nz,KEY_GMODE		;03ac	20 19
	ld hl,00276h		;03ae	21 76 02
	bit 5,b			;03b1	cb 68
	jr z,KEY_LOOKUP		;03b3	28 d3
	cp 038h			;03b5	fe 38
	jr nc,KEY_89		;03b7	30 07
	sub 020h		;03b9	d6 20
	inc b			;03bb	04
	ret z			;03bc	c8
	add a,008h		;03bd	c6 08
	ret			;03bf	c9
KEY_89:
	sub 036h		;03c0	d6 36
	inc b			;03c2	04
	ret z			;03c3	c8
	add a,0feh		;03c4	c6 fe
	ret			;03c6	c9
KEY_GMODE:
	ld hl,SEKEYS		;03c7	21 52 02
	cp 039h			;03ca	fe 39
	jr z,KEY_LOOKUP		;03cc	28 ba
	cp 030h			;03ce	fe 30
	jr z,KEY_LOOKUP		;03d0	28 b6
	and 007h		;03d2	e6 07
	add a,080h		;03d4	c6 80
	inc b			;03d6	04
	ret z			;03d7	c8
	xor 00fh		;03d8	ee 0f
	ret			;03da	c9
KEY_LK_MODE:
	inc b			;03db	04
	ret z			;03dc	c8
	bit 5,b			;03dd	cb 68
	ld hl,SEKEYS		;03df	21 52 02
	jr nz,KEY_LOOKUP		;03e2	20 a4
	sub 010h		;03e4	d6 10
	cp 022h			;03e6	fe 22
KEY_AT:
	jr z,KEY_ATSIGN		;03e8	28 06
	cp 020h			;03ea	fe 20
	ret nz			;03ec	c0
	ld a,05fh		;03ed	3e 5f
	ret			;03ef	c9
KEY_ATSIGN:
	ld a,040h		;03f0	3e 40
	ret			;03f2	c9
PARP:

;================================================================
; Module: KBSCAN
; Routine: PARP ($03F3)
; Beep sound generation. Enter with DE=cycles-1, HL=period.
;================================================================
	di			;03f3	f3
	ld a,l			;03f4	7d
	srl l			;03f5	cb 3d
	srl l			;03f7	cb 3d
	cpl			;03f9	2f
	and 003h		;03fa	e6 03
	ld c,a			;03fc	4f
	ld b,000h		;03fd	06 00
	ld ix,PARP_NOP		;03ff	dd 21 0f 04
	add ix,bc		;0403	dd 09
	ld a,(05c48h)		;0405	3a 48 5c  ; BORDCR
	and 038h		;0408	e6 38
	rrca			;040a	0f
	rrca			;040b	0f
	rrca			;040c	0f
	or 008h			;040d	f6 08
PARP_NOP:
	nop			;040f	00
	nop			;0410	00
	nop			;0411	00
	inc b			;0412	04
	inc c			;0413	0c
PARP_LOOP:
	dec c			;0414	0d
	jr nz,PARP_LOOP		;0415	20 fd
	ld c,03fh		;0417	0e 3f
	dec b			;0419	05
	jp nz,PARP_LOOP		;041a	c2 14 04
	xor 010h		;041d	ee 10
PARP_OUT:
	out (0feh),a		;041f	d3 fe
	ld b,h			;0421	44
	ld c,a			;0422	4f
	bit 4,a			;0423	cb 67
	jr nz,PARP_HI		;0425	20 09
	ld a,d			;0427	7a
	or e			;0428	b3
	jr z,PARP_DONE		;0429	28 09
	ld a,c			;042b	79
	ld c,l			;042c	4d
	dec de			;042d	1b
	jp (ix)			;042e	dd e9
PARP_HI:
	ld c,l			;0430	4d
PARP_HI2:
	inc c			;0431	0c
	jp (ix)			;0432	dd e9
PARP_DONE:
	ei			;0434	fb
	ret			;0435	c9

;================================================================
; Module: KBSCAN
; Routine: BEEP ($0436)
; BASIC BEEP command handler. Uses calculator to convert
; note/duration to cycle count and period for PARP.
;================================================================
	rst 28h			;0436	ef
	ld sp,0c027h		;0437	31 27 c0
	inc bc			;043a	03
	inc (hl)		;043b	34
	call pe,0986ch		;043c	ec 6c 98
	rra			;043f	1f
	push af			;0440	f5
	inc b			;0441	04
	and c			;0442	a1
	rrca			;0443	0f
	jr c,$+35		;0444	38 21
	sub d			;0446	92
	ld e,h			;0447	5c
	ld a,(hl)		;0448	7e
	and a			;0449	a7
	jr nz,BEEP_ERR		;044a	20 5e
	inc hl			;044c	23
	ld c,(hl)		;044d	4e
	inc hl			;044e	23
	ld b,(hl)		;044f	46
	ld a,b			;0450	78
	rla			;0451	17
	sbc a,a			;0452	9f
	cp c			;0453	b9
	jr nz,BEEP_ERR		;0454	20 54
	inc hl			;0456	23
	cp (hl)			;0457	be
	jr nz,BEEP_ERR		;0458	20 50
	ld a,b			;045a	78
	add a,03ch		;045b	c6 3c
	jp p,BEEP_OCTAVE		;045d	f2 63 04
	jp po,BEEP_ERR		;0460	e2 aa 04
BEEP_OCTAVE:
	ld b,0fah		;0463	06 fa
BEEP_OCT_LP:
	inc b			;0465	04
	sub 00ch		;0466	d6 0c
	jr nc,BEEP_OCT_LP		;0468	30 fb
	add a,00ch		;046a	c6 0c
	push bc			;046c	c5
	ld hl,TONC		;046d	21 ac 04
	call HL_5A		;0470	cd c5 37
	call STK_M		;0473	cd 73 37
	rst 28h			;0476	ef
	inc b			;0477	04
	jr c,$-13		;0478	38 f1
	add a,(hl)		;047a	86
	ld (hl),a		;047b	77
	rst 28h			;047c	ef
	ret nz			;047d	c0
	ld (bc),a		;047e	02
	ld sp,0cd38h		;047f	31 38 cd
	ld e,01fh		;0482	1e 1f
	cp 00bh			;0484	fe 0b
	jr nc,BEEP_ERR		;0486	30 22
	rst 28h			;0488	ef
	ret po			;0489	e0
	inc b			;048a	04
	ret po			;048b	e0
	inc (hl)		;048c	34
	add a,b			;048d	80
	ld b,e			;048e	43
	ld d,l			;048f	55
	sbc a,a			;0490	9f
	add a,b			;0491	80
	ld bc,l3405h		;0492	01 05 34
	dec (hl)		;0495	35
	ld (hl),c		;0496	71
	inc bc			;0497	03
	jr c,$-49		;0498	38 cd
	inc hl			;049a	23
	rra			;049b	1f
	push bc			;049c	c5
	call FP_TO_BC		;049d	cd 23 1f
	pop hl			;04a0	e1
	ld d,b			;04a1	50
	ld e,c			;04a2	59
	ld a,d			;04a3	7a
BEEP_DUR:
	or e			;04a4	b3
	ret z			;04a5	c8
	dec de			;04a6	1b
	jp PARP		;04a7	c3 f3 03
BEEP_ERR:
	rst 8			;04aa	cf
	ld a,(bc)		;04ab	0a
TONC:

;================================================================
; BEEP lookup table - note frequency data (12 semitones)
; Each entry is a 5-byte floating point number.
;================================================================
	adc a,c			;04ac	89
	ld (bc),a		;04ad	02
	ret nc			;04ae	d0
	ld (de),a		;04af	12
	add a,(hl)		;04b0	86
	adc a,c			;04b1	89
	ld a,(bc)		;04b2	0a
	sub a			;04b3	97
	ld h,b			;04b4	60
	ld (hl),l		;04b5	75
	adc a,c			;04b6	89
	ld (de),a		;04b7	12
	push de			;04b8	d5
	rla			;04b9	17
	rra			;04ba	1f
	adc a,c			;04bb	89
	dec de			;04bc	1b
	sub b			;04bd	90
	ld b,c			;04be	41
	ld (bc),a		;04bf	02
TONE:
	adc a,c			;04c0	89
	inc h			;04c1	24
	ret nc			;04c2	d0
	ld d,e			;04c3	53
	jp z,l2e89h		;04c4	ca 89 2e
	sbc a,l			;04c7	9d
	ld (hl),0b1h		;04c8	36 b1
	adc a,c			;04ca	89
	jr c,$+1		;04cb	38 ff
	ld c,c			;04cd	49
	ld a,089h		;04ce	3e 89
	ld b,e			;04d0	43
	rst 38h			;04d1	ff
	ld l,d			;04d2	6a
	ld (hl),e		;04d3	73
	adc a,c			;04d4	89
	ld c,a			;04d5	4f
	and a			;04d6	a7
	nop			;04d7	00
	ld d,h			;04d8	54
	adc a,c			;04d9	89
	ld e,h			;04da	5c
	nop			;04db	00
	nop			;04dc	00
	nop			;04dd	00
	adc a,c			;04de	89
	ld l,c			;04df	69
	inc d			;04e0	14
TONH_1:
	or 024h			;04e1	f6 24
TONH_2:
	adc a,c			;04e3	89
TONH_3:
	halt			;04e4	76
TONH_4:
	pop af			;04e5	f1
	djnz DUALCOPY_POP		;04e6	10 05
DUALBANK_COPY:

;*** ZEBRA MODIFICATION: Dual-Bank Copy Routine ($04E8-$04FA) ***
; Replaces unused space. Copies data in both display banks
; for 64-column mode scrolling.
; PUSH BC,DE,HL / LDIR (primary bank $4000)
; POP HL,DE,BC / SET 5,D / SET 5,H / LDIR (secondary bank $6000)
; RES 5,H / RES 5,D / RET
;================================================================
	push bc			;04e8	c5
	push de			;04e9	d5
	push hl			;04ea	e5
	ldir			;04eb	ed b0
DUALCOPY_POP:
	pop hl			;04ed	e1
	pop de			;04ee	d1
DUALCOPY_POP2:
	pop bc			;04ef	c1
DUALCOPY_BANK2:
	set 5,d			;04f0	cb ea
	set 5,h			;04f2	cb ec
	ldir			;04f4	ed b0
	res 5,h			;04f6	cb ac
	res 5,d			;04f8	cb aa
	ret			;04fa	c9
	nop			;04fb	00
	nop			;04fc	00
	nop			;04fd	00
	nop			;04fe	00
	nop			;04ff	00
SENDTV:

;================================================================
; Module: IO_1
; Routine: SENDTV ($0500)
; Main TV output routine. Dispatches control characters
; and printable characters.
;================================================================
	call LDTVCU		;0500	cd 1a 06
	cp 020h			;0503	fe 20
	jp nc,PRINT_CHAR		;0505	d2 f0 05
	cp 00ch			;0508	fe 0c
	jr nz,SENDTV_CTRL		;050a	20 07
	bit 4,(iy+001h)		;050c	fd cb 01 66  ; IY+$01 = FLAGS
	jp z,PRINT_CHAR		;0510	ca f0 05
SENDTV_CTRL:
	cp 006h			;0513	fe 06
	jr c,PRINT_QMARK		;0515	38 69
	cp 018h			;0517	fe 18
	jr nc,PRINT_QMARK		;0519	30 65
	ld hl,CONTRO		;051b	21 22 05
	ld e,a			;051e	5f
	ld d,000h		;051f	16 00
	add hl,de		;0521	19
CONTRO:
	ld e,(hl)		;0522	5e
	add hl,de		;0523	19
	push hl			;0524	e5
	jp LDTVCU		;0525	c3 1a 06

;================================================================
; Module: IO_1
; Print control jump table (offsets from table base).
;================================================================
	ld c,(hl)		;0528	4e
	ld d,a			;0529	57
	djnz $+43		;052a	10 29
	ld d,h			;052c	54
	ld d,e			;052d	53
	ld d,d			;052e	52
	scf			;052f	37
	ld d,b			;0530	50
	ld c,a			;0531	4f
	ld e,a			;0532	5f
	ld e,(hl)		;0533	5e
	ld e,l			;0534	5d
	ld e,h			;0535	5c
	ld e,e			;0536	5b
	ld e,d			;0537	5a
	ld d,h			;0538	54
	ld d,e			;0539	53

;================================================================
; Module: IO_1
; Routine: P_LFT ($053A)
; Cursor left / line wrap handling.
;*** ZEBRA MODIFICATION: Column count $21 (33) -> $41 (65) ***
; at $054F for 64-column mode.
;================================================================
	inc c			;053a	0c
	ld a,042h		;053b	3e 42
	cp c			;053d	b9
	jr nz,P_LFT_DONE		;053e	20 11
	bit 1,(iy+001h)		;0540	fd cb 01 4e  ; IY+$01 = FLAGS
	jr nz,P_LFT_WRAP		;0544	20 09
	inc b			;0546	04
	ld c,002h		;0547	0e 02
	ld a,019h		;0549	3e 19
	cp b			;054b	b8
	jr nz,P_LFT_DONE		;054c	20 03
	dec b			;054e	05
P_LFT_WRAP:
	ld c,041h		;054f	0e 41
P_LFT_DONE:
	jp STTVC		;0551	c3 12 09

;================================================================
; Module: IO_1
; Routine: P_RT ($0554)
; Cursor right - print space with OVER flag.
;================================================================
	ld a,(05c91h)		;0554	3a 91 5c  ; PFLAG
	push af			;0557	f5
	ld (iy+057h),001h	;0558	fd 36 57 01  ; IY+$57 = PFLAG
	ld a,020h		;055c	3e 20
	call PRINT_CHAR		;055e	cd f0 05
	pop af			;0561	f1
	ld (05c91h),a		;0562	32 91 5c  ; PFLAG
	ret			;0565	c9

;================================================================
; Module: IO_1
; Routine: P_NL ($0566)
;*** ZEBRA MODIFICATION: Column count $21 -> $41 ***
; at $056D for 64-column mode.
;================================================================
	bit 1,(iy+001h)		;0566	fd cb 01 4e  ; IY+$01 = FLAGS
	jp nz,PRINTER_STUB		;056a	c2 23 0a
	ld c,041h		;056d	0e 41
	call TVFUL		;056f	cd 90 07
	dec b			;0572	05
	jp STTVC		;0573	c3 12 09
	call LDTVCU		;0576	cd 1a 06
	ld a,c			;0579	79
	dec a			;057a	3d
	dec a			;057b	3d
	and 020h		;057c	e6 20
	jr COMMA_CONT		;057e	18 5a
PRINT_QMARK:
	ld a,03fh		;0580	3e 3f
	jr PRINT_CHAR		;0582	18 6c
TVDATA_2:
	ld de,TVDATA_RESET		;0584	11 9e 05
	ld (05c0fh),a		;0587	32 0f 5c  ; TVDATA+1
	jr CHAN_UPDATE		;058a	18 0b
	ld de,TVDATA_2		;058c	11 84 05
	jr TVDATA_SAVE		;058f	18 03
	ld de,TVDATA_RESET		;0591	11 9e 05
TVDATA_SAVE:
	ld (05c0eh),a		;0594	32 0e 5c  ; TVDATA
CHAN_UPDATE:
	ld hl,(05c51h)		;0597	2a 51 5c  ; CURCHL
	ld (hl),e		;059a	73
	inc hl			;059b	23
	ld (hl),d		;059c	72
	ret			;059d	c9
TVDATA_RESET:
	ld de,SENDTV		;059e	11 00 05
	call CHAN_UPDATE		;05a1	cd 97 05
	ld hl,(05c0eh)		;05a4	2a 0e 5c  ; TVDATA
	ld d,a			;05a7	57
	ld a,l			;05a8	7d
	cp 016h			;05a9	fe 16
	jp c,l23bbh		;05ab	da bb 23
	jr nz,TAB_HANDLER		;05ae	20 29
	ld b,h			;05b0	44
	ld c,d			;05b1	4a
	ld a,03fh		;05b2	3e 3f
	sub c			;05b4	91
	jr c,SET_AT_ERR		;05b5	38 0c
	add a,002h		;05b7	c6 02
	ld c,a			;05b9	4f
	bit 1,(iy+001h)		;05ba	fd cb 01 4e  ; IY+$01 = FLAGS
	jr nz,SET_AT_DONE		;05be	20 16
	ld a,016h		;05c0	3e 16
	sub b			;05c2	90
SET_AT_ERR:
	jp c,ERR_OUTSCREEN		;05c3	da 29 1f
	inc a			;05c6	3c
	ld b,a			;05c7	47
	inc b			;05c8	04
	bit 0,(iy+002h)		;05c9	fd cb 02 46  ; IY+$02 = TVFLAG
	jp nz,TVFUL		;05cd	c2 90 07
	cp (iy+031h)		;05d0	fd be 31  ; IY+$31 = DFSZ
	jp c,ERR5		;05d3	da c1 07
SET_AT_DONE:
	jp STTVC		;05d6	c3 12 09
TAB_HANDLER:
	ld a,h			;05d9	7c
COMMA_CONT:
	call LDTVCU		;05da	cd 1a 06
	add a,c			;05dd	81
	dec a			;05de	3d
	and 03fh		;05df	e6 3f
	ret z			;05e1	c8
	ld d,a			;05e2	57
	set 0,(iy+001h)		;05e3	fd cb 01 c6  ; IY+$01 = FLAGS
SPACE_LOOP:
	ld a,020h		;05e7	3e 20
	call PR_TV2		;05e9	cd 76 07
	dec d			;05ec	15
	jr nz,SPACE_LOOP		;05ed	20 f8
	ret			;05ef	c9
PRINT_CHAR:

;================================================================
; Module: IO_1
; Routine: PRINT_CHAR ($05F0)
; Output a character bitmap to the display file.
;================================================================
	call GLYPH_CHAR		;05f0	cd 3b 06
STTVCU:
	bit 1,(iy+001h)		;05f3	fd cb 01 4e  ; IY+$01 = FLAGS
	jr nz,STTVCU_PR		;05f7	20 1a
	bit 0,(iy+002h)		;05f9	fd cb 02 46  ; IY+$02 = TVFLAG
	jr nz,STTVCU_LHS		;05fd	20 08
	ld (05c88h),bc		;05ff	ed 43 88 5c  ; SPOSNCOL
	ld (05c84h),hl		;0603	22 84 5c  ; DFCC
	ret			;0606	c9
STTVCU_LHS:
	ld (05c8ah),bc		;0607	ed 43 8a 5c  ; SPOSNLCOL
	ld (05c82h),bc		;060b	ed 43 82 5c  ; ECHOE
	ld (05c86h),hl		;060f	22 86 5c  ; DFCCL
	ret			;0612	c9
STTVCU_PR:
	ld (iy+045h),c		;0613	fd 71 45  ; IY+$45 = PRPOSN
	ld (05c80h),hl		;0616	22 80 5c  ; PRCC
	ret			;0619	c9
LDTVCU:

;================================================================
; Module: IO_1
; Routine: LDTVCU ($061A)
; Load registers with TV display position information.
; HL = display file position, BC = line/column.
;================================================================
	bit 1,(iy+001h)		;061a	fd cb 01 4e  ; IY+$01 = FLAGS
	jr nz,LDTVCU_PR		;061e	20 14
	ld bc,(05c88h)		;0620	ed 4b 88 5c  ; SPOSNCOL
	ld hl,(05c84h)		;0624	2a 84 5c  ; DFCC
	bit 0,(iy+002h)		;0627	fd cb 02 46  ; IY+$02 = TVFLAG
	ret z			;062b	c8
	ld bc,(05c8ah)		;062c	ed 4b 8a 5c  ; SPOSNLCOL
	ld hl,(05c86h)		;0630	2a 86 5c  ; DFCCL
	ret			;0633	c9
LDTVCU_PR:
	ld c,(iy+045h)		;0634	fd 4e 45  ; IY+$45 = PRPOSN
	ld hl,(05c80h)		;0637	2a 80 5c  ; PRCC
	ret			;063a	c9
GLYPH_CHAR:

;================================================================
; Module: IO_1
; Routine: GLYPH_CHAR ($063B)
; Prepare character glyph for display. Handles special
; characters, block graphics, UDGs, and tokens.
;================================================================
	cp 00ch			;063b	fe 0c
	jr nz,GLYPH_1		;063d	20 04
	ld a,07ah		;063f	3e 7a
	jr TOKEN_PRINT		;0641	18 51
GLYPH_1:
	cp 07ch			;0643	fe 7c
	jr z,TOKEN_PRINT		;0645	28 4d
	cp 07eh			;0647	fe 7e
	jr z,TOKEN_PRINT		;0649	28 49
	cp 07bh			;064b	fe 7b
	jr c,GLYPH_PRINT		;064d	38 0a
	cp 080h			;064f	fe 80
	jr nc,GLYPH_PRINT		;0651	30 06
	bit 4,(iy+001h)		;0653	fd cb 01 66  ; IY+$01 = FLAGS
	jr z,TOKEN_PRINT		;0657	28 3b
GLYPH_PRINT:
	cp 080h			;0659	fe 80
	jr c,CHAR_PRINT		;065b	38 3d
	cp 090h			;065d	fe 90
	jr nc,UDG_HANDLER		;065f	30 26
	ld b,a			;0661	47
	call MKBLKGR		;0662	cd 6d 06
	call LDTVCU		;0665	cd 1a 06
	ld de,05c92h		;0668	11 92 5c  ; MEMBOT
	jr CHAR_OUTPUT		;066b	18 47
MKBLKGR:
	ld hl,05c92h		;066d	21 92 5c  ; MEMBOT
	call MKBLKGR_HALF		;0670	cd 73 06
MKBLKGR_HALF:
	rr b			;0673	cb 18
	sbc a,a			;0675	9f
	and 00fh		;0676	e6 0f
	ld c,a			;0678	4f
	rr b			;0679	cb 18
	sbc a,a			;067b	9f
	and 0f0h		;067c	e6 f0
	or c			;067e	b1
	ld c,004h		;067f	0e 04
BLKGR_LOOP:
	ld (hl),a		;0681	77
	inc hl			;0682	23
	dec c			;0683	0d
	jr nz,BLKGR_LOOP		;0684	20 fb
	ret			;0686	c9
UDG_HANDLER:
	sub 0a5h		;0687	d6 a5
	jr nc,TOKEN_PRINT		;0689	30 09
	add a,015h		;068b	c6 15
	push bc			;068d	c5
	ld bc,(05c7bh)		;068e	ed 4b 7b 5c  ; UDG
	jr CHAR_LOOKUP		;0692	18 0b
TOKEN_PRINT:
	call PRTTOK		;0694	cd 45 07
	jp LDTVCU		;0697	c3 1a 06
CHAR_PRINT:
	push bc			;069a	c5
	ld bc,(05c36h)		;069b	ed 4b 36 5c  ; CHARS
CHAR_LOOKUP:
	ex de,hl		;069f	eb
	ld hl,05c3bh		;06a0	21 3b 5c  ; FLAGS
	res 0,(hl)		;06a3	cb 86
	cp 020h			;06a5	fe 20
	jr nz,CHAR_NOSPACE		;06a7	20 02
	set 0,(hl)		;06a9	cb c6
CHAR_NOSPACE:
	ld h,000h		;06ab	26 00
	ld l,a			;06ad	6f
	add hl,hl		;06ae	29
	add hl,hl		;06af	29
	add hl,hl		;06b0	29
	add hl,bc		;06b1	09
	pop bc			;06b2	c1
	ex de,hl		;06b3	eb
CHAR_OUTPUT:

;================================================================
; Module: IO_1
; Character bitmap output loop ($06B4)
;*** ZEBRA MODIFICATION: Column count $21 -> $41 at $06B7 ***
;*** ZEBRA MODIFICATION: ZX Printer inline test removed ($06BC-$06C6) ***
; Original ZX Printer path NOPped out — Centronics printing now
; goes through the channel system at $3D4A instead.
;================================================================
	ld a,c			;06b4	79
	dec a			;06b5	3d
	ld a,041h		;06b6	3e 41
	jr nz,CHAR_DO_PRINT		;06b8	20 0e
	dec b			;06ba	05
	ld c,a			;06bb	4f
	nop			;06bc	00
	nop			;06bd	00
	nop			;06be	00
	nop			;06bf	00
	nop			;06c0	00
	nop			;06c1	00
	nop			;06c2	00
	nop			;06c3	00
	nop			;06c4	00
	nop			;06c5	00
	nop			;06c6	00
	ld a,c			;06c7	79
CHAR_DO_PRINT:
	cp c			;06c8	b9
	push de			;06c9	d5
	call z,TVFUL	;06ca	cc 90 07
	pop de			;06cd	d1
	push bc			;06ce	c5
	push hl			;06cf	e5
	ld a,c			;06d0	79
	ld (iy+076h),a		;06d1	fd 77 76  ; IY+$76 = COL_PARITY
	ld a,(05c91h)		;06d4	3a 91 5c  ; PFLAG
	ld b,0ffh		;06d7	06 ff
	rra			;06d9	1f
	jr c,PFLAG_INVERT		;06da	38 01
	inc b			;06dc	04
PFLAG_INVERT:
	rra			;06dd	1f
	rra			;06de	1f
	sbc a,a			;06df	9f
	ld c,a			;06e0	4f
	ld a,008h		;06e1	3e 08
	and a			;06e3	a7
	ex de,hl		;06e4	eb
CHAR_SCANLINE:

;================================================================
; Module: IO_1
; Character scanline loop ($06E5)
;*** ZEBRA MODIFICATION: Dual-bank addressing ***
; Checks IY+$76 (column parity) and uses SET 5,D / RES 5,D
; to toggle between primary ($4000) and secondary ($6000) banks.
;================================================================
	ex af,af'		;06e5	08
	bit 0,(iy+076h)		;06e6	fd cb 76 46  ; IY+$76 = COL_PARITY
	jr nz,CHAR_DUALBANK_RD		;06ea	20 02
	set 5,d			;06ec	cb ea
CHAR_DUALBANK_RD:
	ld a,(de)		;06ee	1a
	and b			;06ef	a0
	xor (hl)		;06f0	ae
	xor c			;06f1	a9
	ld (de),a		;06f2	12
	bit 0,(iy+076h)		;06f3	fd cb 76 46  ; IY+$76 = COL_PARITY
	jr nz,CHAR_DUALBANK_WR		;06f7	20 02
	res 5,d			;06f9	cb aa
CHAR_DUALBANK_WR:
	ex af,af'		;06fb	08
	inc d			;06fc	14
	inc hl			;06fd	23
	dec a			;06fe	3d
	jr nz,CHAR_SCANLINE		;06ff	20 e4
CHAR_DONE:
	ex de,hl		;0701	eb
	pop hl			;0702	e1
	pop bc			;0703	c1
	dec c			;0704	0d
	bit 0,c			;0705	cb 41
	ret z			;0707	c8
	inc hl			;0708	23
	ret			;0709	c9
	nop			;070a	00
	nop			;070b	00
	nop			;070c	00
	nop			;070d	00
	nop			;070e	00
	nop			;070f	00

;================================================================
; Module: IO_1
; Routine: ATTBYT ($0710)
;*** ZEBRA MODIFICATION: Complete rewrite ($0710-$073E) ***
; Original: Computes attribute address from display address.
; Zebra: Returns immediately (RET at $0710).
; New 64-col pixel handler at $0711:
;   CP 4 / JR C / SET 5,H (toggle to secondary bank)
;   Rotates pixel mask, applies OVER/INVERSE, stores result.
;   $0733-$073E: NOP padding (freed space).
;================================================================
	ret			;0710	c9
PIX64_HANDLER:
	cp 004h			;0711	fe 04
	jr c,PIX64_MASK		;0713	38 02
	set 5,h			;0715	cb ec
PIX64_MASK:
	and 003h		;0717	e6 03
	ld b,a			;0719	47
	inc b			;071a	04
	ld a,0fch		;071b	3e fc
PIX64_ROTATE:
	rrca			;071d	0f
	rrca			;071e	0f
	djnz PIX64_ROTATE		;071f	10 fc
	ld b,a			;0721	47
	ld a,(hl)		;0722	7e
	ld c,(iy+057h)		;0723	fd 4e 57  ; IY+$57 = PFLAG
	bit 0,c			;0726	cb 41
	jr nz,PIX64_OVER		;0728	20 01
	and b			;072a	a0
PIX64_OVER:
	bit 2,c			;072b	cb 51
	jr nz,PIX64_STORE		;072d	20 02
	xor b			;072f	a8
	cpl			;0730	2f
PIX64_STORE:
	ld (hl),a		;0731	77
	ret			;0732	c9
	nop			;0733	00
	nop			;0734	00
	nop			;0735	00
	nop			;0736	00
	nop			;0737	00
	nop			;0738	00
	nop			;0739	00
	nop			;073a	00
	nop			;073b	00
	nop			;073c	00
	nop			;073d	00
	nop			;073e	00
PUTMES:

;================================================================
; Module: IO_1
; Routine: PUTMES ($073F)
; Print a system message by number.
;================================================================
	push hl			;073f	e5
	ld h,000h		;0740	26 00
	ex (sp),hl		;0742	e3
	jr PUTMES_2		;0743	18 0a
PRTTOK:

;================================================================
; Module: IO_1
; Routine: PRTTOK ($0745)
; Print the token whose value is in A.
;================================================================
	ld de,TOKENS		;0745	11 98 00
	cp 05bh			;0748	fe 5b
	jr c,PUTMES_1		;074a	38 02
	sub 01fh		;074c	d6 1f
PUTMES_1:
	push af			;074e	f5
PUTMES_2:
	call FINDMSG		;074f	cd 7c 07
	jr c,MSG_LOOP		;0752	38 09
	ld a,020h		;0754	3e 20
	bit 0,(iy+001h)		;0756	fd cb 01 46  ; IY+$01 = FLAGS
	call z,PR_TV2	;075a	cc 76 07
MSG_LOOP:
	ld a,(de)		;075d	1a
	and 07fh		;075e	e6 7f
	call PR_TV2		;0760	cd 76 07
	ld a,(de)		;0763	1a
	inc de			;0764	13
	add a,a			;0765	87
	jr nc,MSG_LOOP		;0766	30 f5
	pop de			;0768	d1
	cp 048h			;0769	fe 48
	jr z,MSG_SPACE		;076b	28 03
	cp 082h			;076d	fe 82
	ret c			;076f	d8
MSG_SPACE:
	ld a,d			;0770	7a
	cp 003h			;0771	fe 03
	ret c			;0773	d8
	ld a,020h		;0774	3e 20
PR_TV2:

;================================================================
; Module: IO_1
; Routine: PR_TV2 ($0776)
; Output character via RST $10 with register save/restore.
;================================================================
	push de			;0776	d5
	exx			;0777	d9
	rst 10h			;0778	d7
	exx			;0779	d9
	pop de			;077a	d1
	ret			;077b	c9
FINDMSG:

;================================================================
; Module: IO_1
; Routine: FINDMSG ($077C)
; Find message number A in table at (DE).
;================================================================
	push af			;077c	f5
	ex de,hl		;077d	eb
	inc a			;077e	3c
FINDMSG_LP:
	bit 7,(hl)		;077f	cb 7e
	inc hl			;0781	23
	jr z,FINDMSG_LP		;0782	28 fb
	dec a			;0784	3d
	jr nz,FINDMSG_LP		;0785	20 f8
	ex de,hl		;0787	eb
	pop af			;0788	f1
	cp 020h			;0789	fe 20
	ret c			;078b	d8
	ld a,(de)		;078c	1a
	sub 041h		;078d	d6 41
	ret			;078f	c9
TVFUL:

;================================================================
; Module: IO_1
; Routine: TVFUL ($0790)
; Check if the display is full. Handle scrolling or error.
;================================================================
	bit 1,(iy+001h)		;0790	fd cb 01 4e  ; IY+$01 = FLAGS
	ret nz			;0794	c0
	ld de,STTVC		;0795	11 12 09
	push de			;0798	d5
	ld a,b			;0799	78
	bit 0,(iy+002h)		;079a	fd cb 02 46  ; IY+$02 = TVFLAG
	jp nz,TVFUL_LHS		;079e	c2 3d 08
	cp (iy+031h)		;07a1	fd be 31  ; IY+$31 = DFSZ
	jr c,ERR5		;07a4	38 1b
	ret nz			;07a6	c0
	bit 4,(iy+002h)		;07a7	fd cb 02 66  ; IY+$02 = TVFLAG
	jr z,SCROLL_CHECK		;07ab	28 16
	ld e,(iy+02dh)		;07ad	fd 5e 2d  ; IY+$2D = BREG
	dec e			;07b0	1d
	jr z,DO_SCROLL		;07b1	28 5a
	ld a,000h		;07b3	3e 00
	call SELECT		;07b5	cd 30 12
	ld sp,(05c3fh)		;07b8	ed 7b 3f 5c  ; LISTSP
	res 4,(iy+002h)		;07bc	fd cb 02 a6  ; IY+$02 = TVFLAG
	ret			;07c0	c9
ERR5:
	rst 8			;07c1	cf
	inc b			;07c2	04
SCROLL_CHECK:
	dec (iy+052h)		;07c3	fd 35 52  ; IY+$52 = SCRCT
	jr nz,DO_SCROLL		;07c6	20 45
	ld a,018h		;07c8	3e 18
	sub b			;07ca	90
	ld (05c8ch),a		;07cb	32 8c 5c  ; SCRCT
	ld hl,(05c8fh)		;07ce	2a 8f 5c  ; ATTRT
	push hl			;07d1	e5
	ld a,(05c91h)		;07d2	3a 91 5c  ; PFLAG
	push af			;07d5	f5
	ld a,0fdh		;07d6	3e fd
	call SELECT		;07d8	cd 30 12
	xor a			;07db	af
	ld de,SCROLLMSG		;07dc	11 33 08
	call PUTMES		;07df	cd 3f 07
	set 5,(iy+002h)		;07e2	fd cb 02 ee  ; IY+$02 = TVFLAG
	ld hl,05c3bh		;07e6	21 3b 5c  ; FLAGS
	set 3,(hl)		;07e9	cb de
	res 5,(hl)		;07eb	cb ae
	exx			;07ed	d9
	call RDCH		;07ee	cd cf 11
	exx			;07f1	d9
	cp 020h			;07f2	fe 20
	jr z,SCROLL_BREAK		;07f4	28 45
	cp 0e2h			;07f6	fe e2
	jr z,SCROLL_BREAK		;07f8	28 41
	or 020h			;07fa	f6 20
	cp 06eh			;07fc	fe 6e
	jr z,SCROLL_BREAK		;07fe	28 3b
	ld a,0feh		;0800	3e fe
	call SELECT		;0802	cd 30 12
	pop af			;0805	f1
	ld (05c91h),a		;0806	32 91 5c  ; PFLAG
	pop hl			;0809	e1
	ld (05c8fh),hl		;080a	22 8f 5c  ; ATTRT
DO_SCROLL:
	call SCRL1		;080d	cd 39 09
	ld b,(iy+031h)		;0810	fd 46 31  ; IY+$31 = DFSZ
	inc b			;0813	04
	ld c,041h		;0814	0e 41
	push bc			;0816	c5
	call DF_ADDR		;0817	cd d6 09
	ld a,h			;081a	7c
	rrca			;081b	0f
	rrca			;081c	0f
	rrca			;081d	0f
	and 003h		;081e	e6 03
	or 058h			;0820	f6 58
	ld h,a			;0822	67
	ld de,05ae0h		;0823	11 e0 5a
	ld a,(de)		;0826	1a
	ld c,(hl)		;0827	4e
	ld b,020h		;0828	06 20
	ex de,hl		;082a	eb
SWAP_ATTR_LP:
	ld (de),a		;082b	12
	ld (hl),c		;082c	71
	inc de			;082d	13
	inc hl			;082e	23
	djnz SWAP_ATTR_LP		;082f	10 fa
	pop bc			;0831	c1
	ret			;0832	c9
SCROLLMSG:

;================================================================
; "scroll?" message data
;================================================================
	add a,b			;0833	80
	ld (hl),e		;0834	73
	ld h,e			;0835	63
	ld (hl),d		;0836	72
	ld l,a			;0837	6f
	ld l,h			;0838	6c
	ld l,h			;0839	6c
	cp a			;083a	bf
SCROLL_BREAK:
	rst 8			;083b	cf
	inc c			;083c	0c
TVFUL_LHS:
	cp 002h			;083d	fe 02
	jr c,ERR5		;083f	38 80
	add a,(iy+031h)		;0841	fd 86 31  ; IY+$31 = DFSZ
	sub 019h		;0844	d6 19
	ret nc			;0846	d0
	neg			;0847	ed 44
	push bc			;0849	c5
	ld b,a			;084a	47
	ld hl,(05c8fh)		;084b	2a 8f 5c  ; ATTRT
	push hl			;084e	e5
	ld hl,(05c91h)		;084f	2a 91 5c  ; PFLAG
	push hl			;0852	e5
	call DO_ATTS		;0853	cd 88 08
	ld a,b			;0856	78
SCROLL_LINES:
	push af			;0857	f5
	ld hl,05c6bh		;0858	21 6b 5c  ; DFSZ
	ld b,(hl)		;085b	46
	ld a,b			;085c	78
	inc a			;085d	3c
	ld (hl),a		;085e	77
	ld hl,05c89h		;085f	21 89 5c  ; SPOSNLIN
	cp (hl)			;0862	be
	jr c,SCROLL_DO		;0863	38 03
	inc (hl)		;0865	34
	ld b,018h		;0866	06 18
SCROLL_DO:
	call SCRLB		;0868	cd 3b 09
	pop af			;086b	f1
	dec a			;086c	3d
	jr nz,SCROLL_LINES		;086d	20 e8
	pop hl			;086f	e1
	ld (iy+057h),l		;0870	fd 75 57  ; IY+$57 = PFLAG
	pop hl			;0873	e1
	ld (05c8fh),hl		;0874	22 8f 5c  ; ATTRT
	ld bc,(05c88h)		;0877	ed 4b 88 5c  ; SPOSNCOL
	res 0,(iy+002h)		;087b	fd cb 02 86  ; IY+$02 = TVFLAG
	call STTVC		;087f	cd 12 09
	set 0,(iy+002h)		;0882	fd cb 02 c6  ; IY+$02 = TVFLAG
	pop bc			;0886	c1
	ret			;0887	c9
DO_ATTS:

;================================================================
; Module: IO_1
; Routine: DO_ATTS ($0888)
; Setup printing attributes (temporary from permanent).
;================================================================
	xor a			;0888	af
	ld hl,(05c8dh)		;0889	2a 8d 5c  ; ATTRP
	bit 0,(iy+002h)		;088c	fd cb 02 46  ; IY+$02 = TVFLAG
	jr z,DOATTS_1		;0890	28 04
	ld h,a			;0892	67
	ld l,(iy+00eh)		;0893	fd 6e 0e  ; IY+$0E = BORDCR
DOATTS_1:
	ld (05c8fh),hl		;0896	22 8f 5c  ; ATTRT
	ld hl,05c91h		;0899	21 91 5c  ; PFLAG
	jr nz,R_ATTS_1		;089c	20 02
	ld a,(hl)		;089e	7e
	rrca			;089f	0f
R_ATTS_1:
	xor (hl)		;08a0	ae
	and 055h		;08a1	e6 55
	xor (hl)		;08a3	ae
	ld (hl),a		;08a4	77
	ret			;08a5	c9
K_CLS:

;================================================================
; Module: IO_1
; Routine: K_CLS ($08A6) / CLLHS ($08A9)
; Clear screen / clear lower half screen.
;================================================================
	call CLS		;08a6	cd ea 08
CLLHS:
	ld hl,05c3ch		;08a9	21 3c 5c  ; TVFLAG
	res 5,(hl)		;08ac	cb ae
	set 0,(hl)		;08ae	cb c6
	call DO_ATTS		;08b0	cd 88 08
	ld b,(iy+031h)		;08b3	fd 46 31  ; IY+$31 = DFSZ
	call CLS_B		;08b6	cd 7f 09
	ld hl,05ac0h		;08b9	21 c0 5a
	ld a,(05c8dh)		;08bc	3a 8d 5c  ; ATTRP
	dec b			;08bf	05
	jr CLS_NEXT		;08c0	18 07
CLS_LINE:
	ld c,020h		;08c2	0e 20
CLS_CHAR:
	dec hl			;08c4	2b
	ld (hl),a		;08c5	77
	dec c			;08c6	0d
	jr nz,CLS_CHAR		;08c7	20 fb
CLS_NEXT:
	djnz CLS_LINE		;08c9	10 f7
	ld (iy+031h),002h	;08cb	fd 36 31 02  ; IY+$31 = DFSZ
CLS_LHS:

;================================================================
; Module: IO_1
; Routine: CLS_LHS ($08CF)
;*** ZEBRA MODIFICATION: BC = $1741 instead of $1721 ***
; at $08D4 for 64-column mode (65 columns).
;*** ZEBRA MODIFICATION: Channel setup NOPs ($08D9-$08E9) ***
; 17 bytes of channel output setup replaced with NOPs.
;================================================================
	ld a,0fdh		;08cf	3e fd
	call SELECT		;08d1	cd 30 12
	ld bc,LINE_LEN_HI		;08d4	01 41 17
	jr STTVC		;08d7	18 39
	nop			;08d9	00
	nop			;08da	00
	nop			;08db	00
	nop			;08dc	00
	nop			;08dd	00
	nop			;08de	00
	nop			;08df	00
	nop			;08e0	00
	nop			;08e1	00
	nop			;08e2	00
	nop			;08e3	00
	nop			;08e4	00
	nop			;08e5	00
	nop			;08e6	00
	nop			;08e7	00
	nop			;08e8	00
	nop			;08e9	00
CLS:

;================================================================
; Module: IO_1
; Routine: CLS ($08EA)
; Clear the entire screen, reset coordinates.
;================================================================
	ld hl,LROS_HEADER		;08ea	21 00 00
	ld (05c7dh),hl		;08ed	22 7d 5c  ; XCOORD
	res 0,(iy+030h)		;08f0	fd cb 30 86  ; IY+$30 = FLAGS2
	call CLS_LHS		;08f4	cd cf 08
	ld a,0feh		;08f7	3e fe
	call SELECT		;08f9	cd 30 12
	call DO_ATTS		;08fc	cd 88 08
	ld b,018h		;08ff	06 18
	call CLS_B		;0901	cd 7f 09
	ld (iy+052h),001h	;0904	fd 36 52 01  ; IY+$52 = SCRCT
	ld bc,LOAD_SIZE		;0908	01 41 18
	jr STTVC		;090b	18 05
	xor 007h		;090d	ee 07
	jp DUALCOPY_POP2		;090f	c3 ef 04
STTVC:

;================================================================
; Module: IO_1A
; Routine: STTVC ($0912)
; Set TV current print position pointers.
;================================================================
	ld hl,05b00h		;0912	21 00 5b
	bit 1,(iy+001h)		;0915	fd cb 01 4e  ; IY+$01 = FLAGS
	jr nz,STTVC_2		;0919	20 12
	ld a,b			;091b	78
	bit 0,(iy+002h)		;091c	fd cb 02 46  ; IY+$02 = TVFLAG
	jr z,STTVC_1		;0920	28 05
	add a,(iy+031h)		;0922	fd 86 31  ; IY+$31 = DFSZ
	sub 018h		;0925	d6 18
STTVC_1:
	push bc			;0927	c5
	ld b,a			;0928	47
	call DF_ADDR		;0929	cd d6 09
	pop bc			;092c	c1
STTVC_2:
	ld a,041h		;092d	3e 41
	sub c			;092f	91
	srl a			;0930	cb 3f
	ld e,a			;0932	5f
	ld d,000h		;0933	16 00
	add hl,de		;0935	19
	jp STTVCU		;0936	c3 f3 05
SCRL1:

;================================================================
; Module: IO_1A
; Routine: SCRL1 ($0939) / SCRLB ($093B)
; Scroll screen up by one line / B lines.
;*** ZEBRA MODIFICATION: LDIR replaced with CALL $04E8 ***
; at $0952 and $0965 for dual-bank scrolling.
;================================================================
	ld b,017h		;0939	06 17
SCRLB:
	call DF_ADDR		;093b	cd d6 09
	ld c,008h		;093e	0e 08
SCRL_SCAN:
	push bc			;0940	c5
	push hl			;0941	e5
	ld a,b			;0942	78
	and 007h		;0943	e6 07
	ld a,b			;0945	78
	jr nz,SCRL_CONT		;0946	20 0d
SCRL_BLOCK:
	ex de,hl		;0948	eb
	ld hl,0f8e0h		;0949	21 e0 f8
	add hl,de		;094c	19
	ex de,hl		;094d	eb
	ld bc,NEXTCH_RST		;094e	01 20 00
	dec a			;0951	3d
	call DUALBANK_COPY		;0952	cd e8 04
SCRL_CONT:
	ex de,hl		;0955	eb
	ld hl,0ffe0h		;0956	21 e0 ff
	add hl,de		;0959	19
	ex de,hl		;095a	eb
	ld b,a			;095b	47
	and 007h		;095c	e6 07
	rrca			;095e	0f
	rrca			;095f	0f
	rrca			;0960	0f
	ld c,a			;0961	4f
	ld a,b			;0962	78
	ld b,000h		;0963	06 00
	call DUALBANK_COPY		;0965	cd e8 04
	ld b,007h		;0968	06 07
	add hl,bc		;096a	09
	and 0f8h		;096b	e6 f8
	jr nz,SCRL_BLOCK		;096d	20 d9
	pop hl			;096f	e1
	inc h			;0970	24
	pop bc			;0971	c1
	dec c			;0972	0d
	jr nz,SCRL_SCAN		;0973	20 cb
	nop			;0975	00
	nop			;0976	00
	nop			;0977	00
	nop			;0978	00
	nop			;0979	00
	nop			;097a	00
	nop			;097b	00
	nop			;097c	00
	ld b,001h		;097d	06 01
CLS_B:

;================================================================
; Module: IO_1A
; Routine: CLS_B ($097F)
; Clear lower B lines of the display.
;*** ZEBRA MODIFICATION: Dual-bank clear ***
; Uses SET 5,D / SET 5,H for secondary bank.
;*** ZEBRA MODIFICATION: Column count $21 -> $41 at $09C1 ***
;================================================================
	push bc			;097f	c5
	call DF_ADDR		;0980	cd d6 09
	ld c,008h		;0983	0e 08
CLS_B_SCAN:
	push bc			;0985	c5
	push hl			;0986	e5
	ld a,b			;0987	78
CLS_B_BLOCK:
	and 007h		;0988	e6 07
	rrca			;098a	0f
	rrca			;098b	0f
	rrca			;098c	0f
	ld c,a			;098d	4f
	ld a,b			;098e	78
	ld b,000h		;098f	06 00
	dec c			;0991	0d
	ld d,h			;0992	54
	ld e,l			;0993	5d
	ld (hl),000h		;0994	36 00
	inc de			;0996	13
	push bc			;0997	c5
	push de			;0998	d5
	push hl			;0999	e5
	ldir			;099a	ed b0
	pop hl			;099c	e1
	pop de			;099d	d1
	pop bc			;099e	c1
	set 5,d			;099f	cb ea
	set 5,h			;09a1	cb ec
	ld (hl),000h		;09a3	36 00
	ldir			;09a5	ed b0
	res 5,h			;09a7	cb ac
	ld de,CHAR_DONE		;09a9	11 01 07
	add hl,de		;09ac	19
	dec a			;09ad	3d
	and 0f8h		;09ae	e6 f8
	ld b,a			;09b0	47
	jr nz,CLS_B_BLOCK		;09b1	20 d5
	pop hl			;09b3	e1
	inc h			;09b4	24
	pop bc			;09b5	c1
	dec c			;09b6	0d
	jr nz,CLS_B_SCAN		;09b7	20 cc
	nop			;09b9	00
	nop			;09ba	00
	nop			;09bb	00
	nop			;09bc	00
	nop			;09bd	00
	nop			;09be	00
	pop bc			;09bf	c1
	ld c,041h		;09c0	0e 41
	ret			;09c2	c9
	ld a,h			;09c3	7c
	rrca			;09c4	0f
	rrca			;09c5	0f
	rrca			;09c6	0f
	dec a			;09c7	3d
	or 050h			;09c8	f6 50
	ld h,a			;09ca	67
	ex de,hl		;09cb	eb
	ld h,c			;09cc	61
	ld l,b			;09cd	68
	add hl,hl		;09ce	29
	add hl,hl		;09cf	29
	add hl,hl		;09d0	29
	add hl,hl		;09d1	29
	add hl,hl		;09d2	29
	ld b,h			;09d3	44
	ld c,l			;09d4	4d
	ret			;09d5	c9
DF_ADDR:

;================================================================
; Module: IO_1A
; Routine: DF_ADDR ($09D6)
; Calculate display file address for line B.
;================================================================
	ld a,018h		;09d6	3e 18
	sub b			;09d8	90
	ld d,a			;09d9	57
	rrca			;09da	0f
DF_ADDR_1:
	rrca			;09db	0f
	rrca			;09dc	0f
	and 0e0h		;09dd	e6 e0
	ld l,a			;09df	6f
	ld a,d			;09e0	7a
	and 018h		;09e1	e6 18
	or 040h			;09e3	f6 40
	ld h,a			;09e5	67
	ret			;09e6	c9

;================================================================
; Module: IO_1A
; Routine: PAUSE handler ($09E7)
; Wait for keypress, then clear lower screen.
;================================================================
	push af			;09e7	f5
	push bc			;09e8	c5
	push de			;09e9	d5
	ld bc,09c40h		;09ea	01 40 9c
WAIT_LOOP:
	dec bc			;09ed	0b
	ld a,c			;09ee	79
	or b			;09ef	b0
	jr nz,WAIT_LOOP		;09f0	20 fb
WAIT_KEY:
	xor a			;09f2	af
	in a,(0feh)		;09f3	db fe
	and 01fh		;09f5	e6 1f
	cp 01fh			;09f7	fe 1f
	jr z,WAIT_KEY		;09f9	28 f7
	call CLLHS		;09fb	cd a9 08
	pop de			;09fe	d1
	pop bc			;09ff	c1
	pop af			;0a00	f1
	ret			;0a01	c9

;================================================================
;*** ZEBRA MODIFICATION: K_DUMP replaced with COPY dispatcher + cursor flash ($0A02-$0A4A) ***
; Original ZX Printer screen dump replaced with two routines:
;
; COPY command dispatcher ($0A02-$0A08):
;   LD HL,(COPY_addr) / LD A,H / OR L / RET Z / JP (HL)
;   Dispatches COPY to the Centronics COPY routine at COPY_addr ($FFE8).
;   Default target is $3ED4 (Epson-compatible screen dump).
;
; Cursor flash routine ($0A09-$0A37):
;   Reuses COPYtab RAM ($FFF8) for cursor screen address and
;   COPYtab+5 ($FFFD) as flash countdown. Inverts 8 scanlines
;   at cursor position when counter reaches zero.
;   Safe because cursor flash and COPY never run simultaneously.
;
; Keyboard scan ($0A3A):
;   CALL $02E1 then RET.
;   $0A3E-$0A49: NOP padding (freed space).
;================================================================
	ld hl,(0ffe8h)		;0a02	2a e8 ff  ; COPY_addr
	ld a,h			;0a05	7c
	or l			;0a06	b5
	ret z			;0a07	c8
	jp (hl)			;0a08	e9
	ld hl,(0fff8h)		;0a09	2a f8 ff  ; COPYtab
	nop			;0a0c	00
	nop			;0a0d	00
	nop			;0a0e	00
	nop			;0a0f	00
	nop			;0a10	00
	ld a,(0fffdh)		;0a11	3a fd ff  ; COPYtab+5
	dec a			;0a14	3d
	ld (0fffdh),a		;0a15	32 fd ff  ; COPYtab+5
	jr nz,CURSOR_KEYSCAN		;0a18	20 20
	ld a,(05c8ah)		;0a1a	3a 8a 5c  ; SPOSNLCOL
	nop			;0a1d	00
	nop			;0a1e	00
	nop			;0a1f	00
	nop			;0a20	00
	nop			;0a21	00
	nop			;0a22	00
PRINTER_STUB:
	nop			;0a23	00
	nop			;0a24	00
CURSOR_BANK:
	nop			;0a25	00
	nop			;0a26	00
	bit 0,a			;0a27	cb 47
	jr z,CURSOR_FLASH_LP		;0a29	28 02
	set 5,h			;0a2b	cb ec
CURSOR_FLASH_LP:
	ld b,008h		;0a2d	06 08
CURSOR_INV_LP:
	ld a,(hl)		;0a2f	7e
	cpl			;0a30	2f
	ld (hl),a		;0a31	77
	inc h			;0a32	24
	djnz CURSOR_INV_LP		;0a33	10 fa
CURSOR_RESET:
	ld a,00fh		;0a35	3e 0f
	ld (0fffdh),a		;0a37	32 fd ff  ; COPYtab+5
CURSOR_KEYSCAN:
	call UPD_K		;0a3a	cd e1 02
	ret			;0a3d	c9
	nop			;0a3e	00
	nop			;0a3f	00
	nop			;0a40	00
	nop			;0a41	00
	nop			;0a42	00
	nop			;0a43	00
	nop			;0a44	00
	nop			;0a45	00
	nop			;0a46	00
	nop			;0a47	00
	nop			;0a48	00
	nop			;0a49	00

;================================================================
; Module: TAPE
; Routine: TAPE_HEADER ($0A4A)
; Tape save/load header handling.
;================================================================
	ld a,b			;0a4a	78
	cp 003h			;0a4b	fe 03
	sbc a,a			;0a4d	9f
	and 002h		;0a4e	e6 02
	out (0fbh),a		;0a50	d3 fb
	ld d,a			;0a52	57
TAPE_LOOP:
	call TAPE_SYNC		;0a53	cd 09 20
	jr c,TAPE_READ		;0a56	38 0a
	ld a,004h		;0a58	3e 04
	out (0fbh),a		;0a5a	d3 fb
	ei			;0a5c	fb
	call CURSOR_RESET		;0a5d	cd 35 0a
	rst 8			;0a60	cf
	inc c			;0a61	0c
TAPE_READ:
	in a,(0fbh)		;0a62	db fb
	add a,a			;0a64	87
	ret m			;0a65	f8
	jr nc,TAPE_LOOP		;0a66	30 eb
	ld c,020h		;0a68	0e 20
TAPE_BYTE:
	ld e,(hl)		;0a6a	5e
	inc hl			;0a6b	23
	ld b,008h		;0a6c	06 08
TAPE_BIT:
	rl d			;0a6e	cb 12
	rl e			;0a70	cb 13
	rr d			;0a72	cb 1a
TAPE_WAIT:
	in a,(0fbh)		;0a74	db fb
	rra			;0a76	1f
	jr nc,TAPE_WAIT		;0a77	30 fb
	ld a,d			;0a79	7a
	out (0fbh),a		;0a7a	d3 fb
	djnz TAPE_BIT		;0a7c	10 f0
	dec c			;0a7e	0d
	jr nz,TAPE_BYTE		;0a7f	20 e9
	ret			;0a81	c9
EDITOR:

;================================================================
; Module: EDITOR
; Routine: EDITOR ($0A82)
; Main line editor loop.
;================================================================
	ld hl,(05c3dh)		;0a82	2a 3d 5c  ; ERRSP
	push hl			;0a85	e5
EDITOR_LOOP:
	ld hl,ED_ERROR		;0a86	21 e5 0b
	push hl			;0a89	e5
	ld (05c3dh),sp		;0a8a	ed 73 3d 5c  ; ERRSP
ED_KEYS:
	call RDCH		;0a8e	cd cf 11
	push af			;0a91	f5
	ld d,000h		;0a92	16 00
	ld e,(iy-001h)		;0a94	fd 5e ff
	ld hl,TOK_SIN		;0a97	21 c8 00
	call PARP		;0a9a	cd f3 03
	pop af			;0a9d	f1
	ld hl,ED_KEYS		;0a9e	21 8e 0a
	push hl			;0aa1	e5
	cp 00ch			;0aa2	fe 0c
	jr nz,ED_CTRL		;0aa4	20 0c
	bit 5,(iy+030h)		;0aa6	fd cb 30 6e  ; IY+$30 = FLAGS2
	jr nz,ED_CTRL		;0aaa	20 06
	bit 3,(iy+001h)		;0aac	fd cb 01 5e  ; IY+$01 = FLAGS
	jr z,ED_CHAR		;0ab0	28 35
ED_CTRL:
	cp 018h			;0ab2	fe 18
	jr nc,ED_CHAR		;0ab4	30 31
	cp 007h			;0ab6	fe 07
	jr c,ED_CHAR		;0ab8	38 2d
	cp 010h			;0aba	fe 10
	jr c,ED_SPECIAL		;0abc	38 3a
	ld bc,LROS_BC+1		;0abe	01 02 00
	ld d,a			;0ac1	57
	cp 016h			;0ac2	fe 16
	jr c,ED_AT_TAB		;0ac4	38 0c
	inc bc			;0ac6	03
	bit 7,(iy+037h)		;0ac7	fd cb 37 7e  ; IY+$37 = FLAGX+1
	jp z,ED_SKIP		;0acb	ca 84 0b
	call RDCH		;0ace	cd cf 11
	ld e,a			;0ad1	5f
ED_AT_TAB:
	call RDCH		;0ad2	cd cf 11
	push de			;0ad5	d5
	ld hl,(05c5bh)		;0ad6	2a 5b 5c  ; KCUR
	res 0,(iy+007h)		;0ad9	fd cb 07 86  ; IY+$07 = MODE
	call MAKE_ROOM		;0add	cd bb 12
	pop bc			;0ae0	c1
	inc hl			;0ae1	23
	ld (hl),b		;0ae2	70
	inc hl			;0ae3	23
	ld (hl),c		;0ae4	71
	jr ED_STORE		;0ae5	18 0a
ED_CHAR:
	res 0,(iy+007h)		;0ae7	fd cb 07 86  ; IY+$07 = MODE
	ld hl,(05c5bh)		;0aeb	2a 5b 5c  ; KCUR
	call MAKE_ROOM_1		;0aee	cd b8 12
ED_STORE:
	ld (de),a		;0af1	12
	inc de			;0af2	13
	ld (05c5bh),de		;0af3	ed 53 5b 5c  ; KCUR
	ret			;0af7	c9
ED_SPECIAL:
	ld e,a			;0af8	5f
	ld d,000h		;0af9	16 00
	ld hl,ED_JUMP_TBL		;0afb	21 ff 0a
	add hl,de		;0afe	19
ED_JUMP_TBL:
	ld e,(hl)		;0aff	5e
	add hl,de		;0b00	19
	push hl			;0b01	e5
	ld hl,(05c5bh)		;0b02	2a 5b 5c  ; KCUR
	ret			;0b05	c9
	add hl,bc		;0b06	09
	ld h,(hl)		;0b07	66
	ld l,d			;0b08	6a
	ld d,b			;0b09	50
	or l			;0b0a	b5
	ld (hl),b		;0b0b	70
	ld a,(hl)		;0b0c	7e
	rst 8			;0b0d	cf
	call nc,0492ah		;0b0e	d4 2a 49
	ld e,h			;0b11	5c
	bit 5,(iy+037h)		;0b12	fd cb 37 6e  ; IY+$37 = FLAGX+1
	jp nz,CLEAR_ELINE		;0b16	c2 fd 0b
	call FIND_LINE		;0b19	cd d6 16
	call GET_LINENO		;0b1c	cd 24 13
	ld a,d			;0b1f	7a
	or e			;0b20	b3
	jp z,CLEAR_ELINE		;0b21	ca fd 0b
	push hl			;0b24	e5
	inc hl			;0b25	23
	ld c,(hl)		;0b26	4e
	inc hl			;0b27	23
	ld b,(hl)		;0b28	46
	ld hl,ERROR+2		;0b29	21 0a 00
	add hl,bc		;0b2c	09
	ld b,h			;0b2d	44
	ld c,l			;0b2e	4d
	call TEST_ROOM		;0b2f	cd bb 1f
	call CLEAR_ELINE		;0b32	cd fd 0b
	ld hl,(05c51h)		;0b35	2a 51 5c  ; CURCHL
	ex (sp),hl		;0b38	e3
	push hl			;0b39	e5
	ld a,0ffh		;0b3a	3e ff
	call SELECT		;0b3c	cd 30 12
	pop hl			;0b3f	e1
	dec hl			;0b40	2b
	dec (iy+00fh)		;0b41	fd 35 0f  ; IY+$0F = E_PPC
	call LIST_NOLINE		;0b44	cd ac 15
	inc (iy+00fh)		;0b47	fd 34 0f  ; IY+$0F = E_PPC
	ld hl,(05c59h)		;0b4a	2a 59 5c  ; ELINE
	inc hl			;0b4d	23
	inc hl			;0b4e	23
	inc hl			;0b4f	23
	inc hl			;0b50	23
	ld (05c5bh),hl		;0b51	22 5b 5c  ; KCUR
	pop hl			;0b54	e1
	call SET_CURCHL		;0b55	cd 48 12
	ret			;0b58	c9
	bit 5,(iy+037h)		;0b59	fd cb 37 6e  ; IY+$37 = FLAGX+1
	jr nz,ED_ERR		;0b5d	20 08
	ld hl,05c49h		;0b5f	21 49 5c  ; E_PPC
	call SET_LINE		;0b62	cd 5b 16
	jr ED_LIST		;0b65	18 6d
ED_ERR:
	ld (iy+000h),010h	;0b67	fd 36 00 10  ; IY+$00 = ERR_NR
	jr ED_POP2		;0b6b	18 1d
	call ED_FINDLINE		;0b6d	cd 97 0b
	jr ED_SET_KCUR		;0b70	18 05
	ld a,(hl)		;0b72	7e
	cp 00dh			;0b73	fe 0d
	ret z			;0b75	c8
	inc hl			;0b76	23
ED_SET_KCUR:
	ld (05c5bh),hl		;0b77	22 5b 5c  ; KCUR
	ret			;0b7a	c9
	call ED_FINDLINE		;0b7b	cd 97 0b
	ld bc,LROS_BC		;0b7e	01 01 00
	jp RECLAIM		;0b81	c3 50 17
ED_SKIP:
	call RDCH		;0b84	cd cf 11
	call RDCH		;0b87	cd cf 11
ED_POP2:
	pop hl			;0b8a	e1
	pop hl			;0b8b	e1
ED_RESTORE:
	pop hl			;0b8c	e1
	ld (05c3dh),hl		;0b8d	22 3d 5c  ; ERRSP
	bit 7,(iy+000h)		;0b90	fd cb 00 7e  ; IY+$00 = ERR_NR
	ret nz			;0b94	c0
	ld sp,hl		;0b95	f9
	ret			;0b96	c9
ED_FINDLINE:
	scf			;0b97	37
	call GET_ELINE		;0b98	cd fb 0c
	sbc hl,de		;0b9b	ed 52
	add hl,de		;0b9d	19
	inc hl			;0b9e	23
	pop bc			;0b9f	c1
	ret c			;0ba0	d8
	push bc			;0ba1	c5
	ld b,h			;0ba2	44
	ld c,l			;0ba3	4d
ED_LINE_SCAN:
	ld h,d			;0ba4	62
	ld l,e			;0ba5	6b
	inc hl			;0ba6	23
	ld a,(de)		;0ba7	1a
	and 0f0h		;0ba8	e6 f0
	cp 010h			;0baa	fe 10
	jr nz,ED_LINE_CMP		;0bac	20 09
	inc hl			;0bae	23
	ld a,(de)		;0baf	1a
	sub 017h		;0bb0	d6 17
	adc a,000h		;0bb2	ce 00
	jr nz,ED_LINE_CMP		;0bb4	20 01
	inc hl			;0bb6	23
ED_LINE_CMP:
	and a			;0bb7	a7
	sbc hl,bc		;0bb8	ed 42
	add hl,bc		;0bba	09
	ex de,hl		;0bbb	eb
	jr c,ED_LINE_SCAN		;0bbc	38 e6
	ret			;0bbe	c9
	bit 5,(iy+037h)		;0bbf	fd cb 37 6e  ; IY+$37 = FLAGX+1
	ret nz			;0bc3	c0
	ld hl,(05c49h)		;0bc4	2a 49 5c  ; E_PPC
	call FIND_LINE		;0bc7	cd d6 16
	ex de,hl		;0bca	eb
	call GET_LINENO		;0bcb	cd 24 13
	ld hl,05c4ah		;0bce	21 4a 5c  ; E_PPC+1
	call STORE_LINE		;0bd1	cd 68 16
ED_LIST:
	call AUTO_LIST		;0bd4	cd e1 14
	ld a,000h		;0bd7	3e 00
	jp SELECT		;0bd9	c3 30 12
	bit 7,(iy+037h)		;0bdc	fd cb 37 7e  ; IY+$37 = FLAGX+1
	jr z,ED_POP2		;0be0	28 a8
	jp ED_CHAR		;0be2	c3 e7 0a
ED_ERROR:
	bit 4,(iy+030h)		;0be5	fd cb 30 66  ; IY+$30 = FLAGS2
	jr z,ED_RESTORE		;0be9	28 a1
	ld (iy+000h),0ffh	;0beb	fd 36 00 ff  ; IY+$00 = ERR_NR
	ld d,000h		;0bef	16 00
	ld e,(iy-002h)		;0bf1	fd 5e fe
	ld hl,BEEP_TABLE+1		;0bf4	21 90 1a
	call PARP		;0bf7	cd f3 03
	jp EDITOR_LOOP		;0bfa	c3 86 0a
CLEAR_ELINE:
	push hl			;0bfd	e5
	call GET_WORKSP		;0bfe	cd f6 0c
	dec hl			;0c01	2b
	call RECLAIM_INIT		;0c02	cd 4d 17
	ld (05c5bh),hl		;0c05	22 5b 5c  ; KCUR
	ld (iy+007h),000h	;0c08	fd 36 07 00  ; IY+$07 = MODE
	pop hl			;0c0c	e1
	ret			;0c0d	c9
KEY_INPUT:
	bit 3,(iy+002h)		;0c0e	fd cb 02 5e  ; IY+$02 = TVFLAG
	call nz,CURSOR_CLEAR	;0c12	c4 83 0c
	and a			;0c15	a7
	bit 5,(iy+001h)		;0c16	fd cb 01 6e  ; IY+$01 = FLAGS
	ret z			;0c1a	c8
	ld a,(05c08h)		;0c1b	3a 08 5c  ; LASTK
	res 5,(iy+001h)		;0c1e	fd cb 01 ae  ; IY+$01 = FLAGS
	push af			;0c22	f5
	bit 5,(iy+002h)		;0c23	fd cb 02 6e  ; IY+$02 = TVFLAG
	call nz,CLLHS	;0c27	c4 a9 08
	pop af			;0c2a	f1
	cp 020h			;0c2b	fe 20
	jr nc,KEY_DONE		;0c2d	30 52
	cp 010h			;0c2f	fe 10
	jr nc,KEY_COLOR		;0c31	30 2d
	cp 006h			;0c33	fe 06
	jr nc,KEY_CAPS		;0c35	30 0a
	ld b,a			;0c37	47
	and 001h		;0c38	e6 01
	ld c,a			;0c3a	4f
	ld a,b			;0c3b	78
	rra			;0c3c	1f
	add a,012h		;0c3d	c6 12
	jr KEY_STORE_COLOR		;0c3f	18 2a
KEY_CAPS:
	jr nz,KEY_MODE		;0c41	20 09
	ld hl,05c6ah		;0c43	21 6a 5c  ; FLAGX
	ld a,008h		;0c46	3e 08
	xor (hl)		;0c48	ae
	ld (hl),a		;0c49	77
	jr KEY_SETFLAG		;0c4a	18 0e
KEY_MODE:
	cp 00eh			;0c4c	fe 0e
	ret c			;0c4e	d8
	sub 00dh		;0c4f	d6 0d
	ld hl,05c41h		;0c51	21 41 5c  ; MODE
	cp (hl)			;0c54	be
	ld (hl),a		;0c55	77
	jr nz,KEY_SETFLAG		;0c56	20 02
	ld (hl),000h		;0c58	36 00
KEY_SETFLAG:
	set 3,(iy+002h)		;0c5a	fd cb 02 de  ; IY+$02 = TVFLAG
	cp a			;0c5e	bf
	ret			;0c5f	c9
KEY_COLOR:
	ld b,a			;0c60	47
	and 007h		;0c61	e6 07
	ld c,a			;0c63	4f
	ld a,010h		;0c64	3e 10
	bit 3,b			;0c66	cb 58
	jr nz,KEY_STORE_COLOR		;0c68	20 01
	inc a			;0c6a	3c
KEY_STORE_COLOR:
	ld (iy-02dh),c		;0c6b	fd 71 d3
	ld de,KEY_REENTER		;0c6e	11 73 0c
	jr KEY_CHAN_SET		;0c71	18 06
KEY_REENTER:
	ld a,(05c0dh)		;0c73	3a 0d 5c  ; KDATA
	ld de,KEY_INPUT		;0c76	11 0e 0c
KEY_CHAN_SET:
	ld hl,(05c4fh)		;0c79	2a 4f 5c  ; CHANS
	inc hl			;0c7c	23
	inc hl			;0c7d	23
	ld (hl),e		;0c7e	73
	inc hl			;0c7f	23
	ld (hl),d		;0c80	72
KEY_DONE:
	scf			;0c81	37
	ret			;0c82	c9
CURSOR_CLEAR:
	call DO_ATTS		;0c83	cd 88 08
	res 3,(iy+002h)		;0c86	fd cb 02 9e  ; IY+$02 = TVFLAG
	res 5,(iy+002h)		;0c8a	fd cb 02 ae  ; IY+$02 = TVFLAG
	ld hl,(05c8ah)		;0c8e	2a 8a 5c  ; SPOSNLCOL
	push hl			;0c91	e5
	ld hl,(05c3dh)		;0c92	2a 3d 5c  ; ERRSP
	push hl			;0c95	e5
	ld hl,CURSOR_ERR		;0c96	21 cd 0c
	push hl			;0c99	e5
	ld (05c3dh),sp		;0c9a	ed 73 3d 5c  ; ERRSP
	ld hl,(05c82h)		;0c9e	2a 82 5c  ; ECHOE
	push hl			;0ca1	e5
	scf			;0ca2	37
	call GET_ELINE		;0ca3	cd fb 0c
	ex de,hl		;0ca6	eb
	call LIST_SETFLG		;0ca7	cd c9 15
	ex de,hl		;0caa	eb
	call SHOW_CURSOR		;0cab	cd 2d 16
	ld hl,(05c8ah)		;0cae	2a 8a 5c  ; SPOSNLCOL
	ex (sp),hl		;0cb1	e3
	ex de,hl		;0cb2	eb
	call DO_ATTS		;0cb3	cd 88 08
CURSOR_LOOP:
	ld a,(05c8bh)		;0cb6	3a 8b 5c  ; SPOSNLLIN
	sub d			;0cb9	92
	jr c,CURSOR_POP		;0cba	38 26
	jr nz,CURSOR_SPACE		;0cbc	20 06
	ld a,e			;0cbe	7b
	sub (iy+050h)		;0cbf	fd 96 50  ; IY+$50 = S_POSN
	jr nc,CURSOR_POP		;0cc2	30 1e
CURSOR_SPACE:
	ld a,020h		;0cc4	3e 20
	push de			;0cc6	d5
	call SENDTV		;0cc7	cd 00 05
	pop de			;0cca	d1
	jr CURSOR_LOOP		;0ccb	18 e9
CURSOR_ERR:
	ld d,000h		;0ccd	16 00
	ld e,(iy-002h)		;0ccf	fd 5e fe
	ld hl,BEEP_TABLE+1		;0cd2	21 90 1a
	call PARP		;0cd5	cd f3 03
	ld (iy+000h),0ffh	;0cd8	fd 36 00 ff  ; IY+$00 = ERR_NR
	ld de,(05c8ah)		;0cdc	ed 5b 8a 5c  ; SPOSNLCOL
	jr CURSOR_RESTORE		;0ce0	18 02
CURSOR_POP:
	pop de			;0ce2	d1
	pop hl			;0ce3	e1
CURSOR_RESTORE:
	pop hl			;0ce4	e1
	ld (05c3dh),hl		;0ce5	22 3d 5c  ; ERRSP
	pop bc			;0ce8	c1
	push de			;0ce9	d5
	call STTVC		;0cea	cd 12 09
	pop hl			;0ced	e1
	ld (05c82h),hl		;0cee	22 82 5c  ; ECHOE
	ld (iy+026h),000h	;0cf1	fd 36 26 00  ; IY+$26 = FLAGX
	ret			;0cf5	c9
GET_WORKSP:
	ld hl,(05c61h)		;0cf6	2a 61 5c  ; WORKSP
	dec hl			;0cf9	2b
	and a			;0cfa	a7
GET_ELINE:
	ld de,(05c59h)		;0cfb	ed 5b 59 5c  ; ELINE
	bit 5,(iy+037h)		;0cff	fd cb 37 6e  ; IY+$37 = FLAGX+1
	ret z			;0d03	c8
	ld de,(05c61h)		;0d04	ed 5b 61 5c  ; WORKSP
	ret c			;0d08	d8
	ld hl,(05c63h)		;0d09	2a 63 5c  ; STKBOT
	ret			;0d0c	c9
REMOVE_NUMS:
	ld a,(hl)		;0d0d	7e
	cp 00eh			;0d0e	fe 0e
	ld bc,LROS_CALL+2		;0d10	01 06 00
	call z,RECLAIM		;0d13	cc 50 17
	ld a,(hl)		;0d16	7e
	inc hl			;0d17	23
	cp 00dh			;0d18	fe 0d
	jr nz,REMOVE_NUMS		;0d1a	20 f1
	ret			;0d1c	c9
COLD_START_ALT:

;================================================================
; Module: INIT
; Routine: COLD_START_ALT ($0D1D)
; Alternative cold start - copies stub to RAM and jumps.
;================================================================
	di			;0d1d	f3
	ld hl,COLD_STUB		;0d1e	21 2c 0d
	ld de,05b00h		;0d21	11 00 5b
	ld bc,LROS_JP_LO		;0d24	01 07 00
	ldir			;0d27	ed b0
	jp 05b00h		;0d29	c3 00 5b
COLD_STUB:
	ld a,000h		;0d2c	3e 00
	out (0f4h),a		;0d2e	d3 f4
	jp COLD_START_ALT		;0d30	c3 1d 0d
BANK_SETUP:

;================================================================
; Module: INIT
;*** ZEBRA MODIFICATION: Bank Setup ($0D33) ***
; Copies bank-switch code to RAM ($5B00), executes it to
; map cartridge ROM, copies charset from $3D00 to $7800,
; initializes system variables for 64-column mode.
;================================================================
	di			;0d33	f3
	ld hl,BANK_SWITCH_CODE		;0d34	21 bc 0d
	ld de,05b00h		;0d37	11 00 5b
	ld bc,NEXTCH_RST		;0d3a	01 20 00
	ldir			;0d3d	ed b0
	call 05b00h		;0d3f	cd 00 5b
	ld hl,EXROM_STUB		;0d42	21 f3 3c
	ld de,0fc5dh		;0d45	11 5d fc
	ld bc,0000dh		;0d48	01 0d 00
	ldir			;0d4b	ed b0
	ei			;0d4d	fb
	ld hl,05c92h		;0d4e	21 92 5c  ; MEMBOT
	ld (05c68h),hl		;0d51	22 68 5c  ; MEM
	ld a,041h		;0d54	3e 41
	ld hl,05c82h		;0d56	21 82 5c  ; ECHOE
	ld (hl),a		;0d59	77
	ld hl,05c88h		;0d5a	21 88 5c  ; SPOSNCOL
	ld (hl),a		;0d5d	77
	ld hl,05c8ah		;0d5e	21 8a 5c  ; SPOSNLCOL
	ld (hl),a		;0d61	77
	ld hl,05c7fh		;0d62	21 7f 5c  ; PRPOSN
	ld (hl),a		;0d65	77
	ld hl,0fee7h		;0d66	21 e7 fe
	ld (05cb2h),hl		;0d69	22 b2 5c  ; RAMTOP
	ld a,001h		;0d6c	3e 01
	out (0f4h),a		;0d6e	d3 f4
	ld hl,ZEBRA_INIT		;0d70	21 00 3d
	ld de,07800h		;0d73	11 00 78
	ld bc,00300h		;0d76	01 00 03
	ldir			;0d79	ed b0
	ld a,003h		;0d7b	3e 03
	out (0f4h),a		;0d7d	d3 f4

;================================================================
;*** ZEBRA MODIFICATION: Modified NEW Routine ($0D7F-$0D93) ***
; Sets CHARS to $7700 (font at $7800), initializes
; COPYtab ($FFF8), printer width WDTH ($FFF5=64 cols),
; calls ZEBRA_INIT ($3D00) to set up channels and printer.
;================================================================
	ld hl,07800h		;0d7f	21 00 78
	dec h			;0d82	25
	ld (05c36h),hl		;0d83	22 36 5c  ; CHARS
	ld a,001h		;0d86	3e 01
	ld (0fff8h),a		;0d88	32 f8 ff  ; COPYtab
	ld a,040h		;0d8b	3e 40
	ld (0fff5h),a		;0d8d	32 f5 ff  ; WDTH
	call ZEBRA_INIT		;0d90	cd 00 3d
	ret			;0d93	c9
	nop			;0d94	00
	nop			;0d95	00
	nop			;0d96	00
	nop			;0d97	00
	nop			;0d98	00
	nop			;0d99	00
	nop			;0d9a	00
	nop			;0d9b	00
	nop			;0d9c	00
	nop			;0d9d	00

;================================================================
;*** ZEBRA MODIFICATION: LROS Entry Routine ($0D9E-$0DD5) ***
; Called when cartridge is first detected during HOME ROM init.
; Calls BANK_SETUP, K_CLS, displays Timex copyright and
; Zebra copyright, then jumps to BASIC main loop.
;================================================================
	call BANK_SETUP		;0d9e	cd 33 0d
	call K_CLS		;0da1	cd a6 08
	xor a			;0da4	af
	set 4,(iy+001h)		;0da5	fd cb 01 e6  ; IY+$01 = FLAGS
	ld de,COPYRIGHT_MSG		;0da9	11 17 11
	call PUTMES		;0dac	cd 3f 07
	ld de,ZEBRA_COPYRIGHT		;0daf	11 d6 0d
	call PUTMES		;0db2	cd 3f 07
	set 5,(iy+002h)		;0db5	fd cb 02 ee  ; IY+$02 = TVFLAG
	jp MAIN_ENTRY		;0db9	c3 2f 0e
BANK_SWITCH_CODE:

;================================================================
;*** ZEBRA MODIFICATION: Bank Switch Code ($0DBC-$0DD5) ***
; Code that runs from RAM to switch DOCK/HOME banks via
; port $FF (DECR) and port $F4 (bank select).
;================================================================
	in a,(0ffh)		;0dbc	db ff
	set 7,a			;0dbe	cb ff
	out (0ffh),a		;0dc0	d3 ff
	ld a,001h		;0dc2	3e 01
	out (0f4h),a		;0dc4	d3 f4
	ld a,03eh		;0dc6	3e 3e
	call MAIN_EXEC		;0dc8	cd 8e 0e
	in a,(0ffh)		;0dcb	db ff
	res 7,a			;0dcd	cb bf
	out (0ffh),a		;0dcf	d3 ff
	ld a,003h		;0dd1	3e 03
	out (0f4h),a		;0dd3	d3 f4
	ret			;0dd5	c9
ZEBRA_COPYRIGHT:

;================================================================
;*** ZEBRA MODIFICATION: Copyright Message ($0DD6-$0DF4) ***
; Sinclair-encoded: "(C) 1985 Zebra Systems Inc"
;================================================================
	add a,b			;0dd6	80
	dec c			;0dd7	0d
	dec c			;0dd8	0d
	rla			;0dd9	17
	ld de,PAD_1FFE+2		;0dda	11 00 20
	ld a,a			;0ddd	7f
	jr nz,NOP_PAD_1		;0dde	20 31
	add hl,sp		;0de0	39
	jr c,NOP_PAD_2		;0de1	38 35
	jr nz,$+92		;0de3	20 5a
	ld h,l			;0de5	65
	ld h,d			;0de6	62
	ld (hl),d		;0de7	72
	ld h,c			;0de8	61
	jr nz,$+85		;0de9	20 53
	ld a,c			;0deb	79
	ld (hl),e		;0dec	73
	ld (hl),h		;0ded	74
	ld h,l			;0dee	65
	ld l,l			;0def	6d
	ld (hl),e		;0df0	73
	jr nz,$+75		;0df1	20 49
	ld l,(hl)		;0df3	6e
	ex (sp),hl		;0df4	e3
FSCREEN_64:

;================================================================
;*** ZEBRA MODIFICATION: F_SCRN Wrapper ($0DF5-$0E05) ***
; Adjusts SCREEN$ function for 64-column mode.
; Calls GET_XY, fetches CHARS pointer, divides X by 2.
;================================================================
	call GET_XY		;0df5	cd 60 26
	ld hl,(05c36h)		;0df8	2a 36 5c  ; CHARS
	ld de,TOK_NOT+1		;0dfb	11 00 01
	add hl,de		;0dfe	19
	ld a,c			;0dff	79
	ld (iy+077h),b		;0e00	fd 70 77  ; IY+$77 = XCOORD_SAVE
	srl b			;0e03	cb 38
	ret			;0e05	c9
	nop			;0e06	00
	nop			;0e07	00
	nop			;0e08	00
	nop			;0e09	00
	nop			;0e0a	00
	nop			;0e0b	00
	nop			;0e0c	00
	nop			;0e0d	00
	nop			;0e0e	00
	nop			;0e0f	00
	nop			;0e10	00
NOP_PAD_1:
	nop			;0e11	00
	nop			;0e12	00
	nop			;0e13	00
	nop			;0e14	00
	nop			;0e15	00
	nop			;0e16	00
	nop			;0e17	00
NOP_PAD_2:
	nop			;0e18	00
	nop			;0e19	00
	nop			;0e1a	00
	nop			;0e1b	00
	nop			;0e1c	00
	nop			;0e1d	00
	nop			;0e1e	00
	nop			;0e1f	00
	nop			;0e20	00
	nop			;0e21	00
	nop			;0e22	00
	nop			;0e23	00
	nop			;0e24	00
	nop			;0e25	00
	nop			;0e26	00
	nop			;0e27	00
MAIN_LOOP_CR:

;================================================================
; Module: BASIC
; Routine: MAIN_LOOP ($0E28-$0E8D)
; Main BASIC interpreter loop.
;================================================================
	ld (iy+031h),002h	;0e28	fd 36 31 02  ; IY+$31 = DFSZ
	call AUTO_LIST		;0e2c	cd e1 14
MAIN_ENTRY:
	call CLEAR_ELINE_2		;0e2f	cd 3f 13
MAIN_LOOP:
	ld a,000h		;0e32	3e 00
	call SELECT		;0e34	cd 30 12
	call EDITOR		;0e37	cd 82 0a
	call sub_1a27h		;0e3a	cd 27 1a
	bit 7,(iy+000h)		;0e3d	fd cb 00 7e  ; IY+$00 = ERR_NR
	jr nz,MAIN_LINE		;0e41	20 12
	bit 4,(iy+030h)		;0e43	fd cb 30 66  ; IY+$30 = FLAGS2
	jr z,MAIN_HALT		;0e47	28 44
	ld hl,(05c59h)		;0e49	2a 59 5c  ; ELINE
	call REMOVE_NUMS		;0e4c	cd 0d 0d
	ld (iy+000h),0ffh	;0e4f	fd 36 00 ff  ; IY+$00 = ERR_NR
	jr MAIN_LOOP		;0e53	18 dd
MAIN_LINE:
	ld hl,(05c59h)		;0e55	2a 59 5c  ; ELINE
	ld (05c5dh),hl		;0e58	22 5d 5c  ; CH_ADD
	call SYNTAX_CHECK		;0e5b	cd 68 17
	ld a,b			;0e5e	78
	or c			;0e5f	b1
	jp nz,MAIN_INSERT		;0e60	c2 58 11
	rst 18h			;0e63	df
	cp 00dh			;0e64	fe 0d
	jr z,MAIN_LOOP_CR		;0e66	28 c0
	bit 0,(iy+030h)		;0e68	fd cb 30 46  ; IY+$30 = FLAGS2
	call nz,CLS	;0e6c	c4 ea 08
	call CLLHS		;0e6f	cd a9 08
	ld a,019h		;0e72	3e 19
	sub (iy+04fh)		;0e74	fd 96 4f  ; IY+$4F = S_TOP
	ld (05c8ch),a		;0e77	32 8c 5c  ; SCRCT
	set 7,(iy+001h)		;0e7a	fd cb 01 fe  ; IY+$01 = FLAGS
	ld (iy+000h),0ffh	;0e7e	fd 36 00 ff  ; IY+$00 = ERR_NR
	ld (iy+00ah),001h	;0e82	fd 36 0a 01  ; IY+$0A = NSPPC
	ld (iy+07ch),000h	;0e86	fd 36 7c 00  ; IY+$7C = DEBUG_FLAG
	call sub_1ad8h		;0e8a	cd d8 1a
MAIN_HALT:
	halt			;0e8d	76
MAIN_EXEC:

;================================================================
; Module: BASIC
; Routine: MAIN_EXEC ($0E8E)
; Execute BASIC statement, handle errors and CONTINUE.
;================================================================
	ld a,(iy+000h)		;0e8e	fd 7e 00  ; IY+$00 = ERR_NR
	cp 0ffh			;0e91	fe ff
	jr z,MAIN_INIT_IO		;0e93	28 33
	bit 7,(iy+07dh)		;0e95	fd cb 7d 7e  ; IY+$7D = ERRLN_FLAGS
	jr z,MAIN_INIT_IO		;0e99	28 2d
	set 6,(iy+07dh)		;0e9b	fd cb 7d f6  ; IY+$7D = ERRLN_FLAGS
	inc a			;0e9f	3c
	ld (05cbbh),a		;0ea0	32 bb 5c  ; ERRNR2
	ld (iy+000h),0ffh	;0ea3	fd 36 00 ff  ; IY+$00 = ERR_NR
	ld hl,(05c45h)		;0ea7	2a 45 5c  ; PPC
	ld (05cb8h),hl		;0eaa	22 b8 5c  ; NXTCONT
	ld a,(05c47h)		;0ead	3a 47 5c  ; SUBPPC
	ld (05cbah),a		;0eb0	32 ba 5c  ; NXTCONT+2
	ld hl,(05cb6h)		;0eb3	2a b6 5c  ; ERRLN
	res 7,h			;0eb6	cb bc
	res 6,h			;0eb8	cb b4
	ld (05c42h),hl		;0eba	22 42 5c  ; NEWPPC
	ld (iy+00ah),001h	;0ebd	fd 36 0a 01  ; IY+$0A = NSPPC
	ld hl,MAIN_HALT		;0ec1	21 8d 0e
	push hl			;0ec4	e5
	jp l1ab9h		;0ec5	c3 b9 1a
MAIN_INIT_IO:

;================================================================
; Module: BASIC
; Routine: MAIN_INIT_IO ($0EC8)
; Initialize I/O ports and scan for errors.
;================================================================
	ld a,007h		;0ec8	3e 07
	out (0f5h),a		;0eca	d3 f5
	ld a,0ffh		;0ecc	3e ff
	out (0f6h),a		;0ece	d3 f6
	res 3,(iy+002h)		;0ed0	fd cb 02 9e  ; IY+$02 = TVFLAG
	res 5,(iy+001h)		;0ed4	fd cb 01 ae  ; IY+$01 = FLAGS
	bit 1,(iy+030h)		;0ed8	fd cb 30 4e  ; IY+$30 = FLAGS2
	call nz,PRINTER_STUB		;0edc	c4 23 0a
	ld a,(05c3ah)		;0edf	3a 3a 5c  ; ERR_NR
	inc a			;0ee2	3c
ERROR_HANDLER:
	push af			;0ee3	f5
	ld hl,LROS_HEADER		;0ee4	21 00 00
	ld (iy+037h),h		;0ee7	fd 74 37  ; IY+$37 = FLAGX+1
	ld (iy+026h),h		;0eea	fd 74 26  ; IY+$26 = FLAGX
	ld (05c0bh),hl		;0eed	22 0b 5c  ; DEFADD
	ld hl,LROS_BC		;0ef0	21 01 00
	ld (05c16h),hl		;0ef3	22 16 5c  ; STRMS+6
	call CLEAR_ELINE_2		;0ef6	cd 3f 13
	res 5,(iy+037h)		;0ef9	fd cb 37 ae  ; IY+$37 = FLAGX+1
	call CLLHS		;0efd	cd a9 08
	set 5,(iy+002h)		;0f00	fd cb 02 ee  ; IY+$02 = TVFLAG
ERR_DISPLAY:
	pop af			;0f04	f1
	ld b,a			;0f05	47
	cp 00ah			;0f06	fe 0a
	jr c,ERR_HEX		;0f08	38 02
	add a,007h		;0f0a	c6 07
ERR_HEX:
	call PRINT_DIGIT		;0f0c	cd ea 11
	ld a,020h		;0f0f	3e 20
	rst 10h			;0f11	d7
	ld a,b			;0f12	78
	ld de,ERR_MSGS		;0f13	11 65 0f
	call PUTMES		;0f16	cd 3f 07
	xor a			;0f19	af
	ld de,LROS_MSG		;0f1a	11 15 11
	call PUTMES		;0f1d	cd 3f 07
	ld bc,(05c45h)		;0f20	ed 4b 45 5c  ; PPC
	call PRINT_NUM		;0f24	cd 88 17
	ld a,03ah		;0f27	3e 3a
	rst 10h			;0f29	d7
	ld c,(iy+00dh)		;0f2a	fd 4e 0d  ; IY+$0D = SUBPPC
	ld b,000h		;0f2d	06 00
	call PRINT_NUM		;0f2f	cd 88 17
	call CLEAR_ELINE		;0f32	cd fd 0b
	ld a,(05c3ah)		;0f35	3a 3a 5c  ; ERR_NR
	inc a			;0f38	3c
	jr z,ERR_FINAL		;0f39	28 1b
	cp 009h			;0f3b	fe 09
	jr z,ERR_SUBLINE		;0f3d	28 04
	cp 015h			;0f3f	fe 15
	jr nz,ERR_CONT		;0f41	20 03
ERR_SUBLINE:
	inc (iy+00dh)		;0f43	fd 34 0d  ; IY+$0D = SUBPPC
ERR_CONT:
	ld bc,LROS_BC+2		;0f46	01 03 00
	ld de,05c70h		;0f49	11 70 5c  ; OLDPPC
	ld hl,05c44h		;0f4c	21 44 5c  ; NSPPC
	bit 7,(hl)		;0f4f	cb 7e
	jr z,ERR_SAVE		;0f51	28 01
	add hl,bc		;0f53	09
ERR_SAVE:
	lddr			;0f54	ed b8
ERR_FINAL:
	ld (iy+00ah),0ffh	;0f56	fd 36 0a ff  ; IY+$0A = NSPPC
	res 3,(iy+001h)		;0f5a	fd cb 01 9e  ; IY+$01 = FLAGS
	res 3,(iy+002h)		;0f5e	fd cb 02 9e  ; IY+$02 = TVFLAG
	jp MAIN_LOOP		;0f62	c3 32 0e
ERR_MSGS:

;================================================================
; Module: BASIC
; Error message table ($0F65-$1114)
; Sinclair-encoded error description strings.
;================================================================
	add a,b			;0f65	80
	ld c,a			;0f66	4f
	bit 1,(hl)		;0f67	cb 4e
	ld b,l			;0f69	45
	ld e,b			;0f6a	58
	ld d,h			;0f6b	54
	jr nz,$+121		;0f6c	20 77
	ld l,c			;0f6e	69
	ld (hl),h		;0f6f	74
	ld l,b			;0f70	68
	ld l,a			;0f71	6f
	ld (hl),l		;0f72	75
	ld (hl),h		;0f73	74
	jr nz,ERR_BIG		;0f74	20 46
	ld c,a			;0f76	4f
	jp nc,06156h		;0f77	d2 56 61
	ld (hl),d		;0f7a	72
	ld l,c			;0f7b	69
	ld h,c			;0f7c	61
	ld h,d			;0f7d	62
	ld l,h			;0f7e	6c
	ld h,l			;0f7f	65
	jr nz,ERR_INVARG		;0f80	20 6e
	ld l,a			;0f82	6f
	ld (hl),h		;0f83	74
	jr nz,ERR_INV		;0f84	20 66
	ld l,a			;0f86	6f
	ld (hl),l		;0f87	75
	ld l,(hl)		;0f88	6e
	call po,07553h		;0f89	e4 53 75
	ld h,d			;0f8c	62
	ld (hl),e		;0f8d	73
	ld h,e			;0f8e	63
	ld (hl),d		;0f8f	72
	ld l,c			;0f90	69
	ld (hl),b		;0f91	70
	ld (hl),h		;0f92	74
	jr nz,ERR_RANGE		;0f93	20 77
	ld (hl),d		;0f95	72
	ld l,a			;0f96	6f
	ld l,(hl)		;0f97	6e
	rst 20h			;0f98	e7
	ld c,a			;0f99	4f
	ld (hl),l		;0f9a	75
	ld (hl),h		;0f9b	74
	jr nz,$+113		;0f9c	20 6f
	ld h,(hl)		;0f9e	66
	jr nz,ERR_RANGE2		;0f9f	20 6d
	ld h,l			;0fa1	65
ERR_MEM:
	ld l,l			;0fa2	6d
	ld l,a			;0fa3	6f
	ld (hl),d		;0fa4	72
	ld sp,hl		;0fa5	f9
	ld c,a			;0fa6	4f
	ld (hl),l		;0fa7	75
	ld (hl),h		;0fa8	74
	jr nz,ERR_OUT_SCREEN		;0fa9	20 6f
	ld h,(hl)		;0fab	66
	jr nz,ERR_BASIC		;0fac	20 73
	ld h,e			;0fae	63
	ld (hl),d		;0faf	72
	ld h,l			;0fb0	65
	ld h,l			;0fb1	65
	xor 04eh		;0fb2	ee 4e
	ld (hl),l		;0fb4	75
	ld l,l			;0fb5	6d
	ld h,d			;0fb6	62
	ld h,l			;0fb7	65
	ld (hl),d		;0fb8	72
	jr nz,ERR_CONT2		;0fb9	20 74
	ld l,a			;0fbb	6f
ERR_BIG:
	ld l,a			;0fbc	6f
	jr nz,ERR_BASIC		;0fbd	20 62
	ld l,c			;0fbf	69
	rst 20h			;0fc0	e7
	ld d,d			;0fc1	52
	ld b,l			;0fc2	45
	ld d,h			;0fc3	54
	ld d,l			;0fc4	55
	ld d,d			;0fc5	52
	ld c,(hl)		;0fc6	4e
	jr nz,ERR_DATA		;0fc7	20 77
	ld l,c			;0fc9	69
	ld (hl),h		;0fca	74
	ld l,b			;0fcb	68
	ld l,a			;0fcc	6f
	ld (hl),l		;0fcd	75
	ld (hl),h		;0fce	74
	jr nz,ERR_NONSENSE		;0fcf	20 47
	ld c,a			;0fd1	4f
	ld d,e			;0fd2	53
	ld d,l			;0fd3	55
	jp nz,06e45h		;0fd4	c2 45 6e
	ld h,h			;0fd7	64
	jr nz,ERR_INVFILE2		;0fd8	20 6f
	ld h,(hl)		;0fda	66
	jr nz,ERR_INVFILE		;0fdb	20 66
	ld l,c			;0fdd	69
	ld l,h			;0fde	6c
	push hl			;0fdf	e5
ERR_STOP:
	ld d,e			;0fe0	53
	ld d,h			;0fe1	54
	ld c,a			;0fe2	4f
	ld d,b			;0fe3	50
	jr nz,ERR_NOROOM3		;0fe4	20 73
	ld (hl),h		;0fe6	74
	ld h,c			;0fe7	61
	ld (hl),h		;0fe8	74
	ld h,l			;0fe9	65
	ld l,l			;0fea	6d
	ld h,l			;0feb	65
ERR_INV:
	ld l,(hl)		;0fec	6e
	call p,06e49h		;0fed	f4 49 6e
ERR_INVARG:
	halt			;0ff0	76
	ld h,c			;0ff1	61
	ld l,h			;0ff2	6c
	ld l,c			;0ff3	69
	ld h,h			;0ff4	64
	jr nz,ERR_NOROOM2		;0ff5	20 61
	ld (hl),d		;0ff7	72
	ld h,a			;0ff8	67
	ld (hl),l		;0ff9	75
	ld l,l			;0ffa	6d
	ld h,l			;0ffb	65
	ld l,(hl)		;0ffc	6e
	call p,06e49h		;0ffd	f4 49 6e
	ld (hl),h		;1000	74
	ld h,l			;1001	65
	ld h,a			;1002	67
	ld h,l			;1003	65
	ld (hl),d		;1004	72
	jr nz,ERR_NEXT		;1005	20 6f
	ld (hl),l		;1007	75
	ld (hl),h		;1008	74
	jr nz,ERR_NEXT2		;1009	20 6f
	ld h,(hl)		;100b	66
ERR_RANGE:
	jr nz,$+116		;100c	20 72
ERR_RANGE2:
	ld h,c			;100e	61
	ld l,(hl)		;100f	6e
	ld h,a			;1010	67
	push hl			;1011	e5
	ld c,(hl)		;1012	4e
	ld l,a			;1013	6f
	ld l,(hl)		;1014	6e
	ld (hl),e		;1015	73
	ld h,l			;1016	65
	ld l,(hl)		;1017	6e
ERR_NONSENSE:
	ld (hl),e		;1018	73
	ld h,l			;1019	65
ERR_OUT_SCREEN:
	jr nz,ERR_VALID2		;101a	20 69
	ld l,(hl)		;101c	6e
	jr nz,ERR_LINE		;101d	20 42
	ld b,c			;101f	41
	ld d,e			;1020	53
ERR_BASIC:
	ld c,c			;1021	49
	jp 05242h		;1022	c3 42 52
	ld b,l			;1025	45
	ld b,c			;1026	41
	ld c,e			;1027	4b
	jr nz,ERR_NOROOM		;1028	20 2d
	jr nz,l106fh		;102a	20 43
	ld c,a			;102c	4f
	ld c,(hl)		;102d	4e
	ld d,h			;102e	54
ERR_CONT2:
	jr nz,l10a3h		;102f	20 72
	ld h,l			;1031	65
	ld (hl),b		;1032	70
	ld h,l			;1033	65
	ld h,c			;1034	61
	ld (hl),h		;1035	74
	di			;1036	f3
	ld c,a			;1037	4f
	ld (hl),l		;1038	75
	ld (hl),h		;1039	74
	jr nz,ERR_PROG		;103a	20 6f
	ld h,(hl)		;103c	66
	jr nz,ERR_VALID		;103d	20 44
	ld b,c			;103f	41
ERR_DATA:
	ld d,h			;1040	54
	pop bc			;1041	c1
	ld c,c			;1042	49
ERR_INVFILE:
	ld l,(hl)		;1043	6e
	halt			;1044	76
	ld h,c			;1045	61
	ld l,h			;1046	6c
	ld l,c			;1047	69
	ld h,h			;1048	64
ERR_INVFILE2:
	jr nz,$+104		;1049	20 66
	ld l,c			;104b	69
	ld l,h			;104c	6c
	ld h,l			;104d	65
	jr nz,ERR_STATEMENT		;104e	20 6e
	ld h,c			;1050	61
	ld l,l			;1051	6d
	push hl			;1052	e5
	ld c,(hl)		;1053	4e
	ld l,a			;1054	6f
	jr nz,$+116		;1055	20 72
ERR_NOROOM:
	ld l,a			;1057	6f
ERR_NOROOM2:
	ld l,a			;1058	6f
ERR_NOROOM3:
	ld l,l			;1059	6d
ERR_FORLINE:
	jr nz,l10c2h		;105a	20 66
	ld l,a			;105c	6f
	ld (hl),d		;105d	72
	jr nz,ERR_LOST2		;105e	20 6c
	ld l,c			;1060	69
ERR_LINE:
	ld l,(hl)		;1061	6e
	push hl			;1062	e5
	ld d,e			;1063	53
	ld d,h			;1064	54
	ld c,a			;1065	4f
	ld d,b			;1066	50
	jr nz,ERR_STREAM		;1067	20 69
	ld l,(hl)		;1069	6e
	jr nz,l10b5h		;106a	20 49
	ld c,(hl)		;106c	4e
	ld d,b			;106d	50
	ld d,l			;106e	55
l106fh:
	call nc,04f46h		;106f	d4 46 4f
	ld d,d			;1072	52
	jr nz,ERR_PARAM		;1073	20 77
	ld l,c			;1075	69
ERR_NEXT:
	ld (hl),h		;1076	74
	ld l,b			;1077	68
	ld l,a			;1078	6f
	ld (hl),l		;1079	75
ERR_NEXT2:
	ld (hl),h		;107a	74
	jr nz,ERR_LOST		;107b	20 4e
	ld b,l			;107d	45
	ld e,b			;107e	58
	call nc,06e49h		;107f	d4 49 6e
	halt			;1082	76
ERR_VALID:
	ld h,c			;1083	61
	ld l,h			;1084	6c
ERR_VALID2:
	ld l,c			;1085	69
	ld h,h			;1086	64
	jr nz,ERR_STREAM		;1087	20 49
	cpl			;1089	2f
	ld c,a			;108a	4f
	jr nz,ERR_PARAM2		;108b	20 64
	ld h,l			;108d	65
	halt			;108e	76
	ld l,c			;108f	69
	ld h,e			;1090	63
	push hl			;1091	e5
	ld c,c			;1092	49
	ld l,(hl)		;1093	6e
	halt			;1094	76
	ld h,c			;1095	61
	ld l,h			;1096	6c
	ld l,c			;1097	69
	ld h,h			;1098	64
	jr nz,ERR_TAPE		;1099	20 63
	ld l,a			;109b	6f
	ld l,h			;109c	6c
	ld l,a			;109d	6f
	jp p,05242h		;109e	f2 42 52
	ld b,l			;10a1	45
	ld b,c			;10a2	41
l10a3h:
	ld c,e			;10a3	4b
	jr nz,ERR_MISSING		;10a4	20 69
	ld l,(hl)		;10a6	6e
	ld (hl),h		;10a7	74
	ld l,a			;10a8	6f
	jr nz,CR_1982		;10a9	20 70
ERR_PROG:
	ld (hl),d		;10ab	72
	ld l,a			;10ac	6f
	ld h,a			;10ad	67
	ld (hl),d		;10ae	72
	ld h,c			;10af	61
	sbc hl,de		;10b0	ed 52
	ld b,c			;10b2	41
	ld c,l			;10b3	4d
	ld d,h			;10b4	54
l10b5h:
	ld c,a			;10b5	4f
	ld d,b			;10b6	50
	jr nz,CR_RESEARCH		;10b7	20 6e
	ld l,a			;10b9	6f
	jr nz,CR_SINCLAIR		;10ba	20 67
	ld l,a			;10bc	6f
	ld l,a			;10bd	6f
ERR_STATEMENT:
	call po,07453h		;10be	e4 53 74
	ld h,c			;10c1	61
l10c2h:
	ld (hl),h		;10c2	74
	ld h,l			;10c3	65
	ld l,l			;10c4	6d
	ld h,l			;10c5	65
	ld l,(hl)		;10c6	6e
	ld (hl),h		;10c7	74
	jr nz,CR_1983		;10c8	20 6c
	ld l,a			;10ca	6f
ERR_LOST:
	ld (hl),e		;10cb	73
ERR_LOST2:
	call p,06e49h		;10cc	f4 49 6e
	halt			;10cf	76
	ld h,c			;10d0	61
	ld l,h			;10d1	6c
ERR_STREAM:
	ld l,c			;10d2	69
	ld h,h			;10d3	64
	jr nz,CR_TIMEX		;10d4	20 73
	ld (hl),h		;10d6	74
	ld (hl),d		;10d7	72
	ld h,l			;10d8	65
	ld h,c			;10d9	61
	im 0			;10da	ed 46
	ld c,(hl)		;10dc	4e
	jr nz,$+121		;10dd	20 77
	ld l,c			;10df	69
	ld (hl),h		;10e0	74
	ld l,b			;10e1	68
	ld l,a			;10e2	6f
	ld (hl),l		;10e3	75
	ld (hl),h		;10e4	74
	jr nz,CR_RESEARCH2		;10e5	20 44
	ld b,l			;10e7	45
	add a,050h		;10e8	c6 50
	ld h,c			;10ea	61
	ld (hl),d		;10eb	72
ERR_PARAM:
	ld h,c			;10ec	61
	ld l,l			;10ed	6d
	ld h,l			;10ee	65
	ld (hl),h		;10ef	74
	ld h,l			;10f0	65
ERR_PARAM2:
	ld (hl),d		;10f1	72
	jr nz,$+103		;10f2	20 65
	ld (hl),d		;10f4	72
	ld (hl),d		;10f5	72
	ld l,a			;10f6	6f
	jp p,06154h		;10f7	f2 54 61
	ld (hl),b		;10fa	70
	ld h,l			;10fb	65
	jr nz,MAIN_INST3		;10fc	20 6c
ERR_TAPE:
	ld l,a			;10fe	6f
	ld h,c			;10ff	61
	ld h,h			;1100	64
	ld l,c			;1101	69
	ld l,(hl)		;1102	6e
	ld h,a			;1103	67
	jr nz,MAIN_INST4		;1104	20 65
	ld (hl),d		;1106	72
	ld (hl),d		;1107	72
	ld l,a			;1108	6f
	jp p,0694dh		;1109	f2 4d 69
	ld (hl),e		;110c	73
	ld (hl),e		;110d	73
	ld l,c			;110e	69
ERR_MISSING:
	ld l,(hl)		;110f	6e
	ld h,a			;1110	67
	jr nz,MAIN_INST2		;1111	20 4c
	ld d,d			;1113	52
	ld c,a			;1114	4f
LROS_MSG:

;================================================================
; Module: BASIC
; System messages: "LROS" and copyright strings.
;================================================================
	out (02ch),a		;1115	d3 2c
COPYRIGHT_MSG:
	and b			;1117	a0
	ld a,a			;1118	7f
	jr nz,$+51		;1119	20 31
CR_1982:
	add hl,sp		;111b	39
	jr c,MAIN_NEWLINE		;111c	38 32
	jr nz,$+85		;111e	20 53
	ld l,c			;1120	69
	ld l,(hl)		;1121	6e
	ld h,e			;1122	63
CR_SINCLAIR:
	ld l,h			;1123	6c
	ld h,c			;1124	61
	ld l,c			;1125	69
	ld (hl),d		;1126	72
CR_RESEARCH:
	jr nz,MAIN_INST6		;1127	20 52
	ld h,l			;1129	65
	ld (hl),e		;112a	73
CR_RESEARCH2:
	ld h,l			;112b	65
	ld h,c			;112c	61
	ld (hl),d		;112d	72
	ld h,e			;112e	63
	ld l,b			;112f	68
	jr nz,MAIN_INST7		;1130	20 4c
	ld (hl),h		;1132	74
	ld h,h			;1133	64
	jr nz,$+34		;1134	20 20
CR_1983:
	ld a,a			;1136	7f
	jr nz,MAIN_INST3		;1137	20 31
	add hl,sp		;1139	39
	jr c,$+53		;113a	38 33
	jr nz,MAIN_INST9		;113c	20 54
	ld l,c			;113e	69
	ld l,l			;113f	6d
	ld h,l			;1140	65
	ld a,b			;1141	78
	jr nz,$+69		;1142	20 43
	ld l,a			;1144	6f
	ld l,l			;1145	6d
	ld (hl),b		;1146	70
	ld (hl),l		;1147	75
	ld (hl),h		;1148	74
CR_TIMEX:
	ld h,l			;1149	65
	ld (hl),d		;114a	72
	jr nz,MAIN_INST8		;114b	20 43
	ld l,a			;114d	6f
	ld (hl),d		;114e	72
	ret p			;114f	f0
MAIN_NEWLINE:
	ld a,010h		;1150	3e 10
	ld bc,LROS_HEADER		;1152	01 00 00
	jp ERROR_HANDLER		;1155	c3 e3 0e
MAIN_INSERT:
	ld (05c49h),bc		;1158	ed 43 49 5c  ; E_PPC
	ld hl,(05c5dh)		;115c	2a 5d 5c  ; CH_ADD
MAIN_INST2:
	ex de,hl		;115f	eb
	ld hl,MAIN_NEWLINE		;1160	21 50 11
	push hl			;1163	e5
	ld hl,(05c61h)		;1164	2a 61 5c  ; WORKSP
	scf			;1167	37
	sbc hl,de		;1168	ed 52
MAIN_INST3:
	push hl			;116a	e5
MAIN_INST4:
	ld h,b			;116b	60
	ld l,c			;116c	69
	call FIND_LINE		;116d	cd d6 16
	jr nz,MAIN_INST5		;1170	20 06
	call LINE_NEXT		;1172	cd 20 17
	call RECLAIM		;1175	cd 50 17
MAIN_INST5:
	pop bc			;1178	c1
	ld a,c			;1179	79
	dec a			;117a	3d
MAIN_INST6:
	or b			;117b	b0
	jr z,MAIN_INSTDONE		;117c	28 28
MAIN_INST7:
	push bc			;117e	c5
	inc bc			;117f	03
	inc bc			;1180	03
	inc bc			;1181	03
	inc bc			;1182	03
	dec hl			;1183	2b
	ld de,(05c53h)		;1184	ed 5b 53 5c  ; PROG
	push de			;1188	d5
	call MAKE_ROOM		;1189	cd bb 12
	pop hl			;118c	e1
	ld (05c53h),hl		;118d	22 53 5c  ; PROG
MAIN_INST8:
	pop bc			;1190	c1
	push bc			;1191	c5
MAIN_INST9:
	inc de			;1192	13
	ld hl,(05c61h)		;1193	2a 61 5c  ; WORKSP
	dec hl			;1196	2b
	dec hl			;1197	2b
	lddr			;1198	ed b8
	ld hl,(05c49h)		;119a	2a 49 5c  ; E_PPC
	ex de,hl		;119d	eb
	pop bc			;119e	c1
	ld (hl),b		;119f	70
	dec hl			;11a0	2b
	ld (hl),c		;11a1	71
	dec hl			;11a2	2b
	ld (hl),e		;11a3	73
	dec hl			;11a4	2b
	ld (hl),d		;11a5	72
MAIN_INSTDONE:
	pop af			;11a6	f1
	jp MAIN_LOOP_CR		;11a7	c3 28 0e

;================================================================
; Module: BASIC
; Channel/stream descriptor data.
;================================================================
	nop			;11aa	00
	dec b			;11ab	05
	ld c,00ch		;11ac	0e 0c
	ld c,e			;11ae	4b
	nop			;11af	00
	dec b			;11b0	05
	cp a			;11b1	bf
	ld de,0e753h		;11b2	11 53 e7
	ld a,(bc)		;11b5	0a
	cp a			;11b6	bf
	ld de,PHLAF_RET		;11b7	11 52 00
	dec b			;11ba	05
	cp a			;11bb	bf
	ld de,08050h		;11bc	11 50 80
	rst 8			;11bf	cf
	ld (de),a		;11c0	12
	ld bc,00600h		;11c1	01 00 06
	nop			;11c4	00
	dec bc			;11c5	0b
	nop			;11c6	00
	ld bc,TOK_NOT+1		;11c7	01 00 01
	nop			;11ca	00
	ld b,000h		;11cb	06 00
	djnz RDCH		;11cd	10 00
RDCH:

;================================================================
; Module: BASIC
; Routine: RDCH ($11CF)
; Read a character from the current input stream.
;================================================================
	bit 5,(iy+002h)		;11cf	fd cb 02 6e  ; IY+$02 = TVFLAG
	jr nz,l11d9h		;11d3	20 04
	set 3,(iy+002h)		;11d5	fd cb 02 de  ; IY+$02 = TVFLAG
l11d9h:
	call RDCH_CHAN		;11d9	cd e1 11
	ret c			;11dc	d8
	jr z,l11d9h		;11dd	28 fa
	rst 8			;11df	cf
	rlca			;11e0	07
RDCH_CHAN:
	exx			;11e1	d9
	push hl			;11e2	e5
	ld hl,(05c51h)		;11e3	2a 51 5c  ; CURCHL
	inc hl			;11e6	23
	inc hl			;11e7	23
	jr l11f2h		;11e8	18 08
PRINT_DIGIT:

;================================================================
; Module: BASIC
; Routine: PRINT_DIGIT ($11EA)
; Print a digit (0-9) via RST $10.
;================================================================
	ld e,030h		;11ea	1e 30
	add a,e			;11ec	83
l11edh:

;================================================================
; Module: BASIC
; Routine: STREAM_OUTPUT ($11ED)
; Output character A to the current stream.
;================================================================
	exx			;11ed	d9
	push hl			;11ee	e5
	ld hl,(05c51h)		;11ef	2a 51 5c  ; CURCHL
l11f2h:
	ex af,af'		;11f2	08
	ld a,(05cbfh)		;11f3	3a bf 5c  ; DEVNUM
	cp 002h			;11f6	fe 02
	jr nc,STREAM_EXT		;11f8	30 0b
	ex af,af'		;11fa	08
	ld e,(hl)		;11fb	5e
	inc hl			;11fc	23
	ld d,(hl)		;11fd	56
	ex de,hl		;11fe	eb
	call JP_HL		;11ff	cd 64 12
	pop hl			;1202	e1
	exx			;1203	d9
	ret			;1204	c9
STREAM_EXT:
	ex af,af'		;1205	08
	ld hl,(05c51h)		;1206	2a 51 5c  ; CURCHL
	ld b,(hl)		;1209	46
	ld c,088h		;120a	0e 88
	ld a,(05cc6h)		;120c	3a c6 5c  ; VIDMOD
	bit 0,a			;120f	cb 47
	jr nz,STREAM_EXT2		;1211	20 02
	inc hl			;1213	23
	inc hl			;1214	23
STREAM_EXT2:
	ld a,(05ccbh)		;1215	3a cb 5c  ; STRMNO
	ld e,a			;1218	5f
	ld d,000h		;1219	16 00
	push de			;121b	d5
	ld de,LROS_JP_LO		;121c	11 07 00
	add hl,de		;121f	19
	push hl			;1220	e5
	push bc			;1221	c5
	ld bc,LROS_BC+1		;1222	01 02 00
	push bc			;1225	c5
	ld bc,LROS_HEADER		;1226	01 00 00
	push bc			;1229	c5
	call 065d0h		;122a	cd d0 65
	pop hl			;122d	e1
	exx			;122e	d9
	ret			;122f	c9
SELECT:

;================================================================
; Module: BASIC
; Routine: SELECT ($1230)
; Select stream A as the current channel.
;================================================================
	add a,a			;1230	87
	add a,016h		;1231	c6 16
	ld l,a			;1233	6f
	ld h,05ch		;1234	26 5c
	ld e,(hl)		;1236	5e
	inc hl			;1237	23
	ld d,(hl)		;1238	56
	ld a,d			;1239	7a
	or e			;123a	b3
	jr nz,STREAM_LOOKUP		;123b	20 02
STREAM_ERR:
	rst 8			;123d	cf
	rla			;123e	17
STREAM_LOOKUP:
	cp 080h			;123f	fe 80
	jr nc,STREAM_SYSCON		;1241	30 22
	dec de			;1243	1b
	ld hl,(05c4fh)		;1244	2a 4f 5c  ; CHANS
	add hl,de		;1247	19
SET_CURCHL:
	ld (05c51h),hl		;1248	22 51 5c  ; CURCHL
	ld a,000h		;124b	3e 00
	ld (05cbfh),a		;124d	32 bf 5c  ; DEVNUM
	res 4,(iy+030h)		;1250	fd cb 30 a6  ; IY+$30 = FLAGS2
	inc hl			;1254	23
	inc hl			;1255	23
	inc hl			;1256	23
	inc hl			;1257	23
	ld c,(hl)		;1258	4e
	ld hl,CHAN_TABLE		;1259	21 93 12
	call SEARCH_TABLE		;125c	cd 6b 13
	ret nc			;125f	d0
	ld d,000h		;1260	16 00
	ld e,(hl)		;1262	5e
	add hl,de		;1263	19
JP_HL:
	jp (hl)			;1264	e9
STREAM_SYSCON:
	ld hl,(05cbch)		;1265	2a bc 5c  ; SYSCON
	sub 080h		;1268	d6 80
	ld d,a			;126a	57
	add hl,de		;126b	19
	ld (05c51h),hl		;126c	22 51 5c  ; CURCHL
	ld a,(hl)		;126f	7e
	ld (05cbfh),a		;1270	32 bf 5c  ; DEVNUM
	res 4,(iy+030h)		;1273	fd cb 30 a6  ; IY+$30 = FLAGS2
	inc hl			;1277	23
	inc hl			;1278	23
	inc hl			;1279	23
	inc hl			;127a	23
	inc hl			;127b	23
	inc hl			;127c	23
	ld a,(05cbfh)		;127d	3a bf 5c  ; DEVNUM
	ld b,a			;1280	47
	ld c,088h		;1281	0e 88
	ld d,(hl)		;1283	56
	inc hl			;1284	23
	ld e,(hl)		;1285	5e
	ld h,d			;1286	62
	ld l,e			;1287	6b
	push hl			;1288	e5
	push bc			;1289	c5
	ld bc,LROS_HEADER		;128a	01 00 00
	push bc			;128d	c5
	push bc			;128e	c5
	call 065d0h		;128f	cd d0 65
	ret			;1292	c9
CHAN_TABLE:
	ld c,e			;1293	4b
	ld b,053h		;1294	06 53
	ld (de),a		;1296	12
	ld d,b			;1297	50
	dec de			;1298	1b
	nop			;1299	00
	set 0,(iy+002h)		;129a	fd cb 02 c6  ; IY+$02 = TVFLAG
	res 5,(iy+001h)		;129e	fd cb 01 ae  ; IY+$01 = FLAGS
	set 4,(iy+030h)		;12a2	fd cb 30 e6  ; IY+$30 = FLAGS2
	jr CHAN_SET_PR		;12a6	18 04
	res 0,(iy+002h)		;12a8	fd cb 02 86  ; IY+$02 = TVFLAG
CHAN_SET_PR:
	res 1,(iy+001h)		;12ac	fd cb 01 8e  ; IY+$01 = FLAGS
	jp DO_ATTS		;12b0	c3 88 08
	set 1,(iy+001h)		;12b3	fd cb 01 ce  ; IY+$01 = FLAGS
	ret			;12b7	c9
MAKE_ROOM_1:

;================================================================
; Module: BASIC
; Routine: MAKE_ROOM ($12B8/$12BB)
; Insert BC bytes at position HL in the BASIC workspace.
;================================================================
	ld bc,LROS_BC		;12b8	01 01 00
MAKE_ROOM:
	push hl			;12bb	e5
	call TEST_ROOM		;12bc	cd bb 1f
	pop hl			;12bf	e1
	call ADJUST_ALL		;12c0	cd ca 12
	ld hl,(05c65h)		;12c3	2a 65 5c  ; STKEND
	ex de,hl		;12c6	eb
	lddr			;12c7	ed b8
	ret			;12c9	c9
ADJUST_ALL:
	push af			;12ca	f5
	push hl			;12cb	e5
	ld hl,05cc4h		;12cc	21 c4 5c  ; CHPTR
	ld e,(hl)		;12cf	5e
	inc hl			;12d0	23
	ld d,(hl)		;12d1	56
	ex (sp),hl		;12d2	e3
	and a			;12d3	a7
	sbc hl,de		;12d4	ed 52
	add hl,de		;12d6	19
	ex (sp),hl		;12d7	e3
	jr nc,ADJUST_PTRS		;12d8	30 06
	ex de,hl		;12da	eb
	add hl,bc		;12db	09
	ex de,hl		;12dc	eb
	ld (hl),d		;12dd	72
	dec hl			;12de	2b
	ld (hl),e		;12df	73
ADJUST_PTRS:
	ld hl,05c4bh		;12e0	21 4b 5c  ; VARS
	ld a,00eh		;12e3	3e 0e
ADJ_LOOP:
	cp 009h			;12e5	fe 09
	jr z,ADJ_CHECK		;12e7	28 04
	cp 008h			;12e9	fe 08
	jr nz,ADJ_NORMAL		;12eb	20 0d
ADJ_CHECK:
	push hl			;12ed	e5
	ld hl,05cc6h		;12ee	21 c6 5c  ; VIDMOD
	ld l,(hl)		;12f1	6e
	bit 7,l			;12f2	cb 7d
	pop hl			;12f4	e1
	jr z,ADJ_NORMAL		;12f5	28 03
	inc hl			;12f7	23
	jr ADJ_NEXT		;12f8	18 14
ADJ_NORMAL:
	ld e,(hl)		;12fa	5e
	inc hl			;12fb	23
	ld d,(hl)		;12fc	56
	ex (sp),hl		;12fd	e3
	and a			;12fe	a7
	sbc hl,de		;12ff	ed 52
	add hl,de		;1301	19
	ex (sp),hl		;1302	e3
	jr nc,ADJ_NEXT		;1303	30 09
	push de			;1305	d5
	ex de,hl		;1306	eb
	add hl,bc		;1307	09
	ex de,hl		;1308	eb
	ld (hl),d		;1309	72
	dec hl			;130a	2b
	ld (hl),e		;130b	73
	inc hl			;130c	23
	pop de			;130d	d1
ADJ_NEXT:
	inc hl			;130e	23
	dec a			;130f	3d
	jr nz,ADJ_LOOP		;1310	20 d3
	ex de,hl		;1312	eb
	pop de			;1313	d1
	pop af			;1314	f1
	and a			;1315	a7
	sbc hl,de		;1316	ed 52
	ld b,h			;1318	44
	ld c,l			;1319	4d
	inc bc			;131a	03
	add hl,de		;131b	19
	ex de,hl		;131c	eb
	ret			;131d	c9
LINE_ZERO:
	nop			;131e	00
	nop			;131f	00
GET_LINE:
	ex de,hl		;1320	eb
	ld de,LINE_ZERO		;1321	11 1e 13
GET_LINENO:
	ld a,(hl)		;1324	7e
	and 0c0h		;1325	e6 c0
	jr nz,GET_LINE		;1327	20 f7
	ld d,(hl)		;1329	56
	inc hl			;132a	23
	ld e,(hl)		;132b	5e
	ret			;132c	c9
GLPR:
	ld hl,(05c63h)		;132d	2a 63 5c  ; STKBOT
	dec hl			;1330	2b
	call MAKE_ROOM		;1331	cd bb 12
	inc hl			;1334	23
	inc hl			;1335	23
	pop bc			;1336	c1
	ld (05c61h),bc		;1337	ed 43 61 5c  ; WORKSP
	pop bc			;133b	c1
	ex de,hl		;133c	eb
	inc hl			;133d	23
	ret			;133e	c9
CLEAR_ELINE_2:

;================================================================
; Module: BASIC
; Routine: CLEAR_ELINE ($133F)
; Clear the edit line, set up workspace pointers.
;================================================================
	ld hl,(05c59h)		;133f	2a 59 5c  ; ELINE
	ld (hl),00dh		;1342	36 0d
	ld (05c5bh),hl		;1344	22 5b 5c  ; KCUR
	inc hl			;1347	23
	ld (hl),080h		;1348	36 80
	inc hl			;134a	23
	ld (05c61h),hl		;134b	22 61 5c  ; WORKSP
CLEAR_WKSP:
	ld hl,(05c61h)		;134e	2a 61 5c  ; WORKSP
	ld (05c63h),hl		;1351	22 63 5c  ; STKBOT
RESET:

;================================================================
; Module: BASIC
; Routine: RESET ($1354)
; Reset calculator stack and memory pointers.
;================================================================
	ld hl,(05c63h)		;1354	2a 63 5c  ; STKBOT
	ld (05c65h),hl		;1357	22 65 5c  ; STKEND
	push hl			;135a	e5
	ld hl,05c92h		;135b	21 92 5c  ; MEMBOT
	ld (05c68h),hl		;135e	22 68 5c  ; MEM
	pop hl			;1361	e1
	ret			;1362	c9
	ld de,(05c59h)		;1363	ed 5b 59 5c  ; ELINE
	jp RECLAIM_INIT		;1367	c3 4d 17
SEARCH_LOOP:
	inc hl			;136a	23
SEARCH_TABLE:
	ld a,(hl)		;136b	7e
	and a			;136c	a7
	ret z			;136d	c8
	cp c			;136e	b9
	inc hl			;136f	23
	jr nz,SEARCH_LOOP		;1370	20 f8
	scf			;1372	37
	ret			;1373	c9
FIND_SYSCON:
	ld hl,(05cbch)		;1374	2a bc 5c  ; SYSCON
	ld de,0000ch		;1377	11 0c 00
	add hl,de		;137a	19
SYSCON_SCAN:
	ld a,(hl)		;137b	7e
	cp 080h			;137c	fe 80
	jr z,SYSCON_NOTFOUND		;137e	28 1a
	inc hl			;1380	23
	inc hl			;1381	23
	cp 001h			;1382	fe 01
	jr nz,SYSCON_NEXT		;1384	20 04
	ld a,(hl)		;1386	7e
	cp c			;1387	b9
	jr z,SYSCON_FOUND		;1388	28 12
SYSCON_NEXT:
	push hl			;138a	e5
	ex de,hl		;138b	eb
	ld de,GETCURCH		;138c	11 18 00
	add hl,de		;138f	19
	ex de,hl		;1390	eb
	pop hl			;1391	e1
	push de			;1392	d5
	ld de,00016h		;1393	11 16 00
	add hl,de		;1396	19
	pop de			;1397	d1
	jr SYSCON_SCAN		;1398	18 e1
SYSCON_NOTFOUND:
	and a			;139a	a7
	ret			;139b	c9
SYSCON_FOUND:
	dec hl			;139c	2b
	scf			;139d	37
	ret			;139e	c9
	call CLOSE_INIT		;139f	cd 0f 14
	ld a,b			;13a2	78
	or c			;13a3	b1
	ret z			;13a4	c8
	call OPEN_CHAN		;13a5	cd be 13
CLEAR_STREAM:
	ld bc,LROS_HEADER		;13a8	01 00 00
	ld de,0a3e2h		;13ab	11 e2 a3
	ex de,hl		;13ae	eb
	add hl,de		;13af	19
	jr c,OPEN_SAVE		;13b0	38 07
	ld bc,RDCH		;13b2	01 cf 11
	add hl,bc		;13b5	09
	ld c,(hl)		;13b6	4e
	inc hl			;13b7	23
	ld b,(hl)		;13b8	46
OPEN_SAVE:
	ex de,hl		;13b9	eb
	ld (hl),c		;13ba	71
	inc hl			;13bb	23
	ld (hl),b		;13bc	70
	ret			;13bd	c9
OPEN_CHAN:
	push hl			;13be	e5
	ld a,b			;13bf	78
	cp 080h			;13c0	fe 80
	jr nc,OPEN_SYSCON		;13c2	30 14
	ld hl,(05c4fh)		;13c4	2a 4f 5c  ; CHANS
	add hl,bc		;13c7	09
	inc hl			;13c8	23
	inc hl			;13c9	23
	inc hl			;13ca	23
	ld c,(hl)		;13cb	4e
	ex de,hl		;13cc	eb
	ld hl,CLOSE_TABLE		;13cd	21 07 14
	call SEARCH_TABLE		;13d0	cd 6b 13
	ld c,(hl)		;13d3	4e
	ld b,000h		;13d4	06 00
	add hl,bc		;13d6	09
	jp (hl)			;13d7	e9
OPEN_SYSCON:
	sub 080h		;13d8	d6 80
	ld b,a			;13da	47
	ld hl,(05cbch)		;13db	2a bc 5c  ; SYSCON
	add hl,bc		;13de	09
	ld a,(hl)		;13df	7e
	cp 000h			;13e0	fe 00
	ret z			;13e2	c8
	cp 080h			;13e3	fe 80
	ret z			;13e5	c8
	inc hl			;13e6	23
	ld b,(hl)		;13e7	46
	inc hl			;13e8	23
	inc hl			;13e9	23
	inc hl			;13ea	23
	inc hl			;13eb	23
	ld e,(hl)		;13ec	5e
	inc hl			;13ed	23
	ld d,(hl)		;13ee	56
	ld h,d			;13ef	62
	ld l,e			;13f0	6b
	ld a,(05ccbh)		;13f1	3a cb 5c  ; STRMNO
	ld e,a			;13f4	5f
	ld d,000h		;13f5	16 00
	push de			;13f7	d5
	push hl			;13f8	e5
	push bc			;13f9	c5
	ld bc,LROS_BC+1		;13fa	01 02 00
	push bc			;13fd	c5
	ld bc,LROS_HEADER		;13fe	01 00 00
	push bc			;1401	c5
	call 065d0h		;1402	cd d0 65
	pop hl			;1405	e1
	ret			;1406	c9
CLOSE_TABLE:
	ld c,e			;1407	4b
	dec b			;1408	05
	ld d,e			;1409	53
	inc bc			;140a	03
	ld d,b			;140b	50
	ld bc,0c9e1h		;140c	01 e1 c9
CLOSE_INIT:
	call FP_TO_A		;140f	cd 1e 1f
	ld (05ccbh),a		;1412	32 cb 5c  ; STRMNO
	cp 010h			;1415	fe 10
	jr c,CLOSE_OK		;1417	38 02
CLOSE_ERR:
	rst 8			;1419	cf
	rla			;141a	17
CLOSE_OK:
	add a,003h		;141b	c6 03
	rlca			;141d	07
	ld hl,05c10h		;141e	21 10 5c  ; STRMS
	ld c,a			;1421	4f
	ld b,000h		;1422	06 00
	add hl,bc		;1424	09
	ld c,(hl)		;1425	4e
	inc hl			;1426	23
	ld b,(hl)		;1427	46
	dec hl			;1428	2b
	ret			;1429	c9
	cp 02ch			;142a	fe 2c
	jr z,CLOSE_HASH		;142c	28 05
	call 01b44h		;142e	cd 44 1b
	jr CLOSE_END		;1431	18 0b
CLOSE_HASH:
	call CHECK_SYNTAX_2		;1433	cd 89 28
	jr nz,CLOSE_END		;1436	20 06
	call EXPR_PAIR		;1438	cd 69 25
	call 01b44h		;143b	cd 44 1b
CLOSE_END:
	rst 28h			;143e	ef
	ld bc,0cd38h		;143f	01 38 cd
	rrca			;1442	0f
	inc d			;1443	14
	ld a,b			;1444	78
	or c			;1445	b1
	jr z,CLOSE_FINAL		;1446	28 16
	ex de,hl		;1448	eb
	ld hl,(05c4fh)		;1449	2a 4f 5c  ; CHANS
	add hl,bc		;144c	09
	inc hl			;144d	23
	inc hl			;144e	23
	inc hl			;144f	23
	ld a,(hl)		;1450	7e
	ex de,hl		;1451	eb
	cp 04bh			;1452	fe 4b
	jr z,CLOSE_FINAL		;1454	28 08
	cp 053h			;1456	fe 53
	jr z,CLOSE_FINAL		;1458	28 04
	cp 050h			;145a	fe 50
	jr nz,CLOSE_ERR		;145c	20 bb
CLOSE_FINAL:
	call CLOSE_SAVE		;145e	cd 65 14
	ld (hl),e		;1461	73
	inc hl			;1462	23
	ld (hl),d		;1463	72
	ret			;1464	c9
CLOSE_SAVE:
	push hl			;1465	e5
	call GET_STRING		;1466	cd af 2f
	dec bc			;1469	0b
	ld a,b			;146a	78
	or c			;146b	b1
	jr z,$+6		;146c	28 04
CLOSE_BAD_STRM:
	rst 8			;146e	cf
	ld (de),a		;146f	12
CLOSE_BAD_DEV:
	rst 8			;1470	cf
	ld c,003h		;1471	0e 03
	push bc			;1473	c5
	ld a,(de)		;1474	1a
	and 0dfh		;1475	e6 df
	ld c,a			;1477	4f
	ld hl,CLOSE_DEV_TBL		;1478	21 c7 14
	call SEARCH_TABLE		;147b	cd 6b 13
	jr nc,CLOSE_NODEV		;147e	30 06
	ld c,(hl)		;1480	4e
	ld b,000h		;1481	06 00
	add hl,bc		;1483	09
	pop bc			;1484	c1
	jp (hl)			;1485	e9
CLOSE_NODEV:
	jr CLOSE_BAD_STRM		;1486	18 e6
	call FIND_SYSCON		;1488	cd 74 13
	jr nc,CLOSE_BAD_STRM		;148b	30 e1
	pop bc			;148d	c1
	dec bc			;148e	0b
	ld a,b			;148f	78
	or c			;1490	b1
	jr nz,CLOSE_BAD_STRM		;1491	20 db
	push de			;1493	d5
	ex de,hl		;1494	eb
	call OPEN_DEV		;1495	cd b9 25
	ex de,hl		;1498	eb
	ld b,(hl)		;1499	46
	ld c,088h		;149a	0e 88
	inc hl			;149c	23
	inc hl			;149d	23
	ld e,(hl)		;149e	5e
	inc hl			;149f	23
	ld d,(hl)		;14a0	56
	ld h,d			;14a1	62
	ld l,e			;14a2	6b
	ld a,(05ccbh)		;14a3	3a cb 5c  ; STRMNO
	ld e,a			;14a6	5f
	ld d,000h		;14a7	16 00
	push de			;14a9	d5
	push hl			;14aa	e5
	push bc			;14ab	c5
STK_POP:
	ld hl,(05c65h)		;14ac	2a 65 5c  ; STKEND
	ld c,(hl)		;14af	4e
	dec hl			;14b0	2b
	ld (05c65h),hl		;14b1	22 65 5c  ; STKEND
	ld b,000h		;14b4	06 00
	inc bc			;14b6	03
	inc bc			;14b7	03
	push bc			;14b8	c5
	ld bc,LROS_HEADER		;14b9	01 00 00
	push bc			;14bc	c5
	call 065d0h		;14bd	cd d0 65
	pop de			;14c0	d1
	ld a,d			;14c1	7a
	add a,080h		;14c2	c6 80
	ld d,a			;14c4	57
	pop hl			;14c5	e1
	ret			;14c6	c9
CLOSE_DEV_TBL:
	ld c,e			;14c7	4b
	ld b,053h		;14c8	06 53
	ex af,af'		;14ca	08
	ld d,b			;14cb	50
	ld a,(bc)		;14cc	0a
	nop			;14cd	00
	ld e,001h		;14ce	1e 01
	jr l14d8h		;14d0	18 06
	ld e,006h		;14d2	1e 06
	jr l14d8h		;14d4	18 02
	ld e,010h		;14d6	1e 10
l14d8h:
	dec bc			;14d8	0b
	ld a,b			;14d9	78
	or c			;14da	b1
	jp nz,CLOSE_BAD_DEV		;14db	c2 70 14
	ld d,a			;14de	57
	pop hl			;14df	e1
	ret			;14e0	c9
AUTO_LIST:
	ld (05c3fh),sp		;14e1	ed 73 3f 5c  ; LISTSP
	ld (iy+002h),010h	;14e5	fd 36 02 10  ; IY+$02 = TVFLAG
	call CLS		;14e9	cd ea 08
	set 0,(iy+002h)		;14ec	fd cb 02 c6  ; IY+$02 = TVFLAG
	ld b,(iy+031h)		;14f0	fd 46 31  ; IY+$31 = DFSZ
	call CLS_B		;14f3	cd 7f 09
	res 0,(iy+002h)		;14f6	fd cb 02 86  ; IY+$02 = TVFLAG
	set 0,(iy+030h)		;14fa	fd cb 30 c6  ; IY+$30 = FLAGS2
	ld hl,(05c49h)		;14fe	2a 49 5c  ; E_PPC
	ld de,(05c6ch)		;1501	ed 5b 6c 5c  ; S_TOP
	and a			;1505	a7
	sbc hl,de		;1506	ed 52
	add hl,de		;1508	19
	jr c,l152dh		;1509	38 22
	push de			;150b	d5
	call FIND_LINE		;150c	cd d6 16
	ld de,K_SCAN_2		;150f	11 c0 02
	ex de,hl		;1512	eb
	sbc hl,de		;1513	ed 52
	ex (sp),hl		;1515	e3
	call FIND_LINE		;1516	cd d6 16
	pop bc			;1519	c1
l151ah:
	push bc			;151a	c5
	call LINE_NEXT		;151b	cd 20 17
	pop bc			;151e	c1
	add hl,bc		;151f	09
	jr c,l1530h		;1520	38 0e
	ex de,hl		;1522	eb
	ld d,(hl)		;1523	56
	inc hl			;1524	23
	ld e,(hl)		;1525	5e
	dec hl			;1526	2b
	ld (05c6ch),de		;1527	ed 53 6c 5c  ; S_TOP
	jr l151ah		;152b	18 ed
l152dh:
	ld (05c6ch),hl		;152d	22 6c 5c  ; S_TOP
l1530h:
	ld hl,(05c6ch)		;1530	2a 6c 5c  ; S_TOP
	call FIND_LINE		;1533	cd d6 16
	jr z,l1539h		;1536	28 01
	ex de,hl		;1538	eb
l1539h:
	call LIST_START		;1539	cd 7f 15
	res 4,(iy+002h)		;153c	fd cb 02 a6  ; IY+$02 = TVFLAG
	ret			;1540	c9
	ld a,003h		;1541	3e 03
	jr l1547h		;1543	18 02
	ld a,002h		;1545	3e 02
l1547h:
	ld (iy+002h),000h	;1547	fd 36 02 00  ; IY+$02 = TVFLAG
	call CHECK_SYNTAX_2		;154b	cd 89 28
	call nz,SELECT	;154e	c4 30 12
	rst 18h			;1551	df
	call CHECK_HASH		;1552	cd 0f 22
	jr c,l156bh		;1555	38 14
	rst 18h			;1557	df
	cp 03bh			;1558	fe 3b
	jr z,l1560h		;155a	28 04
	cp 02ch			;155c	fe 2c
	jr nz,l1566h		;155e	20 06
l1560h:
	rst 20h			;1560	e7
	call EXPR_NUM		;1561	cd e5 1b
	jr l156eh		;1564	18 08
l1566h:
	call EXPR_STR_2		;1566	cd 51 1c
	jr l156eh		;1569	18 03
l156bh:
	call EXPR_STR_1		;156b	cd 49 1c
l156eh:
	call 01b44h		;156e	cd 44 1b
	call FP_TO_BC		;1571	cd 23 1f
	ld a,b			;1574	78
	and 03fh		;1575	e6 3f
	ld h,a			;1577	67
	ld l,c			;1578	69
	ld (05c49h),hl		;1579	22 49 5c  ; E_PPC
	call FIND_LINE		;157c	cd d6 16
LIST_START:
	ld e,001h		;157f	1e 01
LIST_LOOP:
	call LIST_LINE_SUB		;1581	cd a1 15
	rst 10h			;1584	d7
	bit 4,(iy+002h)		;1585	fd cb 02 66  ; IY+$02 = TVFLAG
	jr z,LIST_LOOP		;1589	28 f6
	ld a,(05c6bh)		;158b	3a 6b 5c  ; DFSZ
	sub (iy+04fh)		;158e	fd 96 4f  ; IY+$4F = S_TOP
	jr nz,LIST_LOOP		;1591	20 ee
	xor e			;1593	ab
	ret z			;1594	c8
	push hl			;1595	e5
	push de			;1596	d5
	ld hl,05c6ch		;1597	21 6c 5c  ; S_TOP
	call SET_LINE		;159a	cd 5b 16
	pop de			;159d	d1
	pop hl			;159e	e1
	jr LIST_LOOP		;159f	18 e0
LIST_LINE_SUB:
	ld bc,(05c49h)		;15a1	ed 4b 49 5c  ; E_PPC
	call CMP_LINE		;15a5	cd e8 16
	ld d,03eh		;15a8	16 3e
	jr z,LIST_ARROW		;15aa	28 05
LIST_NOLINE:
	ld de,LROS_HEADER		;15ac	11 00 00
	rl e			;15af	cb 13
LIST_ARROW:
	ld (iy+02dh),e		;15b1	fd 73 2d  ; IY+$2D = BREG
	ld a,(hl)		;15b4	7e
	cp 040h			;15b5	fe 40
	pop bc			;15b7	c1
	ret nc			;15b8	d0
	push bc			;15b9	c5
	call PRINT_LINE_NUM		;15ba	cd 95 17
	inc hl			;15bd	23
	inc hl			;15be	23
	inc hl			;15bf	23
	res 0,(iy+001h)		;15c0	fd cb 01 86  ; IY+$01 = FLAGS
	ld a,d			;15c4	7a
	and a			;15c5	a7
	jr z,LIST_LINE		;15c6	28 05
	rst 10h			;15c8	d7
LIST_SETFLG:
	set 0,(iy+001h)		;15c9	fd cb 01 c6  ; IY+$01 = FLAGS
LIST_LINE:
	push de			;15cd	d5
	ex de,hl		;15ce	eb
	res 2,(iy+030h)		;15cf	fd cb 30 96  ; IY+$30 = FLAGS2
	ld hl,05c3bh		;15d3	21 3b 5c  ; FLAGS
	res 2,(hl)		;15d6	cb 96
	bit 5,(iy+037h)		;15d8	fd cb 37 6e  ; IY+$37 = FLAGX+1
	jr z,LIST_XPTR		;15dc	28 02
	set 2,(hl)		;15de	cb d6
LIST_XPTR:
	ld hl,(05c5fh)		;15e0	2a 5f 5c  ; X_PTR
	and a			;15e3	a7
	sbc hl,de		;15e4	ed 52
	jr nz,LIST_CHAR		;15e6	20 05
	ld a,03fh		;15e8	3e 3f
	call FLASHA		;15ea	cd 0d 16
LIST_CHAR:
	call SHOW_CURSOR		;15ed	cd 2d 16
	ex de,hl		;15f0	eb
	ld a,(hl)		;15f1	7e
	call SKIP_NUMVAL		;15f2	cd 02 16
	inc hl			;15f5	23
	cp 00dh			;15f6	fe 0d
	jr z,LIST_END		;15f8	28 06
	ex de,hl		;15fa	eb
	call PRINT_LISTING		;15fb	cd 83 16
	jr LIST_XPTR		;15fe	18 e0
LIST_END:
	pop de			;1600	d1
	ret			;1601	c9
SKIP_NUMVAL:
	cp 00eh			;1602	fe 0e
	ret nz			;1604	c0
	inc hl			;1605	23
	inc hl			;1606	23
	inc hl			;1607	23
	inc hl			;1608	23
	inc hl			;1609	23
	inc hl			;160a	23
	ld a,(hl)		;160b	7e
	ret			;160c	c9
FLASHA:
	exx			;160d	d9
	ld bc,(05c86h)		;160e	ed 4b 86 5c  ; DFCCL

;================================================================
;*** ZEBRA MODIFICATION: FLASHA removal ($1612-$161B) ***
; 10 bytes of attribute manipulation code replaced with NOPs.
; In 64-column mode there are no per-character attributes.
;================================================================
	nop			;1612	00
	nop			;1613	00
	nop			;1614	00
	nop			;1615	00
	nop			;1616	00
	nop			;1617	00
	nop			;1618	00
	nop			;1619	00
	nop			;161a	00
	nop			;161b	00
	ld hl,05c91h		;161c	21 91 5c  ; PFLAG
	ld d,(hl)		;161f	56
	push de			;1620	d5
	ld (hl),000h		;1621	36 00
	call SENDTV		;1623	cd 00 05
	pop hl			;1626	e1
	ld (05c8fh),hl		;1627	22 8f 5c  ; ATTRT
	exx			;162a	d9
	ret			;162b	c9
	nop			;162c	00
SHOW_CURSOR:
	ld hl,(05c5bh)		;162d	2a 5b 5c  ; KCUR
	and a			;1630	a7
	sbc hl,de		;1631	ed 52
	ret nz			;1633	c0
	ld a,(05c41h)		;1634	3a 41 5c  ; MODE
	rlc a			;1637	cb 07
	jr z,CURSOR_K		;1639	28 04
	add a,043h		;163b	c6 43
	jr CURSOR_SHOW		;163d	18 16
CURSOR_K:
	ld hl,05c3bh		;163f	21 3b 5c  ; FLAGS
	res 3,(hl)		;1642	cb 9e
	ld a,04bh		;1644	3e 4b
	bit 2,(hl)		;1646	cb 56
	jr z,CURSOR_SHOW		;1648	28 0b
	set 3,(hl)		;164a	cb de
	inc a			;164c	3c
	bit 3,(iy+030h)		;164d	fd cb 30 5e  ; IY+$30 = FLAGS2
	jr z,CURSOR_SHOW		;1651	28 02
	ld a,043h		;1653	3e 43
CURSOR_SHOW:
	push de			;1655	d5
	call FLASHA		;1656	cd 0d 16
	pop de			;1659	d1
	ret			;165a	c9
SET_LINE:
	ld e,(hl)		;165b	5e
	inc hl			;165c	23
	ld d,(hl)		;165d	56
	push hl			;165e	e5
	ex de,hl		;165f	eb
	inc hl			;1660	23
	call FIND_LINE		;1661	cd d6 16
	call GET_LINENO		;1664	cd 24 13
	pop hl			;1667	e1
STORE_LINE:
	bit 5,(iy+037h)		;1668	fd cb 37 6e  ; IY+$37 = FLAGX+1
	ret nz			;166c	c0
	ld (hl),d		;166d	72
	dec hl			;166e	2b
	ld (hl),e		;166f	73
	ret			;1670	c9
NUM_NEG:
	ld a,e			;1671	7b
	and a			;1672	a7
	ret m			;1673	f8
	jr PRINT_LISTING		;1674	18 0d
NUM_DIV:
	xor a			;1676	af
NUM_DIV_LP:
	add hl,bc		;1677	09
	inc a			;1678	3c
	jr c,NUM_DIV_LP		;1679	38 fc
	sbc hl,bc		;167b	ed 42
	dec a			;167d	3d
	jr z,NUM_NEG		;167e	28 f1
	jp PRINT_DIGIT		;1680	c3 ea 11
PRINT_LISTING:
	res 4,(iy+001h)		;1683	fd cb 01 a6  ; IY+$01 = FLAGS
	bit 2,(iy+001h)		;1687	fd cb 01 56  ; IY+$01 = FLAGS
	jr z,l1691h		;168b	28 04
	set 4,(iy+001h)		;168d	fd cb 01 e6  ; IY+$01 = FLAGS
l1691h:
	call TOKENIZE		;1691	cd d9 30
	jr nc,l16d4h		;1694	30 3e
	cp 00ch			;1696	fe 0c
	jr z,l16d0h		;1698	28 36
	cp 021h			;169a	fe 21
	jr c,l16d4h		;169c	38 36
	res 2,(iy+001h)		;169e	fd cb 01 96  ; IY+$01 = FLAGS
	cp 07bh			;16a2	fe 7b
	jr nz,l16ach		;16a4	20 06
	bit 4,(iy+001h)		;16a6	fd cb 01 66  ; IY+$01 = FLAGS
	jr z,l16d4h		;16aa	28 28
l16ach:
	cp 0cbh			;16ac	fe cb
	jr z,l16d4h		;16ae	28 24
	cp 03ah			;16b0	fe 3a
	jr nz,l16c2h		;16b2	20 0e
	bit 5,(iy+037h)		;16b4	fd cb 37 6e  ; IY+$37 = FLAGX+1
	jr nz,l16d0h		;16b8	20 16
	bit 2,(iy+030h)		;16ba	fd cb 30 56  ; IY+$30 = FLAGS2
	jr z,l16d4h		;16be	28 14
	jr l16d0h		;16c0	18 0e
l16c2h:
	cp 022h			;16c2	fe 22
	jr nz,l16d0h		;16c4	20 0a
	push af			;16c6	f5
	ld a,(05c6ah)		;16c7	3a 6a 5c  ; FLAGX
	xor 004h		;16ca	ee 04
	ld (05c6ah),a		;16cc	32 6a 5c  ; FLAGX
	pop af			;16cf	f1
l16d0h:
	set 2,(iy+001h)		;16d0	fd cb 01 d6  ; IY+$01 = FLAGS
l16d4h:
	rst 10h			;16d4	d7
	ret			;16d5	c9
FIND_LINE:
	push hl			;16d6	e5
	ld hl,(05c53h)		;16d7	2a 53 5c  ; PROG
	ld d,h			;16da	54
	ld e,l			;16db	5d
l16dch:
	pop bc			;16dc	c1
	call CMP_LINE		;16dd	cd e8 16
	ret nc			;16e0	d0
	push bc			;16e1	c5
	call LINE_NEXT		;16e2	cd 20 17
	ex de,hl		;16e5	eb
	jr l16dch		;16e6	18 f4
CMP_LINE:
	ld a,(hl)		;16e8	7e
	cp b			;16e9	b8
	ret nz			;16ea	c0
	inc hl			;16eb	23
	ld a,(hl)		;16ec	7e
	dec hl			;16ed	2b
	cp c			;16ee	b9
	ret			;16ef	c9
	inc hl			;16f0	23
	inc hl			;16f1	23
	inc hl			;16f2	23
FIND_STMT:
	ld (05c5dh),hl		;16f3	22 5d 5c  ; CH_ADD
	ld c,000h		;16f6	0e 00
FIND_STMT:
	dec d			;16f8	15
	ret z			;16f9	c8
	rst 20h			;16fa	e7
	cp e			;16fb	bb
	jr nz,FIND_CHECK		;16fc	20 04
	and a			;16fe	a7
	ret			;16ff	c9
FIND_NEXT:
	inc hl			;1700	23
	ld a,(hl)		;1701	7e
FIND_CHECK:
	call SKIP_NUMVAL		;1702	cd 02 16
	ld (05c5dh),hl		;1705	22 5d 5c  ; CH_ADD
	cp 022h			;1708	fe 22
	jr nz,FIND_COLON		;170a	20 01
	dec c			;170c	0d
FIND_COLON:
	cp 03ah			;170d	fe 3a
	jr z,FIND_QUOTE		;170f	28 04
	cp 0cbh			;1711	fe cb
	jr nz,FIND_CR		;1713	20 04
FIND_QUOTE:
	bit 0,c			;1715	cb 41
	jr z,FIND_STMT		;1717	28 df
FIND_CR:
	cp 00dh			;1719	fe 0d
	jr nz,FIND_NEXT		;171b	20 e3
	dec d			;171d	15
	scf			;171e	37
	ret			;171f	c9
LINE_NEXT:
	push hl			;1720	e5
	ld a,(hl)		;1721	7e
	cp 040h			;1722	fe 40
	jr c,LINE_SHORT		;1724	38 17
	bit 5,a			;1726	cb 6f
	jr z,LINE_MED		;1728	28 14
	add a,a			;172a	87
	jp m,LINE_LEN_1		;172b	fa 2f 17
	ccf			;172e	3f
LINE_LEN_1:
	ld bc,LROS_CALL+1		;172f	01 05 00
	jr nc,LINE_LEN_LP		;1732	30 02
	ld c,012h		;1734	0e 12
LINE_LEN_LP:
	rla			;1736	17
	inc hl			;1737	23
	ld a,(hl)		;1738	7e
	jr nc,LINE_LEN_LP		;1739	30 fb
	jr LINE_CALC		;173b	18 06
LINE_SHORT:
	inc hl			;173d	23
LINE_MED:
	inc hl			;173e	23
	ld c,(hl)		;173f	4e
	inc hl			;1740	23
LINE_LEN_HI:
	ld b,(hl)		;1741	46
	inc hl			;1742	23
LINE_CALC:
	add hl,bc		;1743	09
	pop de			;1744	d1
LINE_LENGTH:
	and a			;1745	a7
	sbc hl,de		;1746	ed 52
	ld b,h			;1748	44
	ld c,l			;1749	4d
	add hl,de		;174a	19
	ex de,hl		;174b	eb
	ret			;174c	c9
RECLAIM_INIT:
	call LINE_LENGTH		;174d	cd 45 17
RECLAIM:
	push bc			;1750	c5
	ld a,b			;1751	78
	cpl			;1752	2f
	ld b,a			;1753	47
	ld a,c			;1754	79
	cpl			;1755	2f
	ld c,a			;1756	4f
	inc bc			;1757	03
	push bc			;1758	c5
	call ADJUST_ALL		;1759	cd ca 12
	ex (sp),hl		;175c	e3
	add hl,bc		;175d	09
	ld c,l			;175e	4d
	ld b,h			;175f	44
	pop de			;1760	d1
	pop hl			;1761	e1
	add hl,de		;1762	19
	push de			;1763	d5
	ldir			;1764	ed b0
	pop hl			;1766	e1
	ret			;1767	c9
SYNTAX_CHECK:
	ld hl,(05c59h)		;1768	2a 59 5c  ; ELINE
	dec hl			;176b	2b
	ld (05c5dh),hl		;176c	22 5d 5c  ; CH_ADD
	rst 20h			;176f	e7
	ld hl,05c92h		;1770	21 92 5c  ; MEMBOT
	ld (05c65h),hl		;1773	22 65 5c  ; STKEND
	call SYNTAX_MAIN		;1776	cd f9 30
	call EVAL_NUMERIC		;1779	cd 60 31
	jr c,SYNTAX_ERR		;177c	38 04
	ld hl,0d8f0h		;177e	21 f0 d8
	add hl,bc		;1781	09
SYNTAX_ERR:
	jp c,NONSENSE_ERR		;1782	da ed 1b
	jp RESET		;1785	c3 54 13
PRINT_NUM:
	push de			;1788	d5
	push hl			;1789	e5
	xor a			;178a	af
	bit 7,b			;178b	cb 78
	jr nz,NUM_NEG_PRINT		;178d	20 20
	ld h,b			;178f	60
	ld l,c			;1790	69
	ld e,0ffh		;1791	1e ff
	jr NUM_PRINT		;1793	18 08
PRINT_LINE_NUM:
	push de			;1795	d5
	ld d,(hl)		;1796	56
	inc hl			;1797	23
	ld e,(hl)		;1798	5e
	push hl			;1799	e5
	ex de,hl		;179a	eb
	ld e,020h		;179b	1e 20
NUM_PRINT:
	ld bc,0fc18h		;179d	01 18 fc
	call NUM_DIV		;17a0	cd 76 16
	ld bc,0ff9ch		;17a3	01 9c ff
	call NUM_DIV		;17a6	cd 76 16
	ld c,0f6h		;17a9	0e f6
	call NUM_DIV		;17ab	cd 76 16
	ld a,l			;17ae	7d
NUM_NEG_PRINT:
	call PRINT_DIGIT		;17af	cd ea 11
	pop hl			;17b2	e1
	pop de			;17b3	d1
	ret			;17b4	c9
LOAD_SUB:
	push bc			;17b5	c5
	ld bc,0ff00h		;17b6	01 00 ff
	call 06499h		;17b9	cd 99 64
	pop bc			;17bc	c1
	call MAKE_ROOM		;17bd	cd bb 12
	ld hl,(05cbch)		;17c0	2a bc 5c  ; SYSCON
	ld de,LROS_CALL		;17c3	11 04 00
	add hl,de		;17c6	19
	ld a,(hl)		;17c7	7e
	ld b,000h		;17c8	06 00
	ld c,a			;17ca	4f
	call 06499h		;17cb	cd 99 64
	ret			;17ce	c9
LOAD_FIND:
	ld hl,(05cbch)		;17cf	2a bc 5c  ; SYSCON
	inc hl			;17d2	23
	inc hl			;17d3	23
	ld e,(hl)		;17d4	5e
	inc hl			;17d5	23
	ld d,(hl)		;17d6	56
	ex de,hl		;17d7	eb
VARFIND_LP:
	ld a,(hl)		;17d8	7e
	cp b			;17d9	b8
	jr nz,VARFIND_RET		;17da	20 04
	inc hl			;17dc	23
	ld a,(hl)		;17dd	7e
	dec hl			;17de	2b
	cp c			;17df	b9
VARFIND_RET:
	ret nc			;17e0	d0
	inc hl			;17e1	23
	inc hl			;17e2	23
	ld e,(hl)		;17e3	5e
	inc hl			;17e4	23
	ld d,(hl)		;17e5	56
	inc hl			;17e6	23
	add hl,de		;17e7	19
	jr VARFIND_LP		;17e8	18 ee
LOAD_SETUP:
	push hl			;17ea	e5
	ld hl,(05cbch)		;17eb	2a bc 5c  ; SYSCON
	ld de,LROS_CALL		;17ee	11 04 00
	add hl,de		;17f1	19
	ld a,(hl)		;17f2	7e
	ld c,a			;17f3	4f
	ld b,000h		;17f4	06 00
	call 06499h		;17f6	cd 99 64
	pop bc			;17f9	c1
	call LOAD_FIND		;17fa	cd cf 17
	jr LOAD_CHECK		;17fd	18 19
LOAD_EXEC:
	call CHECK_SYNTAX_2		;17ff	cd 89 28
	ret z			;1802	c8
	ld hl,(05cbch)		;1803	2a bc 5c  ; SYSCON
	ld de,LROS_CALL		;1806	11 04 00
	add hl,de		;1809	19
	ld a,(hl)		;180a	7e
	ld c,a			;180b	4f
	ld b,000h		;180c	06 00
	call 06499h		;180e	cd 99 64
	ld hl,(05c55h)		;1811	2a 55 5c  ; NXTLIN
	ld (iy+00ah),000h	;1814	fd 36 0a 00  ; IY+$0A = NSPPC
LOAD_CHECK:
	ld a,(hl)		;1818	7e
	and 0c0h		;1819	e6 c0
	jr z,LOAD_LINE		;181b	28 07
	ld bc,0ff00h		;181d	01 00 ff
	call 06499h		;1820	cd 99 64
	ret			;1823	c9
LOAD_LINE:
	ld d,(hl)		;1824	56
	inc hl			;1825	23
	ld e,(hl)		;1826	5e
	ld (05c45h),de		;1827	ed 53 45 5c  ; PPC
	inc hl			;182b	23
	ld e,(hl)		;182c	5e
	inc hl			;182d	23
	ld d,(hl)		;182e	56
	inc hl			;182f	23
	push hl			;1830	e5
	add hl,de		;1831	19
	ld (05c55h),hl		;1832	22 55 5c  ; NXTLIN
	push de			;1835	d5
	ld hl,(05c4fh)		;1836	2a 4f 5c  ; CHANS
	dec hl			;1839	2b
	ld de,(05cc4h)		;183a	ed 5b c4 5c  ; CHPTR
	and a			;183e	a7
	sbc hl,de		;183f	ed 52
LOAD_SIZE:
	ld de,TOK_TAN		;1841	11 d0 00
	ex de,hl		;1844	eb
	and a			;1845	a7
	sbc hl,de		;1846	ed 52
	jr nc,LOAD_SKIP		;1848	30 24
	ld a,l			;184a	7d
	cpl			;184b	2f
	ld c,a			;184c	4f
	ld a,h			;184d	7c
	cpl			;184e	2f
	ld b,a			;184f	47
	inc bc			;1850	03
	inc bc			;1851	03
	ld hl,(05cc4h)		;1852	2a c4 5c  ; CHPTR
	push bc			;1855	c5
	ld bc,0ff00h		;1856	01 00 ff
	call 06499h		;1859	cd 99 64
	pop bc			;185c	c1
	call RECLAIM		;185d	cd 50 17
	ld hl,(05cbch)		;1860	2a bc 5c  ; SYSCON
	ld de,LROS_CALL		;1863	11 04 00
	add hl,de		;1866	19
	ld a,(hl)		;1867	7e
	ld b,000h		;1868	06 00
	ld c,a			;186a	4f
	call 06499h		;186b	cd 99 64
LOAD_SKIP:
	pop hl			;186e	e1
	push hl			;186f	e5
	ld de,TOK_COS+1		;1870	11 cf 00
	dec hl			;1873	2b
	and a			;1874	a7
	sbc hl,de		;1875	ed 52
	jr c,LOAD_POP		;1877	38 0a
	ld c,l			;1879	4d
	ld b,h			;187a	44
	inc bc			;187b	03
	ld hl,(05c4fh)		;187c	2a 4f 5c  ; CHANS
	dec hl			;187f	2b
	call LOAD_SUB		;1880	cd b5 17
LOAD_POP:
	pop bc			;1883	c1
	pop de			;1884	d1
	ld hl,TOK_NOT		;1885	21 ff 00
	push hl			;1888	e5
	push de			;1889	d5
	ld hl,(05cc4h)		;188a	2a c4 5c  ; CHPTR
	ld (hl),00dh		;188d	36 0d
	ld (05c5dh),hl		;188f	22 5d 5c  ; CH_ADD
	inc hl			;1892	23
	push hl			;1893	e5
	push bc			;1894	c5
	ld bc,LROS_BC		;1895	01 01 00
	push bc			;1898	c5
	call 06722h		;1899	cd 22 67
	ld a,(iy+00ah)		;189c	fd 7e 0a  ; IY+$0A = NSPPC
	ld (iy+00ah),0ffh	;189f	fd 36 0a ff  ; IY+$0A = NSPPC
	cp 001h			;18a3	fe 01
	adc a,000h		;18a5	ce 00
	dec a			;18a7	3d
	push af			;18a8	f5
	ld (05c47h),a		;18a9	32 47 5c  ; SUBPPC
	ld (iy+000h),0ffh	;18ac	fd 36 00 ff  ; IY+$00 = ERR_NR
	ld bc,0ff00h		;18b0	01 00 ff
	call 06499h		;18b3	cd 99 64
	pop af			;18b6	f1
	jp z,l1a44h		;18b7	ca 44 1a
	inc a			;18ba	3c
	ld d,a			;18bb	57
	ld e,000h		;18bc	1e 00
	call FIND_STMT		;18be	cd f3 16
	jp z,l1b4ah		;18c1	ca 4a 1b
	rst 8			;18c4	cf
	ld d,021h		;18c5	16 21
	add a,05ch		;18c7	c6 5c
	ld (hl),080h		;18c9	36 80
	ld bc,TOK_TAN		;18cb	01 d0 00
	ld hl,06840h		;18ce	21 40 68
	dec hl			;18d1	2b
	call MAKE_ROOM		;18d2	cd bb 12
	ld hl,06840h		;18d5	21 40 68
	ld (05cc4h),hl		;18d8	22 c4 5c  ; CHPTR
	ld hl,(05cbch)		;18db	2a bc 5c  ; SYSCON
	ld de,LROS_CALL+2		;18de	11 06 00
	add hl,de		;18e1	19
	ld c,(hl)		;18e2	4e
	inc hl			;18e3	23
	ld b,(hl)		;18e4	46
	ld hl,06840h		;18e5	21 40 68
	dec hl			;18e8	2b
	call MAKE_ROOM		;18e9	cd bb 12
	ld hl,(05cbch)		;18ec	2a bc 5c  ; SYSCON
	ld de,LROS_CALL		;18ef	11 04 00
	add hl,de		;18f2	19
	ld a,(hl)		;18f3	7e
	ld b,000h		;18f4	06 00
	ld c,a			;18f6	4f
	call 06499h		;18f7	cd 99 64
	ld hl,(05cbch)		;18fa	2a bc 5c  ; SYSCON
	inc hl			;18fd	23
	inc hl			;18fe	23
	ld e,(hl)		;18ff	5e
	inc hl			;1900	23
	ld d,(hl)		;1901	56
	ex de,hl		;1902	eb
	ld d,(hl)		;1903	56
	inc hl			;1904	23
	ld e,(hl)		;1905	5e
	ld bc,0ff00h		;1906	01 00 ff
	call 06499h		;1909	cd 99 64
	ld hl,(05cbch)		;190c	2a bc 5c  ; SYSCON
	ld bc,LROS_CALL+1		;190f	01 05 00
	add hl,bc		;1912	09
	ld a,(hl)		;1913	7e
LOAD_TYPE:
	cp 000h			;1914	fe 00
	jr z,l1941h		;1916	28 29
	ld (05c42h),de		;1918	ed 53 42 5c  ; NEWPPC
	call K_CLS		;191c	cd a6 08
	ld hl,(05cbch)		;191f	2a bc 5c  ; SYSCON
	inc hl			;1922	23
	inc hl			;1923	23
	ld e,(hl)		;1924	5e
	inc hl			;1925	23
	ld d,(hl)		;1926	56
	ex de,hl		;1927	eb
	dec hl			;1928	2b
	ld (05c57h),hl		;1929	22 57 5c
	ld (iy+000h),0ffh	;192c	fd 36 00 ff  ; IY+$00 = ERR_NR
	set 7,(iy+001h)		;1930	fd cb 01 fe  ; IY+$01 = FLAGS
	ld (iy+00ah),000h	;1934	fd 36 0a 00  ; IY+$0A = NSPPC
	ld hl,MAIN_HALT		;1938	21 8d 0e
	push hl			;193b	e5
	ld hl,l1ab9h		;193c	21 b9 1a
	ei			;193f	fb
	jp (hl)			;1940	e9
l1941h:
	ei			;1941	fb
	jp MAIN_ENTRY		;1942	c3 2f 0e
l1945h:
	or l			;1945	b5
	ret nc			;1946	d0
	ret nz			;1947	c0
	call nz,0b3c8h		;1948	c4 c8 b3
	cp b			;194b	b8
	sub a			;194c	97
	sub l			;194d	95
	sub (hl)		;194e	96
	sbc a,c			;194f	99
	sbc a,h			;1950	9c
	sbc a,h			;1951	9c
	sbc a,h			;1952	9c
	sbc a,h			;1953	9c
	sbc a,h			;1954	9c
	sbc a,h			;1955	9c
	sbc a,h			;1956	9c
	add a,e			;1957	83
	add a,l			;1958	85
	ld (07270h),a		;1959	32 70 72
	ld (hl),h		;195c	74
	ld c,h			;195d	4c
	sbc a,b			;195e	98
	ld e,d			;195f	5a
	ld b,e			;1960	43
	ld b,l			;1961	45
	cpl			;1962	2f
	dec de			;1963	1b
	inc hl			;1964	23
	dec sp			;1965	3b
	ld a,e			;1966	7b
	ld c,b			;1967	48
	inc de			;1968	13
	ld e,l			;1969	5d
	cpl			;196a	2f
	ld b,a			;196b	47
	ld sp,Z64_UDG_PRINT		;196c	31 55 3e
	ld (hl),c		;196f	71
	ld b,(hl)		;1970	46
	ld de,0604dh		;1971	11 4d 60
	ld c,b			;1974	48
	add hl,de		;1975	19
	ld h,c			;1976	61
l1977h:
	and h			;1977	a4
	and (hl)		;1978	a6
	xor b			;1979	a8
	xor d			;197a	aa
	ld bc,l023dh		;197b	01 3d 02
	ld b,000h		;197e	06 00
	pop af			;1980	f1
	ld e,006h		;1981	1e 06
	rlc l			;1983	cb 05
	ld e,e			;1985	5b
	inc e			;1986	1c
	ld b,000h		;1987	06 00
	sbc a,c			;1989	99
	rra			;198a	1f
	nop			;198b	00
	ld e,c			;198c	59
	inc e			;198d	1c
	nop			;198e	00
	call nc,PARP_OUT	;198f	d4 1f 04
	dec a			;1992	3d
	ld b,0cch		;1993	06 cc
	ld b,005h		;1995	06 05
	ld a,b			;1997	78
	inc e			;1998	1c
	inc b			;1999	04
	nop			;199a	00
	ld d,l			;199b	55
	dec e			;199c	1d
	dec b			;199d	05
	ld e,c			;199e	59
	ld hl,02b05h		;199f	21 05 2b
	ld (0c005h),hl		;19a2	22 05 c0
	cpl			;19a5	2f
	dec b			;19a6	05
	nop			;19a7	00
	dec de			;19a8	1b
	nop			;19a9	00
	dec e			;19aa	1d
	dec c			;19ab	0d
	inc bc			;19ac	03
	dec hl			;19ad	2b
	rra			;19ae	1f
	dec b			;19af	05
	ld b,l			;19b0	45
	dec d			;19b1	15
	ex af,af'		;19b2	08
	nop			;19b3	00
	ld a,(bc)		;19b4	0a
	rra			;19b5	1f
	inc bc			;19b6	03
	call nc,GETCURCH_1+2	;19b7	d4 1e 00
	call po,0031eh		;19ba	e4 1e 03
	ld (hl),01fh		;19bd	36 1f
	nop			;19bf	00
	and (hl)		;19c0	a6
	ex af,af'		;19c1	08
	add hl,bc		;19c2	09
	nop			;19c3	00
	dec (hl)		;19c4	35
	ld h,006h		;19c5	26 06
	nop			;19c7	00
	ex de,hl		;19c8	eb
	rra			;19c9	1f
	dec b			;19ca	05
	sub a			;19cb	97
	dec e			;19cc	1d
	dec b			;19cd	05
	add a,d			;19ce	82
	ld e,003h		;19cf	1e 03
	sbc a,l			;19d1	9d
	ld e,009h		;19d2	1e 09
	dec b			;19d4	05
	in a,(026h)		;19d5	db 26
	nop			;19d7	00
	ld (bc),a		;19d8	02
	ld a,(bc)		;19d9	0a
	dec b			;19da	05
	ld d,l			;19db	55
	ld hl,04105h		;19dc	21 05 41
	dec d			;19df	15
	dec bc			;19e0	0b
	dec bc			;19e1	0b
	dec bc			;19e2	0b
	dec bc			;19e3	0b
	ex af,af'		;19e4	08
	nop			;19e5	00
	ld (hl),004h		;19e6	36 04
	add hl,bc		;19e8	09
	dec b			;19e9	05
	ld a,c			;19ea	79
	ld h,007h		;19eb	26 07
	rlca			;19ed	07
	rlca			;19ee	07
	rlca			;19ef	07
	rlca			;19f0	07
	rlca			;19f1	07
	ex af,af'		;19f2	08
	nop			;19f3	00
	inc b			;19f4	04
	rra			;19f5	1f
	ld b,000h		;19f6	06 00
	ld a,024h		;19f8	3e 24
	dec b			;19fa	05
	dec e			;19fb	1d
	jr nz,l1a04h		;19fc	20 06
	inc l			;19fe	2c
	ld a,(bc)		;19ff	0a
	dec b			;1a00	05
	ld hl,(STTVCU_PR+1)	;1a01	2a 14 06
l1a04h:
	nop			;1a04	00
	sbc a,a			;1a05	9f
	inc de			;1a06	13
	ld a,(bc)		;1a07	0a
	inc l			;1a08	2c
	dec b			;1a09	05
	call z,CURSOR_BANK	;1a0a	cc 25 0a
	inc l			;1a0d	2c
	dec b			;1a0e	05
	ret nc			;1a0f	d0
	dec h			;1a10	25
	ld a,(bc)		;1a11	0a
	inc l			;1a12	2c
	dec b			;1a13	05
	call nc,CURSOR_BANK	;1a14	d4 25 0a
	inc l			;1a17	2c
	dec b			;1a18	05
	ret z			;1a19	c8
	dec h			;1a1a	25
	dec b			;1a1b	05
	pop de			;1a1c	d1
	jr nz,l1a24h		;1a1d	20 05
	add a,b			;1a1f	80
	jr nz,sub_1a27h		;1a20	20 05
	ld d,h			;1a22	54
	inc h			;1a23	24
l1a24h:
	dec b			;1a24	05
	jr z,l1a48h		;1a25	28 21
sub_1a27h:
	res 7,(iy+001h)		;1a27	fd cb 01 be  ; IY+$01 = FLAGS
	call SYNTAX_CHECK		;1a2b	cd 68 17
	ld a,b			;1a2e	78
	or c			;1a2f	b1
	jr z,l1a3ah		;1a30	28 08
	ld a,(05cc6h)		;1a32	3a c6 5c  ; VIDMOD
	bit 7,a			;1a35	cb 7f
	jp nz,NONSENSE_ERR		;1a37	c2 ed 1b
l1a3ah:
	xor a			;1a3a	af
	ld (05c47h),a		;1a3b	32 47 5c  ; SUBPPC
	dec a			;1a3e	3d
	ld (05c3ah),a		;1a3f	32 3a 5c  ; ERR_NR
	jr l1a45h		;1a42	18 01
l1a44h:
	rst 20h			;1a44	e7
l1a45h:
	call CLEAR_WKSP		;1a45	cd 4e 13
l1a48h:
	inc (iy+00dh)		;1a48	fd 34 0d  ; IY+$0D = SUBPPC
	jp m,NONSENSE_ERR		;1a4b	fa ed 1b
	rst 18h			;1a4e	df
	ld b,000h		;1a4f	06 00
	cp 00dh			;1a51	fe 0d
	jp z,l1b09h		;1a53	ca 09 1b
	cp 03ah			;1a56	fe 3a
	jr z,l1a44h		;1a58	28 ea
	ld hl,l1ab9h		;1a5a	21 b9 1a
	push hl			;1a5d	e5
	ld c,a			;1a5e	4f
	rst 20h			;1a5f	e7
	ld a,c			;1a60	79
	cp 00ch			;1a61	fe 0c
	jr z,l1a7fh		;1a63	28 1a
	cp 07bh			;1a65	fe 7b
	jr c,l1a71h		;1a67	38 08
	cp 080h			;1a69	fe 80
	jr nc,l1a71h		;1a6b	30 04
	bit 0,a			;1a6d	cb 47
	jr nz,l1a7fh		;1a6f	20 0e
l1a71h:
	sub 0ceh		;1a71	d6 ce
	jp c,NONSENSE_ERR		;1a73	da ed 1b
	ld c,a			;1a76	4f
	ld hl,l1945h		;1a77	21 45 19
l1a7ah:
	add hl,bc		;1a7a	09
	ld c,(hl)		;1a7b	4e
	add hl,bc		;1a7c	09
	jr l1a98h		;1a7d	18 19
l1a7fh:
	cp 00ch			;1a7f	fe 0c
	jr nz,l1a87h		;1a81	20 04
	ld a,000h		;1a83	3e 00
	jr BEEP_TABLE		;1a85	18 08
l1a87h:
	sub 07ah		;1a87	d6 7a
	cp 005h			;1a89	fe 05
	jr nz,BEEP_TABLE		;1a8b	20 02
	ld a,002h		;1a8d	3e 02
BEEP_TABLE:
	ld hl,l1977h		;1a8f	21 77 19
	ld c,a			;1a92	4f
	jr l1a7ah		;1a93	18 e5
l1a95h:
	ld hl,(05c74h)		;1a95	2a 74 5c
l1a98h:
	ld a,(hl)		;1a98	7e
	inc hl			;1a99	23
	ld (05c74h),hl		;1a9a	22 74 5c
	ld bc,l1a95h		;1a9d	01 95 1a
	push bc			;1aa0	c5
	ld c,a			;1aa1	4f
	cp 020h			;1aa2	fe 20
	jr nc,l1ab2h		;1aa4	30 0c
	ld hl,l1b64h		;1aa6	21 64 1b
	ld b,000h		;1aa9	06 00
	add hl,bc		;1aab	09
	ld c,(hl)		;1aac	4e
	add hl,bc		;1aad	09
	push hl			;1aae	e5
	rst 18h			;1aaf	df
	dec b			;1ab0	05
	ret			;1ab1	c9
l1ab2h:
	rst 18h			;1ab2	df
	cp c			;1ab3	b9
	jp nz,NONSENSE_ERR		;1ab4	c2 ed 1b
	rst 20h			;1ab7	e7
	ret			;1ab8	c9
l1ab9h:
	call TAPE_SYNC		;1ab9	cd 09 20
	jr c,l1ac0h		;1abc	38 02
	rst 8			;1abe	cf
	inc d			;1abf	14
l1ac0h:
	bit 7,(iy+00ah)		;1ac0	fd cb 0a 7e  ; IY+$0A = NSPPC
	jp nz,l1b4ah		;1ac4	c2 4a 1b
	ld hl,(05c42h)		;1ac7	2a 42 5c  ; NEWPPC
	bit 7,h			;1aca	cb 7c
	jr nz,sub_1ad8h		;1acc	20 0a
	ld a,(05cc6h)		;1ace	3a c6 5c  ; VIDMOD
	bit 7,a			;1ad1	cb 7f
	jp nz,LOAD_SETUP		;1ad3	c2 ea 17
	jr l1aech		;1ad6	18 14
sub_1ad8h:
	ld hl,0fffeh		;1ad8	21 fe ff
	ld (05c45h),hl		;1adb	22 45 5c  ; PPC
	ld hl,(05c61h)		;1ade	2a 61 5c  ; WORKSP
	dec hl			;1ae1	2b
	ld de,(05c59h)		;1ae2	ed 5b 59 5c  ; ELINE
	dec de			;1ae6	1b
	ld a,(05c44h)		;1ae7	3a 44 5c  ; NSPPC
	jr l1b27h		;1aea	18 3b
l1aech:
	call FIND_LINE		;1aec	cd d6 16
	ld a,(05c44h)		;1aef	3a 44 5c  ; NSPPC
	jr z,l1b15h		;1af2	28 21
	and a			;1af4	a7
	jr nz,l1b42h		;1af5	20 4b
	ld b,a			;1af7	47
	ld a,(hl)		;1af8	7e
	and 0c0h		;1af9	e6 c0
	ld a,b			;1afb	78
	jr z,l1b15h		;1afc	28 17
	rst 8			;1afe	cf
	rst 38h			;1aff	ff
	pop bc			;1b00	c1
	ld a,(05cc6h)		;1b01	3a c6 5c  ; VIDMOD
	bit 7,a			;1b04	cb 7f
	jp nz,LOAD_EXEC		;1b06	c2 ff 17
l1b09h:
	call CHECK_SYNTAX_2		;1b09	cd 89 28
	ret z			;1b0c	c8
	ld hl,(05c55h)		;1b0d	2a 55 5c  ; NXTLIN
	ld a,0c0h		;1b10	3e c0
	and (hl)		;1b12	a6
	ret nz			;1b13	c0
	xor a			;1b14	af
l1b15h:
	cp 001h			;1b15	fe 01
	adc a,000h		;1b17	ce 00
	ld d,(hl)		;1b19	56
	inc hl			;1b1a	23
	ld e,(hl)		;1b1b	5e
	ld (05c45h),de		;1b1c	ed 53 45 5c  ; PPC
	inc hl			;1b20	23
	ld e,(hl)		;1b21	5e
	inc hl			;1b22	23
	ld d,(hl)		;1b23	56
	ex de,hl		;1b24	eb
	add hl,de		;1b25	19
	inc hl			;1b26	23
l1b27h:
	ld (05c55h),hl		;1b27	22 55 5c  ; NXTLIN
	ex de,hl		;1b2a	eb
	ld (05c5dh),hl		;1b2b	22 5d 5c  ; CH_ADD
	ld d,a			;1b2e	57
	ld e,000h		;1b2f	1e 00
	ld (iy+00ah),0ffh	;1b31	fd 36 0a ff  ; IY+$0A = NSPPC
	dec d			;1b35	15
	ld (iy+00dh),d		;1b36	fd 72 0d  ; IY+$0D = SUBPPC
	jp z,l1a44h		;1b39	ca 44 1a
	inc d			;1b3c	14
	call FIND_STMT		;1b3d	cd f3 16
	jr z,l1b4ah		;1b40	28 08
l1b42h:
	rst 8			;1b42	cf
	ld d,0cdh		;1b43	16 cd
	adc a,c			;1b45	89
	jr z,$-62		;1b46	28 c0
	pop bc			;1b48	c1
	pop bc			;1b49	c1
l1b4ah:
	rst 18h			;1b4a	df
	cp 00dh			;1b4b	fe 0d
	jr nz,l1b5ch		;1b4d	20 0d
	ld hl,(05c55h)		;1b4f	2a 55 5c  ; NXTLIN
	ld a,(05cc6h)		;1b52	3a c6 5c  ; VIDMOD
	bit 7,a			;1b55	cb 7f
	jp nz,LOAD_EXEC		;1b57	c2 ff 17
	jr l1b09h		;1b5a	18 ad
l1b5ch:
	cp 03ah			;1b5c	fe 3a
	jp z,l1a44h		;1b5e	ca 44 1a
	jp NONSENSE_ERR		;1b61	c3 ed 1b
l1b64h:
	rrca			;1b64	0f
	dec e			;1b65	1d
	ld c,e			;1b66	4b
	add hl,bc		;1b67	09
	ld h,a			;1b68	67
	dec bc			;1b69	0b
	ld a,e			;1b6a	7b
	adc a,(hl)		;1b6b	8e
	ld (hl),c		;1b6c	71
	cp h			;1b6d	bc
	add a,c			;1b6e	81
	rst 10h			;1b6f	d7
	call EXPR_STR_1		;1b70	cd 49 1c
	cp a			;1b73	bf
	pop bc			;1b74	c1
	call z,01b44h		;1b75	cc 44 1b
	ex de,hl		;1b78	eb
	ld hl,(05c74h)		;1b79	2a 74 5c
	ld c,(hl)		;1b7c	4e
	inc hl			;1b7d	23
	ld b,(hl)		;1b7e	46
	ex de,hl		;1b7f	eb
	push bc			;1b80	c5
	ret			;1b81	c9
sub_1b82h:
	call sub_2c70h		;1b82	cd 70 2c
l1b85h:
	ld (iy+037h),000h	;1b85	fd 36 37 00  ; IY+$37 = FLAGX+1
	jr nc,$+10		;1b89	30 08
	set 1,(iy+037h)		;1b8b	fd cb 37 ce  ; IY+$37 = FLAGX+1
	jr nz,l1ba9h		;1b8f	20 18
l1b91h:
	rst 8			;1b91	cf
	ld bc,054cch		;1b92	01 cc 54
	dec l			;1b95	2d
	bit 6,(iy+001h)		;1b96	fd cb 01 76  ; IY+$01 = FLAGS
	jr nz,l1ba9h		;1b9a	20 0d
	xor a			;1b9c	af
	call CHECK_SYNTAX_2		;1b9d	cd 89 28
	call nz,GET_STRING	;1ba0	c4 af 2f
	ld hl,05c71h		;1ba3	21 71 5c
	or (hl)			;1ba6	b6
	ld (hl),a		;1ba7	77
	ex de,hl		;1ba8	eb
l1ba9h:
	ld (05c72h),bc		;1ba9	ed 43 72 5c
	ld (05c4dh),hl		;1bad	22 4d 5c  ; DEST
	ret			;1bb0	c9
	pop bc			;1bb1	c1
	call sub_1bb9h		;1bb2	cd b9 1b
	call 01b44h		;1bb5	cd 44 1b
	ret			;1bb8	c9
sub_1bb9h:
	ld a,(05c3bh)		;1bb9	3a 3b 5c  ; FLAGS
sub_1bbch:
	push af			;1bbc	f5
	call EVAL_EXPR		;1bbd	cd 54 28
	pop af			;1bc0	f1
	ld d,(iy+001h)		;1bc1	fd 56 01  ; IY+$01 = FLAGS
	xor d			;1bc4	aa
	and 040h		;1bc5	e6 40
	jr nz,NONSENSE_ERR		;1bc7	20 24
	bit 7,d			;1bc9	cb 7a
	jp nz,l2ebdh		;1bcb	c2 bd 2e
	ret			;1bce	c9
	call sub_2c70h		;1bcf	cd 70 2c
	push af			;1bd2	f5
	ld a,c			;1bd3	79
	or 09fh			;1bd4	f6 9f
	inc a			;1bd6	3c
	jr nz,NONSENSE_ERR		;1bd7	20 14
	pop af			;1bd9	f1
	jr l1b85h		;1bda	18 a9
SKIP_NEXT:
	rst 20h			;1bdc	e7
SKIP_EXPR:
	call EXPR_NUM		;1bdd	cd e5 1b
	cp 02ch			;1be0	fe 2c
	jr nz,NONSENSE_ERR		;1be2	20 09
	rst 20h			;1be4	e7
EXPR_NUM:
	call EVAL_EXPR		;1be5	cd 54 28
	bit 6,(iy+001h)		;1be8	fd cb 01 76  ; IY+$01 = FLAGS
	ret nz			;1bec	c0
NONSENSE_ERR:
	rst 8			;1bed	cf
	dec bc			;1bee	0b
sub_1befh:
	call EVAL_EXPR		;1bef	cd 54 28
	bit 6,(iy+001h)		;1bf2	fd cb 01 76  ; IY+$01 = FLAGS
	ret z			;1bf6	c8
	jr NONSENSE_ERR		;1bf7	18 f4
	bit 7,(iy+001h)		;1bf9	fd cb 01 7e  ; IY+$01 = FLAGS
	res 0,(iy+002h)		;1bfd	fd cb 02 86  ; IY+$02 = TVFLAG
	call nz,DO_ATTS	;1c01	c4 88 08
	pop af			;1c04	f1
	ld a,(05c74h)		;1c05	3a 74 5c
	ld hl,(05c74h)		;1c08	2a 74 5c
	ld de,LOAD_TYPE		;1c0b	11 14 19
	and a			;1c0e	a7
	sbc hl,de		;1c0f	ed 52
	ld a,l			;1c11	7d
	call sub_23a6h		;1c12	cd a6 23
	call 01b44h		;1c15	cd 44 1b
	ld hl,(05c8fh)		;1c18	2a 8f 5c  ; ATTRT
	ld (05c8dh),hl		;1c1b	22 8d 5c  ; ATTRP
	ld hl,05c91h		;1c1e	21 91 5c  ; PFLAG
	ld a,(hl)		;1c21	7e
l1c22h:
	rlca			;1c22	07
	xor (hl)		;1c23	ae
	and 0aah		;1c24	e6 aa
	xor (hl)		;1c26	ae
	ld (hl),a		;1c27	77
	ret			;1c28	c9
	call CHECK_SYNTAX_2		;1c29	cd 89 28
	jr z,l1c41h		;1c2c	28 13
	res 0,(iy+002h)		;1c2e	fd cb 02 86  ; IY+$02 = TVFLAG
	call DO_ATTS		;1c32	cd 88 08
	ld hl,05c90h		;1c35	21 90 5c
	ld a,(hl)		;1c38	7e
	or 0f8h			;1c39	f6 f8
	ld (hl),a		;1c3b	77
	res 6,(iy+057h)		;1c3c	fd cb 57 b6  ; IY+$57 = PFLAG
	rst 18h			;1c40	df
l1c41h:
	call sub_238ch		;1c41	cd 8c 23
	jr SKIP_EXPR		;1c44	18 97
	jp l24d2h		;1c46	c3 d2 24
EXPR_STR_1:
	cp 00dh			;1c49	fe 0d
	jr z,EXPR_STR_2		;1c4b	28 04
	cp 03ah			;1c4d	fe 3a
	jr nz,EXPR_NUM		;1c4f	20 94
EXPR_STR_2:
	call CHECK_SYNTAX_2		;1c51	cd 89 28
	ret z			;1c54	c8
	rst 28h			;1c55	ef
	and b			;1c56	a0
	jr c,l1c22h		;1c57	38 c9
	rst 8			;1c59	cf
	ex af,af'		;1c5a	08
	pop bc			;1c5b	c1
	call CHECK_SYNTAX_2		;1c5c	cd 89 28
	jr z,l1c75h		;1c5f	28 14
	rst 28h			;1c61	ef
	ld (bc),a		;1c62	02
	jr c,$-19		;1c63	38 eb
	call sub_3904h		;1c65	cd 04 39
	jr nc,l1c75h		;1c68	30 0b
	ld a,(05cc6h)		;1c6a	3a c6 5c  ; VIDMOD
	bit 7,a			;1c6d	cb 7f
	jp nz,LOAD_EXEC		;1c6f	c2 ff 17
	jp l1b09h		;1c72	c3 09 1b
l1c75h:
	jp l1a45h		;1c75	c3 45 1a
	cp 0cdh			;1c78	fe cd
	jr nz,l1c85h		;1c7a	20 09
	rst 20h			;1c7c	e7
	call EXPR_NUM		;1c7d	cd e5 1b
	call 01b44h		;1c80	cd 44 1b
	jr $+8			;1c83	18 06
l1c85h:
	call 01b44h		;1c85	cd 44 1b
	rst 28h			;1c88	ef
	and c			;1c89	a1
	jr c,$-15		;1c8a	38 ef
	ret nz			;1c8c	c0
	ld (bc),a		;1c8d	02
	ld bc,001e0h		;1c8e	01 e0 01
	jr c,$-49		;1c91	38 cd
	cp l			;1c93	bd
	ld l,022h		;1c94	2e 22
	ld l,b			;1c96	68
	ld e,h			;1c97	5c
	dec hl			;1c98	2b
	ld a,(hl)		;1c99	7e
	set 7,(hl)		;1c9a	cb fe
	ld bc,LROS_CALL+2		;1c9c	01 06 00
	add hl,bc		;1c9f	09
	rlca			;1ca0	07
	jr c,l1ca9h		;1ca1	38 06
	ld c,00dh		;1ca3	0e 0d
	call MAKE_ROOM		;1ca5	cd bb 12
	inc hl			;1ca8	23
l1ca9h:
	push hl			;1ca9	e5
	rst 28h			;1caa	ef
	ld (bc),a		;1cab	02
	ld (bc),a		;1cac	02
	jr c,$-29		;1cad	38 e1
	ex de,hl		;1caf	eb
	ld c,00ah		;1cb0	0e 0a
	ldir			;1cb2	ed b0
	ld hl,(05c45h)		;1cb4	2a 45 5c  ; PPC
	ex de,hl		;1cb7	eb
	ld (hl),e		;1cb8	73
	inc hl			;1cb9	23
	ld (hl),d		;1cba	72
	ld d,(iy+00dh)		;1cbb	fd 56 0d  ; IY+$0D = SUBPPC
	inc d			;1cbe	14
	inc hl			;1cbf	23
	ld (hl),d		;1cc0	72
	call sub_1d84h		;1cc1	cd 84 1d
	ret nc			;1cc4	d0
	ld hl,(05c45h)		;1cc5	2a 45 5c  ; PPC
	ld (05c42h),hl		;1cc8	22 42 5c  ; NEWPPC
	ld a,(05c47h)		;1ccb	3a 47 5c  ; SUBPPC
	neg			;1cce	ed 44
	ld d,a			;1cd0	57
	ld hl,(05cbch)		;1cd1	2a bc 5c  ; SYSCON
	inc hl			;1cd4	23
	ld a,(hl)		;1cd5	7e
	cp 002h			;1cd6	fe 02
	jr nz,l1cf2h		;1cd8	20 18
	inc hl			;1cda	23
	inc hl			;1cdb	23
	inc hl			;1cdc	23
	ld a,(hl)		;1cdd	7e
	and 00fh		;1cde	e6 0f
	ld c,a			;1ce0	4f
	ld b,000h		;1ce1	06 00
	call 06499h		;1ce3	cd 99 64
	ld bc,(05c45h)		;1ce6	ed 4b 45 5c  ; PPC
	call LOAD_FIND		;1cea	cd cf 17
	ld h,b			;1ced	60
	ld l,c			;1cee	69
	dec hl			;1cef	2b
	jr l1cf5h		;1cf0	18 03
l1cf2h:
	ld hl,(05c5dh)		;1cf2	2a 5d 5c  ; CH_ADD
l1cf5h:
	ld e,0f3h		;1cf5	1e f3
l1cf7h:
	ld bc,(05c55h)		;1cf7	ed 4b 55 5c  ; NXTLIN
	call 01d28h		;1cfb	cd 28 1d
	ld (05c55h),bc		;1cfe	ed 43 55 5c  ; NXTLIN
	ld b,(iy+038h)		;1d02	fd 46 38
	jr c,l1d26h		;1d05	38 1f
	rst 20h			;1d07	e7
	or 020h			;1d08	f6 20
	cp b			;1d0a	b8
	jr z,l1d10h		;1d0b	28 03
	rst 20h			;1d0d	e7
	jr l1cf7h		;1d0e	18 e7
l1d10h:
	rst 20h			;1d10	e7
	ld a,001h		;1d11	3e 01
	sub d			;1d13	92
	ld (05c44h),a		;1d14	32 44 5c  ; NSPPC
	ld hl,05cc6h		;1d17	21 c6 5c  ; VIDMOD
	ld l,(hl)		;1d1a	6e
	bit 7,l			;1d1b	cb 7d
	jr z,l1d25h		;1d1d	28 06
	ld bc,0ff00h		;1d1f	01 00 ff
	call 06499h		;1d22	cd 99 64
l1d25h:
	ret			;1d25	c9
l1d26h:
	rst 8			;1d26	cf
	ld de,0fe7eh		;1d27	11 7e fe
	ld a,(l2027h+1)		;1d2a	3a 28 20
l1d2dh:
	inc hl			;1d2d	23
	ld a,(hl)		;1d2e	7e
	and 0c0h		;1d2f	e6 c0
	scf			;1d31	37
	ret nz			;1d32	c0
	ld a,e			;1d33	7b
	cp 0e4h			;1d34	fe e4
	jr nz,l1d3bh		;1d36	20 03
	ld (05cc7h),hl		;1d38	22 c7 5c
l1d3bh:
	ld b,(hl)		;1d3b	46
l1d3ch:
	inc hl			;1d3c	23
	ld c,(hl)		;1d3d	4e
	ld (05c42h),bc		;1d3e	ed 43 42 5c  ; NEWPPC
	inc hl			;1d42	23
	ld c,(hl)		;1d43	4e
	inc hl			;1d44	23
	ld b,(hl)		;1d45	46
	push hl			;1d46	e5
	add hl,bc		;1d47	09
	ld b,h			;1d48	44
	ld c,l			;1d49	4d
	pop hl			;1d4a	e1
	ld d,000h		;1d4b	16 00
	push bc			;1d4d	c5
	call FIND_STMT		;1d4e	cd f3 16
	pop bc			;1d51	c1
	ret nc			;1d52	d0
	jr l1d2dh		;1d53	18 d8
	bit 1,(iy+037h)		;1d55	fd cb 37 4e  ; IY+$37 = FLAGX+1
	jp nz,l1b91h		;1d59	c2 91 1b
	ld hl,(05c4dh)		;1d5c	2a 4d 5c  ; DEST
	bit 7,(hl)		;1d5f	cb 7e
	jr z,l1d82h		;1d61	28 1f
	inc hl			;1d63	23
	ld (05c68h),hl		;1d64	22 68 5c  ; MEM
	rst 28h			;1d67	ef
	ret po			;1d68	e0
	jp po,0c00fh		;1d69	e2 0f c0
	ld (bc),a		;1d6c	02
	jr c,l1d3ch		;1d6d	38 cd
	add a,h			;1d6f	84
	dec e			;1d70	1d
	ret c			;1d71	d8
	ld hl,(05c68h)		;1d72	2a 68 5c  ; MEM
	ld de,0000fh		;1d75	11 0f 00
	add hl,de		;1d78	19
	ld e,(hl)		;1d79	5e
	inc hl			;1d7a	23
	ld d,(hl)		;1d7b	56
	inc hl			;1d7c	23
	ld h,(hl)		;1d7d	66
	ex de,hl		;1d7e	eb
	jp l1efdh		;1d7f	c3 fd 1e
l1d82h:
	rst 8			;1d82	cf
	nop			;1d83	00
sub_1d84h:
	rst 28h			;1d84	ef
	pop hl			;1d85	e1
	ret po			;1d86	e0
	jp po,00036h		;1d87	e2 36 00
	ld (bc),a		;1d8a	02
	ld bc,03703h		;1d8b	01 03 37
	nop			;1d8e	00
	inc b			;1d8f	04
	jr c,$-87		;1d90	38 a7
	ret			;1d92	c9
	jr c,l1dcch		;1d93	38 37
	ret			;1d95	c9
l1d96h:
	rst 20h			;1d96	e7
	call sub_1b82h		;1d97	cd 82 1b
	call CHECK_SYNTAX_2		;1d9a	cd 89 28
	jp z,l1e78h		;1d9d	ca 78 1e
	rst 18h			;1da0	df
	ld (05c5fh),hl		;1da1	22 5f 5c  ; X_PTR
	ld hl,05cc6h		;1da4	21 c6 5c  ; VIDMOD
	ld l,(hl)		;1da7	6e
	bit 7,l			;1da8	cb 7d
	jp z,l1e52h		;1daa	ca 52 1e
	ld hl,(05cbch)		;1dad	2a bc 5c  ; SYSCON
	ld de,LROS_CALL		;1db0	11 04 00
	add hl,de		;1db3	19
	ld a,(hl)		;1db4	7e
	and 00fh		;1db5	e6 0f
	ld b,000h		;1db7	06 00
	ld c,a			;1db9	4f
	call 06499h		;1dba	cd 99 64
	ld hl,(05c57h)		;1dbd	2a 57 5c
	ld a,(hl)		;1dc0	7e
	cp 02ch			;1dc1	fe 2c
	jr z,l1dd8h		;1dc3	28 13
	ld e,0e4h		;1dc5	1e e4
	call 01d28h		;1dc7	cd 28 1d
	jr nc,l1dd5h		;1dca	30 09
l1dcch:
	ld bc,0ff00h		;1dcc	01 00 ff
	call 06499h		;1dcf	cd 99 64
	jp l1e62h		;1dd2	c3 62 1e
l1dd5h:
	ld (05c57h),hl		;1dd5	22 57 5c
l1dd8h:
	ld hl,(05cc7h)		;1dd8	2a c7 5c
	inc hl			;1ddb	23
	inc hl			;1ddc	23
	ld c,(hl)		;1ddd	4e
	inc hl			;1dde	23
	ld b,(hl)		;1ddf	46
	ld (05cc9h),bc		;1de0	ed 43 c9 5c
	ld bc,0ff00h		;1de4	01 00 ff
	call 06499h		;1de7	cd 99 64
	ld bc,(05cc9h)		;1dea	ed 4b c9 5c
	ld hl,(05c4fh)		;1dee	2a 4f 5c  ; CHANS
	push hl			;1df1	e5
	dec hl			;1df2	2b
	call MAKE_ROOM		;1df3	cd bb 12
	pop de			;1df6	d1
	ld hl,TOK_NOT		;1df7	21 ff 00
	push hl			;1dfa	e5
	ld hl,(05cc7h)		;1dfb	2a c7 5c
	inc hl			;1dfe	23
	inc hl			;1dff	23
	inc hl			;1e00	23
	inc hl			;1e01	23
	push hl			;1e02	e5
	push de			;1e03	d5
	ld bc,(05cc9h)		;1e04	ed 4b c9 5c
	push bc			;1e08	c5
	ld bc,LROS_BC		;1e09	01 01 00
	push bc			;1e0c	c5
	call 06722h		;1e0d	cd 22 67
	ld hl,(05cc7h)		;1e10	2a c7 5c
	ld de,(05cc9h)		;1e13	ed 5b c9 5c
	add hl,de		;1e17	19
	ld de,LROS_CALL		;1e18	11 04 00
	add hl,de		;1e1b	19
	ld bc,(05c57h)		;1e1c	ed 4b 57 5c
	and a			;1e20	a7
	sbc hl,bc		;1e21	ed 42
	ld b,h			;1e23	44
	ld c,l			;1e24	4d
	ld hl,(05c4fh)		;1e25	2a 4f 5c  ; CHANS
	and a			;1e28	a7
	sbc hl,bc		;1e29	ed 42
	push hl			;1e2b	e5
	inc hl			;1e2c	23
	ld (05c5dh),hl		;1e2d	22 5d 5c  ; CH_ADD
	call sub_1bb9h		;1e30	cd b9 1b
	pop de			;1e33	d1
	ld hl,(05c5dh)		;1e34	2a 5d 5c  ; CH_ADD
	and a			;1e37	a7
	sbc hl,de		;1e38	ed 52
	ld de,(05c57h)		;1e3a	ed 5b 57 5c
	add hl,de		;1e3e	19
	ld (05c57h),hl		;1e3f	22 57 5c
	ld hl,(05c4fh)		;1e42	2a 4f 5c  ; CHANS
	ld bc,(05cc9h)		;1e45	ed 4b c9 5c
	and a			;1e49	a7
	sbc hl,bc		;1e4a	ed 42
	call RECLAIM		;1e4c	cd 50 17
	jp l1e6eh		;1e4f	c3 6e 1e
l1e52h:
	ld hl,(05c57h)		;1e52	2a 57 5c
	ld a,(hl)		;1e55	7e
	cp 02ch			;1e56	fe 2c
	jp z,l1e64h		;1e58	ca 64 1e
	ld e,0e4h		;1e5b	1e e4
	call 01d28h		;1e5d	cd 28 1d
	jr nc,l1e64h		;1e60	30 02
l1e62h:
	rst 8			;1e62	cf
	dec c			;1e63	0d
l1e64h:
	call NC_HL		;1e64	cd 77 00
	call sub_1bb9h		;1e67	cd b9 1b
	rst 18h			;1e6a	df
	ld (05c57h),hl		;1e6b	22 57 5c
l1e6eh:
	ld hl,(05c5fh)		;1e6e	2a 5f 5c  ; X_PTR
	ld (iy+026h),000h	;1e71	fd 36 26 00  ; IY+$26 = FLAGX
	call TC_HL		;1e75	cd 78 00
l1e78h:
	rst 18h			;1e78	df
	cp 02ch			;1e79	fe 2c
	jp z,l1d96h		;1e7b	ca 96 1d
	call 01b44h		;1e7e	cd 44 1b
	ret			;1e81	c9
	call CHECK_SYNTAX_2		;1e82	cd 89 28
	jr nz,l1e92h		;1e85	20 0b
l1e87h:
	call EVAL_EXPR		;1e87	cd 54 28
	cp 02ch			;1e8a	fe 2c
	call nz,01b44h		;1e8c	c4 44 1b
	rst 20h			;1e8f	e7
	jr l1e87h		;1e90	18 f5
l1e92h:
	ld a,0e4h		;1e92	3e e4
l1e94h:
	ld b,a			;1e94	47
	cpdr			;1e95	ed b9
	ld de,TOK_RETURN		;1e97	11 00 02
	jp FIND_STMT		;1e9a	c3 f3 16
	call FP_TO_BC		;1e9d	cd 23 1f
	ld hl,(05cbch)		;1ea0	2a bc 5c  ; SYSCON
	inc hl			;1ea3	23
	ld a,(hl)		;1ea4	7e
	cp 002h			;1ea5	fe 02
	jr nz,l1ecah		;1ea7	20 21
	inc hl			;1ea9	23
	inc hl			;1eaa	23
	inc hl			;1eab	23
	ld a,(hl)		;1eac	7e
	and 00fh		;1ead	e6 0f
	push bc			;1eaf	c5
	ld c,a			;1eb0	4f
	ld b,000h		;1eb1	06 00
	call 06499h		;1eb3	cd 99 64
	pop bc			;1eb6	c1
	call LOAD_FIND		;1eb7	cd cf 17
	ld bc,0ff00h		;1eba	01 00 ff
	call 06499h		;1ebd	cd 99 64
	jr l1ec5h		;1ec0	18 03
	call FIND_LINE		;1ec2	cd d6 16
l1ec5h:
	dec hl			;1ec5	2b
	ld (05c57h),hl		;1ec6	22 57 5c
	ret			;1ec9	c9
l1ecah:
	ld h,b			;1eca	60
	ld l,c			;1ecb	69
	call FIND_LINE		;1ecc	cd d6 16
	dec hl			;1ecf	2b
	ld (05c57h),hl		;1ed0	22 57 5c
	ret			;1ed3	c9
	call FP_TO_BC		;1ed4	cd 23 1f
	ld a,b			;1ed7	78
	or c			;1ed8	b1
	jr nz,l1edfh		;1ed9	20 04
	ld bc,(05c78h)		;1edb	ed 4b 78 5c  ; FRAMES
l1edfh:
	ld (05c76h),bc		;1edf	ed 43 76 5c
	ret			;1ee3	c9
	ld hl,(05c6eh)		;1ee4	2a 6e 5c
	inc h			;1ee7	24
	jp z,l1b42h		;1ee8	ca 42 1b
	dec h			;1eeb	25
	ld d,(iy+036h)		;1eec	fd 56 36
	jr l1efdh		;1eef	18 0c
sub_1ef1h:
	call FP_TO_BC		;1ef1	cd 23 1f
	ld h,b			;1ef4	60
	ld l,c			;1ef5	69
	ld d,000h		;1ef6	16 00
	ld a,h			;1ef8	7c
	cp 0f0h			;1ef9	fe f0
	jr nc,ERR_OUTSCREEN		;1efb	30 2c
l1efdh:
	ld (05c42h),hl		;1efd	22 42 5c  ; NEWPPC
	ld (iy+00ah),d		;1f00	fd 72 0a  ; IY+$0A = NSPPC
	ret			;1f03	c9
	call sub_1f0fh		;1f04	cd 0f 1f
	out (c),a		;1f07	ed 79
	ret			;1f09	c9
	call sub_1f0fh		;1f0a	cd 0f 1f
	ld (bc),a		;1f0d	02
	ret			;1f0e	c9
sub_1f0fh:
	call 03193h		;1f0f	cd 93 31
	jr c,ERR_OUTSCREEN		;1f12	38 15
	jr z,l1f18h		;1f14	28 02
	neg			;1f16	ed 44
l1f18h:
	push af			;1f18	f5
	call FP_TO_BC		;1f19	cd 23 1f
	pop af			;1f1c	f1
	ret			;1f1d	c9
FP_TO_A:
	call 03193h		;1f1e	cd 93 31
	jr l1f26h		;1f21	18 03
FP_TO_BC:
	call EVAL_NUMERIC		;1f23	cd 60 31
l1f26h:
	jr c,ERR_OUTSCREEN		;1f26	38 01
	ret z			;1f28	c8
ERR_OUTSCREEN:
	rst 8			;1f29	cf
	ld a,(bc)		;1f2a	0a
	call sub_1ef1h		;1f2b	cd f1 1e
	ld bc,LROS_HEADER		;1f2e	01 00 00
	call l1ecah		;1f31	cd ca 1e
	jr l1f39h		;1f34	18 03
	call FP_TO_BC		;1f36	cd 23 1f
l1f39h:
	ld a,b			;1f39	78
	or c			;1f3a	b1
	jr nz,l1f41h		;1f3b	20 04
	ld bc,(05cb2h)		;1f3d	ed 4b b2 5c  ; RAMTOP
l1f41h:
	push bc			;1f41	c5
	ld de,(05c4bh)		;1f42	ed 5b 4b 5c  ; VARS
	ld hl,(05c59h)		;1f46	2a 59 5c  ; ELINE
	dec hl			;1f49	2b
	call RECLAIM_INIT		;1f4a	cd 4d 17
	call K_CLS		;1f4d	cd a6 08
	ld hl,05cc6h		;1f50	21 c6 5c  ; VIDMOD
	ld l,(hl)		;1f53	6e
	bit 7,l			;1f54	cb 7d
	jr z,l1f67h		;1f56	28 0f
	ld hl,(05cbch)		;1f58	2a bc 5c  ; SYSCON
	inc hl			;1f5b	23
	inc hl			;1f5c	23
	ld e,(hl)		;1f5d	5e
	inc hl			;1f5e	23
	ld d,(hl)		;1f5f	56
	ex de,hl		;1f60	eb
	dec hl			;1f61	2b
	ld (05c57h),hl		;1f62	22 57 5c
	jr l1f6eh		;1f65	18 07
l1f67h:
	ld hl,(05c53h)		;1f67	2a 53 5c  ; PROG
	dec hl			;1f6a	2b
	ld (05c57h),hl		;1f6b	22 57 5c
l1f6eh:
	ld hl,(05c65h)		;1f6e	2a 65 5c  ; STKEND
	ld de,00032h		;1f71	11 32 00
	add hl,de		;1f74	19
	pop de			;1f75	d1
	sbc hl,de		;1f76	ed 52
	jr nc,l1f82h		;1f78	30 08
	ld hl,(05cb4h)		;1f7a	2a b4 5c
	and a			;1f7d	a7
	sbc hl,de		;1f7e	ed 52
	jr nc,l1f84h		;1f80	30 02
l1f82h:
	rst 8			;1f82	cf
	dec d			;1f83	15
l1f84h:
	ex de,hl		;1f84	eb
	ld (05cb2h),hl		;1f85	22 b2 5c  ; RAMTOP
	pop de			;1f88	d1
	pop bc			;1f89	c1
	ld hl,(05cc0h)		;1f8a	2a c0 5c
	dec hl			;1f8d	2b
	ld (hl),03eh		;1f8e	36 3e
	dec hl			;1f90	2b
	ld sp,hl		;1f91	f9
	push bc			;1f92	c5
	ld (05c3dh),sp		;1f93	ed 73 3d 5c  ; ERRSP
	ex de,hl		;1f97	eb
	jp (hl)			;1f98	e9
	pop de			;1f99	d1
	ld h,(iy+00dh)		;1f9a	fd 66 0d  ; IY+$0D = SUBPPC
	inc h			;1f9d	24
	ex (sp),hl		;1f9e	e3
	inc sp			;1f9f	33
	ld bc,(05c45h)		;1fa0	ed 4b 45 5c  ; PPC
	push bc			;1fa4	c5
	push hl			;1fa5	e5
	ld (05c3dh),sp		;1fa6	ed 73 3d 5c  ; ERRSP
	push de			;1faa	d5
	call sub_1ef1h		;1fab	cd f1 1e
	ld hl,(05cc0h)		;1fae	2a c0 5c
	dec h			;1fb1	25
	ld de,WRCH		;1fb2	11 10 00
	add hl,de		;1fb5	19
	sbc hl,sp		;1fb6	ed 72
	ret c			;1fb8	d8
	jr l1fcfh		;1fb9	18 14
TEST_ROOM:
	ld hl,(05c65h)		;1fbb	2a 65 5c  ; STKEND
	add hl,bc		;1fbe	09
	jr c,l1fcfh		;1fbf	38 0e
	ex de,hl		;1fc1	eb
	ld hl,PHLAF		;1fc2	21 50 00
	add hl,de		;1fc5	19
	jr c,l1fcfh		;1fc6	38 07
	ld de,(05cb2h)		;1fc8	ed 5b b2 5c  ; RAMTOP
	sbc hl,de		;1fcc	ed 52
	ret c			;1fce	d8
l1fcfh:
	ld l,003h		;1fcf	2e 03
	jp LE3		;1fd1	c3 55 00
	pop bc			;1fd4	c1
	pop hl			;1fd5	e1
	pop de			;1fd6	d1
	ld a,d			;1fd7	7a
	cp 03eh			;1fd8	fe 3e
	jr z,l1fe7h		;1fda	28 0b
	dec sp			;1fdc	3b
	ex (sp),hl		;1fdd	e3
	ex de,hl		;1fde	eb
	ld (05c3dh),sp		;1fdf	ed 73 3d 5c  ; ERRSP
	push bc			;1fe3	c5
	jp l1efdh		;1fe4	c3 fd 1e
l1fe7h:
	push de			;1fe7	d5
	push hl			;1fe8	e5
	rst 8			;1fe9	cf
	ld b,0fdh		;1fea	06 fd
	rlc c			;1fec	cb 01
	xor (hl)		;1fee	ae
	call FP_TO_BC		;1fef	cd 23 1f
l1ff2h:
	halt			;1ff2	76
	dec bc			;1ff3	0b
	ld a,b			;1ff4	78
	or c			;1ff5	b1
	jr z,l2004h		;1ff6	28 0c
	ld a,b			;1ff8	78
	and c			;1ff9	a1
	inc a			;1ffa	3c
	jr nz,PAD_1FFE		;1ffb	20 01
	inc bc			;1ffd	03
PAD_1FFE:
	bit 5,(iy+001h)		;1ffe	fd cb 01 6e  ; IY+$01 = FLAGS
	jr z,l1ff2h		;2002	28 ee
l2004h:
	res 5,(iy+001h)		;2004	fd cb 01 ae  ; IY+$01 = FLAGS
	ret			;2008	c9
TAPE_SYNC:
	ld a,07fh		;2009	3e 7f
	in a,(0feh)		;200b	db fe
	rra			;200d	1f
	ret c			;200e	d8
	bit 6,(iy+07dh)		;200f	fd cb 7d 76  ; IY+$7D = ERRLN_FLAGS
	jr z,l2017h		;2013	28 02
	scf			;2015	37
	ret			;2016	c9
l2017h:
	ld a,0feh		;2017	3e fe
	in a,(0feh)		;2019	db fe
	rra			;201b	1f
	ret			;201c	c9
	call CHECK_SYNTAX_2		;201d	cd 89 28
	jr z,l2027h		;2020	28 05
	ld a,0ceh		;2022	3e ce
	jp l1e94h		;2024	c3 94 1e
l2027h:
	set 6,(iy+001h)		;2027	fd cb 01 f6  ; IY+$01 = FLAGS
	call sub_304bh		;202b	cd 4b 30
	jr nc,l2046h		;202e	30 16
	rst 20h			;2030	e7
	cp 024h			;2031	fe 24
	jr nz,l203ah		;2033	20 05
	res 6,(iy+001h)		;2035	fd cb 01 b6  ; IY+$01 = FLAGS
	rst 20h			;2039	e7
l203ah:
	cp 028h			;203a	fe 28
	jr nz,l207ah		;203c	20 3c
	rst 20h			;203e	e7
	cp 029h			;203f	fe 29
	jr z,l2063h		;2041	28 20
l2043h:
	call sub_304bh		;2043	cd 4b 30
l2046h:
	jp nc,NONSENSE_ERR		;2046	d2 ed 1b
	ex de,hl		;2049	eb
	rst 20h			;204a	e7
	cp 024h			;204b	fe 24
	jr nz,l2051h		;204d	20 02
	ex de,hl		;204f	eb
	rst 20h			;2050	e7
l2051h:
	ex de,hl		;2051	eb
	ld bc,LROS_CALL+2		;2052	01 06 00
	call MAKE_ROOM		;2055	cd bb 12
	inc hl			;2058	23
	inc hl			;2059	23
	ld (hl),00eh		;205a	36 0e
	cp 02ch			;205c	fe 2c
	jr nz,l2063h		;205e	20 03
	rst 20h			;2060	e7
	jr l2043h		;2061	18 e0
l2063h:
	cp 029h			;2063	fe 29
	jr nz,l207ah		;2065	20 13
	rst 20h			;2067	e7
	cp 03dh			;2068	fe 3d
	jr nz,l207ah		;206a	20 0e
	rst 20h			;206c	e7
	ld a,(05c3bh)		;206d	3a 3b 5c  ; FLAGS
	push af			;2070	f5
	call EVAL_EXPR		;2071	cd 54 28
	pop af			;2074	f1
	xor (iy+001h)		;2075	fd ae 01  ; IY+$01 = FLAGS
	and 040h		;2078	e6 40
l207ah:
	jp nz,NONSENSE_ERR		;207a	c2 ed 1b
	call 01b44h		;207d	cd 44 1b
	rst 18h			;2080	df
	cp 07fh			;2081	fe 7f
	jr z,l20aeh		;2083	28 29
	cp 0ech			;2085	fe ec
	jr z,l20bch		;2087	28 33
	cp 0e8h			;2089	fe e8
	jp nz,NONSENSE_ERR		;208b	c2 ed 1b
	rst 20h			;208e	e7
	call 01b44h		;208f	cd 44 1b
	bit 7,(iy+07dh)		;2092	fd cb 7d 7e  ; IY+$7D = ERRLN_FLAGS
	ret z			;2096	c8
	ld hl,(05cb8h)		;2097	2a b8 5c  ; NXTCONT
	ld (05c42h),hl		;209a	22 42 5c  ; NEWPPC
	ld a,(05cbah)		;209d	3a ba 5c  ; NXTCONT+2
	ld (05c44h),a		;20a0	32 44 5c  ; NSPPC
	res 6,(iy+07dh)		;20a3	fd cb 7d b6  ; IY+$7D = ERRLN_FLAGS
l20a7h:
	pop hl			;20a7	e1
	ld de,LROS_JP_LO		;20a8	11 07 00
	add hl,de		;20ab	19
	push hl			;20ac	e5
	ret			;20ad	c9
l20aeh:
	rst 20h			;20ae	e7
	call 01b44h		;20af	cd 44 1b
	res 7,(iy+07dh)		;20b2	fd cb 7d be  ; IY+$7D = ERRLN_FLAGS
	res 6,(iy+07dh)		;20b6	fd cb 7d b6  ; IY+$7D = ERRLN_FLAGS
	jr l20a7h		;20ba	18 eb
l20bch:
	rst 20h			;20bc	e7
	call EXPR_NUM		;20bd	cd e5 1b
	call 01b44h		;20c0	cd 44 1b
	call EVAL_NUMERIC		;20c3	cd 60 31
	ld a,b			;20c6	78
	and 03fh		;20c7	e6 3f
	or 080h			;20c9	f6 80
	ld b,a			;20cb	47
	ld (05cb6h),bc		;20cc	ed 43 b6 5c  ; ERRLN
	ret			;20d0	c9
	rst 18h			;20d1	df
	cp 02ch			;20d2	fe 2c
	jr nz,l20e0h		;20d4	20 0a
	call CHECK_SYNTAX_2		;20d6	cd 89 28
	jr z,l20e7h		;20d9	28 0c
	rst 28h			;20db	ef
	and c			;20dc	a1
	jr c,$+26		;20dd	38 18
	rlca			;20df	07
l20e0h:
	call EXPR_NUM		;20e0	cd e5 1b
	cp 02ch			;20e3	fe 2c
	jr nz,l211ch		;20e5	20 35
l20e7h:
	rst 20h			;20e7	e7
	cp 00dh			;20e8	fe 0d
	jr z,l20f5h		;20ea	28 09
	cp 03ah			;20ec	fe 3a
	jr z,l20f5h		;20ee	28 05
	call EXPR_NUM		;20f0	cd e5 1b
	jr l20feh		;20f3	18 09
l20f5h:
	ld bc,DEFAULT_BC		;20f5	01 0f 27
	call CHECK_SYNTAX_2		;20f8	cd 89 28
	call nz,STACK_NUM	;20fb	c4 e9 30
l20feh:
	call 01b44h		;20fe	cd 44 1b
	call GET_LINE_PAIR		;2101	cd 1e 21
	inc hl			;2104	23
	call FIND_LINE		;2105	cd d6 16
	push hl			;2108	e5
	call GET_LINE_PAIR		;2109	cd 1e 21
	call FIND_LINE		;210c	cd d6 16
	ex de,hl		;210f	eb
	pop hl			;2110	e1
	push hl			;2111	e5
	scf			;2112	37
	sbc hl,de		;2113	ed 52
	jr c,l211ch		;2115	38 05
	pop hl			;2117	e1
	call RECLAIM_INIT		;2118	cd 4d 17
	ret			;211b	c9
l211ch:
	rst 8			;211c	cf
	dec bc			;211d	0b
GET_LINE_PAIR:
	call EVAL_NUMERIC		;211e	cd 60 31
	ld a,b			;2121	78
	and 03fh		;2122	e6 3f
	ld h,a			;2124	67
	ld l,c			;2125	69
	ret			;2126	c9
l2127h:
	rst 20h			;2127	e7
	call SKIP_EXPR		;2128	cd dd 1b
	call CHECK_SYNTAX_2		;212b	cd 89 28
	jr z,l2146h		;212e	28 16
	call 03193h		;2130	cd 93 31
	push af			;2133	f5
	call 03193h		;2134	cd 93 31
	cp 011h			;2137	fe 11
	jp nc,NONSENSE_ERR		;2139	d2 ed 1b
	dec a			;213c	3d
	inc a			;213d	3c
	jp m,NONSENSE_ERR		;213e	fa ed 1b
	out (0f5h),a		;2141	d3 f5
	pop af			;2143	f1
	out (0f6h),a		;2144	d3 f6
l2146h:
	rst 18h			;2146	df
	cp 03bh			;2147	fe 3b
	jr z,l2127h		;2149	28 dc
	call 01b44h		;214b	cd 44 1b
	ret			;214e	c9
CHECK_SYNTAX:
	call CHECK_SYNTAX_2		;214f	cd 89 28
	pop hl			;2152	e1
	ret z			;2153	c8
	jp (hl)			;2154	e9
	ld a,003h		;2155	3e 03
	jr l2163h		;2157	18 0a
	ld a,(05cc6h)		;2159	3a c6 5c  ; VIDMOD
	res 0,a			;215c	cb 87
	ld (05cc6h),a		;215e	32 c6 5c  ; VIDMOD
	ld a,002h		;2161	3e 02
l2163h:
	call CHECK_SYNTAX_2		;2163	cd 89 28
	call nz,SELECT	;2166	c4 30 12
	call CHECK_SYNTAX_2		;2169	cd 89 28
	call nz,SET_TOKEN_MODE	;216c	c4 79 21
	call DO_ATTS		;216f	cd 88 08
	call PRINT_ITEMS		;2172	cd 7e 21
	call 01b44h		;2175	cd 44 1b
	ret			;2178	c9
SET_TOKEN_MODE:
	set 4,(iy+001h)		;2179	fd cb 01 e6  ; IY+$01 = FLAGS
	ret			;217d	c9
PRINT_ITEMS:
	rst 18h			;217e	df
	call CHECK_END		;217f	cd e4 21
	jr z,l2191h		;2182	28 0d
l2184h:
	call PRINT_SEMI		;2184	cd ed 21
	jr z,l2184h		;2187	28 fb
	call PRINT_AT_TAB		;2189	cd 9b 21
	call PRINT_SEMI		;218c	cd ed 21
	jr z,l2184h		;218f	28 f3
l2191h:
	cp 029h			;2191	fe 29
	ret z			;2193	c8
PRINT_END:
	call CHECK_SYNTAX		;2194	cd 4f 21
	ld a,00dh		;2197	3e 0d
	rst 10h			;2199	d7
	ret			;219a	c9
PRINT_AT_TAB:
	rst 18h			;219b	df
	cp 0ach			;219c	fe ac
	jr nz,l21adh		;219e	20 0d
	call SKIP_NEXT		;21a0	cd dc 1b
	call CHECK_SYNTAX		;21a3	cd 4f 21
	call GET_XY		;21a6	cd 60 26
	ld a,016h		;21a9	3e 16
	jr l21bdh		;21ab	18 10
l21adh:
	cp 0adh			;21ad	fe ad
	jr nz,l21c3h		;21af	20 12
	rst 20h			;21b1	e7
	call EXPR_NUM		;21b2	cd e5 1b
	call CHECK_SYNTAX		;21b5	cd 4f 21
	call FP_TO_BC		;21b8	cd 23 1f
	ld a,017h		;21bb	3e 17
l21bdh:
	rst 10h			;21bd	d7
	ld a,c			;21be	79
	rst 10h			;21bf	d7
	ld a,b			;21c0	78
	rst 10h			;21c1	d7
	ret			;21c2	c9
l21c3h:
	call COLOR_ITEM		;21c3	cd 9c 23
	ret nc			;21c6	d0
	call CHECK_HASH		;21c7	cd 0f 22
	ret nc			;21ca	d0
	call EVAL_EXPR		;21cb	cd 54 28
	call CHECK_SYNTAX		;21ce	cd 4f 21
	bit 6,(iy+001h)		;21d1	fd cb 01 76  ; IY+$01 = FLAGS
	call z,GET_STRING	;21d5	cc af 2f
	jp nz,l31a1h		;21d8	c2 a1 31
l21dbh:
	ld a,b			;21db	78
	or c			;21dc	b1
	dec bc			;21dd	0b
	ret z			;21de	c8
	ld a,(de)		;21df	1a
	inc de			;21e0	13
	rst 10h			;21e1	d7
	jr l21dbh		;21e2	18 f7
CHECK_END:
	cp 029h			;21e4	fe 29
	ret z			;21e6	c8
	cp 00dh			;21e7	fe 0d
	ret z			;21e9	c8
	cp 03ah			;21ea	fe 3a
	ret			;21ec	c9
PRINT_SEMI:
	rst 18h			;21ed	df
	cp 03bh			;21ee	fe 3b
	jr z,l2206h		;21f0	28 14
	cp 02ch			;21f2	fe 2c
	jr nz,l2200h		;21f4	20 0a
	call CHECK_SYNTAX_2		;21f6	cd 89 28
	jr z,l2206h		;21f9	28 0b
	ld a,006h		;21fb	3e 06
	rst 10h			;21fd	d7
	jr l2206h		;21fe	18 06
l2200h:
	cp 027h			;2200	fe 27
	ret nz			;2202	c0
	call PRINT_END		;2203	cd 94 21
l2206h:
	rst 20h			;2206	e7
	call CHECK_END		;2207	cd e4 21
	jr nz,l220dh		;220a	20 01
	pop bc			;220c	c1
l220dh:
	cp a			;220d	bf
	ret			;220e	c9
CHECK_HASH:
	cp 023h			;220f	fe 23
	scf			;2211	37
	ret nz			;2212	c0
	rst 20h			;2213	e7
	call EXPR_NUM		;2214	cd e5 1b
	and a			;2217	a7
	call CHECK_SYNTAX		;2218	cd 4f 21
	call FP_TO_A		;221b	cd 1e 1f
	ld (05ccbh),a		;221e	32 cb 5c  ; STRMNO
	cp 010h			;2221	fe 10
	jp nc,STREAM_ERR		;2223	d2 3d 12
	call SELECT		;2226	cd 30 12
	and a			;2229	a7
	ret			;222a	c9
	ld a,(05cc6h)		;222b	3a c6 5c  ; VIDMOD
	set 0,a			;222e	cb c7
	ld (05cc6h),a		;2230	32 c6 5c  ; VIDMOD
	call CHECK_SYNTAX_2		;2233	cd 89 28
	jr z,l2240h		;2236	28 08
	ld a,001h		;2238	3e 01
	call SELECT		;223a	cd 30 12
	call CLLHS		;223d	cd a9 08
l2240h:
	ld (iy+002h),001h	;2240	fd 36 02 01  ; IY+$02 = TVFLAG
	call sub_226bh		;2244	cd 6b 22
	call 01b44h		;2247	cd 44 1b
	ld bc,(05c88h)		;224a	ed 4b 88 5c  ; SPOSNCOL
	ld a,(05c6bh)		;224e	3a 6b 5c  ; DFSZ
	cp b			;2251	b8
	jr c,l2257h		;2252	38 03
	ld c,041h		;2254	0e 41
	ld b,a			;2256	47
l2257h:
	ld (05c88h),bc		;2257	ed 43 88 5c  ; SPOSNCOL
	ld a,019h		;225b	3e 19
	sub b			;225d	90
	ld (05c8ch),a		;225e	32 8c 5c  ; SCRCT
	res 0,(iy+002h)		;2261	fd cb 02 86  ; IY+$02 = TVFLAG
	call STTVC		;2265	cd 12 09
	jp CLLHS		;2268	c3 a9 08
sub_226bh:
	call PRINT_SEMI		;226b	cd ed 21
	jr z,sub_226bh		;226e	28 fb
	cp 028h			;2270	fe 28
	jr nz,l2282h		;2272	20 0e
	rst 20h			;2274	e7
	call PRINT_ITEMS		;2275	cd 7e 21
	rst 18h			;2278	df
	cp 029h			;2279	fe 29
	jp nz,NONSENSE_ERR		;227b	c2 ed 1b
	rst 20h			;227e	e7
	jp l235ch		;227f	c3 5c 23
l2282h:
	cp 0cah			;2282	fe ca
	jr nz,l2297h		;2284	20 11
	rst 20h			;2286	e7
	call sub_1b82h		;2287	cd 82 1b
	set 7,(iy+037h)		;228a	fd cb 37 fe  ; IY+$37 = FLAGX+1
	bit 6,(iy+001h)		;228e	fd cb 01 76  ; IY+$01 = FLAGS
	jp nz,NONSENSE_ERR		;2292	c2 ed 1b
	jr l22a4h		;2295	18 0d
l2297h:
	call sub_304bh		;2297	cd 4b 30
	jp nc,l2359h		;229a	d2 59 23
	call sub_1b82h		;229d	cd 82 1b
	res 7,(iy+037h)		;22a0	fd cb 37 be  ; IY+$37 = FLAGX+1
l22a4h:
	call CHECK_SYNTAX_2		;22a4	cd 89 28
	jp z,l235ch		;22a7	ca 5c 23
	call CLEAR_WKSP		;22aa	cd 4e 13
	ld hl,05c71h		;22ad	21 71 5c
	res 6,(hl)		;22b0	cb b6
	set 5,(hl)		;22b2	cb ee
	ld bc,LROS_BC		;22b4	01 01 00
	bit 7,(hl)		;22b7	cb 7e
	jr nz,l22c6h		;22b9	20 0b
	ld a,(05c3bh)		;22bb	3a 3b 5c  ; FLAGS
	and 040h		;22be	e6 40
	jr nz,l22c4h		;22c0	20 02
	ld c,003h		;22c2	0e 03
l22c4h:
	or (hl)			;22c4	b6
	ld (hl),a		;22c5	77
l22c6h:
	rst 30h			;22c6	f7
	ld (hl),00dh		;22c7	36 0d
	ld a,c			;22c9	79
	rrca			;22ca	0f
	rrca			;22cb	0f
	jr nc,l22d3h		;22cc	30 05
	ld a,022h		;22ce	3e 22
	ld (de),a		;22d0	12
	dec hl			;22d1	2b
	ld (hl),a		;22d2	77
l22d3h:
	ld (05c5bh),hl		;22d3	22 5b 5c  ; KCUR
	bit 7,(iy+037h)		;22d6	fd cb 37 7e  ; IY+$37 = FLAGX+1
	jr nz,l2308h		;22da	20 2c
	ld hl,(05c5dh)		;22dc	2a 5d 5c  ; CH_ADD
	push hl			;22df	e5
	ld hl,(05c3dh)		;22e0	2a 3d 5c  ; ERRSP
	push hl			;22e3	e5
l22e4h:
	ld hl,l22e4h		;22e4	21 e4 22
	push hl			;22e7	e5
	bit 4,(iy+030h)		;22e8	fd cb 30 66  ; IY+$30 = FLAGS2
	jr z,l22f2h		;22ec	28 04
	ld (05c3dh),sp		;22ee	ed 73 3d 5c  ; ERRSP
l22f2h:
	ld hl,(05c61h)		;22f2	2a 61 5c  ; WORKSP
	call REMOVE_NUMS		;22f5	cd 0d 0d
	ld (iy+000h),0ffh	;22f8	fd 36 00 ff  ; IY+$00 = ERR_NR
	call EDITOR		;22fc	cd 82 0a
	res 7,(iy+001h)		;22ff	fd cb 01 be  ; IY+$01 = FLAGS
	call sub_2363h		;2303	cd 63 23
	jr l230bh		;2306	18 03
l2308h:
	call EDITOR		;2308	cd 82 0a
l230bh:
	ld (iy+022h),000h	;230b	fd 36 22 00
	call 02380h		;230f	cd 80 23
	jr nz,l231eh		;2312	20 0a
	call CURSOR_CLEAR		;2314	cd 83 0c
	ld bc,(05c82h)		;2317	ed 4b 82 5c  ; ECHOE
	call STTVC		;231b	cd 12 09
l231eh:
	ld hl,05c71h		;231e	21 71 5c
	res 5,(hl)		;2321	cb ae
	bit 7,(hl)		;2323	cb 7e
	res 7,(hl)		;2325	cb be
	jr nz,l2345h		;2327	20 1c
	pop hl			;2329	e1
	pop hl			;232a	e1
	ld (05c3dh),hl		;232b	22 3d 5c  ; ERRSP
	pop hl			;232e	e1
	ld (05c5fh),hl		;232f	22 5f 5c  ; X_PTR
	set 7,(iy+001h)		;2332	fd cb 01 fe  ; IY+$01 = FLAGS
	call sub_2363h		;2336	cd 63 23
	ld hl,(05c5fh)		;2339	2a 5f 5c  ; X_PTR
	ld (iy+026h),000h	;233c	fd 36 26 00  ; IY+$26 = FLAGX
	ld (05c5dh),hl		;2340	22 5d 5c  ; CH_ADD
	jr l235ch		;2343	18 17
l2345h:
	ld hl,(05c63h)		;2345	2a 63 5c  ; STKBOT
	ld de,(05c61h)		;2348	ed 5b 61 5c  ; WORKSP
	scf			;234c	37
	sbc hl,de		;234d	ed 52
	ld b,h			;234f	44
	ld c,l			;2350	4d
	call sub_2e70h		;2351	cd 70 2e
	call l2ebdh		;2354	cd bd 2e
	jr l235ch		;2357	18 03
l2359h:
	call PRINT_AT_TAB		;2359	cd 9b 21
l235ch:
	call PRINT_SEMI		;235c	cd ed 21
	jp z,sub_226bh		;235f	ca 6b 22
	ret			;2362	c9
sub_2363h:
	ld hl,(05c61h)		;2363	2a 61 5c  ; WORKSP
	ld (05c5dh),hl		;2366	22 5d 5c  ; CH_ADD
	rst 18h			;2369	df
	cp 0e2h			;236a	fe e2
	jr z,l237ah		;236c	28 0c
	ld a,(05c71h)		;236e	3a 71 5c
	call sub_1bbch		;2371	cd bc 1b
	rst 18h			;2374	df
	cp 00dh			;2375	fe 0d
	ret z			;2377	c8
	rst 8			;2378	cf
	dec bc			;2379	0b
l237ah:
	call CHECK_SYNTAX_2		;237a	cd 89 28
	ret z			;237d	c8
	rst 8			;237e	cf
	djnz $+44		;237f	10 2a
	ld d,c			;2381	51
	ld e,h			;2382	5c
	inc hl			;2383	23
	inc hl			;2384	23
	inc hl			;2385	23
	inc hl			;2386	23
	ld a,(hl)		;2387	7e
	cp 04bh			;2388	fe 4b
	ret			;238a	c9
l238bh:
	rst 20h			;238b	e7
sub_238ch:
	call COLOR_ITEM		;238c	cd 9c 23
	ret c			;238f	d8
	rst 18h			;2390	df
	cp 02ch			;2391	fe 2c
	jr z,l238bh		;2393	28 f6
	cp 03bh			;2395	fe 3b
	jr z,l238bh		;2397	28 f2
	jp NONSENSE_ERR		;2399	c3 ed 1b
COLOR_ITEM:
	cp 0d9h			;239c	fe d9
	ret c			;239e	d8
	cp 0dfh			;239f	fe df
	ccf			;23a1	3f
	ret c			;23a2	d8
	push af			;23a3	f5
	rst 20h			;23a4	e7
	pop af			;23a5	f1
sub_23a6h:
	sub 0c9h		;23a6	d6 c9
	push af			;23a8	f5
	call EXPR_NUM		;23a9	cd e5 1b
	pop af			;23ac	f1
	and a			;23ad	a7
	call CHECK_SYNTAX		;23ae	cd 4f 21
	push af			;23b1	f5
	call FP_TO_A		;23b2	cd 1e 1f
	ld d,a			;23b5	57
	pop af			;23b6	f1
	rst 10h			;23b7	d7
	ld a,d			;23b8	7a
	rst 10h			;23b9	d7
	ret			;23ba	c9
l23bbh:
	sub 011h		;23bb	d6 11
	adc a,000h		;23bd	ce 00
	jr z,l23deh		;23bf	28 1d
	sub 002h		;23c1	d6 02
	adc a,000h		;23c3	ce 00
	ret z			;23c5	c8
	nop			;23c6	00
	cp 001h			;23c7	fe 01
	ld a,d			;23c9	7a
	ld b,001h		;23ca	06 01
	jr nz,l23d2h		;23cc	20 04
	rlca			;23ce	07
	rlca			;23cf	07
	ld b,004h		;23d0	06 04
l23d2h:
	ld c,a			;23d2	4f
	ld a,d			;23d3	7a
	cp 002h			;23d4	fe 02
	jr nc,l23eeh		;23d6	30 16
	ld a,c			;23d8	79
	ld hl,05c91h		;23d9	21 91 5c  ; PFLAG
	jr l2416h		;23dc	18 38
l23deh:
	ld a,d			;23de	7a
	ld b,038h		;23df	06 38
	jr c,l23e8h		;23e1	38 05
	cpl			;23e3	2f
	and 007h		;23e4	e6 07
	ld b,038h		;23e6	06 38
l23e8h:
	ld c,a			;23e8	4f
	ld a,d			;23e9	7a
	cp 008h			;23ea	fe 08
	jr c,l23f0h		;23ec	38 02
l23eeh:
	rst 8			;23ee	cf
	inc de			;23ef	13
l23f0h:

;================================================================
;*** ZEBRA MODIFICATION: PAPER Color via DECR Port ($23F0-$2401) ***
; Attribute-based color bypassed entirely. Paper color written
; directly to DECR register (port $FF) bits 5-3:
;   LD A,C / RLCA x3 (shift to bits 5-3)
;   LD C,$06 / ADD A,C (add 64-col mode enable bits)
;   OUT ($FF),A / RET
;   $23FA-$2401: NOP padding.
;================================================================
	ld a,c			;23f0	79
	rlca			;23f1	07
	rlca			;23f2	07
	rlca			;23f3	07
	ld c,006h		;23f4	0e 06
	add a,c			;23f6	81
	out (0ffh),a		;23f7	d3 ff
	ret			;23f9	c9
	nop			;23fa	00
	nop			;23fb	00
	nop			;23fc	00
	nop			;23fd	00
	nop			;23fe	00
	nop			;23ff	00
	nop			;2400	00
	nop			;2401	00
	ld a,c			;2402	79
	call l2416h		;2403	cd 16 24
	ld a,007h		;2406	3e 07
	cp d			;2408	ba
	sbc a,a			;2409	9f
	call l2416h		;240a	cd 16 24
	rlca			;240d	07
	rlca			;240e	07
	and 050h		;240f	e6 50
	ld b,a			;2411	47
	ld a,008h		;2412	3e 08
	cp d			;2414	ba
	sbc a,a			;2415	9f
l2416h:
	xor (hl)		;2416	ae
	and b			;2417	a0
	xor (hl)		;2418	ae
	ld (hl),a		;2419	77
	inc hl			;241a	23
	ld a,b			;241b	78
	ret			;241c	c9
	sbc a,a			;241d	9f
	ld a,d			;241e	7a
	rrca			;241f	0f
	ld b,080h		;2420	06 80
	jr nz,l2427h		;2422	20 03
	rrca			;2424	0f
	ld b,040h		;2425	06 40
l2427h:
	ld c,a			;2427	4f
	ld a,d			;2428	7a
	cp 008h			;2429	fe 08
	jr z,l2431h		;242b	28 04
	cp 002h			;242d	fe 02
	jr nc,l23eeh		;242f	30 bd
l2431h:
	ld a,c			;2431	79
	ld hl,05c8fh		;2432	21 8f 5c  ; ATTRT
	call l2416h		;2435	cd 16 24
	ld a,c			;2438	79
	rrca			;2439	0f
	rrca			;243a	0f
	rrca			;243b	0f
	jr l2416h		;243c	18 d8
	call FP_TO_A		;243e	cd 1e 1f
	cp 008h			;2441	fe 08
	jr nc,l23eeh		;2443	30 a9
	out (0feh),a		;2445	d3 fe
	rlca			;2447	07
	rlca			;2448	07
	rlca			;2449	07
	bit 5,a			;244a	cb 6f
	jr nz,l2450h		;244c	20 02
	xor 007h		;244e	ee 07
l2450h:
	ld (05c48h),a		;2450	32 48 5c  ; BORDCR
	ret			;2453	c9
	rst 18h			;2454	df
	cp 02ah			;2455	fe 2a
	jr nz,l247fh		;2457	20 26
	call NEXTCH_RST		;2459	cd 20 00
	call 01b44h		;245c	cd 44 1b
	ret			;245f	c9
	ld a,010h		;2460	3e 10
	ld hl,05c16h		;2462	21 16 5c  ; STRMS+6
l2465h:
	call CLEAR_STREAM		;2465	cd a8 13
	inc hl			;2468	23
	inc hl			;2469	23
	dec a			;246a	3d
	jr nz,l2465h		;246b	20 f8
	ld hl,009f4h		;246d	21 f4 09
	push hl			;2470	e5
	ld b,0feh		;2471	06 fe
l2473h:
	ld c,088h		;2473	0e 88
	push bc			;2475	c5
	ld bc,LROS_HEADER		;2476	01 00 00
	push bc			;2479	c5
	push bc			;247a	c5
	call 065d0h		;247b	cd d0 65
	ret			;247e	c9
l247fh:
	cp 023h			;247f	fe 23
	jr z,l2498h		;2481	28 15
	call 01b44h		;2483	cd 44 1b
	ret			;2486	c9
	ld hl,KEY_MODE		;2487	21 4c 0c
	push hl			;248a	e5
	ld bc,0fefeh		;248b	01 fe fe
	push bc			;248e	c5
	ld bc,LROS_HEADER		;248f	01 00 00
	push bc			;2492	c5
	push bc			;2493	c5
	call 065d0h		;2494	cd d0 65
	ret			;2497	c9
l2498h:
	rst 20h			;2498	e7
	call EXPR_NUM		;2499	cd e5 1b
	call 01b44h		;249c	cd 44 1b
	call FP_TO_A		;249f	cd 1e 1f
	cp 011h			;24a2	fe 11
	jr nc,l24b7h		;24a4	30 11
	and a			;24a6	a7
	jp m,l24b7h		;24a7	fa b7 24
	add a,a			;24aa	87
	add a,016h		;24ab	c6 16
	ld l,a			;24ad	6f
	ld h,05ch		;24ae	26 5c
	ld e,(hl)		;24b0	5e
	inc hl			;24b1	23
	ld d,(hl)		;24b2	56
	ld a,d			;24b3	7a
	or e			;24b4	b3
	jr nz,l24b9h		;24b5	20 02
l24b7h:
	rst 8			;24b7	cf
	rla			;24b8	17
l24b9h:
	ld a,d			;24b9	7a
	cp 080h			;24ba	fe 80
	ret c			;24bc	d8
	jp l2567h		;24bd	c3 67 25
	sub 080h		;24c0	d6 80
	ld d,a			;24c2	57
	ld de,(05cbch)		;24c3	ed 5b bc 5c  ; SYSCON
	add hl,de		;24c7	19
	inc hl			;24c8	23
	ld b,(hl)		;24c9	46
	ld d,000h		;24ca	16 00
	ld e,012h		;24cc	1e 12
	add hl,de		;24ce	19
	push hl			;24cf	e5
	jr l2473h		;24d0	18 a1
l24d2h:
	rst 18h			;24d2	df
	cp 02ah			;24d3	fe 2a
	jp nz,l2547h		;24d5	c2 47 25
	rst 20h			;24d8	e7
	call sub_1befh		;24d9	cd ef 1b
	cp 02ch			;24dc	fe 2c
	jp nz,NONSENSE_ERR		;24de	c2 ed 1b
	call CHECK_SYNTAX_2		;24e1	cd 89 28
	jr nz,l24ech		;24e4	20 06
	call EXPR_PAIR		;24e6	cd 69 25
	call 01b44h		;24e9	cd 44 1b
l24ech:
	jr l2567h		;24ec	18 79
	call GET_STRING		;24ee	cd af 2f
	dec bc			;24f1	0b
	ld a,b			;24f2	78
	or c			;24f3	b1
	jr nz,l2567h		;24f4	20 71
	ld a,(de)		;24f6	1a
	and 0dfh		;24f7	e6 df
	ld c,a			;24f9	4f
	call FIND_SYSCON		;24fa	cd 74 13
	jp nc,l2567h		;24fd	d2 67 25
	push hl			;2500	e5
	ld de,WRCH_ALT		;2501	11 14 00
	add hl,de		;2504	19
	ld a,(hl)		;2505	7e
	bit 1,a			;2506	cb 4f
	jp z,l2567h		;2508	ca 67 25
	pop hl			;250b	e1
	ex de,hl		;250c	eb
	call OPEN_DEV		;250d	cd b9 25
	ex de,hl		;2510	eb
	ld a,(05c74h)		;2511	3a 74 5c
	and a			;2514	a7
	cp 000h			;2515	fe 00
	jr c,l253fh		;2517	38 26
	jr z,l2543h		;2519	28 28
	add a,0d4h		;251b	c6 d4
	ld c,a			;251d	4f
l251eh:
	push bc			;251e	c5
	ld d,(hl)		;251f	56
	ld e,088h		;2520	1e 88
	ld bc,0000ch		;2522	01 0c 00
	add hl,bc		;2525	09
	ld c,(hl)		;2526	4e
	inc hl			;2527	23
	ld b,(hl)		;2528	46
	push bc			;2529	c5
	push de			;252a	d5
	ld hl,(05c65h)		;252b	2a 65 5c  ; STKEND
	dec hl			;252e	2b
	ld c,(hl)		;252f	4e
	inc c			;2530	0c
	ld (05c65h),hl		;2531	22 65 5c  ; STKEND
	ld b,000h		;2534	06 00
	push bc			;2536	c5
	ld bc,LROS_HEADER		;2537	01 00 00
	push bc			;253a	c5
	call 065d0h		;253b	cd d0 65
	ret			;253e	c9
l253fh:
	ld c,0f8h		;253f	0e f8
	jr l251eh		;2541	18 db
l2543h:
	ld c,0efh		;2543	0e ef
	jr l251eh		;2545	18 d7
l2547h:
	pop af			;2547	f1
	ld bc,l01abh		;2548	01 ab 01
	push bc			;254b	c5
	ld bc,0fefeh		;254c	01 fe fe
	push bc			;254f	c5
	ld bc,LROS_HEADER		;2550	01 00 00
	push bc			;2553	c5
	push bc			;2554	c5
	ld a,(05cc2h)		;2555	3a c2 5c
	and a			;2558	a7
	jr nz,l2562h		;2559	20 07
	call 065d0h		;255b	cd d0 65
l255eh:
	call 01b44h		;255e	cd 44 1b
	ret			;2561	c9
l2562h:
	call 0fd90h		;2562	cd 90 fd
	jr l255eh		;2565	18 f7
l2567h:
	rst 8			;2567	cf
	ld (de),a		;2568	12
EXPR_PAIR:
	ld a,(05cc6h)		;2569	3a c6 5c  ; VIDMOD
	res 1,a			;256c	cb 8f
	ld (05cc6h),a		;256e	32 c6 5c  ; VIDMOD
	push bc			;2571	c5
	rst 18h			;2572	df
l2573h:
	cp 022h			;2573	fe 22
	jr z,l2582h		;2575	28 0b
	cp 03ah			;2577	fe 3a
	jr z,l2582h		;2579	28 07
	cp 00dh			;257b	fe 0d
	jr z,l2582h		;257d	28 03
	rst 20h			;257f	e7
	jr l2573h		;2580	18 f1
l2582h:
	cp 03ah			;2582	fe 3a
	jr nz,l258dh		;2584	20 07
	ld a,(05cc6h)		;2586	3a c6 5c  ; VIDMOD
	bit 1,a			;2589	cb 4f
	jr nz,l25b6h		;258b	20 29
l258dh:
	push hl			;258d	e5
	ld b,005h		;258e	06 05
l2590h:
	dec hl			;2590	2b
	ld a,(hl)		;2591	7e
	cp 00eh			;2592	fe 0e
	jr z,l25b5h		;2594	28 1f
	djnz l2590h		;2596	10 f8
	pop hl			;2598	e1
	rst 18h			;2599	df
	cp 022h			;259a	fe 22
	jr nz,l25b3h		;259c	20 15
	ld a,(05cc6h)		;259e	3a c6 5c  ; VIDMOD
	bit 1,a			;25a1	cb 4f
	jr nz,l25ach		;25a3	20 07
	set 1,a			;25a5	cb cf
	ld (05cc6h),a		;25a7	32 c6 5c  ; VIDMOD
	jr l25b6h		;25aa	18 0a
l25ach:
	res 1,a			;25ac	cb 8f
	ld (05cc6h),a		;25ae	32 c6 5c  ; VIDMOD
	jr l25b6h		;25b1	18 03
l25b3h:
	pop bc			;25b3	c1
	ret			;25b4	c9
l25b5h:
	pop hl			;25b5	e1
l25b6h:
	rst 20h			;25b6	e7
	jr l2573h		;25b7	18 ba
OPEN_DEV:
	ld bc,0fefeh		;25b9	01 fe fe
	call 06499h		;25bc	cd 99 64
	call 00f09h		;25bf	cd 09 0f
	ld bc,0ff00h		;25c2	01 00 ff
	call 06499h		;25c5	cd 99 64
	ld b,0cfh		;25c8	06 cf
	jr l25d6h		;25ca	18 0a
	ld b,0d0h		;25cc	06 d0
	jr l25d6h		;25ce	18 06
	ld b,0d1h		;25d0	06 d1
	jr l25d6h		;25d2	18 02
	ld b,0d2h		;25d4	06 d2
l25d6h:
	call CHECK_SYNTAX_2		;25d6	cd 89 28
	jr nz,l25e1h		;25d9	20 06
	call EXPR_PAIR		;25db	cd 69 25
	call 01b44h		;25de	cd 44 1b
l25e1h:
	jp l2567h		;25e1	c3 67 25
	ld bc,0000ch		;25e4	01 0c 00
	add hl,bc		;25e7	09
	ld c,(hl)		;25e8	4e
	inc hl			;25e9	23
	ld b,(hl)		;25ea	46
	push bc			;25eb	c5
	push de			;25ec	d5
	ld hl,(05c65h)		;25ed	2a 65 5c  ; STKEND
	dec hl			;25f0	2b
	ld c,(hl)		;25f1	4e
	inc c			;25f2	0c
	ld (05c65h),hl		;25f3	22 65 5c  ; STKEND
	ld b,000h		;25f6	06 00
	push bc			;25f8	c5
	ld bc,LROS_HEADER		;25f9	01 00 00
	push bc			;25fc	c5
	call 065d0h		;25fd	cd d0 65
	ret			;2600	c9
	rst 8			;2601	cf
	ld (de),a		;2602	12
PIXEL_ADDR:
	ld a,0afh		;2603	3e af
	sub b			;2605	90
	jp c,l2852h		;2606	da 52 28
	ld b,a			;2609	47
	and a			;260a	a7
	rra			;260b	1f
	scf			;260c	37
	rra			;260d	1f
	and a			;260e	a7
	rra			;260f	1f
	xor b			;2610	a8
	and 0f8h		;2611	e6 f8
	xor b			;2613	a8
	ld h,a			;2614	67
	ld a,c			;2615	79
	rlca			;2616	07
	rlca			;2617	07
	rlca			;2618	07
	xor b			;2619	a8
	and 0c7h		;261a	e6 c7
	xor b			;261c	a8
	rlca			;261d	07
	rlca			;261e	07
	ld l,a			;261f	6f
	ld a,c			;2620	79
	and 007h		;2621	e6 07
	ret			;2623	c9
sub_2624h:
	call GET_XY		;2624	cd 60 26
	call PIXEL_ADDR		;2627	cd 03 26
	cp 004h			;262a	fe 04
	jr c,PLOT64_MASK		;262c	38 02
	set 5,h			;262e	cb ec
PLOT64_MASK:
	and 003h		;2630	e6 03
	jr POINT_64COL		;2632	18 15
	nop			;2634	00
PLOT_ENTRY:
	call GET_XY		;2635	cd 60 26
	call PLOT_SUB		;2638	cd 3e 26
	jp DO_ATTS		;263b	c3 88 08
PLOT_SUB:
	ld (05c7dh),bc		;263e	ed 43 7d 5c  ; XCOORD
	call PIXEL_ADDR		;2642	cd 03 26

;================================================================
;*** ZEBRA MODIFICATION: PLOT Redirect ($2645-$265F) ***
; Standard PLOT replaced with call to 64-col pixel handler:
;   CALL $0711 / RET
; Followed by POINT function adaptation for 64-col mode.
;================================================================
	call PIX64_HANDLER		;2645	cd 11 07
	ret			;2648	c9
POINT_64COL:
	ld b,a			;2649	47
	inc b			;264a	04
	ld a,(hl)		;264b	7e
POINT_ROTATE:
	rlca			;264c	07
	rlca			;264d	07
	djnz POINT_ROTATE		;264e	10 fc
	and 003h		;2650	e6 03
	jp l30e6h		;2652	c3 e6 30
	nop			;2655	00
	nop			;2656	00
	nop			;2657	00
	nop			;2658	00
	nop			;2659	00
	nop			;265a	00
	nop			;265b	00
	nop			;265c	00
	nop			;265d	00
	nop			;265e	00
	nop			;265f	00
GET_XY:
	call GET_COORD		;2660	cd 6d 26
	ld b,a			;2663	47
	push bc			;2664	c5
	call GET_COORD		;2665	cd 6d 26
	ld e,c			;2668	59
	pop bc			;2669	c1
	ld d,c			;266a	51
GET_XY_RET:
	ld c,a			;266b	4f
	ret			;266c	c9
GET_COORD:
	call 03193h		;266d	cd 93 31
	jp c,l2852h		;2670	da 52 28
	ld c,001h		;2673	0e 01
	ret z			;2675	c8
	ld c,0ffh		;2676	0e ff
	ret			;2678	c9
	rst 18h			;2679	df
	cp 02ch			;267a	fe 2c
	jp nz,NONSENSE_ERR		;267c	c2 ed 1b
	rst 20h			;267f	e7
	call EXPR_NUM		;2680	cd e5 1b
	call 01b44h		;2683	cd 44 1b
	rst 28h			;2686	ef
	ld hl,(CALC_REF3)		;2687	2a 3d 38
	ld a,(hl)		;268a	7e
	cp 081h			;268b	fe 81
	jr nc,l2694h		;268d	30 05
	rst 28h			;268f	ef
	ld (bc),a		;2690	02
	jr c,l26abh		;2691	38 18
	and c			;2693	a1
l2694h:
	rst 28h			;2694	ef
	and e			;2695	a3
	jr c,l26ceh		;2696	38 36
	add a,e			;2698	83
	rst 28h			;2699	ef
	push bc			;269a	c5
	ld (bc),a		;269b	02
	jr c,GET_XY_RET		;269c	38 cd
	sub 027h		;269e	d6 27
	push bc			;26a0	c5
	rst 28h			;26a1	ef
	ld sp,TONH_1		;26a2	31 e1 04
	jr c,l2725h		;26a5	38 7e
	cp 080h			;26a7	fe 80
	jr nc,l26b3h		;26a9	30 08
l26abh:
	rst 28h			;26ab	ef
	ld (bc),a		;26ac	02
	ld (bc),a		;26ad	02
	jr c,$-61		;26ae	38 c1
	jp PLOT_ENTRY		;26b0	c3 35 26
l26b3h:
	rst 28h			;26b3	ef
	jp nz,0c001h		;26b4	c2 01 c0
	ld (bc),a		;26b7	02
	inc bc			;26b8	03
	ld bc,ERR_STOP		;26b9	01 e0 0f
	ret nz			;26bc	c0
l26bdh:
	ld bc,0e031h		;26bd	01 31 e0
	ld bc,0e031h		;26c0	01 31 e0
	and b			;26c3	a0
	pop bc			;26c4	c1
l26c5h:
	ld (bc),a		;26c5	02
	jr c,l26c5h		;26c6	38 fd
	inc (hl)		;26c8	34
	ld h,d			;26c9	62
	call FP_TO_A		;26ca	cd 1e 1f
	ld l,a			;26cd	6f
l26ceh:
	push hl			;26ce	e5
	call FP_TO_A		;26cf	cd 1e 1f
	pop hl			;26d2	e1
	ld h,a			;26d3	67
	ld (05c7dh),hl		;26d4	22 7d 5c  ; XCOORD
	pop bc			;26d7	c1
	jp l2779h		;26d8	c3 79 27
l26dbh:
	rst 18h			;26db	df
	cp 02ch			;26dc	fe 2c
	jr z,l26e6h		;26de	28 06
	call 01b44h		;26e0	cd 44 1b
	jp 027d0h		;26e3	c3 d0 27
l26e6h:
	rst 20h			;26e6	e7
	call EXPR_NUM		;26e7	cd e5 1b
	call 01b44h		;26ea	cd 44 1b
	rst 28h			;26ed	ef
	push bc			;26ee	c5
	and d			;26ef	a2
	inc b			;26f0	04
	rra			;26f1	1f
	ld sp,l3030h		;26f2	31 30 30
	nop			;26f5	00
	ld b,002h		;26f6	06 02
	jr c,l26bdh		;26f8	38 c3
	ret nc			;26fa	d0
l26fbh:
	daa			;26fb	27
	ret nz			;26fc	c0
	ld (bc),a		;26fd	02
	pop bc			;26fe	c1
	ld (bc),a		;26ff	02
	ld sp,0e12ah		;2700	31 2a e1
	ld bc,l2ae1h		;2703	01 e1 2a
	rrca			;2706	0f
	ret po			;2707	e0
	dec b			;2708	05
	ld hl,(001e0h)		;2709	2a e0 01
	dec a			;270c	3d
	jr c,l278dh		;270d	38 7e
DEFAULT_BC:
	cp 081h			;270f	fe 81
	jr nc,l271ah		;2711	30 07
	rst 28h			;2713	ef
	ld (bc),a		;2714	02
	ld (bc),a		;2715	02
	jr c,l26dbh		;2716	38 c3
	ret nc			;2718	d0
	daa			;2719	27
l271ah:
	call sub_27d6h		;271a	cd d6 27
	push bc			;271d	c5
	rst 28h			;271e	ef
	ld (bc),a		;271f	02
	pop hl			;2720	e1
	ld bc,0c105h		;2721	01 05 c1
	ld (bc),a		;2724	02
l2725h:
	ld bc,0e131h		;2725	01 31 e1
	inc b			;2728	04
	jp nz,TOK_BIN		;2729	c2 02 01
	ld sp,TONH_1		;272c	31 e1 04
	jp po,0e0e5h		;272f	e2 e5 e0
	inc bc			;2732	03
	and d			;2733	a2
	inc b			;2734	04
	ld sp,0c51fh		;2735	31 1f c5
	ld (bc),a		;2738	02
	jr nz,l26fbh		;2739	20 c0
	ld (bc),a		;273b	02
	jp nz,0c102h		;273c	c2 02 c1
	push hl			;273f	e5
	inc b			;2740	04
	ret po			;2741	e0
	jp po,ERR_DISPLAY		;2742	e2 04 0f
	pop hl			;2745	e1
	ld bc,K_SCAN_3		;2746	01 c1 02
	ret po			;2749	e0
	inc b			;274a	04
	jp po,TONH_4		;274b	e2 e5 04
	inc bc			;274e	03
	jp nz,0e12ah		;274f	c2 2a e1
	ld hl,(EKEYS_2)		;2752	2a 0f 02
	jr c,$+28		;2755	38 1a
	cp 081h			;2757	fe 81
	pop bc			;2759	c1
	jp c,027d0h		;275a	da d0 27
	push bc			;275d	c5
	rst 28h			;275e	ef
	ld bc,l3a38h		;275f	01 38 3a
	ld a,l			;2762	7d
	ld e,h			;2763	5c
	call l30e6h		;2764	cd e6 30
	rst 28h			;2767	ef
	ret nz			;2768	c0
	rrca			;2769	0f
	ld bc,l3a38h		;276a	01 38 3a
	ld a,(hl)		;276d	7e
	ld e,h			;276e	5c
	call l30e6h		;276f	cd e6 30
	rst 28h			;2772	ef
	push bc			;2773	c5
	rrca			;2774	0f
	ret po			;2775	e0
	push hl			;2776	e5
	jr c,$-61		;2777	38 c1
l2779h:
	dec b			;2779	05
	jr z,l27b8h		;277a	28 3c
	jr l2792h		;277c	18 14
l277eh:
	rst 28h			;277e	ef
	pop hl			;277f	e1
l2780h:
	ld sp,TONH_2		;2780	31 e3 04
	jp po,TONH_3		;2783	e2 e4 04
	inc bc			;2786	03
	pop bc			;2787	c1
	ld (bc),a		;2788	02
	call po,0e204h		;2789	e4 04 e2
	ex (sp),hl		;278c	e3
l278dh:
	inc b			;278d	04
	rrca			;278e	0f
	jp nz,l3802h		;278f	c2 02 38
l2792h:
	push bc			;2792	c5
	rst 28h			;2793	ef
	ret nz			;2794	c0
	ld (bc),a		;2795	02
	pop hl			;2796	e1
	rrca			;2797	0f
	ld sp,l3a38h		;2798	31 38 3a
	ld a,l			;279b	7d
	ld e,h			;279c	5c
	call l30e6h		;279d	cd e6 30
	rst 28h			;27a0	ef
	inc bc			;27a1	03
	ret po			;27a2	e0
	jp po,0c00fh		;27a3	e2 0f c0
	ld bc,l38e0h		;27a6	01 e0 38
	ld a,(05c7eh)		;27a9	3a 7e 5c  ; YCOORD
	call l30e6h		;27ac	cd e6 30
	rst 28h			;27af	ef
	inc bc			;27b0	03
l27b1h:
	jr c,l2780h		;27b1	38 cd
	djnz l27ddh		;27b3	10 28
	pop bc			;27b5	c1
	djnz l277eh		;27b6	10 c6
l27b8h:
	rst 28h			;27b8	ef
	ld (bc),a		;27b9	02
	ld (bc),a		;27ba	02
	ld bc,l3a38h		;27bb	01 38 3a
	ld a,l			;27be	7d
	ld e,h			;27bf	5c
	call l30e6h		;27c0	cd e6 30
	rst 28h			;27c3	ef
	inc bc			;27c4	03
	ld bc,l3a38h		;27c5	01 38 3a
	ld a,(hl)		;27c8	7e
	ld e,h			;27c9	5c
	call l30e6h		;27ca	cd e6 30
	rst 28h			;27cd	ef
	inc bc			;27ce	03
	jr c,$-49		;27cf	38 cd
	djnz $+42		;27d1	10 28
	jp DO_ATTS		;27d3	c3 88 08
sub_27d6h:
	rst 28h			;27d6	ef
	ld sp,l3428h		;27d7	31 28 34
	ld (TOK_NOT+1),a		;27da	32 00 01
l27ddh:
	dec b			;27dd	05
	push hl			;27de	e5
	ld bc,02a05h		;27df	01 05 2a
	jr c,l27b1h		;27e2	38 cd
	sub e			;27e4	93
	ld sp,00638h		;27e5	31 38 06
	and 0fch		;27e8	e6 fc
	add a,004h		;27ea	c6 04
	jr nc,l27f0h		;27ec	30 02
	ld a,0fch		;27ee	3e fc
l27f0h:
	push af			;27f0	f5
	call l30e6h		;27f1	cd e6 30
	rst 28h			;27f4	ef
	push hl			;27f5	e5
	ld bc,03105h		;27f6	01 05 31
	rra			;27f9	1f
	call nz,sub_3102h	;27fa	c4 02 31
	and d			;27fd	a2
	inc b			;27fe	04
	rra			;27ff	1f
	pop bc			;2800	c1
	ld bc,K_SCAN_2		;2801	01 c0 02
	ld sp,03104h		;2804	31 04 31
	rrca			;2807	0f
	and c			;2808	a1
	inc bc			;2809	03
	dec de			;280a	1b
	jp l3802h		;280b	c3 02 38
	pop bc			;280e	c1
	ret			;280f	c9
	call GET_XY		;2810	cd 60 26
	ld a,c			;2813	79
	cp b			;2814	b8
	jr nc,l281dh		;2815	30 06
	ld l,c			;2817	69
	push de			;2818	d5
	xor a			;2819	af
	ld e,a			;281a	5f
	jr l2824h		;281b	18 07
l281dh:
	or c			;281d	b1
	ret z			;281e	c8
	ld l,b			;281f	68
	ld b,c			;2820	41
	push de			;2821	d5
	ld d,000h		;2822	16 00
l2824h:
	ld h,b			;2824	60
	ld a,b			;2825	78
	rra			;2826	1f
l2827h:
	add a,l			;2827	85
	jr c,l282dh		;2828	38 03
	cp h			;282a	bc
	jr c,l2834h		;282b	38 07
l282dh:
	sub h			;282d	94
	ld c,a			;282e	4f
	exx			;282f	d9
	pop bc			;2830	c1
	push bc			;2831	c5
	jr l2838h		;2832	18 04
l2834h:
	ld c,a			;2834	4f
	push de			;2835	d5
	exx			;2836	d9
	pop bc			;2837	c1
l2838h:
	ld hl,(05c7dh)		;2838	2a 7d 5c  ; XCOORD
	ld a,b			;283b	78
	add a,h			;283c	84
	ld b,a			;283d	47
	ld a,c			;283e	79
	inc a			;283f	3c
	add a,l			;2840	85
	jr c,l2850h		;2841	38 0d
	jr z,l2852h		;2843	28 0d
l2845h:
	dec a			;2845	3d
	ld c,a			;2846	4f
	call PLOT_SUB		;2847	cd 3e 26
	exx			;284a	d9
	ld a,c			;284b	79
	djnz l2827h		;284c	10 d9
	pop de			;284e	d1
	ret			;284f	c9
l2850h:
	jr z,l2845h		;2850	28 f3
l2852h:
	rst 8			;2852	cf
	ld a,(bc)		;2853	0a
EVAL_EXPR:
	rst 18h			;2854	df
	ld b,000h		;2855	06 00
	push bc			;2857	c5
l2858h:
	ld c,a			;2858	4f
	ld hl,l294ch		;2859	21 4c 29
	call SEARCH_TABLE		;285c	cd 6b 13
	ld a,c			;285f	79
	jp nc,l2a42h		;2860	d2 42 2a
	ld b,000h		;2863	06 00
	ld c,(hl)		;2865	4e
	add hl,bc		;2866	09
	jp (hl)			;2867	e9
l2868h:
	call NEXTCH		;2868	cd 74 00
	inc bc			;286b	03
	cp 00dh			;286c	fe 0d
	jp z,NONSENSE_ERR		;286e	ca ed 1b
	cp 022h			;2871	fe 22
	jr nz,l2868h		;2873	20 f3
	call NEXTCH		;2875	cd 74 00
	cp 022h			;2878	fe 22
	ret			;287a	c9
sub_287bh:
	rst 20h			;287b	e7
	cp 028h			;287c	fe 28
	jr nz,l2886h		;287e	20 06
	call SKIP_NEXT		;2880	cd dc 1b
	rst 18h			;2883	df
	cp 029h			;2884	fe 29
l2886h:
	jp nz,NONSENSE_ERR		;2886	c2 ed 1b
CHECK_SYNTAX_2:
	bit 7,(iy+001h)		;2889	fd cb 01 7e  ; IY+$01 = FLAGS
	ret			;288d	c9
FSCREEN:

;================================================================
;*** ZEBRA MODIFICATION: SCREEN$ calls $0DF5 ***
; Instead of calling $2660 (GET_XY) directly, calls the
; Zebra FSCREEN_64 wrapper which adjusts for 64-column mode.
;================================================================
	call FSCREEN_64		;288e	cd f5 0d
	rrca			;2891	0f
	rrca			;2892	0f
	rrca			;2893	0f
	and 0e0h		;2894	e6 e0
	xor b			;2896	a8
	ld e,a			;2897	5f
	ld a,c			;2898	79
	and 018h		;2899	e6 18
	xor 040h		;289b	ee 40
	ld d,a			;289d	57
	bit 0,(iy+077h)		;289e	fd cb 77 46  ; IY+$77 = XCOORD_SAVE
	jr z,l28a6h		;28a2	28 02
	set 5,d			;28a4	cb ea
l28a6h:
	ld b,060h		;28a6	06 60
l28a8h:
	push bc			;28a8	c5
	push de			;28a9	d5
	push hl			;28aa	e5
	ld a,(de)		;28ab	1a
	xor (hl)		;28ac	ae
	jr z,l28b3h		;28ad	28 04
	inc a			;28af	3c
	jr nz,l28cch		;28b0	20 1a
	dec a			;28b2	3d
l28b3h:
	ld c,a			;28b3	4f
	ld b,007h		;28b4	06 07
l28b6h:
	inc d			;28b6	14
	inc hl			;28b7	23
	ld a,(de)		;28b8	1a
l28b9h:
	xor (hl)		;28b9	ae
	xor c			;28ba	a9
	jr nz,l28cch		;28bb	20 0f
	djnz l28b6h		;28bd	10 f7
	pop bc			;28bf	c1
l28c0h:
	pop bc			;28c0	c1
	pop bc			;28c1	c1
	ld a,080h		;28c2	3e 80
	sub b			;28c4	90
	ld bc,LROS_BC		;28c5	01 01 00
	rst 30h			;28c8	f7
	ld (de),a		;28c9	12
	jr l28d6h		;28ca	18 0a
l28cch:
	pop hl			;28cc	e1
	ld de,ERROR		;28cd	11 08 00
	add hl,de		;28d0	19
	pop de			;28d1	d1
	pop bc			;28d2	c1
	djnz l28a8h		;28d3	10 d3
	ld c,b			;28d5	48
l28d6h:
	ret			;28d6	c9
sub_28d7h:
	call GET_XY		;28d7	cd 60 26
	ld a,c			;28da	79
	rrca			;28db	0f
	rrca			;28dc	0f
	rrca			;28dd	0f
	ld c,a			;28de	4f
	and 0e0h		;28df	e6 e0
	xor b			;28e1	a8
	ld l,a			;28e2	6f
	ld a,c			;28e3	79
	and 003h		;28e4	e6 03
	xor 058h		;28e6	ee 58
	ld h,a			;28e8	67
	ld a,(hl)		;28e9	7e
	jp l30e6h		;28ea	c3 e6 30
	call CHECK_SYNTAX_2		;28ed	cd 89 28
	jr z,$+5		;28f0	28 03
	rst 28h			;28f2	ef
	and e			;28f3	a3
	jr c,l28b9h		;28f4	38 c3
	add a,c			;28f6	81
	ld hl,(07bcdh)		;28f7	2a cd 7b
	jr z,l28c0h		;28fa	28 c4
	ld (bc),a		;28fc	02
	add hl,hl		;28fd	29
	rst 20h			;28fe	e7
	jp l2a81h		;28ff	c3 81 2a
	call GET_XY		;2902	cd 60 26
	ld a,b			;2905	78
	call sub_292bh		;2906	cd 2b 29
	ld a,c			;2909	79
	call sub_292bh		;290a	cd 2b 29
	ld d,c			;290d	51
	ld a,00eh		;290e	3e 0e
	out (0f5h),a		;2910	d3 f5
	ld c,0f6h		;2912	0e f6
	in a,(c)		;2914	ed 78
	cpl			;2916	2f
	ld b,d			;2917	42
	djnz l2926h		;2918	10 0c
	and 00fh		;291a	e6 0f
	cp 00fh			;291c	fe 0f
	jr c,l2922h		;291e	38 02
	and 000h		;2920	e6 00
l2922h:
	call l30e6h		;2922	cd e6 30
	ret			;2925	c9
l2926h:
	rlca			;2926	07
	and 001h		;2927	e6 01
	jr l2922h		;2929	18 f7
sub_292bh:
	sub 002h		;292b	d6 02
	adc a,000h		;292d	ce 00
	jr nz,l2932h		;292f	20 01
	ret			;2931	c9
l2932h:
	rst 8			;2932	cf
	add hl,bc		;2933	09
	call CHECK_SYNTAX_2		;2934	cd 89 28
	jr z,l2948h		;2937	28 0f
	ld hl,(05cb2h)		;2939	2a b2 5c  ; RAMTOP
	ld de,(05c65h)		;293c	ed 5b 65 5c  ; STKEND
	and a			;2940	a7
	sbc hl,de		;2941	ed 52
	ld c,l			;2943	4d
	ld b,h			;2944	44
	call STACK_NUM		;2945	cd e9 30
l2948h:
	rst 20h			;2948	e7
	jp l2a81h		;2949	c3 81 2a
l294ch:
	ld (l2824h),hl		;294c	22 24 28
	ld d,a			;294f	57
	ld l,0fah		;2950	2e fa
	dec hl			;2952	2b
	ld a,(de)		;2953	1a
	ld a,h			;2954	7c
	ld d,07eh		;2955	16 7e
	ld (de),a		;2957	12
	xor b			;2958	a8
	ld e,d			;2959	5a
	and l			;295a	a5
	ld e,e			;295b	5b
	and a			;295c	a7
	adc a,b			;295d	88
	and (hl)		;295e	a6
	sub e			;295f	93
	call nz,0aaeah		;2960	c4 ea aa
	jp 0cbabh		;2963	c3 ab cb
	xor c			;2966	a9
	jp nc,LOAD_EXEC+1		;2967	d2 00 18
	ret			;296a	c9
	jr $-115		;296b	18 8b
	rst 20h			;296d	e7
	jp l2858h		;296e	c3 58 28
	rst 18h			;2971	df
	inc hl			;2972	23
	push hl			;2973	e5
	ld bc,LROS_HEADER		;2974	01 00 00
	call l2868h		;2977	cd 68 28
	jr nz,l2997h		;297a	20 1b
l297ch:
	call l2868h		;297c	cd 68 28
	jr z,l297ch		;297f	28 fb
	call CHECK_SYNTAX_2		;2981	cd 89 28
	jr z,l2997h		;2984	28 11
	rst 30h			;2986	f7
	pop hl			;2987	e1
	push de			;2988	d5
l2989h:
	ld a,(hl)		;2989	7e
	inc hl			;298a	23
	ld (de),a		;298b	12
	inc de			;298c	13
	cp 022h			;298d	fe 22
	jr nz,l2989h		;298f	20 f8
	ld a,(hl)		;2991	7e
	inc hl			;2992	23
	cp 022h			;2993	fe 22
	jr z,l2989h		;2995	28 f2
l2997h:
	dec bc			;2997	0b
	pop de			;2998	d1
l2999h:
	ld hl,05c3bh		;2999	21 3b 5c  ; FLAGS
	res 6,(hl)		;299c	cb b6
	bit 7,(hl)		;299e	cb 7e
	call nz,sub_2e70h	;29a0	c4 70 2e
	jp l2ad0h		;29a3	c3 d0 2a
	rst 20h			;29a6	e7
	call EVAL_EXPR		;29a7	cd 54 28
	cp 029h			;29aa	fe 29
	jp nz,NONSENSE_ERR		;29ac	c2 ed 1b
	rst 20h			;29af	e7
	jp l2ad0h		;29b0	c3 d0 2a
	jp 02b7bh		;29b3	c3 7b 2b
	call CHECK_SYNTAX_2		;29b6	cd 89 28
	jr z,l29e3h		;29b9	28 28
	ld bc,(05c76h)		;29bb	ed 4b 76 5c
	call STACK_NUM		;29bf	cd e9 30
	rst 28h			;29c2	ef
	and c			;29c3	a1
	rrca			;29c4	0f
	inc (hl)		;29c5	34
	scf			;29c6	37
	ld d,004h		;29c7	16 04
	inc (hl)		;29c9	34
	add a,b			;29ca	80
	ld b,c			;29cb	41
	nop			;29cc	00
	nop			;29cd	00
	add a,b			;29ce	80
	ld (0a102h),a		;29cf	32 02 a1
	inc bc			;29d2	03
	ld sp,0cd38h		;29d3	31 38 cd
	ld h,b			;29d6	60
	ld sp,043edh		;29d7	31 ed 43
	halt			;29da	76
	ld e,h			;29db	5c
	ld a,(hl)		;29dc	7e
	and a			;29dd	a7
	jr z,l29e3h		;29de	28 03
	sub 010h		;29e0	d6 10
	ld (hl),a		;29e2	77
l29e3h:
	jr l29eeh		;29e3	18 09
	call CHECK_SYNTAX_2		;29e5	cd 89 28
	jr z,l29eeh		;29e8	28 04
	rst 28h			;29ea	ef
	and e			;29eb	a3
	jr c,$+54		;29ec	38 34
l29eeh:
	rst 20h			;29ee	e7
	jp l2a81h		;29ef	c3 81 2a
	ld bc,ERR_FORLINE		;29f2	01 5a 10
	rst 20h			;29f5	e7
	cp 023h			;29f6	fe 23
	jp z,l2acbh		;29f8	ca cb 2a
	ld hl,05c3bh		;29fb	21 3b 5c  ; FLAGS
	res 6,(hl)		;29fe	cb b6
	bit 7,(hl)		;2a00	cb 7e
	jr z,l2a23h		;2a02	28 1f
	call K_SCAN		;2a04	cd b0 02
	ld c,000h		;2a07	0e 00
	jr nz,l2a1eh		;2a09	20 13
	call K_BASE		;2a0b	cd 5c 03
	jr nc,l2a1eh		;2a0e	30 0e
	dec d			;2a10	15
	ld e,a			;2a11	5f
	call CHCODE		;2a12	cd 71 03
	push af			;2a15	f5
	ld bc,LROS_BC		;2a16	01 01 00
	rst 30h			;2a19	f7
	pop af			;2a1a	f1
	ld (de),a		;2a1b	12
	ld c,001h		;2a1c	0e 01
l2a1eh:
	ld b,000h		;2a1e	06 00
	call sub_2e70h		;2a20	cd 70 2e
l2a23h:
	jp l2ad0h		;2a23	c3 d0 2a
	call sub_287bh		;2a26	cd 7b 28
	call nz,FSCREEN	;2a29	c4 8e 28
	rst 20h			;2a2c	e7
	jp l2999h		;2a2d	c3 99 29
	call sub_287bh		;2a30	cd 7b 28
	call nz,sub_28d7h	;2a33	c4 d7 28
	rst 20h			;2a36	e7
	jr l2a81h		;2a37	18 48
	call sub_287bh		;2a39	cd 7b 28
	call nz,sub_2624h	;2a3c	c4 24 26
	rst 20h			;2a3f	e7
	jr l2a81h		;2a40	18 3f
l2a42h:
	call IS_ALPHA		;2a42	cd 46 30
	jr nc,l2a9dh		;2a45	30 56
	cp 041h			;2a47	fe 41
	jr nc,l2a87h		;2a49	30 3c
	call CHECK_SYNTAX_2		;2a4b	cd 89 28
	jr nz,l2a73h		;2a4e	20 23
	call sub_3059h		;2a50	cd 59 30
	rst 18h			;2a53	df
	ld bc,LROS_CALL+2		;2a54	01 06 00
	call MAKE_ROOM		;2a57	cd bb 12
	inc hl			;2a5a	23
	ld (hl),00eh		;2a5b	36 0e
	inc hl			;2a5d	23
	ex de,hl		;2a5e	eb
	ld hl,(05c65h)		;2a5f	2a 65 5c  ; STKEND
	ld c,005h		;2a62	0e 05
	and a			;2a64	a7
	sbc hl,bc		;2a65	ed 42
	ld (05c65h),hl		;2a67	22 65 5c  ; STKEND
	ldir			;2a6a	ed b0
	ex de,hl		;2a6c	eb
	dec hl			;2a6d	2b
	call NC_HL		;2a6e	cd 77 00
	jr l2a81h		;2a71	18 0e
l2a73h:
	rst 18h			;2a73	df
l2a74h:
	inc hl			;2a74	23
	ld a,(hl)		;2a75	7e
	cp 00eh			;2a76	fe 0e
	jr nz,l2a74h		;2a78	20 fa
	inc hl			;2a7a	23
	call STK_M		;2a7b	cd 73 37
	ld (05c5dh),hl		;2a7e	22 5d 5c  ; CH_ADD
l2a81h:
	set 6,(iy+001h)		;2a81	fd cb 01 f6  ; IY+$01 = FLAGS
	jr l2a9bh		;2a85	18 14
l2a87h:
	call sub_2c70h		;2a87	cd 70 2c
	jp c,l1b91h		;2a8a	da 91 1b
	call z,sub_2d54h	;2a8d	cc 54 2d
	ld a,(05c3bh)		;2a90	3a 3b 5c  ; FLAGS
	cp 0c0h			;2a93	fe c0
	jr c,l2a9bh		;2a95	38 04
	inc hl			;2a97	23
	call STK_M		;2a98	cd 73 37
l2a9bh:
	jr l2ad0h		;2a9b	18 33
l2a9dh:
	ld bc,DF_ADDR_1		;2a9d	01 db 09
	cp 02dh			;2aa0	fe 2d
	jr z,l2acbh		;2aa2	28 27
	ld bc,ERR_NONSENSE		;2aa4	01 18 10
	cp 0aeh			;2aa7	fe ae
	jr z,l2acbh		;2aa9	28 20
l2aabh:
	sub 0afh		;2aab	d6 af
	jp c,NONSENSE_ERR		;2aad	da ed 1b
	ld bc,DUALCOPY_BANK2		;2ab0	01 f0 04
	cp 014h			;2ab3	fe 14
	jr z,l2acbh		;2ab5	28 14
	jp nc,NONSENSE_ERR		;2ab7	d2 ed 1b
	ld b,010h		;2aba	06 10
	add a,0dch		;2abc	c6 dc
	ld c,a			;2abe	4f
	cp 0dfh			;2abf	fe df
	jr nc,l2ac5h		;2ac1	30 02
	res 6,c			;2ac3	cb b1
l2ac5h:
	cp 0eeh			;2ac5	fe ee
	jr c,l2acbh		;2ac7	38 02
	res 7,c			;2ac9	cb b9
l2acbh:
	push bc			;2acb	c5
	rst 20h			;2acc	e7
	jp l2858h		;2acd	c3 58 28
l2ad0h:
	rst 18h			;2ad0	df
l2ad1h:
	cp 028h			;2ad1	fe 28
	jr nz,l2ae1h		;2ad3	20 0c
	bit 6,(iy+001h)		;2ad5	fd cb 01 76  ; IY+$01 = FLAGS
	jr nz,l2af2h		;2ad9	20 17
	call sub_2e10h		;2adb	cd 10 2e
	rst 20h			;2ade	e7
	jr l2ad1h		;2adf	18 f0
l2ae1h:
	ld b,000h		;2ae1	06 00
	ld c,a			;2ae3	4f
	ld hl,l2b53h		;2ae4	21 53 2b
	call SEARCH_TABLE		;2ae7	cd 6b 13
	jr nc,l2af2h		;2aea	30 06
	ld c,(hl)		;2aec	4e
	ld hl,l2aabh		;2aed	21 ab 2a
	add hl,bc		;2af0	09
	ld b,(hl)		;2af1	46
l2af2h:
	pop de			;2af2	d1
	ld a,d			;2af3	7a
	cp b			;2af4	b8
	jr c,l2b31h		;2af5	38 3a
	and a			;2af7	a7
	jp z,GETCURCH		;2af8	ca 18 00
	push bc			;2afb	c5
	ld hl,05c3bh		;2afc	21 3b 5c  ; FLAGS
	ld a,e			;2aff	7b
	cp 0edh			;2b00	fe ed
	jr nz,l2b0ah		;2b02	20 06
	bit 6,(hl)		;2b04	cb 76
	jr nz,l2b0ah		;2b06	20 02
	ld e,099h		;2b08	1e 99
l2b0ah:
	push de			;2b0a	d5
	call CHECK_SYNTAX_2		;2b0b	cd 89 28
	jr z,l2b19h		;2b0e	28 09
	ld a,e			;2b10	7b
	and 03fh		;2b11	e6 3f
	ld b,a			;2b13	47
	rst 28h			;2b14	ef
	dec sp			;2b15	3b
	jr c,$+26		;2b16	38 18
	add hl,bc		;2b18	09
l2b19h:
	ld a,e			;2b19	7b
	xor (iy+001h)		;2b1a	fd ae 01  ; IY+$01 = FLAGS
	and 040h		;2b1d	e6 40
l2b1fh:
	jp nz,NONSENSE_ERR		;2b1f	c2 ed 1b
	pop de			;2b22	d1
	ld hl,05c3bh		;2b23	21 3b 5c  ; FLAGS
	set 6,(hl)		;2b26	cb f6
	bit 7,e			;2b28	cb 7b
	jr nz,l2b2eh		;2b2a	20 02
	res 6,(hl)		;2b2c	cb b6
l2b2eh:
	pop bc			;2b2e	c1
	jr l2af2h		;2b2f	18 c1
l2b31h:
	push de			;2b31	d5
	ld a,c			;2b32	79
	bit 6,(iy+001h)		;2b33	fd cb 01 76  ; IY+$01 = FLAGS
	jr nz,l2b4eh		;2b37	20 15
	and 03fh		;2b39	e6 3f
	add a,008h		;2b3b	c6 08
	ld c,a			;2b3d	4f
	cp 010h			;2b3e	fe 10
	jr nz,l2b46h		;2b40	20 04
	set 6,c			;2b42	cb f1
	jr l2b4eh		;2b44	18 08
l2b46h:
	jr c,l2b1fh		;2b46	38 d7
	cp 017h			;2b48	fe 17
	jr z,l2b4eh		;2b4a	28 02
	set 7,c			;2b4c	cb f9
l2b4eh:
	push bc			;2b4e	c5
	rst 20h			;2b4f	e7
	jp l2858h		;2b50	c3 58 28
l2b53h:
	dec hl			;2b53	2b
	rst 8			;2b54	cf
	dec l			;2b55	2d
	jp 0c42ah		;2b56	c3 2a c4
	cpl			;2b59	2f
	push bc			;2b5a	c5
	ld e,(hl)		;2b5b	5e
	add a,03dh		;2b5c	c6 3d
	adc a,03eh		;2b5e	ce 3e
	call z,0cd3ch		;2b60	cc 3c cd
	rst 0			;2b63	c7
	ret			;2b64	c9
	ret z			;2b65	c8
	jp z,0cbc9h		;2b66	ca c9 cb
	push bc			;2b69	c5
	rst 0			;2b6a	c7
	add a,0c8h		;2b6b	c6 c8
	nop			;2b6d	00
	ld b,008h		;2b6e	06 08
	ex af,af'		;2b70	08
	ld a,(bc)		;2b71	0a
	ld (bc),a		;2b72	02
	inc bc			;2b73	03
	dec b			;2b74	05
	dec b			;2b75	05
	dec b			;2b76	05
	dec b			;2b77	05
	dec b			;2b78	05
	dec b			;2b79	05
	ld b,0cdh		;2b7a	06 cd
	adc a,c			;2b7c	89
	jr z,l2b9fh		;2b7d	28 20
	dec (hl)		;2b7f	35
	rst 20h			;2b80	e7
	call sub_304bh		;2b81	cd 4b 30
	jp nc,NONSENSE_ERR		;2b84	d2 ed 1b
	rst 20h			;2b87	e7
	cp 024h			;2b88	fe 24
	push af			;2b8a	f5
	jr nz,l2b8eh		;2b8b	20 01
	rst 20h			;2b8d	e7
l2b8eh:
	cp 028h			;2b8e	fe 28
	jr nz,l2ba4h		;2b90	20 12
	rst 20h			;2b92	e7
	cp 029h			;2b93	fe 29
	jr z,l2ba7h		;2b95	28 10
l2b97h:
	call EVAL_EXPR		;2b97	cd 54 28
	rst 18h			;2b9a	df
	cp 02ch			;2b9b	fe 2c
	jr nz,l2ba2h		;2b9d	20 03
l2b9fh:
	rst 20h			;2b9f	e7
	jr l2b97h		;2ba0	18 f5
l2ba2h:
	cp 029h			;2ba2	fe 29
l2ba4h:
	jp nz,NONSENSE_ERR		;2ba4	c2 ed 1b
l2ba7h:
	rst 20h			;2ba7	e7
	ld hl,05c3bh		;2ba8	21 3b 5c  ; FLAGS
	res 6,(hl)		;2bab	cb b6
	pop af			;2bad	f1
	jr z,l2bb2h		;2bae	28 02
	set 6,(hl)		;2bb0	cb f6
l2bb2h:
	jp l2ad0h		;2bb2	c3 d0 2a
	rst 20h			;2bb5	e7
	and 0dfh		;2bb6	e6 df
l2bb8h:
	ld b,a			;2bb8	47
	rst 20h			;2bb9	e7
	sub 024h		;2bba	d6 24
	ld c,a			;2bbc	4f
	jr nz,l2bc0h		;2bbd	20 01
	rst 20h			;2bbf	e7
l2bc0h:
	rst 20h			;2bc0	e7
	push hl			;2bc1	e5
	ld hl,(05c53h)		;2bc2	2a 53 5c  ; PROG
	dec hl			;2bc5	2b
l2bc6h:
	ld de,TOK_COS		;2bc6	11 ce 00
	push bc			;2bc9	c5
	call 01d28h		;2bca	cd 28 1d
	pop bc			;2bcd	c1
	jr nc,$+4		;2bce	30 02
	rst 8			;2bd0	cf
	jr l2bb8h		;2bd1	18 e5
	call sub_2c69h		;2bd3	cd 69 2c
	and 0dfh		;2bd6	e6 df
	cp b			;2bd8	b8
	jr nz,l2be3h		;2bd9	20 08
	call sub_2c69h		;2bdb	cd 69 2c
	sub 024h		;2bde	d6 24
	cp c			;2be0	b9
	jr z,l2befh		;2be1	28 0c
l2be3h:
	pop hl			;2be3	e1
	dec hl			;2be4	2b
	ld de,TOK_RETURN		;2be5	11 00 02
	push bc			;2be8	c5
	call FIND_STMT		;2be9	cd f3 16
	pop bc			;2bec	c1
	jr l2bc6h		;2bed	18 d7
l2befh:
	and a			;2bef	a7
	call z,sub_2c69h	;2bf0	cc 69 2c
	pop de			;2bf3	d1
	pop de			;2bf4	d1
	ld (05c5dh),de		;2bf5	ed 53 5d 5c  ; CH_ADD
	call sub_2c69h		;2bf9	cd 69 2c
	push hl			;2bfc	e5
	cp 029h			;2bfd	fe 29
	jr z,l2c43h		;2bff	28 42
l2c01h:
	inc hl			;2c01	23
	ld a,(hl)		;2c02	7e
	cp 00eh			;2c03	fe 0e
	ld d,040h		;2c05	16 40
	jr z,l2c10h		;2c07	28 07
	dec hl			;2c09	2b
	call sub_2c69h		;2c0a	cd 69 2c
	inc hl			;2c0d	23
	ld d,000h		;2c0e	16 00
l2c10h:
	inc hl			;2c10	23
	push hl			;2c11	e5
	push de			;2c12	d5
	call EVAL_EXPR		;2c13	cd 54 28
	pop af			;2c16	f1
	xor (iy+001h)		;2c17	fd ae 01  ; IY+$01 = FLAGS
	and 040h		;2c1a	e6 40
	jr nz,l2c49h		;2c1c	20 2b
	pop hl			;2c1e	e1
	ex de,hl		;2c1f	eb
	ld hl,(05c65h)		;2c20	2a 65 5c  ; STKEND
	ld bc,LROS_CALL+1		;2c23	01 05 00
	sbc hl,bc		;2c26	ed 42
	ld (05c65h),hl		;2c28	22 65 5c  ; STKEND
	ldir			;2c2b	ed b0
	ex de,hl		;2c2d	eb
	dec hl			;2c2e	2b
	call sub_2c69h		;2c2f	cd 69 2c
	cp 029h			;2c32	fe 29
	jr z,l2c43h		;2c34	28 0d
	push hl			;2c36	e5
	rst 18h			;2c37	df
	cp 02ch			;2c38	fe 2c
	jr nz,l2c49h		;2c3a	20 0d
	rst 20h			;2c3c	e7
	pop hl			;2c3d	e1
	call sub_2c69h		;2c3e	cd 69 2c
	jr l2c01h		;2c41	18 be
l2c43h:
	push hl			;2c43	e5
	rst 18h			;2c44	df
	cp 029h			;2c45	fe 29
	jr z,l2c4bh		;2c47	28 02
l2c49h:
	rst 8			;2c49	cf
	add hl,de		;2c4a	19
l2c4bh:
	pop de			;2c4b	d1
	ex de,hl		;2c4c	eb
	ld (05c5dh),hl		;2c4d	22 5d 5c  ; CH_ADD
	ld hl,(05c0bh)		;2c50	2a 0b 5c  ; DEFADD
	ex (sp),hl		;2c53	e3
	ld (05c0bh),hl		;2c54	22 0b 5c  ; DEFADD
	push de			;2c57	d5
	rst 20h			;2c58	e7
	rst 20h			;2c59	e7
	call EVAL_EXPR		;2c5a	cd 54 28
	pop hl			;2c5d	e1
	ld (05c5dh),hl		;2c5e	22 5d 5c  ; CH_ADD
	pop hl			;2c61	e1
	ld (05c0bh),hl		;2c62	22 0b 5c  ; DEFADD
	rst 20h			;2c65	e7
	jp l2ad0h		;2c66	c3 d0 2a
sub_2c69h:
	inc hl			;2c69	23
	ld a,(hl)		;2c6a	7e
	cp 021h			;2c6b	fe 21
	jr c,sub_2c69h		;2c6d	38 fa
	ret			;2c6f	c9
sub_2c70h:
	set 6,(iy+001h)		;2c70	fd cb 01 f6  ; IY+$01 = FLAGS
	rst 18h			;2c74	df
	call sub_304bh		;2c75	cd 4b 30
	jp nc,NONSENSE_ERR		;2c78	d2 ed 1b
	push hl			;2c7b	e5
	and 01fh		;2c7c	e6 1f
	ld c,a			;2c7e	4f
	rst 20h			;2c7f	e7
	push hl			;2c80	e5
	cp 028h			;2c81	fe 28
	jr z,l2cadh		;2c83	28 28
	set 6,c			;2c85	cb f1
	cp 024h			;2c87	fe 24
	jr z,l2c9ch		;2c89	28 11
	set 5,c			;2c8b	cb e9
	call IS_ALPHA		;2c8d	cd 46 30
	jr nc,l2ca1h		;2c90	30 0f
l2c92h:
	call IS_ALPHA		;2c92	cd 46 30
	jr nc,l2cadh		;2c95	30 16
	res 6,c			;2c97	cb b1
	rst 20h			;2c99	e7
	jr l2c92h		;2c9a	18 f6
l2c9ch:
	rst 20h			;2c9c	e7
	res 6,(iy+001h)		;2c9d	fd cb 01 b6  ; IY+$01 = FLAGS
l2ca1h:
	ld a,(05c0ch)		;2ca1	3a 0c 5c
	and a			;2ca4	a7
	jr z,l2cadh		;2ca5	28 06
	call CHECK_SYNTAX_2		;2ca7	cd 89 28
	jp nz,l2d0fh		;2caa	c2 0f 2d
l2cadh:
	ld b,c			;2cad	41
	call CHECK_SYNTAX_2		;2cae	cd 89 28
	jr nz,l2cbbh		;2cb1	20 08
	ld a,c			;2cb3	79
	and 0e0h		;2cb4	e6 e0
	set 7,a			;2cb6	cb ff
	ld c,a			;2cb8	4f
	jr l2cf2h		;2cb9	18 37
l2cbbh:
	ld hl,(05c4bh)		;2cbb	2a 4b 5c  ; VARS
l2cbeh:
	ld a,(hl)		;2cbe	7e
	and 07fh		;2cbf	e6 7f
	jr z,l2cf0h		;2cc1	28 2d
	cp c			;2cc3	b9
	jr nz,l2ce8h		;2cc4	20 22
	rla			;2cc6	17
	add a,a			;2cc7	87
	jp p,l2cfdh		;2cc8	f2 fd 2c
	jr c,l2cfdh		;2ccb	38 30
	pop de			;2ccd	d1
	push de			;2cce	d5
	push hl			;2ccf	e5
l2cd0h:
	inc hl			;2cd0	23
l2cd1h:
	ld a,(de)		;2cd1	1a
	inc de			;2cd2	13
	cp 020h			;2cd3	fe 20
	jr z,l2cd1h		;2cd5	28 fa
	or 020h			;2cd7	f6 20
	cp (hl)			;2cd9	be
	jr z,l2cd0h		;2cda	28 f4
	or 080h			;2cdc	f6 80
	cp (hl)			;2cde	be
	jr nz,l2ce7h		;2cdf	20 06
	ld a,(de)		;2ce1	1a
	call IS_ALPHA		;2ce2	cd 46 30
	jr nc,l2cfch		;2ce5	30 15
l2ce7h:
	pop hl			;2ce7	e1
l2ce8h:
	push bc			;2ce8	c5
	call LINE_NEXT		;2ce9	cd 20 17
	ex de,hl		;2cec	eb
	pop bc			;2ced	c1
	jr l2cbeh		;2cee	18 ce
l2cf0h:
	set 7,b			;2cf0	cb f8
l2cf2h:
	pop de			;2cf2	d1
	rst 18h			;2cf3	df
	cp 028h			;2cf4	fe 28
	jr z,l2d01h		;2cf6	28 09
	set 5,b			;2cf8	cb e8
	jr l2d09h		;2cfa	18 0d
l2cfch:
	pop de			;2cfc	d1
l2cfdh:
	pop de			;2cfd	d1
	pop de			;2cfe	d1
	push hl			;2cff	e5
	rst 18h			;2d00	df
l2d01h:
	call IS_ALPHA		;2d01	cd 46 30
	jr nc,l2d09h		;2d04	30 03
	rst 20h			;2d06	e7
	jr l2d01h		;2d07	18 f8
l2d09h:
	pop hl			;2d09	e1
	rl b			;2d0a	cb 10
	bit 6,b			;2d0c	cb 70
	ret			;2d0e	c9
l2d0fh:
	ld hl,(05c0bh)		;2d0f	2a 0b 5c  ; DEFADD
	ld a,(hl)		;2d12	7e
	cp 029h			;2d13	fe 29
	jp z,l2cadh		;2d15	ca ad 2c
l2d18h:
	ld a,(hl)		;2d18	7e
	or 060h			;2d19	f6 60
	ld b,a			;2d1b	47
	inc hl			;2d1c	23
	ld a,(hl)		;2d1d	7e
	cp 00eh			;2d1e	fe 0e
	jr z,l2d29h		;2d20	28 07
	dec hl			;2d22	2b
	call sub_2c69h		;2d23	cd 69 2c
	inc hl			;2d26	23
	res 5,b			;2d27	cb a8
l2d29h:
	ld a,b			;2d29	78
	cp c			;2d2a	b9
	jr z,l2d3fh		;2d2b	28 12
	inc hl			;2d2d	23
	inc hl			;2d2e	23
	inc hl			;2d2f	23
	inc hl			;2d30	23
	inc hl			;2d31	23
	call sub_2c69h		;2d32	cd 69 2c
	cp 029h			;2d35	fe 29
	jp z,l2cadh		;2d37	ca ad 2c
	call sub_2c69h		;2d3a	cd 69 2c
	jr l2d18h		;2d3d	18 d9
l2d3fh:
	bit 5,c			;2d3f	cb 69
	jr nz,l2d4fh		;2d41	20 0c
	inc hl			;2d43	23
	ld de,(05c65h)		;2d44	ed 5b 65 5c  ; STKEND
	call sub_377fh		;2d48	cd 7f 37
	ex de,hl		;2d4b	eb
	ld (05c65h),hl		;2d4c	22 65 5c  ; STKEND
l2d4fh:
	pop de			;2d4f	d1
	pop de			;2d50	d1
	xor a			;2d51	af
	inc a			;2d52	3c
	ret			;2d53	c9
sub_2d54h:
	xor a			;2d54	af
	ld b,a			;2d55	47
	bit 7,c			;2d56	cb 79
	jr nz,l2da5h		;2d58	20 4b
	bit 7,(hl)		;2d5a	cb 7e
	jr nz,l2d6ch		;2d5c	20 0e
	inc a			;2d5e	3c
l2d5fh:
	inc hl			;2d5f	23
	ld c,(hl)		;2d60	4e
	inc hl			;2d61	23
	ld b,(hl)		;2d62	46
	inc hl			;2d63	23
	ex de,hl		;2d64	eb
	call sub_2e70h		;2d65	cd 70 2e
	rst 18h			;2d68	df
	jp l2e07h		;2d69	c3 07 2e
l2d6ch:
	inc hl			;2d6c	23
	inc hl			;2d6d	23
	inc hl			;2d6e	23
	ld b,(hl)		;2d6f	46
	bit 6,c			;2d70	cb 71
	jr z,l2d7eh		;2d72	28 0a
	dec b			;2d74	05
	jr z,l2d5fh		;2d75	28 e8
	ex de,hl		;2d77	eb
	rst 18h			;2d78	df
	cp 028h			;2d79	fe 28
	jr nz,l2ddeh		;2d7b	20 61
	ex de,hl		;2d7d	eb
l2d7eh:
	ex de,hl		;2d7e	eb
	jr l2da5h		;2d7f	18 24
l2d81h:
	push hl			;2d81	e5
	rst 18h			;2d82	df
	pop hl			;2d83	e1
	cp 02ch			;2d84	fe 2c
	jr z,l2da8h		;2d86	28 20
	bit 7,c			;2d88	cb 79
	jr z,l2ddeh		;2d8a	28 52
	bit 6,c			;2d8c	cb 71
	jr nz,l2d96h		;2d8e	20 06
	cp 029h			;2d90	fe 29
	jr nz,l2dd0h		;2d92	20 3c
	rst 20h			;2d94	e7
	ret			;2d95	c9
l2d96h:
	cp 029h			;2d96	fe 29
	jr z,l2e06h		;2d98	28 6c
	cp 0cch			;2d9a	fe cc
	jr nz,l2dd0h		;2d9c	20 32
l2d9eh:
	rst 18h			;2d9e	df
	dec hl			;2d9f	2b
	ld (05c5dh),hl		;2da0	22 5d 5c  ; CH_ADD
	jr l2e03h		;2da3	18 5e
l2da5h:
	ld hl,LROS_HEADER		;2da5	21 00 00
l2da8h:
	push hl			;2da8	e5
	rst 20h			;2da9	e7
	pop hl			;2daa	e1
	ld a,c			;2dab	79
	cp 0c0h			;2dac	fe c0
	jr nz,l2db9h		;2dae	20 09
	rst 18h			;2db0	df
	cp 029h			;2db1	fe 29
	jr z,l2e06h		;2db3	28 51
	cp 0cch			;2db5	fe cc
	jr z,l2d9eh		;2db7	28 e5
l2db9h:
	push bc			;2db9	c5
	push hl			;2dba	e5
	call GET_NEXT_VAR		;2dbb	cd ac 2e
	ex (sp),hl		;2dbe	e3
	ex de,hl		;2dbf	eb
	call SLICE_VAR		;2dc0	cd 8a 2e
	jr c,l2ddeh		;2dc3	38 19
	dec bc			;2dc5	0b
	call CHECK_STRING		;2dc6	cd b2 2e
	add hl,bc		;2dc9	09
	pop de			;2dca	d1
	pop bc			;2dcb	c1
	djnz l2d81h		;2dcc	10 b3
	bit 7,c			;2dce	cb 79
l2dd0h:
	jr nz,l2e38h		;2dd0	20 66
	push hl			;2dd2	e5
	bit 6,c			;2dd3	cb 71
	jr nz,l2deah		;2dd5	20 13
	ld b,d			;2dd7	42
	ld c,e			;2dd8	4b
	rst 18h			;2dd9	df
	cp 029h			;2dda	fe 29
	jr z,l2de0h		;2ddc	28 02
l2ddeh:
	rst 8			;2dde	cf
	ld (bc),a		;2ddf	02
l2de0h:
	rst 20h			;2de0	e7
	pop hl			;2de1	e1
	ld de,LROS_CALL+1		;2de2	11 05 00
	call CHECK_STRING		;2de5	cd b2 2e
	add hl,bc		;2de8	09
	ret			;2de9	c9
l2deah:
	call GET_NEXT_VAR		;2dea	cd ac 2e
	ex (sp),hl		;2ded	e3
	call CHECK_STRING		;2dee	cd b2 2e
	pop bc			;2df1	c1
	add hl,bc		;2df2	09
	inc hl			;2df3	23
	ld b,d			;2df4	42
	ld c,e			;2df5	4b
	ex de,hl		;2df6	eb
	call sub_2e6fh		;2df7	cd 6f 2e
	rst 18h			;2dfa	df
	cp 029h			;2dfb	fe 29
	jr z,l2e06h		;2dfd	28 07
	cp 02ch			;2dff	fe 2c
	jr nz,l2ddeh		;2e01	20 db
l2e03h:
	call sub_2e10h		;2e03	cd 10 2e
l2e06h:
	rst 20h			;2e06	e7
l2e07h:
	cp 028h			;2e07	fe 28
	jr z,l2e03h		;2e09	28 f8
	res 6,(iy+001h)		;2e0b	fd cb 01 b6  ; IY+$01 = FLAGS
	ret			;2e0f	c9
sub_2e10h:
	call CHECK_SYNTAX_2		;2e10	cd 89 28
	call nz,GET_STRING	;2e13	c4 af 2f
	rst 20h			;2e16	e7
	cp 029h			;2e17	fe 29
	jr z,l2e6bh		;2e19	28 50
	push de			;2e1b	d5
	xor a			;2e1c	af
	push af			;2e1d	f5
	push bc			;2e1e	c5
	ld de,LROS_BC		;2e1f	11 01 00
	rst 18h			;2e22	df
	pop hl			;2e23	e1
	cp 0cch			;2e24	fe cc
	jr z,l2e3fh		;2e26	28 17
	pop af			;2e28	f1
	call SLICE_VAR_2		;2e29	cd 8b 2e
	push af			;2e2c	f5
	ld d,b			;2e2d	50
	ld e,c			;2e2e	59
	push hl			;2e2f	e5
	rst 18h			;2e30	df
	pop hl			;2e31	e1
	cp 0cch			;2e32	fe cc
	jr z,l2e3fh		;2e34	28 09
	cp 029h			;2e36	fe 29
l2e38h:
	jp nz,NONSENSE_ERR		;2e38	c2 ed 1b
	ld h,d			;2e3b	62
	ld l,e			;2e3c	6b
	jr l2e52h		;2e3d	18 13
l2e3fh:
	push hl			;2e3f	e5
	rst 20h			;2e40	e7
	pop hl			;2e41	e1
	cp 029h			;2e42	fe 29
	jr z,l2e52h		;2e44	28 0c
	pop af			;2e46	f1
	call SLICE_VAR_2		;2e47	cd 8b 2e
	push af			;2e4a	f5
	rst 18h			;2e4b	df
	ld h,b			;2e4c	60
	ld l,c			;2e4d	69
	cp 029h			;2e4e	fe 29
	jr nz,l2e38h		;2e50	20 e6
l2e52h:
	pop af			;2e52	f1
	ex (sp),hl		;2e53	e3
	add hl,de		;2e54	19
	dec hl			;2e55	2b
	ex (sp),hl		;2e56	e3
	and a			;2e57	a7
	sbc hl,de		;2e58	ed 52
	ld bc,LROS_HEADER		;2e5a	01 00 00
	jr c,l2e66h		;2e5d	38 07
	inc hl			;2e5f	23
	and a			;2e60	a7
	jp m,l2ddeh		;2e61	fa de 2d
	ld b,h			;2e64	44
	ld c,l			;2e65	4d
l2e66h:
	pop de			;2e66	d1
	res 6,(iy+001h)		;2e67	fd cb 01 b6  ; IY+$01 = FLAGS
l2e6bh:
	call CHECK_SYNTAX_2		;2e6b	cd 89 28
	ret z			;2e6e	c8
sub_2e6fh:
	xor a			;2e6f	af
sub_2e70h:
	res 6,(iy+001h)		;2e70	fd cb 01 b6  ; IY+$01 = FLAGS
sub_2e74h:
	push bc			;2e74	c5
	call sub_3768h		;2e75	cd 68 37
	pop bc			;2e78	c1
	ld hl,(05c65h)		;2e79	2a 65 5c  ; STKEND
	ld (hl),a		;2e7c	77
	inc hl			;2e7d	23
	ld (hl),e		;2e7e	73
	inc hl			;2e7f	23
	ld (hl),d		;2e80	72
	inc hl			;2e81	23
	ld (hl),c		;2e82	71
	inc hl			;2e83	23
	ld (hl),b		;2e84	70
	inc hl			;2e85	23
	ld (05c65h),hl		;2e86	22 65 5c  ; STKEND
l2e89h:
	ret			;2e89	c9
SLICE_VAR:
	xor a			;2e8a	af
SLICE_VAR_2:
	push de			;2e8b	d5
	push hl			;2e8c	e5
	push af			;2e8d	f5
	call EXPR_NUM		;2e8e	cd e5 1b
	pop af			;2e91	f1
	call CHECK_SYNTAX_2		;2e92	cd 89 28
	jr z,l2ea9h		;2e95	28 12
	push af			;2e97	f5
	call FP_TO_BC		;2e98	cd 23 1f
	pop de			;2e9b	d1
	ld a,b			;2e9c	78
	or c			;2e9d	b1
	scf			;2e9e	37
	jr z,l2ea6h		;2e9f	28 05
	pop hl			;2ea1	e1
	push hl			;2ea2	e5
	and a			;2ea3	a7
	sbc hl,bc		;2ea4	ed 42
l2ea6h:
	ld a,d			;2ea6	7a
	sbc a,000h		;2ea7	de 00
l2ea9h:
	pop hl			;2ea9	e1
	pop de			;2eaa	d1
	ret			;2eab	c9
GET_NEXT_VAR:
	ex de,hl		;2eac	eb
	inc hl			;2ead	23
	ld e,(hl)		;2eae	5e
	inc hl			;2eaf	23
	ld d,(hl)		;2eb0	56
	ret			;2eb1	c9
CHECK_STRING:
	call CHECK_SYNTAX_2		;2eb2	cd 89 28
	ret z			;2eb5	c8
	call FP_TEST		;2eb6	cd 68 34
	jp c,l1fcfh		;2eb9	da cf 1f
	ret			;2ebc	c9
l2ebdh:
	ld hl,(05c4dh)		;2ebd	2a 4d 5c  ; DEST
	bit 1,(iy+037h)		;2ec0	fd cb 37 4e  ; IY+$37 = FLAGX+1
	jr z,l2f24h		;2ec4	28 5e
	ld bc,LROS_CALL+1		;2ec6	01 05 00
l2ec9h:
	inc bc			;2ec9	03
l2ecah:
	inc hl			;2eca	23
	ld a,(hl)		;2ecb	7e
	cp 020h			;2ecc	fe 20
	jr z,l2ecah		;2ece	28 fa
	jr nc,l2eddh		;2ed0	30 0b
	cp 010h			;2ed2	fe 10
	jr c,l2ee7h		;2ed4	38 11
	cp 016h			;2ed6	fe 16
	jr nc,l2ee7h		;2ed8	30 0d
	inc hl			;2eda	23
	jr l2ecah		;2edb	18 ed
l2eddh:
	call IS_ALPHA		;2edd	cd 46 30
	jr c,l2ec9h		;2ee0	38 e7
	cp 024h			;2ee2	fe 24
	jp z,l2f7eh		;2ee4	ca 7e 2f
l2ee7h:
	ld a,c			;2ee7	79
	ld hl,(05c59h)		;2ee8	2a 59 5c  ; ELINE
	dec hl			;2eeb	2b
	call MAKE_ROOM		;2eec	cd bb 12
	inc hl			;2eef	23
	inc hl			;2ef0	23
	ex de,hl		;2ef1	eb
	push de			;2ef2	d5
	ld hl,(05c4dh)		;2ef3	2a 4d 5c  ; DEST
	dec de			;2ef6	1b
	sub 006h		;2ef7	d6 06
	ld b,a			;2ef9	47
	jr z,l2f0dh		;2efa	28 11
l2efch:
	inc hl			;2efc	23
l2efdh:
	ld a,(hl)		;2efd	7e
	cp 021h			;2efe	fe 21
	jr c,l2efch		;2f00	38 fa
	or 020h			;2f02	f6 20
	inc de			;2f04	13
	ld (de),a		;2f05	12
	djnz l2efch		;2f06	10 f4
	or 080h			;2f08	f6 80
	ld (de),a		;2f0a	12
	ld a,0c0h		;2f0b	3e c0
l2f0dh:
	ld hl,(05c4dh)		;2f0d	2a 4d 5c  ; DEST
	xor (hl)		;2f10	ae
	or 020h			;2f11	f6 20
	pop hl			;2f13	e1
	call sub_2fa8h		;2f14	cd a8 2f
l2f17h:
	push hl			;2f17	e5
	rst 28h			;2f18	ef
	ld (bc),a		;2f19	02
	jr c,l2efdh		;2f1a	38 e1
	ld bc,LROS_CALL+1		;2f1c	01 05 00
	and a			;2f1f	a7
	sbc hl,bc		;2f20	ed 42
	jr l2f64h		;2f22	18 40
l2f24h:
	bit 6,(iy+001h)		;2f24	fd cb 01 76  ; IY+$01 = FLAGS
	jr z,l2f30h		;2f28	28 06
	ld de,LROS_CALL+2		;2f2a	11 06 00
	add hl,de		;2f2d	19
	jr l2f17h		;2f2e	18 e7
l2f30h:
	ld hl,(05c4dh)		;2f30	2a 4d 5c  ; DEST
	ld bc,(05c72h)		;2f33	ed 4b 72 5c
	bit 0,(iy+037h)		;2f37	fd cb 37 46  ; IY+$37 = FLAGX+1
	jr nz,l2f6dh		;2f3b	20 30
	ld a,b			;2f3d	78
	or c			;2f3e	b1
	ret z			;2f3f	c8
	push hl			;2f40	e5
	rst 30h			;2f41	f7
	push de			;2f42	d5
	push bc			;2f43	c5
	ld d,h			;2f44	54
	ld e,l			;2f45	5d
	inc hl			;2f46	23
	ld (hl),020h		;2f47	36 20
	lddr			;2f49	ed b8
	push hl			;2f4b	e5
	call GET_STRING		;2f4c	cd af 2f
	pop hl			;2f4f	e1
	ex (sp),hl		;2f50	e3
	and a			;2f51	a7
	sbc hl,bc		;2f52	ed 42
	add hl,bc		;2f54	09
	jr nc,l2f59h		;2f55	30 02
	ld b,h			;2f57	44
	ld c,l			;2f58	4d
l2f59h:
	ex (sp),hl		;2f59	e3
	ex de,hl		;2f5a	eb
	ld a,b			;2f5b	78
	or c			;2f5c	b1
	jr z,l2f61h		;2f5d	28 02
	ldir			;2f5f	ed b0
l2f61h:
	pop bc			;2f61	c1
	pop de			;2f62	d1
	pop hl			;2f63	e1
l2f64h:
	ex de,hl		;2f64	eb
	ld a,b			;2f65	78
	or c			;2f66	b1
	ret z			;2f67	c8
	push de			;2f68	d5
	ldir			;2f69	ed b0
	pop hl			;2f6b	e1
	ret			;2f6c	c9
l2f6dh:
	dec hl			;2f6d	2b
	dec hl			;2f6e	2b
	dec hl			;2f6f	2b
	ld a,(hl)		;2f70	7e
	push hl			;2f71	e5
	push bc			;2f72	c5
	call sub_2f84h		;2f73	cd 84 2f
	pop bc			;2f76	c1
	pop hl			;2f77	e1
	inc bc			;2f78	03
	inc bc			;2f79	03
	inc bc			;2f7a	03
	jp RECLAIM		;2f7b	c3 50 17
l2f7eh:
	ld a,0dfh		;2f7e	3e df
	ld hl,(05c4dh)		;2f80	2a 4d 5c  ; DEST
	and (hl)		;2f83	a6
sub_2f84h:
	push af			;2f84	f5
	call GET_STRING		;2f85	cd af 2f
	ex de,hl		;2f88	eb
	add hl,bc		;2f89	09
	push bc			;2f8a	c5
	dec hl			;2f8b	2b
	ld (05c4dh),hl		;2f8c	22 4d 5c  ; DEST
	inc bc			;2f8f	03
	inc bc			;2f90	03
	inc bc			;2f91	03
	ld hl,(05c59h)		;2f92	2a 59 5c  ; ELINE
	dec hl			;2f95	2b
	call MAKE_ROOM		;2f96	cd bb 12
	ld hl,(05c4dh)		;2f99	2a 4d 5c  ; DEST
	pop bc			;2f9c	c1
	push bc			;2f9d	c5
	inc bc			;2f9e	03
	lddr			;2f9f	ed b8
	ex de,hl		;2fa1	eb
	inc hl			;2fa2	23
	pop bc			;2fa3	c1
	ld (hl),b		;2fa4	70
	dec hl			;2fa5	2b
	ld (hl),c		;2fa6	71
	pop af			;2fa7	f1
sub_2fa8h:
	dec hl			;2fa8	2b
	ld (hl),a		;2fa9	77
	ld hl,(05c59h)		;2faa	2a 59 5c  ; ELINE
	dec hl			;2fad	2b
	ret			;2fae	c9
GET_STRING:
	ld hl,(05c65h)		;2faf	2a 65 5c  ; STKEND
	dec hl			;2fb2	2b
	ld b,(hl)		;2fb3	46
	dec hl			;2fb4	2b
	ld c,(hl)		;2fb5	4e
	dec hl			;2fb6	2b
	ld d,(hl)		;2fb7	56
	dec hl			;2fb8	2b
	ld e,(hl)		;2fb9	5e
	dec hl			;2fba	2b
	ld a,(hl)		;2fbb	7e
	ld (05c65h),hl		;2fbc	22 65 5c  ; STKEND
	ret			;2fbf	c9
	call sub_2c70h		;2fc0	cd 70 2c
l2fc3h:
	jp nz,NONSENSE_ERR		;2fc3	c2 ed 1b
	call CHECK_SYNTAX_2		;2fc6	cd 89 28
	jr nz,l2fd3h		;2fc9	20 08
	res 6,c			;2fcb	cb b1
	call sub_2d54h		;2fcd	cd 54 2d
	call 01b44h		;2fd0	cd 44 1b
l2fd3h:
	jr c,l2fddh		;2fd3	38 08
	push bc			;2fd5	c5
	call LINE_NEXT		;2fd6	cd 20 17
	call RECLAIM		;2fd9	cd 50 17
	pop bc			;2fdc	c1
l2fddh:
	set 7,c			;2fdd	cb f9
	ld b,000h		;2fdf	06 00
	push bc			;2fe1	c5
	ld hl,LROS_BC		;2fe2	21 01 00
	bit 6,c			;2fe5	cb 71
	jr nz,l2febh		;2fe7	20 02
	ld l,005h		;2fe9	2e 05
l2febh:
	ex de,hl		;2feb	eb
l2fech:
	rst 20h			;2fec	e7
	ld h,0ffh		;2fed	26 ff
	call SLICE_VAR		;2fef	cd 8a 2e
	jp c,l2ddeh		;2ff2	da de 2d
	pop hl			;2ff5	e1
	push bc			;2ff6	c5
	inc h			;2ff7	24
	push hl			;2ff8	e5
	ld h,b			;2ff9	60
	ld l,c			;2ffa	69
	call CHECK_STRING		;2ffb	cd b2 2e
	ex de,hl		;2ffe	eb
	rst 18h			;2fff	df
	cp 02ch			;3000	fe 2c
	jr z,l2fech		;3002	28 e8
	cp 029h			;3004	fe 29
	jr nz,l2fc3h		;3006	20 bb
	rst 20h			;3008	e7
	pop bc			;3009	c1
	ld a,c			;300a	79
	ld l,b			;300b	68
	ld h,000h		;300c	26 00
	inc hl			;300e	23
	inc hl			;300f	23
	add hl,hl		;3010	29
	add hl,de		;3011	19
	jp c,l1fcfh		;3012	da cf 1f
	push de			;3015	d5
	push bc			;3016	c5
	push hl			;3017	e5
	ld b,h			;3018	44
	ld c,l			;3019	4d
	ld hl,(05c59h)		;301a	2a 59 5c  ; ELINE
	dec hl			;301d	2b
	call MAKE_ROOM		;301e	cd bb 12
	inc hl			;3021	23
	ld (hl),a		;3022	77
	pop bc			;3023	c1
	dec bc			;3024	0b
	dec bc			;3025	0b
	dec bc			;3026	0b
	inc hl			;3027	23
	ld (hl),c		;3028	71
	inc hl			;3029	23
	ld (hl),b		;302a	70
CALC_REF:
	pop bc			;302b	c1
	ld a,b			;302c	78
	inc hl			;302d	23
	ld (hl),a		;302e	77
	ld h,d			;302f	62
l3030h:
	ld l,e			;3030	6b
l3031h:
	dec de			;3031	1b
	ld (hl),000h		;3032	36 00
	bit 6,c			;3034	cb 71
	jr z,l303ah		;3036	28 02
	ld (hl),020h		;3038	36 20
l303ah:
	pop bc			;303a	c1
	lddr			;303b	ed b8
l303dh:
	pop bc			;303d	c1
	ld (hl),b		;303e	70
	dec hl			;303f	2b
	ld (hl),c		;3040	71
	dec hl			;3041	2b
	dec a			;3042	3d
	jr nz,l303dh		;3043	20 f8
	ret			;3045	c9
IS_ALPHA:
	call TOKENIZE		;3046	cd d9 30
	ccf			;3049	3f
	ret c			;304a	d8
sub_304bh:
	cp 041h			;304b	fe 41
	ccf			;304d	3f
	ret nc			;304e	d0
	cp 05bh			;304f	fe 5b
	ret c			;3051	d8
	cp 061h			;3052	fe 61
	ccf			;3054	3f
	ret nc			;3055	d0
	cp 07bh			;3056	fe 7b
	ret			;3058	c9
sub_3059h:
	cp 0c4h			;3059	fe c4
	jr nz,l3076h		;305b	20 19
	ld de,LROS_HEADER		;305d	11 00 00
l3060h:
	rst 20h			;3060	e7
	sub 031h		;3061	d6 31
	adc a,000h		;3063	ce 00
	jr nz,l3071h		;3065	20 0a
	ex de,hl		;3067	eb
	ccf			;3068	3f
	adc hl,hl		;3069	ed 6a
	jp c,l356ch		;306b	da 6c 35
	ex de,hl		;306e	eb
	jr l3060h		;306f	18 ef
l3071h:
	ld b,d			;3071	42
	ld c,e			;3072	4b
	jp STACK_NUM		;3073	c3 e9 30
l3076h:
	cp 02eh			;3076	fe 2e
l3078h:
	jr z,l3089h		;3078	28 0f
	call SYNTAX_MAIN		;307a	cd f9 30
	cp 02eh			;307d	fe 2e
	jr nz,l30a9h		;307f	20 28
	rst 20h			;3081	e7
	call TOKENIZE		;3082	cd d9 30
	jr c,l30a9h		;3085	38 22
	jr $+12			;3087	18 0a
l3089h:
	rst 20h			;3089	e7
	call TOKENIZE		;308a	cd d9 30
l308dh:
	jp c,NONSENSE_ERR		;308d	da ed 1b
	rst 28h			;3090	ef
	and b			;3091	a0
	jr c,$-15		;3092	38 ef
	and c			;3094	a1
	ret nz			;3095	c0
	ld (bc),a		;3096	02
	jr c,l3078h		;3097	38 df
	call sub_30e0h		;3099	cd e0 30
	jr c,l30a9h		;309c	38 0b
	rst 28h			;309e	ef
l309fh:
	ret po			;309f	e0
	and h			;30a0	a4
	dec b			;30a1	05
	ret nz			;30a2	c0
	inc b			;30a3	04
	rrca			;30a4	0f
	jr c,$-23		;30a5	38 e7
	jr $-15			;30a7	18 ef
l30a9h:
	cp 045h			;30a9	fe 45
	jr z,l30b0h		;30ab	28 03
	cp 065h			;30ad	fe 65
	ret nz			;30af	c0
l30b0h:
	ld b,0ffh		;30b0	06 ff
	rst 20h			;30b2	e7
	cp 02bh			;30b3	fe 2b
	jr z,l30bch		;30b5	28 05
	cp 02dh			;30b7	fe 2d
	jr nz,l30bdh		;30b9	20 02
	inc b			;30bb	04
l30bch:
	rst 20h			;30bc	e7
l30bdh:
	call TOKENIZE		;30bd	cd d9 30
	jr c,l308dh		;30c0	38 cb
	push bc			;30c2	c5
	call SYNTAX_MAIN		;30c3	cd f9 30
	call 03193h		;30c6	cd 93 31
	pop bc			;30c9	c1
	jp c,l356ch		;30ca	da 6c 35
	and a			;30cd	a7
	jp m,l356ch		;30ce	fa 6c 35
	inc b			;30d1	04
	jr z,l30d6h		;30d2	28 02
	neg			;30d4	ed 44
l30d6h:
	jp l310dh		;30d6	c3 0d 31
TOKENIZE:
	cp 030h			;30d9	fe 30
	ret c			;30db	d8
	cp 03ah			;30dc	fe 3a
	ccf			;30de	3f
	ret			;30df	c9
sub_30e0h:
	call TOKENIZE		;30e0	cd d9 30
	ret c			;30e3	d8
	sub 030h		;30e4	d6 30
l30e6h:
	ld c,a			;30e6	4f
	ld b,000h		;30e7	06 00
STACK_NUM:
	ld iy,05c3ah		;30e9	fd 21 3a 5c  ; ERR_NR
	xor a			;30ed	af
	ld e,a			;30ee	5f
l30efh:
	ld d,c			;30ef	51
	ld c,b			;30f0	48
	ld b,a			;30f1	47
	call sub_2e74h		;30f2	cd 74 2e
	rst 28h			;30f5	ef
	jr c,l309fh		;30f6	38 a7
	ret			;30f8	c9
SYNTAX_MAIN:
	push af			;30f9	f5
	rst 28h			;30fa	ef
	and b			;30fb	a0
	jr c,l30efh		;30fc	38 f1
l30feh:
	call sub_30e0h		;30fe	cd e0 30
	ret c			;3101	d8
sub_3102h:
	rst 28h			;3102	ef
	ld bc,BEEP_DUR		;3103	01 a4 04
l3106h:
	rrca			;3106	0f
	jr c,l30d6h		;3107	38 cd
	ld (hl),h		;3109	74
	nop			;310a	00
	jr l30feh		;310b	18 f1
l310dh:
	rlca			;310d	07
	rrca			;310e	0f
l310fh:
	jr nc,l3113h		;310f	30 02
	cpl			;3111	2f
	inc a			;3112	3c
l3113h:
	push af			;3113	f5
	ld hl,05c92h		;3114	21 92 5c  ; MEMBOT
	call sub_3926h		;3117	cd 26 39
	rst 28h			;311a	ef
	and h			;311b	a4
	jr c,l310fh		;311c	38 f1
l311eh:
	srl a			;311e	cb 3f
l3120h:
	jr nc,l312fh		;3120	30 0d
	push af			;3122	f5
	rst 28h			;3123	ef
	pop bc			;3124	c1
	ret po			;3125	e0
	nop			;3126	00
	inc b			;3127	04
	inc b			;3128	04
l3129h:
	inc sp			;3129	33
	ld (bc),a		;312a	02
	dec b			;312b	05
	pop hl			;312c	e1
	jr c,l3120h		;312d	38 f1
l312fh:
	jr z,l3139h		;312f	28 08
l3131h:
	push af			;3131	f5
	rst 28h			;3132	ef
	ld sp,l3804h		;3133	31 04 38
	pop af			;3136	f1
	jr l311eh		;3137	18 e5
l3139h:
	rst 28h			;3139	ef
	ld (bc),a		;313a	02
	jr c,l3106h		;313b	38 c9
FP_PUSH:
	inc hl			;313d	23
	ld c,(hl)		;313e	4e
	inc hl			;313f	23
	ld a,(hl)		;3140	7e
	xor c			;3141	a9
	sub c			;3142	91
	ld e,a			;3143	5f
	inc hl			;3144	23
	ld a,(hl)		;3145	7e
	adc a,c			;3146	89
	xor c			;3147	a9
	ld d,a			;3148	57
	ret			;3149	c9
	ld c,000h		;314a	0e 00
FP_ADD_INT:
	push hl			;314c	e5
	ld (hl),000h		;314d	36 00
	inc hl			;314f	23
	ld (hl),c		;3150	71
	inc hl			;3151	23
	ld a,e			;3152	7b
	xor c			;3153	a9
l3154h:
	sub c			;3154	91
	ld (hl),a		;3155	77
	inc hl			;3156	23
	ld a,d			;3157	7a
	adc a,c			;3158	89
	xor c			;3159	a9
	ld (hl),a		;315a	77
l315bh:
	inc hl			;315b	23
	ld (hl),000h		;315c	36 00
	pop hl			;315e	e1
	ret			;315f	c9
EVAL_NUMERIC:
	rst 28h			;3160	ef
l3161h:
	jr c,$+128		;3161	38 7e
	and a			;3163	a7
	jr z,$+7		;3164	28 05
	rst 28h			;3166	ef
	and d			;3167	a2
	rrca			;3168	0f
	daa			;3169	27
	jr c,l315bh		;316a	38 ef
	ld (bc),a		;316c	02
	jr c,l3154h		;316d	38 e5
	push de			;316f	d5
	ex de,hl		;3170	eb
	ld b,(hl)		;3171	46
	call FP_PUSH		;3172	cd 3d 31
	xor a			;3175	af
	sub b			;3176	90
	bit 7,c			;3177	cb 79
	ld b,d			;3179	42
	ld c,e			;317a	4b
	ld a,e			;317b	7b
	pop de			;317c	d1
	pop hl			;317d	e1
	ret			;317e	c9
sub_317fh:
	ld d,a			;317f	57
	rla			;3180	17
	sbc a,a			;3181	9f
	ld e,a			;3182	5f
	ld c,a			;3183	4f
	xor a			;3184	af
	ld b,a			;3185	47
l3186h:
	call sub_2e74h		;3186	cd 74 2e
	rst 28h			;3189	ef
	inc (hl)		;318a	34
	rst 28h			;318b	ef
	ld a,(de)		;318c	1a
	jr nz,l3129h		;318d	20 9a
	add a,l			;318f	85
	inc b			;3190	04
	daa			;3191	27
	jr c,l3161h		;3192	38 cd
	ld h,b			;3194	60
	ld sp,0f5d8h		;3195	31 d8 f5
	dec b			;3198	05
	inc b			;3199	04
	jr z,l319fh		;319a	28 03
	pop af			;319c	f1
	scf			;319d	37
	ret			;319e	c9
l319fh:
	pop af			;319f	f1
	ret			;31a0	c9
l31a1h:
	rst 28h			;31a1	ef
	ld sp,00036h		;31a2	31 36 00
	dec bc			;31a5	0b
	ld sp,00037h		;31a6	31 37 00
	dec c			;31a9	0d
	ld (bc),a		;31aa	02
	jr c,$+64		;31ab	38 3e
	jr nc,l3186h		;31ad	30 d7
	ret			;31af	c9
	ld hl,(03e38h)		;31b0	2a 38 3e
	dec l			;31b3	2d
	rst 10h			;31b4	d7
	rst 28h			;31b5	ef
	and b			;31b6	a0
	jp 0c5c4h		;31b7	c3 c4 c5
	ld (bc),a		;31ba	02
	jr c,$-37		;31bb	38 d9
	push hl			;31bd	e5
	exx			;31be	d9
l31bfh:
	rst 28h			;31bf	ef
	ld sp,0c227h		;31c0	31 27 c2
	inc bc			;31c3	03
	jp po,0c201h		;31c4	e2 01 c2
	ld (bc),a		;31c7	02
	jr c,$+128		;31c8	38 7e
	and a			;31ca	a7
	jr nz,l3215h		;31cb	20 48
l31cdh:
	call FP_PUSH		;31cd	cd 3d 31
	ld b,010h		;31d0	06 10
	ld a,d			;31d2	7a
	and a			;31d3	a7
	jr nz,l31dch		;31d4	20 06
	or e			;31d6	b3
	jr z,l31e2h		;31d7	28 09
	ld d,e			;31d9	53
	ld b,008h		;31da	06 08
l31dch:
	push de			;31dc	d5
	exx			;31dd	d9
	pop de			;31de	d1
	exx			;31df	d9
	jr l323ah		;31e0	18 58
l31e2h:
	rst 28h			;31e2	ef
	ld (bc),a		;31e3	02
	jp po,07e38h		;31e4	e2 38 7e
	sub 07eh		;31e7	d6 7e
	call sub_317fh		;31e9	cd 7f 31
	ld d,a			;31ec	57
	ld a,(05cach)		;31ed	3a ac 5c
	sub d			;31f0	92
	ld (05cach),a		;31f1	32 ac 5c
	ld a,d			;31f4	7a
	call l310dh		;31f5	cd 0d 31
	rst 28h			;31f8	ef
	ld sp,0c127h		;31f9	31 27 c1
	inc bc			;31fc	03
	pop hl			;31fd	e1
	jr c,l31cdh		;31fe	38 cd
	sub e			;3200	93
	ld sp,l32e4h+1		;3201	31 e5 32
	and c			;3204	a1
	ld e,h			;3205	5c
	dec a			;3206	3d
	rla			;3207	17
	sbc a,a			;3208	9f
	inc a			;3209	3c
	ld hl,05cabh		;320a	21 ab 5c
	ld (hl),a		;320d	77
	inc hl			;320e	23
	add a,(hl)		;320f	86
	ld (hl),a		;3210	77
	pop hl			;3211	e1
	jp 0328eh		;3212	c3 8e 32
l3215h:
	sub 080h		;3215	d6 80
	cp 01ch			;3217	fe 1c
	jr c,l322eh		;3219	38 13
	call sub_317fh		;321b	cd 7f 31
	sub 007h		;321e	d6 07
	ld b,a			;3220	47
	ld hl,05cach		;3221	21 ac 5c
	add a,(hl)		;3224	86
	ld (hl),a		;3225	77
	ld a,b			;3226	78
	neg			;3227	ed 44
	call l310dh		;3229	cd 0d 31
	jr l31bfh		;322c	18 91
l322eh:
	ex de,hl		;322e	eb
	call sub_3379h		;322f	cd 79 33
	exx			;3232	d9
	set 7,d			;3233	cb fa
	ld a,l			;3235	7d
	exx			;3236	d9
	sub 080h		;3237	d6 80
	ld b,a			;3239	47
l323ah:
	sla e			;323a	cb 23
	rl d			;323c	cb 12
	exx			;323e	d9
	rl e			;323f	cb 13
	rl d			;3241	cb 12
	exx			;3243	d9
	ld hl,05caah		;3244	21 aa 5c
	ld c,005h		;3247	0e 05
l3249h:
	ld a,(hl)		;3249	7e
	adc a,a			;324a	8f
	daa			;324b	27
	ld (hl),a		;324c	77
	dec hl			;324d	2b
	dec c			;324e	0d
	jr nz,l3249h		;324f	20 f8
	djnz l323ah		;3251	10 e7
	xor a			;3253	af
	ld hl,05ca6h		;3254	21 a6 5c
	ld de,05ca1h		;3257	11 a1 5c
	ld b,009h		;325a	06 09
	rld			;325c	ed 6f
	ld c,0ffh		;325e	0e ff
l3260h:
	rld			;3260	ed 6f
	jr nz,l3268h		;3262	20 04
	dec c			;3264	0d
	inc c			;3265	0c
	jr nz,l3272h		;3266	20 0a
l3268h:
	ld (de),a		;3268	12
	inc de			;3269	13
	inc (iy+071h)		;326a	fd 34 71
	inc (iy+072h)		;326d	fd 34 72
	ld c,000h		;3270	0e 00
l3272h:
	bit 0,b			;3272	cb 40
	jr z,l3277h		;3274	28 01
	inc hl			;3276	23
l3277h:
	djnz l3260h		;3277	10 e7
	ld a,(05cabh)		;3279	3a ab 5c
	sub 009h		;327c	d6 09
	jr c,l328ah		;327e	38 0a
	dec (iy+071h)		;3280	fd 35 71
	ld a,004h		;3283	3e 04
	cp (iy+06fh)		;3285	fd be 6f
	jr l32cbh		;3288	18 41
l328ah:
	rst 28h			;328a	ef
	ld (bc),a		;328b	02
	jp po,0eb38h		;328c	e2 38 eb
	call sub_3379h		;328f	cd 79 33
	exx			;3292	d9
	ld a,080h		;3293	3e 80
	sub l			;3295	95
	ld l,000h		;3296	2e 00
	set 7,d			;3298	cb fa
	exx			;329a	d9
	call sub_339ch		;329b	cd 9c 33
l329eh:
	ld a,(iy+071h)		;329e	fd 7e 71
	cp 008h			;32a1	fe 08
	jr c,l32abh		;32a3	38 06
	exx			;32a5	d9
	rl d			;32a6	cb 12
	exx			;32a8	d9
	jr l32cbh		;32a9	18 20
l32abh:
	ld bc,TOK_RETURN		;32ab	01 00 02
l32aeh:
	ld a,e			;32ae	7b
	call sub_334ah		;32af	cd 4a 33
	ld e,a			;32b2	5f
	ld a,d			;32b3	7a
	call sub_334ah		;32b4	cd 4a 33
	ld d,a			;32b7	57
	push bc			;32b8	c5
	exx			;32b9	d9
	pop bc			;32ba	c1
	djnz l32aeh		;32bb	10 f1
	ld hl,05ca1h		;32bd	21 a1 5c
	ld a,c			;32c0	79
	ld c,(iy+071h)		;32c1	fd 4e 71
	add hl,bc		;32c4	09
	ld (hl),a		;32c5	77
	inc (iy+071h)		;32c6	fd 34 71
	jr l329eh		;32c9	18 d3
l32cbh:
	push af			;32cb	f5
l32cch:
	ld hl,05ca1h		;32cc	21 a1 5c
	ld c,(iy+071h)		;32cf	fd 4e 71
	ld b,000h		;32d2	06 00
	add hl,bc		;32d4	09
	ld b,c			;32d5	41
	pop af			;32d6	f1
l32d7h:
	dec hl			;32d7	2b
	ld a,(hl)		;32d8	7e
	adc a,000h		;32d9	ce 00
	ld (hl),a		;32db	77
	and a			;32dc	a7
	jr z,l32e4h		;32dd	28 05
	cp 00ah			;32df	fe 0a
	ccf			;32e1	3f
	jr nc,l32ech		;32e2	30 08
l32e4h:
	djnz l32d7h		;32e4	10 f1
	ld (hl),001h		;32e6	36 01
	inc b			;32e8	04
	inc (iy+072h)		;32e9	fd 34 72
l32ech:
	ld (iy+071h),b		;32ec	fd 70 71
	rst 28h			;32ef	ef
	ld (bc),a		;32f0	02
	jr c,l32cch		;32f1	38 d9
	pop hl			;32f3	e1
	exx			;32f4	d9
	ld bc,(05cabh)		;32f5	ed 4b ab 5c
	ld hl,05ca1h		;32f9	21 a1 5c
	ld a,b			;32fc	78
	cp 009h			;32fd	fe 09
	jr c,l3305h		;32ff	38 04
	cp 0fch			;3301	fe fc
	jr c,l332bh		;3303	38 26
l3305h:
	and a			;3305	a7
	call z,PRINT_DIGIT	;3306	cc ea 11
sub_3309h:
	xor a			;3309	af
	sub b			;330a	90
	jp m,l3311h		;330b	fa 11 33
	ld b,a			;330e	47
	jr l331dh		;330f	18 0c
l3311h:
	ld a,c			;3311	79
	and a			;3312	a7
	jr z,l3318h		;3313	28 03
	ld a,(hl)		;3315	7e
	inc hl			;3316	23
	dec c			;3317	0d
l3318h:
	call PRINT_DIGIT		;3318	cd ea 11
	djnz l3311h		;331b	10 f4
l331dh:
	ld a,c			;331d	79
	and a			;331e	a7
	ret z			;331f	c8
	inc b			;3320	04
	ld a,02eh		;3321	3e 2e
l3323h:
	rst 10h			;3323	d7
	ld a,030h		;3324	3e 30
	djnz l3323h		;3326	10 fb
	ld b,c			;3328	41
	jr l3311h		;3329	18 e6
l332bh:
	ld d,b			;332b	50
	dec d			;332c	15
	ld b,001h		;332d	06 01
	call sub_3309h		;332f	cd 09 33
	ld a,045h		;3332	3e 45
CALC_REF2:
	rst 10h			;3334	d7
	ld c,d			;3335	4a
	ld a,c			;3336	79
	and a			;3337	a7
	jp p,l3342h		;3338	f2 42 33
	neg			;333b	ed 44
	ld c,a			;333d	4f
	ld a,02dh		;333e	3e 2d
	jr l3344h		;3340	18 02
l3342h:
	ld a,02bh		;3342	3e 2b
l3344h:
	rst 10h			;3344	d7
	ld b,000h		;3345	06 00
	jp PRINT_NUM		;3347	c3 88 17
sub_334ah:
	push de			;334a	d5
	ld l,a			;334b	6f
	ld h,000h		;334c	26 00
	ld e,l			;334e	5d
	ld d,h			;334f	54
	add hl,hl		;3350	29
	add hl,hl		;3351	29
	add hl,de		;3352	19
	add hl,hl		;3353	29
	ld e,c			;3354	59
	add hl,de		;3355	19
	ld c,h			;3356	4c
	ld a,l			;3357	7d
	pop de			;3358	d1
	ret			;3359	c9
sub_335ah:
	ld a,(hl)		;335a	7e
	ld (hl),000h		;335b	36 00
	and a			;335d	a7
	ret z			;335e	c8
	inc hl			;335f	23
	bit 7,(hl)		;3360	cb 7e
	set 7,(hl)		;3362	cb fe
	dec hl			;3364	2b
	ret z			;3365	c8
	push bc			;3366	c5
	ld bc,LROS_CALL+1		;3367	01 05 00
	add hl,bc		;336a	09
	ld b,c			;336b	41
	ld c,a			;336c	4f
	scf			;336d	37
l336eh:
	dec hl			;336e	2b
	ld a,(hl)		;336f	7e
	cpl			;3370	2f
	adc a,000h		;3371	ce 00
	ld (hl),a		;3373	77
	djnz l336eh		;3374	10 f8
	ld a,c			;3376	79
	pop bc			;3377	c1
	ret			;3378	c9
sub_3379h:
	push hl			;3379	e5
	push af			;337a	f5
	ld c,(hl)		;337b	4e
	inc hl			;337c	23
	ld b,(hl)		;337d	46
	ld (hl),a		;337e	77
	inc hl			;337f	23
	ld a,c			;3380	79
	ld c,(hl)		;3381	4e
	push bc			;3382	c5
	inc hl			;3383	23
	ld c,(hl)		;3384	4e
	inc hl			;3385	23
	ld b,(hl)		;3386	46
	ex de,hl		;3387	eb
	ld d,a			;3388	57
	ld e,(hl)		;3389	5e
	push de			;338a	d5
	inc hl			;338b	23
	ld d,(hl)		;338c	56
	inc hl			;338d	23
	ld e,(hl)		;338e	5e
	push de			;338f	d5
	exx			;3390	d9
	pop de			;3391	d1
	pop hl			;3392	e1
	pop bc			;3393	c1
	exx			;3394	d9
	inc hl			;3395	23
	ld d,(hl)		;3396	56
	inc hl			;3397	23
	ld e,(hl)		;3398	5e
	pop af			;3399	f1
	pop hl			;339a	e1
	ret			;339b	c9
sub_339ch:
	and a			;339c	a7
	ret z			;339d	c8
	cp 021h			;339e	fe 21
	jr nc,l33b8h		;33a0	30 16
	push bc			;33a2	c5
	ld b,a			;33a3	47
l33a4h:
	exx			;33a4	d9
	sra l			;33a5	cb 2d
	rr d			;33a7	cb 1a
	rr e			;33a9	cb 1b
	exx			;33ab	d9
	rr d			;33ac	cb 1a
	rr e			;33ae	cb 1b
	djnz l33a4h		;33b0	10 f2
	pop bc			;33b2	c1
	ret nc			;33b3	d0
	call sub_33c3h		;33b4	cd c3 33
	ret nz			;33b7	c0
l33b8h:
	exx			;33b8	d9
	xor a			;33b9	af
sub_33bah:
	ld l,000h		;33ba	2e 00
	ld d,a			;33bc	57
	ld e,l			;33bd	5d
	exx			;33be	d9
	ld de,LROS_HEADER		;33bf	11 00 00
	ret			;33c2	c9
sub_33c3h:
	inc e			;33c3	1c
	ret nz			;33c4	c0
	inc d			;33c5	14
	ret nz			;33c6	c0
	exx			;33c7	d9
	inc e			;33c8	1c
	jr nz,l33cch		;33c9	20 01
	inc d			;33cb	14
l33cch:
	exx			;33cc	d9
	ret			;33cd	c9
sub_33ceh:
	ex de,hl		;33ce	eb
	call sub_382dh		;33cf	cd 2d 38
	ex de,hl		;33d2	eb
	ld a,(de)		;33d3	1a
	or (hl)			;33d4	b6
	jr nz,l33fdh		;33d5	20 26
	push de			;33d7	d5
	inc hl			;33d8	23
	push hl			;33d9	e5
	inc hl			;33da	23
	ld e,(hl)		;33db	5e
	inc hl			;33dc	23
	ld d,(hl)		;33dd	56
	inc hl			;33de	23
	inc hl			;33df	23
	inc hl			;33e0	23
	ld a,(hl)		;33e1	7e
	inc hl			;33e2	23
	ld c,(hl)		;33e3	4e
	inc hl			;33e4	23
	ld b,(hl)		;33e5	46
	pop hl			;33e6	e1
	ex de,hl		;33e7	eb
	add hl,bc		;33e8	09
	ex de,hl		;33e9	eb
	adc a,(hl)		;33ea	8e
	rrca			;33eb	0f
	adc a,000h		;33ec	ce 00
	jr nz,l33fbh		;33ee	20 0b
	sbc a,a			;33f0	9f
	ld (hl),a		;33f1	77
	inc hl			;33f2	23
	ld (hl),e		;33f3	73
	inc hl			;33f4	23
	ld (hl),d		;33f5	72
	dec hl			;33f6	2b
	dec hl			;33f7	2b
	dec hl			;33f8	2b
	pop de			;33f9	d1
	ret			;33fa	c9
l33fbh:
	dec hl			;33fb	2b
	pop de			;33fc	d1
l33fdh:
	call FP_NORMALIZE		;33fd	cd 52 36
	exx			;3400	d9
	push hl			;3401	e5
	exx			;3402	d9
	push de			;3403	d5
	push hl			;3404	e5
l3405h:
	call sub_335ah		;3405	cd 5a 33
	ld b,a			;3408	47
	ex de,hl		;3409	eb
	call sub_335ah		;340a	cd 5a 33
	ld c,a			;340d	4f
	cp b			;340e	b8
	jr nc,l3414h		;340f	30 03
	ld a,b			;3411	78
	ld b,c			;3412	41
	ex de,hl		;3413	eb
l3414h:
	push af			;3414	f5
	sub b			;3415	90
	call sub_3379h		;3416	cd 79 33
	call sub_339ch		;3419	cd 9c 33
	pop af			;341c	f1
	pop hl			;341d	e1
	ld (hl),a		;341e	77
	push hl			;341f	e5
	ld l,b			;3420	68
	ld h,c			;3421	61
	add hl,de		;3422	19
	exx			;3423	d9
	ex de,hl		;3424	eb
	adc hl,bc		;3425	ed 4a
	ex de,hl		;3427	eb
l3428h:
	ld a,h			;3428	7c
	adc a,l			;3429	8d
	ld l,a			;342a	6f
	rra			;342b	1f
	xor l			;342c	ad
	exx			;342d	d9
	ex de,hl		;342e	eb
	pop hl			;342f	e1
	rra			;3430	1f
l3431h:
	jr nc,l343bh		;3431	30 08
	ld a,001h		;3433	3e 01
	call sub_339ch		;3435	cd 9c 33
l3438h:
	inc (hl)		;3438	34
	jr z,l345eh		;3439	28 23
l343bh:
	exx			;343b	d9
	ld a,l			;343c	7d
	and 080h		;343d	e6 80
	exx			;343f	d9
	inc hl			;3440	23
	ld (hl),a		;3441	77
	dec hl			;3442	2b
	jr z,l3464h		;3443	28 1f
	ld a,e			;3445	7b
	neg			;3446	ed 44
	ccf			;3448	3f
	ld e,a			;3449	5f
	ld a,d			;344a	7a
	cpl			;344b	2f
	adc a,000h		;344c	ce 00
	ld d,a			;344e	57
	exx			;344f	d9
	ld a,e			;3450	7b
	cpl			;3451	2f
	adc a,000h		;3452	ce 00
	ld e,a			;3454	5f
	ld a,d			;3455	7a
	cpl			;3456	2f
	adc a,000h		;3457	ce 00
	jr nc,l3462h		;3459	30 07
	rra			;345b	1f
	exx			;345c	d9
	inc (hl)		;345d	34
l345eh:
	jp z,l356ch		;345e	ca 6c 35
	exx			;3461	d9
l3462h:
	ld d,a			;3462	57
	exx			;3463	d9
l3464h:
	xor a			;3464	af
	jp l3514h		;3465	c3 14 35
FP_TEST:
	push bc			;3468	c5
	ld b,010h		;3469	06 10
	ld a,h			;346b	7c
	ld c,l			;346c	4d
	ld hl,LROS_HEADER		;346d	21 00 00
l3470h:
	add hl,hl		;3470	29
	jr c,l347dh		;3471	38 0a
	rl c			;3473	cb 11
	rla			;3475	17
	jr nc,l347bh		;3476	30 03
	add hl,de		;3478	19
	jr c,l347dh		;3479	38 02
l347bh:
	djnz l3470h		;347b	10 f3
l347dh:
	pop bc			;347d	c1
	ret			;347e	c9
sub_347fh:
	call sub_3904h		;347f	cd 04 39
	ret c			;3482	d8
	inc hl			;3483	23
	xor (hl)		;3484	ae
	set 7,(hl)		;3485	cb fe
	dec hl			;3487	2b
	ret			;3488	c9
	ld a,(de)		;3489	1a
	or (hl)			;348a	b6
	jr nz,l34afh		;348b	20 22
	push de			;348d	d5
	push hl			;348e	e5
	push de			;348f	d5
	call FP_PUSH		;3490	cd 3d 31
	ex de,hl		;3493	eb
	ex (sp),hl		;3494	e3
	ld b,c			;3495	41
	call FP_PUSH		;3496	cd 3d 31
	ld a,b			;3499	78
	xor c			;349a	a9
	ld c,a			;349b	4f
	pop hl			;349c	e1
	call FP_TEST		;349d	cd 68 34
	ex de,hl		;34a0	eb
	pop hl			;34a1	e1
	jr c,l34aeh		;34a2	38 0a
	ld a,d			;34a4	7a
	or e			;34a5	b3
	jr nz,l34a9h		;34a6	20 01
	ld c,a			;34a8	4f
l34a9h:
	call FP_ADD_INT		;34a9	cd 4c 31
	pop de			;34ac	d1
	ret			;34ad	c9
l34aeh:
	pop de			;34ae	d1
l34afh:
	call FP_NORMALIZE		;34af	cd 52 36
	xor a			;34b2	af
	call sub_347fh		;34b3	cd 7f 34
	ret c			;34b6	d8
	exx			;34b7	d9
	push hl			;34b8	e5
	exx			;34b9	d9
	push de			;34ba	d5
	ex de,hl		;34bb	eb
	call sub_347fh		;34bc	cd 7f 34
	ex de,hl		;34bf	eb
	jr c,l351ch		;34c0	38 5a
	push hl			;34c2	e5
	call sub_3379h		;34c3	cd 79 33
	ld a,b			;34c6	78
	and a			;34c7	a7
	sbc hl,hl		;34c8	ed 62
	exx			;34ca	d9
	push hl			;34cb	e5
	sbc hl,hl		;34cc	ed 62
	exx			;34ce	d9
	ld b,021h		;34cf	06 21
	jr l34e4h		;34d1	18 11
l34d3h:
	jr nc,l34dah		;34d3	30 05
	add hl,de		;34d5	19
	exx			;34d6	d9
	adc hl,de		;34d7	ed 5a
	exx			;34d9	d9
l34dah:
	exx			;34da	d9
	rr h			;34db	cb 1c
	rr l			;34dd	cb 1d
	exx			;34df	d9
	rr h			;34e0	cb 1c
	rr l			;34e2	cb 1d
l34e4h:
	exx			;34e4	d9
	rr b			;34e5	cb 18
	rr c			;34e7	cb 19
	exx			;34e9	d9
	rr c			;34ea	cb 19
	rra			;34ec	1f
	djnz l34d3h		;34ed	10 e4
	ex de,hl		;34ef	eb
	exx			;34f0	d9
	ex de,hl		;34f1	eb
	exx			;34f2	d9
	pop bc			;34f3	c1
	pop hl			;34f4	e1
	ld a,b			;34f5	78
	add a,c			;34f6	81
	jr nz,l34fah		;34f7	20 01
	and a			;34f9	a7
l34fah:
	dec a			;34fa	3d
	ccf			;34fb	3f
l34fch:
	rla			;34fc	17
	ccf			;34fd	3f
	rra			;34fe	1f
	jp p,l3505h		;34ff	f2 05 35
	jr nc,l356ch		;3502	30 68
	and a			;3504	a7
l3505h:
	inc a			;3505	3c
	jr nz,l3510h		;3506	20 08
	jr c,l3510h		;3508	38 06
	exx			;350a	d9
	bit 7,d			;350b	cb 7a
	exx			;350d	d9
	jr nz,l356ch		;350e	20 5c
l3510h:
	ld (hl),a		;3510	77
	exx			;3511	d9
	ld a,b			;3512	78
	exx			;3513	d9
l3514h:
	jr nc,l352bh		;3514	30 15
	ld a,(hl)		;3516	7e
	and a			;3517	a7
l3518h:
	ld a,080h		;3518	3e 80
	jr z,l351dh		;351a	28 01
l351ch:
	xor a			;351c	af
l351dh:
	exx			;351d	d9
	and d			;351e	a2
	call sub_33bah		;351f	cd ba 33
	rlca			;3522	07
	ld (hl),a		;3523	77
	jr c,l3554h		;3524	38 2e
	inc hl			;3526	23
	ld (hl),a		;3527	77
	dec hl			;3528	2b
	jr l3554h		;3529	18 29
l352bh:
	ld b,020h		;352b	06 20
l352dh:
	exx			;352d	d9
	bit 7,d			;352e	cb 7a
	exx			;3530	d9
	jr nz,l3545h		;3531	20 12
	rlca			;3533	07
	rl e			;3534	cb 13
	rl d			;3536	cb 12
	exx			;3538	d9
	rl e			;3539	cb 13
	rl d			;353b	cb 12
	exx			;353d	d9
	dec (hl)		;353e	35
	jr z,l3518h		;353f	28 d7
	djnz l352dh		;3541	10 ea
	jr l351ch		;3543	18 d7
l3545h:
	rla			;3545	17
	jr nc,l3554h		;3546	30 0c
	call sub_33c3h		;3548	cd c3 33
	jr nz,l3554h		;354b	20 07
	exx			;354d	d9
	ld d,080h		;354e	16 80
	exx			;3550	d9
	inc (hl)		;3551	34
	jr z,l356ch		;3552	28 18
l3554h:
	push hl			;3554	e5
	inc hl			;3555	23
	exx			;3556	d9
	push de			;3557	d5
	exx			;3558	d9
	pop bc			;3559	c1
	ld a,b			;355a	78
	rla			;355b	17
	rl (hl)			;355c	cb 16
	rra			;355e	1f
	ld (hl),a		;355f	77
	inc hl			;3560	23
	ld (hl),c		;3561	71
	inc hl			;3562	23
	ld (hl),d		;3563	72
	inc hl			;3564	23
	ld (hl),e		;3565	73
	pop hl			;3566	e1
	pop de			;3567	d1
	exx			;3568	d9
	pop hl			;3569	e1
	exx			;356a	d9
	ret			;356b	c9
l356ch:
	rst 8			;356c	cf
	dec b			;356d	05
	call FP_NORMALIZE		;356e	cd 52 36
	ex de,hl		;3571	eb
	xor a			;3572	af
	call sub_347fh		;3573	cd 7f 34
	jr c,l356ch		;3576	38 f4
	ex de,hl		;3578	eb
	call sub_347fh		;3579	cd 7f 34
	ret c			;357c	d8
	exx			;357d	d9
	push hl			;357e	e5
	exx			;357f	d9
	push de			;3580	d5
	push hl			;3581	e5
	call sub_3379h		;3582	cd 79 33
	exx			;3585	d9
	push hl			;3586	e5
	ld h,b			;3587	60
	ld l,c			;3588	69
	exx			;3589	d9
	ld h,c			;358a	61
	ld l,b			;358b	68
	xor a			;358c	af
	ld b,0dfh		;358d	06 df
	jr l35a1h		;358f	18 10
FP_SUB:
	rla			;3591	17
	rl c			;3592	cb 11
	exx			;3594	d9
	rl c			;3595	cb 11
	rl b			;3597	cb 10
	exx			;3599	d9
FP_RET:
	add hl,hl		;359a	29
	exx			;359b	d9
	adc hl,hl		;359c	ed 6a
	exx			;359e	d9
	jr c,l35b1h		;359f	38 10
l35a1h:
	sbc hl,de		;35a1	ed 52
	exx			;35a3	d9
	sbc hl,de		;35a4	ed 52
	exx			;35a6	d9
	jr nc,l35b8h		;35a7	30 0f
	add hl,de		;35a9	19
	exx			;35aa	d9
	adc hl,de		;35ab	ed 5a
	exx			;35ad	d9
	and a			;35ae	a7
	jr FP_ADD		;35af	18 08
l35b1h:
	and a			;35b1	a7
	sbc hl,de		;35b2	ed 52
	exx			;35b4	d9
	sbc hl,de		;35b5	ed 52
	exx			;35b7	d9
l35b8h:
	scf			;35b8	37
FP_ADD:
	inc b			;35b9	04
	jp m,FP_SUB		;35ba	fa 91 35
	push af			;35bd	f5
	jr z,FP_RET		;35be	28 da
	ld e,a			;35c0	5f
	ld d,c			;35c1	51
	exx			;35c2	d9
	ld e,c			;35c3	59
	ld d,b			;35c4	50
	pop af			;35c5	f1
	rr b			;35c6	cb 18
	pop af			;35c8	f1
	rr b			;35c9	cb 18
	exx			;35cb	d9
	pop bc			;35cc	c1
	pop hl			;35cd	e1
	ld a,b			;35ce	78
	sub c			;35cf	91
	jp l34fch		;35d0	c3 fc 34
	ld a,(hl)		;35d3	7e
	and a			;35d4	a7
	ret z			;35d5	c8
	cp 081h			;35d6	fe 81
	jr nc,FP_SMALL		;35d8	30 06
	ld (hl),000h		;35da	36 00
	ld a,020h		;35dc	3e 20
	jr FP_TRUNC		;35de	18 51
FP_SMALL:
	cp 091h			;35e0	fe 91
	jr nz,FP_SHIFT		;35e2	20 1a
	inc hl			;35e4	23
	inc hl			;35e5	23
	inc hl			;35e6	23
	ld a,080h		;35e7	3e 80
	and (hl)		;35e9	a6
	dec hl			;35ea	2b
	or (hl)			;35eb	b6
	dec hl			;35ec	2b
	jr nz,FP_NEG		;35ed	20 03
	ld a,080h		;35ef	3e 80
	xor (hl)		;35f1	ae
FP_NEG:
	dec hl			;35f2	2b
	jr nz,FP_CARRY		;35f3	20 36
	ld (hl),a		;35f5	77
	inc hl			;35f6	23
	ld (hl),0ffh		;35f7	36 ff
	dec hl			;35f9	2b
	ld a,018h		;35fa	3e 18
	jr FP_TRUNC		;35fc	18 33
FP_SHIFT:
	jr nc,FP_SUB_A0		;35fe	30 2c
	push de			;3600	d5
	cpl			;3601	2f
	add a,091h		;3602	c6 91
	inc hl			;3604	23
	ld d,(hl)		;3605	56
	inc hl			;3606	23
	ld e,(hl)		;3607	5e
	dec hl			;3608	2b
	dec hl			;3609	2b
	ld c,000h		;360a	0e 00
	bit 7,d			;360c	cb 7a
	jr z,FP_SET7		;360e	28 01
	dec c			;3610	0d
FP_SET7:
	set 7,d			;3611	cb fa
	ld b,008h		;3613	06 08
	sub b			;3615	90
	add a,b			;3616	80
	jr c,FP_ZERO		;3617	38 04
	ld e,d			;3619	5a
	ld d,000h		;361a	16 00
	sub b			;361c	90
FP_ZERO:
	jr z,FP_ROUND		;361d	28 07
	ld b,a			;361f	47
FP_SHR_LP:
	srl d			;3620	cb 3a
	rr e			;3622	cb 1b
	djnz FP_SHR_LP		;3624	10 fa
FP_ROUND:
	call FP_ADD_INT		;3626	cd 4c 31
	pop de			;3629	d1
	ret			;362a	c9
FP_CARRY:
	ld a,(hl)		;362b	7e
FP_SUB_A0:
	sub 0a0h		;362c	d6 a0
	ret p			;362e	f0
	neg			;362f	ed 44
FP_TRUNC:
	push de			;3631	d5
	ex de,hl		;3632	eb
	dec hl			;3633	2b
	ld b,a			;3634	47
	srl b			;3635	cb 38
	srl b			;3637	cb 38
	srl b			;3639	cb 38
	jr z,FP_BIT		;363b	28 05
FP_ZERO_LP:
	ld (hl),000h		;363d	36 00
	dec hl			;363f	2b
	djnz FP_ZERO_LP		;3640	10 fb
FP_BIT:
	and 007h		;3642	e6 07
	jr z,FP_DONE		;3644	28 09
	ld b,a			;3646	47
	ld a,0ffh		;3647	3e ff
l3649h:
	sla a			;3649	cb 27
	djnz l3649h		;364b	10 fc
	and (hl)		;364d	a6
	ld (hl),a		;364e	77
FP_DONE:
	ex de,hl		;364f	eb
	pop de			;3650	d1
	ret			;3651	c9
FP_NORMALIZE:
	call FP_NORM_HALF		;3652	cd 55 36
FP_NORM_HALF:
	ex de,hl		;3655	eb
FP_NORM_LP:
	ld a,(hl)		;3656	7e
	and a			;3657	a7
	ret nz			;3658	c0
	push de			;3659	d5
	call FP_PUSH		;365a	cd 3d 31
	xor a			;365d	af
	inc hl			;365e	23
	ld (hl),a		;365f	77
	dec hl			;3660	2b
	ld (hl),a		;3661	77
	ld b,091h		;3662	06 91
	ld a,d			;3664	7a
	and a			;3665	a7
	jr nz,FP_NORM2		;3666	20 08
	or e			;3668	b3
	ld b,d			;3669	42
	jr z,FP_STORE		;366a	28 10
	ld d,e			;366c	53
	ld e,b			;366d	58
	ld b,089h		;366e	06 89
FP_NORM2:
	ex de,hl		;3670	eb
FP_NORM3:
	dec b			;3671	05
	add hl,hl		;3672	29
	jr nc,FP_NORM3		;3673	30 fc
	rrc c			;3675	cb 09
	rr h			;3677	cb 1c
	rr l			;3679	cb 1d
	ex de,hl		;367b	eb
FP_STORE:
	dec hl			;367c	2b
	ld (hl),e		;367d	73
	dec hl			;367e	2b
	ld (hl),d		;367f	72
	dec hl			;3680	2b
	ld (hl),b		;3681	70
	pop de			;3682	d1
	ret			;3683	c9
CONST_TABLE:
	nop			;3684	00
	or b			;3685	b0
	nop			;3686	00
	ld b,b			;3687	40
	or b			;3688	b0
	nop			;3689	00
	ld bc,ALLOCBC		;368a	01 30 00
	pop af			;368d	f1
	ld c,c			;368e	49
	rrca			;368f	0f
	jp c,040a2h		;3690	da a2 40
	or b			;3693	b0
	nop			;3694	00
	ld a,(bc)		;3695	0a
FP_TABLE:
	xor d			;3696	aa
	ld a,(FP_TABLE2)		;3697	3a fb 37
	ld h,b			;369a	60
	scf			;369b	37
	adc a,033h		;369c	ce 33
	adc a,c			;369e	89
	inc (hl)		;369f	34
	ld l,(hl)		;36a0	6e
	dec (hl)		;36a1	35
	ld l,h			;36a2	6c
	inc a			;36a3	3c
	ld (hl),039h		;36a4	36 39
	ccf			;36a6	3f
	add hl,sp		;36a7	39
	ld d,(hl)		;36a8	56
	add hl,sp		;36a9	39
	ld d,(hl)		;36aa	56
	add hl,sp		;36ab	39
	ld d,(hl)		;36ac	56
	add hl,sp		;36ad	39
	ld d,(hl)		;36ae	56
	add hl,sp		;36af	39
	ld d,(hl)		;36b0	56
	add hl,sp		;36b1	39
	ld d,(hl)		;36b2	56
	add hl,sp		;36b3	39
	out (033h),a		;36b4	d3 33
	ld c,b			;36b6	48
	add hl,sp		;36b7	39
	ld d,(hl)		;36b8	56
	add hl,sp		;36b9	39
	ld d,(hl)		;36ba	56
	add hl,sp		;36bb	39
	ld d,(hl)		;36bc	56
	add hl,sp		;36bd	39
	ld d,(hl)		;36be	56
	add hl,sp		;36bf	39
	ld d,(hl)		;36c0	56
	add hl,sp		;36c1	39
	ld d,(hl)		;36c2	56
	add hl,sp		;36c3	39
	or a			;36c4	b7
	add hl,sp		;36c5	39
	ld sp,hl		;36c6	f9
	add hl,sp		;36c7	39
	rst 10h			;36c8	d7
	jr c,l372bh		;36c9	38 60
	ld a,(sub_382dh)	;36cb	3a 2d 38
	add a,h			;36ce	84
	ld a,(l39f9h)		;36cf	3a f9 39
	adc a,a			;36d2	8f
	ld a,(l3bd0h)		;36d3	3a d0 3b
	push bc			;36d6	c5
	dec sp			;36d7	3b
	push af			;36d8	f5
	dec sp			;36d9	3b
	ld c,(hl)		;36da	4e
	inc a			;36db	3c
	ld e,(hl)		;36dc	5e
	inc a			;36dd	3c
	defb 0fdh,03bh,02eh ;illegal sequence	;36de	fd 3b 2e
	dec sp			;36e1	3b
	rst 18h			;36e2	df
	ld a,(l3acah)		;36e3	3a ca 3a
	ld h,l			;36e6	65
	inc a			;36e7	3c
	ld d,c			;36e8	51
	jr c,$+43		;36e9	38 29
	jr c,$+109		;36eb	38 6b
	jr c,l3753h		;36ed	38 64
l36efh:
	jr c,$+116		;36ef	38 72
	jr c,l372dh		;36f1	38 3a
	ld a,(l39e4h)		;36f3	3a e4 39
	inc e			;36f6	1c
	add hl,sp		;36f7	39
	ld a,a			;36f8	7f
	scf			;36f9	37
	cp e			;36fa	bb
	ld a,(l3aa1h)		;36fb	3a a1 3a
	add a,l			;36fe	85
	scf			;36ff	37
	sub l			;3700	95
	ld a,(l3921h)		;3701	3a 21 39
	inc d			;3704	14
	add hl,sp		;3705	39
	or (hl)			;3706	b6
	ld a,(l3b9eh)		;3707	3a 9e 3b
	out (035h),a		;370a	d3 35
	ld h,c			;370c	61
	scf			;370d	37
	dec c			;370e	0d
	ld sp,FP_NORM_LP		;370f	31 56 36
	ex af,af'		;3712	08
	jr c,l36efh		;3713	38 da
	scf			;3715	37
	call pe,0ce37h		;3716	ec 37 ce
	scf			;3719	37
l371ah:
	call sub_39dah		;371a	cd da 39
sub_371dh:
	ld a,b			;371d	78
	ld (05c67h),a		;371e	32 67 5c
sub_3721h:
	exx			;3721	d9
	ex (sp),hl		;3722	e3
	exx			;3723	d9
l3724h:
	ld (05c65h),de		;3724	ed 53 65 5c  ; STKEND
	exx			;3728	d9
	ld a,(hl)		;3729	7e
	inc hl			;372a	23
l372bh:
	push hl			;372b	e5
	and a			;372c	a7
l372dh:
	jp p,l373fh		;372d	f2 3f 37
	ld d,a			;3730	57
	and 060h		;3731	e6 60
	rrca			;3733	0f
	rrca			;3734	0f
	rrca			;3735	0f
	rrca			;3736	0f
	add a,07ch		;3737	c6 7c
	ld l,a			;3739	6f
	ld a,d			;373a	7a
	and 01fh		;373b	e6 1f
	jr l374dh		;373d	18 0e
l373fh:
	cp 018h			;373f	fe 18
	jr nc,l374bh		;3741	30 08
	exx			;3743	d9
	ld bc,0fffbh		;3744	01 fb ff
	ld d,h			;3747	54
	ld e,l			;3748	5d
	add hl,bc		;3749	09
	exx			;374a	d9
l374bh:
	rlca			;374b	07
	ld l,a			;374c	6f
l374dh:
	ld de,FP_TABLE		;374d	11 96 36
	ld h,000h		;3750	26 00
	add hl,de		;3752	19
l3753h:
	ld e,(hl)		;3753	5e
	inc hl			;3754	23
	ld d,(hl)		;3755	56
	ld hl,l3724h		;3756	21 24 37
	ex (sp),hl		;3759	e3
	push de			;375a	d5
	exx			;375b	d9
	ld bc,(05c66h)		;375c	ed 4b 66 5c
	ret			;3760	c9
	pop af			;3761	f1
	ld a,(05c67h)		;3762	3a 67 5c
	exx			;3765	d9
	jr l372bh		;3766	18 c3
sub_3768h:
	push de			;3768	d5
	push hl			;3769	e5
	ld bc,LROS_CALL+1		;376a	01 05 00
	call TEST_ROOM		;376d	cd bb 1f
	pop hl			;3770	e1
	pop de			;3771	d1
	ret			;3772	c9
STK_M:
	ld de,(05c65h)		;3773	ed 5b 65 5c  ; STKEND
	call sub_377fh		;3777	cd 7f 37
	ld (05c65h),de		;377a	ed 53 65 5c  ; STKEND
	ret			;377e	c9
sub_377fh:
	call sub_3768h		;377f	cd 68 37
	ldir			;3782	ed b0
	ret			;3784	c9
	ld h,d			;3785	62
	ld l,e			;3786	6b
sub_3787h:
	call sub_3768h		;3787	cd 68 37
	exx			;378a	d9
	push hl			;378b	e5
	exx			;378c	d9
	ex (sp),hl		;378d	e3
	push bc			;378e	c5
	ld a,(hl)		;378f	7e
	and 0c0h		;3790	e6 c0
	rlca			;3792	07
	rlca			;3793	07
	ld c,a			;3794	4f
	inc c			;3795	0c
	ld a,(hl)		;3796	7e
	and 03fh		;3797	e6 3f
	jr nz,l379dh		;3799	20 02
	inc hl			;379b	23
	ld a,(hl)		;379c	7e
l379dh:
	add a,050h		;379d	c6 50
	ld (de),a		;379f	12
	ld a,005h		;37a0	3e 05
	sub c			;37a2	91
	inc hl			;37a3	23
	inc de			;37a4	13
	ld b,000h		;37a5	06 00
	ldir			;37a7	ed b0
	pop bc			;37a9	c1
	ex (sp),hl		;37aa	e3
	exx			;37ab	d9
	pop hl			;37ac	e1
	exx			;37ad	d9
	ld b,a			;37ae	47
	xor a			;37af	af
l37b0h:
	dec b			;37b0	05
	ret z			;37b1	c8
	ld (de),a		;37b2	12
	inc de			;37b3	13
	jr l37b0h		;37b4	18 fa
sub_37b6h:
	and a			;37b6	a7
l37b7h:
	ret z			;37b7	c8
	push af			;37b8	f5
	push de			;37b9	d5
	ld de,LROS_HEADER		;37ba	11 00 00
	call sub_3787h		;37bd	cd 87 37
	pop de			;37c0	d1
	pop af			;37c1	f1
	dec a			;37c2	3d
	jr l37b7h		;37c3	18 f2
HL_5A:
	ld c,a			;37c5	4f
	rlca			;37c6	07
	rlca			;37c7	07
	add a,c			;37c8	81
	ld c,a			;37c9	4f
	ld b,000h		;37ca	06 00
	add hl,bc		;37cc	09
	ret			;37cd	c9
	push de			;37ce	d5
	ld hl,(05c68h)		;37cf	2a 68 5c  ; MEM
	call HL_5A		;37d2	cd c5 37
	call sub_377fh		;37d5	cd 7f 37
	pop hl			;37d8	e1
	ret			;37d9	c9
	ld h,d			;37da	62
	ld l,e			;37db	6b
	exx			;37dc	d9
	push hl			;37dd	e5
	ld hl,CONST_TABLE		;37de	21 84 36
	exx			;37e1	d9
	call sub_37b6h		;37e2	cd b6 37
	call sub_3787h		;37e5	cd 87 37
	exx			;37e8	d9
	pop hl			;37e9	e1
	exx			;37ea	d9
	ret			;37eb	c9
	push hl			;37ec	e5
	ex de,hl		;37ed	eb
	ld hl,(05c68h)		;37ee	2a 68 5c  ; MEM
	call HL_5A		;37f1	cd c5 37
	ex de,hl		;37f4	eb
	call sub_377fh		;37f5	cd 7f 37
	ex de,hl		;37f8	eb
	pop hl			;37f9	e1
	ret			;37fa	c9
FP_TABLE2:
	ld b,005h		;37fb	06 05
l37fdh:
	ld a,(de)		;37fd	1a
	ld c,(hl)		;37fe	4e
	ex de,hl		;37ff	eb
	ld (de),a		;3800	12
	ld (hl),c		;3801	71
l3802h:
	inc hl			;3802	23
	inc de			;3803	13
l3804h:
	djnz l37fdh		;3804	10 f7
	ex de,hl		;3806	eb
	ret			;3807	c9
	ld b,a			;3808	47
	call sub_371dh		;3809	cd 1d 37
	ld sp,0c00fh		;380c	31 0f c0
l380fh:
	ld (bc),a		;380f	02
	and b			;3810	a0
	jp nz,0e031h		;3811	c2 31 e0
	inc b			;3814	04
	jp po,KEY_89+1		;3815	e2 c1 03
	jr c,$-49		;3818	38 cd
	add a,l			;381a	85
	scf			;381b	37
	call sub_3721h		;381c	cd 21 37
	rrca			;381f	0f
	ld bc,K_SCAN_RET		;3820	01 c2 02
	dec (hl)		;3823	35
	xor 0e1h		;3824	ee e1
	inc bc			;3826	03
	jr c,$-53		;3827	38 c9
	ld b,0ffh		;3829	06 ff
	jr l3833h		;382b	18 06
sub_382dh:
	call sub_3904h		;382d	cd 04 39
	ret c			;3830	d8
	ld b,000h		;3831	06 00
l3833h:
	ld a,(hl)		;3833	7e
	and a			;3834	a7
	jr z,l3842h		;3835	28 0b
	inc hl			;3837	23
	ld a,b			;3838	78
	and 080h		;3839	e6 80
	or (hl)			;383b	b6
	rla			;383c	17
CALC_REF3:
	ccf			;383d	3f
	rra			;383e	1f
	ld (hl),a		;383f	77
	dec hl			;3840	2b
	ret			;3841	c9
l3842h:
	push de			;3842	d5
	push hl			;3843	e5
	call FP_PUSH		;3844	cd 3d 31
	pop hl			;3847	e1
	ld a,b			;3848	78
	or c			;3849	b1
	cpl			;384a	2f
	ld c,a			;384b	4f
	call FP_ADD_INT		;384c	cd 4c 31
	pop de			;384f	d1
	ret			;3850	c9
	call sub_3904h		;3851	cd 04 39
	ret c			;3854	d8
	push de			;3855	d5
	ld de,LROS_BC		;3856	11 01 00
	inc hl			;3859	23
	rl (hl)			;385a	cb 16
	dec hl			;385c	2b
	sbc a,a			;385d	9f
	ld c,a			;385e	4f
	call FP_ADD_INT		;385f	cd 4c 31
	pop de			;3862	d1
	ret			;3863	c9
	call FP_TO_BC		;3864	cd 23 1f
	in a,(c)		;3867	ed 78
	jr l386fh		;3869	18 04
	call FP_TO_BC		;386b	cd 23 1f
	ld a,(bc)		;386e	0a
l386fh:
	jp l30e6h		;386f	c3 e6 30
	call FP_TO_BC		;3872	cd 23 1f
	call sub_388eh		;3875	cd 8e 38
	ld hl,l3882h		;3878	21 82 38
	push hl			;387b	e5
	ld hl,STACK_NUM		;387c	21 e9 30
	push hl			;387f	e5
	push bc			;3880	c5
	ret			;3881	c9
l3882h:
	pop af			;3882	f1
	inc a			;3883	3c
	ret z			;3884	c8
	push bc			;3885	c5
	ld bc,0ff00h		;3886	01 00 ff
	call 06499h		;3889	cd 99 64
	pop bc			;388c	c1
	ret			;388d	c9
sub_388eh:
	ld hl,(05cbch)		;388e	2a bc 5c  ; SYSCON
	inc hl			;3891	23
	ld a,(hl)		;3892	7e
	cp 002h			;3893	fe 02
	jr nz,l38c5h		;3895	20 2e
	inc hl			;3897	23
	inc hl			;3898	23
	inc hl			;3899	23
	ld a,b			;389a	78
	bit 7,a			;389b	cb 7f
	jr z,l38c5h		;389d	28 26
	and 006h		;389f	e6 06
	jr z,l38beh		;38a1	28 1b
	sub 004h		;38a3	d6 04
	jp m,l38b7h		;38a5	fa b7 38
	jr z,l38b0h		;38a8	28 06
	ld a,(hl)		;38aa	7e
	jp m,l38c5h		;38ab	fa c5 38
	jr l38cbh		;38ae	18 1b
l38b0h:
	ld a,(hl)		;38b0	7e
	bit 6,a			;38b1	cb 77
	jr z,l38cbh		;38b3	28 16
	jr l38c5h		;38b5	18 0e
l38b7h:
	ld a,(hl)		;38b7	7e
	bit 5,a			;38b8	cb 6f
	jr z,l38cbh		;38ba	28 0f
	jr l38c5h		;38bc	18 07
l38beh:
	ld a,(hl)		;38be	7e
	bit 4,a			;38bf	cb 67
	jr z,l38cbh		;38c1	28 08
	jr l38c5h		;38c3	18 00
l38c5h:
	pop hl			;38c5	e1
	ld a,0ffh		;38c6	3e ff
	push af			;38c8	f5
	push hl			;38c9	e5
	ret			;38ca	c9
l38cbh:
	pop hl			;38cb	e1
	push af			;38cc	f5
	push hl			;38cd	e5
	push bc			;38ce	c5
	ld c,a			;38cf	4f
	ld b,000h		;38d0	06 00
	call 06499h		;38d2	cd 99 64
	pop bc			;38d5	c1
	ret			;38d6	c9
	call GET_STRING		;38d7	cd af 2f
	dec bc			;38da	0b
	ld a,b			;38db	78
	or c			;38dc	b1
	jr nz,l3902h		;38dd	20 23
	ld a,(de)		;38df	1a
l38e0h:
	call sub_304bh		;38e0	cd 4b 30
	jr c,l38eeh		;38e3	38 09
	sub 090h		;38e5	d6 90
	jr c,l3902h		;38e7	38 19
	cp 015h			;38e9	fe 15
	jr nc,l3902h		;38eb	30 15
	inc a			;38ed	3c
l38eeh:
	dec a			;38ee	3d
	add a,a			;38ef	87
	add a,a			;38f0	87
	add a,a			;38f1	87
	cp 0a8h			;38f2	fe a8
	jr nc,l3902h		;38f4	30 0c
	ld bc,(05c7bh)		;38f6	ed 4b 7b 5c  ; UDG
	add a,c			;38fa	81
	ld c,a			;38fb	4f
	jr nc,l38ffh		;38fc	30 01
	inc b			;38fe	04
l38ffh:
	jp STACK_NUM		;38ff	c3 e9 30
l3902h:
	rst 8			;3902	cf
	add hl,bc		;3903	09
sub_3904h:
	push hl			;3904	e5
	push bc			;3905	c5
	ld b,a			;3906	47
	ld a,(hl)		;3907	7e
	inc hl			;3908	23
	or (hl)			;3909	b6
	inc hl			;390a	23
	or (hl)			;390b	b6
	inc hl			;390c	23
	or (hl)			;390d	b6
	ld a,b			;390e	78
	pop bc			;390f	c1
	pop hl			;3910	e1
	ret nz			;3911	c0
	scf			;3912	37
	ret			;3913	c9
sub_3914h:
	call sub_3904h		;3914	cd 04 39
	ret c			;3917	d8
	ld a,0ffh		;3918	3e ff
	jr l3922h		;391a	18 06
sub_391ch:
	call sub_3904h		;391c	cd 04 39
	jr sub_3926h		;391f	18 05
l3921h:
	xor a			;3921	af
l3922h:
	inc hl			;3922	23
	xor (hl)		;3923	ae
	dec hl			;3924	2b
	rlca			;3925	07
sub_3926h:
	push hl			;3926	e5
	ld a,000h		;3927	3e 00
	ld (hl),a		;3929	77
	inc hl			;392a	23
	ld (hl),a		;392b	77
	inc hl			;392c	23
	rla			;392d	17
	ld (hl),a		;392e	77
	rra			;392f	1f
	inc hl			;3930	23
	ld (hl),a		;3931	77
	inc hl			;3932	23
	ld (hl),a		;3933	77
	pop hl			;3934	e1
	ret			;3935	c9
	ex de,hl		;3936	eb
	call sub_3904h		;3937	cd 04 39
	ex de,hl		;393a	eb
	ret c			;393b	d8
	scf			;393c	37
	jr sub_3926h		;393d	18 e7
	ex de,hl		;393f	eb
	call sub_3904h		;3940	cd 04 39
	ex de,hl		;3943	eb
	ret nc			;3944	d0
	and a			;3945	a7
	jr sub_3926h		;3946	18 de
	ex de,hl		;3948	eb
	call sub_3904h		;3949	cd 04 39
	ex de,hl		;394c	eb
	ret nc			;394d	d0
	push de			;394e	d5
	dec de			;394f	1b
	xor a			;3950	af
	ld (de),a		;3951	12
	dec de			;3952	1b
	ld (de),a		;3953	12
	pop de			;3954	d1
	ret			;3955	c9
	ld a,b			;3956	78
	sub 008h		;3957	d6 08
	bit 2,a			;3959	cb 57
	jr nz,l395eh		;395b	20 01
	dec a			;395d	3d
l395eh:
	rrca			;395e	0f
	jr nc,l3969h		;395f	30 08
	push af			;3961	f5
	push hl			;3962	e5
	call FP_TABLE2		;3963	cd fb 37
	pop de			;3966	d1
	ex de,hl		;3967	eb
	pop af			;3968	f1
l3969h:
	bit 2,a			;3969	cb 57
	jr nz,l3974h		;396b	20 07
	rrca			;396d	0f
	push af			;396e	f5
	call sub_33ceh		;396f	cd ce 33
	jr $+53			;3972	18 33
l3974h:
	rrca			;3974	0f
	push af			;3975	f5
	call GET_STRING		;3976	cd af 2f
	push de			;3979	d5
	push bc			;397a	c5
	call GET_STRING		;397b	cd af 2f
	pop hl			;397e	e1
l397fh:
	ld a,h			;397f	7c
	or l			;3980	b5
	ex (sp),hl		;3981	e3
	ld a,b			;3982	78
	jr nz,l3990h		;3983	20 0b
	or c			;3985	b1
l3986h:
	pop bc			;3986	c1
	jr z,l398dh		;3987	28 04
	pop af			;3989	f1
	ccf			;398a	3f
	jr l39a3h		;398b	18 16
l398dh:
	pop af			;398d	f1
	jr l39a3h		;398e	18 13
l3990h:
	or c			;3990	b1
	jr z,l39a0h		;3991	28 0d
	ld a,(de)		;3993	1a
	sub (hl)		;3994	96
	jr c,l39a0h		;3995	38 09
	jr nz,l3986h		;3997	20 ed
l3999h:
	dec bc			;3999	0b
	inc de			;399a	13
	inc hl			;399b	23
	ex (sp),hl		;399c	e3
	dec hl			;399d	2b
	jr l397fh		;399e	18 df
l39a0h:
	pop bc			;39a0	c1
	pop af			;39a1	f1
	and a			;39a2	a7
l39a3h:
	push af			;39a3	f5
	rst 28h			;39a4	ef
	and b			;39a5	a0
	jr c,l3999h		;39a6	38 f1
	push af			;39a8	f5
	call c,sub_391ch	;39a9	dc 1c 39
	pop af			;39ac	f1
	push af			;39ad	f5
	call nc,sub_3914h	;39ae	d4 14 39
	pop af			;39b1	f1
	rrca			;39b2	0f
	call nc,sub_391ch	;39b3	d4 1c 39
	ret			;39b6	c9
	call GET_STRING		;39b7	cd af 2f
	push de			;39ba	d5
	push bc			;39bb	c5
	call GET_STRING		;39bc	cd af 2f
	pop hl			;39bf	e1
	push hl			;39c0	e5
	push de			;39c1	d5
	push bc			;39c2	c5
	add hl,bc		;39c3	09
	ld b,h			;39c4	44
	ld c,l			;39c5	4d
	rst 30h			;39c6	f7
	call sub_2e70h		;39c7	cd 70 2e
	pop bc			;39ca	c1
	pop hl			;39cb	e1
	ld a,b			;39cc	78
	or c			;39cd	b1
	jr z,l39d2h		;39ce	28 02
	ldir			;39d0	ed b0
l39d2h:
	pop bc			;39d2	c1
	pop hl			;39d3	e1
	ld a,b			;39d4	78
	or c			;39d5	b1
	jr z,sub_39dah		;39d6	28 02
	ldir			;39d8	ed b0
sub_39dah:
	ld hl,(05c65h)		;39da	2a 65 5c  ; STKEND
	ld de,0fffbh		;39dd	11 fb ff
	push hl			;39e0	e5
	add hl,de		;39e1	19
	pop de			;39e2	d1
	ret			;39e3	c9
l39e4h:
	call 03193h		;39e4	cd 93 31
	jr c,l39f7h		;39e7	38 0e
	jr nz,l39f7h		;39e9	20 0c
	push af			;39eb	f5
	ld bc,LROS_BC		;39ec	01 01 00
	rst 30h			;39ef	f7
	pop af			;39f0	f1
	ld (de),a		;39f1	12
	call sub_2e70h		;39f2	cd 70 2e
	ex de,hl		;39f5	eb
	ret			;39f6	c9
l39f7h:
	rst 8			;39f7	cf
	ld a,(bc)		;39f8	0a
l39f9h:
	ld hl,(05c5dh)		;39f9	2a 5d 5c  ; CH_ADD
	push hl			;39fc	e5
	ld a,b			;39fd	78
	add a,0e3h		;39fe	c6 e3
	sbc a,a			;3a00	9f
	push af			;3a01	f5
	call GET_STRING		;3a02	cd af 2f
	push de			;3a05	d5
	inc bc			;3a06	03
	rst 30h			;3a07	f7
	pop hl			;3a08	e1
	ld (05c5dh),de		;3a09	ed 53 5d 5c  ; CH_ADD
	push de			;3a0d	d5
	ldir			;3a0e	ed b0
	ex de,hl		;3a10	eb
	dec hl			;3a11	2b
	ld (hl),00dh		;3a12	36 0d
	res 7,(iy+001h)		;3a14	fd cb 01 be  ; IY+$01 = FLAGS
	call EVAL_EXPR		;3a18	cd 54 28
	rst 18h			;3a1b	df
	cp 00dh			;3a1c	fe 0d
	jr nz,l3a27h		;3a1e	20 07
	pop hl			;3a20	e1
	pop af			;3a21	f1
	xor (iy+001h)		;3a22	fd ae 01  ; IY+$01 = FLAGS
	and 040h		;3a25	e6 40
l3a27h:
	jp nz,NONSENSE_ERR		;3a27	c2 ed 1b
	ld (05c5dh),hl		;3a2a	22 5d 5c  ; CH_ADD
	set 7,(iy+001h)		;3a2d	fd cb 01 fe  ; IY+$01 = FLAGS
	call EVAL_EXPR		;3a31	cd 54 28
	pop hl			;3a34	e1
	ld (05c5dh),hl		;3a35	22 5d 5c  ; CH_ADD
l3a38h:
	jr sub_39dah		;3a38	18 a0
	ld bc,LROS_BC		;3a3a	01 01 00
	rst 30h			;3a3d	f7
	ld (05c5bh),hl		;3a3e	22 5b 5c  ; KCUR
	push hl			;3a41	e5
	ld hl,(05c51h)		;3a42	2a 51 5c  ; CURCHL
	push hl			;3a45	e5
	ld a,0ffh		;3a46	3e ff
	call SELECT		;3a48	cd 30 12
	call l31a1h		;3a4b	cd a1 31
	pop hl			;3a4e	e1
	call SET_CURCHL		;3a4f	cd 48 12
	pop de			;3a52	d1
	ld hl,(05c5bh)		;3a53	2a 5b 5c  ; KCUR
	and a			;3a56	a7
	sbc hl,de		;3a57	ed 52
	ld b,h			;3a59	44
	ld c,l			;3a5a	4d
	call sub_2e70h		;3a5b	cd 70 2e
	ex de,hl		;3a5e	eb
	ret			;3a5f	c9
	call FP_TO_A		;3a60	cd 1e 1f
	cp 010h			;3a63	fe 10
	jp nc,ERR_OUTSCREEN		;3a65	d2 29 1f
	ld hl,(05c51h)		;3a68	2a 51 5c  ; CURCHL
	push hl			;3a6b	e5
	call SELECT		;3a6c	cd 30 12
	call RDCH_CHAN		;3a6f	cd e1 11
	ld bc,LROS_HEADER		;3a72	01 00 00
	jr nc,l3a7ah		;3a75	30 03
	inc c			;3a77	0c
	rst 30h			;3a78	f7
	ld (de),a		;3a79	12
l3a7ah:
	call sub_2e70h		;3a7a	cd 70 2e
	pop hl			;3a7d	e1
	call SET_CURCHL		;3a7e	cd 48 12
	jp sub_39dah		;3a81	c3 da 39
	call GET_STRING		;3a84	cd af 2f
	ld a,b			;3a87	78
	or c			;3a88	b1
	jr z,l3a8ch		;3a89	28 01
	ld a,(de)		;3a8b	1a
l3a8ch:
	jp l30e6h		;3a8c	c3 e6 30
l3a8fh:
	call GET_STRING		;3a8f	cd af 2f
	jp STACK_NUM		;3a92	c3 e9 30
	exx			;3a95	d9
	push hl			;3a96	e5
	ld hl,05c67h		;3a97	21 67 5c
	dec (hl)		;3a9a	35
	pop hl			;3a9b	e1
	jr nz,l3aa2h		;3a9c	20 04
	inc hl			;3a9e	23
	exx			;3a9f	d9
	ret			;3aa0	c9
l3aa1h:
	exx			;3aa1	d9
l3aa2h:
	ld e,(hl)		;3aa2	5e
	ld a,e			;3aa3	7b
	rla			;3aa4	17
	sbc a,a			;3aa5	9f
	ld d,a			;3aa6	57
	add hl,de		;3aa7	19
l3aa8h:
	exx			;3aa8	d9
	ret			;3aa9	c9
	inc de			;3aaa	13
	inc de			;3aab	13
	ld a,(de)		;3aac	1a
	dec de			;3aad	1b
	dec de			;3aae	1b
	and a			;3aaf	a7
	jr nz,l3aa1h		;3ab0	20 ef
	exx			;3ab2	d9
	inc hl			;3ab3	23
	exx			;3ab4	d9
	ret			;3ab5	c9
	pop af			;3ab6	f1
	exx			;3ab7	d9
	ex (sp),hl		;3ab8	e3
	exx			;3ab9	d9
	ret			;3aba	c9
	rst 28h			;3abb	ef
	ret nz			;3abc	c0
	ld (bc),a		;3abd	02
	ld sp,005e0h		;3abe	31 e0 05
	daa			;3ac1	27
	ret po			;3ac2	e0
	ld bc,TONE		;3ac3	01 c0 04
	inc bc			;3ac6	03
	ret po			;3ac7	e0
	jr c,$-53		;3ac8	38 c9
l3acah:
	rst 28h			;3aca	ef
	ld sp,00036h		;3acb	31 36 00
	inc b			;3ace	04
	ld a,(0c938h)		;3acf	3a 38 c9
	ld sp,0c03ah		;3ad2	31 3a c0
	inc bc			;3ad5	03
	ret po			;3ad6	e0
	ld bc,ALLOCBC		;3ad7	01 30 00
	inc bc			;3ada	03
	and c			;3adb	a1
	inc bc			;3adc	03
	jr c,l3aa8h		;3add	38 c9
	rst 28h			;3adf	ef
	dec a			;3ae0	3d
	inc (hl)		;3ae1	34
l3ae2h:
	pop af			;3ae2	f1
	jr c,l3a8fh		;3ae3	38 aa
	dec sp			;3ae5	3b
	add hl,hl		;3ae6	29
	inc b			;3ae7	04
	ld sp,0c327h		;3ae8	31 27 c3
	inc bc			;3aeb	03
	ld sp,0a10fh		;3aec	31 0f a1
	inc bc			;3aef	03
	adc a,b			;3af0	88
	inc de			;3af1	13
	ld (hl),058h		;3af2	36 58
	ld h,l			;3af4	65
	ld h,(hl)		;3af5	66
	sbc a,l			;3af6	9d
l3af7h:
	ld a,b			;3af7	78
	ld h,l			;3af8	65
	ld b,b			;3af9	40
	and d			;3afa	a2
	ld h,b			;3afb	60
	ld (0e7c9h),a		;3afc	32 c9 e7
	ld hl,0aff7h		;3aff	21 f7 af
	inc h			;3b02	24
	ex de,hl		;3b03	eb
	cpl			;3b04	2f
l3b05h:
	or b			;3b05	b0
	or b			;3b06	b0
	inc d			;3b07	14
	xor 07eh		;3b08	ee 7e
	cp e			;3b0a	bb
	sub h			;3b0b	94
	ld e,b			;3b0c	58
	pop af			;3b0d	f1
	ld a,(0f87eh)		;3b0e	3a 7e f8
	rst 8			;3b11	cf
	ex (sp),hl		;3b12	e3
	jr c,l3ae2h		;3b13	38 cd
	sub e			;3b15	93
	ld sp,00720h		;3b16	31 20 07
	jr c,l3b1eh		;3b19	38 03
	add a,(hl)		;3b1b	86
	jr nc,l3b27h		;3b1c	30 09
l3b1eh:
	rst 8			;3b1e	cf
	dec b			;3b1f	05
	jr c,l3b29h		;3b20	38 07
	sub (hl)		;3b22	96
	jr nc,l3b29h		;3b23	30 04
	neg			;3b25	ed 44
l3b27h:
	ld (hl),a		;3b27	77
	ret			;3b28	c9
l3b29h:
	rst 28h			;3b29	ef
	ld (bc),a		;3b2a	02
	and b			;3b2b	a0
	jr c,l3af7h		;3b2c	38 c9
	rst 28h			;3b2e	ef
	dec a			;3b2f	3d
	ld sp,00037h		;3b30	31 37 00
	inc b			;3b33	04
	jr c,l3b05h		;3b34	38 cf
	add hl,bc		;3b36	09
	and b			;3b37	a0
	ld (bc),a		;3b38	02
	jr c,l3bb9h		;3b39	38 7e
	ld (hl),080h		;3b3b	36 80
	call l30e6h		;3b3d	cd e6 30
	rst 28h			;3b40	ef
	inc (hl)		;3b41	34
	jr c,l3b44h		;3b42	38 00
l3b44h:
	inc bc			;3b44	03
	ld bc,l3431h		;3b45	01 31 34
	ret p			;3b48	f0
	ld c,h			;3b49	4c
	call z,0cdcch		;3b4a	cc cc cd
	inc bc			;3b4d	03
	scf			;3b4e	37
	nop			;3b4f	00
	ex af,af'		;3b50	08
	ld bc,LED4_RET		;3b51	01 a1 03
	ld bc,l3438h		;3b54	01 38 34
	rst 28h			;3b57	ef
	ld bc,0f034h		;3b58	01 34 f0
	ld sp,01772h		;3b5b	31 72 17
	ret m			;3b5e	f8
	inc b			;3b5f	04
	ld bc,K_MODE_KEYWORD		;3b60	01 a2 03
	and d			;3b63	a2
	inc bc			;3b64	03
	ld sp,03234h		;3b65	31 34 32
	jr nz,$+6		;3b68	20 04
	and d			;3b6a	a2
	inc bc			;3b6b	03
	adc a,h			;3b6c	8c
	ld de,STK_POP		;3b6d	11 ac 14
	add hl,bc		;3b70	09
	ld d,(hl)		;3b71	56
	jp c,059a5h		;3b72	da a5 59
	jr nc,$-57		;3b75	30 c5
	ld e,h			;3b77	5c
	sub b			;3b78	90
	xor d			;3b79	aa
	sbc a,(hl)		;3b7a	9e
	ld (hl),b		;3b7b	70
	ld l,a			;3b7c	6f
	ld h,c			;3b7d	61
	and c			;3b7e	a1
	set 3,d			;3b7f	cb da
	sub (hl)		;3b81	96
	and h			;3b82	a4
	ld sp,0b49fh		;3b83	31 9f b4
	rst 20h			;3b86	e7
	and b			;3b87	a0
	cp 05ch			;3b88	fe 5c
	call m,01beah		;3b8a	fc ea 1b
	ld b,e			;3b8d	43
l3b8eh:
	jp z,0ed36h		;3b8e	ca 36 ed
	and a			;3b91	a7
	sbc a,h			;3b92	9c
	ld a,(hl)		;3b93	7e
	ld e,(hl)		;3b94	5e
	ret p			;3b95	f0
	ld l,(hl)		;3b96	6e
	inc hl			;3b97	23
	add a,b			;3b98	80
	sub e			;3b99	93
	inc b			;3b9a	04
	rrca			;3b9b	0f
	jr c,$-53		;3b9c	38 c9
l3b9eh:
	rst 28h			;3b9e	ef
	dec a			;3b9f	3d
	inc (hl)		;3ba0	34
	xor 022h		;3ba1	ee 22
	ld sp,hl		;3ba3	f9
	add a,e			;3ba4	83
	ld l,(hl)		;3ba5	6e
	inc b			;3ba6	04
	ld sp,ERR_MEM		;3ba7	31 a2 0f
	daa			;3baa	27
	inc bc			;3bab	03
	ld sp,l310fh		;3bac	31 0f 31
	rrca			;3baf	0f
	ld sp,0a12ah		;3bb0	31 2a a1
	inc bc			;3bb3	03
	ld sp,0c037h		;3bb4	31 37 c0
	nop			;3bb7	00
	inc b			;3bb8	04
l3bb9h:
	ld (bc),a		;3bb9	02
	jr c,$-53		;3bba	38 c9
	and c			;3bbc	a1
	inc bc			;3bbd	03
	ld bc,00036h		;3bbe	01 36 00
	ld (bc),a		;3bc1	02
	dec de			;3bc2	1b
	jr c,l3b8eh		;3bc3	38 c9
	rst 28h			;3bc5	ef
l3bc6h:
	add hl,sp		;3bc6	39
	ld hl,(LED4_RET)		;3bc7	2a a1 03
	ret po			;3bca	e0
	nop			;3bcb	00
	ld b,01bh		;3bcc	06 1b
	inc sp			;3bce	33
	inc bc			;3bcf	03
l3bd0h:
	rst 28h			;3bd0	ef
l3bd1h:
	add hl,sp		;3bd1	39
l3bd2h:
	ld sp,PARP_HI2		;3bd2	31 31 04
	ld sp,0a10fh		;3bd5	31 0f a1
	inc bc			;3bd8	03
	add a,(hl)		;3bd9	86
	inc d			;3bda	14
	and 05ch		;3bdb	e6 5c
	rra			;3bdd	1f
	dec bc			;3bde	0b
	and e			;3bdf	a3
	adc a,a			;3be0	8f
	jr c,l3bd1h		;3be1	38 ee
	jp (hl)			;3be3	e9
	dec d			;3be4	15
	ld h,e			;3be5	63
	cp e			;3be6	bb
	inc hl			;3be7	23
	xor 092h		;3be8	ee 92
	dec c			;3bea	0d
	call 0f1edh		;3beb	cd ed f1
	inc hl			;3bee	23
	ld e,l			;3bef	5d
	dec de			;3bf0	1b
	jp pe,l3804h		;3bf1	ea 04 38
	ret			;3bf4	c9
	rst 28h			;3bf5	ef
	ld sp,TOK_DEF_FN		;3bf6	31 1f 01
	jr nz,l3c00h		;3bf9	20 05
	jr c,l3bc6h		;3bfb	38 c9
	call FP_NORM_LP		;3bfd	cd 56 36
l3c00h:
	ld a,(hl)		;3c00	7e
	cp 081h			;3c01	fe 81
	jr c,l3c13h		;3c03	38 0e
	rst 28h			;3c05	ef
	and c			;3c06	a1
	dec de			;3c07	1b
	ld bc,03105h		;3c08	01 05 31
	ld (hl),0a3h		;3c0b	36 a3
	ld bc,00600h		;3c0d	01 00 06
	dec de			;3c10	1b
	inc sp			;3c11	33
	inc bc			;3c12	03
l3c13h:
	rst 28h			;3c13	ef
	and b			;3c14	a0
	ld bc,l3131h		;3c15	01 31 31
	inc b			;3c18	04
	ld sp,0a10fh		;3c19	31 0f a1
	inc bc			;3c1c	03
	adc a,h			;3c1d	8c
	djnz l3bd2h		;3c1e	10 b2
	inc de			;3c20	13
	ld c,055h		;3c21	0e 55
	call po,0588dh		;3c23	e4 8d 58
	add hl,sp		;3c26	39
	cp h			;3c27	bc
	ld e,e			;3c28	5b
	sbc a,b			;3c29	98
	sbc a,(iy+000h)		;3c2a	fd 9e 00  ; IY+$00 = ERR_NR
	ld (hl),075h		;3c2d	36 75
	and b			;3c2f	a0
	in a,(0e8h)		;3c30	db e8
	or h			;3c32	b4
	ld h,e			;3c33	63
	ld b,d			;3c34	42
	call nz,0b5e6h		;3c35	c4 e6 b5
	add hl,bc		;3c38	09
l3c39h:
	ld (hl),0beh		;3c39	36 be
	jp (hl)			;3c3b	e9
	ld (hl),073h		;3c3c	36 73
	dec de			;3c3e	1b
	ld e,l			;3c3f	5d
	call pe,0ded8h		;3c40	ec d8 de
	ld h,e			;3c43	63
	cp (hl)			;3c44	be
	ret p			;3c45	f0
	ld h,c			;3c46	61
	and c			;3c47	a1
	or e			;3c48	b3
	inc c			;3c49	0c
	inc b			;3c4a	04
	rrca			;3c4b	0f
	jr c,$-53		;3c4c	38 c9
	rst 28h			;3c4e	ef
	ld sp,PARP_HI2		;3c4f	31 31 04
l3c52h:
	and c			;3c52	a1
	inc bc			;3c53	03
	dec de			;3c54	1b
	jr z,$-93		;3c55	28 a1
	rrca			;3c57	0f
	dec b			;3c58	05
	inc h			;3c59	24
	ld sp,l380fh		;3c5a	31 0f 38
	ret			;3c5d	c9
	rst 28h			;3c5e	ef
	ld (K_MODE_KEYWORD+1),hl	;3c5f	22 a3 03
	dec de			;3c62	1b
	jr c,$-53		;3c63	38 c9
	rst 28h			;3c65	ef
	ld sp,ALLOCBC		;3c66	31 30 00
	ld e,0a2h		;3c69	1e a2
	jr c,$-15		;3c6b	38 ef
	ld bc,l3031h		;3c6d	01 31 30
	nop			;3c70	00
	rlca			;3c71	07
	dec h			;3c72	25
	inc b			;3c73	04
	jr c,l3c39h		;3c74	38 c3
	rst 18h			;3c76	df
	ld a,(sub_3102h)	;3c77	3a 02 31
	jr nc,l3c7ch		;3c7a	30 00
l3c7ch:
	add hl,bc		;3c7c	09
	and b			;3c7d	a0
	ld bc,00037h		;3c7e	01 37 00
	ld b,0a1h		;3c81	06 a1
	ld bc,TOK_COPY		;3c83	01 05 02
	and c			;3c86	a1
	jr c,l3c52h		;3c87	38 c9
	add a,b			;3c89	80
	ld d,e			;3c8a	53
	ld (hl),h		;3c8b	74
	ld h,c			;3c8c	61
	ld (hl),d		;3c8d	72
	ld (hl),h		;3c8e	74
	jr nz,$+118		;3c8f	20 74
	ld h,c			;3c91	61
	ld (hl),b		;3c92	70
	ld h,l			;3c93	65
	dec sp			;3c94	3b
	jr nz,$+118		;3c95	20 74
	ld l,b			;3c97	68
	ld h,l			;3c98	65
	ld l,(hl)		;3c99	6e
	jr nz,INIT_VIDMODE		;3c9a	20 70
	ld (hl),d		;3c9c	72
	ld h,l			;3c9d	65
	ld (hl),e		;3c9e	73
	ld (hl),e		;3c9f	73
	jr nz,ZEBRA_INIT_2		;3ca0	20 61
	ld l,(hl)		;3ca2	6e
	ld a,c			;3ca3	79
	jr nz,INIT_PRINTBUF		;3ca4	20 6b
	ld h,l			;3ca6	65
	ld a,c			;3ca7	79
	xor (hl)		;3ca8	ae
	dec c			;3ca9	0d
	ld d,b			;3caa	50
	ld (hl),d		;3cab	72
	ld l,a			;3cac	6f
	ld h,a			;3cad	67
	cp d			;3cae	ba
	dec c			;3caf	0d
	inc hl			;3cb0	23
	ld h,c			;3cb1	61
	ld (hl),d		;3cb2	72
	ld (hl),d		;3cb3	72
	ld h,c			;3cb4	61
	ld a,c			;3cb5	79
	cp d			;3cb6	ba
	dec c			;3cb7	0d
	inc h			;3cb8	24
	ld h,c			;3cb9	61
	ld (hl),d		;3cba	72
	ld (hl),d		;3cbb	72
	ld h,c			;3cbc	61
	ld a,c			;3cbd	79
	cp d			;3cbe	ba
	dec c			;3cbf	0d
	ld b,d			;3cc0	42
	ld a,c			;3cc1	79
	ld (hl),h		;3cc2	74
	ld h,l			;3cc3	65
	ld (hl),e		;3cc4	73
	cp d			;3cc5	ba
	ld a,c			;3cc6	79
l3cc7h:
	ld (05cb1h),a		;3cc7	32 b1 5c
	ld b,0f0h		;3cca	06 f0
	bit 0,(iy+057h)		;3ccc	fd cb 57 46  ; IY+$57 = PFLAG
	jr z,l3cd4h		;3cd0	28 02
	ld b,0ffh		;3cd2	06 ff
l3cd4h:
	ld a,(05cb1h)		;3cd4	3a b1 5c
	bit 0,a			;3cd7	cb 47
	ld a,b			;3cd9	78
	call nz,NIBBLE_SWAP	;3cda	c4 2b 00
	ld b,a			;3cdd	47
	ld c,000h		;3cde	0e 00
	bit 2,(iy+057h)		;3ce0	fd cb 57 56  ; IY+$57 = PFLAG
	jr z,l3ce8h		;3ce4	28 02
	ld c,00fh		;3ce6	0e 0f
l3ce8h:
	ld a,(05cb1h)		;3ce8	3a b1 5c
	bit 0,a			;3ceb	cb 47
	ld a,c			;3ced	79
	call nz,NIBBLE_SWAP	;3cee	c4 2b 00
	ld c,a			;3cf1	4f
	ret			;3cf2	c9
EXROM_STUB:

;================================================================
; EXROM stub data ($3CF3-$3CFF)
; Copied to high RAM during initialization.
;================================================================
	ld a,b			;3cf3	78
	inc a			;3cf4	3c
	jr nz,$+22		;3cf5	20 14
	ld a,c			;3cf7	79
	and a			;3cf8	a7
	jr nz,$+18		;3cf9	20 10
	ld bc,TOK_CHR		;3cfb	01 fc 00
	jr $+13			;3cfe	18 0b
ZEBRA_INIT:

;================================================================
;*** ZEBRA MODIFICATION: Init & 64-Col Display Code ($3D00-$3FFF) ***
; This area replaces the original 768-byte character set.
; The font is copied to RAM at $7800 during initialization.
;
; $3D00: ZEBRA_INIT - calls setup and channel init
; $3D07: ZEBRA_SETUP - configures printer width, UDG, print area, channel redirect
; $3D33: ZEBRA_CHANNELS - inits Centronics vars (COPY_addr, IFDR_addr, CR, LF)
; $3D4A: Z64_OUTPUT - Centronics LPRINT/LLIST handler (printer channel output)
; $3ED4: Z64_COPY - Centronics COPY screen dump (Epson ESC/P graphics)
; $3F76: Z64_OUTPUT_BYTE - dispatches byte to selected interface driver
; $3F7A-$3FCD: Interface drivers (Tasman-C, Tasman-B, Timex 2040/Aerco/Oliger, A&J)
;================================================================
	call ZEBRA_SETUP		;3d00	cd 07 3d
ZEBRA_INIT_2:
	call ZEBRA_CHANNELS		;3d03	cd 33 3d
	ret			;3d06	c9
ZEBRA_SETUP:
	ld b,000h		;3d07	06 00
	ld a,(0fff5h)		;3d09	3a f5 ff  ; WDTH
INIT_VIDMODE:
	inc a			;3d0c	3c
	ld (0ffedh),a		;3d0d	32 ed ff  ; MAXcl
	ld c,a			;3d10	4f
INIT_PRINTBUF:
	ld (05c7fh),bc		;3d11	ed 43 7f 5c  ; PRPOSN
	ld hl,05b00h		;3d15	21 00 5b
	ld (05c80h),hl		;3d18	22 80 5c  ; PRCC
	ld hl,(05c4fh)		;3d1b	2a 4f 5c  ; CHANS
	ld bc,0000fh		;3d1e	01 0f 00
	add hl,bc		;3d21	09
	ld de,Z64_OUTPUT		;3d22	11 4a 3d
	ld (hl),e		;3d25	73
	inc hl			;3d26	23
	ld (hl),d		;3d27	72
	ld hl,05b00h		;3d28	21 00 5b
	ld b,000h		;3d2b	06 00
l3d2dh:
	ld (hl),020h		;3d2d	36 20
	inc hl			;3d2f	23
	djnz l3d2dh		;3d30	10 fb
	ret			;3d32	c9
ZEBRA_CHANNELS:
	ld hl,Z64_COPY		;3d33	21 d4 3e
	ld (0ffe8h),hl		;3d36	22 e8 ff  ; COPY_addr
	ld hl,l3fa7h		;3d39	21 a7 3f
	ld (0fff3h),hl		;3d3c	22 f3 ff  ; IFDR_addr
	ld a,00dh		;3d3f	3e 0d
	ld (0ffe6h),a		;3d41	32 e6 ff  ; CR
	ld a,00ah		;3d44	3e 0a
	ld (0ffe7h),a		;3d46	32 e7 ff  ; LF
	ret			;3d49	c9
Z64_OUTPUT:
	ld hl,0fff7h		;3d4a	21 f7 ff  ; FLAGSnew
	res 7,(hl)		;3d4d	cb be
	ld hl,0ffeeh		;3d4f	21 ee ff
	bit 0,(hl)		;3d52	cb 46
	jr z,Z64_CHAR_START		;3d54	28 04
	call Z64_OUTPUT_BYTE		;3d56	cd 76 3f
	ret			;3d59	c9
Z64_CHAR_START:
	call Z64_LDTVCU		;3d5a	cd 26 3e
	cp 020h			;3d5d	fe 20
	jr nc,Z64_PRINT_CHAR		;3d5f	30 59
	cp 00ch			;3d61	fe 0c
	jr nz,Z64_CTRL_CHECK		;3d63	20 06
	bit 4,(iy+001h)		;3d65	fd cb 01 66  ; IY+$01 = FLAGS
	jr z,Z64_PRINT_CHAR		;3d69	28 4f
Z64_CTRL_CHECK:
	cp 006h			;3d6b	fe 06
	jr c,Z64_QMARK		;3d6d	38 49
	cp 018h			;3d6f	fe 18
	jr nc,Z64_QMARK		;3d71	30 45
	ld hl,Z64_CTRL_TABLE		;3d73	21 7a 3d
	ld e,a			;3d76	5f
	ld d,000h		;3d77	16 00
	add hl,de		;3d79	19
Z64_CTRL_TABLE:
	ld e,(hl)		;3d7a	5e
	add hl,de		;3d7b	19
	push hl			;3d7c	e5
	jp Z64_LDTVCU		;3d7d	c3 26 3e
	dec (hl)		;3d80	35
	scf			;3d81	37
	djnz $+30		;3d82	10 1c
	inc (hl)		;3d84	34
	inc sp			;3d85	33
	ld (CALC_REF),a		;3d86	32 2b 30
	cpl			;3d89	2f
	ccf			;3d8a	3f
	ld a,03dh		;3d8b	3e 3d
	inc a			;3d8d	3c
	dec sp			;3d8e	3b
	ld a,(CALC_REF2)		;3d8f	3a 34 33
	inc c			;3d92	0c
	ld a,(0fff5h)		;3d93	3a f5 ff  ; WDTH
	inc a			;3d96	3c
	inc a			;3d97	3c
	cp c			;3d98	b9
	jr nz,Z64_P_LFT		;3d99	20 02
	ld c,041h		;3d9b	0e 41
Z64_P_LFT:
	jr Z64_STTVC		;3d9d	18 72
	ld a,(05c91h)		;3d9f	3a 91 5c  ; PFLAG
	push af			;3da2	f5
	ld (iy+057h),001h	;3da3	fd 36 57 01  ; IY+$57 = PFLAG
	ld a,020h		;3da7	3e 20
	call Z64_CHAR_PRINT		;3da9	cd 5f 3e
	pop af			;3dac	f1
	ld (05c91h),a		;3dad	32 91 5c  ; PFLAG
	jr Z64_STTVC		;3db0	18 5f
	jp Z64_NEWLINE		;3db2	c3 86 3e
	jp Z64_NEWLINE		;3db5	c3 86 3e
Z64_QMARK:
	ld a,03fh		;3db8	3e 3f
Z64_PRINT_CHAR:
	jr Z64_OUTPUT_CHAR		;3dba	18 57
Z64_TVDATA2:
	ld de,Z64_TVDATA_RST		;3dbc	11 d6 3d
	ld (05c0fh),a		;3dbf	32 0f 5c  ; TVDATA+1
	jr Z64_CHAN_UPDATE		;3dc2	18 0b
	ld de,Z64_TVDATA2		;3dc4	11 bc 3d
	jr Z64_TVDATA_SAVE		;3dc7	18 03
	ld de,Z64_TVDATA_RST		;3dc9	11 d6 3d
Z64_TVDATA_SAVE:
	ld (05c0eh),a		;3dcc	32 0e 5c  ; TVDATA
Z64_CHAN_UPDATE:
	ld hl,(05c51h)		;3dcf	2a 51 5c  ; CURCHL
	ld (hl),e		;3dd2	73
	inc hl			;3dd3	23
	ld (hl),d		;3dd4	72
	ret			;3dd5	c9
Z64_TVDATA_RST:
	ld de,Z64_OUTPUT		;3dd6	11 4a 3d
	call Z64_CHAN_UPDATE		;3dd9	cd cf 3d
	ld hl,(05c0eh)		;3ddc	2a 0e 5c  ; TVDATA
	ld d,a			;3ddf	57
	ld a,l			;3de0	7d
	cp 016h			;3de1	fe 16
	ret c			;3de3	d8
	jr nz,Z64_TAB_HANDLER		;3de4	20 0f
	ld b,h			;3de6	44
	ld c,d			;3de7	4a
	ld a,(0fff5h)		;3de8	3a f5 ff  ; WDTH
	dec a			;3deb	3d
	sub c			;3dec	91
	jp c,ERR_OUTSCREEN		;3ded	da 29 1f
	add a,002h		;3df0	c6 02
	ld c,a			;3df2	4f
	jr Z64_STTVC		;3df3	18 1c
Z64_TAB_HANDLER:
	ld a,h			;3df5	7c
	call Z64_LDTVCU		;3df6	cd 26 3e
	add a,c			;3df9	81
	dec a			;3dfa	3d
	push af			;3dfb	f5
	ld a,(0fff5h)		;3dfc	3a f5 ff  ; WDTH
	ld e,a			;3dff	5f
	pop af			;3e00	f1
	sub e			;3e01	93
	ret z			;3e02	c8
	ld d,a			;3e03	57
	set 0,(iy+001h)		;3e04	fd cb 01 c6  ; IY+$01 = FLAGS
Z64_SPACE_LOOP:
	ld a,020h		;3e08	3e 20
	call PR_TV2		;3e0a	cd 76 07
	dec d			;3e0d	15
	jr nz,Z64_SPACE_LOOP		;3e0e	20 f8
	ret			;3e10	c9
Z64_STTVC:
	jr Z64_CALC_POS		;3e11	18 65
Z64_OUTPUT_CHAR:
	call Z64_GLYPH_CHAR		;3e13	cd 2d 3e
Z64_STTVCU:
	ld (iy+045h),c		;3e16	fd 71 45  ; IY+$45 = PRPOSN
	ld (05c80h),hl		;3e19	22 80 5c  ; PRCC
	ld a,(0ffedh)		;3e1c	3a ed ff  ; MAXcl
	cp c			;3e1f	b9
	ret c			;3e20	d8
	ld a,c			;3e21	79
	ld (0ffedh),a		;3e22	32 ed ff  ; MAXcl
	ret			;3e25	c9
Z64_LDTVCU:
	ld c,(iy+045h)		;3e26	fd 4e 45  ; IY+$45 = PRPOSN
	ld hl,(05c80h)		;3e29	2a 80 5c  ; PRCC
	ret			;3e2c	c9
Z64_GLYPH_CHAR:
	cp 00ch			;3e2d	fe 0c
	jr nz,Z64_GLYPH_1		;3e2f	20 04
	ld a,07ah		;3e31	3e 7a
	jr Z64_TOKEN_PRINT		;3e33	18 24
Z64_GLYPH_1:
	cp 07ch			;3e35	fe 7c
	jr z,Z64_TOKEN_PRINT		;3e37	28 20
	cp 07eh			;3e39	fe 7e
	jr z,Z64_TOKEN_PRINT		;3e3b	28 1c
	cp 07bh			;3e3d	fe 7b
	jr c,Z64_GLYPH_PRINT		;3e3f	38 0a
	cp 080h			;3e41	fe 80
	jr nc,Z64_GLYPH_PRINT		;3e43	30 06
	bit 4,(iy+001h)		;3e45	fd cb 01 66  ; IY+$01 = FLAGS
	jr z,Z64_TOKEN_PRINT		;3e49	28 0e
Z64_GLYPH_PRINT:
	cp 080h			;3e4b	fe 80
	jr c,Z64_CHAR_PRINT		;3e4d	38 10
	cp 0a5h			;3e4f	fe a5
	jr nc,Z64_TOKEN_ADJ		;3e51	30 04
	ld a,03fh		;3e53	3e 3f
Z64_UDG_PRINT:
	jr Z64_CHAR_PRINT		;3e55	18 08
Z64_TOKEN_ADJ:
	sub 0a5h		;3e57	d6 a5
Z64_TOKEN_PRINT:
	call PRTTOK		;3e59	cd 45 07
	jp Z64_LDTVCU		;3e5c	c3 26 3e
Z64_CHAR_PRINT:
	push af			;3e5f	f5
	ld a,c			;3e60	79
	dec a			;3e61	3d
	push af			;3e62	f5
	ld a,(0fff5h)		;3e63	3a f5 ff  ; WDTH
	inc a			;3e66	3c
	ld e,a			;3e67	5f
	pop af			;3e68	f1
	ld a,e			;3e69	7b
	jr nz,Z64_CHAR_STORE		;3e6a	20 07
	ld c,a			;3e6c	4f
	push de			;3e6d	d5
	call Z64_NEWLINE		;3e6e	cd 86 3e
	pop de			;3e71	d1
	ld a,c			;3e72	79
Z64_CHAR_STORE:
	pop af			;3e73	f1
	ld (hl),a		;3e74	77
	inc hl			;3e75	23
	dec c			;3e76	0d
	ret			;3e77	c9
Z64_CALC_POS:
	ld hl,05b00h		;3e78	21 00 5b
	ld a,(0fff5h)		;3e7b	3a f5 ff  ; WDTH
	inc a			;3e7e	3c
	sub c			;3e7f	91
	ld e,a			;3e80	5f
	ld d,000h		;3e81	16 00
	add hl,de		;3e83	19
	jr Z64_STTVCU		;3e84	18 90
Z64_NEWLINE:
	ld hl,05b00h		;3e86	21 00 5b
	ld a,(0ffedh)		;3e89	3a ed ff  ; MAXcl
	dec a			;3e8c	3d
	ld b,a			;3e8d	47
	ld a,(0fff5h)		;3e8e	3a f5 ff  ; WDTH
	sub b			;3e91	90
	jr z,Z64_NL_CR		;3e92	28 0a
	ld b,a			;3e94	47
Z64_NL_LOOP:
	ld a,(hl)		;3e95	7e
	push hl			;3e96	e5
	call Z64_OUTPUT_BYTE		;3e97	cd 76 3f
	pop hl			;3e9a	e1
	inc hl			;3e9b	23
	djnz Z64_NL_LOOP		;3e9c	10 f7
Z64_NL_CR:
	ld a,(0ffe6h)		;3e9e	3a e6 ff  ; CR
	call Z64_OUTPUT_BYTE		;3ea1	cd 76 3f
Z64_NL_FINISH:
	ld a,(0ffe7h)		;3ea4	3a e7 ff  ; LF
	call Z64_OUTPUT_BYTE		;3ea7	cd 76 3f
	ld hl,05b00h		;3eaa	21 00 5b
	ld (iy+046h),l		;3ead	fd 75 46  ; IY+$46 = PRPOSN+1
	ld b,000h		;3eb0	06 00
Z64_CLR_LINE:
	ld (hl),020h		;3eb2	36 20
	inc hl			;3eb4	23
	djnz Z64_CLR_LINE		;3eb5	10 fb
	res 1,(iy+030h)		;3eb7	fd cb 30 8e  ; IY+$30 = FLAGS2
	ld a,(0fff5h)		;3ebb	3a f5 ff  ; WDTH
	inc a			;3ebe	3c
	ld c,a			;3ebf	4f
	ld (0ffedh),a		;3ec0	32 ed ff  ; MAXcl
	jr Z64_CALC_POS		;3ec3	18 b3
Z64_PRINTCTL_1:
	ld (bc),a		;3ec5	02
	dec de			;3ec6	1b
	ld b,b			;3ec7	40
Z64_PRINTCTL_2:
	inc bc			;3ec8	03
	dec de			;3ec9	1b
	ld b,c			;3eca	41
	ex af,af'		;3ecb	08
Z64_PRINTCTL_3:
	inc b			;3ecc	04
	dec de			;3ecd	1b
	ld c,h			;3ece	4c
	nop			;3ecf	00
	ld (bc),a		;3ed0	02
Z64_PRINTCTL_4:
	ld (bc),a		;3ed1	02
	dec c			;3ed2	0d
	ld a,(bc)		;3ed3	0a
Z64_COPY:
	ld hl,0fff7h		;3ed4	21 f7 ff  ; FLAGSnew
	set 7,(hl)		;3ed7	cb fe
	call Z64_PRINTCTL_INIT		;3ed9	cd 4e 3f
	ld hl,Z64_PRINTCTL_2		;3edc	21 c8 3e
	call Z64_SEND_BLOCK		;3edf	cd 6b 3f
	ld a,018h		;3ee2	3e 18
	ld (0ffefh),a		;3ee4	32 ef ff  ; LINE
Z64_SCREEN_LINE:
	ld hl,0fff8h		;3ee7	21 f8 ff  ; COPYtab
	call Z64_SEND_BLOCK		;3eea	cd 6b 3f
	ld hl,Z64_PRINTCTL_3		;3eed	21 cc 3e
	call Z64_SEND_BLOCK		;3ef0	cd 6b 3f
	ld hl,LROS_HEADER		;3ef3	21 00 00
	ld (0ffe4h),hl		;3ef6	22 e4 ff  ; Xpos
	ld a,(0ffefh)		;3ef9	3a ef ff  ; LINE
	ld b,a			;3efc	47
	call DF_ADDR		;3efd	cd d6 09
Z64_SCREEN_COL:
	push hl			;3f00	e5
	ld bc,(0ffe4h)		;3f01	ed 4b e4 ff  ; Xpos
	srl b			;3f05	cb 38
	rr c			;3f07	cb 19
	srl b			;3f09	cb 38
	rr c			;3f0b	cb 19
	srl b			;3f0d	cb 38
	rr c			;3f0f	cb 19
	push bc			;3f11	c5
	srl b			;3f12	cb 38
	rr c			;3f14	cb 19
	add hl,bc		;3f16	09
	pop bc			;3f17	c1
	bit 0,c			;3f18	cb 41
	jr z,Z64_DUAL_BANK		;3f1a	28 02
	set 5,h			;3f1c	cb ec
Z64_DUAL_BANK:
	ld a,(0ffe4h)		;3f1e	3a e4 ff  ; Xpos
	and 007h		;3f21	e6 07
	call Z64_GET_PIXEL		;3f23	cd 55 3f
	call Z64_OUTPUT_BYTE		;3f26	cd 76 3f
	pop hl			;3f29	e1
Z64_SCREEN_NEXT:
	ld bc,(0ffe4h)		;3f2a	ed 4b e4 ff  ; Xpos
	inc bc			;3f2e	03
	ld (0ffe4h),bc		;3f2f	ed 43 e4 ff  ; Xpos
	ld de,TOK_RETURN		;3f33	11 00 02
	ex de,hl		;3f36	eb
	and a			;3f37	a7
	sbc hl,bc		;3f38	ed 42
	ex de,hl		;3f3a	eb
	jr nz,Z64_SCREEN_COL		;3f3b	20 c3
	push hl			;3f3d	e5
	ld hl,Z64_PRINTCTL_4		;3f3e	21 d1 3e
	call Z64_SEND_BLOCK		;3f41	cd 6b 3f
	pop hl			;3f44	e1
	ld a,(0ffefh)		;3f45	3a ef ff  ; LINE
	dec a			;3f48	3d
	ld (0ffefh),a		;3f49	32 ef ff  ; LINE
	jr nz,Z64_SCREEN_LINE		;3f4c	20 99
Z64_PRINTCTL_INIT:
	ld hl,Z64_PRINTCTL_1		;3f4e	21 c5 3e
	call Z64_SEND_BLOCK		;3f51	cd 6b 3f
	ret			;3f54	c9
Z64_GET_PIXEL:
	ld b,008h		;3f55	06 08
	ld e,000h		;3f57	1e 00
Z64_PIX_LOOP:
	push af			;3f59	f5
	push bc			;3f5a	c5
	ld b,a			;3f5b	47
	inc b			;3f5c	04
	ld a,(hl)		;3f5d	7e
Z64_PIX_ROTATE:
	rlc a			;3f5e	cb 07
	djnz Z64_PIX_ROTATE		;3f60	10 fc
	rl e			;3f62	cb 13
	pop bc			;3f64	c1
	pop af			;3f65	f1
	inc h			;3f66	24
	djnz Z64_PIX_LOOP		;3f67	10 f0
	ld a,e			;3f69	7b
	ret			;3f6a	c9
Z64_SEND_BLOCK:
	ld b,(hl)		;3f6b	46
Z64_SEND_LP:
	inc hl			;3f6c	23
	ld a,(hl)		;3f6d	7e
	push hl			;3f6e	e5
	call Z64_OUTPUT_BYTE		;3f6f	cd 76 3f
	pop hl			;3f72	e1
	djnz Z64_SEND_LP		;3f73	10 f7
	ret			;3f75	c9
Z64_OUTPUT_BYTE:
	ld hl,(0fff3h)		;3f76	2a f3 ff  ; IFDR_addr
	jp (hl)			;3f79	e9
	push bc			;3f7a	c5
	ld c,a			;3f7b	4f
Z64_PR_WAIT:
	call Z64_CHECK_BREAK		;3f7c	cd ce 3f
	in a,(0fbh)		;3f7f	db fb
	bit 0,a			;3f81	cb 47
	jr nz,Z64_PR_WAIT		;3f83	20 f7
	jr Z64_PR_SEND		;3f85	18 0b
	push bc			;3f87	c5
	ld c,a			;3f88	4f
Z64_PR_WAIT2:
	call Z64_CHECK_BREAK		;3f89	cd ce 3f
	in a,(0bfh)		;3f8c	db bf
	bit 0,a			;3f8e	cb 47
	jr nz,Z64_PR_WAIT2		;3f90	20 f7
Z64_PR_SEND:
	xor a			;3f92	af
	out (0fbh),a		;3f93	d3 fb
	dec a			;3f95	3d
	out (07bh),a		;3f96	d3 7b
	out (0fbh),a		;3f98	d3 fb
	ld a,c			;3f9a	79
	out (07bh),a		;3f9b	d3 7b
	ld a,0f7h		;3f9d	3e f7
	out (0fbh),a		;3f9f	d3 fb
	ld a,0ffh		;3fa1	3e ff
	out (0fbh),a		;3fa3	d3 fb
	pop bc			;3fa5	c1
	ret			;3fa6	c9
l3fa7h:
	push af			;3fa7	f5
Z64_SERIAL_WAIT:
	call Z64_CHECK_BREAK		;3fa8	cd ce 3f
	in a,(07fh)		;3fab	db 7f
	bit 4,a			;3fad	cb 67
	jr nz,Z64_SERIAL_WAIT		;3faf	20 f7
	pop af			;3fb1	f1
	out (07fh),a		;3fb2	d3 7f
	nop			;3fb4	00
	nop			;3fb5	00
	in a,(07fh)		;3fb6	db 7f
	ret			;3fb8	c9
	push af			;3fb9	f5
Z64_PAR_WAIT:
	call Z64_CHECK_BREAK		;3fba	cd ce 3f
	in a,(041h)		;3fbd	db 41
	and 004h		;3fbf	e6 04
	jr nz,Z64_PAR_WAIT		;3fc1	20 f7
	pop af			;3fc3	f1
	out (042h),a		;3fc4	d3 42
	ld a,004h		;3fc6	3e 04
	out (041h),a		;3fc8	d3 41
	xor a			;3fca	af
	out (041h),a		;3fcb	d3 41
	ret			;3fcd	c9
Z64_CHECK_BREAK:
	push hl			;3fce	e5
	ld hl,0fff7h		;3fcf	21 f7 ff  ; FLAGSnew
	bit 6,(hl)		;3fd2	cb 76
	pop hl			;3fd4	e1
	ret nz			;3fd5	c0
	ld a,07fh		;3fd6	3e 7f
	in a,(0feh)		;3fd8	db fe
	rra			;3fda	1f
	ret c			;3fdb	d8
	ld hl,0fff7h		;3fdc	21 f7 ff  ; FLAGSnew
	set 6,(hl)		;3fdf	cb f6
	bit 7,(hl)		;3fe1	cb 7e
	jr z,Z64_BREAK_DONE		;3fe3	28 10
	ld bc,KEY_AT		;3fe5	01 e8 03
Z64_BREAK_LOOP:
	ld a,000h		;3fe8	3e 00
	call Z64_OUTPUT_BYTE		;3fea	cd 76 3f
	dec bc			;3fed	0b
	ld a,b			;3fee	78
	or c			;3fef	b1
	jr nz,Z64_BREAK_LOOP		;3ff0	20 f6
	call Z64_PRINTCTL_INIT		;3ff2	cd 4e 3f
Z64_BREAK_DONE:
	call Z64_NL_FINISH		;3ff5	cd a4 3e
	ld hl,0fff7h		;3ff8	21 f7 ff  ; FLAGSnew
	res 6,(hl)		;3ffb	cb b6
	rst 8			;3ffd	cf
	inc c			;3ffe	0c
	nop			;3fff	00
