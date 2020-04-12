#!/bin/bash
# For more colors: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# Based upon post: https://stackoverflow.com/questions/60876170/colorfull-netcat-chat
sed -u "s/^/\x1b\[31m/g; s/$/\x1b\[0m/g" | nc -l ${1} | sed "s/^/\x1b\[0m/g; s/$/\x1b\[31m/g"
