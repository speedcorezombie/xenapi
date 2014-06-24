#!/bin/bash
# Parameters:
# name template package ip pass
if [ $# -lt 5  ]; then
        echo "Usage: create_vm.sh VMID TEMPLATE PACKAGE IP PASS"
        exit 1
fi

source ./conf.sh
ACTION='create'

VMID=$1
TEMPLATE=$2
PACKAGE=$3
IP=$4
PASSWORD=$5
HOST=vm${VMID}.${TECHDOMAIN}
UUID=`${UUIDGEN}`
DISK=${VMID}
SWAP=${VMID}_swap
TPL_ROOT=${TMP_PATH}/${DISK}


# Determine disk and swap size
case "${PACKAGE}" in
	s)
		DISK_SIZE=10
		SWAP_SIZE=1
		;;
	m)
        	DISK_SIZE=15
        	SWAP_SIZE=1
		;;
	l)
        	DISK_SIZE=20
        	SWAP_SIZE=1
		;;
	*)
		error "Undefined disk and swap size"
esac

# create LVMs for disk and swap, if they present - stop creating
if [ ! -e /dev/${VG}/${DISK} ]; then
	${LVCREATE} -L${DISK_SIZE}G -n ${DISK} ${VG}
else
	error "LVM is present"
fi
if [ ! -e /dev/${VG}/${SWAP} ]; then
	${LVCREATE} -L${SWAP_SIZE}G -n ${SWAP} ${VG}
else
        error "LVM is present"
fi
log "LVMs created"

# make filesystem and swap
${MKFS} -L root /dev/${VG}/${DISK}
if [ $? -ne 0 ]; then
        error "Make FS failed"
else
	log   "Filesystem created"
fi
${MKSWAP} -L swap    /dev/${VG}/${SWAP}
if [ $? -ne 0 ]; then
        error "Make swap failed"
else
        log   "Swap created"
fi

# make tmp dir for temlate deploy
if [ ! -e ${TPL_ROOT} ]; then
	${MKDIR} ${TPL_ROOT}
fi

# mount disk lvm and deploy template
${MOUNT} /dev/${VG}/${DISK} ${TPL_ROOT}
if [ $? -ne 0 ]; then
	error "Disk mount failed"
else
	log   "Disk is mounted"
fi
${TAR} xzf ${TPL_PATH}/${TEMPLATE}.tgz -C ${TPL_ROOT}
if [ $? -ne 0 ]; then
        error "Template deploy failed"
else
	log   "Template deployed"
fi

# set network and password parameters
${SUDO} ${CGI_PATH}/setup_vm_${TEMPLATE}.sh ${IP} ${NETMASK} ${GATEWAY} ${HOST} ${PASSWORD} ${TPL_ROOT}
if [ $? -ne 0 ]; then 
	error "Setup failed"
else
	log   "Setup completed"
fi

${UMOUNT} ${TPL_ROOT}
${RMDIR} ${TPL_ROOT}

# Create domain xml file
${CP} ${DOM_PATH}/template_${PACKAGE}.xml ${DOM_PATH}/${VMID}.xml
if [ $? -ne 0 ]; then
        error "Fail to create VM domain file"
fi
${SED} -i -e 's/__NAME__/'${VMID}'/' ${DOM_PATH}/${VMID}.xml
${SED} -i -e 's/__UUID__/'${UUID}'/' ${DOM_PATH}/${VMID}.xml
${SED} -i -e 's/__VG__/'${VG}'/' ${DOM_PATH}/${VMID}.xml
${SED} -i -e 's/__DISK_SRC_DEV__/'${DISK}'/' ${DOM_PATH}/${VMID}.xml
${SED} -i -e 's/__SWAP_SRC_DEV__/'${SWAP}'/' ${DOM_PATH}/${VMID}.xml
if [ $? -ne 0 ]; then
        error "Fail to setup VM domain file"
else
	log "VM domain file created"
fi
# Define and start VM
${VIRSH} define ${DOM_PATH}/${VMID}.xml
if [ $? -ne 0 ]; then 
        error "VM domain define failed"
else
	log   "VM domain defined"
fi 
${VIRSH} autostart ${VMID}
${VIRSH} start ${VMID}
if [ $? -ne 0 ]; then
        error "VM start failed"
else
        log   "VM started"
fi
