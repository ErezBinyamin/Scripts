#!/bin/bash
# Eulers method in bash
# Define variales in this script and then go!

########################################################################################
########################################################################################
# Declare starting X value
X=1

# Declare starting Y value
Y=0

# Declare step size ΔX or h or Δt or whaterver u call it
h=0.1

# Declare ending value of X
ENDX=2.4
########################################################################################
########################################################################################

# Initialize intermediate variables
dYdX=0
dltaY=0
Yn=0

# Calculate dY/dX
deriv()
{
	local X=$1
	local Y=$2
	local EQUATION=""

#	EQUATION="(${X})^3 / ${Y}"
#	EQUATION="(-9) * (${X}) * ${Y}"
#	EQUATION="3 * (${X}) - ${Y} + 1"
#	EQUATION="0.07 * (${Y})"
	EQUATION="-(${X}) - (${Y})"

	bc -l <<< "${EQUATION}"
}

# Format printing for a pretty table
myPrint(){

	# Print colored values
	printf "$(tput setaf 1)|%-5s$(tput setaf 2)|%-30s$(tput setaf 3)|%-30s$(tput setaf 4)|%-30s$(tput setaf 5)|%-30s\n" \
		"$1" "$2" "$3" "$4" "$5"

	# Print line separator
	tput setaf 0
	for i in $(seq 1 $(tput cols))
	do
		printf '═'
	done

	# Return terminal to default state on newline
	tput sgr0
	printf "\n"
}

main()
{
	myPrint "X" "Y" "dY/dX" "ΔY" "new Y"

	while [ $(bc -l <<< "${X} <= ${ENDX}") -eq 1 ]
	do
		dYdX=$(deriv $X $Y)
		dltaY=$(bc -l <<< "${dYdX} * ${h}")
		Yn=$( bc -l <<< "${Y} + ${dltaY}" )

		myPrint "$X" "$Y" "$dYdX" "$dltaY" "$Yn"

		Y=$Yn
		X=$(bc -l <<< "(${X}) + (${h})")

	done
}
printf "%-50s %s\n"

main
