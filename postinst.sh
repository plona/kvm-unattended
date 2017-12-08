#!/bin/sh

# This script is run by debian installer using preseed/late_command
# directive, see preseed.cfg

# Setup console, remove timeout on boot.
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="console=ttyS0"/g; s/TIMEOUT=5/TIMEOUT=0/g' /etc/default/grub
update-grub

