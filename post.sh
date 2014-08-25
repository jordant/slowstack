#!/bin/bash
echo "deb http://mirrors.dreamcompute.com/debian wheezy main
deb http://mirrors.dreamcompute.com/security.debian.org/ wheezy/updates main
deb http://mirrors.dreamcompute.com/debian wheezy-updates main " > /tmp/sources.list
sudo cp /tmp/sources.list /etc/apt/

echo "deb http://mirrors.dreamcompute.com/debian wheezy-backports main" > /tmp/wheezy_backports.list
sudo cp /tmp/wheezy_backports.list /etc/apt/sources.list.d/


echo "ADMIN_PASSWORD=secrete
MYSQL_PASSWORD=secrete
RABBIT_PASSWORD=secrete
SERVICE_PASSWORD=secrete
SERVICE_TOKEN=secrete
#ENABLED_SERVICES=key,cinder,c-sch,c-api,c-vol,rabbit,mysql
" > /tmp/localrc
sudo mv /tmp/localrc /vagrant/devstack/

cd /vagrant/devstack && ./stack.sh || exit 1
