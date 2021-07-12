#!/bin/bash
# Download a random crackme from: https://crackmes.one/

crackme() (
  local BASEURL='https://crackmes.one'
  local TMPDIR=$(mktemp -d)
  local RAW=${TMPDIR}/raw.html

  # -- main --
  local PAGENUM=$(( ($RANDOM % 68) + 1 ))
  local PAGEURL="${BASEURL}/lasts/${PAGENUM}"
  curl --silent ${PAGEURL} > ${RAW}

  local CRACKME=`grep '<td> <a href="/crackme/' ${RAW} | grep -o '".*"' | tr -d '"' | shuf -n 1`
  local DESCURL="${BASEURL}/${CRACKME:1}"
  local BINURL="${BASEURL}/static/${CRACKME:1}.zip"

  # Error checking
  # Check for 404 error in first response
  if grep -q '<title>404' ${RAW}
  then
    >&2 echo "ERROR PAGEURL PageNotFound: ${PAGEURL}"
    return 1
  fi
  # Check to see if the binary URL even exist
  if ! curl --output /dev/null --silent --fail -r 0-0 "$BINURL"
  then
    >&2 echo "ERROR BINURL PageNotFound: $BINURL"
    return 1
  fi

  # Parse binary description
  curl --silent $DESCURL > /tmp/foo.html
  grep -A 3 \
       -e 'Author' \
       -e 'Language' \
       -e 'Upload' \
       -e 'Platform' \
       -e 'Difficulty' \
       -e 'Quality' \
       -e 'Description' \
       /tmp/foo.html | sed -e 's/<[^>]*>//g; /^[[:space:]]*$/d; /--/d; s/&#34;/"/g'

  read -p "Download this crackme? [y/n]" X
  if [[ "${X,,}" =~ 'y' ]]
  then
     # Download actual binary
     wget $BINURL
     echo "Crackme downloaded from: ${DESCURL}"
  fi 

  rm -rf $TMPDIR
)

crackme $@
