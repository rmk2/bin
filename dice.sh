#!/bin/bash

RANGE="$1"+1
FLOOR=0
NUMBER=0

while [ "$NUMBER" -le $FLOOR ]; do
    NUMBER=$RANDOM
    let "NUMBER %= $RANGE"
done
echo \(d"$1"\) $NUMBER
