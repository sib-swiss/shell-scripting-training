#!/usr/bin/env bash

# Assign first and second command line arguments to variables.
# Note: quoting of variables is not needed here, as word splitting does
# not occur during variable assignment.
name=$1
day=$2

# Test that user passed input values.
[[ -z $name ]] && echo "Error: name parameter is required" && exit 1
[[ -z $day ]] && echo "Error: day parameter is required" && exit 1

# Past this point, there should be no unbound variables.
set -u

echo "Hello $name, what a nice $day"
exit 0
