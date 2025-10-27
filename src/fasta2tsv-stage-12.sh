#!/usr/bin/env bash

# stage 12: more options

function show_help {
	cat <<END
"usage: fasta2csv [options] <fasta file>"

Options:

	 -h: this help

	 -t: output headers

	 -s: <character> specify separator (default: TAB)
END
}

function print_header {
    local header=$1
    printf '%s%s' "${header:1}" "$SEPARATOR" 
}

# Defaults: they may be overridden by options.

TITLES= # could use TITLES=0, but then we should test differently.
SEPARATOR=$'\t' # ANSI quoting: understands \t, \n etc.

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
            SEPARATOR=$2
            shift 2
            ;;
        *)
            #printf "end of options detected\n"
            break
            ;;
    esac
done


# If there still is an argument, treat it as a filename and redirect standard
# input to that filename. This is like '<' on the command line, except it's done
# from within the script.

[[ "$1" ]] && exec < "$1"

[[ "$TITLES" ]] && printf "header%ssequence\n" "$SEPARATOR"

# Assumes (rather reasonably) that the 1st line is a header
read line
print_header "$line"

while read line; do
    # 1st char of line
    first_char=${line:0:1}
    if [[ '>' == "$first_char" ]] ; then
        printf '\n'
        print_header "$line"
    else
        printf "%s" "$line"
    fi
done

printf "\n" 
