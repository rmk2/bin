#!/bin/bash 
if [ -z "$1" ]; then
	echo Usage: scr dir delay
	exit
fi
while : ; do
	ls -laFtr $1 | tail -1
	sleep $2
done
