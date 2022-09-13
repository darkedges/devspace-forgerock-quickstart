#!/bin/bash -eux

./setup \
    --deploymentKey "${DEPLOYMENT_KEY}" \
    --deploymentKeyPassword "${DEPLOYMENT_KEY_PASSWORD}" \
    --serverId "${HOSTNAME}" \
    --instancePath /opt/frds/instance/data \
    --rootUserDN "uid=admin" \
    --rootUserPassword "${ROOT_USER_PASSWORD}" \
    --monitorUserPassword "${MONITOR_USER_PASSWORD}" \
    --hostname ${HOSTNAME} \
    --adminConnectorPort 4444 \
    --ldapPort 389 \
    --ldapsPort 636 \
    --httpsPort 8443 \
    --profile am-config \
    --set am-config/amConfigAdminPassword:${AMCONFIG_ADMIN_PASSWORD} \
    --set am-config/baseDn:${AMCONFIG_BASE_DN} \
    --set am-config/backendName:${AMCONFIG_BACKEND_NAME} \
    --acceptLicense

./bin/dsconfig --offline --no-prompt --batch <<EOF
# Use default values for the following global settings so that it is possible to run tools when building derived images.
set-global-configuration-prop --set "server-id:&{ds.server.id|docker}"
set-global-configuration-prop --set "group-id:&{ds.group.id|default}"
set-global-configuration-prop --set "advertised-listen-address:&{ds.advertised.listen.address|localhost}"
set-global-configuration-prop --advanced --set "trust-transaction-ids:&{platform.trust.transaction.header|false}"
set-synchronization-provider-prop --provider-name "Multimaster synchronization" --set "enabled:true" --set "bootstrap-replication-server:&{ds.bootstrap.replication.servers|localhost:8989}"
EOF