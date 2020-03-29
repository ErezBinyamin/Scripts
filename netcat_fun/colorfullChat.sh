#!/bin/bash
# For more colors: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# Based upon post: https://stackoverflow.com/questions/60876170/colorfull-netcat-chat

NO_COLOR="\x1b\[0m"      # Uncolored
SERVER_COLOR="\x1b\[31m" # Red
CLIENT_COLOR="\x1b\[32m" # Green
PORT=1234		 # Port to listen on

# Start Chat
printf "\nThis machines ip:\t$(hostname -I | sed 's/ .*//')"
printf "\nListening on port:\t${PORT}"
printf "\n--------------------------\n"
sed -u "s/^/${SERVER_COLOR}/g; s/$/${NO_COLOR}/g" | nc -l ${PORT} | sed "s/^/${CLIENT_COLOR}/g; s/$/${SERVER_COLOR}/g"
