# fram-fbc-init

```console
docker build -t devspace-forgerock-quickstart/am-fbc:8.0.1 .
docker volume create ds-fbc
docker network create fbc
# File Based Configuraton
docker run -it --rm --name fbc-ds --network=fbc --publish 1389:1389 --volume ds-fbc:/opt/frds/instance/data:rw devspace-forgerock-quickstart/frds:8.0.0 init_start
docker run -it --rm --name fbc-am --network=fbc --publish 8081:8080 devspace-forgerock-quickstart/am-fbc:8.0.1 
docker network rm fbc
docker volume rm ds-fbc
```


```console
docker build -t devspace-forgerock-quickstart/am-fbc:8.0.1 .
docker run -it --rm -p 8080:8080 --name darkedges-am-fbc-init docker.io/darkedges/am-fbc:8.0.1
```
