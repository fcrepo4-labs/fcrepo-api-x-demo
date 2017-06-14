## fcrepo 4.7.1 Dockerfile

Image contains the `fcrepo-webapp-4.7.1.war`, and is available on port `80` by default, available at `/fcrepo/rest`.  `stderr` and `stdout` are directed to the console.

A remote debugger may be connected at any time to port `5006` by default.

If running on a `docker-machine` or using `docker-compose`, remember to publish the ports to the [host](https://docs.docker.com/engine/reference/run/#/expose-incoming-ports).

## Environment variables and default values

* FCREPO_VERSION=4.7.3
* FCREPO_HOST=localhost
* FCREPO_PORT=80
* DEBUG_PORT=5006
* FCREPO_CONTEXT_PATH=/fcrepo
* FCREPO_LOG_LEVEL=INFO

## Exposed ports

* ${FCREPO_PORT}
* ${DEBUG_PORT}

## entrypoint

The [entrypoint](entrypoint.sh) is used to evaluate any environment variables that may have been set at run time, such as `${FCREPO_PORT}` or `${DEBUG_PORT}`.

## Example Usage

#### Starting

Logs displayed to the console, published to port 80, allows container to be killed using CTRL-C.

`$ docker run -ti -p "80:80" fcrepoapix/apix-fcrepo:4.7.3`

Or, published to port 8080:

`$ docker run -ti -p "8080:80" fcrepoapix/apix-fcrepo:4.7.3`

With logging turned up:

`$ docker run -ti -p "80:80" -e FEDORA_LOG_LEVEL=DEBUG fcrepoapix/apix-fcrepo:4.7.3`

#### Debugging

Java remote debugging is enabled by default on `${DEBUG_PORT}` (port 5006).  To use a different debugging port (in this example 4000):

`$ docker run -ti -p "80:80" -p "4000:4000" -e DEBUG_PORT=4000 fcrepoapix/apix-fcrepo:4.7.3`

#### Display logs

Logs are by default echoed out to the console when a container is running.  However, if you're in a different shell window and want to see them:

`$ docker logs <container name>`

#### Obtain a shell

To obtain a shell in a running container, first [start the container](#starting), and then in another shell window run:

`$ docker exec -ti <container name> /bin/ash`

Alternately, to create and shell into a container, override the entrypoint:

`$ docker run -ti --entrypoint=/bin/ash fcrepoapix/apix-fcrepo:4.7.3`
