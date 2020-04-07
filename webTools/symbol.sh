#!/bin/bash
# Search for a unicode symbol
symbol() {
	SYMBOL="${@}"
	SYMBOL_FILE=/tmp/symbol_file.html
	curl 'https://en.wikipedia.org/wiki/List_of_Unicode_characters' 2>/dev/null > ${SYMBOL_FILE}
	cat ${SYMBOL_FILE} | sed 's#</td>##g' | sed -r '/^\s*$/d; s#<td align="center">#<td>#g' | grep -e '<td>' | grep -B 10 -i "$SYMBOL" | sed '/^.\{6\}./d' | sed 's#<td>##g; s#--##g' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
	cat ${SYMBOL_FILE} | grep 'class="mw-redirect" title="' | grep -i "${SYMBOL}" | tr '"' '\n' | sed '/^.\{1\}./d' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'

	curl 'https://en.wikipedia.org/wiki/Dingbat' 2>/dev/null > ${SYMBOL_FILE}
	cat ${SYMBOL_FILE} | sed 's#</td>##g' | sed -r '/^\s*$/d; s#<td align="center">#<td>#g' | grep -e '<td>' | grep -B 10 -i "$SYMBOL" | sed '/^.\{6\}./d' | sed 's#<td>##g; s#--##g' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
	cat ${SYMBOL_FILE} | grep 'class="mw-redirect" title="' | grep -i "${SYMBOL}" | tr '"' '\n' | sed '/^.\{1\}./d' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
}
