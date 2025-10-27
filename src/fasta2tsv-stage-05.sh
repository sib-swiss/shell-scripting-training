#!/usr/bin/env bash

# stage 5: read the whole fasta file, 
# one line at a time.

while read line; do
    # 1st char of line
    first_char=${line:0:1}
    echo "$first_char"
done
