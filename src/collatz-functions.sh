# iterative

collatz_i() {
	declare -i n=$1
	while ((n > 1)); do
		printf "%d\n" "$n"
		if ((0 == n % 2)); then
			((n /= 2))
		else
			((n = 3*n +1))
		fi
	done
}

# recursive

collatz_r() {
	declare -i n=$1
	printf "%d\n" "$n"
	((1 == n)) && return
	if ((0 == n % 2)); then
		collatz_r $((n / 2))
	else
		collatz_r $((3*n + 1))
	fi
}

