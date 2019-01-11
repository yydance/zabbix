#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import requests
import json

USER = 'admin'
PASS = 'admin'
domain = "127.0.0.1"
port = "8161"

def jsonparser():
   data = []
   result = json.loads(r.content)
   for item in result['value'].keys():
       qnames = item.split(",")[1].split("=")[1]
       data.append({'{#QNAME}':qnames})
   return json.dumps({"data":data})

urll = "http://{}:{}/api/jolokia/read/org.apache.activemq:brokerName=localhost,destinationName=*,destinationType=Queue,type=Broker".format(domain, port)

try:
   r = requests.get(url=urll, auth=(USER, PASS))
   print(jsonparser())
except ValueError as a:
   print a
