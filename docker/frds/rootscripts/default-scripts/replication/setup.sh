#!/bin/bash -eux

export ROOT_USER_DN=${ROOT_USER_DN:-uid=admin}
export ROOT_USER_PASSWORD=${ROOT_USER_PASSWORD:-Passw0rd}
DSCONFIG_SETUP=""
DSCONFIG_REPLICATION=""

./setup \
    --deploymentId "${DEPLOYMENT_KEY:-AeHV0e6uT7eUFASCfG0MWRZKCYY3Zw5CBVN1bkVDDJrPKRD22mygkg}" \
    --deploymentIdPassword "${DEPLOYMENT_KEY_PASSWORD:-Passw0rd}" \
    --serverId "${HOSTNAME}" \
    --instancePath /opt/frds/instance/data \
    --rootUserDN "uid=admin" \
    --rootUserPassword "${ROOT_USER_PASSWORD}" \
    --monitorUserPassword "${MONITOR_USER_PASSWORD}" \
    --hostname ${HOSTNAME} \
    --adminConnectorPort 4444 \
    --replicationPort 8989 \
    --acceptLicense

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
ROOT_USER_DN=${ROOT_USER_DN} ROOT_USER_PASSWORD=${ROOT_USER_PASSWORD} /opt/frds/default-scripts/replication/init.sh