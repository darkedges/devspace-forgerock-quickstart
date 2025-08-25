# Upgrade

1. Build AM Config Updater

    ```console
    docker build . -t devspace-forgerock-quickstart/am-config-upgrader:8.0.1
    ```

1. Upgrade am 7.5.0 to 8.0.1

    ```console
    docker run -it --rm --volume ${PWD}/config:/tmp/fram --volume darkedgessecrets:/mnt/secrets devspace-forgerock-quickstart/am-config-upgrader:8.0.1
    ```

1. Build AM Config image

    ```console
    docker build -f Dockerfile.amconfig -t devspace-forgerock-quickstart/am-config:8.0.1 .
    ```

1. Build AM FBC Image

    ```console
    cd fram-fbc-init
    docker build -t devspace-forgerock-quickstart/am-fbc-init:8.0.1 .
    ```
