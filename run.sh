#!/bin/bash

if [ ! -f /p4/p4root/logs/log ]; then
    echo >&2 "No perforce log detected, first time container is being loaded. Setting up Perforce."
    source /p4/docker/init-perforce.sh
else
    echo >&2 "Perforce Server installation detected. Starting server."
fi

p4dctl start -t p4d p4server

exec /usr/bin/tail --pid=$(cat /var/run/p4d.p4server.pid) -F "/p4/p4root/logs/log" 