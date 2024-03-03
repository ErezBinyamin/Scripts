#!/bin/bash
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
#set -x

gdp() (
	local GDP_URL='https://fred.stlouisfed.org/data/GDP.txt'
	local GDP_TXT='/tmp/GDP.txt'
	[ -f ${GDP_TXT} ] || curl --silent "${GDP_URL}" | sed 's/ .* /,/g' > "${GDP_TXT}" &
	
	local VAL1="${1}"
	local YEAR1="${2}"
	local YEAR2="${3:-0}"
	local VAL2=0

	argparse() {
		local isnum='^[0-9]+$'
		if [[ ! ${VAL1} =~ ${isnum} || \
			! ${YEAR1} =~ ${isnum} || \
			! ${YEAR2} =~ ${isnum} ]]
		then
			echo "ERROR: Invalid arguments"
			return 1
		fi
	}

	main() {
		local GDP1 GDP2
		argparse || return $?

		wait
		GDP1=$(grep "${YEAR1}-01-01" ${GDP_TXT} | cut -d',' -f2 | tr -d '\r')
		if [[ "${YEAR2}" == "0" ]]
		then
			YEAR2=$(tail -n1 ${GDP_TXT} | cut -d',' -f1 | cut -d'-' -f1)
			GDP2=$(tail -n1 ${GDP_TXT} | cut -d',' -f2 | tr -d '\r')
		else
			GDP2=$(grep "${YEAR2}-01-01" ${GDP_TXT} | cut -d',' -f2 | tr -d '\r')
		fi

		VAL2=$( bc -l <<< "${VAL1} * (${GDP2} / ${GDP1})" )

		printf "\n $ ${VAL1} dollars in ${YEAR1} is equivalent to $ ${VAL2} dollars in ${YEAR2}\n"
		
	}

	main $@
)

gdp $@
