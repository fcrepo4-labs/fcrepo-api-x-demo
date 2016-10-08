FROM emetsger/apix-build:latest

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with a local Maven repository at ${MAVEN_REPO}"

# Location of the Karaf installation in the docker container
ENV KARAF_RUNTIME /opt/karaf

# The version of Karaf to download and install in the container
ENV KARAF_VERSION 4.0.6

# The port Karaf will listen on when debugging is enabled.
#
# Karaf actually pays attention to the value of JAVA_DEBUG_PORT, but in order
# to be consistent with the environment variable (DEBUG_PORT) documented and
# presented in the build/Dockerfile, assign the value of DEBUG_PORT to
# JAVA_DEBUG_PORT
ENV DEBUG_PORT 5007
ENV JAVA_DEBUG_PORT=${DEBUG_PORT}
EXPOSE ${DEBUG_PORT}
EXPOSE ${JAVA_DEBUG_PORT}

# Download and install Karaf, then clean up.
RUN export KARAF_DIST=apache-karaf-${KARAF_VERSION}.tar.gz                         && \
    curl -SL "http://archive.apache.org/dist/karaf/${KARAF_VERSION}/${KARAF_DIST}"    \
        > /tmp/${KARAF_DIST}                                                       && \
    mkdir -p ${KARAF_RUNTIME}                                                      && \
    cd ${KARAF_RUNTIME}                                                            && \
    tar -xzf /tmp/${KARAF_DIST}                                                    && \
    rm -rf /tmp/apache-karaf-${KARAF_VERSION}*

WORKDIR ${KARAF_RUNTIME}/apache-karaf-${KARAF_VERSION}

# Update the Karaf configuration so that the Maven repository under ${MAVEN_REPO}
# is used by Karaf to discover features.
RUN sed -e "s:^#org.ops4j.pax.url.mvn.localRepository=:org.ops4j.pax.url.mvn.localRepository=${MAVEN_REPO}:"     \
        -i etc/org.ops4j.pax.url.mvn.cfg                                                                      && \
    sed -e "s:^#\(org.ops4j.pax.url.mvn.defaultLocalRepoAsRemote=\)false:\1true:"                                \
        -i etc/org.ops4j.pax.url.mvn.cfg

# Start Karaf, run a simple command with the client (to verify that Karaf
# started) then stop it.  This establishes some kind of state that enables
# commands to be scripted on container initialization
# See https://goo.gl/5VfWsn

RUN bin/start                            && \
    bin/client -r 10 -d 5 system:version && \
    bin/stop

# Launch Karaf...
ENTRYPOINT [ "bin/karaf" ]

# ...with arguments provided by CMD
CMD [ "console" ]
