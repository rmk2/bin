#!/bin/bash

set -e

WEBROOT="/var/www/servers/eve.rmk2.org/pages/.templates/"
DELAYED=false
TYPE="latest"

function exec_watchlist() {
    if [[ $DELAYED == "true" ]]; then
	TYPE="delayed"
    else
	TYPE="latest"
    fi

    for i in 1000 750; do
	echo "-------------"
	echo "> Generating $TYPE watchlist with $i entries"
	echo "-------------"
	/home/ryko/bin/eve-watchlist.rkt --hostile --length $i > $WEBROOT/all_$TYPE-$i.js
	/home/ryko/bin/eve-watchlist.rkt --custom "PL|NC|DRF|TC" --length $i > $WEBROOT/major_$TYPE-$i.js
	/home/ryko/bin/eve-watchlist.rkt --custom "^(?!PL|NC|IMP|DRF).+" --length $i > $WEBROOT/minor_$TYPE-$i.js
	echo "Success!"
    done
    
}

while getopts :p:d OPT; do
    case $OPT in
	p|+p)
	    WEBROOT="$OPTARG"
	    ;;
	d|+d)
	    DELAYED=true
	    ;;
	*)
	    echo "usage: ${0##*/} [+-p ARG] [+-d} [--] ARGS..."
	    exit 2
    esac
done
shift $(( OPTIND - 1 ))
OPTIND=1

# Exec

echo
exec_watchlist
echo "-------------"
echo "Mission accomplished!"
echo
exit 0
