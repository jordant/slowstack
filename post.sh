#!/bin/bash

# setup apt proxy
cat > /tmp/01proxy << EOF
Acquire::http::Proxy "http://10.10.10.152:3142";
EOF

sudo cp /tmp/01proxy /etc/apt/apt.conf.d/

echo "ADMIN_PASSWORD=secrete
MYSQL_PASSWORD=secrete
RABBIT_PASSWORD=secrete
SERVICE_PASSWORD=secrete
SERVICE_TOKEN=secrete
#ENABLED_SERVICES=key,cinder,c-sch,c-api,c-vol,rabbit,mysql
" > /tmp/localrc
sudo mv /tmp/localrc /vagrant/devstack/

cd /vagrant/devstack && ./stack.sh || exit 1
