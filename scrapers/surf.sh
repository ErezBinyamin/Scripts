#!/bin/bash

surf_web() {
  local BASE_URL='https://www.surf-forecast.com/breaks'
  local SEARCH_URL=''
  local HTTP_CODE=404
  local TMP=$(mktemp -d)
  local SEARCH_RESULT_FILE=${TMP}/search.html

  #Check Args
  if [ $# -ne 1 ]
  then
    echo "[ERROR] Usage: $0 <name of break>"
    return 1
  fi
  local BEACH=$(echo ${1,,} | tr ' ' '-')

  for apnd in "" "-beach" "_1"
  do
    SEARCH_URL="${BASE_URL}/${BEACH}${apnd}/forecasts/latest/six_day"
    HTTP_CODE=$( curl -Ls -o ${SEARCH_RESULT_FILE} -w "%{response_code}" "${SEARCH_URL}" )
    [ $HTTP_CODE -eq 200 ] && break
  done

  # Catch no website error
  if [ $HTTP_CODE -ne 200 ]
  then
    echo "[ERROR] Got HTTP $HTTP_CODE when searching for: ${BEACH}"
    return 1
  fi
}

surf_web2() {
  local BASE_URL='https://www.surf-forecast.com'
  local TMP=$(mktemp -d)
  local SEARCH_RESULT_FILE=${TMP}/search.html

  # Find break name
  /breaks?page=27
}

surf_web2 $@
