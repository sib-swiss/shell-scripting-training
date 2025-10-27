#!/usr/bin/env bash

show_help() {
    printf "Usage: $(basename $0) [-ht]\n"
    printf "I/O: stdin/stdout\n"
}

HEADERS=
WARN_TABS=

# TODO: allow other separators than TAB (e.g. comma)
# TODO: handle separators in header line, e.g. by quoting (but then, escape any
# quotes...)
# TODO: allow the script to _warn_ about separator-in-header, without doing
# anything.

while :; do
    case "$1" in 
        -h)
            show_help
            exit
            ;;
        -t)
            HEADERS=1
            shift
            ;;
        -?*)
            printf "Unknown option $1, aborting.\n" >&2
            exit 1
            ;;
        *)
            break
    esac
done

set -u

echo '---'

[ "$HEADERS" ] && printf "Header\tSequence\n"

output_line=''

while read line; do
    first_char=${line:0:1}
    if [[ '>' = "$first_char" ]]; then
        # first, echo current output line
        #printf "$output_line\n"
        if [ "$output_line" ]; then printf "$output_line\n"; fi
        # then start a new output line
        printf -v output_line "%s\t" "${line:1}"
    else
        output_line="${output_line}${line}"
    fi
done

# last line 
printf "$output_line\n"
