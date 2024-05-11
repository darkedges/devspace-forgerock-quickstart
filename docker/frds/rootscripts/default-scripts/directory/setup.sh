#!/bin/bash -eux

#Initial values
export AMCTS_BACKEND_NAME=${AMCTS_BACKEND_NAME:-amCts}
export AMCONFIG_BACKEND_NAME=${AMCONFIG_BACKEND_NAME:-cfgStore}
export AMIDENTITYSTORE_BACKEND_NAME=${AMIDENTITYSTORE_BACKEND_NAME:-amIdentityStore}
export IDM_BACKEND_NAME=${IDM_BACKEND_NAME:-idmRepo}
export ROOT_USER_DN=${ROOT_USER_DN:-uid=admin}
export ROOT_USER_PASSWORD=${ROOT_USER_PASSWORD:-Passw0rd}
INIT_REPLICATION_TYPE=${INIT_REPLICATION_TYPE:-}
DSCONFIG_SETUP=""
DSCONFIG_REPLICATION=""

EXTRA_OPTIONS=""
if [ -f "/var/run/secrets/frds/keystore.jks" ]; then
    EXTRA_OPTIONS="--certNickname certificate --useJceKeyStore /var/run/secrets/frds/keystore.jks ${EXTRA_OPTIONS}"
fi
if [ -f "/var/run/secrets/frds/truststore.jks" ]; then
    EXTRA_OPTIONS="--useJavaTrustStore /var/run/secrets/frds/truststore.jks ${EXTRA_OPTIONS}"
fi
if [ -f "/var/run/secrets/frds/keystore.pin" ]; then
     EXTRA_OPTIONS="--keyStorePassword:file /var/run/secrets/frds/keystore.pin ${EXTRA_OPTIONS}"
fi
if [ -f "/var/run/secrets/frds/truststore.pin" ]; then
    EXTRA_OPTIONS="--trustStorePassword:file /var/run/secrets/frds/truststore.pin ${EXTRA_OPTIONS}"
fi
if [[ "${INIT_REPLICATION_TYPE}" == "embedded" ]]; then
    EXTRA_OPTIONS="--replicationPort ${FRDS_REPLICATION_PORT:-8989} ${EXTRA_OPTIONS}"
fi
./setup \
    --deploymentId "${DEPLOYMENT_KEY:-AeHV0e6uT7eUFASCfG0MWRZKCYY3Zw5CBVN1bkVDDJrPKRD22mygkg}" \
    --deploymentIdPassword "${DEPLOYMENT_KEY_PASSWORD:-Passw0rd}" \
    --serverId "${HOSTNAME}" \
    --instancePath /opt/frds/instance/data \
    --rootUserDN "${ROOT_USER_DN}" \
    --rootUserPassword "${ROOT_USER_PASSWORD}" \
    --monitorUserPassword "${MONITOR_USER_PASSWORD:-Passw0rd}" \
    --hostname ${HOSTNAME} \
    --adminConnectorPort 4444 \
    --ldapPort ${FRDS_LDAP_PORT:-1389} \
    --ldapsPort ${FRDS_LDAPS_PORT:-1636} \
    --httpsPort ${FRDS_HTTPS_PORT:-8443} \
    --profile am-cts:6.5.0 \
    --profile am-identity-store:7.5.0 \
    --profile am-config:6.5.0 \
    --profile idm-repo:7.5.0 \
    --set idm-repo/domain:${IDM_DOMAIN:-forgerock,dc=io} \
    --set idm-repo/backendName:${IDM_BACKEND_NAME} \
    --set am-cts/amCtsAdminPassword:${AMCTS_ADMIN_PASSWORD:-Passw0rd} \
    --set am-cts/baseDn:${AMCTS_BASE_DN:-ou=tokens} \
    --set am-cts/backendName:${AMCTS_BACKEND_NAME} \
    --set am-cts/tokenExpirationPolicy:${AMCTS_BACKEND_TOKEN_EXPIRARTION_POLICY:-ds} \
    --set am-identity-store/amIdentityStoreAdminPassword:${AMIDENTITYSTORE_ADMIN_PASSWORD:-Passw0rd} \
    --set am-identity-store/baseDn:${AMIDENTITYSTORE_BASE_DN:-ou=identities} \
    --set am-identity-store/backendName:${AMIDENTITYSTORE_BACKEND_NAME} \
    --set am-config/amConfigAdminPassword:${AMCONFIG_ADMIN_PASSWORD:-Passw0rd} \
    --set am-config/baseDn:${AMCONFIG_BASE_DN:-ou=am-config} \
    --set am-config/backendName:${AMCONFIG_BACKEND_NAME} \
    --acceptLicense \
    ${EXTRA_OPTIONS}

if [[ -f "/opt/frds/instance/init/dsconfig/setup.dsconfig" ]]; then
    DSCONFIG_SETUP=`envsubst </opt/frds/instance/init/dsconfig/setup.dsconfig`
fi
if [[ -f "/opt/frds/instance/init/dsconfig/replication.dsconfig" ]]; then
    DSCONFIG_REPLICATION=`envsubst </opt/frds/instance/init/dsconfig/replication.dsconfig`
fi
./bin/dsconfig --offline --no-prompt --batch <<EOF
# Use default values for the following global settings so that it is possible to run tools when building derived images.
set-global-configuration-prop --set "server-id:&{ds.server.id|docker}"
set-global-configuration-prop --set "group-id:&{ds.group.id|default}"
set-global-configuration-prop --set "advertised-listen-address:&{ds.advertised.listen.address|localhost}"
set-global-configuration-prop --advanced --set "trust-transaction-ids:&{platform.trust.transaction.header|true}"
${DSCONFIG_SETUP}
EOF

set +u
if [[ -v "DS_BOOTSTRAP_REPLICATION_SERVERS" ]]; then
./bin/dsconfig --offline --no-prompt --batch <<EOF
${DSCONFIG_REPLICATION}
set-synchronization-provider-prop --provider-name "Multimaster synchronization" --set "enabled:true" --set "bootstrap-replication-server:&{ds.bootstrap.replication.servers}"
EOF
fi

# Start initialization
ROOT_USER_DN=${ROOT_USER_DN} ROOT_USER_PASSWORD=${ROOT_USER_PASSWORD} /opt/frds/default-scripts/directory/init.sh
