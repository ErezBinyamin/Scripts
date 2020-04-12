#!/bin/bash
# trap all signals to allow for clean exit
trap 'printf "\e[0m\nEXIT? [Y/N]: ";read -n 1 CHOICE;[[ ${CHOICE,,}  =~ "y" ]] && printf "\n";exit 0' $(trap -l | tr ' \t' '\n' | grep SIG | tr '\n' ' ')
for i in $(seq 0 65535)
do
	printf '\r'
	nc -v -z -w 2 ${1} ${i} &> /dev/null && printf "$(nc -v -z ${1} ${i} 2>&1 | xargs printf '\r%s %s %s %s %s %s %s\n\r\t\t\t\r')" &
	printf "SCANNING PORT: \e[33m${i}\e[0m of 65535"
done
printf '\n'
