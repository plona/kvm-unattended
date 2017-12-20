#!/bin/bash
# based on:
# http://ostolc.org/category/kvm.html

if [ $# -ne 5 ] ; then
	echo "Usage: $0 <OS> <NAME> <RAM_GB> <DISK_GB> <CPUs>"
	echo "  Where OS is one of the following"
	echo "    centos-6.5-64"
	echo "    fedora-19-64"
	echo "    ubuntu-12.04-64"
	echo "    debian-7.1-64"
	exit 1
fi

OS=$1
NAME=$2
RAM_MB=$(($3*1024))
DISK_GB=$4
VCPUS=$5

if [ "$OS" == "centos-6.5-64" ] ; then
        LOCATION="http://mirror.i3d.net/pub/centos/6.5/os/x86_64/"
	EXTRA_ARGS="ks=http://ostolc.org/pxe/centos-6.5-64.cfg"
elif [ "$OS" == "fedora-19-64" ] ; then
        LOCATION="http://mirror.i3d.net/pub/fedora/linux/releases/19/Fedora/x86_64/os/"
        EXTRA_ARGS="ks=http://ostolc.org/pxe/fedora-19-64.cfg"
elif [ "$OS" == "ubuntu-12.04-64" ] ; then
        LOCATION="http://archive.ubuntu.com/ubuntu/dists/precise/main/installer-amd64/"
        EXTRA_ARGS="auto=true interface=eth0 hostname=ubuntu1204 url=http://ostolc.org/pxe/ubuntu-12.04-64.cfg"
elif [ "$OS" == "debian-7.1-64" ] ; then
        LOCATION="http://ftp.debian.org/debian/dists/Debian7.1/main/installer-amd64/"
        EXTRA_ARGS="auto=true interface=eth0 hostname=debian71 domain=localdomain url=http://ostolc.org/pxe/debian-7.1-64.cfg"
else
        echo "Wrong OS!"
        exit 1
fi

virt-install                            \
        --connect qemu:///system        \
        --virt-type kvm                 \
	--os-type linux			\
	--os-varian virtio26		\
        --name $NAME                    \
        --ram $RAM_MB                   \
        --disk path=/var/lib/libvirt/images/$NAME.qcow2,format=qcow2,size=$DISK_GB	\
        --network bridge=br0            \
        --vcpus $VCPUS                  \
        --graphics vnc                  \
        --noautoconsole                 \
        --location $LOCATION            \
        --extra-args "$EXTRA_ARGS"
