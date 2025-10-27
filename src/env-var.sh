#!/bin/bash

if [[ -v DEBUG && $DEBUG == true ]]; then
	echo "Debug mode ON"
	echo Path: "$PATH"
else
	echo "Debug mode OFF"
fi
	
