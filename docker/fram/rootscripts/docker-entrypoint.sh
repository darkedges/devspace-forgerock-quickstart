#!/bin/bash

TOMCAT_HOME=/usr/local/tomcat
LISTENER_PORT=${LISTENER_PORT:-8080}
SERVER_URL=${SERVER_URL:-am.7f000001.nip.io}
SERVER_SCHEME=${SERVER_SCHEME:-http}
HOSTNAME=$(hostname)

if [ -z "$SERVER_URL" ]; then
    NAMESPACE="$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)"
    SERVICE_DOMAIN=${HOSTNAME%-*}
    SERVER_URL="${SERVER_SCHEME}://${HOSTNAME}.${SERVICE_DOMAIN}.${NAMESPACE}.svc.cluster.local:${LISTENER_PORT}/openam"
else 
    SERVER_URL="${SERVER_SCHEME}://${SERVER_URL}:${LISTENER_PORT}/openam"
fi

init() {
    set -ex
    if [ "$(find /opt/fram/instance/data/var  -type d)" ]; then
        echo "->OpenaAM Already Configured"
    else
        echo "Starting configuration"
        echo "-> Starting Tomcat"
        ${TOMCAT_HOME}/bin/catalina.sh start
        until $(curl --output /dev/null --silent --head --fail ${SERVER_SCHEME}://localhost:${LISTENER_PORT});
        do
            echo "-->Waiting for OpenAM to be available"
            sleep 10
        done
        echo "->Tomcat started"
        if [[ ${HOSTNAME} == *-0 ]]; then
            cat <<EOF > /tmp/installOpenAM
install-openam \
    --acceptLicense \
    --serverUrl ${SERVER_URL} \
    --pwdEncKey YcVB1NreOTzwK0DNpDWEJ7zpySrOU3RW \
    --adminPwd ${FRAM_ADMIN_PASSWORD:-Passw0rd} \
    --cfgDir /opt/fram/instance/data \
    --cfgStore dirServer \
    --cfgStoreDirMgr "${FRAM_CFG_STORE_DIR_MGR:-uid=am-config,ou=admins,dc=amconfig}" \
    --cfgStoreDirMgrPwd "${FRAM_CFG_STORE_DIR_MGR_PWD:-Passw0rd}" \
    --cfgStoreHost "${FRAM_CFG_STORE_HOST:-dfq-ds}" \
    --cfgStorePort "${FRAM_CFG_STORE_PORT:-1389}" \
    --cfgStoreRootSuffix ${FRAM_CFG_STORE_ROOT_SUFFIX:-dc=amconfig} \
    --cfgStoreSsl "${FRAM_CFG_STORE_SSL:-false}" \
    --userStoreDirMgr "${FRAM_USER_STORE_DIR_MGR:-uid=am-identity-bind-account,ou=admins,ou=identities}" \
    --userStoreDirMgrPwd "${FRAM_USER_STORE_DIR_MGR_PWD:-Passw0rd}" \
    --userStoreHost "${FRAM_USER_STORE_HOST:-dfq-ds}" \
    --userStoreType LDAPv3ForOpenDS \
    --userStorePort "${FRAM_USER_STORE_PORT:-1389}" \
    --userStoreSsl "${FRAM_USER_STORE_SSL:-false}" \
    --userStoreRootSuffix "${FRAM_USER_STORE_ROOT_SUFFIX:-ou=identities}"
:exit
EOF
        else
            master=${hostname//\-[0-9]/-0}
            cat <<EOF > /tmp/installOpenAM
install-openam \
    --acceptLicense \
    --adminPwd ${FRAM_ADMIN_PASSWORD:-Passw0rd} \
    --cfgDir /opt/fram/instance/data \
    --cfgStore dirServer \
    --cfgStoreDirMgr "${FRAM_CFG_STORE_DIR_MGR_PWD:-Passw0rd}" \
    --cfgStoreDirMgrPwd "${FRAM_CFG_STORE_DIR_MGR_PWD:-Passw0rd}" \
    --cfgStoreHost "${FRAM_CFG_STORE_HOST:-dfq-ds}"  \
    --cfgStorePort "${FRAM_CFG_STORE_PORT:-1389}" \
    --cfgStoreRootSuffix "${FRAM_CFG_STORE_ROOT_SUFFIX:-dc=amconfig}" \
    --cfgStoreSsl "${FRAM_CFG_STORE_SSL:-false}" \
    --existingServerId ${SERVER_URL} \
    --pwdEncKey YcVB1NreOTzwK0DNpDWEJ7zpySrOU3RW \
    --serverUrl ${SERVER_URL}
:exit
EOF
        fi
        echo "->Using configuration file with contents"
        cat /tmp/installOpenAM
        echo "->Configuring OpenAM"
        /opt/amster/amster /tmp/installOpenAM
        echo "->Adding amster keys"
        ssh-keygen -N '' -m pem -t rsa -f /opt/fram/instance/data/security/keys/amster/amster_rsa <<< y
        # This adds but need to restrict to ip address
        # Kinda hard in a dynamic environment, but will figure something out
        cat /opt/fram/instance/data/security/keys/amster/amster_rsa.pub > /opt/fram/instance/data/security/keys/amster/authorized_keys
        if [ -f "/opt/amster/config/importConfig.sh" ]; then
            echo "Import Amster Configuration"
            /opt/amster/config/importConfig.sh
        fi
    fi
}

start() {
    ${TOMCAT_HOME}/bin/catalina.sh stop -force
    ${TOMCAT_HOME}/bin/catalina.sh run
}

CMD="${1:-run}"

case "$CMD" in
init) 
    init
    ;;
docker_start)
    export CATALINA_PID=${TOMCAT_HOME}/bin/pid.txt
    init
    start
    ;;
*)
    exec "$@"
esac
