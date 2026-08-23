; eToolkit EPROM - Machine Code Routines
; by Thomas B. Woods
; Extracted from eToolkit.ROM, offset $5700-$57CF
; Located in chunk 2 (display file area, $4000-$5FFF)
;
; These routines live in the display file area of the cartridge ROM.
; They are NOT directly executable from here — they are accessed
; when the BASIC program calls USR at various addresses.
;
; Three bootstrap routines at $57B0/$57BC/$57C7 (called as USR 55216,
; USR 55228, USR 55239 from BASIC) copy MC from $D700+ (RAM chunk 6)
; into $6200+ (RAM chunk 3) for the various toolkit functions.
;
; The routines at $5700-$57AC handle bank switching and string
; conversion, and are the templates that get copied to $6200+.

	org $5700

;================================================================
; Dispatcher ($6204 when copied to RAM)
; Called via: RANDOMIZE value: RANDOMIZE USR 25092
; Reads SEED ($5C76), saves/restores HSR (port $F4),
; switches to HOME bank (E=0) or alternate (E=$40),
; then calls address in HL from dispatcher table.
;================================================================
DISPATCH_HOME:
	ld e,$00		;5700  E=0: switch to HOME bank
	jr DISPATCH		;5702

DISPATCH_ALT:
	ld e,$40		;5704  E=$40: switch to alternate bank

DISPATCH:
	ld hl,($5C76)		;5706  HL = SEED (dispatch address)
	in a,($F4)		;5709  save current HSR
	push af
	ld a,e			;570C  switch bank via HSR
	out ($F4),a
	call $1264		;570F  call address (in HOME ROM context)
	pop af			;5712  restore original HSR
	out ($F4),a
	ret

;================================================================
; Hex string conversion ($6216 when copied to RAM)
; Converts byte in SEED low ($5C76) to 2-char hex string
; at the BASIC string workspace pointed to by CHANS ($5C4D)
;================================================================
HEX_CONVERT:
	ld a,($5C77)		;5716  high byte of SEED (iteration count?)
	ld hl,($5C4D)		;5719  HL = CHANS (string workspace pointer)
	call $6222		;571C  store high nibble
	ld a,($5C76)		;571F  low byte of SEED (value to convert)
	push af
	srl a			;5723  extract high nibble
	srl a
	srl a
	srl a
	push af
	call $623B		;572C  convert nibble to ASCII and store
	pop af
	sla a			;5730  extract low nibble
	sla a
	sla a
	sla a
	ld b,a
	pop af
	sub b			;573A  low nibble = original - (high << 4)
	add a,$30		;573B  convert to ASCII '0'-'9'
	cp $3A
	jr c,.store		;573F  if > '9', add 7 for 'A'-'F'
	add a,$07
.store:
	ld (hl),a		;5743
	inc hl
	ret

;================================================================
; Cleanup / mode restore ($6246 when copied to RAM)
; Adjusts string length byte in BASIC workspace
;================================================================
CLEANUP_1:
	ld hl,($5C4D)		;5746  CHANS
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl			;574E  back up 6 bytes to length field
	ld a,(hl)
	sub $80			;5750  clear bit 7 (length adjustment)
	ld (hl),a
	ret

;================================================================
; Binary string conversion ($6247 when copied to RAM)
; Converts byte in SEED to 8-char binary string ("01010011")
;================================================================
BIN_CONVERT:
	ld a,($5C77)		;5754  iteration control
	ld hl,($5C4D)		;5757  string workspace
	inc hl
	call $6223		;575B  setup
	ld a,($5C76)		;575E  byte to convert
	ld b,8			;5792  8 bits
.bit_loop:
	rla			;5794  rotate left through carry
	ld (hl),'1'		;5795  assume bit is 1
	jr c,.next		;5797
	ld (hl),'0'		;5799  bit was 0
.next:
	inc hl
	djnz .bit_loop		;579C
	ret

;================================================================
; Cleanup 2 ($6261 when copied to RAM)
; Same as CLEANUP_1 but at different entry point
;================================================================
CLEANUP_2:
	ld hl,($5C4D)		;579F
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	ld a,(hl)
	sub $80
	ld (hl),a
	ret

	nop			;57AD  padding
	rst $38			;57AE
	rst $38			;57AF

;================================================================
; Bootstrap 1: USR 55216 ($D7B0 in memory)
; Copies 22 bytes from $D700 to $6200 (dispatch routine)
; Called from BASIC line 1 during init
;================================================================
BOOTSTRAP_1:
	ld hl,$D700		;57B0  source in RAM chunk 6
	ld bc,$0016		;57B3  22 bytes
	ld de,$6200		;57B6  dest in RAM chunk 3
	ldir
	ret

;================================================================
; Bootstrap 2: USR 55228 ($D7BC in memory)
; Copies 64 bytes from $D716 to $6216 (hex converter + utilities)
; Called from BASIC line 201 (Hex/Dec Loader init)
;================================================================
BOOTSTRAP_2:
	ld hl,$D716		;57BC
	ld de,$6216		;57BF
	ld bc,$0040		;57C2  64 bytes
	jr BOOTSTRAP_1+9	;57C5  jump to LDIR; RET

;================================================================
; Bootstrap 3: USR 55239 ($D7C7 in memory)
; Copies 89 bytes from $D754 to $6216 (binary converter + utilities)
; Called from BASIC line 501 (Tri-Base Arithmetic init)
;================================================================
BOOTSTRAP_3:
	ld hl,$D754		;57C7
	ld de,$6216		;57CA
	ld bc,$0059		;57CD  89 bytes
	; falls through to LDIR; RET at $57B9
