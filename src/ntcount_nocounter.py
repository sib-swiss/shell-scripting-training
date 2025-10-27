#!/usr/bin/env python3

from sys import stdin

counter = {}

for line in stdin:
    for nt in line:
        if nt in counter:
            counter[nt] = counter[nt] + 1
        else:
            counter[nt] = 1


print("A: {}\nC: {}\nG: {}\nT: {}\n".format(
    counter["A"],
    counter["C"],
    counter["G"],
    counter["T"]))
