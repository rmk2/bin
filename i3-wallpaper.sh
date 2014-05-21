#!/bin/bash

INT="eDP1"
EXT="DP1"

if [ $(xrandr -q | grep -c -e "^$EXT connected") -eq 0 ]; then
    nitrogen --set-auto Pictures/wallpapers/flowers.jpg
else
    nitrogen --set-auto Pictures/i3_wall.png
fi
