#!/bin/bash

#awk '{f=$1.JPG;print $2"-"$3"-"$4}' list

awk '{f=$1;sub("^[0-9]*",$2"-"$3"-"$4"-"$5,$1);system("mv "f" "$1)}' list
