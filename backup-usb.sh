#!/bin/bash

SOURCE=`echo "$1"`
TARGET=`echo "$2"`

case "$1" in
    /* | ~/*)
	case "$2" in
	    /* | ~/*)
		rsync -ahmv --delete-after --safe-links --exclude='**arm*' --exclude='.wine**' \
		--exclude='.backup**' --exclude='.cache**' --include='Downloads/*' --exclude='Downloads/*.mp4' --include='Downloads/fonts**' \
		--exclude='Downloads/**' --exclude='.thumbnails**' --exclude='Pictures/iwdrm**' --exclude='.libvirt**' \
		--exclude='.local/share/wineprefixes**' --include='rpmbuild/SPECS**' --exclude='rpmbuild/*'  "$SOURCE" "$TARGET"
		;;
	    "")
		echo Error: Second parameter is empty
		;;
	    *)
		echo Error: Second parameter is not a valid path
	esac
	;;
    "")
	echo Error: This command needs two paths as parameters, a SOURCE path followed by a TARGET path
	;;
    *)
	echo Error: First parameter is not a valid path
esac
