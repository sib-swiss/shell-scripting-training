# UNIX shell scripting - summary

Summary for the bash concepts and commands seen during the course.

<br>

## Input parsing by the shell

The shell parses user input in the following steps:

1. Read user input instructions (from the terminal or a script).
2. Split input into **tokens**.
3. Parse tokens into **simple commands**, **pipelines**, **lists** and
   **compound commands**.
4. **Brace expansion** `{}`
5. **Other expansions** (from left to right):
    * **Tilde expansion**: `~`
    * **Parameter expansion**: `$variable`
    * **Command substitution**: `$(date)`
    * **Arithmetic expansion**: `$(( 2 + 3 ))`
    * **Process substitution**: `<(sort file.txt)`
6. **Word splitting**
7. **Filename expansion** (globbing): `* ? [a-f]`
8. Quote removal.
9. Redirection of standard input/output/error: `>`, `<`, `>>`, `<<`, `&>`, ...
10. Command execution.

<br>

### Tokenizing - splitting input into tokens

* Input is split on unquoted **metacharacters**: whitespace (`space`, `\t`,
  `\n`) and **operators** (`| & ; ( ) < >`).
* The elements resulting from this splitting are called **tokens**.
* Tokens fall into two categories: **words** and **operators**.

```sh
# Examples:
ls | wc -l > ${output_file}   # Split into 6 tokens.
                              # -> 4 words: ls, wc, -l, ${output_file}
                              # -> 2 operators: | and >
ls|wc -l>${output_file}       # Same split as above (but less readable).

# The following fails at the command execution stage, because `wc-l` is no
# longer split and the shell starts looking for a  command named `wc-l` that
# does not exist
ls|wc-l>${output_file}
```

<br>

### Quoting

When a character is **quoted**/**escaped**, it becomes a so-called **literal**,
and loses its "special" meaning (e.g. metacharacter, expansion or
quoting/escaping properties).

Three forms of quoting:

* `\`: escapes the subsequent character (next character becomes literal) .
* `""`: all quoted characters become literals, except ``$ ` \``. For `\`, only
  before ``" $ ` \``
* `''`: all quoted characters become literals.

In summary:

* **Double quotes:** use when parameter/variable expansion is needed, but you
  want to avoid word splitting.
* **Single quotes:** use when you don’t want parameter expansion (`$variable`).

```sh
# Examples:
# Quoting/escaping white space to avoid it being treated as metacharacter.
cat "unfortunate name.txt"     
name=Bond,\ James\ Bond      # --> name variable set to "Bond, James Bond" 

echo "my name is '$name'"     # --> my name is 'Bond'
echo "my name is \"$name\""   # --> my name is "Bond"
echo 'my name is \"$name\"'   # --> my name is \"$name\"
```

<br>

### Commands, pipelines and lists

* **Simple command**: smallest unit of code execution. Generally a call to a
  program and its input arguments.
* **Pipeline**: commands separated by `|`, such as `cat | wc -l`.
  * The std output of one command is passed as std input of the next.
* **Lists**: commands or pipelines separated by `&&`, `||` or `&`.
  * `&&`: executes the subsequent command/pipeline only
    **if the previous succeeds**.
  * `||`: executes the subsequent command/pipeline only
    **if the previous fails**.
  * `&`: execute the command/pipeline in the background.
* **Compound command**: grouping of commands.
  * `{ cmd-1; cmd-2 && cmd-3; }`: group commands in current shell.
  * `( cmd-1; cmd-2 && cmd-3 )`: group commands and run in sub-shell.
  * `if ... then`, `case`, `for`, `while`, ...

```sh
# Simple commands grouped in a pipeline.
grep -o 's:.*;' data/sample_01.fasta | sort | uniq -c | sort -rn | head -1

# List of commands:
[[ -f $file ]] && cat "$file" || echo "Error: file '$file' does not exist!"

# Compound command:
for x in {1..10}; do echo $x; done
[[ -f $file ]] || { echo "file is missing"; exit 1; }
```

All commands (simple, pipeline, lists, compound) have an **exit code**
(also known as **exit status**):

* `0` indicates **success**.
* `1` or any other number indicates **failure**.
* The return value of the last executed command can be accessed via the
  `$?` variable.

<br>

### Brace expansions

* Brace expansion `{}` is the first expansion to occur.
* Differs from globbing (filename expansion): the generated strings are _not_
  matched against existing filenames.

```sh
echo project/{src,data,doc}   # --> project/src project/data project/doc
echo file{,.pdf,.txt}         # --> file file.pdf file.txt
echo sample_{1..5}.csv        # --> sample_1.csv sample_2.csv sample_3.csv ...
echo {a..f}                   # --> a b c d e f 
echo {A..F}                   # --> A B C D E F
```

* If multiple `{}` are present in a token, they expand to all possible
  combinations (cartesian product):

```sh
echo project_{panther,guinea-pig}/{src,data,doc}
# project_panther/src
# project_panther/data
# project_panther/doc
# project_guinea-pig/src
# project_guinea-pig/data
# project_guinea-pig/doc
```

* `{}` can be nested:

```sh
echo project/{src,data_{private,public}}
# project/src
# project/data_private
# project/data_public
```

<br>

### Other expansions

* **Tilde expansion**: `~` characters are expanded to the user's home directory.
* **Parameter expansion:** `$variable` are expanded to the variable (parameter) value.
* **Command substitution:** Commands in `$(cmd)` are executed, and the `$(cmd)`
  is replaced by the command's standard output.
* **Arithmetic expressions:** expressions in `$(( ))` are evaluated.
  * Only integer values are supported.
  * Variable/parameter expansion occurs even without `$`.
* **Process substitution:** commands in `<(cmd)` are executed, and their
  standard output is treated as a "virtual file".

```sh
# Tilde expansion:
ls ~/Desktop  # --> /home/alice/Desktop

# Parameter expansion:
name=Bond
echo my name is $name  # --> my name is Bond

# Command substitution:
echo "Today is $(date)"                  # --> Today is Wed Nov 12 07:39:36 AM CET 2025
echo "Today is ... $(date > /dev/null)"  # --> Today is ...

# Arithmetic expansion:
x=2; y=3
echo $(( x + y ))

# Process substitution:
diff -u <(echo -e "Alice \n Bob \n James") <(echo -e "Alice \n Bob \n John")
# Compare the 1st column of two tabulated text files.
diff -s <(cut -f1 data/gene_expression_s1.tsv) <(cut -f1 data/gene_expression_s2.tsv)
```

<br>

### Word splitting

Splitting of the results of **non-quoted expansions** into separate words.
In practice this only applies to **non-double-quoted expressions**, since there
is no expansion in single quotes anyway.

* Split is based on the `$IFS` (Internal Field Separator), which
  defaults to `<space><tab><newline>`
* To reset the IFS to its default value: `unset IFS`
* If `$IFS` is empty (`IFS=""`), word splitting is disabled.

```sh
# Example:
file="READ ME.md"
cat $file          # Splitting occurs: `cat` receives 2 arguments.
cat "$file"        # No splitting because of the quotes: `cat` receives 1 argument.

# Setting the IFS to an empty value to avoid word splitting.
IFS="" && cat $file && unset IFS
```

<br>

### Filename expansion (globbing)

Expansion of **wildcard characters `* ? []`** if there exists a matching
file/directory.

* `*` match zero or more characters.
* `?` match exactly 1 character.
* `[xyz]` match a character in the specified list (here `x`, `y` or `z`).
* `[a-f]` match a character in the specified range.
* `[^abc]` or `[!abc]` reverse a match: any character _except_ those specified.

```sh
# Examples:
ls *.pdf              # Matches any file ending in .pdf
ls sample_?.fasta     # Matches "sample_1.fasta" or "sample_z.fasta".
ls sample_[dkx]       # Matches "sample_d", "sample_k" and "sample_x"
ls [^iI]*             # Matches any file, except those starting with lower or upper case "i".
ls sample_[1-5a-f]    # Matches "sample_1", "sample_2" or "sample_a", but not "sample_1a".
ls sample_[1-5][a-f]  # Matches "sample_1a" or "sample_5c", but not "sample_5" or "sample_6a".
```

<br>
<br>
<br>

## Variables (parameters)

### Variable assignment

Variables are created (assigned) with a `=`:

* No spaces around the `=` operator: `name=value`
* Variable names can contain letter, digits and `_`. Cannot start with digit.
* During assignment, expansion occurs, but no word splitting.
* An **unset** variable is _not_ the same as **null** (empty string) variable.
* Variables can be deleted with `unset variable`.
* ✨ **Tip:** in scripts, it is good practice to use `set -u` at the top of
  the script to raise an error when an unset variable is used.
  To turn off the setting: `set +u`.

```sh
# Examples:
answer=42
human="Homo sapiens"  # Quotes needed to escape the whitespace.
species=$human        # No word splitting -> quotes are not required.
extension="*.pdf"     # Quotes needed to avoid globbing (filename expansion) to occur.
date=$(date);         # Assign the expansion of a command.

unset answer          # Delete the variable.
set -u
echo $answer          # --> bash: answer: unbound variable
```

<br>

### Variable expansion

There are 2 basic syntaxes for variable expansion:

* **Short form: `$variable`** - works when the variable name can be inferred
  unambiguously.
* **Long form: `${variable}`** - necessary when the variable is shorter than
  expected by the shell. E.g. in `$place_1`, the shell will be looking for a
  variable named `place_1` and not `place`, unless we make it explicit with
  `${place}_1`.

```sh
# Examples:
place=Reykjavik
echo $place          # Short form
echo ${place}        # Long form
echo ${place}_1.jpg  # Here, only the long form will work needed.
```

<br>

### Variable operations

Note that in all expansions, globbing can be used:
`*`, `?`, `[abc]`, `[^abc]`, `[!abc]`.

#### String sub-setting

```sh
genus=Harpagofututor
${#genus}       # length -> 14
${genus:7}      # substring from 7. Indexing is 0-based.
${genus:0:7}    # substring of length 7 from 0
${genus: -5:4}  # substring from the end. SPACE is required before "-".

a=7; b=14
${genus:a:b}    # Arithmetic evaluation of variable values.
```

#### Character substitution

```sh
var=moose
${var/m/g}    # Substitute 1st match    -->  goose
${var/oo/u}   # Substitute 1st match    -->  muse
${var//o/u}   # Substitute all matches  -->  muuse

var=starfish
${var/%fish/struck}  # Only match values located at end of string   -->  starstruck
${var/#star/moon}    # Only match values located at start of string -->  moonfish
```

#### String trimming (deletions) and increment

```sh
${var%match}   # Trim shortest occurrence of `match`, starting from the end.
               # The match must extend to the end of the variable to be matched.
${var%%match}  # Same as above, but trims the longest occurrence (greedy matching).
${var#match}   # As above, but trims from the beginning.
${var##match}

var="The quick brown fox!"
${var%o*}    # Shortest match from end is removed   --> The quick brown f
${var%%o*}   # Longest match from end is removed    --> The quick br 
${var#*o}    # Shortest match from start is removed --> wn fox!
${var##*o}   # Longest match from start is removed  --> x!

var+=" jumps over the lazy dog"   # Increment variable.
```

<br>

### Arithmetic operations

The shell can perform arithmetic computations on **integer** values with the
syntax `$(( ))`.

* Only works for **integer** numbers.
* Variable expansion occurs even without prefix variable names with `$`. This
  is because the any non-digit value is assumed to be a variable.

```sh
a=5
echo $(( a + 3 ))  # -> 8
```

To perform operations on **floats** (fractional numbers), an external command
must be used, such as `bc`:

```sh
echo "scale=3; 71 / 1.69^2" | bc
```

<br>
<br>
<br>

## Condition testing

Bash has the following test operators:

* **`[[ ]]`**: bash conditional expression (bash-specific keyword).
* **`[ ]`**  : legacy test operator (POSIX compatible).
* **`(( ))`**: arithmetic test operators (bash-specific keyword).

**`[[ ]]`** supports:

* Tests on file/directory properties:
  * `-e`: file/dir exists.
  * `-f`: is a regular file.
  * `-d`: is directory.
  * `-r/-w/-x`: is readable/writable/executable.
  * `-s`: file has size > 0.
* Pattern matching with `==` (globs) or `=~` (regex).
* Logical operators: `&&` / `||`.
* Arithmetic comparisons with `-gt`, `-ge`, `-lt`, `-le`.
* ⚠️ No world-splitting or filename expansion (globbing) occurs inside `[[ ]]`.

```sh
# Examples:
[[ -e ... ]]       # Test whether a "file" in the broad sense exists (e.g. a directory is also a file).
[[ -f ... ]]       # Test if a file exists, and is a "regular" file (not a directory or a symlink).
[[ -d ... ]]       # Test is a directory exists.

[[ foo == f* ]]    # --> true   (glob match)
[[ foo == f?? ]]   # --> true   (glob match)
[[ foo =~ ^f.* ]]  # --> true   (regexp match)
[[ foo =~ fo?$ ]]  # --> false  (regexp match)

[[ a < b ]]        # --> true (lexical comparison).
(( 10 > 2 ))       # --> true
[[ 10 -gt 2 ]]     # gt = greater than.
[[ 10 -ge 10 ]]    # ge = greater or equal.
```

### Pitfalls ⚠️

* Filename expansion (globbing) does _not_ occur in `[[ ]]`. As a workaround,
  we can use the `ls` command:

  ```sh
  ls uni?.code-workspace &> /dev/null && echo true
  # or
  [[ $( ls uni?.code-workspace | wc -l ) -gt 0 ]] && echo true
  (( $( ls uni?.code-workspace | wc -l ) > 0 )) && echo true
  ```

* `[[ 10 > 2 ]]` is a valid test, but it does a lexical comparison, and not
  an arithmetic tests.

  ```sh
  (( 10 > 2 )) && echo true || echo false     # --> true
  [[ 10 > 2 ]] && echo true || echo false     # --> false !!
  [[ 10 -gt 2 ]] && echo true || echo false   # --> true
  ```

<br>
<br>

### Input/Output redirection

Each time a command is run, 3 **file descriptors** are created by default:

* `0` - **stdin**, standard input.
* `1` - **stdout**, standard output.
* `2` - **stderr**, standard error.

By default **stdout** and **stderr** are **"attached" to the screen**: their
content is displayed on screen instead of being written to a file. The standard
input is attached to the keyboard.

Redirection operators allows to use a different input/output and
source/destination:

* `>` or `1>`        : redirect stdout.
* `2>`               : redirect stderr.
* `&>`               : redirect both stdout and stderr.
* `>>`, `1>>`, `2>>` : append to output file rather than overwriting it.
* `<`                : stdin redirection. Content of a file is redirected to
                       standard input.
* `2>&1`             : redirect stderr into stdout (wherever it goes).
* `1>&2`, `>&2`      : redirect stdout to stderr (wherever it goes). Useful
                       to display errors and warnings to the user in scripts.
* `|`  : pipe stdout to another command (for which it then acts as stdin).
* `|&` : pipe both stdout and stderr to another command. A shortcut for
         `2>&1 |`, but does not work in all bash versions.
* `exec < $input_file`: set the standard input **file descriptor** to the
  value assigned to it (in this case, an input file). This is generally used
  in scripts.
