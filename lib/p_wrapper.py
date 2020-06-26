#!/usr/bin/env python3
# This script handles the "p" shell shortcut
# Example usage: `p 'A'*300 #> as.txt`

import pickle
from contextlib import redirect_stdout
from io import StringIO
from pathlib import Path
from sys import argv, stderr

LAST_RESULT = Path('~/.cache/p_last.pkl').expanduser()

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
if LAST_RESULT.is_file():
    with LAST_RESULT.open('rb') as f:
        g['_'] = pickle.load(f)
o = StringIO()
out = ''
with redirect_stdout(o):
    try:
        for e in ex:
            exec(e, g, l)
        try:
            out = eval(ev, g, l)
        except SyntaxError:
            exec(ev, g, l)
    except Exception as e:
        import traceback
        o = StringIO()
        o.write('\n')
        traceback.print_exc(file=o, chain=False)
        print(o.getvalue()[:-1], end='', file=stderr)
        exit()

out = o.getvalue() or out

if sp:
    from subprocess import check_output
    if not isinstance(out, bytes):
        out = str(out).encode()
    out = check_output(f'cat {sp}', shell=True, input=out).rstrip().decode()
if out and (type(out) != str or out.strip()):
    print(f'\n{out}', end='')
    with LAST_RESULT.open('wb') as f:
        pickle.dump(out, f)
