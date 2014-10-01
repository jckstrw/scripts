#!/usr/bin/python

import sys
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
response = rest_iface.execute('/Zone/', 'GET')
zone_resources = response['data']

response_a = rest_iface.send_command('https://api.dynect.net/REST/RTTM/lijit.com/', 'GET', arguments)

print response
# Log out, to be polite
rest_iface.execute('/Session/', 'DELETE')
