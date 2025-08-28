#!/usr/bin/env bash
if [ -f "/opt/frds/instance/data/init_complete" ]; then
    ldapsearch \
        --hostname localhost \
        --port ${FRDS_LDAPS_PORT:-1636} \
        --bindDN "uid=admin" \
        --bindPassword "${ROOT_USER_PASSWORD:-Passw0rd}" \
        --useSsl \
        --trustAll \
        --baseDn "" \
        --searchScope base \
        "(objectClass=*)" 1.1
else
    exit 1;
fi
