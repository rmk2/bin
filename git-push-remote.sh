#!/bin/bash

function push-ox() {
    echo "-------------"
    echo "> ox"
    echo "-------------"
    git push ox HEAD:master
}

function push-bb() {
    echo "-------------"
    echo "> bitbucket"
    echo "-------------"
    git push bb HEAD:master
}

function push-pi() {
    echo "-------------"
    echo "> pi"
    echo "-------------"
    git push pi HEAD:master
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
    push-ox
    push-bb
    if [ "$1" == "--pi" ]; then
	push-pi
    fi
    exec-hooks
    exec-archive
    echo "-------------"
    echo "Mission accomplished!"
    echo
elif [ -d './.git' ]; then
    echo
    echo "Pushing to remote repositories"
    push-ox
    push-bb
    if [ "$1" == "--pi" ]; then
	push-pi
    fi
    echo "-------------"
    echo "Mission accomplished!"
    echo
else
    echo "Error: This directory is not under version control via git!"
fi
