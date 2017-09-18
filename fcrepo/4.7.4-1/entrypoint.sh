#!/bin/sh

# handle port
sed -ie "s:<Connector port=\"8080\":<Connector port=\"${FCREPO_PORT}\":" conf/server.xml

# Prefer the API-X base uri as the JMS base url
if [ -n "${FCREPO_JMS_BASEURL}" ] ;
then 
  _JMS_BASEURL=${APIX_BASEURI}
elif [ -n "${APIX_BASEURI}" ] ;
then
  _JMS_BASEURL=${APIX_BASEURI}
else
  # if the API-X base uri is not set, and Fedora is running on port 80, omit
  # the port number from the JMS base url
  if [ -z "${FCREPO_PORT}" -o "${FCREPO_PORT}" == "80" ] ;
  then
    _JMS_BASEURL="http://${FCREPO_HOST}${FCREPO_CONTEXT_PATH}/rest"
  else
    _JMS_BASEURL="http://${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest"
  fi
fi

OPTS="-Dfcrepo.log=${FCREPO_LOG_LEVEL}                                       \
      -Dfcrepo.jms.baseUrl=${_JMS_BASEURL}                                   \
      -Dfcrepo.modeshape.configuration=${FCREPO_MODESHAPE_CONFIGURATION}     \
      -Dfcrepo.spring.configuration=${FCREPO_SPRING_CONFIGURATION}           \
      -Dfcrepo.postgresql.host=${FCREPO_POSTGRESQL_HOST}                     \
      -Dfcrepo.postgresql.port=${FCREPO_POSTGRESQL_PORT}                     \
      -Dfcrepo.postgresql.username=${FCREPO_POSTGRESQL_USERNAME}             \
      -Dfcrepo.postgresql.password=${FCREPO_POSTGRESQL_PASSWORD}             \
      -Dfcrepo.binary.directory=${FCREPO_BINARY_DIRECTORY}                   \
      -Dfcrepo.activemq.directory=${FCREPO_ACTIVEMQ_DIRECTORY}               \
      -Dfcrepo.modeshape.index.directory=${FCREPO_MODESHAPE_INDEX_DIRECTORY} \
      -Dfcrepo.object.directory=${FCREPO_OBJECT_DIRECTORY}                   \
      -Dfcrepo.activemq.configuration=${FCREPO_ACTIVEMQ_CONFIGURATION}       \
      -Dactivemq.broker.uri=${ACTIVEMQ_BROKER_URI}                           \
      -Dcom.arjuna.ats.arjuna.objectstore.objectStoreDir=${ARJUNA_OBJECTSTORE_DIRECTORY}"

# handle debugging

if [ -n "${DEBUG_PORT}" ] ;
then
  OPTS="${OPTS} `echo ${DEBUG_ARG} | envsubst`"
fi

CATALINA_OPTS="${OPTS}" catalina.sh run
