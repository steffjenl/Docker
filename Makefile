update-dependencies:
	docker pull curlimages/curl:latest
	docker pull postgres:16.3-alpine

compose-build:
	docker compose build

compose-up:
	docker compose up

build:
	docker build -t cachet/docker .
