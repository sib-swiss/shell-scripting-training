#!/bin/bash

# Output a welcome message. We use a here document, instead of cat'ing a separate file.

cat <<END # NOT echo pr printf!

Welcome, $USER!

Today is $(date +"%A, %d %B %Y"); it is now $(date +"%T")

Enjoy!
END

exit 0

# If we could only use echo/printf, it would look like this:

echo "Welcome, $USER!

Today is $(date +"%A, %d %B %Y"); it is now $(date +"%T")

Enjoy!"

# In this case, the resulted string is passed as an _argument_ to echo, while in
# the above case it is _redirected_ to cat's _standard input_, 
