#!/usr/bin/env bash

# Load input_file.
input_file=data/sample_01.fasta

# Tests whether the file exists.
[[ -f $input_file ]] || { echo "Error: file '${input_file}' does not exist" && exit 1;}

# Read first line of file.
line=$(head -1 $input_file)

# Test if line starts with ">"
[[ ${line:0:1} == ">" ]] && echo "The file '$input_file' Looks like a fasta file."

# Alternative solutions.
[[ $line == \>* ]] && echo "Looks like a fasta file."
[[ $line =~ ^\>.* ]] && echo "Looks like a fasta file."
[ "${line:0:1}" == ">" ] && echo "Looks like a fasta file."

# Test if line starts with ">"
if [[ ${line:0:1} == ">" ]]; then
  echo "File '$input_file' looks like a FASTA file."
else
  echo "File '$input_file' does not look like a FASTA file."
fi

# Solution without creating an intermediate "line" variable.
if [[ $(head -1 $input_file | cut -c1) == ">" ]]; then
  echo "File '$input_file' looks like a FASTA file."
else
  echo "File '$input_file' does not look like a FASTA file."
fi

exit 0
