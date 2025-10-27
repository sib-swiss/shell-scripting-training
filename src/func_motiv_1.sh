# I have a series of measures stored in arrays.

weights=(10 30 20 15 25)
lengths=(12 15 18 15 14 16 15)
ages=(75 100 125 80 120 100)

# Let's compute means

mean_weight=0
for w in "${weight[@]}"; do
    ((mean_weight+=w))
    ((mean_weight/=${#mean_weight[@]}))
done

mean_length=0
for w in "${length[@]}"; do
    ((mean_length+=w))
    ((mean_length/=${#mean_length[@]}))
done

mean_age=0
for w in "${age[@]}"; do
    ((mean_age+=w))
    ((mean_weight/=${#mean_weight[@]}))
done

# This won't be impressive...
printf "mean weight:\t%f\n" $mean_weight
printf "mean length:\t%f\n" $mean_length
printf "mean age:\t%f\n"    $mean_age

# There are several problems here:

# * The code is WRONG! I copied the first loop twice, but forgot to change
#   `weight` to `age` in the last loop. Plus, the original loop has several
#   bugs, which were copied to the other two: (i) it should be weights[@], not
#   weight[@] (classic typo); and the division by the number of elements should
#   occur _once_ and _after the loop_.
#
# * The code is _misleading_. The loop variable is `w` (for 'weight'), in the
#   first loop but  (again because of copy-paste) it wasn't changed in the
#   two other loops. It should be 'l' and 'a', respectively. This doesn't cause
#   errors, but forces you to double-check that you understand what is going on.
# 
# * The code is _repetitive_. The procedure for computing an arithmetic mean is
#   always the same, yet here it is written three times. Imagine if I had ten or a
#   hundred different arrays of values for which I wanted to compute the
#   average! And if I wanted to fix or modify anything in the loop, I'd have to
#   repeat the change in _every_ loop.
