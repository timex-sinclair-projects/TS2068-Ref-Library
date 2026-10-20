"""Build patched E000h images of ADL ASC 003 (40-column) and ASC 002 (80-column)
from the original images relocated from the transcriptions.

Every patch site is checked against its original bytes before it is changed.
The checking code is appended after the end of the module.

Usage: python3 patch.py 40|80   (reads col40_E000.bin / col80_E000.bin,
                                 writes col40_E000_patched.bin / col80_..)"""
import sys

B = 0xE000
CFG = {
  # module offsets (from the listings); INVPAR = BC=1 exit, FULL = 'screen full' exit
  # that also resets SCRLCT to 1, SCRL0 = scroll worker.
  '40': dict(INVPAR=0x013F, FULL=0x0154, SCRL0=0x01BC,
             SCROLL_ADD=0x01AB, SCROLL_RESUME=0x01B6,   # lines 386-391
             CLR_ADD=0x0258, CLR_RESUME=0x0263,         # lines 518-523
             AUTO_JP=0x0166,                            # line 312
             SETATT=None),
  '80': dict(INVPAR=0x0147, FULL=0x015C, SCRL0=0x01E4,
             SCROLL_ADD=0x01D3, SCROLL_RESUME=0x01DE,   # lines 433-438
             CLR_ADD=0x0281, CLR_RESUME=0x028C,         # lines 562-567
             AUTO_JP=0x016E,                            # line 338
             SETATT=dict(site=0x0315, ret=0x031A, attbyt=0x0039)),  # lines 670-673
}

def w(v): return [v & 0xFF, v >> 8]

def build(m):
    c = CFG[m]
    orig = open(f'col{m}_E000.bin', 'rb').read()
    img = bytearray(orig)
    A = lambda off: B + off                     # absolute address of a module offset
    new = bytearray(); labels = {}; fix = []
    def lab(n): labels[n] = B + len(orig) + len(new)
    def emit(*bs): new.extend(bs)
    def jp(op, target): emit(op); fix.append((len(new), target)); emit(0, 0)

    INVPAR, FULL = A(c['INVPAR']), A(c['FULL'])

    lab('CHKSCR')                               # entry: A = B = count (non-zero), C = first line
    emit(0x81); jp(0xDA, INVPAR)                # ADD A,C / JP C,INVPAR   (8-bit overflow)
    emit(0xFE, 25); jp(0xD2, INVPAR)            # CP 25   / JP NC,INVPAR  (first+count > 24)
    emit(0x79, 0xA7); jp(0xCA, INVPAR)          # LD A,C / AND A / JP Z,INVPAR (first line 0)
    jp(0xC3, A(c['SCROLL_RESUME']))

    lab('CHKCLR')                               # entry: A = B = count (non-zero), C = first line
    emit(0x81); jp(0xDA, INVPAR)                # ADD A,C / JP C,INVPAR
    emit(0xFE, 25); jp(0xD2, INVPAR)            # CP 25   / JP NC,INVPAR
    jp(0xC3, A(c['CLR_RESUME']))

    lab('CHKAUTO')                              # automatic scroll: BC = (SCRCTL)
    emit(0x78, 0xA7); jp(0xCA, FULL)            # LD A,B / AND A / JP Z,full   (count 0)
    emit(0x81); jp(0xDA, FULL)                  # ADD A,C / JP C,full          (overflow)
    emit(0xFE, 25); jp(0xD2, FULL)              # CP 25 / JP NC,full           (past line 23)
    emit(0x79, 0xA7); jp(0xCA, FULL)            # LD A,C / AND A / JP Z,full   (first line 0)
    jp(0xC3, A(c['SCRL0']))

    sites = [  # (offset, original bytes, new bytes, why)
     (c['SCROLL_ADD'], [0x81, 0xFE, 1, 0xDA] + w(INVPAR), None, 'CHKSCR', 'SCROLL: reject 8-bit overflow and first line 0'),
     (c['CLR_ADD'],    [0x81, 0xFE, 1, 0xDA] + w(INVPAR), None, 'CHKCLR', 'CLRSCN: reject 8-bit overflow'),
     (c['AUTO_JP'],    [0xC3] + w(A(c['SCRL0'])),         None, 'CHKAUTO', 'automatic scroll: validate SCRCTL, else report screen full'),
    ]
    if c['SETATT']:
        s = c['SETATT']
        lab('FIXATT')                           # entry: A = ink << 3 (from POP AF), C = ink
        emit(0x2F)                              # CPL
        emit(0xE6, 0x38)                        # AND 38H   (keep only the paper bits)
        emit(0xB1)                              # OR C
        emit(0x32, *w(A(s['attbyt'])))          # LD (ATTBYT),A
        jp(0xC3, A(s['ret']))                   # JP GOODRET (the original next instruction)
        sites.append((s['site'], [0x2F, 0xB1, 0x32] + w(A(s['attbyt'])), None, 'FIXATT',
                      'SETATT: store paper = complement of ink, FLASH/BRIGHT 0'))

    for pos, t in fix:
        new[pos:pos + 2] = bytes(w(labels[t] if isinstance(t, str) else t))

    done = []
    for off, old, _, target, why in sites:
        assert list(img[off:off + len(old)]) == old, (m, hex(A(off)), img[off:off + len(old)].hex(), bytes(old).hex())
        nb = [0xC3] + w(labels[target]) + [0] * (len(old) - 3)   # JP target, NOPs over the rest
        img[off:off + len(old)] = bytes(nb)
        done.append((A(off), bytes(old), bytes(nb), why))
    out = bytes(img) + bytes(new)
    open(f'col{m}_E000_patched.bin', 'wb').write(out)
    return out, labels, done, len(orig)

if __name__ == '__main__':
    from z80dis import z80
    for m in sys.argv[1:] or ['40', '80']:
        out, labels, done, n0 = build(m)
        print(f'== ASC {"003" if m == "40" else "002"} ({m}-col): size {len(out)}, end {B + len(out) - 1:04X}')
        for n, v in sorted(labels.items(), key=lambda x: x[1]): print(f'  {n:8} {v:04X}')
        a = B + n0; p = 0; extra = out[n0:]
        while p < len(extra):
            n = {0xC3: 3, 0xCA: 3, 0xD2: 3, 0xDA: 3, 0xFE: 2, 0xE6: 2, 0x32: 3}.get(extra[p], 1)
            name = [k for k, v in labels.items() if v == a + p]
            print(f'  {a+p:04X}  {extra[p:p+n].hex():8} {name[0] if name else "":8} {z80.disasm(bytes(extra[p:p+n]), a+p)}')
            p += n
        for ad, old, nb, why in done:
            print(f'  site {ad:04X} {old.hex():14} -> {nb.hex():14} {why}')
