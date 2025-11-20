#!/usr/bin/env bash

grep -o 's:.*;' |    # Keep only species names.
  sort |             # Sort alphabetically. Needed for applying `uniq` to the data.
  uniq -c |          # Keep only a single occurrence of each value, and add counts.
  sort -n |          # Sort numerically.
  tail -1 |          # Keep the last value only (the one with the most counts).
  grep -o '[0-9]\+'  # Keep only the number of counts (not the name of the species).


# Anything in a comment is ignored

