#!/bin/bash -eux

# https://github.com/hashicorp/docker-vault/blob/master/0.X/Dockerfile
PACKAGE_NAME="vault"

if [ -x "$(command -v apt-get)" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -yq
    apt-get install -yq aptitude software-properties-common python-minimal \
      apt-transport-https nano curl wget git gnupg2 tar gzip \
      unzip python-apt libcap2-bin iproute2
    python --version
elif [ -x "$(command -v dnf)" ]; then
    dnf makecache
    dnf --assumeyes install which nano curl wget git gnupg2 initscripts \
        hostname python3 tar gzip unzip iproute python3-libselinux
    dnf clean all
    alternatives --set python /usr/bin/python3
    python --version

elif [ -x "$(command -v yum)" ]; then
    yum makecache fast
    yum update -y
    yum install -y which nano curl wget git gnupg2 initscripts hostname gzip \
        tar gzip shadow-utils
    yum clean all
    python --version
fi



# install the systemctl stub
cd /tmp
curl -sLO https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py \
  && yes | cp -f systemctl.py /usr/bin/systemctl \
  && chmod a+x /usr/bin/systemctl \
  && mkdir -p /run/systemd/system/ \
  && rm -rf /sbin/initctl

# https://github.com/Yelp/dumb-init
wget -q -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
  && chmod +x /usr/bin/dumb-init

# gosu
# https://github.com/tianon/gosu/releases
# https://gist.github.com/rafaeltuelho/6b29827a9337f06160a9
# https://cinhtau.net/2017/06/19/install-gosu-for-docker/
export GOSU_VERSION=1.11
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && curl -o /usr/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    && gpg --batch --verify /usr/bin/gosu.asc /usr/bin/gosu \
    && rm /usr/bin/gosu.asc \
    && rm -rf /root/.gnupg/ \
    && chmod +x /usr/bin/gosu \
    && gosu nobody true

# create vault user and group
groupadd vault
useradd -g vault vault
