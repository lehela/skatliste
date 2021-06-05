#!/bin/bash
set -x

# Container Variables
CONTAINER=skatliste_nodered
USERDIR=/data

# Backup Variables
BACKUPDIR=/host/backups
ARCHIVE=$1

# Unpack archive into user directory 
docker exec $CONTAINER /bin/bash -c "\
    rm -rf ""$USERDIR""/.config*; \
    rm -rf ""$USERDIR""/.sessions*; \
    tar -xzf ""$BACKUPDIR""/""$ARCHIVE"" --directory ""$USERDIR"" \
    "
# Install node-red packages
docker exec $CONTAINER /bin/bash -c "\
    cd ""$USERDIR""; \
    npm install && npm audit fix; \
    "
# Restart the container
docker container restart $CONTAINER
