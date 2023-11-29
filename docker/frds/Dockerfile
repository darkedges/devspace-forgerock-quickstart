ARG JRE_IMAGE=eclipse-temurin
ARG JRE_TAG=17.0.9_9-jre-ubi9-minimal

# Binary extract
FROM alpine:3.18.4 as installFile
ARG FRDS_ARCHIVE=DS-7.4.0.zip
ARG FRDS_ARCHIVE_REPOSITORY_URL=

ADD ${FRDS_ARCHIVE_REPOSITORY_URL}${FRDS_ARCHIVE}  /var/tmp/frds.zip

RUN unzip /var/tmp/frds.zip -d /var/tmp/ 

RUN apk add --no-cache curl && \
    curl --retry 10 -S -L -O https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 && \
    curl --retry 10 -S -L -O https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64.sha256sum && \
    sha256sum -c tini-amd64.sha256sum  && \
    rm tini-amd64.sha256sum  && \
    mv tini-amd64 /tmp/tini 

# Runtime deployment
FROM ${JRE_IMAGE}:${JRE_TAG} as base
ARG DEPLOYMENT_TYPE=development

COPY --from=0 /var/tmp/opendj /opt/frds/

WORKDIR /opt/frds

ENV PATH=$PATH:/opt/frds/scripts:/opt/frds/bin

RUN groupadd -g 11111 forgerock && \
    useradd -d /opt/frds -g forgerock -m -u 11111 forgerock && \
    mkdir -p /opt/frds/instance/data && \
    mkdir -p /opt/frds/instance/init && \
    chmod 755 /opt/frds/instance && \
    chmod g+s /opt/frds/instance 

COPY --from=installFile /tmp/tini /usr/bin/tini
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
