#!/usr/bin/env bash

# stage 4: read the whole fasta file, 
# one line at a time.

while read line; do
    # print the line, just to check
    echo "$line"
done
