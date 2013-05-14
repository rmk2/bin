#!/bin/bash

NAME=$(basename $0)
RECIPIENT="ryko@rmk2.org"
HOST=$(hostname -f)

if [ -z "$1" ]; then
    echo "Usage: $NAME [OPTION]"
    echo "Try '$NAME --help' for more information."
fi

for i in $@; do
    case "$i" in
	--checksums | -c | checksums)
	    echo "Attachment: SHA512 checksums for all files under /boot for $HOST" | sudo mailx -s "[$HOST] Checksums" -a /home/ryko/$(hostname -s)_boot.sha512 $RECIPIENT
	    ;;
	--iptables | -i | iptables)
	    echo "Attachment: iptables rules for $HOST" | sudo mailx -s "[$HOST] IPtables" -a /etc/iptables.save $RECIPIENT
	    ;;
	--openvpn | -o | openvpn)
	    echo "Attachment: openvpn server configuration for $HOST" | sudo mailx -s "[$HOST] OpenVPN" -a /etc/openvpn/server.conf $RECIPIENT
	    ;;
	--help | -?)
	    echo Usage: $NAME [OPTION]
	    echo
	    echo Available options:
	    echo -e "-c, --checksums \t send sha512 checksums for all files under /boot to $RECIPIENT"
	    echo -e "-i, --iptables \t\t send saved iptables rules to $RECIPIENT"
	    echo -e "-o, --openvpn \t\t send saved openvpn server configuration to $RECIPIENT"
	    ;;
	*)
	    echo "Usage: $NAME [OPTION]"
	    echo "Try '$NAME --help' for more information."
	    ;;
    esac
done
