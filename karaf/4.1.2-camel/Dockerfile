FROM fcrepoapix/apix-karaf:4.1.2@sha256:c3c9cf96ea2c77446bd46078b39e2b721e131051ba13057f52424a4a1a3edd7f

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Camel and Activemq pre-loaded"

# Camel and Activemq versions
ENV CAMEL_VERSION=2.19.2 \
    ACTIVEMQ_VERSION=5.15.0 

RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.camel.karaf/apache-camel/${CAMEL_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.activemq/activemq-karaf/${ACTIVEMQ_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:install camel" && \
    bin/client -r 10 -d 5  "feature:install activemq-camel" && \
    bin/client -r 10 -d 5  "feature:install camel-http4" && \
    bin/client -r 10 -d 5  "feature:install camel-jetty" && \
    bin/stop && \
    rm -rf instances/* && \
    rm -rf /build/repository/*
