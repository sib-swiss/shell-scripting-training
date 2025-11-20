#!/usr/bin/env bash

# Test command: to be removed when the script is functional.
# echo "Staring FASTA to TST converter..."

# If user passes an argument (input file), redirect stdin from that file.
[[ -n $1 ]] && exec < "$1"

# Guard against unset variables.
set -u

# 1. Read the first line, strip the leading '>` and trailing newline, and
#    print it, followed by a tab character.
read line
printf "%s\t" "${line:1}"

# 2. While there are lines in the file, read the next line.
while read line; do

    # Line is a header line.
    if [[ ${line:0:1} == ">" ]]; then
        # Print a newline (this starts a new record).
        # Print the header line (skipping the `>`), followed by a tab.
        printf "\n"
        printf "%s\t" "${line:1}"

    # Line is a sequence line.
    else
        # Print the sequence line without adding a newline at the end.
        printf "%s" "$line"
    fi
done
printf "\n"

exit 0
