#!/bin/bash -eux

upgradeXtoY() {
    CURRENTVERSION=$1
    NEXTVERSION=$2
    CURRENTVERSION_C=$(echo "$CURRENTVERSION" | sed "s/0/x/g" | sed "s/[0-9]$/x/")
    NEXTVERSION_C=$(echo "$NEXTVERSION" | sed "s/0/x/g")
    rm -rf /tmp/fram/${NEXTVERSION}
    echo "Converting from ${CURRENTVERSION} to ${NEXTVERSION}"
    /home/forgerock/amupgrade/amupgrade \
        --inputConfig /tmp/fram/${CURRENTVERSION} \
        --output /tmp/fram/${NEXTVERSION} \
        --amsterVersion ${NEXTVERSION} \
        /home/forgerock/amupgrade/rules/amster/${CURRENTVERSION_C}-to-${NEXTVERSION_C}.groovy
    applyPostPatch${NEXTVERSION_C}
}

applyPostPatch7.2.x() {
    echo "Nothing to Patch"
}

applyPostPatch7.3.x() {
    echo "Nothing to Patch"
}

applyPostPatch7.4.x() {
    echo "Nothing to Patch"
}

CMD="${1:-upgrade}"
case "$CMD" in
upgrade720to730)
    upgradeXtoY 7.2.0 7.3.0 
    ;;
upgrade730to740)
    upgradeXtoY 7.3.0 7.4.0 
    ;;
upgrade)
    upgradeXtoY 7.2.0 7.3.0
    upgradeXtoY 7.3.0 7.4.0
    ;;
*)
    exec "$@"
esac