# Upgrade

1. Build AM Config Updater

    ```console
    docker build . -t devspace-forgerock-quickstart/am-config-upgrader:7.4.0
    ```

1. Convert am to 7.4.0

    ```console
    docker run -it --rm --volume ${pwd}:/tmp/fram --volume darkedgessecrets:/mnt/secrets devspace-forgerock-quickstart/am-config-upgrader:7.4.0
    ```

1. Build AM Config image

    ```console
    docker build -f Dockerfile.amconfig -t devspace-forgerock-quickstart/am-config:7.4.0 .
    ```

1. Build AM FBC Image

    ```console
    cd fram-fbc-init
    docker build -t devspace-forgerock-quickstart/am-fbc-init:7.4.0 .
    ```
