#!/usr/bin/env bash

# stage 8: as before, but suppresses the unneeded leading newline and supplies
# the missing trailing newline

# Assumes (rather reasonably) that the 1st line is a header
read line
printf "%s\t" "${line:1}"

while read line; do
    # 1st char of line
    first_char=${line:0:1}
    if [[ '>' == "$first_char" ]] ; then
        printf '\n%s\t' "${line:1}"
    else
        printf "%s" "$line"
    fi
done

printf "\n" 
