#!/bin/bash

car() {
	local IMAGE_NAME=python/car

	#TODO: Only rebuild when needed (use timestamps/Makefile)
	#docker build -t ${IMAGE_NAME} .

	docker run -it ${IMAGE_NAME} python car.py $@
}

car $@
