---
subtitle: Further Supplementary Slides
---

Functions
---------

A *function* is like a miniature script that can be called from within
another script. Calling a function causes its code to be executed, but does
not by itself start a new process.

We write functions in order to:

* Re-use code (DRY principle).
* Improve the clarity of the code.
* Avoid creating new processes (they have a cost: see `noop_test.sh`) 

Definition
----------

Functions are defined with one of the following forms:

```bash
my_func() {
  <commands> # function body
}

function my_func {
 <commands> # function body
}
```

Call
----

A function is called just like a command. Arguments are passed in the same way:

```bash
my_func arg1 "$value"
```

Positional parameters (`$1`, `$@`, `shift`, etc.) work in the same way as in
scripts.

Local Variables
---------------

By default, all variables in Bash are **global**: once set, they can be
accessed from anywhere in the script.  
Variables defined in a function can^[And usually should] be declared as
**local**, so that they are only available in the namespace of that function:

```bash
my_var='a'
my_func() {
  local my_var='b'  # A different variable.
}
```

See `../src/func.sh`.

"Returning values" from functions
---------------------------------

Shell functions **do not** return values^[Unlike in pretty much every other
language.]: instead, they return an exit status, again behaving like commands.

To pass data back to the caller: (i) have the function output the value of
interest, and (ii) use command substitution over the function call.

```bash
my_func() { echo "Hi!"; }
result=$(my_func)  # The function is called just like any command.
```

The exit status is that of the last command in the function body, but it can be
overridden with the `return` keyword.

Practice
--------

Let's practice using functions to avoid duplication.

**$\rightarrow$ Exercise 3.3** - Introduction to functions.

**$\rightarrow$ Exercise 3.4** - Removing code duplication in `fasta2tsv`.

Practice - Exercise 3.5
-----------------------

Ok, now we know everything we need to parse options, let's put this knowledge
into practice to improve the CLI of our `fasta2tsv.sh` script.

**$\rightarrow$ Exercise 3.5** - Final touches to `fasta2tsv.sh`


Further Ideas
-------------

The `fasta2tsv.sh` script is now functional and can be used in real life.
We'll stop here, but here are some ideas for further improvement:

* Instead of _assuming_ that the first line is a header, check that it is (and
  take action if it isn't).
* Deal with quotes.


Conclusion
----------

* We have seen how the shell operates, including tokenizing, parsing, the
  various forms of expansions, conditionals and arithmetic.
* We have used this knowledge (and more) to write a script that converts Fasta
  to CSV. It's not efficient, but it's easy to understand.
* You should now be able to start writing your own scripts.

May You Solve Interesting Problems
----------------------------------

> For some people, myself included, the satisfaction of solving a problem is
> the difference between work and drudgery. [...] Besides, once I accomplish
> my task, I congratulate myself on being clever. I feel like I have done a
> little bit of magic and spared myself some dull labor.

\hfill Dale Dougherty and Arnold Robbins, _sed & awk_ (2010)

Learning shell scripting - Resources
====================================

----------

* `man bash` - always handy, if a bit terse.
* `help` - for Bash builtins etc.

* The [Bash website](https://www.gnu.org/software/bash) and especially the
  [Bash Manual](http://www.gnu.org/software/bash/manual) (not the same as
  `man bash`!).
* The [Advanced Bash Scripting Guide](https://tldp.org/LDP/abs/html).
* The [Bash Cheat Sheet](https://devhints.io/bash).
* The [Bash Programming Reference](https://gitlab.isb-sib.ch/tjunier/bash-prog-cheat).
  is another cheatsheet, more specialized towards programming.

----------

* [Shellcheck](https://www.shellcheck.net/) - static analysis tool

* [Bash Cookbook](https://www.oreilly.com/library/view/bash-cookbook-2nd/9781491975329/)
* [Bash Idioms](https://www.oreilly.com/library/view/bash-idioms/9781492094746/)

Thank You for your Attention
============================

A small problem
---------------

We can now specify the separator: the script can separate with tabs (the
default) or anything else. But see what happens with CSV:

```bash
./fasta2tsv-stage-13.sh -t -s ',' \
  < ../data/Spo0A.msa | csvlook
```

Why might that be?

. . .

$\rightarrow$ The header contains commas.

Dealing with Separators
-----------------------

We can deal with the problem in the following ways^[The way the script deals
with the problem could itself be a parameter, _e.g._ warn by default, but be
more strict or lax according to some option.]:

::: incremental

* **Fail** - output a failure message, and return a nonzero exit code.
* **Warn** - succeed, but emit a warning message.
* **Attempt to fix** the header.
* **Ignore** it.

:::

. . .

Let's first try to at least warn the user of the problem.

`fasta2tsv.sh`: Stage 14 {#stage-14}
------------------------------------

The check for separators will have to be done in two places in the code, so it's
a good candidate for a function. The same goes for emitting a warning, if
needed.

(see `../src/fasta2tsv-stage-14.sh`).

Name References
---------------

Consider computing the _union_ vs. the _intersection_ of two arrays:

```bash
a1=(A B C)
a2=(D E F)
u=$("${a1[@}}" "${a2[@]}")
```

Appendix I: Protecting against Errors
=====================================

Unset variables
---------------

Unset variables can cause hard-to-find bugs, and they can even be dangerous:

```bash
prefix=tmp
rm $prefix*     # -> rm tmp* (+- ok)

rm $prefiy*     # oops! typo...
# Result: rm *  -> I just deleted all files in my directory!

set -u          # or shot -o -s nounset
rm $prefiy
# -> bash: prefiy: unbound variable
```

**NOTE** no quotes around `$prefix*` (why?)

Mutable Variables
-----------------

To prevent accidentally modifying variables, use `declare -r`.

Appendix II: Solutions involving CSV
=======================

Longest Sequence
----------------

```bash
awk -F '\t' '{print length($2), $1}' \
  < sample_00.csv | sort -k1,1n | tail -1
```

or, in pure Bash:

```bash
while IFS=$'\t' read header sequence; do
    echo ${#sequence} ${header%%;*}
done  < sample_00.csv | sort -k1,1n | tail -1
```

Discard Sequences with too many Gaps
------------------------------------

```bash
AA=ACDEFGHIKLMNPQRSTVWY  # amino acids

while IFS=$'\t' read hdr seq; do
  gaps=${seq//[$AA]/}
  ((${#gaps} < 50)) && echo "$hdr ${#gaps}"
done < Spo0A.tsv
```

Sort sequences by Genus
-----------------------

```bash
../src/fasta2tsv-stage-12.sh < sample_00.dna \
  | awk -F'\t' '{
  match($1, /g:.*,/);
  genus=substr($1, RSTART+2, RLENGTH-3);
  fprintf ">%s\n%s\n", $1, $2 >genus".fas"
}'
```

Supplementary Slides
====================

A small problem
---------------

If you look carefully at our `fasta2tsv.sh` script, we have a redundancy in
some of the code: two of the `printf` statements are (almost) identical:

```sh
read line
printf "%s%s" "${line:1}" "$FIELD_SEPARATOR"

while read line; do
    # Get the 1st char of the current line.
    ...
        printf '\n%s%s' "${line:1}" "$FIELD_SEPARATOR" 
    ...
done
```

A small problem (continued)
---------------------------

This is a problem, because if we want to make a change to one of these lines,
we will need to remember to do the same change on the other line as well. For
example:

* Renaming a variable (say `FIELD_SEPARATOR` to `FIELD_SEP`).
* Optionally keeping the leading `>`.
* Optionally outputting other formats than CSV/TSV.

The **DRY** principle: **Don't Repeat Yourself**.  
This leads us to *functions*.


More control structures with `case` and `break`
----------------------------------------------

Let's consider the scenario where we want to make the command line interface
(CLI) of a script a bit more powerful.

For instance, in our `fasta2tsv.sh` script we might want to have the following
optional arguments:

* `-s/--separator`, to allow specifying a custom field separator.
* `-o/--output`, to save the output of the script to a file, rather than
  printing it to stdout.
* `-h/--help`, to display help for the script.

How should we proceed?

Looping over Arguments
----------------------

The most obvious solution is to loop over the values passed by the user, and
for each value, test whether it is a recognized argument/option:

* If yes, process it and move on to the next value.
* If not, ignore the value or maybe raise an error (depending on how
  permissive you want the interface to be).

Let's see how we can do this in practice...

Looping over Arguments (continued)
----------------------------------

We know about `$1`, `$2`, etc., but what if the number of arguments isn't
known in advance (typically because some arguments are optional) ?

* **`"$@"`** expands to all arguments, one word each.

_Note:_ there are other ways to access all arguments, but `"$@"` is the most
useful one here. See `../src/showpp.sh`.

----------

Intuitively, we might do something like:

```bash
for arg in "$@"; do # or just: for arg; do
  # process $arg -> leaves $@ intact.
done
```

. . .

Another possibility is

```bash
while [[ $@ ]]; do
  # process $1
  shift # "consumes" $1 -> changes $@.
done
```

Processing Arguments
--------------------

To identify which argument corresponds to which option, we _could_ do
something like:

```bash
if [[ "$1" == '-h' ]] ; then ...
elif [[ "$1" == '-s' ]] ; then ...
elif [[ "$1" == '-t' ]] ; then ...
fi
```

But there is a better way...

`case` keyword
--------------

The **`case`**^[Very much like `switch` in C/C++/Java/Perl, or `case` in Ruby,
or `match` in Python.] statement is like a multi-way `if...elif...`:

```bash
case <word> in
  <pattern1> ) <list1> ;;
  <pattern2> ) <list2> ;;
  <pattern3> ) <list3> ;; # or more...
esac
```

`<word>` is _pattern-matched_ (like globbing) against each `<pattern>` in
turn, and the first match causes the corresponding `<list>` to be executed.
After a match is found, the `case` block exits (i.e. subsequent patterns are
not attempted to be matched against).

`case` - continued
------------------

Usually written on more than 1 line per clause:

```bash
case $arg in
    '-s' )
        # do something
        ;;
    '*' ) # default - matches anything
        ;;
esac
```

**Note**: Word splitting is disabled between `case` and `in`.

