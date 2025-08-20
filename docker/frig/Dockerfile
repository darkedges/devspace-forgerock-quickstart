ARG JRE_IMAGE=eclipse-temurin
ARG JRE_TAG=17.0.12_7-jre-alpine
ARG IG_TAG=2024.6.0
ARG ALPINE_TAG=3.19

FROM gcr.io/forgerock-io/ig:${IG_TAG} AS igbase

# Binary extract
FROM alpine:${ALPINE_TAG} AS installfile
COPY --from=igbase /opt/ig /var/tmp/bootstrap/ig

# Runtime deployment
FROM ${JRE_IMAGE}:${JRE_TAG} AS base

COPY --from=installfile /var/tmp/bootstrap/ig /opt/frig/

WORKDIR /opt/frig

ENV INSTANCE_DIR="/opt/frig/instance"

RUN apk add --no-cache tini bash curl jq && \
    addgroup -g 11111 -S forgerock && \
    adduser -h /opt/frig -G forgerock -D -u 11111 forgerock && \
    mkdir -p /opt/frig/instance && \
    chown -R forgerock:forgerock /opt/frig

RUN mkdir /var/run/secrets/ && \
    echo "changeit" > /var/run/secrets/keystore.pass && \
    keytool -genkey -alias https-connector-key -keyalg RSA -keystore /var/run/secrets/keystore.pkcs12 -storepass changeit -keypass changeit -dname "CN=platform.7f000001.nip.io" -ext SAN=DNS:platform.7f000001.nip.io

COPY --chown=forgerock:forgerock rootscripts/*.sh /opt/frig/

RUN chmod 755 /opt/frig/*.sh

COPY --chown=forgerock:forgerock instance  /opt/frig/instance/

VOLUME [ "/opt/frig/instance" ]

USER 11111

EXPOSE 8080

ENTRYPOINT  ["/opt/frig/docker-entrypoint.sh"]

CMD ["start"]
