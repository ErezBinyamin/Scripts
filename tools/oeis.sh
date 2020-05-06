#!/bin/bash
# OEIS is the Online Encyclopedia of Integer Sequences
# oeis.sh is the command line way to access it :)

BASE_URL='https://oeis.org/'
oeis() (
	local URL='https://oeis.org/search?q='
	local TMP=/tmp/oeis
	local DOC=/tmp/oeis/doc.html
	mkdir -p $TMP

	# Build URL
	URL+="$(echo $@ | tr ' ' ',')"

	# Retrieve DOC
	curl $URL 2>/dev/null > $DOC

	# Get sequences names and values
	[ $# -ne 1 ] && grep -o '=id:.*&' $DOC | sed 's/=id://; s/&//' > $TMP/nam
	[ $# -ne 1 ] && grep -o '<tt>.*<b.*</tt>' $DOC | sed 's/<[^>]*>//g' > $TMP/seq

	[ $# -eq 1 ] && cat $DOC # > $TMP/nam
	#[ $# -eq 1 ] && cat $DOC # > $TMP/seq

	# Print data
	readarray -t NAM < $TMP/nam
	readarray -t SEQ < $TMP/seq
	for i in ${!NAM[@]}
	do
		echo ${NAM[$i]}
		echo ${SEQ[$i]}
	done
)

oeis $@
