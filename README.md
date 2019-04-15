# gvm10-docker

WIP...

### Pull and run

```docker pull falkowich/gvm10:lastest```  

#### Test out with non persistant storage and sqlite3

```docker run -p 443:443 falkowich/gvm10:latest```

#### Start with mounted volume and sqlite3

This will mount /usr/local/var/lib/gvm/ in /var/lib/docker/volumes/gvm/_data/ as docker volume gvm.

```
docker run \
       -p 443:443 \
       -v gvm:/usr/local/var/lib/gvm/ \
        falkowich/gvm10:latest

```

To check out info about the volume

``` 
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

### GSA:
user/pass - admin/admin

### Disclamer:
This is an unofficial build, just to test out new GVM 10 releases.  
Much info was taken from https://github.com/mikesplain/openvas-docker that makes good production ready container builds.

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
