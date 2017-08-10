## fuseki Dockerfile

This image provides a Fuseki runtime with two indexes: one available at `/fuseki/service-index` and another available at `/fuseki/fcrepo-triple-index`.

## Environment variables and default values

* FUSEKI_VERSION=3.4.0
* FUSEKI_BASE=/shared/fuseki-data
* DEBUG_PORT=5009

## Exposed ports

* 3030
* ${DEBUG_PORT}

## Example Usage

#### Starting

Logs displayed to the console, allows container to be killed using CTRL-C.

`$ docker run -ti fcrepoapix/apix-fuseki:3.4.0`

#### Display logs

Logs are by default echoed out to the console.  However, if you're in a different shell window and want to see them:

`$ docker logs <container name>`

#### Obtain a shell

To obtain a shell in a running container, first [start the container](#starting), and then in another shell window run:

`$ docker exec -ti <container name> /bin/bash`

Alternately, to simply shell into a non-existent container, override the entrypoint:

`$ docker run -ti --entrypoint=/bin/ash fcrepoapix/apix-fuseki:3.4.0`
