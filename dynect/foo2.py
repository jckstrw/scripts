#!/usr/bin/python
import sys
import json
from dynect.DynectDNS import DynectRest

rest_iface = DynectRest()

# Log in
arguments = {
	'customer_name': 'lijit',
        'user_name': 'jmatthews',
        'password': 'Gr8ful00',
}
response = rest_iface.execute('/Session/', 'POST', arguments)

if response['status'] != 'success':
	sys.exit("Incorrect credentials")

# Perform action
#response = rest_iface.execute('/Zone/', 'GET')
response = rest_iface.execute('/REST/RTTMRegion/lijit.com/vap.lijit.com/', 'GET')
 
print response

zone_resources = response['data']
print zone_resources

# Log out, to be polite
rest_iface.execute('/Session/', 'DELETE')
