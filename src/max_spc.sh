#!/bin/bash

grep -o 's:.*$' | sort | uniq -c | sort -n | tail -1 | grep -o '[0-9]\+'
