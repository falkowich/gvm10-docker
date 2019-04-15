#!/bin/bash

set -o errexit
set -o pipefail


# == Vars
#
# DB_MIGRATION_DIR='/powerdns-admin/migrations'
# if [[ -z ${PDNS_PROTO} ]];
#  then PDNS_PROTO="http"
# fi
# 
# if [[ -z ${PDNS_PORT} ]];
#  then PDNS_PORT=8081
# fi



# Generate certificates if not ready
if $(/usr/local/bin/gvm-manage-certs -V | grep -q 'ERROR:') ; then
    echo "---> Generating Certs"
    /usr/local/bin/gvm-manage-certs -af
fi


# Wait for us to be able to connect to REDIS before proceeding
echo "===> Waiting for REDIS service"
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

# Check if admin exists, if not create admin
if $(/usr/local/sbin/gvmd --get-users | grep -q 'admin') ; then
    echo "---> Admin already exists.."
else
    echo "---> Creating admin with new password"
    /usr/local/sbin/gvmd --create-user=admin --password=admin
fi


# Check certs
echo "---> Starting Certsync.." ;\
/usr/local/sbin/greenbone-certdata-sync ;\
echo "---> Starting Scapsync.." ;\
/usr/local/sbin/greenbone-scapdata-sync


# Start GVM stuffs
echo "---> Starting OPENVASSD"
openvassd
echo "---> Starting GVMD"
gvmd 
echo "---> Starting GSAD"
gsad 


# WHATTODOWITTHIS?
if [ -z "$BUILD" ]; then
  echo "Tailing logs"
  tail -F /usr/local/var/log/gvm/*
fi