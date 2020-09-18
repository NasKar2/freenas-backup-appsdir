# freenas-appsdir-backup

### Backup apps directory without items in the delete variable

### Restore option will restore all(last option) or an individual .tar.gz file to the POOL_PATH/APPS_PATH location that was the originally backup

### Prerequisites

Create appsdir-config file

cron="yes" will set the option to automatically backup

POOL_PATH is the the location of the pool

APPS_PATH is the location of the apps directory

BACKUP_PATH is the location to store the backup files

BACKUP_NAME is the name to be appended to the jail name ie. caddy.tar.gz

SKIP_APPS is the names of apps directories to not backup

PLEX_APP is the name of the plex directory. TAR will skip the cache directory.

```
cron=""
POOL_PATH="/mnt/v1"
APPS_PATH="apps"
BACKUP_PATH="temp"
BACKUP_NAME=".tar.gz"
SKIP_APPS="duplicati urbackup"
PLEX_APP="plexpass"
```

