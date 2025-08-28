ARG FRAM_VERSION=8.0.1
ARG ALPINE_TAG=3.19

FROM alpine:${ALPINE_TAG} AS fr_am_war
ARG FRAM_VERSION
ARG FRAM_WAR_ARCHIVE=AM-${FRAM_VERSION}.zip
ARG FRAM_ARCHIVE_REPOSITORY_URL=
ADD ${FRAM_ARCHIVE_REPOSITORY_URL}${FRAM_WAR_ARCHIVE} /tmp/am.zip
RUN unzip /tmp/am.zip -d /tmp && \
    unzip -d /tmp/am_war /tmp/openam/AM-8.0.1.war 

FROM gcr.io/forgerock-io/amster:${FRAM_VERSION} AS fr_amster
FROM gcr.io/forgerock-io/am-config-upgrader:${FRAM_VERSION} AS am_config_upgrader

FROM tomcat:10-jre21

ENV FORGEROCK_HOME=/home/forgerock
ENV FRAM_HOME=$FORGEROCK_HOME/openam
ENV TOMCAT_KEYSTORE_PASSWORD=changeit
ENV JAVA_OPTS=""
ENV FRAM_CONTAINER_JVM_ARGS=-XX:MaxRAMPercentage=75 -XX:InitialRAMPercentage=75 -XX:MaxTenuringThreshold=1 -Djava.security.egd=file:/dev/urandoms

RUN apt-get update
RUN apt-get install -y patch
RUN groupadd -g 11111 forgerock && \
    useradd -c "ForgeRock user" -m -d $FORGEROCK_HOME -u 11111 -g 11111 -G root forgerock -s /usr/bin/bash && \
    chown -R forgerock:root "$CATALINA_HOME" && \ 
    mkdir -p $FRAM_HOME && \ 
    chmod -R g+wx $FRAM_HOME
COPY --chown=forgerock:root --from=fr_am_war /tmp/am_war /usr/local/tomcat/webapps/am/
COPY --chown=forgerock:root --from=fr_amster /opt/amster /opt/amster
COPY --chown=forgerock:root --from=am_config_upgrader /home/forgerock/amupgrade /opt/amupgrade
COPY --chown=forgerock:root fram/amster/ /opt/amster/config/
COPY --chown=forgerock:root docker-entrypoint.sh /docker-entrypoint.sh
COPY --chown=forgerock:root fram/templates/ /opt/templates/
COPY --chown=forgerock:root --from=fr_am_war /tmp/*.jar /usr/local/tomcat/webapps/am/WEB-INF/lib
USER 11111
COPY fram/scripts/install $FORGEROCK_HOME
COPY amconfig/ /mnt/amconfig/
WORKDIR $FORGEROCK_HOME
COPY fram/scripts/placeholder $FORGEROCK_HOME
WORKDIR $FRAM_HOME
EXPOSE 8080
VOLUME /mnt/amconfig
ENV CATALINA_OPTS="-server -Dcom.sun.identity.configuration.directory=/home/forgerock/openam -Dcom.sun.identity.sm.sms_object_filebased_enabled=true -Dam.server.fqdn=am.7f000001.nip.io -Dam.stores.user.servers=fbc-ds:1389 -Dam.stores.user.username=uid=am-identity-bind-account,ou=admins,ou=identities -Dam.stores.user.password=Passw0rd -Dam.stores.user.ssl.enabled -Dam.stores.application.servers=fbc-ds:1389 -Dam.stores.application.password=Passw0rd -Dam.stores.application.ssl.enabled=false"
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["catalina.sh", "run"]