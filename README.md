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

The backup scripts can be run without any arguments:
- `nodered_backup.sh` saves the following files into a timestamped tgz archive:
  
  - flows.json (The application logic)
  - flows_cred.json (Database credentials, which must match the `docker-compose.yml`)
  - settings.json (The settings with credential encryption disabled for clear texts)
  - package.json (Additional nodes required)
- `mariadb_backup.sh` saves the `skatliste` database into a timestamped `.sql` file.
- `app_backup.sh` is a convenience scripts which calls the above backup scripts at the same time.

The restore scripts must be run with arguments:
- `nodered_restore.sh` \<<i>timestamped tgz archive</i>\>
- `mysql_restore.sh` \<<i>timestamped mariadb_dump</i>\>
- `app_restore.sh` (without args) is a convenience script that calls the bove restore scripts. Edit this file to set the correct timestamped input files prior to execution. 

Note to self: scripts to be polished up from their current bare-bones form.
