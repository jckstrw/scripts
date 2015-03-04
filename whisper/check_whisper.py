#!/usr/bin/python
#
# check the age of whisper files
#
# jmm 2015-03-04

import os

whisper_dir = "/opt/graphite/storage/whisper"

#print os.listdir(whisper_dir)
for dirName, subdirList, fileList in os.walk(whisper_dir, topdown=False):
    #print('Found directory: %s' % dirName)
    for fname in fileList:
        print('\t%s' % fname)
