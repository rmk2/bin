#!/bin/bash

case "$*" in
    -c | --check | check)
	sudo sha512sum -c ~/$(hostname -s)_boot.sha512 | grep -v OK
	;;
    -w | --write | write)
	sudo find /boot -type f -exec sha512sum > ~/$(hostname -s)_boot.sha512 '{}' \;
	;;
    -h | --help | -? | ? | help)
	echo "Usage: $(basename $0) <option>"
	echo
	echo Available options:
	echo -e "-c, --check \t check the hashes for all files in /boot as read from ~/$(hostname -s)_boot.sha512"
	echo -e "-w, --write \t calculate the hashes for all files in /boot and write them to ~/$(hostname -s)_boot.sha512"
	;;
    *)
	echo "Usage: $(basename $0) <option>"
	echo "Try '$(basename $0) --help' for more information."
esac




