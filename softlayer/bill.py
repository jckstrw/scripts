#!/usr/bin/env python
 
import os
import sys
 
import SoftLayer
from pprint import pprint as pp
 
api_username = 'jmatthews'
api_key = '956d7fa0ef3a49e24d401e5b05f2aa968ed577f65db38530f1a7c24f4ab2c650'
invoice_id = 3709790
 
client = SoftLayer.Client(
    username=api_username,
    api_key=api_key,
)
 
object_mask = "mask.associatedChildren"
 
container = client['SoftLayer_Billing_Invoice'].getInvoiceTopLevelItems(mask=object_mask, id=invoice_id)
 
pp(container)
