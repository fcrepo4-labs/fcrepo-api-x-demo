FROM tomcat:8.5.15-jre8-alpine@sha256:eaf901f324d9f49a492270b28669b32a2d7b418db8c649c2268531ddefaa0b01

ENV SOLR_VERSION=4.10.4 \
    SOLR_HOME=/shared/solr \
    SOLR_PORT=8080 \
    DEBUG_PORT=5009 

EXPOSE 8080

RUN export SOLR_DIST=solr-${SOLR_VERSION}      && \
    wget -O /tmp/${SOLR_DIST}.tgz \
        http://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/${SOLR_DIST}.tgz && \
    echo "0edf666bea51990524e520bdcb811e14b4de4c41 */tmp/${SOLR_DIST}.tgz" \
        | sha1sum -c -                                                             && \
    wget -O ${CATALINA_HOME}/lib/commons-logging-1.1.2.jar \
       http://central.maven.org/maven2/commons-logging/commons-logging/1.1.2/commons-logging-1.1.2.jar && \
    tar xzvf /tmp/${SOLR_DIST}.tgz -C /tmp && \
    cp /tmp/${SOLR_DIST}/dist/${SOLR_DIST}.war ${CATALINA_HOME}/webapps/solr.war && \
    mkdir -p ${SOLR_HOME}/collection1/conf && \
    cp -Rv /tmp/${SOLR_DIST}/example/solr/* ${SOLR_HOME} && \
    cp /tmp/${SOLR_DIST}/example/resources/log4j.properties ${CATALINA_HOME}/lib && \
    cp /tmp/${SOLR_DIST}/example/lib/ext/slf4j* ${CATALINA_HOME}/lib && \
    cp /tmp/${SOLR_DIST}/example/lib/ext/log4j* ${CATALINA_HOME}/lib && \
    touch ${CATALINA_HOME}/velocity.log && \
    rm -rf /tmp/${SOLR_DIST}* && \
    rm -rf /root/.victims*                                                               && \
    echo "solr.solr.home=${SOLR_HOME}" >> ${CATALINA_HOME}/conf/catalina.properties

COPY schema.xml ${SOLR_HOME}/collection1/conf

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
