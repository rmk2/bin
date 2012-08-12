#! /bin/bash

DIR="git_backup/$(basename $(pwd))"

if [ -z "$2" ]; then
    NAME="pi"
else
    NAME="$2"
fi

case $1 in
    -c | --create | create)
	ssh -q $(id -un)@$NAME mkdir -p ~/$DIR/
	ssh -q $(id -un)@$NAME git init ~/$DIR/
	;;
    -a | --add | add)
	git remote add $NAME $(id -un)@$NAME:$DIR/.git/
	;;
    -p | --push | push)
	git push --all $NAME
	;;
    --auto | auto)
	ssh -q $(id -un)@$NAME mkdir -p ~/$DIR/
	ssh -q $(id -un)@$NAME git init ~/$DIR/
	git remote add $NAME $(id -un)@$NAME:$DIR/.git/
	ssh -q $(id -un)@$NAME git --git-dir=$DIR/.git/ checkout -b dummy
	git push --all $NAME
	ssh -q $(id -un)@$NAME git --git-dir=$DIR/.git/ checkout master
	;;
    --help | -? | ?)
	exit 0
	;;
    *)
	exit 0
esac
