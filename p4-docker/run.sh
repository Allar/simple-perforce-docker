#!/bin/bash

if [! command -v p4dctl &> /dev/null]; then
    cowsay "Unable to find p4dctl. Bad image?"
    exit
fi

if [[ -f "/p4/docker/p4server.conf" ]]; then
    cp /p4/docker/p4server.conf /etc/perforce/p4dctl.conf
    chown perforce /etc/perforce/p4dctl.conf
fi

source /p4/docker/perforce-config.sh

if [[ $(p4dctl list | grep -i 'p4server') ]]; then
    cowsay "Perforce Server installation found. Starting..."
    p4dctl start -t p4d -a  
else
    cowsay "Found no perforce server installed. Initializing Perforce."
    source /p4/docker/init-perforce.sh
fi

exec /usr/bin/tail --pid=$(cat /var/run/p4d.p4server.pid) -F "/p4/p4root/logs/log" 