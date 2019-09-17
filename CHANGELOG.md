# CHANGELOG

## 2019-09-17

- [FEATURE] Updated images to GVMD 8.0.1 from upstream. [#12](https://github.com/falkowich/gvm10-docker/issues/12) [Falk]
- [BUG] Added dependensies for pdf reports [#10](https://github.com/falkowich/gvm10-docker/issues/10) [Falk]
  
## 2019-04-26

- [FEATURE] [edge]: A build with the live master branch from greenbone gitrepo. [Falk]
- [BUG] [sqlite, psql]: Cherrypicked a fix from upstream from unrealeased GSA 8.0.1. [#3](https://github.com/falkowich/gvm10-docker/issues/3) [Falk]


## 2019-04-23

- [FEATURE] [sqlite, slave]: First WIP with master-slave setups. [Falk]

## 2019-04-21

- [CLEANUP]: A first try to clean up the repo. Moved each active branch into directories in master. [Falk] 

## 2019-04-19

- [FEATURE]: Forked out a new branch with postgresql as backend. [Falk]

## 2019-04-16

- [README]: Updated readme with some goodtohave commands.[Falk]
- [FEATURE]: Updated readme with some docker-compose info.[Falk]

## 2019-04-15

- [BUG]: Sometimes the sslcerts wasn't created.[Falk]
- [BUG]: Start borked when script could not sync data from greenbone.[Falk]
- [BUG]: User is now static with admin/admin.[Falk]
