# FBC

```console
docker run -it --rm --name dfq-ds -publish 1389:1389 -publish 1636:1636 devspace-forgerock-quickstart/frds:7.4.0-fbc init_start
docker run -it --rm --name dfq-am --link dfq-ds:dfq-ds --publish 8081:8080  devspace-forgerock-quickstart/am:7.4.0-fbc
docker run -it --rm --name dfq-ig --link dfq-am:dfq-am --publish 8082:8080  devspace-forgerock-quickstart/ig:7.4.0-fbc
```
