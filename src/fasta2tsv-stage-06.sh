#!/usr/bin/env bash

# stage 6: read the whole fasta file, 
# distinguish headers from sequence
# lines based on 1st char.

while read line; do
    # 1st char of line
    first_char=${line:0:1}
    echo -n "first char: $first_char - "
    if [[ '>' == "$first_char" ]] ; then
        echo 'header'
    else
        echo 'sequence'
    fi
done
