# Docker: ForgeRock Directory Services

This is a ForgeRock Directory Services container, based on eclipse-temurin:11.0.14_9-jre-alpine

## Pre-Requisite

It is necessary to have the FRDS `zip` archive downloaded from backstage and placed in the `docker/frds` folder as `IG-x.x.x.zip`.

It is possible to override the default `build-arg` value of `FRDS_ARCHIVE` to a version required.

It can also be retrieved from a web server by override the default `build-arg` value of `FRDS_ARCHIVE_REPOSITORY_URL` to a web address i.e `https://files.internal.darkedges.com`

## Build

To build the container:

```console
git clone https://github.com/darkedges/devspace-forgerock-quickstart.git
cd docker/frds

# To build
docker build -t devspace-forgerock-quickstart/ds:7.2.0 .
```

## Run

```console
docker run -it --rm --name dfq-ds devspace-forgerock-quickstart/ds:7.2.0 init_start
```

In another shell start another instance using

```console
docker run -it --rm --link dfq-ds:dfq-ds devspace-forgerock-quickstart/ds:7.2.0 bash
```

When it has started issiue the following to confirm it is working.

```console
./bin/ldapsearch -h dfq-ds -p 1636 -X -Z -Duid=admin -wPassw0rd -b ou=identities "(objectclass=*)" dn
```

should return

```console
dn: ou=identities

dn: ou=people,ou=identities

dn: ou=groups,ou=identities

dn: ou=admins,ou=identities

dn: uid=am-identity-bind-account,ou=admins,ou=identities
```

## Build Arguments

| build-arg                     | Default Value          | Description                                             |
| ----------------------------- | ---------------------- | ------------------------------------------------------- |
| `JRE_IMAGE`                   | `eclipse-temurin`      | image name                                              |
| `JRE_TAG`                     | `11.0.14_9-jre-alpine` | tag value                                               |
| `FRDS_ARCHIVE`                | `DS-7.2.0.zip`         | name of archive to deploy                               |
| `FRDS_ARCHIVE_REPOSITORY_URL` |                        | URL of Web Server / Nexus Repository / Cloud Bucket URL |

## Folder Structure

### rootscripts

Contains the [`docker-entrypoint.sh`](rootscripts/docker-entrypoint.sh) file that is used to start the FRDS instance.

#### environmental variables

| build-arg                                | Default Value                                             | Description                                                                                                                                                               | Build or Deploy |
| ---------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `AMCONFIG_ADMIN_PASSWORD`                | `Passw0rd`                                                | AM Config Password - <https://backstage.forgerock.com/docs/ds/7.2/install-guide/setup-profiles.html#default-setup-profiles>                                               | `build`         |
| `AMCONFIG_BACKEND_NAME`                  | `cfgStore`                                                | AM Config Backend Name                                                                                                                                                    | `build`         |
| `AMCONFIG_BASE_DN`                       | `ou=amconfig`                                             | AM Config Base DN                                                                                                                                                         | `build`         |
| `AMCTS_ADMIN_PASSWORD`                   | `Passw0rd`                                                | AM CTS Password - <https://backstage.forgerock.com/docs/ds/7.2/install-guide/setup-profiles.html#am-cts-6.5.0>                                                            | `build`         |
| `AMCTS_BACKEND_NAME`                     | `amCts`                                                   | AM CTS Backend Name                                                                                                                                                       | `build`         |
| `AMCTS_BACKEND_TOKEN_EXPIRARTION_POLICY` | `ds`                                                      | AM CTS Token Expiration Policy can be `ds` \| `am-sessions-only` \| `am` see <https://backstage.forgerock.com/docs/ds/7.2/install-guide/setup-profiles.html#am-cts-6.5.0> | `build`         |
| `AMCTS_BASE_DN`                          | `ou=tokens`                                               | AM CTS Base DN                                                                                                                                                            | `build`         |
| `AMIDENTITYSTORE_ADMIN_PASSWORD`         | `Passw0rd`                                                | AM Identity Store Password - <https://backstage.forgerock.com/docs/ds/7.2/install-guide/setup-profiles.html#am-identity-store-7.2.0>                                      | `build`         |
| `AMIDENTITYSTORE_BACKEND_NAME`           | `amIdentityStore`                                         | AM Identity Store Backend Name                                                                                                                                            | `build`         |
| `AMIDENTITYSTORE_BASE_DN`                | `ou=identities`                                           | AM Identity Store Base DN                                                                                                                                                 | `build`         |
| `DEPLOYMENT_KEY_PASSWORD`                | `Passw0rd`                                                | FRDS Deployment Password                                                                                                                                                  | `build`         |
| `DEPLOYMENT_KEY`                         | `AKtnvIyweZddXIA2jL4hq6F5Bn7C1Q5CBVN1bkVDfvPByQLPrt_1mJw` | FRDS Deployment Key - this can be generated via running the docker image with `init_deploymentkey`                                                                        | `build`         |
| `DS_ADVERTISED_LISTEN_ADDRESS`           | `localhost`                                               | Can be IP Address of Container to listen for.                                                                                                                             | `deploy`        |
| `DS_BOOTSTRAP_REPLICATION_SERVERS`       | ``                                                        | List of existing servers to be used to bootstrap replication etc                                                                                                          | `deploy`        |
| `DS_GROUP_ID`                            | `default`                                                 | Group ID that this server insance belongs to.                                                                                                                             | `deploy`        |
| `DS_SERVER_ID`                           | `docker`                                                  | Server ID that is attached to this instance.                                                                                                                              | `deploy`        |
| `FRDS_HTTPS_PORT`                        | `8443`                                                    | HTTPS Port                                                                                                                                                                | `build`         |
| `FRDS_LDAP_PORT`                         | `1389`                                                    | LDAP Port                                                                                                                                                                 | `build`         |
| `FRDS_LDAPS_PORT`                        | `1636`                                                    | LDAPS Port                                                                                                                                                                | `build`         |
| `MONITOR_USER_PASSWORD`                  | `Passw0rd`                                                | Password for the monitor user                                                                                                                                             | `build`         |
| `PLATFORM_TRUST_TRANSACTION_HEADER`      | `true`                                                    | Wether to enable trusting transaction id's                                                                                                                                | `build`         |
| `ROOT_USER_PASSWORD`                     | `Passw0rd`                                                | Password for the uid=admin user                                                                                                                                           | `build`         |

### instance

Contains the standard configuration folder structure for FRDS.

| folder                        | description                                                                                                                                                                                                                                                                                                                                   |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`instance`](instance/)       | Place any LDIF artefacts here and reference them in [rootscripts/default-scripts/development/init.sh](rootscripts/default-scripts/development/init.sh)                                                                                                                                                                                        |
| [`rootscripts`](rootscripts/) | Core scriptinjg is placed here. [rootscripts/docker-entrypoint.sh](rootscripts/docker-entrypoint.sh) is the main script for managing the lifecycle of the container. in   [rootscripts/default-scripts](rootscripts/default-scripts) are the scripts for generating `amconfig`, `cts`, `development`, `indentity` and `replication` instances |

Each instance has the following scripts

| Script       | Description                                                                                                                   |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| `setup.sh`   | Called on a container initilization it will setup the required instance and then call `init.sh` to complete initialization.   |
| `init.sh`    | Called when a container is initialized after setup. Should be called once in the environment. All calls should be idempotent. |
| `upgrade.sh` | Called as a job when an upgrade needs to occur                                                                                |

## Enabling SSL

To enable SSL you need to create a keystore as per the guide <https://backstage.forgerock.com/docs/ds/7.2/install-guide/setup-own-keys.html> and either include it in the image or mount it as a volume.

These files are

| Environmental Variable                 | Description            |
| -------------------------------------- | ---------------------- |
| `/var/run/secrets/frds/keystore.jks`   | Keystore               |
| `/var/run/secrets/frds/truststore.jks` | Truststore             |
| `/var/run/secrets/frds/keystore.pin`   | Password to Keystore   |
| `/var/run/secrets/frds/truststore.pin` | Password to Truststore |

Consider using the `genjks` container to help with the generation of SSL using HashiCorp Vault and cert-manager.

## docker-entrypoint.sh

| Command              | Description                                                                                     |
| -------------------- | ----------------------------------------------------------------------------------------------- |
| `start`              | Start an FRDS Instance.                                                                         |
| `stop`               | Stop an FRDS Instance.                                                                          |
| `init_deploymentkey` | Generate a Deployment Key, based on the supplied environment variable `DEPLOYMENT_KEY_PASSWORD` |
| `init`               | Perform an initilization operation.                                                             |
| `upgrade`            | Ugrade an instance.                                                                             |
