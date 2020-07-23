#!/bin/bash

install_docker() {
	# Install Docker
	# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
	if docker -v &>/dev/null
	then
		sudo apt install -y \
			sudo apt-transport-https \
			ca-certificates \
			curl \
			gnupg-agent \
			software-properties-common
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo sudo apt-key add -
		sudo apt-key fingerprint 0EBFCD88
		add-apt-repository \
			"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
			$(lsb_release -cs) \
			stable"
		sudo apt update
		sudo apt install -y docker-ce \
			docker-ce-cli \
			containerd.io
		sudo apt-cache madison docker-ce
	else
		echo [COMPLETE] docker
	fi
	return 0
}

install_docker $@
