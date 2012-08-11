#!/bin/bash

SOURCE=`echo "$1" | sed 's|/$||'`
TARGET=`echo "$2"`
PRESET="/home/ryko/.backup/"

case "$1" in
    /* | ~/*)
	case "$2" in
	    /* | ~/*)
		rsync -achmv --delete-after --exclude='**arm*' --safe-links "$SOURCE" "$TARGET"
		;;
	    "")
		rsync -achmv --delete-after --exclude='**arm*' --safe-links "$SOURCE" "$PRESET"
		;;
	    *)
		echo Error: Second parameter is not a valid path
	esac
	;;
    "")
	echo Error: This command needs at least one, ideally two paths as parameters, a SOURCE path followed by an optional TARGET path
	;;
    *)
	echo Error: First parameter is not a valid path
esac
