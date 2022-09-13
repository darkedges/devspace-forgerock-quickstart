#!/bin/bash -eux

VERSION=${FRDS_VERSION:-7.2.0}
CURRENT_VERSION=`./upgrade | tail -1 | sed 's/ //g'`
if [[ ! "${CURRENT_VERSION}" == ${VERSION}* ]]; then
    ./upgrade
fi