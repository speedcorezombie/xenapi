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

virsh destroy ${NAME}
virsh undefine ${NAME}
lvremove -f /dev/${VG}/${DISK}
lvremove -f /dev/${VG}/${SWAP}
