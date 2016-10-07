#!/bin/bash

# Start fuseki.  For some reason shutdowns are not clean, so remove lock file if it exists
mkdir -p ${FUSEKI_BASE}                                     && \
mkdir -p ${FUSEKI_BASE}/databases/${FUSEKI_DEFAULT_DATASET} && \
find ${FUSEKI_BASE} -name *.lock | xargs -r rm

if [ ${DEBUG} -a ${DEBUG} != "false" ] ;
then
    java `echo ${DEBUG_ARG} | envsubst`                        \
      -jar ${FUSEKI_HOME}/${FUSEKI_JAR}                        \
      --update                                                 \
      --loc=${FUSEKI_BASE}/databases/${FUSEKI_DEFAULT_DATASET} \
      ${FUSEKI_DEFAULT_DATASET} 2>&1                           \
    | tee -a ${FUSEKI_BASE}/fuseki.log
else
    java -jar ${FUSEKI_HOME}/${FUSEKI_JAR}                     \
      --update                                                 \
      --loc=${FUSEKI_BASE}/databases/${FUSEKI_DEFAULT_DATASET} \
      ${FUSEKI_DEFAULT_DATASET} 2>&1                           \
    | tee -a ${FUSEKI_BASE}/fuseki.log
fi
