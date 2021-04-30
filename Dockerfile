FROM ubuntu:bionic
LABEL maintainer="Michael Allar <allar@michaelallar.com>"
EXPOSE 1666

ARG SuperUserName=Allar
ARG SuperUserPassword=AllarAllar
ARG StreamName=SimpleStream
ARG ServerWorkspaceName=ServerWorkspace

RUN apt-get -qq -y update && \
    apt-get -qq -y upgrade && \
    apt-get install -y sudo apt-transport-https ca-certificates wget gnupg cowsay figlet unzip && \
    ln -s /usr/games/cowsay /usr/bin/cowsay

RUN wget -qO - https://package.perforce.com/perforce.pubkey | sudo apt-key add -
RUN echo "deb http://package.perforce.com/apt/ubuntu bionic release" >> /etc/apt/sources.list.d/perforce.list

RUN apt-get update && apt-get install -y helix-p4d

COPY ./seed-engines/ /p4/p4root/workspace/Engines
RUN cd /p4/p4root/workspace/Engines && unzip "*.zip" && rm *.zip && find . -type f -name '*@*' -delete && cd /

COPY ./p4-docker/ /p4/docker/

RUN find /p4/docker -type f -exec sed -i "s/REPLACE_WITH_SUPER_USER/$SuperUserName/g" {} + && \
    find /p4/docker -type f -exec sed -i "s/REPLACE_WITH_SUPER_PASSWORD/$SuperUserPassword/g" {} + && \
    find /p4/docker -type f -exec sed -i "s/REPLACE_WITH_STREAM_NAME/$StreamName/g" {} + && \
    find /p4/docker -type f -exec sed -i "s/REPLACE_WITH_SERVER_WORKSPACE_NAME/$ServerWorkspaceName/g" {} + 

COPY ./initial-workspace/ /p4/p4root/workspace/

ENTRYPOINT ["/p4/docker/run.sh"]
