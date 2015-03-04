#!/usr/bin/python
#
import os

# Get a list of VMs
#os.chdir("/etc/libvirt/qemu/")
os.chdir("/home/jmatthews/git/scripts/google_doc/")

for i in os.listdir(os.getcwd()):
    if i.endswith(".xml"):
	for line in open(i):
		if "<name>" in line:
			name = line.strip().split()
			#print(name[0])
			
