#!/bin/bash
#
# jmm 2014-02-14

result=`/usr/bin/nodetool status | grep \`hostname -i\` | cut -c1`

if [[ $result == U ]]; then
	echo "Node is up"
	exit 0
else
	echo "Node is down"
	exit 1
fi
