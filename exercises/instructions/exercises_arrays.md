# Shell scripting exercises: Arrays

## Exercise 1

Write a program that translates codons to amino acids.

### A) Data structure

What kind of data structure would be suitable for storing amino acids and
mapping codons to them? You should be able, given e.g. codon `ATG`, to retrieve
the corresponding amino acid (namely, methionine (IUPAC code: `M`), with
something like `aa=${GENETIC_CODE[ATG]}`.

Write a script in which you declare such a structure (feel free to write a
partial version first: you can move to the full 64 codons when your code works).
The full genetic code is found in `./data/genetic_code.csv`. To keep things
simple, use e.g. a 0 or an asterisk to translate the STOP codon.

You can check that your structure is correct by using `declare -p` in your
script.

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

```bash
declare -rA GENETIC_CODE=(
    [AAA]=K [AAC]=N [AAG]=K [AAT]=N [ACA]=T [ACC]=T [ACG]=T [ACT]=T
    [AGA]=R [AGC]=S [AGG]=R [AGT]=S [ATA]=I [ATC]=I [ATG]=M [ATT]=I
    [CAA]=Q [CAC]=H [CAG]=Q [CAT]=H [CCA]=P [CCC]=P [CCG]=P [CCT]=P
    [CGA]=R [CGC]=R [CGG]=R [CGT]=R [CTA]=L [CTC]=L [CTG]=L [CTT]=L
    [GAA]=E [GAC]=D [GAG]=E [GAT]=D [GCA]=A [GCC]=A [GCG]=A [GCT]=A
    [GGA]=G [GGC]=G [GGG]=G [GGT]=G [GTA]=V [GTC]=V [GTG]=V [GTT]=V
    [TAA]=0 [TAC]=Y [TAG]=0 [TAT]=Y [TCA]=S [TCC]=S [TCG]=S [TCT]=S
    [TGA]=0 [TGC]=C [TGG]=W [TGT]=C [TTA]=L [TTC]=F [TTG]=L [TTT]=F
)
```

</p>
</details>
<br>

### B) Split the sequence into codons

Now, have your script accept a sequence as its first (and only) parameter.
Print each codon in turn, e.g.

```bash
./translate GGGCTATCCTAA
```

should produce

```sh
GGG
CTA
TCC
TAA
```

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

There are least two relatively easy way to solve this problem:

* The first option is to run a **`while` loop**, and at each iteration, shorten
  the sequence by 3 nucleotides until the sequence is empty.

```bash
#!/usr/bin/env bash

seq=$1

while [[ $seq ]]; do
    codon=${seq:0:3}
    echo $codon
    seq=${seq:3}
done
```

* The other way is to use a **C-style loop** with a counter `i` that is
  increased by a value of `3` at each loop.

```bash
#!/usr/bin/env bash

seq=$1

for ((i=0; i<${#seq}; i+=3)); do
    codon=${seq:i:3}
    echo $codon
done
```

</p>
</details>
<br>

### C) Codon translation

Now, instead of printing each codon, print its translation instead (using the
structure you declared in step 1). Do not print a newline after each amino acid;
rather, print a newline only after the last one. It should look like this:

```bash
./translate GGGCTATCCTAA
# -> GLSO
```

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

```bash
seq=$1

while [[ $seq ]]; do
    codon=${seq:0:3}
    printf "%s" "${GENETIC_CODE[$codon]}"
    seq=${seq:3}
done
printf "\n"
```

</p>
</details>
<br>

### 🔮 D) Additional Task: programmatically build the array

Instead of hard-coding the genetic code in a large array, _read_ it from the
CSV file `./data/genetic_code.csv` instead.
Recall that you can use `read` to, well, read lines, and tweak `IFS` to split
along separators.

> ✨ **Note:**t we do not bother with the following:
>
> * Any characters other than `ATGC` in the sequence.
> * Sequences whose length is not a multiple of 3.
>
> In a realistic setting, both of the above should be addressed.

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

```bash
declare -A GENETIC_CODE

while IFS=',' read codon aa; do
  GENETIC_CODE[$codon]=$aa
done < ../data/genetic_code.csv

seq=$1

while [[ $seq ]]; do
    codon=${seq:0:3}
    printf "%s" "${GENETIC_CODE[$codon]}"
    seq=${seq:3}
done
printf "\n"
```

</p>
</details>

<br>
<br>

## Exercise 2 - Sequence similarity

We would like to write a script named `compute_similarity.sh` that takes a
FASTA file as unique input and outputs a matrix (table) of all pairwise
sequence similarity values between the sequences from the input FASTA file.

In other words, we would like a script that we can call with:

```sh
./compute_similarity.sh data/sequence_similarity.fasta
```

And that will output:

```sh
100.00  24.18   23.28   97.91  70.75
24.18   100.00  22.39   24.78  26.87
23.28   22.39   100.00  22.99  22.39
97.91   24.78   22.99   100.00  70.45
70.75   26.87   22.39   70.45   100.00
```

### A) Compute similarity between sequences

The fist part of this exercise is to write a **function** that can
**compute similarity between 2 DNA sequences** (or amino-acids sequences).
We can then re-use this function in the second part of the exercise.

* The function should accept 2 arguments: the two sequences (strings) for
  which to compute similarity.
* The function should output a single (floating) number: the percentage of
  similarity between the two sequences.
* The **similarity of two sequences** is the percentage of nucleotides (or
  amino-acids) that are the same (at a given position) between the two
  sequences being compared. See below for some examples.
* **Hint:** make sure that your function outputs a **floating number**.
  Remember that you can use `bc -l` to compute floating point operations.

Here is some test data to develop and test your function.

```sh
seq1=AAGAATTTTTCC
seq2=TTTTTAAAAACC  # Similarity with seq1: 16.6%, with seq3: 25.0%
seq3=TTGAACCTTTGC  # Similarity with seq1: 58.3%

sequence_similarity $seq1 $seq1  # -> 100.00
sequence_similarity $seq1 $seq2  # -> 16.66 
sequence_similarity $seq1 $seq3  # -> 58.33
sequence_similarity $seq2 $seq3  # -> 25.00
```

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

```bash
# Define function to compute similarity between 2 sequences.
function sequence_similarity {
    local seq1=$1
    local seq2=$2
    local counter=0
    for ((i=0; i<${#seq1}; i++)); do
        # Test if the nucleotide at the current position are the same, and
        # if yes, increment the counter.
        [[ ${seq1:i:1} == ${seq2:i:1} ]] && ((++counter))
    done
    # Print output with a precision of 5 decimals.
    printf "%.5f\n" $( echo "$counter / ${#seq1} * 100" | bc -l )
}
```

</p>
</details>
<br>

### B) Write a script

Now that we have the core of the function - the `sequence_similarity` function,
we can write a **`compute_similarity.sh`** script around it.

Roughly speaking, the logic of the code should be to:

* **Load the sequences** from the input file (here
  `data/sequence_similarity.fasta`) and store them in an **array**.
* **Loop through the sequences** and compute the similarity for each
  combination of sequences in the list using the `sequence_similarity`
  function.
* **Print the sequence similarity values** in a matrix format.

> 🎯 **Hints:**
>
> * **To load the sequences** from the input FASTA file, you will find it handy
>   to use the FASTA to TSV converter that we wrote earlier in this course.
> * **To split tabular data** (such as produced by the FASTA to TSV converter)
>   into individual fields, the **`cut`** command (see `man cut` for details).
> * To avoid repeatedly loading the same sequences, you can
>   **store them in an array**.

You can use the test file `data/sequence_similarity.fasta` to test your
script. If it is working properly, you should get the following matrix
output:

```sh
./compute_similarity.sh data/sequence_similarity.fasta 
100.00  24.18   23.28   97.91  70.75
24.18   100.00  22.39   24.78  26.87
23.28   22.39   100.00  22.99  22.39
97.91   24.78   22.99   100.00  70.45
70.75   26.87   22.39   70.45   100.00
```

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

```sh
#!/usr/bin/env bash

# Get user input.
set -u
input_fasta_file=$1

# Define function to compute similarity between 2 sequences.
function sequence_similarity {
    local seq1=$1
    local seq2=$2
    local counter=0
    for ((i=0; i<${#seq1}; i++)); do
        # Test if the nucleotide at the current position are the same, and
        # if yes, increment the counter.
        [[ ${seq1:i:1} == ${seq2:i:1} ]] && ((++counter))
    done
    # Print output with a precision of 5 decimals.
    printf "%.5f\n" $( echo "$counter / ${#seq1} * 100" | bc -l )
}


# Store sequences in an array.
sequences=( $( ./fasta2tsv.sh "$input_fasta_file" | cut -f2 ) )

first_loop=1
for seq1 in ${sequences[@]}; do
    
    # Start a new line of the matrix, except on the first loop.
    [[ $first_loop -eq 0 ]] && printf "\n"
    first_loop=0

    for seq2 in ${sequences[@]}; do
        printf "%.2f\t" $( sequence_similarity $seq1 $seq2 )
    done
done
printf "\n"
```

</p>
</details>
<br>
