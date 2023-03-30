IMAGE_NAME=carsoup
DEPS=Dockerfile app/car.py app/requirements.txt

.PHONY: all
all: .image_build

.image_build: $(DEPS)
	docker build -t $(IMAGE_NAME) .
	touch .image_build
