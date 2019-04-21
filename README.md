# gvm10-docker

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/falkowich/gvm10.svg?style=plastic) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/falkowich/gvm10.svg?style=plastic)  ![Docker Pulls](https://img.shields.io/docker/pulls/falkowich/gvm10.svg?style=plastic)

- [gvm10-docker](#gvm10-docker)
  - [Sqlite3 DB backend](#sqlite3-db-backend)
    - [Use with "docker run"](#use-with-%22docker-run%22)
      - [Start with non-persistant storage](#start-with-non-persistant-storage)
      - [Start with mounted volume](#start-with-mounted-volume)
  - [PostgrSQL DB backend](#postgrsql-db-backend)
    - [Use with "docker run"](#use-with-%22docker-run%22-1)
      - [Start with non-persistant storage](#start-with-non-persistant-storage-1)
      - [Start with mounted volume](#start-with-mounted-volume-1)
  - [Use with docker-compose](#use-with-docker-compose)
    - [Start in frontend](#start-in-frontend)
    - [Start in backend](#start-in-backend)
    - [Check logs](#check-logs)
  - [Maintanance](#maintanance)
    - [With docker-compose](#with-docker-compose)
    - [With docker](#with-docker)
  - [GSA](#gsa)
  - [Disclamer](#disclamer)
  - [ToDo / Thoughts / Goals](#todo--thoughts--goals)
  - [Done [sorta]](#done-sorta)

Suggestions and bugreports are always welcome, just post an issue over at [falkowich/gvm10-docker](https://github.com/falkowich/gvm10-docker)

## Sqlite3 DB backend

```docker pull falkowich/gvm10:sqlite```  

### Use with "docker run"

#### Start with non-persistant storage

```docker run -p 443:443 falkowich/gvm10:sqlite```

#### Start with mounted volume

This will mount /usr/local/var/lib/gvm/ in /var/lib/docker/volumes/gvm/_data/ as docker volume gvm.  
**WARNING** - This volume will be lost if/when container is pruned

```bash
docker run \
       -p 443:443 \
       -v gvm:/usr/local/var/lib/gvm/ \
       --name gvm10 \
       falkowich/gvm10:sqlite
```

To check out info about the volume

```bash
docker volume inspect gvm
[
    {
        "CreatedAt": "2019-04-13T19:22:15+02:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/gvm/_data",
        "Name": "gvm",
        "Options": null,
        "Scope": "local"
    }
]
```

## PostgrSQL DB backend

```docker pull falkowich/gvm10:psql```  

### Use with "docker run"

#### Start with non-persistant storage

```docker run -p 443:443 falkowich/gvm10:psql```

#### Start with mounted volume

**WARNING** - These volumes will be lost if/when container is pruned

```bash
docker run \
       -p 443:443 \
       -v gvm:/usr/local/var/lib/gvm \
       -v psql:/var/lib/postgresql/data \
       --name gvm10 \
       falkowich/gvm10:psql
```

To check out info about the volume

```bash
docker volume inspect gvm
[
    {
        "CreatedAt": "2019-04-13T19:22:15+02:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/gvm/_data",
        "Name": "gvm",
        "Options": null,
        "Scope": "local"
    }
]
```

## Use with docker-compose

### Start in frontend

```docker-compose up```

### Start in backend

```docker-compose up -d```

### Check logs

```docker-compose logs -f```

## Maintanance

### With docker-compose

Sync SCAP data  
```docker-compose exec gvm10 /usr/local/sbin/greenbone-scapdata-sync```

Sync CERT data  
```docker-compose exec gvm10 /usr/local/sbin/greenbone-certdata-sync```

Sync NVT data  
```docker-compose exec gvm10 /usr/local/sbin/greenbone-nvt-sync```

DB maintanance (vacuum, analyze, cleanup-config-prefs, cleanup-port-names, cleanup-result-severities, cleanup-schedule-times, rebuild-report-cache or update-report-cache)  
```docker-compose exec gvm10 /usr/local/sbin/gvmd -v --optimize=vacuum```

Change admin password  
```docker-compose exec gvm10 /usr/local/sbin/gvmd -v --user=admin --new-password=super-secret-password```

### With docker

Sync SCAP data  
```docker exec -i gvm10 sh -c "/usr/local/sbin/greenbone-scapdata-sync"```

Sync CERT data  
```docker exec -i gvm10 sh -c "/usr/local/sbin/greenbone-certdata-sync"```

Sync NVT data  
```docker exec -i gvm10 sh -c "/usr/local/sbin/greenbone-nvt-sync"```

DB maintanance (vacuum, analyze, cleanup-config-prefs, cleanup-port-names, cleanup-result-severities, cleanup-schedule-times, rebuild-report-cache or update-report-cache)  
```docker exec -i gvm10 sh -c "/usr/local/sbin/gvmd -v --optimize=vacuum"```

Change admin password  
```docker exec -i gvm10 sh -c "/usr/local/sbin/gvmd -v --user=admin --new-password=super-secret-password"```

## GSA

user/pass - admin/admin

## Disclamer

This is an unofficial build and my try to build gvm10 docker containers.  
One goal is to get a working master/slave setup, with a sane workflow.  
Hopefully an usable ansible playbook that can help with the slaves..
But then, perhaps it doesn't get more interesting than this :)

Much info was learned from [mikesplain/openvas-docker](https://github.com/mikesplain/openvas-docker) that makes good production ready container builds.

## ToDo / Thoughts / Goals

- Fix workflow with testing before build.. _(..Lots of PEBKAC tonight..)_
- docker-compose files.
- better logging?
- master/slave images?
- openvas-check-setup type of check?
- tools like arachni etc

## Done [sorta]

- ~~postgresql build~~
- ~~separated containers for sql? (scrapped for the moment)~~
- ~~better volume support~~
