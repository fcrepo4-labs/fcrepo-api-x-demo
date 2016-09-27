FROM emetsger/apix-karaf:latest

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Amherst features"

# Allow the string "acrepo" to be recognized by Karaf as the Amherst feature repository

RUN echo "acrepo=mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" >> etc/org.apache.karaf.features.repos.cfg

# Add the Amherst acrepo as a feature repository, and install all of the features found there on boot

RUN echo "feature:repo-add -i mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" >> etc/shell.init.script

# Add ACDC as a registered features repository by default

#RUN sed -e "s:^\(    mvn\:org.apache.karaf.features/enterprise/${KARAF_VERSION}/xml/features\):\1, \\\
#    mvn\:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features \\\:" \
#        -i etc/org.apache.karaf.features.cfg

EXPOSE 5005
