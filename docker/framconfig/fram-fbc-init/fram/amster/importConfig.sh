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

CMD="${1:-darkedges}"
case "$CMD" in
darkedges) 
    ;;
install) 
    ;;
*)
    echo "Invalid option should be darkedges|install"
    exit 1;
    ;;
esac

source /configurationvariables/env.sh
source /configurationvariables/environment.properties
export $(cut -d= -f1 /configurationvariables/environment.properties)

/opt/amster/amster ${JAVA_OPTS} /opt/amster/config/importConfig-${CMD}.amster