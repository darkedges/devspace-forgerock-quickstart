#!/bin/bash

TOMCAT_HOME=/usr/local/tomcat
SERVER_PORT=${SERVER_PORT:-8080}
SERVER_URL=${SERVER_URL:-am.7f000001.nip.io}
SERVER_SCHEME=${SERVER_SCHEME:-http}
HOSTNAME=$(hostname)

am-crypto() {
    java -jar /home/forgerock/crypto-tool.jar $@
}

export AM_ENCRYPTION_KEY=${AM_ENCRYPTION_KEY:-rMWLMd7UJEJFeY0VpCbM3dBwtWDssH65}
AM_PASSWORDS_AMADMIN=${AM_PASSWORDS_AMADMIN:-Passw0rd}
# File Based Connfiguration Environment values
export AM_AUTHENTICATION_MODULES_LDAP_CONNECTION_MODE=${AM_AUTHENTICATION_MODULES_LDAP_CONNECTION_MODE:LDAP}
export AM_AUTHENTICATION_MODULES_LDAP_CONNECTION_MODEKEY=${AM_AUTHENTICATION_MODULES_LDAP_CONNECTION_MODEKEY:-Passw0rd}
export AM_AUTHENTICATION_MODULES_LDAP_PASSWORD=${AM_AUTHENTICATION_MODULES_LDAP_PASSWORD:-Passw0rd}
export AM_AUTHENTICATION_MODULES_LDAP_SERVERS=${AM_AUTHENTICATION_MODULES_LDAP_SERVERS:-dfq-ds:1389}
export AM_AUTHENTICATION_MODULES_LDAP_USERNAME=${AM_AUTHENTICATION_MODULES_LDAP_USERNAME:-uid=am-identity-bind-account,ou=admins,ou=identities}
export AM_AUTHENTICATION_SHARED_SECRET=${AM_AUTHENTICATION_SHARED_SECRET:-ck1XTE1kN1VKRUpGZVkwVnBDYk0zZEJ3dFdEc3NINjUK}
export AM_KEYSTORE_DEFAULT_ENTRY_PASSWORD=${AM_KEYSTORE_DEFAULT_ENTRY_PASSWORD:-$(cat $FRAM_HOME/security/secrets/default/.keypass)}
export AM_KEYSTORE_DEFAULT_PASSWORD=${AM_KEYSTORE_DEFAULT_PASSWORD:-$(cat $FRAM_HOME/security/secrets/default/.storepass)}
export AM_MONITORING_PROMETHEUS_PASSWORD_ENCRYPTED=${AM_MONITORING_PROMETHEUS_PASSWORD_ENCRYPTED:-$(echo $AM_ENCRYPTION_KEY | am-crypto hash encrypt des)}
export AM_OIDC_CLIENT_SUBJECT_IDENTIFIER_HASH_SALT=${AM_OIDC_CLIENT_SUBJECT_IDENTIFIER_HASH_SALT:-rMWLMd7UJEJFeY0VpCbM3dBwtWDssH65}
export AM_PASSWORDS_AMADMIN_HASHED_ENCRYPTED=${AM_PASSWORDS_AMADMIN_HASHED_ENCRYPTED:-$(echo $AM_PASSWORDS_AMADMIN | am-crypto hash | am-crypto encrypt des)}
export AM_PASSWORDS_ANONYMOUS_HASHED_ENCRYPTED=${AM_PASSWORDS_ANONYMOUS_HASHED_ENCRYPTED:-$(echo $AM_ENCRYPTION_KEY | am-crypto hash| am-crypto encrypt des)}
export AM_PASSWORDS_DSAMEUSER_ENCRYPTED=${AM_PASSWORDS_DSAMEUSER_ENCRYPTED:-$(echo $AM_ENCRYPTION_KEY | am-crypto encrypt des)}
export AM_PASSWORDS_DSAMEUSER_HASHED_ENCRYPTED=${AM_PASSWORDS_DSAMEUSER_HASHED_ENCRYPTED:-$(echo $AM_ENCRYPTION_KEY | am-crypto hash encrypt des)}
export AM_SELFSERVICE_LEGACY_CONFIRMATION_EMAIL_LINK_SIGNING_KEY=${AM_SELFSERVICE_LEGACY_CONFIRMATION_EMAIL_LINK_SIGNING_KEY:-ck1XTE1kN1VKRUpGZVkwVnBDYk0zZEJ3dFdEc3NINjUK}
export AM_SERVER_FQDN=${AM_SERVER_FQDN:-dfq-am.7f000001.nip.io}
export AM_SERVER_HOSTNAMES=${AM_SERVER_HOSTNAMES:=am.darkedges.com.au}
export AM_SERVER_PROTOCOL=${AM_SERVER_PROTOCOL:-HTTP}
export AM_SESSION_STATELESS_ENCRYPTION_KEY=${AM_SESSION_STATELESS_ENCRYPTION_KEY:-ck1XTE1kN1VKRUpGZVkwVnBDYk0zZEJ3dFdEc3NINjUK}
export AM_SESSION_STATELESS_SIGNING_KEY=${AM_SESSION_STATELESS_SIGNING_KEY:-ck1XTE1kN1VKRUpGZVkwVnBDYk0zZEJ3dFdEc3NINjUK}
export AM_STORES_APPLICATION_PASSWORD=${AM_STORES_APPLICATION_PASSWORD:-Passw0rd}
export AM_STORES_APPLICATION_SERVERS=${AM_STORES_APPLICATION_SERVERS:-dfq-ds:1389}
export AM_STORES_APPLICATION_SSL_ENABLED=${AM_STORES_APPLICATION_SSL_ENABLED:-false}
export AM_STORES_APPLICATION_USERNAME=${AM_STORES_APPLICATION_USERNAME:-uid=am-config,ou=admins,ou=am-config}
export AM_STORES_CTS_PASSWORD=${AM_STORES_CTS_PASSWORD:-Passw0rd}
export AM_STORES_CTS_SERVERS=${AM_STORES_CTS_SERVERS:-dfq-ds:1389}
export AM_STORES_CTS_SSL_ENABLED=${AM_STORES_CTS_SSL_ENABLED:-false}
export AM_STORES_CTS_USERNAME=${AM_STORES_CTS_USERNAME:-uid=openam_cts,ou=admins,ou=famrecords,ou=openam-session,ou=tokens}
export AM_STORES_POLICY_PASSWORD=${AM_STORES_POLICY_PASSWORD:-Passw0rd}
export AM_STORES_POLICY_SERVERS=${AM_STORES_POLICY_SERVERS:-dfq-ds:1389}
export AM_STORES_POLICY_SSL_ENABLED=${AM_STORES_POLICY_SSL_ENABLED:-false}
export AM_STORES_POLICY_USERNAME=${AM_STORES_POLICY_USERNAME:-uid=am-config,ou=admins,ou=am-config}
export AM_STORES_SSL_ENABLED=false
export AM_STORES_UMA_PASSWORD=${AM_STORES_UMA_PASSWORD:-Passw0rd}
export AM_STORES_UMA_SERVERS=${AM_STORES_UMA_SERVERS:-dfq-ds:1389}
export AM_STORES_UMA_SSL_ENABLED=${AM_STORES_UMA_SSL_ENABLED:-false}
export AM_STORES_UMA_USERNAME=${AM_STORES_UMA_USERNAME:-uid=am-config,ou=admins,ou=am-config}
export AM_STORES_USER_CONNECTION_MODE=${AM_STORES_USER_CONNECTION_MODE:-LDAP}
export AM_STORES_USER_PASSWORD=${AM_STORES_USER_PASSWORD:-Passw0rd}
export AM_STORES_USER_SERVERS=${AM_STORES_USER_SERVERS:-dfq-ds:1389}
export AM_STORES_USER_SSL_ENABLED=${AM_STORES_POLICY_SSL_ENABLED:-false}
export AM_STORES_USER_TYPE=${AM_STORES_USER_TYPE:-LDAPv3ForOpenDS}
export AM_STORES_USER_USERNAME=${AM_STORES_USER_USERNAME:-uid=am-identity-bind-account,ou=admins,ou=identities}
export SECRETS_PATH=${SECRETS_PATH:-Passw0rd}

if [ -z "$SERVER_URL" ]; then
    NAMESPACE="$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)"
    SERVICE_DOMAIN=${HOSTNAME%-*}
    SERVER_URL="${SERVER_SCHEME}://${HOSTNAME}.${SERVICE_DOMAIN}.${NAMESPACE}.svc.cluster.local:${SERVER_PORT}/openam"
else 
    SERVER_URL="${SERVER_SCHEME}://${SERVER_URL}:${SERVER_PORT}/openam"
fi

if [ ! -z "$TRUSTSTORE_PATH" ] && [ ! -z "$TRUSTSTORE_PASSWORD" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Djavax.net.ssl.trustStore=$TRUSTSTORE_PATH -Djavax.net.ssl.trustStorePassword=$TRUSTSTORE_PASSWORD -Djavax.net.ssl.trustStoreType=jks"
fi

init() {
    set -ex
    if [ "$(find /opt/fram/instance/data/var  -type d)" ]; then
        echo "->OpenaAM Already Configured"
    else
        echo "Starting configuration"
        echo "-> Starting Tomcat"
        ${TOMCAT_HOME}/bin/catalina.sh start
        until $(curl --output /dev/null --silent --head --fail ${SERVER_SCHEME}://localhost:${SERVER_PORT});
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
    --cfgStoreDirMgr "${FRAM_CFG_STORE_DIR_MGR:-uid=am-config,ou=admins,ou=am-config}" \
    --cfgStoreDirMgrPwd "${FRAM_CFG_STORE_DIR_MGR_PWD:-Passw0rd}" \
    --cfgStoreHost "${FRAM_CFG_STORE_HOST:-dfq-ds:1389}" \
    --cfgStorePort "${FRAM_CFG_STORE_PORT:-1389}" \
    --cfgStoreRootSuffix ${FRAM_CFG_STORE_ROOT_SUFFIX:-ou=am-config} \
    --cfgStoreSsl "${FRAM_CFG_STORE_SSL:-false}" \
    --userStoreDirMgr "${FRAM_USER_STORE_DIR_MGR:-uid=am-identity-bind-account,ou=admins,ou=identities}" \
    --userStoreDirMgrPwd "${FRAM_USER_STORE_DIR_MGR_PWD:-Passw0rd}" \
    --userStoreHost "${FRAM_USER_STORE_HOST:-dfq-ds:1389}" \
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
    --cfgStoreHost "${FRAM_CFG_STORE_HOST:-dfq-ds:1389}"  \
    --cfgStorePort "${FRAM_CFG_STORE_PORT:-1389}" \
    --cfgStoreRootSuffix "${FRAM_CFG_STORE_ROOT_SUFFIX:-ou=am-config}" \
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

stop() {
    ${TOMCAT_HOME}/bin/catalina.sh stop -force
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
stop)
    stop
    ;;
*)
    exec "$@"
esac
