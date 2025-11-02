#!/bin/bash

echo "The list of input arguments is:"
for arg in "$@"; do
    echo "* Argument: $arg"
done

echo -e "\nNow grep for cyanobacteria in the input data..."
grep Cyanobacteria

exit 0
