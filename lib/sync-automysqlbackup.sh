#!/bin/bash
#This script syncs automysqldump to a specified environment


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


rsync -avz -e "ssh -p $ENV_SSHPORT" $DIR_LOCAL $ENV_SSHUSER@$ENV_HOST:$DIR_SERVER

