xenapi
======

API for xen vps hosting

add to sudoers:

#Defaults    requiretty
apache  ALL =   NOPASSWD: /bin/umount
apache  ALL =   NOPASSWD: /bin/mount
apache  ALL =   NOPASSWD: /sbin/lvremove
apache  ALL =   NOPASSWD: /sbin/lvcreate
apache  ALL =   NOPASSWD: /sbin/mkswap
apache  ALL =   NOPASSWD: /sbin/mkfs.ext4
apache  ALL =   NOPASSWD: /usr/bin/virsh

