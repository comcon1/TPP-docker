
# TPPMKTOP deployment repository

MD topology generation is a very complex task because of huge amount of the atomtypes described this force field. For instance, the OPLS-AA force filed contains more than 800 atom types that is nevertheless not sufficient for describing all the diversity of chemical structures. Thus, as parameters for new chemical fragments appears in literature the atomtype database is also extending. TPPMKOP is an utility developed for the automatic topology generation based on automatic atomtype attribution according to the neighboring of the chemical environment. 

**We strongly recommend to use docker-compose version of TPPMKTOP instead of ERG webserver!**

The web version at server in MSU: http://erg.biophys.msu.ru/tpp/

Core TPPMKTOP container at dockerhub: https://hub.docker.com/r/comcon1/tppcon

TPPMKTOP C++ code: https://github.com/comcon1/TopologyPreProcessor

TPPMKTOP deployment via docker & docker-compose.

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
> This script upload the database from `my.sql` file. Please don't ignore this step!

3. Further compose usage
   1. Use standard `docker-compose stop` | `docker-compose start -d` to stop | start containers.
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

## Getting started with TPP

```
echo 'CC(CO)CCC(CCC)C[NH3+]' > 1.smi
obabel -ismi 1.smi -opdb --gen3D -O 1.pdb
docker exec compose_tpp_1 tpprenum -i 1.pdb -o 1rn.pdb
docker exec compose_tpp_1 runtppmktop.sh -i 1rn.pdb -o UBB.itp -l lack.itp -f OPLS-AA -v
```

## Fix permissions to allow non-root usage

Let your system username is *john*. Then it automatically belongs to group *john* (you can verify it running `groups john`). So you can change group ownership of the folder:
```
sudo chown :john /usr/local/share/tpp/work
```
and then allow every group member to write into this folder:
```
sudo chmod g+w /usr/local/share/tpp/work
```
After these changes you will be able to copy file into this folder without sudo
```
cp file.pdb /usr/local/share/tpp/work
docker exec tpp_1 tpprenum -i file.pdb -o o_file.pdb
cp o_file.pdb .
```

## To rebuild docker image

```
cd docker 
docker build -t <imagename> .
```
