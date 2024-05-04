#!/bin/bash

TOMCAT_HOME=/usr/local/tomcat
FRAM_ADMIN_PASSWORD=${FRAM_ADMIN_PASSWORD:-changeit}
SERVER_URL=${SERVER_URL:-http://localhost:8080/am/}
SECRETS_PATH=${SECRETS_PATH:-${FRAM_HOME}/security}
AM_KEY=${AM_KEY:-changeit}
export CATALINA_OPTS="-server -Dcom.sun.services.debug.mergeall=on -Dcom.sun.identity.configuration.directory=${FRAM_HOME} -Dcom.iplanet.services.stats.state=off -Dcom.sun.identity.sm.sms_object_filebased_enabled=true -Dcom.sun.identity.sm.filebased_embedded_enabled=true -Dorg.forgerock.donotupgrade=true"

set -ex
echo "Starting configuration"
echo "-> Starting Tomcat"
${TOMCAT_HOME}/bin/catalina.sh start
until $(curl -k --output /dev/null --silent --head --fail ${SERVER_URL});
do
    echo "-->Waiting for FRAM to be available"
    sleep 10
done
echo "->Tomcat started"
echo "->Configuring FRAM"
/opt/amster/config/importConfig.sh install
/opt/amster/config/importConfig.sh core