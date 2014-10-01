#!/bin/bash

output=`/usr/bin/service syslog-ng status 2>/dev/null`

if [ ! -z "output" ] && [[ "$output" = " * syslog-ng is running" ]]
then
	echo "Running"
	exit 0
else	
	echo "Not running"
	exit 2
fi
