FROM openjdk:8u131-jre-alpine

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with a local Maven repository at ${MAVEN_REPO}"

# The port Karaf will listen on when debugging is enabled.
#
# Karaf actually pays attention to the value of JAVA_DEBUG_PORT, but in order
# to be consistent with the environment variable (DEBUG_PORT) documented and
# presented in the build/Dockerfile, assign the value of DEBUG_PORT to
# JAVA_DEBUG_PORT
ENV KARAF_VERSION=4.0.9 \
    MAVEN_REPO=/build/repository \
    KARAF_RUNTIME=/opt/karaf \
    DEBUG_PORT=5007 \
    JAVA_DEBUG_PORT=5007 

EXPOSE ${DEBUG_PORT}
EXPOSE ${JAVA_DEBUG_PORT}

# Download and install Karaf, then clean up.
#
# Update the Karaf configuration so that the Maven repository under ${MAVEN_REPO}
# is used by Karaf to discover features.
#
# Start Karaf, run a simple command with the client (to verify that Karaf
# started) then stop it.  This establishes some kind of state that enables
# commands to be scripted on container initialization
# See https://goo.gl/5VfWsn
RUN export KARAF_DIST=apache-karaf-${KARAF_VERSION}.tar.gz                         && \
    echo "http://dl-3.alpinelinux.org/alpine/v3.6/main/" > /etc/apk/repositories && \
    echo "http://dl-3.alpinelinux.org/alpine/v3.6/community/" > /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.6/main/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.6/community/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.6/main/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.6/community/" >> /etc/apk/repositories && \
    apk --no-cache add --update curl && \
    curl -SL "http://archive.apache.org/dist/karaf/${KARAF_VERSION}/${KARAF_DIST}"    \
        > /tmp/${KARAF_DIST}                                                       && \
    mkdir -p ${KARAF_RUNTIME}                                                      && \
    cd ${KARAF_RUNTIME}                                                            && \
    tar -xzf /tmp/${KARAF_DIST}                                                    && \
    rm -rf /tmp/apache-karaf-${KARAF_VERSION}*                                     && \
    cd ${KARAF_RUNTIME}/apache-karaf-${KARAF_VERSION}                              && \
    sed -e "s:^#org.ops4j.pax.url.mvn.localRepository=:org.ops4j.pax.url.mvn.localRepository=${MAVEN_REPO}:"     \
        -i etc/org.ops4j.pax.url.mvn.cfg                                                                      && \
    sed -e "s:^#\(org.ops4j.pax.url.mvn.defaultLocalRepoAsRemote=\)false:\1true:"                                \
        -i etc/org.ops4j.pax.url.mvn.cfg && \
    bin/start                            && \
    bin/client -r 10 -d 5 system:version && \
    bin/stop && \
    rm -rf instances/* && \
    sed -e "s/osgi:/stdout, osgi:/" -i etc/org.ops4j.pax.logging.cfg


WORKDIR ${KARAF_RUNTIME}/apache-karaf-${KARAF_VERSION}

# Launch Karaf...
ENTRYPOINT [ "bin/karaf" ]

# ...with arguments provided by CMD
CMD [ "console" ]
