FROM tomcat:8.5.16-jre8-alpine@sha256:4aea2f7e65af82c5a639db9c78ac06000059d81a428da061add3a1fa6e9743c0

ENV FUSEKI_VERSION=3.4.0 \
FUSEKI_BASE=/shared/fuseki-data \
DEBUG_PORT=5009

EXPOSE 8080
EXPOSE ${DEBUG_PORT}

RUN export FUSEKI_DIST=${FUSEKI_VERSION}/jena-fuseki-war-${FUSEKI_VERSION}.war      && \
    wget -O ${CATALINA_HOME}/webapps/fuseki.war \
    http://central.maven.org/maven2/org/apache/jena/jena-fuseki-war/${FUSEKI_DIST} && \
    echo "fbdba15d500fb2978e6658470bd9b84a2f7bc9fb *${CATALINA_HOME}/webapps/fuseki.war" \
        | sha1sum -c -                                                             && \
    mkdir -p ${FUSEKI_BASE}/configuration && \
    mkdir -p ${FUSEKI_BASE}/service-index_data && \
    mkdir -p ${FUSEKI_BASE}/fcrepo-triple-index_data && \

    # gettext provides envsubst used in entrypoint
    echo "http://dl-3.alpinelinux.org/alpine/v3.6/main/" > /etc/apk/repositories && \
    echo "http://dl-3.alpinelinux.org/alpine/v3.6/community/" > /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.6/main/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.6/community/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.6/main/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.6/community/" >> /etc/apk/repositories && \
    apk --no-cache add --update gettext

COPY shiro.ini ${FUSEKI_BASE}
COPY service-index.ttl ${FUSEKI_BASE}/configuration

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
