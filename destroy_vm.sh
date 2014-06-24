#!/bin/bash
# Parameters:
# name
if [ $# -lt 1  ]; then
        echo "Usage: destroy_vm.sh VMID"
        exit 1
fi

source ./conf.sh
VMID=$1
DISK=${VMID}
SWAP=${VMID}_swap

${VIRSH} destroy ${VMID}
${VIRSH} undefine ${VMID}
${LVREMOVE} -f /dev/${VG}/${DISK}
${LVREMOVE} -f /dev/${VG}/${SWAP}
${RM} ${DOM_PATH}/${VMID}.xml

