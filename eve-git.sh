#!/bin/bash
#
# eve-git - watch file and git commit all changes as they happen
#

PLAIN="/home/ryko/eve-intel.results"
REGIONS="/home/ryko/eve-intel_regions.results"
DEST="/home/ryko/eve"

while true; do

    inotifywait -qq -e CLOSE_WRITE $REGIONS
    # <$PLAIN sort | uniq -c | sed 's/^\s*\([0-9]*\)\s*/\1,/g' > $DEST/results.txt
    cp $REGIONS $DEST/results_regions.txt
    cd $DEST
    git commit -a -m "autocommit @ $(date -I)"
    # git push origin master
    git push edis master

done
