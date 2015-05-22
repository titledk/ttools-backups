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



