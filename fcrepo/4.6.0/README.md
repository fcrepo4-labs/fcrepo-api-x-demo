## fcrepo 4.0.6 Dockerfile

Image contains the `fcrepo-webapp-4.6.0-jetty-console.jar`, and is launched on port `8080` by default.  `stderr` and `stdout` are directed to the console.

If the environment variable named `DEBUG` exists, then a debugger is launched on port `5006` by default.

If running on a `docker-machine`, remember to publish the ports to the [host](https://docs.docker.com/engine/reference/run/#/expose-incoming-ports).

## Environment variables and default values

* FCREPO_VERSION=4.6.0
* FCREPO_RUNTIME=/opt/fcrepo/4.0.6
* FCREPO_PORT=8080
* DEBUG_PORT=5006

## Exposed ports

* ${FCREPO_PORT}
* ${DEBUG_PORT}
* 61613 (STOMP protocol)
* 61616 (JMS broker port)

## entrypoint

The [entrypoint](entrypoint.sh) is used to evaluate any environment variables that may have been set at run time, such as `${FCREPO_PORT}` or `${DEBUG_PORT}`.

## Example Usage

#### Starting

Logs displayed to the console, allows container to be killed using CTRL-C.

`$ docker run -ti emetsger/apix-fcrepo:4.6.0`

#### Debugging

Enable Java remote debugging, on `${DEBUG_PORT}`

`$ docker run -ti -e DEBUG emetsger/apix-fcrepo:4.6.0`

#### Display logs

Logs are by default echoed out to the console.  However, if you're in a different shell window and want to see them:

`$ docker logs <container name>`

#### Obtain a shell

To obtain a shell in a running container, first [start the container](#starting), and then in another shell window run:

`$ docker exec -ti <container name> /bin/bash`

Alternately, to simply shell into a non-existent container, override the entrypoint:

`$ docker run -ti --entrypoint=/bin/bash emetsger/apix-fcrepo:4.6.0`
