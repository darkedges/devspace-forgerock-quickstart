#!/bin/bash -eux

export AM_SERVER_FQDN=${AM_SERVER_FQDN:-am.7f000001.nip.io}
export AM_SERVER_PROTOCOL=${AM_SERVER_PROTOCOL:-http}
export AM_SERVER_PORT=${AM_SERVER_PORT:-8080}
if [ -z "$AM_SERVER_FQDN" ]; then
    HOSTNAME=`hostname -f` 
    export AMSTER_URL="${AM_SERVER_PROTOCOL}://${HOSTNAME}:${AM_SERVER_PORT}/am"
else
    export AMSTER_URL="${AM_SERVER_PROTOCOL}://${AM_SERVER_FQDN}:${AM_SERVER_PORT}/am"
fi
/opt/amster/amster /opt/amster/config/importConfig.amster