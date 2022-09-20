# Docker: ForgeRock Identity Manager Schema

This is a ForgeRock Identity Manager Schema container, based on [Liquibase](https://www.liquibase.org/)

## Build

To build the container:

```console
git clone https://github.com/darkedges/devspace-forgerock-quickstart.git
cd docker/idmschema

# To build

docker build -t devspace-forgerock-quickstart/idmschema:7.2.0 .
```

## Run

```console
docker run -it --rm --name dfq-db -e "MYSQL_ROOT_PASSWORD=Passw0rd" -e "MYSQL_DATABASE=frim" -e "MYSQL_USER=frim" -e "MYSQL_PASSWORD=Passw0rd" --publish 3306:3306 mysql:8.0.30-oracle
docker run -it --rm --link dfq-db:dfq-db --publish 8080:8080  -e "DRIVER=com.mysql.cj.jdbc.Driver" -e "URL=jdbc:mysql://dfq-db:3306/frim"-e "USERNAME=frim" -e "PASSWORD=Passw0rd" -e "CHANGELOG_FILE=changelog/frim/install_7.2.0-changelog.xml" -e "LOG_LEVEL=INFO" -e "CMD=update" devspace-forgerock-quickstart/idmschema:7.2.0
```

## Explore

```console
docker run -it --rm --link dfq-db:dfq-db mysql:8.0.30-oracle mysql -u frim -h dfq-db -pPassw0rd frim -e 'show tables'
```

should return

```console
+------------------------------+                                                                    
| Tables_in_frim               |                                                                    
+------------------------------+                                                                    
| DATABASECHANGELOG            |                                                                    
| DATABASECHANGELOGLOCK        |                                                                    
| auditaccess                  |                                                                    
| auditactivity                |                                                                    
| auditauthentication          |                                                                    
| auditconfig                  |
| auditrecon                   |
| auditsync                    |
| clusteredrecontargetids      |
| clusterobjectproperties      |
| clusterobjects               |
| configobjectproperties       |
| configobjects                |
| files                        |
| genericobjectproperties      |
| genericobjects               |
| importobjectproperties       |
| importobjects                |
| internalrole                 |
| internaluser                 |
| links                        |
| locks                        |
| managedobjectproperties      |
| managedobjects               |
| metaobjectproperties         |
| metaobjects                  |
| notificationobjectproperties |
| notificationobjects          |
| objecttypes                  |
| reconassoc                   |
| reconassocentry              |
| reconassocentryview          |
| relationshipproperties       |
| relationshipresources        |
| relationships                |
| schedulerobjectproperties    |
| schedulerobjects             |
| syncqueue                    |
| uinotification               |
| updateobjectproperties       |
| updateobjects                |
+------------------------------+
```

## Stop

```console
docker stop dfq-db
```

## Build Arguments

| build-arg         | Default Value         | Description |
| ----------------- | --------------------- | ----------- |
| `LIQUIBASE_IMAGE` | `liquibase/liquibase` | image name  |
| `LIQUIBASE_TAG`   | `4.16`                | tag value   |

## Folder Structure

### environmental variables

| Name             | Default Value | Description                                                               |
| ---------------- | ------------- | ------------------------------------------------------------------------- |
| `CHANGELOG_FILE` |               | Change log to execute. e.g. ``                                            |
| `CMD`            |               | Liquibase command to execute. e.g. `update`                               |
| `DRIVER`         |               | JDBC Driver. e.g. `com.mysql.cj.jdbc.Driver`                              |
| `LOG_LEVEL`      |               | Log level to use.g. `INFO`                                                |
| `PASSWORD`       |               | Password to connect to database. e.g. `Passw0rd`                          |
| `URL`            |               | JDBC URL for connection to database. e.g. `jdbc:mysql://dfq-db:3306/frim` |
| `USERNAME`       |               | Change log to execute. e.g. `frim`                                        |

### instance

Contains the standard configuration folder structure for FRAM.

| folder                   | description                                                                       |
| ------------------------ | --------------------------------------------------------------------------------- |
| [`changelog`](changelog) | Place the necessary SQL Files and Liquibase change log files here.                |
| [`lib`](lib)             | This contains the JDBC Connector Library. This example includes the one for MySQL |
