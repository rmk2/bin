#!/bin/bash

export WINEDEBUG=-all

case "$1" in
    cata | wow)
	cd "/windows/E/games/World of Warcraft - Cataclysm"
	WINEPREFIX=~/.wine-games wine WoW.exe &
	;;
    d2 | diablo2 | diablo)
	cd "/home/ryko/.wine-d2/drive_c/Program Files/Diablo II"
	WINEPREFIX=~/.wine-d2 wine Game.exe -w "$2" &
	;;
    kotor)
	cd "/windows/E/games/Star Wars KotOR II TSL"
	WINEPREFIX=~/.wine-games wine swkotor2.exe &
	;;
    q3 | quake | quake3)
	/opt/quake3/ioquake3.x86_64 &
	;;
    sc4 | sim)
	WINEPREFIX=~/.wine-sc4 wine "C:\Program Files\SimCity 4 Deluxe\Apps\SimCity 4.exe" \
	    -d:opengl -intro:off -CPUCount:1 -CustomResolution:enabled -r1280x800x32
	;;
    sims | sims3 | ts3)
	WINEPREFIX=~/.wine-sims wine "C:\Program Files\The Sims 3\Game\Bin\TS3.exe"
	;;
    steam)
	WINEPREFIX=~/.wine-steam wine "C:\Program Files\Steam\Steam.exe" -no-dwrite
	;;
    torchlight | torch | tl)
	cd "/windows/E/games/Torchlight"
	WINEPREFIX=~/.wine-games wine Torchlight.exe &
	;;
    *)
	echo 'Usage: games.sh <name>'
esac
