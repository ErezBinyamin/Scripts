#!/bin/bash

car() {
	local IMAGE_NAME=python/car
	docker build -t ${IMAGE_NAME} .
	docker run -it ${IMAGE_NAME} python car.py $@
}

car $@
