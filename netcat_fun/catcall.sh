#!/bin/bash
# Best when catcall_connect is run FIRST in a while loop on a client machine
# SECOND catcatll_host should be run on a server machine
catcall_host() {
	PORT=${1}
	arecord | nc -l ${PORT} | aplay 2>/dev/null
}

catcall_connect() {
	IP_ADDR=${1}
	PORT=${2}
	arecord | nc ${IP_ADDR} ${PORT} | aplay 2>/dev/null
}
