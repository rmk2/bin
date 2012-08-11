#!/bin/bash 

INTERVAL=5

if [ -e ~/memfree.log ]; then
	rm ~/memfree.log
fi

echo
echo "Printing free memory information from /proc/meminfo with a $INTERVAL seconds interval" 
echo
while : ; do
	cat /proc/meminfo | grep MemFree | awk '{print $2}' | tee -a ~/memfree.log
	sleep $INTERVAL 
done
