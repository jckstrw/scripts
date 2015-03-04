#!/usr/bin/python
import re
from bs4 import BeautifulSoup
f = open("/home/jmatthews/git/scripts/google_doc/ldap0.15c.xml")
soup = BeautifulSoup(f)

name = re.compile('(?<=\<name\>).*?(?=\<\/name\>)')
print name
#for table in soup.split("</name>"):
#	print table
