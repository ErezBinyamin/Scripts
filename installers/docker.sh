#!/bin/bash
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

install_docker() {
	# Install Docker
	if ! which docker &>/dev/null
	then
		# Set up the repository
		## 1. Update the apt package index and install packages to allow apt to use a repository over HTTPS:
		sudo apt update
		sudo apt-get install \
			ca-certificates \
			curl \
			gnupg \
			lsb-release
		## 2. 
		sudo mkdir -m 0755 -p /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
		## 3. Use the following command to set up the repository:
		echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

		# Grant read permission for the Docker public key file before updating the package index:
		sudo chmod a+r /etc/apt/keyrings/docker.gpg

		# Install Docker Engine
		## 1. Update the apt package index:
		sudo apt-get update
		## 2. Install Docker Engine, containerd, and Docker Compose.
		sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

		# Post install https://docs.docker.com/engine/install/linux-postinstall/
		## 1. Create the docker group.
		sudo groupadd docker
		## 2. Add your user to the docker group.
		sudo usermod -aG docker $USER
		## 3. run the following command to activate the changes to groups:
		newgrp docker
		## 4. change its ownership and permissions using the following commands:
		sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
		sudo chmod g+rwx "$HOME/.docker" -R
		# Configure Docker to start on boot with systemd https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot-with-systemd
		sudo systemctl enable docker.service
		sudo systemctl enable containerd.service
	else
		echo [COMPLETE] docker installed!
	fi

	# Docker images
	# DOCKER_IMAGES=()
	# DOCKER_IMAGES+=("frolvlad/alpine-python2")
	# DOCKER_IMAGES+=("frolvlad/alpine-python3")
	# for dimage in ${DOCKER_IMAGES[$@]}
	# do
	# 	[[ "$(docker images -q ${dimage} 2> /dev/null)" == "" ]] && docker pull frolvlad/alpine-python2 || echo [COMPLETE] ${dimage}
	# done


}

install_docker $@
