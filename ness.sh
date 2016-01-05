#!/bin/bash

#Variables
SPLUNK_NESSUS=/mnt/nessus

#Retrive AUTH Token
token="$(/usr/bin/wget -q --no-check-certificate --post-data 'login=admin&password=O13ucuDx9K' https://nessus1.15c.lijit.com:8834/login -O - | grep -Po '(?<=token\>)[^\<]+(?=\<\/token)')"

#Get list of reports
/usr/bin/wget -q --no-check-certificate --post-data "token=$token" https://nessus1.15c.lijit.com:8834/report/list -O - | grep -Po '(?<=name\>)[^\<]+(?=\<\/name)' > /tmp/reports
