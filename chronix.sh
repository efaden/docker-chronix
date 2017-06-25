#!/bin/bash

# Check for config directory
if [ ! -d /data ]; then
	mkdir -p /data
fi

if [ ! "$(ls -A /data/)" ]; then
	cp -rf /chronix/server/solr/chronix/data/* /data/
fi

rm -rf /chronix/server/solr/chronix/data
ln -s /data /chronix/server/solr/chronix/data
chmod -R 777 /data

exec /chronix/bin/solr -force -f -p 8983 -a "-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8984"
