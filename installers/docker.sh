#!/bin/bash
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

install_docker() {
	# Install Docker
	if which docker &>/dev/null
	then
		echo [COMPLETE] docker already installed!
	else
		pushd "${PWD}"
		cd /tmp

		# 1. download the script
		curl -fsSL https://get.docker.com -o install-docker.sh

		# 2. verify the script's content
		#cat install-docker.sh

		# 3. run the script with --dry-run to verify the steps it executes
		sh install-docker.sh --dry-run

		# 4. run the script either as root, or using sudo to perform the installation.
		sudo sh install-docker.sh

		# linux-postinstall: https://docs.docker.com/engine/install/linux-postinstall/
		# Manage Docker as a non-root user
		sudo groupadd docker
		sudo usermod -aG docker $USER
		newgrp docker
		docker run hello-world

		# Configure Docker to start on boot with systemd
		sudo systemctl enable docker.service; sleep 2
		sudo systemctl enable containerd.service; sleep 2
		sudo systemctl disable docker.service; sleep 2
		sudo systemctl disable containerd.service

		echo [COMPLETE] docker installed!
		popd
	fi

	# Docker images
	# DOCKER_IMAGES=()
	# DOCKER_IMAGES+=("pihole/pihole")
	# DOCKER_IMAGES+=("bettercap/bettercap")
	# DOCKER_IMAGES+=("frolvlad/alpine-python2")
	# DOCKER_IMAGES+=("frolvlad/alpine-python3")
	# for dimage in ${DOCKER_IMAGES[$@]}
	# do
	# 	[[ "$(docker images -q ${dimage} 2> /dev/null)" == "" ]] && docker pull "${diamge}" || echo "[COMPLETE] ${dimage}"
	# done
}

install_docker $@
