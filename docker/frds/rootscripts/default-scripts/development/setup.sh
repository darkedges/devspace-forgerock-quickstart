#!/bin/bash -eux

#Initial values
AMCTS_BACKEND_NAME=${AMCTS_BACKEND_NAME:-amCts}
AMCONFIG_BACKEND_NAME=${AMCONFIG_BACKEND_NAME:-cfgStore}
AMIDENTITYSTORE_BACKEND_NAME=${AMIDENTITYSTORE_BACKEND_NAME:-amIdentityStore}

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
./setup \
    --deploymentKey "${DEPLOYMENT_KEY:-AKtnvIyweZddXIA2jL4hq6F5Bn7C1Q5CBVN1bkVDfvPByQLPrt_1mJw}" \
    --deploymentKeyPassword "${DEPLOYMENT_KEY_PASSWORD:-Passw0rd}" \
    --serverId "${HOSTNAME}" \
    --instancePath /opt/frds/instance/data \
    --rootUserDN "uid=admin" \
    --rootUserPassword "${ROOT_USER_PASSWORD:-Passw0rd}" \
    --monitorUserPassword "${MONITOR_USER_PASSWORD:-Passw0rd}" \
    --hostname ${HOSTNAME} \
    --adminConnectorPort 4444 \
    --ldapPort ${FRDS_LDAP_PORT:-1389} \
    --ldapsPort ${FRDS_LDAPS_PORT:-1636} \
    --httpsPort ${FRDS_HTTPS_PORT:-8443} \
    --profile am-identity-store \
    --profile am-config \
    --profile am-cts \
    --set am-cts/amCtsAdminPassword:${AMCTS_ADMIN_PASSWORD:-Passw0rd} \
    --set am-cts/baseDn:${AMCTS_BASE_DN:-ou=tokens} \
    --set am-cts/backendName:${AMCTS_BACKEND_NAME} \
    --set am-cts/tokenExpirationPolicy:${AMCTS_BACKEND_TOKEN_EXPIRARTION_POLICY:-ds} \
    --set am-identity-store/amIdentityStoreAdminPassword:${AMIDENTITYSTORE_ADMIN_PASSWORD:-Passw0rd} \
    --set am-identity-store/baseDn:${AMIDENTITYSTORE_BASE_DN:-ou=identities} \
    --set am-identity-store/backendName:${AMIDENTITYSTORE_BACKEND_NAME} \
    --set am-config/amConfigAdminPassword:${AMCONFIG_ADMIN_PASSWORD:-Passw0rd} \
    --set am-config/baseDn:${AMCONFIG_BASE_DN:-ou=amconfig} \
    --set am-config/backendName:${AMCONFIG_BACKEND_NAME} \
    --acceptLicense \
    ${EXTRA_OPTIONS}

./bin/dsconfig --offline --no-prompt --batch <<EOF
# Use default values for the following global settings so that it is possible to run tools when building derived images.
set-global-configuration-prop --set "server-id:&{ds.server.id|docker}"
set-global-configuration-prop --set "group-id:&{ds.group.id|default}"
set-global-configuration-prop --set "advertised-listen-address:&{ds.advertised.listen.address|localhost}"
set-global-configuration-prop --advanced --set "trust-transaction-ids:&{platform.trust.transaction.header|true}"
set-backend-prop --backend-name ${AMCTS_BACKEND_NAME} --set confidentiality-enabled:false
set-backend-prop --backend-name ${AMCONFIG_BACKEND_NAME} --set confidentiality-enabled:false
set-backend-prop --backend-name ${AMIDENTITYSTORE_BACKEND_NAME} --set confidentiality-enabled:false
set-password-policy-prop --policy-name "Default Password Policy"--set require-secure-authentication:false
EOF

set +u
if [[ -v "${DS_BOOTSTRAP_REPLICATION_SERVERS}" ]]; then
./bin/dsconfig --offline --no-prompt --batch <<EOF
set-synchronization-provider-prop --provider-name "Multimaster synchronization" --set "enabled:true" --set "bootstrap-replication-server:&{ds.bootstrap.replication.servers}"
EOF

# Start initialization
./init.sh
fi