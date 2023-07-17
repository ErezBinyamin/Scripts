#!/bin/bash

# Check if software exists on your computer.
software_ok=0 # Zero good, one bad.
for software in nc ffmpeg mplayer; do
	which $software
	has=$?
	echo $has
	if [ $has -ne "0" ]; then
	 	echo "You need $software";
   		software_ok=1
	fi
done
if [ $software_ok -eq 1 ]; then
	exit 1
 fi

# 1. Run catcall_connect <IP> <PORT> on CLIENT
# 2. Run catcall_host <PORT> on SERVER

# Server will advertise on PORT
# Serve audio and video on PORT+1
catcall_host() (
	local PORT=${1}
	nc -l ${PORT} &
	let PORT++
	ffmpeg \
		-f alsa -i hw:1 \
		-acodec flac \
		-f matroska \
		-f video4linux2 -i /dev/video0 \
		-vcodec mpeg4 \
		-f matroska \
		-tune zerolatency -y /dev/stdout \
		2>/dev/null | nc -l ${PORT} | mplayer - &>/dev/null
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
	ffmpeg \
		-f alsa -i hw:1 \
		-acodec flac \
		-f matroska \
		-f video4linux2 -i /dev/video0 \
		-vcodec mpeg4 \
		-f matroska \
		-tune zerolatency -y /dev/stdout \
		2>/dev/null | nc ${IP_ADDR} ${PORT} | mplayer - &>/dev/null
}
