# Control inputs and outputs
INPUT=example.yaml
OUTPUT=example.png

IMAGE_NAME=local/wireviz

all: 
	docker build -t ${IMAGE_NAME} .
	docker run -it -v ${PWD}:/tmp ${IMAGE_NAME} wireviz /tmp/${INPUT}

show: all
	xdg-open ${OUTPUT}

clean:
	rm -f *.png
	rm -f *.tsv
	rm -f *.gv
	rm -f *.html
	rm -f *.svg

