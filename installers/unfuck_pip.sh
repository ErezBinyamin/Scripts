#!/bin/bash
# https://github.com/pypa/pip/issues/5495
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

pip3 freeze | xargs pip3 uninstall -y
pip3 freeze | grep -v "^-e" | xargs pip3 uninstall -y

pip3 freeze | xargs sudo pip3 uninstall -y
pip3 freeze | grep -v "^-e" | xargs sudo pip3 uninstall -y

sudo apt remove --purge -y python3-pip
sudo apt install -y python3-pip

#sudo apt install --reinstall python3-pip
#pip3 install --upgrade --user pip3
