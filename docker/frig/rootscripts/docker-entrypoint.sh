#!/usr/bin/env bash

INSTANCE_DIR="${INSTANCE_DIR:-/opt/frig/instance/}"
env_file="${INSTANCE_DIR}/bin/env.sh"
if [ -r "${env_file}" ]; then
    . "${env_file}"
fi

init() {
    echo "initializing FRIG"
    # Add any initializing steps here.
    # Run once on container creation 
}

start() {
    echo "Starting FRIG"
    # Start the FRIG instance.
    # using tini to start the instance and keeps it alive.
    set -ex
    CMD_RUN=
    if [[ "${CMD}" = "start" ]]; then
      CMD_RUN="exec tini -v -- "
    fi
    ${CMD_RUN}${JAVA_HOME}/bin/java -classpath "classes:lib/*:${INSTANCE_DIR}/extra/*" ${JAVA_OPTS} org.forgerock.openig.standalone.Start ${INSTANCE_DIR}
}

stop() {
    echo "Stopping FRIG"
}

CMD="${1:-start}"

case "$CMD" in
devspace)
    start
    ;;
start)
    start
    ;;
stop)
    stop
    ;;
init)
    init
    ;;
*)
    exec "$@"
esac