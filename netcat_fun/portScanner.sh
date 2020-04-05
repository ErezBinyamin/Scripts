#!/bin/bash
#------------ ~~~~~~~~ ------------
IP=$1
SIGNALS=""
MINPORT=0
MAXPORT=65535
#------------ ~~~~~~~~ ------------
usage() {
	printf "\nUSAGE: portScanner <TARGET IP>\n\n"
	exit 1
}

testPort() {
	nc -v -z -w 2 $IP $1 &> /dev/null && printf "\n$(nc -v -z $IP $1)"
}

signalIRQ() {
	printf "\nEXIT? [Y/N]: "
	read -n 1 CHOICE
	printf "\n\n"
	[[ ${CHOICE,,}  =~ "y" ]] && exit 0
}

# Process input (Exit when more than 2 args are passed, or IP address provided (arg1) is of invalid length)
[ $# -gt 2 ] || [ ${#1} -lt 7 ] || [ ${#1} -gt 15 ] && usage

# Trap signals (all strings of length >3 from trap -l output)
for i in $(trap -l)
do
	[ ${#i} -gt 3 ] && SIGNALS="$SIGNALS $i"
done

trap 'signalIRQ' $SIGNALS
# #######################
# MAIN Port scan loop
# #######################
for i in $(seq $MINPORT $MAXPORT)
do
	printf "\r"
	testPort $i &
	printf "SCANNING PORT: $i of $MAXPORT"
done
