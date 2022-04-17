# node-red-skat

A simple web app to track Skat scores for multiple players across seasons.

## Pre-requisites
The host must have `docker` and `docker-compose` installed.
Since all credentials exposed in the sources,  run this app behind a web proxy.

## Installation
1. Clone repository locally.
2. cd \<clone-directory\>
3. ./app_rebuild.sh
4. Proxy port 1880 to Docker host (including websocket traffic, see example apache2 conf)


## Notes
The application consists out of two docker services:
- The Node-Red main application service
- The MariaDB database service

Each of the services has backup/restore scripts in their respective folders.

## Backup
The backup script `app_backup.sh` is a convenience scripts which calls the below scripts:
- `nodered/nodered_backup.sh` saves the following files into the `nodered/backups/node-red-skat.tgz` tgz archive:
  
  - flows.json (The application logic)
  - flows_cred.json (Database credentials, which must match the `docker-compose.yml`)
  - settings.json (The settings with credential encryption disabled for clear texts)
  - package.json (Additional nodes required)
- `mariadb/mariadb_backup.sh` saves the `skatliste` database into the `mariadb/backups/mariadb-sqldump.sql` file.

## Restore
The restore script `app_restore.sh` runs the following scripts:
- `nodered_restore.sh` to restore the nodered application  from the last `nodered/backups/node-red-skat.tgz` archive
- `mysql_restore.sh` to restore the database entries from the last `mariadb/backups/mariadb-sqldump.sql` archive

## Rebuild
> Only attempt to run this after backup files have been created!
> 
The script `app_rebuild.sh` tears down all current Docker artefacts, and completely rebuilds them from the archived

Note to self: scripts to be polished up from their current bare-bones form.
