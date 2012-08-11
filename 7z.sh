#!/bin/bash
if [ -z "$1" ]; then
        echo Usage: 7z.sh password archive-name folder
        exit
fi
7z a -p$1 -mhe $2 $3
