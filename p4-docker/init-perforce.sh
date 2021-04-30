#!/bin/bash

source /p4/docker/perforce-config.sh

/opt/perforce/sbin/configure-helix-p4d.sh p4server -n -u $P4_SUPER_USER -P $P4_SUPER_PASSWORD --unicode --case 1 -r /p4/p4root
cp /etc/perforce/p4dctl.conf.d/p4server.conf /p4/docker/p4server.conf

export P4PASSWD=$(echo $P4PASSWD | p4 login -p | sed -e "s/Enter password: //g")

cowsay "temporarily being insecure, be sure to make secure again"
p4 configure set security=1

cat /p4/docker/templates/user-workstation.txt | p4 user -f -i
cat /p4/docker/templates/user-consumer.txt | p4 user -f -i

cowsay "creating stream depot $P4_STREAM_NAME"
cat /p4/docker/templates/stream_depot.txt | p4 depot -t stream -i

cowsay "making main stream for stream depot $P4_STREAM_NAME"
cat /p4/docker/templates/stream.txt | p4 stream -t mainline -i

cowsay "making workspace for main stream on $P4_STREAM_NAME"
cat /p4/docker/templates/server_workspace.txt | p4 client -i


export P4CLIENT=$P4_SERVER_WORKSPACE_NAME

cowsay "setting typemap"
cat /p4/docker/templates/typemap.txt | p4 typemap -i

cowsay "populating workspace"
cd /p4/p4root/workspace
p4 add .p4ignore
p4 set P4IGNORE=.p4ignore
p4 reconcile -ead
p4 submit -d "Initial Workspace Population"

cowsay "making secure again"
p4 configure set security=3