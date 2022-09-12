# Devspace Quickstart for ForgeRock

This is a collection of Helm Charts and Devspace Configurations to deploy the ForgeRock Platform quickly into a Kubernetes 1.20+ environment.

Currently it is supporting only the following services

- ForgeRock Identity Gateway

the following will follow shortly

- ForgeRock Identity Manager
- ForgeRock Access Manager
- ForgeRock Directory Services

## Repository Folder Layout

1. Helm Charts are located in the [helm](helm) folder.
2. Helm Chart Values are located in the [values/environment](values/environment) folder.
3. Docker Images are located in the [docker](docker) folder.
4. Devspace Configuration are located in the [devspace](devspace) folder.

Each folder will have the following mapping attached

| Product                     | Folder |
| --------------------------- | ------ |
| ForgeRock Identity Gateway  | `frig` |
| ForgeRock Identity Manager  | `frim` |
| ForgeRock Access Manager    | `fram` |
| ForgeRock Directory Service | `frds` |

except `values/environments` where there are 2 environments defined

- [devspace](values/environment/devspace)
- [localdev](values/environment/localdev)

and the values will be in the format above as yaml files.

## Quick Start

The following quickstarts guides will get each Service up and running with a simple command

| Product                     | Folder                         |
| --------------------------- | ------------------------------ |
| ForgeRock Identity Gateway  | [devspace/frig](devspace/frig/README.md) |
| ForgeRock Identity Manager  | [devspace/frim](devspace/frim/README.md) |
| ForgeRock Access Manager    | [devspace/fram](devspace/fram/README.md) |
| ForgeRock Directory Service | [devspace/frds](devspace/frds/README.md) |

In order to complete the QuickStarts it is recommended to install the following utilities

- [DevSpace](https://devspace.sh/) - [devspace](devspace)
- [Helm](https://helm.sh/) - [helm chart](helm)
- [Docker](https://www.docker.com/) - [Dockerfile](docker/Dockerfile)

Further it is recommended to download the necessary artefacts for each product.

| Product                     | Link                         | Artefact Location and Name |
| --------------------------- | ------------------------------ | --- |
| ForgeRock Identity Gateway  | [IG-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:ig/productId:ig/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip)  | `docker/frig/IG-7.2.0.zip` |
| ForgeRock Identity Manager  | [IDM-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:idm/productId:idm/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip) | `docker/frim/IDM-7.2.0.zip` |
| ForgeRock Access Manager    | [AM-7.2.0.war](https://backstage.forgerock.com/downloads/get/familyId:am/productId:am/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:war) <br/>[Amster-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:am/productId:amster/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip)  | `docker/fram/AM-7.2.0.war`<br/>`docker/fram/Amster-7.2.0.zip` |
| ForgeRock Directory Service | [DS-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:ds/productId:ds/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip)  | `docker/frds/DS-7.2.0.zip` |
