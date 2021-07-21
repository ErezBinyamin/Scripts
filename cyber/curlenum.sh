#!/bin/bash
# Good example URL list: https://raw.githubusercontent.com/fuzzdb-project/fuzzdb/master/attack/business-logic/CommonDebugParamNames.txt
# Tests some base URL with a bunch of potentially interesting endpoints
# Prints colored HTTP response codes

curlenum() (
  __assign_http_color() {
    for BASE in $(seq 100 100 1000)
    do
      if [[ $1 -ge $BASE && $1 -lt $(( $BASE + 100 )) ]]
      then
        COLOR=$(( $1 - $BASE + ( $BASE / 100 ) ))
        printf '\033[48;5;'"$COLOR"'m'
      fi
    done
  }
  
  usage() {
    echo "$0 <URL> <url endings file>"
  }

  # -- MAIN --
  local RST="\e[0m"

  if [ $# -lt 2 ] || \
     [ ! -f $2 ]
  then
    usage
    return 1
  fi

  URL=$1
  mapfile -t ENDPOINTS < $2

  printf "\nSTART\n"
  for EP in ${ENDPOINTS[@]}
  do
    ( HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" ${URL}/${EP}); \
	    [ $HTTP_CODE -ne 404 ] && printf "$(__assign_http_color ${HTTP_CODE})[ ${HTTP_CODE} ]${RST} ${URL}/${EP}\n" ) &
  done
  wait
  printf "\nDONE\n"
)

curlenum $@
