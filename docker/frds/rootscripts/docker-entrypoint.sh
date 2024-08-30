#!/usr/bin/env bash

INIT_INSTANCE_PROFILE="${INIT_INSTANCE_PROFILE:-directory}"
export OPENDJ_JAVA_ARGS="${OPENDJ_JAVA_ARGS:--Xmx2048M -XX:MaxTenuringThreshold=1 -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -Djava.security.egd=file:/dev/urandoms}"

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
    if [ -d "/opt/frds/instance/data/config" ]; then
         if [ -d "/opt/frds/instance/data/init_complete" ]; then
             if [ "${INIT_INSTANCE_LDIF}" = true]; then
                ./default-scripts/${INIT_INSTANCE_PROFILE}/init.sh
            fi
        fi
    else
        rm -rf instance.loc
        ./default-scripts/${INIT_INSTANCE_PROFILE}/setup.sh
    fi
}

upgrade() {
    echo "Upgrading"
    ./default-scripts/${INIT_INSTANCE_PROFILE}/upgrade.sh
}


CMD="${1:-run}"

case "$CMD" in
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