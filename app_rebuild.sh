#!/bin/bash

docker-compose down
docker volume rm \
    skatliste_nodered_userdir \
    skatliste_mariadb_datadir
docker-compose up -d

./app_restore.sh