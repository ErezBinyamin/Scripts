IMAGE_NAME=cyber
DEPS=Dockerfile

.PHONY: all
all: .image_build
.image_build: $(DEPS)
	docker build -t $(IMAGE_NAME) .
	touch .image_build

bash: all
	docker run -it --network host --privileged $(IMAGE_NAME)
