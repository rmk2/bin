
#!/bin/bash

DEFAULT=/home/ryko/Documents/TeX/universitet/
BACKUP="/home/ryko/.backup/$2"

if [ -z "$1" ]; then
    DIR=`echo $DEFAULT | sed 's|/$||'`
else
    DIR=`echo $1 | sed 's|/$||'`
fi

rsync -abchmv --delete-after --exclude='*-blx.bib' --include='*.bib' --include='*.org' --exclude='*.*~' --include='*.tex' --include='*.jpg' --include='*.png' --include='*.gin' --include='.git**' --exclude='*.*~' --exclude='*.*' "$DIR" "$BACKUP"
