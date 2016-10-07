#!/bin/bash

if [ ${DEBUG} -a ${DEBUG} != "false" ] ;
then
    java ${DEBUG_ARG}                                                \
         -Dfcrepo.home=${FCREPO_RUNTIME}                             \
         -jar /tmp/fcrepo-webapp-${FCREPO_VERSION}-jetty-console.jar \
         --port ${FCREPO_PORT}                                       \
         --headless 2>&1
else
    java -Dfcrepo.home=${FCREPO_RUNTIME}                             \
         -jar /tmp/fcrepo-webapp-${FCREPO_VERSION}-jetty-console.jar \
         --port ${FCREPO_PORT}                                       \
         --headless 2>&1
fi
