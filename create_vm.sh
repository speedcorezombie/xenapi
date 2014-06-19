#!/bin/bash
# Parameters:
# name template 
source ./conf.sh
NAME=
TEMPLATE=
PACKAGE=
IP=
PASSWORD=
HOST=vm${NAME}.xen.tech-logol.ru
UUID=`uuidgen`
DISK=${NAME}
SWAP=${NAME}_swap
TPL_ROOT=/templates/tmp/${DISK}
case "PACKAGE" in
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
	/usr/sbin/lvcreate -L${DISK_SIZE}G -n ${DISK} ${VG}
else
	echo "ERROR: lvm is present"
	exit 3
fi
if [ ! -e /dev/${VG}/${SWAP} ]; then
	/usr/sbin/lvcreate -L${SWAP_SIZE}G -n ${SWAP} ${VG}
else
        echo "ERROR: lvm is present"
        exit 3
fi
# make filesystem and swap
mkfs.ext4 /dev/${VG}/${DISK}
mkswap    /dev/${VG}/${SWAP}
# make tmp dir for temlate deploy
if [ ! -e ${TPL_ROOT} ]; then
	mkdir ${TPL_ROOT}
fi
# mount disk lvm and deploy template
mount /dev/${VG}/${DISK} ${TPL_ROOT}
tar xzf /templates/${TEMPLATE}.tgz -C ${TPL_ROOT}
# set network and password parameters
./setup_vm_${TEMPLATE}.sh ${IP} ${MASK} ${GATE} ${HOST} ${PASS}
umount ${TPL_ROOT}
rmdir ${TPL_ROOT}
cp ${DOM_PATH}/template_${PACKAGE}.xml ${DOM_PATH}/${NAME}.xml
sed -i -e 's/__NAME__/'${NAME}'/' ${DOM_PATH}/${NAME}.xml
sed -i -e 's/__UUID__/'${UUID}'/' ${DOM_PATH}/${NAME}.xml
sed -i -e 's/__VG__/'${VG}'/' ${DOM_PATH}/${NAME}.xml
sed -i -e 's/__DISK_SRC_DEV__/'${DISK}'/' ${DOM_PATH}/${NAME}.xml
sed -i -e 's/__SWAP_SRC_DEV__/'${SWAP}'/' ${DOM_PATH}/${NAME}.xml
virsh define ${DOM_PATH}/${NAME}.xml 
virsh define autostart ${NAME}
virsh start ${NAME}
