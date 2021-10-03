#!/bin/bash

delta_t() {
	[ $# -ne 2 ] && return 1
	local T1=$(date '+%s%N' --date="$1")
	local T2=$(date '+%s%N' --date="$2")
	bc -l <<< "( ${T2} - ${T1} ) / 10^9"
}

serial_test() {
	[ $# -ne 1 ] && return 1
	[ $1 -gt 1 ] || return 1
	local NUM_SAMPLES=${1}
	local TEST_OUT_FILE=/tmp/serial_test.csv

	# Get serial devices
	local TxD="/dev/$(ls -l /dev/serial/by-id/ | grep 'Prolific' | grep -o 'tty.*' | head -n1)"
	local RxD="/dev/$(ls -l /dev/serial/by-id/ | grep 'Prolific' | grep -o 'tty.*' | tail -n1)"
	[[ -e $TxD && -e $RxD ]] || return 1

	# Create file descriptor handles to Serial devices
	sudo chmod a+w $TxD
	sudo chmod a+r $RxD
	exec {var}>${TxD}
	local TxFD=$var
	exec {var}<${RxD}
	local RxFD=$var


	rm -f ${TEST_OUT_FILE}
	local COUNT=0
	while [ ${COUNT} -lt ${NUM_SAMPLES} ]
	do
		# Time before packet send
		T1=$(date +'%T.%N')

		printf "TEST\n" > $TxD
		read RX < $RxD

		# Time after packet send
		T2=$(date +'%T.%N')
		delta_t ${T1} ${T2} >> ${TEST_OUT_FILE}
		let COUNT++
	done

	# Free file descriptors
	exec <&${TxFD}-
	exec <&${RxFD}-
}

local_test $@
