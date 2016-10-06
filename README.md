Provides Docker images and orchestration for various Fedora API-X components.

## [build](build/)
A base image, built from Ubuntu 16.04 (for various reasons, but mainly because Karaf 4.0.6+ requires glibc, and cannot use musl), containing a Java 8 build environment with Maven.

## [fcrepo 4.6.0](fcrepo/4.6.0)
Extends the base image, and provides a default-configured Fedora 4.6.0 runtime on port 8080.  Debugging the runtime is possible by supplying an environment variable named "DEBUG".

## [karaf 4.0.6](karaf/4.0.6)
Extends the base image, and provides a Karaf container running version 4.0.6.  Debugging the runtime is possible by supplying 'debug' as an argument to `docker run`.

## [acrepo](acrepo/)
Extends the _karaf_ image, and provides a Karaf container with the Amherst features already intalled and running.
