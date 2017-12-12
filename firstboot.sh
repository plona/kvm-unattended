#!/bin/bash - 
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/bin
export PATH
set -o verbose
set -o xtrace
exec 1>/root/firstboot.log 2>&1

date
umount /extra
sed -i.orig -e 's/.*\/extra.*//g' /etc/fstab
lv_extra=$(lvscan | grep extra | awk '{print $2}' | tr -d "'")
lvremove --force $lv_extra
lvextend -r -l +100%FREE /dev/system/root
rm -fv /etc/firstboot
rm /root/firstboot.sh


