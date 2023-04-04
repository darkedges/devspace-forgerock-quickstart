# EBR

## Execute

### Start Database

```console
docker run -it --rm --name oracledb -p 1521:1521 -e ORACLE_PWD=Passw0rd darkedges/oracledb:12.2.0.1-frim
```

### Base Upgrade

```console
docker run -it --rm --link oracledb:oracledb -e "DRIVER=oracle.jdbc.OracleDriver" -e "URL=jdbc:oracle:thin:@oracledb:1521/ORCLPDB1" -e "USERNAME=frim5513" -e "PASSWORD=Passw0rd" -e "CHANGELOG_FILE=changelog/frim/oracle/ebr/update-base-changelog.xml" -e "LOG_LEVEL=INFO" -e "CMD=update" devspace-forgerock-quickstart/idmschema:5.5.0
```

### V1 Upgrade

```console
docker run -it --rm --link oracledb:oracledb -e "DRIVER=oracle.jdbc.OracleDriver" -e "URL=jdbc:oracle:thin:@oracledb:1521/ORCLPDB1" -e "USERNAME=frim5513" -e "PASSWORD=Passw0rd" -e "CHANGELOG_FILE=changelog/frim/oracle/ebr/update-v1-changelog.xml" -e "LOG_LEVEL=INFO" -e "CMD=update" devspace-forgerock-quickstart/idmschema:5.5.0
```

### V2 Upgrade

```console
docker run -it --rm --link oracledb:oracledb -e "DRIVER=oracle.jdbc.OracleDriver" -e "URL=jdbc:oracle:thin:@oracledb:1521/ORCLPDB1" -e "USERNAME=frim5513" -e "PASSWORD=Passw0rd" -e "CHANGELOG_FILE=changelog/frim/oracle/ebr/update-v2-changelog.xml" -e "LOG_LEVEL=INFO" -e "CMD=update" devspace-forgerock-quickstart/idmschema:5.5.0
```
