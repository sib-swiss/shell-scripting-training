Bash shell scripting: exercises day 2
=====================================

**Exercise list:**

* [Exercise 2.1 - variable assignment and testing](#exercise-21-variable-assignment-and-testing)
* [Exercise 2.2 - Reusing standard input](#exercise-22-reusing-standard-input)
* [Exercise 2.3 - Getting user input from arguments](#exercise-23-getting-user-input-from-arguments)
* [Exercise 2.4 - a simple `for` loop](#exercise-24-a-simple-for-loop)
* [Exercise 2.5 - Introduction to functions](#exercise-25-introduction-to-functions)

:pushpin:
**Notes:**

* **Exercise material:** all exercise material is found in the `exercises/`
  directory of this Git repository. The exercise instructions assume that you
  are located in that directory, so we suggest entering it when doing the
  exercises: `cd exercises/`.
* Some of the exercises build on previous exercises, so it's best if they are
  done in order.
* At the end of some exercises, you will find an **Additional Tasks** section.
  These sections contain additional tasks for you to complete,
  **if you still have the time after having completed the main part of the**
  **exercise**. These sections will in principle not be corrected in class.
* **Exercise solutions:** all exercises have their solution embedded in this
  document. The solutions are hidden by default, but you can reveal them by
  clicking on the drop-down menu, like the one here-below.
  We encourage you to *not* look at the solution too quickly, and try to
  solve the exercise without it. Remember you can always ask the course
  teachers for help.

<details><summary><b>Exercise solution example</b></summary>

> This would reveal the answer...

</details>

<br>
<br>

Exercise 2.1 - variable assignment and testing
----------------------------------------------

Write a short script named `test_fasta.sh` that does the following
(in this order):

1. **Create a variable named `input_file`** and set its value to
   `data/sample_01.dna`.
2. **Test whether the file `data/sample_01.dna` exists** and is a regular
   file. You should test this using the `input_file` variable.
   If the file does not exist, the script should exit with exit code `1`.
3. **Read the first line of the file** and assign it to a variable named `line`.
   :dart:
   **Hint:** you can use the command `head -n1` to get the first line of a file.
4. **Using the `line` variable**, test whether the first line starts with the
   character **`>`** (indicating that it is a header line of a FASTA file).
   If so, print the message:
   > File 'input file name here' looks like a FASTA file
5. **Make your script executable and test run it.**
   Also make sure that it still works if you set `input_file` to
   `data/poorly named sample.dna` (i.e. an input file that contains a space).

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

```sh
#!/bin/bash

input_file="data/sample_01.dna"

# Test whether file exists, and if not, exit the script.
[[ -f "$input_file" ]] || exit 1

# Store the content of the first line of the file in the variable `line`.
line=$(head -n1 "$input_file")

# Test whether the first line starts with the character `>`.
[[ ${line:0:1} == ">" ]] && echo "File '${input_file}' looks like a FASTA file"

```

By setting `input_file="data/poorly named sample.dna"` we can check that our
script still works when the input file has a white space in its name. To make
the script resilient to white spaces in file names, we need to make sure that
the expansion `"$input_file"` is **surrounded by double quotes** on lines 6
and 9 of the script.

</p>
</details>
<br>

### Additional tasks (if you have time)

Improve the script so that it additionally prints an explicit error message
before exiting. The error message should look like this:

> Error: file 'input file name here' does not exist

<br>
<details><summary><b>Additional tasks solution</b></summary>
<p>

To add an explicit error message, we can change line 6 of the script to the
following:

```sh
[[ -f "$input_file" ]] || ( echo "Error: file '${input_file}' does not exist" && exit 1 )
```

</p>
</details>

<br>
<br>

Exercise 2.2 - Reusing standard input
-------------------------------------

In the `exercises/` directory, try to run the following command:

* :pushpin:
  *Note:* to halt a running script press `Ctrl + C` on your keyboard

```bash
./reuse_stdin.sh data/Spo0A.msa
```

* Why doesn't the following work?  
* How can we make it work?
* :dart:
  **Hint:** we will see this in more details in the next slides, but `$@` is a
  list of all input argument values passed to a script (or function).

For reference, here is the content of the `./reuse_stdin.sh` script:

```sh
#!/usr/bin/env bash

echo "The list of input arguments is: $@"
echo "And now we grep..."
grep Spo0
```

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

* The problem is that the script `reuse_stdin.sh` expects to get user input
  on **the standard input**, but when we call the script with
  `./reuse_stdin.sh data/Spo0A.msa`, we are passing the input (in the form
  of a file name) **as an argument** (and indeed, you should see the file name
  `data/Spo0A.msa` printed in the list of arguments).

* To fix the problem, we should pass the content of the input file
  `data/Spo0A.msa` as standard input with the **`<`** redirection character:

    ```sh
    ./reuse_stdin.sh < data/Spo0A.msa
    ```

* Alternatively, we could also modify the `reuse_stdin.sh` script so that
  it accepts a file name as argument... this is what we will cover in the
  next lecture slides just now!

</p>
</details>
<br>

<br>
<br>

Exercise 2.3 - Getting user input from arguments
------------------------------------------------

Write a short script named `hello_world.sh` that does the following:

* The script should **accept 2 input arguments**: `name` and `day` (in
  this order).
* The script should **print a sentence that contains the 2 values passed** by
  the user as the arguments `name` and `day`.
  For instance, if the user passes `John` as value for `name`, and `Wednesday`
  as value for `day`, the script could print something like:
  `Hello John, what a nice Wednesday`.
* If no or only 1 value is passed by the user, the script should
  **print an error message and exit** with an error code.
* Don't forget to **make the script executable** and run it with some test
  values to see if it works properly.

Here is how you would run this script:

```sh
./hello_world.sh John Wednesday
# -> Hello John, what a nice Wednesday
```

:dart:
**Hints:**

* To exit a script, use the command `exit 0` (success) or `exit 1` (error
  code 1).
* To test whether a variable exists (and is non-empty), you can use
  `[ -z $variable ]` or `[[ -z $variable ]]` - the former works in most
  shells, while the latter only works in `bash` shells (we will see this in
  more details later in the course). These expressions **evaluate to true** if
  the variable is unset or empty.
  
Here is an example of how we could test that `test_variable` is set and
non-empty:

```sh
unset test_variable
[ -z $test_variable ] && echo "Variable 'test_variable' is not set..."
```

<br>
<details><summary><b>Exercise solution</b></summary>
<p>

```sh
#!/usr/bin/env bash

name=$1  # The 1st value passed to the script is assigned to variable "name".
day=$2   # The 2nd value passed to the script is assigned to variable "day".

[ -z "$day" ] && echo "please enter a name and day" &&  exit 1

echo "Hello $name, what a nice $day."
exit 0
```

We can then run the script with a couple of test values:

```sh
chmod a+x ./hello_world.sh John Wednesday
chmod a+x ./hello_world.sh
chmod a+x ./hello_world.sh John
chmod a+x ./hello_world.sh Wednesday
```

</p>
</details>
<br>

**Additional tasks (if you have time):**  
Try to improve the script so that it can also detect when a single argument
(instead of 2) is passed, and **provide a more custom error message**
depending on whether a single argument or both arguments are missing.

<br>
<details><summary><b>Additional tasks solution</b></summary>
<p>

A simple solution is to detect whether both or only the 2nd value are missing
from the input. Note that this assumes that the argument values are always
passed in the correct order (first `name` and then `day`).

```sh
#!/bin/bash

name=$1
day=$2

[ -z "$name" ] && echo "please enter a name and day" &&  exit 1
[ -z "$day" ] && echo "please enter a day" &&  exit 1

echo "Hello $name, what a nice $day."
exit 0
```

We will see later in the course how you can make an interface that accepts
named arguments, such as say `--name John --day Wednesday`.

</p>
</details>
<br>

<br>
<br>

Exercise 2.4 - a simple `for` loop
----------------------------------

### Part 1 - list files

Write a script named `list_files.sh` that:

* Accepts a **single input argument** that is a directory name.
* **Using a `for` loop**, lists all files/directories located in the directory
  that was passed as input (essentially, this script will do what `ls` does...).

<br>
<details><summary><b>Exercise solution: part 1</b></summary>
<p>

Script `list_files.sh`:

```sh
#!/usr/bin/env bash

directory=$1

for file in "$directory"/*; do
    echo $file
done

```

</p>
</details>
<br>

### Part 2 - generate files

Write a script named `generate_empty_files.sh` that:

* **Generates a number of empty files** named `empty_file_<x>_test.txt`,
  where `<x>` is the number of the file (e.g. `empty_file_1_test.txt`,
  `empty_file_2_test.txt`, etc...).
* The script should **accept a single argument**: the number of files to
  generate.
* If no value is passed by the user, the script should
  **generate 5 files by default**.
* :dart:
  **Hints:**
  * To generate an empty file, you can use the `touch <file name>`
    command.
  * Remember the problem with expanding things like `for x in {1..$n}` that
    we saw in an exercise yesterday. In this exercise you will also need to
    get around this problem.

Example usage of `touch`:

```sh
touch a_new_file.txt  # Create a new (empty) file named "a_new_file.txt"
```

<br>
<details><summary><b>Exercise solution: part 2</b></summary>
<p>

Script `generate_empty_files.sh`:

```sh
#!/usr/bin/env bash

n=$1
[ -z $n ] && n=5

for ((i=1; i<=$n; i++)); do
    touch empty_file_${i}_test.txt
done
```

Alternatively, we can also use the `seq` command and **command substitution**
`$( seq 1 $n )` to run our `for` loop:

```sh
for i in $( seq 1 $n ); do
    touch empty_file_${i}_test.txt
done
```

</p>
</details>
<br>

### Additional Task: Part 3 - delete empty files

In the second part of this exercise, write a script that will automatically
delete all files named `empty_file_<x>_test.txt`, but
**only if they are empty**. Files that contain something should not be deleted,
to avoid accidental data loss.

:dart:
**Hint:**

* To test whether a file is empty or not, you can use
  **`[ -s <file> ]`** (or **`[[ -s <file> ]]`**, as long as you are in bash),
  which evaluates to **true** if the file is *not* empty.
* Example usage of `[ -s <file> ]`:

    ```sh
    [ -s data/sample_01.dna ] && echo "file is not empty"
    ```

**Important:** when performing a **destructive** task in a loop, it's always
best to run your script with prefixing the destructive command with `echo`
as a test run, to make sure it works as expected!

* To be extra safe, you can also use `rm -i` instead of `rm` so that you
  are asked for confirmation to delete a file each time.

<br>
<details><summary><b>Additional Task solution: part 3</b></summary>
<p>

Script `delete_empty_files.sh`:

```sh
#!/usr/bin/env bash

for file in empty_file_*_test.txt; do
    [ -s "$file" ] && continue
    rm -i "$file"
done
```

Alternatively, we could also delete files when they are empty, instead of
skipping non-empty ones as in the solution above. Note the usage of **`!`**
as **logical not** (inverses the value of a boolean).

```sh
#!/usr/bin/env bash

for file in empty_file_*_test.txt; do
    [ ! -s "$file" ] && rm "$file"
done
```

</p>
</details>
<br>

<br>
<br>

Exercise 2.5 - introduction to functions
----------------------------------------

Have a look at the script `exercises/compute_mean_values.sh`: it computes
the mean values for 3 different arrays of numbers (`weights`, `lengths` and
`ages`) and prints them to `stdout`.

In particular, you should note the usage of a function named `mean`, which
computes the mean value of a sequence of integer numbers. As you can see, this
function is called multiple times in the script, avoiding code duplication.

If you try to run the script, you should get the following output:

```sh
./compute_mean_values.sh
Age:    mean=95.00
Weight: mean=20.00
Length: mean=14.00
```

<br>

### Part 1 - add a `sum` function and refactor the script

In its initial form, the `compute_mean_values.sh` contains a single function
`mean` that takes care of both summing-up the data and computing the mean.

We now would like to refactor the script so that it has a dedicated function
that **computes the sum** of an array of (integer) values. Specifically, you
should do the following:

* **Write a `sum` function** that computes the sum of an array of integer
  values.
* **Modify the `mean` function** in the script so that it uses the new `sum`
  function to compute the sum of values (i.e. no code duplication).
* **Modify `compute_mean_values.sh`** so that it prints the sum of each array,
  in addition of its mean.
* :dart:
  **Hint:** the core of the `sum` function is already present in the current
  version of the script - it's part of the `mean` function. All you have to
  do is extract the part of the `mean` function that computes the sum and
  place it in a new `sum` function.

When implemented correctly, your script should output:

```sh
Age:    sum=475.00  mean=95.00
Weight: sum=100.00  mean=20.00
Length: sum=70.00   mean=14.00
```

<br>
<details><summary><b>Exercise solution: part 1</b></summary>
<p>

```bash
#!/usr/bin/env bash

# Arrays for which to compute the mean and sum.
ages=(75 100 105 80 115)
weights=(10 30 20 15 25)
lengths=(10 15 20 15 10)

# Function that computes the sum of an array of integer values.
function sum {
    local sum=0
    for n in $@; do
        (( sum += n ))
    done
    echo $sum
}

# Function that computes the mean of an array of values.
function mean {
    echo $(( $( sum $@ ) / $# ))
}

# Print sum and mean values.
printf "Age:\tsum=%.2f\tmean=%.2f\n" $(sum ${ages[@]}) $(mean ${ages[@]})
printf "Weight:\tsum=%.2f\tmean=%.2f\n" $(sum ${weights[@]}) $(mean ${weights[@]})
printf "Length:\tsum=%.2f\tmean=%.2f\n" $(sum ${lengths[@]}) $(mean ${lengths[@]})
```

</p>
</details>
<br>

### Additional Task (if you have time): Part 2 - add support for floating point values

Change the value of the `lengths` variable in the `compute_mean_values.sh` to
the following:

```sh
lengths=(11.5 17.1 18.2 15.57 14.8)
```

Then try running the script again. You should get an output with a number of
error printed:

```sh
Age:    sum=475.00  mean=95.00
Weight: sum=100.00  mean=20.00
./work.sh: line 12: ((: 12.5: syntax error: invalid arithmetic operator (error token is ".5")
./work.sh: line 12: ((: 15.1: syntax error: invalid arithmetic operator (error token is ".1")
./work.sh: line 12: ((: 18.2: syntax error: invalid arithmetic operator (error token is ".2")
./work.sh: line 12: ((: 14.8: syntax error: invalid arithmetic operator (error token is ".8")
Length: sum=15.00  mean=3.00
```

The problem is that, in its current incarnation, our script only supports
integer values: **it does not support floating point values**. Let's fix this!

Your task is to **modify the `compute_mean_values.sh` script** so that it can
compute the `sum` and `mean` of floating point values. After having added
support for floating point values, you should get the following output:

```sh
Age:    sum=475.00  mean=95.00
Weight: sum=100.00  mean=20.00
Length: sum=77.17   mean=15.43
```

:dart:
**Hints:**

* One of the easiest ways to do floating point arithmetic in the bash shell is
  to use the
  **[`bc` command](https://www.gnu.org/software/bc/manual/html_mono/bc.html)**.
* The way that `bc` works is by passing it a string with the expression to
  evaluate. Example: `echo "1.1 + 2.2" | bc`.
* To perform floating point divisions, use `bc -l`. E.g. `echo "3 / 2" | bc -l`

<br>
<details><summary><b>Exercise solution: part 2</b></summary>
<p>

```bash
#!/usr/bin/env bash

# Arrays for which to compute the mean and sum.
ages=(75 100 105 80 115)
weights=(10 30 20 15 25)
lengths=(11.5 17.1 18.2 15.57 14.8)

# Function that computes the sum of an array of integer or float values.
function sum {
    local sum=0
    for n in $@; do
        sum=$(echo "$sum + $n" | bc -l)
    done
    echo $sum
}

# Function that computes the mean of an array of integer or float values.
function mean {
    echo "$(sum $@) / $#" | bc -l
}

# Print sum and mean values.
printf "Age:\tsum=%.2f\tmean=%.2f\n" $(sum ${ages[@]}) $(mean ${ages[@]})
printf "Weight:\tsum=%.2f\tmean=%.2f\n" $(sum ${weights[@]}) $(mean ${weights[@]})
printf "Length:\tsum=%.2f\tmean=%.2f\n" $(sum ${lengths[@]}) $(mean ${lengths[@]})
```

**Bonus:** actually, since we are now using `bc` to compute the sum, we could
also rewrite the `sum` function in a more efficient (and elegant) way, avoiding
having a `for` loop altogether...

```bash
# Function that computes the sum of an array of integer or float values.
function sum {
    echo $@ | tr " " "+" | bc -l
}
```

</p>
</details>
<br>

### Additional Task (if you have time): Part 3 - add a `variance` function

Add a function that **computes the variance** of each array, and modify
`compute_mean_values.sh` so that is additionally prints the variance values.

* :dart:
  **Hint:** variance is computed as: `(x - mean(x))^2 / (n-1)`, where `n`
  is the total number of elements in the array.

When implemented correctly, your script should output:

```sh
Age:    sum=475.00  mean=95.00  var=287.50
Weight: sum=100.00  mean=20.00  var=62.50
Length: sum=77.17   mean=15.43  var=6.58
```

<br>
<details><summary><b>Exercise solution: part C</b></summary>
<p>

```bash
#!/usr/bin/env bash

# Arrays for which to compute the mean and sum.
ages=(75 100 105 80 115)
weights=(10 30 20 15 25)
lengths=(11.5 17.1 18.2 15.57 14.8)

# Function that computes the sum of an array of integer or float values.
function sum {
    echo $@ | tr " " "+" | bc -l
}

# Function that computes the mean of an array of integer or float values.
function mean {
    echo "$(sum $@) / $#" | bc -l
}

# Function that calculates the sample variance of an array of values.
function variance {
    local mean_value=$(mean $@)

    # Compute the sum of squared difference to the mean.
    local squared_diff_sum=0
    for n in "$@"; do
        squared_diff=$( echo "($n - $mean_value)^2" | bc -l )
        squared_diff_sum=$( echo "$squared_diff_sum + $squared_diff" | bc -l )
    done

    # Return the sample variance.
    echo "$squared_diff_sum / ( $# - 1 )" | bc -l
}

# Print sum, mean and variance values.
printf "Age:\tsum=%.2f\tmean=%.2f\tvar=%.2f\n" \
    $(sum ${ages[@]}) \
    $(mean ${ages[@]}) \
    $(variance ${ages[@]})
printf "Weight:\tsum=%.2f\tmean=%.2f\tvar=%.2f\n" \
    $(sum ${weights[@]}) \
    $(mean ${weights[@]}) \
    $(variance ${weights[@]})
printf "Length:\tsum=%.2f\tmean=%.2f\tvar=%.2f\n" \
    $(sum ${lengths[@]}) \
    $(mean ${lengths[@]}) \
    $(variance ${lengths[@]})
```

</p>
</details>
<br>

<br>
<br>
