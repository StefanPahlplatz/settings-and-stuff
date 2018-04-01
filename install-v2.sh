#!/bin/bash

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    sudo apt-get install -y dialog python3-dialog python-apt git python3-pip >/dev/null
    git clone https://github.com/StefanPahlplatz/settings-and-stuff.git setup >/dev/null
    pip3 install pythondialog >/dev/null
    sudo python3 setup/scripts/script.py
else
    echo "You are offline, please get yourself some internet and try again."
    exit
fi
