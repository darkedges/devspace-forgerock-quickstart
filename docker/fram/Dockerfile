# ARG JRE_IMAGE=eclipse-temurin
# ARG JRE_TAG=17.0.12_7-jre-alpine
ARG TOMCAT_IMAGE=tomcat
ARG TOMCAT_TAG=9-jre17
ARG FR_TAG=7.5.0
ARG ALPINE_TAG=3.20.2

FROM gcr.io/forgerock-io/am-base:${FR_TAG} AS ambase
FROM gcr.io/forgerock-io/amster:${FR_TAG} AS amster

# Binary extract
FROM alpine:${ALPINE_TAG} AS installfile
COPY --from=ambase /usr/local/tomcat/webapps/am /var/tmp/bootstrap/webapps/am
COPY --from=amster /opt/amster /var/tmp/bootstrap/amster 

COPY webapps/ var/tmp/bootstrap/webapps/

COPY patches/ /var/tmp/bootstrap/webapps/am/

COPY instance/webapps/ /var/tmp/bootstrap/webapps/am/

# Runtime deployment
FROM ${TOMCAT_IMAGE}:${TOMCAT_TAG}

RUN set -ex && \
    rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /opt/amster/config

COPY --from=installfile /var/tmp/bootstrap/webapps /usr/local/tomcat/webapps/
COPY --from=installfile /var/tmp/bootstrap/amster /opt/amster/
COPY --from=ambase /home/forgerock/crypto-tool.jar /home/forgerock/crypto-tool.jar

RUN set -ex && \
    apt-get update && \
    apt-get install -y curl keychain ldap-utils tini bash && \
    mkdir -p /opt/fram/instance/data && \
    groupadd -g 11111 forgerock && \
    useradd -g forgerock -u 11111 forgerock && \
    chmod 755 /opt/fram/instance/data && \
    chmod g+s /opt/fram/instance/data && \
    chmod 755 /opt/amster && \
    chown -R forgerock:forgerock /usr/local/tomcat && \
    chown -R forgerock:forgerock /opt/amster && \
    sed -i 's/<\/Host>/<Valve className="org.apache.catalina.valves.RemoteIpValve" remoteIpHeader="X-Forwarded-For" protocolHeader="X-Forwarded-Proto"\/><\/Host>/' /usr/local/tomcat/conf/server.xml && \
    chown forgerock:forgerock /home/forgerock/crypto-tool.jar

COPY --chown=forgerock:forgerock --chmod=0755 rootscripts/*.sh /usr/local/tomcat/

COPY --chown=forgerock:forgerock --chmod=0755 instance/amster /opt/amster/config/

COPY --chown=forgerock:forgerock instance/home/ /home/forgerock/

RUN chmod 755 /usr/local/tomcat/*.sh

VOLUME [ "/opt/fram/instance/data"]

USER 11111

WORKDIR /home/forgerock

ENV FRAM_CONTAINER_JVM_ARGS=-Xmx2048M -XX:MetaspaceSize=256M -XX:MaxRAMPercentage=75 -XX:InitialRAMPercentage=75 -XX:MaxTenuringThreshold=1 -Djava.security.egd=file:/dev/urandom
ENV CATALINA_HOME /usr/local/tomcat
ENV CATALINA_OPTS -server -Dcom.sun.services.debug.mergeall=on -Dcom.sun.identity.configuration.directory=/home/forgerock/openam -Dcom.iplanet.services.stats.state=off -Dcom.sun.identity.sm.sms_object_filebased_enabled=true -Dorg.forgerock.donotupgrade=true -DtomcatAccessLogDir=/proc/self/fd -DtomcatAccessLogFile=1 --add-opens java.xml/com.sun.org.apache.xerces.internal.dom=ALL-UNNAMED
ENV FRAM_CONTAINER_JVM_ARGS=-XX:MaxRAMPercentage=75 -XX:InitialRAMPercentage=75 -XX:MaxTenuringThreshold=1 -Djava.security.egd=file:/dev/urandoms
ENV FRAM_HOME=/home/forgerock/openam
ENV SECRETS_PATH=${FRAM_HOME}/security

RUN mkdir -p ${SECRETS_PATH}/secrets/amster && \
    bash -c "ssh-keygen -N '' -m pem -t rsa -f ${SECRETS_PATH}/secrets/amster/amster_rsa <<< y" && \
    cat ${SECRETS_PATH}/secrets/amster/amster_rsa.pub > ${SECRETS_PATH}/secrets/amster/authorized_keys

ENTRYPOINT  ["/usr/local/tomcat/docker-entrypoint.sh"]

EXPOSE 8080

CMD ["catalina.sh", "run"]