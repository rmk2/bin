#!/bin/sh

COUNT="$1"

if [ -z "$COUNT" ]; then
    COUNT=16
fi

# tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${COUNT} | xargs -0

base64 < /dev/urandom | head -c ${COUNT} | xargs -0
