#!/usr/bin/env bash

declare -Ai counter

while read line; do
    for ((i=0; i < ${#line}; i++)); do
        counter[${line:i:1}]+=1
    done
done

printf "A: %d\nC: %d\nG: %d\nT: %d\n" \
    ${counter[A]} ${counter[C]} ${counter[G]} ${counter[T]}
