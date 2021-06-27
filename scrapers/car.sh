#!/bin/bash
get_car_data() {
  local MODEL=${1:-none}
  local MAKE=${2:-none}
  local URL="https://www.caranddriver.com/${MODEL}/${MAKE}/specs"
  local TMPDIR=$(mktemp -d)
  local RAW=${TMPDIR}/raw.html
  local DATA=${TMPDIR}/data.html
  local KEYS=${TMPDIR}/keys.txt
  local VALUES=${TMPDIR}/values.txt
  
  curl --silent ${URL} > ${RAW}
 
  if grep -q '<title>404' ${RAW}
  then
    >&2 echo "ERROR CarNotFound: $@"
    return 1
  fi

  OVERVIEW_START_LINE=$(grep -nr 'specs-overview' ${RAW} | grep -o '^[0-9].*[!0-9]')
  #OVERVIEW_END_LINE=$(grep -nr 'content-rail review-rail' ${RAW} | grep -o '^[0-9].*[!0-9]')
  
  sed "1,${OVERVIEW_START_LINE}d" ${RAW} > ${DATA}
  
  PRICE=$(grep '="price' ${DATA} | sed 's/<[^>]*>//g; s/,//g' | tr -d ' \t')
  echo "price" > ${KEYS}
  sed "s/^[ \t]*//" ${DATA} | grep -A 1 -e '<h3' | sed 's/<[^>]*>//g; /^\s*$/d' | grep -v '\-\-' | tr -d ',' >> ${KEYS}
  echo "${PRICE}" > ${VALUES}
  sed "s/^[ \t]*//" ${DATA} | grep -A 3 -e '<h3' | grep 'div' | sed 's/<[^>]*>//g; /^\s*$/d' |  grep -v '\-\-' | tr -d ',' >> ${VALUES}
  
  paste -d, ${KEYS} ${VALUES}

  rm -rf ${TMPDIR}
}

tabulate() {
  if [[ $DATA == "None" || ! -f ${DATA} ]]
  then
	  echo "ERROR: ${DATA}"
	  return 1
  fi
  sed 's/,,/, ,/g;s/,,/, ,/g' ${DATA} | column -s, -t
}


car() {
  local MAKE=${1:-"None"}
  local MODEL=${2:-"None"}

  if [[ $MODEL == "None" ]]; then
    echo "USAGE: $0 <Make> <Model>"
    return 1
  fi

  local TMPDIR=$(mktemp -d)
  local DATA=${TMPDIR}/${MAKE}_${MODEL}.csv

  touch $DATA
  get_car_data $MAKE $MODEL > $DATA
  tabulate ${DATA}
  rm -rf $TMPDIR
}

car $@
