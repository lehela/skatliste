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
SQLDUMP=mariadb-sqldump-$(date +"%Y%m%d%H%M").sql

# Write mysqldump to backup directory 
docker exec $CONTAINER /bin/bash -c "\
    mysqldump \
        -hlocalhost \
        --user=${DBUSER} \
        --password=${DBPWD} \
        --lock-tables \
        --events \
        --routines \
        --databases ${DATABASE} \
        > ${BACKUPDIR}/${SQLDUMP}
    "

