#!/usr/bin/env python3
# This script handles the "py" shell shortcut

from sys import argv

cmd = argv[1]
for_shell = None
if '>' in cmd or '|' in cmd:
    import shlex
    parts = shlex.split(cmd, posix=False)
    real_cmd = []
    for i, p in enumerate(parts):
        if p == '>' or p == '|':
            for_shell = ' '.join(parts[i:])
            break
        else:
            real_cmd.append(p)
    cmd = ' '.join(real_cmd)

ss = cmd.split(';')
for s in ss[:-1]:
    exec(s)
out = eval(ss[-1])
if isinstance(out, bytes):
    out = out.decode()
out = str(out)
if for_shell is None:
    print('\n' + out, end='')
else:
    from subprocess import check_output
    print(check_output(['echo {} {}'.format(shlex.quote(out), for_shell)], shell=True)[:-1].decode(), end='' if '>' in for_shell else '\n')
