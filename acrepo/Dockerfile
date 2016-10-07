FROM emetsger/apix-karaf:4.0.6

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Amherst features"

# The port acrepo Karaf will listen on when debugging is enabled

ENV DEBUG_PORT 5008
ENV JAVA_DEBUG_PORT ${DEBUG_PORT}
EXPOSE ${DEBUG_PORT}
EXPOSE 9102

# The port that the Fedora repository is running on (in a separate container)
ENV FCREPO_PORT 8080

# Allow the string "acrepo" to be recognized by Karaf as the Amherst feature repository

RUN echo "acrepo=mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" >> etc/org.apache.karaf.features.repos.cfg

# Add acrepo as a registered features repository by default

RUN sed -e "s:^\(    mvn\:org.apache.karaf.features/enterprise/${KARAF_VERSION}/xml/features\):\1, \\\
    mvn\:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features \\\:" \
        -i etc/org.apache.karaf.features.cfg

# Install all of the latest features found in the acrepo features repository (typically these features will be SNAPSHOT versions)

RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add -i mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features" && \
    bin/stop

# Update the Karaf logging configuration so that `bin/karaf` will echo logging
# to the console, viewable by `docker logs`

RUN sed -e "s/osgi:/stdout, osgi:/" -i etc/org.ops4j.pax.logging.cfg

# Update Amherst configurations

# Change "fcrepo.baseUrl=localhost:8080/fcrepo/rest" to "fcrepo.baseUrl=fcrepo:${FCREPO_PORT}/rest"
#RUN for f in `ls etc/edu.amherst.*` ; do sed -e "s:localhost\:8080/fcrepo/rest:fcrepo\:${FCREPO_PORT}/rest:" -i $f ; done

# localhost:8080/fits to acrepo:8080/fits
#RUN for f in `ls etc/edu.amherst.*` ; do sed -e "s:localhost\:8080/fits:acrepo\:8080/fits:" -i $f ; done

# Change "rest.host=localhost" to "rest.host=acrepo"
RUN for f in `ls etc/edu.amherst.*` ; do sed -e "s:rest\.host=localhost:rest\.host=0\.0\.0\.0:" -i $f ; done

# Change "jms.brokerUrl=tcp://localhost:61616" to "jms.brokerUrl=tcp://fcrepo:61616"
#RUN for f in `ls etc/edu.amherst.*` ; do sed -e "s:localhost\:61616:fcrepo\:61616:" -i $f ; done

# Launch Karaf with no console, and debugging enabled by default.

CMD [ "server", "debug" ]
