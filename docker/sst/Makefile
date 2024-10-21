IMGAGE=sst
DEPS=Dockerfile

.PHONY: all
all: .image_build
.image_build: $(DEPS)
	docker build -t $(IMGAGE) .
	touch .image_build

bash: all
	docker run -it $(IMGAGE)

clean:
	docker image rm $(IMGAGE)
	rm -f .image_build
