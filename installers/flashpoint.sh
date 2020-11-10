#!/bin/bash
# Tutorial Source: https://bluemaxima.org/flashpoint/datahub/Linux_Support
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

# Config
TMP='~/Downloads/flashpoint_install'
FPBASE='~/fpbase/Data/Platforms'
mkdir -p ${DOWNLOAD}
mkdir -p ${FPBASE}

# Download launcher
cd ${DOWNLOAD}
aria2c -x 16 'https://bluepload.unstable.life/flashpoint-bin.deb/torrent'
mv torrent flashpoint.torrent
aria2c --seed-time 0 -V flashpoint.torrent
printf "

	Need root password to install flashpoint-bin package...

"
sudo apt install -f ./flashpoint-bin.deb

# Launch launcher
cd ${FPBASE}
flashpoint
