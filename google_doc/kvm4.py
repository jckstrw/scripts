#!/usr/bin/python
import re
#f = open("/home/jmatthews/git/scripts/google_doc/ldap0.15c.xml")

#for line in f.readlines():
#	name = re.split("(?<=\<name\>).*?(?=\<\/name\>)", line)
	#print name

with open("/home/jmatthews/git/scripts/google_doc/ldap0.15c.xml") as f:
	for line in f:
		if "<name>" in line:
			foo = re.split("(?<=\<name\>).*?(?=\<\/name\>)", line)
			print foo
