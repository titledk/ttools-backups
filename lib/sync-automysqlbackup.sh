#!/bin/bash
#This script syncs automysqldump to a specified backup environment


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
DIR_LOCAL="/var/lib/automysqlbackup/";
DIR_SERVER="~/automysqlbackup-sync";

echo "Now syncing automysql backup";
echo "---";
echo "HELP: Run from root cron like this:"
echo "$BASEDIR/ttools/backups/lib/sync-automysqlbackup.sh";
echo "---";

#TODO the port part should be configurable
rsync -avz -e "ssh -p $ENV_SSHPORT" $DIR_LOCAL $ENV_SSHUSER@$ENV_HOST:$DIR_SERVER

