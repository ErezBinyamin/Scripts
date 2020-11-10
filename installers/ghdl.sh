#!/bin/bash
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

sudo apt update
sudo apt install -y \
  git \
  make \
  gnat \
  zlib1g-dev

git clone https://github.com/ghdl/ghdl
cd ghdl
./configure --prefix=/usr/local
make
sudo make install
echo "$0: All done!"

sudo apt install gtkwave
