ARG JRE_IMAGE=eclipse-temurin
ARG JRE_TAG=17.0.10_7-jre-alpine
ARG FR_TAG=7.5.0
ARG ALPINE_TAG=3.19
ARG LIQUIBASE_TAG=4.27
ARG FRIM_REPO_KIND=directory
ARG FRIM_REPO_TYPE=external

FROM gcr.io/forgerock-io/idm:${FR_TAG} as idmbase

# Initial Configuration
FROM alpine:${ALPINE_TAG} as installFile
COPY --from=idmbase /opt/openidm /var/tmp/bootstrap/openidm

RUN rm -rf /var/tmp/bootstrap/openidm/samples

FROM liquibase/liquibase:${LIQUIBASE_TAG} as jdbc

FROM alpine:${ALPINE_TAG} as repo_database_mysql
ARG FRIM_REPO_KIND
ARG FRIM_REPO_TYPE
COPY repo/${FRIM_REPO_KIND}/${FRIM_REPO_TYPE}/ /var/tmp/instance/conf/
ADD https://cdn.mysql.com/Downloads/Connector-J/mysql-connector-j-8.2.0.zip /tmp/mysql.zip
RUN unzip /tmp/mysql.zip -d /tmp/ && \
    mkdir -p /tmp/jars && \
    cp /tmp/mysql-connector-j-8.2.0/mysql-connector-j-8.2.0.jar /tmp/jars

FROM ${JRE_IMAGE}:${JRE_TAG} as repo_database_oracle
ARG FRIM_REPO_KIND
ARG FRIM_REPO_TYPE
ADD https://repo1.maven.org/maven2/biz/aQute/bnd/biz.aQute.bnd/6.4.1/biz.aQute.bnd-6.4.1.jar /tmp/biz.jar
COPY repo/${FRIM_REPO_KIND}/${FRIM_REPO_TYPE}/*.json /var/tmp/instance/conf/
COPY --from=jdbc /liquibase/internal/lib/ojdbc8.jar /tmp/ojdbc8.jar
COPY repo/${FRIM_REPO_KIND}/${FRIM_REPO_TYPE}/ojdbc8.bnd /tmp/ojdbc8.bnd
RUN mkdir -p /tmp/jars && \
    java -jar /tmp/biz.jar wrap --properties /tmp/ojdbc8.bnd --output /tmp/jars/ojdbc8-osgi.jar /tmp/ojdbc8.jar

FROM alpine:${ALPINE_TAG} as repo_database_postgresql
ARG FRIM_REPO_KIND
ARG FRIM_REPO_TYPE
COPY repo/${FRIM_REPO_KIND}/${FRIM_REPO_TYPE}/ /var/tmp/instance/conf/
RUN mkdir -p /tmp/jars

FROM alpine:${ALPINE_TAG} as repo_directory_embedded
ARG FRIM_REPO_KIND
ARG FRIM_REPO_TYPE
COPY repo/${FRIM_REPO_KIND}/${FRIM_REPO_TYPE}/ /var/tmp/instance/conf/
RUN mkdir -p /tmp/jars

FROM alpine:${ALPINE_TAG} as repo_directory_external
ARG FRIM_REPO_KIND
ARG FRIM_REPO_TYPE
COPY repo/${FRIM_REPO_KIND}/${FRIM_REPO_TYPE}/ /var/tmp/instance/conf/
RUN mkdir -p /tmp/jars

FROM repo_${FRIM_REPO_KIND}_${FRIM_REPO_TYPE} as frim_repo

FROM alpine:${ALPINE_TAG} as config
ARG FRIM_REPO_KIND
ARG FRIM_REPO_TYPE
COPY instance /var/tmp/instance
COPY --from=frim_repo /var/tmp/instance/conf /var/tmp/instance/conf
COPY --from=frim_repo /tmp/jars/ /var/tmp/instance/bundle

# Runtime deployment
FROM ${JRE_IMAGE}:${JRE_TAG} as base

COPY --from=installFile /var/tmp/bootstrap/openidm /opt/frim/

WORKDIR /opt/frim

RUN apk add --no-cache tini bash && \
    addgroup -g 11111 -S forgerock && \
    adduser -h /opt/frim -G forgerock -D -u 11111 forgerock && \   
    mkdir -p /opt/frim/instance/data && \
    chmod 755 /opt/frim/instance && \
    chmod g+s /opt/frim/instance && \
    chown -R forgerock:forgerock /opt/frim && \
    chmod 755 /opt/frim/*.sh

COPY --chown=forgerock:forgerock rootscripts/*.sh /opt/frim/

RUN chmod 755 /opt/frim/*.sh

COPY --chown=forgerock:forgerock --from=config /var/tmp/instance /opt/frim/instance/data/

VOLUME [ "/opt/frim/instance/data" ]

USER 11111

ENTRYPOINT ["/opt/frim/docker-entrypoint.sh"]

CMD ["start"]
