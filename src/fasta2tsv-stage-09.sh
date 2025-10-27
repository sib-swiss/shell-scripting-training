#!/usr/bin/env bash

# stage 9: allow filename argument.

# If there is an argument, treat it as a filename and redirect standard input to
# that filename. This is like '<' on the command line, except it's done from
# within the script.

[[ "$1" ]] && exec < "$1"

# Tis is the short form of:

#if [[ "$1" ]] ; then
#    exec <"$1"
#fi

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
