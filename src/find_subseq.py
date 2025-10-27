#!/usr/bin/env python3

from sys import argv
from sys import stdin

subseq = argv[1]

for line in stdin:
    if line.find(subseq) != -1:
        print(line)

