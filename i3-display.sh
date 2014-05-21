#!/bin/bash

INT="eDP1"
EXT="DP1"

if [ $(xrandr -q | grep -c -e "^$EXT connected") -eq 0 ]; then
    xrandr --output $INT --auto --primary
else
    xrandr --output $INT --auto --primary --output $EXT --right-of $INT --auto
fi
