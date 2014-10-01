#!/bin/bash
#
# jmm 2014-02-14

echo $1
if [[ `nc -z -w 3 $1 7000; echo $?` -eq 0 ]]; then
	echo "Gossip is listening"
else
	echo "Gossip has let us down"
	exit 1
fi
