#!/bin/bash

sudo find /tmp/ -mtime +3 -print0 | sudo xargs -0 rm -rf
