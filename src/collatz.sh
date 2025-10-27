#!/usr/bin/env bash

declare -i n=$1
while ((n > 1)); do
	printf "%d\n" "$n"
	if ((0 == n % 2)); then
		((n /= 2))
	else
		((n = 3*n +1))
	fi
done
