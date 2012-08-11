#!/bin/bash
COUNTER=0
INPUT=$1
DIR=/home/ryko/Pictures/iwdrm

let "INPUT += 1"

function download() {
    echo "http://iwdrm.tumblr.com/" > $DIR/wget.iwdrm
    while [ $COUNTER -lt $INPUT ]; do
	echo "http://iwdrm.tumblr.com/page/$COUNTER" >> $DIR/wget.iwdrm
	let COUNTER=COUNTER+1
    done
    sed -e '/\/page\/0$/ d' -e '/\/page\/1$/ d' <$DIR/wget.iwdrm >$DIR/wget.iwdrm_sed
    mv $DIR/wget.iwdrm_sed $DIR/wget.iwdrm
    wget -H -Dmedia.tumblr.com,iwdrm.tumblr.com -k -p -np -N -erobots=off -P $DIR -i $DIR/wget.iwdrm
    mv $DIR/iwdrm.tumblr.com $DIR/index
}

if [ ! -d "$DIR" ]; then
    mkdir $DIR
    download
elif [ -d "$DIR/index" ]; then
    mv $DIR/index $DIR/iwdrm.tumblr.com
    download
else
    echo "Error!"
fi





