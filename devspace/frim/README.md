# devspace-forgerock-frim

This is a simple POC for using [DevSpace](https://devspace.sh) to develop a Kubernetes instance of [ForgeRock Identity Manager](https://www.forgerock.com/platform/identity-management).

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

1. Download [IDM-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:am/productId:idm/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip) to `docker/frim/IDM-7.2.0.zip`

## Develop

### Local file change

1. Init DevSpace

   ```console
   cd devspace-forgerock-quickstart/devspace/frim
   devspace use namespace devspace-forgerock-quickstart
   ```

1. Start Developing

   ```console
   devspace dev
   ```

1. Open [http://am.7f000001.nip.io:8080/](http://am.7f000001.nip.io:8080/) and it should return show the c Login page.

1. clean up

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
   cd devspace-forgerock-quickstart/devspace/frim
   devspace enter --label-selector app.kubernetes.io/component=frim
   ```

1. Open a browser to <http://frim.7f000001.nip.io:8080/> and it should redirect you to `http://am.7f000001.nip.io:8080/openam/XUI/#login/`

   The default credentials are `amadmin`:`Passw0rd`

1. create `docker/frim/instance/conf/endpoint-helloworld.json` with the following content

   ```json
   {
      "context": "endpoint/hellworld/*",
      "type": "text/javascript",
      "source": "(function(){return {\"hello\": \"world\"}})();"
   }
   ```

1. wait for the following to show up in the console

   ```console
   dev:ports-2 sync  Downstream - Download file './conf/endpoint-helloworld.json', uncompressed: ~0.14 KB
   dev:ports-2 sync  Downstream - Successfully processed 1 change(s)
   ```

1. in a console enter

   ```console
   curl http://idm.7f000001.nip.io/openidm/endpoint/hellworld --header "X-OpenIDM-Username: openidm-admin" --header "X-OpenIDM-Password: openidm-admin" --header "Accept-API-Version: resource=1.0" 
   ```

   it should return

   ```console
   {"_id":"","hello":"world"}
   ```

1. view [docker/frim/instance/endpoint-helloworld.json](../../docker/frim/instance/endpoint-helloworld.json) and check line it has been created.

   ```json
   {
      "context": "endpoint/hellworld/*",
      "type": "text/javascript",
      "source": "(function(){return {\"hello\": \"world\"}})();"
   }
   ```

1. edit [docker/frim/instance/endpoint-helloworld.json](../../docker/frim/instance/endpoint-helloworld.json) and change to below.

   ```json
   {
      "context": "endpoint/hellworld/*",
      "type": "text/javascript",
      "source": "(function(){return {\"hello\": \"world!!"}})();"
   }
   ```

   The following should appear in the devspace console

   ```console
   dev:ports-2 sync  Upstream - Upload File 'conf/endpoint-helloworld.json'
   dev:ports-2 sync  Upstream - Upload 1 create change(s) (Uncompressed ~0.14 KB)
   dev:ports-2 sync  Upstream - Successfully processed 1 change(s)
   ```

1. confirm it is working

   ```console
   curl http://idm.7f000001.nip.io/openidm/endpoint/hellworld --header "X-OpenIDM-Username: openidm-admin" --header "X-OpenIDM-Password: openidm-admin" --header "Accept-API-Version: resource=1.0" 
   ```

   it should return

   ```console
   {"_id":"","hello":"world!!"}
   ```

1. delete [docker/frim/instance/endpoint-helloworld.json](../../docker/frim/instance/endpoint-helloworld.json)

   ```console
   dev:ports-2 sync  Upstream - Handling 1 removes
   dev:ports-2 sync  Upstream - Remove 'conf/endpoint-helloworld.json'
   dev:ports-2 sync  Upstream - Remove 'conf/endpoint-helloworld.json'
   dev:ports-2 sync  Upstream - Successfully processed 1 change(s)
   ```

1. confirm it has been deleted

   ```console
   curl http://idm.7f000001.nip.io/openidm/endpoint/hellworld --header "X-OpenIDM-Username: openidm-admin" --header "X-OpenIDM-Password: openidm-admin" --header "Accept-API-Version: resource=1.0" 
   ```

   it should return

   ```console
   {"code":404,"reason":"Not Found","message":"Resource &#39;endpoint/hellworld&#39; not found"}
   ```
