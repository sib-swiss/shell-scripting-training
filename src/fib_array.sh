#!/bin/bash

fib_numbers=()

n=$1

fib_numbers[0]=1
fib_numbers[1]=1

for ((i=2; i<=n; i++)); do
    fib_numbers[i]=$((${fib_numbers[i-1]} + ${fib_numbers[i-2]}))
done

echo ${fib_numbers[n]}
