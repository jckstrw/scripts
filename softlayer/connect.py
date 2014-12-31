#!/usr/bin/env python

import SoftLayer
import pprint

username = 'jmatthews'
key = '956d7fa0ef3a49e24d401e5b05f2aa968ed577f65db38530f1a7c24f4ab2c650'

try:
	client	= SoftLayer.Client(username=username, api_key=key)

#generate order template
	orderTemplate = client['Virtual_Guest'].generateOrderTemplate({
    	'hostname': 'myAPIexamplehostname',
    	'domain': 'er.org',
    	'startCpus': 1,
    	'maxMemory': 1024,
    	'hourlyBillingFlag': 'true',
    	'operatingSystemReferenceCode': 'UBUNTU_LATEST',
    	'localDiskFlag': 'false'
	})

	verifiedOrder = client['Product_Order'].verifyOrder(orderTemplate)

#verifyOrder method returns order template with pricing and other information added 
	pprint.pprint(verifiedOrder)

#if order verified, place order
	receipt = client['Product_Order'].placeOrder(orderTemplate)
	pprint.pprint(receipt)

except Exception as e:
	pprint.pprint('Unable to order virtual guest: ')
      	import traceback
      	traceback.print_exc()
