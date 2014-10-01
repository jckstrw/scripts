#!/bin/bash
#
#
DATE=`date +%Y%m%d`
FILE=/opt/kindle/temp.pdf
FILELCK=/opt/kindle/FM_TechOps.pdf
LOG=/tmp/kindle_sync_$DATE.txt
PASSWD=aopbc

if [[ -z "$@" ]]; then
    echo "Usage: $0 /dev/sdx"
    exit 1
fi

if [[ `grep kindle /proc/mounts` ]]; then
        echo "Kindle is already mounted"
        echo "Please unmount the device and rerun the script"
        exit 1
fi

echo Exporting Confluence site...
/opt/kindle/confluence.sh -s https://intranet.lijit.com --user kindle --password Gr8ful00 --action exportSpace --space "itt" --exportType "PDF" --file $FILE

echo Setting password on PDF file...
/usr/bin/pdftk $FILE output $FILELCK user_pw $PASSWD

echo Syncing file to kindle...
mount -t vfat $1 /kindle
cp $FILELCK /kindle/documents/
umount /kindle
rm $FILE $FILELCK
