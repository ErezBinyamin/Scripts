#!/bin/bash
# Script to iterate through people who have viewed your facebook profile recently

echo "[1] Go to your www.facebook.com profile page: www.facebook.com/YOURNAME"
read -s INPUT
echo "[2] Press ctrl + u to open the page source"
read -s INPUT
echo "[3] Press ctrl + s to download the page source"
read -s INPUT
unset FB_PROFILE
while [ ${#FB_PROFILE} -lt 2 ] || [ ! -f ${FB_PROFILE} ]
do
	printf "[4] Enter full path to downloaded file: "
	read FB_PROFILE
	echo ""
done

BASE_URL='www.facebook.com'
NUM=0
for s in `grep -iPo '"buddy_id":"[0-9]+"' ${FB_PROFILE}`
do
	ID=$(echo $s | cut -d ':' -f 2 | tr -d '"')
	echo Openning stalker number: $((NUM++))
	firefox "${BASE_URL}/${ID}"
	read -s INPUT
done
