#!/usr/bin/env python3
# This script handles the "p" shell shortcut
# Example usage: `p 'A'*300 #> as.txt`

from contextlib import redirect_stdout
from io import StringIO
from sys import argv

cmd = argv[1]
q = None
i = 0
s = 0
ex = []
while i < len(cmd):
    c = cmd[i]
    if c == '\\':
        i += 1
    elif q is None:
        if c in '\'"':
            q = c
        elif c == ';':
            ex.append(cmd[s:i])
            s = i + 1
        elif c == '#':
            break
    elif c == q:
        q = None
    i += 1

ev = cmd[s:i]
sp = cmd[i+1:]
g, l = {}, {}
o = StringIO()
with redirect_stdout(o):
    for e in ex:
        exec(e, g, l)
    out = eval(ev, g, l)
o.seek(0)
out = o.read() or out

if sp:
    from subprocess import check_output
    if not isinstance(out, bytes):
        out = str(out).encode()
    out = check_output(f'cat {sp}', shell=True, input=out).rstrip().decode()
print(f'\n{out}', end='')
