#!/bin/bash
#
# script to check zookeeper values
#

if [[ -z "$@" ]]; then
    echo "Usage: $0 hostname"
    exit 1
fi

HOST=$1
LATENCY=`echo srvr | nc $HOST 5181 | grep Latency | cut -d/ -f4`
NODE_COUNT=`echo srvr | nc $HOST 5181 | grep Node | awk {'print $3'}`

if [ $LATENCY -gt 10 ]; 
then
	echo "Critical"
	exit 2
elif [ $LATENCY -gt 5 ] && [ $LATENCY -lt 10 ];
then
	echo "Warning"
	exit 1
else
	echo "The animals are happy"
fi

if [ $NODE_COUNT -lt 800 ];
then
	echo "Node count is critical"
	exit 2
elif [ $NODE_COUNT -lt 800 ] && [ $LATENCY -gt 300 ];
then
	echo "Node count is warning"
	exit 1
else	
	echo "The animals are happy"
fi
