#!/bin/bash

if [ -z "$1" ]; then
    exit 0
fi

if [ -z "$2" ]; then
    DIR=/home/ryko/Pictures/iwdrm
else
    DIR=$2
fi

# let "INPUT += 1"

# function download() {
#     echo "http://iwdrm.tumblr.com/" > $DIR/wget.iwdrm
#     while [ $COUNTER -lt $INPUT ]; do
# 	echo "http://iwdrm.tumblr.com/page/$COUNTER" >> $DIR/wget.iwdrm
# 	let COUNTER=COUNTER+1
#     done
#     sed -e '/\/page\/0$/ d' -e '/\/page\/1$/ d' <$DIR/wget.iwdrm >$DIR/wget.iwdrm_sed
#     mv $DIR/wget.iwdrm_sed $DIR/wget.iwdrm
#     wget -H -Dmedia.tumblr.com,iwdrm.tumblr.com -k -p -np -N -erobots=off -P $DIR -i $DIR/wget.iwdrm
#     mv $DIR/iwdrm.tumblr.com $DIR/index
# }

function download() {
    wget -H -Dmedia.tumblr.com,iwdrm.tumblr.com -k -p -np -N -erobots=off -P $DIR http://iwdrm.tumblr.com/

    for i in $(seq 2 $1); do
	echo "http://iwdrm.tumblr.com/page/$i" ; done | wget -H -Dmedia.tumblr.com,iwdrm.tumblr.com -k -p -np -N -erobots=off -P $DIR -i -
    done
}

# if [ ! -d "$DIR" ]; then
#     mkdir $DIR
#     download
# elif [ -d "$DIR/index" ]; then
#     mv $DIR/index $DIR/iwdrm.tumblr.com
#     download
# else
#     echo "Error!"
# fi

download
