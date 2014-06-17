#!/bin/bash
# Apply network and password settings to deployed centos temlate
if [ $# -lt 5  ]; then
        echo "Usage: centos-create.sh IP MASK GATE HOST PASS"
        exit 1
fi
IP=$1
MASK=$2
GATE=$3
HOST=$4
PASS=$5
SALT=`pwgen -n1`
TPL_ROOT=/templates/mnt
HASH=`/root/api/hgen.pl $PASS $SALT`

sed -i -e 's/__HOSTNAME__/'$HOST'/'  ${TPL_ROOT}/etc/sysconfig/network
sed -i -e 's/__GATEWAY__/'$GATE'/'   ${TPL_ROOT}/etc/sysconfig/network
sed -i -e 's/__IPADDR__/'$IP'/'      ${TPL_ROOT}/etc/sysconfig/network-scripts/ifcfg-eth0
sed -i -e 's/__NETMASK__/'$MASK'/'   ${TPL_ROOT}/etc/sysconfig/network-scripts/ifcfg-eth0
sed -i -e 's#__PASSWORD_HASH__#'$HASH'#'      ${TPL_ROOT}/etc/shadow
