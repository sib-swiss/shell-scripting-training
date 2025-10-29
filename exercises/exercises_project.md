Bash shell scripting: "FASTA to TSV converter" project exercises
================================================================

**Exercise list:**

* [Exercise 3.1 - FASTA to TSV converter: program logic](#exercise-31-fasta-to-tsv-converter-program-logic)
* [Exercise 3.2 - FASTA to TSV converter: reading the input file line by line](#exercise-32-fasta-to-tsv-converter-reading-the-input-file-line-by-line)
* [Exercise 3.3 - FASTA to TSV converter: distinguish header from sequence](#exercise-33-fasta-to-tsv-converter-distinguish-header-from-sequence)
* [Exercise 3.4 - FASTA to TSV converter: handle the two kinds of lines](#exercise-34-fasta-to-tsv-converter-handle-the-two-kinds-of-lines)
* [Exercise 3.5 - FASTA to TSV converter: two last glitches](#exercise-35-fasta-to-tsv-converter-two-last-glitches)
* [Additional tasks - FASTA to TSV converter: further developments](#additional-tasks-fasta-to-tsvconverter-further-developments)

In this series of exercises, we will progressively build a script that converts
an input in [FASTA format](https://en.wikipedia.org/wiki/FASTA_format) - from a
file or from standard input - into a line oriented format:
TSV (`TAB` separated values).

Exercises in this series build upon each other, and should therefore be done
in order.

:pushpin:
**Notes:**

* **Exercise material:** all exercise material is found in the `exercises/`
  directory of this Git repository. The exercise instructions assume that you
  are located in that directory, so we suggest entering it when doing the
  exercises: `cd exercises/`.
* **Exercise solutions:** all exercises have their solution embedded in this
  document. The solutions are hidden by default, but you can reveal them by
  clicking on the drop-down menu, like the one here-below.
  We encourage you to *not* look at the solution too quickly, and try to
  solve the exercise without it. Remember you can always ask the course
  teachers for help.

<details><summary><b>Exercise solution example</b></summary>

> This would reveal the answer...

</details>

<br>
<br>

Exercise 3.1 - FASTA to TSV converter: program logic
----------------------------------------------------

### Part 1 - description of the FASTA to TSV converter project

This is the first of a series of exercises where we will progressively build
a script that converts an input in
[FASTA format](https://en.wikipedia.org/wiki/FASTA_format) (from a file or from
standard input) into a line oriented format: TSV (`TAB` separated values).

In the FASTA format, **each sequence starts with a header line** (recognizable
by its leading **`>`** character), followed by
**a variable number of lines that contain the actual sequence** (generally
the sequence contains nucleotides or amino-acids).  
In the output TSC format, each sequence should be printed on **a single line**.

In other words, we want to turn something like...

```sh
>DNA sequence 1 (the first header)
ATGCATGCGCGCGCGC
GCGCGCGCATGCATGC
GAGCGTTCGCACGAAC
>Protein sequence 2 (the second header)
ALEAIACTAEST
MVRVAINGFGIQ
```

...into (note: header and sequence are separated by a `TAB`):

```sh
DNA sequence 1 (the first header)      ATGCATGCGCGCGCGCGCGCGCGCATGCATGCGAGCGTTCGCACGAAC
Protein sequence 2 (the second header) ALEAIACTAESTMVRVAINGFGIQ
```

#### Create a `fasta2tsv.sh` script file

Now that we are familiar with the task at hand, let's do the following:

* **Create a new script file** named `fasta2tsv.sh`.
* **Make the script print a simple line**, e.g.
  `Starting FASTA to TSV converter...`.
* **Add execution permissions** to the script and test-run it.

<br>
<details><summary><b>Exercise solution: part 1</b></summary>
<p>

```sh
#!/usr/bin/env bash

# Print a test string, just to make sure the script works:
echo "Starting FASTA to TSV converter..."

```

Add execution permission and test run the script.

```sh
chmod a+x fasta2tsv.sh
./fasta2tsv.sh
# -> Starting FASTA to TSV converter...
```

</p>
</details>
<br>

### Part 2 - testing

The DNA and protein FASTA snippet examples that were shown earlier in this
exercise **can be used to test our script:** you will find them in the files
`data/fasta2tsv_test_input.fas` and `data/fasta2tsv_test_output.fas`.

We can thus use the following `diff` command to check that our script works:

```sh
diff -su <(./fasta2tsv.sh < data/fasta2tsv_test_input.fas) data/fasta2tsv_test_output.tsv
```

**As long as `diff` reports a difference**, our script does not work as
expected. Obviously, at this point, we are getting lot of differences between
the actual and expected outputs.

:pushpin:
*Notes:*

* The `-u` option of `diff` prints output in **unified format**, which makes it
  a bit easier to read.
* The `-s` option prompts `diff` to print a short message when both files are
  identical. The default behavior of `diff` is to print nothing when both files
  are the same.
* When writing a real production script there would typically be more than one
  test, and they would all be run automatically.

<br>

### Part 3 - write the program logic

It's generally a good idea to at least have a sketch of the program's behavior
before we start happily coding away.

In this exercise, your task is to:

* In the `fasta2tsv.sh` file, **draft the logic of the FASTA to TSV converter**
  in [pseudocode](https://en.wikipedia.org/wiki/Pseudocode). You can write the
  pseudocode as shell comments.

<br>
<details><summary><b>Exercise solution: part 3</b></summary>
<p>

```sh
#!/usr/bin/env bash

# Print a test string, just to make sure the script works:
echo "Starting FASTA to TSV converter..."

# Program logic in pseudo-code:

# 1. Read the first line, strip the leading '>` and trailing newline, and
#    print it, followed by a tab character.

# 2. While there are still lines to read in the file:
#    3. Read one line and strip the trailing newline.
#    4. * If the line starts with `>` (FASTA header):
#         5. print a newline (this starts a new record).
#         6. print the header line (skipping the `>`), followed by a tab.
#       * Otherwise (sequence), just print the line.
```

:pushpin:
*Note* that the *first* header line is treated slightly differently from the
other headers: it is not preceded by a newline, since we do not have to
separate it from preceding records.

</p>
</details>
<br>

<br>
<br>

Exercise 3.2 - FASTA to TSV converter: reading the input file line by line
--------------------------------------------------------------------------

We will now start to flesh-out our **`fasta2tsv.sh`** script that we created
in exercise 3.1 with actual code.

The first part of the FASTA to TSV converter that we will implement is the
reading of the input. For now we will assume that our input FASTA data
**is provided to our script via the standard input**.

### Part 1: reading the first line from the input

Read the first line of FASTA input into a variable named `line`, and print
that line to stdout.

We can now also delete the initial test line from the script.

```sh
echo "Starting FASTA to TSV converter..."
```

Test your script by running it on the `data/fasta2tsv_test_input.fas` test
input file. It should print a single line (the first line of the file):

```sh
./fasta2tsv.sh < data/fasta2tsv_test_input.fas
```

<br>
<details><summary><b>Exercise solution: part 1</b></summary>
<p>

```sh
#!/usr/bin/env bash

read line
printf "%s\n" "$line"
```

</p>
</details>
<br>

### Part 2: reading the remaining lines from the input

Read all remaining lines, **one at a time**. Store each line in the variable
`line` and print it to stdout.

* :dart:
  **Hint:** this is a repetitive task, and therefore a perfect candidate for
  **a loop**.
* :pushpin:
  *Note:* if we just wanted to print all lines, we could simply call `cat`. But
  as we will want to process individual lines, we need to be able to read each
  line individually.

As before, test your script by running:

```sh
./fasta2tsv.sh < data/fasta2tsv_test_input.fas
```

It should now print the entire content of `data/fasta2tsv_test_input.fas`.

<br>
<details><summary><b>Exercise solution: part 2</b></summary>
<p>

Here we are doing something - read and print a line - *while* there is still
lines to read, so a `while` loop seems most useful.

The `read` command, as we know, will store the next line in the `line`
variable; it will fail if there is nothing to read, ending the loop.

```sh
#!/usr/bin/env bash

# Read and print the first line of the file.
read line
printf "%s\n" "$line"

# Read and print all remaining lines.
while read line; do
  printf "%s\n" "$line"
done
```

</p>
</details>
<br>

<br>
<br>

Exercise 3.3 - FASTA to TSV converter: distinguish header from sequence
-----------------------------------------------------------------------

As discussed at the start of this series of exercises (see pseudocode in
exercise 3.1), we have to treat header lines differently from sequence lines.
We must therefore be able to distinguish them.

* :dart:
  **Hint:** remember that in FASTA format, header lines are the only lines that
  start with the character **`>`**.

Update the `fasta2tsv.sh` script so that it can determines whether the current
line is a header or a sequence line, and accordingly
**prints the string `"header"` or `"sequence"`** before printing each line.
Note that there is no need to do this for the first line of the input, as we
will assume that it's always a header line.

Test your script by running `./fasta2tsv.sh < data/fasta2tsv_test_input.fas`,
your output should look something like:

```text
>DNA sequence 1 (the first header)
sequence ATGCATGCGCGCGCGC
sequence GCGCGCGCATGCATGC
sequence GAGCGTTCGCACGAAC
header >Protein sequence 2 (the second header)
sequence ALEAIACTAEST
sequence MVRVAINGFGIQ
```

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

We have to make a true/false decision, and we need to do something in either
situation: this is the textbook use case for `if ... then ... else ... fi`.

The decision criterion is whether the first character of the `line` variable
is a `>` or not, so we use `${line:0:1}` in a string comparison
`[[ ... = ... ]]`.

```sh
#!/usr/bin/env bash

# Read and print the first line of the file.
read line
printf "%s\n" "$line"

# Read and print all remaining lines.
while read line; do

  # Line is a header line
  if [[ ${line:0:1} = '>' ]]; then
    printf "header %s\n" "$line"

  # Line is a sequence line.
  else
    printf "sequence %s\n" "$line"
  fi

done
```

</p>
</details>
<br>

<br>
<br>

Exercise 3.4 - FASTA to TSV converter: handle the two kinds of lines
--------------------------------------------------------------------

Now that we can tell headers apart from sequence lines, we are going to output
them differently (see pseudocode in exercise 3.1).

Update the `fasta2tsv.sh` script so that:

* If the current line is a header, (i) print a newline, (ii) print the line
  itself, followed by a TAB character.
* If the current line is a sequence line, just print it.

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

As seen when discussing parameter expansion, `${line:1}` expands to `$line`,
but starting from the second character, and thus dropping the leading `>`.

```sh
#!/usr/bin/env bash

# Read and print the first line of the file.
read line
printf "%s\n" "$line"

# Read and print all remaining lines.
while read line; do

  # Line is a header line
  if [[ ${line:0:1} = '>' ]]; then
    printf "\n"
    printf "%s\t" "${line:1}"

  # Line is a sequence line.
  else
    printf "%s" "$line"
  fi

done
```

</p>
</details>
<br>

<br>
<br>

Exercise 3.5 - FASTA to TSV converter: two last glitches
--------------------------------------------------------

We're almost there, but testing the program with `diff` shows that there are
still 3 problems:

```sh
diff -su <(./fasta2tsv.sh < data/fasta2tsv_test_input.fas) data/fasta2tsv_test_output.tsv
```

1. The first line of the output still starts with a **`>`** character.
2. There is an extra newline at the end of the first header line, i.e. for
   the first sequence, the header and the sequence are not on the same line.
3. There should be a newline at the end of the output.

Your task here is to fix these last problems in the `fasta2tsv.sh` script.
When you are done, try to run the script again, and try to run the test with
`diff` again. The output of the script should now be equal to
`data/fasta2tsv_test_output.tsv`.

```sh
diff -su <(./fasta2tsv.sh < data/fasta2tsv_test_input.fas) data/fasta2tsv_test_output.tsv
```

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

* To fix the first problem, we print `"${line:1}"` instead of `"$line"`.
* To fix the second problem, we print a `\t` (tab) instead of a `\n` (newline)
  when printing the first line of the input with `printf`.
* To fix the third problem, we simply output a newline after the loop (at the
  end of the script).

```sh
#!/usr/bin/env bash

# Read and print the first line of the file.
read line
printf "%s\t" "${line:1}"

# Read and print all remaining lines.
while read line; do

  # Line is a header line
  if [[ ${line:0:1} = '>' ]]; then
    printf "\n"
    printf "%s\t" "${line:1}"

  # Line is a sequence line.
  else
    printf "%s" "$line"
  fi

done

printf "\n"
```

</p>
</details>
<br>

<br>
<br>

Additional tasks - FASTA to TSV converter: further developments
---------------------------------------------------------------

Here are some ideas to make the script more realistic:

* **Add a header to the output TSV file:** the first line of a TSV/CSV file
  typically consists of field names rather than data themselves. Our script
  could be modified to include them.
* **Make the header optional:** sometimes, headers get in the way (e.g. when
  sorting by species), so perhaps they should be printed at the user's
  discretion. The `fasta2tsv.sh` script could thus accept an option to prevent
  the printing of the output header. 
* **Custom field separator:** for now fields in the output are TAB-separated,
  but it would be convenient to output CSV (comma-separated) or, for that
  matter, to let the user specify any custom field separator.

<br>
<br>

Use the Script
--------------

Congratulations! The script should now work as advertised (but you should still
do a final check). Now the script can be put to good use.

Try the following tasks:

1. From the file `./data/Spo0A.msa`, extract the record corresponding to ID `Bsph_3503` (as TSV)
2. Find the longest sequence in 


<br>
<details><summary><b>Solution</b></summary>
<p>

### Task 1

```bash
~/bin/fasta2dsv.sh < Spo0A.msa | grep Bsph_3503 
```

### Task 2

The only slightly tricky bit is to get the sequence lengths. This can be done
e.g. by calling Awk:

```bash
$ ~/bin/fasta2tsv.sh < sample_01.dna \
  | awk -F $'\t' -v OFS=$'\t' '{print $1, $2, length($2)}' \
  | sort -t $'\t' -k3,3n | tail -1
```

Or we could use Bash itself to compute the length.
</p>
</details>
<br>

<br>
<br>