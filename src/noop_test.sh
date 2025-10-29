#!/usr/bin/env bash
#

set -u

BASE_DIR="$(dirname "$(readlink -f $0)")"

# This function does nothing
noop(){ :; }

repetitions=${1-100}

printf "%d calls of no-op function:" "$repetitions"
time for n in $(seq 1 $repetitions) ; do noop; done
printf "%d calls of no-op script:" "$repetitions"
time for n in $(seq 1 $repetitions) ; do "$BASE_DIR"/noop_script.sh; done
