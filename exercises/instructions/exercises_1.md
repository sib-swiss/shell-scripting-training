# Shell scripting exercises part 1: shell expansions

<br>

## Before you start 📣

* 📚 **Exercise material setup:** make sure you **downloaded and unzipped**
  the course material to your computer. The exercise material is found in
  the `exercises/` subdirectory. Instructions assume that you are located
  in that directory.

* 🔮 **Additional Tasks:** some exercises have **Additional Task** sections
  that you can complete if you still have time after having completed the main
  part of the exercise. These will in principle not be corrected in class,
  but solutions are provided.

* ✅ **Exercise solutions** are directly embedded in this document. You can
  reveal them by clicking on the drop-down menu, as shown below.

  <details><summary><b>Solution (click to reveal)</b></summary>
  🌟 This reveals the answer 🌟
  </details>

  We encourage you to **not look at the solution too quickly**, and try to
  solve the exercise without it. Remember you can always ask the course
  instructors for help.

* ✨ **Table of content:** when viewing this document on GitHub, you can
  display a table of content by clicking on the "Outline" button at the top
  right.

<br>
<br>

## Exercise 1.1 - A complex pipeline

🎯 **Objective:** warmup exercise: a reminder of interactive shell usage and
of some UNIX commands.

<br>

Before we write bash scripts, let's start with an exercise where we carry-out
a task in an **interactive** way (i.e. typing our commands directly in the
shell).

You are given the file `data/sample_01.fasta`, which contains genetic sequences
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

> ✨ **Notes:**
>
> * In FASTA format, each sequence starts with a **header line**, identified
>   by its leading **`>`** character.
> * In the particular case of our FASTA files, the species name to which each
>   sequence belongs can be found in the header, and is prefixed with **`s:`**.
>   E.g., in our example above, the species of the first sequence is
>   `Desulfovibrio vulgaris` - a species of
>   [sulfate-reducing bacteria](https://en.wikipedia.org/wiki/Desulfovibrio_vulgaris).

<br>

Your task is to **find the number of sequences** of the species with the most
sequences in the file (useful e.g. to check for over-representation).
The result should be a single number. For instance, if the most represented
species has 16 sequences in the file, then your command should output `16`.

To achieve this objective, we will count the number of sequence headers for
each species, and then see which one has the most. In practice, we proceed in
the following way (note: there are many ways to achieve this task - this is
only one of them):

1. **Extract the species name** from each header in the file. This can be done
   by using the UNIX command `grep`.

   ```sh
   grep -o "s:.*;" data/sample_01.fasta
   ```

   > ✨ **Tip:** to check the output of a command without displaying all of
   > it, you can pipe the command's output into `head`.
   >
   > ```sh
   > grep -o "s:.*;" data/sample_01.fasta | head
   > ```

   > 🦉 **Reminder:** `grep` print lines (from a file or from standard input)
   > that match a given pattern. The **`-o`** option of `grep` allows to print
   > only the part of the line that matches the pattern instead of printing the
   > entire line (the default behavior).

   <br>

2. **Count the number of occurrences** of each species by piping the output
   of our earlier `grep` into `sort` and `uniq`:

    ```sh
    grep -o "s:.*;" data/sample_01.fasta | sort | uniq -c
    ```

   `uniq -c` counts the number of occurrences of each line. However, this
   only works if the lines are sorted (identical lines must be adjacent),
   which is why we first sort the lines with **`sort`**.

    > 🦉 **Reminder:**
    >
    > * **`sort`**: sorts lines of text alphabetically, or numerically
    >   with `-n` option.
    > * **`uniq`**: filters _adjacent_ repeated lines and keeps only a single
    >   occurrence of them. By adding the **`-c`** option, it can also count
    >   occurrences of each line.

    <br>

3. **Isolate the species with the most counts**. For this we need to:
   * Order species by increasing (or decreasing) occurrence count. This can
     be achieved with **`sort -n`** (does a numeric sort).
   * Keep only the species with the largest count number. This can be done with
     **`tail -1`** or **`head -1`** (if you sorted in decreasing order).

      <details>
      <summary><b>✅ Solution</b></summary>

      ```sh
      grep -o "s:.*;" data/sample_01.fasta | sort | uniq -c | sort -n | tail -1
      ```

      </details>

    > 🦉 **Reminder:**
    >
    > * **`head`** - output the first part of text files (or standard input).
    > * **`tail`** output the last part of text files (or standard input).

    <br>

4. **Extract the number of occurrence count**. The last step is to keep only
   the actual occurrence count, and not the entire line. This can be done e.g.
   with either:
   * `grep -o '[0-9]\+'`
   * `awk '{print $1}'` : the command `awk` splits lines on whitespace by
     default, and the `print $1` instruction prints the first field or the
     line.

   <br>
   <details>
   <summary><b>✅ Solution</b></summary>

    ```sh
    grep -o 's:.*;' data/sample_01.fasta | sort | uniq -c | sort -n | tail -1 | grep -o '[0-9]\+'
    grep -o 's:.*;' data/sample_01.fasta | sort | uniq -c | sort -n | tail -1 | awk '{print $1}'
    ```

   </details>

<br>
<details><summary><b>✅ Full solution</b></summary>
<p>

There is a multitude of ways to solve this task. Here is one of them:

```bash
# Commented solution. This will not work if you copy/paste as is because of
# the comments at the end of lines.

grep -o 's:.*;' data/sample_01.fasta | \  # Keep only species names.
  sort | \            # Sort alphabetically. Needed for applying `uniq` to the data.
  uniq -c | \         # Keep only a single occurrence of each value, and add counts.
  sort -n | \         # Sort numerically.
  tail -1 | \         # Keep the last value only (the one with the most counts).
  grep -o '[0-9]\+'   # Keep only the number of counts (not the name of the species).

# The same on a single line:
grep -o 's:.*;' data/sample_01.fasta | sort | uniq -c | sort -n | tail -1 | grep -o '[0-9]\+'
```

<br>

> **✨ Notes**
>
> * The backslashes `\` at the end of lines are only for page layout purpose
>   (it's a line continuation character). As we shall see, backslashes are a
>   form of _escaping_.
> * The second `grep` could be replaced by `sed`, `awk` or `cut`. We decided to
>   show the solution with `grep` because it might be more familiar to most
>   people.
> * For the `grep` command to really only match the species name (without the
>   leading `s:` prefix), we can use a regular expression with a lookahead.
>
>    ```sh
>    grep -oP "(?<=s:).*;" data/sample_01.fasta
>    ```

</p>
</details>

<br>
<br>

## Exercise 1.2 - A simple shell script

Using your favorite text editor - which should be [Vim](https://www.vim.org)
of course 😎 - create a new file named `max_spc.sh` and copy/paste the
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

> **✨ Notes:**
>
> * These are just the commands from Exercise 1.1 with a couple of minor
>   changes (can you spot them?).
> * In the file name, the **`.sh`** extension, like all extensions under UNIX,
>   has no particular effect and is just a matter of convention. `sh` is short
>   for `shell`.

<br>

**Congratulations 🎉 !** You have just created a **Bash script**. Let's make
it **executable** by using the command:

```bash
chmod a+x max_spc.sh
```

We can now run our script as if it were a **system command**...

```bash
./max_spc.sh < ./data/sample_01.fasta
```

Of course, we can pass any other FASTA file to it...

```bash
./max_spc.sh < ./data/sample_02.fasta
```

<br>

> **💎 Bonus:** we will see **`for` loops** later in the course, but here is a
> peek at how we could easily run `max_spc.sh` on all our FASTA files. You can
> try copy-pasting the following lines in your shell if you like:
>
> ```bash
> for file in ./data/sample_0?.fasta; do
>     echo -n "Max sequence counts for a single species in $file: "
>     ./max_spc.sh < "$file"
> done
> ```

<br>
<br>

## Exercise 1.3 - Tokenizing and quoting

### A) Quoting

Run the following lines of code in your shell:

```bash
name=Gaius
echo my name is '$name'
echo "my name is '$name'"
```

**❓ Question:** can you explain why the variable `$name` gets expanded
in the second case, but not in the first ?

<details><summary><b>✅ Solution</b></summary>
<p>

* `echo my name is '$name'`: here the variable `name` is surrounded by single
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

### B) Character escaping

The following command works...

```bash
echo my name is Bond
```

...but this one does not:

```bash
echo my name is O'Donnelly
```

**❓ Question:** Why is that ? And how can we fix this ?

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

The problem is that the single quote in `O'Donnelly` is not matched by a second
(closing) single quote. To fix this, we can either:

* Escape the single quote: `echo my name is O\'Donnelly`.
* Double-quote the word containing the single quote, or the whole string:
  `echo "my name is O'Donnelly"`.

> ✨ **Note:** since the character we are trying to escape is a single
> quote `'`, we cannot use single quotes to quote it.
> This will _not_ work: `echo 'my name is O'Donnelly'`, because there is now
> again a non-matched single quote (the last one).

</p>
</details>

<br>
<br>

## Exercise 1.4 - Command parsing

1. **Write a command list** that prints the content of a file to standard
   output (i.e. the terminal) if a file exists, and prints
   `Error: the file '<name of file>' does not exist!"` otherwise.

   > **🔥 Important:** make sure your command also works with files whose name
   > contains a space!

   > **🎯 Hint:** the command to test if a file exists is: `[[ -f $file ]]`.
   > Note the word splitting is deactivated, and therefore it is not
   > necessary to quote the `$file` variable.

   <br>

2. **Modify your command list** so that the error message gets printed to both
   the standard output and a hypothetical log file named `tmp.log`. The error
   messages should _append_ to the log file, not overwrite it.

   * **🎯 Hint:** the command `tee` allows to both write content to a file and
     redirect it to standard output. Example usage:

      ```bash
      echo "print me!" | tee test_file.txt
      echo "add another line" | tee -a test_file.txt
      ```

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

We start by creating a couple of files that we will use to test our command.
Note that the second file has a space in its name.

```sh
echo "This is the content of the file..." > test_file.txt
echo "This is the content of the file..." > "test file.txt"
```

We can now write our command and test it.

```sh
file="test_file.txt"      # Test with a regular file.
file="test file.txt"      # Test with a file containing a white space.
file="missing_file.txt"   # Test with a non-existent file.

[[ -f $file ]] && cat "$file" || echo "Error: file '$file' does not exist!"

# Alternatively, we can also directly run `cat` on the file, and re-direct
# eventual error messages to /dev/null (but this is maybe slightly hacky...).
cat "$file" 2> /dev/null || echo "Error: file '$file' does not exist!"
```

> ✨ **Notes:**
>
> * To work with file names that contain spaces, the variable `$file` must be
>   double quoted to prevent **word spitting** from occurring.
> * Inside double quotes, the expansion of variables between single quotes
>   (here `'$file'`) _does_ occur.

<br>

To both print and save the error message to a log file named `tmp.log`:

```sh
[[ -f $file ]] && cat "$file"  || \
  echo "Error: file '$file' does not exist!" | tee -a tmp.log
```

</p>
</details>
<br>

### 🔮 Additional Task: improved error message

Prepend the current date and time to the error message. To create a string
with the current date and time, you can use:

```sh
date "+%Y%m%d %H:%M:%S"
```

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

```sh
[[ -f $file ]] && cat "$file" || \
  echo "$(date "+%Y%m%d %H:%M:%S") - Error: file '$file' does not exist!" | \
  tee -a tmp.log
```

</p>
</details>

<br>
<br>

## Exercise 1.5 - Parameter expansion

In your shell, define a new **function** named **`showa`** (this is the
same function as shown in the course slides):

```bash
showa(){ printf "%d args\n" "$#"; printf "%s\n" "$@"; }
```

Then try to run the following (feel free to use any value for `name`, as long
as it has more than one word):

```bash
name="Otocolobus manul"
showa $name
```

You should see that the functions tells us that 2 arguments were passed to it.

<br>

**❓ Question:** give two ways of passing `$name` to `showa` such that the
content of `$name` is **passed as a single argument**. In other words, `showa`
should output
[`Otocolobus manul`](https://en.wikipedia.org/wiki/Pallas%27s_cat) on a single
line, as shown below.

```bash
1 args
Otocolobus manul
```

> 🎯 **Hint:** if needed, feel free to read
> [this short section of the bash manual](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html)
> about word splitting.

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

In order to pass our value `Otocolobus manul` as a single argument, we have
to **disable word splitting** on the expansion of `$name`.

**Option 1:**  
Prevent word splitting by adding **double quotes** around the variable `$name`.
Note that we must use double quotes, because single quotes will would prevent
expansion of `$name` in the first place.

```sh
name="Otocolobus manul"
showa "$name"
# 1 args
# Otocolobus manul
```

**Option 2:**  
Set the
[**`IFS` - Internal Field Separator**](https://www.gnu.org/software/bash/manual/bash.html#index-IFS)
to an empty string, so that the expanded content of `$name` is no longer split
on whitespace (the default `IFS`).

> 🔥 **Important:** make sure to **reset the IFS** to its default using
> `unset IFS` when the modified `IFS` is no longer needed. Otherwise you are
> likely to get strange (but not unexpected!) behaviors in your shell later on
> (the default `IFS` value is: `<spc><tab><newline>`).

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

## Exercise 1.6 - Brace expansion

We would like to print the numbers 1 to 10 using the following code.
Try to run it in your shell... but you should see that it does not give the
expected result !

```bash
n=10
for i in {1..$n}; do
    echo $i
done
```

**❓ Question:** why does it not work as expected ?

> **✨ Note:** we have not yet formally seen the syntax of `for` loops, but it
> doesn't really matter here: the syntax of the for loop is correct, the
> problem is elsewhere.

> **⚠️ Warning:** make sure that you are using `bash` and not `zsh`  - the
> [Z shell](https://en.wikipedia.org/wiki/Z_shell) - which is currently the
> default on MacOS.

<br>
<details><summary><b>✅ Solution</b></summary>
<p>

The reason why the above loop does not print the expected result (i.e.
numbers from 1 to 10), is because of the
**order in which expansions are carried-out** by the shell.

Specifically, brace expansion is **performed before any other expansions**. In
our case, this means that the shell will attempt to expand `{1..$n}` before it
has actually expanded `$n` to the value `10`. Since `{1..$n}` does not expand
to anything, it is left as is, and then `$n` is expanded into `10`. As a
result, the `for` loop iterates over a single value: `{1..10}`, which is
printed to the terminal via `echo {1..10}`.

</p>
</details>
<br>

### 🔮 Additional task: command substitution

Try to make the above `for` loop work by replacing `{1..$n}` with the output
of a call to the command **`seq`**. The `seq` command can be used to generate
a sequence of integer numbers.

Example use of `seq`:

```sh
seq 1 5  # -> prints the number from 1 to 5.
```

<br>
<details><summary><b>✅ Solution</b></summary>
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

## Exercise 1.7 - Process substitution

The files `data/gene_expression_s1.tsv` and `data/gene_expression_s2.tsv` are
two replicates of a gene expression experiment.

The files contain tabular data with 2 columns: the name of the gene (1st
column) and its expression level (2nd column).

```txt
GeneID      Sample1
1007_s_at   10.93
1053_at     8.28
117_at      3.31
...
```

To make sure that both files contain values for the same genes and in the same
order, we want to quickly verify that
**the 1st column of both files is identical**.

Using the commands **`diff`** and **`cut`**, write a 1-line command that checks
whether the first column of these two files are identical. This task should be
performed **without creating any intermediate files**.

> **🎯 Hints:**
>
> * To test whether 2 files are identical, we can use the command:
>   **`diff -s <file 1> <file 2>`**
> * The command **`cut -f<x>`** can be used to extract one or more columns from
>   a tabulated file, where `<x>` is the column to extract.
>   E.g. `cut -f2` extracts the 2nd column, and `cut -f3,5` extracts the 3rd and
>   5th columns.
>
> <details>
> <summary>
> <b>🎯 Additional hint</b> - if you need more hints to get started.
> </summary>
> <p>
>
> The idea of this exercise is to use **process substitution** to create
> "virtual" files that contain only the 1st column of our 2 sample files.
> These "virtual" files can then be compared to see if they are identical.
> </p>
> </details>

<br>
<details><summary><b>✅ Solution</b></summary>
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

### 🔮 Additional task: concatenating files

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

> **🎯 Hints:**
>
> * Use **`sort -n`** to sort the files. Here `-n` (numerical sort) is a bit of
>   a hack that allows us (in this case) to keep the header row at the top of the
>   file.
> * The **`paste`** command allows to concatenate the content of different files
>   by columns.

<br>
<details><summary><b>✅ Solution</b></summary>
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

> **✨ Note:** an alternative would be to use the **`join`** command.
> Unfortunately, the `join` command only allows to join 2 files at a time,
> so in this case the solution ends-up being more complicated. `join` would
> however be much better in cases where we want to join files that have
> missing rows (i.e. not all rows are present in all files):
>
> ```sh
> join --check-order -o 0 1.2 1.3 2.2 -1 1 -2 1 \
>      <( join --check-order -o 0 1.2 2.2 -1 1 -2 1 \
>              <( sort data/gene_expression_s1.tsv ) \
>              <( sort data/gene_expression_s2.tsv ) \
>       ) \
>      <( sort data/gene_expression_s3.tsv ) | \
>      sort -n | tr " " "\t" > gene_expression_all.tsv
> 
> head gene_expression_all.tsv
> ```

</p>
</details>
<br>
