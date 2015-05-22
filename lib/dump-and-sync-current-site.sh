#!/bin/bash
#This script syncs the current site to a specified backup environment
#This requires the site sync module to be set up properly

# Can be called with FROM_ENV and TO_ENV


FROM_ENV=LOCAL;
if [ "${1}" ]; then
	FROM_ENV=$1;
fi

TO_ENV='Backups';
if [ "${2}" ]; then
	TO_ENV=$2;
fi



BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../.. && pwd )";

#getting configuration variables
VARS="$BASEDIR/ttools/core/lib/vars.sh"
eval `$VARS`

#sourcing variables
source $BASEDIR/ttools/sitesync-core/lib/vars.sh;

#getting vars specifically to the environment we want to sync TO
ENVVARS="$BASEDIR/ttools/core/lib/vars-for-env.sh $TO_ENV"
eval `$ENVVARS`


#https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps
#rsync -a dir1/ dir2
#"the contents of dir1"

#this is where the sitesync module will dump the site to
DIR_LOCAL="$BASEDIR/temp/dumps/latest/";

#Server dir
DIR_SERVER="~/latest-sync";
#if a specific server dir has been set for the environment, use that instead
backupPathToEval="Environments_"$FROM_ENV"_Backups_RemoteBackupPath"
if [ "${!backupPathToEval}" != "" ]; then
	DIR_SERVER="${!backupPathToEval}";
fi


echo "Now dumping and syncing";

$BASEDIR/ttools/sitesync-core/lib/dump-current-site.sh dump;


RSYNC_CMD="$DIR_LOCAL $ENV_SSHUSER@$ENV_HOST:$DIR_SERVER"

if [ "$ENV_CUSTOM_RSYNCPORTSTR" == "" ]; then
	rsync -avz $RSYNC_CMD
else
	rsync -avz -e "$ENV_CUSTOM_RSYNCPORTSTR" $RSYNC_CMD
fi
