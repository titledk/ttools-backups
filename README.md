# ttools-backups
Helps you to use Terminal Tools to perform backups.
As local backups are mostly part of the sitesync modules, **this module focuses mainly on remote backups**.


## Installation and setup of backup to separate server

1. Add module: `git submodule add https://github.com/titledk/ttools-backups.git ttools/backups;`
2. Add a `Backups` environment to `config.yml` - this is the environment that we'll be backing up to.
3. Make sure that servers that need to be backed up can access the `Backups` environment!
4. Set up a cronjob, see below

###  Configuration example

```yml
Environments:
  Live:
    Host: "xxx"
    Sshuser: "xxx"
    Repodir: "xxx"
    Backups:
      RemoteBackupPath: "xxx"
      RemoteBackupKeep: 96
  Backups:
    Host: "xxx"
    Repodir: "xxx"
    Sshuser: "xxx"
```



## Cronjob setup

This is a good default, using the default settings:

* every 8 hours a local backup is created, 6 are kept
* every 8 hours a remote backup is created, 24 are kept

```sh
0 4,12,20 * * * /ABSOLUTE_REPO_PATH/ttools/sitesync-core/lib/dump-current-site.sh backup Test
30 0,8,16 * * * /ABSOLUTE_REPO_PATH/ttools/backups/lib/dump-and-sync-current-site.sh Test
```

