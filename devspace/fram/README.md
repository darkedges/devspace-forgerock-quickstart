# devspace-forgerock-fram

This is a simple POC for using [DevSpace](https://devspace.sh) to develop a Kubernetes instance of [ForgeRock Access Manager](https://www.forgerock.com/platform/access-management).

It uses

- [DevSpace](https://devspace.sh/) - [devspace](devspace)
- [Helm](https://helm.sh/) - [helm chart](helm)
- [Docker](https://www.docker.com/) - [Dockerfile](docker/Dockerfile)

## Prerequisites

1. checkout these repositories

   ```console
   git clone https://github.com/darkedges/devspace-forgerock-quickstart
   ```

2. Install

   - [Helm](https://helm.sh/docs/intro/install/)
   - [Docker](https://docs.docker.com/get-docker/)
   - [DevSpace](https://devspace.sh/cli/docs/getting-started/installation)

3. Download [AM-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:am/productId:am/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip) to `docker/fram/AM-7.2.0.zip`
4. Download [Amster-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:am/productId:amster/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip) to `docker/fram/Amster-7.2.0.zip`

## Develop

### Local file change

1. Init DevSpace

   ```console
   cd devspace-forgerock-quickstart/devspace/fram
   devspace use namespace devspace-forgerock-quickstart
   ```

2. Start Developing

   ```console
   devspace dev
   ```

3. Open [http://ig.7f000001.nip.io:8080/](http://ig.7f000001.nip.io:8080/) and it should return show the FRAM Login page.

4. clean up

   ```console
   devspace purge
   ```

### Remote file change

1. Start Developing

   ```console
   devspace dev
   ```

2. in a second console enter

   ```console
   cd devspace-forgerock-quickstart/devspace/fram
   devspace enter
   ```

3. Edit `/opt/amster/config/test` and change line 2 back to
   
   ```java
   response.entity = "hello " + java.net.InetAddress.getLocalHost().getHostName();` and save
   ```

4. wait for the following to show up in the console

   ```console
   dev:ports-0 sync  Downstream - Download file './scripts/groovy/hello.groovy', uncompressed: ~0.13 KB
   dev:ports-0 sync  Downstream - Successfully processed 1 change(s)
   ```

   and reload [http://ig.7f000001.nip.io:8080/hello](http://ig.7f000001.nip.io:8080/hello) which should return the hostname.

5. view [docker/fram/instance/scripts/groovy/hello.groovy](../../docker/fram/instance/scripts/groovy/hello.groovy) and check line 2 is 
   
   ```java
   response.entity = "hello " + java.net.InetAddress.getLocalHost().getHostName();` and save
   ```