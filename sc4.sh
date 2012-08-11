#!/bin/bash
export WINEPREFIX=~/.wine-sc4/
# export WINEDEBUG=-all
wine "C:\Program Files\SimCity 4 Deluxe\Apps\SimCity 4.exe" -d:opengl -intro:off -CPUCount:1 -CustomResolution:enabled -r1280x800x32
