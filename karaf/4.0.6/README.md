## karaf 4.0.6 Dockerfile

This image provides a Karaf 4.0.6 instance, configured to use a local Maven repository as a Karaf features repository location.  This allows a developer to install Karaf features into their local Maven repository (i.e. without publishing the features to a repository somewhere on the web), mount the local Maven repository into this container, and ask Karaf to install features from the local Maven repository.

Arguments provided to this image when creating containers are considered as arguments to `bin/karaf`.  The default argument is `console`, which will start Karaf and launch the interactive Karaf console.  If remote debugging is desired, provide the `debug` argument instead of `console`.  By default, a remote debug port will be available on port 5007.

If running on a `docker-machine`, remember to publish the ports to the [host](https://docs.docker.com/engine/reference/run/#/expose-incoming-ports).

### Environment variables and default values

* KARAF_VERSION=4.0.6
* KARAF_RUNTIME=/opt/karaf/${KARAF_VERSION}
* KARAF_DIST=apache-karaf-${KARAF_VERSION}
* DEBUG_PORT=5007
* JAVA_DEBUG_PORT=${DEBUG_PORT}

This image inherits from the [build image](../../build), so its environment is also available.
