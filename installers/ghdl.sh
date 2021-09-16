#!/bin/bash
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '

choice() {
  while true; do
    read -p "Do you wish to install this program? " yn
    case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
                * ) echo "Please answer yes or no.";;
    esac
  done
}

ghdl_req() {
  set -x
  sudo apt update
  sudo apt install -y \
    git \
    make \
    gnat \
    zlib1g-dev \
    gtkwave
  set +x
}

ghdl_install() {
  set -x
  cd /tmp
  git clone https://github.com/ghdl/ghdl
  cd ghdl
  ./configure --prefix=/usr/local
  make
  sudo make install
  echo "$0: All done!"
  set +x
}

choice
ghdl_req
ghdl_install
