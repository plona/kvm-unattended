#!/bin/bash - 
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/bin
export PATH
set -o verbose
set -o xtrace
exec 1>/root/firstboot.log 2>&1

# remove extra lvm partition
umount /extra
sed -i.orig -e 's/.*\/extra.*//g' /etc/fstab
lv_extra=$(lvscan | grep extra | awk '{print $2}' | tr -d "'")
lvremove --force $lv_extra
lvextend -r -l +100%FREE /dev/system/root

# remove systemd
export DEBIAN_FRONTEND=noninteractive
apt-get purge -y systemd
apt-get -y autoremove
ec=$(deborphan | wc -l)
while [ $ec -gt 0 ]; do
    deborphan | xargs apt-get -y purge
    ec=$(deborphan | wc -l)
done

# delete user instalator
# userdel -r instalator

# turn off firstboot
rm -fv /etc/firstboot
rm /root/firstboot.sh


