#!/bin/bash

QUERY=$(xrandr --query | sed -e '2p;d' | awk '{print $4}')

if [ "$QUERY" = "right" ]; then
    xrandr --output DP1 --rotate normal
else
    xrandr --output DP1 --rotate right
fi
