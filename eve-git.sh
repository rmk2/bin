#!/bin/bash
#
# eve-git - watch file and git commit all changes as they happen
#

FILE="/home/ryko/eve-intel.results"
DEST="/home/ryko/eve"

while true; do

    inotifywait -qq -e CLOSE_WRITE $FILE
    <$FILE sort | uniq -c | sed 's/^\s*\([0-9]*\)\s*/\1,/g' > $DEST/results.txt
    cd $DEST
    git commit -a -m "autocommit @ $(date -I)"
    git push origin master

done
