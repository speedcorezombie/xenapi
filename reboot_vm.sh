#!/bin/bash
# 
# Reboot VM
if [ $# -lt 1  ]; then
        echo "Usage: reboot_vm.sh NAME"
        exit 1
fi
source ./conf.sh
NAME=$1

virsh reboot ${NAME}
echo $?
