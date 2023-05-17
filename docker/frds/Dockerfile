ARG JRE_IMAGE=eclipse-temurin
ARG JRE_TAG=11.0.14_9-jre-alpine

# Binary extract
FROM alpine:3.15.0 as installFile
ARG FRDS_ARCHIVE=DS-7.2.0.zip
ARG FRDS_ARCHIVE_REPOSITORY_URL=

ADD ${FRDS_ARCHIVE_REPOSITORY_URL}${FRDS_ARCHIVE}  /var/tmp/frds.zip

RUN unzip /var/tmp/frds.zip -d /var/tmp/

# Runtime deployment
FROM ${JRE_IMAGE}:${JRE_TAG} as base
ARG DEPLOYMENT_TYPE=development

COPY --from=0 /var/tmp/opendj /opt/frds/

WORKDIR /opt/frds

ENV PATH=$PATH:/opt/frds/scripts:/opt/frds/bin

RUN apk add --no-cache tini bash && \
    addgroup -g 11111 -S forgerock && \
    adduser -h /opt/frds -G forgerock -D -u 11111 forgerock && \
    mkdir -p /opt/frds/instance/data && \
    mkdir -p /opt/frds/instance/init && \
    chmod 755 /opt/frds/instance && \
    chmod g+s /opt/frds/instance 

COPY --chown=forgerock:forgerock rootscripts/ /opt/frds/
COPY --chown=forgerock:forgerock installedfiles/ /opt/frds/
COPY --chown=forgerock:forgerock instance/${DEPLOYMENT_TYPE}/init/ /opt/frds/instance/init/

RUN chown -R forgerock:forgerock /opt/frds && \
    chmod 755 /opt/frds/*.sh && \
    chmod 755 -R /opt/frds/default-scripts/*

VOLUME /opt/frds/instance/data

USER 11111

EXPOSE 1389 1636 4444 8443

ENTRYPOINT  ["/opt/frds/docker-entrypoint.sh"]

CMD ["start"]
