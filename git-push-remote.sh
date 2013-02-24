#!/bin/bash

if [ "$*" == "--pi" ]; then
    ARRAY="ox bb edis pi"
else
    ARRAY="ox bb edis"
fi

function exec-push() {
    for i in $ARRAY; do
	echo "-------------"
	echo "> $i"
	echo "-------------"
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
    echo "-------------"
    echo "Mission accomplished!"
    echo
else
    echo "Error: This directory is not under version control via git!"
fi
