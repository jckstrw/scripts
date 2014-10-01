#!/usr/bin/python

import sys
import json
import httplib2

http = httplib2.Http()
http.force_exception_to_status_code = True

# First do the login and save the session token
token = ""
loginParams = {}
loginParams["customer_name"] = customername
loginParams["user_name"] = username
loginParams["password"] = password

response, content = http.request('https://api2.dynect.net/REST/Session/', 'POST', json.JSONEncoder().encode(loginParams), headers={'Content-type': 'application/json'})
result = json.loads(content)

if result["status"] == "success":
	token = result["data"]["token"]
    	return True
else:
	return False

# Now that we have the session and token, add the A record for our zone and fqdn
recordParams = {}
recordParams["rdata"] = {}
recordParams["rdata"]["address"] = '192.168.1.2'
recordParams["ttl"] = 30

response, content = http.request('https://api2.dynect.net/REST/ARecord/myzone.com/myfqdn.myzone.com/', 'POST', json.JSONEncoder().encode(recordParams), headers={'Content-type': 'application/json', 'Auth-Token':  token})

result = json.loads(content)

# Finally, if adding the A record was a success, let's publish the zone
if result["status"] == "success":
	publishParams = {}
	publishParams["publish"] = 1

	response, content = http.request('https://api2.dynect.net/REST/Zone/myzone.com/', 'PUT', json.JSONEncoder().encode(publishParams), headers={'Content-type': 'application/json', 'Auth-Token':  token})
	result = json.loads(content)
	if result["status"] == "success":
		return True
	else:
		return False
else:

	return False
