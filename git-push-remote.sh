#!/bin/bash

set -e

GITDIR="$(pwd)/.git"

ARRAY="ox bb edis"

while getopts :pHatg:s: OPT; do
    case $OPT in
	p|+p)
	    ARRAY+=" pi2"
	    ;;
	s|+s)
	    ARRAY+=" $OPTARG"
	    ;;
	H|+H)
	    HOOKS=true
	    ;;
	a|+a)
	    ARCHIVE=true
	    ;;
	t|+t)
	    TAGS=true
	    ;;
	g|+g)
	    if [ $(basename "$OPTARG") == ".git" ]; then
		GITDIR="$OPTARG"
	    elif [ -d "$OPTARG" ] && [ -d "$OPTARG/.git" ]; then
		GITDIR="$OPTARG/.git"
	    else
		echo "Error: This directory is not under version control via git!"
		exit 1
	    fi
	    ;;
	*)
	    echo "usage: ${0##*/} [+-phatg ARG [+-s ARG} [--] ARGS..."
	    exit 2
    esac
done
shift $(( OPTIND - 1 ))
OPTIND=1

function exec-push() {
    for i in $ARRAY; do
	echo "-------------"
	echo "> $i"
	echo "-------------"
	if [ "$TAGS" == "true" ]; then
	    git --git-dir=$GITDIR push --tags $i HEAD:master
	fi
	git --git-dir=$GITDIR push $i HEAD:master
    done
}

function exec-hooks() {
    echo "-------------"
    echo "> executing post-commit hook"
    echo "-------------"
    sh $GITDIR/hooks/post-commit
    echo Success
}

function exec-archive() {
    echo "-------------"
    echo "> running git archive on HEAD"
    echo "-------------"
    git --git-dir=$GITDIR archive --format=tar.gz HEAD > ~/$(basename $(dirname $GITDIR) | tr -d '.').tar.gz
    echo Success
}

if [ $(pwd) = '/home/ryko/Documents/TeX/universitet' ]; then
    echo
    echo "Pushing to remote repositories"
    exec-push
    exec-hooks
    exec-archive
    echo "-------------"
    echo "Mission accomplished!"
    echo
    exit 0
elif [ -d $GITDIR ]; then
    echo
    echo "Pushing to remote repositories"
    exec-push
    if [ "$HOOKS" == "true" ]; then
	exec-hooks
    fi
    if [ "$ARCHIVE" == "true" ]; then
	exec-archive
    fi
    echo "-------------"
    echo "Mission accomplished!"
    echo
    exit 0
else
    echo "Error: This directory is not under version control via git!"
    exit 1
fi
