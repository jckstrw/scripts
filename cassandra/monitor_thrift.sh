#!/bin/bash
#
# jmm 2014-02-14

echo $1
if [[ `nc -z -w 3 $1 9160; echo $?` -eq 0 ]]; then
	echo "Thrift is listening"
else
	echo "Thrift has let us down"
	exit 1
fi
