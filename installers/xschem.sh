#!/bin/bash
# http://repo.hu/projects/xschem/xschem_man/tutorial_install_xschem.html
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

# Pre-requisites
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


sudo rm -rf /usr/local/share/xschem/ /usr/local/share/doc/xschem/
rm -f  ~/xschemrc ~/.xschem/xschemrc
rm -rf /tmp/xschem_install

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
