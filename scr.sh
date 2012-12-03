#!/bin/bash 
if [ -z "$1" ]; then
	echo Usage: scr dir delay
	exit
fi

if [ -z "$2" ]; then
    DELAY=10
else
    DELAY="$2"
fi

while : ; do
	ls -laFtr $1 | tail -1
	sleep $DELAY
done
