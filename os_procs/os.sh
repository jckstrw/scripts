#!/bin/bash
#
# script to check a list of base processes
#
# jmm 2014-12-16

DATE=`date +%Y%m%d%s`
PROCESS_LIST=("/sbin/init" "kthreadd" "ksoftirqd" "sendmail")
#PROCESS_LIST=("/sbin/init" "kthreadd" "ksoftirqd")
FILE=/home/jmatthews/git/scripts/os_procs/os-$DATE.txt
STATUS=/home/jmatthews/git/scripts/os_procs/status.dat

for i in "${PROCESS_LIST[@]}"
do
	if [[ `ps -ef | grep -v grep| grep $i` ]]; then
		echo "$i process found" >> $FILE
		echo 0 > $STATUS
	else
		echo "$i process not found" >> $FILE
		echo 1 > $STATUS
	fi
done
