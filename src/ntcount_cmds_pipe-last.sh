#!/usr/bin/env bash

tee >(printf "A: %s\n" $(tr -dc A | wc -c) >&2) \
    >(printf "C: %s\n" $(tr -dc C | wc -c) >&2) \
    >(printf "G: %s\n" $(tr -dc G | wc -c) >&2) \
    | printf "T: %s\n" $(tr -dc T | wc -c) >&2
