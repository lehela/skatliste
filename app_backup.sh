#!/bin/bash
DIRNAME=$(dirname "${BASH_SOURCE[0]}")
"$DIRNAME"/mariadb/mariadb_backup.sh
"$DIRNAME"/nodered/nodered_backup.sh
