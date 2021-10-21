#!/bin/bash

MARIADB_DUMP=mariadb-sqldump-202109101540.sql
NODERED_ARCHIVE=node-red-skat-202109101540.tgz

./nodered/nodered_restore.sh ${NODERED_ARCHIVE}
./mariadb/mariadb_restore.sh ${MARIADB_DUMP}
