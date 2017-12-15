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
declare -A new_users
new_users['plona']='/home/plona'
new_users['fijal']='/home/fijal'
for key in "${!new_users[@]}"; do
    val=${new_users[$key]}
    new_user="$key"
    new_home="$val"
    useradd -m -s /bin/bash "$new_user"
    echo "$new_user:$new_user" | chpasswd
    usermod -aG sudo "$new_user"
    tar xf /tmp/homes.tgz -C "$new_home"
    chown -R "$new_user":"$new_user" "$new_home"
done
#useradd -m -s /bin/bash plona
#echo "plona:plona" | chpasswd
#usermod -aG sudo plona
#tar xf /tmp/homes.tgz -C /home/plona
#chown -R plona:plona /home/plona
tar xf /tmp/homes.tgz -C /root

# ip visible after login
echo >> /etc/motd
ip address show | grep -w inet >> /etc/motd
echo >> /etc/motd

# purge packages
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

# install packages
apt-get update
apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y install \
apt-file \
apt-transport-https \
binutils \
debian-goodies \
deborphan \
dnsutils \
gawk \
git \
htop \
less \
lsb-release \
lsof \
mc \
mlocate \
net-tools \
netcat-openbsd \
ntp \
ntpdate \
openssh-server \
openssl \
parted \
pv \
resolvconf \
rsync \
screen \
scsitools \
sudo \
sysv-rc \
sysvinit-core \
sysvinit-utils \
tcpdump \
tmux \
tree \
tshark \
vim \
wajig

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
[ -f inittab ] && mv inittab inittab.orig
cp /usr/share/sysvinit/inittab .
sed -i.orig -e 's/^#T0:23:respawn:\/sbin\/getty -L ttyS0 9600 vt100/T0:123:respawn:\/sbin\/getty -L ttyS0 115200 xterm/' /etc/inittab

cp /tmp/firstboot.sh /root
chmod a+x /root/firstboot.sh
echo '@reboot root /root/firstboot.sh' > /etc/cron.d/firstboot

