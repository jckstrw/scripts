#!/bin/bash
#
# script to change user on call
#
DATE=`date +%Y%m%d`
LOG=/tmp/changeoncall_$DATE.txt
NAGIOS_CONTACT=/etc/nagios3/conf.d/contacts.cfg
NAGIOS_BIN=/usr/sbin/nagios3
NAGIOS_CFG=/etc/nagios3/nagios.cfg

# Jim
JIM=/etc/nagios3/conf.d/jim
JIMSMS=3036181199@mms.att.net
# Ed
ED=/etc/nagios3/conf.d/ed
EDSMS=3037092424@vtext.com
# Doug
DOUG=/etc/nagios3/conf.d/doug
DOUGSMS=7207710651@txt.att.net
# Zach
ZACH=/etc/nagios3/conf.d/zach
ZACHSMS=7203239237@vtext.com
# Mike
MIKE=/etc/nagios3/conf.d/mike
MIKESMS=3035130763@txt.att.net

if [[ `whoami` != 'root' ]]; then
	echo "You must be root to run this"
	exit 1
fi

if [[ -z "$@" ]]; then
	echo "Usage: $0 <username>"
	echo "Current usernames available are: Doug|Ed|Jim|Mike|Zach"
    	exit 1
fi

# Test Nagios config before we even start monkeying about
if [[ `$NAGIOS_BIN -v $NAGIOS_CFG | grep Errors | awk '{print $3}'` != 0 ]]; then
        echo "There's a problem with the Nagios config"
        exit 1
fi

case "$1" in
	Jim)	echo "Making $1 on call"
		# make a backup copy of $NAGIOS_CONTACT just in case
		cp $NAGIOS_CONTACT $NAGIOS_CONTACT.bak
		cp $JIM $NAGIOS_CONTACT
		if [[ `$NAGIOS_BIN -v $NAGIOS_CFG | grep Errors | awk '{print $3}'` !=0 ]]; then
			echo "There's a problem with the Nagios contacts config"
                        echo "Restoring Nagios contacts file..."
			cp $NAGIOS_CONTACT.bak $NAGIOS_CONTACT
                        if [[ `$NAGIOS_BIN -v $NAGIOS_CFG | grep Errors | awk '{print $3}'` !=0 ]]; then
                            echo "Something really goofed. Exiting."
                            exit 1
                        fi
		        exit 1
		fi
                  
                service nagios3 reload
                rm $NAGIOS_CONTACT.bak

		echo "$1 is on call" | mail -s "Currently on call" jmatthews@lijit.com 
		echo " "| mail -s "You are on call" $JIMSMS
	;;

	*)
	;;
esac
