#!/bin/bash

LOGFILE=/tmp/cf.txt

result=`cat $LOGFILE`

if [ $result -eq 100 ];
then
        echo "Perfect score: $result%"
        exit 0
elif [ $result -gt 80 ];
then
        echo "Warning Promises: $result%"
        exit 1
else
        echo "Critical Promises: $result%"
        exit 2
fi

