#!/bin/bash
# OEIS is the Online Encyclopedia of Integer Sequences
# oeis.sh is the command line way to access it :)
# curl 'https://oeis.org/search?q=3%2C11%2C22%2C33%2C101' | less

BASE_URL='https://oeis.org/'
oeis() (
	# USAGE STATEMENT
	usage() {
		echo "oeis \"sequence string\""
	}

	# PARSE ARGS
	echo $@

	# MAKE WEB REQUEST
	# FORMAT RESPONSE
	# PRINT
)

oeis $@
