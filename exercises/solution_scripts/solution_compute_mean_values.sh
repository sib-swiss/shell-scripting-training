#!/usr/bin/env bash

# In this script we have a series of measures stored in arrays, and we want to
# compute the mean and variance of each array.

# Arrays for which to compute the mean and sum.
ages=(75 100 105 80 115)
weights=(10 30 20 15 25)
lengths=(10 15 20 15 10)

function sum {
    # echo "computing sum of $# numbers: $*" >&2
    local sum=0
    for n in "$@"; do
        (( sum += n ))
    done
    echo $sum
}

# Function that computes the mean of an array of values.
function mean {
    mean=$(( $(sum "$@") / $# ))  # Note: "$#" is the number of elements in "$@".
    echo $mean
}

# Compute the mean for each array, by calling the `mean` function.
mean_age=$(mean "${ages[@]}")
mean_weight=$(mean "${weights[@]}")
mean_length=$(mean "${lengths[@]}")

# Print mean values:
printf "Age:\tmean=%.2f\n" "$mean_age"
printf "Weight:\tmean=%.2f\n" "$mean_weight"
printf "Length:\tmean=%.2f\n" "$mean_length"
