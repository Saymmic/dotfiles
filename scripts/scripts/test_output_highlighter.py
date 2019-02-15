#!/usr/bin/python3

import sys

from pygments import highlight
from pygments.formatters.terminal import TerminalFormatter
from pygments.lexers import get_lexer_by_name
from termcolor import colored


def bold_relevant_trace_lines(traceback: str):
    color_line = False
    colored_lines = []
    for line in traceback.split('\n'):
        if 'File' in line and 'dist-packages' not in line:
            color_line = True
        if 'dist-packages' in line:
            color_line = False
        if color_line:
            line = colored(line, attrs=['bold'])
        colored_lines.append(line)
    return '\r\n'.join(colored_lines)


def colorize_traceback(traceback: str) -> str:
    lexer = get_lexer_by_name("pytb", stripall=True)
    formatter = TerminalFormatter()
    return highlight(traceback, lexer, formatter)


line: str
is_traceback = False
tb = []
for line in sys.stdin:
    if 'Traceback (most recent call last):' in line:
        is_traceback = True
    if '------' in line or '======' in line:
        is_traceback = False
        sys.stdout.write(bold_relevant_trace_lines(colorize_traceback(''.join(tb))))
        tb = []
    if is_traceback:
        tb.append(line)
        continue
    sys.stdout.write(line)
