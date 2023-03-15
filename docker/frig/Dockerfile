ARG JRE_IMAGE=eclipse-temurin
ARG JRE_TAG=11.0.14_9-jre-alpine

# Binary extract
FROM alpine:3.15.0 as installFile
ARG FRIG_ARCHIVE=IG-2023.2.0.zip
ARG FRIG_ARCHIVE_REPOSITORY_URL=

ADD ${FRIG_ARCHIVE_REPOSITORY_URL}${FRIG_ARCHIVE}  /var/tmp/frig.zip

RUN unzip /var/tmp/frig.zip -d /var/tmp/

# Runtime deployment
FROM ${JRE_IMAGE}:${JRE_TAG} as base

COPY --from=0 /var/tmp/identity-gateway /opt/frig/

WORKDIR /opt/frig

ENV INSTANCE_DIR /opt/frig/instance

RUN apk add --no-cache tini bash curl jq && \
    addgroup -g 11111 -S forgerock && \
    adduser -h /opt/frig -G forgerock -D -u 11111 forgerock && \
    mkdir -p /opt/frig/instance && \
    chown -R forgerock:forgerock /opt/frig

COPY --chown=forgerock:forgerock rootscripts/*.sh /opt/frig/

RUN chmod 755 /opt/frig/*.sh

COPY --chown=forgerock:forgerock instance  /opt/frig/instance/

VOLUME [ "/opt/frig/instance" ]

USER 11111

EXPOSE 8080

ENTRYPOINT  ["/opt/frig/docker-entrypoint.sh"]

CMD ["start"]
