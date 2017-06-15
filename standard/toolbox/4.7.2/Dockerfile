FROM fcrepoapix/apix-karaf-camel:4.0.9@sha256:130e48a21aaa0ec3c6739dddc69d70dde9a33f5a348bc84121d049367ee05e93

# The version of API-X features being included in the image
ENV FCREPO_TOOLBOX_VERSION=4.7.2 \
    FUSEKI_HOST=fuseki \
    FCREPO_HOST=fcrepo \
    FCREPO_PORT=8080 \
    FCREPO_CONTEXT_PATH=/fcrepo \
    REINDEXING_PORT=9090

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/
RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.fcrepo.camel/toolbox-features/${FCREPO_TOOLBOX_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-service-activemq" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-fixity" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-reindexing" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-indexing-triplestore" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-indexing-solr" && \
    bin/stop && \
    rm -rf instances/* && \
    rm -rf /build/repository/* && \
    mkdir /www


ENV JAVA_DEBUG_PORT=${DEBUG_PORT} \
    FCREPO_BASEURI=http://${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest


# Copy Karaf feature configuration files into the image
COPY cfg/* etc/
COPY deploy/* deploy/

# Temporary for local development; copy any Maven artifacts into `maven/` that you want the image build process to see (e.g. locally build features that have yet to be published)
#ADD maven/ /build/repository/

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# Launch Karaf with no console
CMD [ "server" ]
