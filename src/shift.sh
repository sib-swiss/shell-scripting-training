#!/bin/bash

while [[ "$*" ]]; do
    printf '"$@":' 
    printf " <%s>" "$@"
    printf "\n"
    printf '(shift)\n'
    shift
done
