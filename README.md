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

## Quick Start - Docker Compose

1. Start the Directory Server
   ```console
   docker-compose run dfq-ds
   ```
2. When it has completed Stop it using `<ctrl> c`
3. Start the Ping Identity Platform
   ```console
   docker-compose up
   ```
5. When it has completed startup the OAuth2 Clients needs to be seeded.
   ```console
   docker exec -it dfq-am /opt/amster/config/importConfig.sh
   ```
6. Access via <https://platform.7f000001.nip.io:8443/platform-login/?realm=/#/> and when prompted for credential use `amadmin:Passw0rd`

