#!/bin/bash

# try e.g. name1="Hamilcar  Barca" ; name2="J S  Bach"; ./showpp.sh 1 2 $name1 "$name2" 

printf 'Unquoted:\n  $*:' 
printf " <%s>" $*
printf '\n  $@:' 
printf " <%s>" $@
printf "\n"

printf "\n"

printf 'Quoted:\n"$*":' 
printf " <%s>" "$*"
printf '\n"$@":' 
printf " <%s>" "$@"
printf "\n"
