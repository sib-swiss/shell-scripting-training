#!/usr/bin/env bash

IFS=$'\t'
while read hdr seq; do
	printf ">%s\n%s\n" "$hdr" "$seq"
done
