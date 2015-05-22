# Dump and sync current site

**This requires the site sync module to be set up properly**


If the backup server has been properly configured as described in the README,
you can set a cron job up like this:

	30 0,4,8,12,16,20 * * * /ABSOLUTE_REPO_PATH/ttools/backups/lib/dump-and-sync-current-site.sh

Of course try it out before you just let cron do it's thing.
This one will sync every 4 hours, but you can set things up as you please.
