#! /bin/bash

DIR="git_backup/$(basename $(pwd))"

if [ -z "$2" ]; then
    NAME="pi"
else
    NAME="$2"
fi

case $1 in
    -c | --create | create)
	ssh -q $NAME mkdir -p ~/$DIR/
#	ssh -q $NAME git init ~/$DIR/
	;;
    -a | --add | add)
	git remote add $NAME $NAME:$DIR/.git/
	;;
    -p | --push | push)
	git push --all $NAME
	;;
    --auto | auto)
	ssh -q $NAME mkdir -p ~/$DIR/
	ssh -q $NAME git init ~/$DIR/
	git remote add $NAME $NAME:$DIR/.git/
	ssh -q $NAME git --git-dir=$DIR/.git/ checkout -b dummy
	git push --all $NAME
	ssh -q $(id -un)@$NAME git --git-dir=$DIR/.git/ checkout master
	;;
    --test | -t)
	echo $DIR
	;;
    --help | -? | ?)
	exit 0
	;;
    *)
	exit 0
esac
