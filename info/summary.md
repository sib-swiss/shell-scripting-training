# UNIX shell scripting - summary

<br>

## Input parsing by the shell

The shell parses user input in the following steps:

1. Reads user input instructions (from the terminal or a script).
2. Splits the input into **tokens**.
3. Parses tokens into **commands**, **pipelines** and **lists**.
4. **Brace expansion** `{}`
5. **Other expansions** (from left to right):
    * Tilde expansion: `~`
    * Parameter expansion: `$variable`
    * Command substitution: `$(date)`
    * Arithmetic expansion: `$(( 2 + 3 ))`
    * Process substitution: `<(sort file.txt)`
6. **Word splitting**
7. **Filename expansion** (globbing): `* ? [a-f]`
8. Removes quotes.
9. Redirections of standard input/output/error: `>`, `<`, `>>`, `<<`, `&>`, ...
10. Executes the commands.

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

```sh
# Simple commands grouped in a pipeline.
grep -o 's:.*;' data/sample_01.fasta | sort | uniq -c | sort -rn | head -1

# List of commands:
[[ -f $file ]] && cat "$file" || echo "Error: file '$file' does not exist!"
```

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
```

<br>

### Filename expansion (globbing)

Expansion of **wildcard characters `* ? []`** if there exists a matching
file/directory.

* `*` match zero or more characters.
* `?` match exactly 1 character.
* `[]` match any character in the specified list or range of values.
* `[^]` match any character _except_ those specified.

```sh
# Examples:
ls *.pdf             # Matches any file ending in .pdf
ls sample_?.fasta    # Matches "sample_1.fasta" or "sample_z.fasta".
ls sample_[dkx]      # Matches "sample_d", "sample_k" and "sample_x"
ls [^iI]*            # Matches any file, except those starting with lower or upper case "i".
ls sample_[1-5a-f]   # Matches "sample_1", "sample_2" or "sample_a", but not "sample_1a".
ls sample_[1-5][a-f] # Matches "sample_1a" or "sample_5c", but not "sample_5" or "sample_6a".
```

<br>

--------------------------------------------------------------------------------

<br>
<br>

## Work in progress ...

<br>

## Input/output redirection

“>” is to re-direct the output of a command to a file (or more generally to
another “file descriptor”)
“<” will re-direct the content of a file to the standard input of the shell.
