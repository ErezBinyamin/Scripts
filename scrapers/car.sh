#!/bin/bash
MODEL=$1
MAKE=$2
URL="https://www.caranddriver.com/${MODEL}/${MAKE}/specs"
TMPDIR=$(mktemp -d)
RAW=${TMPDIR}/raw.html
DATA=${TMPDIR}/data.html
KEYS=${TMPDIR}/keys.txt
VALUES=${TMPDIR}/values.txt
OUT=/tmp/out.csv
rm -f ${OUT}

curl ${URL} > ${RAW}

OVERVIEW_START_LINE=$(grep -nr 'specs-overview' ${RAW} | grep -o '^[0-9].*[!0-9]')
OVERVIEW_END_LINE=$(grep -nr 'content-rail review-rail' ${RAW} | grep -o '^[0-9].*[!0-9]')

sed "1,${OVERVIEW_START_LINE}d" ${RAW} > ${DATA}

PRICE=$(grep '="price' ${DATA} | sed 's/<[^>]*>//g; s/,//g' | tr -d ' \t')
echo "price" > ${KEYS}
sed "s/^[ \t]*//" ${DATA} | grep -A 1 -e '<h3' | sed 's/<[^>]*>//g; /^\s*$/d' | grep -v '\-\-' | tr -d ',' >> ${KEYS}
echo "${PRICE}" > ${VALUES}
sed "s/^[ \t]*//" ${DATA} | grep -A 3 -e '<h3' | grep 'div' | sed 's/<[^>]*>//g; /^\s*$/d' |  grep -v '\-\-' | tr -d ',' >> ${VALUES}

paste -d, ${KEYS} ${VALUES} >> ${OUT}
column -ts, ${OUT}

cp ${RAW} /tmp/raw

rm -rf ${TMPDIR}
