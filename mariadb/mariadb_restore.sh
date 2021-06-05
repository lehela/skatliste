#!/bin/bash
set -x

# Container Variables
CONTAINER=skatliste_mariadb

# Database Variables
DATABASE=skatliste
DBUSER=root
DBPWD=rootsecrets

# Backup location
BACKUPDIR=/host/backups
SQLDUMP=$1

# Import mysqldump from backup directory 
docker exec $CONTAINER /bin/bash -c "\
    mysql \
        -hlocalhost \
        --user=${DBUSER} \
        --password=${DBPWD} \
        < ${BACKUPDIR}/${SQLDUMP}
    "

