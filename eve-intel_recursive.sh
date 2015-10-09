#!/bin/bash

set -e

DAYS=2

OUTPUT_FILE="/dev/shm/eve-intel_recursive.results"
WAIT_INTERVAL=10

DATE=""
TIME_INTERVAL=0

API_SUPERS=""
API_TITANS=""

TMP_SUPERS="/dev/shm/super-involved.txt"
TMP_TITANS="/dev/shm/titan-involved.txt"
TMP_ALL="/dev/shm/all-involved.txt"

function clean_tmp_files() {
    
    if [[ -e $TMP_SUPERS || -e $TMP_TITANS || -e $TMP_ALL ]] ; then
	rm $TMP_SUPERS $TMP_TITANS $TMP_ALL
    else
	return
    fi
}

function set_time() {
    
    DATE=$(date +%Y%m%d --date="$TIME_INTERVAL days ago")
    
    API_SUPERS="https://zkillboard.com/api/kills/groupID/659/no-items/startTime/"$DATE"0000/endTime/"$DATE"2359"
    API_TITANS="https://zkillboard.com/api/kills/groupID/30/no-items/startTime/"$DATE"0000/endTime/"$DATE"2359"
   
}

function get_data() {

    # Get necessary killmail data from zkill, using gzip because we are just
    # that nice
    
    curl --show-error --silent --header "Accept-Encoding: gzip" --user-agent "ryko@rmk2.org" $1 | gzip -d - > $2
}

function check_data() {

    # Check whether the temporary files holding our killmail data exist and/or
    # whether they are older than one hour.
    
    TMP_FILE=""

    case $1 in
	--supers)
	    TMP_FILE=$TMP_SUPERS
	    API=$API_SUPERS
	    ;;
	--titans)
	    TMP_FILE=$TMP_TITANS
	    API=$API_TITANS
	    ;;
	*)
	    return 1
    esac

    if [[ ! -e $TMP_FILE && ! -s $TMP_FILE || $(( $(stat -c %Y $TMP_FILE) + 3600 )) < $(date +%s) ]] ; then
	get_data $API $TMP_FILE
    fi
}

function parse_input() {
    eve-intel.rkt -aiT | sort | uniq
}

function combine_input() {

    # Combine separate API queries for supers and titans into one input file,
    # since zkill limits the available amount of killmails severly if both are
    # polled in the same request. This could even be done for each type of
    # super individually, if necessary

    # In order for this combination to work, we have to make sure they are all
    # part of the *same* json array, which is why we are stripping the closing
    # bracket from the first file and join the second file by replacing its
    # opening bracket with a comma, thus combining them into one array
    
    if [[ ! -e $TMP_ALL && ! -s $TMP_ALL || $TMP_SUPERS -nt $TMP_ALL || $TMP_TITANS -nt $TMP_ALL ]] ; then
	sed 's/\]$//' $TMP_SUPERS > $TMP_ALL
	sed 's/^\[/,/' $TMP_TITANS >> $TMP_ALL
    fi
}

while getopts :cdfimstwx OPT; do
    case $OPT in
	x|+x)
	    echo "Dummy argument for testing purposes"
	    exit 0
	    ;;

	s|+s)
	    DUMMY=0
	    ;;
	t|+t)
	    DUMMY=0
	    ;;
	i|+i)
	    INPUT="interactive"
	    ;;
	d|+d)
	    TIME_INTERVAL="day"
	    ;;
	w|+w)
	    TIME_INTERVAL="week"
	    ;;
	m|+m)
	    TIME_INTERVAL="month"
	    ;;
	f|+f)
	    TIME_INTERVAL="first"
	    ;;
	c|+c)
	    clean_tmp_files
	    exit 0
	    ;;
	*)
	    echo "usage: ${0##*/} [+-cdfimstwx} [--] ARGS..."
	    exit 2
    esac
done
shift $(( OPTIND - 1 ))
OPTIND=1

for i in $(seq $DAYS -1 0); do
    
    TIME_INTERVAL=$i

    DATE=$(date +%Y%m%d --date="$TIME_INTERVAL days ago")
    
    API_SUPERS="https://zkillboard.com/api/kills/groupID/659/no-items/startTime/"$DATE"0000/endTime/"$DATE"2359"
    API_TITANS="https://zkillboard.com/api/kills/groupID/30/no-items/startTime/"$DATE"0000/endTime/"$DATE"2359"

    echo
    echo "-------------"
    echo "Pulling data for: $(date +%Y%m%d --date="$TIME_INTERVAL days ago")"
    echo "-------------"

    #    set_time
    check_data --supers
    check_data --titans
    combine_input

    <$TMP_ALL parse_input | sed -e "s/\$/,$(date +%Y-%m-%d --date="$TIME_INTERVAL days ago")/g" >> $OUTPUT_FILE

    echo "Output appended to $OUTPUT_FILE"

    clean_tmp_files

    if [ $i -gt 0 ]; then
	echo "-------------"
	echo "Waiting for $WAIT_INTERVAL seconds until next API pull"
	sleep $WAIT_INTERVAL
    else
	echo "-------------"
	echo "Mission accomplished!"
	echo
	exit 0
    fi
    
done

