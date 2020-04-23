#!/bin/bash
# @param  int  : g number to test as a generator
# @param  int  : p prime field to test g in
# @return bool : is g a generator for Zp
isGen() {
	g=$1
	p=$2

	val=1
	count=1
	for i in `seq 1 $(( ${p}-1 ))`
	do
		val=$(( ($val * $g) % $p))
		[ $val -eq 1 ] && break
		let count++
	done
	[ $count -eq $(( $p-1 )) ] && return 0 || return 1
}

# Proof through exhaustion:
# Find all generators for a given prime group <p>
allGen() {
	[ ! -z ${1+x} ] || echo "USAGE: $0 <PRIME>"
	p=$1
	# Test numbers from 2 -> p-1
	for g in `seq 2 $(($p - 1))`
	do
		isGen $g $p && echo "$g is a generator for ℤ-${p}"
	done
}
