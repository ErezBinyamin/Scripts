#!/bin/bash
# https://gqrx.dk/download/install-ubuntu
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

sudo apt-get purge --auto-remove gqrx
sudo apt-get purge --auto-remove gqrx-sdr
sudo apt-get purge --auto-remove libgnuradio*

sudo add-apt-repository -y ppa:bladerf/bladerf
sudo add-apt-repository -y ppa:myriadrf/drivers
sudo add-apt-repository -y ppa:myriadrf/gnuradio
sudo add-apt-repository -y ppa:gqrx/gqrx-sdr
sudo apt-get update

sudo apt-get install gqrx-sdr

sudo apt-get install libvolk1-bin
volk_profile
