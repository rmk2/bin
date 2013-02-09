#!/bin/bash

SCRIPT=$(basename $0)

## define DIR and DIR aliases for specific folders (~/ & ~/.bin)

case $(basename $(pwd)) in
    ryko)
	DIR="backup/git/config"
	;;
    .bin)
	DIR="backup/git/scripts"
	;;
    *)
	DIR="backup/git/$(basename $(pwd))"
esac

## define server names

if [ -z "$2" ]; then
    ARRAY="bb ox pi"
else
    shift
    ARRAY="$@"
fi

## define functions

function create() {
    for i in $ARRAY; do
	NAME=$i
	if [ "$i" = "bb" ]; then
	    echo "Please use the web interface on bitbucket.org to create remote repositories."
	else
	    ssh -q $NAME "mkdir -p ~/$DIR"
	    ssh -q $NAME "git init --bare ~/$DIR/.git"
	fi
    done
}

function add() {
    for i in $ARRAY; do
	NAME=$i
	if [ "$i" = "bb" ]; then
	    git remote add $NAME $NAME:ryko/$(basename $DIR).git
	else
	    git remote add $NAME $NAME:$DIR/.git
	fi
    done
}

function push() {
    for i in $ARRAY; do
	NAME=$i
	git push $NAME HEAD:master
    done
}

## execution part

case "$1" in
    -c | --create | create)
	create
	;;
    -a | --add | add)
	add
	;;
    -p | --push | push)
	push
	;;
    -A | --all | all)
	create
	add
	push
	;;
    -t | --test)
	echo $DIR
	echo $ARRAY
	;;
    -h | --help | -? | ? | help)
	echo "Usage: $SCRIPT [OPTION] <remote server names>"
	echo
	echo Note:
	echo 'If no remote (space-separated) servers are given, the standard servers are used.'
	echo -e '\t\t Standard servers: bb, ox, pi'
#	echo -e '\t\t Maximum servers: 5'
	echo
	echo Available options:
	echo -e '-c, --create \t create folders and initialise a bare git repository on the remote server'
	echo -e '-a, --add \t add remote server as remote git repository'
	echo -e '-p, --push \t push current git repository into remote git repository'
	echo -e '-A, --all \t create, then add, then push, as described above, for all given remote servers'
	;;
    *)
	echo "Usage: $SCRIPT [OPTION] <remote server names>"
	echo "Try '$SCRIPT --help' for more information."
esac
