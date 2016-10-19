#!/bin/bash

# Update the Karaf configuration so that the Maven repository under ${MAVEN_REPO}
# is used by Karaf to discover features.

sed -e "s:^org.ops4j.pax.url.mvn.localRepository=.*:org.ops4j.pax.url.mvn.localRepository=${MAVEN_REPO}:" \
        -i etc/org.ops4j.pax.url.mvn.cfg

# Update Amherst configurations

# Change "fcrepo.baseUrl=localhost:8080/fcrepo/rest" to "fcrepo.baseUrl=fcrepo:${FCREPO_PORT}/rest"
for f in `ls etc/edu.amherst.*` ;
do
  sed -e "s:localhost\:8080/fcrepo/rest:fcrepo\:${FCREPO_PORT}/rest:" -i $f
done

# localhost:8080/fits to 0.0.0.0:8080/fits
for f in `ls etc/edu.amherst.*` ;
do
    sed -e "s:localhost\:8080/fits:0\.0\.0\.0\:8080/fits:" -i $f
done

# Change "rest.host=localhost" to "rest.host=0.0.0.0"
for f in `ls etc/edu.amherst.*` ;
do
    sed -e "s:rest\.host=localhost:rest\.host=0\.0\.0\.0:" -i $f
done

# Change "jms.brokerUrl=tcp://localhost:61616" to "jms.brokerUrl=tcp://fcrepo:61616"
for f in `ls etc/edu.amherst.*` ;
do
    sed -e "s:localhost\:61616:fcrepo\:61616:" -i $f
done

# Execute `bin/karaf` with any arguments suppled by CMD
exec bin/karaf "$@"
