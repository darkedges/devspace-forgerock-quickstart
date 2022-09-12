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
    exec tini -v -- ${JAVA_HOME}/bin/java -classpath "classes:lib/*:${INSTANCE_DIR}/extra/*" ${JAVA_OPTS} org.forgerock.openig.launcher.Main ${INSTANCE_DIR}
}

devspace() {
    echo "Starting devspace FRIG"
    # Starts the FRIG instance for use with devspace.
    # devspace wll inject its own binary to manage the lifecycle of the aplication
    set -ex
    ${JAVA_HOME}/bin/java -classpath "classes:lib/*:${INSTANCE_DIR}/extra/*" ${JAVA_OPTS} org.forgerock.openig.launcher.Main ${INSTANCE_DIR}
}

CMD="${1:-start}"

echo "Command is $CMD"

case "$CMD" in
devspace)
    devspace
    ;;
start)
    start
    ;;
init)
    init
    ;;
*)
    exec "$@"
esac