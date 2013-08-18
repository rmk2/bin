#!/bin/bash

set -e

SCRIPT=$(basename $0)

TEST=""

VG="storage"
LV="backup"

ROOT="/"
HOME="/home/"
TARGET="/mnt/$LV/"

function ext_open() {
    sudo cryptsetup luksOpen $EXTDISK cr_$VG
    sudo vgscan
    sudo vgchange -ay $VG
    sudo mkdir -p $TARGET
    sudo mount /dev/$VG/$LV $TARGET
}

function ext_close() {
    sudo umount $TARGET
    sleep 1
    sudo rm -ri $TARGET
    sudo vgchange -an $VG
    sudo cryptsetup luksClose cr_$VG
}

function home() {
    sudo rsync -aAHXv $TEST \
	--exclude='*/.adobe**' \
	--exclude='*/.cache**' \
	--exclude='*/.macromedia**' \
	--exclude='*/.libvirt**' \
	--exclude='*/.steam/steam/appcache/httpcache**' \
	--exclude='*/.thumbnails**' \
	$HOME $TARGET$HOME
}

function system() {
    sudo rsync -aAHXv --delete $TEST \
	--exclude='/home**' \
	--exclude='/dev**' \
	--exclude='/media**' \
	--exclude='/mnt**' \
	--exclude='/proc**' \
	--exclude='/sys**' \
	--exclude='/tmp**' \
	--exclude='/var/tmp**' \
	--exclude='/run/media**' \
	--exclude='/windows**' \
	$ROOT $TARGET
}

function create() {
    for DIR in "dev" "media" "mnt" "proc" "run/media" "sys" "tmp" "windows"; do
	if [ ! -e $TARGET/$DIR ]; then
	    sudo mkdir -p $TARGET$DIR
	    echo "mkdir -p $TARGET$DIR"
	else
	    echo "skipped $TARGET$DIR"
	fi
    done
}

for i in "$@"; do
    case "$1" in
	-t | --test)
	    TEST="--list-only"
	    ;;
	-m | --mount)
	    ext_open
	    exit 0
	    ;;
	-u | --umount)
	    ext_close
	    exit 0
	    ;;
	-h | --help | -? | ? | help)
	    echo "Usage: $SCRIPT [OPTIONS] <location of external disk>"
	    echo
	    echo Note:
	    echo 'The location of the external disk has to be /dev/sdX and the disk must exist.'
	    echo
	    echo Available options:
	    # echo -e '-b, --backup \t this option is mandatory, otherwise the script will abort'
	    echo -e '-t, --test \t do not touch any actual files but print instead what this script would have done'
	    exit 0
	    ;;
	/dev/sd*)
	    if [[ -e "$1" ]]; then
	    	EXTDISK="$1"
	    else
	    	echo "No disk found at $1"
	    	exit 1
	    fi
	    ;;
	*)
	    echo "Usage: $SCRIPT [OPTIONS] <location of external disk>"
	    echo "Try '$SCRIPT --help' for more information."
	    exit 0
    esac
    shift
done

if [[ -n "$EXTDISK" ]]; then
    # append "-n 1" without quotes below to avoid having to press enter
    read -p "If in doubt, use '$SCRIPT --test <disk>'! Continue to run this script? (Y/n): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
	# actually run
	sleep 1
	echo
	echo "-------------"
	echo "> mounting"
	echo "-------------"
	ext_open
	echo "-------------"
	echo "> creating excluded dirs"
	echo "-------------"
	create
	echo "-------------"
	echo "> backup: $ROOT"
	echo "-------------"
	system
	echo "-------------"
	echo "> backup: $HOME"
	echo "-------------"
	home
	echo "-------------"
	echo "> unmounting"
	echo "-------------"
	ext_close
	echo "-------------"
	echo "Mission accomplished!"
	echo
    else
	echo
	echo "Aborted by user!"
	exit 0
    fi
else
    echo "Usage: $SCRIPT [OPTIONS] <location of external disk>"
    echo "Try '$SCRIPT --help' for more information."
    exit 0
fi
