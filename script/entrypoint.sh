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


# Wait for us to be able to connect to MySQL before proceeding
echo "===> Waiting for REDIS service"
service redis-server restart
X="$(redis-cli -s /var/run/redis/redis-server.sock ping)"
while  [ "${X}" != "PONG" ]; do
        echo "Redis not yet ready..."
        sleep 1
        X="$(redis-cli -s /var/run/redis/redis-server.sock ping)"
done


# Generate certificates if not ready
if $(/usr/local/bin/gvm-manage-certs -V | grep -q 'ERROR:') ; then
    echo "---> Generating Certs"
    /usr/local/bin/gvm-manage-certs -af
fi

# Check if admin exists, if not create admin
if $(/usr/local/sbin/gvmd --get-users | grep -q 'admin') ; then
    echo "---> Admin already exists.."
else
    echo "---> Creating admin with new password"
    /usr/local/sbin/gvmd --create-user=admin --password=${USER_PASSWORD}
fi


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