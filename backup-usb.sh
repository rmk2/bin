#!/bin/bash

SOURCE="$1"
TARGET="$2"

case "$1" in
    /* | ~/*)
	case "$2" in
	    /* | ~/*)
		rsync -ahmv --delete			                \
		    --exclude='**arm*'					\
		    --exclude='.wine**'					\
		    --exclude='.adobe**'				\
		    --exclude='.backup**'				\
		    --exclude='.cache**'				\
		    --exclude='Documents/universitet/phd/journal**'	\
		    --exclude='Documents/rpg/star-wars/pdf**'		\
		    --exclude='Downloads/*.mp4'				\
		    --exclude='Downloads/*.flv'				\
		    --exclude='Downloads/*.webm'			\
		    --exclude='Downloads/*.zip'				\
		    --exclude='Downloads/*.ogg'				\
		    --include='Downloads/*'				\
		    --include='Downloads/fonts/*.zip'			\
		    --exclude='Downloads/fonts**'			\
		    --exclude='Downloads/**'				\
		    --exclude='.thumbnails**'				\
		    --exclude='Pictures/iwdrm**'			\
		    --exclude='.libvirt**'				\
		    --exclude='.local/share/wineprefixes**'		\
		    --include='rpmbuild/SPECS**'			\
		    --exclude='rpmbuild/*'				\
		    --exclude='.local/share/Steam/**'                   \
		    --exclude='.thunderbird/*.default/ImapMail'         \
		    --exclude='.kde4/share/apps/okular/docdata/**'	\
		    --exclude='Maildir**'				\
		    --exclude='evething**'				\
		    "$SOURCE" "$TARGET"
		;;
	    "")
		echo Error: Second parameter is empty
		;;
	    *)
		echo Error: Second parameter is not a valid path
	esac
	;;
    "")
	echo 'Error: This command needs two paths as parameters, a SOURCE path followed by a TARGET path'
	;;
    *)
	echo 'Error: First parameter is not a valid path'
esac

