#!/bin/bash
set -o nounset
set -o verbose
set -o xtrace
exec 1>/root/postinstall.log 2>&1

# This script is run by debian installer using preseed/late_command
# directive, see preseed.cfg

# grub text console & ipv6 off. Default conf files 
tar xf /tmp/conf.tgz -C /
update-grub

#users
. /tmp/users.txt
for key in "${!new_users[@]}"; do
    val=${new_users[$key]}
    new_user="$key"
    new_home="$val"
    useradd -m -s /bin/bash "$new_user"
    echo "$new_user:$new_user" | chpasswd
    usermod -aG sudo "$new_user"
    chage -d0 $new_user
    tar xf /tmp/homes.tgz -C "$new_home"
    chmod 700 "$new_home"
    chown -R "$new_user":"$new_user" "$new_home"
done
tar xf /tmp/homes.tgz -C /root

# ip visible after login
echo >> /etc/motd
ip address show | grep -w inet >> /etc/motd
echo >> /etc/motd

# packages
export DEBIAN_FRONTEND=noninteractive

# purge packages
cat /tmp/packages_u.txt | \
    sed -e 's/#.*$//' -e '/^$/d' | \
    xargs apt-get -y purge 

# install packages
apt-get update
cat /tmp/packages_i.txt | \
    sed -e 's/#.*$//' -e '/^$/d' | \
    xargs apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y install 
apt-get -y autoremove

# short tmux
cd /usr/bin && ln -s tmux t

# disable root login via ssh
sed -i.orig -e 's/^PermitRootLogin\s.*\|^#.*PermitRootLogin\s.*/PermitRootLogin no/' /etc/ssh/sshd_config

# additional locales
sed -i.orig -e 's/.*pl_PL\.UTF-8.*/pl_PL.UTF-8 UTF-8/' -e 's/.*en_US\.UTF-8.*/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=pl_PL.UTF-8' > /etc/default/locale

# replace systemd with sysvinit
cd /etc
[ -f inittab ] && mv inittab inittab.orig_00
cp /usr/share/sysvinit/inittab .
sed -i.orig_01 -e 's/^#T0:23:respawn:\/sbin\/getty -L ttyS0 9600 vt100/T0:123:respawn:\/sbin\/getty -L ttyS0 115200 xterm/' /etc/inittab

cp /tmp/firstboot.sh /root
chmod a+x /root/firstboot.sh
echo '@reboot root /root/firstboot.sh' > /etc/cron.d/firstboot

