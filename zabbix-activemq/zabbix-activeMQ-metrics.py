#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import json
import requests

domain = '127.0.0.1'
port = '8161'
brokerName = "localhost"
USER = "admin"
PASS = "admin"

url = "http://{}:{}/api/jolokia/read/org.apache.activemq:brokerName={},type=Broker".format(domain, port, brokerName)

try:
    response = requests.get(url=url, auth=(USER, PASS))
    result = json.loads(response.content)
    print(int(result['value']['{}'.format(sys.argv[1])]))
except Exception as e:
    print(e)
