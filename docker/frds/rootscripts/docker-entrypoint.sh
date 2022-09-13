#!/usr/bin/env bash

INIT_INSTANCE_PROFILE="${INIT_INSTANCE_PROFILE:-development}"

start() {
    set -ex
    echo "Starting DS"
    CMD_RUN=
    if [[ "${CMD}" = "start" ]]; then
      CMD_RUN="exec tini -v -- "
    fi
    ${CMD_RUN}./bin/start-ds --nodetach
}

stop() {
    set -ex
    echo "Stopping DS"
    ./bin/stop-ds
}

init_deploymentkey() {
    "./bin/dskeymgr" create-deployment-key \
        --outputFile /tmp/deploymentkey \
        --deploymentKeyPassword "${DEPLOYMENT_KEY_PASSWORD:-Passw0rd}"
    cat /tmp/deploymentkey
}

init() {
    echo "Initializing with profile: ${INIT_INSTANCE_PROFILE}"
    if [ -d "/opt/frds/instance/config" ]; then
        ./default-scripts/${INIT_INSTANCE_PROFILE}/init.sh
    else
        ./default-scripts/${INIT_INSTANCE_PROFILE}/setup.sh
    fi
}

upgrade() {
    echo "Upgrading"
    ./default-scripts/${INIT_INSTANCE_PROFILE}/upgrade.sh
}


CMD="${1:-run}"

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
init_deploymentkey)
    init_deploymentkey
    ;;
init_start)
    init
    start
    ;;
upgrade)
    upgrade
    ;;
init)
    init
    ;;
*)
    exec "$@"
esac