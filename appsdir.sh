#!/bin/bash
#
# Initialize Variables
#
cron=""
POOL_PATH="/mnt/v1"
APPS_PATH="apps"
BACKUP_PATH="temp"
BACKUP_NAME="apps.tar.gz"
SKIP_APPS="plexpass urbackup sonarr radarr lidarr"


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
# Ask to Backup or restore, if cron=yes just backup
#
if [ "$cron" = "yes" ]; then
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
#for del in ${delete[@]}
#do
#   array=("${array[@]/$del}") #Quotes when working with strings                                 
#done
for target in "${delete[@]}"; do
  for i in "${!array[@]}"; do
    if [[ ${array[i]} = $target ]]; then
      unset 'array[i]'
    fi
  done
done
for dir in "${array[@]}"; do echo "tar "${dir};
GZ=${dir}${BACKUP_NAME}
  tar zcfP ${POOL_PATH}/${BACKUP_PATH}/${GZ} ${POOL_PATH}/${APPS_PATH}/${dir}
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
restore=$dir
currentRestoreApp="${RESTORE_DIR}/${restore}"
#echo $currentRestoreApp

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
     tar -xzvf ${RESTORE_DIR}/${dir} -P -C /
    #echo "tar -xzvf "${RESTORE_DIR}/${dir} -P -C /
     echo ${dir}" restored"
     echo
  done
else
   tar -xzvf ${currentRestoreApp} -P -C /
  #echo "tar -xzvf "${currentRestoreApp} -P -C /
   echo ${dir}" restored"
fi
else
  echo "NONE"
  echo "Must enter '(B)ackup' to backup Plex or '(R)estore' to restore app directory: "
  echo
fi
