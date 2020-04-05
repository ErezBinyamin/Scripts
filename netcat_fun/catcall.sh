#!/bin/bash
# 1. Run catcall_connect <IP> <PORT> on CLIENT
# 2. Run catcall_host <PORT> on SERVER

# Server will advertise on PORT
# Serve audio on PORT+1
# Serve video on PORT+2
catcall_host() (
	local PORT=${1}
	nc -l ${PORT} &
	let PORT++
	arecord 2>/dev/null | nc -l ${PORT} 2>/dev/null | aplay &>/dev/null &
	let PORT++
	ffmpeg -f video4linux2  -i /dev/video0 -vcodec libx264 -b 1000k -f matroska -y /dev/stdout 2>/dev/null | nc -l ${PORT} | mplayer - &>/dev/null
)

# When server advertise PORT is up, connect audio and video
catcall_connect() {
	local IP_ADDR=${1}
	local PORT=${2}
	local TRY=0
	printf "\nAwaiting ${IP_ADDR}:${PORT} to advertise connection:\n"
	while ! nc -dzW 1 ${IP_ADDR} ${PORT} &>/dev/null
	do
		[ $TRY -eq 0 ] && printf '.'
		TRY=$(((TRY + 1) % 100))
	done
	printf '\nCONNECTION ACHIEVED!\n'
	let PORT++
	arecord 2>/dev/null | nc ${IP_ADDR} ${PORT} 2>/dev/null | aplay &>/dev/null &
	let PORT++
	ffmpeg -f video4linux2  -i /dev/video0 -vcodec libx264 -b 1000k -f matroska -y /dev/stdout 2>/dev/null | nc ${IP_ADDR} ${PORT} | stdbuf -i0 mplayer - &>/dev/null
}
