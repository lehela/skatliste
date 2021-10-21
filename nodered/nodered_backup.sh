#!/bin/bash
set -x

# Container Variables
CONTAINER=skatliste_nodered
USERDIR=/data

# Backup Variables
BACKUPDIR=/host/backups
ARCHIVE=node-red-skat-$(date +"%Y%m%d%H%M").tgz

# Write app files to archive
docker exec $CONTAINER /bin/bash -c "\
    cd ""$USERDIR""; \
    tar -czf ""$BACKUPDIR""/""$ARCHIVE"" \
        flows.json \
        flows_cred.json \
        package.json \
        settings.js \
    "
