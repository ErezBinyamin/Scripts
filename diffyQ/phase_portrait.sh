#!/bin/bash
# Generates a phase portrait
# From    : FROM
# To      : TO
# Interval: STEP
# Green arrows are increasing
# Red arrows are decreasing
# White circles are equilibrium points

##############################################################################################
##############################################################################################
declare -i FROM=-10
declare -i STEP=1
declare -i TO=10

# Define the equation to draw a phase portrait for
equ(){
	local X=$1
	local Y=$2
	EQUATION="($Y)^2 * (($Y) - 4) * (($Y) - 2)"
	bc -l <<< "${EQUATION}"
}
##############################################################################################
##############################################################################################

myPrint(){
	local Y="$1"
	local dydx="$2"
	local phase="$3"

	printf "%-5s%-10s%-5s" "${Y}" "${dydx}" "${phase}"
	printf "\n"
}

smartPortrait(){
	local FROM=$1
	local STEP=$2
	local TO=$3
	local X=0
	local Y=0

	local LAST=0
	local dydx=0
	local Yt=0
	local NEXT=0

	myPrint "Y" "dY/dX" "phase-diagram"
	for Y in $(seq $FROM $STEP $TO)
	do
		LAST=${dydx}						# LAST dydx

		dydx=$(equ ${X} ${Y})					# Calculate dYdX

		Yt=$(bc -l <<< "(${Y}) + (${STEP})")
		NEXT=$(equ ${X} ${Yt})					# NEXT dydx

		# DETERMINE PHASE
		phase=""
		if [ $( bc -l <<< "(${dydx}) < 0" ) -eq 1 ]		# Decreasing
		then
			phase="$(tput setaf 1)▼$(tput sgr0)"

		elif [ $( bc -l <<< "(${dydx}) > 0" ) -eq 1 ]		# Increasing
		then
			phase="$(tput setaf 2)▲$(tput sgr0)"

		elif [ $( bc -l <<< "(${dydx}) == 0" ) -eq 1 ]		# Equilibrium point
		then
			phase="$(tput bold)●$(tput sgr0)"
			# UNSTABLE
			if [ $(bc -l <<< "(${LAST}) > 0") -eq 1 ] && [ $(bc -l <<< "(${NEXT}) < 0") -eq 1 ]
			then
				phase="${phase}  --> UNSTABLE"
			# STABLE
			elif [ $(bc -l <<< "(${LAST}) < 0") -eq 1 ] && [ $(bc -l <<< "(${NEXT}) > 0") -eq 1 ]
			then
				phase="${phase}  --> STABLE"
			# SEMI-STABLE
			else
				phase="${phase}  --> SEMI-STABLE"
			fi
		else
			echo "CRITICAL ERROR: bc -l"
			return 1
		fi

		myPrint "${Y}" "${dydx}" "${phase}"
	done
}

# Draw the phase portrait
draw(){
	local FROM=$1
	local STEP=$2
	local TO=$3
	export GREP_COLOR='1;37'

	smartPortrait $FROM $STEP $TO | grep -C 3 '●'
}

draw $FROM $STEP $TO
