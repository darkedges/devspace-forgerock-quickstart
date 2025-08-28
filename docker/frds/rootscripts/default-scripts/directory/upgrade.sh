#!/bin/bash -eux

PREVIOUS_VERSION=${FRDS_VERSION:-8.0.1}
CURRENT_VERSION=`cat /opt/frds/instance/data/config/config.ldif | grep 'ds-cfg-version:' | sed 's/ds-cfg-version: //g'`
if [[ ! "${CURRENT_VERSION}" == ${PREVIOUS_VERSION}* ]]; then
    ./upgrade --no-prompt
fi