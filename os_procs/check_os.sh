#!/bin/bash
#
# for nrpe to check os processes 
#
# jim 2014-12-16

STATUS=/home/jmatthews/git/scripts/os_procs/status.dat

if [[ `cat $STATUS` = "1" ]]; then
	echo "Houston, we have a problem"
	exit 1
else
	echo "We're ok. How are you?"
	exit 0
fi
