# gvm10-docker

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/falkowich/gvm10.svg?style=plastic) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/falkowich/gvm10.svg?style=plastic)  ![Docker Pulls](https://img.shields.io/docker/pulls/falkowich/gvm10.svg?style=plastic)

WIP...

## Download latest image

```docker pull falkowich/gvm10:latest```  

### Test out with non persistant storage and sqlite3

```docker run -p 443:443 falkowich/gvm10:latest```

### Start with mounted volume and sqlite3

This will mount /usr/local/var/lib/gvm/ in /var/lib/docker/volumes/gvm/_data/ as docker volume gvm.

```bash
docker run \
       -p 443:443 \
       -v gvm:/usr/local/var/lib/gvm/ \
        falkowich/gvm10:latest

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

### GSA

user/pass - admin/admin

### Disclamer

This is an unofficial build, just to test out new GVM 10 releases.  
Much info was taken from [mikesplain/openvas-docker](https://github.com/mikesplain/openvas-docker) that makes good production ready container builds.

More images, and better quality are hopefully coming here later :)

## ToDo / Thoughts / Goals

* postgresql build
* docker-compose files.
* better logging?
* separated containers for sql?
* master/slave images?
* openvas-check-setup
* tools like arachni etc
* suggestions are always welcome
