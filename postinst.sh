#!/bin/sh

# This script is run by debian installer using preseed/late_command
# directive, see preseed.cfg

mv /etc/default/grub /etc/default/grub.orig
mv /tmp/grub /etc/default/grub
update-grub

echo >> /etc/motd
ip address show | grep -w inet >> /etc/motd
echo >> /etc/motd

