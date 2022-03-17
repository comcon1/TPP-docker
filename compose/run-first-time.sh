#!/bin/bash
docker-compose up -d
cat my.sql | docker exec -i mariadb_1 mysql -utppuser -pYourSecretPassword tppforcefield
