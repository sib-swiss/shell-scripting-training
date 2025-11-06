# UNIX Shell Scripting

Welcome to the home page of the **UNIX Shell Scripting** SIB course. This
repository contains all of the course material.

<br>

## Course resources 📚

**Course slides:**

* [Course slides - day 1](slides/2days/shell-scripting-day1.pdf)
* [Course slides - day 2](slides/2days/shell-scripting-day2.pdf)
* [Summary](info/summary.md)

**Exercise instructions:**

* [Exercises part 1: shell expansions](exercises/instructions/exercises_1.md)
* [Exercises part 2: arguments, loops and functions](exercises/instructions/exercises_2.md)
* [Exercises: FASTA to TSV converter project](exercises/instructions/exercises_project.md)

**Documentation:**

* [Course frequently asked questions](info/shell_scripting_faq.md)
* [Bash Programming Reference](doc/bash_programming_ref.pdf)
* [Bash koans](doc/bash_koans.md)
* [A sysadmin's guide to bash scripting](doc/sysadmin_guide_to_bash_scripting.pdf)

<br>
<br>

## Course description 💫

### Overview

Scripting allows shell users to automate repetitive tasks, improving
reproducibility, reducing the risk of errors, freeing time, and avoiding
boredom.

Bioinformatics analysis pipelines may involve dozens or hundreds of steps that
are each carried out by different command-line programs: assembling these into
scripts allows users to treat whole pipelines as if they were ordinary shell
commands.

<br>

### Audience

This course targets users who already have basic knowledge of interactive
shell use, such as taught in the SIB's
[Introduction to Linux / UNIX and the Bash shell](https://github.com/sib-swiss/unix-first-steps-training)
, and are interested in moving from interactive to automated tasks.

<br>

### Learning objectives

The course covers the following topics:

* Understanding command parsing and processing by the shell:
  * Tokenizing.
  * Command parsing.
  * Expansions (brace, parameter, process substitution).
  * Word splitting and the IFS.
  * Globbing.
  * Standard input/output re-directions.
* The main syntactic constructs of the Bash shell: tests, conditionals, loops
  and functions.
* String and arithmetic operations.
* Reading inputs and writing outputs.
* Passing and parsing command-line arguments and options to shell scripts.
* Using arrays.
* Assembling individual analysis steps into reproducible, automated pipelines.

<br>
<br>

## Prerequisites and environment setup 🔨

### Knowledge / Skills

Participants are expected be familiar with the basics of UNIX shells, in
particular:

* Moving around the file system and creating/deleting directories: `ls`, `cd`,
  `mkdir`, `rmdir`.
* Understanding path names, i.e. what is the path to a file or a directory.
* Redirecting output to files or other programs: `>`, `>>` and `|` operators.
* Some familiarity with basic shell utilities such as `grep`, `cut`, `tr`
  (no expert skills required).
* Proficiency with a text editor (necessary to write/edit script files).

Notions of programming (in any language) will be useful, but are not essential.
For a more detailed list of prerequisites, please see
[this document](prerequisites.md).

<br>

### Technical - setting-up your environment

**🔥 Important:** please make sure perform the following environment setup
**before the start of the course**.

The only technical requirement for the course is having a version of
`bash` >= `4.0` (released in 2009) installed on your computer.

If you need to install `bash`, please see the
[setting-up your environment instructions](environment_setup.md) documentation.
