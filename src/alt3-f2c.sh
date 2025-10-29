#!/bin/bash

# vim: ft=bash

set -ue

# This version treats the 1st line differently, and so has fewer tests;
# OTOH it launches a sed command.

read line
printf "%s\t" "${line:1}"

while read line; do
    if [[ "$line" =~ '>' ]] ; then
        printf "\n%s\t" "${line:1}"
    else
        printf "%s" "$line"
    fi
done 
