#!/usr/bin/env bash

# stage 15: a function for quoting strings

# Functions

function show_help {
	cat <<END
"usage: fasta2csv [options] <fasta file>"

Options:

	 -h: this help

	 -t: output headers

	 -s: <character> specify separator (default: TAB)
END
}

contains_separator() {
    local line="$1"
    [[ "$line" == *${SEPARATOR}* ]] 
}

warn_separator() {
    local line="$1"
    printf "WARNING: %s contains a separator\n" "$line" >&2
}

double_quote() {
    # surrounds arg with double quotes, escaping any internal double quotes
    local string="$1"
    printf "\"%s\"" "${string//\"/\\\"}"
}

# Defaults: they may be overridden by options.

TITLES= # could use TITLES=0, but then we should test differently.
SEPARATOR=$'\t' # "\t" or '\t' won't work

while [[ "$@" ]] ; do
    #printf '$1: %s\n' "$1"
    case "$1" in
        -h)
            show_help
            exit 0
            ;;
        -t)
            #printf "titles ON\n"
            TITLES=1
            shift
            ;;
        -s)
            #printf "separator: '$2'\n"
            SEPARATOR="$2"
            shift 2
            ;;
        *)
            #printf "end of options detected\n"
            break
            ;;
    esac
done

#printf "Arguments after parsing options %s\n" "$@"

# If there is an argument, treat it as a filename and redirect standard input to
# that filename. This is like '<' on the command line, except it's done from
# within the script.

[[ "$1" ]] && exec < "$1"

[[ "$TITLES" ]] && printf "header%ssequence\n" "$SEPARATOR"

# Assumes (rather reasonably) that the 1st line is a header
read line

# the following 5 lines are repeated below: they should be put into a function
line="${line:1}"
if contains_separator "$line" ; then
    warn_separator "$line"
    line=$(double_quote "$line")
fi
printf "%s%s" "${line:1}" "$SEPARATOR"

while read line; do
    # 1st char of line
    first_char=${line:0:1}
    if [[ '>' == "$first_char" ]] ; then
        line="${line:1}"
        if contains_separator "$line" ; then
            warn_separator "$line"
            line=$(double_quote "$line")
        fi
        printf '\n%s%s' "${line}" "$SEPARATOR"
    else
        printf "%s" "$line"
    fi
done

printf "\n" 
