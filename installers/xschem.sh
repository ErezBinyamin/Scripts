#!/bin/bash
# http://repo.hu/projects/xschem/xschem_man/tutorial_install_xschem.html
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '

xschem_uninstall() {
	set -x
	sudo rm -rf /usr/local/share/xschem/ /usr/local/share/doc/xschem/
	rm -f  ~/xschemrc ~/.xschem/xschemrc /usr/local/bin/xschem
	rm -rf /tmp/xschem_install
	set +x
}

xschem_requirements() {
	set -x
	sudo apt install subversion \
                 tcl8.6 \
                 libx11-dev \
                 tk8.6 \
                 libxpm-dev \
                 tcl8.6-dev \
                 bison \
                 tk8.6-dev \
                 flex \
                 gawk \
                 libcairo2-dev
	set +x
}

xschem_install() {
	set -x
	mkdir -p /tmp/xschem_install
	cd /tmp/xschem_install
	mkdir build
	cd build
	svn checkout svn://repo.hu/xschem/trunk

	cd trunk
	./configure --prefix=/usr/local --user-conf-dir=~/.xschem \
	  --user-lib-path=~/share/xschem/xschem_library \
	  --sys-lib-path=/usr/local/share/xschem/xschem_library
	make
	sudo make install

	cp src/xschemrc ~/.xschem
	set +x
}

# If already installed
if which xschem &>/dev/null
then
	while [[ ${C^^} != "Y" && ${C^^} != "N" ]]
	do
		read -p "xschem already installed. Uninstall xschem? [Y|N]" -sn1 C
	done
	[[ ${C^^} == "Y" ]] && xschem_uninstall
	unset C
fi

while [[ ${C^^} != "Y" && ${C^^} != "N" ]]
do
	read -p "Install xschem? [Y|N]" -sn1 C
done
if [[ ${C^^} == "Y" ]]
then
	unset C
	xschem_requirements
	xschem_install
fi
