#!/bin/bash
#
# script to notify users

DOUGT="g_dtabb"
BILL="g_bill"
DOUGF="g_dfarmer"
SCOTT="g_scott"
NATE="g_nate"
JIM="g_jmatthews"
TMP_FILE=/tmp/email

function email() {
cat > $TMP_FILE << EOF
There has been a disruption to our services. Please join the Control Room in Hip
Chat for the latest.
EOF

cat $TMP_FILE | mail -s "Sovrn Service Disruption $rnd" 5fdf8209-2652-408c-b97f-14eac2654a61+$1@alert.victorops.com

rm $TMP_FILE
}

for parameters in $*
do	
	case $parameters in
	"jim")		
		rnd=`rand`
		email $JIM
		;;

	"dtabb")	
		rnd=`rand`
		email $DOUGT
		;;

	"sbutler")
		rnd=`rand`
		email $SCOTT
		;;

	"all")
		rnd=`rand`	
		email $JIM
		sleep 1
		rnd=`rand`
		email $SCOTT
		sleep 1
                rnd=`rand`
		email $DOUGT
		;;
	esac
done
