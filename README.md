# gvm10-docker

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/falkowich/gvm10.svg?style=plastic) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/falkowich/gvm10.svg?style=plastic)  ![Docker Pulls](https://img.shields.io/docker/pulls/falkowich/gvm10.svg?style=plastic)

- [gvm10-docker](#gvm10-docker)
  - [Some examples and info](#some-examples-and-info)
  - [Sqlite3 DB backend](#sqlite3-db-backend)
    - [Use with "docker run"](#use-with-%22docker-run%22)
      - [Start with non-persistant storage](#start-with-non-persistant-storage)
      - [Start with mounted volume](#start-with-mounted-volume)
  - [PostgrSQL DB backend](#postgrsql-db-backend)
      - [Start with mounted volume](#start-with-mounted-volume-1)
  - [Use with docker-compose](#use-with-docker-compose)
    - [Start in frontend](#start-in-frontend)
    - [Check logs](#check-logs)
    - [With docker](#with-docker)
  - [Disclamer](#disclamer)
  - [ToDo / Thoughts / Goals](#todo--thoughts--goals)
  - [Done [sorta]](#done-sorta)

Suggestions and bugreports are always welcome, just post an issue over at [falkowich/gvm10-docker](https://github.com/falkowich/gvm10-docker)  

## Some examples and info

I tried to do a writeup how to use these images in a _(hopefully)_ working environment on [sadsloth.net](https://sadsloth.net/post/gmv10dockermasterslave/).

## Sqlite3 DB backend

```docker pull falkowich/gvm10:sqlite```  

And if you want to try out "bleeding edge", master branch

```docker pull falkowich/gvm10:edge```  

### Use with "docker run"

#### Start with non-persistant storage

```docker run -p 443:443 falkowich/gvm10:sqlite```

```docker pull falkowich/gvm10:edge```  

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

```bash
docker run \
       -p 443:443 \
       -v gvm:/usr/local/var/lib/gvm/ \
       --name gvm10 \
       falkowich/gvm10:edge
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

Update to "latest" image
```bash
docker-compose stop
docker-compose pull
docker-compose up -d
```

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

## Master - Slave setup [take 1 :)]

I tried to do a writeup how to use these images in a _(hopefully)_ working environment on [sadsloth.net](https://sadsloth.net/post/gmv10dockermasterslave/).

### Master Setup

```bash
docker run \
       -p 443:443 \
       -p 9391:9391 \
       -v gvm:/usr/local/var/lib/gvm \
       -v psql:/var/lib/postgresql/data \
       --name gvm10 \
       falkowich/gvm10:psql
```

### Slave Setup

```bash
docker run \
       -p 9391:9391 \
       -v gvm:/usr/local/var/lib/gvm/ \
       falkowich/gvm10:slave
```

Then on the slave (scanner):  
```docker exec -i gvm10 sh -c "/usr/local/sbin/gvmd -v --create-user=scanner-user"```

Write down password or change to another one.  
``` User created with password 'ca3c6307-c8d8-4b96-83c5-cdaffd803671'. ```

Create a scanner in GSAD on the **MASTER** (I will checkout the cli way): 
Configuration > Scanners > New Scanner:  
```
Name: Scanner01 
Comment: Remote Scanner   
Type: GMP Scanner 
Host: IP on slave  
Credentials: New Credentials 

  Name: Slave01 Credentials  
  Comment: Foo Bar 
  Username: scanner-user 
  Password: ca3c6307-c8d8-4b96-83c5-cdaffd803671  
  [save]  
[save]
```

On the **MASTER**:  
```docker exec -i gvm10 sh -c "/usr/local/sbin/gvmd --get-scanners"```  

Then you will get the newly created Scanner01, like this:  
```33d23dc3-00f1-4e4a-82da-1f003303c322  Scanner01```

From the **SLAVE** copy  /var/lib/docker/volumes/gvm/_data/CA/cacert.pem to the **MASTER** for example to /tmp/scanner01-cacert.pem

On the **MASTER**:  
```sudo cp /tmp/scanner01-cacert.pem /var/lib/docker/volumes/gvm/_data/CA/ -arv```

Then on the **MASTER**:  
```docker exec -i gvm10 sh -c "/usr/local/sbin/gvmd --modify-scanner=33d23dc3-00f1-4e4a-82da-1f003303c322 --scanner-ca-pub=/usr/local/var/lib/gvm/CA/scanner01-cacert.pem```

Now you should be able to start scans from the MASTER and select scanner01 as scanner :)

_This will be rewritten, with better information_

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
