
# TPP deployment

TPP deployment via docker & docker-compose.

## Getting started with compose

1. Edit settings and prepare files
   1. Edit compose/.env to set up your password for database & adminer
   2. Edit pathes in compose/docker-compose.yml
   3. Pull all required images by using `docker-compose pull`
   4. Edit `run-first-time.sh` to fix mysql password

>Note, that **tpp_1** will operate only with files in `/work` folder mounted by default to `/usr/local/share/tpp/work`. If you want to change the location, please, edit the corresponding line in `docker-compose.yml`.

2. Run compose to deploy three containers and upload the database:
    - **compose_tpp_1**: container with tppmktop
    - **compose_mariadb_1**: container with FF database
    - **compose_adminer_1**: container with web-interface to FF database
```
./run-first-time.sh
```

3. Further compose usage
   1. Use standard `docker-compose down` | `docker-compose up -d` to stop | start containers.
   2. Verify adminer connect via http://localhost:9000/ using user/password from step 1.

4. Try **tpprenum** on the test file from `./test`:
```
sudo cp ./test/not-renumbered.pdb /usr/local/share/tpp/work
docker exec tpp_1 tpprenum -i not-renumbered.pdb -o renumbered.pdb
```

5. Try **tppmktop** on the test file from `./test`:
```
sudo cp ./test/test.pdb /usr/local/share/tpp/work
docker exec dragon_tpp_1 runtppmktop.sh -i test.pdb -o output.itp -l lack.itp -f OPLS-AA -v
```
> Script `runtppmktop.sh` automatically substitutes proper settings of the database connection. You can use `tppmktop` binary directly if you want.

## Fix permissions to allow non-root usage

Let your system username is *john*. Then it automatically belongs to group *john* (you can verify it running `groups john`). So you can change group ownership of the folder:
```
sudo chown :john /usr/share/tpp/work
```
and then allow every group member to write into this folder:
```
sudo chmod g+w /usr/share/tpp/work
```
After these changes you will be able to copy file into this folder without sudo
```
cp file.pdb /usr/share/tpp/work
docker exec tpp_1 tpprenum -i file.pdb -o o_file.pdb
cp o_file.pdb .
```


## To rebuild docker image

```
cd docker 
docker build -t <imagename> .
```
