Bash shell scripting: exercises day 1
=====================================

**Exercise list:**

* [Exercise 1.1 - a complex pipeline](#exercise-11-a-complex-pipeline)
* [Exercise 1.2 - a simple shell script](#exercise-12-a-simple-shell-script)
* [Exercise 1.3 - tokenizing and quoting](#exercise-13-tokenizing-and-quoting)
* [Exercise 1.4 - command parsing](#exercise-14-command-parsing)
* [Exercise 1.5 - parameter expansions](#exercise-15-parameter-expansion)
* [Exercise 1.6 - brace expansions and command substitution](#exercise-16-brace-expansion-and-command-substitution)
* [Exercise 1.7 - process-substitution](#exercise-17-proccess-substitution)

:pushpin:
**Notes:**

* **Exercise material:** all exercise material is found in the `exercises/`
  directory of this Git repository. The exercise instructions assume that you
  are located in that directory, so we suggest entering it when doing the
  exercises: `cd exercises/`.
* Some of the exercises build on previous exercises, so it's best if they are
  done in order.
* At the end of some exercises, you will find an **Additional Tasks** section.
  These sections contain additional tasks for you to complete,
  **if you still have the time after having completed the main part of the**
  **exercise**. These sections will in principle not be corrected in class.
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

Exercise 1.1 - A complex pipeline
---------------------------------

You are given the file `data/sample_01.dna`, which contains genetic sequences
in [FASTA format](https://en.wikipedia.org/wiki/FASTA_format) that look like
the following:

```bash
>Desulfo_vulgaris_Hilden;tax=d:Bacteria,...,s:Desulfovibrio vulgaris;
ATGGCGAAGAAACCGAGCCTCAGCCCCGAAGAGATGCGCCG
CACCATCGAGCGGAAGTACGGTCTGGGGGCGGTCATGAAAC
TCCCCGTCATCCCCACCGGTTCCATCGGCCTTGACCTCGCA
...
>Mycobac_tubercu_H37Rv;tax=d:Bacteria,...,s:Pseudomonas putida;
ATGACGCAGACCCCCGATCGGGAAAAGGCGCTCGAGCTGGC
CGGCAAAGGTTCGGTGATGCGCCTCGGCGACGAGGCGCGTC
GATCCATCGCACTAGACGTGGCCCTGGGCATTGGCGGCCTG
```

Your task is to **find the number of sequences** of the species with the most
sequences in the file (this may be useful *e.g.* to check for
over-representation).  
The result should be a single number. For instance, if the most represented
species has 16 sequences in the file, then your command should output `16`.

:dart:
**Hints:**

* In a FASTA file, each sequence starts with a **header line** that can be
  identified with by its leading **`>`** character.
* The species name to which each sequence belongs can be found in the header
  of each sequence, and is prefixed with **`s:`**. In our example above, the
  species of the first sequence is `Desulfovibrio vulgaris` - a species of
  [sulfate-reducing bacteria](https://en.wikipedia.org/wiki/Desulfovibrio_vulgaris).
* Here are some common UNIX commands that could be useful to complete this
  task:
  * **`grep`** - print lines (of a text file or standard input) that match
    a given pattern. The **`-o`** option of `grep` allows to print only the
    part of the line that matches the given pattern instead of printing the
    entire line (the default behavior).
  * **`tail`** - output the last part of text files (or standard input).
  * **`uniq`** - filter adjacent repeated lines and keep only a single
    occurrence of them. By adding the **`-c`** option, it can also count
    occurrences of each value (lines).
  * **`sort`** - sort lines of text files (or standard input) alphabetically
    or numerically (**`-n`** option).
* You can display help for these commands by typing **`man <command name>`**
  in your shell.

<details>
  <summary>
    :dart:
    <b>Additional hint 1</b> - click here for an additional hint if you don't
    know how to get started.
  </summary>
  <p>

  The first step of this exercise is to isolate the name of the species for
  each sequence. This can be done by using the `grep` command and its `-o`
  option.

```bash
grep -o 's:.*;' data/sample_01.dna
```

</p>
</details>

<details>
  <summary>
    :dart:
    <b>Additional hint 2</b> - click here for an additional hint if you don't
    know how to get started.
  </summary>
  <p>
  
  After isolating the species name, we can use a combination of `sort` and
  `uniq -c` to get a list of all species along with their count.

```bash
grep -o 's:.*;' data/sample_01.dna | sort | uniq -c
```

</p>
</details>

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

There are a multitude of ways to solve this task, this is just one way to do
it:

```bash
# Commented solution (Note: will not work if you copy/paste because of comments).
grep -o 's:.*;' data/sample_01.dna | \  # Keep only species names.
  sort | \            # Sort alphabetically. Needed for applying `uniq` to the data.
  uniq -c | \         # Keep only a single occurrence of each value, and add counts.
  sort -n | \         # Sort numerically.
  tail -1 | \         # Keep the last value only (the one with the most counts).
  grep -o '[0-9]\+'   # Keep only the number of counts (not the name of the species).

# The same on a single line:
grep -o 's:.*;' data/sample_01.dna | sort | uniq -c | sort -n | tail -1 | grep -o '[0-9]\+'
```

**Notes**:

* The backslashes `\` at the end of lines are only for page layout purpose
  (it's a line continuation character) - it's all really one line. As we
  shall see, backslashes are a form of *escaping*.
* The second `grep` could be replaced by `sed`, `awk` or `cut`. We decided to
  show the solution with `grep` because it might be more familiar to most
  people.

</p>
</details>
<br>

<br>
<br>

Exercise 1.2 - A simple shell script
------------------------------------

Using your favorite text editor - which should be [Vim](https://www.vim.org),
of course :-) - create a new file named `max_spc.sh` and copy/paste the
following lines of shell script into it.

```bash
#!/usr/bin/env bash

grep -o 's:.*;' |    # Keep only species names.
  sort |             # Sort alphabetically. Needed for applying `uniq` to the data.
  uniq -c |          # Keep only a single occurrence of each value, and add counts.
  sort -n |          # Sort numerically.
  tail -1 |          # Keep the last value only (the one with the most counts).
  grep -o '[0-9]\+'  # Keep only the number of counts (not the name of the species).
```

**Notes:**

* These are just the commands from Exercise 1.1 with a couple of minor changes
  (can you spot them?).
* Feel free to choose a different file name: the **`.sh`** extension, like all
  extensions under UNIX, has no particular effect and is just a matter of
  convention (`sh` is short for `shell`). It could also be `.bash`, for
  example.

**Congratulations!**, you have just created a **Bash script**. Let's make it
**executable** by using the command: **`chmod a+x max_spc.sh`**.

You can now try to **run it just as if it were a system command**:

```bash
./max_spc.sh < ./data/sample_01.dna
```

Of course, you can pass any other FASTA file to it...

```bash
./max_spc.sh < ./data/sample_02.dna
```

...and it wouldn't be hard to run `max_spc.sh` on *all* our FASTA
`./data/sample_*.dna` files in a single command. We will see **`for` loops**
later in the course, but here is how you could do it (you can try copy-pasting
the following lines in your shell):

```bash
for file in ./data/sample_0?.dna; do
    echo -n "Max sequence counts for a single species in $file: "
    ./max_spc.sh < "$file"
done
```

<br>
<br>

Exercise 1.3 - Tokenizing and quoting
-------------------------------------

**Part 1:** run the following 3 lines in your shell.

```bash
name=Gaius
echo my name is '$name'
echo "my name is '$name'"
```

Can you explain why the variable `$name` gets expanded in the second case, but
not in the first ?

<br>
<details><summary><b>Exercise solution - part 1</b></summary>
<p>

* `echo my name is '$name'`: here the variable name is surrounded by singled
  quotes, which prevents it from being expanded by the shell.
* `echo "my name is '$name'"`: this time there are additionally double quotes
  around the single quotes. Double quotes have the effect of removing the
  "special" meaning of characters (i.e. all characters are literal), except
  for `$`, `` ` `` (backtick) and `\`. As a result, the single quotes inside
  double quotes lose their effect of preventing variable expansion, and hence
  `$name` gets expanded.

</p>
</details>
<br>

**Part 2:** the following command works...

```bash
echo my name is Bond
```

...but this one does not:

```bash
echo my name is O'Donnelly
```

Why is that? and how can we fix this?

<br>
<details><summary><b>Exercise solution - part 2</b></summary>
<p>

The problem is that the single quote in `O'Donnelly` is not matched by a second
(closing) single quote. To fix this, we can either:

* Escape the single quote: `echo my name is O\'Donnelly`.
* Double-quote the whole name (or, indeed, the whole string:
  `echo "my name is O'Donnelly"`.

**Note:** since the character we are trying to escape is a single quote `'`,
we cannot use single quotes to quote it.  
This will *not* work: `echo 'my name is O'Donnelly'`, because there is now
again a non-matched single quote (the last one).

</p>
</details>
<br>

<br>
<br>

Exercise 1.4 - Command parsing
------------------------------

1. **Write a command list** that prints the content of a file to standard
   output (i.e. the terminal) if a file exists, and prints
   `Error: the file '<name of file>' does not exist!"` otherwise.

   * :fire:
     **Important:** make sure your command also works with files whose name
     contains a space!
   * :dart:
     **Hint:** the command to test if a file exists is `[[ -f "$file" ]]`.

2. **Modify your command list** so that the error message gets printed to both
   the standard output and a hypothetical log file named `tmp.log`. Note: the
   error messages should *append* to the log file, not overwrite it.

   * :dart:
     **Hint:** the command `tee` allows to both write content to a file and
     redirect it to standard output. Example usage:

      ```bash
      echo "print me!" | tee test_file.txt
      echo "add another line" | tee -a test_file.txt
      ```

3. **Additional task (if you have time):** prepend the current date and time
   to the error message.

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

1. We start by creating a couple of files that we will use to test our command.
   Note that the second file has a space in its name.

    ```sh
    echo "This is the content of the file..." > test_file.txt
    echo "This is the content of the file..." > "test file.txt"
    ```

   We can now write our command and test it. Note that:

    * To work with file names that contain spaces, the variable `$file` must be
      double quoted to prevent **word spitting** from occurring.
    * Inside double quotes, the expansion of variables between single quotes
      (here `'$file'`) *does* occur.

    ```sh
    file="test_file.txt"      # Test with a regular file.
    file="test file.txt "     # Test with a file containing a white space.
    file="missing_file.txt"   # Test with a non-existent file.

    [ -f "$file" ] && cat "$file" || echo "Error: file '$file' does not exist!"

    # Alternatively, we can also directly run `cat` on the file, and re-direct
    # eventual error messages to /dev/null (but this is maybe slightly hacky...).
    cat "$file" 2> /dev/null || echo "Error: file '$file' does not exist!"
    ```

    <br>

2. Both print and save the error message to a log file named `tmp.log`.

    ```sh
    [ -f "$file" ] && cat "$file"  || echo "Error: file '$file' does not exist!" | tee -a tmp.log
    ```

    <br>

3. Prefix the error log messages with the date and time.

    ```sh
    [ -f "$file" ] && cat "$file" || \
      echo "$(date "+%Y%m%d %H:%M:%S") - Error: file '$file' does not exist!" | tee -a tmp.log
    ```

</p>
</details>
<br>

<br>
<br>

Exercise 1.5 - Parameter expansion
----------------------------------

Using the **`showa` function** from the course slides, try the following (feel
free to use any name as long as it has more than one word):

```bash
# Define the `showa` function if not already done.
showa(){ printf "%d args\n" "$#"; printf "%s\n" "$@";}

# Call the `showa` command.
name="Otocolobus manul"
showa $name
#   2 args
#   Otocolobus
#   manul
```

* Give two ways of passing `$name` to `showa` such that the content of `$name`
  is **passed as a single argument**. In other words, `showa` should output
  [`Otocolobus manul`](https://en.wikipedia.org/wiki/Pallas%27s_cat) on a
  single line, as shown below.
* If needed, feel free to read
  [this short section of the bash manual about word splitting](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html).

```bash
showa <your argument here, must involve $name>
# Your output should be:
#   1 args
#   Otocolobus manul
```

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

A first solution is to add double quotes around the variable `$name` when
passing it to the `showa` function. Note that it must be double quotes -
single quotes will not work as they prevent expansion of the `$name` variable.

```sh
name="Otocolobus manul"
showa "$name"
# 1 args
# Otocolobus manul
```

A second solution is to set the
**[`IFS` - Internal Field Separator](https://www.gnu.org/software/bash/manual/bash.html#index-IFS)**
to an empty string, so that the expanded content of `$name` is no longer split
on whitespace (the default `IFS`).

:fire:
**Important:** when using this option, make sure to
**reset the IFS to its default** using the command `unset IFS` when the
modified `IFS` is no longer needed, otherwise you are likely to get strange
(but not unexpected!) behaviors in your shell later on (default `IFS` value
is: `<spc><tab><newline>`).

```sh
IFS=""
showa $name
# 1 args
# Otocolobus manul

# Make sure to reset the IFS to its default.
unset IFS
```

</p>
</details>
<br>

<br>
<br>

Exercise 1.6 - Brace expansion and command substitution
-------------------------------------------------------

### Brace expansion

We would like to print the numbers 1 to 10 using the following code.
Try to run it in your shell... but you should see that it does not give the
expected result!

```bash
n=10
for i in {1..$n}; do
    echo $i
done
```

* :question:
  **Questions:** why does it not work as expected?
* :pushpin:
  **Note:** we have not yet formally seen the syntax of `for` loops, but it
  does not really matter here (the syntax of the for loop is correct, the
  problem is elsewhere).
* :warning:
  **Warning:** make sure that you are using `bash` and not `zsh`  - the
  [Z shell](https://en.wikipedia.org/wiki/Z_shell) - which is currently the
  default on MacOS.

<br>
<details><summary><b>Exercise solution - brace expansion</b></summary>
<p>

The reason why the above loop does not print the expected result (i.e.
numbers from 1 to 10), is because of the
**order in which expansions are carried-out by the shell**.

Specifically, brace expansion is **performed before any other expansions**. In
our case, this means that the shell will attempt to expand `{1..$n}` before it
has actually expanded `$n` to the value `10`. Since `{1..$n}` does not expand
to anything, it is left as is, and then `$n` is expanded into `10`. As a
result, the `for` loop iterates over a single value: `{1..$10}`, which is
printed to the terminal via `echo {1..$10}`.

</p>
</details>
<br>

### Additional Task (if you have time): command substitution

Try to make the above `for` loop work by replacing `{1..$n}` with the output
of a call to the command **`seq`**. The `seq` command can be used to generate
a sequence of integer numbers.

Example use of `seq`:

```sh
seq 1 5  # -> prints the number from 1 to 5.
```

<br>
<details><summary><b>Exercise solution - command substitution</b></summary>
<p>

To make the loop print numbers from 1 to 10 while expanding the `$n` variable,
we can use the **command substitution** `$( seq 1 $n )`:

```sh
n=10
for i in $( seq 1 $n ); do
    echo $i
done
```

Alternatively, we could also use the **C-style syntax** `for` loop:

```sh
n=10
for ((i=1; i<=$n; i++)); do
    echo $i
done
```

</p>
</details>
<br>

Exercise 1.7 - Process substitution
-----------------------------------

The files `data/gene_expression_s1.tsv` and `data/gene_expression_s2.tsv` are
two replicates of a gene expression experiment.

The files contain tabular data with 2 columns: the name of the gene (1st
column) and its expression level (2nd column). To make sure that both files
contain values for the same genes and in the same order, we want to quickly
verify that **the 1st column of both files is identical**.

Using the commands **`diff`** and **`cut`**, write a 1-line command that checks
whether the first column of these two files are identical. This task should be
performed **without creating any intermediate file**.

:dart:
**Hints:**

* To test whether 2 files are identical, we can use the command
  **`diff -s <file 1> <file 2>`**.
* The command **`cut -f<x>`** can be used to extract one or more columns from
  a tabulated file, where `<x>` is the column to extract.
  E.g. `cut -f2` extracts the 2nd column, and `cut -f3,5` extracts the 3rd and
  5th columns.

<details>
  <summary>
    :dart:
    <b>Additional hint</b> - click here for an additional hint if you don't
    know how to get started.
  </summary>
  <p>

* The idea of this exercise is to use **process substitution** to create
  "virtual" files that contain only the 1st column of our 2 sample files. These
  "virtual" files can then be compared to see if they are identical.

</p>
</details>

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

We use **process substitution** to replace the filename arguments of **`diff`**
with the output of the **`cut`** command, which we use to extract the first
column of each file. In this way we are effectively creating 2 "virtual" files
with a single column, and then compare these "virtual" files using
**`diff -s`** to ensure they are the same.

```bash
diff -s <(cut -f1 data/gene_expression_s1.tsv) <(cut -f1 data/gene_expression_s2.tsv)
```

</p>
</details>
<br>

### Additional Task (if you have time)

We now would like to create a new file named `gene_expression_all.tsv` that
contains the data from the 3 files: `data/gene_expression_s1.tsv`,
`data/gene_expression_s3.tsv` and `data/gene_expression_s3.tsv`.

More specifically, the output file should have the following structure: the
first column contains the `GeneID`, and the 3 subsequent columns should contain
the expression levels for each gene in the 3 replicates. Here is how the final
output file should look like:

```text
GeneID   Sample1  Sample2  Sample3
117_at      3.31     3.13     3.41
121_at      4.42     4.46     4.32
1007_s_at  10.93    11.19    11.44
1053_at     8.28     8.06     7.54
```

One additional complication is that the order of the rows (i.e. the genes) is
**not the same between the 3 files** - so you will need to perform some sorting
before putting the columns from the 3 files together.

As before, we want to perform this task
**without creating any intermediate file**.

:dart:
**Hints:**

* Use **`sort -n`** to sort the files. Here `-n` (numerical sort) is a bit of
  a hack that allows us (in this case) to keep the header row at the top of the
  file.
* The **`paste`** command allows to concatenate the content of different files
  by columns.

<br>
<details><summary><b>Exercise solution - additional task</b></summary>
<p>

As before, we can use **process substitution** to avoid creating any
intermediate files.

A combination of **`sort`** and **`cut`** allows to extract the desired columns
of each file: we keep both columns of the 1st file, but only the 2nd column of
the 2nd and 3rd file (because we don't want to duplicate the gene names).

Finally **`paste`** is used to concatenate the content of our 3 "virtual" files
into a single output file.

```sh
paste <(sort -n data/gene_expression_s1.tsv) \
      <(sort -n data/gene_expression_s2.tsv | cut -f2) \
      <(sort -n data/gene_expression_s3.tsv | cut -f2) > gene_expression_all.tsv

head gene_expression_all.tsv
```

<br>

:pushpin:
**Note:** an alternative would be to use the **`join`** command. Unfortunately,
the `join` command only allows to join 2 files at a time, so in this case the
solution ends-up being more complicated (`join` would however be much better in
cases where we want to join files that have missing rows - i.e. not all files
have all the rows):

```sh
join --check-order -o 0 1.2 1.3 2.2 -1 1 -2 1 \
     <( join --check-order -o 0 1.2 2.2 -1 1 -2 1 \
             <( sort data/gene_expression_s1.tsv ) \
             <( sort data/gene_expression_s2.tsv ) \
      ) \
     <( sort data/gene_expression_s3.tsv ) | \
     sort -n | tr " " "\t" > gene_expression_all.tsv

head gene_expression_all.tsv
```

</p>
</details>
<br>
