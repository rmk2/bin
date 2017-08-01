#!/bin/bash

set -e

WIRELESS="$HOME/Downloads/source/non-vc/broadcom-wl"
BACKLIGHT="$HOME/Downloads/source/git/mba6x_bl"

# Prepare module folder

echo
echo "-------------"
echo "> creating folder(s)"
echo "-------------"

sudo mkdir -p /lib/modules/$(uname -r)/extra && echo "Success!"

# Make mba6x_bl

echo "-------------"
echo "> building backlight driver"
echo "-------------"

cd $BACKLIGHT

make && sudo make install

# Make broadcom-wl

echo "-------------"
echo "> building wireless driver"
echo "-------------"

cd $WIRELESS

make && sudo cp wl.ko /lib/modules/$(uname -r)/extra

# Reload and activate modules

echo "-------------"
echo "> activating modules"
echo "-------------"

sudo depmod -a && sudo modprobe wl && sudo modprobe mba6x_bl && echo "Success!"

echo "-------------"
echo "Mission accomplished!"
echo
