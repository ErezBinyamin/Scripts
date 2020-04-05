#!/bin/bash
# 1. Run catcall_connect <IP> <PORT> in a while loop on CLIENT
# 2. Run catcall_host <PORT> on server
catcall_host() {
	PORT=${1}
	arecord 2>/dev/null | nc -l ${PORT} | aplay &>/dev/null &
	let PORT++
	ffmpeg -f video4linux2  -i /dev/video0 -vcodec libx264 -b 1000k -f matroska -y /dev/stdout 2>/dev/null | nc -l ${PORT} | mplayer - &>/dev/null
}

catcall_connect() {
	IP_ADDR=${1}
	PORT=${2}
	arecord 2>/dev/null | nc ${IP_ADDR} ${PORT} | aplay &>/dev/null &
	let PORT++
	ffmpeg -f video4linux2  -i /dev/video0 -vcodec libx264 -b 1000k -f matroska -y /dev/stdout 2>/dev/null | nc ${IP_ADDR} ${PORT} | stdbuf -i0 mplayer - &>/dev/null
}
