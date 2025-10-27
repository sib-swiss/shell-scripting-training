#!/usr/bin/env python3

from subprocess import Popen, PIPE
from sys import argv

sequence = argv[1]

# Couldn't find how to redirect STDIN from a file. Probably possible with dup()
# or something, but definitely not easy to find. Hence I resort to a "useless"
# cat(1).

p1 = Popen(["cat", sequence], stdout=PIPE)
p2 = Popen(["tr", "-dc", "A"], stdin=p1.stdout, stdout=PIPE)
p3 = Popen(["wc", "-c"], stdin=p2.stdout, stdout=PIPE)
p1.stdout.close()
p2.communicate()[0]
print(p3.communicate()[0])

# Well, forget it. Anyway, even Python experts advise that it's easier to
# delegate pipes to the shell
# (https://stackoverflow.com/questions/295459/how-do-i-use-subprocess-popen-to-connect-multiple-processes-by-pipes).
