
run: build
	docker run -v /var/run/docker.sock:/var/run/docker.sock -ti cws

build:
	docker build -t cws .


