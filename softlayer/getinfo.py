#!/usr/bin/env python

user_name = "jmatthews"
api_key = "956d7fa0ef3a49e24d401e5b05f2aa968ed577f65db38530f1a7c24f4ab2c650" 

import SoftLayer
from pprint import pprint as pp

client = SoftLayer.Client(username=user_name, api_key=api_key)

container = client['Account'].getObject()
pp(container)
