#!/bin/bash

venomous=(Vipera Vespa Chironex Atrax Naja)
snakes=(Natrix Vipera Naja Coluber Lampropeltis)

element_of() {
    needle=$1
    shift;
    for hay in "$@"; do [[ $hay == $needle ]] && return 0; done
    return 1
}

# A1 inter  A2
intersection() {
    # -n: name references ("namerefs")
    declare -ln a1=$1
    declare -ln a2=$2
    declare -ln result=$3
    for e in "${a1[@]}"; do
        element_of "$e" "${a2[@]}" && result+=("$e")
    done
}
