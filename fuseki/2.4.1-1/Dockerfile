FROM tomcat:8.5.15-jre8-alpine@sha256:7ba4d49795a3783d08cc53b896616a0397ae8a3cf61ecb4c0b77ebd45cce3b76

ENV FUSEKI_VERSION         2.4.1
ENV FUSEKI_BASE            /shared/fuseki-data

ENV DEBUG_PORT 5009

EXPOSE 8080
EXPOSE ${DEBUG_PORT}

RUN export FUSEKI_DIST=${FUSEKI_VERSION}/jena-fuseki-war-${FUSEKI_VERSION}.war      && \
    wget -O ${CATALINA_HOME}/webapps/fuseki.war \
    http://central.maven.org/maven2/org/apache/jena/jena-fuseki-war/${FUSEKI_DIST} && \
    echo "aa3948d154dc32083524232f3e44894059698a4e *${CATALINA_HOME}/webapps/fuseki.war" \
        | sha1sum -c -                                                             && \
    mkdir -p ${FUSEKI_BASE}/configuration && \
    mkdir -p ${FUSEKI_BASE}/service-index_data && \
    mkdir -p ${FUSEKI_BASE}/fcrepo-triple-index_data

COPY shiro.ini ${FUSEKI_BASE}
COPY service-index.ttl ${FUSEKI_BASE}/configuration

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
