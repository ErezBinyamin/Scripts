#!/bin/bash
# From: https://github.com/NationalSecurityAgency/ghidra#download-additional-build-dependencies-into-source-repository
export PS4='\033[0;33m$0:$LINENO [$?]+ \033[0m '
set -x

# TODO: Conditionally install gradle

# Download from GitHub
git clone https://github.com/NationalSecurityAgency/ghidra.git
# Download additional build dependencies into source repository:
cd ghidra
gradle -I gradle/support/fetchDependencies.gradle init
# Create development build:
gradle buildGhidra

set +x
