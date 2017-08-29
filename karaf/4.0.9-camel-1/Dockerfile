FROM fcrepoapix/apix-karaf:4.0.9@sha256:d0a2910efaa3b97b508ca80225377ba2ce07a66078e61364d291b731f1bea1e8

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Camel and Activemq pre-loaded"

# Camel and Activemq versions
ENV CAMEL_VERSION=2.19.2 \
    ACTIVEMQ_VERSION=5.15.0 

RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.camel.karaf/apache-camel/${CAMEL_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.activemq/activemq-karaf/${ACTIVEMQ_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:install activemq-camel" && \
    bin/client -r 10 -d 5  "feature:install camel-http4" && \
    bin/client -r 10 -d 5  "feature:install camel-jetty" && \
    bin/stop && \
    rm -rf instances/* && \
    rm -rf /build/repository/*
