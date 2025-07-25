compose-build:
	docker compose build

compose-up:
	docker compose up -d

build:
	docker build -t cachet/docker .
