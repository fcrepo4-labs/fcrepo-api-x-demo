FROM fcrepoapix/apix-karaf:4.0.7@sha256:b258ee07e6e578fc80b791aa0a02d54bcf18dc94acb7c3b340bea3ea8949f7c7

# The version of API-X features being included in the image
ENV FCREPO_TOOLBOX_VERSION=4.7.2 \
    CAMEL_VERSION=2.18.4 \
    ACTIVEMQ_VERSION=5.14.5 \
    FUSEKI_HOST=fuseki \
    FCREPO_HOST=fcrepo \
    FCREPO_PORT=8080 \
    FCREPO_CONTEXT_PATH=/fcrepo \
    REINDEXING_PORT=9090

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/
RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.fcrepo.camel/toolbox-features/${FCREPO_TOOLBOX_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.camel.karaf/apache-camel/${CAMEL_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.activemq/activemq-karaf/${ACTIVEMQ_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-service-activemq" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-fixity" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-reindexing" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-indexing-triplestore" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-indexing-solr" && \
    bin/stop && \
    mkdir /www


ENV JAVA_DEBUG_PORT=${DEBUG_PORT} \
    FCREPO_BASEURI=http://${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest


# Copy Karaf feature configuration files into the image
COPY cfg/* etc/
COPY deploy/* deploy/

# Update the Karaf logging configuration so that `bin/karaf` will echo logging
# to the console, viewable by `docker logs`

RUN sed -e "s/osgi:/stdout, osgi:/" -i etc/org.ops4j.pax.logging.cfg

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# Launch Karaf with no console
CMD [ "server" ]
