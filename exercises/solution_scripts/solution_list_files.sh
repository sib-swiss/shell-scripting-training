#!/usr/bin/env bash

input_dir=$1
echo "List of files in directory: $1"

# Note: `$input_dir` must be quoted to avoid word splitting. This is for the
# case where the input directory would contain a white space.
for file in "$input_dir"/*; do
    echo "$file"
done

exit 0
