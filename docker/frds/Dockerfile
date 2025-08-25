ARG JRE_IMAGE=eclipse-temurin
ARG JRE_TAG=21.0.8_9-jre-alpine
ARG FR_TAG=8.0.0
ARG ALPINE_TAG=3.19

FROM gcr.io/forgerock-io/ds:${FR_TAG} AS dsbase

# Binary extract
FROM alpine:${ALPINE_TAG} AS installfile
COPY --from=dsbase /opt/opendj /var/tmp/bootstrap/opendj

# Runtime deployment
FROM ${JRE_IMAGE}:${JRE_TAG} AS base
ARG DEPLOYMENT_TYPE=directory

WORKDIR /opt/frds

ENV PATH=$PATH:/opt/frds/scripts:/opt/frds/bin

RUN apk add --no-cache tini gettext bash && \
    addgroup -g 11111 -S forgerock && \
    adduser -h /opt/frds -G forgerock -D -u 11111 forgerock && \
    mkdir -p /opt/frds/instance/data && \
    mkdir -p /opt/frds/instance/init && \
    chmod 755 /opt/frds/instance && \
    chmod g+s /opt/frds/instance 

COPY --from=installfile /var/tmp/bootstrap/opendj /opt/frds/
COPY --chown=forgerock:forgerock rootscripts/ /opt/frds/
COPY --chown=forgerock:forgerock installedfiles/ /opt/frds/
COPY --chown=forgerock:forgerock instance/${DEPLOYMENT_TYPE}/ /opt/frds/instance/init/

RUN chown -R forgerock:forgerock /opt/frds && \
    chmod 755 /opt/frds/*.sh && \
    chmod 755 -R /opt/frds/default-scripts/*

VOLUME /opt/frds/instance/data

USER 11111

EXPOSE 1389 1636 4444 8443

ENTRYPOINT  ["/opt/frds/docker-entrypoint.sh"]

CMD ["start"]
