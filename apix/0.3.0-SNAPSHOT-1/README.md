## apix Dockerfile

This image inherits from the [karaf image](../../karaf/4.0.7), so its configuration and environment also hold for this image.  However, this image does have some modifications which facilitate the installation and execution of API-X core features.

The string "apixrepo" is a short cut recognized as the API-X feature repository at `mvn:org.fcrepo.apix/fedora-api-x-karaf/${APIX_VERSION}/xml/features`.  Features from this repository are installed into this Karaf image at _image build time_.

The apix image default debugging port is 5011.  Debugging is enabled by default, but the port will need to be mapped using the `-p` command line argument to `docker run`.

If running on a `docker-machine`, remember to publish the ports to the [host](https://docs.docker.com/engine/reference/run/#/expose-incoming-ports).

## Environment variables and default values

* DEBUG_PORT=5011
* JAVA_DEBUG_PORT=${DEBUG_PORT}
* FCREPO_HOST=fcrepo
* FCREPO_PORT=8080
* FCREPO_CONTEXT_PATH=/fcrepo
* FCREPO_BASEURI=http://${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest
* APIX_VERSION=0.2.0-SNAPSHOT
* PUBLIC_REPOSITORY_PORT=80
* APIX_INTERCEPT_PATH=fcrepo/rest
* PUBLIC_REPOSITORY_BASEURI=http://localhost:${PUBLIC_REPOSITORY_PORT}/${APIX_INTERCEPT_PATH}

*N.B.:* If you want to change the remote debugging port, you will need to set the `JAVA_DEBUG_PORT` environment variable, _not_ `DEBUG_PORT`.

## Exposed ports

* ${DEBUG_PORT}/${JAVA_DEBUG_PORT}
* ${PUBLIC_REPOSITORY_PORT}

## Example Usage

By default this container does _not_ start a Karaf console, and will emit logs to stdout (viewable by `docker logs <container name>`).  By default, a debugger runs on port 5009.

#### Starting a container in the background

No logs emitted to console:
`$ docker run -d fcrepoapix/apix-core`

#### Starting a container in the foreground

Logs emitted to console, allows CTRL-C to stop the container:
`$ docker run -ti fcrepoapix/apix-core`

#### Start a container for debugging purposes

Debugger can then be attached to port 5011, logs emitted to console, allows CTRL-C to stop container:
`$ docker run -p "5011:5011" fcrepoapix/apix-core debug`

To use a different debugging port (in this example 4000):

`$ docker run -ti -e JAVA_DEBUG_PORT=4000 -p "4000:4000" fcrepoapix/apix-core debug`

#### View container console log

`$ docker logs <container name>`

#### Obtain a Karaf console in a running container

`$ docker exec -ti <container name> bin/client`

It seems that backspace (or other keys) do not work when executing the client.  I am not sure why this is.

#### Mount your local Maven repository in a container

Useful when you wish to expose unpublished Maven artifacts or Karaf features to the container.

`$ docker run -ti -v ~/.m2/repository:/build/repository fcrepoapix/apix-core:latest`
