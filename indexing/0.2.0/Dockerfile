FROM fcrepoapix/apix-karaf:4.0.7

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with indexing features"

# The version of API-X features being included in the image
ENV APIX_VERSION=0.2.0-SNAPSHOT \
    APIX_HOST=apix \
    APIX_PORT=80 \
    APIX_INTERCEPT_PATH=fcrepo/rest \
    FCREPO_HOST=fcrepo \
    FCREPO_PORT=8080 \
    FCREPO_CONTEXT_PATH=/fcrepo \
    FUSEKI_HOST=fuseki \
    FUSEKI_PORT=8080 \
    DEBUG_PORT=5010  \
    REINDEXING_PORT=9090

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/
RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.fcrepo.apix/fcrepo-api-x-karaf/${APIX_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-api-x-indexing" && \
    bin/stop


ENV JAVA_DEBUG_PORT=${DEBUG_PORT} \
    APIX_BASEURI=http://${APIX_HOST}:${APIX_PORT}/${APIX_INTERCEPT_PATH} \
    FUSEKI_BASEURI=http://${FUSEKI_HOST}:${FUSEKI_PORT}/fuseki/service-index \
    FCREPO_BASEURI=http://${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest


# Copy Karaf feature configuration files into the image
COPY cfg/* etc/


# Update the Karaf logging configuration so that `bin/karaf` will echo logging
# to the console, viewable by `docker logs`

RUN sed -e "s/osgi:/stdout, osgi:/" -i etc/org.ops4j.pax.logging.cfg

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

EXPOSE ${DEBUG_PORT} ${REINDEXING_PORT}
ENTRYPOINT [ "/entrypoint.sh" ]

# Launch Karaf with no console, and debugging enabled by default.
CMD [ "server", "debug" ]
