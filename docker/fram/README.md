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

| build-arg                     | Default Value          | Description                                             |
| ----------------------------- | ---------------------- | ------------------------------------------------------- |
| `JRE_IMAGE`                   | `eclipse-temurin`      | image name                                              |
| `JRE_TAG`                     | `11.0.14_9-jre-alpine` | tag value                                               |
| `FRIG_ARCHIVE`                | `IG-7.2.0.zip`         | name of archive to deploy                               |
| `FRIG_ARCHIVE_REPOSITORY_URL` |                        | URL of Web Server / Nexus Repository / Cloud Bucket URL |

## Folder Structure

### rootscripts

Contains the [`docker-entrypoint.sh`](rootscripts/docker-entrypoint.sh) file that is used to start the FRAM instance.

#### environmental variables

| build-arg      | Default Value         | Description                                                       |
| -------------- | --------------------- | ----------------------------------------------------------------- |
| `INSTANCE_DIR` | `/opt/fram/instance/` | define where the FRAM Configuration instance directory is located |
| `JAVA_HOME`    | `/opt/java/openjdk`   | should be set by the JRE container deployed                       |
| `JAVA_OPTS`    |                       | pass any jvm arguments needed to be added                         |

### instance

Contains the standard configuration folder structure for FRAM.

| folder                                      | description                                                                                                                                                                                         |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`config`](instance/config)                 | contains <ul><li>[`config/admin.json`](instance/config/admin.json)</li><li>[`config/admin.json`](instance/config/admin.json)</li> <li>[`config/logback.xml`](instance/config/logback.xml)</li></ul> |
| [`config/routes`](instance/config/routes)   | contains <ul><li>[`config/routes/hello.json`](instance/config/routes/hello.json)</li></ul>                                                                                                          |
| [`extras`](instance/extras)                 | place any dependency jars here                                                                                                                                                                      |
| [`scripts`](instance/scripts)               | the core scripts directory                                                                                                                                                                          |
| [`scripts/groovy`](instance/scripts/groovy) | contains <ul><li>[`scripts/groovy/hello.groovy`](instance/scripts/groovy/hello.groovy)</li></ul>                                                                                                    |

## Enabling SSL

To enable SSL you need to create a keystore as per the guide [https://backstage.forgerock.com/docs/ig/7.2/installation-guide/install-standalone.html#standalone-https-keyManager](https://backstage.forgerock.com/docs/ig/7.2/installation-guide/install-standalone.html#standalone-https-keyManager) and either include it n the image or mount it as a volume.

Next you need to replace [`config/admin.json`](instance/config/admin.json) with [`config/admin.ssl.json`](instance/config/admin.ssl.json) and define the following environmental variables

| Environmental Variable | Example                               | Description                                        |
| ---------------------- | ------------------------------------- | -------------------------------------------------- |
| `IG_KEYSTORE_LOCATION` | `/var/fram/instance/ssl/keystore.jks` | location of the PKCS12 keystore created            |
| `IG_KEYSTORE_PASSWORD` | `changeit`                            | password used when the PKCS12 keystore was created |
| `IG_KEYSTORE_ALIAS`    | `https-connector-key`                 | alias used when the PKCS12 keystore was created    |

Consider using the `genjks` container to help with the generation of SSL using HashiCorp Vault and cert-manager.

## docker-entrypoint.sh

| Command              | Description                                                                                     |
| -------------------- | ----------------------------------------------------------------------------------------------- |
| `start`              | Start an FRDS Instance.                                                                         |
| `stop`               | Stop an FRDS Instance.                                                                          |
| `init_deploymentkey` | Generate a Deployment Key, based on the supplied environment variable `DEPLOYMENT_KEY_PASSWORD` |
| `init`               | Perform an initilization operation.                                                             |
| `upgrade`            | Ugrade an instance.                                                                             |
