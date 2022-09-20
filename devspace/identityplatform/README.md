# devspace-forgerock-identityplatform

This is a simple POC for using [DevSpace](https://devspace.sh) to develop a Kubernetes instance of [ForgeRock Identity Platform](https://backstage.forgerock.com/docs/platform/7.2/platform-guide/about.html).

It uses

- [DevSpace](https://devspace.sh/) - [devspace](devspace)
- [Helm](https://helm.sh/) - [helm chart](helm)
- [Docker](https://www.docker.com/) - [Dockerfile](docker/Dockerfile)

## Prerequisites

1. checkout these repositories

   ```console
   git clone https://github.com/darkedges/devspace-forgerock-quickstart
   ```

1. Install

   - [Helm](https://helm.sh/docs/intro/install/)
   - [Docker](https://docs.docker.com/get-docker/)
   - [DevSpace](https://devspace.sh/cli/docs/getting-started/installation)

1. Please review the guides below fror installation requirements

   - [ForgeRock Identity Gateway](../frig/README.md#prerequisites)
   - [ForgeRock Directory Services](../frds/README.md#prerequisites)
   - [ForgeRock Access Manager](../fram/README.md#prerequisites)
   - [ForgeRock Identity Manager](../frim/README.md#prerequisites)

## Develop

Please review the guides below for development

- [ForgeRock Identity Gateway](../frig/README.md#develop)
- [ForgeRock Directory Services](../frds/README.md#develop)
- [ForgeRock Access Manager](../fram/README.md#develop)
- [ForgeRock Identity Manager](../frim/README.md#develop)

## Note:

Ports are different dues to them not being able to use the smae one.

- [ForgeRock Identity Gateway](http://ig7f000001.nip.io:8080)
- [ForgeRock Access Manager](http://ig7f000001.nip.io:8081)
- [ForgeRock Identity Manager](http://ig7f000001.nip.io:8082)
