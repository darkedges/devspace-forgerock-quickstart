#!/bin/bash

TOMCAT_HOME=/usr/local/tomcat
FRAM_ADMIN_PASSWORD=${FRAM_ADMIN_PASSWORD:-changeit}
SERVER_URL=${SERVER_URL:-http://localhost:8080/openam/}
AM_KEY=${AM_KEY:-changeit}
export CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.identity.sm.filebased_embedded_enabled=true"

set -ex
echo "Starting configuration"
echo "-> Starting Tomcat"
${TOMCAT_HOME}/bin/catalina.sh start
until $(curl -k --output /dev/null --silent --head --fail ${SERVER_URL});
do
    echo "-->Waiting for OpenAM to be available"
    sleep 10
done
echo "->Tomcat started"
echo "->Configuring OpenAM"
/opt/amster/config/importConfig.sh install
/opt/amster/config/importConfig.sh core
${TOMCAT_HOME}/bin/catalina.sh stop -force

