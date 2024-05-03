#!/usr/bin/env bash
#
# Copyright 2020 ForgeRock AS. All Rights Reserved
#

set -o errexit
set -o pipefail
set -x

mv $FRAM_HOME/config/services/realm/root/iplanetamplatformservice/1.0/globalconfig/default/com-sun-identity-servers/http___localhost_8080_am.json \
   $FRAM_HOME/config/services/realm/root/iplanetamplatformservice/1.0/globalconfig/default/com-sun-identity-servers/http___am_80_am.json

cd $FRAM_HOME/config
oldHostname="http://localhost:8080/am"
newHostname="http://am:80/am"
find . -name '*.json' -type f -exec sed -i "s+$oldHostname+$newHostname+g" {} \;

mv /opt/templates/boot.json $FRAM_HOME/config
mv /opt/templates/rsa_api.properties $FRAM_HOME/config/auth/ace/data/rsa_api.properties

/opt/amupgrade/amupgrade -i ${FRAM_HOME}/config/services -o ${FRAM_HOME}/config/services --fileBasedMode --prettyArrays ${FORGEROCK_HOME}/7.0.0-placeholders.groovy
/opt/amupgrade/amupgrade -i ${FRAM_HOME}/config/services -o ${FRAM_HOME}/config/services --fileBasedMode ${FORGEROCK_HOME}/serverconfig-modification.groovy
/opt/amupgrade/amupgrade -i ${FRAM_HOME}/config/services -o ${FRAM_HOME}/config/services --fileBasedMode ${FORGEROCK_HOME}/darkedges-modification.groovy
rawIdRepoValue="LDAPv3ForOpenDS"
placeholderedIdRepoValue="\&{am.stores.user.type}"
find . -name 'opendj.json' -type f -exec sed -i "s+$rawIdRepoValue+$placeholderedIdRepoValue+g" {} \;

mv /opt/templates/serverconfig.xml $FRAM_HOME/config/services/realm/root/iplanetamplatformservice/1.0/globalconfig/default/com-sun-identity-servers/

# find ${FRAM_HOME}/config -type f -name '*.json' -exec sh -c 'python3 -m json.tool --sort-keys < $0 | sponge $0' {} \;