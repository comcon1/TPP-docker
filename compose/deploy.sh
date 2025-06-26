#!/bin/bash

PREFIX=tpproject

source .env
mkdir -p volume/db
mkdir -p volume/work

docker-compose -p $PREFIX up -d

while true; do
  healthy_container=$(docker ps --filter "label=com.docker.compose.project=$PREFIX" --filter "health=healthy" --format "{{.Names}}" | grep mariadb)
  if [ -n "$healthy_container" ]; then
    echo "MariaDB container is healthy!"
    break
  else
    echo "Waiting for MariaDB container to setting up..."
    sleep 5
  fi
done

while true; do
  echo "SHOW DATABASES; " | docker exec -i ${PREFIX}_mariadb_1 mariadb -u$TPP_DB_USR -p$TPP_DB_PWD > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "MariaDB is ready to accept connections!"
    break
  else
    echo "Waiting for MariaDB is configured..."
    sleep 5
  fi
done

cat my.sql | docker exec -i ${PREFIX}_mariadb_1 mariadb -u$TPP_DB_USR -p$TPP_DB_PWD tppforcefield

echo "TPP containers are ready!"