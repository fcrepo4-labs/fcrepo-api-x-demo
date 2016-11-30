FROM fcrepoapix/apix-karaf:4.0.7

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with indexing features"

# The port Karaf will listen on when debugging is enabled
ENV DEBUG_PORT 5010
ENV JAVA_DEBUG_PORT ${DEBUG_PORT}
EXPOSE ${DEBUG_PORT}

# The version of API-X features being included in the image
ENV APIX_VERSION 0.0.1-SNAPSHOT

# The version of Feddora Camel Toolbox being included in the image
ENV FCREPO_CAMEL_VERSION 4.6.0

# The Fedora repository base URI
ENV FCREPO_HOST=fcrepo
ENV FCREPO_PORT=8080
ENV FCREPO_CONTEXT_PATH=/fcrepo
ENV FCREPO_BASEURI=http://${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest

# The Fuseki triplestore base URI
ENV FUSEKI_HOST=fuseki
ENV FUSEKI_PORT=3030
ENV FUSEKI_BASEURI=http://${FUSEKI_HOST}:${FUSEKI_PORT}/fcrepo-triple-index

# API-X base URI
ENV APIX_HOST=apix
ENV APIX_PORT=80
ENV APIX_INTERCEPT_PATH=fcrepo/rest
ENV APIX_BASEURI=http://${APIX_HOST}:${APIX_PORT}/${APIX_INTERCEPT_PATH}

# API-X Re-indexing service
ENV APIX_REINDEXING_SERVICE_URI=http://0.0.0.0:9090/reindexing
EXPOSE 9090

# Update the Karaf logging configuration so that `bin/karaf` will echo logging
# to the console, viewable by `docker logs`

RUN sed -e "s/osgi:/stdout, osgi:/" -i etc/org.ops4j.pax.logging.cfg

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/

# Copy Karaf feature configuration files into the image
COPY cfg/* etc/

# Install indexing-related features from fcrepo-camel-toolbox and fcrepo-api-x

RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.fcrepo.apix/fcrepo-api-x-karaf/${APIX_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.fcrepo.camel/toolbox-features/${FCREPO_CAMEL_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-service-camel" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-service-activemq" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-reindexing" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-api-x-indexing" && \
    bin/stop

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# Launch Karaf with no console, and debugging enabled by default.

CMD [ "server", "debug" ]
