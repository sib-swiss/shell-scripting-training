#!/usr/bin/env python3

from sys import stdin
from collections import Counter

counter = Counter()
for line in stdin:
    counter = counter + Counter(line)

print("A: {}\nC: {}\nG: {}\nT: {}\n".format(
    counter["A"],
    counter["C"],
    counter["G"],
    counter["T"]))
