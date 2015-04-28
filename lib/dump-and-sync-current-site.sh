#!/bin/bash
#This script syncs the current site to a specified backup environment


#Getting environment specific vars
ENV='Backups';
if [ "${1}" ]; then
	ENV=$1;
fi


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../.. && pwd )";

#sourcing variables
source $BASEDIR/ttools/sitesync-core/lib/vars.sh;

ENVVARS="$BASEDIR/ttools/core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`

#https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps
#rsync -a dir1/ dir2
#"the contents of dir1"

#TODO this could be made configurable if needed
DIR_LOCAL="$BASEDIR/temp/dumps/latest/";
DIR_SERVER="~/latest-sync";

echo "Now dumping and syncing";

$BASEDIR/ttools/sitesync-core/lib/dump-current-site.sh dump;


RSYNC_CMD="$DIR_LOCAL $ENV_SSHUSER@$ENV_HOST:$DIR_SERVER"
if [ "$ENV_CUSTOM_RSYNCPORTSTR" == "" ]; then
	rsync -avz $RSYNC_CMD
else
	rsync -avz -e "$ENV_CUSTOM_RSYNCPORTSTR" $RSYNC_CMD
fi
