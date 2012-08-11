#!/bin/bash
ls | grep [0-9]$ | awk '{print("mv "$1" "$1)}' | sed 's/\([0-9]$\)/\1.JPG/' | /bin/sh
