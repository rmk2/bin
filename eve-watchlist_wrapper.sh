#!/bin/bash

WEBROOT="/var/www/servers/eve.rmk2.org/pages/"
DELAYED=false

function exec_latest() {
    for i in 1000 750; do
	
	echo "-------------"
	echo "> Generating latest watchlist with $i entries"
	echo "-------------"
	/home/ryko/bin/eve-watchlist.rkt --hostile --length $i > $WEBROOT/all_latest-$i.js
	/home/ryko/bin/eve-watchlist.rkt --custom "PL|NC|DRF|TC" --length $i > $WEBROOT/major_latest-$i.js
	/home/ryko/bin/eve-watchlist.rkt --custom "^(?!PL|NC|IMP|DRF).+" --length $i > $WEBROOT/minor_latest-$i.js
	echo "Success!"
	
    done
}

function exec_delayed() {
    for i in 1000 750; do
	
	echo "-------------"
	echo "> Generating delayed watchlist with $i entries"
	echo "-------------"
	/home/ryko/bin/eve-watchlist.rkt --hostile --length $i > $WEBROOT/all_delayed-$i.js
	/home/ryko/bin/eve-watchlist.rkt --custom "PL|NC|DRF|TC" --length $i > $WEBROOT/major_delayed-$i.js
	/home/ryko/bin/eve-watchlist.rkt --custom "^(?!PL|NC|IMP|DRF).+" --length $i > $WEBROOT/minor_delayed-$i.js
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
	    echo "usage: ${0##*/} [+-o ARG] [+-d} [--] ARGS..."
	    exit 2
    esac
done
shift $(( OPTIND - 1 ))
OPTIND=1

# Exec

echo
if [[ $DELAYED == "true" ]]; then
    exec_delayed
else
    exec_latest
fi
echo "-------------"
echo "Mission accomplished!"
echo
exit 0
