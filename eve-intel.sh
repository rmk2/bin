#!/bin/bash

set -e

FILTER=""
INPUT=""

TIME_INTERVAL_DEFAULT="day"
TIME_INTERVAL=$TIME_INTERVAL_DEFAULT
DATE_DEFAULT=$(date +%Y%m%d --date="1 $TIME_INTERVAL_DEFAULT ago")

OUTPUT="shipTypeID characterName corporationName allianceName"
DELIMITER=","

TYPEID=(3514 22852 23913 23917 23919 671 3764 11567 23773)
NAME=("Revenant" "Hel" "Nyx" "Wyvern" "Aeon" "Erebus" "Leviathan" "Avatar" "Ragnarok")

API_SUPERS="https://zkillboard.com/api/kills/groupID/659/no-items/startTime/"$DATE_DEFAULT"0000"
API_TITANS="https://zkillboard.com/api/kills/groupID/30/no-items/startTime/"$DATE_DEFAULT"0000"

TMP_SUPERS="/dev/shm/super-involved.txt"
TMP_TITANS="/dev/shm/titan-involved.txt"
TMP_ALL="/dev/shm/all-involved.txt"

function clean_tmp_files() {
    if [[ -e $TMP_SUPERS || -e $TMP_TITANS || -e $TMP_ALL ]] ; then
	rm $TMP_SUPERS $TMP_TITANS $TMP_ALL
	exit 0
    else
	return
    fi
}

function set_time() {
    case $TIME_INTERVAL in
	day|week|month)
	    DATE=$(date +%Y%m%d --date="1 $TIME_INTERVAL ago")
	    ;;
	first)
	    DATE="$(date +%Y%m)01"
	    ;;
	*)
    esac

    API_SUPERS="https://zkillboard.com/api/kills/groupID/659/no-items/startTime/"$DATE"0000"
    API_TITANS="https://zkillboard.com/api/kills/groupID/30/no-items/startTime/"$DATE"0000"
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
    json -ga attackers | json -ga $1 -d$2 | sed -n -e $3 | sort | uniq
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

	    DATE=$(date +%Y%m)

	    for ((i=0; i<${#TYPEID[@]}; i++)); do
		get_data https://zkillboard.com/api/kills/shipTypeID/${TYPEID[i]}/no-items/startTime/201506120000 /dev/shm/${TYPEID[i]}.txt
	    done
	    
	    exit 0
	    ;;

	s|+s)
	    for ((i=0; i<5; i++)); do
		FILTER+="s/${TYPEID[i]}/${NAME[i]}/p;"
	    done
	    ;;
	t|+t)
	    for ((i=5; i<${#TYPEID[@]}; i++)); do
		FILTER+="s/${TYPEID[i]}/${NAME[i]}/p;"
	    done
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
	    ;;
	*)
	    echo "usage: ${0##*/} [+-cdfimstwx} [--] ARGS..."
	    exit 2
    esac
done
shift $(( OPTIND - 1 ))
OPTIND=1

set_time
check_data --supers
check_data --titans
combine_input

if [[ "$INPUT" == "interactive" ]]; then
    parse_input "$OUTPUT" "$DELIMITER" "${FILTER[*]}"

    while read data; do
	echo "INPUT = $INPUT"
    done
else
    <$TMP_ALL parse_input "$OUTPUT" "$DELIMITER" "${FILTER[*]}"
fi

