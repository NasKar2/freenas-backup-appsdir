#!/usr/local/bin/bash

#while read p; do
#  echo "$p";
  # tar here
#done < configs.txt 
#exit


#
# Initialize Variables
#
cron=""
POOL_PATH="/mnt/v1"
APPS_PATH="apps"
BACKUP_PATH="temp"
BACKUP_NAME="apps.tar.gz"
DELETE_APPS="plexpass urbackup sonarr radarr lidarr"


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
#if [ -z $DELETE_APPS ]; then
#  echo 'Configuration error: DELETE_APPS must be set'
#  exit 1                                                                                                        
#fi

if [[ "$cron" != "yes" ]]; then
 read -p "Enter '(B)ackup' to backup Plex or '(R)estore' to restore app directory: " choice
fi
echo

if [[ "${cron}" == "yes" ]]; then
    choice="B"
fi

#
# Check if Backup dir exists
#
if [[ ! -d "${POOL_PATH}/${BACKUP_PATH}" ]]; then
   mkdir ${POOL_PATH}/${BACKUP_PATH}
   echo "does not exist"
   echo "directory "${POOL_PATH}/${BACKUP_PATH} "does not exist"
else
   echo "does exist"
   echo "directory "${POOL_PATH}/${BACKUP_PATH} "already exists"
fi

echo

if [[ ${choice} == "B" ]] || [[ ${choice} == "b" ]]; then
delete=(${DELETE_APPS})
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
elif [[ $choice == "R" ]] || [[ $choice == "r" ]]; then
echo ${POOL_PATH}/${BACKUP_PATH}
cd ${POOL_PATH}/${BACKUP_PATH}
array=($(ls *.tar.gz))
for dir in "${array[@]}"; do echo ${dir};
GZ=${dir}${BACKUP_NAME}
  tar zcfP ${POOL_PATH}/${BACKUP_PATH}/${GZ} ${POOL_PATH}/${APPS_PATH}/${dir}
  echo ${POOL_PATH}/${BACKUP_PATH}/${GZ}
  echo "Backup complete file located at ${POOL_PATH}/${BACKUP_PATH}/${GZ}"
  echo
done


#tar zvxf ${POOL_PATH}/${BACKUP_PATH}/${BACKUP_NAME} -C ${POOL_PATH}/${APPS_PATH}/${PLEX_DESTINATION}
echo "restore"
else
  echo "Must enter '(B)ackup' to backup Plex or '(R)estore' to restore app directory: "
  echo
fi
