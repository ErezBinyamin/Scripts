#!/bin/bash
# 1. Run catcall_connect <IP> <PORT> on CLIENT
# 2. Run catcall_host <PORT> on SERVER

# 7 bash commands. One line of code. Really 3 bash commands though.
[ $# -eq 1 ] && \
	ffmpeg \
		-f alsa -i hw:1 \
		-acodec flac \
		-f matroska \
		-f video4linux2 -i /dev/video0 \
		-vcodec mpeg4 \
		-f matroska \
		-tune zerolatency -y /dev/stdout \
		2>/dev/null | nc -l ${1} | mplayer - &>/dev/null \
||	ffmpeg \
		-f alsa -i hw:1 \
		-acodec flac \
		-f matroska \
		-f video4linux2 -i /dev/video0 \
		-vcodec mpeg4 \
		-f matroska \
		-tune zerolatency -y /dev/stdout \
		2>/dev/null | nc ${1} ${2} | mplayer - &>/dev/null
