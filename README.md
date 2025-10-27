UNIX Shell Scripting for Life Scientists
========================================

Welcome to the home page of the **UNIX Shell Scripting** SIB course.

<br>

Resources
---------

### Course slides and resources

**Course in 2 days:**

* [Course slides - day 1](slides/2days/shell-scripting-day1.pdf)
* [Course slides - day 2](slides/2days/shell-scripting-day2.pdf)

**Course in 3 days:**

* [Course slides - day 1](slides/3days/shell-scripting-day1.pdf)
* [Course slides - day 2](slides/3days/shell-scripting-day2.pdf)
* [Course slides - day 3](slides/3days/shell-scripting-day3.pdf)

### Exercise instructions

* [Exercise instructions - day 1](exercises/exercises_day1.md)
* [Exercise instructions - day 2](exercises/exercises_day2.md)
* [Exercise instructions - day 3](exercises/exercises_day3.md)
* [Exercise instructions - FASTA to TSV converter project](exercises/exercises_project.md)
* [Course and exercise data download](https://gitlab.sib.swiss/tjunier/scripting-course/-/archive/master/scripting-course-master.zip)

### Documentation

* [Bash Programming Reference](doc/bash_programming_ref.pdf)
* [Bash koans](doc/bash_koans.md)
* [A sysadmin's guide to bash scripting](doc/sysadmin_guide_to_bash_scripting.pdf)
* [Frequently asked questions](doc/shell_scripting_faq.md)

### Links for online classes

* [Google doc](https://docs.google.com/document/d/1RY2Le0Z6dghKVlzQIOI32OpObC-6TjVuGe2mXXryRPA)
  for asking questions.

<br>
<br>

Course description
------------------

### Overview

Scripting allows shell users to automate repetitive tasks, improving
reproducibility, reducing the risk of errors, freeing time, and avoiding
boredom.

Bioinformatics analysis pipelines may involve dozens or hundreds of steps that
are each carried out by different command-line programs: assembling these into
scripts allows users to treat whole pipelines as if they were ordinary shell
commands.

### Audience

This course targets users who have basic knowledge of interactive shell use,
such as taught in the SIB's [First Steps with UNIX in Life
Sciences](https://www.sib.swiss/training/course/2020-09-unix) and are
interested in moving from interactive to automated tasks.

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

Prerequisites and environment setup
-----------------------------------

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

### Technical - setting-up your environment

**Important:** please make sure perform the following environment setup
**before the start of the course**.

The only technical requirement for the course is having a version of
`bash` >= `4.0` (released in 2009) installed on your computer.  
If you need to install `bash`, please see the
[setting-up your environment instructions](environment_setup.md) documentation.
