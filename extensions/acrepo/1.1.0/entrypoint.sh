#!/bin/sh

# Update the Karaf configuration so that the Maven repository under ${MAVEN_REPO}
# is used by Karaf to discover features.

sed -e "s:^org.ops4j.pax.url.mvn.localRepository=.*:org.ops4j.pax.url.mvn.localRepository=${MAVEN_REPO}:" \
        -i etc/org.ops4j.pax.url.mvn.cfg

# Update Amherst configurations

# Change "fcrepo.baseUrl=localhost:8080/fcrepo/rest" to "fcrepo.baseUrl=${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest"
for f in `ls etc/edu.amherst.*` ;
do
  sed -e "s:localhost\:8080/fcrepo/rest:${FCREPO_HOST}\:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest:" -i $f
done

# Change "rest.host=localhost" to "rest.host=acrepo"
for f in `ls etc/edu.amherst.*` ;
do
    sed -e "s:rest\.host=localhost:rest\.host=acrepo:" -i $f
done

# Change "jms.brokerUrl=tcp://localhost:61616" to "jms.brokerUrl=tcp://fcrepo:61616"
for f in `ls etc/edu.amherst.*` ;
do
    sed -e "s:localhost\:61616:fcrepo\:61616:" -i $f
done

# Load extensions by default, except ORE service
for f in `ls etc/edu.amherst.* | grep -v ore` ;
do
    sed -e "s:extension\.load=.*:extension\.load=true:" -i $f
done


# Set'extension.load.uri' in each config file
for f in `ls etc/edu.amherst.*` ;
do
    sed -e "s:extension\.load\.uri=.*:http\://apix:\${env\:APIX_PORT\:-80}/services//apix\:load:" >> $f
done


# Add 'extension.load.maximumRediveries' to each config file
for f in `ls etc/edu.amherst.*` ;
do
    echo "extension.load.maximumRediveries=300" >> $f
done


# Update rest.port to "${env:ACREPO_IMAGE_PORT:-9105}"
sed -e "s:rest\.port=.*:rest\.port=\${env\:ACREPO_IMAGE_PORT\:-9105}:" -i etc/edu.amherst.acdc.exts.image.cfg

# Update rest.port to ${env:ACREPO_FITS_PORT:-9106}
sed -e "s:rest\.port=.*:rest\.port=\${env\:ACREPO_FITS_PORT\:-9106}:" -i etc/edu.amherst.acdc.exts.fits.cfg

# Update fits.endpoint to fits:${env:FITS_PORT:-8082}/fits/examine
sed -e "s:fits\.endpoint=.*:fits\.endpoint=http\://fits\:\${env\:FITS_PORT\:-8082}/fits/examine:" -i etc/edu.amherst.acdc.exts.fits.cfg

# Update rest.port to ${env:ACREPO_PCDM_PORT:-9107}
sed -e "s:rest\.port=.*:rest\.port=\${env\:ACREPO_PCDM_PORT\:-9107}:" -i etc/edu.amherst.acdc.exts.pcdm.cfg

# Update rest.port to ${env:ACREPO_SERIALIZE_XML_PORT:-9104}
sed -e "s:rest\.port=.*:rest\.port=\${env\:ACREPO_SERIALIZE_XML_PORT\:-9104}:" -i etc/edu.amherst.acdc.exts.serialize.xml.cfg

# Update rest.port to "${env:ACREPO_ORE_PORT:-9108}"
sed -e "s:rest\.port=.*:rest\.port=\${env\:ACREPO_ORE_PORT\:-9108}:" -i etc/edu.amherst.acdc.exts.ore.cfg

echo "#empty" > /etc/hosts

# Execute `bin/karaf` with any arguments suppled by CMD
exec bin/karaf "$@"
