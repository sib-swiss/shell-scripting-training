# UNIX shell scripting: frequently asked questions

<br>

## General

### List environment variables in the current shell session

To list all environment variables (parameters) currently defined in a shell
session, run the command **`env`**.

Note that `env` only lists **exported variables**, i.e. variables that are
available to subprocesses. To list all (exported and non-exported) variables,
use **`set`** bash keyword.

<br>

### Stop a task running in the background

Once a process is in the background, it can be brought back to the foreground
with the command **`fg`**. Once in the foreground, the process can be aborted
with "Ctrl + C".

**Example:**

```sh
sleep 30 &   # Start a process and send it to the background.
jobs         # displays all jobs currently running the background.
fg           # Bring the process to the foreground.

# At this point the process can be aborted with "Ctrl + C".
```

> ✨ **Notes:**
>
> * If multiple processes are running in the background, **`fg %i`** can bring
>   back the desired process. E.g. `fg %3` will bring back the 3rd process to
>   the foreground.
> * Use `jobs` to show a list of backgrounded commands.

<br>

Alternatively, a process (backgrounded or not) can also be force-terminated
with the `kill <PID>` command, where `<PID>` is the process ID.

**Example:**

```sh
kill 50548   # The number is the PID of the process.
```

<br>

### Testing for file existence: why use `[[ -f $name ]]` rather than `ls $name`

Using `ls` prints the file name (if it exists) or an error message (if it does
not), which in a scripting context is not something we want. It’s possible to
re-direct the output of `ls $file > /dev/null` to avoid this, but it is less
convenient.

<br>

### About sub-shells

A sub-shell is a child shell process spawned by the current shell. It runs in
a separate execution environment, allowing isolated command execution.

**Example:** change directory only inside the sub-shell. The current shell
will remain in the same directory.

```sh
(cd /tmp && ls)  
```

* Sub-shells are crated by adding brackets `()` around an expression.
* Sub-shells inherit environment variables that are exported in their parent
  shell. Changes made in the sub-shell environment do not affect the parent
  shell.
* Command substitution `$(command)` are run in a sub-shell.

<br>

### Re-running the previous command

* Executing `!!` in the shell will re-run the command ran just before.
* With `!!:gs/old/new` we can re-run the last command, while replacing all
  instances of `old` with `new`.

**Example:**

```sh
echo "This is a test-1"
!!                       # will print -> This is a test-1
!!:gs/1/2                # will print -> This is a test-2
```

<br>
<br>

## `zsh` vs. `bash` - some differences

### No word splitting no globbing after variable expansion

```bash
my_var=${foo}

my_var=$~{foo}    # perform globbing after variable expansion.
my_var=$={foo}    # perform word splitting after variable expansion.
my_var=$~={foo}   # perform both globbing and word splitting.
```

<br>

### Non-terminated quote with pattern: `!"`

From <https://unix.stackexchange.com/questions/497328/zsh-thinks-unterminated-quote-if-preceded-by-exclamation-mark>

> If the shell encounters the character sequence `!"` in the input, the history
  mechanism is temporarily disabled until the current list is fully parsed.
  The `!"` is removed from the input, and any subsequent `!` characters have
  no special significance.

see also `man zshexpn(1)` for more details.

<br>
<br>

## MacOS troubleshooting

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
<br>

## Windows troubleshooting

### Windows: disabling EOL (end-of-line) automatic conversion by Git

Inside of the course's Git repo, type the following command:
`git config core.autocrlf false`

If needed, reset the current content of the repo to the original version:
`git reset --hard HEAD`

```sh
git config core.autocrlf false
git reset --hard HEAD
```

<br>
<br>
