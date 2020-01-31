#!/bin/bash
# https://www.advancedclustering.com/act_kb/installing-nvidia-drivers-rhel-centos-7/

step_0() {
	printf 'Prepare your machine\n'
	yum -y update
	yum -y groupinstall "GNOME Desktop" "Development Tools"
	yum -y install kernel-devel
}

step_1() {
	read -p "In order to have the NVIDIA drivers rebuilt automatically with future kernel updates you can also install the EPEL repository and the DKMS package. This is optional. Install? [Y/N]: " -sn1 CHOICE
	if [ ${CHOICE^^} == 'Y' ]
	then
		yum -y install epel-release
		yum -y install dkms
	fi
	printf '\n\nReboot your machine to make sure you are running the newest kernel\n'
}

step_2() {
	printf 'Edit /etc/default/grub Append the following to "GRUB_CMDLINE_LINUX":
	\trd.driver.blacklist=nouveau nouveau.modeset=0\n'
	sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="rd.driver.blacklist=nouveau nouveau.modeset=0 /' /etc/default/grub

	printf 'Generate a new grub configuration to include the above changes.\n'
	grub2-mkconfig -o /boot/grub2/grub.cfg

	printf 'Edit/create /etc/modprobe.d/blacklist.conf and append:
	blacklist nouveau\n'
	echo 'blacklist nouveau' > /etc/modprobe.d/blacklist.conf

	printf 'Backup your old initramfs and then build a new one\n'
	mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img
	dracut /boot/initramfs-$(uname -r).img $(uname -r)

	printf 'Reboot your machine\n'
}

step_3() {
	printf '\nDownloading NVIDIA-Linux-x86_64-440.44.run\n'
	wget 'http://us.download.nvidia.com/XFree86/Linux-x86_64/440.44/NVIDIA-Linux-x86_64-440.44.run'

	printf '\nThe NVIDIA installer will not run while X is running so switch to text mode:\n'
	systemctl set-default multi-user.target

	printf '\nRun the NVIDIA driver installer and enter yes to all options.\n'
	sh NVIDIA-Linux-x86_64-*.run

	printf '\nReboot your machine\n'
}

step_4() {
	printf 'Downloading cuda_10.2.89_440.33.01_linux.run'
	wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run

	printf 'Run the CUDA installer.\n\n'
	printf 'Say no to installing the NVIDIA driver. The standalone driver you already installed is typically newer than what is packaged with CUDA. Use the default option for all other choices.'
	printf '\n\nSetting up ...'
	sleep 2
	sh cuda_*.run

	printf 'Create /etc/profile.d/cuda.sh\n'
	touch /etc/profile.d/cuda.sh
	PATH=$PATH:/usr/local/cuda/bin
	export PATH

	printf 'Create /etc/profile.d/cuda.csh\n'
	touch /etc/profile.d/cuda.csh
	set path = "$path /usr/local/cuda/bin"

	printf 'Create /etc/ld.so.conf.d/cuda.conf\n'
	touch /etc/ld.so.conf.d/cuda.conf
	/usr/local/cuda/lib64

	systemctl set-default graphical.target
}

usage() {
	echo "USAGE $0 <step number>"
	printf "\nSTEPS:
			0:	Basic package update and install
			1:	Optional: Future-proofing step
			2:	Blacklist nouveau
			3:	Run Nvidia driver installer (runfile)
			4:	Optional: Install NVIDIA's CUDA Toolkit
	"
	echo " "
}
# -- MAIN --
main() {
	if [ "$EUID" -ne 0 ]
	then
		echo "Please run as root"
		return 1
	fi

	[ -z ${1+x} ] && usage && return 1

	case "$1" in
	"0")
		read -p "Basic package update and install. Continue? [Y/N]" read -sn1 CHOICE
		[ ${CHOICE^^} == 'N' ] && return 0
		step_0
		;;
	"1")
		read -p "Optional: Future-proofing step. Continue? [Y/N]" read -sn1 CHOICE
		[ ${CHOICE^^} == 'N' ] && return 0
		step_1
		;;
	"2")
		read -p "Blacklist nouveau. Continue? [Y/N]" read -sn1 CHOICE
		[ ${CHOICE^^} == 'N' ] && return 0
		step_2
		;;
	"3")
		read -p "Run Nvidia driver installer (runfile). Continue? [Y/N]" read -sn1 CHOICE
		[ ${CHOICE^^} == 'N' ] && return 0
		step_3
		;;
	"4")
		read -p "Optional: Install NVIDIA's CUDA Toolkit. Continue? [Y/N]" read -sn1 CHOICE
		[ ${CHOICE^^} == 'N' ] && return 0
		step_4
		;;
	"a" | "A")
		read -p "Complete all steps in super-fast dont care MODE? [Y/N]" read -sn1 CHOICE
		[ ${CHOICE^^} == 'N' ] && return 0
		step_0
		step_1
		step_2
		step_3
		step_4
		;;
	*)
		usage
		return 1
		;;
	esac

	echo "Completed step $1 !! Reboot machine and run next step to continue installation."
}

main $@
