#!/bin/bash -eux

ldif=(  
   "01-external-fram-policy-store.ldif"
   "02-external-fram-identity-store.ldif"
)
/opt/frds/bin/start-ds
# Install the LDIF files
for i in "${ldif[@]}"
do
   ldapmodify -h localhost -p 1636 -X -Z -D ${ROOT_USER_DN} -w ${ROOT_USER_PASSWORD} -f /opt/frds/instance/init/${i}
done
touch /opt/frds/instance/data/init_complete
/opt/frds/bin/stop-ds
