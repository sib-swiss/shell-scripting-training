#!/usr/bin/env python3

from sys import argv
from sys import stdin
from os  import popen

subseq = argv[1]

print(popen('grep {}'.format(subseq)).read())
