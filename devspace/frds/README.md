# devspace-forgerock-frds

This is a simple POC for using [DevSpace](https://devspace.sh) to develop a Kubernetes instance of [ForgeRock Directory Services](https://www.forgerock.com/platform/directory-services).

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

3. Download [DS-7.2.0.zip](https://backstage.forgerock.com/downloads/get/familyId:ig/productId:ds/minorVersion:7.2/version:7.2.0/releaseType:full/distribution:zip) to `docker/frds/DS-7.2.0.zip`

## Develop
1. Init DevSpace

   ```console
   cd devspace-forgerock-quickstart/devspace/frig
   devspace use namespace devspace-forgerock-quickstart
   ```

2. Start Developing

   ```console
   devspace dev
   ```

3. clean up

   ```console
   devspace purge
   ```

### Connect to localhost

The following ports are open to the local instance:

| port number | type  |
| ----------- | ----- |
| `1389`      | LDAP  |
| `1636`      | LDAPS |

Meaning you can connect via a tool like Apache Directory Studio.

### Connect to instance

1. Open another command prompt and navigate to `devspace-forgerock-quickstart`
2. Enter `devspace enter` and it will connect to the FRDS instance.
3. In the console enter

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

4. enter the following

   ```console
   cd instance/init
   touch test
   ```

   in the devspace console you will see

   ```console
   dev:ports-0 sync  Downstream - Download file './test', uncompressed: ~0.00 KB
   dev:ports-0 sync  Downstream - Successfully processed 1 change(s)
   ```

   and in the `docker/instance/init` folder you will find a file named `test`

5. delete `docker/instance/init/test` the devspace console will report

   ```console
   ev:ports-0 sync  Upstream - Handling 1 removes
   dev:ports-0 sync  Upstream - Remove 'test'
   dev:ports-0 sync  Upstream - Remove 'test'
   dev:ports-0 sync  Upstream - Successfully processed 1 change(s)
   ```

   check in the runnin instance and the file will have gone

   ```console
   bash-5.1$ ls -l /opt/frds/instance/init
   total 0
   ```

## Enhancements

An LDAP Idempotent tool will be release and will be added to this framework so that changes to LDIF files in the `instance/init` folder will be automatically applied, allowing any changes to applied wihtout having to destory and recreate the instance.
