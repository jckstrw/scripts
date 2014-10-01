#!/bin/bash

os=`lsb_release -i | cut -f 2`

if [ $os == "Ubuntu" ];
then
	cfagent="/usr/sbin/cf-agent -Kv"
	pct_complete=`sudo $cfagent | grep "Promises observed to be kept" | awk '{print $13}' | cut -d'%' -f1`
elif [ $os == "CentOS" ];
then
	cfagent="/usr/sbin/cfagent -qv"
	pct_complete=`sudo $cfagent | grep "Promises observed to be kept" | awk '{print $12}' | cut -d'%' -f1`
else
	exit
fi

#pct_complete=`sudo $cfagent | grep "Promises observed to be kept" | awk '{print $13}' | cut -d'%' -f1`

if [ $pct_complete -eq 100 ]; 
then
	echo "Perfect score: $pct_complete%"
	exit 0
elif [ $pct_complete -gt 80 ];
then
	echo "Warning Promises: $pct_complete%"
	exit 1
else
	echo "Critical Promises: $pct_complete%"
	exit 2
fi
