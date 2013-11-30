#!/bin/bash

rsync -tvl --fake-super --delete --rsh=ssh --files-from=$HOME/rsync.edis edis:/ ~/ares/
