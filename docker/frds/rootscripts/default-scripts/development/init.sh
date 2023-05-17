#!/bin/bash -eux

ldif=(  
   "am-config/01-external-fram-policy-store.ldif"
   "identity/01-external-fram-identity-store.ldif"
)
/opt/frds/bin/start-ds
# Install the LDIF files
for i in "${ldif[@]}"
do
   ldapmodify -h localhost -p 1636 -X -Z -Duid=admin -wPassw0rd -f /opt/frds/instance/init/${i}
done
/opt/frds/bin/stop-ds
