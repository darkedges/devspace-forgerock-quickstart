#!/bin/bash -eux

export SERVER_PORT=${SERVER_PORT:-8080}
export SERVER_URL=${SERVER_URL:-localhost}
export SERVER_SCHEME=${SERVER_SCHEME:-http}
if [ -z "$SERVER_URL" ]; then
    HOSTNAME=`hostname -f` 
    export AMSTER_URL="${SERVER_SCHEME}://${HOSTNAME}:${SERVER_PORT}/openam"
else
    export AMSTER_URL="${SERVER_SCHEME}://${SERVER_URL}:${SERVER_PORT}/openam"
fi

CMD="${1:-darkedges}"
case "$CMD" in
core) 
    ;;
install) 
    ;;
*)
    echo "Invalid option should be core|install"
    exit 1;
    ;;
esac

/opt/amster/amster ${JAVA_OPTS} /opt/amster/config/importConfig-${CMD}.amster