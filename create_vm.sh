#!/bin/bash
# Parameters:
# name template 
if [ $# -lt 5  ]; then
        echo "Usage: create_vm.sh NAME TEMPLATE PACKAGE IP PASS"
        exit 1
fi


source ./conf.sh
NAME=$1
TEMPLATE=$2
PACKAGE=$3
IP=$4
PASSWORD=$5
HOST=vm${NAME}.${TECHDOMAIN}
UUID=`${UUIDGEN}`
DISK=${NAME}
SWAP=${NAME}_swap
TPL_ROOT=${TMP_PATH}/${DISK}
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
		echo "ERROR: undefined disk size"
		exit 2
esac

# create LVMs for disk and swap, if they present - stop creating
if [ ! -e /dev/${VG}/${DISK} ]; then
	${LVCREATE} -L${DISK_SIZE}G -n ${DISK} ${VG}
else
	echo "ERROR: lvm is present"
	exit 3
fi
if [ ! -e /dev/${VG}/${SWAP} ]; then
	${LVCREATE} -L${SWAP_SIZE}G -n ${SWAP} ${VG}
else
        echo "ERROR: lvm is present"
        exit 3
fi
# make filesystem and swap
${MKFS} -L root /dev/${VG}/${DISK}
${MKSWAP} -L swap    /dev/${VG}/${SWAP}
# make tmp dir for temlate deploy
if [ ! -e ${TPL_ROOT} ]; then
	${MKDIR} ${TPL_ROOT}
fi
# mount disk lvm and deploy template
${MOUNT} /dev/${VG}/${DISK} ${TPL_ROOT}
${TAR} xzf ${TPL_PATH}/${TEMPLATE}.tgz -C ${TPL_ROOT}
# set network and password parameters
${SUDO} ${CGI_PATH}/setup_vm_${TEMPLATE}.sh ${IP} ${NETMASK} ${GATEWAY} ${HOST} ${PASSWORD} ${TPL_ROOT}
${UMOUNT} ${TPL_ROOT}
${RMDIR} ${TPL_ROOT}

# Create domain xml file
${CP} ${DOM_PATH}/template_${PACKAGE}.xml ${DOM_PATH}/${NAME}.xml
${SED} -i -e 's/__NAME__/'${NAME}'/' ${DOM_PATH}/${NAME}.xml
${SED} -i -e 's/__UUID__/'${UUID}'/' ${DOM_PATH}/${NAME}.xml
${SED} -i -e 's/__VG__/'${VG}'/' ${DOM_PATH}/${NAME}.xml
${SED} -i -e 's/__DISK_SRC_DEV__/'${DISK}'/' ${DOM_PATH}/${NAME}.xml
${SED} -i -e 's/__SWAP_SRC_DEV__/'${SWAP}'/' ${DOM_PATH}/${NAME}.xml

# Define and start VM
${VIRSH} define ${DOM_PATH}/${NAME}.xml 
${VIRSH} autostart ${NAME}
${VIRSH} start ${NAME}
