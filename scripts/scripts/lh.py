#!/usr/bin/python3

import re
import sys

from termcolor import colored

ansi_escape = re.compile(r'\x1B\[[0-?]*[ -/]*[@-~]')
normal_log = re.compile(r'\[\d+/\d+/\d+ \d+:\d+:\d+\]')

line: str
color_line = False
for line in sys.stdin:
    if 'File' in line and 'dist-packages' not in line:
        color_line = True
    if normal_log.search(line) or 'dist-packages' in line:
        color_line = False
    if color_line:
        prefix, value = line.split('|', 1)
        value = ansi_escape.sub('', value)
        line = f'{prefix}|{colored(value, "green")}'
    sys.stdout.write(line)
