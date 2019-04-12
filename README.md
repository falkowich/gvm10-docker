# gvm10-docker

WIP...

**no persistant data as of now...**  

```docker pull falkowich/gvm10```  
```docker run -p 443:443 falkowich/gvm10:latest```

### GSA:
user/pass - admin/admin

### Disclamer:
This is an unofficial build, just to test out new GVM 10 releases.  
Much info was taken from https://github.com/mikesplain/openvas-docker that makes good production ready container builds.

More images, and better quality are hopefully coming here later :)

## ToDo / Thoughts / Goals
* postgresql build
* better volume support
* better Dockerfile syntax
* docker-compose files.
* better logging?
* separated containers for sql?
* master/slave images?
* openvas-check-setup 
* tools like arachni etc
* suggestions are always welcome