#!/usr/bin/env bash

set -u

declare -r PRIVATE=.
declare -r PUBLIC=../public
declare -r FILE_LIST=publish.rsync

RSYNC_OPTS=(-a --delete --prune-empty-dirs --include-from="$FILE_LIST" --exclude='*')

while getopts ":n" opt; do
    case $opt in
        n) RSYNC_OPTS+=(--dry-run) ;;
        *) echo getopts error; exit 1;;
    esac
done

chmod -R +200 "$PUBLIC"
rsync "${RSYNC_OPTS[@]}" "$PRIVATE"/ "$PUBLIC"/
# Write-protect, except .git
chmod -R -222 "$PUBLIC"/*
chmod -R +200 "$PUBLIC"/.git
