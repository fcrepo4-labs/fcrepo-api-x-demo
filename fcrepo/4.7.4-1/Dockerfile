FROM tomcat:8.5.16-jre8-alpine@sha256:4aea2f7e65af82c5a639db9c78ac06000059d81a428da061add3a1fa6e9743c0

ENV FCREPO_VERSION=4.7.4 \
FCREPO_HOST=localhost \
FCREPO_PORT=80 \
FCREPO_CONTEXT_PATH=/fcrepo \
FCREPO_LOG_LEVEL=INFO \
FCREPO_MODESHAPE_CONFIGURATION=classpath:/config/servlet-auth/repository.json \
ACTIVEMQ_BROKER_URI=tcp://localhost:61616 \
FCREPO_ACTIVEMQ_CONFIGURATION=classpath:/config/activemq.xml \
FCREPO_SPRING_CONFIGURATION=${CATALINA_HOME}/conf/fcrepo-config.xml \
DEBUG_PORT=5006 \
DEBUG_ARG="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5006"

EXPOSE ${DEBUG_PORT}
EXPOSE ${FCREPO_PORT}



# Fcrepo webapp

RUN apk update && \
    apk add --no-cache ca-certificates wget && \
    apk add --no-cache gettext && \
    export FCREPO_WAR=fcrepo-webapp-${FCREPO_VERSION}.war && \ 
    wget -O ${CATALINA_HOME}/webapps/fcrepo.war \
    #http://central.maven.org/maven2/org/fcrepo/fcrepo-webapp/4.7.4/fcrepo-webapp-4.7.4.war && \
    https://github.com/fcrepo4-exts/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-${FCREPO_VERSION}/fcrepo-webapp-plus-webac-audit-${FCREPO_VERSION}.war && \
    echo "f58682cd322517718f0168e0038e874774507285 *${CATALINA_HOME}/webapps/fcrepo.war" \
        | sha1sum -c -  && \
    echo "org.apache.catalina.webresources.Cache.level = SEVERE" \
      >> ${CATALINA_HOME}/conf/logging.properties

COPY entrypoint.sh /
COPY conf/* ${CATALINA_HOME}/conf/

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
