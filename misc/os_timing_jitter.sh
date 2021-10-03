#!/bin/bash

delta_t() {
	[ $# -ne 2 ] && return 1
	local T1=$(date '+%s%N' --date="$1")
	local T2=$(date '+%s%N' --date="$2")
	bc -l <<< "( ${T2} - ${T1} ) / 10^9"
}

local_test() {
	[ $# -ne 1 ] && return 1
	local NUM_SAMPLES=${1}
	local TEST_OUT_FILE=/tmp/local_test.csv

	rm -f ${TEST_OUT_FILE}
	local COUNT=0
	while [ ${COUNT} -lt ${NUM_SAMPLES} ]
	do
		T1=$(date +'%T.%N')
		T2=$(date +'%T.%N')
		delta_t ${T1} ${T2} >> ${TEST_OUT_FILE}
		let COUNT++
	done
}

local_test $@
