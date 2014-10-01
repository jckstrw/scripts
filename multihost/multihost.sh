#!/bin/bash

HOSTLIST=$1
COMMAND=$2

if [ "$#" = "0" ]
then
  echo "Usage: $0 hosts_file command_to_run" 
  exit
fi

for i in `cat $HOSTLIST`
do
	/usr/bin/ssh $i $COMMAND
done
