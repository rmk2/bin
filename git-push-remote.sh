#!/bin/bash

if 
[ `pwd` = '/home/ryko/Documents/TeX/universitet' ]; then
    echo
    echo "Pushing to remote repositories"
    # echo "-------------"
    # echo "> uni-login"
    # echo "-------------"
    # git push ph35
    echo "-------------"
    echo "> ox"
    echo "-------------"
    git push ox HEAD:master
    echo "-------------"
    echo "> bitbucket"
    echo "-------------"
    git push bb HEAD:master
    echo "-------------"
    echo "> executing post-commit hook"
    echo "-------------"
    sh .git/hooks/post-commit
    echo Success
    echo "-------------"
    echo "> running git archive on HEAD"
    echo "-------------"
    git archive --format=tar.gz HEAD > ~/universitet.tar.gz
    echo Success
    echo "-------------"
    echo "Mission accomplished!"
    echo
else
    echo "Wrong directory"
fi
