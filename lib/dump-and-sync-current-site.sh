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
DIR_SERVER="~/sync";
#if a specific server dir has been set for the environment, use that instead
backupPathToEval="Environments_"$FROM_ENV"_Backups_RemoteBackupPath"
if [ "${!backupPathToEval}" != "" ]; then
	DIR_SERVER="${!backupPathToEval}";
fi

#appending "latest" to the sync
DIR_SERVER_LATEST=$DIR_SERVER"/latest";


echo "Now dumping and syncing";

$BASEDIR/ttools/sitesync-core/lib/dump-current-site.sh dump;


RSYNC_CMD="$DIR_LOCAL $ENV_SSHUSER@$ENV_HOST:$DIR_SERVER_LATEST"

if [ "$ENV_CUSTOM_RSYNCPORTSTR" == "" ]; then
	rsync -avz $RSYNC_CMD
else
	rsync -avz -e "$ENV_CUSTOM_RSYNCPORTSTR" $RSYNC_CMD
fi


# Connecting to the server, and making sure x backups are being kept

DUMP_NAME=$(date +"%Y-%m-%d_%H-%M%Z");

KEEP=24;
#if a keep amount has been set for the environment, use that instead
keepPathToEval="Environments_"$FROM_ENV"_Backups_RemoteBackupKeep"
if [ "${!keepPathToEval}" != "" ]; then
	KEEP="${!keepPathToEval}";
fi

echo "Done syncing, now creating a copy with datestamp, and cleaning up (keeping $KEEP dumps)"

#regulating...
KEEP=$(($KEEP+1));

#from http://stackoverflow.com/questions/6024088/linux-save-only-recent-10-folders-and-delete-the-rest
DELETE_STR="cd $DIR_SERVER/dumps; ls -dt */ | tail -n +$KEEP | xargs rm -rf;"

SERVER_COMMANDS="cp -r $DIR_SERVER_LATEST $DIR_SERVER/dumps/$DUMP_NAME;"



#echo $SERVER_COMMANDS;
#echo $DELETE_STR;

#http://thornelabs.net/2013/08/21/simple-ways-to-send-multiple-line-commands-over-ssh.html#using-ssh-with-the-bash-command
ssh $ENV_CUSTOM_SSHCONNECTIONSTR bash -c "'
$SERVER_COMMANDS
$DELETE_STR
'"

