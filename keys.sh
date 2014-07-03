#!/bin/bash

set -e

CRYPT_FILE="/home/ryko/keys"
CRYPT_NAME=$(basename $CRYPT_FILE)

SOURCE="/home/ryko/"
TARGET="/media/$CRYPT_NAME"

function exec_open() {
    sudo cryptsetup --type tcrypt open $CRYPT_FILE $CRYPT_NAME
}

function exec_close() {
    sudo cryptsetup --type tcrypt close $CRYPT_NAME
}

function exec_mount() {
    sudo mkdir -p $TARGET
    sudo mount /dev/mapper/$CRYPT_NAME $TARGET
}

function exec_umount() {
    sudo umount $TARGET
    sleep 1
    sudo rm -ri $TARGET
}

function exec_sync() {
    rsync -achmv --delete-after --safe-links \
	--exclude='.*~' \
	--exclude='#.*' \
	--exclude='.emacs.d/session*' \
	--exclude='.emacs.d/elpa*' \
	--exclude='.emacs.d/plugins*' \
	--exclude='.emacs.d/tutorial*' \
	--exclude='.emacs.d/.ido.last' \
	--exclude='.emacs.d/.smex.last' \
	--exclude='.gnupg/.#*' \
	--exclude='.gnupg/*~' \
	--include='.*emacs**' \
	--include='memory' \
	--exclude='*.old' \
	--include='.ssh**' \
	--include='.gnupg**' \
	--include='.openvpn**' \
	--include='.bashrc' \
	--include='.zsh*' \
	--exclude='*' \
	$SOURCE $TARGET
}

for i in "$@"; do
    case "$1" in
	-o | --open)
	    exec_open
	    exec_mount
	    exit 0
	    ;;
	-c | --close)
	    exec_umount
	    exec_close
	    exit 0
	    ;;
	-s | --sync)
	    RUN_SYNC=true
	    ;;
    esac
done

echo
echo "-------------"
echo "> opening crypt volume"
echo "-------------"
exec_open
exec_mount
echo "-------------"
echo "> syncing files"
echo "-------------"
exec_sync
echo "-------------"
echo "> closing crypt volume"
echo "-------------"
exec_umount
exec_close
echo "-------------"
echo "Mission accomplished!"
echo
