I am comparing several ways of counting nucleotides in a sequence (see
`ntcount*`). All these implementations have in common that they do not use a
temporary file. 

The following discusses an implementation in which all the work is done by shell
commands(`tr`, `wc`, etc.).

The following solution removes anything but adenines and counts the resulting characters:

```bash
# version 1
$ tr -dc A < genome | wc -c
```

Ok, but only counts the As. If we want the other nucleotides, one solution is to
repeat the process:

```bash
# version 2
$ tr -dc A < genome | wc -c ; tr -dc C < genome | wc -c ; \
  tr -dc G < genome | wc -c ; tr -dc T < genome | wc -c
```

This works, but it's hard to know which count is for which nucleotide. Let's fix
that:

```bash
# version 3
$ echo -n "A: " ; tr -dc A < genome | wc -c ; \
  echo -n "C: " ; tr -dc C < genome | wc -c ; \
  echo -n "G: " ; tr -dc G < genome | wc -c ; \
  echo -n "T: " ; tr -dc T < genome | wc -c
```

This works, but reading the same file from disk four times may not be most
efficient. Let's try reading it only _once_. This means we will have to pipe it
to the counting commands, which will also have an output. The only way I know of
doing this is by using `tee` together with process substitution. Consider a
simpler case first, in which we only count As and Cs, and forget about labeling
counts for a moment:

```bash
$ tee < genome >(tr -dc A | wc -c) | tee >(tr -dc C | wc -c)
```

This works, except that we still see the whole file in the output, which we're not
interested in. It won't do to redirect the whole thing to `/dev/null`, because
we'd lose (most of) the counts too:

```bash
# WRONG!
$ tee < genome >(tr -dc A | wc -c) | tee >(tr -dc C | wc -c) | /dev/null
```

Maybe we can just pipe the output of the first `tee` directly to a counting
command?


```bash
# WRONG!
$ tee < genome >(tr -dc A | wc -c) | tr -dc C | wc -c
```

This fails, because the output of `wc` is piped to the second `tr`, which causes
the count to disappear. However, this (almost) works:

```bash
# Ok-ish
$ tee < genome >(tr -dc A | wc -c) > >(tr -dc C | wc -c)
```

Instead of _piping_ the output of `tee` to the second `tr`, I _redirect_ it to a
file... except that instead of a regular file I use another process
substitution. For some reason, in this case the output of the first `wc` is
_not_ redirected to the "file" - only the output of `tee` is.

I said "almost" works, because (again for reasons beyond my ken) this command
hangs until the user hits RETURN a second time. A solution is to put a `cat` at
the end:

```bash
$ tee < genome >(tr -dc A | wc -c) > >(tr -dc C | wc -c) | cat
```

Honestly, I don't know why. It seems to have something to do with `wc -l`, at
least, because this

```bash
$ tee < genome >(cat) > >(cat)
```

doesn't hang (apart from not doing what I want, of course), while this

```bash
$ tee < genome >(cat) > >(wc -l)
```

doesn't; however this

```bash
$ tee < genome >(wc -l) > >(cat)
```

hangs again. Even stranger, a simple `wc` (without `-l`) will cause a hang even
when `wc -l` works in the example above. Also, this seems to be Bash-specific -
at least it doesn't happen in Zsh.

A way around this is to have the genome on `tee`'s
file argument, and the counts on its output (redirected to stderr, to avoid
mixups):

```bash
$ { tee < genome /dev/fd/3 | tr -dc A | wc -c >&2; } 3>&1 | { tee /dev/fd/3 | tr -dc C | wc -c >&2; } 3>&1 | { tee /dev/fd/3 | tr -dc G | wc -c >&2; } 3>&1 | tr -dc T | wc -c
```
