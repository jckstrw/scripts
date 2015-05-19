#!/usr/bin/env bash
sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '/Volumes/STICK/hoff1.jpg'";
killall Dock;
