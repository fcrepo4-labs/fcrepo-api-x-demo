#!/bin/sh

# Update the Karaf configuration so that the Maven repository under ${MAVEN_REPO}
# is used by Karaf to discover features.

sed -e "s:^org.ops4j.pax.url.mvn.localRepository=.*:org.ops4j.pax.url.mvn.localRepository=${MAVEN_REPO}:" \
        -i etc/org.ops4j.pax.url.mvn.cfg
rm -rf instances/*
echo "#empty" > /etc/hosts

replace_envs() {
        envsubst < etc/${1} > /tmp/${1}
        mv /tmp/${1} etc/${1} 
}

replace_envs "org.fcrepo.apix.registry.http.cfg"

echo "log4j2.logger.ldpath.name = org.apache.marmotta" >>  etc/org.ops4j.pax.logging.cfg
echo "log4j2.logger.ldpath.level = WARN" >> etc/org.ops4j.pax.logging.cfg
echo "log4j2.logger.ldpath.additivity = false" >> etc/org.ops4j.pax.logging.cfg

# Execute `bin/karaf` with any arguments suppled by CMD
exec bin/karaf "$@"
