ARG JRE_IMAGE=darkedges/jre
ARG JRE_TAG=11.0.14_9-jre-alpine

# Initial Configuration
FROM alpine:3.15.0 as installFile
ARG FRIM_ARCHIVE=IDM-7.4.0.zip
ARG FRIM_ARCHIVE_REPOSITORY_URL=

ADD ${FRIM_ARCHIVE_REPOSITORY_URL}${FRIM_ARCHIVE}  /var/tmp/frim.zip

RUN unzip /var/tmp/frim.zip -d /var/tmp/bootstrap/ && \
    rm -rf /var/tmp/bootstrap/openidm/samples

# Runtime deployment
FROM ${JRE_IMAGE}:${JRE_TAG} as base

COPY --from=0 /var/tmp/bootstrap/openidm /opt/frim/

WORKDIR /opt/frim

RUN apk add --no-cache tini bash jq curl && \
    addgroup -g 11111 -S forgerock && \
    adduser -h /opt/frim -G forgerock -D -u 11111 forgerock && \   
    mkdir -p /opt/frim/instance/data && \
    chmod 755 /opt/frim/instance && \
    chmod g+s /opt/frim/instance && \
    chown -R forgerock:forgerock /opt/frim && \
    chmod 755 /opt/frim/*.sh

COPY --chown=forgerock:forgerock rootscripts/*.sh /opt/frim/

RUN chmod 755 /opt/frim/*.sh

COPY --chown=forgerock:forgerock instance /opt/frim/instance/data/

VOLUME [ "/opt/frim/instance/data" ]

USER 11111

ENTRYPOINT ["/opt/frim/docker-entrypoint.sh"]

CMD ["start"]
