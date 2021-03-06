#! /bin/bash

NAME=$(basename $0)

if [ -z "$1" ]; then
    echo "Usage: $NAME [OPTION]"
    echo "Try '$NAME --help' for more information."
fi

for i in $@; do
    case "$i" in
	--cache | cache | -c)
	    rm -f ~/.cache/chromium/Default/Cache/*
	    rm -f ~/.cache/chromium/Default/Media\ Cache/*
	    rm -f ~/.cache/google-chrome/Default/Cache/*
	    echo 'Browser Caches emptied'
	    ;;
	--emacs | emacs | -e)
	    find ~/.emacs.d/ -name ".saves*" -mtime +3 -print0 | xargs -0 rm
	    find ~/.emacs.d/ -name "session*" -mtime +3 -print0 | xargs -0 rm
	    echo 'Emacs leftovers cleared'
	    ;;
	--tmp | tmp | -t)
	    find /tmp/ -mtime +3 -user `id -un` -print0 | xargs -0 rm -rf
	    echo 'User created files older than 3 days in tmp cleared'
	    ;;
	--tmp-sudo | tmp-sudo | -T)
	    sudo find /tmp/ -mtime +3 -print0 | sudo xargs -0 rm -rf
	    echo 'All files older than 3 days in tmp cleared'
	    ;;
	--help | -?)
	    echo Usage: $NAME [OPTION]
	    echo
	    echo Available options:
	    echo -e '-c, --cache \t clear browser caches located in ~/.cache unconditionally'
	    echo -e '-e, --emacs \t clear emacs autosave and session files older than 3 days in ~/.emacs.d'
	    echo -e '-t, --tmp \t\t clear user generated tmp files older than 3 days in /tmp'
	    echo -e '-T, --tmp-sudo \t clear ALL tmp files older than 3 days in /tmp -- NEEDS SUDO PRIVILEGE'
	    echo
	    ;;
	*)
	    echo "Usage: $NAME [OPTION]"
	    echo "Try '$NAME --help' for more information."
	    ;;
    esac
done
