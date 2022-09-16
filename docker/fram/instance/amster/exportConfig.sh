#!/bin/bash -eux

export LISTENER_PORT=${LISTENER_PORT:-8080}
export SERVER_URL=${SERVER_URL:-am.7f000001.nip.io}
export SERVER_SCHEME=${SERVER_SCHEME:-http}
if [ -z "$SERVER_URL" ]; then
    HOSTNAME=`hostname -f` 
    export AMSTER_URL="${SERVER_SCHEME}://${HOSTNAME}:${LISTENER_PORT}/openam"
else
    export AMSTER_URL="${SERVER_SCHEME}://${SERVER_URL}:${LISTENER_PORT}/openam"
fi
/opt/amster/amster /opt/amster/config/exportConfig.amster