#!/bin/bash

cd "/home/ryko/.wine-d2/drive_c/Program Files/Diablo II"
WINEPREFIX=~/.wine-d2 WINEDEBUG=-all wine Game.exe -w "$1" &
