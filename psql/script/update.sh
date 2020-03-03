#!/bin/bash

echo "---> Starting Certsync.." ;\
/usr/local/sbin/greenbone-certdata-sync ;\
echo "---> Starting Scapsync.." ;\
/usr/local/sbin/greenbone-scapdata-sync ;\
echo "---> Starting NVTsync.." ;\
/usr/local/sbin/greenbone-nvt-sync 