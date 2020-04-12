#!/bin/bash
# Source this script to gain access to the 'server' and 'sendMsg' functions
# Dont forget to put the '&' at the end !!
# SERVER  USAGE: server <PORT> &
# sendMSG USAGE: sendMSG <USERNAME> <MESSAGE> <IP> <PORT>

# 17 bash commands. 7 lines of code
server() {
	printf "HTTP/1.1 200 OK\n\n<!doctype html><h1>Erez's netcat chat server!!</h1><form>Username:<br><input name=\"username\"><br>Message:<br><input name=\"message\"><div><button>Send data</button></div></form>" > /tmp/webpage
	while [ 1 ]
	do [[ $(head -1 /tmp/response) =~ "GET /?username" ]] && USER=$(head -1 /tmp/response | sed 's@.*username=@@; s@&message.*@@') && MSG=$(head -1 /tmp/response | sed 's@.*message=@@; s@HTTP.*@@')
		[ ${#USER} -gt 1 ] && [ ${#MSG} -gt 1 ] && [ ${#USER} -lt 30 ] && [ ${#MSG} -lt 280 ] && tee -a <<<"<h3>${USER}:    ${MSG}<br>" /tmp/webpage | sed 's/<br>//; s/<h3>/\n/'
		unset USER && unset MSG
		cat /tmp/webpage | timeout 10 nc -q 0 -l $1 > /tmp/response
	done
}

sendMsg(){
	# Check for valid MESSAGE
	if [ ! -z ${1+x} ] && [ ${#1} -gt 0 ]
	then
		MESSAGE=$1
	else
		MESSAGE="Hello, World!"
	fi
	# Check for valid USERNAME
	if [ ! -z ${2+x} ] && [ ${#2} -gt 0 ]
	then
		USERNAME=$2
	else
		USERNAME="$USER"
	fi
	# Check for valid HOST IP address
	if [ ! -z ${3+x} ] && [ ${#3} -gt 6 ]
	then
		HOST=$3
	else
		HOST="localhost"
	fi
	# Check for valid PORT
	if [ ! -z ${4+x} ] && [ $4 -gt 1023 ] && [ $4 -lt 65535 ]
	then
		PORT=$4
	else
		PORT="1234"
	fi
	printf 'GET /?username=%s&message=%s' "${USERNAME}" "${MESSAGE}" | nc $HOST $PORT
}


printf '
 You now have access to the "server" and "sendMSG" functions!

 SERVER  USAGE: server <PORT> &
 sendMSG USAGE: sendMSG <MESSAGE> <USERNAME> <IP> <PORT>

 Kill the server with a simple "kill $!" 
'
echo " "
