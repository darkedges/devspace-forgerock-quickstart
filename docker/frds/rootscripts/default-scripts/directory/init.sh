#!/bin/bash -eux
if [[ $HOSTNAME == *-0 ]]; then
   ldif=(  
      "01-external-fram-policy-store.ldif"
      "02-external-fram-identity-store.ldif"
      "03-external-alpha-fram-policy-store.ldif"
   )
   if [[ -f "/opt/frds/instance/init/dsconfig/init.dsconfig" ]]; then
      readarray -t ldif < <(envsubst </opt/frds/instance/init/dsconfig/init.dsconfig) 
   fi
   /opt/frds/bin/start-ds
   # Install the LDIF files
   for i in "${ldif[@]}"
   do
      ldapmodify -h localhost -p 1636 -X -Z -D ${ROOT_USER_DN} -w ${ROOT_USER_PASSWORD} -f /opt/frds/instance/init/ldif/${i}
   done
fi
/opt/frds/bin/stop-ds
touch /opt/frds/instance/data/init_complete
