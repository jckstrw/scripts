#!/bin/bash
# 
# Wrapper script used to create a VM
#
# jmm - 2015-02-24

if [[ `whoami` != 'root' ]]; then
        echo "You must be root to run this"
        exit 1
fi

read -p "Name of VM: " NAME
read -p "RAM (2): " RAM
RAM=${RAM:-2}
read -p "CPU (1): " CPU
CPU=${CPU:-1}
read -p "Disk Path: " DISKPATH
DISKPATH=${DISKPATH}
if [ -f $DISKPATH ];
then
	echo "file exists"
	exit 1
fi
read -p "Disk Size (16): " DISKSIZE
DISKSIZE=${DISKSIZE:-16}
read -p "Bridge: " BRIDGE
read -p "Installer (trusty): " INSTALLER
INSTALLER=${INSTALLER:-http://repo2.15c.lijit.com/install/ubuntu/trusty/installer-amd64}
read -p "IP: " IP
read -p "Netmask: " MASK
read -p "Gateway: " GW
read -p "Hostname: " HOSTNAME
read -p "Domain: " DOMAIN 
read -p"Preseed Image: " IMAGE 

#echo "virt-install -n $NAME  -r $RAM —vcpus=$CPU --os-type=linux --disk path=$DISK -w bridge=$BRIG --accelerate --virt-type kvm —location=$LOC --vnc --extra-args=\"netcfg/disable_autoconfig=true netcfg/get_nameservers=10.100.10.31 netcfg/get_ipaddress=$IP netcfg/get_netmask=$MASK netcfg/get_gateway=$GATE netcfg/get_hostname=$HOST netcfg/get_domain=$DOMAIN auto=true url=$IMAGE console=ttyS0,115200n8” "
echo "virt-install -n $NAME -r $RAME --vcpus=$CPU --os-type=linux --disk path=$DISKPATH,bus=virtio,format=raw,sparse=false,size=$DISKSIZE -w bridge=$BRIDGE,model=virtio --accelerate --virt-type kvm --location=http:$INSTALLER --vnc --extra-args="netcfg/disable_autoconfig=true netcfg/get_nameservers=10.100.10.31 netcfg/get_ipaddress=$IP netcfg/get_netmask=$MASK netcfg/get_gateway=$GW netcfg/get_hostname=$HOSTNAME netcfg/get_domain=$DOMAIN auto=true url=$IMAGE console=ttyS0,115200n8" "
