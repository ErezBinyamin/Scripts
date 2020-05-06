#!/bin/bash
# OEIS is the Online Encyclopedia of Integer Sequences
# oeis.sh is the command line way to access it :)
oeis() {
	local URL='https://oeis.org'
	local TMP=/tmp/oeis
	local DOC=/tmp/oeis/doc.html
	mkdir -p $TMP

	# Search sequence by ID
	if [ $# -eq 1 ]
	then
		[[ ${1:0:1} == 'A' ]] && ID=${1:1} || ID=${1}
		ID=$(bc <<< "$ID")
		ID="A$(printf '%06d' ${ID})"

		URL+="/${ID}"
		curl $URL 2>/dev/null > $DOC
		printf "ID: ${ID}\n"
		grep -A 1 '<td valign=top align=left>' $DOC | sed '/<td valign=top align=left>/d; /--/d; s/^[ \t]*//; s/<[^>]*>//g;'
		printf "\n"
		grep -o '<tt>.*, .*[0-9]</tt>' $DOC | sed 's/<[^>]*>//g' | grep -v '[a-z]'
		printf "\n"
		cat $DOC | tr '\n' '@' | grep -o 'PROG.*CROSSREFS' | tr '@' '\n' | sed 's/^[ \t]*//; s/<[^>]*>//g; s/&nbsp;/ /g; s/\&amp;/\&/g; s/&gt;/>/g; s/&lt;/</g; s/&quot;/"/g; /^\s*$/d; /CROSSREFS/d; /PROG/d' | sed  's#//.*##g; s#\\.*##g; s#--.*##g; s#/\*.*##g; s/#.*//g'
		printf "\n"
	# Search unknown sequence
	else
		# Build URL
		URL+="/search?q=$(echo $@ | tr ' ' ',')"
		# Retrieve DOC
		curl $URL 2>/dev/null > $DOC

		grep -o '=id:.*&' $DOC | sed 's/=id://; s/&//' > $TMP/id
		grep -A 1 '<td valign=top align=left>' $DOC | sed '/<td valign=top align=left>/d; /--/d; s/^[ \t]*//; s/&nbsp;/ /g; s/\&amp;/\&/g; s/&gt;/>/g; s/&lt;/</g; s/&quot;/"/g; s/<[^>]*>//g' > $TMP/nam
		grep -o '<tt>.*<b.*</tt>' $DOC | sed 's/<[^>]*>//g' > $TMP/seq

		# Print data
		readarray -t ID < $TMP/id
		readarray -t NAM < $TMP/nam
		readarray -t SEQ < $TMP/seq
		for i in ${!NAM[@]}
		do
			printf "${ID[$i]}: ${NAM[$i]}\n"
			echo ${SEQ[$i]}
			echo "--"
		done
	fi
}

oeis $@
