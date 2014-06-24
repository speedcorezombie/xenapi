#!/bin/bash

#######################################################
# Variables
#
# Commands
# for some command needed add sudo permission
CP='/bin/cp'
LVCREATE='/usr/bin/sudo /sbin/lvcreate'
LVREMOVE='/usr/bin/sudo /sbin/lvremove'
MKDIR='/bin/mkdir'
MKFS='/usr/bin/sudo /sbin/mkfs.ext4'
MKSWAP='/usr/bin/sudo /sbin/mkswap'
MOUNT='/usr/bin/sudo /bin/mount'
MV='/bin/mv'
PWGEN='/usr/bin/pwgen'
RM='/bin/rm'
RMDIR='/bin/rmdir'
SED='/bin/sed'
SUDO='/usr/bin/sudo'
TAR='/usr/bin/sudo /bin/tar'
UMOUNT='/usr/bin/sudo /bin/umount'
UUIDGEN='/usr/bin/uuidgen'
VIRSH='/usr/bin/sudo /usr/bin/virsh'

# Log file
LOG='/var/log/xenapi/xenapi.log'

CGI_PATH='/var/www/xenapi/cgi-bin'
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

#########################################################
# Functions

queryid_gen() {
        QUERYID="`/bin/date +%s`-`printf "%05.f\n" $RANDOM`" 
        export QUERYID
}

# Write message in log file
log() {
	DATE=`date +"%D %T %z"`
        echo "[${DATE}] ${QUERYID} ${ACTION}: $*" >> $LOG
}

# Write error message in log file and exit

error() {
        if [  "${QUERYFILE}" ] && [  "${LOCKFILE}" ]; then
                echo "500: $*" >> ${QUERYFILE}.lock
                ${MV} -f ${QUERYFILE}.lock ${QUERYFILE}.log
                ${RM} -f ${LOCKFILE}
        fi

        log "ERROR: $*"
        echo "500: $*"
        exit 1
}
