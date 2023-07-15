#!/bin/bash
# From: https://superuser.com/questions/925268/how-to-netcat-all-the-files-in-my-directory
ncdir() (
  usage() {
    printf 'ncdir: transfer directories using netcat:
  transmit:
    ncdir [dir] [port]        -----> + 
    ncdir [dir] [host] [port] -> +   |
                                 |   |
  recieve:                       |   |
    ncdir [port]              <--+   |
    ncdir [host] [port]       <------+
'
  }
  case $# in
    1)
      [[ ! $1 =~ ^[0-9]+$ ]] && usage && return 1
      nc -l $1 | tar xvzf -
      ;;
    2)
      [[ ! $2 =~ ^[0-9]+$ ]] && usage && return 1
      if [ -e "${1}" ]
      then
        tar cvfz - "${1}" | nc -l $2
      else
        nc "${1}" $2 | tar xvzf -
      fi
      ;;
    3)
      [[ ! $3 =~ ^[0-9]+$ || ! -e "${1}" ]] && usage && return 1
      tar cvfz - "${1}" | nc "${2}" $3
      ;;
    *)
      usage
  esac
)
