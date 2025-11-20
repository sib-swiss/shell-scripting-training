#!/usr/bin/env bash

n=$1
[[ -z $n ]] && n=5

for i in $( seq 1 "$n" ); do
    touch "empty_file_${i}.txt"
done

# Alternative style of loop:
# for ((i=1; i<=$n; i++)); do
#    touch empty_file_${i}.txt
# done

# Note: using brace expansions is not possible in this case, as this
# expansion occurs before parameter expansion (so before $n -> number).
# > touch empty_file_{1..$n}.txt  # does not work.

exit 0