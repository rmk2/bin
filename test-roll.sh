#!/bin/bash

I=10000

until [ $I = 0 ]; do
    dice 20 5000 | awk '{print $2}' | grep -c 20 >> dice_roll
    I=`expr $I - 1`
done
