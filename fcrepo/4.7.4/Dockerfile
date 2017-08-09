FROM tomcat:8.5.16-jre8-alpine@sha256:4aea2f7e65af82c5a639db9c78ac06000059d81a428da061add3a1fa6e9743c0

ENV FCREPO_VERSION=4.7.4 \
FCREPO_HOST=localhost \
FCREPO_PORT=80 \
FCREPO_CONTEXT_PATH=/fcrepo \
FCREPO_LOG_LEVEL=INFO \
DEBUG_PORT=5006 \
DEBUG_ARG="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5006"

EXPOSE ${DEBUG_PORT}
EXPOSE ${FCREPO_PORT}



# Fcrepo webapp

RUN export FCREPO_WAR=fcrepo-webapp-${FCREPO_VERSION}.war && \ 
    wget -O ${CATALINA_HOME}/webapps/fcrepo.war \
    http://central.maven.org/maven2/org/fcrepo/fcrepo-webapp/${FCREPO_VERSION}/${FCREPO_WAR} && \
    echo "4f24f57c9a6d5c433007728595b6b7b417b9a7f6 *${CATALINA_HOME}/webapps/fcrepo.war" \
        | sha1sum -c -  && \
    echo "fcrepo.modeshape.configuration=classpath:/config/file-simple/repository.json" \
      >> ${CATALINA_HOME}/conf/catalina.properties \                                     && \
    echo "org.apache.catalina.webresources.Cache.level = SEVERE" \
      >> ${CATALINA_HOME}/conf/logging.properties

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
