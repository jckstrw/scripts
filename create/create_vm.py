#!/usr/bin/python
# 
# Wrapper script used to create a VM
#
# jmm - 2015-02-24
import os
#if os.geteuid() != 0:
#    exit("You must be root to run this")
os.system('clear')
print ('This wrapper is used to create a VM.')
print ('Some of the prompts have a default value, in parenthesis.') 
print ('Accept the default value by hitting return or input your own.')
print ('')

name 		= raw_input('Name of VM: ')
ram 		= raw_input('RAM (2048): ')
cpu		= raw_input('CPU (1): ')
diskpath	= raw_input('Disk Path: ')
#DISKPATH=${DISKPATH}
#if [ -f $DISKPATH ];
#then
#	echo "Don't be Matt. This file already exists."
#	exit 1
#fi

disksize	= raw_input('Disk Size in GB (16): ')
#DISKSIZE=${DISKSIZE:-16}
bridge		= raw_input('Bridge (br10): ')
#BRIDGE=${BRIDGE:-br10}
installer	= raw_input('Installer (trusty): ')
#INSTALLER=${INSTALLER:-http://repo2.15c.lijit.com/install/ubuntu/trusty/installer-amd64}
ip		= raw_input('IP: ')
mask		= raw_input('Netmask: ')
gw		= raw_input('Gateway: ')
hostname	= raw_input('FQ Hostname: ')
domain		= raw_input('Domain: ') 
image		= raw_input('Preseed Image: ')

print ("") 
print ('Here is the command to execute:')

print ('virt-install -n ' + name + ' -r ' + ram + ' --vcpus=cpu --os-type=linux --disk path=' + diskpath + ',bus=virtio,format=raw,sparse=false,size=' + disksize + ' -w bridge=' + bridge +',model=virtio --accelerate --virt-type kvm --location=' + installer + ' --vnc --extra-args=\"netcfg/disable_autoconfig=true netcfg/get_nameservers=10.100.10.31 netcfg/get_ipaddress=' + ip + ' netcfg/get_netmask=' + mask + ' netcfg/get_gateway=' + gw + ' netcfg/get_hostname=' + hostname + ' netcfg/get_domain=' + domain + ' auto=true url=' + image + ' console=ttyS0,115200n8\"')
