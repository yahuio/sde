
run: build
	docker run -v /var/run/docker.sock:/var/run/docker.sock -ti yahu.io/rde

build:
	docker build -t yahu.io/rde .
