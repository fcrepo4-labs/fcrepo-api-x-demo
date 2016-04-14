FROM emetsger/apix-docker-test:karaf

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Amherst features"

# Locations and versions of Amherst features
ENV ACDC_REPO             https://gitlab.amherst.edu/acdc/repository-extension-services.git
ENV ACDC_COMMIT           master
ENV ACDC_FEATURES_VERSION 1.0.1-SNAPSHOT

# Clone, checkout, and install Amherst features into ${MAVEN_REPO}.
# Clean up after
RUN mkdir /code                                  && \
    cd /code                                     && \
    git clone -n $ACDC_REPO                      && \
    cd repository-extension-services             && \
    git checkout ${ACDC_COMMIT}                  && \
    mvn -Dmaven.repo.local=${MAVEN_REPO} install && \
    mvn clean                                    && \
    cd ..                                        && \
    rm -rf repository-extension-services

# Allow the string "acdc" to be recognized by Karaf as the Amherst ACDC feature repository
# RUN echo "acdc=mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" >> etc/org.apache.karaf.features.repos.cfg

# Add ACDC as a registered features repository by default

RUN sed -e "s:^\(    mvn\:org.apache.karaf.features/enterprise/4.0.4/xml/features\):\1,\n    mvn\:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features:" \
        -i etc/org.apache.karaf.features.cfg

