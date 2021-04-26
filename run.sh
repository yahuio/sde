#!/bin/bash

echo "UID=$(id -u)" > .env
echo "GID=$(id -g)" >> .env
echo "WS=${SDE_WS}" >> .env

docker-compose run --rm sde && \
docker-compose down -v
