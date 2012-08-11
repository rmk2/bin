#!/bin/bash

TEX=$1
BCF=$(echo $1 | sed 's/tex$/bcf/')
AUX=$(echo $1 | sed 's/tex$/aux/')

echo $TEX
echo $BCF
echo $AUX

ls -l | grep -q '.tex' $TEX
if [ $? = 0 ]; then
    echo tex
else
    echo other
fi
