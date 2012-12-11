#!/bin/bash
emacsclient -e '(let ((last-nonmenu-event nil))(kill-emacs))'
