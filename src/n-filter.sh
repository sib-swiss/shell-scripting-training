#!/usr/bin/env bash

# Prints out sequences that contain Ns (see exam question 4).
#
# The input is a TAB-separated file with two fields: Fasta header and sequence
# (such as produced from Fasta by ./fasta2tsv-exam.sh)

while IFS=$'\t' read header sequence; do
	if [[ $sequence = *N* ]]; then
		printf "%s\t%s\n" "$header" "$sequence"
	fi
done
