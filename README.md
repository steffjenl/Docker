# Cachet Docker Image

This is the official repository of the [Docker image](https://hub.docker.com/r/cachethq/docker/) for [Cachet](https://github.com/CachetHQ/Cachet).

[Cachet](https://github.com/CachetHQ/Cachet) is a beautiful and powerful open source status page system, a free replacement for services such as StatusPage.io, Status.io and others.

For full documentation, visit the [Installing Cachet with Docker](https://docs.cachethq.io/docs/get-started-with-docker) page.

# Supporting Cachet

Cachet is a MIT open source project. If you'd like to support future development, check out the [Cachet Patreon](https://patreon.com/jbrooksuk) campaign.

# Quickstart

1. Clone this repository

  ```shell
  git clone https://github.com/CachetHQ/Docker.git
  ```

2. Edit the docker-compose.yml file to specify your [ENV variables](/conf/.env.docker).


3. To build an image containing a specific Cachet release, set the [`cachet_ver` ARG in the docker-compose.yml](/docker-compose.yml)

  The *main* branch and *cachethq/docker:latest* Docker automated build are a work in progress / development version of the upstream https://github.com/CachetHQ/Cachet project. As such, *main* or *latest* should not be used in a production environment as it can change at anytime.

  We strongly recommend specifying a stable [Cachet Release](https://github.com/CachetHQ/Cachet/releases) at build time as mentioned above.

4. Build and run the image

  ```shell
  docker-compose build
  docker-compose up
  ```

5. `cachethq/docker`  runs on port 8000 by default. This is exposed on host port 80 when using docker-compose.


6. Setup the APP_KEY

Whilst the container is up and running, find the name of the Cachet container via `docker ps`.

Run `docker exec -i ID_OF_THE_CONTAINER php artisan key:generate`.

Replace `${APP_KEY:-null}` in `docker-compose.yml` with the newly generated Application key or create an `.env` file in the root of the Docker directory with the key.

__Note:__ make sure you include `base64:` prefix. E.g. `base64:YOUR_UNIQUE_KEY`

Restart the Docker containers.


# Docker Hub Automated build

`cachethq/docker` is available as a [Docker Hub Trusted Build](https://hub.docker.com/r/cachethq/docker/).

For a full list of Cachet versions released as Docker images  please see the [list of Docker hub tags](https://hub.docker.com/r/cachethq/docker/tags/).

Please use a [tagged Cachet Docker image release](https://github.com/CachetHQ/Docker/releases) or one of the tagged builds from https://hub.docker.com/r/cachethq/docker/tags/ with `docker pull cachethq/docker:2.3.12`.

# Debugging

* The services such as Cachet, supervisord, nginx, and php-fpm log to `stdout` and `stderr`, and are visible in the Docker runtime output. 

* Setting the `DEBUG` Docker environment variable within the `docker-compose.yml` file or at runtime to `true` will enable debugging of the container entrypoint init script.
