---
subtitle: Day 1 - Fundamentals
---

Bash Fundamentals
=================

Course Structure
----------------

1. Motivation, Definitions and Objectives
1. Fundamentals
1. Project

Assumed Knowledge
-----------------

The following notions are assumed to be known:

* Simple commands
* Paths and the Filesystem
* Looking (and Moving) around
* Creating, renaming, moving, and deleting files (including directories)
* Editing ordinary files
* I/O redirection, including pipelines
* Filename Globbing
* Simple file operations with `wc`, `grep`, `cut`, and the like
* Return codes, success and failure, `$?`

Advice
------

* The solutions to most exercises can be found in the course material
* However, you'll get more out of this course if you at least try first without
  looking.

Practice
--------

Time for a little warmup:

**$\rightarrow$ Exercise 1.1** - a complex pipeline.

Scripting - the next level
--------------------------

Suppose I wanted to perform the same task (as in Exercise 1.1) on
**all other `data/sample_??.dna` files**.

What are my options? (suggestions welcome!)

. . .

* Type the commands again, once per file.
* Use the history mechanism ($\uparrow$, `!`) - saves a lot of typing.
* Use a loop - saves even more typing.

----------

However:

* Typing the same command multiple times is boring, time-consuming, and
  most of all **error-prone**.
* The history is local and limited - what if I need to do the same task on
  another machine, or when it's no longer in the history?

$\rightarrow$ What we need is a form of **long-term** storage for our command.
In other words, a **script**.

What are shell scripts?
----------------------

Shell scripts:

* Are **plain text** files.
* Contain **shell instructions** - just like the ones we type when working
  interactively.
* Can be **launched from the terminal** like any other program.

To elaborate\ldots{}
--------------------

* The shell is a full **programming language** (not just a command
  interpreter) with constructs like _variables_, _control structures_, and
  _functions_.
* However, it is _specialized_^[The shell can be considered a Domain-Specific
  Language, or DSL] for **running other programs** (including in **concurrency**
  or **parallel**), **passing data** between them, doing **simple**
  computations, and manipulating files.
* By contrast, Python & the like deal primarily with numbers, strings, and
  composite structures made out of these.

Practice
--------

Let's try to write our first shell script.

**$\rightarrow$ Exercise 1.2** - a simple shell script.

Situating Shells among Languages
--------------------------------

\vspace{0.5cm}

![\ ](images/lang-lvl.svg){height=60%}

**Note**: these are _trends_, not absolutes.

What are shell scripts good for?
--------------------------------

### Typical Use Case

**Automating** tasks that we already do (but manually) _in the terminal_.

Ok, so what is automation good for?
-----------------------------------

* Saving time
* Preventing errors
* Ensuring reproducibility
* Avoiding boredom

----------

Nevertheless:

* Interactive tasks _can_ be programmed in the shell (e.g. `bashtop`)...
* \ldots{} and so can serious computations.
* Whether they _should_ be is another question.

Two Styles
----------

Shells can handle a given task in one of two ways:

* **Directly** - the shell performs the task itself.
* By **delegation** - the shell calls one or more other program(s) that do the
  task.

We will refer to these as the **direct** (or **"pure"**) versus **delegation**
styles, respectively.

Two Styles (continued)
----------------------

* Note that the same program can use both approaches.
* $\rightarrow$ The script from Exercise 1.2 is an example of the delegation
  style.

Delegation Style - Wall Metaphor
--------------------------------

![The Wall Metaphor](images/wall-metaphor.png)\
\hfill\footnotesize By Pawel Wozniak -
[Wikimedia Commons](https://commons.wikimedia.org/w/index.php?curid=18603544) \normalsize

Delegation Style - Conductor Metaphor
-------------------------------------

::: columns

:::: column

\begin{center}
\includegraphics[height=.7\textheight]{images/verdi-aida.jpg}
\end{center}
\hfill\footnotesize Verdi conducting \emph{Aida} - Engraving by Adrien Marie,
1881 (public domain) \normalsize

::::

:::: column

\vspace{1cm}

* The conductor does not play any instrument\ldots
* \ldots{} but does play an essential part.^[And, of course, Verdi still wrote
  the whole opera score\ldots]
* The shell may do no heavy computation\ldots
* \ldots{} but still has a crucial role.

::::

:::

Will I need scripting skills?
----------------------------

. . .

![Routinely Unique](images/Chang_Nature_2015.png)\

\hfill\footnotesize Chang J., _Nature_ **520** (2015)\normalsize

* 14 techniques (> 40%) used in only one project.
* Most frequent technique used in < 35% of the projects.
* 79% of techniques used in < 20% of the projects.

Probably yes
-------------

:::{.block}

### The Curse of Uniqueness

Sooner or later you'll face a task that nobody has programmed for you.

:::

$\rightarrow$ Shell scripting is almost certainly part of the solution, though
probably not the whole solution.

"Hidden" Shell Scripts
----------------------

Besides your analysis pipelines, you may also need to write some shell code
for a number of tasks, such as:

* Build systems (Make, Snakemake).
* HPC scheduling jobs.
* Workflow management systems (Nextflow).
* Containers (Dockerfile).
* Test systems (Bats).

When/How **not** to use Shells?
-------------------------------

_Pure_-style shell is **not** recommended if you need:

* Speed.
* Non-trivial data types, _e.g._ floating-point numbers, any kind of structure
  beyond 1-D arrays (matrices, trees, database records, dates, \ldots).
* Functional or object-oriented programming.
* Arbitrary access to file contents.
* Mathematical operations beyond the basics (trigonometry, logs, statistics,
  etc.).

When/How **not** to use Shells? (continued)
-------------------------------

In such cases, it's better to use a more adapted language (`python`, `R`,
`C`, ...) for your task.

$\rightarrow{}$ and then **call your program/script** from in delegation-style
from a shell script.

To sum up
----------

We now know:

* What shell scripting is.
* What it can (and cannot) do for us.
* That it may well prove useful.

$\Rightarrow$ we're ready to start.

Just a Few More Points
======================

Learning Objectives
-------------------

### Objectives

1. Use the shell to write programs (surprise!)
    * Know what the shell does.
    * Understand how it does it.
2. Know enough to learn the rest by yourselves.

Some terminology
----------------

Shell, n.:

: a computer **program** which exposes an _operating system's services_ to
  a human user or other programs (source:
  [Wikipedia](https://en.wikipedia.org/wiki/Shell_(computing)))^[Some shells
  (_sensu lato_) are graphical; in this course we mean **text shells only**.].

Shell, n.:

: the programming **language** that a text-based shell implements^[Graphical
  shells are typically not programmable.].

Shell, n.:

: a **terminal** emulator.

----------

Shell scripting, n.:

: the art of **writing programs** using **a shell language**.

Script, n.:

: a program, usually in a (high-level), **interpreted** language (_e.g._
Python, R, Perl, Ruby, JavaScript, and (of course) shells, but _not_ C, Java,
Rust\ldots)

Which Shell?
------------

* [GNU Bash](https://www.gnu.org/software/bash) is the default shell on most
  Linux distributions, and it's available on MacOS X.
  **It's the one we'll use here.**
* But there are others^[`$ cat /etc/shells` shows you which shells are
  available on your system.], both older (Bourne, Korn, \ldots{}) and newer
  (Fish, Nu, \ldots{}).
* Shells vary in how widespread they are and what features they offer, as well
  as in their licenses (some proprietary, some open-source)

**Warning:** generally, code written for shell X **won't work** in shell Y.  
$\Rightarrow{}$ It matters which one we use.

Course Approach
---------------

* The only way to learn programming is, well, to program\ldots{}
* However, a solid grasp of fundamentals is essential.

We'll start with **fundamentals**, mixing theory and exercises in the
(interactive) shell.

Once we have this under our belt, we'll move to a **coding project** where we
develop an actual (reasonably) useful script for bioinformatics. New notions
will be introduced as we gradually improve the script.  

----------

\begin{alertblock}{Disclaimer}
I may simplify things a little for the sake of brevity and/or clarity.
\end{alertblock}

For example, I might say:

> "Word splitting occurs on unquoted expansions".

instead of:

> "Word splitting occurs on the result of unquoted expansions, except in
> assignments, unless assigning to an array".

Which would be closer to reality (but still not entirely accurate).

Part I - Below the Surface
==========================

WARNING: Lots of Theory Ahead
-----------------------------

* There is no avoiding the material presented below if we want to understand
  how the shell works...
* ... and we need a deeper understanding for scripting than for interactive use.
* Arguably most hair-pulling bugs^[E.g. when you yell at the computer and
  threaten it with defenestration...] come from our^[I
  include myself here, of course] not-so-complete understanding of what the
  shell actually does with our input.
* **Don't** try to learn all this material - rather, be aware of it.
* **Do** follow along in your terminal!

What the Shell does for Us
--------------------------

At the very least, a shell allows users to **launch programs**.  
But shells do much more than that\ldots

To illustrate that, let's try the most bare-bones shell of all:

* demo: **`rush`** - the **R**ather **U**seless **SH**ell.

Rush
----

Command                               Result
----------                            ----------
`ls -l`                               ok
`exit`, Ctrl-D                        ok
`ls *.pdf`                            doesn't work
`grep Bash description.md > result`   doesn't work
`ls | wc -l`                          doesn't work
`cd`                                  doesn't work
`echo $PATH`                          doesn't work
completion, history, arrows           don't work
`peak=Matterhorn; echo $peak`         don't work

What the Shell Does behind the Scenes
-------------------------------------

Besides launching programs, a modern shell, among other functionalities:

* Provides variables.
* Can do arithmetic.
* Performs filename globbing (`*.fasta`, etc.).
* Allows redirection of I/O (`>`, `<`, `|`, etc.).
* Implements a history mechanism.
* Supports auto-completion (`<TAB>`).
* Has flow control structures.

$\rightarrow$ Most of the power of Bash comes from the above features.

For Programming
---------------

Not all of the above are relevant to programming, however.

We'll focus on:

* Variables and how to use them to store, retrieve, and process data.
* Input and output.
* Control Structures ("compound commands").

Because these aspects are the most relevant.

Shell Operation: The Gist
-------------------------

Broadly speaking, the shell does the following:

1. Reads input (terminal, script, `-c`).
1. Splits the input into _tokens_.
1. Parses tokens into commands.
1. Performs expansions (arithmetic, parameters, etc.).
1. Removes quotes.
1. Performs redirections.
1. Executes the commands.
1. Goes back to pt. 1.

We'll survey 2-5. See
[the manual](https://www.gnu.org/software/bash/manual/html_node/Shell-Operation.html#Shell-Operation)
for details.

Step 2: Tokenizing
-------------------

Divide the following sentence into its constituent words:  

> Alas, poor Yorick! I knew him, Horatio.^[W. Shakespeare, _Hamlet_,
> Act V scene 1]

. . .

* We do this effortlessly, without realizing our brain does any work.
* Exceptions: foreign languages, hard-to-read texts.

----------

_Scriptio continua_ has no spaces or punctuation...  
$\rightarrow$ it's now obvious that this requires work.

![images/Vergilius_Augusteus,_Georgica_141-9](images/Vergilius_Augusteus,_Georgica_141-149.png)\

----------

With spaces and punctuation, it's much better:

|     _atque alius latum funda iam uerberat amnem_
|    _alta petens, pelagoque alius trahit umida lina._
|    _tum ferri rigor atque argutae lammina serrae_
|    _(nam primi cuneis scindebant fissile lignum),_
|    _tum uariae uenere artes. labor omnia uicit_
|    _improbus et duris urgens in rebus egestas._
|    _prima Ceres ferro mortalis uertere terram_
|    _instituit, cum iam glandes atque arbuta sacrae_
|    _deficerent siluae et uictum Dodona negaret._

\hfill\footnotesize Publius Vergilius Maro, _Georgica_, Liber I, 141-149\normalsize

This, very broadly speaking, is **tokenizing**.

Tokenizing in Bash
------------------

* **Tokens** are separated according to **metacharacters**: whitespace
  (`space`, `tab`, `newline`) or any of `|` `&` `;` `(` `)` `<` `>`
* Whitespace _separates_ tokens (hence is never _part_ of tokens).
* Tokens are either wholly non-whitespace metacharacters (**operators**) or
  non-metacharacters (**words**).
* Metacharacters can be made literal by _quoting_ (more on that in a few slides).

Tokenizing - Demo
-----------------

The **tokenizing procedure** looks like this:

1. Split on whitespace.
2. Split the resulting tokens on metacharacter -- non-metacharacter boundaries.

**Examples:**

```bash
ls -l | wc -l >> count
ls -l|wc -l>>count
ls-l|wc-l>>count
```

Tokenizing - Examples
--------------------

```bash
ls                      # 1 token: 'ls'
ls -l                   # 2 tokens: 'ls' and '-l'
ls -l > list            # 4 tokens
ls -l >list             # idem
echo $SHELL             # 2 tokens
grep x < file >> out &  # 7 tokens
grep x<file>>out&       # idem
grepx<file>>out&        # 6 tokens - oops!
```

The **`#`** character is special: anything between it and the end of the line
is a **comment**, and is ignored by the shell.

Literal Characters
------------------

These don't work\ldots

```bash
cat data/my file.txt          # WRONG!
echo it is a fact that 3 > 2  # Surprise!
```

\ldots{} because the space and `>` are metacharacters, but here we want them to
stand for themselves: that is, to be _literal_.

Quoting
-------

Quoting removes any special meaning of characters^[There are special characters
other than metacharacters, _e.g._ `$`, `*`, `?` `!`, etc.]. The main forms are:

* `\` (backslash): the next character is literal (except at end of line:
  continuations).
* `''` (single quotes): all characters between `''` are literal (including `\`,
  so cannot include `'`).
* `""` (double quotes): all characters between `""` are literal except `$`,
  \verb+`+,  and`\` (only before `"`, `\`, `$`, \verb+`+).
* `$''` (ANSI): like `''`, but `\t`, etc. work properly.

Quoting - Showing Arguments
---------------------------

We can use the following function^[We'll study functions on day 3.] to
look^[Imperfectly, because _e.g._ expansion, redirection etc. still happen
normally] at arguments. It prints each one on a separate line (type this in
your terminal):

```bash
function showa() {
  printf "%d args\n" "$#"
  printf "%s\n" "$@"
}

# Can be written in shorter form:
showa(){ printf "%d args\n" "$#"; printf "%s\n" "$@";}
```

Quoting - Examples
------------------

```bash
cat > myfile    # Ok
cat > my file   # WRONG
showa my file
showa my\ file  # 1st form
showa 'my file' # 2nd form
showa "my file" # 3rd form
```

Quoting - `''` vs `""`
------------------

The important difference between **`''`** and **`""`** is that the latter allow
_expansions_ to occur (because `$` retains its special status):

```bash
name=Bond
echo "my name is $name"  # Expansion
# -> my name is Bond

echo 'my name is $name'  # No expansion
# -> my name is $name
```

For this reason, single quotes are sometimes called "hard" quotes, and double
quotes "soft" quotes.

**Special case:** expansion occurs if the single quotes are inside double
quotes (because the single quotes then lose their special meaning, and
are treated as literal characters).

```sh
echo "my name is '$name'"
```

Practice
--------

**$\rightarrow$ Exercise 1.3** - tokenizing and quoting.

Step 3: Parsing Commands
------------------------

Natural language analogy: recognizing _grammatically correct sentences_. This
assumes words have been properly identified:

| Utterance                       | Status                           |
| ------------------------------- | -------------------------------- |
| myho vercr afti sful lofe els   | words wrong, grammar _undefined_ |
| hovercraft is my eels of full   | words ok, grammar wrong          |
| my hovercraft is full of eels   | words ok, grammar ok             |

Parsing by the Shell
--------------------

The shell doesn't parse sentences but **commands**^[For details about the
grammar, see its
[official specification](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
].:

* **Simple commands:** we already known this, e.g.
  * `ls -l > out # redirections allowed`
  * `A=1         # also a simple command`
* **Pipelines:** one _or more_ **commands** joined by `|` or `|&`, connecting
  I/O streams (already known)
* **Lists:** one _or more_ pipelines joined by `;` `&` `&&` or `||`, with
  sequential, background and conditional execution
* **Compound commands:** lists structured by flow control keywords (`if`,
  `while`, etc.)

Examples of Lists
-----------------

```bash
long_job &  # Command sent to background.

set -b; sleep 1 & sleep 5 & sleep 8 &
mkdir new ; cd new                     # optimistic
mkdir new && cd new                    # cautious
mkdir /root/stuff && cd /root/stuff    # 1 err msgs
mkdir /root/stuff ; cd /root/stuff     # 2 err msgs
grep skywalker /etc/passwd && echo "found" || echo "not found"
```

Compound Commands
-----------------

More on this later, but just to fix ideas:

```bash
if [ ! -d mydir ]; then mkdir mydir; fi
```

This is a _conditional statement_ built around the simple commands
`[ ! -d mydir ]` and `mkdir mydir`.

$\rightarrow$ Compound commands start and end with _matching keywords_
(`if` \ldots{} `fi`, `{` \ldots{} `}`, etc.)

----------

:::{.block}

### In a Nutshell

Compound commands are made of lists, which are made of pipelines, which are
made of simple commands\ldots{} except that a compound command is _itself_
a simple command: the grammar is _recursive_.

:::

```bash
for f in *; do echo $f; done | wc -l
<--   compound command   -->              
<--    simple command    -->   <-- spl cmd -->
<--         p  i  p  e  l  i  n  e         -->
```

----------

Parsing a sentence converts a linear sequence of words into a tree-like structure:

![\ ](images/sent-syn-tree.pdf)

The tree's structure is constrained by the grammar of English.

----------

The same goes for Bash:^[And all other programming languages, for that matter]

![\ ](images/cmd-syn-tree.pdf)

If a command is syntactically wrong, **it does not parse**.

Practice
--------

**$\rightarrow$ Exercise 1.4** - parsing.

Step 4: Expansions
------------------

After parsing tokens into commands come the **expansions**, _i.e._
the **replacement of expressions with values**, in this order:

1. Brace expansion: `{1..10}`, etc.
1. Left to right:
   * Tilde expansion, _e.g._ `~/Desktop`
   * Parameter expansion: `$USER` & similar
   * Command substitution: `$(date)`, etc.
   * Arithmetic expansion, _e.g._ `$((2+4))`
   * Process substitution: `<(cmd)`
1. Word splitting (different from token splitting!)
1. Filename expansion ("globbing": `*.txt`)

Brace Expansion
---------------

Used to generate sets of strings based on:

* Comma-separated strings: `file_{A,B,C}.txt` $\rightarrow$ `file_A.txt`
  `file_B.txt` `file_C.txt`
* A sequence: `sample_{1..9}` $\rightarrow$ `sample_1` ... `sample_9`

This is **not** the same as file globbing: the generated strings do not have to
be the names of existing files.

Brace Expansion - Examples
--------------------------

```bash
echo {1..100}  # E.g. in loops (see below).
echo {a..j}    # Works on chars.
echo {10..1}   # Works in reverse.

# Create a project tree (note nesting)
mkdir -p my_project/{src,doc/{mail,ref},data}

# {} at same level -> ~ Cartesian product
echo {A..D}{1..3}
```

Tilde Expansion
---------------

This is the well-known replacement of **`~`** by directories:

Tilde expression  Expansion
--------------    ---------
`~`               `$HOME`
`~alice`          Alice's home, probably `/home/alice`
`~+`              `$PWD`

... and a few others that address the directory stack; we won't say more about
them because they're mostly relevant for interactive use.

Parameter Expansion
-------------------

An unquoted **`$`** followed by a parameter name is replaced by the parameter's
value

```bash
place=Rovaniemi
echo $place
# -> Rovaniemi

echo "I'm off to $place"
# -> I'm off to Rovaniemi
```

There is **a lot** more to parameter expansion than this. We'll come back to it
later on.

Command Substitution
--------------------

**`$(...)`** substitutes the output of a command^[Not to be confused with
arithmetic expansion, `$((...))`.]

```bash
echo "Today is $(date -I)"
dirsize=$(du -s .)
nb_files=$(ls | wc -l)
```

An older form uses _backticks_:

```bash
echo "it is now `date`"
```

They're the same, but the modern form is easier to _nest_:

```bash
parent_dirname=$(basename $(dirname $PWD))
```

Arithmetic Expansion
--------------------

This doesn't work as expected:

```bash
a=2; b=3; echo $a+$b
```

This does:

```bash
a=2; b=3; echo $((a+b))  # Note: no $ needed
```

The expression between `$((...))` is evaluated using
[shell arithmetic](#shell-arithmetic) - more about this later.

Process Substitution
--------------------

Replace a filename argument with the output of a command.

Example: What items are common to two lists?

```bash
sort spc-list-1.txt > spc-list-1-sorted.txt
sort spc-list-2.txt > spc-list-2-sorted.txt
comm spc-list-1-sorted.txt spc-list-2-sorted.txt
rm spc-list-1-sorted.txt spc-list-2-sorted.txt
```

With **`<(...)`**, the comparison can be done _on the fly_:

```bash
comm <(sort spc-list-1.txt) <(sort spc-list-2.txt)
```

$\rightarrow{}$ No temporary files, possibly faster.

Word Splitting
--------------

The **results** of **expansions** that **did not occur within double quotes**
then undergo _word splitting_.

```bash
name='Ursus arctos'
showa '$name' # '': no expansion at all
showa "$name" # "": expansion, NO word splitting
showa $name   # expansion, word splitting
```

Why split on words?
-------------------

### Historical aside

* Early shells had no types other than strings.
* To store a _list_ of values, programmers used whitespace:

  ```bash
  dirs='bin doc new'
  ```

* But without word splitting we now have a problem:

  ```Zsh
  # Try this in Zsh, which doesn't word-split
  ls -ld $dirs
  #  ls: cannot access 'bin doc new':
  #  No such file or directory
  ```

Solutions (sort of)
-------------------

* Bourne shell (`sh`, 1976): word-split unless within `""`.
* Korn shell (`ksh`, 1983): new data type (arrays) for lists, otherwise same
  behaviour^[Let's not break existing code];
  syntax for "all elements" rather clunky: `"${array[@]}"`
* Bash, v. 2 (1996): same as `ksh`.
* Zsh (`zsh`, 1991): prefer arrays for lists, word-splitting only if
  required^[If this breaks existing code, so be it!],
  cleaner syntax for all elements.

IFS - Internal Field Separator
------------------------------

Word splitting uses the characters in the the
**`IFS` - the Internal Field Separator**^[Hence the alternative (and better)
term _field_ splitting.] (by default, `<space><tab><newline>`)^[Contrary to
splitting into tokens, which uses whitespace and metacharacters.] as word
delimiters.

The value of `IFS` can be changed:

```bash
line='gene_name,seq_len,mol_wt'   # CSV-like
showa $line                       # 1 field
IFS=','; showa $line; unset IFS   # 3 fields
```

IFS - Internal Field Separator (continued)
------------------------------

If `$IFS` is null, no splitting is done. If unset, the above default is used.  

$\rightarrow$ To reset the value of `IFS`: `unset IFS`.

Filename Expansion ("globbing")
-------------------------------

Words that contain **unquoted** `*`, `?`, or `[` are pattern-matched
against the files in the current directory.^[This is done after parameter
expansions so that globs can be stored in variables, _e.g._
`glob='*.pdf *.docx'; ls $glob`.]

Wildcard   meaning
--------   -------
`?`        any 1 character
`*`        any string, including ''
`[...]`    any character in the class

There are predefined classes, _e.g._ for letters, digits, punctuation, etc.

----------

```bash
# No quotes -> globbing occurs.
ls *.pdf

# Quotes -> no globbing occurs.
ls '*.pdf' "*.pdf" \*.pdf
echo "$glob" # Still quoted -> no globbing

# When a variable is set, quotes not needed
glob=*.pdf
```

In the last example, parameter expansion of `"$glob"` yields `"*.pdf"` (not
`*.pdf`), so no globbing occurs. The quotes are removed in the next stage.

Quote Removal
-------------

After all expansions have been performed, quotes (and backslashes) are removed
(unless they are quoted or result from an expansion):

```bash
echo 'recA' "dnaK"  # '," removed
echo d\'Artagnan    # \ removed
echo "a 'quote"     # ' retained: quoted
q='"'; echo "$q"    # middle " retained: expansion
```

This is why quotes usually disappear when we use `echo` or `showa`.

Expansions can be Mixed
-----------------------

```bash
pattern=*.md
echo "Markdown files:" $(ls $pattern)
```

This mixes parameter expansion, command substitution, word splitting, and
filename globbing.

Practice
--------

**$\rightarrow$ Exercise 1.5** - parameter expansion.

**$\rightarrow$ Exercise 1.6** - brace expansion and command substitution.

**$\rightarrow$ Exercise 1.7** - process substitution.

Step 5: Redirection
-------------------

After all the expansions phase come the **redirections**, in which the
operations specified by `>`, `>>`, `|`, `<` etc. are performed, and the
corresponding operators and arguments removed from the expanded list of words:

```bash
# Output of ls goes into list.txt (destructive!)
# Use >> to append
ls > list.txt
```

**Note**: Redirection can also be done from _within_ the script:

```bash
exec < my_input.txt
# From now on, stdin comes from my_input.txt
```

Here Documents: `<<`
--------------------

```bash
cat <<END
# Everything up to END goes to the input of cat;
# The end token can be any word, not just END
# Quoting prevents expansion.
END
```

Useful to store some multiline output within the script - see `src/welcome.sh`.

Here Strings: `<<<`
------------------

Useful for small inputs that can fit on the command line, _e.g._ measuring the
length of strings:

```bash
# /!\ Includes newline!
wc -l <<< CATCGACATGCA
```

Step 6: Command Execution
-------------------------

Finally, after all these tokenization, parsing, various expansions, quote
removal, and redirection steps, the command is ready to be launched. The shell
requests the kernel to do so.

Recap
-----

The main stages of input processing:

1. Tokenizing
1. Parsing into commands
1. Expansions
   1. `{}`
   1. `~`, `${}`, `$()`, `$(())`, `<()`
   1. Word splitting
   1. Globbing
1. Quote Removal
1. Redirections

A Brief Point About Pure and Delegation Styles
==============================================

----------

* "pure" and "delegation" styles were introduced [earlier](#2styles).
* \ldots{} but to make the following points I needed some recently-introduced
  notions.

----------

Task: count the nucleotides in a sequence file.

```bash
# Pure style: all in Bash
./ntcount-pure < genome

# Delegation style: calls tr, tee etc.
./ntcount-deleg < genome
```

The scripts could hardly be more different (see code).

----------

Now let's measure run times, using increasing numbers of lines.

$\rightarrow$ and the winner is\ldots

----------

![tolower runtime](images/ntcount_all-inputs.svg)\

----------

![tolower runtimes (small inputs)](images/ntcount_small-inputs.svg)\

Interpretation
--------------

* External programs are typically (much) faster than Bash.
* _Launching_ an external program has a **cost** (overhead) .
* The "delegation" style launches programs, the "pure" style doesn't.
* The extra speed more than compensates for the overhead,
  _except for very small inputs_ and/or numerous tasks.

