#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <remote_host>"
    exit 1
fi

rsync -av . "$1:/home/pi/openauto"