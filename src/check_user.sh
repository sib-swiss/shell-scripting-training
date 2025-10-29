#!/usr/bin/env bash

# checks for presence of user 

# usage: check_user <username>

user=$1

# Simplest form: just a 'then' clause

if grep "^$user:" > /dev/null < /etc/passwd
then
    printf "result: %d - user %s found.\n" "$?" "$user"
fi

# With a 'else' clause

# if grep "^$user:" > /dev/null < /etc/passwd
# then
#     printf "result: %d - user %s found.\n" "$?" "$user"
#  else
#      printf "result: %d - user %s NOT found.\n" "$?" "$user"
# fi

# Newlines can be replaced by ; as usual:
# 
# if grep "$user" > /dev/null < /etc/passwd ; then
#     printf "user %s found.\n" "$user"
# else
#     printf "user %s NOT found.\n" "$user"
# fi
