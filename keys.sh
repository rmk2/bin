#!/bin/bash

SOURCE=/home/ryko/
BACKUP=/home/ryko/.backup/

if [ -z "$1" ]; then
    TARGET=`echo "$BACKUP"`
else
    TARGET=`echo "$1"`
fi

rsync -achmv --delete-after --safe-links --exclude='.*~' --exclude='.emacs.d/session*' --exclude='.emacs.d/elpa*' \
--exclude='.emacs.d/plugins*' --exclude='.gnupg/.#*' --include='.*emacs**' --include='memory' --include='.ssh**' \
--include='.gnupg**' --include='.openvpn**' --include='.bashrc' --include='.zsh*' --exclude='*' "$SOURCE" "$TARGET"
