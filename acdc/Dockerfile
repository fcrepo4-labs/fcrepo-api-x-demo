FROM apix-poc/karaf

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Amherst features"

ENV ACDC_FEATURES_VERSION 1.0.0

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:get                        \
          -Dmaven.repo.local=${MAVEN_REPO}                                               \
          -Dartifact=edu.amherst.acdc:acrepo-karaf:${ACDC_FEATURES_VERSION}:xml:features 

