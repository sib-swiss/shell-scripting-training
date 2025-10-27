#!/usr/bin/env bash

# stage 13: implement separator

function show_help {
	cat <<END
"usage: fasta2csv [options] <fasta file>"

Options:

	 -h: this help

	 -t: output headers

	 -s: <character> specify separator (default: TAB)
END
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
printf "%s%s" "${line:1}" "$SEPARATOR"

while read line; do
    # 1st char of line
    first_char=${line:0:1}
    if [[ '>' == "$first_char" ]] ; then
        printf '\n%s%s' "${line:1}" "$SEPARATOR"
    else
        printf "%s" "$line"
    fi
done

printf "\n" 
