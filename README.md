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
   3. Pull all required images by using `docker-compose pull`
   4. Edit `run-first-time.sh` to fix mysql password
   5. Run docker-network via `run-first-time.sh` to upload the database into mariadb container.

3. Further usage
   1. Use standard `docker-compose down` | `docker-compose up -d` to stop | start containers.
   2. Verify adminer connect via http://localhost:9000/ using user/password from step 1.
