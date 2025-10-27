#!/bin/bash

p="2 3 5 7 11"
LIMIT=30

# break out of inner loop when prod > 30
echo "Break out of inner loop at > $LIMIT"
for i in $p; do       # NOT "$p";!
    for j in $p ; do
        prod=$((i*j))
        printf "%d * %d = %d\n" "$i" "$j" "$prod"
        ((prod>LIMIT)) && break
    done
done

# break out of both loops when prod > 30
echo "Break out of both loops at > $LIMIT"
for i in $p; do       # NOT "$p";!
    for j in $p ; do
        prod=$((i*j))
        printf "%d * %d = %d\n" "$i" "$j" "$prod"
        ((prod>LIMIT)) && break 2
    done
done
