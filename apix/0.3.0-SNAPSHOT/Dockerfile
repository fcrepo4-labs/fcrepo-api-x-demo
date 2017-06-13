FROM fcrepoapix/apix-karaf-camel:4.0.9@sha256:130e48a21aaa0ec3c6739dddc69d70dde9a33f5a348bc84121d049367ee05e93

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with API-X features"

ENV APIX_VERSION=0.3.0-SNAPSHOT \
    APIX_PORT=80 \
    APIX_BASEURI=http://localhost:${APIX_PORT}/${APIX_INTERCEPT_PATH} \
    FCREPO_HOST=fcrepo \
    FCREPO_PORT=80 \
    FCREPO_CONTEXT_PATH=fcrepo \
    APIX_PROXY_PATH=fcrepo \
    APIX_INTERCEPT_PATH=fcrepo/rest \
    FCREPO_PROXYURI=http://${FCREPO_HOST}/${FCREPO_CONTEXT_PATH} \
    FCREPO_BASEURI=http://${FCREPO_HOST}/${FCREPO_CONTEXT_PATH}/rest \
    DEBUG_PORT=5011 \
    JAVA_DEBUG_PORT=5011

# API-X base URI
EXPOSE ${APIX_PORT}
EXPOSE ${DEBUG_PORT}

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/

# Install all of the latest features found in the apixrepo features repository (typically these features will be SNAPSHOT versions) ...
# ... but do not create registry containers or attept to index registry content, as the Fedora repository is not available at image build time
RUN export REGISTRY_ONTOLOGY_CREATE=false  && \
    export REGISTRY_EXTENSION_CREATE=false && \
    export REGISTRY_SERVICE_CREATE=false   && \
    export REGISTRY_ONTOLOGY_INDEX=false   && \
    echo "apixrepo=mvn:org.fcrepo.apix/fedora-api-x-karaf/${APIX_VERSION}/xml/features" >> etc/org.apache.karaf.features.repos.cfg && \
    bin/start && \
    bin/client -r 10 -d 5 "feature:repo-add  mvn:org.fcrepo.apix/fcrepo-api-x-karaf/${APIX_VERSION}/xml/features" && \
    bin/client -r 10 -d 5 "feature:install fcrepo-api-x" && \
    bin/stop && \
    rm -rf instances/* && \
    rm -rf /build/repository/*

COPY cfg/* etc/

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# Launch Karaf with no console, and debugging enabled by default.

CMD [ "server" ]
