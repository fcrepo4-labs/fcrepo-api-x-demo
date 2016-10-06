FROM emetsger/apix-karaf:latest

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Amherst features"

# Allow the string "acrepo" to be recognized by Karaf as the Amherst feature repository

RUN echo "acrepo=mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" >> etc/org.apache.karaf.features.repos.cfg

# Add acrepo as a registered features repository by default

RUN sed -e "s:^\(    mvn\:org.apache.karaf.features/enterprise/${KARAF_VERSION}/xml/features\):\1, \\\
    mvn\:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features \\\:" \
        -i etc/org.apache.karaf.features.cfg

# Install all of the latest features found in the acrepo features repository (typically these features will be SNAPSHOT versions)

RUN bin/start && \
    bin/client -r 5 "feature:repo-add -i mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" && \
    bin/stop

EXPOSE 5005
