FROM ubuntu:bionic
LABEL maintainer="Michael Allar <allar@michaelallar.com>"
EXPOSE 1666

ARG SuperUserName=Allar
ARG SuperUserPassword=AllarAllar

RUN apt-get update
RUN apt-get install -y sudo apt-transport-https ca-certificates wget gnupg

RUN wget -qO - https://package.perforce.com/perforce.pubkey | sudo apt-key add -
RUN echo "deb http://package.perforce.com/apt/ubuntu bionic release" >> /etc/apt/sources.list.d/perforce.list
RUN apt-get update

RUN apt-get install -y helix-p4d

ADD ./perforce-config.sh /p4/docker/
RUN sed -i "s/REPLACE_WITH_SUPER_USER/${SuperUserName}/g" /p4/docker/perforce-config.sh
RUN sed -i "s/REPLACE_WITH_SUPER_PASSWORD/${SuperUserPassword}/g" /p4/docker/perforce-config.sh

ADD ./run.sh /p4/docker/
ADD ./init-perforce.sh /p4/docker/

ENTRYPOINT ["/p4/docker/run.sh"]
