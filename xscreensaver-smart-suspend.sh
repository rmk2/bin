#!/bin/bash

set -e

PROC_BASENAME="xscreensaver"
PROC_PID=$(pidof $PROC_BASENAME)
PROC_STATE=$(ps --format s --no-headers --pid $PROC_PID)

while getopts :se OPT; do
    case $OPT in
	s|+s)
	    case $PROC_STATE in
		"T")
		    echo "> xscreensaver[$PROC_PID] is currently suspended"
		    ;;
		"S")
		    echo "> xscreensaver[$PROC_PID] is currently active"
		    ;;
		*)
		    exit 1
	    esac
	;;
	e|+e)
	    case $PROC_STATE in
		"T")
		    kill -CONT $PROC_PID && echo "> xscreensaver[$PROC_PID] continued"
		    ;;
		"S")
		    kill -STOP $PROC_PID && echo "> xscreensaver[$PROC_PID] suspended"
		    ;;
		*)
		    exit 1
	    esac
	    ;;
	*)
	    echo "usage: ${0##*/} [+-se} [--] ARGS..."
	    exit 2
    esac
done
shift $(( OPTIND - 1 ))
OPTIND=1
