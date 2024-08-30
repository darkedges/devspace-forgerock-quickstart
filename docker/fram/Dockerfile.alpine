ARG JRE_IMAGE=eclipse-temurin
ARG JRE_TAG=17.0.12_7-jre-alpine
ARG TOMCAT_IMAGE=tomcat
ARG TOMCAT_TAG=9-jre17
ARG FR_TAG=7.5.0
ARG ALPINE_TAG=3.20.2

FROM gcr.io/forgerock-io/am-base:${FR_TAG} AS ambase
FROM gcr.io/forgerock-io/amster:${FR_TAG} AS amster
FROM ${TOMCAT_IMAGE}:${TOMCAT_TAG} AS tomcat

# Binary extract
FROM alpine:${ALPINE_TAG} AS installfile
COPY --from=ambase /usr/local/tomcat/webapps/am /var/tmp/bootstrap/webapps/am
COPY --from=amster /opt/amster /var/tmp/bootstrap/amster 
COPY --from=tomcat /usr/local/tomcat /var/tmp/bootstrap/tomcat 

COPY webapps/ var/tmp/bootstrap/webapps/

COPY patches/ /var/tmp/bootstrap/webapps/am/

COPY instance/webapps/ /var/tmp/bootstrap/webapps/am/

# Runtime deployment
FROM ${JRE_IMAGE}:${JRE_TAG}

COPY --from=installfile /var/tmp/bootstrap/tomcat /usr/local/tomcat

RUN set -ex && \
    rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /opt/amster/config

COPY --from=installfile /var/tmp/bootstrap/webapps /usr/local/tomcat/webapps/
COPY --from=installfile /var/tmp/bootstrap/amster /opt/amster/
COPY --from=ambase /home/forgerock/crypto-tool.jar /home/forgerock/crypto-tool.jar

RUN set -ex && \
    apk --no-cache update && \
    apk add --no-cache curl openssh-keygen openldap-clients tini bash apr && \
    mkdir -p /opt/fram/instance/data && \
    addgroup -g 11111 -S forgerock && \
    adduser -G forgerock -D -u 11111 forgerock && \
    chmod 755 /opt/fram/instance/data && \
    chmod g+s /opt/fram/instance/data && \
    chmod 755 /opt/amster && \
    chown -R forgerock:forgerock /usr/local/tomcat && \
    chown -R forgerock:forgerock /opt/amster && \
    sed -i 's/<\/Host>/<Valve className="org.apache.catalina.valves.RemoteIpValve" remoteIpHeader="X-Forwarded-For" protocolHeader="X-Forwarded-Proto"\/><\/Host>/' /usr/local/tomcat/conf/server.xml && \
    chown forgerock:forgerock /home/forgerock/crypto-tool.jar

COPY --chown=forgerock:forgerock rootscripts/*.sh /usr/local/tomcat/

COPY --chown=forgerock:forgerock instance/amster /opt/amster/config/

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
ENV GPG_KEYS 48F8E69F6390C9F25CFEDCD268248959359E722B A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 DCFD35E0BF8CA7344752DE8B6FB21E8933C60243
ENV PATH $CATALINA_HOME/bin:$PATH
ENV SECRETS_PATH=${FRAM_HOME}/security
ENV TOMCAT_MAJOR 9
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV TOMCAT_SHA512 b2668f50339afdd266dbdf3ff20a98632a5552910179eda272b65ea0b18be4bef8fa9988e3cfc77e4eae4b74ae1e7abe2483b0e427a07628ed50fed3a13eefb9
ENV TOMCAT_VERSION 9.0.88
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

RUN mkdir -p ${SECRETS_PATH}/secrets/amster && \
    bash -c "ssh-keygen -N '' -m pem -t rsa -f ${SECRETS_PATH}/secrets/amster/amster_rsa <<< y" && \
    cat ${SECRETS_PATH}/secrets/amster/amster_rsa.pub > ${SECRETS_PATH}/secrets/amster/authorized_keys

ENTRYPOINT  ["/usr/local/tomcat/docker-entrypoint.sh"]

EXPOSE 8080

CMD ["catalina.sh", "run"]