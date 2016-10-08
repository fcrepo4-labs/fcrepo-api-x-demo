## build Dockerfile

This image provides a basic build environment for building or running Java 8 projects.  It is built from Ubuntu 16.04 and includes:
* Java 8 (OpenJDK)
* Maven 3.3.x
* git
* bash
* curl

The `mvn` command is aliased to `mvn -Dmaven.repo.local=${MAVEN_REPO}` at _run time_.  This allows a developer to mount their local Maven repository from the host (e.g. `~/.m2/repository`) under the container at the path defined by `${MAVEN_REPO}`.

Maven is used at _image build time_ to execute a basic project build in order to seed the empty Maven repository with commonly used artifacts in an effort to speed up builds that this image may be used for.

### Environment variables and default values

* JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
* MAVEN_REPO=/build/repository
* DEBUG=false
* DEBUG_PORT=5005
* DEBUG_ARG="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=\${DEBUG_PORT}"

The `DEBUG` environment may be overridden by child images, or set at runtime.  `DEBUG_ARG` should be evaluated at run time, as the user may specify a different value for `DEBUG_PORT`.
