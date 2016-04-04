FROM apix-poc/build

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with a local Maven repository at ${MAVEN_REPO}"

ENV KARAF_RUNTIME /opt/karaf
ENV KARAF_VERSION 4.0.4

RUN export KARAF_DIST=apache-karaf-${KARAF_VERSION}.tar.gz                                                       && \
    curl -L "http://www.apache.org/dyn/closer.lua?filename=karaf/${KARAF_VERSION}/${KARAF_DIST}&action=download"    \
        > /tmp/${KARAF_DIST}                                                                                     && \
    mkdir -p ${KARAF_RUNTIME}                                                                                    && \
    cd ${KARAF_RUNTIME}                                                                                          && \
    tar -xzf /tmp/${KARAF_DIST}                                                                                  && \
    rm -rf /tmp/apache-karaf-${KARAF_VERSION}*

WORKDIR ${KARAF_RUNTIME}/apache-karaf-${KARAF_VERSION}

RUN sed -e "s:^#org.ops4j.pax.url.mvn.localRepository=:org.ops4j.pax.url.mvn.localRepository=${MAVEN_REPO}:"    \
        -i etc/org.ops4j.pax.url.mvn.cfg                                                                     && \
    sed -e "s:^#\(org.ops4j.pax.url.mvn.defaultLocalRepoAsRemote=\)false:\1true:"                               \
        -i etc/org.ops4j.pax.url.mvn.cfg

CMD [ "bin/karaf", "console" ]
