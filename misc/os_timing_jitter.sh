#!/bin/bash

delta_t() {
	[ $# -ne 2 ] && return 1
	local T1=$(date '+%s%N' --date="$1")
	local T2=$(date '+%s%N' --date="$2")
	bc -l <<< "( ${T2} - ${T1} ) / 10^9"
}

local_test() {
	# Argparse
	[ $# -ne 1 ] && return 1
	[ $1 -gt 1 ] || return 1
	local NUM_SAMPLES=${1}
	local PACKET_SIZE=${2:-"5"}
	local TMP=/tmp/local_test_jitter

	# Packet will have new line apended
	let PACKET_SIZE--
	local PACKET=$(head -c ${PACKET_SIZE} < /dev/zero | tr '\0' '\141')

	# Create output files and fifo for timing consistency
	mkdir -p ${TMP}
	local LOG=$(mktemp ${TMP}/test.XXXXX.dat)
	echo "test output: ${LOG}"
	local TFIFO=$(mktemp --dry-run /tmp/tfifo.XXXXX)
	mkfifo ${TFIFO}

	local COUNT=0
	while [ ${COUNT} -lt ${NUM_SAMPLES} ]
	do
		T1=$(date +'%T.%N')

		printf "${PACKET}\n" >> ${TFIFO} &
		read RX < ${TFIFO}

		T2=$(date +'%T.%N')
		delta_t ${T1} ${T2} >> ${LOG}
		let COUNT++
	done

	# Cleanup
	rm -rf ${TFIFO}
}

local_test $@
