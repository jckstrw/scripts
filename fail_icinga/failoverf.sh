#!/bin/bash
TMP_FILE=/tmp/fail.txt

function check_one() {
result_one=`/usr/lib64/nagios/plugins/check_nrpe -H mon1.15c.lijit.com -c check_mon | awk {'print $2'}`
echo $result_one
case "$result_one" in
CRITICAL)
        echo "Critical"
	result_num_east=2
        ;;
WARNING)
        echo "Warning"
	result_num_east=1
        ;;
OK)
        echo "OK"
	result_num_east=0
        ;;
*)
	echo "wtf"
	result_num_east=0
	;;
esac
echo "wtf + " $result_num_east
}

function check_two() {
result_two=`/usr/lib64/nagios/plugins/check_nrpe -H dynamic12.tor.fmpub.net -c check_mon | awk {'print $2'}`
echo $result_two
case "$result_two" in
CRITICAL)
        echo "Critical"
        result_num_west=2
        ;;
WARNING)
        echo "Warning"
        result_num_west=1
        ;;
OK)
        echo "OK bro"
        result_num_west=0
        ;;
*)
        echo "wtf"
        result_num_west=1
        ;;
esac
echo "wtf + " $result_num_west
}


function email() {
cat > $TMP_FILE << EOF
If this had been an actual emergency,
mon1.dfw2 would have taken over monitoring

http://mon1.dfw2.lijit.com/icinga

EOF

cat $TMP_FILE | mail -s "Emergency Failover" jmatthews@sovrn.com

rm $TMP_FILE
}

check_one
check_two

totes=$result_num_east
echo "$totes"

case "$totes" in
0)
        echo "Both hosts can ping mon1.15c"
        ;;
1)
        echo "One host cannot ping mon1.15c"
        ;;
4)
        echo "Neither host can ping mon1.15c"
        ;;
esac
