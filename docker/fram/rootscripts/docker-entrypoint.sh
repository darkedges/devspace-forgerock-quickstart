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
export AM_STORES_POLICY_ENABLED=${AM_STORES_POLICY_ENABLED:-"true"}
export AM_STORES_APPLICATION_ENABLED=${AM_STORES_APPLICATION_ENABLED:-"true"}
export AM_AUTHENTICATION_MODULES_LDAP_CONNECTION_MODE=${AM_AUTHENTICATION_MODULES_LDAP_CONNECTION_MODE:-LDAP}
export AM_AUTHENTICATION_MODULES_LDAP_CONNECTION_MODEKEY=${AM_AUTHENTICATION_MODULES_LDAP_CONNECTION_MODEKEY:-Passw0rd}
export AM_AUTHENTICATION_MODULES_LDAP_PASSWORD=${AM_AUTHENTICATION_MODULES_LDAP_PASSWORD:-Passw0rd}
export AM_AUTHENTICATION_MODULES_LDAP_SERVERS=${AM_AUTHENTICATION_MODULES_LDAP_SERVERS:-dfq-ds:1389}
export AM_AUTHENTICATION_MODULES_LDAP_USERNAME=${AM_AUTHENTICATION_MODULES_LDAP_USERNAME:-uid=am-identity-bind-account,ou=admins,ou=identities}
export AM_AUTHENTICATION_SHARED_SECRET=${AM_AUTHENTICATION_SHARED_SECRET:-ck1XTE1kN1VKRUpGZVkwVnBDYk0zZEJ3dFdEc3NINjUK}
export AM_KEYSTORE_DEFAULT_ENTRY_PASSWORD=${AM_KEYSTORE_DEFAULT_ENTRFY_PASSWORD:-$(cat $FRAM_HOME/security/secrets/default/.keypass)}
export AM_KEYSTORE_DEFAULT_PASSWORD=${AM_KEYSTORE_DEFAULT_PASSWORD:-$(cat $FRAM_HOME/security/secrets/default/.storepass)}
export AM_MONITORING_PROMETHEUS_PASSWORD_ENCRYPTED=${AM_MONITORING_PROMETHEUS_PASSWORD_ENCRYPTED:-$(echo $AM_ENCRYPTION_KEY | am-crypto hash encrypt des)}
export AM_OIDC_CLIENT_SUBJECT_IDENTIFIER_HASH_SALT=${AM_OIDC_CLIENT_SUBJECT_IDENTIFIER_HASH_SALT:-rMWLMd7UJEJFeY0VpCbM3dBwtWDssH65}
export AM_PASSWORDS_AMADMIN_HASHED_ENCRYPTED=${AM_PASSWORDS_AMADMIN_HASHED_ENCRYPTED:-$(echo $AM_PASSWORDS_AMADMIN | am-crypto hash | am-crypto encrypt des)}
export AM_PASSWORDS_ANONYMOUS_HASHED_ENCRYPTED=${AM_PASSWORDS_ANONYMOUS_HASHED_ENCRYPTED:-$(echo $AM_ENCRYPTION_KEY | am-crypto hash| am-crypto encrypt des)}
export AM_PASSWORDS_DSAMEUSER_ENCRYPTED=${AM_PASSWORDS_DSAMEUSER_ENCRYPTED:-$(echo $AM_ENCRYPTION_KEY | am-crypto encrypt des)}
export AM_PASSWORDS_DSAMEUSER_HASHED_ENCRYPTED=${AM_PASSWORDS_DSAMEUSER_HASHED_ENCRYPTED:-$(echo $AM_ENCRYPTION_KEY | am-crypto hash encrypt des)}
export AM_SELFSERVICE_LEGACY_CONFIRMATION_EMAIL_LINK_SIGNING_KEY=${AM_SELFSERVICE_LEGACY_CONFIRMATION_EMAIL_LINK_SIGNING_KEY:-ck1XTE1kN1VKRUpGZVkwVnBDYk0zZEJ3dFdEc3NINjUK}
export AM_SERVER_FQDN=${AM_SERVER_FQDN:-am.7f000001.nip.io}
export AM_SERVER_HOSTNAMES=${AM_SERVER_HOSTNAMES:-am.7f000001.nip.io,am,am-config}
export AM_SERVER_PROTOCOL=${AM_SERVER_PROTOCOL:-http}
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
export AM_STORES_CTS_ROOT_SUFFIX=${AM_STORES_CTS_ROOT_SUFFIX:-ou=famrecords,ou=openam-session,ou=tokens}
export AM_STORES_POLICY_PASSWORD=${AM_STORES_POLICY_PASSWORD:-Passw0rd}
export AM_STORES_POLICY_SERVERS=${AM_STORES_POLICY_SERVERS:-dfq-ds:1389}
export AM_STORES_POLICY_SSL_ENABLED=${AM_STORES_POLICY_SSL_ENABLED:-false}
export AM_STORES_POLICY_USERNAME=${AM_STORES_POLICY_USERNAME:-uid=am-config,ou=admins,ou=am-config}
export AM_STORES_SSL_ENABLED=false
export AM_STORES_UMA_PASSWORD=${AM_STORES_UMA_PASSWORD:-Passw0rd}
export AM_STORES_UMA_SERVERS=${AM_STORES_UMA_SERVERS:-dfq-ds:1389}
export AM_STORES_UMA_SSL_ENABLED=${AM_STORES_UMA_SSL_ENABLED:-false}
export AM_STORES_UMA_USERNAME=${AM_STORES_UMA_USERNAME:-uid=am-config,ou=admins,ou=am-config}
export AM_STORES_UMA_ROOT_SUFFIX=${AM_STORES_UMA_ROOT_SUFFIX:-ou=am-config}
export AM_STORES_USER_CONNECTION_MODE=${AM_STORES_USER_CONNECTION_MODE:-LDAP}
export AM_STORES_USER_PASSWORD=${AM_STORES_USER_PASSWORD:-Passw0rd}
export AM_STORES_USER_SERVERS=${AM_STORES_USER_SERVERS:-dfq-ds:1389}
export AM_STORES_USER_SSL_ENABLED=${AM_STORES_USER_SSL_ENABLED:-false}
export AM_STORES_USER_TYPE=${AM_STORES_USER_TYPE:-LDAPv3ForOpenDS}
export AM_STORES_USER_USERNAME=${AM_STORES_USER_USERNAME:-uid=am-identity-bind-account,ou=admins,ou=identities}
export SECRETS_PATH=${SECRETS_PATH:-${FRAM_HOME}/security}
export AMSTER_SECRETS_KEYS_PATH=${AMSTER_SECRETS_KEYS_PATH:-${SECRETS_PATH}/keys/amster/authorized_keys}

env|sort

if [ -z "$SERVER_URL" ]; then
    NAMESPACE="$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)"
    SERVICE_DOMAIN=${HOSTNAME%-*}
    SERVER_URL="${SERVER_SCHEME}://${HOSTNAME}.${SERVICE_DOMAIN}.${NAMESPACE}.svc.cluster.local:${SERVER_PORT}/am"
else 
    SERVER_URL="${SERVER_SCHEME}://${SERVER_URL}:${SERVER_PORT}/am"
fi

CATALINA_OPTS="$CATALINA_OPTS $FRAM_CONTAINER_JVM_ARGS $CATALINA_USER_OPTS $JFR_OPTS"

if [ ! -z "$TRUSTSTORE_PATH" ] && [ ! -z "$TRUSTSTORE_PASSWORD" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Djavax.net.ssl.trustStore=$TRUSTSTORE_PATH -Djavax.net.ssl.trustStorePassword=$TRUSTSTORE_PASSWORD -Djavax.net.ssl.trustStoreType=jks"
fi

start() {
    ${TOMCAT_HOME}/bin/catalina.sh run
}

stop() {
    ${TOMCAT_HOME}/bin/catalina.sh stop -force
}

CMD="${1:-run}"

case "$CMD" in
start)
    start
    ;; 
stop)
    stop
    ;;
*)
    exec "$@"
esac
