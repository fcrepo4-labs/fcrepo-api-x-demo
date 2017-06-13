FROM fcrepoapix/apix-karaf-camel:4.0.9@sha256:bbea3acdab13f6f6a321b1b9e08e2ce1af4e741f2ca31b36014f087f0fefa1a6

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Karaf container configured with Amherst features"

# The host and port that the Fedora repository is running on (in a separate container)
ENV ACREPO_VERSION=1.1.0 \
    FCREPO_CAMEL_VERSION=4.5.0 \
    FCREPO_HOST=localhost \
    FCREPO_PORT=80 \
    DEBUG_PORT=5008 \
    JAVA_DEBUG_PORT=5008 \
    FCREPO_CONTEXT_PATH=/fcrepo 

#ADD maven/docke /build/repository/

# Install all of the latest features found in the acrepo features repository)
RUN apk --no-cache add --update imagemagick  && \ 
    echo "acrepo=mvn:edu.amherst.acdc/acrepo-karaf/${ACREPO_VERSION}/xml/features" >> etc/org.apache.karaf.features.repos.cfg && \
    sed -e "s:^\(    mvn\:org.apache.karaf.features/enterprise/${KARAF_VERSION}/xml/features\):\1, \\\
    mvn\:edu.amherst.acdc/acrepo-karaf/${ACREPO_VERSION}/xml/features \\\:" \
        -i etc/org.apache.karaf.features.cfg && \
    bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:edu.amherst.acdc/acrepo-karaf/${ACREPO_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.fcrepo.camel/fcrepo-camel/${FCREPO_CAMEL_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:install camel fcrepo-camel acrepo-exts-ore acrepo-exts-image acrepo-exts-pcdm acrepo-exts-fits acrepo-exts-serialize-xml" && \
    /bin/sleep 15 && \
    bin/stop && \
    rm -rf instances/*

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# Launch Karaf with no console

CMD [ "server" ]
