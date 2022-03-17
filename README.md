# TPP deployment

TPP deployment via docker & docker-compose.

1. Build the main TPP container:

```
cd docker 
docker build -t <imagename> .
```

2. Set up docker network:
 1. Edit compose/.env to set up your password for database & adminer
 2. Edit pathes in compose/docker-compose.yml
 3. Run docker-network via `run-first-time.sh` to upload the database into mariadb container.

