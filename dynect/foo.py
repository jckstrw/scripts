#!/usr/bin/python

import sys
from dynect.DynectDNS import DynectRest
 
dyn = DynectRest()
 
creds = {
 'customer_name': 'lijit',
 'user_name': 'jmatthews',
 'password': 'Gr8ful00',
}
 
def request_dyn(dyn, uri, method, args):
	response = dyn.execute(uri, method, args)
	print response
	if response['status'] != 'success':
 		sys.exit("Error executing " + uri + " " + method + " " + json.dumps(args) + " " + json.dumps(response))
