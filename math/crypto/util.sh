#!/bin/bash
# Utility bash functions for crypto things

# == chr ${NUM} ==
# Convert a number to a char
# @param  number
# @return char
chr() {
	[ "$1" -lt 256 ] || return 1
	printf "\\$(printf '%03o' "$1")"
}

# == ord ${CHR} ==
# Convert a char to a number
# @param  char
# @return number
ord() {
	LC_CTYPE=C printf '%d' "'$1"
}

