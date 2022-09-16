# Docker: ForgeRock fIdentity Gateway

This is a ForgeRock Access Manager container, based on eclipse-temurin:11.0.14_9-jre-alpine

## Pre-Requisite

It is necessary to have the FRAM `zip` archive downloaded from backstage and placed in the `docker/fram` folder as `IG-x.x.x.zip`.

It is possible to override the default `build-arg` value of `FRAM_WAR_ARCHIVE` and `FRAM_AMSTER_ARCHIVE` to a version required.

It can also be retrieved from a web server by override the default `build-arg` value of `FRAM_ARCHIVE_REPOSITORY_URL` to a web address i.e `https://files.internal.darkedges.com`

## Build

To build the container:

```console
git clone https://github.com/darkedges/devspace-forgerock-quickstart.git
cd docker/fram

# To build
docker build -t devspace-forgerock-quickstart/am:7.2.0 .
```

## Run

```console
docker run -it --rm --name dfq-ds devspace-forgerock-quickstart/ds:7.2.0 init_start
docker run -it --rm --name dfq-am --link dfq-ds:dfq-ds --publish 8080:8080  devspace-forgerock-quickstart/am:7.2.0
```

open a web browser to <http://am.7f000001.nip.io:8080/openam/> and it should return the hostname of the container running.

## Build Arguments

| build-arg                     | Default Value             | Description                                             |
| ----------------------------- | ------------------------- | ------------------------------------------------------- |
| `TOMCAT_IMAGE`                | `darkedges/tomcat`        | image name                                              |
| `TOMCAT_TAG`                  | `9.0.65-11.0.14_9-alpine` | tag value                                               |
| `FRAM_WAR_ARCHIVE`            | `AM-7.2.0.zip`            | name of archive to deploy                               |
| `FRAM_AMSTER_ARCHIVE`         | `Amster-7.2.0.zip`        | name of amster archive to deploy                        |
| `FRAM_ARCHIVE_REPOSITORY_URL` |                           | URL of Web Server / Nexus Repository / Cloud Bucket URL |

## Folder Structure

### rootscripts

Contains the [`docker-entrypoint.sh`](rootscripts/docker-entrypoint.sh) file that is used to start the FRAM instance.

#### environmental variables

| Name                          | Default Value                                          | Description                             |
| ----------------------------- | ------------------------------------------------------ | --------------------------------------- |
| `FRAM_ADMIN_PASSWORD`         | `Passw0rd`                                             | `amadmin` password                      |
| `FRAM_CFG_STORE_DIR_MGR_PWD`  | `Passw0rd`                                             | Config Store Password                   |
| `FRAM_CFG_STORE_DIR_MGR`      | `uid=am-config,ou=admins,dc=amconfig`                  | Config Store UID                        |
| `FRAM_CFG_STORE_HOST`         | `dfq-ds`                                               | Config Store Hostname                   |
| `FRAM_CFG_STORE_PORT`         | `1389`                                                 | Config Store Port                       |
| `FRAM_CFG_STORE_ROOT_SUFFIX`  | `dc=amconfig`                                          | Config Store Root Suffix                |
| `FRAM_CFG_STORE_SSL`          | `false`                                                | Config Store using SSL                  |
| `FRAM_USER_STORE_DIR_MGR_PWD` | `Passw0rd`                                             | Identity Store Password                 |
| `FRAM_USER_STORE_DIR_MGR`     | `uid=am-identity-bind-account,ou=admins,ou=identities` | Identity Store UID                      |
| `FRAM_USER_STORE_HOST`        | `dfq-ds`                                               | Identity Store Hostname                 |
| `FRAM_USER_STORE_PORT`        | `1389`                                                 | Identity Store Port                     |
| `FRAM_USER_STORE_ROOT_SUFFIX` | `ou=identities`                                        | Identity Store Root Suffix              |
| `FRAM_USER_STORE_SSL`         | `false`                                                | Identity Store using SSL                |
| `SERVER_PORT`                 | `8080`                                                 | Port the Tomcat instance listens on     |
| `SERVER_SCHEME`               | `http`                                                 | Scheme for the `SERVERURL`              |
| `SERVER_URL`                  | `am.7f000001.nip.io`                                   | Server FQDN that is used to access FRAM |

### instance

Contains the standard configuration folder structure for FRAM.

| folder                                             | description                                                                 |
| -------------------------------------------------- | --------------------------------------------------------------------------- |
| [`patches`](patches)                               | Place any required patches here                                             |
| [`instance/amster`](instance/amster)               | This contains the core scripts to import and export FRAM Configuration.     |
| [`instance/amster/config`](instance/amster/config) | Place the files needed to be configured using Amster here.                  |
| [`webapps`](webapps)                               | Place any content that needs to be deployed to the Tomcat webapps directory |

#### `instance/amster` scripts

| name                  | description                                                                                          |
| --------------------- | ---------------------------------------------------------------------------------------------------- |
| `exportConfig.sh`     | This configures the correct URL to use with Amster and calls the export script `exportConfig.amster` |
| `exportConfig.amster` | This will execute an export of the FRAM configuration into the `/tmp/fram` directory.                |
| `importConfig.sh`     | This configures the correct URL to use with Amster and calls the import script `importConfig.amster` |
| `importConfig.amster` | This will execute an import of the FRAM configuration into the `instance/amster/config` directory.   |

Note: to keep this pure and to be able to import into Identity Cloud, no variable subsituition is being used.

## docker-entrypoint.sh

| Command        | Description                                 |
| -------------- | ------------------------------------------- |
| `init`         | Perform an initilization operation.         |
| `docker_start` | Start to be used for docker to also do init |
