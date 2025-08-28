#!/bin/bash

TOMCAT_HOME=/usr/local/tomcat

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
/opt/amster/config/importConfig.sh core