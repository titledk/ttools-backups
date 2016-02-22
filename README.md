# ttools-backups
Helps you to use Terminal Tools to perform backups.
As local backups are mostly part of the sitesync modules, this module focuses mainly on remote backups.

_We'll be implementing different methods as needed._


## Configure ttools

Add a `Backups` environment to `config.yml`.    
Remote backups will be backed up to that environment.

Make sure that servers that need to be backed up can access the
`Backups` environment!


## Backup methods

See `docs/methods` for implemented methods.


## A good default

This is a good default, using the default settings:

* every 8 hours a local backup is created, 6 are kept
* every 8 hours a remote backup is created, 24 are kept

```sh
0 4,12,20 * * * /ABSOLUTE_REPO_PATH/ttools/sitesync-core/lib/dump-current-site.sh backup Test
30 0,8,16 * * * /ABSOLUTE_REPO_PATH/ttools/backups/lib/dump-and-sync-current-site.sh Test
```

