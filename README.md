xenapi
======

API for xen vps hosting
-----------------------

For work some commands is need add to /etc/sudoers:

> \#Defaults    requiretty
apache  ALL =   NOPASSWD: /bin/umount
apache  ALL =   NOPASSWD: /bin/mount
apache  ALL =   NOPASSWD: /sbin/lvremove
apache  ALL =   NOPASSWD: /sbin/lvcreate
apache  ALL =   NOPASSWD: /sbin/mkswap
apache  ALL =   NOPASSWD: /sbin/mkfs.ext4
apache  ALL =   NOPASSWD: /usr/bin/virsh
apache  ALL =   NOPASSWD: /bin/tar
apache  ALL =   NOPASSWD: /var/www/xenapi/cgi-bin/setup_vm_centos65.sh
