# freenas-appsdir-backup
Backup apps directory without items in the delete variable

Create appsdir-config file

cron="yes" will set the option to backup

POOL_PATH is the the location of the pool

APPS_PATH is the location of the apps directory

BACKUP_PATH is the location to store the backup files

BACKUP_NAME is the name to be appended to the jail name ie. caddy.tar.gz


```
cron=""
POOL_PATH="/mnt/v1"
APPS_PATH="apps"
BACKUP_PATH="temp"
BACKUP_NAME=".tar.gz"
DELETE_APPS="lazylibrarian sabnzbd plexpass urbackup sonarr radarr lidarr tautulli wordpress"
```

Restore option will restore all the *.tar.gz files to the POOL_PATH/APPS_PATH location that was the originally backup
