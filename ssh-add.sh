#!/bin/bash
export SSH_ASKPASS=/usr/lib/ssh/ksshaskpass
/usr/bin/ssh-add </dev/null
/usr/bin/ssh-add /home/ryko/.ssh/id_bitbucket </dev/null
/usr/bin/ssh-add /home/ryko/.ssh/id_ox </dev/null
