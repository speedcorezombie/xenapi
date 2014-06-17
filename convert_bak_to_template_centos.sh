#!/bin/bash
#############################
#    Convert backup with    #
#    CentOS 6 to template   #
#     v 1.0 by speedcorez  #
#############################

TPL_NAME="centos-test"
VM_ROOT=/templates/mnt
TPL_ROOT=/templates/build/tmp

/usr/bin/rsync -auvHXA --numeric-ids ${VM_ROOT}/ ${TPL_ROOT}/
umount ${VM_ROOT}

# clear logs
find ${TPL_ROOT}/var/log/ -type f -exec truncate -s0 {} \;
# clear root's home
rm -f ${TPL_ROOT}/root/anaconda-ks.cfg ${TPL_ROOT}/root/install.log ${TPL_ROOT}/root/install.log.syslog
truncate -s0 ${TPL_ROOT}/root/.bash_history
# uncomment below for clear cron and mail
# rm -f /var/spool/cron/* /var/spool/mail/*
# delete ssh host keys
rm -f /etc/ssh/ssh_host_*

# clear network settings 
echo 'NETWORKING=yes'         > ${TPL_ROOT}/etc/sysconfig/network
echo 'HOSTNAME=__HOSTNAME__' >> ${TPL_ROOT}/etc/sysconfig/network
echo 'GATEWAY=__GATEWAY__'   >> ${TPL_ROOT}/etc/sysconfig/network

echo 'DEVICE="eth0"'          > ${TPL_ROOT}/etc/sysconfig/network-scripts/ifcfg-eth0
echo 'BOOTPROTO="static"'    >> ${TPL_ROOT}/etc/sysconfig/network-scripts/ifcfg-eth0
echo 'IPADDR="_IPADDR_"'     >> ${TPL_ROOT}/etc/sysconfig/network-scripts/ifcfg-eth0
echo 'NETMASK="__NETMASK__"' >> ${TPL_ROOT}/etc/sysconfig/network-scripts/ifcfg-eth0
echo 'ONBOOT="yes"'          >> ${TPL_ROOT}/etc/sysconfig/network-scripts/ifcfg-eth0
echo 'TYPE="Ethernet"'       >> ${TPL_ROOT}/etc/sysconfig/network-scripts/ifcfg-eth0

# change root hash
sed -i -e 's/^root:*$/root:__PASSWORD_HASH__:13879:0:99999:7:::/' ${TPL_ROOT}/etc/shadow

# archive template
tar --selinux --acls --xattr -czf /templates/${TPL_NAME}.tgz --numeric-owner -C ${TPL_ROOT} .
