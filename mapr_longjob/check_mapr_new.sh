#!/bin/bash

NOW_S=`date +%s000`
TWELVE_HOURS=43200
FILE=/tmp/mapr_job_output.txt

/usr/bin/hadoop job -list | grep -v running | grep -v Start | awk {'print $3'} > $FILE

for i in `cat $FILE`
do
	echo "Value of i is $i"

	HOW_LONG=$(((NOW_S - i) / 1000))

	if [[ $HOW_LONG -gt $TWELVE_HOURS ]]; then
		echo "Job has been running longer than 12 hours"
		exit 2
	fi
done
