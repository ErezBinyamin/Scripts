#!/bin/bash
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

bootstrap() {
	# Update, upgrade, autoremove
	sudo apt-get --yes update
	sudo apt-get --yes dist-upgrade
	sudo apt-get --yes autoremove

	# Standard packages
	PACKAGES=()

	# Meta-Packages
	PACKAGES+=("net-tools" "build-essential" "xz-utils")

	# Developer tools
	PACKAGES+=("vim" "git" "git-lfs" "gcc" "make" "llvm")
	PACKAGES+=("git-core" "zlib1g-dev" "libbz2-dev" "libreadline-dev" "libsqlite3-dev" "libssl-dev" "libncurses5-dev" "libncursesw5-dev" "tk-dev" "libffi-dev" "liblzma-dev" "python-openssl")

	# OS UX customization
	PACKAGES+=("gnome-tweaks" "laptop-mode-tools")

	# Good cli software
	PACKAGES+=("xclip" "wget" "curl" "htop")

	# Good gui software
	PACKAGES+=("vlc" "usb-creator-gtk" "brave-browser")

	# Do the installation
	for pkg in ${PACKAGES[@]}
	do
		dpkg -s $pkg &>/dev/null || sudo apt install --yes ${pkg} && echo [COMPLETE] ${pkg}
	done
}

bootstrap $@
