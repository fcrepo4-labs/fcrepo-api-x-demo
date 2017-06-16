#!/bin/sh

# handle port
sed -ie "s:<Connector port=\"8080\":<Connector port=\"${FITS_PORT}\":" conf/server.xml

# handle debugging

if [ -n "${DEBUG_PORT}" ] ;
then
  OPTS="${OPTS} `echo ${DEBUG_ARG} | envsubst`"
fi

CATALINA_OPTS="${OPTS}" catalina.sh run
