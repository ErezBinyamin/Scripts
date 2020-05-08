#!/usr/bin/env bash

# Written by Erez Binyamin (github.com/ErezBinyamin)

# Search for an integer sequence
oeis() {
  local URL='https://oeis.org'
  local TMP=/tmp/oeis
  local DOC=/tmp/oeis/doc.html
  mkdir -p $TMP
  # Search sequence by ID
  if [ $# -eq 1 ]
  then
    # Generate URL
    [[ ${1:0:1} == 'A' ]] && ID=${1:1} || ID=${1}
    ID=$(bc <<< "$ID")
    ID="A$(printf '%06d' ${ID})"
    URL+="/${ID}"
    curl $URL 2>/dev/null > $DOC
    # ID
    printf "ID: ${ID}\n"
    # Description
    grep -A 1 '<td valign=top align=left>' $DOC \
      | sed '/<td valign=top align=left>/d; /--/d; s/^[ \t]*//; s/<[^>]*>//g;'
    printf "\n"
    # Sequence
    grep -o '<tt>.*, .*[0-9]</tt>' $DOC \
      | sed 's/<[^>]*>//g' \
      | grep -v '[a-z]' \
      | grep -v ':'
    printf "\n"
    # Code
    cat $DOC \
      | tr '\n' '@' \
      | grep -o 'PROG.*CROSSREFS' \
      | tr '@' '\n' \
      | sed 's/^[ \t]*//; s/<[^>]*>//g' \
      | sed 's/&nbsp;/ /g; s/\&amp;/\&/g; s/&gt;/>/g; s/&lt;/</g; s/&quot;/"/g' \
      | sed '/^\s*$/d; /CROSSREFS/d; /PROG/d' \
      | sed  's#//.*##g; s#\\.*##g; s#--.*##g; s#/\*.*##g; s/#.*//g' | pygmentize -g
    printf "\n"
  # Search unknown sequence
  else
    # Build URL
    URL+="/search?q=$(echo $@ | tr ' ' ',')"
    curl $URL 2>/dev/null > $DOC
    # Sequence IDs
    grep -o '=id:.*&' $DOC \
      | sed 's/=id://; s/&//' > $TMP/id
    # Descriptions
    grep -A 1 '<td valign=top align=left>' $DOC \
      | sed '/<td valign=top align=left>/d; /--/d; s/^[ \t]*//; s/<[^>]*>//g' \
      | sed 's/&nbsp;/ /g; s/\&amp;/\&/g; s/&gt;/>/g; s/&lt;/</g; s/&quot;/"/g' > $TMP/nam
    # Sequences
    grep -o '<tt>.*<b.*</tt>' $DOC \
      | sed 's/<[^>]*>//g' > $TMP/seq
    # Print data for all
    readarray -t ID < $TMP/id
    readarray -t NAM < $TMP/nam
    readarray -t SEQ < $TMP/seq
    for i in ${!ID[@]}
    do
      printf "${ID[$i]}: ${NAM[$i]}\n"
      echo ${SEQ[$i]}
      printf "\n"
    done
  fi
}

oeis $@
