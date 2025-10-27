#!/bin/bash

# vim: ft=bash

set -ue

first_line=1


# This version does not store lines and should be faster.

while read line; do
    if [[ "$line" =~ '>' ]] ; then
        if [[ "$first_line" ]] ; then 
            first_line=
        else
            printf "\n"
        fi
        printf "%s\t" "${line:1}"
    else
        printf "%s" "$line"
    fi
done
