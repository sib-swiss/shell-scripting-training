#!/bin/bash

# Define an array of sample names
samples=('S01' 'S02' 'S03')

# Loop over the array
for sample in "${samples[@]}"; do
    echo "processing sample $sample.fastq.gz"
done

