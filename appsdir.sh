#!/bin/bash
#
# Initialize Variables
#
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

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
. $SCRIPTPATH/appsdir-config
RELEASE=$(freebsd-version | sed "s/STABLE/RELEASE/g" | sed "s/-p[0-9]*//")

#
# Check if appsdir-config created correctly
#

if [ -z $POOL_PATH ]; then
  echo 'Configuration error: POOL_PATH must be set'
  exit 1                                                                                                        
fi
if [ -z $APPS_PATH ]; then
  echo 'Configuration error: APPS_PATH must be set'
  exit 1                                                                                                        
fi
if [ -z $BACKUP_PATH ]; then
  echo 'Configuration error: BACKUP_PATH must be set'
  exit 1                                                                                                        
fi
if [ -z $BACKUP_NAME ]; then
  echo 'Configuration error: BACKUP_NAME must be set'
  exit 1                                                                                                        
fi
#if [ -z $SKIP_APPS ]; then
#  echo 'Configuration error: SKIP_APPS must be set'
#  exit 1                                                                                                        
#fi
if [ -z $PLEX_APP ]; then
  echo "PLEX_APP not set so will be set to default 'none'"
  PLEX_APP="none"
fi
if [ -z $WORDPRESS_APP ]; then
  echo "WORDPRESS_APP not set so will be set to default 'none'"
  WORDPRESS_APP="none"
fi

#
# Check if Backup dir exists
#
if [[ ! -d "${POOL_PATH}/${BACKUP_PATH}" ]]; then
   mkdir ${POOL_PATH}/${BACKUP_PATH}
   echo "does not exist"
   echo "directory "${POOL_PATH}/${BACKUP_PATH} "created"
else
   echo "does exist"
   echo "directory "${POOL_PATH}/${BACKUP_PATH} "already exists"
fi
#
# Ask to Backup or restore, if run interactively
# 
if ! [ -t 1 ] ; then
  # Not run interactively
  choice="B"
else
 read -p "Enter '(B)ackup' to backup Nextcloud or '(R)estore' to restore Nextcloud: " choice
fi

echo
if [ "$choice" = "B" ] || [ "$choice" = "b" ]; then
echo "B"
echo
delete=(${SKIP_APPS})
cd ${POOL_PATH}/${APPS_PATH}
shopt -s dotglob
shopt -s nullglob
array=(*)
for target in "${delete[@]}"; do
  for i in "${!array[@]}"; do
    if [[ ${array[i]} = $target ]]; then
      unset 'array[i]'
    fi
  done
done
for dir in "${array[@]}"; do echo "tar "${dir};
GZ=${dir}${BACKUP_NAME}
    if [[ ${dir} = ${PLEX_APP} ]]; then
      tar zcfP ${POOL_PATH}/${BACKUP_PATH}/${GZ} --exclude=./Plex\ Media\ Server/Cache ${POOL_PATH}/${APPS_PATH}/${dir}
     #echo "tar zcfP ${POOL_PATH}/${BACKUP_PATH}/${GZ} --exclude=./Plex\ Media\ Server/Cache ${POOL_PATH}/${APPS_PATH}/${dir}"
    elif [[ ${dir} = ${WORDPRESS_APP} ]]; then
      iocage exec ${WORDPRESS_APP} "mysqldump --single-transaction -h localhost -u "root" -p"${DB_PASSWORD}" "${DATABASE_NAME}" > "/${CONFIG_PATH}/${DB_BACKUP_NAME}""
      echo "Wordpress database backup ${DB_BACKUP_NAME} complete"
      tar zcfP ${POOL_PATH}/${BACKUP_PATH}/${GZ} ${POOL_PATH}/${APPS_PATH}/${dir}
    else
      tar zcfP ${POOL_PATH}/${BACKUP_PATH}/${GZ} ${POOL_PATH}/${APPS_PATH}/${dir}
    fi
  echo ${POOL_PATH}/${BACKUP_PATH}/${GZ}
  echo "Backup complete file located at ${POOL_PATH}/${BACKUP_PATH}/${GZ}"
  echo
done

elif [ "$choice" = "R" ] || [ "$choice" = "r" ]; then
echo "R"
#
# Pick the restore directory *don't edit this section*
#
   RESTORE_DIR=${POOL_PATH}/${BACKUP_PATH}
   cd ${RESTORE_DIR}

   array=($(ls *.tar.gz))
for dir in "${array[@]}"; do echo; done

for dir in */; do echo; done
array+=("ALL")
echo "There are ${#array[@]} backups available pick the one to restore"; \
select dir in "${array[@]}"; do echo; break; done

echo "You choose ${dir}"

# More Variables
restore="${dir%%.*}"
#echo $restore
currentRestoreApp="${dir}"
#echo "currentRestoreAPP $currentRestoreApp"
GZ=${dir}

#
# Check if currentRestoreDir exists
#
     if [ ! -d "${RESTORE_DIR}" ]
     then
         echo "ERROR: Backup ${RESTORE_DIR} not found!"
         exit 1
     fi
if [ $dir == "ALL" ]; then
     echo "you choose ALL"
     unset 'array[${#array[@]}-1]'
  for dir in "${array[@]}";
  do
     restore="${dir%%.*}"
echo "restore=${restore}"
     tar -xzf ${RESTORE_DIR}/${dir} -C /
     echo "tar -xzf "${RESTORE_DIR}/${dir}" -C /"
       if [ $restore == "wordpress" ]; then
         iocage exec ${restore} "mysql -u "root" -p"${DB_PASSWORD}" "${DATABASE_NAME}" < "/${CONFIG_PATH}/${DB_BACKUP_NAME}""
         echo "The database ${DB_BACKUP_NAME} has been restored"
         iocage restart ${restore}
       fi
     echo ${dir}" restored"
     echo
  done
else
   echo ${RESTORE_DIR}
   tar -xzvf ${currentRestoreApp} -C /
#   echo "dir = ${dir}"
#   echo "tar -xzvf "${currentRestoreApp} -C /
       if [ $restore == "wordpress" ]; then
#echo "in the wordpress if statement"
#echo "restore=${restore}"
#echo "DB_PASSWORD=${DB_PASSWORD}"
#echo "DATABASE_NAME=${DATABASE_NAME}"
#echo "DB_BACKUP_NAME=${DB_BACKUP_NAME}"
         iocage exec ${restore} "mysql -u "root" -p"${DB_PASSWORD}" "${DATABASE_NAME}" < "/${CONFIG_PATH}/${DB_BACKUP_NAME}""
         echo "The database ${DB_BACKUP_NAME} has been restored"
         iocage restart ${restore}
       fi
   echo ${dir}" restored"
fi
else
  echo "NONE"
  echo "Must enter '(B)ackup' to backup Plex or '(R)estore' to restore app directory: "
  echo
fi

