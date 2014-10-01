#!/bin/bash
#
# jmm 01-24-2014
set -o nounset
set -o errexit

if [[ `dmesg | grep "Out of memory"` ]]; then
	echo "OOM Killer is alive"
	exit 2
else
	echo "OOM sleeps"
	exit 0
fi
