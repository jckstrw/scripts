#!/bin/bash

NOW_S=`date +%s000`
TWELVE_HOURS=43200

for i in `/usr/bin/hadoop job -list | grep -v running | grep -v Start | awk {'print $3'}`
do

	HOW_LONG=$(((NOW_S - i) / 1000))

	if [[ $HOW_LONG -gt $TWELVE_HOURS ]]; then
		echo "Job has been running longer than 12 hours"
		exit 2
	fi
	
	exit 0
done
