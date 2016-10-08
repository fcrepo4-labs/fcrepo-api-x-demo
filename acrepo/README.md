## acrepo Dockerfile

This image inherits from the [karaf image](../karaf/4.0.6), so its configuration and environment also hold for this image.  However, this image does have some modifications which facilitate the installation and execution of Amherst features.

The string "acrepo" is a short cut recognized as the Amherst feature repository at `mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features`.  At _image build time_, all of the latest features (typically SNAPSHOTs) found in the Amherst feature repository are installed into this Karaf image.

The acrepo image default debugging port is 5008.  Debugging is enabled by default, but the port will need to be mapped using the `-p` command line argument to `docker run`.

If running on a `docker-machine`, remember to publish the ports to the [host](https://docs.docker.com/engine/reference/run/#/expose-incoming-ports).

## Example Usage

By default this container does _not_ start a Karaf console, and will emit logs to stdout (viewable by `docker logs <container name>`).

#### Starting a container in the background
No logs emitted to console:
`$ docker run -d emetsger/apix-acrepo`

#### Starting a container in the foreground
Logs emitted to console, allows CTRL-C to stop the container:
`$ docker run -ti emetsger/apix-acrepo`

#### Start a container for debugging purposes
Debugger can then be attached to port 5008, logs emitted to console, allows CTRL-C to stop container:
`$ docker run -p "5008:5008" emetsger/apix-acrepo debug`

To use a different debugging port (in this example 4000):

`$ docker run -ti -e JAVA_DEBUG_PORT=4000 -p "4000:4000" emetsger/apix-acrepo debug`

#### View container console log
`$ docker logs <container name>`

#### Obtain a Karaf console in a running container
`$ docker exec -ti <container name> bin/client`

It seems that backspace (or other keys) do not work when executing the client.  I am not sure why this is.

#### Mount your local Maven repository in a container
`$ docker run -ti -v ~/.m2/repository:/build/repository emetsger/apix-acrepo:latest`

### Environment variables and default values

* DEBUG_PORT=5008
* JAVA_DEBUG_PORT=${DEBUG_PORT}

*N.B.:* If you want to change the remote debugging port, you will need to set the `JAVA_DEBUG_PORT` environment variable, _not_ `DEBUG_PORT`.
