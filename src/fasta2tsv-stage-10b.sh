#!/usr/bin/env bash

# stage 10: user-specified separator

check_for_separator() {
    local header=$1
    # NOTE: *\t* does NOT work! - At some point the \ is discarded, resulting in
    # a 't' which will match any literal 't' in the header.
    if [[ $header == *$'\t'* ]]; then
        printf "ERROR: header\n'%s'\ncontains a TAB\n" "$header" >&2
        declare -p header
        exit 1
    fi
}

[[ "$1" ]] && exec < "$1"

# Assumes (rather reasonably) that the 1st line is a header
read line
check_for_separator "$line"
printf "%s%s" "${line:1}" $'\t' 

while read line; do
    # 1st char of line
    check_for_separator "$line"
    first_char=${line:0:1}
    if [[ '>' == "$first_char" ]] ; then
        printf '\n%s%s' "${line:1}" $'\t' 
    else
        printf "%s" "$line"
    fi
done

printf "\n" 
