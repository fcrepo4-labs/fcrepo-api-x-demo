FROM emetsger/apix-karaf:4.0.6

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Amherst features"

# The port acrepo Karaf will listen on when debugging is enabled

ENV DEBUG_PORT 5008
ENV JAVA_DEBUG_PORT ${DEBUG_PORT}
EXPOSE ${DEBUG_PORT}
EXPOSE 9102

# The host and port that the Fedora repository is running on (in a separate container)
ENV FCREPO_HOST localhost
ENV FCREPO_PORT 80
ENV FCREPO_CONTEXT_PATH /fcrepo

# Allow the string "acrepo" to be recognized by Karaf as the Amherst feature repository

RUN echo "acrepo=mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" >> etc/org.apache.karaf.features.repos.cfg

# Add acrepo as a registered features repository by default

RUN sed -e "s:^\(    mvn\:org.apache.karaf.features/enterprise/${KARAF_VERSION}/xml/features\):\1, \\\
    mvn\:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features \\\:" \
        -i etc/org.apache.karaf.features.cfg

# Install all of the latest features found in the acrepo features repository (typically these features will be SNAPSHOT versions)

RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add -i mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" && \
    sleep 15 && \
    #[[ \"`bin/client -r 10 -d 5  "feature:list" | grep acrepo | grep -v Started`\" == \"\" ]] && \
    #[[ \"`bin/client -r 10 -d 5  "bundle:list"  | grep acrepo | grep -v Active`\"  == \"\" ]] && \
    bin/stop

# Update the Karaf logging configuration so that `bin/karaf` will echo logging
# to the console, viewable by `docker logs`.  This makes using the Karaf console
# difficult, so the recommended way to obtain the Karaf console is to use
# `docker exec -ti <container> bin/client` after the container has been started
# by `docker run`

RUN sed -e "s/osgi:/stdout, osgi:/" -i etc/org.ops4j.pax.logging.cfg

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# Launch Karaf with no console, and debugging enabled by default.

CMD [ "server", "debug" ]
