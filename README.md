
# TPPMKTOP deployment repository

MD topology generation is a very complex task because of huge amount of the atomtypes described this force field. For instance, the OPLS-AA force filed contains more than 800 atom types that is nevertheless not sufficient for describing all the diversity of chemical structures. Thus, as parameters for new chemical fragments appears in literature the atomtype database is also extending. TPPMKOP is an utility developed for the automatic topology generation based on automatic atomtype attribution according to the neighboring of the chemical environment. 

**NOTE: ERG webserver TPP is down!**

The web version at server in MSU: http://erg.biophys.msu.ru/tpp/ is currently down.

Core TPPMKTOP container at dockerhub: https://hub.docker.com/r/comcon1/tppcon

TPPMKTOP C++ code: https://github.com/comcon1/TopologyPreProcessor

TPPMKTOP deployment via docker & docker compose.

## Getting started with compose

1. Edit settings and prepare files
   1. Edit compose/.env to set up your password for database & adminer and container prefix
   2. Edit paths (if you want) in `compose/docker-compose.yml`
   3. Pull all required images by using `docker-compose pull`

>Note, that **tpproject-tpp-1** will operate only with files in `./volume/work`. 
If you want to change the location, please, edit the corresponding line in `docker-compose.yml`.

2. Run compose to deploy three containers and upload the database:
    - **tpproject-tpp-1**: container with tppmktop
    - **tpproject-mariadb-1**: container with FF database
    - **tpproject-adminer-1**: container with web-interface to FF database
```
./deploy.sh
```
> This script will set up everything and upload the database from `my.sql` file. 
Please don't ignore this step!

3. Further compose usage
   1. Use standard `docker compose -p tpproject down` | `docker compose -p tpproject up -d` to stop | start containers.
   2. Verify adminer connect via http://localhost:9000/ using user/password from step 1.
   3. **Note** `docker-compose` creates containers with underscore whereas `docker compose` ccreates them with dashes. Check `docker ps` before you are ready to go.

4. Try **tpprenum** on the test file from `./test`:
```
cp ./test/not-renumbered.pdb ./volume/work/
docker exec tpproject-tpp-1 tpprenum -i not-renumbered.pdb -o renumbered.pdb
head ./volume/work/renumbered.pdb
```

5. Try **tppmktop** on the test file from `./test`:
```
cp ./test/test.pdb ./volume/work
docker exec tpproject-tpp-1 runtppmktop.sh -i test.pdb -o output.itp -l lack.itp -f OPLS-AA -v
```
> Script `runtppmktop.sh` is `tppmktop` call with automatically substituted database credentials. 

## Getting started with TPP

You can test how it works with quite a various molecules by using OpenBabel from-SMILES generator:

```
echo 'CC(CO)CCC(CCC)C[NH3+]' > 1.smi
obabel -ismi 1.smi -opdb --gen3D -O 1.pdb
docker exec compose_tpp_1 tpprenum -i 1.pdb -o 1rn.pdb
docker exec compose_tpp_1 runtppmktop.sh -i 1rn.pdb -o UBB.itp -l lack.itp -f OPLS-AA -v
```

## To rebuild docker image

You can modify docker image on your own. The sources are in `./docker` folder.

```
cd docker 
docker build -t <imagename> .
```

All images from this repo are stored at DockerHub registry: https://hub.docker.com/r/comcon1/tppcon
