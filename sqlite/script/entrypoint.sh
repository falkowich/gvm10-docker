#!/bin/bash

set -o pipefail

# Wait for us to be able to connect to REDIS before proceeding
# Wait for us to be able to connect to REDIS before proceeding
echo "===> Waiting for REDIS service"
service redis-server restart
while [ ! -e /var/run/redis/redis-server.sock ]
do
  service redis-server restart
  sleep 2
done

X="$(redis-cli -s /var/run/redis/redis-server.sock ping)"
while  [ "${X}" != "PONG" ]; do
        echo "Redis not yet ready..."
        sleep 1
        X="$(redis-cli -s /var/run/redis/redis-server.sock ping)"
done

# Check if ssl certs are in place (it's rather late and I will fix this more elegant later[tm])
echo "===> Waiting to get certs ready"
until /usr/local/bin/gvm-manage-certs -V -q
do
  /usr/local/bin/gvm-manage-certs -af
done

# Check if admin exists, if not create admin
if $(/usr/local/sbin/gvmd --get-users | grep -q 'admin') ; then
    echo "---> Admin already exists.."
else
    echo "---> Creating admin with new password"
    /usr/local/sbin/gvmd --create-user=admin --password=admin
fi


# Try to start certdata and scapdata sync
echo "---> Starting Certsync.." ;\
/usr/local/sbin/greenbone-certdata-sync ;\
echo "---> Starting Scapsync.." ;\
/usr/local/sbin/greenbone-scapdata-sync


# Start GVM stuffs
echo "---> Starting OPENVASSD"
openvassd
echo "---> Starting GVMD"
gvmd --listen=0.0.0.0 --port=9391
echo "---> Starting GSAD"
gsad --mlisten=0.0.0.0 --mport=9391


# WHATTODOWITTHIS?
if [ -z "$BUILD" ]; then
  echo "Tailing logs"
  tail -F /usr/local/var/log/gvm/*
fi