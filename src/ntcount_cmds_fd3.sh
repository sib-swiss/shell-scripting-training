#!/usr/bin/env bash

# For some reason this is significantly slower than ntcount_cmds.sh

{   tee /dev/fd/3 | printf "A: %d\n" "$(tr -dc A | wc -c)" >&2; } 3>&1 \
| { tee /dev/fd/3 | printf "C: %d\n" "$(tr -dc C | wc -c)" >&2; } 3>&1 \
| { tee /dev/fd/3 | printf "G: %d\n" "$(tr -dc G | wc -c)" >&2; } 3>&1 \
|                   printf "T: %d\n" "$(tr -dc T | wc -c)" >&2;
