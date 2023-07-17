#!/bin/bash

# Dependency check
PACKAGES=()
PACKAGES+=("nc")
PACKAGES+=("ffmpeg")
PACKAGES+=("mplayer")
for pkg in ${PACKAGES[@]}
do
  if ! dpkg -S $pkg &>/dev/null && ! which $pkg &>/dev/null
  then
    echo [ERROR] MissingPackage: ${pkg}
    exit 1
  fi
done

catcall() (
  usage() {
      printf "Host Usage: catcall <PORT>\nClient usage: catcall <IP_ADDR> <PORT>\n"
  }
  portAvail() {
    netstat -awlpunt 2>/dev/null | grep -Eo ':[0-9]+ ' | tr -d ':' | sort -un | grep --quiet "${1}" && return 1 || return 0
  }
  local IP_ADDR PORT TRY NCCMD
  case $# in
    1)
      if [[ ! ${1} =~ ^[0-9]+$ ]] || ! portAvail ${1}
      then
        usage && return 1
      fi
      PORT=${1}
      nc -l ${PORT}
      NCCMD="nc -l $((++PORT))"
      ;;
    2)
      [[ ! ${2} =~ ^[0-9]+$ ]] && usage && return 1
      IP_ADDR=${1}
      PORT=${2}
      printf "\nAwaiting ${IP_ADDR}:${PORT} to advertise connection:\n"
      while ! nc -dz ${IP_ADDR} ${PORT} &>/dev/null
      do
      	[ $TRY -eq 0 ] && printf '.'
      	TRY=$(((TRY + 1) % 2))
        sleep 1
      done
      printf '\nCONNECTION ACHIEVED!\n'
      NCCMD="nc ${IP_ADDR} $((++PORT))"
      ;;
    *)
      usage
      return 1
      ;;
  esac
  ffmpeg \
    -f alsa -i hw:1 \
    -acodec flac \
    -f matroska \
    -f video4linux2 -i /dev/video0 \
    -vcodec mpeg4 \
    -f matroska \
    -tune zerolatency -y /dev/stdout \
    2>/dev/null | ${NCCMD} | mplayer -
)

