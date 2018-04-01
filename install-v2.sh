#!/bin/bash

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    sudo apt-get install -y dialog python3-dialog python-apt >/dev/null
    sudo python3 scripts/script.py
else
    echo "You are offline, please get yourself some internet and try again."
    exit
fi
