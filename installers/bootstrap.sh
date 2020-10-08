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
	PACKAGES+=("aria2")
	PACKAGES+=("git")
	PACKAGES+=("vim")
	PACKAGES+=("xclip")
	PACKAGES+=("kolourpaint")
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

	bash docker.sh
}

bootstrap $@
