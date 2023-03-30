#!/bin/bash

CarSoup() {
	local IMAGE_NAME=carsoup

	if make --question
	then
		docker run -it ${IMAGE_NAME} python car.py $@
	else
		make && docker run -it ${IMAGE_NAME} python car.py $@
	fi
}

CarSoup $@
