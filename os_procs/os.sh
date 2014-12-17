#!/bin/bash
#
# script to check a list of base processes
#
# jmm 2014-12-16

DATE=`date +%Y%m%d%s`
PROCESS_LIST=("/sbin/init" "kthreadd" "ksoftirqd" "sendmail")
FILE=/home/jmatthews/git/scripts/os_procs/output-$DATE.txt

for i in "${PROCESS_LIST[@]}"
do
	if [[ `ps -ef | grep -v grep| grep $i` ]]; then
		echo "$i process found" >> $FILE
	else
		echo "$i process not found" >> $FILE
	fi
done
