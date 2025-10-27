#!/usr/bin/env bash

# stage 7: read the whole fasta file, 
# start a new line for headers, otherwise just append line.
# Skip the leading >.

while read line; do
    # 1st char of line
    first_char=${line:0:1}
    if [[ '>' == "$first_char" ]] ; then
        printf '\n%s\t' "${line:1}"
    else
        printf "%s" "$line"
    fi
done
