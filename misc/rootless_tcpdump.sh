#!/bin/bash
# Source: https://askubuntu.com/questions/530920/tcpdump-permissions-problem
# Give tcpdump the permission and capability to allow raw packet captures and network interface manipulation.

rootless_tcpdump() {
	local BIN=$(which tcpdump)
	local GROUP=pcap
	if [ ! -f $BIN ]
	then
		echo "FileNotFound: $BIN: Could not find tcpdump binary!"
		return 1
	fi

	set -x
	# Add a capture group and add yourself to it:
	sudo groupadd ${GROUP}
	set -e
	sudo usermod --append --groups ${GROUP} ${USER}

	# Next, change the group of tcpdump and set permissions:
	sudo chgrp ${GROUP} ${BIN} 
	sudo chmod 750 ${BIN} 

	# Finally, use setcap to give tcpdump the necessary permissions:
	sudo setcap cap_net_raw,cap_net_admin=eip ${BIN}
	set +e
	set +x
}

rootless_tcpdump $@
