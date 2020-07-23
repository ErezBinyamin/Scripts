#!/bin/bash

# Download current ghidra version
BASE_URL='https://ghidra-sre.org'
GDRA_ZIP=$(curl "${BASE_URL}" 2>/dev/null | grep -i download | grep -o 'href=".*\.zip' |sed 's/href="//')
if [ ! -f ${GDRA_ZIP} ]
then
	wget ${BASE_URL}/${GDRA_ZIP}
	unzip ${GDRA_ZIP}
else
	echo "Ghidra latest version already installed!"
fi

# Install Java jdk and jre
if ! dpkg -s openjdk-11-jdk &>/dev/null
then
	sudo add-apt-repository ppa:openjdk-r/ppa
	sudo apt update
	sudo apt install -y openjdk-11-jdk \
			openjdk-11-jre-headless
else
	echo "OpenJDK 11 latest version already installed!"
fi

echo "${GDRA_ZIP} and OpenJDK 11 installed and ready to go!"
