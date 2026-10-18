"""Build dualscreen_E000_patched.bin from the original E000 image.
Every patch site is checked against its original bytes first.
New code is appended after the module (from E760)."""
from z80dis import z80

B = 0xE000
orig = open('dualscreen_E000.bin', 'rb').read()
img = bytearray(orig)

INVPAR, FULL = 0xE0C4, 0xE0D9          # error exit (BC=1); 'screen full' exit (BC=3)
COPY_RESUME, EXCH_RESUME = 0xE446, 0xE536
SCROLL_RESUME, CLR_RESUME, SCRL0 = 0xE13B, 0xE1E8, 0xE141

def w(v): return [v & 0xFF, v >> 8]

# ---- appended routines --------------------------------------------------
new = bytearray(); labels = {}; fix = []
def lab(n): labels[n] = B + len(orig) + len(new)
def emit(*bs): new.extend(bs)
def jp(op, target): emit(op); fix.append((len(new), target)); emit(0, 0)   # target may be label name

lab('FIXHL'); emit(0xE1)                          # POP HL
lab('FIXAF'); emit(0xF1); jp(0xC3, INVPAR)        # POP AF / JP INVPAR
lab('FIXDE'); emit(0xD1); jp(0xC3, 'FIXAF')       # POP DE / JP FIXAF

def range_check(reg_ops, resume):
    # entry: A = count (already known non-zero)
    emit(0xFE, 25); jp(0xD2, INVPAR)              # CP 25 / JP NC,INVPAR
    emit(0x67)                                    # LD H,A  (save count)
    for op in reg_ops:
        emit(0x7C, op); jp(0xDA, INVPAR)          # LD A,H / ADD A,r / JP C,INVPAR
        emit(0xFE, 25); jp(0xD2, INVPAR)          # CP 25 / JP NC,INVPAR
    emit(0x7C); jp(0xC3, resume)                  # LD A,H / JP resume

lab('CHKCPY'); range_check([0x80, 0x81], COPY_RESUME)   # B = from line, C = to line
lab('CHKEXC'); range_check([0x81, 0x83], EXCH_RESUME)   # C = line 1,   E = line 2

lab('CHKSCR')                                     # entry: A = B = count (non-zero)
emit(0x81); jp(0xDA, INVPAR)                      # ADD A,C / JP C,INVPAR
emit(0xFE, 25); jp(0xD2, INVPAR)                  # CP 25 / JP NC,INVPAR
emit(0x79, 0xA7); jp(0xCA, INVPAR)                # LD A,C / AND A / JP Z,INVPAR (first line 0)
jp(0xC3, SCROLL_RESUME)

lab('CHKCLR')                                     # entry: A = B = count (non-zero)
emit(0x81); jp(0xDA, INVPAR)                      # ADD A,C / JP C,INVPAR
emit(0xFE, 25); jp(0xD2, INVPAR)                  # CP 25 / JP NC,INVPAR
jp(0xC3, CLR_RESUME)

lab('CHKAUTO')                                    # automatic scroll: BC = (SCRCTL)
emit(0x78, 0xA7); jp(0xCA, FULL)                  # LD A,B / AND A / JP Z,full
emit(0x81); jp(0xDA, FULL)                        # ADD A,C / JP C,full
emit(0xFE, 25); jp(0xD2, FULL)                    # CP 25 / JP NC,full
emit(0x79, 0xA7); jp(0xCA, FULL)                  # LD A,C / AND A / JP Z,full
jp(0xC3, SCRL0)

for pos, t in fix:
    v = labels[t] if isinstance(t, str) else t
    new[pos:pos + 2] = bytes(w(v))

# ---- patch sites -----------------------------------------------------------
L = labels
sites = [  # (address, original bytes, new bytes, why)
 (0xE441, [0xFE, 25, 0xD2] + w(INVPAR), [0xC3] + w(L['CHKCPY']) + [0, 0], 'COPYSC: count check -> also check line+count'),
 (0xE44A, [0xDA] + w(INVPAR), [0xDA] + w(L['FIXAF']), 'COPYSC: pop AF before error exit'),
 (0xE453, [0xDA] + w(INVPAR), [0xDA] + w(L['FIXHL']), 'COPYSC: pop HL, AF before error exit'),
 (0xE531, [0xFE, 25, 0xD2] + w(INVPAR), [0xC3] + w(L['CHKEXC']) + [0, 0], 'EXCHSC: count check -> also check line+count'),
 (0xE53D, [0xDA] + w(INVPAR), [0xDA] + w(L['FIXDE']), 'EXCHSC: pop DE, AF before error exit'),
 (0xE546, [0xDA] + w(INVPAR), [0xDA] + w(L['FIXHL']), 'EXCHSC: pop HL, AF before error exit'),
 (0xE130, [0x81, 0xFE, 1, 0xDA] + w(INVPAR), [0xC3] + w(L['CHKSCR']) + [0, 0, 0], 'SCROLL: reject first line 0 and 8-bit overflow'),
 (0xE1DD, [0x81, 0xFE, 1, 0xDA] + w(INVPAR), [0xC3] + w(L['CHKCLR']) + [0, 0, 0], 'CLRSCN: reject 8-bit overflow'),
 (0xE0EB, [0xC3] + w(SCRL0), [0xC3] + w(L['CHKAUTO']), 'automatic scroll: validate SCRCTL, else report screen full'),
]
for a, old, newb, why in sites:
    o = a - B
    assert list(img[o:o + len(old)]) == old, (hex(a), img[o:o + len(old)].hex(), bytes(old).hex())
    assert len(newb) == len(old)
    img[o:o + len(old)] = bytes(newb)

out = bytes(img) + bytes(new)
open('dualscreen_E000_patched.bin', 'wb').write(out)

if __name__ == '__main__':
    print('size', len(out), 'end', hex(B + len(out) - 1))
    for n, v in sorted(labels.items(), key=lambda x: x[1]): print(f'  {n:8} {v:04X} ({v})')
    # disassemble the appended block
    a = B + len(orig); p = 0
    while p < len(new):
        n = {0xC3: 3, 0xCA: 3, 0xD2: 3, 0xDA: 3, 0xFE: 2}.get(new[p], 1)
        name = [k for k, v in labels.items() if v == a + p]
        print(f'{a+p:04X}  {new[p:p+n].hex():8} {name[0] if name else "":8} {z80.disasm(bytes(new[p:p+n]), a+p)}')
        p += n
    for a_, old, nb, why in sites:
        print(f'{a_:04X} {bytes(old).hex():14} -> {bytes(nb).hex():14} {z80.disasm(bytes(nb), a_):18} {why}')
