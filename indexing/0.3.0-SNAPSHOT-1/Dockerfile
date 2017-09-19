FROM fcrepoapix/apix-karaf-camel:4.0.9-1@sha256:5f19f8266f2c44ec33e2d962312654e666a85bc6f31343b3fa94e376ff1707fa

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with indexing features"

# The version of API-X features being included in the image
ENV APIX_VERSION=0.3.0-SNAPSHOT \
    FUSEKI_HOST=fuseki \
    FCREPO_HOST=fcrepo \
    FCREPO_PORT=80 \
    FCREPO_CONTEXT_PATH=/fcrepo \
    DEBUG_PORT=5010  \
    REINDEXING_PORT=9090 \
    JAVA_DEBUG_PORT=${DEBUG_PORT} \
    FCREPO_BASEURI=http://${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/
RUN apk add --update --no-cache gettext && \
    bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.fcrepo.apix/fcrepo-api-x-karaf/${APIX_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-api-x-registry" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-api-x-indexing" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-indexing-triplestore" && \
    bin/stop && \
    rm -rf instances/* && \
    rm -rf /build/repository/*

# Copy Karaf feature configuration files into the image
COPY cfg/* etc/

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

EXPOSE ${DEBUG_PORT} ${REINDEXING_PORT}
ENTRYPOINT [ "/entrypoint.sh" ]

# Launch Karaf with no console,

CMD [ "server" ]
