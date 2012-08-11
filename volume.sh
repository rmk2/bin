#!/bin/bash

if [ -z "$2" ]; then
    ARG2=nil
else
    ARG2="$2"%
fi

case "$1" in
    --mute)
	if [ "$ARG2" = nil ]; then
	    VALUE="55%"
	else
	    VALUE="$ARG2"
	fi
	amixer -q sset Speaker mute && amixer -q sset Master $VALUE
	echo Speaker muted and Master set to $VALUE
	;;
    --unmute)
	if [ "$ARG2" = nil ]; then
	    VALUE="90%"
	else
	    VALUE="$ARG2"
	fi
	amixer -q sset Speaker unmute && amixer -q sset Master $VALUE
	echo Speaker unmuted and Master set to $VALUE
	;;
    *)
	echo "Usage: this command needs either --mute or --unmute as a parameter, followed by an optional numerical value for the actual master volume level"
	exit
	;;
esac
