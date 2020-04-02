#!/bin/bash
# Best when meowcam_send is run FIRST in a while loop on a server machine
# SECOND meowcam_recv should be run on a server machine
meowcam_send() {
	IP_ADDR=${1}
	PORT=${2}
	ffmpeg -f video4linux2  -i /dev/video0 -vcodec libx264 -b 1000k -f matroska -y /dev/stdout 2>/dev/null | nc ${IP_ADDR} ${PORT} | stdbuf -i0 mplayer - &>/dev/null
}

meowcam_recv() {
	PORT=${1}
	ffmpeg -f video4linux2  -i /dev/video0 -vcodec libx264 -b 1000k -f matroska -y /dev/stdout 2>/dev/null | nc -l ${PORT} | mplayer - &>/dev/null
}
