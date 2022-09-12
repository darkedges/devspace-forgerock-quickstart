# devspace-forgerock-frig

This is a simple POC for using [DevSpace](https://devspace.sh) to develop a Kubernetes instance of [ForgeRock Identity Gateway](https://www.forgerock.com/platform/identity-gateway).

It uses

- [DevSpace](https://devspace.sh/) - [devspace](devspace)
- [Helm](https://helm.sh/) - [helm chart](helm)
- [Docker](https://www.docker.com/) - [Dockerfile](docker/Dockerfile)

## Prerequisites

1. checkout these repositories

   ```bash
   git clone https://github.com/darkedges/devspace-forgerock-quickstart
   ```

2. Install

   - [Helm](https://helm.sh/docs/intro/install/)
   - [Docker](https://docs.docker.com/get-docker/)
   - [DevSpace](https://devspace.sh/cli/docs/getting-started/installation)

3. Download [IG-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:ig/productId:ig/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip) to `docker/frig/IG-7.2.0.zip`

## Develop

### Local file change

1. Init DevSpace

   ```bash
   cd devspace-forgerock-quickstart/devspace/frig
   devspace use namespace devspace-forgerock-quickstart
   ```

2. Start Developing

   ```bash
   devspace dev
   ```

3. Open [http://ig.7f000001.nip.io:8080/hello](http://ig.7f000001.nip.io:8080/hello) and it should return the pod hostname.

4. edit [docker/frig/instance/scripts/groovy/hello.groovy](../../docker/frig/instance/scripts/groovy/hello.groovy) and change line 2 to 

   ```java
   response.entity = "hello " + java.net.InetAddress.getLocalHost().getHostName();` and save
   ```

5. wait for the following to show up in the console

    ```bash
    dev:ports-0 sync  Upstream - Upload File 'scripts/groovy/hello.groovy'
    dev:ports-0 sync  Upstream - Upload 1 create change(s) (Uncompressed ~0.13 KB)
    dev:ports-0 sync  Upstream - Successfully processed 1 change(s)
    ```

   and reload [http://ig.7f000001.nip.io:8080/hello](http://ig.7f000001.nip.io:8080/hello) which should return `hello ` and the pod hostname

### Remote file change

1. Start Developing

   ```bash
   devspace dev
   ```

2. in a second console enter

   ```bash
   cd devspace-forgerock-quickstart/devspace/frig
   devspace enter
   ```

3. Edit `instance/scripts/groovy/hello.groovy` and change line 2 back to 
   
   ```java
   response.entity = "hello " + java.net.InetAddress.getLocalHost().getHostName();` and save
   ```

4. wait for the following to show up in the console

   ```bash
   dev:ports-0 sync  Downstream - Download file './scripts/groovy/hello.groovy', uncompressed: ~0.13 KB
   dev:ports-0 sync  Downstream - Successfully processed 1 change(s)
   ```

   and reload [http://ig.7f000001.nip.io:8080/hello](http://ig.7f000001.nip.io:8080/hello) which should return the hostname.

5. view [docker/frig/instance/scripts/groovy/hello.groovy](../../docker/frig/instance/scripts/groovy/hello.groovy) and check line 2 is 
   
   ```java
   response.entity = "hello " + java.net.InetAddress.getLocalHost().getHostName();` and save
   ```