#!/bin/bash

string="$1"

while [[ "$string" ]] ; do 
    echo $string
    string="${string:1}" # shorten by 1
done


