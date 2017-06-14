FROM tomcat:8.5.15-jre8-alpine@sha256:eaf901f324d9f49a492270b28669b32a2d7b418db8c649c2268531ddefaa0b01


ENV FUSEKI_VERSION         2.6.0
ENV FUSEKI_BASE            /shared/fuseki-data

ENV DEBUG_PORT 5009

EXPOSE 8080
EXPOSE ${DEBUG_PORT}

RUN export FUSEKI_DIST=${FUSEKI_VERSION}/jena-fuseki-war-${FUSEKI_VERSION}.war      && \
    wget -O ${CATALINA_HOME}/webapps/fuseki.war \
    http://central.maven.org/maven2/org/apache/jena/jena-fuseki-war/${FUSEKI_DIST} && \
    echo "18a75b0af4eb316d657b3312d9b0247d8ce3919d *${CATALINA_HOME}/webapps/fuseki.war" \
        | sha1sum -c -                                                             && \
    mkdir -p ${FUSEKI_BASE}/configuration && \
    mkdir -p ${FUSEKI_BASE}/service-index_data && \
    mkdir -p ${FUSEKI_BASE}/fcrepo-triple-index_data

COPY shiro.ini ${FUSEKI_BASE}
COPY service-index.ttl ${FUSEKI_BASE}/configuration

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
