FROM fcrepoapix/apix-karaf:4.0.7

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Amherst features"
# Needed for -image
RUN apt-get update && apt-get -y install imagemagick && rm -rf /var/lib/apt/lists/* && apt-get purge -y

# The port acrepo Karaf will listen on when debugging is enabled

ENV DEBUG_PORT 5008
ENV JAVA_DEBUG_PORT ${DEBUG_PORT}
EXPOSE ${DEBUG_PORT}
EXPOSE 9102

# The host and port that the Fedora repository is running on (in a separate container)
ENV FCREPO_HOST localhost
ENV FCREPO_PORT 80
ENV FCREPO_CONTEXT_PATH /fcrepo


ADD maven/ /build/repository/

# Install all of the latest features found in the acrepo features repository (typically these features will be SNAPSHOT versions)

RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.activemq/activemq-karaf/5.14.2/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.camel.karaf/apache-camel/2.18.2/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add -i mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" && \
    #bin/client -r 10 -d 5  "feature:install acrepo-exts-image acrepo-exts-pcdm acrepo-exts-serialize-xml acrepo-exts-template acrepo-exts-fits acrepo-exts-jsonld " && \
    /bin/sleep 15 && \
    #[[ \"`bin/client -r 10 -d 5  "feature:list" | grep acrepo | grep -v Started`\" == \"\" ]] && \
    #[[ \"`bin/client -r 10 -d 5  "bundle:list"  | grep acrepo | grep -v Active`\"  == \"\" ]] && \
    bin/stop

COPY cfg/* etc/

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
