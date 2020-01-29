#!/bin/bash
# Script to access all cmd_euler features
# Accesible via command line or GUI interface
# Features:
#	Problem fetcher
#	Template Generator
cmd_euler()
(
	local WRK_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
	local LAUNCH_GUI=0
	local PRINT_HELP=0
	local PROBLEM_NUMBER=0
	local GEN_TEMPLATE=0
	local TEMPLATE=""

	usage() {
		echo "USAGE: cmd_euler [-g] [-p <problem-number>] [-t <language-template>]"
	}

	# Given an argument string, will parse arguments
	# Populates global variables with
	# Argument specified user-variables
	parse_args() {
		while getopts ":ghp:t:" o; do
			case "${o}" in
			g)
				LAUNCH_GUI=1
				;;
			h)
				PRINT_HELP=1
				;;
			p)
				PROBLEM_NUMBER=${OPTARG}
				;;
			t)
				TEMPLATE=${OPTARG}
				;;
			*)
				case $o in
					'?')
						echo "Unknown option!"
						;;
					':')
						echo "Missing argument to option!"
						;;
					  *)
						echo "Unknown argument parsing error!!"
						;;
				esac
				;;
			esac
		done
		shift $((OPTIND-1))
	}

	call_feature() {
		if [ $LAUNCH_GUI -ne 0 ]
		then
			echo "GUI"
		fi

		if [ $PRINT_HELP -ne 0 ]
		then
			usage
		fi

		if [ ${#TEMPLATE} -ne 0 ] && [ $PROBLEM_NUMBER -ne 0 ]
		then
			for t in $(ls ${WRK_DIR}/templates)
			do
				if [[ ${t,,} == ${TEMPLATE,,} ]]
				then
					cat ${WRK_DIR}/templates/$t/template.*
				fi
			done

			echo "GENERATING $TEMPLATE TEMPLATE FOR PROBLEM $PROBLEM_NUMBER"
			bash ${WRK_DIR}/scripts/get_euler.sh ${PROBLEM_NUMBER}
		elif [ $PROBLEM_NUMBER -ne 0 ]
		then
			echo "GET PROBLEM $PROBLEM_NUMBER"
			bash ${WRK_DIR}/scripts/get_euler.sh ${PROBLEM_NUMBER}
		fi

		if [ ${#TEMPLATE} -eq $PROBLEM_NUMBER ] && [ $PRINT_HELP -eq $LAUNCH_GUI ]
		then
			usage
		fi

	}

	# Parses user-arguments
	# Call aprropriate feature depending upon user demand
	main() {
		parse_args $@
		call_feature
	}

	## MAIN FUNCTION CALL ##
	main $@
)

cmd_euler $@
