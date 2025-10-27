#!/bin/bash

IFS=$'\t'
while read hdr seq; do
    if [[ $seq = *N* ]]; then
        printf "%s\t%s\n" "$hdr" "$seq"
    fi
done
unset IFS
