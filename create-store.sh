#!/bin/bash

set -e

SIZE="5" # INT*1M, i.e. 5M as a default size

TARGET=""
CRYPT_NAME=""

function exec_create() {
    if [ ! -e $TARGET ]; then
	dd if=/dev/urandom of=$TARGET bs=1M count=$SIZE
    else
	echo "File exists. If you are sure this is correct, run '$0 --format filename'"
    fi
}

function exec_open() {
    sudo cryptsetup luksOpen $TARGET $CRYPT_NAME
}

function exec_close() {
    sudo cryptsetup luksClose $CRYPT_NAME
}

function exec_mount() {
    sudo mkdir -p /mnt/$CRYPT_NAME
    sudo mount /dev/mapper/$CRYPT_NAME /mnt/$CRYPT_NAME
}

function exec_umount() {
    sudo umount /mnt/$CRYPT_NAME
    sudo rm -ri /mnt/$CRYPT_NAME
}

function exec_format() {
    if [ -e $TARGET ]; then
	cryptsetup -y luksFormat $TARGET
	exec_open
	sudo mkfs.ext4 /dev/mapper/$CRYPT_NAME
	exec_close
    else
	echo "File does not exist. Run '$0 --create filename' to create it first."
    fi
}

function exec_help() {
    echo "Usage: $0 command filename"
    echo
    echo Available options:
    echo -e '-o, --open \t open and mount the crypt volume'
    echo -e '-c, --close \t unmount and close the crypt volume'
    echo -e '-C, --create \t create a new empty file'
    echo -e '-f, --format \t format a previously created file as crypt volume'
    echo
    exit 0
}

if [ $# -eq 2 ]; then
    TARGET="$2"
    CRYPT_NAME=$(basename "$2")
else
    exec_help
fi

case "$1" in
    -o | --open)
	RUN_OPEN="true"
	echo
	echo "-------------"
	echo "> open crypt volume"
	echo "-------------"
	exec_open
	exec_mount
	echo "-------------"
	echo "Crypt volume opened at /mnt/$CRYPT_NAME"
	echo "-------------"
	echo "Mission accomplished!"
	echo
	exit 0
	;;
    -c | --close)
	RUN_CLOSE="true"
	echo
	echo "-------------"
	echo "> closing crypt volume"
	echo "-------------"
	exec_umount
	exec_close
	echo "-------------"
	echo "Mission accomplished!"
	echo
	exit 0
	;;
    -f | --format)
	RUN_FORMTA="true"
	echo
	echo "-------------"
	echo "> creating crypt volume"
	echo "-------------"
	exec_format
	echo "-------------"
	echo "Mission accomplished!"
	echo
	exit 0
	;;
    -C | --create)
	RUN_CREATE="true"
	echo
	echo "-------------"
	echo "> creating crypt volume"
	echo "-------------"
	exec_create
	echo "-------------"
	echo "Mission accomplished!"
	echo
	exit 0
	;;
    * | --help | -h | help | -? | ?)
	exec_help
	;;
esac
