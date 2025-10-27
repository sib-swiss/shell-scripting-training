#!/usr/bin/env bash


# stage 11: user-specified separator

function print_header {
    local header=$1
    printf '%s%s' "${header:1}" "$OUTPUT_FIELD_SEPARATOR" 
}

function show_help {
	cat<<END
f2c [-hst] <file|stdin>

(some description)
END
}


# If the first argument is '-s', then the second argument is the separator

OUTPUT_FIELD_SEPARATOR=$'\t' # ANSI quoting: understands \t, \n etc.
TITLES=

while [[ "$1" ]]; do
	case $1 in
		-h | --help )
			show_help
			exit 0
			;;
		-s )
			OUTPUT_FIELD_SEPARATOR=$2
			shift 2;
			;;
		-t | --headers )
			TITLES=1
			shift
			;;
		* ) 
			break
			;;
	esac
done

# If there still is an argument, treat it as a filename and redirect standard
# input to that filename. This is like '<' on the command line, except it's done
# from within the script.

[[ "$1" ]] && exec < "$1"

[[ $TITLES ]] && printf "header%ssequence\n" "$OUTPUT_FIELD_SEPARATOR"

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
