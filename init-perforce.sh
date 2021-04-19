#!/bin/bash

source /p4/docker/perforce-config.sh

export P4USER=$P4_SUPER_USER
export P4PASSWD=$P4_SUPER_PASSWORD

/opt/perforce/sbin/configure-helix-p4d.sh p4server -n -u $P4_SUPER_USER -P $P4_SUPER_PASSWORD --unicode --case 1 -r /p4/p4root