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

3. Open [http://am.7f000001.nip.io:8080/](http://am.7f000001.nip.io:8080/) and it should return show the FRAM Login page.

   The default credentials are `amadmin`:`Passw0rd`

4. clean up

   ```console
   devspace purge
   ```

### Remote file change

1. Start Developing

   ```console
   devspace dev
   ```

1. in a second console enter

   ```console
   cd devspace-forgerock-quickstart/devspace/fram
   devspace enter
   ```

1. Open a browser to <http://fram.7f000001.nip.io:8080/> and it should redirect you to `http://am.7f000001.nip.io:8080/openam/XUI/#login/`

1. Edit `/opt/amster/config/config/global/Realms` and add `"fram.7f000001.nip.io"` to the list of values in `data/aliases`

   ```json
   {
      "metadata": {
         "realm": null,
         "amsterVersion": "7.2.0",
         "entityType": "Realms",
         "entityId": "Lw",
         "pathParams": {}
      },
      "data": {
         "_id": "Lw",
         "parentPath": null,
         "active": true,
         "name": "/",
         "aliases": [
            "localhost",
            "am.7f000001.nip.io",
            "fram.7f000001.nip.io",
            "amconfig"
         ]
      }
   }
   ```

1. wait for the following to show up in the console

   ```console
   dev:ports-0 sync  Downstream - Download file './config/global/Realms/root.json', uncompressed: ~0.35 KB
   dev:ports-0 sync  Downstream - Successfully processed 1 change(s)
   ```

1. view [docker/fram/instance/amster/config/global/Realms/root.json](../../docker/fram/instance/amster/config/global/Realms/root.json) and check line it has been updated.

   ```json
   {
      "metadata": {
         "realm": null,
         "amsterVersion": "7.2.0",
         "entityType": "Realms",
         "entityId": "Lw",
         "pathParams": {}
      },
      "data": {
         "_id": "Lw",
         "parentPath": null,
         "active": true,
         "name": "/",
         "aliases": [
            "localhost",
            "am.7f000001.nip.io",
            "fram.7f000001.nip.io",
            "amconfig"
         ]
      }
   }
   ```

1. Deploy teh configuration change using the following commands

   ```console
   cd /opt/amster/config
   ./importConfig.sh
   ```

   should return

   ```console
   + export SERVER_PORT=8080
   + SERVER_PORT=8080
   + export SERVER_URL=am.7f000001.nip.io
   + SERVER_URL=am.7f000001.nip.io
   + export SERVER_SCHEME=http
   + SERVER_SCHEME=http
   + '[' -z am.7f000001.nip.io ']'
   + export AMSTER_URL=http://am.7f000001.nip.io:8080/openam
   + AMSTER_URL=http://am.7f000001.nip.io:8080/openam
   + /opt/amster/amster /opt/amster/config/importConfig.amster
   Amster OpenAM Shell (7.2.0 build 64ef7ebc01ed3df1a1264d7b0400351bc101361f, JVM: 11.0.14)
   Type ':help' or ':h' for help.
   ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   am> :load /opt/amster/config/importConfig.amster
   ===> http://am.7f000001.nip.io:8080/openam
   Imported /opt/amster/config/config/global/Realms/root.json
   Imported /opt/amster/config/config/DefaultCtsDataStoreProperties.json
   ```

1. Open a browser to <http://fram.7f000001.nip.io:8080/> and it should redirect you to `http://fram.7f000001.nip.io:8080/openam/XUI/#login/`

1. delete the line from the local file and confirm this appears in the console

   ```console
   dev:ports-0 sync  Upstream - Upload File 'config/global/Realms/root.json'
   dev:ports-0 sync  Upstream - Upload 1 create change(s) (Uncompressed ~0.32 KB)
   dev:ports-0 sync  Upstream - Successfully processed 1 change(s)
   ```

1. confirm it has changed on the FRAM instance

   ```console
   more /opt/amster/config/config/global/Realms/root.json
   ```

   returns

   ```console
   {
      "metadata": {
         "realm": null,
         "amsterVersion": "7.2.0",
         "entityType": "Realms",
         "entityId": "Lw",
         "pathParams": {}
      },
      "data": {
         "_id": "Lw",
         "parentPath": null,
         "active": true,
         "name": "/",
         "aliases": [
            "localhost",
            "am.7f000001.nip.io",
            "amconfig"
         ]
      }
   }
   ```
