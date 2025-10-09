---
title: Bash kōans
classoption:
 - onecolumn
---

```bash
$ exp="1 -gt 2"; [ $exp ] && echo true || echo false 
false
$ exp="1 -gt 2"; [[ $exp ]] && echo true || echo false
true
```

**Reason**: word splitting (as well as pathname expansion) is disabled between
`[[]]`. The expression succeeds as long as `exp` is not null (and is the same as
`[[ -n $exp ]]`.

----

```bash
exp="1 -gt 2"; [ $exp ] && echo true || echo false   # false
exp="1 -gt 2"; [ "$exp" ] && echo true || echo false # true!
```

**Reason**: double quotes prevent word splitting, resulting in `[]` being passed a
single argument - in which case it determines truth value based on whether or
not its argument is null (which it is not).

----

```bash
$ a=(a b "c d"); for e in ${a[@]}; do echo $e; done
a
b
c
d
$ a=(a b "c d"); for e in "${a[@]}"; do echo $e; done
a
b
c d
```

**Reason**: double quotes around `${a[@]}` disable word splitting of array
elements, while still returning separate elements.

----

```bash
$ mkdir d # just to have an empty dir
$ cd d
$ a=(a b 'c d' *.bar)
$ echo ${a[3]}
*.bar
$ touch zorg.bar
$ echo ${a[3]}
zorg.bar
$ echo "${a[3]}"
*.bar
$ b=(a b 'c d' *.bar)
echo "${b[3]}"
zorg.bar
echo ${b[3]}
zorg.bar
$ rm zorg.bar
echo "${b[3]}"
zorg.bar
echo ${b[3]}
zorg.bar
```

----

How many arguments?

```bash
$ count_args() { echo $# args; }
$ count_args a b
$ a=''
$ count_args $a b
$ count_args "$a" b
```

**Reason**: `$a` disappears, but `"$a"` evaluates to an empty string (during
null argument removal).

----

Why does the second loop fail with `A: unbound variable` while the first loop
succeeds?

```bash
set -u

while read foo; do
    echo "$((foo + 1))"
done <<< "0"

while read foo; do
    echo "$((foo + 1))"
done <<< "A"
```

Setting `-u` causes a check for unbound variables. Expressions within `((...))`
are evaluated using _shell arithmetic_, but `A` is not numeric (while `0`
certainly is), therefore `A` cannot be bound to `foo` (although I'd expect the
shell to complain about _`foo`_ being unbound, not `A`).

----

```
$ show_args(){ for arg in "$@"; do printf ">%s<\n" "$arg"; done; }
$ show_args abc\ def
>abc def<
$ STR='abc\ def'
$ show_args $STR
>abc\<
>def<
```

**Reason**: in the first example, the `\` is encountered during parsing, and thus
escapes the space aftr it. n the second case, when `$STR` is expanded to `abc\
def`, parsine has _already occurred_, and the `\` is now literal.

----

The following question was asked by a student:

Why doesn't this work?

```
$ mkdir new | cd new
cd: no such file or directory: new
```

What the student wanted was probably `mkdir new; cd new` or (better) `mkdir new
&& cd new`, which was my reply - but this doesn't answer the question: why does
it fail?  (hint: it's _not_ because `mkdir` emits no output or because `cd`
expects no input)

**Reason**: Contrary to what we may think, commands linked by a pipeline are not
run after one another, but simultaneously - to see this, find a long text
document and try `$ time cat <long-doc> | head` and `$ time cat <long-doc> |
tail`: the first will be significantly faster, because `head` exits as soon as
it has read ten lines, at which point `cat` is still busy reading and outputting
the rest of the file, while `tail` has to read _all_ lines to detect that it has
found the last ten.

So, `mkdir new | cd new` fails because when `cd` starts, `mkdir` has not yet
finished creating the directory. If we delay `cd` a little, it works:

```bash
$ mkdir new | { sleep 1; cd new; }
```

----

```bash
$ a=1; b=2
$ a=foo b=bar eval 'echo $a $b'
foo bar
$ a=foo b=bar eval "echo $a $b"
1 2
```

```bash
$ a=1; echo $a {b,c,d}
1 b c d
$ a=1; echo $a{b,c,d}
```

**Reason**: Brace expansion occurs before parameter expansion (indeed, brace
expansion is the first of all expansions). Therefore, `$a{b,c,d}` first
brace-expands to `$ab $ac $ad`, which are undefined. To see this, try:

```bash
$ set -u; a=1; echo $a{b,c,d}
bash: ab: unbound variable
```

----

```bash
$ i=0; true && ((i++)) || ((i--)); echo $i
0
$ i=0; true && ((++i)) || ((i--)); echo $i
1
```

**Reason** `((i++))` evaluates to 0, that is, _false_ (for an arithmetic
expression). This causes the command after the `||` to be evaluated, setting
`i` back to 0. On the other hand, `((++i))` evaluates to 1 (true), and `||`
shortcuts to true, leaving `((i--))` unevaluated.

In other words, `cmd1 && cmd2 || cmd3` **is not the same** as `if cmd1; then
cmd2; else cmd3; fi`: in the former case the exit values of _both_ cmd1 and
cmd2 may decide whether cmd3 is evaluated; in the latter, only the exit value
of cmd1 does. This is usually what we want.  See [Bash
Pitfalls](http://mywiki.wooledge.org/BashPitfalls).

----

This works

```bash
$ find . -name '*.c' | while read cfile; do ...; end
```

But if I need to iterate >1 time over the file names, and try storing the array:

```bash
$ find . -name '*.c' | readarray cfiles
$ for cfile in "${cfiles[@]}"; do ...; end # 1st iteration
$ for cfile in "${cfiles[@]}"; do ...; end # 2nd iteration
```

it fails because the `cfiles` array is empty.

**Reason**

Commands in pipelines are run within their own subshell. So the `cfiles` array
is only defined within the subshell that runs readarray, not to the shell that
calls the whole pipeline. To fix, use

```bash
$ readarray cfiles < <(find . -name '*.c')
```

Or do `shopt -s lastpipe`, which makes the _last_ command in a pipeline run in the
same process as the current process.

**NOTE** also that the above would fail with newline-containing filenames. I
wanted to keep it simple, but it should be `find ... -print0` and `readarray -d ''`.

A similar problem occurs when trying to populate an array with the output of a
command that is piped to `read`, like this:

```bash
declare -A hash
some_cmd | while read key value; do
  hash[$key]=$value
done
echo ${#hash[@]}  # 0!
```

After the loop, `hash` is empty!


----

```bash
$ cmd='ls -l'
$ $cmd    # ok
$ "$cmd"  # fails
```

**Reason**: the double quotes around `$cmd` prevent word splitting, so the first
word on the line isn't `ls` but `ls -l`, which isn't a command^[Well, usually
not... although it's technically possible to have a command called `ls -l`,
since spaces are allowed in filenames. But that would be _evil_! ].

Note also that other shells may work differently: Zsh, for example, doesn't
word-split by default, so `$cmd` (unquoted) would also fail.

TODO: 

* append to array like this: ary+=elem instead of ary+=(elem) -> fails
* `var=val; cat <<< $var` works as expected, but `cat <<< {1..5}` doesn't
* In the following, "$str" prevents word splitting but we still read 3 values -
  that's because `read` does word-splitting too (and IFS was just set to ',')
    `str="a value,another value,a third value"`
    `IFS=',' read var1 var2 var3 <<< "$str"`
