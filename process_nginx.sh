#!/bin/bash
#
# script to sync access/error logfiles from nginx server to syslog server
#
# jmm 2015-09-27

API_DEST_DIR=/var/log/api
SOURCE_DIR=/mnt/sec-syslog
API_DEST_HOST=("api1" "api2" "api3" "api4" "api5" "api6" "api7")

WEB_DEST_DIR=/var/log/web
WEB_DEST_HOST=("web1" "web2" "web3" "web4")

for i in "${API_DEST_HOST[@]}"
do
	cat $SOURCE_DIR/$i/nginx/access.log.1 | grep -v 10.106.113.12 | grep -v 10.106.113.186|  grep -v healthcheck > $API_DEST_DIR/$i/access.log; rm $SOURCE_DIR/$i/nginx/access.log.1
	cat $SOURCE_DIR/$i/nginx/error.log.1 | grep -v 10.106.113.12 | grep -v 10.106.113.186|  grep -v healthcheck > $API_DEST_DIR/$i/error.log; rm $SOURCE_DIR/$i/nginx/error.log.1
done

#for i in "${WEB_DEST_HOST[@]}"
#do
#        cat $SOURCE_DIR/$i/nginx/access.log.1 | grep -v 10.106.113.12 | grep -v 10.106.113.186|  grep -v healthcheck > $WEB_DEST_DIR/$i/access.log
#        cat $SOURCE_DIR/$i/nginx/error.log.1 | grep -v 10.106.113.12 | grep -v 10.106.113.186|  grep -v healthcheck > $WEB_DEST_DIR/$i/error.log
#done
