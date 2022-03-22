
# TPP deployment

TPP deployment via docker & docker-compose.

# Getting started with compose

1. Edit settings and prepare files
   1. Edit compose/.env to set up your password for database & adminer
   2. Edit pathes in compose/docker-compose.yml
   3. Pull all required images by using `docker-compose pull`
   4. Edit `run-first-time.sh` to fix mysql password

>Note, that **tpp_1** will operate only with files in `/work` folder mounted by default to `/usr/local/share/tpp/work`. If you want to change the location, please, edit the corresponding line in `docker-compose.yml`.

2. Run compose to deploy three containers and upload the database:
    - **tpp_1**: container with tppmktop
    - **mariadb_1**: container with FF database
    - **adminer_1**: container with web-interface to FF database
```
./run-first-time.sh
```

3. Further compose usage
   1. Use standard `docker-compose down` | `docker-compose up -d` to stop | start containers.
   2. Verify adminer connect via http://localhost:9000/ using user/password from step 1.

4. Try **tpprenum** on the test file from `./test`:
```
docker exec tpp_1 tpprenum -i not-renumbered.pdb -o renumbered.pdb
```

5. Try **tppmktop** on the test file from `./test`:
```
docker exec dragon_tpp_1 runtppmktop.sh -i test.pdb -o output.itp -l lack.itp -f OPLS-AA -v
```
> Script `runtppmktop.sh` automatically substitutes proper settings of the database connection. You can use `tppmktop` binary directly if you want.

## To rebuild docker image

```
cd docker 
docker build -t <imagename> .
```
