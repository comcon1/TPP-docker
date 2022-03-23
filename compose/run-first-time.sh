#!/bin/bash
docker-compose up -d
echo "Waiting for 30 seconds to allow MySQL server start..."
sleep 30 
cat my.sql | docker exec -i compose_mariadb_1 mysql -utppuser -pYourSecretPassword tppforcefield
