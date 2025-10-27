#!/usr/bin/env bash

# stage 10: user-specified separator

# If the first argument is '-s', then the second argument is the separator

OUTPUT_FIELD_SEPARATOR=$'\t' # ANSI quoting: understands \t, \n etc.
if [[ "$1" == '-s' ]] ; then
    OUTPUT_FIELD_SEPARATOR=$2
    shift 2 # so that any filename argument is now $1
fi

# If there still is an argument, treat it as a filename and redirect standard
# input to that filename. This is like '<' on the command line, except it's done
# from within the script.

[[ "$1" ]] && exec < "$1"

# Tis is the short form of:

#if [[ "$1" ]] ; then
#    exec <"$1"
#fi

# Assumes (rather reasonably) that the 1st line is a header
read line
printf "%s%s" "${line:1}" "$OUTPUT_FIELD_SEPARATOR" 

while read line; do
    # 1st char of line
    first_char=${line:0:1}
    if [[ '>' == "$first_char" ]] ; then
        printf '\n%s%s' "${line:1}" "$OUTPUT_FIELD_SEPARATOR" 
    else
        printf "%s" "$line"
    fi
done

printf "\n" 
