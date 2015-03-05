#!/bin/bash
#
# script to check age of whisper files
# 
# 2015-03-04

WHISPER_DIR="/opt/graphite/storage/whisper/DFW2"

COUNT=`find $WHISPER_DIR -type f -mmin +720 | wc -l`

if [ $COUNT -gt 0 ];
then
	echo "There are $COUNT files that have not been updated in at least 6 hours"
	exit 2
else
	echo "Whisper files are up-to-date"
	exit 0
fi
