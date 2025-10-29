#!/bin/bash

set -u

n=${1-10}

row=(1)
echo "${row[*]}"

for ((i=2; i<=n; i=i+1)); do
    new_row[0]=1
    for ((j=1; j<i; j++)); do
        new_row[j]=$((row[j]+row[j-1]))
    done
    row=(${new_row[@]})
    echo "${row[*]}"
done

