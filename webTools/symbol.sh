#!/bin/bash
# Search for a unicode symbol
symbol() {
	SYMBOL="${@}"
	SYMBOL_FILE=/tmp/symbol_file.html
	# Special case for box chars
	if [[ ${SYMBOL^^} == "BOX" ]]
	then
		curl 'https://en.wikipedia.org/wiki/Box-drawing_character' 2>/dev/null --output ${SYMBOL_FILE}
		grep '<td>.*</td>' ${SYMBOL_FILE} | sed -r 's/<td>//g; s#</td>##g; /^\s*$/d' | awk '!a[$0]++'
		echo "══════════════════════════════════════════════"
	fi
	# Standard unicode
	curl 'https://en.wikipedia.org/wiki/List_of_Unicode_characters' 2>/dev/null --output ${SYMBOL_FILE}
	cat ${SYMBOL_FILE} | sed 's#</td>##g' | sed -r '/^\s*$/d; s#<td align="center">#<td>#g' | grep -e '<td>' | grep -B 10 -i "$SYMBOL" | sed '/^.\{6\}./d' | sed 's#<td>##g; s#--##g' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
	cat ${SYMBOL_FILE} | grep 'class="mw-redirect" title="' | grep -i "${SYMBOL}" | tr '"' '\n' | sed '/^.\{1\}./d' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
	# Dingbats
	curl 'https://en.wikipedia.org/wiki/Dingbat' 2>/dev/null --output ${SYMBOL_FILE}
	cat ${SYMBOL_FILE} | sed 's#</td>##g' | sed -r '/^\s*$/d; s#<td align="center">#<td>#g' | grep -e '<td>' | grep -B 10 -i "$SYMBOL" | sed '/^.\{6\}./d' | sed 's#<td>##g; s#--##g' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
	cat ${SYMBOL_FILE} | grep 'class="mw-redirect" title="' | grep -i "${SYMBOL}" | tr '"' '\n' | sed '/^.\{1\}./d' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
}
