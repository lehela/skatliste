#!/bin/bash

MARIADB_DUMP=mariadb-sqldump.sql
NODERED_ARCHIVE=node-red-skat.tgz

./nodered/nodered_restore.sh ${NODERED_ARCHIVE}
./mariadb/mariadb_restore.sh ${MARIADB_DUMP}
