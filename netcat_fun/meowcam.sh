#!/bin/bash
meowcam_send() {
	IP_ADDR=${1}
	PORT=${2}
	ffmpeg -f video4linux2  -i /dev/video0 -vcodec libx264 -b 1000k -f matroska -y /dev/stdout | nc ${IP_ADDR} ${PORT}
}

meowcam_recv() {
	PORT=${1}
	nc -l ${PORT} | vlc -
}
