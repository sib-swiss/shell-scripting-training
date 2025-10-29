#!/bin/bash

# vim: ft=bash

set -ue

# This version removes the spurious '\n' at the end, and so has fewer tests;
# OTOH it launches a sed command.

while read line; do
    if [[ "$line" =~ '>' ]] ; then
        printf "\n%s\t" "${line:1}"
    else
        printf "%s" "$line"
    fi
done | sed '/^$/{d;q}'
