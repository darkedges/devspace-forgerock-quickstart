#!/bin/bash -eux

export SERVER_PORT=${SERVER_PORT:-8080}
export SERVER_URL=${SERVER_URL:-am.7f000001.nip.io}
export SERVER_SCHEME=${SERVER_SCHEME:-http}
if [ -z "$SERVER_URL" ]; then
    HOSTNAME=`hostname -f` 
    export AMSTER_URL="${SERVER_SCHEME}://${HOSTNAME}:${SERVER_PORT}/am"
else
    export AMSTER_URL="${SERVER_SCHEME}://${SERVER_URL}:${SERVER_PORT}/am"
fi
/opt/amster/amster /opt/amster/config/importConfig.amster