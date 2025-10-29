---
title: Self-Test Questions
subtitle: for the SIB Shell Programming Course
author: Thomas Junier
date: \today{}
classoption:
  -onecolumn
number-sections: false
---


**NOTE** All questions have between 0 and 5 (included) correct answers.

### Question 1

Which part the following command is an _option_?

```bash
$ ls -l
```

* [ ] none
* [x] `-l`
* [ ] Unix commands do not have options
* [ ] `ls`
* [ ] both

### Question 2

How can I obtain help about the `mv` command?

* [ ] `manual mv`
* [x] `man mv`
* [ ] `mv help`
* [ ] `describe mv`
* [ ] `help mv`

### Question 3

Suppose you are logged in as `myself`, and currently working in
`/home/myself/project/`. Which of the following commands will
bring you to your home directory?

* [ ] `cd .`
* [x] `cd /home/myself`
* [x] `cd`
* [x] `cd $HOME`
* [x] `cd ..`

### Question 4

Which of the following terms best describes any document that is _not_ text in
the sense of a Unix text file?

* [ ] CSS
* [ ] graphics
* [x] binary
* [ ] HTML
* [ ] PDF 

### Question 5

What operator(s) redirect(s) a command's output into a file (possibly, but not
necessarily, creating or deleting it beforehand)?

* [ ] `%`
* [x] `>`
* [ ] `|`
* [x] `>>`
* [ ] `&`

### Question 6

Why does this not replace `myfile` with a sorted version of itself?

```bash
$ sort < myfile > myfile # bad!
```

* [ ] the file to be `sort`ed and the output file must both be passed as arguments
* [x] redirections occur before execution, so `myfile` is empty when `sort` runs
* [ ] `myfile` has the wrong permissions
* [ ] sort always deletes its argument
* [ ] the file to be `sort`ed must be passed as an argument

### Question 7

These two commands work without problems and produce the same output:

```bash
$ grep tiffany /etc/passwd
$ grep tiffany < /etc/passwd
```

So why does this work...

```bash
$ tr ':' ';' < /etc/passwd
```

...but not this:

```bash
$ tr ':' ';' /etc/passwd
```

* [ ] `tr` is not allowed to read `/etc/passwd` for security reasons
* [ ] `tr` expects its input in a file named by its first argument
* [ ] `tr` expects its input in a file named by its third argument
* [ ] `tr` expects its input in a file named by its second argument
* [x] `tr` expects its input on standard input

### Question 8

What would be the most straightforward way of displaying the first ten lines of
file `myfile` that contain the string `GAATTC`?

* [ ] `grep GAATTC > tmp; head < tmp`
* [ ] `find GAATTC < myfile -n 10`
* [ ] `grep GAATTC > tmp; head < tmp; rm tmp`
* [x] `grep GAATTC < myfile | head`
* [ ] `head < myfile | grep GAATTC`

### Question 9

What is wrong with this?

```bash
$ cat myfile | grep '^[a-z]\+' >> output.txt
```

* [ ] The regular expression is wrong
* [ ] There will be a bottleneck because `cat` is much slower than `grep`
* [ ] There must be a '`<`' before `myfile`
* [ ] There is nothing wrong with this command
* [x] `cat` is unnecessary and wastes resources

### Question 10

You are given a file named `sci_names.txt` with scientific names, one per line, as follows:

```
Panthera leo
Balaena mysticetus
Panthera tigris
Panthera pardus
Corvus monedula
Corvus corax
Solanum tuberosum
Bacillus subtilis
...
```

Your task is to find the genus with the most species (in the snippet above, that
would be _Panthera_, with three species). The expected output is just the genus
name, nothing else. Which command does the job? 

* [ ] `cut -d' ' -f1 < sci_names.txt | sort | uniq -c | sort -k1,1rn | head -1 | tr -d ' 0-9' | wc -c`
* [ ] `cut -d' ' -f1 < sci_names.txt | uniq -c | sort -k1,1rn | head -1 | tr -d ' 0-9' | wc -c`
* [ ] A 100-line Python script
* [ ] `cut -d ' ' -f1 < sci_names.txt | sort | uniq -c | sort -k1,1rn`
* [x] `cut -d' ' -f1 < sci_names.txt | sort | uniq -c | sort -k1,1rn | head -1 | tr -d ' 0-9'`

**Note** there are plenty of solutions to this problem. The choices above avoid
some of the more powerful shell tools (like `sed` and `awk`) not because they're
not suitable (they are!) but because they may be less familiar.
