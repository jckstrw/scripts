#!/bin/bash
TMP_FILE=/tmp/fail.txt

function check_east() {
result_one=`/usr/lib64/nagios/plugins/check_nrpe -H core1.iad3.lijit.com -c check_mon | awk {'print $2'}`

case "$result_one" in
CRITICAL)
        echo "Critical"
	result_num_east=3
        ;;
WARNING)
        echo "Warning"
	result_num_east=2
        ;;
OK)
        echo "OK"
	result_num_east=0
        ;;
*)
	echo "Unknown"
	result_num_east=1
	;;
esac
}

function check_west(){
result_two=`/usr/lib64/nagios/plugins/check_nrpe -H core1.sna1.lijit.com -c check_mon| awk {'print $2'}`

case "$result_two" in
CRITICAL)
        echo "Critical"
	result_num_west=3
        ;;
WARNING)
        echo "Warning"
	result_num_west=2
        ;;
OK)
        echo "OK"
	result_num_west=0
        ;;
*)
        echo "Unknown"
        result_num_west=1
        ;;
esac
}

function email_defcon1() {
cat > $TMP_FILE << EOF
Icinga slave has gone to DEFCON 1

This is an actual emergency and
the Icinga slave server has taken over.

Notifications are enabled. 

http://mon1.dfw2.lijit.com/icinga

EOF

cat $TMP_FILE | mail -s "Emergency Failover - DEFCON 1" jmatthews@sovrn.com

rm $TMP_FILE
}

function email_defcon3() {
cat > $TMP_FILE << EOF
Icinga slave has gone to DEFCON 3

We're pretty close to an emergency.  Either
one or both IAD3/SNA1 servers are either failing to ping
the master Icinga server or there is another failure
altogether.  There are a number of reasons we
went to DEFCON 3 and rather then list them here, 
it would be best if someone investigated.

If this had been an actual emergency,
mon1.dfw2 would have taken over monitoring.

http://mon1.dfw2.lijit.com/icinga

EOF

cat $TMP_FILE | mail -s "Emergency Failover - DEFCON 3" jmatthews@sovrn.com

rm $TMP_FILE
}

function email_defcon5() {
cat > $TMP_FILE << EOF
Icinga slave is at DEFCON 5

There is something wrong somewhere if we've reached
this point.  Both IAD3 and SNA1 can ping the master 
Icinga server.  Perhaps a tunnel is down?  

As this is not an actual emergency,
mon1.dfw2 will do nothing.

http://mon1.dfw2.lijit.com/icinga

EOF

cat $TMP_FILE | mail -s "Emergency Failover - DEFCON 5" jmatthews@sovrn.com

rm $TMP_FILE
}

function enable_notifications() {
	printfcmd="/usr/bin/printf"
	CommandFile="/var/ramdrive/icinga/rw/icinga.cmd"
	# get the current date/time in seconds since UNIX epoch
	datetime=`date +%s`

	# pipe the command to the command file
	`$printfcmd "[%i] ENABLE_NOTIFICATIONS;%i\n" $datetime $datetime >> $CommandFile`
}

check_east
check_west

totes=$(( $result_num_east + $result_num_west ))
echo "totes is $totes"
case "$totes" in
0)
        echo "Both hosts can ping mon1.15c"
	email_defcon5
        ;;
6)
        echo "Neither host can ping mon1.15c"
	email_defcon1
	#enable_notifications
        ;;
*)
        echo "One (or more) host(s) cannot ping mon1.15c"
        email_defcon3
        ;;

esac
