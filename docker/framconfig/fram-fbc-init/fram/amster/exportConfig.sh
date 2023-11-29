#!/bin/bash -eux

export SERVER_PORT=${SERVER_PORT:-8443}
export SERVER_URL=${SERVER_URL:-localhost}
export SERVER_SCHEME=${SERVER_SCHEME:-https}
if [ -z "$SERVER_URL" ]; then
    HOSTNAME=`hostname -f` 
    export AMSTER_URL="${SERVER_SCHEME}://${HOSTNAME}:${SERVER_PORT}/openam"
else
    export AMSTER_URL="${SERVER_SCHEME}://${SERVER_URL}:${SERVER_PORT}/openam"
fi

/opt/amster/amster ${JAVA_OPTS} /opt/amster/config/exportConfig.amster