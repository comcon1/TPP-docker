#!/bin/bash

source .env

if docker compose version &> /dev/null; then
  DOCKER_COMPOSE="docker compose"
elif command -v docker-compose &> /dev/null; then
  DOCKER_COMPOSE="docker-compose"
else
  echo "Error: Neither docker-compose nor docker compose command is available."
  exit 1
fi

${DOCKER_COMPOSE} -p ${PREFIX} down
rm -fr volume
