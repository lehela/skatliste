#!/bin/bash

MARIADB_DUMP=mariadb-sqldump-202106050533.sql
NODERED_ARCHIVE=nodered-202106050533.tgz

./nodered/nodered_restore.sh ${NODERED_ARCHIVE}
./mariadb/mariadb_restore.sh ${MARIADB_DUMP}
