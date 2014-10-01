#!/bin/bash
#
#
# jmm 2014-01-21
jobtrackers='mapr3.15c.lijit.com mapr4.15c.lijit.com mapr15.15c.lijit.com mapr32.15c.lijit.com'
url="/machines.jsp?type=blacklisted"

for i in $jobtrackers
do
	if [[ `nc -z $i 50030; echo $?` -eq 0 ]]; then
		echo "$i has the jobtracker"
		#echo "URL to test is $i:50030$url"
		if [[ `lynx -dump -nolist $i:50030$url | grep "There are currently no known"` ]]; then
			echo "Nothing blacklisted"
			exit 0
		else
			echo "A node has been blacklisted"
			exit 2
		fi
		exit 0
	fi
done
