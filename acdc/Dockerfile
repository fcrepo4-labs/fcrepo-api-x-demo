FROM emetsger/apix-docker-test:karaf

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Amherst features"

ENV ACDC_REPO             https://gitlab.amherst.edu/acdc/repository-extension-services.git
ENV ACDC_COMMIT           master
ENV ACDC_FEATURES_VERSION 1.0.1-SNAPSHOT

RUN mkdir /code                                  && \
    cd /code                                     && \
    git clone -n $ACDC_REPO                      && \
    cd repository-extension-services             && \
    git checkout ${ACDC_COMMIT}                  && \
    mvn -Dmaven.repo.local=${MAVEN_REPO} install && \
    mvn clean                                    && \
    cd ..                                        && \
    rm -rf repository-extension-services
