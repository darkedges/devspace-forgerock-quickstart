ARG TOMCAT_IMAGE=darkedges/tomcat
ARG TOMCAT_TAG=9.0.65-11.0.14_9-alpine

# Binary extract
FROM alpine:3.15.0
ARG FRAM_WAR_ARCHIVE=AM-7.2.0.zip
ARG FRAM_AMSTER_ARCHIVE=Amster-7.2.0.zip
ARG FRAM_ARCHIVE_REPOSITORY_URL=

ADD ${FRAM_ARCHIVE_REPOSITORY_URL}${FRAM_WAR_ARCHIVE} /var/tmp/fram.war
ADD ${FRAM_ARCHIVE_REPOSITORY_URL}${FRAM_AMSTER_ARCHIVE} /var/tmp/amster.zip

RUN set -ex && \
    mkdir -p /var/tmp/bootstrap/webapps/openam && \
    mkdir -p /var/tmp/bootstrap/amster && \
    unzip /var/tmp/fram.war -d /var/tmp/bootstrap/webapps/openam && \
    unzip /var/tmp/amster.zip -d /var/tmp/bootstrap/amster

COPY webapps/ var/tmp/bootstrap/webapps/

COPY patches/ /var/tmp/bootstrap/webapps/openam/

# Runtime deployment
FROM ${TOMCAT_IMAGE}:${TOMCAT_TAG}

RUN set -ex && \
    rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /opt/amster/config

COPY --from=0 /var/tmp/bootstrap/webapps /usr/local/tomcat/webapps/
COPY --from=0 /var/tmp/bootstrap/amster /opt/amster/

RUN set -ex && \
    apk add --no-cache curl openssh-keygen && \
    mkdir -p /opt/fram/instance/data && \
    addgroup -g 11111 -S forgerock && \
    adduser -G forgerock -D -u 11111 forgerock && \
    chmod 755 /opt/fram/instance/data && \
    chmod g+s /opt/fram/instance/data && \
    chmod 755 /opt/amster && \
    chown -R forgerock:forgerock /usr/local/tomcat && \
    chown -R forgerock:forgerock /opt/amster && \
    sed -i 's/<\/Host>/<Valve className="org.apache.catalina.valves.RemoteIpValve" remoteIpHeader="X-Forwarded-For" protocolHeader="X-Forwarded-Proto"\/><\/Host>/' /usr/local/tomcat/conf/server.xml

COPY --chown=forgerock:forgerock rootscripts/*.sh /usr/local/tomcat/

COPY --chown=forgerock:forgerock instance/amster /opt/amster/config/

COPY --chown=forgerock:forgerock instance/home/ /home/forgerock/

RUN chmod 755 /usr/local/tomcat/*.sh

VOLUME [ "/opt/fram/instance/data"]

USER 11111

WORKDIR /home/forgerock

ENV CATALINA_OPTS -Dcom.sun.services.debug.mergeall=on     -Dcom.sun.identity.configuration.directory=/home/forgerock/openam     -Dcom.iplanet.services.stats.state=off     -Dcom.sun.identity.sm.sms_object_filebased_enabled=true     -Dorg.forgerock.donotupgrade=true     -DtomcatAccessLogDir=/proc/self/fd -DtomcatAccessLogFile=1

ENTRYPOINT  ["/usr/local/tomcat/docker-entrypoint.sh"]

EXPOSE 8080

CMD ["catalina.sh", "run"]