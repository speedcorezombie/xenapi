#!/bin/bash
# Parameters:
# name
if [ $# -lt 1  ]; then
        echo "Usage: destroy_vm.sh NAME"
        exit 1
fi

source ./conf.sh
NAME=$1
DISK=${NAME}
SWAP=${NAME}_swap

${VIRSH} destroy ${NAME}
${VIRSH} undefine ${NAME}
${LVREMOVE} -f /dev/${VG}/${DISK}
${LVREMOVE} -f /dev/${VG}/${SWAP}
${RM} ${DOM_PATH}/${NAME}.xml

