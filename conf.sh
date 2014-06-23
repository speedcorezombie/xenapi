#!/bin/bash

# Commands
# for some command needed add sudo permission
CP='/bin/cp'
LVCREATE='/usr/bin/sudo /sbin/lvcreate'
LVREMOVE='/usr/bin/sudo /sbin/lvremove'
MKDIR='/bin/mkdir'
MKFS='/usr/bin/sudo /sbin/mkfs.ext4'
MKSWAP='/usr/bin/sudo /sbin/mkswap'
MOUNT='/usr/bin/sudo /bin/mount'
PWGEN='/usr/bin/pwgen'
${RM}='/bin/rm'
RMDIR='/bin/rmdir'
SED='/bin/sed'
TAR='/bin/tar'
UMOUNT='/usr/bin/sudo /bin/umount'
UUIDGEN='/usr/bin/uuidgen'
VIRSH='/usr/bin/sudo /usr/bin/virsh'

# Log file
LOG='/var/log/xenapi/xenapi.log'

# path to domain's package xml 
DOM_PATH='/templates/build'
# path to templates
TPL_PATH='/templates'
# tmp dir path
TMP_PATH='/templates/tmp'
# current volume group
VG='vg_vm'

# Network settings
NETMASK='255.255.254.0'
GATEWAY='91.195.124.1'

TECHDOMAIN='xen.tech-logol.ru'
