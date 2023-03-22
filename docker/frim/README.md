# Docker: ForgeRock Identity Manager

This is a ForgeRock Identity Manager container, based on eclipse-temurin:11.0.14_9-jre-alpine

## Pre-Requisite

It is necessary to have the FRIM `zip` archive downloaded from backstage and placed in the `docker/frim` folder as `IDM-x.x.x.zip`.

It is possible to override the default `build-arg` value of `FRIM_ARCHIVE` to a version required.

It can also be retrieved from a web server by override the default `build-arg` value of `FRIM_ARCHIVE_REPOSITORY_URL` to a web address i.e `https://files.internal.darkedges.com`

## Build

To build the container:

```console
git clone https://github.com/darkedges/devspace-forgerock-quickstart.git
cd docker/frim

# To build
docker build -t devspace-forgerock-quickstart/idm:5.5.1.3 .
```

## Run

```console
docker run --name dfq-ds devspace-forgerock-quickstart/ds:5.5.0 init_start
docker run -it --rm --name dfq-db -e "MYSQL_ROOT_PASSWORD=Passw0rd" -e "MYSQL_DATABASE=frim" -e "MYSQL_USER=frim" -e "MYSQL_PASSWORD=Passw0rd" --publish 3306:3306 mysql:8.0.30-oracle
docker run -it --rm --link dfq-db:dfq-db --publish 8080:8080  -e "DRIVER=com.mysql.cj.jdbc.Driver" -e "URL=jdbc:mysql://dfq-db:3306/frim"-e "USERNAME=frim" -e "PASSWORD=Passw0rd" -e "CHANGELOG_FILE=changelog/frim/install_5.5.1.3-changelog.xml" -e "LOG_LEVEL=INFO" -e "CMD=update" devspace-forgerock-quickstart/idmschema:5.5.1.3
docker run -it --rm --name dfq-idm --link dfq-ds:dfq-ds --link dfq-db:dfq-db --publish 8080:8080 devspace-forgerock-quickstart/idm:5.5.1.3
```

when it shows the following

```console
-> OpenIDM version "5.5.1.3" (build: 20220630052128, revision: 4b1c09d) jenkins-idm-release-sustaining%2F7.2.x-6
OpenIDM ready
```

open a web browser to <http://idm.7f000001.nip.io:8080/admin/> and it should return the login screen for ForgeRock Identity Manager 5.5.1.3

## Build Arguments

| build-arg                     | Default Value          | Description                                             |
| ----------------------------- | ---------------------- | ------------------------------------------------------- |
| `JRE_IMAGE`                   | `eclipse-temurin`      | image name                                              |
| `JRE_TAG`                     | `11.0.14_9-jre-alpine` | tag value                                               |
| `FRIM_ARCHIVE`                | `IDM-5.5.1.3.zip`        | name of archive to deploy                               |
| `FRIM_ARCHIVE_REPOSITORY_URL` |                        | URL of Web Server / Nexus Repository / Cloud Bucket URL |

## Folder Structure

### rootscripts

Contains the [`docker-entrypoint.sh`](rootscripts/docker-entrypoint.sh) file that is used to start the FRIM instance.

#### environmental variables

| Name                                     | Default Value | Description                          |
| ---------------------------------------- | ------------- | ------------------------------------ |
| `DARKEDGES_DATASOURCE_JDBC.HOST`         | `dfq-db`      | Hostname of Database                 |
| `DARKEDGES_DATASOURCE_JDBC.PORT`         | `3306`        | Port of Database                     |
| `DARKEDGES_DATASOURCE_JDBC.DATABASENAME` | `frim`        | Database name                        |
| `DARKEDGES_DATASOURCE_JDBC.USERNAME`     | `frim`        | Username to connect to Database      |
| `DARKEDGES_DATASOURCE_JDBC.PASSWORD`     | `Passw0rd`    | Password to connect to Database      |
| `PROJECT_HOME`                           | `/opt/frim`   | Where the FRIM project is located    |
| `LOGGING_CONFIG`                         |               | What logging properties are needed   |
| `IDM_ENVCONFIG_DIRS`                     |               | Where the                            |
| `LAUNCHER_CONFIG`                        |               | Where the launcher config is         |
| `IDM_CLASSPATH`                          |               | provides additional classpath rules  |
| `JAVA_OPTS`                              |               | Any Java configuration               |
| `OPENIDM_OPTS`                           |               | Any FRIM options                     |
| `JAVA_ENDORSED_DIRS`                     |               | Where the Java Endorde deirectory is |

### instance

Contains the standard configuration folder structure for FRIM.

| folder                 | description                                            |
| ---------------------- | ------------------------------------------------------ |
| [`instance`](instance) | Standard Project layout for ForgeRock Identity Manager |

Note: to keep this pure and to be able to import into Identity Cloud, no variable subsituition is being used.

## docker-entrypoint.sh

| Command    | Description                               |
| ---------- | ----------------------------------------- |
| `init`     | Perform an initilization operation.       |
| `start`    | Start command     as a `tini` process     |
| `stop`     | Stop command                              |
| `devspace` | Start command     as a `DevSpace` process |


## Build older version

```console
docker build . -t devspace-forgerock-quickstart/frim:5.5.1.3 --build-arg FRIM_ARCHIVE=IDM-5.5.1.3.zip --build-arg JRE_TAG=8-jre-alpine
```