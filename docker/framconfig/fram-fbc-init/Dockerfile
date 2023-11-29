ARG FRAM_VERSION=7.4.0

FROM busybox as fr_am_war
ARG FRAM_VERSION
ARG FRAM_WAR_ARCHIVE=AM-${FRAM_VERSION}.zip
ARG FRAM_ARCHIVE_REPOSITORY_URL=
ADD ${FRAM_ARCHIVE_REPOSITORY_URL}${FRAM_WAR_ARCHIVE} /tmp/openam.war
COPY fram/libs /tmp
RUN unzip /tmp/openam.war -d /tmp/openam

FROM gcr.io/forgerock-io/amster:${FRAM_VERSION} as fr_amster
FROM gcr.io/forgerock-io/am-config-upgrader:${FRAM_VERSION} as am_config_upgrader

FROM tomcat:9-jdk11

ENV FORGEROCK_HOME=/home/forgerock
ENV FRAM_HOME=$FORGEROCK_HOME/fram
ENV TOMCAT_KEYSTORE_PASSWORD=changeit
ENV JAVA_OPTS=""
ENV CATALINA_OPTS="-server \
    -Dcom.sun.services.debug.mergeall=on \
    -Dcom.sun.identity.configuration.directory=${FRAM_HOME} \
    -Dcom.iplanet.services.stats.state=off \
    -Dcom.sun.identity.sm.sms_object_filebased_enabled=true \
    -Dcom.sun.identity.sm.filebased_embedded_enabled=true \
    -Dorg.forgerock.donotupgrade=true"
RUN apt-get update && \
    apt-get install -y vim moreutils python3
RUN groupadd -g 11111 forgerock && \
    useradd -c "ForgeRock user" -m -d $FORGEROCK_HOME -u 11111 -g 11111 -G root forgerock -s /usr/bin/bash
RUN chown -R forgerock:root "$CATALINA_HOME" && \ 
    mkdir -p $FRAM_HOME && \ 
    chmod -R g+wx $FRAM_HOME
COPY --chown=forgerock:root --from=fr_am_war /tmp/openam /usr/local/tomcat/webapps/openam/
COPY --chown=forgerock:root --from=fr_amster /opt/amster /opt/amster
COPY --chown=forgerock:root --from=am_config_upgrader /home/forgerock/amupgrade /opt/amupgrade
COPY --chown=forgerock:root fram/amster/ /opt/amster/config/
COPY --chown=forgerock:root docker-entrypoint.sh /docker-entrypoint.sh
COPY --chown=forgerock:root fram/templates/ /opt/templates/
COPY --chown=forgerock:root --from=fr_am_war /tmp/*.jar /usr/local/tomcat/webapps/openam/WEB-INF/lib
USER 11111
COPY fram/scripts/install $FORGEROCK_HOME
WORKDIR $FORGEROCK_HOME
RUN ./install.sh
# COPY fram/scripts/placeholder $FORGEROCK_HOME
# RUN ./placeholder-config.sh
# WORKDIR $FRAM_HOME
# RUN rm -rf opends && \
#     rm -rf security && \
#     rm -rf var
EXPOSE 8443
VOLUME /mnt/amconfig
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["catalina.sh", "run"]