#!/usr/bin/python
#
from bs4 import BeautifulSoup
f = open("/home/jmatthews/git/scripts/google_doc/ldap0.15c.xml")
soup = BeautifulSoup(f)
print(soup.prettify())
