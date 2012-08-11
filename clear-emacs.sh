#!/bin/bash

find ~/.emacs.d/ -name ".saves*" -mtime +5 -print0 | xargs -0 rm
find ~/.emacs.d/ -name "session*" -mtime +5 -print0 | xargs -0 rm
