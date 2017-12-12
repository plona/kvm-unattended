#!/bin/bash

# This script is run by debian installer using preseed/late_command
# directive, see preseed.cfg

# grub text console & ipv6 off
tar xf /tmp/conf.tgz -C /
#mv /etc/default/grub /etc/default/grub.orig
#mv /tmp/grub /etc/default/grub
update-grub

# ip visible after login
echo >> /etc/motd
ip address show | grep -w inet >> /etc/motd
echo >> /etc/motd

# remove fake lv vol & resize root part
#umount /extra
sed -i.orig -e 's/.*\/extra.*//g' /etc/fstab
#lv_extra=$(lvscan | grep extra | awk '{print $2}' | tr -d "'")
#lvremove --force $lv_extra
#lvextend -r -l +100%FREE /dev/system/root

export DEBIAN_FRONTEND=noninteractive
apt-get purge -y \
dictionaries-common \
emacsen-common \
iamerican \
ibritish \
ienglish-common \
laptop-detect \
nano \
task-english \
tasksel \
tasksel-data
