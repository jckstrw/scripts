#!/bin/bash

echo -n "Name: " 
read NAME
echo -n "RAM: "
read RAM
echo -n "CPU: "
read CPU
echo -n "DISK: "
read DISK
echo -n "BRIG: "
read BRIG
echo -n "LOC: "
read LOC
echo -n "IP: "
read IP
echo -n "MASK: "
read MASK
echo -n "GATE: "
read GATE
echo -n "HOST: "
read HOST
echo -n "DOMAIN: " 
read DOMAIN
echo -n "IMAGE: " 
read IMAGE

echo "virt-install -n $NAME  -r $RAM —vcpus=$CPU --os-type=linux --disk path=$DISK -w bridge=$BRIG --accelerate --virt-type kvm —location=$LOC --vnc --extra-args=\"netcfg/disable_autoconfig=true netcfg/get_nameservers=10.100.10.31 netcfg/get_ipaddress=$IP netcfg/get_netmask=$MASK netcfg/get_gateway=$GATE netcfg/get_hostname=$HOST netcfg/get_domain=$DOMAIN auto=true url=$IMAGE console=ttyS0,115200n8” "
