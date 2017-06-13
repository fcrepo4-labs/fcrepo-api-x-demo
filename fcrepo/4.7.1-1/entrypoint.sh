#!/bin/ash

# handle port
sed -ie "s:<Connector port=\"8080\":<Connector port=\"${FCREPO_PORT}\":" conf/server.xml

# Prefer the API-X base uri as the JMS base url
if [ -n "${APIX_BASEURI}" ] ;
then
  JMS_BASEURL=${APIX_BASEURI}
else
  # if the API-X base uri is not set, and Fedora is running on port 80, omit
  # the port number from the JMS base url
  if [ -z "${FCREPO_PORT}" -o "${FCREPO_PORT}" == "80" ] ;
  then
    JMS_BASEURL="http://${FCREPO_HOST}${FCREPO_CONTEXT_PATH}/rest"
  else
    JMS_BASEURL="http://${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest"
  fi
fi

OPTS="-Dfcrepo.log=${FCREPO_LOG_LEVEL} -Dfcrepo.jms.baseUrl=${JMS_BASEURL}"

# handle debugging

if [ -n "${DEBUG_PORT}" ] ;
then
  OPTS="${OPTS} `echo ${DEBUG_ARG} | envsubst`"
fi

CATALINA_OPTS="${OPTS}" catalina.sh run
