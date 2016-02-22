# Remote backup of all Mysql databases on your Server

_This requires you to have root access to your server_

Start by installing [AutoMySQLBackup](http://sourceforge.net/projects/automysqlbackup/):

On Ubuntu:

	sudo apt-get install automysqlbackup

This should install it, and the cron.


Resources:

	* https://serverpilot.io/community/articles/how-to-back-up-mysql-databases-with-automysqlbackup.html


NOTES:

	#backup location:
	/var/lib/automysqlbackup

	#configuration file:
	/etc/default/automysqlbackup


## Installing the cron job

Automysqlbackup runs as root, and thus we need to make sure that
root can access our remote server.

	#create ssh key for root - if needed, and add it to the backup server
	sudo ssh-keygen
	cat /root/.ssh/id_rsa.pub

Try running this manually with sudo to make sure that you've got the proper
permissions:

	./ttools/backups/lib/sync-automysqlbackup.sh



...then, add to the root cronjob:

	#remember to make it an absolute path
	sudo crontab -e -u root

