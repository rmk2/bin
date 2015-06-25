#!/bin/bash

ARRAY="ox bb edis"

for i in "$@"; do
    case "$1" in
	-p | --pi | -pi | pi)
	    ARRAY+="pi"
	    ;;
	-h | --hooks | -hooks | hooks)
	    HOOKS=true
	    ;;
	-a | --archive | -archive | archive)
	    ARCHIVE=true
	    ;;
	-t | --tags | -tags | tags)
	    TAGS=true
	    ;;
    esac
    shift
done


function exec-push() {
    for i in $ARRAY; do
	echo "-------------"
	echo "> $i"
	echo "-------------"
	if [ "$TAGS" == "true" ]; then
	    git push --tags $i HEAD:master
	fi
	git push $i HEAD:master
    done
}

function exec-hooks() {
    echo "-------------"
    echo "> executing post-commit hook"
    echo "-------------"
    sh .git/hooks/post-commit
    echo Success
}

function exec-archive() {
    echo "-------------"
    echo "> running git archive on HEAD"
    echo "-------------"
    git archive --format=tar.gz HEAD > ~/$(basename $(pwd) | tr -d '.').tar.gz
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
elif [ -d './.git' ]; then
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
else
    echo "Error: This directory is not under version control via git!"
fi
