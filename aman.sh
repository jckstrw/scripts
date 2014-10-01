#!/bin/bash

#FILE=/etc/amanda/amanda-client.conf
FILE=file.conf
HOSTNAME=`hostname`

sed -i "s/hostname/$HOSTNAME/" $FILE

