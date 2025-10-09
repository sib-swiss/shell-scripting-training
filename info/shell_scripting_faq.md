# UNIX shell scripting: frequently asked questions

<br>

## General

### MacOS (`zsh`) error when running a script: "operation not permitted"

Original source:
https://www.alansiu.net/2021/08/19/troubleshooting-zsh-operation-not-permitted

### Windows: disabling EOL (end-of-line) automatic conversion by Git

Inside of the course's Git repo, type the following command:
`git config core.autocrlf false`

If needed, reset the current content of the repo to the original version:
`git reset --hard HEAD`

```sh
git config core.autocrlf false
git reset --hard HEAD
```

### MacOS (`zsh`) error - `date` command does not have the `-I` option

On Linux systems, the `date` command generally has the `-I` option to format
the output of the `date` command in
[ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format:

```sh
date -I   # -> 2022-05-25
```

On Mac OS, the `date` command does not have this option. Instead, one must
manually provide a format string:

```sh
date "+%Y-%m-%d"   # -> 2022-05-25
```

<br>

## `zsh` vs. `bash` - some differences

### No word splitting not globbing after variable expansion.

```bash
my_var=${foo}

my_var=$~{foo}    # perform globbing after variable expansion.
my_var=$={foo}    # perform word splitting after variable expansion.
my_var=$~={foo}   # perform both globbing and word splitting.
```

### Non-terminated quote with pattern: `!"`

https://unix.stackexchange.com/questions/497328/zsh-thinks-unterminated-quote-if-preceded-by-exclamation-mark

> If the shell encounters the character sequence `!"` in the input, the history
  mechanism is temporarily disabled until the current list is fully parsed.
  The `!"` is removed from the input, and any subsequent `!` characters have
  no special significance.

see also `man zshexpn(1)` for more details.
