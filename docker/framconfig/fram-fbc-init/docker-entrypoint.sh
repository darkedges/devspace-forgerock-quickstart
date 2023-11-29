#!/bin/bash

TOMCAT_HOME=/usr/local/tomcat
FRAM_ADMIN_PASSWORD=${FRAM_ADMIN_PASSWORD:-changeit}
SERVER_URL=${SERVER_URL:-https://localhost:8443}

start() {
    ${TOMCAT_HOME}/bin/catalina.sh run
}

stop() {
    ${TOMCAT_HOME}/bin/catalina.sh stop -force
}

CMD="${1}"
export CATALINA_PID=${TOMCAT_HOME}/bin/pid.txt
case "$CMD" in
start)
    start
    ;;
stop)
    stop
    ;;
*)
    exec "$@"
esac