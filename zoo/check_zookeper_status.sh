#!/bin/bash
#
# script to check zookeeper values
#

if [[ -z "$@" ]]; then
    echo "Usage: $0 hostname"
    exit 1
fi

HOST=$1

STATUS=`echo ruok | nc $HOST 5181`

if [[ $STATUS != imok ]] 
then
	echo "Zookeeper is not happy"
	exit 2
else
	echo "The animals are happy"
fi
