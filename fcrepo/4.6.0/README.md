## fcrepo 4.0.6 Dockerfile

Image contains the `fcrepo-webapp-4.6.0-jetty-console.jar`, and is launched on port `8080` by default.  `stderr` and `stdout` are directed to the console.

If the environment variable named `DEBUG` exists, then a debugger is launched on port `5006` by default.

If running on a `docker-machine`, remember to publish the ports to the [host](https://docs.docker.com/engine/reference/run/#/expose-incoming-ports).

### Environment variables and default values

* FCREPO_VERSION=4.6.0
* FCREPO_RUNTIME=/opt/fcrepo/4.0.6
* FCREPO_PORT=8080
* DEBUG=false
* DEBUG_PORT=5006
* DEBUG_ARG=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=${DEBUG_PORT}
