# Same arrays as before...

weights=(10 30 20 15 25)
lengths=(12 15 18 15 14 16 15)
ages=(75 100 125 80 120 100)

# Let's compute means, but this time using a _function_:

function mean {
    local sum=0
    for n; do
        ((sum += n))
    done
    mean=$((sum / $#))
    echo $mean
}

# Now, instead of writing three loops (and making typos), I just _call_ the
# function, the same way I'd call a command:

# $(...) does command substitution on functions as well
mean_weight=$(mean "${weights[@]}")
mean_length=$(mean "${lengths[@]}")
mean_age=$(mean "${ages[@]}")

# Since now the code works, we might as well look at the results:

printf "mean weight:\t%f\n" $mean_weight
printf "mean length:\t%f\n" $mean_length
printf "mean age:\t%f\n"    $mean_age

# The code is smaller (and hence has fewer opportunities for bugs).

# Now suppose we want to make the code work also if averages don't happen to be
# integers (by an incredible coincidence, they do up to now!). Well, we'd just
# have to change one line in the function. In fact, that's precisely the next
# exercise, in a few slides.
#
# Bottom line: without functions, we'd have to make the same change _everywhere_
# we compute averages.
