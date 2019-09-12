#!/bin/bash -eux

# https://github.com/hashicorp/docker-vault/blob/master/0.X/Dockerfile
PACKAGE_NAME="vault"

if [ -x "$(command -v apt-get)" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -yq
    apt-get install -yq aptitude software-properties-common python-minimal \
      apt-transport-https nano curl wget git gnupg2 tar gzip \
      unzip python-apt libcap2-bin iproute2 gosu
    python --version
elif [ -x "$(command -v dnf)" ]; then
    dnf makecache
    dnf --assumeyes install which nano curl wget git gnupg2 initscripts \
        hostname python3 tar gzip
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
  && mkdir -p /run/systemd/system/
rm -rf /sbin/initctl

# https://github.com/Yelp/dumb-init
wget -q -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
chmod +x /usr/bin/dumb-init

# create vault user group
groupadd vault
useradd -g vault vault
# mkdir -p /usr/local/bin
# touch /usr/local/bin/vault
# chown vault:vault /usr/local/bin/vault
