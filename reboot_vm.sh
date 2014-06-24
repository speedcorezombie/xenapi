#!/bin/bash
# 
# Reboot VM
if [ $# -lt 1  ]; then
        echo "Usage: reboot_vm.sh VMID"
        exit 1
fi
source ./conf.sh
VMID=$1

virsh reboot ${VMID}
echo $?
