ARG FRAM_VERSION=7.5.0
ARG ALPINE_TAG=3.19

FROM alpine:${ALPINE_TAG} as fr_am_war
ARG FRAM_VERSION
ARG FRAM_WAR_ARCHIVE=AM-${FRAM_VERSION}.zip
ARG FRAM_ARCHIVE_REPOSITORY_URL=
ADD ${FRAM_ARCHIVE_REPOSITORY_URL}${FRAM_WAR_ARCHIVE} /tmp/am.war
COPY fram/libs /tmp
RUN unzip /tmp/am.war -d /tmp/am

FROM gcr.io/forgerock-io/amster:${FRAM_VERSION} as fr_amster
FROM gcr.io/forgerock-io/am-config-upgrader:${FRAM_VERSION} as am_config_upgrader

FROM tomcat:9-jre17

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
COPY --chown=forgerock:root --from=fr_am_war /tmp/am /usr/local/tomcat/webapps/am/
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
RUN ./install.sh
COPY fram/scripts/placeholder $FORGEROCK_HOME
RUN ./placeholder-config.sh
WORKDIR $FRAM_HOME
RUN rm -rf opends && \
    rm -rf security && \
    rm -rf var
EXPOSE 8080
VOLUME /mnt/amconfig
ENV CATALINA_OPTS="-server -Dcom.sun.services.debug.mergeall=on -Dcom.sun.identity.configuration.directory=/home/forgerock/openam -Dcom.iplanet.services.stats.state=off -Dcom.sun.identity.sm.sms_object_filebased_enabled=true -Dorg.forgerock.donotupgrade=true -DtomcatAccessLogDir=/proc/self/fd -DtomcatAccessLogFile=1 --add-opens java.xml/com.sun.org.apache.xerces.internal.dom=ALL-UNNAMED"
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["catalina.sh", "run"]