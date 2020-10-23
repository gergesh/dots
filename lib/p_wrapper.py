#!/usr/bin/env python3
# This script handles the "p" shell shortcut
# Example usage: `p 'A'*300 #> as.txt`

import pickle
from ast import parse
from contextlib import redirect_stdout, suppress
from io import StringIO
from pathlib import Path
from sys import argv, path, stderr


def die(limit=None):
    import traceback
    o = StringIO()
    o.write('\n')
    traceback.print_exc(limit=limit, file=o, chain=False)
    print(o.getvalue()[:-1], end='', file=stderr)
    exit(1)


LAST_RESULT = Path('~/.cache/p_last.pkl').expanduser()
path.insert(0, '')
try:
    ast = parse(argv[1], mode='single').body
except SyntaxError:
    die(limit=0)

g = {'Path': Path}
if LAST_RESULT.is_file():
    with LAST_RESULT.open('rb') as f:
        with suppress(EOFError):
            g['_'] = pickle.load(f)

o = StringIO()
out = ''
with redirect_stdout(o):
    try:
        exec(argv[1][: ast[-1].col_offset], g, g)
        try:
            out = eval(argv[-1][ast[-1].col_offset : ast[-1].end_col_offset], g, g)
        except SyntaxError:
            exec(argv[-1][ast[-1].col_offset : ast[-1].end_col_offset], g, g)
    except Exception:
        die()

out = o.getvalue() or out

sp = argv[1][ast[-1].end_col_offset :]
sp = sp[sp.find('#'):][1:]
if sp:
    from subprocess import check_output
    if not isinstance(out, bytes):
        out = str(out).encode()
    out = check_output(f'cat {sp}', shell=True, input=out).rstrip().decode()
if out is not None and (not isinstance(out, str) or out.strip()):
    print(f'\n{out}', end='')
    with LAST_RESULT.open('wb') as f:
        with suppress(TypeError):
            pickle.dump(out, f)
