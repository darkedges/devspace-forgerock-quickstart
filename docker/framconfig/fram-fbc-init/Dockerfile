ARG FRAM_VERSION=7.3.0

FROM busybox as fr_am_war
ARG FRAM_VERSION
ARG FRAM_WAR_ARCHIVE=AM-7.3.0.war
ARG FRAM_ARCHIVE_REPOSITORY_URL=https://artifactory.darkedges.com/artifactory/forgerock/fram/${FRAM_VERSION}/
ADD ${FRAM_ARCHIVE_REPOSITORY_URL}${FRAM_WAR_ARCHIVE} /tmp/openam.war
COPY fram/libs /tmp
RUN unzip /tmp/openam.war -d /tmp/openam

FROM docker.io/darkedges/am-config:7.3.0 as am_config
FROM docker.io/darkedges/fr-amster:${FRAM_VERSION} as fr_amster
FROM docker.io/darkedges/am-config-upgrader:${FRAM_VERSION} as am_config_upgrader

FROM tomcat:9-jdk11

ENV FORGEROCK_HOME=/home/forgerock
ENV FRAM_HOME=$FORGEROCK_HOME/fram
ENV TOMCAT_KEYSTORE_PASSWORD=changeit
ENV JAVA_OPTS="-Djavax.net.ssl.trustStoreType=JKS \
    -Djavax.net.ssl.trustStore=/mnt/init/cacerts.jks \
    -Djavax.net.ssl.trustStorePassword=${TOMCAT_KEYSTORE_PASSWORD}"
ENV CATALINA_OPTS="-server \
    -Dcom.sun.services.debug.mergeall=on \
    -Dcom.sun.identity.configuration.directory=${FRAM_HOME} \
    -Dcom.iplanet.services.stats.state=off \
    -Dcom.sun.identity.sm.sms_object_filebased_enabled=true \
    -Dcom.sun.identity.sm.filebased_embedded_enabled=true \
    -Dorg.forgerock.donotupgrade=true \
    -DtomcatAccessLogDir=/proc/self/fd \
    -Dtomcat.connector.clientAuth=optional \
    -Dtomcat.connector.keystoreFile=/mnt/init/server_cert.p12 \
    -Dtomcat.connector.keystorePass=${TOMCAT_KEYSTORE_PASSWORD} \
    -Dtomcat.connector.keystoreType=PKCS12 \
    -Dtomcat.connector.maxHttpHeaderSize=8192 \
    -Dtomcat.connector.maxThreads=200 \
    -Dtomcat.connector.port=8443 \
    -Dtomcat.connector.scheme=https \
    -Dtomcat.connector.secure=true \
    -Dtomcat.connector.sslEnabled=true \
    -Dtomcat.connector.sslEnabledProtocols=TLSv1.2 \
    -Dtomcat.connector.sslProtocol=TLSv1.2"
RUN apt-get update && \
    apt-get install -y vim moreutils python3
RUN groupadd -g 11111 forgerock && \
    useradd -c "ForgeRock user" -m -d $FORGEROCK_HOME -u 11111 -g 11111 -G root forgerock -s /usr/bin/bash
RUN chown -R forgerock:root "$CATALINA_HOME" && \ 
    mkdir -p $FRAM_HOME && \ 
    chmod -R g+wx $FRAM_HOME
COPY --chown=forgerock:root fram/init/ /mnt/init/
COPY --chown=forgerock:root tomcat/ /usr/local/tomcat/
COPY --chown=forgerock:root --from=fr_am_war /tmp/openam /usr/local/tomcat/webapps/openam/
COPY --chown=forgerock:root --from=fr_amster /opt/amster /opt/amster
COPY --chown=forgerock:root --from=am_config_upgrader /home/forgerock/amupgrade /opt/amupgrade
COPY --chown=forgerock:root fram/amster/ /opt/amster/config/
COPY --chown=forgerock:root docker-entrypoint.sh /docker-entrypoint.sh
COPY --chown=forgerock:root fram/templates/ /opt/templates/
COPY --chown=forgerock:root fram/env/ /configurationvariables
COPY --chown=forgerock:root --from=fr_am_war /tmp/*.jar /usr/local/tomcat/webapps/openam/WEB-INF/lib
COPY --chown=forgerock:root --from=am_config /mnt/amconfig /mnt/amconfig
USER 11111
COPY fram/scripts/install $FORGEROCK_HOME
WORKDIR $FORGEROCK_HOME
RUN ./install.sh
COPY fram/scripts/placeholder $FORGEROCK_HOME
RUN ./placeholder-config.sh
WORKDIR $FRAM_HOME
RUN rm -rf opends && \
    rm -rf security && \
    rm -rf var
EXPOSE 8443
VOLUME /mnt/amconfig
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["catalina.sh", "run"]