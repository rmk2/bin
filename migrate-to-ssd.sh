#!/bin/bash

SSD=/media/ssd
HDD=/media/hdd
TEST="--list-only"

if [ -e "$HDD" ]; then
    echo "$HDD found, continuing!"
else
    echo "Error: $HDD does not exist!"
    exit 0
fi

if [ -e "$SSD" ]; then
    echo "Warning: $SSD already exists!"
else
    echo "Creating $SSD and subfolders!"
    sudo mkdir -p $SSD/{home,data,dev,media,mnt,proc,sys,tmp,windows}
fi

case "$1" in
    data | --data)
	SOURCE=$HDD/data/
	TARGET=$SSD/data/
	rsync -amAXzv --safe-links $TEST \
	    "$SOURCE" "$TARGET"
	;;
    home | --home)
	SOURCE=$HDD/home/ryko
	TARGET=$SSD/home/
	rsync -amAXzv --safe-links $TEST \
	    --exclude='**arm*' \
	    --exclude='.adobe**' \
	    --exclude='.cache**' \
	    --exclude='.libvirt**' \
	    --exclude='.macromedia**' \
	    --exclude='rpmbuild**' \
	    --exclude='**.iso' \
	    "$SOURCE" "$TARGET"
	;;
    root | --root)
	SOURCE=$HDD/
	TARGET=$SSD/
	rsync -amHAXzv $TEST \
	    --exclude='/dev**' \
	    --exclude='/media**' \
	    --exclude='/mnt**' \
	    --exclude='/proc**' \
	    --exclude='/sys**' \
	    --exclude='/tmp**' \
	    --exclude='/var/tmp**' \
	    --exclude='/home/ryko**' \
	    --exclude='/data**' \
	    --exclude='/windows**' \
	    "$SOURCE" "$TARGET"
	;;
    *)
	exit 0
esac
