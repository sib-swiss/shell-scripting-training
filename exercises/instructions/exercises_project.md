# Shell scripting exercises: FASTA to TSV converter project

<br>

> 🔥 **Important:** exercises in this series build upon each other, and should
> therefore be done in order.

<br>

## Project introduction

In this series of exercises, we will progressively build a script that converts
an input in [FASTA format](https://en.wikipedia.org/wiki/FASTA_format) into a
TSV (Tab Separated Values) file.

* In FASTA format, each sequence **starts with a header line** - recognizable
  by its leading **`>`** character - followed by **a variable number of lines**
  that contain the actual sequence. Generally the sequence contains nucleotides
  or amino-acids.
* In the output TSV format, each sequence (including its header) will be
  printed on **a single line**.

In other words, we want to turn something like:

```sh
>DNA sequence 1 (the first header)
ATGCATGCGCGCGCGC
GCGCGCGCATGCATGC
GAGCGTTCGCACGAAC
>Protein sequence 2 (the second header)
ALEAIACTAEST
MVRVAINGFGIQ
```

into:

```sh
DNA sequence 1 (the first header)       ATGCATGCGCGCGCGCGCGCGCGCATGCATGCGAGCGTTCGCACGAAC
Protein sequence 2 (the second header)  ALEAIACTAESTMVRVAINGFGIQ
```

Note that the header and sequence are separated by a `TAB`.

<br>
<br>

## Exercise 3.1 - Program logic

Now that we are familiar with the task at hand, let's start by laying out
the different steps that will have to be carried-out.

<br>

### A) Create a `fasta2tsv.sh` script file

Let's start by creating a new script file.

* **Create a new script file** named `fasta2tsv.sh`.
* **Make the script print** a simple line, e.g.
  `Starting FASTA to TSV converter...`.
* **Add execution permissions** to the script and test-run it.

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

```sh
#!/usr/bin/env bash

# Print a test string, just to make sure the script works:
echo "Starting FASTA to TSV converter..."
```

Add execution permission and test run the script.

```sh
chmod a+x fasta2tsv.sh
./fasta2tsv.sh          # Running the script should print the test text line.
```

</p>
</details>
<br>

### B) Testing

To make sure that our script performs as expected, we can use the following
pair of sample input and expected output files:

* Input: `data/fasta2tsv_test_input.fasta`
* Expected output: `data/fasta2tsv_test_output.fas`

And use the following `diff` command to check that our script works.

```sh
diff -su <(./fasta2tsv.sh < data/fasta2tsv_test_input.fasta) data/fasta2tsv_test_output.tsv
```

**As long as `diff` reports a difference**, our script does not work as
expected. Obviously, at this point, we are getting lot of differences between
the actual and expected outputs.

> ✨ **Notes:**
>
> * The `-u` option of `diff` prints output in **unified format**, which makes
>   it a bit easier to read.
> * The `-s` option prompts `diff` to print a short message when both files are
>   identical. The default behavior of `diff` is to print nothing when both
>   files are the same.
> * When writing a real production script, there would typically be more than
>   one test, and they would all be run automatically.

<br>

### C) Write the program logic

It's generally a good idea to at least have a sketch of the program's flow
before we start happily coding away.

Your task here is to **draft the logic of the FASTA to TSV converter** in
[pseudocode](https://en.wikipedia.org/wiki/Pseudocode). You can do this by
writing the pseudocode as shell comments in the `fasta2tsv.sh` file.

<br>
<details><summary><b>✅ Solution</b></summary>
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
#         5. Print a newline (this starts a new record).
#         6. Print the header line (skipping the `>`), followed by a tab.
#       * Otherwise (sequence), just print the line.
```

> ✨ **Note:** the _first_ header line is treated slightly differently from the
> other headers: it is not preceded by a newline, since we do not have to
> separate it from preceding records.

</p>
</details>

<br>
<br>

## Exercise 3.2 - Reading the input file line by line

We will now start to flesh-out our **`fasta2tsv.sh`** script that we created
in exercise 3.1 with actual code.

The first part of the FASTA to TSV converter that we will implement is the
reading of the input. For now we will assume that our input FASTA data
**is provided to our script via the standard input**.

<br>

### A) Reading the first line from the input

Read the first line of the FASTA input into a variable named `line`, and print
that line to stdout.

Test your script by running it on the `data/fasta2tsv_test_input.fasta` test
input file. It should print a single line (the first line of the file):

```sh
./fasta2tsv.sh < data/fasta2tsv_test_input.fasta
```

> ✨ **Note::** we can now delete the initial test line from out script.

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

```sh
#!/usr/bin/env bash

read line
printf "%s\n" "$line"
```

</p>
</details>
<br>

### B) Reading the remaining lines from the input

Read all remaining lines, **one at a time**. Store each line in the variable
`line` and print it to stdout.

> 🎯 **Hint:** this is a repetitive task, and therefore a perfect candidate
> for **a loop**.

> ✨ **Note:** if we just wanted to print all lines, we could simply call
> `cat`. But as we will want to process individual lines, we need to be able
> to read each line individually.

As before, test your script by running:

```sh
./fasta2tsv.sh < data/fasta2tsv_test_input.fasta
```

It should now print the entire content of `data/fasta2tsv_test_input.fasta`.

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

Here we are doing something - read and print a line - _while_ there are still
lines to read, so a `while` loop seems most useful.

* At each iteration of the loop, the `read` command stores the next line in
  the `line` variable
* `read` will fail when there is nothing to read, ending the loop.

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

## Exercise 3.3 - Distinguish header from sequence

As discussed at the start of this series of exercises, we have to treat header
lines differently from sequence lines. We must therefore be able to
distinguish between them.

> 🎯 **Hint:** remember that in FASTA format, header lines are the only lines
> that start with the character **`>`**.

Update `fasta2tsv.sh` so that it determines whether the current line is a
header or a sequence line. To check that your implementation is working
properly, make the script **prints the string `"header"` or `"sequence"`**
before printing each line.

Note that there is no need to do this for the first line of the input, as we
will assume that it's always a header line.

Test your script by running:

```sh
./fasta2tsv.sh < data/fasta2tsv_test_input.fasta
```

Your output should look like the following.

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
<details><summary><b>✅ Solution</b></summary>
<p>

We need a different behavior based on whether a given condition is true or
false: this is a textbook use case for an `if ... else` construct.

Here the decision criterion is whether the first character of the `line`
variable is a `>` or not.

```sh
#!/usr/bin/env bash

# Read and print the first line of the file.
read line
printf "%s\n" "$line"

# Read and print all remaining lines.
while read line; do

  # Line is a header line
  if [[ ${line:0:1} == ">" ]]; then
    printf "header %s\n" "$line"
  # Line is a sequence line.
  else
    printf "sequence %s\n" "$line"
  fi

done
```

> **Note:** in the solution above, we use the bash **extended test** operator
> `[[ ... == ... ]]` to do our testing.
>
> But we could also have used `[ ... = ... ]` to make our script POSIX
> compatible.

</p>
</details>

<br>
<br>

## Exercise 3.4 - Handle the two kinds of lines

Now that we can tell headers apart from sequence lines, we are going to output
them differently. Update the `fasta2tsv.sh` script so that:

* If the current line is a header: we first print a newline character, and
  then print the line itself, followed by a TAB character (`\t`).
* If the current line is a sequence line: print the line with no newline
  character at the end (since there might be additional elements to the
  sequence to print on the same line).

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

> 🦉 **Reminder:** `${line:1}` expands to `$line`, but starting from the
> second character, and thus dropping the leading `>`.

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

## Exercise 3.5 - Fixing the last glitches

We're almost there, but testing the program with `diff` shows that there are
still 3 small problems:

```sh
diff -su <(./fasta2tsv.sh < data/fasta2tsv_test_input.fasta) data/fasta2tsv_test_output.tsv
```

1. The first line of the output still starts with a **`>`** character.
2. There is an extra newline at the end of the first header line, i.e. for
   the first sequence, the header and the sequence are not on the same line.
3. There should be a newline at the end of the output.

Your task here is to fix these last problems in the `fasta2tsv.sh` script.
When you are done, try to run the script again, and try to run the test with
`diff` again.

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

* To fix the first problem, we can print `"${line:1}"` instead of `"$line"`.
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
exit 0
```

</p>
</details>

<br>
<br>

## 🔮 Additional tasks - Further developments

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
