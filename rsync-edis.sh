#!/bin/bash

rsync -tvl --delete --rsh=ssh --files-from=/home/ryko/rsync.edis edis:/ ~/ares/
