#!/bin/bash - 
#===============================================================================
#
#          FILE: v
# 
#         USAGE: ./v
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Marek Płonka (marekpl), marek.plonka@nask.pl
#  ORGANIZATION: NASK
#       CREATED: 12/07/2017 12:38:30 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

DOMAIN=`/bin/hostname -d` # Use domain of the host system
DIST_URL="http://ftp.de.debian.org/debian/dists/stretch/main/installer-amd64/"
homes="home"
conf="conf"

# prepare files
rm -rf $homes/.vim || true
cp -Rp $HOME/.vim $homes

shopt -s dotglob
pushd $homes
    tar czf ../homes.tgz *
    rm -rf .vim
popd
pushd $conf
    tar czf ../conf.tgz *
popd
shopt -u dotglob

virt-install \
    --connect qemu:///system \
    --name=$1 \
    --memory=2048 \
    --vcpus=2 \
    --disk size=10,cache=writeback \
    --initrd-inject=preseed.cfg \
    --initrd-inject=postinst.sh \
    --initrd-inject=firstboot.sh \
    --initrd-inject=conf.tgz \
    --initrd-inject=homes.tgz \
    --location ${DIST_URL} \
    --os-type linux \
    --os-variant=debian9 \
    --virt-type=kvm \
    --network network=default \
    --graphic none \
    --extra-args="auto=true hostname="${1}" domain="${DOMAIN}" console=tty0 console=ttyS0,115200n8 serial"

#virt-clone --connect qemu:///system --original d9 --name d9a --file /var/lib/libvirt/images/d9a.qcow2

#pushd ansible
#    ansible-playbook install.yml -kK
#popd
virsh --connect qemu:///system shutdown $1
sleep 30
virt-clone --connect qemu:///system --original $1 --name $1a --file /var/lib/libvirt/images/$1a.qcow2

virsh --connect qemu:///system undefine $1
virsh --connect qemu:///system vol-delete $1.qcow2 --pool default

