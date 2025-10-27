#!/usr/bin/env bash

genome=$1

echo -n "A: "
tr -dc A < "$genome" | wc -c
echo -n "C: "
tr -dc C < "$genome" | wc -c
echo -n "G: "
tr -dc G < "$genome" | wc -c
echo -n "T: "
tr -dc T < "$genome" | wc -c
