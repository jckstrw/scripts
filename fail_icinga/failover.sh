#!/bin/bash
TMP_FILE=/tmp/fail.txt

function check_one() {
result_one=`/usr/lib64/nagios/plugins/check_nrpe -H mon1.15c.lijit.com -c check_mon | awk {'print $2'}`

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

function check_two(){
result_two=`/usr/lib64/nagios/plugins/check_nrpe -H repo1.15c.lijit.com -c check_mon| awk {'print $2'}`

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

If this had been an actual emergency,
mon1.dfw2 would have taken over monitoring

http://mon1.dfw2.lijit.com/icinga

EOF

cat $TMP_FILE | mail -s "Emergency Failover - DEFCON 1" jmatthews@sovrn.com

rm $TMP_FILE
}

function email_defcon3() {
cat > $TMP_FILE << EOF
Icinga slave has gone to DEFCON 3

If this had been an actual emergency,
mon1.dfw2 would have taken over monitoring

http://mon1.dfw2.lijit.com/icinga

EOF

cat $TMP_FILE | mail -s "Emergency Failover - DEFCON 3" jmatthews@sovrn.com

rm $TMP_FILE
}

function email_defcon5() {
cat > $TMP_FILE << EOF
Icinga slave is at DEFCON 5

There is something wrong somewhere.  Both 
IAD3 and SNA1 can ping the master Icinga server.

Perhaps a tunnel is down?  

As this is not an actual emergency,
mon1.dfw2 will do nothing.

http://mon1.dfw2.lijit.com/icinga

EOF

cat $TMP_FILE | mail -s "Emergency Failover - DEFCON 5" jmatthews@sovrn.com

rm $TMP_FILE
}


check_one
check_two

totes=$(( $result_num_east + $result_num_west ))

case "$totes" in
0)
        echo "Both hosts can ping mon1.15c"
	email_defcon5
        ;;
[1245])
        echo "One host cannot ping mon1.15c"
	email_defcon3
        ;;
6)
        echo "Neither host can ping mon1.15c"
	email_defcon1
        ;;
esac
