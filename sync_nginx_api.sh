#!/bin/bash
#
# script to sync access/error logfiles from nginx server to syslog server
#
# jmm 2015-09-27

DATE=`date +%Y%m%d`
RSYNC=/usr/bin/rsync
DEST_DIR=/var/log/nginx
SOURCE_DIR=/var/log/api
DEST_HOST=("api1.dfw2.lijit.com" "api2.dfw2.lijit.com" "api3.dfw2.lijit.com" "api4.dfw2.lijit.com" "api5.dfw2.lijit.com" "api6.dfw2.lijit.com" "api7.dfw2.lijit.com")

for i in "${DEST_HOST[@]}"
do
	$RSYNC -avp -e ssh $i:$DEST_DIR/*.1 $SOURCE_DIR/$i
	cat access.log.1 | grep -v 10.106.113.12 | grep -v 10.106.113.186|  grep -v healthcheck > $SOURCE_DIR/access.log
	cat error.log.1 | grep -v 10.106.113.12 | grep -v 10.106.113.186|  grep -v healthcheck > $SOURCE_DIR/error.log
done
