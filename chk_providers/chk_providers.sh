#!/bin/bash
#
#
DATE=`date +%Y%m%d`
LOG=/tmp/chk_provider_$DATE.txt
PROVIDER_LST=rtb.providers2

for i in `cat $PROVIDER_LST`
do
	if [[ `nslookup $i` = 0 ]]; then
		echo "Problems"
		exit 1
	fi
done
