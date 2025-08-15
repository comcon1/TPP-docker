#!/bin/bash

source .env
PREFIX=tpproject

if docker compose version &> /dev/null; then
  DOCKER_COMPOSE="docker compose"
elif command -v docker-compose &> /dev/null; then
  DOCKER_COMPOSE="docker-compose"
else
  echo "Error: Neither docker-compose nor docker compose command is available."
  exit 1
fi

export dUID=$(id -u)
export dGID=$(id -g)

${DOCKER_COMPOSE} -p $PREFIX up -d

