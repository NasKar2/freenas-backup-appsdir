# freenas-backup-appsdir

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

WORDPRESS_APP is the name of your wordpress jail

DATABASE_NAME is the name of you wordpress database

DB_DBACKUP_NAME is the name of the mysql wordpress database

DB_PASSWORD is the password for the mysql database

CONFIG_PATH is the path in the jail that has the /mnt/v1/apps/wordpress mounted

```
cron=""
POOL_PATH="/mnt/v1"
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

