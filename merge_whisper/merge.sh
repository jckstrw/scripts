#!/bin/bash
#
for i in $(find  -type f -name '*.wsp');
do
	#echo $i
	grep $i /tmp/all_whisper.txt > /dev/null; /usr/local/bin/whisper-merge.py $i /opt/graphite/storage/whisper/DFW2/$i 
done
