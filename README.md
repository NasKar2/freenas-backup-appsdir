# freenas-backup-appsdir

## Backup apps directory without items in the delete variable

Change to the directory you have cloned the repository to and run it by typing ```./appsdir.sh```
To automate backup, create a cron job pointing to the backup script. The prompts wll be bypassed in any non-interactive operation like a cron task in the FreeNAS GUI.

## Restore option will restore all(last option) or an individual .tar.gz file to the POOL_PATH/APPS_PATH location that was the originally backup

### Prerequisites

Create appsdir-config file

POOL_PATH is the the location of the pool and will be set by default

APPS_PATH is the location of the apps directory

BACKUP_PATH is the location to store the backup files

BACKUP_NAME is the name to be appended to the jail name ie. caddy.tar.gz

SKIP_APPS is the names of apps directories to not backup

PLEX_APP is the name of the plex directory. TAR will skip the cache,diagnositics,logs,updates directories.

WORDPRESS_APP is the name of your wordpress jail

DATABASE_NAME is the name of you wordpress database

DB_DBACKUP_NAME is the name of the mysql wordpress database

DB_PASSWORD is the password for the mysql database

CONFIG_PATH is the path in the jail that has the /mnt/v1/apps/wordpress mounted

```
APPS_PATH="apps"
BACKUP_PATH="backup/apps"
BACKUP_NAME=".tar.gz"
SKIP_APPS="duplicati urbackup"
PLEX_APP="plexpass"
WORDPRESS_APP="wordpress"
DATABASE_NAME="wordpress"
DB_BACKUP_NAME="wordpress.sql"
DB_PASSWORD="your_wordpress_database_password"
CONFIG_PATH="/config"
```

