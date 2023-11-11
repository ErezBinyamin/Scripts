#!/bin/bash
# https://linux.how2shout.com/how-to-install-qemu-kvm-on-ubuntu-22-04-20-04-lts/
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

install_qemu() {
	# Install QEMU
	sudo apt update && sudo apt upgrade
	egrep -c '(vmx|svm)' /proc/cpuinfo
	grep -E --color '(vmx|svm)' /proc/cpuinfo
	sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon
	sudo systemctl enable --now libvirtd
	sudo apt install virt-manager -y
}

install_qemu $@
