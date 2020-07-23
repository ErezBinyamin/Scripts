#!/bin/bash
bootstrap() {
	# Verify root user
	if [ $EUID -ne 0 ]
	then
		echo "sudo $0"
		return 1
	fi

	# Update, upgrade, autoremove
	apt update
	apt dist-upgrade
	apt autoremove

	# Standard packages
	apt install -y ubuntu-restricted-extras \
			gnome-tweaks \
			laptop-mode-tools \
			curl \
			git

	# Snap install
	snap install vlc

	# Install Docker
	# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
	apt install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	apt-key fingerprint 0EBFCD88
	add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"
	apt update
	apt install -y docker-ce \
		docker-ce-cli \
		containerd.io
	apt-cache madison docker-ce

	# Install virtual tools
	apt install -y \
		qemu-kvm \
		libvirt-clients \
		libvirt-daemon-system \
		bridge-utils \
		virt-manager
}

bootstrap $@
