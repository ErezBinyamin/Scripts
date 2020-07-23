#!/bin/bash
bootstrap() {
	# Update, upgrade, autoremove
	sudo apt update
	sudo apt dist-upgrade
	sudo apt autoremove

	# Standard packages
	PACKAGES=()
	PACKAGES+=("ubuntu-restricted-extras")
	PACKAGES+=("gnome-tweaks")
	PACKAGES+=("laptop-mode-tools")
	PACKAGES+=("curl")
	PACKAGES+=("git")
	PACKAGES+=("vim")
	PACKAGES+=("xclip")
	for pkg in ${PACKAGES[@]}
	do
		dpkg -s $pkg &>/dev/null || sudo apt install -y ${pkg} && echo [COMPLETE] ${pkg}
	done

	# Snap install
	PACKAGES=()
	PACKAGES+=("vlc")
	for pkg in ${PACKAGES[@]}
	do
		snap list | grep $pkg &>/dev/null || sudo snap install -y ${pkg} && echo [COMPLETE] ${pkg}
	done

	# Install virtual tools
	PACKAGES=()
	PACKAGES+=("qemu-kvm")
	PACKAGES+=("libvirt-clients")
	PACKAGES+=("libvirt-daemon-system")
	PACKAGES+=("bridge-utils")
	PACKAGES+=("virt-manager")
	for pkg in ${PACKAGES[@]}
	do
		dpkg -s $pkg &>/dev/null || sudo apt install -y ${pkg} && echo [COMPLETE] ${pkg}
	done

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

	# Docker images
	DOCKER_IMAGES=()
	DOCKER_IMAGES+=("frolvlad/alpine-python2")
	DOCKER_IMAGES+=("frolvlad/alpine-python3")
	DOCKER_IMAGES+=("schickling/latex")
	for dimage in ${DOCKER_IMAGES[$@]}
	do
		[[ "$(docker images -q ${dimage} 2> /dev/null)" == "" ]] && docker pull frolvlad/alpine-python2 || echo [COMPLETE] ${dimage}
	done
}

bootstrap $@
