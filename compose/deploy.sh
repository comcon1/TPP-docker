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

mkdir -p volume/db
mkdir -p volume/work

# fixing permissions for current user to use 'volume/work' folder
export UID=$(id -u)
export GID=$(id -g)

${DOCKER_COMPOSE} -p $PREFIX up -d

MARIA=$(docker ps --format '{{.Names}}' | grep mariadb | grep ${PREFIX})
echo "MariaDB container: ${MARIA}"

while true; do
  healthy_container=$(docker ps --filter "health=healthy" --format "{{.Names}}" | grep ${MARIA})
  if [ -n "$healthy_container" ]; then
    echo "MariaDB container is healthy!"
    break
  else
    echo "Waiting for MariaDB container to setting up..."
    sleep 5
  fi
done

while true; do
  echo "SHOW DATABASES; " | docker exec -i ${MARIA} mariadb -u$TPP_DB_USR -p$TPP_DB_PWD > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "MariaDB is ready to accept connections!"
    break
  else
    echo "Waiting for MariaDB is configured..."
    sleep 5
  fi
done

cat my.sql | docker exec -i ${MARIA} mariadb -u$TPP_DB_USR -p$TPP_DB_PWD tppforcefield

echo "TPP containers are ready!"
