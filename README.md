# Devspace Quickstart for ForgeRock

This is a collection of Helm Charts and Devspace Configurations to deploy the ForgeRock Platform quickly into a Kubernetes 1.20+ environment.

Currently it is supporting only the following services

- ForgeRock Identity Gateway
- ForgeRock Directory Services
- ForgeRock Access Manager
- ForgeRock Identity Manager

## Repository Folder Layout

1. Helm Charts are located in the [helm](helm) folder.
2. Helm Chart Values are located in the [values/environment](values/environment) folder.
3. Docker Images are located in the [docker](docker) folder.
4. Devspace Configuration are located in the [devspace](devspace) folder.

Each folder will have the following mapping attached

| Product                     | Folder             |
| --------------------------- | ------------------ |
| ForgeRock Identity Gateway  | `frig`             |
| ForgeRock Identity Manager  | `frim`             |
| ForgeRock Access Manager    | `fram`             |
| ForgeRock Directory Service | `frds`             |
| ForgeRock Identity Platform | `identityplatform` |

except `values/environments` where there are 2 environments defined

- [devspace](values/environment/devspace)
- [localdev](values/environment/localdev)

and the values will be in the format above as yaml files.

## Quick Start

The following quickstarts guides will get each Service up and running with a simple command

| Product                     | Folder                                                           |
| --------------------------- | ---------------------------------------------------------------- |
| ForgeRock Identity Gateway  | [devspace/frig](devspace/frig/README.md)                         |
| ForgeRock Identity Manager  | [devspace/frim](devspace/frim/README.md)                         |
| ForgeRock Access Manager    | [devspace/fram](devspace/fram/README.md)                         |
| ForgeRock Directory Service | [devspace/frds](devspace/frds/README.md)                         |
| ForgeRock Identity Platform | [devspace/identityplatform](devspace/identityplatform/README.md) |

In order to complete the QuickStarts it is recommended to install the following utilities

- [DevSpace](https://devspace.sh/) - [devspace](devspace)
- [Helm](https://helm.sh/) - [helm chart](helm)
- [Docker](https://www.docker.com/) - [Dockerfile](docker/Dockerfile)

Further it is recommended to download the necessary artefacts for each product.

| Product                     | Link                                                                                                                                                                                                                                                                                                                         | Artefact Location and Name                                    |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| ForgeRock Identity Gateway  | [IG-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:ig/productId:ig/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip)                                                                                                                                                                      | `docker/frig/IG-7.2.0.zip`                                    |
| ForgeRock Identity Manager  | [IDM-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:idm/productId:idm/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip)                                                                                                                                                                   | `docker/frim/IDM-7.2.0.zip`                                   |
| ForgeRock Access Manager    | [AM-7.2.0.war](https://backstage.forgerock.com/downloads/get/familyId:am/productId:am/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:war) <br/>[Amster-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:am/productId:amster/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip) | `docker/fram/AM-7.2.0.war`<br/>`docker/fram/Amster-7.2.0.zip` |
| ForgeRock Directory Service | [DS-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:ds/productId:ds/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip)                                                                                                                                                                      | `docker/frds/DS-7.2.0.zip`                                    |

## FRAM

```console
docker build . -t devspace-forgerock-quickstart/am:7.2.0-fbc
docker run -it  --rm --name dfq-am --link dfq-ds --link dfq-im --publish 8081:8080  --env-file=.env devspace-forgerock-quickstart/am:7.2.0-fbc
```

## FRDS

```console
docker build . -t devspace-forgerock-quickstart/frds:7.2.0-fbc
docker run -it --rm -p 1389:1389 -p 1636:1636 --name dfq-ds devspace-forgerock-quickstart/frds:7.2.0-fbc init_start
```

## FRIM

```console
docker build . -t devspace-forgerock-quickstart/idm:7.2.0-fbc
docker run -it  --rm --name dfq-im --link dfq-ds --link dfq-am --publish 8084:8080  devspace-forgerock-quickstart/idm:7.2.0-fbc
```

## FRIG

```console
docker build . -t devspace-forgerock-quickstart/ig:7.2.0-fbc
docker run -it --rm --name dfq-ig --link dfq-am:dfq-am --publish 8082:8080  devspace-forgerock-quickstart/ig:7.2.0-fbc
```

docker run -it --rm --name dfq-ig --link dfq-am:dfq-am --publish 8082:8080  devspace-forgerock-quickstart/ig:7.2.0-fbc
docker run -it  --rm --name dfq-am --link dfq-ds --link dfq-im --publish 8081:8080  --env-file=.env devspace-forgerock-quickstart/am:7.2.0-fbc
docker run -it  --rm --name dfq-im --link dfq-ds --link dfq-am --publish 8084:8080  devspace-forgerock-quickstart/idm:7.2.0_fbc
docker run -it --rm -p 1389:1389 -p 1636:1636 --name dfq-ds devspace-forgerock-quickstart/frds:7.2.0-fbc init_start

## Helm

```console
helm upgrade --install development-frds .\helm\frds\ -f .\values\environments\localdev\frds.yaml
helm upgrade --install development-frim .\helm\frim\ -f .\values\environments\localdev\frim.yaml
helm upgrade --install development-fram .\helm\fram\ -f .\values\environments\localdev\fram.yaml
helm upgrade --install development-frig .\helm\frig\ -f .\values\environments\localdev\frig.yaml
helm upgrade --install development-ui .\helm\ui\ -f .\values\environments\localdev\ui.yaml
```

```console
helm uninstall development-frds
helm uninstall development-frim
helm uninstall development-fram
helm uninstall development-frig
helm uninstall development-ui
```
