#!/bin/bash

count=`ls /usr/share/lijit-solr-realtime/*.hprof | wc -l`

if [ $count -gt 0 ]; then
	echo "There are $count files that need to be examined and/or deleted"
	exit 2
else
	echo "There are no files"
fi
