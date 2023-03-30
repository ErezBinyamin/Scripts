#!/bin/bash
ROUTER_IP=${1:-_gateway}
INTERFACE_NAME=$(ip route get 8.8.8.8 | sed -nr 's/.*dev ([^\ ]+).*/\1/p')
docker run --restart='unless-stopped' --net=host -it -e ROUTER_IP=${ROUTER_IP} -e INTERFACE_NAME=$INTERFACE_NAME techblog/arpspoof-docker
