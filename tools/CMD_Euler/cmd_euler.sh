#!/bin/bash
# Script to access all cmd_euler features
# Accesible via command line or GUI interface
# Features:
#	Problem fetcher
#	Template Generator
cmd_euler()
(
	local WRK_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
	local PRINT_HELP=0
	local PROBLEM_NUMBER=0
	local GEN_TEMPLATE=0
	local TEMPLATE=""

	usage() {
		echo "USAGE: cmd_euler [-p <problem-number>] [-t <language-template>]"
	}

	# Given an argument string, will parse arguments
	# Populates global variables with
	# Argument specified user-variables
	parse_args() {
		while getopts ":hp:t:" o; do
			case "${o}" in
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

	validate_args() {
		re='^[0-9]+$'
		if ! [[ $PROBLEM_NUMBER =~ $re ]] || [ $PROBLEM_NUMBER -lt 1 ] || [ $PROBLEM_NUMBER -gt 699 ]
		then
			echo "ERROR: No valid problem number specified!" >&2
			usage
			return 1
		fi
	}

	call_feature() {
		if [ $PRINT_HELP -ne 0 ]
		then
			usage
			return 0
		elif [ ${#TEMPLATE} -ne 0 ] && [ $PROBLEM_NUMBER -ne 0 ]
		then
			bash ${WRK_DIR}/scripts/make_template.sh "${TEMPLATE}" ${PROBLEM_NUMBER}
		elif [ $PROBLEM_NUMBER -ne 0 ]
		then
			echo "GET PROBLEM $PROBLEM_NUMBER"
			bash ${WRK_DIR}/scripts/get_euler.sh ${PROBLEM_NUMBER}
		elif [ ${#TEMPLATE} -eq $PROBLEM_NUMBER ] && [ $PRINT_HELP -eq $LAUNCH_GUI ]
		then
			usage
			return 1
		fi
	}

	# Parses user-arguments
	# Call aprropriate feature depending upon user demand
	main() {
		parse_args $@ || return 1
		validate_args || return 1
		call_feature || return 1
	}

	## MAIN FUNCTION CALL ##
	main $@ || return 1
)

cmd_euler $@
