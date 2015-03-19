#!/bin/bash
#
# script to shame people who forget to checkin changes
#
# 2015-03-16

ICINGA_DIR='/etc/icinga'
DNS_DIR='/var/named/chroot/var/named'

if [ -d $ICINGA_DIR ]; then
	if [ `cd $ICINGA_DIR; git status --porcelain` ]; then
		cd $ICINGA_DIR; git status --porcelain | mail -s "Git" jmatthews@sovrn.com
	fi
fi

if [ -d $DNS_DIR ]; then
	echo "dir exists"
fi
